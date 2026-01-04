package com.grownited.controller;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.grownited.entity.AccountEntity;
import com.grownited.entity.CategoryEntity;
import com.grownited.entity.ExpenseEntity;
import com.grownited.entity.SubCategoryEntity;
import com.grownited.entity.UserEntity;
import com.grownited.entity.VendorEntity;
import com.grownited.repository.AccountRepository;
import com.grownited.repository.CategoryRepository;
import com.grownited.repository.ExpenseRepository;
import com.grownited.repository.SubCategoryRepository;
import com.grownited.repository.VendorRepository;

import jakarta.servlet.http.HttpSession;

@Controller
public class ExpenseController
{
  @Autowired
  ExpenseRepository repositoryExpense;

  @Autowired
  CategoryRepository repositoryCategory;

  @Autowired
  SubCategoryRepository repositorySubCategory;

  @Autowired
  VendorRepository repositoryVendor;

  @Autowired
  AccountRepository repositoryAccount;

  @GetMapping("newexpense")
  public String newExpense(HttpSession session, Model model)
  {
    UserEntity user = (UserEntity) session.getAttribute("user");
    if (user == null) {
      return "redirect:/login";
    }

    // FIXED: Populate dropdowns
    List<CategoryEntity> categories = repositoryCategory.findByUserId(user.getUserId());
    List<SubCategoryEntity> subcategories = repositorySubCategory.findByUserId(user.getUserId());
    List<VendorEntity> vendors = repositoryVendor.findByUserId(user.getUserId());
    List<AccountEntity> accounts = repositoryAccount.findByUserId(user.getUserId());

    model.addAttribute("allCategories", categories);
    model.addAttribute("allSubCategories", subcategories);
    model.addAttribute("allVendors", vendors);
    model.addAttribute("allAccounts", accounts);

    return "NewExpense";
  }

  // FIXED: Consistent naming (was "saveExpense")
  @PostMapping("saveexpense")
  public String saveExpense(ExpenseEntity entityExpense, HttpSession session, Model model)
  {
    UserEntity user = (UserEntity) session.getAttribute("user");
    if (user == null) {
      return "redirect:/login";
    }

    // FIXED: Set userId and transaction date
    entityExpense.setUserId(user.getUserId());
    if (entityExpense.getTranscationDate() == null) {
      entityExpense.setTranscationDate(LocalDateTime.now());
    }

    repositoryExpense.save(entityExpense);

    model.addAttribute("success", "Expense created successfully!");
    return "redirect:/listexpense";
  }

  // FIXED: Consistent naming (was "listExpense")
  @GetMapping("listexpense")
  public String listExpense(Model model, HttpSession session)
  {
    UserEntity user = (UserEntity) session.getAttribute("user");
    if (user == null) {
      return "redirect:/login";
    }

    // FIXED: User-specific expenses
    List<ExpenseEntity> expenseList = repositoryExpense.findByUserId(user.getUserId());
    model.addAttribute("expenseList", expenseList);
    return "ListExpense";
  }

  @GetMapping("viewexpense")
  public String viewExpense(@RequestParam Integer expenseId, Model model, HttpSession session)
  {
    UserEntity user = (UserEntity) session.getAttribute("user");
    if (user == null) {
      return "redirect:/login";
    }

    Optional<ExpenseEntity> op = repositoryExpense.findById(expenseId);
    if (op.isEmpty())
    {
      model.addAttribute("error", "Expense not found");
      return "redirect:/listexpense";
    }
    else
    {
      ExpenseEntity expense = op.get();

      // Security check
      if (!expense.getUserId().equals(user.getUserId())) {
        model.addAttribute("error", "Access denied");
        return "redirect:/listexpense";
      }

      model.addAttribute("expense", expense);
    }

    return "ViewExpense";
  }

  // FIXED: Added GET mapping for edit page
  @GetMapping("editexpense")
  public String editExpensePage(@RequestParam Integer expenseId, Model model, HttpSession session)
  {
    UserEntity user = (UserEntity) session.getAttribute("user");
    if (user == null) {
      return "redirect:/login";
    }

    Optional<ExpenseEntity> op = repositoryExpense.findById(expenseId);
    if (op.isEmpty())
    {
      model.addAttribute("error", "Expense not found");
      return "redirect:/listexpense";
    }

    ExpenseEntity expense = op.get();

    // Security check
    if (!expense.getUserId().equals(user.getUserId())) {
      model.addAttribute("error", "Access denied");
      return "redirect:/listexpense";
    }

    // Populate dropdowns
    List<CategoryEntity> categories = repositoryCategory.findByUserId(user.getUserId());
    List<SubCategoryEntity> subcategories = repositorySubCategory.findByUserId(user.getUserId());
    List<VendorEntity> vendors = repositoryVendor.findByUserId(user.getUserId());
    List<AccountEntity> accounts = repositoryAccount.findByUserId(user.getUserId());

    model.addAttribute("allCategories", categories);
    model.addAttribute("allSubCategories", subcategories);
    model.addAttribute("allVendors", vendors);
    model.addAttribute("allAccounts", accounts);
    model.addAttribute("expense", expense);

    return "EditExpense";
  }

  // FIXED: Added POST mapping for editing
  @PostMapping("editexpense")
  public String editExpense(ExpenseEntity entityExpense, HttpSession session, Model model)
  {
    UserEntity user = (UserEntity) session.getAttribute("user");
    if (user == null) {
      return "redirect:/login";
    }

    // Preserve userId
    entityExpense.setUserId(user.getUserId());
    repositoryExpense.save(entityExpense);

    model.addAttribute("success", "Expense updated successfully!");
    return "redirect:/listexpense";
  }

  @GetMapping("deleteexpense")
  public String deleteExpense(@RequestParam Integer expenseId, HttpSession session, Model model)
  {
    UserEntity user = (UserEntity) session.getAttribute("user");
    if (user == null) {
      return "redirect:/login";
    }

    // Security check before delete
    Optional<ExpenseEntity> op = repositoryExpense.findById(expenseId);
    if (op.isPresent() && op.get().getUserId().equals(user.getUserId())) {
      repositoryExpense.deleteById(expenseId);
      model.addAttribute("success", "Expense deleted successfully!");
    } else {
      model.addAttribute("error", "Cannot delete expense");
    }

    return "redirect:/listexpense";
  }
}