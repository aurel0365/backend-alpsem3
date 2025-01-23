<?php

namespace App\Http\Controllers\Auth;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Hash;
use App\Models\User;
use App\Models\Driver;
use Illuminate\Support\Facades\Validator;

class ApiController extends Controller
{
    
    // Middleware akan memeriksa token menggunakan Sanctum
    public function __construct()
    {
        $this->middleware('auth:sanctum');
    }

        /**
     * @OA\Get(
     *     path="/api/profile",
     *     summary="Retrieve authenticated user profile",
     *     tags={"User Profile"},
     *     security={{"sanctum": {}}},
     *     @OA\Response(
     *         response=200,
     *         description="User profile retrieved successfully",
     *         @OA\JsonContent(
     *             @OA\Property(property="message", type="string", example="You are authenticated"),
     *             @OA\Property(property="user", type="object", example={"id": 1, "name": "John Doe", "email": "user@example.com"})
     *         )
     *     )
     * )
     */

    // Contoh endpoint API yang memerlukan autentikasi
    public function getProfile(Request $request)
    {
        return response()->json(['message' => 'You are authenticated', 'user' => $request->user()]);
    }

     /**
     * @OA\Post(
     *     path="/api/logout",
     *     summary="Log out the authenticated user",
     *     tags={"Authentication"},
     *     security={{"sanctum": {}}},
     *     @OA\Response(
     *         response=200,
     *         description="Logged out successfully",
     *         @OA\JsonContent(
     *             @OA\Property(property="message", type="string", example="Logged out successfully")
     *         )
     *     )
     * )
     */

    public function logout(Request $request)
    {
        // Menghapus token yang ada
        $request->user()->currentAccessToken()->delete();


        return response()->json(['message' => 'Logged out successfully']);
    }

    /**
     * @OA\Put(
     *     path="/api/edit-profile",
     *     summary="Update user profile",
     *     tags={"User Profile"},
     *     security={{"sanctum": {}}},
     *     @OA\RequestBody(
     *         required=true,
     *         @OA\JsonContent(
     *             @OA\Property(property="nama", type="string", example="John Doe", description="Full name of the user"),
     *             @OA\Property(property="email", type="string", format="email", example="user@example.com", description="User's email"),
     *             @OA\Property(property="password", type="string", example="password123", description="New password"),
     *             @OA\Property(property="no_hp", type="string", example="081234567890", description="Phone number"),
     *             @OA\Property(property="alamat", type="string", example="Jl. Example No. 1", description="Address"),
     *             @OA\Property(property="gender", type="string", enum={"laki-laki", "perempuan"}, example="laki-laki", description="Gender"),
     *             @OA\Property(property="tgl_lahir", type="string", format="date", example="1990-01-01", description="Date of birth")
     *         )
     *     ),
     *     @OA\Response(
     *         response=200,
     *         description="User profile updated successfully",
     *         @OA\JsonContent(
     *             @OA\Property(property="message", type="string", example="User profile updated successfully.")
     *         )
     *     ),
     *     @OA\Response(
     *         response=422,
     *         description="Validation failed",
     *         @OA\JsonContent(
     *             @OA\Property(property="message", type="string", example="Validation failed"),
     *             @OA\Property(property="errors", type="object", additionalProperties=@OA\Property(type="array", @OA\Items(type="string")))
     *         )
     *     )
     * )
     */

    public function editProfile(Request $request)
    {
        // Get the authenticated user from the token
        $user = $request->user();

        // Define validation rules for partial updates
        $rules = [
            'nama' => 'sometimes|required|string|max:255',
            'email' => 'sometimes|required|email|unique:users,email,' . $user->id,
            'password' => 'sometimes|nullable|string|min:8|confirmed',
            'no_hp' => 'sometimes|string|max:15',
            'alamat' => 'sometimes|string|max:255',
            'gender' => 'sometimes|in:laki-laki,perempuan',
            'tgl_lahir' => 'sometimes|date',
        ];

        // Create a validator instance
        $validator = Validator::make($request->all(), $rules);

        // Check if the validation fails
        if ($validator->fails()) {
            return response()->json([
                'message' => 'Validation failed',
                'errors' => $validator->errors(),
            ], 422);
        }

        // Retrieve validated data
        $validatedData = $validator->validated();

        // Determine if the user is a driver based on the relationship
        if ($user->driver) {
            // Update driver record with only the provided fields
            $driver = $user->driver;
            $driver->fill($validatedData);
            if (!empty($validatedData['password'])) {
                $driver->password = bcrypt($validatedData['password']);
            }
            $driver->save();

            return response()->json(['message' => 'Driver profile updated successfully.']);
        } else {
            // Update user record with only the provided fields
            $user->fill($validatedData);
            if (!empty($validatedData['password'])) {
                $user->password = bcrypt($validatedData['password']);
            }
            if ($request->hasFile('profile_photo')) {
                $path = $request->file('profile_photo')->store('profile_photos', 'public');
                $user->profile_photo_path = $path;
            }
            $user->save();

            return response()->json(['message' => 'User profile updated successfully.']);
        }
    }

     /**
     * @OA\Delete(
     *     path="/api/delete-account",
     *     summary="Delete authenticated user's account",
     *     tags={"User Profile"},
     *     security={{"sanctum": {}}},
     *     @OA\Response(
     *         response=200,
     *         description="User account deleted successfully",
     *         @OA\JsonContent(
     *             @OA\Property(property="message", type="string", example="User account deleted successfully.")
     *         )
     *     )
     * )
     */

        public function deleteUser(Request $request)
    {
        // Get the authenticated user
        $user = $request->user();

        // Delete the user
        $user->delete();

        // Return a response indicating the user has been deleted
        return response()->json(['message' => 'User account deleted successfully.']);
    }

}
