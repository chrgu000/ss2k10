/* SS - 101028.1 By: Bill Jiang */

{mfdeclre.i}
{gplabel.i} /* EXTERNAL LABEL INCLUDE */

DEFINE INPUT PARAMETER ref_glt LIKE glt_det.glt_ref.

DEFINE VARIABLE line_glt LIKE glt_det.glt_line.
DEFINE VARIABLE continue AS LOGICAL.

DEFINE TEMP-TABLE ttglt_det NO-UNDO
   LIKE glt_det
   INDEX index1 glt_domain glt_ref glt_rflag glt_line
   .

FOR EACH ttglt_det:
   DELETE ttglt_det.
END.

line_glt = 0.
continue = FALSE.
FOR EACH glt_det NO-LOCK
   WHERE glt_det.glt_domain = global_domain
   AND glt_det.glt_ref = ref_glt
   BY glt_det.glt_line
   :
   CREATE ttglt_det.
   BUFFER-COPY glt_det TO ttglt_det.
   ASSIGN
      line_glt = line_glt + 1
      ttglt_det.glt_line = line_glt
      continue = (glt_det.glt_line <> LINE_glt)
      .
END.

IF continue THEN DO:
   DO TRANSACTION:
      FOR EACH glt_det EXCLUSIVE-LOCK
         WHERE glt_det.glt_domain = global_domain
         AND glt_det.glt_ref = ref_glt
         :
         DELETE glt_det.
      END.
   
      FOR EACH ttglt_det:
         CREATE glt_det.
         BUFFER-COPY ttglt_det TO glt_det.
      END.
   END. /* DO TRANSACTION: */
END.
