#!/bin/bash
# Definir el archivo de log
LOGFILE="script.log"
# Función de log con timestamps
leer_log_errores() {
echo "$(date '+%Y-%m-%d %H:%M:%S') - $*" >> "$LOGFILE"
}
# Redirigir stdout y stderr a la función leer_log_errores
exec > >(while IFS= read -r line; do leer_log_errores "$line"; done) 2>&1

# Comienzo del script
leer_log_errores "Inicio del script"

salida="$(analisis_web.sh)"

if [ "${#salida}" -gt 0 ]; then
  leer_log_errores 'El archivo script.log contiene información de errores'
else
  leer_log_errores 'El archivo script.log está vacío'
fi
