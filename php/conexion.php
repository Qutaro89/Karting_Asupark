<?php
    $db_host = getenv("DB_HOST") ?: "localhost";
    $db_user = getenv("DB_USER") ?: "root";
    $db_pass = getenv("DB_PASS") ?: "";
    $db_name = getenv("DB_NAME") ?: "asupark";

    $mysqli = new mysqli($db_host, $db_user, $db_pass, $db_name);
    if ($mysqli->connect_error) {
        die("Error de conexion;");
    };
?>