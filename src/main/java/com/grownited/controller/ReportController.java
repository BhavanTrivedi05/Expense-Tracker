package com.grownited.controller;

import jakarta.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.grownited.entity.ExpenseEntity;
import com.grownited.entity.UserEntity;
import com.grownited.repository.CategoryRepository;
import com.grownited.repository.ExpenseRepository;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.time.format.DateTimeFormatter;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@Controller
public class ReportController
{
  @Autowired
  ExpenseRepository repositoryExpense;

  @Autowired
  CategoryRepository repositoryCategory;

  @GetMapping("reports")
  public String reports(HttpSession session, Model model)
  {
    UserEntity user = (UserEntity) session.getAttribute("user");

    if (user == null)
    {
      model.addAttribute("error", "Please log in to view reports.");
      return "Login";
    }

    // FIXED: Provide default report data
    List<ExpenseEntity> allExpenses = repositoryExpense.findByUserId(user.getUserId());

    // Calculate statistics
    double totalExpenses = allExpenses.stream()
        .mapToDouble(ExpenseEntity::getAmount)
        .sum();

    // Find top category
    Map<Integer, Double> categoryTotals = new HashMap<>();
    for (ExpenseEntity expense : allExpenses) {
      categoryTotals.merge(expense.getCategoryId(), expense.getAmount(), Double::sum);
    }

    String topCategory = "N/A";
    double categoryPercentage = 0;
    if (!categoryTotals.isEmpty()) {
      Integer topCategoryId = categoryTotals.entrySet().stream()
          .max(Map.Entry.comparingByValue())
          .get()
          .getKey();
      double topCategoryAmount = categoryTotals.get(topCategoryId);
      categoryPercentage = (topCategoryAmount / totalExpenses) * 100;
      topCategory = "Category " + topCategoryId; // You can fetch actual name
    }

    model.addAttribute("totalExpenses", String.format("%.2f", totalExpenses));
    model.addAttribute("topCategory", topCategory);
    model.addAttribute("categoryPercentage", String.format("%.1f", categoryPercentage));
    model.addAttribute("remainingBudget", "0.00"); // Set budget logic if needed
    model.addAttribute("expenseList", allExpenses);
    model.addAttribute("expenseChange", "0"); // Calculate month-over-month if needed

    return "Reports";
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
      return "Login";
    }

    // FIXED: Actual report generation logic
    try {
      DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");
      LocalDate start = LocalDate.parse(startDate, formatter);
      LocalDate end = LocalDate.parse(endDate, formatter);

      LocalDateTime startDateTime = start.atStartOfDay();
      LocalDateTime endDateTime = end.atTime(LocalTime.MAX);

      // Fetch expenses in date range
      List<ExpenseEntity> filteredExpenses = repositoryExpense
          .findByUserIdAndTranscationDateBetween(user.getUserId(), startDateTime, endDateTime);

      // Filter by category if provided
      if (categoryId != null) {
        filteredExpenses = filteredExpenses.stream()
            .filter(e -> e.getCategoryId().equals(categoryId))
            .collect(Collectors.toList());
      }

      // Calculate statistics
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
      return "Login";
    }

    // FIXED: Admin can see all expenses
    List<ExpenseEntity> allExpenses = repositoryExpense.findAll();

    double totalExpenses = allExpenses.stream()
        .mapToDouble(ExpenseEntity::getAmount)
        .sum();

    model.addAttribute("totalExpenses", String.format("%.2f", totalExpenses));
    model.addAttribute("expenseList", allExpenses);

    return "AdminReports";
  }
}