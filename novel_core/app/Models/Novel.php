<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Factories\HasFactory;

class Novel extends Model
{
    use HasFactory;

    protected $fillable = [
        'title',
        'author',
        'publisher',
        'cover',
        'description',
        'published_date',
        'admin_id',
        'content'
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
