package com.example.server.service;

import com.example.server.domain.Dog;
import com.example.server.dto.DogDto;
import com.example.server.exceptions.DogShelterException;
import com.example.server.repository.DogRepository;
import lombok.extern.java.Log;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;

@Service
@Log
public class DogService {

    private final DogRepository dogRepository;

    public DogService(DogRepository dogRepository) {
        this.dogRepository = dogRepository;
    }

    public DogDto addDog(DogDto dogDto) {
        Dog dog = Dog.builder()
                .name(dogDto.getName())
                .breed(dogDto.getBreed())
                .arrivalDate(dogDto.getArrivalDate())
                .crateNumber(dogDto.getCrateNumber())
                .yearOfBirth(dogDto.getYearOfBirth())
                .medicalDetails(dogDto.getMedicalDetails())
                .build();
        dogRepository.save(dog);
        log.info("dog added with id: " + dog.getId());
        dogDto.setId(dog.getId());
        return dogDto;
    }

    public void removeDog(Long id) {
        Dog dog = dogRepository.findById(id).orElseThrow(() -> {
            throw new DogShelterException("Dog doesn't exist!");
        });

        dogRepository.deleteById(id);
        log.info("dog with id: " + id + " was deleted");
    }

    public DogDto updateDog(Long id, DogDto dogDto) {
        Dog dog = dogRepository.findById(id).orElseThrow(() -> {
            throw new DogShelterException("Dog doesn't exist!");
        });

        dog.setName(dogDto.getName());
        dog.setBreed(dogDto.getBreed());
        dog.setArrivalDate(dogDto.getArrivalDate());
        dog.setCrateNumber(dogDto.getCrateNumber());
        dog.setMedicalDetails(dogDto.getMedicalDetails());
        dog.setYearOfBirth(dogDto.getYearOfBirth());
        dogRepository.save(dog);
        log.info("dog with id: " + id + " was updated");

        dogDto.setId(dog.getId());
        return dogDto;
    }

    public List<DogDto> getAllDogs() {
        Iterable<Dog> dogs = dogRepository.findAll();
        List<DogDto> dogDtos = new ArrayList<>();

        dogs.forEach(dog ->
                dogDtos.add(DogDto.builder()
                        .id(dog.getId())
                        .name(dog.getName())
                        .breed(dog.getBreed())
                        .arrivalDate(dog.getArrivalDate())
                        .crateNumber(dog.getCrateNumber())
                        .yearOfBirth(dog.getYearOfBirth())
                        .medicalDetails(dog.getMedicalDetails())
                        .build()
                ));

        log.info("retrieved list of dogs");

        return dogDtos;
    }
}
