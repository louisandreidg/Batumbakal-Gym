package com.batumbakal.gym.service;

import com.batumbakal.gym.model.MembershipPlan;
import com.batumbakal.gym.repository.MembershipPlanRepository;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class MembershipPlanService {

    private final MembershipPlanRepository membershipPlanRepository;

    public MembershipPlanService(MembershipPlanRepository membershipPlanRepository) {
        this.membershipPlanRepository = membershipPlanRepository;
    }

    public MembershipPlan createPlan(MembershipPlan plan) {
        return membershipPlanRepository.save(plan);
    }

    public List<MembershipPlan> getAllPlans() {
        return membershipPlanRepository.findAll();
    }

    public Optional<MembershipPlan> getPlanById(Integer id) {
        return membershipPlanRepository.findById(id);
    }

    public MembershipPlan updatePlan(Integer id, MembershipPlan updatedPlan) {
        MembershipPlan plan = membershipPlanRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Membership plan not found"));

        plan.setPlanName(updatedPlan.getPlanName());
        plan.setDurationMonths(updatedPlan.getDurationMonths());
        plan.setPrice(updatedPlan.getPrice());

        return membershipPlanRepository.save(plan);
    }

    public void deletePlan(Integer id) {
        if (!membershipPlanRepository.existsById(id)) {
            throw new RuntimeException("Membership plan not found");
        }

        membershipPlanRepository.deleteById(id);
    }
}