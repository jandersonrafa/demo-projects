package com.example.medidorinbound.model.api

import com.example.medidorinbound.model.EmployeeDetail
import com.example.medidorinbound.model.Employee
import retrofit2.http.GET
import retrofit2.http.POST
import retrofit2.http.Path

interface GetEmployeeService {

    @GET("employees")
    suspend fun getEmployee(): Employee

    @GET("employee/{id}")
    suspend fun getEmployeeById(@Path("id") employeedId: Int): EmployeeDetail

}