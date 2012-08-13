/* xxxxcode.p  - cab gen code maintenance                             */
/* VER:          DATED:2001-03-13     BY:James Zou     MARK:AOCAB001 */

/* DISPLAY TITLE */
{mfdeclre.i}
{gplabel.i}


DEFINE INPUT PARAMETER inp-recid AS RECID.


define variable pop-tit        as character no-undo.
define variable v_confirm      as logical   format "Yes/No" no-undo.
DEFINE VARIABLE v_err          AS CHARACTER FORMAT "X(30)".

DEFINE VARIABLE v_part AS CHAR.
DEFINE VARIABLE v_site AS CHAR.
DEFINE VARIABLE v_version AS INTEGER.
DEFINE VAR      v_accessok    AS LOGICAL INITIAL NO NO-UNDO.

form
    xxwobmfd_comp         COLUMN-LABEL "零件"
    xxwobmfd_op           COLUMN-LABEL "工序"
    xxwobmfd_qty          COLUMN-LABEL "用量"
    xxwobmfd_cost_tot     COLUMN-LABEL "总成本"
    xxwobmfd_mtl_tl       COLUMN-LABEL "本层物料"
    xxwobmfd_lbr_tl       COLUMN-LABEL "本层人工"
    xxwobmfd_bdn_tl       COLUMN-LABEL "本层附加"
    xxwobmfd_ovh_tl       COLUMN-LABEL "本层间接"
    xxwobmfd_sub_tl       COLUMN-LABEL "本层外包"
    xxwobmfd_mtl_ll       COLUMN-LABEL "底层物料"
    xxwobmfd_lbr_ll       COLUMN-LABEL "底层人工"
    xxwobmfd_bdn_ll       COLUMN-LABEL "底层附加"
    xxwobmfd_ovh_ll       COLUMN-LABEL "底层间接"
    xxwobmfd_sub_ll       COLUMN-LABEL "底层外包"

with row 5 centered overlay down TITLE pop-tit frame f-b width 300.
setFrameLabels(frame f-b:handle).

FORM 
    xxwobmfd_comp         LABEL "零件"
    xxwobmfd_op           LABEL "工序"
    xxwobmfd_qty          LABEL "用量"
    xxwobmfd_cost_tot     LABEL "总成本"
    xxwobmfd_mtl_tl       LABEL "本层物料"
    xxwobmfd_lbr_tl       LABEL "本层人工"
    xxwobmfd_bdn_tl       LABEL "本层附加"
    xxwobmfd_ovh_tl       LABEL "本层间接"
    xxwobmfd_sub_tl       LABEL "本层外包"
    xxwobmfd_mtl_ll       LABEL "底层物料"
    xxwobmfd_lbr_ll       LABEL "底层人工"
    xxwobmfd_bdn_ll       LABEL "底层附加"
    xxwobmfd_ovh_ll       LABEL "底层间接"
    xxwobmfd_sub_ll       LABEL "底层外包"
    with row 9 width 80 overlay center  TITLE pop-tit frame f-c SIDE-LABELS 1 COLUMN.
setFrameLabels(frame f-c:handle).


find xxwobmfm_mstr where recid(xxwobmfm_mstr) = inp-recid no-lock no-error.
IF NOT AVAILABLE xxwobmfm_mstr THEN LEAVE.
ASSIGN v_part = xxwobmfm_part
       v_site = xxwobmfm_site
       v_version = xxwobmfm_version.

pop-tit = "Components Detail, Version:" + STRING(v_version).

    MainBlock:
    do on error undo,leave on endkey undo,leave:

        { yywobmfmmta.i
          &file = "xxwobmfd_det"
          &where = "where (xxwobmfd_par = v_part
                      AND  xxwobmfd_site = v_site
                      AND  xxwobmfd_version = v_version)"
          &frame = "f-b"
          &fieldlist = "
            xxwobmfd_comp 
            xxwobmfd_op
            xxwobmfd_qty
            xxwobmfd_cost_tot
            xxwobmfd_mtl_tl
            xxwobmfd_lbr_tl
            xxwobmfd_bdn_tl
            xxwobmfd_ovh_tl
            xxwobmfd_sub_tl
            xxwobmfd_mtl_ll
            xxwobmfd_lbr_ll
            xxwobmfd_bdn_ll
            xxwobmfd_ovh_ll
            xxwobmfd_sub_ll
                       "
          &prompt     = "xxwobmfd_comp"
          &index      = "use-index xxwobmfd_idx1"
          &midchoose  = "color mesages"
          &predisplay = "~ run xxpro-m-predisplay. ~ "
          &updkey     = "M"
          &updcode    = "~ run xxpro-m-update. ~"
          &inskey     = "A"
          &inscode    = "~ run xxpro-m-add. ~"
          &delkey     = "D"
          &delcode    = "~ run xxpro-m-delete. ~"
        }

    end. /*MAIN BLOCK */

