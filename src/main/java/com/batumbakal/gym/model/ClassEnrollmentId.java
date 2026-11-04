package com.batumbakal.gym.model;

import java.io.Serializable;
import java.util.Objects;

public class ClassEnrollmentId implements Serializable {

    private Integer memberId;
    private Integer classId;

    public ClassEnrollmentId() {
    }

    public ClassEnrollmentId(Integer memberId, Integer classId) {
        this.memberId = memberId;
        this.classId = classId;
    }

    @Override
    public boolean equals(Object object) {
        if (this == object) return true;
        if (!(object instanceof ClassEnrollmentId)) return false;
        ClassEnrollmentId that = (ClassEnrollmentId) object;
        return Objects.equals(memberId, that.memberId)
                && Objects.equals(classId, that.classId);
    }

    @Override
    public int hashCode() {
        return Objects.hash(memberId, classId);
    }
}