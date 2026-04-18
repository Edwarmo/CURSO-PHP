<?php

use App\Http\Controllers\Web\EventController;
use App\Http\Controllers\Web\VenueController;
use Illuminate\Foundation\Application;
use Illuminate\Support\Facades\Route;
use Inertia\Inertia;

Route::get('/', function () {
    return Inertia::render('Welcome', [
        'canLogin' => Route::has('login'),
        'canRegister' => Route::has('register'),
        'laravelVersion' => Application::VERSION,
        'phpVersion' => PHP_VERSION,
    ]);
});

Route::middleware([
    'auth:sanctum',
    config('jetstream.auth_session'),
    'verified',
])->group(function () {
    Route::get('/dashboard', function () {
        $events = \App\Models\Event::with('venue')
            ->where('event_status', true)
            ->orderBy('event_date', 'asc')
            ->get();
        return Inertia::render('Dashboard', ['events' => $events]);
    })->name('dashboard');

    Route::resource('venues', VenueController::class);
    Route::resource('events', EventController::class);
});
