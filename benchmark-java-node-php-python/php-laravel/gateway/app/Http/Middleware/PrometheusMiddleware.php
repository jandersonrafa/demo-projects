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

        // ignora endpoints internos
        if (
            $request->is('metrics') ||
            $request->is('prometheus') ||
            $request->is('up') ||
            $request->is('health')
        ) {
            return $response;
        }

        try {
            $adapter = new APCng();
            $registry = new CollectorRegistry($adapter);

            $method = $request->getMethod();
            $path = $request->route()
                ? $request->route()->uri()
                : $request->getPathInfo();
            $status = (string) $response->getStatusCode();

            /**
             * TOTAL DE REQUESTS
             */
            $requestsCounter = $registry->getOrRegisterCounter(
                'app',
                'http_requests_total',
                'Total number of HTTP requests',
                ['method', 'path', 'status']
            );

            $requestsCounter->inc([$method, $path, $status]);

            /**
             * CONTADOR DE ERROS (4xx + 5xx)
             */
            if ((int) $status >= 400) {
                $errorsCounter = $registry->getOrRegisterCounter(
                    'app',
                    'http_requests_errors_total',
                    'Total number of HTTP error responses',
                    ['method', 'path', 'status']
                );

                $errorsCounter->inc([$method, $path, $status]);
            }

            /**
             * HISTOGRAMA DE DURAÇÃO
             */
            $histogram = $registry->getOrRegisterHistogram(
                'app',
                'http_request_duration_seconds',
                'Request duration in seconds',
                ['method', 'path', 'status'],
                [0.001, 0.005, 0.01, 0.025, 0.05, 0.075, 0.1, 0.25, 0.5, 0.75, 1, 2.5, 5, 7.5, 10]
            );

            $histogram->observe($duration, [$method, $path, $status]);
        } catch (\Throwable $e) {
            // nunca quebrar a app por causa de métricas
        }

        return $response;
    }
}