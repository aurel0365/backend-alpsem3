<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Http;



class GeocodingController extends Controller
{
    /**
     * @OA\Get(
     *     path="/api/search-location",
     *     summary="Search location by query",
     *     tags={"Geocoding"},
     *     @OA\Parameter(
     *         name="query",
     *         in="query",
     *         description="Location to search for",
     *         required=true,
     *         @OA\Schema(type="string", example="Universitas Ciputra")
     *     ),
     *     @OA\Response(
     *         response=200,
     *         description="Location search results",
     *         @OA\JsonContent(
     *             type="array",
     *             @OA\Items(
     *                 type="object",
     *                 @OA\Property(property="place_name", type="string"),
     *                 @OA\Property(property="lat", type="number", format="float"),
     *                 @OA\Property(property="lon", type="number", format="float")
     *             )
     *         )
     *     ),
     *     @OA\Response(
     *         response=500,
     *         description="Failed to fetch location",
     *         @OA\JsonContent(
     *             @OA\Property(property="error", type="string", example="Failed to fetch location")
     *         )
     *     )
     * )
     */
        public function searchLocation(Request $request)
    {
        $query = $request->input('query'); // Ambil input lokasi dari user

        $response = Http::withHeaders([
            'User-Agent' => 'Universitas Ciputra',
            'Referer' => 'https://www.ciputra.ac.id/'
        ])->get('https://nominatim.openstreetmap.org/search', [
            'q' => $query,
            'format' => 'json',
            'limit' => 5,
        ]);

        if ($response->successful()) {
            return response()->json($response->json());
        }

        return response()->json(['error' => 'Failed to fetch location'], 500);
    }   

       /**
     * @OA\Get(
     *     path="/api/reverse-geocode",
     *     summary="Get address by latitude and longitude",
     *     tags={"Geocoding"},
     *     @OA\Parameter(
     *         name="lat",
     *         in="query",
     *         description="Latitude of the location",
     *         required=true,
     *         @OA\Schema(type="number", format="float", example="-5.2299394697095245")
     *     ),
     *     @OA\Parameter(
     *         name="lon",
     *         in="query",
     *         description="Longitude of the location",
     *         required=true,
     *         @OA\Schema(type="number", format="float", example="119.50211253693419")
     *     ),
     *     @OA\Response(
     *         response=200,
     *         description="Address for given coordinates",
     *         @OA\JsonContent(
     *             type="object",
     *             @OA\Property(property="address", type="object"),
     *             @OA\Property(property="place_name", type="string"),
     *             @OA\Property(property="lat", type="number", format="float"),
     *             @OA\Property(property="lon", type="number", format="float")
     *         )
     *     ),
     *     @OA\Response(
     *         response=500,
     *         description="Failed to fetch address",
     *         @OA\JsonContent(
     *             @OA\Property(property="error", type="string", example="Failed to fetch address")
     *         )
     *     )
     * )
     */

        public function reverseGeocode(Request $request)
    {
        $lat = $request->input('lat');
        $lon = $request->input('lon');

        // Panggil API Nominatim
        $response = Http::withHeaders([
            'User-Agent' => 'Universitas Ciputra',
            'Referer' => 'https://www.ciputra.ac.id/'
        ])->get('https://nominatim.openstreetmap.org/reverse', [
            'lat' => $lat,
            'lon' => $lon,
            'format' => 'json',

        ]);
        if ($response->successful()) {
            return response()->json($response->json());
        }

        return response()->json(['error' => 'Failed to fetch address'], 500);
    }

    /**
     * @OA\Get(
     *     path="/api/get-route",
     *     summary="Get route from start to end location",
     *     tags={"Geocoding"},
     *     @OA\Parameter(
     *         name="start_lat",
     *         in="query",
     *         description="Starting latitude",
     *         required=true,
     *         @OA\Schema(type="number", format="float")
     *     ),
     *     @OA\Parameter(
     *         name="start_lon",
     *         in="query",
     *         description="Starting longitude",
     *         required=true,
     *         @OA\Schema(type="number", format="float")
     *     ),
     *     @OA\Parameter(
     *         name="end_lat",
     *         in="query",
     *         description="Ending latitude",
     *         required=true,
     *         @OA\Schema(type="number", format="float")
     *     ),
     *     @OA\Parameter(
     *         name="end_lon",
     *         in="query",
     *         description="Ending longitude",
     *         required=true,
     *         @OA\Schema(type="number", format="float")
     *     ),
     *     @OA\Response(
     *         response=200,
     *         description="Route details",
     *         @OA\JsonContent(
     *             type="object",
     *             @OA\Property(property="routes", type="array", 
     *                 @OA\Items(
     *                     type="object",
     *                     @OA\Property(property="distance", type="number", format="float", example=1500),
     *                     @OA\Property(property="duration", type="number", format="float", example=10),
     *                     @OA\Property(property="geometry", type="string", example="polyline_string_here")
     *                 )
     *             )
     *         )
     *     ),
     *     @OA\Response(
     *         response=400,
     *         description="Missing parameters",
     *         @OA\JsonContent(
     *             @OA\Property(property="error", type="string", example="Missing required parameters")
     *         )
     *     ),
     *     @OA\Response(
     *         response=500,
     *         description="Failed to fetch route from OSRM",
     *         @OA\JsonContent(
     *             @OA\Property(property="error", type="string", example="Failed to fetch route from OSRM")
     *         )
     *     )
     * )
     */
        public function getRoute(Request $request)
    {
            $startLat = $request->query('start_lat');
            $startLon = $request->query('start_lon');
            $endLat = $request->query('end_lat');
            $endLon = $request->query('end_lon');

            // Validasi input
            if (!$startLat || !$startLon || !$endLat || !$endLon) {
                return response()->json(['error' => 'Missing required parameters'], 400);
            }

            // OSRM Routing API URL
            $osrmUrl = "http://localhost:5000/route/v1/driving/{$startLon},{$startLat};{$endLon},{$endLat}?overview=full&geometries=polyline";

            // Fetch data dari OSRM
            $response = Http::get($osrmUrl);

            if ($response->ok()) {
                return response()->json($response->json());
            }

            return response()->json(['error' => 'Failed to fetch route from OSRM'], 500);
    }

