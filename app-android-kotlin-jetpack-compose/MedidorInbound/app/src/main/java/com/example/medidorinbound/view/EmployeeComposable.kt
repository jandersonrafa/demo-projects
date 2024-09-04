package com.example.medidorinbound.view

import android.content.Context
import android.widget.Toast
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.wrapContentSize
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material3.Divider
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.runtime.getValue
import androidx.compose.runtime.livedata.observeAsState
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.unit.dp
import androidx.lifecycle.viewmodel.compose.viewModel
import androidx.navigation.NavHostController
import androidx.navigation.compose.rememberNavController
import com.example.medidorinbound.model.Data
import com.example.medidorinbound.navigation.Routes
import com.example.medidorinbound.viewmodel.EmployeeViewModel


@Composable
fun EmployeeComposable(viewModel: EmployeeViewModel = viewModel(), navController: NavHostController) {
    val employees by viewModel.employees.observeAsState()
    val context = LocalContext.current


    LaunchedEffect(Unit) {
        viewModel.fetchEmployees()
        println("teste")
    }

    Column(
        modifier = Modifier
            .wrapContentSize()
            .clip(RoundedCornerShape((4.dp)))
            .padding(16.dp)
    ) {
        if (employees?.data.isNullOrEmpty()) {
            Text(text = "Loading...")
        } else {
            var emps = employees?.data as List<Data>
            emps.let {
                LazyColumn {
                    items(it) {
                        Column(modifier = Modifier.clickable {
                            onClick(id = it.id, context = context, navController2= navController)
                        }) {
                            Text(text = it.employee_name)
                            Text(text = it.employee_age.toString())
                            Text(text = it.employee_salary.toString())
                            Divider()
                        }
                    }
                }
            }

        }

    }
}

fun onClick(id: Int, context: Context, navController2: NavHostController) {
    Toast.makeText(context, "Button clicked tres! " + id, Toast.LENGTH_SHORT).show()
    navController2.navigate(Routes.Detail.createRoute(id))
}
