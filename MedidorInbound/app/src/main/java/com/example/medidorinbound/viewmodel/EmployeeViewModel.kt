package com.example.medidorinbound.viewmodel

import android.util.Log
import androidx.lifecycle.LiveData
import androidx.lifecycle.MutableLiveData
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.example.medidorinbound.model.Data
import com.example.medidorinbound.model.Employee
import com.example.medidorinbound.model.repository.ApiRepository
import kotlinx.coroutines.launch
import java.util.Arrays

class EmployeeViewModel: ViewModel() {

    private val repository = ApiRepository()

    private val _employees = MutableLiveData<Employee>()
    val employees: LiveData<Employee> = _employees

    fun fetchEmployees() {
        viewModelScope.launch {
            try {
                val empl = repository.getEmployee()
                _employees.value = empl
            } catch (e: Exception) {
                Log.d("Repo","fetchEmployees exception ${e.message}")
                _employees.value = getMockEmployeeList()
            }
        }
    }

    private fun getMockEmployeeList(): Employee {
        val data1 = Data(
            employee_salary = 1,
            employee_name = "teste1",
            employee_age = 1,
            id = 1,
            profile_image = "teste1"
        )
        val data2 = Data(
            employee_salary = 2,
            employee_name = "teste2",
            employee_age = 2,
            id = 2,
            profile_image = "teste2"
        )
        val data3 = Data(
            employee_salary = 3,
            employee_name = "teste3",
            employee_age = 3,
            id = 3,
            profile_image = "teste3"
        )
        val data4 = Data(
            employee_salary = 4,
            employee_name = "teste4",
            employee_age = 4,
            id = 4,
            profile_image = "teste4"
        )
        val emp = Employee(
            data = Arrays.asList(data1, data2, data3, data4),
            status = "200",
            message = "mocked"
        )
        return emp
    }
}