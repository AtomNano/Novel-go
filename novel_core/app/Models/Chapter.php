<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Factories\HasFactory;

class Chapter extends Model
{
    use HasFactory;

    protected $fillable = [
        'novel_id', 'title', 'content', 'chapter_number'
    ];

    public function novel()
    {
        return $this->belongsTo(Novel::class);
    }
}
