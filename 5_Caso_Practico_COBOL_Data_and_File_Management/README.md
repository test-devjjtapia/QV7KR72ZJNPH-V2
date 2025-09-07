# Caso Práctico: Sistema de Procesamiento de Transacciones Bancarias Diarias en Mainframe

## Módulo 5: Gestión de Datos y Archivos COBOL

Este módulo profundiza en la gestión de datos y archivos dentro del contexto del sistema de procesamiento de transacciones.

### Archivos Utilizados

*   **Archivo de Transacciones (TRANS.DAT):** Un archivo secuencial de entrada que contiene todas las transacciones del día. Es leído de principio a fin.
*   **Archivo Maestro de Cuentas (MASTER.DAT):** Para este caso práctico, se simula como un archivo secuencial. En un entorno real de mainframe, este archivo sería típicamente un **VSAM KSDS (Key-Sequenced Data Set)**. Un KSDS permite tanto el acceso secuencial como el acceso directo a registros basándose en una clave (en este caso, el número de cuenta), lo cual es crucial para la actualización eficiente de saldos.

### Estructuras de Registros (FD - File Description)

Las estructuras de los registros para `TRANS.DAT` y `MASTER.DAT` se definen en la `FILE SECTION` de los programas COBOL.

**TRANS-RECORD (para TRANS.DAT):**
```cobol
01  TRANS-RECORD.
    05  TR-ACCOUNT-NUMBER       PIC X(10).
    05  TR-TRANSACTION-TYPE     PIC X(01).
        88  TR-DEPOSIT          VALUE 'D'.
        88  TR-WITHDRAWAL       VALUE 'W'.
        88  TR-TRANSFER         VALUE 'T'.
    05  TR-AMOUNT               PIC S9(08)V99.
    05  TR-DEST-ACCOUNT-NUMBER  PIC X(10).
```

**MASTER-RECORD (para MASTER.DAT):**
```cobol
01  MASTER-RECORD.
    05  MR-ACCOUNT-NUMBER       PIC X(10).
    05  MR-ACCOUNT-BALANCE      PIC S9(08)V99.
```

### Operaciones de Archivo

Los programas COBOL utilizan sentencias como `OPEN`, `READ`, `WRITE`, `REWRITE` (para VSAM KSDS) y `CLOSE` para interactuar con estos archivos. La gestión adecuada de los archivos es vital para la integridad de los datos en un sistema bancario.
