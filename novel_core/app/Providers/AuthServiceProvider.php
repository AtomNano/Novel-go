<?php

namespace App\Providers;

use App\Models\User;
use Illuminate\Support\Facades\Gate;
use Illuminate\Support\ServiceProvider;

class AuthServiceProvider extends ServiceProvider
{
    /**
     * Register any application services.
     *
     * @return void
     */
    public function register()
    {
        //
    }

    /**
     * Boot the authentication services for the application.
     *
     * @return void
     */
    public function boot()
    {
        // Here you may define how you wish users to be authenticated for your Lumen
        // application. The callback which receives the incoming request instance
        // should return either a User instance or null. You're free to obtain
        // the User instance via an API token or any other method necessary.

        $this->app['auth']->viaRequest('api', function ($request) {
            $token = $request->bearerToken();

            if (!$token) {
                return null;
            }

            try {
                $key = env('JWT_SECRET');
                if (!$key) {
                    // Fallback or error logging
                    return null;
                }

                // Decode JWT
                $decoded = \Firebase\JWT\JWT::decode($token, new \Firebase\JWT\Key($key, 'HS256'));

                // Find user by ID
                if (isset($decoded->id)) {
                    return User::find($decoded->id);
                }
            } catch (\Exception $e) {
                return null;
            }
        });
    }
}
