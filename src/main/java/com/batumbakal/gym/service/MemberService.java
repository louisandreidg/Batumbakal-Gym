package com.batumbakal.gym.service;

import com.batumbakal.gym.model.Member;
import com.batumbakal.gym.repository.MemberRepository;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class MemberService {

    private final MemberRepository memberRepository;

    public MemberService(MemberRepository memberRepository) {
        this.memberRepository = memberRepository;
    }

    public Member createMember(Member member) {
        return memberRepository.save(member);
    }

    public List<Member> getAllMembers() {
        return memberRepository.findAll();
    }

    public Optional<Member> getMemberById(Integer id) {
        return memberRepository.findById(id);
    }

    public Member updateMember(Integer id, Member updatedMember) {
        Member member = memberRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Member not found"));

        member.setFirstName(updatedMember.getFirstName());
        member.setLastName(updatedMember.getLastName());
        member.setEmail(updatedMember.getEmail());
        member.setContactNumber(updatedMember.getContactNumber());
        member.setEmergencyContact(updatedMember.getEmergencyContact());
        member.setStatus(updatedMember.getStatus());
        member.setTrainerId(updatedMember.getTrainerId());

        return memberRepository.save(member);
    }

    public Member deactivateMember(Integer id) {
        Member member = memberRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Member not found"));

        member.setStatus("Inactive");

        return memberRepository.save(member);
    }
}