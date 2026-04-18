<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Venue extends Model
{
    use HasFactory;
    protected $primaryKey = 'id_venue';

    protected $fillable = [
        'venue_name',
        'venue_address',
        'venue_max_capacity',
        'venue_image'
    ];

    public function events()
    {
        return $this->hasMany(Event::class, 'fk_venue_event', 'id_venue');
    }
}
