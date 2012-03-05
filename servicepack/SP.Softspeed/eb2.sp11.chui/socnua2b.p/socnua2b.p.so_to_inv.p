/* ²éÑ¯ */
FOR EACH so_mstr NO-LOCK
   ,EACH sod_det NO-LOCK
   WHERE sod_nbr = so_nbr
   :
   IF so_to_inv = YES OR so_inv_nbr <> "" THEN NEXT.
   IF sod_qty_inv <> 0 THEN DO:
      DISP so_nbr.
   END.
END.

/* ¸üÐÂ */
DEFINE BUFFER b FOR so_mstr.
DEFINE VARIABLE i AS INTEGER.
i = 0.
FOR EACH so_mstr NO-LOCK:
   IF so_to_inv = YES THEN NEXT.
   IF so_inv_nbr <> "" THEN NEXT.
   FOR EACH sod_det NO-LOCK
      WHERE sod_nbr = so_nbr
      :
      IF sod_qty_inv <> 0 THEN DO:
         FIND FIRST b EXCLUSIVE-LOCK WHERE b.so_nbr = so_mstr.so_nbr.
         ASSIGN
            b.so_to_inv = YES
            i = i + 1
            .
         LEAVE.
      END.
   END.
END.
MESSAGE STRING(i) VIEW-AS ALERT-BOX.
