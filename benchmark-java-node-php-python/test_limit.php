<?php
try {
    $dsn = "pgsql:host=pgbouncer;port=6432;dbname=benchmark;sslmode=prefer";
    $pdo = new PDO($dsn, "postgres", "postgres");
    echo "Connected.\n";

    $pdo->setAttribute(PDO::ATTR_CASE, PDO::CASE_NATURAL);
    echo "Set CASE_NATURAL.\n";

    $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
    echo "Set ERRMODE_EXCEPTION.\n";

    $pdo->setAttribute(PDO::ATTR_ORACLE_NULLS, PDO::NULL_NATURAL);
    echo "Set NULL_NATURAL.\n";

    $pdo->setAttribute(PDO::ATTR_STRINGIFY_FETCHES, false);
    echo "Set STRINGIFY_FETCHES.\n";

    // This is valid only if emulated prepares is enabled? Or checks support?
    $pdo->setAttribute(PDO::ATTR_EMULATE_PREPARES, true);
    echo "Set EMULATE_PREPARES.\n";

    echo "All attributes set successfully.\n";

} catch (Exception $e) {
    echo "Error: " . $e->getMessage() . "\n";
}
