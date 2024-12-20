package com.example.demo.service;

import com.example.demo.model.Employee;
import com.example.demo.repository.EmployeeRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDate;
import java.util.Random;

@Service
public class EmployeeService {

    @Autowired
    private EmployeeRepository employeeRepository;

    public Iterable<Employee> findAll() {
        return this.employeeRepository.findFirst20ByOrderByNameAsc();
    }

    public Employee findById(@PathVariable("id") Integer id) {
        return this.employeeRepository.findById(id).get();
    }

    public Employee create(@RequestBody Employee employee) {
        return this.employeeRepository.save(employee);
    }

    public void deleteById(@PathVariable("id") Integer id) {
        this.employeeRepository.deleteById(id);
    }

//    public Employee test() {
//        Employee employee = getEmployee();
//        this.employeeRepository.exampleBlocking(1);
//        Employee save = this.employeeRepository.save(employee);
//        save.setLastName(save.getLastName() + new Random().nextInt());
//        employeeRepository.save(save);
//        return this.employeeRepository.findById(save.getId()).get();
//    }

    private static Employee getEmployee() {
        Employee employee = new Employee();
        employee.setFirstName("Test First Name");
        employee.setLastName("Test Last Name");
        employee.setDateOfBirth(LocalDate.now());
        return employee;
    }

}
