package com.grownited.entity;

import java.time.LocalDate;

import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Table;

@Entity // create table
@Table(name = "users") // table name set
public class UserEntity 
{
	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	private Integer userId;//primary key 
	private String firstName;
	private String lastName;
	private String email;
	private String password;
	private String role;
	private LocalDate dob;
	private String contactNum;
	private String gender;
	private String otp; // Ensure OTP field exists
	
	public Integer getUserId() 
	{
		return userId;
	}
	public void setUserId(Integer userId) 
	{
		this.userId = userId;
	}
	public String getFirstName() 
	{
		return firstName;
	}
	public void setFirstName(String firstName) 
	{
		this.firstName = firstName;
	}
	public String getLastName() 
	{
		return lastName;
	}
	public void setLastName(String lastName) 
	{
		this.lastName = lastName;
	}
	public String getEmail() 
	{
		return email;
	}
	public void setEmail(String email) 
	{
		this.email = email;
	}
	public String getPassword() 
	{
		return password;
	}
	public void setPassword(String password) 
	{
		this.password = password;
	}
	public String getRole() 
	{
		return role;
	}
	public void setRole(String role) 
	{
		this.role = role;
	}
	public String getOtp() 
	{
		return otp;
	}
	public void setOtp(String otp) 
	{
		this.otp = otp;
	}
	public String getContactNum() 
	{
		return contactNum;
	}
	public void setContactNum(String contactNum) 
	{
		this.contactNum = contactNum;
	}
	public String getGender() 
	{
		return gender;
	}
	public void setGender(String gender) 
	{
		this.gender = gender;
	}
	public LocalDate getdob()
	{
		return dob;
	}
	public void setdob(LocalDate dob) 
	{
		this.dob = dob;
	}
	
}
