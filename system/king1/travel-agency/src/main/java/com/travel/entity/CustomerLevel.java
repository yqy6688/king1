package com.travel.entity;

import lombok.Data;

@Data
public class CustomerLevel {
    private Long id;
    private String name;
    private Double minConsumption;
    private Double discount;
    private String description;
}