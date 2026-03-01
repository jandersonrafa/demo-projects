# Benchmark Report
Generated on 2026-03-01T18:44:11.862945

## Swarm Metrics - Infraestrutura

| Date | Start Time | End Time | Stack | Swarm Inst | Total - CPU Alloc | Total - CPU Avg | Total - CPU Max | Total - Mem Alloc (MiB) | Total - Mem Avg (MiB) | Total - Mem Max (MiB) |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| 22/02/2026 | 21:23:14 | 21:33:14 | Rust Axum | 2 | 0,52 core | 0,39 core | 0,52 core | 512 MiB | 16 MiB | 17 MiB |
| 22/02/2026 | 16:36:12 | 16:46:12 | Java Quarkus | 2 | 1,04 core | 0,59 core | 0,82 core | 512 MiB | 471 MiB | 502 MiB |
| 22/02/2026 | 15:10:43 | 15:20:43 | Java MVC VT | 2 | 1,04 core | 0,74 core | 0,98 core | 512 MiB | 504 MiB | 508 MiB |
| 22/02/2026 | 15:53:33 | 16:03:33 | Java WebFlux | 2 | 2,00 core | 1,35 core | 1,94 core | 512 MiB | 479 MiB | 480 MiB |
| 22/02/2026 | 19:08:41 | 19:18:41 | Node.js (Fastify) | 2 | 2,00 core | 1,18 core | 1,64 core | 512 MiB | 223 MiB | 280 MiB |
| 23/02/2026 | 16:13:26 | 16:23:26 | Java MVC Without VT | 2 | 2,00 core | 0,87 core | 1,21 core | 512 MiB | 509 MiB | 511 MiB |
| 22/02/2026 | 18:24:57 | 18:34:57 | Node.js (Express) | 2 | 3,00 core | 1,41 core | 1,92 core | 512 MiB | 232 MiB | 271 MiB |
| 22/02/2026 | 17:17:44 | 17:27:44 | .NET Core | 2 | 3,00 core | 1,70 core | 2,38 core | 512 MiB | 187 MiB | 202 MiB |
| 22/02/2026 | 20:32:33 | 20:42:33 | Golang Gin | 2 | 4,00 core | 1,10 core | 1,69 core | 512 MiB | 32 MiB | 40 MiB |
| 22/02/2026 | 23:43:13 | 23:53:13 | Python | 3 | 6,00 core | 3,48 core | 5,27 core | 1536 MiB | 749 MiB | 750 MiB |
| 23/02/2026 | 15:23:04 | 15:33:04 | PHP Octane | 8 | 8,00 core | 3,44 core | 4,98 core | 6048 MiB | 2957 MiB | 2960 MiB |
| 01/03/2026 | 16:09:55 | 16:19:55 | PHP FPM | 24 | 24,00 core | 8,84 core | 13,02 core | 18144 MiB | 936 MiB | 939 MiB |

## K6 Metrics

| Stack | K6 Reqs | K6 Erros | K6 RPS Avg | K6 P95 (ms) | K6 Avg (ms) | Success % | Threshold |
| --- | --- | --- | --- | --- | --- | --- | --- |
| Rust Axum | 434776 | 1579 | 724,63 | 46,25 | 20,62 | 99,64% | ✅ |
| Java Quarkus | 435884 | 883 | 726,47 | 42,46 | 20,42 | 99,80% | ✅ |
| Java MVC VT | 437142 | 1207 | 728,57 | 138,25 | 40,95 | 99,72% | ✅ |
| Java WebFlux | 436506 | 1159 | 727,51 | 137,05 | 36,86 | 99,74% | ✅ |
| Node.js (Fastify) | 433803 | 1887 | 723,01 | 182,56 | 40,18 | 99,57% | ✅ |
| Java MVC Without VT | 435453 | 2053 | 725,76 | 42,81 | 21,99 | 99,53% | ✅ |
| Node.js (Express) | 435996 | 785 | 726,66 | 62,83 | 21,69 | 99,82% | ✅ |
| .NET Core | 435338 | 2003 | 725,56 | 136,52 | 35,91 | 99,54% | ✅ |
| Golang Gin | 438664 | 244 | 731,11 | 23,82 | 14,10 | 99,94% | ✅ |
| Python | 435182 | 1352 | 725,30 | 65,55 | 27,45 | 99,69% | ✅ |
| PHP Octane | 435678 | 1011 | 726,13 | 117,40 | 38,42 | 99,77% | ✅ |
| PHP FPM | 0 | 0 | 0,00 | 0,00 | 0,00 | 0,00% | ❌ |

## Traefik Metrics

| Stack | Traefik Reqs | Traefik Erros | Traefik RPS Avg | Traefik P95 (ms) | Traefik Avg (ms) | Success % | Threshold |
| --- | --- | --- | --- | --- | --- | --- | --- |
| Rust Axum | 436632 | 0 | 727,72 | 36,45 | 7,85 | 100,00% | ✅ |
| Java Quarkus | 440005 | 0 | 733,34 | 9,84 | 7,00 | 100,00% | ✅ |
| Java MVC VT | 439113 | 0 | 731,86 | 20,30 | 7,64 | 100,00% | ✅ |
| Java WebFlux | 438552 | 0 | 730,92 | 71,12 | 21,08 | 100,00% | ✅ |
| Node.js (Fastify) | 434111 | 0 | 723,52 | 44,17 | 11,63 | 100,00% | ✅ |
| Java MVC Without VT | 438403 | 0 | 730,67 | 9,95 | 4,76 | 100,00% | ✅ |
| Node.js (Express) | 440091 | 2 | 733,49 | 48,82 | 14,33 | 100,00% | ✅ |
| .NET Core | 436227 | 0 | 727,05 | 9,77 | 4,68 | 100,00% | ✅ |
| Golang Gin | 440627 | 0 | 734,38 | 11,99 | 4,75 | 100,00% | ✅ |
| Python | 438275 | 3 | 730,46 | 37,29 | 12,60 | 100,00% | ✅ |
| PHP Octane | 437038 | 0 | 728,40 | 46,57 | 15,99 | 100,00% | ✅ |
| PHP FPM | 0 | 0 | 0,00 | 0,00 | 0,00 | 0,00% | ❌ |

