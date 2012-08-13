
{mfdtitle.i "d+ "}
DEFINE VAR part_cost LIKE sct_cst_tot.
DEFINE VAR site1 LIKE pt_site.
DEFINE VAR site2 LIKE pt_site.
DEFINE VAR loc1 LIKE tag_loc.
DEFINE VAR loc2 LIKE tag_loc.
DEFINE VAR lotyes AS LOGICAL INITIAL NO.
DEFINE VAR v_var AS  LOGICAL INITIAL NO.
DEFINE VAR costg LIKE sct_sim INITIAL "STD2009".
DEFINE VAR v_desc LIKE pt_desc2.
DEFINE VAR v_prod_line LIKE pt_prod_line.
DEFINE VAR v_abc LIKE IN_abc.
DEFINE VAR v_keeper LIKE IN__qadc01.

DEFINE WORKFILE xxwkqad
       FIELD tag LIKE tag_nbr
       FIELD site LIKE tag_site
       FIELD loc LIKE tag_loc
       FIELD part LIKE tag_part
       FIELD desc1 LIKE pt_desc2
       FIELD prod_line LIKE pt_prod_line
       FIELD abc LIKE IN_abc
       FIELD keeper LIKE IN__qadc01
       FIELD cost LIKE sct_cst_tot
       FIELD serial LIKE tag_serial
       FIELD qty_frz LIKE ld_qty_frz
       FIELD cnt_qty LIKE tag_cnt_qty
       FIELD rcnt_qty LIKE tag_rcnt_qty.

DEFINE WORKFILE xxwkall
       FIELD tag LIKE tag_nbr
       FIELD site LIKE tag_site
       FIELD loc LIKE tag_loc
       FIELD part LIKE tag_part
       FIELD desc1 LIKE pt_desc2
       FIELD prod_line LIKE pt_prod_line
       FIELD abc LIKE IN_abc
       FIELD keeper LIKE IN__qadc01
       FIELD cost LIKE sct_cst_tot
       FIELD serial LIKE tag_serial
       FIELD qty_frz LIKE ld_qty_frz
       FIELD cnt_qty LIKE tag_cnt_qty
       FIELD rcnt_qty LIKE tag_rcnt_qty
       FIELD bar_code LIKE b_co_code
       FIELD bar_qty LIKE b_co_qty_cur
       FIELD sign LIKE b_co_cntst.

FORM 
    site1 colon 25 site2 label {t001.i} colon 49
    loc1  colon 25 loc2 label {t001.i} colon 49  
    lotyes COLON 25 LABEL "Only display Lot(Yes/No)"
    v_var COLON 25  LABEL "Display Variance(Yes/No)"
    costg  COLON 25 LABEL "Standard cost gather"
    with frame a side-labels width 80 attr-space NO-BOX THREE-D /*GUI*/.


