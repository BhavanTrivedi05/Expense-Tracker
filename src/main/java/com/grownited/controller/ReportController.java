package com.grownited.controller;

import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.grownited.entity.CategoryEntity;
import com.grownited.entity.ExpenseEntity;
import com.grownited.entity.UserEntity;
import com.grownited.repository.CategoryRepository;
import com.grownited.repository.ExpenseRepository;
import com.grownited.service.ExportService;

import java.io.IOException;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.time.format.DateTimeFormatter;
import java.time.format.TextStyle;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.stream.Collectors;

@Controller
public class ReportController
{
  @Autowired
  ExpenseRepository repositoryExpense;

  @Autowired
  CategoryRepository repositoryCategory;

  @Autowired
  ExportService exportService;

  @GetMapping("reports")
  public String reports(HttpSession session, Model model)
  {
    UserEntity user = (UserEntity) session.getAttribute("user");

    if (user == null)
    {
      model.addAttribute("error", "Please log in to view reports.");
      return "redirect:/login";
    }

    // Get user's expenses
    List<ExpenseEntity> allExpenses = repositoryExpense.findByUserId(user.getUserId());
    List<CategoryEntity> categories = repositoryCategory.findAll();

    // Calculate statistics
    double totalExpenses = allExpenses.stream()
        .mapToDouble(ExpenseEntity::getAmount)
        .sum();

    // ========== CHART 1: CATEGORY BREAKDOWN (PIE) ==========
    Map<Integer, Double> categoryTotals = new HashMap<>();
    Map<Integer, String> categoryNames = new HashMap<>();

    for (CategoryEntity cat : categories) {
      categoryNames.put(cat.getCategoryId(), cat.getTitle());
    }

    for (ExpenseEntity expense : allExpenses) {
      if (expense.getCategoryId() != null) {
        categoryTotals.merge(expense.getCategoryId(), expense.getAmount(), Double::sum);
      }
    }

    List<String> categoryLabels = new ArrayList<>();
    List<Double> categoryData = new ArrayList<>();

    String topCategory = "N/A";
    double topCategoryAmount = 0;

    if (!categoryTotals.isEmpty()) {
      for (Map.Entry<Integer, Double> entry : categoryTotals.entrySet()) {
        String catName = categoryNames.getOrDefault(entry.getKey(), "Category " + entry.getKey());
        categoryLabels.add(catName);
        categoryData.add(entry.getValue());

        if (entry.getValue() > topCategoryAmount) {
          topCategoryAmount = entry.getValue();
          topCategory = catName;
        }
      }
    }

    double categoryPercentage = totalExpenses > 0 ? (topCategoryAmount / totalExpenses) * 100 : 0;

    // ========== CHART 2: MONTHLY TREND (LINE) ==========
    Map<String, Double> monthlyExpenses = new LinkedHashMap<>();

    // Last 6 months
    for (int i = 5; i >= 0; i--) {
      LocalDate monthDate = LocalDate.now().minusMonths(i);
      String monthName = monthDate.getMonth().getDisplayName(TextStyle.SHORT, Locale.ENGLISH) + " " + monthDate.getYear();
      monthlyExpenses.put(monthName, 0.0);
    }

    for (ExpenseEntity expense : allExpenses) {
      if (expense.getTranscationDate() != null) {
        LocalDate expenseDate = expense.getTranscationDate().toLocalDate();
        String monthKey = expenseDate.getMonth().getDisplayName(TextStyle.SHORT, Locale.ENGLISH) + " " + expenseDate.getYear();

        if (monthlyExpenses.containsKey(monthKey)) {
          monthlyExpenses.put(monthKey, monthlyExpenses.get(monthKey) + expense.getAmount());
        }
      }
    }

    List<String> monthlyLabels = new ArrayList<>(monthlyExpenses.keySet());
    List<Double> monthlyData = new ArrayList<>(monthlyExpenses.values());

    // ========== CHART 3: TOP 5 EXPENSES (BAR) ==========
    List<ExpenseEntity> topExpenses = allExpenses.stream()
        .sorted((e1, e2) -> Double.compare(e2.getAmount(), e1.getAmount()))
        .limit(5)
        .collect(Collectors.toList());

    List<String> topExpenseLabels = new ArrayList<>();
    List<Double> topExpenseData = new ArrayList<>();

    for (ExpenseEntity expense : topExpenses) {
      topExpenseLabels.add(expense.getTitle() != null ? expense.getTitle() : "Expense #" + expense.getExpenseId());
      topExpenseData.add(expense.getAmount());
    }

    // ========== CHART 4: WEEKLY SPENDING (BAR) ==========
    Map<String, Double> weeklyExpenses = new LinkedHashMap<>();

    // Last 4 weeks
    for (int i = 3; i >= 0; i--) {
      weeklyExpenses.put("Week " + (4 - i), 0.0);
    }

    for (ExpenseEntity expense : allExpenses) {
      if (expense.getTranscationDate() != null) {
        LocalDate expenseDate = expense.getTranscationDate().toLocalDate();
        long weeksDiff = java.time.temporal.ChronoUnit.WEEKS.between(expenseDate, LocalDate.now());

        if (weeksDiff >= 0 && weeksDiff < 4) {
          String weekKey = "Week " + (4 - weeksDiff);
          if (weeklyExpenses.containsKey(weekKey)) {
            weeklyExpenses.put(weekKey, weeklyExpenses.get(weekKey) + expense.getAmount());
          }
        }
      }
    }

    List<String> weeklyLabels = new ArrayList<>(weeklyExpenses.keySet());
    List<Double> weeklyData = new ArrayList<>(weeklyExpenses.values());

    // Calculate expense change
    double thisMonthExpenses = allExpenses.stream()
        .filter(e -> e.getTranscationDate() != null &&
            e.getTranscationDate().toLocalDate().getMonth() == LocalDate.now().getMonth())
        .mapToDouble(ExpenseEntity::getAmount)
        .sum();

    double lastMonthExpenses = allExpenses.stream()
        .filter(e -> e.getTranscationDate() != null &&
            e.getTranscationDate().toLocalDate().getMonth() == LocalDate.now().minusMonths(1).getMonth())
        .mapToDouble(ExpenseEntity::getAmount)
        .sum();

    double expenseChange = lastMonthExpenses > 0 ?
        ((thisMonthExpenses - lastMonthExpenses) / lastMonthExpenses) * 100 : 0;

    // Add to model
    model.addAttribute("totalExpenses", String.format("%.2f", totalExpenses));
    model.addAttribute("topCategory", topCategory);
    model.addAttribute("categoryPercentage", String.format("%.1f", categoryPercentage));
    model.addAttribute("remainingBudget", "0.00");
    model.addAttribute("expenseList", allExpenses);
    model.addAttribute("expenseChange", String.format("%.1f", expenseChange));

    // Chart data
    model.addAttribute("categoryLabels", categoryLabels);
    model.addAttribute("categoryData", categoryData);
    model.addAttribute("monthlyLabels", monthlyLabels);
    model.addAttribute("monthlyData", monthlyData);
    model.addAttribute("topExpenseLabels", topExpenseLabels);
    model.addAttribute("topExpenseData", topExpenseData);
    model.addAttribute("weeklyLabels", weeklyLabels);
    model.addAttribute("weeklyData", weeklyData);

    return "Reports";
  }

