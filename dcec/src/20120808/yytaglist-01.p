
{mfdtitle.i "d+ "}
DEFINE VAR part_cost LIKE sct_cst_tot.
DEFINE VAR site1 LIKE pt_site.
DEFINE VAR site2 LIKE pt_site.
DEFINE VAR loc1 LIKE tag_loc.
DEFINE VAR loc2 LIKE tag_loc.
DEFINE VAR lotyes AS CHAR INITIAL "No".
DEFINE VAR costg LIKE sct_sim INITIAL "STD2009".
FORM 
    site1 colon 25 site2 label {t001.i} colon 49
    loc1  colon 25 loc2 label {t001.i} colon 49  
    lotyes COLON 25 LABEL "display LOT (Yes/No)"
    costg  COLON 25 LABEL "standard cost gather"
    with frame a side-labels width 80 attr-space NO-BOX THREE-D /*GUI*/.


REPEAT:
 UPDATE site1 site2 loc1 loc2 lotyes costg WITH FRAME a.
 {mfselprt.i "printer" 132}
 IF site1 = hi_char THEN site1 = "".
 IF site2 = "" THEN site2 = hi_char.
 IF loc1 = hi_char  THEN loc1 = "".
 IF loc2 = ""  THEN loc2 = hi_char.

IF lotyes = "No" THEN DO:
 FOR EACH tag_mstr WHERE tag_site >= site1 AND tag_site <= site2 AND tag_loc >= loc1 AND tag_loc <= loc2 BY tag_nbr.
    FIND FIRST pt_mstr WHERE pt_part = tag_part NO-LOCK.
    IF AVAIL pt_mstr THEN DO:
       FOR EACH ld_det WHERE ld_part = tag_part AND ld_loc = tag_loc AND ld_site = tag_site AND ld_lot = tag_serial NO-LOCK.
        IF AVAIL ld_det THEN DO:
           FIND FIRST IN_mstr WHERE IN_part = tag_part AND IN_site = tag_site NO-LOCK.
           IF AVAIL IN_mstr THEN DO:
               IF tag_site <> "DCEC-SV" AND tag_site <> "CEBJ" THEN DO:
                  FIND FIRST sct_det WHERE sct_site = IN_site AND sct_sim = costg AND sct_part = ld_part NO-LOCK NO-ERROR.
                  IF AVAILABLE sct_det THEN part_cost = sct_cst_tot. ELSE part_cost = 0.
               END.
               ELSE DO:
                  FIND FIRST sct_det WHERE sct_site = "DCEC-C" AND sct_sim = costg AND sct_part = ld_part NO-LOCK NO-ERROR.
                  IF AVAILABLE sct_det THEN part_cost = sct_cst_tot. ELSE part_cost = 0.
               END.
               DISP tag_nbr tag_site tag_loc tag_part pt_desc2 pt_prod_line ld_qty_frz IN_abc IN__qadc01 part_cost tag_serial tag_cnt_qty tag_rcnt_qty WITH WIDTH 180 STREAM-IO.       
           END.
           ELSE DISP tag_nbr tag_site tag_loc tag_part pt_desc2 pt_prod_line ld_qty_frz "#N/A"    "#N/A" part_cost tag_serial tag_cnt_qty tag_rcnt_qty WITH WIDTH 180 STREAM-IO. 
        END.
       END.
    END.
 END.
END.
IF lotyes = "Yes" THEN DO:
 FOR EACH tag_mstr WHERE tag_site >= site1 AND tag_site <= site2 AND tag_loc >= loc1 AND tag_loc <= loc2 AND tag_serial <> ""BY tag_nbr.
    FIND FIRST pt_mstr WHERE pt_part = tag_part NO-LOCK.
    IF AVAIL pt_mstr THEN DO:
       FOR EACH ld_det WHERE ld_part = tag_part AND ld_loc = tag_loc AND ld_site = tag_site AND ld_lot = tag_serial NO-LOCK.
        IF AVAIL ld_det THEN DO:
           FIND FIRST IN_mstr WHERE IN_part = tag_part AND IN_site = tag_site NO-LOCK.
           IF AVAIL IN_mstr THEN DO:
               IF tag_site <> "DCEC-SV" AND tag_site <> "CEBJ" THEN DO:
                  FIND FIRST sct_det WHERE sct_site = IN_site AND sct_sim = costg AND sct_part = ld_part NO-LOCK NO-ERROR.
                  IF AVAILABLE sct_det THEN part_cost = sct_cst_tot. ELSE part_cost = 0.
               END.
               ELSE DO:
                  FIND FIRST sct_det WHERE sct_site = "DCEC-C" AND sct_sim = costg AND sct_part = ld_part NO-LOCK NO-ERROR.
                  IF AVAILABLE sct_det THEN part_cost = sct_cst_tot. ELSE part_cost = 0.
               END.
               DISP tag_nbr tag_site tag_loc tag_part pt_desc2 pt_prod_line ld_qty_frz IN_abc IN__qadc01 part_cost tag_serial tag_cnt_qty tag_rcnt_qty WITH WIDTH 180 STREAM-IO.       
           END.
           ELSE DISP tag_nbr tag_site tag_loc tag_part pt_desc2 pt_prod_line ld_qty_frz "#N/A"    "#N/A" part_cost tag_serial tag_cnt_qty tag_rcnt_qty WITH WIDTH 180 STREAM-IO. 
        END.
       END.
    END.
 END.
