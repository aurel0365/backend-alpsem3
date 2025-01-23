<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\Transaction;
use Carbon\Carbon;

class TransaksiController extends Controller
{

        /**
     * @OA\Get(
     *     path="/api/user/transaksi",
     *     summary="Get all transactions for the authenticated user",
     *     tags={"Transaksi"},
     *     @OA\Response(
     *         response=200,
     *         description="Successfully retrieved transactions",
     *         @OA\JsonContent(type="array", @OA\Items(ref="#/components/schemas/Transaction"))
     *     ),
     *     @OA\Response(
     *         response=401,
     *         description="User not authenticated",
     *         @OA\JsonContent(
     *             @OA\Property(property="message", type="string", example="User tidak terautentikasi")
     *         )
     *     ),
     *     @OA\Response(
     *         response=404,
     *         description="No transactions found",
     *         @OA\JsonContent(
     *             @OA\Property(property="message", type="string", example="Tidak ada transaksi untuk user ini")
     *         )
     *     )
     * )
     */


    public function getUserTransactions()
    {
    // Pastikan user terautentikasi
    if (!auth()->check()) {
        return response()->json(['message' => 'User tidak terautentikasi'], 401);
    }


    $userId = auth()->user()->id; // Ambil ID user yang terautentikasi

    // Ambil transaksi yang melibatkan user ini
    $transaksi = Transaction::where('id_user', $userId)->get();

    if ($transaksi->isEmpty()) {
        return response()->json(['message' => 'Tidak ada transaksi untuk user ini'], 404);
    }

    return response()->json($transaksi);
    }

    
        /**
     * @OA\Get(
     *     path="/api/driver/transaksi",
     *     summary="Get all transactions for the authenticated driver",
     *     tags={"Transaksi"},
     *     @OA\Response(
     *         response=200,
     *         description="Successfully retrieved driver transactions",
     *         @OA\JsonContent(type="array", @OA\Items(ref="#/components/schemas/Transaction"))
     *     ),
     *     @OA\Response(
     *         response=403,
     *         description="Driver only can access this",
     *         @OA\JsonContent(
     *             @OA\Property(property="message", type="string", example="Hanya driver yang dapat melihat transaksi ini")
     *         )
     *     ),
     *     @OA\Response(
     *         response=404,
     *         description="No transactions found",
     *         @OA\JsonContent(
     *             @OA\Property(property="message", type="string", example="Tidak ada transaksi untuk driver ini")
     *         )
     *     )
     * )
     */

    public function getDriverTransactions()
    {
    // Pastikan user terautentikasi dan memiliki role 'driver'
    if (auth()->check() && auth()->user()->role != 'driver') {
        return response()->json(['message' => 'Hanya driver yang dapat melihat transaksi ini'], 403);
    }

    $driverId = auth()->user()->id; // Ambil ID driver yang terautentikasi

    // Ambil transaksi yang melibatkan driver ini
    $transaksi = Transaction::where('id_driver', $driverId)->get();

    if ($transaksi->isEmpty()) {
        return response()->json(['message' => 'Tidak ada transaksi untuk driver ini'], 404);
    }

    return response()->json($transaksi);
    }

        /**
     * @OA\Get(
     *     path="/api/transaksi/filter/date/{date}",
     *     summary="Filter transactions by date",
     *     tags={"Transaksi"},
     *     @OA\Parameter(
     *         name="date",
     *         in="path",
     *         required=true,
     *         description="The date to filter transactions",
     *         @OA\Schema(type="string", format="date")
     *     ),
     *     @OA\Response(
     *         response=200,
     *         description="Successfully filtered transactions",
     *         @OA\JsonContent(type="array", @OA\Items(ref="#/components/schemas/Transaction"))
     *     )
     * )
     */


    public function filterByDate(Request $request, $date)
    {
        $user = $request->user();
    
        // Cek apakah user adalah driver atau customer
        if ($user->driver) {
            // User adalah driver, filter berdasarkan id_driver
            $transaksi = Transaction::whereDate('tgl_transaksi', $date)
                                ->where('id_driver', $user->id) // Menampilkan transaksi yang terkait dengan driver
                                ->get();
        } else {
            // User adalah customer, filter berdasarkan id_user
            $transaksi = Transaction::whereDate('tgl_transaksi', $date)
                                ->where('id_user', $user->id) // Menampilkan transaksi yang terkait dengan customer
                                ->get();
        }
    
        return response()->json($transaksi);
    }

