<?php

namespace App\Services;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Http;
use GuzzleHttp\Client;

class GatewayService
{
    protected $monolithUrl;
    private static $guzzleClient;

    public function __construct()
    {
        $this->monolithUrl = 'http://php-monolith:8000';

        if (is_null(self::$guzzleClient)) {
            self::$guzzleClient = new Client([
                'base_uri' => $this->monolithUrl,
                'timeout' => 30,
                'http_errors' => false,
                'headers' => [
                    'Connection' => 'keep-alive'
                ],
                'curl' => [
                    CURLOPT_TCP_NODELAY => true
                ]
            ]);
        }
    }

    public function proxy(Request $request)
    {
        $url = $this->monolithUrl . '/' . $request->path();

        try {
            $method = strtoupper($request->method());
            $path = ltrim($request->path(), '/');

            $options = [
                'headers' => [],
                'query' => $request->query(),
            ];

            foreach ($request->headers->all() as $k => $v) {
                $options['headers'][$k] = is_array($v) ? implode(', ', $v) : $v;
            }
            unset($options['headers']['host']);

            if (in_array($method, ['POST', 'PUT', 'PATCH'])) {
                $options['body'] = $request->getContent();
            }

            $res = self::$guzzleClient->request($method, $path, $options);

            $status = $res->getStatusCode();
            $contentType = $res->getHeaderLine('Content-Type') ?: '';
            $body = $res->getBody()->getContents();

            if (stripos($contentType, 'text/plain') !== false || stripos($contentType, 'text') !== false || $status >= 400) {
                return response($body, $status)->header('Content-Type', $contentType ?: 'text/plain');
            }

            $decoded = null;
            try {
                $decoded = json_decode($body, true, 512, JSON_THROW_ON_ERROR);
            } catch (\Throwable $e) {
                // ignore
            }

            if (is_array($decoded)) {
                return response()->json($decoded, $status);
            }

            return response($body, $status)->header('Content-Type', $contentType ?: 'application/json');
        } catch (\Throwable $e) {
            $response = Http::withHeaders($request->headers->all())
                ->send($request->method(), $url, [
                    'json' => $request->all()
                ]);

            $contentType = $response->header('Content-Type') ?? '';
            $body = $response->body();
            try {
                $json = $response->json();
                return response()->json($json, $response->status());
            } catch (\Exception $ee) {
                return response($body, $response->status())->header('Content-Type', $contentType ?: 'application/json');
            }
        }
    }
}
