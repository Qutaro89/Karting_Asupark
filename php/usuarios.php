<?php
    require "conexion.php";
    $usuario = $_POST["NOMBRE_USUARIO"];
    $contra_usuario = $_POST["CONTRA_USUARIO"];

    $stmt = $mysqli->prepare("SELECT * FROM USUARIOS WHERE NOMBRE_USUARIO = ? AND CONTRA_USUARIO = ?");
    $stmt->bind_param("ss", $usuario, $contra_usuario);
    $stmt->execute();
    $query = $stmt->get_result();

    if ($query->num_rows > 0) {
        echo "CORRECTO";
    } else {
        echo "ERROR";
    }
?>