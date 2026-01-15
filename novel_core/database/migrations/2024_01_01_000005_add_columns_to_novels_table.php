<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration {
    public function up(): void
    {
        Schema::table('novels', function (Blueprint $table) {
            $table->string('author')->nullable()->after('title');
            $table->string('publisher')->nullable()->after('author');
            $table->string('cover')->nullable()->after('publisher');
            $table->string('published_date')->nullable()->after('description');
        });
    }

    public function down(): void
    {
        Schema::table('novels', function (Blueprint $table) {
            $table->dropColumn(['author', 'publisher', 'cover', 'published_date']);
        });
    }
};
