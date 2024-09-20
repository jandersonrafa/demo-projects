package com.example.medidorinbound.view

import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.wrapContentSize
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material3.Button
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.runtime.getValue
import androidx.compose.runtime.livedata.observeAsState
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.unit.dp
import androidx.lifecycle.viewmodel.compose.viewModel
import androidx.navigation.NavHostController
import com.example.medidorinbound.model.Data
import com.example.medidorinbound.navigation.Routes
import com.example.medidorinbound.viewmodel.EmployeeDetailViewModel


@Composable
fun EmployeDetailComposable(
    viewModel: EmployeeDetailViewModel = viewModel(),
    navController: NavHostController,
    id: Int?
) {
    val employees by viewModel.employeeDetail.observeAsState()

    LaunchedEffect(Unit) {
        viewModel.fetchEmployees(id)
        println("teste")
    }

    Column(
        modifier = Modifier
            .wrapContentSize()
            .clip(RoundedCornerShape((4.dp)))
            .padding(16.dp)
    ) {
        if (employees?.data?.id == null) {
            Text(text = "Loading...")
        } else {
            var it = employees?.data as Data
            Text(text = "id:" + it.id)
            Text(text = "Name:" + it.employee_name)
            Text(text = "Age:" + it.employee_age.toString())
            Text(text = "Salary:" + it.employee_salary.toString())
        }
        Button(onClick = { onClickReturn(navController) }) {
            Text(text = "Voltar")
        }

    }

}


fun onClickReturn(navController: NavHostController) {
    navController.navigate(Routes.List.route)
}