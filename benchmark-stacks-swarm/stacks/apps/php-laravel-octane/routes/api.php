<?php

use App\Http\Controllers\BonusController;
use Illuminate\Support\Facades\Route;


Route::post('/bonus', [BonusController::class, 'store']);
Route::get('/bonus/recents', [BonusController::class, 'recents']);
Route::get('/bonus/{id}', [BonusController::class, 'show'])
    ->whereNumber('id');
