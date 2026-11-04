package com.batumbakal.gym.service;

import com.batumbakal.gym.model.GymClass;
import com.batumbakal.gym.repository.GymClassRepository;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class GymClassService {

    private final GymClassRepository gymClassRepository;

    public GymClassService(GymClassRepository gymClassRepository) {
        this.gymClassRepository = gymClassRepository;
    }

    public GymClass createClass(GymClass gymClass) {
        return gymClassRepository.save(gymClass);
    }

    public List<GymClass> getAllClasses() {
        return gymClassRepository.findAll();
    }

    public Optional<GymClass> getClassById(Integer id) {
        return gymClassRepository.findById(id);
    }

    public GymClass updateClass(Integer id, GymClass updatedClass) {
        GymClass gymClass = gymClassRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Class not found"));

        gymClass.setClassName(updatedClass.getClassName());
        gymClass.setTrainerId(updatedClass.getTrainerId());
        gymClass.setRoom(updatedClass.getRoom());
        gymClass.setClassDate(updatedClass.getClassDate());
        gymClass.setStartTime(updatedClass.getStartTime());
        gymClass.setEndTime(updatedClass.getEndTime());
        gymClass.setCapacity(updatedClass.getCapacity());

        return gymClassRepository.save(gymClass);
    }

    public void deleteClass(Integer id) {
        if (!gymClassRepository.existsById(id)) {
            throw new RuntimeException("Class not found");
        }

        gymClassRepository.deleteById(id);
    }
}