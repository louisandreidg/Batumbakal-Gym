package com.batumbakal.gym.service;

import com.batumbakal.gym.model.Trainer;
import com.batumbakal.gym.repository.TrainerRepository;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class TrainerService {

    private final TrainerRepository trainerRepository;

    public TrainerService(TrainerRepository trainerRepository) {
        this.trainerRepository = trainerRepository;
    }

    public Trainer createTrainer(Trainer trainer) {
        return trainerRepository.save(trainer);
    }

    public List<Trainer> getAllTrainers() {
        return trainerRepository.findAll();
    }

    public Optional<Trainer> getTrainerById(Integer id) {
        return trainerRepository.findById(id);
    }

    public Trainer updateTrainer(Integer id, Trainer updatedTrainer) {
        Trainer trainer = trainerRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Trainer not found"));

        trainer.setFirstName(updatedTrainer.getFirstName());
        trainer.setLastName(updatedTrainer.getLastName());
        trainer.setSpecialty(updatedTrainer.getSpecialty());
        trainer.setContactNumber(updatedTrainer.getContactNumber());

        return trainerRepository.save(trainer);
    }

    public void deleteTrainer(Integer id) {
        if (!trainerRepository.existsById(id)) {
            throw new RuntimeException("Trainer not found");
        }

        trainerRepository.deleteById(id);
    }
}