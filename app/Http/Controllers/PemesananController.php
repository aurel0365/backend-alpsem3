<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\Trayek;
use App\Models\Halte;
use App\Models\Schedule;
use App\Models\Transaction;
use App\Models\User;
use App\Models\Driver;
use Illuminate\Support\Facades\Validator;
use Carbon\Carbon;


class PemesananController extends Controller
{
      /**
     * @OA\Get(
     *     path="/api/get-trayeks",
     *     summary="Get all trayek",
     *     tags={"Pemesanan"},
     *     @OA\Response(
     *         response=200,
     *         description="List of trayeks",
     *         @OA\JsonContent(
     *             type="array",
     *             @OA\Items(ref="#/components/schemas/Trayek")
     *         )
     *     )
     * )
     */

    // Menampilkan list trayek untuk semua orang (tidak memerlukan autentikasi)
    public function getTrayeks()
    {
        $trayeks = Trayek::all();
        return response()->json($trayeks);
    }

     /**
     * @OA\Get(
     *     path="/api/get-haltes",
     *     summary="Get all haltes",
     *     tags={"Pemesanan"},
     *     @OA\Response(
     *         response=200,
     *         description="List of haltes",
     *         @OA\JsonContent(
     *             type="array",
     *             @OA\Items(ref="#/components/schemas/Halte")
     *         )
     *     )
     * )
     */

    // Menampilkan list halte untuk semua orang (tidak memerlukan autentikasi)
    public function getHaltes()
    {
        $haltes = Halte::all();
        return response()->json($haltes);
    }

     /**
     * @OA\Get(
     *     path="/api/get-schedules",
     *     summary="Get all schedules",
     *     tags={"Pemesanan"},
     *     @OA\Response(
     *         response=200,
     *         description="List of schedules",
     *         @OA\JsonContent(
     *             type="array",
     *             @OA\Items(ref="#/components/schemas/Schedule")
     *         )
     *     )
     * )
     */

    // Menampilkan list jadwal untuk semua orang (tidak memerlukan autentikasi)
    public function getSchedules()
    {
        $schedules = Schedule::all();
        return response()->json($schedules);
    }


    /**
     * @OA\Get(
     *     path="/api/get-trayek-with-halte/{trayekId}",
     *     summary="Get trayek with halte details",
     *     tags={"Pemesanan"},
     *     @OA\Parameter(
     *         name="trayekId",
     *         in="path",
     *         description="Trayek ID",
     *         required=true,
     *         @OA\Schema(type="integer")
     *     ),
     *     @OA\Response(
     *         response=200,
     *         description="Trayek with haltes",
     *         @OA\JsonContent(
     *             type="object",
     *             @OA\Property(property="kode_trayek", type="string"),
     *             @OA\Property(property="urutan_halte", type="array", @OA\Items(ref="#/components/schemas/Halte"))
     *         )
     *     ),
     *     @OA\Response(
     *         response=404,
     *         description="Trayek not found",
     *         @OA\JsonContent(
     *             @OA\Property(property="error", type="string", example="Trayek tidak ditemukan")
     *         )
     *     )
     * )
     */

    public function getTrayekWithHalte($trayekId)
    {
        // Ambil trayek berdasarkan ID dengan Eloquent
        $trayek = Trayek::find($trayekId);
    
        if ($trayek) {
            // Decode halte_order JSON
            $halteIds = json_decode($trayek->urutan_halte);
    
            // Ambil detail halte berdasarkan ID menggunakan Eloquent
            $haltes = Halte::whereIn('id', $halteIds)->get();
    
            return response()->json([
                'kode_trayek' => $trayek->kode_trayek,
                'urutan_halte' => $haltes
            ]);
        }
    
        return response()->json(['error' => 'Trayek tidak ditemukan'], 404);
    }

