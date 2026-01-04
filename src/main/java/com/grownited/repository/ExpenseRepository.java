package com.grownited.repository;

import java.time.LocalDateTime;
import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import com.grownited.entity.ExpenseEntity;

@Repository
public interface ExpenseRepository extends JpaRepository<ExpenseEntity, Integer>
{
  // FIXED: Added user-specific queries
  List<ExpenseEntity> findByUserId(Integer userId);

  // FIXED: Added date range query for reports
  List<ExpenseEntity> findByUserIdAndTranscationDateBetween(
      Integer userId, LocalDateTime start, LocalDateTime end);

  // FIXED: Added category filter
  List<ExpenseEntity> findByCategoryId(Integer categoryId);

  // FIXED: Added sum query for total expenses
  @Query("SELECT SUM(e.amount) FROM ExpenseEntity e WHERE e.userId = :userId")
  Double sumAmountByUserId(@Param("userId") Integer userId);
}