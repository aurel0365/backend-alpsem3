<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

/**
 * @OA\Schema(
 *     schema="Trayek",
 *     type="object",
 *     required={"id", "kode_trayek", "urutan_halte", "id_schedule"},
 *     @OA\Property(property="id", type="integer", description="ID of the trayek"),
 *     @OA\Property(property="kode_trayek", type="string", description="Trayek code"),
 *     @OA\Property(property="urutan_halte", type="integer", description="Order of halts"),
 *     @OA\Property(property="id_schedule", type="integer", description="Associated schedule ID"),
 *     @OA\Property(property="schedule", ref="#/components/schemas/Schedule"),
 *     @OA\Property(property="haltes", type="array", @OA\Items(ref="#/components/schemas/Halte")),
 *     @OA\Property(property="kendaraan", type="array", @OA\Items(ref="#/components/schemas/Kendaraan")),
 *     @OA\Property(property="transaksi", type="array", @OA\Items(ref="#/components/schemas/Transaction"))
 * )
 */

class Trayek extends Model
{
    use HasFactory;

    protected $fillable = [
        'kode_trayek',
        'urutan_halte',
        'id_schedule',
    ];

    public function schedule()
    {
        return $this->belongsTo(Schedule::class, 'id_schedule');
    }

    public function trayekHaltes()
    {
        return $this->hasMany(TrayekHalte::class, 'id_trayek');
    }
    
    public function haltes()
    {
        return $this->hasMany(Halte::class, 'kode_trayek', 'kode_trayek');
    }

    public function kendaraan()
    {
        return $this->hasMany(Kendaraan::class, 'trayek_id');
    }

    public function transaksi()
    {
        return $this->hasMany(Transaction::class, 'id_trayek');
    }

}