END.

   {mfreset.i}
   {mfgrptrm.i} /*Report-to-Window*/
END.

/*

FOR EACH tag_mstr BY tag_nbr.
    FIND FIRST pt_mstr WHERE pt_part = tag_part NO-LOCK.
    IF AVAIL pt_mstr THEN DO:
       FOR EACH ld_det WHERE ld_part = tag_part AND ld_loc = tag_loc AND ld_site = tag_site AND ld_lot = tag_serial NO-LOCK.
        IF AVAIL ld_det THEN DO:
           FIND FIRST IN_mstr WHERE IN_part = tag_part AND IN_site = tag_site NO-LOCK.
           IF AVAIL IN_mstr THEN DO:
               IF tag_site <> "DCEC-SV" AND tag_site <> "CEBJ" THEN DO:
                  FIND FIRST sct_det WHERE sct_site = IN_site AND sct_sim = costg AND sct_part = ld_part NO-LOCK NO-ERROR.
                  IF AVAILABLE sct_det THEN part_cost = sct_cst_tot. ELSE part_cost = 0.
               END.
               ELSE DO:
                  FIND FIRST sct_det WHERE sct_site = "DCEC-C" AND sct_sim = costg AND sct_part = ld_part NO-LOCK NO-ERROR.
                  IF AVAILABLE sct_det THEN part_cost = sct_cst_tot. ELSE part_cost = 0.
               END.
               FIND FIRST b_co_mstr WHERE b_co_site = tag_site AND b_co_loc = tag_loc AND b_co_part = tag_part AND b_co_lot = tag_serial AND (b_co_status = "rct" OR b_co_status = "issln") NO-LOCK NO-ERROR.
               IF AVAILABLE b_co_mstr THEN
                    DISP tag_nbr tag_site tag_loc tag_part pt_desc2 pt_prod_line ld_qty_frz IN_abc IN__qadc01 part_cost tag_serial tag_cnt_qty tag_rcnt_qty b_co_code b_co_qty_cur b_co_cntst WITH WIDTH 350 STREAM-IO.   
               ELSE DISP tag_nbr tag_site tag_loc tag_part pt_desc2 pt_prod_line ld_qty_frz IN_abc IN__qadc01 part_cost tag_serial tag_cnt_qty tag_rcnt_qty WITH WIDTH 350 STREAM-IO.
           END.
           ELSE DO:
               FIND FIRST b_co_mstr WHERE b_co_site = tag_site AND b_co_loc = tag_loc AND b_co_part = tag_part AND b_co_lot = tag_serial AND (b_co_status = "rct" OR b_co_status = "issln") NO-LOCK NO-ERROR.
               IF AVAILABLE b_co_mstr THEN
                    DISP tag_nbr tag_site tag_loc tag_part pt_desc2 pt_prod_line ld_qty_frz "#N/A"    "#N/A"  part_cost tag_serial tag_cnt_qty tag_rcnt_qty b_co_code b_co_qty_cur b_co_cntst WITH WIDTH 350 STREAM-IO.
               ELSE DISP tag_nbr tag_site tag_loc tag_part pt_desc2 pt_prod_line ld_qty_frz "#N/A"    "#N/A"  part_cost tag_serial tag_cnt_qty tag_rcnt_qty WITH WIDTH 250 STREAM-IO.
           END.
        END.
       END.
    END.
END.
*/
