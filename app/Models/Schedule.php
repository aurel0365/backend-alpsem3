<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

    /**
     * @OA\Schema(
     *     schema="Schedule",
     *     type="object",
     *     required={"id", "id_kendaraan", "waktu_berangkat", "waktu_tiba"},
     *     @OA\Property(property="id", type="integer", description="ID of the schedule"),
     *     @OA\Property(property="id_kendaraan", type="integer", description="ID of the kendaraan (vehicle) associated with the schedule"),
     *     @OA\Property(property="waktu_berangkat", type="string", format="date-time", description="Departure time"),
     *     @OA\Property(property="waktu_tiba", type="string", format="date-time", description="Arrival time"),
     *     @OA\Property(property="kendaraan", ref="#/components/schemas/Kendaraan"),
     *     @OA\Property(property="trayeks", type="array", @OA\Items(ref="#/components/schemas/Trayek"))
     * )
     */

class Schedule extends Model
{
    use HasFactory;

    protected $fillable = [
        'id_kendaraan',
        'waktu_berangkat',
        'waktu_tiba',
    ];

    public function kendaraan()
    {
        return $this->belongsTo(Kendaraan::class, 'id_kendaraan');
    }

    public function trayeks()
    {
        return $this->hasMany(Trayek::class, 'id_schedule');
    }
}
