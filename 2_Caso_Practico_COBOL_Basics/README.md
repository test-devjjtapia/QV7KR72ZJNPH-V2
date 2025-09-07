# Caso Práctico: Sistema de Procesamiento de Transacciones Bancarias Diarias en Mainframe

## Módulo 2: Fundamentos de COBOL

Este módulo introduce los conceptos básicos de COBOL a través de un programa simple que lee y muestra el contenido de un archivo de transacciones.

### Programa: TRANS_READER.cbl

Este programa COBOL (`TRANS_READER.cbl`) demuestra cómo leer un archivo secuencial (`TRANS.DAT`) y mostrar cada registro en la consola. Es un ejemplo fundamental para entender la estructura de un programa COBOL, la definición de archivos y la manipulación básica de datos.

### Archivo de Datos de Ejemplo: TRANS.DAT

El archivo `TRANS.DAT` contiene registros de transacciones simuladas. Cada línea representa una transacción con un formato fijo.

**Formato de TRANS.DAT:**
*   Posiciones 1-10: Número de Cuenta (PIC X(10))
*   Posiciones 11-11: Tipo de Transacción (D=Depósito, W=Retiro, T=Transferencia) (PIC X(1))
*   Posiciones 12-21: Monto (PIC 9(08)V99, con dos decimales implícitos)
*   Posiciones 22-31: Número de Cuenta Destino (solo para transferencias, PIC X(10))

**Ejemplo de TRANS.DAT:**
```
1234567890D00001000000
9876543210W00000500000
1122334455T000002500006677889900
```
