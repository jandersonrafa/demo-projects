package com.example.medidorinbound.navigation

import androidx.compose.runtime.Composable
import androidx.navigation.NavType
import androidx.navigation.compose.NavHost
import androidx.navigation.compose.composable
import androidx.navigation.compose.rememberNavController
import androidx.navigation.navArgument
import com.example.medidorinbound.view.EmployeDetailComposable
import com.example.medidorinbound.view.EmployeeComposable
import com.example.medidorinbound.view.LoginComposable
import com.example.medidorinbound.viewmodel.EmployeeDetailViewModel
import com.example.medidorinbound.viewmodel.EmployeeViewModel


@Composable
fun Navigation() {
//fun Navigation(viewModel: EmployeeViewModel, viewDetailModel: EmployeeDetailViewModel) {

    val navController = rememberNavController()

    NavHost(navController = navController, startDestination = Routes.Login.route) {
        composable(Routes.List.route) {
            EmployeeComposable(navController = navController)
        }
        composable(
            route = Routes.Detail.route,
            arguments = listOf(navArgument("id") { type = NavType.IntType })
        ) { backStackEntry ->
            val id = backStackEntry.arguments?.getInt("id")
            EmployeDetailComposable(navController = navController, id = id)
        }
        composable(Routes.Login.route) {
            LoginComposable(navController = navController)
        }
    }
}