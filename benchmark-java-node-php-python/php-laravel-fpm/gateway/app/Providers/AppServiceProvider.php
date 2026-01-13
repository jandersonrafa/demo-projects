<?php

namespace App\Providers;

use Illuminate\Support\ServiceProvider;

class AppServiceProvider extends ServiceProvider
{
    /**
     * Register any application services.
     */
    public function register(): void
    {
        $this->app->singleton(\GuzzleHttp\Client::class, function ($app) {
            return new \GuzzleHttp\Client([
                'base_uri' => env('MONOLITH_URL', 'http://php-fpm-monolith-web'),
                'timeout' => 30,
                'http_errors' => false,
                'headers' => [
                    'Connection' => 'keep-alive'
                ],
                'curl' => [
                    CURLOPT_TCP_NODELAY => true,
                ],
            ]);
        });
    }

    /**
     * Bootstrap any application services.
     */
    public function boot(): void
    {
        //
    }
}
