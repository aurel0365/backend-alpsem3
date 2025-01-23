<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;


    /**
     * @OA\Schema(
     *     schema="Ticket",
     *     type="object",
     *     required={"id", "id_user", "tgl_pembelian", "expired_at", "status"},
     *     @OA\Property(property="id", type="integer", description="ID of the ticket"),
     *     @OA\Property(property="id_user", type="integer", description="ID of the user who purchased the ticket"),
     *     @OA\Property(property="tgl_pembelian", type="string", format="date-time", description="Ticket purchase date"),
     *     @OA\Property(property="expired_at", type="string", format="date-time", description="Ticket expiration date"),
     *     @OA\Property(property="status", type="string", description="Ticket status (active/expired)"),
     *     @OA\Property(property="user", ref="#/components/schemas/User")
     * )
     */

class Ticket extends Model
{
    use HasFactory;
     // Tabel yang digunakan
     protected $table = 'tickets';

     // Kolom yang dapat diisi (mass assignable)
     protected $fillable = [
         'id_user',
         'tgl_pembelian',
         'expired_at',
         'status',
     ];
 
     // Kolom dengan tipe data tanggal
     protected $dates = [
         'tgl_pembelian',
         'expired_at',
         'created_at',
         'updated_at',
     ];
 
     // Relasi ke tabel User
     public function user()
     {
         return $this->belongsTo(User::class);
     }
 
     // Scope untuk tiket aktif
     public function scopeActive($query)
     {
         return $query->where('status', 'active');
     }
 
     // Scope untuk tiket kedaluwarsa
     public function scopeExpired($query)
     {
         return $query->where('status', 'expired');
     }
}
