#!/bin/bash

# Define tu clave de API de URLScan.io aquí
API_KEY="TU_CLAVE_API"

# Definir las variables para cada sitio web en un arreglo
sitios=("irsi.education" "n")

# Declarar un arreglo asociativo para almacenar los UUIDs de URLScan.io asociados a cada sitio
declare -A uuid_por_sitio

# Función para mostrar los sitios web
mostrar_sitios() {
    for sitio in "${sitios[@]}"; do
        echo "Sitio web: $sitio"
    done
}

# Función para analizar los sitios web con wafw00f
analizar_con_wafw00f() {
    for sitio in "${sitios[@]}"; do
        echo "Analizando $sitio con wafw00f..."
        wafw00f $sitio
    done
}

# Función para analizar puertos abiertos con nmap
analizar_con_nmap() {
    for sitio in "${sitios[@]}"; do
        echo "Analizando puertos abiertos en $sitio con nmap..."
        nmap -Pn $sitio
    done
}

# Función para enviar URLs a URLScan.io
enviar_a_urlscan() {
    for sitio in "${sitios[@]}"; do
        echo "Enviando $sitio a URLScan.io..."
        response=$(curl -s --request POST --url 'https://urlscan.io/api/v1/scan/' \
        --header "Content-Type: application/json" \
        --header "API-Key: $API_KEY" \
        --data "{\"url\": \"$sitio\", \"customagent\": \"US\"}")
        uuid=$(echo $response | jq -r '.uuid')
        if [ "$uuid" != "null" ]; then
            echo "UUID de URLScan.io para $sitio: $uuid"
            uuid_por_sitio["$sitio"]=$uuid
        else
            echo "Error al enviar $sitio a URLScan.io. Respuesta: $response"
        fi
    done
}

# Función para obtener resultados de URLScan.io
obtener_resultados_urlscan() {
    for sitio in "${!uuid_por_sitio[@]}"; do
        uuid=${uuid_por_sitio[$sitio]}
        echo "Obteniendo resultados de URLScan.io para $sitio (UUID: $uuid)..."
        response=$(curl -s --request GET --url "https://urlscan.io/api/v1/result/$uuid/" \
        --header "API-Key: $API_KEY")
        echo "Resultado de URLScan.io para $sitio (UUID: $uuid): $response"
    done
}

# Función para mostrar el menú de opciones
mostrar_menu() {
    echo "Menú de opciones:"
    echo "1. Mostrar sitios web"
    echo "2. Analizar sitios web con wafw00f"
    echo "3. Analizar puertos abiertos con nmap"
    echo "4. Enviar URLs a URLScan.io"
    echo "5. Obtener resultados de URLScan.io"
    echo "6. Salir"
    read -p "Elige una opción (1-6): " opcion
    case $opcion in
        1)
            clear
            mostrar_sitios
            read -p "Presiona Enter para volver al menú principal"
            clear
            mostrar_menu
            ;;
        2)
            clear
            analizar_con_wafw00f
            read -p "Presiona Enter para volver al menú principal"
            clear
            mostrar_menu
            ;;
        3)
            clear
            analizar_con_nmap
            read -p "Presiona Enter para volver al menú principal"
            clear
            mostrar_menu
            ;;
        4)
            clear
            enviar_a_urlscan
            read -p "Presiona Enter para volver al menú principal"
            clear
            mostrar_menu
            ;;
        5)
            clear
            obtener_resultados_urlscan
            read -p "Presiona Enter para volver al menú principal"
            clear
            mostrar_menu
            ;;
        6)
            echo "Saliendo del script..."
            exit 0
            ;;
        *)
            echo "Opción no válida. Por favor, elige una opción del 1 al 6."
            mostrar_menu
            ;;
    esac
}

# Iniciar el script mostrando el menú principal
mostrar_menu
