package com.grownited.controller.Admin;

import java.time.LocalDate;
import java.time.format.TextStyle;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import com.grownited.entity.UserEntity;
import com.grownited.repository.AccountRepository;
import com.grownited.repository.CategoryRepository;
import com.grownited.repository.ExpenseRepository;
import com.grownited.repository.SubCategoryRepository;
import com.grownited.repository.UserRepository;
import com.grownited.repository.VendorRepository;

import jakarta.servlet.http.HttpSession;

@Controller
public class AdminController
{
  @Autowired
  UserRepository repositoryUser;

  @Autowired
  ExpenseRepository repositoryExpense;

  @Autowired
  AccountRepository repositoryAccount;

  @Autowired
  CategoryRepository repositoryCategory;

  @Autowired
  VendorRepository repositoryVendor;

  @Autowired
  SubCategoryRepository repositorySubCategory;

  @GetMapping("/admindashboard")
  public String getAdminDashboard(HttpSession session, Model model)
  {
    UserEntity user = (UserEntity) session.getAttribute("user");

    // Security check
    if (user == null || !"ADMIN".equals(user.getRole())) {
      model.addAttribute("error", "Access denied. Admin privileges required.");
      return "redirect:/login";
    }

    // Calculate system-wide statistics
    long totalUsers = repositoryUser.count();
    long totalAdmins = repositoryUser.findAll().stream()
        .filter(u -> "ADMIN".equals(u.getRole()))
        .count();
    long totalRegularUsers = totalUsers - totalAdmins;

    double totalExpenses = repositoryExpense.findAll().stream()
        .mapToDouble(e -> e.getAmount())
        .sum();

    long totalAccounts = repositoryAccount.count();
    long totalCategories = repositoryCategory.count();
    long totalVendors = repositoryVendor.count();
    long totalSubCategories = repositorySubCategory.count();
    long expenseCount = repositoryExpense.count();

    // ========== ADMIN CHART DATA ==========

    // 1. USER GROWTH CHART (Last 4 weeks)
    List<String> userGrowthLabels = new ArrayList<>();
    List<Long> userGrowthData = new ArrayList<>();

    // Simulate weekly growth (in real app, you'd track creation dates)
    for (int i = 3; i >= 0; i--) {
      LocalDate weekStart = LocalDate.now().minusWeeks(i);
      userGrowthLabels.add("Week " + (4 - i));
    }

    // Simple growth simulation
    if (totalUsers == 0) {
      userGrowthData = List.of(0L, 0L, 0L, 0L);
    } else if (totalUsers == 1) {
      userGrowthData = List.of(0L, 0L, 0L, 1L);
    } else {
      // Distribute users across weeks
      long perWeek = totalUsers / 4;
      long remainder = totalUsers % 4;
      userGrowthData = List.of(perWeek, perWeek, perWeek, perWeek + remainder);
    }

    // 2. ACTIVITY PIE CHART
    List<String> activityLabels = List.of("Expenses", "Accounts", "Categories", "Vendors");
    List<Long> activityData = List.of(expenseCount, totalAccounts, totalCategories, totalVendors);

    // Add to model
    model.addAttribute("admin", user);
    model.addAttribute("totalUsers", totalUsers);
    model.addAttribute("totalAdmins", totalAdmins);
    model.addAttribute("totalRegularUsers", totalRegularUsers);
    model.addAttribute("totalExpenses", String.format("%.2f", totalExpenses));
    model.addAttribute("totalAccounts", totalAccounts);
    model.addAttribute("totalCategories", totalCategories);
    model.addAttribute("totalVendors", totalVendors);
    model.addAttribute("totalSubCategories", totalSubCategories);
    model.addAttribute("expenseCount", expenseCount);

    // Chart data
    model.addAttribute("userGrowthLabels", userGrowthLabels);
    model.addAttribute("userGrowthData", userGrowthData);
    model.addAttribute("activityLabels", activityLabels);
    model.addAttribute("activityData", activityData);

    return "AdminDashboard";
  }
}