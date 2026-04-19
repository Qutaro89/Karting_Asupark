<?php
    require "conexion.php";

    $usuario = $_POST["NOMBRE_USUARIO"];
    $correo  = $_POST["CORREO_USUARIO"];
    $contra  = $_POST["CONTRA_USUARIO"];

    // Comprobar si el usuario o correo ya existen
    $stmt = $mysqli->prepare("SELECT ID_USUARIO FROM USUARIOS WHERE NOMBRE_USUARIO = ? OR CORREO_USUARIO = ?");
    $stmt->bind_param("ss", $usuario, $correo);
    $stmt->execute();
    $stmt->get_result()->num_rows > 0
        ? die("EXISTE")
        : null;

    // Insertar nuevo usuario
    $stmt = $mysqli->prepare("INSERT INTO USUARIOS (NOMBRE_USUARIO, CORREO_USUARIO, FECHA_ALTA, CONTRA_USUARIO) VALUES (?, ?, CURDATE(), ?)");
    $stmt->bind_param("sss", $usuario, $correo, $contra);

    if ($stmt->execute()) {
        echo "CORRECTO";
    } else {
        echo "ERROR";
    }
?>