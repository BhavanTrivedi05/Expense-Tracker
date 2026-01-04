package com.grownited.controller.Admin;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import com.grownited.entity.UserEntity;
import com.grownited.repository.AccountRepository;
import com.grownited.repository.ExpenseRepository;
import com.grownited.repository.UserRepository;

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

  @GetMapping("/admindashboard")
  public String getAdminDashboard(HttpSession session, Model model)
  {
    UserEntity user = (UserEntity) session.getAttribute("user");

    // FIXED: Security check
    if (user == null || !user.getRole().equals("ADMIN")) {
      model.addAttribute("error", "Access denied");
      return "redirect:/login";
    }

    // FIXED: Calculate actual statistics
    long totalUsers = repositoryUser.count();

    double totalExpenses = repositoryExpense.findAll().stream()
        .mapToDouble(e -> e.getAmount())
        .sum();

    long totalAccounts = repositoryAccount.count();

    model.addAttribute("totalUsers", totalUsers);
    model.addAttribute("totalExpenses", String.format("%.2f", totalExpenses));
    model.addAttribute("totalAccounts", totalAccounts);

    return "AdminDashboard";
  }

  // FIXED: Added user management endpoints
  @GetMapping("/listusers")
  public String listUsers(HttpSession session, Model model) {
    UserEntity user = (UserEntity) session.getAttribute("user");

    if (user == null || !user.getRole().equals("ADMIN")) {
      return "redirect:/login";
    }

    List<UserEntity> users = repositoryUser.findAll();
    model.addAttribute("userList", users);
    return "ManageUsers";
  }
}