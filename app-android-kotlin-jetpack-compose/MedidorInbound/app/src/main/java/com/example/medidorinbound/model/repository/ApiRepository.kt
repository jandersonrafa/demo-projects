package com.example.medidorinbound.model.repository

import com.example.medidorinbound.model.EmployeeDetail
import com.example.medidorinbound.model.Employee
import com.example.medidorinbound.model.api.RetrofitInstance

class ApiRepository {

    private val employeeService = RetrofitInstance.getEmployeeService

    suspend fun getEmployee(): Employee {
        return employeeService.getEmployee()
    }

    suspend fun getEmployeeById(id: Int?): EmployeeDetail {
        if (id != null ) {
            return employeeService.getEmployeeById(id)
        } else  {
            throw RuntimeException("Nenhum id passado ")
        }
    }

    suspend fun login(username: String, password: String) {
        // TODO implementar
    }
}