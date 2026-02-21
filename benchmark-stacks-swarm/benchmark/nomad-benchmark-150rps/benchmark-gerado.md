# Benchmark Report
Generated on 2026-02-12T17:40:50.813930

## Nomad Metrics - Infraestrutura

| Date | Start Time | End Time | Stack | Nomad Inst | Total - CPU Alloc | Total - CPU Avg | Total - CPU Max | Total - Mem Alloc (MiB) | Total - Mem Avg (MiB) | Total - Mem Max (MiB) |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| 11/02/2026 | 14:11:54 | 14:21:54 | Rust Axum | 1 | 0,50 core | 0,50 core | 0,53 core | 256 MiB | 3 MiB | 4 MiB |
| 11/02/2026 | 11:22:40 | 11:32:40 | Node.js | 1 | 1,50 core | 1,36 core | 1,52 core | 256 MiB | 209 MiB | 255 MiB |
| 11/02/2026 | 14:38:43 | 14:48:43 | Java Quarkus | 1 | 1,50 core | 0,64 core | 1,18 core | 512 MiB | 189 MiB | 196 MiB |
| 11/02/2026 | 11:45:13 | 11:55:13 | .NET Core | 1 | 1,50 core | 1,46 core | 1,60 core | 512 MiB | 192 MiB | 199 MiB |
| 11/02/2026 | 12:45:59 | 12:55:59 | Golang Gin | 1 | 1,50 core | 0,99 core | 1,68 core | 512 MiB | 40 MiB | 44 MiB |
| 11/02/2026 | 09:56:08 | 10:06:08 | Java MVC VT | 1 | 1,50 core | 0,99 core | 1,54 core | 512 MiB | 277 MiB | 283 MiB |
| 11/02/2026 | 10:37:30 | 10:47:30 | Java WebFlux | 1 | 2,50 core | 1,44 core | 1,59 core | 256 MiB | 238 MiB | 240 MiB |
| 11/02/2026 | 13:54:57 | 14:04:57 | Python | 2 | 3,00 core | 2,20 core | 2,48 core | 1024 MiB | 437 MiB | 439 MiB |
| 11/02/2026 | 13:33:13 | 13:43:13 | PHP Octane | 2 | 4,50 core | 2,80 core | 4,16 core | 2560 MiB | 1002 MiB | 1007 MiB |
| 11/02/2026 | 13:10:31 | 13:20:31 | PHP FPM | 6 | 13,50 core | 5,10 core | 6,44 core | 3072 MiB | 442 MiB | 445 MiB |

## K6 Metrics

| Stack | K6 Reqs | K6 Erros | K6 RPS Avg | K6 P95 (ms) | K6 Avg (ms) | Success % | Threshold |
| --- | --- | --- | --- | --- | --- | --- | --- |
| Rust Axum | 89464 | 25 | 149,11 | 28,87 | 10,61 | 99,97% | ✅ |
| Node.js | 89932 | 33 | 149,89 | 51,49 | 39,53 | 99,96% | ✅ |
| Java Quarkus | 89919 | 40 | 149,87 | 23,24 | 9,52 | 99,95% | ✅ |
| .NET Core | 89847 | 41 | 149,75 | 88,97 | 23,12 | 99,95% | ✅ |
| Golang Gin | 89907 | 41 | 149,85 | 34,99 | 12,14 | 99,95% | ✅ |
| Java MVC VT | 89507 | 8 | 149,18 | 26,66 | 9,74 | 99,99% | ✅ |
| Java WebFlux | 89946 | 16 | 149,91 | 16,31 | 9,34 | 99,98% | ✅ |
| Python | 89423 | 40 | 149,04 | 45,61 | 15,76 | 99,95% | ✅ |
| PHP Octane | 89473 | 21 | 149,12 | 115,37 | 29,90 | 99,98% | ✅ |
| PHP FPM | 89232 | 173 | 148,72 | 124,31 | 32,31 | 99,81% | ✅ |

## Traefik Metrics

| Stack | Traefik Reqs | Traefik Erros | Traefik RPS Avg | Traefik P95 (ms) | Traefik Avg (ms) | Success % | Threshold |
| --- | --- | --- | --- | --- | --- | --- | --- |
| Rust Axum | 89952 | 0 | 149,92 | 18,66 | 4,62 | 100,00% | ✅ |
| Node.js | 89934 | 0 | 149,89 | 14,26 | 7,17 | 100,00% | ✅ |
| Java Quarkus | 89929 | 0 | 149,88 | 9,66 | 3,31 | 100,00% | ✅ |
| .NET Core | 89928 | 0 | 149,88 | 79,25 | 17,78 | 100,00% | ✅ |
| Golang Gin | 89917 | 0 | 149,86 | 9,92 | 5,82 | 100,00% | ✅ |
| Java MVC VT | 89985 | 0 | 149,98 | 9,83 | 4,86 | 100,00% | ✅ |
| Java WebFlux | 89970 | 0 | 149,95 | 9,67 | 4,44 | 100,00% | ✅ |
| Python | 89907 | 0 | 149,85 | 26,85 | 9,86 | 100,00% | ✅ |
| PHP Octane | 89962 | 0 | 149,94 | 63,70 | 12,78 | 100,00% | ✅ |
| PHP FPM | 89661 | 0 | 149,44 | 69,70 | 18,38 | 100,00% | ✅ |

