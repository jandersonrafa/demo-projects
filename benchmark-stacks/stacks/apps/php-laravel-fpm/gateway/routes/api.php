<?php

use App\Http\Controllers\GatewayController;
use Illuminate\Support\Facades\Route;


Route::post('/bonus', [GatewayController::class, 'createBonus']);
Route::get('/bonus/recents', [GatewayController::class, 'recents']);
Route::get('/bonus/{id}', [GatewayController::class, 'getBonus']);
