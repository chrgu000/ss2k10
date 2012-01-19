/* SS - 111020.1 BY KEN */
/******************************************************************************/
/* SCHEDULE MAINTENANCE DETAIL SUBPROGRAM */
/* DISPLAYS/MAINTAINS CUSTOMER LAST RECEIPT INFO */
/*by Ken chen 111220.1*/
/*by Ken chen 120113.1*/

{mfdeclre.i}
{gplabel.i} /* EXTERNAL LABEL INCLUDE */



DEFINE SHARED VARIABLE file_name AS CHARACTER FORMAT "x(50)".
DEFINE SHARED VARIABLE v_qty_oh LIKE IN_qty_oh.
DEFINE SHARED VARIABLE fn_i AS CHARACTER.
DEFINE SHARED VARIABLE v_tr_trnbr LIKE tr_trnbr.


DEFINE SHARED TEMP-TABLE xxpod_det
   FIELD xxpod_nbr LIKE po_nbr
   FIELD xxpod_line LIKE pod_line
   FIELD xxpod_due_date LIKE pod_due_date
   FIELD xxpod_per_date LIKE pod_per_date
   FIELD xxpod_need LIKE pod_need
   FIELD xxpod_status LIKE pod_status
   FIELD xxpod_error AS CHARACTER FORMAT "x(48)"
   INDEX index1 xxpod_nbr xxpod_line.


  /*cimload */
  FOR EACH xxpod_det:
      FIND FIRST po_mstr WHERE po_domain = GLOBAL_domain AND po_nbr = xxpod_nbr NO-LOCK NO-ERROR.
      FIND FIRST pod_det WHERE pod_domain = GLOBAL_domain AND pod_nbr = xxpod_nbr AND pod_line = xxpod_line NO-LOCK NO-ERROR.
      

      fn_i = "".
      fn_i = "xxpopoim-" + replace(STRING(TIME,"HH:MM:SS"),":","-").

      OUTPUT TO VALUE( fn_i + ".inp" ). 
      PUT UNFORMATTED xxpod_nbr  SKIP.
      PUT UNFORMATTED "-"  SKIP.
      PUT UNFORMATTED "-"  SKIP.
      PUT UNFORMATTED "- - - - - - - - - - - - - - - - - - - - - - - no"  SKIP.

      /*ss - 120113.1 b*/
      FIND FIRST gl_ctrl WHERE gl_domain = GLOBAL_domain NO-LOCK NO-ERROR.
      IF AVAIL gl_ctrl THEN DO:
          IF po_curr <> gl_base_curr THEN DO:
             PUT UNFORMATTED "-" SKIP.
          END.
      END.
      /*ss - 120113.1 e*/

      PUT UNFORMATTED "-" SKIP.

      IF po_consignment = YES THEN DO:
         PUT UNFORMATTED "-" SKIP.
      END.

      PUT UNFORMATTED xxpod_line SKIP.
      PUT UNFORMATTED "-" SKIP.
      PUT UNFORMATTED "-" SKIP.
      PUT UNFORMATTED "-" SKIP.

      PUT UNFORMATTED "- - - " .
          
      IF xxpod_status <> "" THEN
         PUT UNFORMATTED xxpod_status.
      ELSE 
         PUT UNFORMATTED "-".
          
      PUT UNFORMATTED " - " .
          
      IF xxpod_due_date <> ? THEN 
         PUT UNFORMATTED xxpod_due_date.
      ELSE
         PUT UNFORMATTED "-".
              
      PUT UNFORMATTED " ".

      IF xxpod_per_date <> ? THEN
         PUT UNFORMATTED xxpod_per_date.
      ELSE 
         PUT UNFORMATTED "-".

      PUT UNFORMATTED " ".
      IF xxpod_need <> ? THEN
         PUT UNFORMATTED xxpod_need.
      ELSE 
         PUT UNFORMATTED "-".
      PUT UNFORMATTED " - - - - - - - - - - no" SKIP.

      IF pod_taxable = YES THEN DO:
         PUT UNFORMATTED "-" SKIP. 
      END.
      FIND FIRST cns_ctrl WHERE cns_domain = global_domain NO-LOCK no-error.
      IF AVAIL cns_ctrl AND cns_active = YES THEN DO:
          PUT UNFORMATTED "-" SKIP. 
      END.
      PUT UNFORMATTED "." SKIP.
      PUT UNFORMATTED "." SKIP.
      PUT UNFORMATTED "-" SKIP.
      PUT UNFORMATTED "-" SKIP.
      OUTPUT CLOSE .

      batchrun = yes.      
      INPUT FROM VALUE( fn_i + ".inp" ) .      
      OUTPUT TO VALUE( fn_i + ".cim" ) .                  
      {gprun.i ""popomt.p""}      
      INPUT CLOSE .
      OUTPUT CLOSE .
      batchrun = NO.   
      
      FIND FIRST pod_det WHERE pod_domain = GLOBAL_domain 
          AND pod_nbr = xxpod_nbr          
          AND pod_line = xxpod_line          
          AND (pod_due_date = xxpod_due_date OR xxpod_due_date = ?)
          AND (pod_per_date = xxpod_per_date OR xxpod_per_date= ?)
          AND (pod_need = xxpod_need OR xxpod_need = ?)          
          AND pod_status = xxpod_status          
          NO-LOCK NO-ERROR.
      IF AVAIL pod_det THEN DO:
         xxpod_error = "OK".
         OS-DELETE VALUE( fn_i + ".inp").
         OS-DELETE VALUE( fn_i + ".cim").
      END.       
      ELSE DO:
         xxpod_error = "µº»Î ß∞‹".
      END.                  
  END.

