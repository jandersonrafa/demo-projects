<?php

namespace App\Http\Requests;

use Illuminate\Foundation\Http\FormRequest;

class BonusCreateRequest extends FormRequest
{
    public function authorize()
    {
        return true;
    }

    public function rules()
    {
        return [
            'amount' => 'required|numeric|min:0.01',
            'description' => 'required|string',
            'clientId' => 'required|string'
        ];
    }
}
