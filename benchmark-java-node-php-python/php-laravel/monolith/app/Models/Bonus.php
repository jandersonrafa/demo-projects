<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Bonus extends Model
{
    protected $table = 'bonus';
    protected $fillable = ['amount', 'description', 'client_id', 'expiration_date', 'created_at'];
    public $timestamps = false;

    public function toArray()
    {
        return [
            'id' => $this->id,
            'amount' => (float) $this->amount,
            'description' => $this->description,
            'clientId' => $this->client_id,
            'createdAt' => $this->created_at,
            'expirationDate' => $this->expiration_date,
        ];
    }
}
