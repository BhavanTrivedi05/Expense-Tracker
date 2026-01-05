package com.grownited.controller;

import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;

import com.grownited.entity.UserEntity;
import com.grownited.repository.UserRepository;
import com.grownited.service.MailService;

import jakarta.servlet.http.HttpSession;

@Controller
public class SessionController {

  @Autowired
  private MailService serviceMail;

  @Autowired
  private UserRepository repositoryUser;

  @Autowired
  private PasswordEncoder encoder;

  @GetMapping(value = { "/", "signup" })
  public String signup() {
    return "Signup";
  }

  @GetMapping("login")
  public String login() {
    return "Login";
  }

  @PostMapping("saveuser")
  public String saveUser(UserEntity userEntity, Model model) {
    // Check for duplicate email
    Optional<UserEntity> existingUser = repositoryUser.findByEmail(userEntity.getEmail());
    if (existingUser.isPresent()) {
      model.addAttribute("error", "Email already registered. Please login or use a different email.");
      return "Signup";
    }

    userEntity.setPassword(encoder.encode(userEntity.getPassword()));

    // CRITICAL: First user becomes admin automatically
    long userCount = repositoryUser.count();
    if (userCount == 0) {
      userEntity.setRole("ADMIN");

      // Print admin credentials to console
      System.out.println("\n");
      System.out.println("========================================");
      System.out.println("🎉 FIRST ADMIN ACCOUNT CREATED!");
      System.out.println("========================================");
      System.out.println("Name: " + userEntity.getFirstName() + " " + userEntity.getLastName());
      System.out.println("Email: " + userEntity.getEmail());
      System.out.println("Role: ADMIN");
      System.out.println("========================================");
      System.out.println("⚠️  ADMIN ACCESS INSTRUCTIONS:");
      System.out.println("1. Login at: http://localhost:9999/admin/login");
      System.out.println("2. Email: " + userEntity.getEmail());
      System.out.println("3. Password: (the one you just created)");
      System.out.println("4. Admin Secret Key: SPENDWISE_ADMIN_2026");
      System.out.println("========================================");
      System.out.println("📝 IMPORTANT: Save this information securely!");
      System.out.println("========================================\n");

      model.addAttribute("success", "Admin account created! Check console for login details.");
    } else {
      // All subsequent users are regular users
      userEntity.setRole("USER");
      model.addAttribute("success", "Registration successful! Please login.");
    }

    repositoryUser.save(userEntity);

    // Email disabled for now
    // serviceMail.sendWelcomeMail(userEntity.getEmail(), userEntity.getFirstName());

    return "Login";
  }

  @GetMapping("/forgetpassword")
  public String forgetPassword() {
    return "ForgetPassword";
  }

  @PostMapping("sendOtp")
  public String sendOtp(String email, Model model) {
    Optional<UserEntity> userOpt = repositoryUser.findByEmail(email);
    if (userOpt.isEmpty()) {
      model.addAttribute("error", "Email not found");
      return "ForgetPassword";
    }

    UserEntity user = userOpt.get();
    String otp = String.valueOf((int) (Math.random() * 1000000));
    user.setOtp(otp);
    repositoryUser.save(user);

    // Print OTP to console for testing
    System.out.println("========================================");
    System.out.println("🔑 OTP GENERATED");
    System.out.println("Email: " + email);
    System.out.println("OTP: " + otp);
    System.out.println("========================================");

    model.addAttribute("success", "OTP sent! Check console for OTP.");
    return "ChangePassword";
  }

  @PostMapping("updatepassword")
  public String updatePassword(String email, String password, String otp, Model model) {
    Optional<UserEntity> userOpt = repositoryUser.findByEmail(email);
    if (userOpt.isEmpty()) {
      model.addAttribute("error", "Invalid email");
      return "ChangePassword";
    }

    UserEntity user = userOpt.get();
    if (user.getOtp() == null || !user.getOtp().equals(otp)) {
      model.addAttribute("error", "Invalid OTP");
      return "ChangePassword";
    }

    user.setPassword(encoder.encode(password));
    user.setOtp(null);
    repositoryUser.save(user);

    model.addAttribute("success", "Password updated successfully! Please login.");
    return "Login";
  }

  @PostMapping("authenticate")
  public String authenticate(String email, String password, Model model, HttpSession session) {
    Optional<UserEntity> userOpt = repositoryUser.findByEmail(email);
    if (userOpt.isPresent()) {
      UserEntity user = userOpt.get();
      if (encoder.matches(password, user.getPassword())) {
        session.setAttribute("user", user);

        // Route based on role
        if ("ADMIN".equals(user.getRole())) {
          // Redirect admin to admin dashboard
          return "redirect:/admindashboard";
        } else {
          // Regular user to home
          return "redirect:/home";
        }
      }
    }
    model.addAttribute("error", "Invalid email or password");
    return "Login";
  }

  @GetMapping("logout")
  public String logout(HttpSession session, Model model) {
    session.invalidate();
    model.addAttribute("success", "You have been logged out successfully!");
    return "redirect:/login";
  }
}