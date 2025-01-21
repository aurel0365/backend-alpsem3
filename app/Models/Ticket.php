<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

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
