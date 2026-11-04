package com.batumbakal.gym.repository;

import com.batumbakal.gym.model.ClassEnrollment;
import com.batumbakal.gym.model.ClassEnrollmentId;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface ClassEnrollmentRepository extends JpaRepository<ClassEnrollment, ClassEnrollmentId> {

    long countByClassId(Integer classId);
}