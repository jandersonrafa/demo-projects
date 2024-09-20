package com.example.medidorinbound.model.api

import retrofit2.Retrofit
import retrofit2.converter.gson.GsonConverterFactory

object RetrofitInstance {

    private const val BASE_URL = "https://dummy.restapiexample.com/api/v1/"

    private val retrofit: Retrofit by lazy {
        Retrofit.Builder()
            .baseUrl(BASE_URL)
            .addConverterFactory(GsonConverterFactory.create())
            .build();
    }

    val getEmployeeService: GetEmployeeService by lazy {
        retrofit.create(GetEmployeeService::class.java)
    }
}