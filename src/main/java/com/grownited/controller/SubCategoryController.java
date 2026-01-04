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
import com.grownited.entity.SubCategoryEntity;
import com.grownited.entity.UserEntity;
import com.grownited.repository.CategoryRepository;
import com.grownited.repository.SubCategoryRepository;

import jakarta.servlet.http.HttpSession;

@Controller
public class SubCategoryController
{
  @Autowired
  SubCategoryRepository repositorySubCategory;

  @Autowired
  CategoryRepository repositoryCategory;

  @GetMapping("newsubcategory")
  public String newSubCategory(HttpSession session, Model model)
  {
    UserEntity user = (UserEntity) session.getAttribute("user");
    if (user == null) {
      return "redirect:/login";
    }

    // FIXED: Populate categories for dropdown
    List<CategoryEntity> categories = repositoryCategory.findByUserId(user.getUserId());
    model.addAttribute("allCategories", categories);

    return "NewSubCategory";
  }

  @PostMapping("savesubcategory")
  public String saveSubCategory(SubCategoryEntity entitySubCategory, HttpSession session, Model model)
  {
    UserEntity user = (UserEntity) session.getAttribute("user");
    if (user == null) {
      return "redirect:/login";
    }

    // FIXED: Set userId
    entitySubCategory.setUserId(user.getUserId());
    repositorySubCategory.save(entitySubCategory);

    model.addAttribute("success", "Subcategory created successfully!");
    return "redirect:/listsubcategory";
  }

  @GetMapping("listsubcategory")
  public String listSubCategory(Model model, HttpSession session)
  {
    UserEntity user = (UserEntity) session.getAttribute("user");
    if (user == null) {
      return "redirect:/login";
    }

    // FIXED: User-specific subcategories
    List<SubCategoryEntity> subcategoryList = repositorySubCategory.findByUserId(user.getUserId());
    model.addAttribute("subcategoryList", subcategoryList);
    return "ListSubCategory";
  }

  @GetMapping("viewsubcategory")
  public String viewSubCategory(@RequestParam Integer subcategoryId, Model model, HttpSession session)
  {
    UserEntity user = (UserEntity) session.getAttribute("user");
    if (user == null) {
      return "redirect:/login";
    }

    Optional<SubCategoryEntity> op = repositorySubCategory.findById(subcategoryId);
    if (op.isEmpty())
    {
      model.addAttribute("error", "Subcategory not found");
      return "redirect:/listsubcategory";
    }
    else
    {
      SubCategoryEntity subcategory = op.get();

      // Security check
      if (!subcategory.getUserId().equals(user.getUserId())) {
        model.addAttribute("error", "Access denied");
        return "redirect:/listsubcategory";
      }

      model.addAttribute("subcategory", subcategory);
    }

    return "ViewSubCategory";
  }

  // FIXED: Added GET mapping for edit page
  @GetMapping("editsubcategory")
  public String editSubCategoryPage(@RequestParam Integer subcategoryId, Model model, HttpSession session)
  {
    UserEntity user = (UserEntity) session.getAttribute("user");
    if (user == null) {
      return "redirect:/login";
    }

    Optional<SubCategoryEntity> op = repositorySubCategory.findById(subcategoryId);
    if (op.isEmpty())
    {
      model.addAttribute("error", "Subcategory not found");
      return "redirect:/listsubcategory";
    }

    SubCategoryEntity subcategory = op.get();

    // Security check
    if (!subcategory.getUserId().equals(user.getUserId())) {
      model.addAttribute("error", "Access denied");
      return "redirect:/listsubcategory";
    }

    // FIXED: Populate categories for dropdown
    List<CategoryEntity> categories = repositoryCategory.findByUserId(user.getUserId());
    model.addAttribute("allCategories", categories);
    model.addAttribute("subcategory", subcategory);

    return "EditSubCategory";
  }

  // FIXED: Added POST mapping for editing
  @PostMapping("editsubcategory")
  public String editSubCategory(SubCategoryEntity entitySubCategory, HttpSession session, Model model)
  {
    UserEntity user = (UserEntity) session.getAttribute("user");
    if (user == null) {
      return "redirect:/login";
    }

    // Preserve userId
    entitySubCategory.setUserId(user.getUserId());
    repositorySubCategory.save(entitySubCategory);

    model.addAttribute("success", "Subcategory updated successfully!");
    return "redirect:/listsubcategory";
  }

  @GetMapping("deletesubcategory")
  public String deleteSubCategory(@RequestParam Integer subcategoryId, HttpSession session, Model model)
  {
    UserEntity user = (UserEntity) session.getAttribute("user");
    if (user == null) {
      return "redirect:/login";
    }

    // Security check before delete
    Optional<SubCategoryEntity> op = repositorySubCategory.findById(subcategoryId);
    if (op.isPresent() && op.get().getUserId().equals(user.getUserId())) {
      repositorySubCategory.deleteById(subcategoryId);
      model.addAttribute("success", "Subcategory deleted successfully!");
    } else {
      model.addAttribute("error", "Cannot delete subcategory");
    }

    return "redirect:/listsubcategory";
  }
}