REPEAT:
 UPDATE site1 site2 loc1 loc2 lotyes v_var costg WITH FRAME a.
 {mfselprt.i "printer" 132}
 IF site1 = hi_char THEN site1 = "".
 IF site2 = "" THEN site2 = hi_char.
 IF loc1 = hi_char  THEN loc1 = "".
 IF loc2 = ""  THEN loc2 = hi_char.

 FOR EACH tag_mstr WHERE tag_site >= site1 AND tag_site <= site2 AND tag_loc >= loc1 AND tag_loc <= loc2  USE-INDEX tag_slpsn NO-LOCK BY tag_nbr.
     FIND FIRST pt_mstr WHERE pt_part = tag_part USE-INDEX pt_part NO-LOCK.
     IF AVAIL pt_mstr  THEN DO:
         v_desc = pt_desc2. v_prod_line = pt_prod_line.
     END.
     ELSE DO:
         v_desc = "". v_prod_line = "".
     END.
     FIND FIRST sct_det WHERE sct_site = tag_site AND (tag_site <> "DCEC-SV" AND tag_site <> "CEBJ") AND sct_sim = costg AND sct_part = tag_part NO-LOCK NO-ERROR.
     IF AVAILABLE sct_det THEN part_cost = sct_cst_tot. ELSE part_cost = 0.

     FIND FIRST sct_det WHERE sct_site = "DCEC-C" AND (tag_site = "DCEC-SV" OR tag_site = "CEBJ") AND sct_sim = costg AND sct_part = tag_part NO-LOCK NO-ERROR.
     IF AVAILABLE sct_det THEN part_cost = sct_cst_tot.

     FIND FIRST IN_mstr WHERE IN_part = tag_part AND IN_site = tag_site USE-INDEX IN_part NO-LOCK NO-ERROR.
     IF AVAIL IN_mstr THEN DO:
         v_abc = IN_abc. v_keeper = IN__qadc01.
     END.
     ELSE DO:
         v_abc = "". v_keeper = "".
     END.

     FIND ld_det WHERE ld_site = tag_site AND ld_loc = tag_loc AND ld_part = tag_part AND ld_lot = tag_serial USE-INDEX ld_loc_p_lot NO-LOCK NO-ERROR.
     IF NOT AVAIL ld_det THEN DO:
         CREATE xxwkqad.
         ASSIGN
              xxwkqad.tag = tag_nbr
              xxwkqad.site = tag_site
              xxwkqad.loc = tag_loc
              xxwkqad.part = tag_part
              xxwkqad.desc1 = v_desc
              xxwkqad.prod_line = v_prod_line
              xxwkqad.qty_frz = 0
              xxwkqad.abc = v_abc
              xxwkqad.keeper = v_keeper
              xxwkqad.cost = part_cost
              xxwkqad.serial = tag_serial
              xxwkqad.cnt_qty = tag_cnt_qty
              xxwkqad.rcnt_qty = tag_rcnt_qty.
     END.
     ELSE DO:
         CREATE xxwkqad.
         ASSIGN
              xxwkqad.tag = tag_nbr
              xxwkqad.site = tag_site
              xxwkqad.loc = tag_loc
              xxwkqad.part = tag_part
              xxwkqad.desc1 = v_desc
              xxwkqad.prod_line = v_prod_line
              xxwkqad.qty_frz = ld_qty_frz
              xxwkqad.abc = v_abc
              xxwkqad.keeper = v_keeper
              xxwkqad.cost = part_cost
              xxwkqad.serial = tag_serial
              xxwkqad.cnt_qty = tag_cnt_qty
              xxwkqad.rcnt_qty = tag_rcnt_qty.
     END.

 END.


 FOR EACH xxwkqad BY xxwkqad.tag.
     FOR EACH b_co_mstr WHERE b_co_part = xxwkqad.part AND b_co_lot = xxwkqad.serial AND b_co_site = xxwkqad.site AND b_co_loc = xxwkqad.loc AND b_co_status ="RCT" 
         USE-INDEX b_co_lot NO-LOCK BREAK BY b_co_lot BY b_co_code.
         IF FIRST-OF (b_co_lot) THEN DO:
             CREATE xxwkall.
             ASSIGN
                 tag = xxwkqad.tag
                 site = xxwkqad.site
                 loc = xxwkqad.loc
                 part = xxwkqad.part
                 desc1 = xxwkqad.desc1
                 prod_line = xxwkqad.prod_line
                 qty_frz = xxwkqad.qty_frz
                 abc =  xxwkqad.abc
                 keeper =  xxwkqad.keeper
                 cost = xxwkqad.cost
                 serial =  xxwkqad.serial
                 cnt_qty =  xxwkqad.cnt_qty
                 rcnt_qty =  xxwkqad.rcnt_qty
                 bar_code = b_co_code
                 bar_qty = b_co_qty_cur
                 sign = b_co_cntst.
         END.
         ELSE DO:
             CREATE xxwkall.
             ASSIGN
                 tag = xxwkqad.tag
                 site = xxwkqad.site
                 loc = xxwkqad.loc
                 part = xxwkqad.part
                 desc1 = xxwkqad.desc1
                 prod_line = xxwkqad.prod_line
                 abc =  xxwkqad.abc
                 keeper =  xxwkqad.keeper
                 cost = xxwkqad.cost
                 bar_code = b_co_code
                 bar_qty = b_co_qty_cur
                 sign = b_co_cntst.

         END.
     END.
 END.

 IF v_var = NO AND lotyes = NO THEN DO:
     FOR EACH xxwkqad WHERE xxwkqad.site >= site1 AND xxwkqad.site <= site2 AND xxwkqad.loc >= loc1 AND xxwkqad.loc <= loc2 BY xxwkqad.tag.
         DISP xxwkqad WITH WIDTH 300 STREAM-IO.
     END.
 END.

 IF v_var = YES AND lotyes = NO THEN DO:
     FOR EACH xxwkqad WHERE xxwkqad.site >= site1 AND xxwkqad.site <= site2 AND xxwkqad.loc >= loc1 AND xxwkqad.loc <= loc2 
          AND xxwkqad.qty_frz <> xxwkqad.cnt_qty BY xxwkqad.tag.
         DISP xxwkqad WITH WIDTH 300 STREAM-IO.
     END.
 END.


 IF v_var = NO AND lotyes = YES THEN DO:
     FOR EACH xxwkall WHERE xxwkall.site >= site1 AND xxwkall.site <= site2 AND xxwkall.loc >= loc1 AND xxwkall.loc <= loc2 BY xxwkall.tag BY xxwkall.bar_code.
         DISP xxwkall WITH WIDTH 300 STREAM-IO.
     END.
 END.

 IF v_var = YES AND lotyes = YES THEN DO:
     FOR EACH xxwkqad WHERE xxwkqad.site >= site1 AND xxwkqad.site <= site2 AND xxwkqad.loc >= loc1 AND xxwkqad.loc <= loc2 AND xxwkqad.qty_frz <> xxwkqad.cnt_qty
          BY xxwkqad.tag.
         FOR EACH  xxwkall WHERE xxwkall.tag = xxwkqad.tag  BY xxwkall.tag BY xxwkall.bar_code.
             DISP xxwkall WITH WIDTH 300 STREAM-IO.
         END.
     END.
 END.

   {mfreset.i}
   {mfgrptrm.i} /*Report-to-Window*/
END.
