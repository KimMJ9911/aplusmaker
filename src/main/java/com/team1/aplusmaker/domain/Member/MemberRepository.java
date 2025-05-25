package com.team1.aplusmaker.domain.Member;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;


import java.util.Optional;

public interface MemberRepository extends JpaRepository<Member, Long> {
    Optional<Member> findByUsername(String username);
    //특정한 값만 가져오려면 쿼리문으로 작성하라함
    @Query("SELECT m.id FROM Member m WHERE m.username = :username")
    Long findIdByUsername(@Param("username") String username);


}