/*----------------------------------------------------------*/

PROCEDURE xxpro-m-predisplay.
    hide message no-pause. 
    message "[ESC]返回".
END PROCEDURE.

PROCEDURE xxpro-m-update.
    find xxwobmfd_det where recid(xxwobmfd_det) = w-rid[Frame-line(f-b)]
    no-lock no-error.

    if not available xxwobmfd_det then leave .
    RUN xxpro-access-check(OUTPUT v_accessok).
    IF v_accessok = NO THEN LEAVE.

    find xxwobmfd_det where recid(xxwobmfd_det) = w-rid[Frame-line(f-b)]
    no-error.

    display
        xxwobmfd_comp 
        xxwobmfd_op
        xxwobmfd_qty
        xxwobmfd_cost_tot
        xxwobmfd_mtl_tl
        xxwobmfd_lbr_tl
        xxwobmfd_bdn_tl
        xxwobmfd_ovh_tl
        xxwobmfd_sub_tl
        xxwobmfd_mtl_ll
        xxwobmfd_lbr_ll
        xxwobmfd_bdn_ll
        xxwobmfd_ovh_ll
        xxwobmfd_sub_ll
    with frame f-c.
    UPDATE
        xxwobmfd_qty
        /*xxwobmfd_cost_tot*/
            xxwobmfd_mtl_tl
            xxwobmfd_lbr_tl
            xxwobmfd_bdn_tl
            xxwobmfd_ovh_tl
            xxwobmfd_sub_tl
    with frame f-c.
    ASSIGN xxwobmfd_cost_tot = 
        xxwobmfd_mtl_tl +
        xxwobmfd_lbr_tl +
        xxwobmfd_bdn_tl +
        xxwobmfd_ovh_tl +
        xxwobmfd_sub_tl +
        xxwobmfd_mtl_ll +
        xxwobmfd_lbr_ll +
        xxwobmfd_bdn_ll +
        xxwobmfd_ovh_ll +
        xxwobmfd_sub_ll .
    ASSIGN xxwobmfd_userid   = GLOBAL_userid
           xxwobmfd_date_mod = TODAY.
    RUN xxpro-recal-m(INPUT inp-recid).
    HIDE FRAME f-c NO-PAUSE.
END PROCEDURE.

PROCEDURE xxpro-m-add.
    pop-tit = ' Input New Data '.
    RUN xxpro-access-check(OUTPUT v_accessok).
    IF v_accessok = NO THEN LEAVE.

    clear frame f-c ALL no-pause.

    REPEAT WITH FRAME f-c:
       prompt-for 
           xxwobmfd_comp 
           xxwobmfd_op
           xxwobmfd_qty
           /*xxwobmfd_cost_tot*/
           xxwobmfd_mtl_tl
           xxwobmfd_lbr_tl
           xxwobmfd_bdn_tl
           xxwobmfd_ovh_tl
           xxwobmfd_sub_tl
       WITH FRAME f-c.

       find first xxwobmfd_det 
           where xxwobmfd_par   = v_part
           and xxwobmfd_site    = v_site
           AND xxwobmfd_version = v_version
           AND xxwobmfd_comp    = input frame f-c xxwobmfd_comp
           AND xxwobmfd_op      = input frame f-c xxwobmfd_op
       no-lock no-error.

       if available xxwobmfd_det then do:
            message "ERR:data already Exists.".
            UNDO,RETRY.
       end.
       create xxwobmfd_det.
       assign
           xxwobmfd_par      = v_part
           xxwobmfd_site     = v_site
           xxwobmfd_version  = v_version
           xxwobmfd_comp     = input frame f-c xxwobmfd_comp
           xxwobmfd_op       = input frame f-c xxwobmfd_op
           xxwobmfd_qty      = input frame f-c xxwobmfd_qty
           /*xxwobmfd_cost_tot = input frame f-c xxwobmfd_cost_tot*/
           xxwobmfd_mtl_tl = input frame f-c xxwobmfd_mtl_tl
           xxwobmfd_lbr_tl = input frame f-c xxwobmfd_lbr_tl
           xxwobmfd_bdn_tl = input frame f-c xxwobmfd_bdn_tl
           xxwobmfd_ovh_tl = input frame f-c xxwobmfd_ovh_tl
           xxwobmfd_sub_tl = input frame f-c xxwobmfd_sub_tl
           .
       ASSIGN xxwobmfd_cost_tot = 
           xxwobmfd_mtl_tl +
           xxwobmfd_lbr_tl + 
           xxwobmfd_bdn_tl +
           xxwobmfd_ovh_tl + 
           xxwobmfd_sub_tl +
           xxwobmfd_mtl_ll +
           xxwobmfd_lbr_ll + 
           xxwobmfd_bdn_ll +
           xxwobmfd_ovh_ll + 
           xxwobmfd_sub_ll .
       w-newrecid = recid(xxwobmfd_det).  
       RUN xxpro-recal-m(INPUT inp-recid).
       DOWN 1 WITH FRAME f-c.
   END.
   hide frame f-pop no-pause.