        /**
     * @OA\Get(
     *     path="/api/transaksi/filter/month/{month}/year/{year}",
     *     summary="Filter transactions by month and year",
     *     tags={"Transaksi"},
     *     @OA\Parameter(
     *         name="month",
     *         in="path",
     *         required=true,
     *         description="Month to filter",
     *         @OA\Schema(type="integer", example=1)
     *     ),
     *     @OA\Parameter(
     *         name="year",
     *         in="path",
     *         required=true,
     *         description="Year to filter",
     *         @OA\Schema(type="integer", example=2025)
     *     ),
     *     @OA\Response(
     *         response=200,
     *         description="Successfully filtered transactions",
     *         @OA\JsonContent(type="array", @OA\Items(ref="#/components/schemas/Transaction"))
     *     )
     * )
     */

    
    public function filterByMonth(Request $request, $month, $year)
    {
        $user = $request->user();
    
        // Cek apakah user adalah driver atau customer
        if ($user->driver) {
            // User adalah driver, filter berdasarkan id_driver
            $transaksi = Transaction::whereMonth('tgl_transaksi', $month)
                                ->whereYear('tgl_transaksi', $year)
                                ->where('id_driver', $user->id) // Menampilkan transaksi yang terkait dengan driver
                                ->get();
        } else {
            // User adalah customer, filter berdasarkan id_user
            $transaksi = Transaction::whereMonth('tgl_transaksi', $month)
                                ->whereYear('tgl_transaksi', $year)
                                ->where('id_user', $user->id) // Menampilkan transaksi yang terkait dengan customer
                                ->get();
        }
    
        return response()->json($transaksi);
    }

        /**
     * @OA\Get(
     *     path="/api/transaksi/filter/year/{year}",
     *     summary="Filter transactions by year",
     *     tags={"Transaksi"},
     *     @OA\Parameter(
     *         name="year",
     *         in="path",
     *         required=true,
     *         description="Year to filter",
     *         @OA\Schema(type="integer", example=2025)
     *     ),
     *     @OA\Response(
     *         response=200,
     *         description="Successfully filtered transactions",
     *         @OA\JsonContent(type="array", @OA\Items(ref="#/components/schemas/Transaction"))
     *     )
     * )
     */

    
    public function filterByYear(Request $request, $year)
    {
        $user = $request->user();
    
        // Cek apakah user adalah driver atau customer
        if ($user->driver) {
            // User adalah driver, filter berdasarkan id_driver
            $transaksi = Transaction::whereYear('tgl_transaksi', $year)
                                ->where('id_driver', $user->id) // Menampilkan transaksi yang terkait dengan driver
                                ->get();
        } else {
            // User adalah customer, filter berdasarkan id_user
            $transaksi = Transaction::whereYear('tgl_transaksi', $year)
                                ->where('id_user', $user->id) // Menampilkan transaksi yang terkait dengan customer
                                ->get();
        }
    
        return response()->json($transaksi);
    }

        /**
     * @OA\Get(
     *     path="/api/transaksi/filter/date/{date}/month/{month}/year/{year}",
     *     summary="Filter transactions by specific date, month, and year",
     *     tags={"Transaksi"},
     *     @OA\Parameter(
     *         name="date",
     *         in="path",
     *         required=true,
     *         description="The date to filter",
     *         @OA\Schema(type="string", format="date")
     *     ),
     *     @OA\Parameter(
     *         name="month",
     *         in="path",
     *         required=true,
     *         description="Month to filter",
     *         @OA\Schema(type="integer", example=1)
     *     ),
     *     @OA\Parameter(
     *         name="year",
     *         in="path",
     *         required=true,
     *         description="Year to filter",
     *         @OA\Schema(type="integer", example=2025)
     *     ),
     *     @OA\Response(
     *         response=200,
     *         description="Successfully filtered transactions",
     *         @OA\JsonContent(type="array", @OA\Items(ref="#/components/schemas/Transaction"))
     *     )
     * )
     */

    
    public function filterByDateMonthYear(Request $request, $date, $month, $year)
    {
        $user = $request->user();
    
        // Cek apakah user adalah driver atau customer
        if ($user->driver) {
            // User adalah driver, filter berdasarkan id_driver
            $transaksi = Transaction::whereDate('tgl_transaksi', $date)
                                ->whereMonth('tgl_transaksi', $month)
                                ->whereYear('tgl_transaksi', $year)
                                ->where('id_driver', $user->id) // Menampilkan transaksi yang terkait dengan driver
                                ->get();
        } else {
            // User adalah customer, filter berdasarkan id_user
            $transaksi = Transaction::whereDate('tgl_transaksi', $date)
                                ->whereMonth('tgl_transaksi', $month)
                                ->whereYear('tgl_transaksi', $year)
                                ->where('id_user', $user->id) // Menampilkan transaksi yang terkait dengan customer
                                ->get();
        }
    
        return response()->json($transaksi);
    }

}
 