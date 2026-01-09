<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Services\GatewayService;

class GatewayController extends Controller
{
    protected $gatewayService;

    public function __construct(GatewayService $gatewayService)
    {
        $this->gatewayService = $gatewayService;
    }

    public function proxy(Request $request)
    {
        return $this->gatewayService->proxy($request);
    }
}
