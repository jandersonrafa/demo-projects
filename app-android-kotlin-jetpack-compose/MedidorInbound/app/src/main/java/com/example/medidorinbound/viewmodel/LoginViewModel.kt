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

class LoginViewModel: ViewModel() {

    private val repository = ApiRepository()

    private val _login = MutableLiveData<Employee>()
//    val login: LiveData<Employee> = _login

    fun login(username: String, password: String) {
        viewModelScope.launch {
            try {
                val empl = repository.login(username, password)
//                _login.value = empl
            } catch (e: Exception) {
                Log.d("Repo","login exception ${e.message}")
            }
        }
    }

}