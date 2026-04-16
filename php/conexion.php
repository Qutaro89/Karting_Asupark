<?php
    $mysqli = new mysqli("localhost", "root", "", "asupark");
    if ($mysqli->connect_error) {
        die("Error de conexion;")
    };
?>