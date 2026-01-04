package com.grownited.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import com.grownited.entity.ExpenseEntity;
import com.grownited.entity.UserEntity;
import com.grownited.repository.AccountRepository;
import com.grownited.repository.ExpenseRepository;

import jakarta.servlet.http.HttpSession;

@Controller
public class UserController
{
  @Autowired
  ExpenseRepository repositoryExpense;

  @Autowired
  AccountRepository repositoryAccount;

  @GetMapping("home")
  public String home(HttpSession session, Model model)
  {
    UserEntity user = (UserEntity) session.getAttribute("user");
    if (user == null) {
      return "redirect:/login";
    }

    // FIXED: Calculate actual dashboard statistics
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
    totalExpensesStat.put("color", "text-danger");
    totalExpensesStat.put("status", expenses.size() + " transactions");

    Map<String, Object> totalBalanceStat = new HashMap<>();
    totalBalanceStat.put("title", "Total Balance");
    totalBalanceStat.put("value", String.format("%.2f", totalBalance));
    totalBalanceStat.put("color", "text-success");
    totalBalanceStat.put("status", "Across all accounts");

    Map<String, Object> remainingStat = new HashMap<>();
    remainingStat.put("title", "Remaining");
    remainingStat.put("value", String.format("%.2f", totalBalance - totalExpenses));
    remainingStat.put("color", totalBalance >= totalExpenses ? "text-success" : "text-danger");
    remainingStat.put("status", totalBalance >= totalExpenses ? "Surplus" : "Deficit");

    List<Map<String, Object>> dashboardStats = List.of(totalExpensesStat, totalBalanceStat, remainingStat);

    model.addAttribute("user", user);
    model.addAttribute("dashboardStats", dashboardStats);

    return "Home";
  }
}