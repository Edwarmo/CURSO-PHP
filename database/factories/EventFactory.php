<?php

namespace Database\Factories;

use Illuminate\Database\Eloquent\Factories\Factory;

/**
 * @extends \Illuminate\Database\Eloquent\Factories\Factory<\App\Models\Event>
 */
class EventFactory extends Factory
{
    /**
     * Define the model's default state.
     *
     * @return array<string, mixed>
     */
    public function definition(): array
    {
        return [
            "event_name" => fake()->unique()->words(5, true),
            "event_date" => fake()->dateTime,
            "event_max_capacity" => fake()->numberBetween(5000, 25000),
            "event_speaker_name" => fake()->name . ' ' . fake()->lastName,
            "event_location_name" => fake()->address(),
            "event_meetup_url" => fake()->url,
            "event_is_virtual" =>fake()->boolean(30),
            'event_status' => fake()->boolean(30),
        ];
    }
}
