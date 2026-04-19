<?php
    require "conexion.php";
    $usuario = $_POST["NOMBRE_USUARIO"];

    $stmt = $mysqli->prepare(
        "SELECT T.TIEMPO_VUELTA, T.FECHA_HORA_VUELTA
         FROM TIEMPOS T
         JOIN USUARIOS U ON T.ID_USUARIO = U.ID_USUARIO
         WHERE U.NOMBRE_USUARIO = ?
         ORDER BY T.TIEMPO_VUELTA ASC"
    );
    $stmt->bind_param("s", $usuario);
    $stmt->execute();
    $query = $stmt->get_result();

    $vueltas = [];
    while ($fila = $query->fetch_assoc()) {
        $vueltas[] = $fila;
    }

    echo json_encode($vueltas);
?>