package com.batumbakal.gym.service;

import com.batumbakal.gym.model.Attendance;
import com.batumbakal.gym.repository.AttendanceRepository;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class AttendanceService {

    private final AttendanceRepository attendanceRepository;

    public AttendanceService(AttendanceRepository attendanceRepository) {
        this.attendanceRepository = attendanceRepository;
    }

    public Attendance createAttendance(Attendance attendance) {
        return attendanceRepository.save(attendance);
    }

    public List<Attendance> getAllAttendance() {
        return attendanceRepository.findAll();
    }

    public Optional<Attendance> getAttendanceById(Integer id) {
        return attendanceRepository.findById(id);
    }

    public Attendance updateAttendance(Integer id, Attendance updatedAttendance) {
        Attendance attendance = attendanceRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Attendance record not found"));

        attendance.setMemberId(updatedAttendance.getMemberId());
        attendance.setCheckInTime(updatedAttendance.getCheckInTime());

        return attendanceRepository.save(attendance);
    }

    public void deleteAttendance(Integer id) {
        if (!attendanceRepository.existsById(id)) {
            throw new RuntimeException("Attendance record not found");
        }

        attendanceRepository.deleteById(id);
    }
}