#!/bin/bash

echo "Actualizando paquetes..."
sudo apt update && sudo apt -y install haproxy

echo "Habilitando HAProxy..."
sudo systemctl enable haproxy

echo "Configurando HAProxy..."
sudo tee -a /etc/haproxy/haproxy.cfg <<EOF
frontend http_front
    bind *:80
    default_backend web_servers
    errorfile 503 /etc/haproxy/errors/503.http 

backend web_servers
    balance roundrobin
    
    server server1-3000 192.168.100.11:3000 check
    server server1-3001 192.168.100.11:3001 check
    server server1-3002 192.168.100.11:3002 check

    server server2-3003 192.168.100.12:3003 check
    server server2-3004 192.168.100.12:3004 check
    server server2-3005 192.168.100.12:3005 check

frontend stats
    bind *:8080
    stats enable
    stats uri /haproxy?stats
    stats auth admin:admin
EOF

echo "Creando carpeta de errores para haproxy..."
mkdir /etc/haproxy/errors

echo "Creando archivo de errores personalizada..."
touch /etc/haproxy/errors/503.http

echo "Creando página personalizada para error 503..."
sudo tee -a /etc/haproxy/errors/503.http <<EOF
HTTP/1.0 503 Service Unavailable
Cache-Control: no-cache
Connection: close
Content-Type: text/html

<!DOCTYPE html>
<html lang="es">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Servicio No Disponible</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #1a1a1a;
            margin: 0;
            padding: 0;
            display: flex;
            flex-direction: column;
            justify-content: center;
            align-items: center;
            height: 100vh;
            color: white;
        }

        main {
            background-color: #292929;
            min-width: 600px;
            padding: 4em;
            margin: 2em;
            border-radius: 10px;
            border: 2px solid rgba(122, 122, 122, 0.4);
            box-shadow: 0 0 15px rgba(255, 255, 255, 0.1);
            text-align: center;
        }

        h1 {
            font-size: 2.3em;
            margin-bottom: 1em;
            margin-top: 0.5em;
            color: white;
            font-style: italic;
        }

        p {
            color: white;
            font-size: 1.2em;
            margin-bottom: 1em;
        }

        .icono {
            display: inline-block;
            font-size: 3em;
            margin-bottom: 10px;
        }

        section {
            margin-top: 2em;
            display: flex;
        }

        @keyframes loading {
            0% {
                width: 0%;
            }

            25% {
                width: 25%;
            }

            50% {
                width: 50%;
            }

            75% {
                width: 75%;
            }

            100% {
                width: 100%;
            }
        }

        .carga-div {
            width: 100%;
            max-width: 250px;
            height: 0.8em;
            background: #444;
            border-radius: 5px;
            overflow: hidden;
            margin: 1em auto;
        }

        .carga-bar {
            height: 100%;
            background: linear-gradient(90deg, #ff4757, #ff6b81);
            width: 0%;
            border-radius: 5px;
            animation: loading 6s infinite;
        }
    </style>
</head>

<body>
    <main>
        <div class="icono">🚫</div>
        <h1>¡Oops! Servicio No Disponible</h1>
        <p>Estamos experimentando problemas con nuestros servicios disponibles.</p>
        <p>Por favor, recarga la página en unos minutos.</p>
        <p>Agradecemos tu paciencia y espera 🚀</p>

        <section>
            <div class="carga-div">
                <div class="carga-bar"></div>
            </div>
        </section>
    </main>
</body>

</html>
EOF

echo "Reiniciando HAProxy para aplicar cambios..."
systemctl restart haproxy

echo "Configuración de HAProxy completada con éxito."





