package com.batumbakal.gym.controller;

import com.batumbakal.gym.model.ClassEnrollment;
import com.batumbakal.gym.service.ClassEnrollmentService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/class-enrollments")
@CrossOrigin(origins = "*")
public class ClassEnrollmentController {

    private final ClassEnrollmentService enrollmentService;

    public ClassEnrollmentController(ClassEnrollmentService enrollmentService) {
        this.enrollmentService = enrollmentService;
    }

    @PostMapping
    public ClassEnrollment createEnrollment(@RequestBody ClassEnrollment enrollment) {
        return enrollmentService.createEnrollment(enrollment);
    }

    @GetMapping
    public List<ClassEnrollment> getAllEnrollments() {
        return enrollmentService.getAllEnrollments();
    }

    @GetMapping("/{memberId}/{classId}")
    public ResponseEntity<ClassEnrollment> getEnrollmentById(
            @PathVariable Integer memberId,
            @PathVariable Integer classId) {

        return enrollmentService.getEnrollmentById(memberId, classId)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    @PutMapping("/{memberId}/{classId}")
    public ClassEnrollment updateEnrollment(
            @PathVariable Integer memberId,
            @PathVariable Integer classId,
            @RequestBody ClassEnrollment enrollment) {

        return enrollmentService.updateEnrollment(memberId, classId, enrollment);
    }

    @DeleteMapping("/{memberId}/{classId}")
    public ResponseEntity<Void> deleteEnrollment(
            @PathVariable Integer memberId,
            @PathVariable Integer classId) {

        enrollmentService.deleteEnrollment(memberId, classId);
        return ResponseEntity.noContent().build();
    }
}