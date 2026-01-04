package com.grownited.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.grownited.entity.VendorEntity;

// FIXED: Added @Repository annotation
@Repository
public interface VendorRepository extends JpaRepository<VendorEntity, Integer>
{
  // FIXED: Added user-specific query
  List<VendorEntity> findByUserId(Integer userId);
}