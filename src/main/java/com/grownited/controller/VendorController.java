package com.grownited.controller;

import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.grownited.entity.UserEntity;
import com.grownited.entity.VendorEntity;
import com.grownited.repository.VendorRepository;

import jakarta.servlet.http.HttpSession;

@Controller
public class VendorController
{
  @Autowired
  VendorRepository repositoryVendor;

  @GetMapping("newvendor")
  public String newVendor(HttpSession session, Model model)
  {
    UserEntity user = (UserEntity) session.getAttribute("user");
    if (user == null) {
      return "redirect:/login";
    }
    return "NewVendor";
  }

  @PostMapping("savevendor")
  public String saveVendor(VendorEntity entityVendor, HttpSession session, Model model)
  {
    UserEntity user = (UserEntity) session.getAttribute("user");
    if (user == null) {
      return "redirect:/login";
    }

    // FIXED: Set userId
    entityVendor.setUserId(user.getUserId());
    repositoryVendor.save(entityVendor);

    model.addAttribute("success", "Vendor created successfully!");
    return "redirect:/listvendor";
  }

  @GetMapping("listvendor")
  public String listVendor(Model model, HttpSession session)
  {
    UserEntity user = (UserEntity) session.getAttribute("user");
    if (user == null) {
      return "redirect:/login";
    }

    // FIXED: User-specific vendors
    List<VendorEntity> vendorList = repositoryVendor.findByUserId(user.getUserId());

    // FIXED: Correct attribute name (was "memberList")
    model.addAttribute("vendorList", vendorList);
    return "ListVendor";
  }

  @GetMapping("viewvendor")
  public String viewVendor(@RequestParam Integer vendorId, Model model, HttpSession session)
  {
    UserEntity user = (UserEntity) session.getAttribute("user");
    if (user == null) {
      return "redirect:/login";
    }

    Optional<VendorEntity> op = repositoryVendor.findById(vendorId);
    if (op.isEmpty())
    {
      model.addAttribute("error", "Vendor not found");
      return "redirect:/listvendor";
    }
    else
    {
      VendorEntity vendor = op.get();

      // Security check
      if (!vendor.getUserId().equals(user.getUserId())) {
        model.addAttribute("error", "Access denied");
        return "redirect:/listvendor";
      }

      // FIXED: Correct attribute name (was "member")
      model.addAttribute("vendor", vendor);
    }

    return "ViewVendor";
  }

  // FIXED: Added GET mapping for edit page
  @GetMapping("editvendor")
  public String editVendorPage(@RequestParam Integer vendorId, Model model, HttpSession session)
  {
    UserEntity user = (UserEntity) session.getAttribute("user");
    if (user == null) {
      return "redirect:/login";
    }

    Optional<VendorEntity> op = repositoryVendor.findById(vendorId);
    if (op.isEmpty())
    {
      model.addAttribute("error", "Vendor not found");
      return "redirect:/listvendor";
    }

    VendorEntity vendor = op.get();

    // Security check
    if (!vendor.getUserId().equals(user.getUserId())) {
      model.addAttribute("error", "Access denied");
      return "redirect:/listvendor";
    }

    model.addAttribute("vendor", vendor);
    return "EditVendor";
  }

  // FIXED: Added POST mapping for editing
  @PostMapping("editvendor")
  public String editVendor(VendorEntity entityVendor, HttpSession session, Model model)
  {
    UserEntity user = (UserEntity) session.getAttribute("user");
    if (user == null) {
      return "redirect:/login";
    }

    // Preserve userId
    entityVendor.setUserId(user.getUserId());
    repositoryVendor.save(entityVendor);

    model.addAttribute("success", "Vendor updated successfully!");
    return "redirect:/listvendor";
  }

  @GetMapping("deletevendor")
  public String deleteVendor(@RequestParam Integer vendorId, HttpSession session, Model model)
  {
    UserEntity user = (UserEntity) session.getAttribute("user");
    if (user == null) {
      return "redirect:/login";
    }

    // Security check before delete
    Optional<VendorEntity> op = repositoryVendor.findById(vendorId);
    if (op.isPresent() && op.get().getUserId().equals(user.getUserId())) {
      repositoryVendor.deleteById(vendorId);
      model.addAttribute("success", "Vendor deleted successfully!");
    } else {
      model.addAttribute("error", "Cannot delete vendor");
    }

    return "redirect:/listvendor";
  }
}