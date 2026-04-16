<?php

    require "conexion.php";
    $usuario = $_POST["NOMBRE_USUARIO"];
    $contra_usuario = $_POST["CONTRA_USUARIO"];

    $sql="SELECT * FROM USUARIOS WHERE NOMBRE_USUARIO='$usuario' AND CONTRA_USUARIO='$contra_usuario'";

     if($query->num_rows > 0) {
        echo "CORRECTO";
    } else {
        echo "ERROR";
    }

?>