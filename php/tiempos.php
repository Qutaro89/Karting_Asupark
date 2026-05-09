<?php
    require "conexion.php";

    $tipo = $_POST["TIPO"]; // "HOY", "MES", "ANUAL" o "GLOBAL"

    if ($tipo == "HOY") {
        $sql = "SELECT U.NOMBRE_USUARIO, T.TIEMPO_VUELTA
                FROM TIEMPOS T
                JOIN USUARIOS U ON T.ID_USUARIO = U.ID_USUARIO
                WHERE DATE(T.FECHA_HORA_VUELTA) = CURDATE()
                
                ORDER BY T.TIEMPO_VUELTA ASC";
    } else if($tipo == "MES") {
        $sql = "SELECT U.NOMBRE_USUARIO, T.TIEMPO_VUELTA
                FROM TIEMPOS T
                JOIN USUARIOS U ON T.ID_USUARIO = U.ID_USUARIO
                WHERE MONTH(T.FECHA_HORA_VUELTA) = MONTH(CURDATE()) AND YEAR(T.FECHA_HORA_VUELTA) = YEAR(CURDATE())
                ORDER BY T.TIEMPO_VUELTA ASC";
     }else if($tipo == "ANUAL") {
        $sql = "SELECT U.NOMBRE_USUARIO, T.TIEMPO_VUELTA
                FROM TIEMPOS T
                JOIN USUARIOS U ON T.ID_USUARIO = U.ID_USUARIO
                WHERE YEAR(T.FECHA_HORA_VUELTA) = YEAR(CURDATE())
                
                ORDER BY T.TIEMPO_VUELTA ASC";
     }else{
        $sql = "SELECT U.NOMBRE_USUARIO, MIN(T.TIEMPO_VUELTA) AS TIEMPO_VUELTA
                FROM TIEMPOS T
                JOIN USUARIOS U ON T.ID_USUARIO = U.ID_USUARIO
                GROUP BY U.ID_USUARIO, U.NOMBRE_USUARIO
                ORDER BY TIEMPO_VUELTA ASC";
    }

    $query = $mysqli->query($sql);

    $tiempos = [];
    while ($fila = $query->fetch_assoc()) {
        $tiempos[] = $fila;
    }

    echo json_encode($tiempos);
?>