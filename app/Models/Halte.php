<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;


    /**
     * @OA\Schema(
     *     schema="Halte",
     *     type="object",
     *     required={"id", "nama_halte", "latitude", "longitude"},
     *     @OA\Property(property="id", type="integer", description="ID of the halte"),
     *     @OA\Property(property="nama_halte", type="string", description="Name of the halte"),
     *     @OA\Property(property="latitude", type="number", format="float", description="Latitude of the halte"),
     *     @OA\Property(property="longitude", type="number", format="float", description="Longitude of the halte"),
     * )
     */


class Halte extends Model
{
    use HasFactory;

    // Specify the table name if it doesn't follow Laravel's naming convention
    protected $table = 'haltes';

    protected $fillable = [
        'nama_halte',
        'latitude',
        'longitude',
    ];

    public function trayekHaltes()
    {
        return $this->hasMany(TrayekHalte::class, 'id_halte');
    }

    
}
