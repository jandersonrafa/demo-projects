package com.example.medidorinbound.navigation

sealed class Routes(val route: String) {
    object List : Routes("List")
    object Login : Routes("Login")
    object Detail : Routes("Detail/{id}") {
        fun createRoute(id: Int) = "detail/$id"
    }
}