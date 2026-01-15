<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration {
    public function up(): void
    {
        if (Schema::hasTable('novels') && !Schema::hasColumn('novels', 'content')) {
            Schema::table('novels', function (Blueprint $table) {
                // Use longText for large content
                $table->longText('content')->nullable()->after('description');
            });
        }
    }

    public function down(): void
    {
        if (Schema::hasTable('novels') && Schema::hasColumn('novels', 'content')) {
            Schema::table('novels', function (Blueprint $table) {
                $table->dropColumn('content');
            });
        }
    }
};
