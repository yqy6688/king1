package com.travel.utils;

import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;

public class PasswordEncoderTest {
    public static void main(String[] args) {
        BCryptPasswordEncoder encoder = new BCryptPasswordEncoder();
        
        // 生成密码为 "123456" 的哈希
        String password = "123456";
        String encodedPassword = encoder.encode(password);
        
        System.out.println("密码: " + password);
        System.out.println("BCrypt 哈希: " + encodedPassword);
        
        // 验证哈希是否正确
        boolean isMatch = encoder.matches(password, encodedPassword);
        System.out.println("验证结果: " + isMatch);
        
        // 生成其他用户的密码哈希
        String[] users = {"admin", "operator", "sales", "finance", "guide"};
        for (String user : users) {
            String userPassword = "123456";
            String userEncodedPassword = encoder.encode(userPassword);
            System.out.println(user + " 的密码哈希: " + userEncodedPassword);
        }
    }
}