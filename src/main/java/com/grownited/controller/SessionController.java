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
    public String saveUser(UserEntity userEntity) {
        userEntity.setPassword(encoder.encode(userEntity.getPassword()));

        // Ensure role is set (default to USER if not provided)
        if (userEntity.getRole() == null || userEntity.getRole().isEmpty()) {
            userEntity.setRole("USER");
        }

        repositoryUser.save(userEntity);
        serviceMail.sendWelcomeMail(userEntity.getEmail(), userEntity.getFirstName());

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

        serviceMail.sendOtpForForgetPassword(email, user.getFirstName(), otp);
        return "ChangePassword";
    }

    @PostMapping("updatepassword")
    public String updatePassword(String email, String password, String otp, Model model) {
        Optional<UserEntity> userOpt = repositoryUser.findByEmail(email);
        if (userOpt.isEmpty()) {
            model.addAttribute("error", "Invalid Data");
            return "ChangePassword";
        }

        UserEntity user = userOpt.get();
        if (!user.getOtp().equals(otp)) {
            model.addAttribute("error", "Invalid OTP");
            return "ChangePassword";
        }

        user.setPassword(encoder.encode(password));
        user.setOtp(null);
        repositoryUser.save(user);

        model.addAttribute("msg", "Password updated successfully");
        return "Login";
    }

    @PostMapping("authenticate")
    public String authenticate(String email, String password, Model model, HttpSession session) {
        Optional<UserEntity> userOpt = repositoryUser.findByEmail(email);
        if (userOpt.isPresent()) {
            UserEntity user = userOpt.get();
            if (encoder.matches(password, user.getPassword())) {
                session.setAttribute("user", user);
                return user.getRole().equals("ADMIN") ? "redirect:/admindashboard" : "redirect:/home";
            }
        }
        model.addAttribute("error", "Invalid Credentials");
        return "Login";
    }

    @GetMapping("logout")
    public String logout(HttpSession session) {
        session.invalidate();
        return "redirect:/login";
    }
}
