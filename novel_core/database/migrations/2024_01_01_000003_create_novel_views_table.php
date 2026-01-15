<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration {
    public function up(): void
    {
        if (!Schema::hasTable('novel_views')) {
            Schema::create('novel_views', function (Blueprint $table) {
                $table->id();
                $table->foreignId('novel_id')->constrained('novels')->onDelete('cascade');
                $table->timestamps();
            });
        }
    }

    public function down(): void
    {
        Schema::dropIfExists('novel_views');
    }
};
