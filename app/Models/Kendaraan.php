<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

    /**
     * @OA\Schema(
     *     schema="Kendaraan",
     *     type="object",
     *     required={"id", "trayek_id", "no_plat", "tahun_kendaraan", "is_tersedia", "koordinat"},
     *     @OA\Property(property="id", type="integer", description="ID of the vehicle"),
     *     @OA\Property(property="trayek_id", type="integer", description="ID of the route (trayek) the vehicle is assigned to"),
     *     @OA\Property(property="no_plat", type="string", description="License plate number of the vehicle"),
     *     @OA\Property(property="tahun_kendaraan", type="integer", description="Year of the vehicle"),
     *     @OA\Property(property="is_tersedia", type="boolean", description="Availability of the vehicle (true if available, false if not)"),
     *     @OA\Property(property="koordinat", type="string", description="Coordinates of the vehicle (e.g., latitude, longitude)"),
     *     @OA\Property(property="trayek", ref="#/components/schemas/Trayek"),
     *     @OA\Property(property="schedules", ref="#/components/schemas/Schedule"),
     *     @OA\Property(property="drivers", ref="#/components/schemas/Driver"),
     * )
     */

class Kendaraan extends Model
{
    use HasFactory;

    protected $fillable = [
        'trayek_id',
        'no_plat',
        'tahun_kendaraan',
        'is_tersedia',
        'koordinat',
    ];

    public function schedules()
    {
        return $this->hasMany(Schedule::class, 'id_kendaraan');
    }

    public function drivers()
    {
        return $this->hasMany(Driver::class, 'id_kendaraan');
    }

    public function kursis()
    {
        return $this->hasMany(Kursi::class, 'id_kendaraan');
    }

    public function trayek()
    {
        return $this->belongsTo(Trayek::class, 'trayek_id');
    }
}
