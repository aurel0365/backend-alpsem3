<?php

namespace App\Http\Controllers\Auth;

use App\Models\User;
use App\Models\Driver;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use App\Http\Controllers\Controller;
use Illuminate\Support\Facades\Hash;
use Illuminate\Validation\ValidationException;

class LoginController extends Controller
{
    /**
 * @OA\Post(
 *     path="/api/login",
 *     summary="Login user berdasarkan role",
 *     tags={"Authentication"},
 *     @OA\RequestBody(
 *         required=true,
 *         @OA\JsonContent(
 *             required={"email", "password", "role"},
 *             @OA\Property(property="email", type="string", format="email", example="user@example.com", description="Email pengguna"),
 *             @OA\Property(property="password", type="string", example="password123", description="Password pengguna"),
 *             @OA\Property(property="role", type="string", enum={"customer", "driver"}, example="customer", description="Role pengguna (customer atau driver)")
 *         )
 *     ),
 *     @OA\Response(
 *         response=200,
 *         description="Login berhasil",
 *         @OA\JsonContent(
 *             @OA\Property(property="message", type="string", example="Login berhasil"),
 *             @OA\Property(property="role", type="string", example="customer", description="Role pengguna"),
 *             @OA\Property(property="token", type="string", example="1|xyz123abc456def789ghi"),
 *             @OA\Property(property="nama", type="string", example="John Doe", description="Nama pengguna")
 *         )
 *     ),
 *     @OA\Response(
 *         response=401,
 *         description="Email, role, atau password tidak sesuai",
 *         @OA\JsonContent(
 *             @OA\Property(property="message", type="string", example="Email, role, atau password tidak sesuai.")
 *         )
 *     ),
 *     @OA\Response(
 *         response=400,
 *         description="Role tidak valid",
 *         @OA\JsonContent(
 *             @OA\Property(property="message", type="string", example="Role tidak valid.")
 *         )
 *     ),
 *     @OA\Response(
 *         response=422,
 *         description="Validasi input gagal",
 *         @OA\JsonContent(
 *             @OA\Property(property="message", type="string", example="The given data was invalid."),
 *             @OA\Property(property="errors", type="object", additionalProperties=@OA\Property(type="array", @OA\Items(type="string")))
 *         )
 *     )
 * )
 */

    public function login(Request $request)
    {
        // Validasi input
        $validated = $request->validate([
            'email' => 'required|email',
            'password' => 'required|string',
            'role' => 'required|in:customer,driver', // Pastikan role dikirimkan
        ]);

        if ($validated['role'] === 'customer') {
            // Cari customer berdasarkan email
            $user = User::where('email', $validated['email'])->first();

            // Validasi password untuk customer
            if (!$user || !Hash::check($validated['password'], $user->password)) {
                return response()->json([
                    'message' => 'Email, role, atau password tidak sesuai.',
                ], 401); // Status 401 Unauthorized
            }

            // Login dan buat token untuk customer
            $token = $user->createToken('MyApp')->plainTextToken;

            return response()->json([
                'message' => 'Login berhasil',
                'role' => 'customer',
                'token' => $token,
                'nama' => $user->nama,
            ]);
        }

        // Jika role adalah driver
        if ($validated['role'] === 'driver') {
            // Cari driver berdasarkan email
            $driver = Driver::where('email', $validated['email'])->first();

            // Validasi password untuk driver
            if (!$driver || !Hash::check($validated['password'], $driver->password)) {
                return response()->json([
                    'message' => 'Email, role, atau password tidak sesuai.',
                ], 401); // Status 401 Unauthorized
            }

            // Login dan buat token untuk driver
            $token = $driver->createToken('MyApp')->plainTextToken;

            return response()->json([
                'message' => 'Login berhasil',
                'role' => 'driver',
                'token' => $token,
                'nama' => $driver->nama,
            ]);
        }

        return response()->json([
            'message' => 'Role tidak valid.',
        ], 400); // Status 400 Bad Request
    }
}
