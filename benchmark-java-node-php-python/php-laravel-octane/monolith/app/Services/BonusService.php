<?php

namespace App\Services;

use App\Models\Bonus;
use App\Models\Client;
use Carbon\Carbon;
use Illuminate\Http\Request;

class BonusService
{
    public function createBonus(array $data)
    {
        // 1. Integrity Check
        $client = Client::find($data['clientId']);

        if (!$client) {
            return ['error' => 'Client not found', 'status' => 404];
        }

        if (!$client->active) {
            return ['error' => 'Client is inactive', 'status' => 400];
        }

        // 2. Biz Logic
        $amount = $data['amount'];
        if ($amount > 100) {
            $amount = $amount * 1.1;
        }

        $now = Carbon::now();
        $expirationDate = $now->copy()->addDays(30);

        $bonus = Bonus::create([
            'amount' => $amount,
            'description' => 'PHPLARAVELOCTANE - ' . $data['description'],
            'client_id' => $data['clientId'],
            'expiration_date' => $expirationDate,
            'created_at' => $now
        ]);

        return ['data' => $bonus, 'status' => 201];
    }

    public function getBonus($id)
    {
        $bonus = Bonus::find($id);
        if (!$bonus) {
            return ['error' => 'Not found', 'status' => 404];
        }
        return ['data' => $bonus, 'status' => 200];
    }
}
