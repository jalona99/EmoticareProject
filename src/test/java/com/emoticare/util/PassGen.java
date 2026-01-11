package com.emoticare.util;

import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;

public class PassGen {
    public static void main(String[] args) {
        BCryptPasswordEncoder encoder = new BCryptPasswordEncoder(12);
        String raw = "password123";
        String encoded = encoder.encode(raw);
        System.out.println("HASH: " + encoded);
    }
}
