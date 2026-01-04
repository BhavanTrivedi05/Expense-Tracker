package com.grownited.entity;

import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Table;

@Entity // create table
@Table(name = "subcategory") // table name set
public class SubCategoryEntity 
{
	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	private Integer subCategoryId;
	private String title;
	private Integer categoryId;
	private Integer userId;
	public Integer getSubCategoryId() 
	{
		return subCategoryId;
	}
	public void setSubCategoryId(Integer subCategoryId) 
	{
		this.subCategoryId = subCategoryId;
	}
	public String getTitle() 
	{
		return title;
	}
	public void setTitle(String title) 
	{
		this.title = title;
	}
	public Integer getCategoryId() 
	{
		return categoryId;
	}
	public void setCategoryId(Integer categoryId) 
	{
		this.categoryId = categoryId;
	}
	public Integer getUserId() 
	{
		return userId;
	}
	public void setUserId(Integer userId) 
	{
		this.userId = userId;
	}
	
}
