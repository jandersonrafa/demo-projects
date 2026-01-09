<?php

namespace App\Http\Middleware;

use Closure;
use Illuminate\Http\Request;
use Prometheus\CollectorRegistry;
use Prometheus\Storage\APCng;

class PrometheusMiddleware
{
    public function handle(Request $request, Closure $next)
    {
        $start = microtime(true);
        $response = $next($request);
        $duration = microtime(true) - $start;

        if ($request->is('metrics') || $request->is('prometheus') || $request->is('up') || $request->is('health')) {
            return $response;
        }

        try {
            $adapter = new APCng();
            $registry = new CollectorRegistry($adapter);

            $counter = $registry->getOrRegisterCounter(
                '',
                'http_requests_total',
                'Total number of requests',
                ['method', 'path', 'status']
            );

            $counter->inc([
                $request->getMethod(),
                $request->route() ? $request->route()->uri() : $request->getPathInfo(),
                (string) $response->getStatusCode()
            ]);

            $histogram = $registry->getOrRegisterHistogram(
                '',
                'http_request_duration_seconds',
                'Request duration in seconds',
                ['method', 'path', 'status'],
                [0.1, 0.2, 0.3, 0.5, 0.8, 1, 1.5, 2, 5]
            );

            $histogram->observe(
                $duration,
                [
                    $request->getMethod(),
                    $request->route() ? $request->route()->uri() : $request->getPathInfo(),
                    (string) $response->getStatusCode()
                ]
            );
        } catch (\Exception $e) {
            // Silence errors in metrics to not break the app
        }

        return $response;
    }
}
