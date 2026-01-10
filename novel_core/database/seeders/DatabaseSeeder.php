<?php

namespace Database\Seeders;

use App\Models\User;
use App\Models\Novel;
use App\Models\Chapter;
use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Str;

class DatabaseSeeder extends Seeder
{
    /**
     * Run the database seeds.
     *
     * @return void
     */
    public function run()
    {
        // Create Admin
        $admin = User::create([
            'name' => 'Admin User',
            'email' => 'admin@example.com',
            'password' => Hash::make('password'),
            'role' => 'admin',
            'api_token' => 'admin-token-secret'
        ]);

        // Create Regular User
        User::create([
            'name' => 'John Doe',
            'email' => 'john@example.com',
            'password' => Hash::make('password'),
            'role' => 'user',
            'api_token' => Str::random(32)
        ]);

        // Create Novels
        $novel1 = Novel::create([
            'title' => 'The Beginning After The End',
            'description' => 'A king reincarnated into a new world of magic.',
            'admin_id' => $admin->id
        ]);

        // Create Chapters for Novel 1
        Chapter::create([
            'novel_id' => $novel1->id,
            'title' => 'Chapter 1: The Light',
            'content' => 'This is the content of chapter 1 defined in the seeder.',
            'chapter_number' => 1
        ]);
        Chapter::create([
            'novel_id' => $novel1->id,
            'title' => 'Chapter 2: The Darkness',
            'content' => 'This is the content of chapter 2 defined in the seeder.',
            'chapter_number' => 2
        ]);
    }
}