    /**
     * @OA\Get(
     *     path="/api/get-koordinat-halte",
     *     summary="Get coordinates of predefined bus stops",
     *     tags={"Geocoding"},
     *     @OA\Response(
     *         response=200,
     *         description="Predefined bus stops with coordinates",
     *         @OA\JsonContent(
     *             type="array",
     *             @OA\Items(
     *                 type="object",
     *                 @OA\Property(property="name", type="string"),
     *                 @OA\Property(property="lat", type="number", format="float"),
     *                 @OA\Property(property="lon", type="number", format="float")
     *             )
     *         )
     *     )
     * )
     */

        public function getKoordinatHalte()
    {
            // Inisialisasi data halte
            $stops = [
                ['name' => 'Kampus Unhas Teknik Gowa', 'lat' => -5.2299394697095245, 'lon' => 119.50211253693419],
                ['name' => 'Halte CSA Unhas', 'lat' => -5.230279153107808, 'lon' => 119.50271553823227],
                ['name' => 'Asrama Rindam Gowa', 'lat' => -5.225254, 'lon' => 119.496872],
                ['name' => 'Citraland Hertasning', 'lat' => -5.18092218503825, 'lon' => 119.46426590725011],
                ['name' => 'Mall Panakkukang', 'lat' => -5.156793513683525, 'lon' => 119.44766356706735],
                ['name' => 'Taman Pakui', 'lat' => -5.151616686795926, 'lon' => 119.43729584824564],
                ['name' => 'Halte GPIB Mangngamaseang', 'lat' => -5.145760125553669, 'lon' => 119.46944072857308],
                ['name' => 'Fakultas Sospol Unhas', 'lat' => -5.131505037510745, 'lon' => 119.49023242996354], // Kembali ke awal 
            ];
    
           
            return response()->json($stops);
    }

    /**
     * @OA\Get(
     *     path="/api/get-circular-route",
     *     summary="Get circular route by waypoints",
     *     tags={"Geocoding"},
     *     @OA\Parameter(
     *         name="waypoints",
     *         in="query",
     *         description="Waypoints in lon,lat format",
     *         required=true,
     *         @OA\Schema(type="string", example="119.50211253693419,-5.2299394697095245;119.46426590725011,-5.18092218503825")
     *     ),
     *     @OA\Response(
     *         response=200,
     *         description="Circular route details",
     *         @OA\JsonContent(
     *             type="object",
     *             @OA\Property(property="routes", type="array", 
     *                 @OA\Items(
     *                     type="object",
     *                     @OA\Property(property="distance", type="number", format="float", example=1500),
     *                     @OA\Property(property="duration", type="number", format="float", example=10),
     *                     @OA\Property(property="geometry", type="string", example="polyline_string_here")
     *                 )
     *             )
     *         )
     *     ),
     *     @OA\Response(
     *         response=400,
     *         description="Missing waypoints parameter",
     *         @OA\JsonContent(
     *             @OA\Property(property="error", type="string", example="Missing required parameters")
     *         )
     *     ),
     *     @OA\Response(
     *         response=500,
     *         description="Failed to fetch route from OSRM",
     *         @OA\JsonContent(
     *             @OA\Property(property="error", type="string", example="Failed to fetch route from OSRM")
     *         )
     *     )
     * )
     */

        public function getCircularRoute(Request $request)
    {
        $waypoints = $request->query('waypoints'); // Waypoints dalam format lon,lat;lon,lat;...

        if (!$waypoints) {
            return response()->json(['error' => 'Missing required parameters'], 400);
        }

        // OSRM Routing API URL
        $osrmUrl = "http://localhost:5000/route/v1/driving/{$waypoints}?overview=full&geometries=polyline";

        // Fetch data dari OSRM
        $response = Http::get($osrmUrl);

        if ($response->ok()) {
            return response()->json($response->json());
        }

        return response()->json(['error' => 'Failed to fetch route from OSRM'], 500);
    }


}
