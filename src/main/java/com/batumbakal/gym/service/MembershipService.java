package com.batumbakal.gym.service;

import com.batumbakal.gym.model.Membership;
import com.batumbakal.gym.repository.MembershipRepository;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class MembershipService {

    private final MembershipRepository membershipRepository;

    public MembershipService(MembershipRepository membershipRepository) {
        this.membershipRepository = membershipRepository;
    }

    public Membership createMembership(Membership membership) {
        return membershipRepository.save(membership);
    }

    public List<Membership> getAllMemberships() {
        return membershipRepository.findAll();
    }

    public Optional<Membership> getMembershipById(Integer id) {
        return membershipRepository.findById(id);
    }

    public Membership updateMembership(Integer id, Membership updatedMembership) {
        Membership membership = membershipRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Membership not found"));

        membership.setMemberId(updatedMembership.getMemberId());
        membership.setPlanId(updatedMembership.getPlanId());
        membership.setStartDate(updatedMembership.getStartDate());
        membership.setEndDate(updatedMembership.getEndDate());
        membership.setStatus(updatedMembership.getStatus());

        return membershipRepository.save(membership);
    }

    public Membership cancelMembership(Integer id) {
        Membership membership = membershipRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Membership not found"));

        membership.setStatus("Cancelled");

        return membershipRepository.save(membership);
    }
}