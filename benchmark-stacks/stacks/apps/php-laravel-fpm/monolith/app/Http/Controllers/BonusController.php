<?php

namespace App\Http\Controllers;

use App\Services\BonusService;
use App\Http\Requests\BonusCreateRequest;

class BonusController extends Controller
{
    protected $service;

    public function __construct(BonusService $service)
    {
        $this->service = $service;
    }

    public function store(BonusCreateRequest $request)
    {
        $result = $this->service->createBonus($request->validated());

        if (isset($result['error'])) {
            return response()->json(['message' => $result['error']], $result['status']);
        }

        return response()->json($result['data'], $result['status']);
    }

    public function show($id)
    {
        $result = $this->service->getBonus($id);

        if (isset($result['error'])) {
            return response()->json(['message' => $result['error']], $result['status']);
        }

        return response()->json($result['data']);
    }
}
