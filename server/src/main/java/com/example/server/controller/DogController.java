package com.example.server.controller;

import com.example.server.dto.DogDto;
import com.example.server.service.DogService;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/dogs")
public class DogController {

    private final DogService dogService;

    public DogController(DogService dogService) {
        this.dogService = dogService;
    }

    @GetMapping
    public ResponseEntity<List<DogDto>> getAllDogs() {
        return ResponseEntity.ok(dogService.getAllDogs());
    }

    @PostMapping
    public ResponseEntity<DogDto> addDog(@RequestBody DogDto dogDto) {
        return ResponseEntity.ok(dogService.addDog(dogDto));
    }

    @PutMapping("/{id}")
    public ResponseEntity<DogDto> updateDog(@PathVariable Long id, @RequestBody DogDto dogDto) {
        return ResponseEntity.ok(dogService.updateDog(id, dogDto));
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> removeDog(@PathVariable Long id) {
        dogService.removeDog(id);
        return new ResponseEntity<>(HttpStatus.OK);
    }
}
