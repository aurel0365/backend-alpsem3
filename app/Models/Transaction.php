<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

        /**
     * @OA\Schema(
     *     schema="Transaction",
     *     type="object",
     *     required={"id", "id_user", "id_driver", "id_trayek", "jenis_tiket", "tgl_transaksi", "jumlah_tiket", "payment_method", "payment_amount", "payment_status"},
     *     @OA\Property(property="id", type="integer", description="ID of the transaction"),
     *     @OA\Property(property="id_user", type="integer", description="ID of the user who made the transaction"),
     *     @OA\Property(property="id_driver", type="integer", description="ID of the driver involved in the transaction"),
     *     @OA\Property(property="id_trayek", type="integer", description="ID of the route (trayek) associated with the transaction"),
     *     @OA\Property(property="jenis_tiket", type="string", description="Type of ticket (e.g., regular, VIP)"),
     *     @OA\Property(property="tgl_transaksi", type="string", format="date-time", description="Transaction date and time"),
     *     @OA\Property(property="jumlah_tiket", type="integer", description="Number of tickets purchased"),
     *     @OA\Property(property="payment_method", type="string", description="Payment method used (e.g., cash, credit card)"),
     *     @OA\Property(property="payment_amount", type="number", format="float", description="Amount paid for the transaction"),
     *     @OA\Property(property="payment_status", type="string", description="Status of the payment (e.g., pending, completed)"),
     *     @OA\Property(property="user", ref="#/components/schemas/User"),
     *     @OA\Property(property="driver", ref="#/components/schemas/Driver"),
     *     @OA\Property(property="trayek", ref="#/components/schemas/Trayek")
     * )
     */

class Transaction extends Model
{
    use HasFactory;

    protected $fillable = [
        'id_user',
        'id_driver',
        'id_trayek',
        'jenis_tiket',
        'tgl_transaksi',
        'jumlah_tiket',
        'payment_method',
        'payment_amount',
        'payment_status',
    ];

    public $timestamps = false;

    public function user()
    {
        return $this->belongsTo(User::class, 'id_user');
    }

    public function driver()
    {
        return $this->belongsTo(Driver::class, 'id_driver');
    }

    public function trayek()
    {
        return $this->belongsTo(Trayek::class, 'id_trayek');
    }

}