  // ========== EXPORT TO EXCEL ==========
  @GetMapping("exportexpenses")
  public void exportToExcel(HttpServletResponse response, HttpSession session) throws IOException {
    UserEntity user = (UserEntity) session.getAttribute("user");

    if (user == null) {
      response.sendRedirect("/login");
      return;
    }

    List<ExpenseEntity> expenses = repositoryExpense.findByUserId(user.getUserId());

    byte[] excelData = exportService.exportExpensesToExcel(expenses, user.getFirstName() + " " + user.getLastName());

    response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
    response.setHeader("Content-Disposition", "attachment; filename=SpendWise_Expenses_" +
        LocalDate.now() + ".xlsx");
    response.setContentLength(excelData.length);

    response.getOutputStream().write(excelData);
    response.getOutputStream().flush();
  }

  // ========== EXPORT TO PDF ==========
  @GetMapping("exportpdf")
  public void exportToPDF(HttpServletResponse response, HttpSession session) throws IOException {
    UserEntity user = (UserEntity) session.getAttribute("user");

    if (user == null) {
      response.sendRedirect("/login");
      return;
    }

    try {
      List<ExpenseEntity> expenses = repositoryExpense.findByUserId(user.getUserId());

      byte[] pdfData = exportService.exportExpensesToPDF(expenses, user.getFirstName() + " " + user.getLastName());

      response.setContentType("application/pdf");
      response.setHeader("Content-Disposition", "attachment; filename=SpendWise_Expenses_" +
          LocalDate.now() + ".pdf");
      response.setContentLength(pdfData.length);

      response.getOutputStream().write(pdfData);
      response.getOutputStream().flush();

    } catch (Exception e) {
      e.printStackTrace();
      response.sendRedirect("/reports?error=export_failed");
    }
  }

