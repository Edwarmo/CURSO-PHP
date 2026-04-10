<?php

use App\Http\Controllers\EventController;
use App\Http\Controllers\LoginController;
use App\Http\Controllers\VenueController;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;

Route::get('/user', function (Request $request) {
    return $request->user();
})->middleware('auth:sanctum');

Route::apiResource('events', EventController::class)->names('apievents')->middleware('auth:sanctum');
//Route::apiResource('venues', VenueController::class)->middleware('auth:sanctum');

Route::get('index-active-events', [EventController::class, 'indexActiveEvents'])->middleware('auth:sanctum');

Route::post('/login', [LoginController::class, 'login']);
