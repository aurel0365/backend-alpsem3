<?php

namespace App\Models;

// use Illuminate\Contracts\Auth\MustVerifyEmail;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Foundation\Auth\User as Authenticatable;
use Illuminate\Notifications\Notifiable;
use Laravel\Sanctum\HasApiTokens;

    /**
     * @OA\Schema(
     *     schema="User",
     *     type="object",
     *     @OA\Property(property="id", type="integer", example=1),
     *     @OA\Property(property="nama", type="string", example="John Doe"),
     *     @OA\Property(property="email", type="string", example="john.doe@example.com"),
     *     @OA\Property(property="no_hp", type="string", example="081234567890"),
     *     @OA\Property(property="alamat", type="string", example="Jl. Merdeka No. 123"),
     *     @OA\Property(property="gender", type="string", enum={"laki-laki", "perempuan"}, example="laki-laki"),
     *     @OA\Property(property="tgl_lahir", type="string", format="date", example="1990-01-01"),
     *     @OA\Property(property="role", type="string", enum={"customer", "driver"}, example="customer"),
     *     @OA\Property(property="foto_profil", type="string", format="binary", description="Optional profile photo")
     * )
     */
class User extends Authenticatable
{
    use HasApiTokens, HasFactory, Notifiable;

    /**
     * The attributes that are mass assignable.
     *
     * @var array<int, string>
     */
    protected $fillable = [
        'nama',
        'email',
        'password',
        'no_hp',
        'alamat',
        'gender',
        'tgl_lahir',
        'foto_profil'
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

    public function notifications()
    {
        return $this->hasMany(Notification::class, 'id_user');
    }

    public function transactions()
    {
        return $this->hasMany(Transaction::class, 'id_user');
    }

    public function driver()
    {
        return $this->hasOne(Driver::class, 'id_driver');
    }

    public function kursis()
    {
        return $this->hasMany(Kursi::class, 'id_pemesan');
    }

    public function tickets()
    {
        return $this->hasMany(Ticket::class);
    }
}
