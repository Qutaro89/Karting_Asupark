<?php
    require "conexion.php";
    $usuario = $_POST["NOMBRE_USUARIO"];

    $stmt = $mysqli->prepare(
        "SELECT U.NOMBRE_USUARIO, U.CORREO_USUARIO, U.FECHA_ALTA,
                COUNT(T.TIEMPO_VUELTA) AS TOTAL_VUELTAS,
                MIN(T.TIEMPO_VUELTA) AS MEJOR_VUELTA
         FROM USUARIOS U
         LEFT JOIN TIEMPOS T ON U.ID_USUARIO = T.ID_USUARIO
         WHERE U.NOMBRE_USUARIO = ?
         GROUP BY U.ID_USUARIO"
    );
    $stmt->bind_param("s", $usuario);
    $stmt->execute();
    $datos = $stmt->get_result()->fetch_assoc();

    echo json_encode($datos);
?>