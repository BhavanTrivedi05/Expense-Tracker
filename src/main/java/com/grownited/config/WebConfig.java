package com.grownited.config;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.InterceptorRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

@Configuration
public class WebConfig implements WebMvcConfigurer {

  @Autowired
  private PermissionInterceptor permissionInterceptor;

  @Override
  public void addInterceptors(InterceptorRegistry registry) {
    registry.addInterceptor(permissionInterceptor)
        .addPathPatterns("/**")
        .excludePathPatterns(
            "/",
            "/login",
            "/signup",
            "/saveuser",
            "/authenticate",
            "/logout",
            "/admin/login",
            "/admin/authenticate",
            "/admin/logout",
            "/forgetpassword",
            "/sendOtp",
            "/updatepassword",
            "/error",
            "/css/**",
            "/js/**",
            "/images/**"
        );
  }
}