package com.example.medidorinbound.viewmodel

import android.util.Log
import androidx.lifecycle.LiveData
import androidx.lifecycle.MutableLiveData
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.example.medidorinbound.model.Data
import com.example.medidorinbound.model.EmployeeDetail
import com.example.medidorinbound.model.repository.ApiRepository
import kotlinx.coroutines.launch

class EmployeeDetailViewModel: ViewModel() {

    private val repository = ApiRepository()

    private val _employeeDetail = MutableLiveData<EmployeeDetail>()
    val employeeDetail: LiveData<EmployeeDetail> = _employeeDetail

    fun fetchEmployees(id: Int?) {
        viewModelScope.launch {
            try {
                val empl = repository.getEmployeeById(id)
                _employeeDetail.value = empl
            } catch (e: Exception) {
                Log.d("Repo","fetchEmployees exception ${e.message}" + id)
                _employeeDetail.value = getMockEmployeeDetail(id)
            }
        }
    }

    private fun getMockEmployeeDetail(id: Int?): EmployeeDetail {
        val data1 = Data(
            employee_salary = 10,
            employee_name = "teste" + id,
            employee_age = id!!,
            id = id!!,
            profile_image = "teste" + id
        )
        val emp = EmployeeDetail(
            data = data1,
            status = "200",
            message = "mocked"
        )
        return emp
    }
}