    /**
     * @OA\Post(
     *     path="/api/beli-tiket",
     *     summary="Buy a ticket",
     *     tags={"Pemesanan"},
     *     @OA\RequestBody(
     *         required=true,
     *         @OA\JsonContent(
     *             type="object",
     *             @OA\Property(property="trayek_id", type="integer"),
     *             @OA\Property(property="jumlah_tiket", type="integer"),
     *             @OA\Property(property="payment_method", type="string", enum={"cash", "cashless"})
     *         )
     *     ),
     *     @OA\Response(
     *         response=200,
     *         description="Ticket purchased successfully",
     *         @OA\JsonContent(
     *             @OA\Property(property="message", type="string", example="Tiket berhasil dibeli"),
     *             @OA\Property(property="ticket", ref="#/components/schemas/Ticket")
     *         )
     *     ),
     *     @OA\Response(
     *         response=403,
     *         description="Invalid ticket or expired",
     *         @OA\JsonContent(
     *             @OA\Property(property="error", type="string", example="Tiket tidak valid atau sudah kadaluarsa")
     *         )
     *     )
     * )
     */

    public function beliTiket(Request $request)
    {
        $user = $request->user();

        // Buat tiket baru
        $ticket = Ticket::create([
            'id_user' => $user->id,
            'tgl_pembelian' => now()->format('Y-m-d'),
            'expired_at' => now()->endOfDay(), // Jam 23:59 hari itu
            'status' => 'active',
        ]);

        return response()->json(['message' => 'Tiket berhasil dibeli', 'ticket' => $ticket]);
    }

     /**
     * @OA\Post(
     *     path="/api/cek-status-tiket",
     *     summary="Check ticket status",
     *     tags={"Pemesanan"},
     *     @OA\Response(
     *         response=200,
     *         description="Ticket is valid and can be used",
     *         @OA\JsonContent(
     *             @OA\Property(property="message", type="string", example="Tiket valid dan dapat digunakan")
     *         )
     *     ),
     *     @OA\Response(
     *         response=403,
     *         description="Ticket is invalid or expired",
     *         @OA\JsonContent(
     *             @OA\Property(property="error", type="string", example="Tiket tidak valid atau sudah kadaluarsa")
     *         )
     *     )
     * )
     */

    public function cekTiket(Request $request)
    {   
        $user = $request->user();

        $ticket = Ticket::where('user_id', $user->id)
            ->where('status', 'active')
            ->where('expired_at', '>=', now())
            ->first();

        if (!$ticket) {
            return response()->json(['error' => 'Tiket tidak valid atau sudah kadaluarsa.'], 403);
        }

        return response()->json(['message' => 'Tiket valid dan dapat digunakan.']);
    }

        /**
     * @OA\Post(
     *     path="/api/pesan-pete",
     *     summary="Pesan angkot (angkutan kota)",
     *     tags={"Pemesanan"},
     *     @OA\RequestBody(
     *         required=true,
     *         @OA\JsonContent(
     *             type="object",
     *             @OA\Property(property="trayek_id", type="integer", description="ID trayek yang ingin dipesan"),
     *             @OA\Property(property="jumlah_tiket", type="integer", description="Jumlah tiket yang ingin dipesan"),
     *             @OA\Property(property="payment_method", type="string", enum={"cash", "cashless"}, description="Metode pembayaran")
     *         )
     *     ),
     *     @OA\Response(
     *         response=200,
     *         description="Tiket berhasil dipesan",
     *         @OA\JsonContent(
     *             @OA\Property(property="message", type="string", example="Tiket berhasil dipesan"),
     *             @OA\Property(property="transaksi", ref="#/components/schemas/Transaction")
     *         )
     *     ),
     *     @OA\Response(
     *         response=403,
     *         description="Hanya customer yang dapat memesan tiket atau tiket belum dibeli",
     *         @OA\JsonContent(
     *             @OA\Property(property="message", type="string", example="Hanya customer yang dapat memesan tiket")
     *         )
     *     ),
     *     @OA\Response(
     *         response=404,
     *         description="Trayek atau kendaraan tidak ditemukan",
     *         @OA\JsonContent(
     *             @OA\Property(property="message", type="string", example="Tidak ada kendaraan yang tersedia untuk trayek ini")
     *         )
     *     ),
     *     @OA\Response(
     *         response=400,
     *         description="Input tidak valid atau ada kesalahan dalam pemesanan",
     *         @OA\JsonContent(
     *             @OA\Property(property="message", type="string", example="Tiket belum dibeli")
     *         )
     *     )
     * )
     */
   
