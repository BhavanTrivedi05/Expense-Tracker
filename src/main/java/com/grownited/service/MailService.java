package com.grownited.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.stereotype.Service;

@Service
public class MailService 
{

	@Autowired
	JavaMailSender mailSender;

	public void sendWelcomeMail(String email, String firstName) 
	{
		String subject = "Welcome to Expense Tracker App";
		String body = "Hey " + firstName
				+ ", We're excited to have you on board. If you have any questions, feel free to reach out – we’re here to help!";
		String from = "bhavantrivedi05@gmail.com";

		// logic
		SimpleMailMessage message = new SimpleMailMessage();

		message.setFrom(from);
		message.setTo(email);
		message.setSubject(subject);
		message.setText(body);

		mailSender.send(message);

	}
	public void sendOtpMail(String toEmail, int otp) {
        SimpleMailMessage message = new SimpleMailMessage();
        message.setTo(toEmail);
        message.setSubject("Your OTP for Password Reset");
        message.setText("Your OTP for password reset is: " + otp + "\n\nPlease enter this OTP to reset your password.");

        mailSender.send(message);
    }
	public void sendOtpForForgetPassword(String email, String firstName, String otp) 
	{
		String subject = "OTP for Resetpassword";
		String body = "Hey " + firstName
				+ ", It seems you have request for forget password, please use below otp for reset password.  If not then simply ignore the message!OTP:"+otp;
		String from = "tejasshah2k19@gmail.com";

		// logic
		SimpleMailMessage message = new SimpleMailMessage();

		message.setFrom(from);
		message.setTo(email);
		message.setSubject(subject);
		message.setText(body);

		mailSender.send(message);
	
	}
}