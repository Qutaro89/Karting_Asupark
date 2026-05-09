<?php
    require "conexion.php";

    // Recogemos los datos (usando null coalesce para evitar errores de índice)
    $nombre_usuario = $_POST["NOMBRE_USUARIO"] ?? null;
    $tiempo_app = $_POST["TIEMPO"] ?? null; // Viene de la App como "MM:SS.mmm"

    // 1. Validar que los campos no estén vacíos
    if (!$nombre_usuario || !$tiempo_app) {
        echo json_encode(["status" => "error", "message" => "Faltan datos"]);
        exit;
    }

    // 2. REGEXP: Validar formato MM:SS.mmm (2 dígitos, dos puntos, 2 dígitos, punto, 3 dígitos)
    if (!preg_match('/^\d{2}:\d{2}\.\d{3}$/', $tiempo_app)) {
        echo json_encode(["status" => "error", "message" => "Formato inválido. Use MM:SS.mmm"]);
        exit;
    }

    // 3. FORMATEO MANUAL para tipo TIME en MySQL (HH:MM:SS.mmm)
    $tiempo_formateado = "00:" . $tiempo_app;

    // 4. Buscar ID_USUARIO
    $sql_user = "SELECT ID_USUARIO FROM USUARIOS WHERE NOMBRE_USUARIO = ?";
    $stmt_user = $mysqli->prepare($sql_user);
    $stmt_user->bind_param("s", $nombre_usuario);
    $stmt_user->execute();
    $res_user = $stmt_user->get_result();

    if ($fila = $res_user->fetch_assoc()) {
        $id_usuario = $fila['ID_USUARIO'];

        // 5. Insertar con el formato corregido
        $sql_insert = "INSERT INTO TIEMPOS (ID_USUARIO, TIEMPO_VUELTA, FECHA_HORA_VUELTA) 
                       VALUES (?, ?, NOW())";
        
        $stmt_insert = $mysqli->prepare($sql_insert);
        $stmt_insert->bind_param("is", $id_usuario, $tiempo_formateado);

        if ($stmt_insert->execute()) {
            echo json_encode(["status" => "success", "message" => "Vuelta registrada"]);
        } else {
            echo json_encode(["status" => "error", "message" => "Error al insertar: " . $mysqli->error]);
        }
    } else {
        echo json_encode(["status" => "error", "message" => "Usuario no encontrado"]);
    }

    $mysqli->close();
?>