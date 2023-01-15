package com.example.server.domain;

import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import lombok.*;

@Entity
@NoArgsConstructor
@AllArgsConstructor
@Builder
@Getter
@Setter
public class Dog {
    @Id
    @GeneratedValue
    private long id;

    private String name;

    private String breed;

    private int yearOfBirth;

    private String arrivalDate;

    private String medicalDetails;

    private int crateNumber;
}
