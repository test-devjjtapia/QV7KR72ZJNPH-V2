       IDENTIFICATION DIVISION.
       PROGRAM-ID. TRANS-PROCESSOR.
       AUTHOR. Javier J. Tapia 2023.

       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT TRANS-FILE ASSIGN TO 'TRANS.DAT'
               ORGANIZATION IS LINE SEQUENTIAL.
           SELECT MASTER-FILE ASSIGN TO 'MASTER.DAT'
               ORGANIZATION IS LINE SEQUENTIAL.
           SELECT ERROR-REPORT-FILE ASSIGN TO 'ERROR.RPT'
               ORGANIZATION IS LINE SEQUENTIAL.

       DATA DIVISION.
       FILE SECTION.
       FD  TRANS-FILE.
       01  TRANS-RECORD-IN.
           05  TR-ACCOUNT-NUMBER       PIC X(10).
           05  TR-TRANSACTION-TYPE     PIC X(01).
               88  TR-DEPOSIT          VALUE 'D'.
               88  TR-WITHDRAWAL       VALUE 'W'.
               88  TR-TRANSFER         VALUE 'T'.
           05  TR-AMOUNT-STR           PIC X(10).
           05  TR-DEST-ACCOUNT-NUMBER  PIC X(10).

       FD  MASTER-FILE.
       01  MASTER-RECORD-IN.
           05  MR-ACCOUNT-NUMBER       PIC X(10).
           05  MR-ACCOUNT-BALANCE-STR  PIC X(10).

       FD  ERROR-REPORT-FILE.
       01  ERROR-RECORD-OUT            PIC X(80).

       WORKING-STORAGE SECTION.
       01  WS-EOF-TRANS-FILE           PIC X(01) VALUE 'N'.
           88  END-OF-TRANS-FILE       VALUE 'Y'.
       01  WS-EOF-MASTER-FILE          PIC X(01) VALUE 'N'.
           88  END-OF-MASTER-FILE      VALUE 'Y'.

       01  WS-TRANS-DATA.
           05  WS-TRANS-ACCOUNT-NUMBER     PIC X(10).
           05  WS-TRANS-TYPE               PIC X(01).
           05  WS-TRANS-AMOUNT             PIC S9(08)V99.
           05  WS-TRANS-DEST-ACCOUNT       PIC X(10).

       01  WS-MASTER-DATA.
           05  WS-MASTER-ACCOUNT-NUMBER    PIC X(10).
           05  WS-MASTER-ACCOUNT-BALANCE   PIC S9(08)V99.

       01  WS-ERROR-MESSAGE            PIC X(80).

       PROCEDURE DIVISION.
       MAIN-LOGIC.
           PERFORM 1000-INITIALIZE-SYSTEM.
           PERFORM 2000-PROCESS-TRANSACTIONS
               UNTIL END-OF-TRANS-FILE.
           PERFORM 3000-TERMINATE-SYSTEM.
           STOP RUN.

       1000-INITIALIZE-SYSTEM.
           OPEN INPUT TRANS-FILE
                I-O MASTER-FILE
                OUTPUT ERROR-REPORT-FILE.
           IF NOT END-OF-TRANS-FILE
               PERFORM 1100-READ-TRANS-RECORD
           END-IF.

       1100-READ-TRANS-RECORD.
           READ TRANS-FILE
               AT END SET END-OF-TRANS-FILE TO TRUE
           END-READ.
           IF NOT END-OF-TRANS-FILE
               MOVE TR-ACCOUNT-NUMBER      TO WS-TRANS-ACCOUNT-NUMBER
               MOVE TR-TRANSACTION-TYPE    TO WS-TRANS-TYPE
               UNSTRING TR-AMOUNT-STR DELIMITED BY ALL SPACE
                   INTO WS-TRANS-AMOUNT
               MOVE TR-DEST-ACCOUNT-NUMBER TO WS-TRANS-DEST-ACCOUNT
           END-IF.

       2000-PROCESS-TRANSACTIONS.
           PERFORM 2100-VALIDATE-TRANSACTION.
           IF WS-ERROR-MESSAGE = SPACES
               PERFORM 2200-UPDATE-MASTER-FILE
           ELSE
               PERFORM 2300-WRITE-ERROR-REPORT
           END-IF.
           PERFORM 1100-READ-TRANS-RECORD.

       2100-VALIDATE-TRANSACTION.
           MOVE SPACES TO WS-ERROR-MESSAGE.
           IF WS-TRANS-AMOUNT <= ZERO
               MOVE 'Monto de transacción inválido.' TO WS-ERROR-MESSAGE
           END-IF.

           IF WS-ERROR-MESSAGE = SPACES
               IF TR-DEPOSIT OR TR-WITHDRAWAL
                   PERFORM 2110-VALIDATE-SINGLE-ACCOUNT
               ELSE IF TR-TRANSFER
                   PERFORM 2120-VALIDATE-TRANSFER-ACCOUNTS
               ELSE
                   MOVE 'Tipo de transacción inválido.' 
                   TO WS-ERROR-MESSAGE
               END-IF
           END-IF.

       2110-VALIDATE-SINGLE-ACCOUNT.
           PERFORM 2111-FIND-MASTER-ACCOUNT.
           IF END-OF-MASTER-FILE
               MOVE 'Cuenta no encontrada en archivo maestro.' 
               TO WS-ERROR-MESSAGE
           END-IF.

       2112-FIND-MASTER-ACCOUNT.
           MOVE WS-TRANS-ACCOUNT-NUMBER TO MR-ACCOUNT-NUMBER.
           READ MASTER-FILE
               INVALID KEY SET END-OF-MASTER-FILE TO TRUE
               NOT INVALID KEY
                   MOVE MR-ACCOUNT-BALANCE-STR 
                   TO WS-MASTER-ACCOUNT-BALANCE
           END-READ.

       2120-VALIDATE-TRANSFER-ACCOUNTS.
           PERFORM 2111-FIND-MASTER-ACCOUNT.
           IF END-OF-MASTER-FILE
               MOVE 'Cuenta origen no encontrada para transferencia.' 
               TO WS-ERROR-MESSAGE
           END-END.
           IF WS-ERROR-MESSAGE = SPACES
               MOVE WS-TRANS-DEST-ACCOUNT TO MR-ACCOUNT-NUMBER.
               READ MASTER-FILE
                   INVALID KEY SET END-OF-MASTER-FILE TO TRUE
                   NOT INVALID KEY
                       MOVE MR-ACCOUNT-BALANCE-STR 
                       TO WS-MASTER-ACCOUNT-BALANCE
               END-READ.
               IF END-OF-MASTER-FILE
                   MOVE
                   'Cuenta destino no encontrada para transferencia.' 
                   TO WS-ERROR-MESSAGE
               END-IF
           END-IF.

       2200-UPDATE-MASTER-FILE.
           PERFORM 2210-READ-MASTER-FOR-UPDATE.
           IF NOT END-OF-MASTER-FILE
               IF TR-DEPOSIT
                   ADD WS-TRANS-AMOUNT TO WS-MASTER-ACCOUNT-BALANCE
               ELSE IF TR-WITHDRAWAL
                   IF WS-MASTER-ACCOUNT-BALANCE >= WS-TRANS-AMOUNT
                       SUBTRACT WS-TRANS-AMOUNT 
                       FROM WS-MASTER-ACCOUNT-BALANCE
                   ELSE
                       MOVE 'Fondos insuficientes para retiro.' 
                       TO WS-ERROR-MESSAGE
                       PERFORM 2300-WRITE-ERROR-REPORT
                   END-IF
               ELSE IF TR-TRANSFER
                   PERFORM 2220-PROCESS-TRANSFER
               END-IF.
               IF WS-ERROR-MESSAGE = SPACES
                   MOVE WS-MASTER-ACCOUNT-BALANCE 
                   TO MR-ACCOUNT-BALANCE-STR
                   REWRITE MASTER-RECORD-IN
               END-IF
           END-IF.

       2210-READ-MASTER-FOR-UPDATE.
           MOVE WS-TRANS-ACCOUNT-NUMBER TO MR-ACCOUNT-NUMBER.
           READ MASTER-FILE
               INVALID KEY SET END-OF-MASTER-FILE TO TRUE
               NOT INVALID KEY
                   MOVE MR-ACCOUNT-BALANCE-STR 
                   TO WS-MASTER-ACCOUNT-BALANCE
           END-READ.

       2220-PROCESS-TRANSFER.
           IF WS-MASTER-ACCOUNT-BALANCE >= WS-TRANS-AMOUNT
               SUBTRACT WS-TRANS-AMOUNT FROM WS-MASTER-ACCOUNT-BALANCE.
               PERFORM 2230-UPDATE-DEST-ACCOUNT.
           ELSE
               MOVE 'Fondos insuficientes para transferencia.' 
               TO WS-ERROR-MESSAGE
               PERFORM 2300-WRITE-ERROR-REPORT
           END-IF.

       2230-UPDATE-DEST-ACCOUNT.
           MOVE WS-TRANS-DEST-ACCOUNT TO MR-ACCOUNT-NUMBER.
           READ MASTER-FILE
               INVALID KEY
                   MOVE 'Error: Cuenta destino no encontrada durante transferencia.' TO WS-ERROR-MESSAGE
                   PERFORM 2300-WRITE-ERROR-REPORT
               NOT INVALID KEY
                   ADD WS-TRANS-AMOUNT TO WS-MASTER-ACCOUNT-BALANCE
                   MOVE WS-MASTER-ACCOUNT-BALANCE TO MR-ACCOUNT-BALANCE-STR
                   REWRITE MASTER-RECORD-IN
           END-READ.

       2300-WRITE-ERROR-REPORT.
           STRING 'Error en transacción: '
                  TR-ACCOUNT-NUMBER ' '
                  TR-TRANSACTION-TYPE ' '
                  TR-AMOUNT-STR ' '
                  TR-DEST-ACCOUNT-NUMBER ' - '
                  WS-ERROR-MESSAGE
                  DELIMITED BY SIZE INTO ERROR-RECORD-OUT.
           WRITE ERROR-RECORD-OUT.

       3000-TERMINATE-SYSTEM.
           CLOSE TRANS-FILE
                 MASTER-FILE
                 ERROR-REPORT-FILE.