  // ========== EXPORT TO CSV ==========
  @GetMapping("exportcsv")
  public void exportToCSV(HttpServletResponse response, HttpSession session) throws IOException {
    UserEntity user = (UserEntity) session.getAttribute("user");

    if (user == null) {
      response.sendRedirect("/login");
      return;
    }

    List<ExpenseEntity> expenses = repositoryExpense.findByUserId(user.getUserId());

    byte[] csvData = exportService.exportExpensesToCSV(expenses);

    response.setContentType("text/csv");
    response.setHeader("Content-Disposition", "attachment; filename=SpendWise_Expenses_" +
        LocalDate.now() + ".csv");
    response.setContentLength(csvData.length);

    response.getOutputStream().write(csvData);
    response.getOutputStream().flush();
  }

  // ========== EXPORT TO JSON ==========
  @GetMapping("exportjson")
  public void exportToJSON(HttpServletResponse response, HttpSession session) throws IOException {
    UserEntity user = (UserEntity) session.getAttribute("user");

    if (user == null) {
      response.sendRedirect("/login");
      return;
    }

    List<ExpenseEntity> expenses = repositoryExpense.findByUserId(user.getUserId());

    byte[] jsonData = exportService.exportExpensesToJSON(expenses);

    response.setContentType("application/json");
    response.setHeader("Content-Disposition", "attachment; filename=SpendWise_Expenses_" +
        LocalDate.now() + ".json");
    response.setContentLength(jsonData.length);

    response.getOutputStream().write(jsonData);
    response.getOutputStream().flush();
  }

  @PostMapping("generatereport")
  public String generateReport(@RequestParam String startDate,
                               @RequestParam String endDate,
                               @RequestParam(required = false) Integer categoryId,
                               HttpSession session,
                               Model model)
  {
    UserEntity user = (UserEntity) session.getAttribute("user");

    if (user == null)
    {
      model.addAttribute("error", "Please log in to generate reports.");
      return "redirect:/login";
    }

    try {
      DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");
      LocalDate start = LocalDate.parse(startDate, formatter);
      LocalDate end = LocalDate.parse(endDate, formatter);

      LocalDateTime startDateTime = start.atStartOfDay();
      LocalDateTime endDateTime = end.atTime(LocalTime.MAX);

      List<ExpenseEntity> filteredExpenses = repositoryExpense
          .findByUserIdAndTranscationDateBetween(user.getUserId(), startDateTime, endDateTime);

      if (categoryId != null) {
        filteredExpenses = filteredExpenses.stream()
            .filter(e -> e.getCategoryId().equals(categoryId))
            .collect(Collectors.toList());
      }

      double totalExpenses = filteredExpenses.stream()
          .mapToDouble(ExpenseEntity::getAmount)
          .sum();

      model.addAttribute("totalExpenses", String.format("%.2f", totalExpenses));
      model.addAttribute("expenseList", filteredExpenses);
      model.addAttribute("message", "Report generated for " + startDate + " to " + endDate);

    } catch (Exception e) {
      model.addAttribute("error", "Invalid date format. Use YYYY-MM-DD");
    }

    return "Reports";
  }

  @GetMapping("adminreports")
  public String adminReports(HttpSession session, Model model)
  {
    UserEntity user = (UserEntity) session.getAttribute("user");

    if (user == null || !user.getRole().equals("ADMIN"))
    {
      model.addAttribute("error", "Access Denied. Admins only.");
      return "redirect:/login";
    }

    List<ExpenseEntity> allExpenses = repositoryExpense.findAll();

    double totalExpenses = allExpenses.stream()
        .mapToDouble(ExpenseEntity::getAmount)
        .sum();

    model.addAttribute("totalExpenses", String.format("%.2f", totalExpenses));
    model.addAttribute("expenseList", allExpenses);

    return "AdminReports";
  }
}