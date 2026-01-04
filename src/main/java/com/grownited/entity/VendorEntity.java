package com.grownited.entity;

import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Table;

@Entity // create table
@Table(name = "vendor") // table name set
public class VendorEntity 
{
	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	private Integer vendorId;
	private String title;
	private Integer userId;
	public Integer getVendorId() 
	{
		return vendorId;
	}
	public void setVendorId(Integer vendorId) 
	{
		this.vendorId = vendorId;
	}
	public String getTitle() 
	{
		return title;
	}
	public void setTitle(String title) 
	{
		this.title = title;
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
