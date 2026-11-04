package com.batumbakal.gym.model;

import jakarta.persistence.*;
import java.time.LocalDate;

@Entity
@Table(name = "class_enrollments")
@IdClass(ClassEnrollmentId.class)
public class ClassEnrollment {

    @Id
    @Column(name = "member_id")
    private Integer memberId;

    @Id
    @Column(name = "class_id")
    private Integer classId;

    @Column(name = "enrollment_date", nullable = false)
    private LocalDate enrollmentDate;

    @PrePersist
    public void setDefaultEnrollmentDate() {
        if (enrollmentDate == null) {
            enrollmentDate = LocalDate.now();
        }
    }

    public Integer getMemberId() {
        return memberId;
    }

    public void setMemberId(Integer memberId) {
        this.memberId = memberId;
    }

    public Integer getClassId() {
        return classId;
    }

    public void setClassId(Integer classId) {
        this.classId = classId;
    }

    public LocalDate getEnrollmentDate() {
        return enrollmentDate;
    }

    public void setEnrollmentDate(LocalDate enrollmentDate) {
        this.enrollmentDate = enrollmentDate;
    }
}