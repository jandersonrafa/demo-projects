<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use GuzzleHttp\Client;
use App\Services\GatewayService;

class GatewayController extends Controller
{
    protected $gatewayService;
    protected $httpClient;

    public function __construct(GatewayService $gatewayService, Client $httpClient)
    {
        $this->gatewayService = $gatewayService;
        $this->httpClient = $httpClient;
    }

    public function createBonus(Request $request)
    {
        $response = $this->httpClient->post('/bonus', [
            'json' => $request->all()
        ]);
        return response()->json(json_decode($response->getBody(), true), $response->getStatusCode());
    }

    public function getBonus($id)
    {
        $response = $this->httpClient->get('/bonus/' . $id);
        return response()->json(json_decode($response->getBody(), true), $response->getStatusCode());
    }

    public function proxy(Request $request)
    {
        return $this->gatewayService->proxy($request);
    }
}
