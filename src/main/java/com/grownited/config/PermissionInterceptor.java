package com.grownited.config;

import org.springframework.stereotype.Component;
import org.springframework.web.servlet.HandlerInterceptor;

import com.grownited.entity.UserEntity;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@Component
public class PermissionInterceptor implements HandlerInterceptor {

  @Override
  public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {

    String uri = request.getRequestURI();
    HttpSession session = request.getSession(false);

    // Check if user is logged in
    if (session == null || session.getAttribute("user") == null) {
      response.sendRedirect(request.getContextPath() + "/login");
      return false;
    }

    UserEntity user = (UserEntity) session.getAttribute("user");

    // Check admin-only routes
    if (uri.startsWith(request.getContextPath() + "/admin/") &&
        !uri.contains("/admin/login") &&
        !uri.contains("/admin/authenticate")) {

      if (!"ADMIN".equals(user.getRole())) {
        System.out.println("========================================");
        System.out.println("⚠️  UNAUTHORIZED ADMIN ACCESS ATTEMPT");
        System.out.println("User: " + user.getFirstName() + " " + user.getLastName());
        System.out.println("Email: " + user.getEmail());
        System.out.println("Role: " + user.getRole());
        System.out.println("Attempted URL: " + uri);
        System.out.println("Time: " + java.time.LocalDateTime.now());
        System.out.println("========================================");

        response.sendRedirect(request.getContextPath() + "/home?error=access_denied");
        return false;
      }
    }

    // Check category/vendor/subcategory routes (admin only)
    String[] adminOnlyRoutes = {
        "/newcategory", "/savecategory", "/editcategory", "/deletecategory",
        "/newvendor", "/savevendor", "/editvendor", "/deletevendor",
        "/newsubcategory", "/savesubcategory", "/editsubcategory", "/deletesubcategory",
        "/admindashboard"
    };

    for (String route : adminOnlyRoutes) {
      if (uri.endsWith(route)) {
        if (!"ADMIN".equals(user.getRole())) {
          response.sendRedirect(request.getContextPath() + "/home?error=admin_only");
          return false;
        }
      }
    }

    return true;
  }
}