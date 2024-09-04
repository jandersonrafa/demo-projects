package com.example.medidorinbound.view

import android.content.Context
import android.widget.Toast
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.text.KeyboardOptions
import androidx.compose.material3.Button
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Text
import androidx.compose.material3.TextField
import androidx.compose.runtime.Composable
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.saveable.rememberSaveable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.text.input.KeyboardType
import androidx.compose.ui.text.input.PasswordVisualTransformation
import androidx.compose.ui.text.input.TextFieldValue
import androidx.compose.ui.unit.dp
import androidx.lifecycle.viewmodel.compose.viewModel
import androidx.navigation.NavHostController
import com.example.medidorinbound.navigation.Routes
import com.example.medidorinbound.viewmodel.LoginViewModel


@Composable
fun LoginComposable(viewModel: LoginViewModel = viewModel(), navController: NavHostController) {
    val usernameState = rememberSaveable { mutableStateOf("")}
    val passwordState = rememberSaveable { mutableStateOf("")}
    val errorMessageState = rememberSaveable { mutableStateOf("")}


    Column(
        modifier = Modifier
            .fillMaxSize()
            .padding(16.dp),
        verticalArrangement = Arrangement.Center,
        horizontalAlignment = Alignment.CenterHorizontally
    ) {
        Text("Login", style = MaterialTheme.typography.headlineMedium)

        Spacer(modifier = Modifier.height(16.dp))

        // Campo de entrada para o nome de usuário
        TextField(
            value = usernameState.value,
            onValueChange = {usernameState.value = it},
            label = { Text("Username") },
            modifier = Modifier.fillMaxWidth()
        )

        Spacer(modifier = Modifier.height(8.dp))

        // Campo de entrada para a senha
        TextField(
            value = passwordState.value,
            onValueChange = {passwordState.value = it},
            label = { Text("Password") },
            modifier = Modifier.fillMaxWidth(),
            visualTransformation = PasswordVisualTransformation(),
            keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Password)
        )

        Spacer(modifier = Modifier.height(16.dp))

        // Botão de login
        Button(
            onClick = {
                if (usernameState.value.isBlank() || passwordState.value.isBlank()) {
                    errorMessageState.value = "Please enter both username and password"
                } else {
                    errorMessageState.value = ""
                    viewModel.login(usernameState.value, passwordState.value)
                    navController.navigate(Routes.List.route)
                }
            },
            modifier = Modifier.fillMaxWidth()
        ) {
            Text("Login")
        }

        // Exibe a mensagem de erro se houver
        if (errorMessageState.value.isNotBlank()) {
            Spacer(modifier = Modifier.height(8.dp))
            Text(
                text = errorMessageState.value,
                color = MaterialTheme.colorScheme.error
            )
        }
    }
}
