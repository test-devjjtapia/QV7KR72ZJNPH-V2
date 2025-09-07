# Caso Práctico: Sistema de Procesamiento de Transacciones Bancarias Diarias en Mainframe

## Módulo 3: COBOL Avanzado

Este módulo presenta el programa central del caso práctico, `TRANS_PROCESSOR.cbl`, que maneja la lógica de validación y procesamiento de transacciones, actualizando un archivo maestro de cuentas.

### Programa: TRANS_PROCESSOR.cbl

`TRANS_PROCESSOR.cbl` es el corazón del sistema. Lee el archivo de transacciones (`TRANS.DAT`), valida cada transacción y, si es válida, actualiza el saldo de la cuenta correspondiente en el archivo maestro de cuentas (`MASTER.DAT`). También maneja transferencias entre cuentas.

**Funcionalidades Clave:**
*   Lectura de transacciones.
*   Validación de formato y lógica de negocio (ej. fondos suficientes para retiros/transferencias).
*   Actualización de saldos en el archivo maestro.
*   Manejo de errores y transacciones inválidas.

### Archivo Maestro de Cuentas: MASTER.DAT (Simulado como secuencial para simplicidad)

Para este caso práctico, `MASTER.DAT` se simula como un archivo secuencial. En un entorno real de mainframe, este sería típicamente un archivo VSAM (KSDS) para permitir acceso directo por número de cuenta.

**Formato de MASTER.DAT:**
*   Posiciones 1-10: Número de Cuenta (PIC X(10))
*   Posiciones 11-20: Saldo Actual (PIC S9(08)V99, con dos decimales implícitos, con signo)

**Ejemplo de MASTER.DAT:**
```
123456789000001000000
987654321000000500000
667788990000000250000
```