END PROCEDURE.

PROCEDURE xxpro-m-delete.
    find xxwobmfd_det where recid(xxwobmfd_det) = w-rid[Frame-line(f-b)]
    no-lock no-error.
    if not available xxwobmfd_det THEN LEAVE.
    RUN xxpro-access-check(OUTPUT v_accessok).
    IF v_accessok = NO THEN LEAVE.

    find xxwobmfd_det where recid(xxwobmfd_det) = w-rid[Frame-line(f-b)]
    no-error.
    message "Confirm delete the record?" update v_confirm.
    if v_confirm and available xxwobmfd_det then  do:
        DELETE xxwobmfd_det.
        RUN xxpro-recal-m(INPUT inp-recid).
    END.
END PROCEDURE.

PROCEDURE xxpro-recal-m.
    DEFINE INPUT PARAMETER p_recid AS RECID.
    FIND FIRST xxwobmfm_mstr WHERE recid(xxwobmfm_mstr) = p_recid NO-ERROR.
    IF NOT AVAILABLE xxwobmfm_mstr THEN LEAVE.
    ASSIGN 
        xxwobmfm_cost_tot = 0
        xxwobmfm_mtl_ll = 0
        xxwobmfm_lbr_ll = 0 
        xxwobmfm_bdn_ll = 0
        xxwobmfm_ovh_ll = 0
        xxwobmfm_sub_ll = 0 .


    FOR EACH xxwobmfd_det NO-LOCK
        WHERE xxwobmfd_par = xxwobmfm_part
          AND xxwobmfd_site    = xxwobmfm_site
          AND xxwobmfd_version = xxwobmfm_version:
        ASSIGN 
            xxwobmfm_mtl_ll = xxwobmfm_mtl_ll + (xxwobmfd_mtl_ll + xxwobmfd_mtl_tl) * xxwobmfd_qty
            xxwobmfm_lbr_ll = xxwobmfm_lbr_ll + (xxwobmfd_lbr_ll + xxwobmfd_lbr_tl) * xxwobmfd_qty
            xxwobmfm_bdn_ll = xxwobmfm_bdn_ll + (xxwobmfd_bdn_ll + xxwobmfd_bdn_tl) * xxwobmfd_qty
            xxwobmfm_ovh_ll = xxwobmfm_ovh_ll + (xxwobmfd_ovh_ll + xxwobmfd_ovh_tl) * xxwobmfd_qty
            xxwobmfm_sub_ll = xxwobmfm_sub_ll + (xxwobmfd_sub_ll + xxwobmfd_sub_tl) * xxwobmfd_qty
            .
    END.
    ASSIGN 
        xxwobmfm_cost_tot = 
        xxwobmfm_mtl_tl +
        xxwobmfm_lbr_tl +
        xxwobmfm_bdn_tl +
        xxwobmfm_ovh_tl +
        xxwobmfm_sub_tl + 
        xxwobmfm_mtl_ll +
        xxwobmfm_lbr_ll +
        xxwobmfm_bdn_ll +
        xxwobmfm_ovh_ll +
        xxwobmfm_sub_ll .
    ASSIGN xxwobmfm_userid   = GLOBAL_userid
           xxwobmfm_date_mod = TODAY
           xxwobmfm_time_mod = TIME.
END PROCEDURE.

PROCEDURE xxpro-access-check:
    DEFINE OUTPUT PARAMETER p_accessok AS LOGICAL.
    p_accessok = NO.
    FIND FIRST CODE_mstr WHERE CODE_fldname = "xxwobmfmmt" AND CODE_value = GLOBAL_userid NO-LOCK NO-ERROR.
    IF AVAILABLE CODE_mstr THEN p_accessok = YES.
END PROCEDURE.
