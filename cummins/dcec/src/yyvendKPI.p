{mfdtitle.i "d+ "}
DEFINE VAR v_qty_req LIKE b_req_qty_req.
DEFINE VAR v_qty_rct LIKE b_req_qty_rct.
DEFINE VAR v_qty_req_all LIKE b_req_qty_req.
DEFINE VAR v_qty_rct_all LIKE b_req_qty_rct.
DEFINE VAR v_buyer LIKE ptp_buyer.

DEFINE VAR v_eff_date1 LIKE b_req_due_date.
DEFINE VAR v_eff_date2 LIKE b_req_due_date.
DEFINE VAR v_site1 LIKE b_req_site.
DEFINE VAR v_site2 LIKE b_req_site.
DEFINE VAR v_sum AS LOGICAL INITIAL YES.




FORM
    v_eff_date1 LABEL "生效日期"  COLON 20 v_eff_date2  LABEL "To" COLON 55
    v_site1     LABEL "地点"      COLON 20 v_site2     LABEL "To" COLON 55
    v_sum LABEL "是否汇总" COLON 20

    WITH FRAME  a SIDE-LABELS WIDTH 80 ATTR-SPACE NO-BOX THREE-D.



/*detail*/

REPEAT:

    IF v_site1 = hi_char THEN v_site1 = "".
    IF v_site2 = "" THEN v_site2 = hi_char.
    IF v_eff_date1 = hi_date THEN v_eff_date1 = low_date.
    IF v_eff_date2 = low_date THEN v_eff_date2 = hi_date.

UPDATE v_eff_date1 v_eff_date2 v_site1 v_site2 v_sum WITH FRAME a.
{mfselprt.i "printer" 132}

    IF v_site1 = hi_char THEN v_site1 = "".
    IF v_site2 = "" THEN v_site2 = hi_char.
    IF v_eff_date1 = hi_date THEN v_eff_date1 = low_date.
    IF v_eff_date2 = low_date THEN v_eff_date2 = hi_date.

IF v_sum = NO THEN DO:

 FOR EACH b_req_mstr NO-LOCK WHERE b_req_due_date >= v_eff_date1 AND b_req_due_date <= v_eff_date2 AND b_req_site >= v_site1 AND b_req_site <= v_site2.
    FIND FIRST ptp_det WHERE ptp_part = b_req_part AND ptp_site = b_req_site NO-LOCK NO-ERROR.
    IF AVAIL ptp_det THEN v_buyer = ptp_buyer.
    ELSE v_buyer = "".
    DISP b_req_part b_req_qty_req b_req_qty_rct b_req_site b_req_staff b_req_vend b_req_id b_req_po b_req_due_date  b_req_rct_date  
        b_req_qty_rct / b_req_qty_req v_buyer WITH WIDTH 200 STREAM-IO.
 END.
END.

/*by vendor*/

IF v_sum = YES THEN DO:
 FOR EACH b_req_mstr NO-LOCK WHERE b_req_due_date >= v_eff_date1 AND b_req_due_date <= v_eff_date2 AND b_req_site >= v_site1 AND b_req_site <= v_site2 
    BREAK BY b_req_vend BY b_req_part.
    IF FIRST-OF(b_req_vend) THEN DO:
        v_qty_req = 0.
        v_qty_rct = 0.
        v_qty_req_all = 0.
        v_qty_rct_all = 0.
    END.
    IF FIRST-OF(b_req_part) THEN DO:
        v_qty_req = 0.
        v_qty_rct = 0.
    END.
    v_qty_req = v_qty_req + b_req_qty_req.
    v_qty_rct = v_qty_rct + b_req_qty_rct.

    v_qty_req_all = v_qty_req_all + b_req_qty_req.
    v_qty_rct_all = v_qty_rct_all + b_req_qty_rct.

    IF LAST-OF(b_req_vend) OR LAST-OF(b_req_part) THEN DO:
        FIND FIRST ptp_det WHERE ptp_part = b_req_part AND ptp_site = b_req_site NO-LOCK NO-ERROR.
        IF AVAIL ptp_det THEN v_buyer = ptp_buyer.
        ELSE v_buyer = "".
        DISP b_req_vend b_req_site b_req_part v_qty_req v_qty_rct  v_qty_rct / v_qty_req v_buyer WITH WIDTH 180 STREAM-IO.
    END.
        

    IF LAST-OF(b_req_vend) THEN DO:
        FIND FIRST ptp_det WHERE ptp_part = b_req_part AND ptp_site = b_req_site NO-LOCK NO-ERROR.
        IF AVAIL ptp_det THEN v_buyer = ptp_buyer.
        ELSE v_buyer = "".
        PUT b_req_vend SPACE(3) b_req_site SPACE(3) "Total by Vendor:" SPACE(3)  v_qty_req_all SPACE(1) v_qty_rct_all SPACE(1) v_qty_rct_all / v_qty_req_all SPACE(1) v_buyer SKIP(1).
    END.
        

    /*DISP b_req_part b_req_qty_req b_req_qty_rct b_req_site b_req_staff b_req_vend b_req_id b_req_po b_req_due_date  b_req_rct_date WITH WIDTH 180 STREAM-IO.*/

 END.
END.

{mfreset.i}
{mfgrptrm.i} /*Report-to-Window*/

END.
