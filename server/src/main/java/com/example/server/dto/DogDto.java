package com.example.server.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class DogDto {
    private long id;

    private String name;

    private String breed;

    private int yearOfBirth;

    private String arrivalDate;

    private String medicalDetails;

    private int crateNumber;
}
