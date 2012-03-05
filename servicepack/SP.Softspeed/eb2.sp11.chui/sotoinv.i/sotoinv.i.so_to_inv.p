/* ²éÑ¯ */
OUTPUT TO "so_to_inv.xls".
EXPORT DELIMITER "~011" "sod_nbr" "sod_line" "sod_qty_inv" "sod_price" "sod_consignment".
FOR EACH so_mstr NO-LOCK:
   IF so_to_inv = YES OR so_inv_nbr <> "" THEN NEXT.
   FOR EACH sod_det NO-LOCK 
      WHERE sod_nbr = so_nbr 
      :
      IF sod_qty_inv <> 0 THEN DO:
         EXPORT DELIMITER "~011" sod_nbr sod_line sod_qty_inv sod_price sod_consignment.
      END.
   END.
END.
OUTPUT CLOSE.

/* ¸üÐÂ */
DEFINE BUFFER b FOR so_mstr.
DEFINE VARIABLE i AS INTEGER.
i = 0.
FOR EACH so_mstr NO-LOCK:
   IF so_to_inv = YES THEN NEXT.
   IF so_inv_nbr <> "" THEN NEXT.
   FOR EACH sod_det NO-LOCK
      WHERE sod_nbr = so_nbr
      AND sod_consignment = YES
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
