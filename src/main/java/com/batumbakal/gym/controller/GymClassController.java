package com.batumbakal.gym.controller;

import com.batumbakal.gym.model.GymClass;
import com.batumbakal.gym.service.GymClassService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/classes")
@CrossOrigin(origins = "*")
public class GymClassController {

    private final GymClassService gymClassService;

    public GymClassController(GymClassService gymClassService) {
        this.gymClassService = gymClassService;
    }

    @PostMapping
    public GymClass createClass(@RequestBody GymClass gymClass) {
        return gymClassService.createClass(gymClass);
    }

    @GetMapping
    public List<GymClass> getAllClasses() {
        return gymClassService.getAllClasses();
    }

    @GetMapping("/{id}")
    public ResponseEntity<GymClass> getClassById(@PathVariable Integer id) {
        return gymClassService.getClassById(id)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    @PutMapping("/{id}")
    public GymClass updateClass(
            @PathVariable Integer id,
            @RequestBody GymClass gymClass) {
        return gymClassService.updateClass(id, gymClass);
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteClass(@PathVariable Integer id) {
        gymClassService.deleteClass(id);
        return ResponseEntity.noContent().build();
    }
}