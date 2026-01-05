package com.grownited.controller.Admin;

import java.time.LocalDateTime;
import java.util.Optional;
import java.util.concurrent.ConcurrentHashMap;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import com.grownited.entity.UserEntity;
import com.grownited.repository.UserRepository;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;

@Controller
@RequestMapping("/admin")
public class AdminAuthController {

  @Autowired
  private UserRepository repositoryUser;

  @Autowired
  private PasswordEncoder encoder;

  // Admin Secret Key - Can be overridden by environment variable
  @Value("${admin.secret.key:SPENDWISE_ADMIN_2026}")
  private String ADMIN_SECRET_KEY;

  // Track failed login attempts (IP-based rate limiting)
  private static final ConcurrentHashMap<String, Integer> failedAttempts = new ConcurrentHashMap<>();
  private static final ConcurrentHashMap<String, LocalDateTime> lockoutTime = new ConcurrentHashMap<>();
  private static final int MAX_ATTEMPTS = 5;
  private static final int LOCKOUT_MINUTES = 30;

  @GetMapping("/login")
  public String adminLogin(HttpSession session, Model model) {
    // If already logged in as admin, redirect to dashboard
    UserEntity user = (UserEntity) session.getAttribute("user");
    if (user != null && "ADMIN".equals(user.getRole())) {
      return "redirect:/admindashboard";
    }
    return "AdminLogin";
  }

  @PostMapping("/authenticate")
  public String adminAuthenticate(String email, String password, String adminKey,
                                  HttpSession session, Model model, HttpServletRequest request) {

    String ipAddress = request.getRemoteAddr();

    // Check if IP is locked out
    if (isLockedOut(ipAddress)) {
      model.addAttribute("error", "Too many failed attempts. Account locked for 30 minutes.");
      return "AdminLogin";
    }

    // LAYER 1: Verify Admin Secret Key
    if (!ADMIN_SECRET_KEY.equals(adminKey)) {
      recordFailedAttempt(ipAddress, email, "Invalid secret key");
      model.addAttribute("error", "Invalid admin secret key. Access denied.");
      return "AdminLogin";
    }

    // LAYER 2: Verify User Exists
    Optional<UserEntity> userOpt = repositoryUser.findByEmail(email);
    if (userOpt.isEmpty()) {
      recordFailedAttempt(ipAddress, email, "User not found");
      model.addAttribute("error", "Invalid email or password.");
      return "AdminLogin";
    }

    UserEntity user = userOpt.get();

    // LAYER 3: Verify Password
    if (!encoder.matches(password, user.getPassword())) {
      recordFailedAttempt(ipAddress, email, "Wrong password");
      model.addAttribute("error", "Invalid email or password.");
      return "AdminLogin";
    }

    // LAYER 4: Verify Admin Role
    if (!"ADMIN".equals(user.getRole())) {
      recordFailedAttempt(ipAddress, email, "Not an admin");
      model.addAttribute("error", "Access denied. This account does not have administrator privileges.");
      return "AdminLogin";
    }

    // SUCCESS: Grant Access
    session.setAttribute("user", user);
    clearFailedAttempts(ipAddress);

    // Log successful admin login
    System.out.println("========================================");
    System.out.println("✅ ADMIN LOGIN SUCCESSFUL");
    System.out.println("Admin: " + user.getFirstName() + " " + user.getLastName());
    System.out.println("Email: " + email);
    System.out.println("IP: " + ipAddress);
    System.out.println("Time: " + LocalDateTime.now());
    System.out.println("========================================");

    return "redirect:/admindashboard";
  }

  @GetMapping("/logout")
  public String adminLogout(HttpSession session, Model model) {
    UserEntity user = (UserEntity) session.getAttribute("user");

    if (user != null) {
      System.out.println("========================================");
      System.out.println("🔓 ADMIN LOGOUT");
      System.out.println("Admin: " + user.getFirstName() + " " + user.getLastName());
      System.out.println("Time: " + LocalDateTime.now());
      System.out.println("========================================");
    }

    session.invalidate();
    model.addAttribute("success", "Admin logged out successfully!");
    return "redirect:/admin/login";
  }

  // Helper methods for rate limiting
  private boolean isLockedOut(String ipAddress) {
    if (lockoutTime.containsKey(ipAddress)) {
      LocalDateTime lockTime = lockoutTime.get(ipAddress);
      if (LocalDateTime.now().isBefore(lockTime.plusMinutes(LOCKOUT_MINUTES))) {
        return true;
      } else {
        // Lockout expired, clear it
        lockoutTime.remove(ipAddress);
        failedAttempts.remove(ipAddress);
        return false;
      }
    }
    return false;
  }

  private void recordFailedAttempt(String ipAddress, String email, String reason) {
    int attempts = failedAttempts.getOrDefault(ipAddress, 0) + 1;
    failedAttempts.put(ipAddress, attempts);

    // Log the attempt
    System.out.println("========================================");
    System.out.println("⚠️  UNAUTHORIZED ADMIN ACCESS ATTEMPT");
    System.out.println("IP Address: " + ipAddress);
    System.out.println("Email: " + email);
    System.out.println("Reason: " + reason);
    System.out.println("Attempt #: " + attempts);
    System.out.println("Time: " + LocalDateTime.now());
    System.out.println("========================================");

    // Lock account after max attempts
    if (attempts >= MAX_ATTEMPTS) {
      lockoutTime.put(ipAddress, LocalDateTime.now());
      System.out.println("🔒 IP ADDRESS LOCKED: " + ipAddress);
    }
  }

  private void clearFailedAttempts(String ipAddress) {
    failedAttempts.remove(ipAddress);
    lockoutTime.remove(ipAddress);
  }
}