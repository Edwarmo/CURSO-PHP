<?php

namespace App\Http\Controllers;

use App\Http\Requests\StoreVenueRequest;
use App\Http\Requests\UpdateVenueRequest;
use App\Models\Venue;
use Illuminate\Support\Facades\Storage;

class VenueController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index()
    {
        $venues = Venue::all();
        return response()->json($venues);
    }

    /**
     * Store a newly created resource in storage.
     */
    public function store(StoreVenueRequest $request)
    {
        $validated = $request->validated();

        if ($request->hasFile('venue_image')) {
            $imagePath = $request->file('venue_image')->store('venue-images', 'public');
            $validated['venue_image'] = $imagePath;
        }

        $venue = Venue::create($validated);
        return response()->json($venue, 201);
    }

    /**
     * Display the specified resource.
     */
    public function show(Venue $venue)
    {
        return response()->json($venue);
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(UpdateVenueRequest $request, Venue $venue)
    {
        $validated = $request->validated();

        if ($request->hasFile('venue_image')) {
            // Delete old image if exists
            if ($venue->venue_image) {
                Storage::disk('public')->delete($venue->venue_image);
            }
            $imagePath = $request->file('venue_image')->store('venue-images', 'public');
            $validated['venue_image'] = $imagePath;
        }

        $venue->update($validated);
        return response()->json($venue);
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy(Venue $venue)
    {
        $venue->delete();
        return response()->json(['message' => 'Venue deleted successfully'], 200);
    }
}
