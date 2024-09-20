package com.example.medidorinbound.view.base

import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.layout.width
import androidx.compose.foundation.layout.wrapContentSize
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.ArrowBack
import androidx.compose.material.icons.filled.Home
import androidx.compose.material3.Divider
import androidx.compose.material3.Icon
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.tooling.preview.Preview
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp

@Composable
fun Header() {

    Row(
        verticalAlignment = Alignment.CenterVertically,
        horizontalArrangement = Arrangement.Center,
        modifier = Modifier
            .fillMaxWidth()
            .padding(16.dp)
    ) {
        Icon(
            imageVector = Icons.Filled.Home,
            contentDescription = "Home Icon",
            tint = MaterialTheme.colorScheme.primary,
            modifier = Modifier.size(24.dp) // Ajuste o tamanho conforme necessário
        )
        Spacer(modifier = Modifier.width(8.dp))
        Text(
            text = "Medidor Inbound",
            style = MaterialTheme.typography.headlineMedium.copy(fontSize = 24.sp),
            color = MaterialTheme.colorScheme.onBackground
        )
    }
    Divider(
        thickness = 1.dp, // Espessura da linha
    )
    SubHeader()
    Divider(
        thickness = 1.dp, // Espessura da linha
    )
}

@Preview
@Composable
fun SubHeader() {

    Row(
        verticalAlignment = Alignment.CenterVertically,

        modifier = Modifier
            .fillMaxWidth()
            .padding(16.dp)
    ) {
        // Ícone no início

        Icon(
            imageVector = Icons.Filled.ArrowBack,
            contentDescription = "Home Icon",
            tint = MaterialTheme.colorScheme.primary,
            modifier = Modifier.size(24.dp) // Ajuste o tamanho conforme necessário
        )

        // Espaço flexível para empurrar o conteúdo restante para o centro
        Spacer(modifier = Modifier.weight(1f))


        // Box para centralizar o texto e o segundo ícone
        Box(
            modifier = Modifier
                .fillMaxWidth()
                .wrapContentSize(Alignment.Center)
        ) {
            Row(
                verticalAlignment = Alignment.CenterVertically,
                horizontalArrangement = Arrangement.Center
            ) {
                Icon(
                    imageVector = Icons.Filled.Home,
                    contentDescription = "Search Icon",
                    tint = MaterialTheme.colorScheme.primary,
                    modifier = Modifier.size(24.dp) // Ajuste o tamanho conforme necessário
                )
                Text(
                    text = "Bipar e Editar Medidas",
                    style = MaterialTheme.typography.headlineMedium.copy(fontSize = 24.sp),
                    color = MaterialTheme.colorScheme.onBackground
                )
                Spacer(modifier = Modifier.width(8.dp)) // Espaço entre o texto e o ícone
            }
        }
    }
}