package com.grownited.controller;

import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.grownited.entity.CategoryEntity;
import com.grownited.entity.UserEntity;
import com.grownited.repository.CategoryRepository;

import jakarta.servlet.http.HttpSession;

@Controller
public class CategoryController
{
  @Autowired
  CategoryRepository repositoryCategory;

  @GetMapping("newcategory")
  public String newCategory(HttpSession session, Model model)
  {
    UserEntity user = (UserEntity) session.getAttribute("user");
    if (user == null) {
      return "redirect:/login";
    }
    return "NewCategory";
  }

  @PostMapping("savecategory")
  public String saveCategory(CategoryEntity entityCategory, HttpSession session, Model model)
  {
    UserEntity user = (UserEntity) session.getAttribute("user");
    if (user == null) {
      return "redirect:/login";
    }

    // FIXED: Set userId
    entityCategory.setUserId(user.getUserId());
    repositoryCategory.save(entityCategory);

    model.addAttribute("success", "Category created successfully!");
    return "redirect:/listcategory";
  }

  @GetMapping("listcategory")
  public String listCategory(Model model, HttpSession session)
  {
    UserEntity user = (UserEntity) session.getAttribute("user");
    if (user == null) {
      return "redirect:/login";
    }

    // FIXED: User-specific categories
    List<CategoryEntity> categoryList = repositoryCategory.findByUserId(user.getUserId());

    // FIXED: Correct attribute name (was "memberList")
    model.addAttribute("categoryList", categoryList);
    return "ListCategory";
  }

  @GetMapping("viewcategory")
  public String viewCategory(@RequestParam Integer categoryId, Model model, HttpSession session)
  {
    UserEntity user = (UserEntity) session.getAttribute("user");
    if (user == null) {
      return "redirect:/login";
    }

    Optional<CategoryEntity> op = repositoryCategory.findById(categoryId);
    if (op.isEmpty())
    {
      model.addAttribute("error", "Category not found");
      return "redirect:/listcategory";
    }
    else
    {
      CategoryEntity category = op.get();

      // Security check
      if (!category.getUserId().equals(user.getUserId())) {
        model.addAttribute("error", "Access denied");
        return "redirect:/listcategory";
      }

      // FIXED: Correct attribute name (was "member")
      model.addAttribute("category", category);
    }

    return "ViewCategory";
  }

  // FIXED: Added GET mapping for edit page
  @GetMapping("editcategory")
  public String editCategoryPage(@RequestParam Integer categoryId, Model model, HttpSession session)
  {
    UserEntity user = (UserEntity) session.getAttribute("user");
    if (user == null) {
      return "redirect:/login";
    }

    Optional<CategoryEntity> op = repositoryCategory.findById(categoryId);
    if (op.isEmpty())
    {
      model.addAttribute("error", "Category not found");
      return "redirect:/listcategory";
    }

    CategoryEntity category = op.get();

    // Security check
    if (!category.getUserId().equals(user.getUserId())) {
      model.addAttribute("error", "Access denied");
      return "redirect:/listcategory";
    }

    model.addAttribute("category", category);
    return "EditCategory";
  }

  // FIXED: Added POST mapping for editing
  @PostMapping("editcategory")
  public String editCategory(CategoryEntity entityCategory, HttpSession session, Model model)
  {
    UserEntity user = (UserEntity) session.getAttribute("user");
    if (user == null) {
      return "redirect:/login";
    }

    // Preserve userId
    entityCategory.setUserId(user.getUserId());
    repositoryCategory.save(entityCategory);

    model.addAttribute("success", "Category updated successfully!");
    return "redirect:/listcategory";
  }

  @GetMapping("deletecategory")
  public String deleteCategory(@RequestParam Integer categoryId, HttpSession session, Model model)
  {
    UserEntity user = (UserEntity) session.getAttribute("user");
    if (user == null) {
      return "redirect:/login";
    }

    // Security check before delete
    Optional<CategoryEntity> op = repositoryCategory.findById(categoryId);
    if (op.isPresent() && op.get().getUserId().equals(user.getUserId())) {
      // ✅ FIXED: Changed repositoryAccount to repositoryCategory
      repositoryCategory.deleteById(categoryId);
      model.addAttribute("success", "Category deleted successfully!");
    } else {
      model.addAttribute("error", "Cannot delete category");
    }

    return "redirect:/listcategory";
  }
}