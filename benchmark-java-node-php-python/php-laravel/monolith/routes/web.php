<?php

use Illuminate\Support\Facades\Route;

Route::get('/', function () {
    return view('welcome');
});

Route::get('/metrics', function () {
    $adapter = new \Prometheus\Storage\APCng();
    $registry = new \Prometheus\CollectorRegistry($adapter);

    $registry->getOrRegisterGauge(
        '',
        'php_memory_peak_usage_bytes',
        'Peak memory usage in bytes'
    )->set(memory_get_peak_usage(true));

    $renderer = new \Prometheus\RenderTextFormat();
    return response($renderer->render($registry->getMetricFamilySamples()))
        ->header('Content-Type', \Prometheus\RenderTextFormat::MIME_TYPE);
});
