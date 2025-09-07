       IDENTIFICATION DIVISION.
       PROGRAM-ID. TRANS-READER.
       AUTHOR. Javier J. Tapia 2023

       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT TRANS-FILE ASSIGN TO 'TRANS.DAT'
               ORGANIZATION IS LINE SEQUENTIAL.

       DATA DIVISION.
       FILE SECTION.
       FD  TRANS-FILE.
       01  TRANS-RECORD-IN.
           05  TR-ACCOUNT-NUMBER       PIC X(10).
           05  TR-TRANSACTION-TYPE     PIC X(01).
           05  TR-AMOUNT-STR           PIC X(10).
           05  TR-DEST-ACCOUNT-NUMBER  PIC X(10).

       WORKING-STORAGE SECTION.
       01  WS-EOF-FLAG                 PIC X(01) VALUE 'N'.
           88  END-OF-TRANS-FILE       VALUE 'Y'.

       PROCEDURE DIVISION.
       MAIN-LOGIC.
           OPEN INPUT TRANS-FILE.
           IF NOT END-OF-TRANS-FILE
               PERFORM READ-TRANS-RECORD
           END-IF.

           PERFORM UNTIL END-OF-TRANS-FILE
               DISPLAY 'Número de Cuenta: ' TR-ACCOUNT-NUMBER
               DISPLAY 'Tipo de Transacción: ' TR-TRANSACTION-TYPE
               DISPLAY 'Monto (String): ' TR-AMOUNT-STR
               DISPLAY 'Cuenta Destino: ' TR-DEST-ACCOUNT-NUMBER
               DISPLAY '------------------------------------'
               PERFORM READ-TRANS-RECORD
           END-PERFORM.

           CLOSE TRANS-FILE.
           STOP RUN.

       READ-TRANS-RECORD.
           READ TRANS-FILE
               AT END SET END-OF-TRANS-FILE TO TRUE
           END-READ.
