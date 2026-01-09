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
        $this->monolithUrl = env('MONOLITH_URL', 'http://php-monolith:8000');

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
        $method = strtoupper($request->method());
        $path = ltrim($request->path(), '/');

        try {
            $options = [
                'headers' => $request->headers->all(),
                'query' => $request->query(),
                'http_errors' => false,
            ];

            unset($options['headers']['host']);
            unset($options['headers']['content-length']);

            if (in_array($method, ['POST', 'PUT', 'PATCH'])) {
                $options['body'] = $request->getContent();
            }

            $res = self::$guzzleClient->request($method, $path, $options);

            $headers = $res->getHeaders();
            $contentType = $res->getHeaderLine('Content-Type');

            return response($res->getBody()->getContents(), $res->getStatusCode())
                ->withHeaders($headers);

        } catch (\Throwable $e) {
            return response()->json([
                'error' => 'Gateway Error',
                'message' => $e->getMessage()
            ], 502);
        }
    }
}