    public function pesanPete(Request $request)
    {
        // Pastikan user terautentikasi dan memiliki role customer
        if (auth()->check() && auth()->user()->role != 'customer') {
            return response()->json(['message' => 'Hanya customer yang dapat memesan tiket'], 403);
        }

        // Validasi input
        $request->validate([
            'trayek_id' => 'required|exists:trayeks,id',
            'jumlah_tiket' => 'required|integer|min:1',
            'payment_method' => 'required|in:cash,cashless',
        ], [
            'payment_method.required' => 'Metode pembayaran harus diisi.',
            'payment_method.in' => 'Metode pembayaran hanya bisa cash atau cashless.',
        ]);
        
        $user = auth()->user(); // Ambil user yang terautentikasi
                // Cek apakah user sudah memiliki tiket
                $existingTicket = Ticket::where('id_user', $user->id)
                ->where('status', 'active')
                ->first();
    
            if (!$existingTicket) {
                return response()->json(['message' => 'Tiket belum dibeli'], 403);
            }

        $trayekId = $request->input('trayek_id');
        $jumlahTiket = $request->input('jumlah_tiket');
        $paymentMethod = $request->input('payment_method');
        $hargaPerTiket = 7000; // Harga tiket per tiket

        // Cari trayek berdasarkan ID
        $trayek = Trayek::find($trayekId);
        if (!$trayek) {
            return response()->json(['message' => 'Trayek tidak ditemukan'], 404);
        }

        // Cari kendaraan yang tersedia di trayek yang dipilih
        $kendaraan = Kendaraan::where('is_tersedia', 1)
            ->where('trayek_id', $trayekId)
            ->get();

        if ($kendaraan->isEmpty()) {
            return response()->json(['message' => 'Tidak ada kendaraan yang tersedia untuk trayek ini'], 404);
        }

        // Cari kendaraan yang memiliki kursi tersedia sesuai jumlah tiket yang dipesan
        $angkotTersedia = null;
        foreach ($kendaraan as $kendaraanItem) {
            // Decode kursi_tersedia untuk memeriksa apakah cukup untuk jumlah tiket yang dipesan
            $kursiTersedia = json_decode($kendaraanItem->kursi_tersedia, true);

            // Periksa apakah ada kursi yang tersedia sesuai dengan jumlah tiket yang dipesan
            $kursiCukup = 0;
            foreach ($kursiTersedia as $noKursi => $status) {
                if ($status === 'tersedia') {
                    $kursiCukup++;
                }
            }

            if ($kursiCukup >= $jumlahTiket) {
                $angkotTersedia = $kendaraanItem;
                break;
            }
        }

        if (!$angkotTersedia) {
            return response()->json(['message' => 'Tidak ada kendaraan dengan kursi cukup'], 404);
        }

        // Simpan transaksi ke tabel transaksi
        $transaksi = new Transaction();
        $transaksi->id_user = $user->id;
        $transaksi->id_driver = $angkotTersedia->driver_id;
        $transaksi->id_trayek = $trayek->id;
        $transaksi->tgl_transaksi = Carbon::now();
        $transaksi->jumlah_tiket = $jumlahTiket;
        $transaksi->payment_method = $paymentMethod; 
        $transaksi->payment_amount = $jumlahTiket * 10000; // Harga tiket per tiket
        $transaksi->payment_status = 1; // Status pembayaran, bisa disesuaikan
        $transaksi->save();

        // Update status kendaraan menjadi tidak tersedia
        $angkotTersedia->is_tersedia = 0;
        $angkotTersedia->save();

        return response()->json([
            'message' => 'Tiket berhasil dipesan',
            'transaksi' => $transaksi
        ]);
    }

}
