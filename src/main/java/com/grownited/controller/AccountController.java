package com.grownited.controller;

import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.grownited.entity.AccountEntity;
import com.grownited.entity.UserEntity;
import com.grownited.repository.AccountRepository;

import jakarta.servlet.http.HttpSession;

@Controller
public class AccountController
{
  @Autowired
  AccountRepository repositoryAccount;

  @GetMapping("newaccount")
  public String newAccount(HttpSession session, Model model)
  {
    UserEntity user = (UserEntity) session.getAttribute("user");
    if (user == null) {
      model.addAttribute("error", "Please log in first.");
      return "redirect:/login";
    }
    return "NewAccount";
  }

  @PostMapping("saveaccount")
  public String saveAccount(AccountEntity entityAccount, HttpSession session, Model model)
  {
    UserEntity user = (UserEntity) session.getAttribute("user");
    if (user == null) {
      model.addAttribute("error", "Please log in first.");
      return "redirect:/login";
    }

    // FIXED: Set userId for multi-tenant isolation
    entityAccount.setUserId(user.getUserId());
    repositoryAccount.save(entityAccount);

    model.addAttribute("success", "Account created successfully!");
    return "redirect:/listaccount";
  }

  @GetMapping("listaccount")
  public String listAccount(Model model, HttpSession session)
  {
    UserEntity user = (UserEntity) session.getAttribute("user");
    if (user == null) {
      return "redirect:/login";
    }

    // FIXED: Only show user's own accounts
    List<AccountEntity> accountList = repositoryAccount.findByUserId(user.getUserId());
    model.addAttribute("accountList", accountList);
    return "ListAccount";
  }

  @GetMapping("viewaccount")
  public String viewAccount(@RequestParam Integer accountId, Model model, HttpSession session)
  {
    UserEntity user = (UserEntity) session.getAttribute("user");
    if (user == null) {
      return "redirect:/login";
    }

    Optional<AccountEntity> op = repositoryAccount.findById(accountId);
    if (op.isEmpty())
    {
      model.addAttribute("error", "Account not found");
      return "redirect:/listaccount";
    }
    else
    {
      AccountEntity account = op.get();

      // FIXED: Security check - ensure user owns this account
      if (!account.getUserId().equals(user.getUserId())) {
        model.addAttribute("error", "Access denied");
        return "redirect:/listaccount";
      }

      model.addAttribute("account", account);
    }

    return "ViewAccount";
  }

  // FIXED: Added GET mapping to load account for editing
  @GetMapping("editaccount")
  public String editAccountPage(@RequestParam Integer accountId, Model model, HttpSession session)
  {
    UserEntity user = (UserEntity) session.getAttribute("user");
    if (user == null) {
      return "redirect:/login";
    }

    Optional<AccountEntity> op = repositoryAccount.findById(accountId);
    if (op.isEmpty())
    {
      model.addAttribute("error", "Account not found");
      return "redirect:/listaccount";
    }

    AccountEntity account = op.get();

    // Security check
    if (!account.getUserId().equals(user.getUserId())) {
      model.addAttribute("error", "Access denied");
      return "redirect:/listaccount";
    }

    model.addAttribute("account", account);
    return "EditAccount";
  }

  // FIXED: Added POST mapping to save edited account
  @PostMapping("editaccount")
  public String editAccount(AccountEntity entityAccount, HttpSession session, Model model)
  {
    UserEntity user = (UserEntity) session.getAttribute("user");
    if (user == null) {
      return "redirect:/login";
    }

    // Preserve userId
    entityAccount.setUserId(user.getUserId());
    repositoryAccount.save(entityAccount);

    model.addAttribute("success", "Account updated successfully!");
    return "redirect:/listaccount";
  }

  @GetMapping("deleteaccount")
  public String deleteAccount(@RequestParam Integer accountId, HttpSession session, Model model)
  {
    UserEntity user = (UserEntity) session.getAttribute("user");
    if (user == null) {
      return "redirect:/login";
    }

    // FIXED: Security check before delete
    Optional<AccountEntity> op = repositoryAccount.findById(accountId);
    if (op.isPresent() && op.get().getUserId().equals(user.getUserId())) {
      repositoryAccount.deleteById(accountId);
      model.addAttribute("success", "Account deleted successfully!");
    } else {
      model.addAttribute("error", "Cannot delete account");
    }

    return "redirect:/listaccount";
  }
}