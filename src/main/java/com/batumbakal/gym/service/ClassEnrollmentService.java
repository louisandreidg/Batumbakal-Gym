package com.batumbakal.gym.service;

import com.batumbakal.gym.model.ClassEnrollment;
import com.batumbakal.gym.model.ClassEnrollmentId;
import com.batumbakal.gym.model.GymClass;
import com.batumbakal.gym.repository.ClassEnrollmentRepository;
import com.batumbakal.gym.repository.GymClassRepository;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class ClassEnrollmentService {

    private final ClassEnrollmentRepository enrollmentRepository;
    private final GymClassRepository gymClassRepository;

    public ClassEnrollmentService(
            ClassEnrollmentRepository enrollmentRepository,
            GymClassRepository gymClassRepository) {
        this.enrollmentRepository = enrollmentRepository;
        this.gymClassRepository = gymClassRepository;
    }

    public ClassEnrollment createEnrollment(ClassEnrollment enrollment) {
        GymClass gymClass = gymClassRepository.findById(enrollment.getClassId())
                .orElseThrow(() -> new RuntimeException("Class not found"));

        ClassEnrollmentId id = new ClassEnrollmentId(
                enrollment.getMemberId(),
                enrollment.getClassId()
        );

        if (enrollmentRepository.existsById(id)) {
            throw new RuntimeException("Member is already enrolled in this class");
        }

        if (enrollmentRepository.countByClassId(enrollment.getClassId())
                >= gymClass.getCapacity()) {
            throw new RuntimeException("Class capacity has been reached");
        }

        return enrollmentRepository.save(enrollment);
    }

    public List<ClassEnrollment> getAllEnrollments() {
        return enrollmentRepository.findAll();
    }

    public Optional<ClassEnrollment> getEnrollmentById(
            Integer memberId, Integer classId) {
        return enrollmentRepository.findById(
                new ClassEnrollmentId(memberId, classId)
        );
    }

    public ClassEnrollment updateEnrollment(
            Integer memberId,
            Integer classId,
            ClassEnrollment updatedEnrollment) {

        ClassEnrollment enrollment = enrollmentRepository.findById(
                new ClassEnrollmentId(memberId, classId)
        ).orElseThrow(() -> new RuntimeException("Enrollment not found"));

        enrollment.setEnrollmentDate(updatedEnrollment.getEnrollmentDate());

        return enrollmentRepository.save(enrollment);
    }

    public void deleteEnrollment(Integer memberId, Integer classId) {
        ClassEnrollmentId id = new ClassEnrollmentId(memberId, classId);

        if (!enrollmentRepository.existsById(id)) {
            throw new RuntimeException("Enrollment not found");
        }

        enrollmentRepository.deleteById(id);
    }
}