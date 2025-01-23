<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Notifications\Notifiable;
use Laravel\Sanctum\HasApiTokens;
use Illuminate\Database\Eloquent\Model;

    /**
     * @OA\Schema(
     *     schema="Driver",
     *     type="object",
     *     required={"id_driver", "nama", "email", "password", "alamat", "tgl_lahir", "no_hp", "gender", "id_kendaraan"},
     *     @OA\Property(property="id_driver", type="integer", description="ID of the driver"),
     *     @OA\Property(property="nama", type="string", description="Name of the driver"),
     *     @OA\Property(property="email", type="string", description="Email of the driver"),
     *     @OA\Property(property="password", type="string", description="Password of the driver"),
     *     @OA\Property(property="alamat", type="string", description="Address of the driver"),
     *     @OA\Property(property="tgl_lahir", type="string", format="date", description="Date of birth of the driver"),
     *     @OA\Property(property="no_hp", type="string", description="Phone number of the driver"),
     *     @OA\Property(property="gender", type="string", description="Gender of the driver"),
     *     @OA\Property(property="id_kendaraan", type="integer", description="ID of the vehicle assigned to the driver"),
     *     @OA\Property(property="kendaraan", ref="#/components/schemas/Kendaraan"),
     * )
     */

class Driver extends Model
{
    use HasApiTokens, HasFactory, Notifiable;

    
    protected $primaryKey = 'id_driver';

    protected $fillable = [
            'id_driver',
            'nama',
            'email',
            'password',
            'alamat',
            'tgl_lahir',
            'no_hp',
            'gender',
            'id_kendaraan'
    ];

    /**
     * The attributes that should be hidden for serialization.
     *
     * @var array<int, string>
     */
    protected $hidden = [
        'password',
        'remember_token',
    ];

    /**
     * The attributes that should be cast.
     *
     * @var array<string, string>
     */
    protected $casts = [
        'email_verified_at' => 'datetime',
        'password' => 'hashed',
    ];


   
    public function kendaraan()
    {
        return $this->belongsTo(Kendaraan::class, 'id_kendaraan');
    }

    public function notifications()
    {
        return $this->hasMany(Notification::class, 'id_driver');
    }

    public function transactions()
    {
        return $this->hasMany(Transaction::class, 'id_driver');
    }
}
