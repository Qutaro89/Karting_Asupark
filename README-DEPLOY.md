# Despliegue con Docker (backend + base de datos)

Esto levanta el backend PHP, la base de datos y phpMyAdmin en contenedores Docker, accesibles desde cualquier dispositivo conectado al mismo **tailnet de Tailscale**.

## Requisitos

- [Docker Desktop](https://www.docker.com/products/docker-desktop/) instalado y en ejecución en tu equipo.
- [Tailscale](https://tailscale.com/) instalado y con sesión iniciada en tu equipo y en el dispositivo del cliente (móvil/tablet).

## Arrancar el stack

Desde la raíz del repositorio:

```bash
docker compose up -d --build
```

Esto crea y levanta:

| Contenedor  | Descripción                                | URL                                  |
|-------------|--------------------------------------------|--------------------------------------|
| `web`       | Apache + PHP 8.2 + endpoints de la API      | `http://<host-tailscale>/asupark/`   |
| `db`        | MariaDB 10.6 con la BD `asupark` cargada    | interno (solo accesible dentro de Docker) |
| `phpmyadmin`| Administrador web de la BD                  | `http://<host-tailscale>:8081/`      |

La primera vez importa automáticamente `base_de_datos/asupark.sql`. Los datos se guardan en el volumen `db_data`, así que sobreviven a `docker compose down` y a reinicios.

Parar el stack:

```bash
docker compose down          # mantiene los datos
docker compose down -v       # borra también los datos de la BD
```

## Credenciales

Por defecto están definidas en `docker-compose.yml` (variables `DB_PASS`, `DB_ROOT_PASS`). Puedes sobreescribirlas con un archivo `.env` en la raíz:

```env
DB_PASS=micontraseña
DB_ROOT_PASS=otracontraseña
```

Los endpoints PHP leen las credenciales de las variables de entorno `DB_HOST`, `DB_USER`, `DB_PASS` y `DB_NAME` (`php/conexion.php`). Si se ejecutan fuera de Docker conservan los valores por defecto de XAMPP.

## Configurar la app Flutter

1. Averigua el hostname o IP de tu equipo en Tailscale:

   ```bash
   tailscale status
   tailscale ip -4
   ```

2. Edita `proyecto/asupark/lib/config.dart` y sustituye `apiBaseUrl` por el hostname (recomendado) o la IP de tu tailnet:

   ```dart
   const String apiBaseUrl = "http://mi-maquina.tailXXXX.ts.net/asupark";
   ```

3. Compila la app para el cliente:

   ```bash
   cd proyecto/asupark
   flutter build apk --release
   ```

4. Instala el APK (`build/app/outputs/flutter-apk/app-release.apk`) en el dispositivo del cliente, que debe tener **Tailscale instalado y conectado al mismo tailnet** para poder alcanzar tu equipo.

> Nota: `lib/config.dart` es el único lugar donde se configura la URL. Los cambios de red (permiso `INTERNET` y tráfico HTTP sin cifrar) ya están aplicados en `AndroidManifest.xml` e `Info.plist` para que la app funcione con HTTP plano sobre Tailscale.

## Comprobación rápida

Con el stack levantado, abre en el navegador:

- `http://<host-tailscale>/asupark/tiempos.php` (devolverá JSON, aunque requerirá POST).
- `http://<host-tailscale>:8081/` (phpMyAdmin, usuario `root` y `DB_ROOT_PASS`).

## Puertos

- `80` → API PHP. Si tienes XAMPP u otro servicio en el puerto 80, cambia `"80:80"` en `docker-compose.yml` por otro puerto (p. ej. `"8080:80"`) y actualiza `apiBaseUrl` en `lib/config.dart`.
- `8081` → phpMyAdmin.