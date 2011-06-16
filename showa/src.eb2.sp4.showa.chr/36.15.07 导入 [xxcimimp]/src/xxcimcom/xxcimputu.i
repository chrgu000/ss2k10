/* SS - 081222.1 By: Bill Jiang */

      IF tt1_c1[{1}] = "-" THEN DO:
         PUT UNFORMATTED " -".
      END.
      ELSE DO:
         PUT UNFORMATTED " """ + tt1_c1[{1}] + """".
      END.
