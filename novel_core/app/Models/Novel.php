<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Factories\HasFactory;

class Novel extends Model
{
    use HasFactory;

    protected $fillable = [
        'title', 'description', 'admin_id'
    ];

    public function author()
    {
        return $this->belongsTo(User::class, 'admin_id');
    }

    public function chapters()
    {
        return $this->hasMany(Chapter::class);
    }
}
