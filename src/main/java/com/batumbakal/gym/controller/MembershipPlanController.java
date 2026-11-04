package com.batumbakal.gym.controller;

import com.batumbakal.gym.model.MembershipPlan;
import com.batumbakal.gym.service.MembershipPlanService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/membership-plans")
@CrossOrigin(origins = "*")
public class MembershipPlanController {

    private final MembershipPlanService membershipPlanService;

    public MembershipPlanController(MembershipPlanService membershipPlanService) {
        this.membershipPlanService = membershipPlanService;
    }

    @PostMapping
    public MembershipPlan createPlan(@RequestBody MembershipPlan plan) {
        return membershipPlanService.createPlan(plan);
    }

    @GetMapping
    public List<MembershipPlan> getAllPlans() {
        return membershipPlanService.getAllPlans();
    }

    @GetMapping("/{id}")
    public ResponseEntity<MembershipPlan> getPlanById(@PathVariable Integer id) {
        return membershipPlanService.getPlanById(id)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    @PutMapping("/{id}")
    public MembershipPlan updatePlan(
            @PathVariable Integer id,
            @RequestBody MembershipPlan plan) {
        return membershipPlanService.updatePlan(id, plan);
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deletePlan(@PathVariable Integer id) {
        membershipPlanService.deletePlan(id);
        return ResponseEntity.noContent().build();
    }
}