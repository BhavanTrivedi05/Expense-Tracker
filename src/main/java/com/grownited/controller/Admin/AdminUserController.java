package com.grownited.controller.Admin;

import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.grownited.entity.UserEntity;
import com.grownited.repository.UserRepository;

import jakarta.servlet.http.HttpSession;

@Controller
@RequestMapping("/admin")
public class AdminUserController {

  @Autowired
  UserRepository repositoryUser;

  @GetMapping("/listusers")
  public String listUsers(HttpSession session, Model model) {
    UserEntity admin = (UserEntity) session.getAttribute("user");

    if (admin == null || !"ADMIN".equals(admin.getRole())) {
      model.addAttribute("error", "Access denied");
      return "redirect:/login";
    }

    List<UserEntity> users = repositoryUser.findAll();
    model.addAttribute("userList", users);
    model.addAttribute("currentAdmin", admin);
    return "ManageUsers";
  }

  @GetMapping("/promoteuser")
  public String promoteUser(@RequestParam Integer userId, HttpSession session, Model model) {
    UserEntity admin = (UserEntity) session.getAttribute("user");

    if (admin == null || !"ADMIN".equals(admin.getRole())) {
      return "redirect:/login";
    }

    Optional<UserEntity> userOpt = repositoryUser.findById(userId);
    if (userOpt.isPresent()) {
      UserEntity user = userOpt.get();
      user.setRole("ADMIN");
      repositoryUser.save(user);

      // Log promotion
      System.out.println("========================================");
      System.out.println("👑 USER PROMOTED TO ADMIN");
      System.out.println("Promoted: " + user.getFirstName() + " " + user.getLastName());
      System.out.println("Email: " + user.getEmail());
      System.out.println("By Admin: " + admin.getFirstName() + " " + admin.getLastName());
      System.out.println("Time: " + java.time.LocalDateTime.now());
      System.out.println("========================================");

      model.addAttribute("success", user.getFirstName() + " " + user.getLastName() + " is now an administrator!");
    }

    return "redirect:/admin/listusers";
  }

  @GetMapping("/demoteuser")
  public String demoteUser(@RequestParam Integer userId, HttpSession session, Model model) {
    UserEntity admin = (UserEntity) session.getAttribute("user");

    if (admin == null || !"ADMIN".equals(admin.getRole())) {
      return "redirect:/login";
    }

    Optional<UserEntity> userOpt = repositoryUser.findById(userId);
    if (userOpt.isPresent()) {
      UserEntity user = userOpt.get();

      // Security: Prevent admin from demoting themselves
      if (user.getUserId().equals(admin.getUserId())) {
        model.addAttribute("error", "You cannot demote yourself! Ask another admin.");
        return "redirect:/admin/listusers";
      }

      // Count remaining admins
      long adminCount = repositoryUser.findAll().stream()
          .filter(u -> "ADMIN".equals(u.getRole()))
          .count();

      // Prevent demoting last admin
      if (adminCount <= 1) {
        model.addAttribute("error", "Cannot demote the last admin! Promote another user first.");
        return "redirect:/admin/listusers";
      }

      user.setRole("USER");
      repositoryUser.save(user);

      // Log demotion
      System.out.println("========================================");
      System.out.println("📉 ADMIN DEMOTED TO USER");
      System.out.println("Demoted: " + user.getFirstName() + " " + user.getLastName());
      System.out.println("By Admin: " + admin.getFirstName() + " " + admin.getLastName());
      System.out.println("Time: " + java.time.LocalDateTime.now());
      System.out.println("========================================");

      model.addAttribute("success", user.getFirstName() + " is now a regular user.");
    }

    return "redirect:/admin/listusers";
  }

  @GetMapping("/deleteuser")
  public String deleteUser(@RequestParam Integer userId, HttpSession session, Model model) {
    UserEntity admin = (UserEntity) session.getAttribute("user");

    if (admin == null || !"ADMIN".equals(admin.getRole())) {
      return "redirect:/login";
    }

    // Prevent deleting yourself
    if (userId.equals(admin.getUserId())) {
      model.addAttribute("error", "You cannot delete your own account!");
      return "redirect:/admin/listusers";
    }

    Optional<UserEntity> userOpt = repositoryUser.findById(userId);
    if (userOpt.isPresent()) {
      UserEntity user = userOpt.get();

      // Log deletion
      System.out.println("========================================");
      System.out.println("🗑️  USER DELETED");
      System.out.println("Deleted: " + user.getFirstName() + " " + user.getLastName());
      System.out.println("Email: " + user.getEmail());
      System.out.println("By Admin: " + admin.getFirstName() + " " + admin.getLastName());
      System.out.println("Time: " + java.time.LocalDateTime.now());
      System.out.println("========================================");

      repositoryUser.deleteById(userId);
      model.addAttribute("success", "User deleted successfully.");
    }

    return "redirect:/admin/listusers";
  }
}