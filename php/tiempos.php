<?php
    require "conexion.php";

    $tipo = $_POST["TIPO"]; // "HOY" o "GLOBAL"

    if ($tipo == "HOY") {
        $sql = "SELECT U.NOMBRE_USUARIO, T.TIEMPO_VUELTA
                FROM TIEMPOS T
                JOIN USUARIOS U ON T.ID_USUARIO = U.ID_USUARIO
                WHERE DATE(T.FECHA_HORA_VUELTA) = CURDATE()
                GROUP BY T.ID_USUARIO
                ORDER BY T.TIEMPO_VUELTA ASC";
    } else {
        $sql = "SELECT U.NOMBRE_USUARIO, T.TIEMPO_VUELTA
                FROM TIEMPOS T
                JOIN USUARIOS U ON T.ID_USUARIO = U.ID_USUARIO
                GROUP BY T.ID_USUARIO
                ORDER BY T.TIEMPO_VUELTA ASC";
    }

    $query = $mysqli->query($sql);

    $tiempos = [];
    while ($fila = $query->fetch_assoc()) {
        $tiempos[] = $fila;
    }

    echo json_encode($tiempos);
?>