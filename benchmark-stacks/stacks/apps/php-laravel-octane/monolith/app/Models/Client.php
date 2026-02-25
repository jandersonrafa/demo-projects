<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Client extends Model
{
    protected $table = 'clients';
    protected $fillable = ['id', 'name', 'active'];
    public $incrementing = false;
    protected $keyType = 'string';
    public $timestamps = false;
}
