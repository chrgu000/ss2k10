DEFINE INPUT PARAMETER part AS CHARACTER.
DEFINE OUTPUT PARAMETER sucess AS LOGICAL INITIAL FALSE.
      DEFINE VARIABLE bccode AS CHARACTER.
      DEFINE VARIABLE ifmatch AS LOGICAL INITIAL FALSE.
      DEFINE FRAME bc
        bccode
          WITH WIDTH 80 SIDE-LABEL THREE-D.

      UPDATE bccode WITH FRAME bc.
      FIND FIRST b_co_mstr NO-LOCK WHERE b_co_code = bccode NO-ERROR.
      IF AVAILABLE b_co_mstr THEN DO:
          IF b_co_part = part THEN ifmatch = TRUE. ELSE ifmatch = FALSE.
      END.
      IF ifmatch = FALSE THEN DO:
          MESSAGE "����ɨ�����������˳����µ��".
          sucess = FALSE.
      END.
      ELSE DO:
          sucess = TRUE.
      END.
