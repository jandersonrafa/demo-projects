package com.example.demo.repository;

import com.example.demo.model.Employee;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.CrudRepository;
import org.springframework.data.repository.query.Param;

import java.util.List;

public interface EmployeeRepository extends CrudRepository<Employee, Integer> {

    @Query(value = "SELECT pg_sleep(:seconds)", nativeQuery = true)
    void exampleBlocking(@Param("seconds") int seconds);

    @Query("SELECT u FROM Employee u ORDER BY u.firstName ASC LIMIT 20")
    List<Employee> findFirst20ByOrderByNameAsc();
}
