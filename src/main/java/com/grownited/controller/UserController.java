package com.grownited.controller;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.TextStyle;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import com.grownited.entity.CategoryEntity;
import com.grownited.entity.ExpenseEntity;
import com.grownited.entity.UserEntity;
import com.grownited.repository.AccountRepository;
import com.grownited.repository.CategoryRepository;
import com.grownited.repository.ExpenseRepository;

import jakarta.servlet.http.HttpSession;

@Controller
public class UserController
{
  @Autowired
  ExpenseRepository repositoryExpense;

  @Autowired
  AccountRepository repositoryAccount;

  @Autowired
  CategoryRepository repositoryCategory;

  @GetMapping("home")
  public String home(HttpSession session, Model model)
  {
    UserEntity user = (UserEntity) session.getAttribute("user");
    if (user == null) {
      return "redirect:/login";
    }

    // Get user's expenses
    List<ExpenseEntity> expenses = repositoryExpense.findByUserId(user.getUserId());

    // Calculate total expenses
    double totalExpenses = expenses.stream()
        .mapToDouble(ExpenseEntity::getAmount)
        .sum();

    // Calculate total account balance
    double totalBalance = repositoryAccount.findByUserId(user.getUserId()).stream()
        .mapToDouble(account -> account.getAmount())
        .sum();

    // Create dashboard stats
    Map<String, Object> totalExpensesStat = new HashMap<>();
    totalExpensesStat.put("title", "Total Expenses");
    totalExpensesStat.put("value", String.format("%.2f", totalExpenses));
    totalExpensesStat.put("color", "bg-gradient-danger");
    totalExpensesStat.put("status", expenses.size() + " transactions");

    Map<String, Object> totalBalanceStat = new HashMap<>();
    totalBalanceStat.put("title", "Total Balance");
    totalBalanceStat.put("value", String.format("%.2f", totalBalance));
    totalBalanceStat.put("color", "bg-gradient-primary");
    totalBalanceStat.put("status", "Across all accounts");

    Map<String, Object> remainingStat = new HashMap<>();
    double remaining = totalBalance - totalExpenses;
    remainingStat.put("title", "Remaining");
    remainingStat.put("value", String.format("%.2f", remaining));
    remainingStat.put("color", remaining >= 0 ? "bg-gradient-success" : "bg-gradient-warning");
    remainingStat.put("status", remaining >= 0 ? "Surplus" : "Deficit");

    List<Map<String, Object>> dashboardStats = List.of(totalExpensesStat, totalBalanceStat, remainingStat);

    // ========== CHART DATA CALCULATION ==========

    // 1. CATEGORY PIE CHART DATA
    Map<Integer, Double> categoryTotals = new HashMap<>();
    Map<Integer, String> categoryNames = new HashMap<>();

    // Get all categories for this user (admin) or all categories
    List<CategoryEntity> categories;
    if ("ADMIN".equals(user.getRole())) {
      categories = repositoryCategory.findAll();
    } else {
      categories = repositoryCategory.findAll(); // All users can see categories
    }

    // Map category IDs to names
    for (CategoryEntity cat : categories) {
      categoryNames.put(cat.getCategoryId(), cat.getTitle());
    }

    // Calculate spending per category
    for (ExpenseEntity expense : expenses) {
      if (expense.getCategoryId() != null) {
        categoryTotals.merge(expense.getCategoryId(), expense.getAmount(), Double::sum);
      }
    }

    // Prepare chart data
    List<String> categoryLabels = new ArrayList<>();
    List<Double> categoryData = new ArrayList<>();

    if (categoryTotals.isEmpty()) {
      // No data - show placeholder
      categoryLabels = List.of("No expenses yet");
      categoryData = List.of(1.0);
    } else {
      for (Map.Entry<Integer, Double> entry : categoryTotals.entrySet()) {
        String catName = categoryNames.getOrDefault(entry.getKey(), "Category " + entry.getKey());
        categoryLabels.add(catName);
        categoryData.add(entry.getValue());
      }
    }

    // 2. TREND LINE CHART DATA (Last 7 days)
    Map<LocalDate, Double> dailyExpenses = new LinkedHashMap<>();

    // Initialize last 7 days with 0
    for (int i = 6; i >= 0; i--) {
      LocalDate date = LocalDate.now().minusDays(i);
      dailyExpenses.put(date, 0.0);
    }

    // Fill with actual data
    for (ExpenseEntity expense : expenses) {
      if (expense.getTranscationDate() != null) {
        LocalDate expenseDate = expense.getTranscationDate().toLocalDate();
        if (dailyExpenses.containsKey(expenseDate)) {
          dailyExpenses.put(expenseDate, dailyExpenses.get(expenseDate) + expense.getAmount());
        }
      }
    }

    List<String> trendLabels = new ArrayList<>();
    List<Double> trendData = new ArrayList<>();

    for (Map.Entry<LocalDate, Double> entry : dailyExpenses.entrySet()) {
      String dayName = entry.getKey().getDayOfWeek().getDisplayName(TextStyle.SHORT, Locale.ENGLISH);
      trendLabels.add(dayName);
      trendData.add(entry.getValue());
    }

    // Add chart data to model
    model.addAttribute("categoryLabels", categoryLabels);
    model.addAttribute("categoryData", categoryData);
    model.addAttribute("trendLabels", trendLabels);
    model.addAttribute("trendData", trendData);

    // Add other attributes
    model.addAttribute("user", user);
    model.addAttribute("dashboardStats", dashboardStats);
    model.addAttribute("hasExpenses", !expenses.isEmpty());

    return "Home";
  }
}