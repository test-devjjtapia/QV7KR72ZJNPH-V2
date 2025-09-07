# Caso Práctico: Sistema de Procesamiento de Transacciones Bancarias Diarias en Mainframe

## Módulo 6: Pruebas y Depuración Básicas de COBOL

Este módulo aborda la importancia de las pruebas y la depuración en el desarrollo de programas COBOL, utilizando el `TRANS_PROCESSOR.cbl` como ejemplo.

### Plan de Pruebas Básico

Un plan de pruebas para `TRANS_PROCESSOR.cbl` incluiría:

1.  **Pruebas de Unidades:**
    *   **Transacciones Válidas:** Probar depósitos, retiros y transferencias con datos correctos.
    *   **Transacciones Inválidas:**
        *   Número de cuenta inexistente.
        *   Monto negativo o cero.
        *   Tipo de transacción inválido.
        *   Retiro/transferencia con fondos insuficientes.
        *   Transferencia sin cuenta destino.
    *   **Casos Extremos:** Montos máximos/mínimos, archivos vacíos.

2.  **Datos de Prueba:** Creación de archivos `TRANS.DAT` y `MASTER.DAT` específicos para cada escenario de prueba.

### Técnicas de Depuración

En un entorno mainframe, las técnicas de depuración incluyen:

*   **Sentencias `DISPLAY`:** Insertar sentencias `DISPLAY` en el código COBOL para mostrar el valor de las variables en puntos clave de la ejecución.
*   **Herramientas de Depuración:** Uso de herramientas de depuración interactivas (como IBM Debug Tool) que permiten establecer puntos de interrupción, examinar variables y ejecutar el código paso a paso.
*   **Análisis de Salida:** Revisión de los archivos de salida (ej. informes de errores, archivos de log) generados por el programa.
