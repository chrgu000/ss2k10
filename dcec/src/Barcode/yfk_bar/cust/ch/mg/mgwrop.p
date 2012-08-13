{mfdeclre.i}
DEFINE INPUT PARAMETER bccode LIKE b_co_code.
DEFINE INPUT PARAMETER bcpart LIKE b_co_part.
DEFINE INPUT PARAMETER optype LIKE b_op_type.
DEFINE INPUT PARAMETER opstatus LIKE b_op_status.
DEFINE INPUT PARAMETER opsite LIKE b_op_site.
DEFINE INPUT PARAMETER opfloc LIKE b_op_floc.
DEFINE INPUT PARAMETER optloc LIKE b_op_tloc.
DEFINE INPUT PARAMETER opqty LIKE b_op_qty.
DEFINE INPUT PARAMETER opdate LIKE b_op_date.
DEFINE INPUT PARAMETER optime LIKE b_op_time.
DEFINE INPUT PARAMETER opdesc LIKE b_op_desc.

DEFINE VARIABLE i AS INTEGER.

/*SELECT MAX(b_op_id) INTO i FROM b_op_hist.
IF i = ? THEN i = 1. ELSE i = i + 1.*/
i = NEXT-VALUE(bop_seq01).
 IF i = ?  THEN DO:
     MESSAGE '«Î≥ı ºªØb_op_hist£°' VIEW-AS ALERT-BOX ERROR.
     LEAVE.
 END.
 
DO ON ERROR UNDO ,LEAVE:
     CREATE b_op_hist.
     ASSIGN 
         b_op_id = i
         b_op_code = bccode
         b_op_part = bcpart
         b_op_type = optype
         b_op_status = opstatus
          b_op_site = opsite
          b_op_floc = opfloc
          b_op_tloc = optloc
          b_op_qty = opqty
          b_op_date = opdate
          b_op_time = optime
          b_op_desc = opdesc.
END.

