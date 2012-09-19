/* xxxxcode.p  - cab gen code maintenance                             */
/* VER:          DATED:2001-03-13     BY:James Zou     MARK:AOCAB001 */
/* $Revision:eb21sp12  $ BY: Jordan Lin            DATE: 08/16/12  ECO: *SS-20120816.1*   */

/* DISPLAY TITLE */
{mfdtitle.i "120816.1"}

define variable pop-tit        as character no-undo.
define variable v_confirm      as logical   format "Yes/No" no-undo.
DEFINE VARIABLE v_err          AS CHARACTER FORMAT "X(30)".


define variable v_part        LIKE pt_part.
define variable v_site        LIKE pt_site.
DEFINE VARIABLE v_date        LIKE tr_effdate.
DEFINE VAR      v_accessok    AS LOGICAL INITIAL NO NO-UNDO.
DEFINE VAR      v_desc        LIKE pt_desc1.


form
    v_part LABEL "���"
    v_site LABEL "�ص�"
    v_desc NO-LABELS 
    SKIP(1)
with frame f-a side-label width 80.
setFrameLabels(frame f-a:handle).
    
FORM 
    xxwobmfm_version      COLUMN-LABEL "�汾"
    xxwobmfm_date_eff     COLUMN-LABEL "����"
    xxwobmfm_cost_tot     COLUMN-LABEL "�ܳɱ�"
    xxwobmfm_bom          COLUMN-LABEL "BOM����"
    xxwobmfm_mtl_tl       COLUMN-LABEL "��������"
    xxwobmfm_lbr_tl       COLUMN-LABEL "�����˹�"
    xxwobmfm_bdn_tl       COLUMN-LABEL "���㸽��"
    xxwobmfm_ovh_tl       COLUMN-LABEL "������"
    xxwobmfm_sub_tl       COLUMN-LABEL "�������"
    xxwobmfm_mtl_ll       COLUMN-LABEL "�ײ�����"
    xxwobmfm_lbr_ll       COLUMN-LABEL "�ײ��˹�"
    xxwobmfm_bdn_ll       COLUMN-LABEL "�ײ㸽��"
    xxwobmfm_ovh_ll       COLUMN-LABEL "�ײ���"
    xxwobmfm_sub_ll       COLUMN-LABEL "�ײ����"
    with row 5 centered overlay down frame f-b width 200.
setFrameLabels(frame f-b:handle).

FORM 
    xxwobmfm_version      LABEL "�汾"     
    xxwobmfm_date_eff     LABEL "����"     
    xxwobmfm_cost_tot     LABEL "�ܳɱ�"   
    xxwobmfm_bom          LABEL "BOM����"  
    xxwobmfm_mtl_tl       LABEL "��������"
    xxwobmfm_lbr_tl       LABEL "�����˹�"
    xxwobmfm_bdn_tl       LABEL "���㸽��"
    xxwobmfm_ovh_tl       LABEL "������"
    xxwobmfm_sub_tl       LABEL "�������"
    xxwobmfm_mtl_ll       LABEL "�ײ�����"
    xxwobmfm_lbr_ll       LABEL "�ײ��˹�"
    xxwobmfm_bdn_ll       LABEL "�ײ㸽��"
    xxwobmfm_ovh_ll       LABEL "�ײ���"
    xxwobmfm_sub_ll       LABEL "�ײ����"
    with row 9 width 80 overlay center frame f-c SIDE-LABELS 1 COLUMN.
setFrameLabels(frame f-c:handle).
   
repeat:
    view frame f-a.
    VIEW FRAME f-b.

    CLEAR FRAME f-b ALL NO-PAUSE.

    UPDATE v_part v_site with frame f-a editing:
        if frame-field = "v_part" then do:
            /* FIND NEXT/PREVIOUS RECORD */
            {mfnp05.i pt_mstr pt_part
                      "yes = yes"
                      pt_part
                      "input v_part"}
            if recno <> ? then do:
                display pt_part @ v_part pt_desc1 @ v_desc with frame f-a.
            end. /* IF RECNO <> ? */
        END.
        ELSE IF frame-field = "v_site" then do:
            /* FIND NEXT/PREVIOUS RECORD */
            {mfnp05.i si_mstr si_site
                      "yes = yes"
                      si_site
                      "input v_site"}
            if recno <> ? then do:
                display si_site @ v_site with frame f-a.
            end. /* IF RECNO <> ? */
        END.
        else do:
           status input.
           readkey.
           apply lastkey.
        end.
    end. /* EDITING */

    FIND FIRST pt_mstr WHERE  /* *SS-20120816.1*   */ pt_mstr.pt_domain = global_domain and pt_part = v_part NO-LOCK NO-ERROR.
    IF AVAILABLE pt_mstr THEN DO:
        ASSIGN v_desc = pt_desc1.
        DISP v_desc WITH FRAME f-a.
    END.
    ELSE DO:
        MESSAGE "��Ч�����".
        UNDO, RETRY.
    END.
    FIND FIRST si_mstr WHERE  /* *SS-20120816.1*   */ si_mstr.si_domain = global_domain and si_site = v_site NO-LOCK NO-ERROR.
    IF NOT AVAILABLE si_mstr THEN DO:
        MESSAGE "��Ч�ĵص�".
        UNDO, RETRY.
    END.


    MainBlock:
    do on error undo,leave on endkey undo,leave:

        { yywobmfmmta.i
          &file = "xxwobmfm_mstr"
          &where = "where (xxwobmfm_part = v_part
                      AND  xxwobmfm_site = v_site)"
          &frame = "f-b"
          &fieldlist = "
            xxwobmfm_version 
            xxwobmfm_date_eff
            xxwobmfm_cost_tot
            xxwobmfm_bom
            xxwobmfm_mtl_tl
            xxwobmfm_lbr_tl
            xxwobmfm_bdn_tl
            xxwobmfm_ovh_tl
            xxwobmfm_sub_tl
            xxwobmfm_mtl_ll
            xxwobmfm_lbr_ll
            xxwobmfm_bdn_ll
            xxwobmfm_ovh_ll
            xxwobmfm_sub_ll
                       "
          &prompt     = "xxwobmfm_version"
          &index      = "use-index xxwobmfm_idx1"
          &midchoose  = "color mesages"
          &predisplay = "~ run xxpro-m-predisplay. ~ "
          &updkey     = "M"
          &updcode    = "~ run xxpro-m-update. ~"
          &inskey     = "A"
          &inscode    = "~ run xxpro-m-add. ~"
          &delkey     = "D"
          &delcode    = "~ run xxpro-m-delete. ~"
          &key1       = "Enter"
          &code1    = "~ run xxpro-m-detail. ~"
          &key2       = "C"
          &code2    = "~ run xxpro-m-compare. ~"
          &key3       = "V"
          &code3    = "~ run xxpro-m-varchk. ~"
        }

    end. /*MAIN BLOCK */
end.

/*----------------------------------------------------------*/

PROCEDURE xxpro-m-predisplay.
    hide message no-pause. 
    message "[�س�]��ϸ [C]�Ƚ� [V]�����ɱ����ۼӳɱ�".
END PROCEDURE.

PROCEDURE xxpro-m-update.
    find xxwobmfm_mstr where recid(xxwobmfm_mstr) = w-rid[Frame-line(f-b)]
    no-lock no-error.

    if not available xxwobmfm_mstr then leave .
    RUN xxpro-access-check(OUTPUT v_accessok).
    IF v_accessok = NO THEN LEAVE.

    find xxwobmfm_mstr where recid(xxwobmfm_mstr) = w-rid[Frame-line(f-b)]
    no-error.

    display
        xxwobmfm_version 
        xxwobmfm_date_eff
        xxwobmfm_cost_tot
        xxwobmfm_bom
        xxwobmfm_mtl_tl
        xxwobmfm_lbr_tl
        xxwobmfm_bdn_tl
        xxwobmfm_ovh_tl
        xxwobmfm_sub_tl
        xxwobmfm_mtl_ll
        xxwobmfm_lbr_ll
        xxwobmfm_bdn_ll
        xxwobmfm_ovh_ll
        xxwobmfm_sub_ll
    with frame f-c.
    UPDATE
        xxwobmfm_date_eff
        /*xxwobmfm_cost_tot*/
        xxwobmfm_bom
        xxwobmfm_mtl_tl
        xxwobmfm_lbr_tl
        xxwobmfm_bdn_tl
        xxwobmfm_ovh_tl
        xxwobmfm_sub_tl
    with frame f-c.
    ASSIGN
        xxwobmfm_cost_tot = xxwobmfm_mtl_tl +
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
    HIDE FRAME f-c NO-PAUSE.
END PROCEDURE.

PROCEDURE xxpro-m-add.
    pop-tit = ' Input New Data '.
    RUN xxpro-access-check(OUTPUT v_accessok).
    IF v_accessok = NO THEN LEAVE.

    clear frame f-c ALL no-pause.

    REPEAT WITH FRAME f-c:
       prompt-for 
           xxwobmfm_version
           xxwobmfm_date_eff
           /*xxwobmfm_cost_tot*/
           xxwobmfm_bom
           xxwobmfm_mtl_tl
           xxwobmfm_lbr_tl
           xxwobmfm_bdn_tl
           xxwobmfm_ovh_tl
           xxwobmfm_sub_tl
       WITH FRAME f-c.

       find first xxwobmfm_mstr 
           where xxwobmfm_part = v_part
           and xxwobmfm_site = v_site
           AND xxwobmfm_version = input frame f-c xxwobmfm_version
       no-lock no-error.

       if available xxwobmfm_mstr then do:
            message "ERR:data already Exists.".
            UNDO,RETRY.
       end.
       create xxwobmfm_mstr.
       assign
           xxwobmfm_part = v_part
           xxwobmfm_site = v_site
           xxwobmfm_version  = input frame f-c xxwobmfm_version
           xxwobmfm_date_eff = input frame f-c xxwobmfm_date_eff
           /*xxwobmfm_cost_tot = input frame f-c xxwobmfm_cost_tot*/
           xxwobmfm_bom      = input frame f-c xxwobmfm_bom
           xxwobmfm_mtl_tl = input frame f-c xxwobmfm_mtl_tl
           xxwobmfm_lbr_tl = input frame f-c xxwobmfm_lbr_tl
           xxwobmfm_bdn_tl = input frame f-c xxwobmfm_bdn_tl
           xxwobmfm_ovh_tl = input frame f-c xxwobmfm_ovh_tl
           xxwobmfm_sub_tl = input frame f-c xxwobmfm_sub_tl
           .
       ASSIGN
           xxwobmfm_cost_tot = xxwobmfm_mtl_tl +
                               xxwobmfm_lbr_tl +
                               xxwobmfm_bdn_tl +
                               xxwobmfm_ovh_tl +
                               xxwobmfm_sub_tl +
                               xxwobmfm_mtl_ll +
                               xxwobmfm_lbr_ll +
                               xxwobmfm_bdn_ll +
                               xxwobmfm_ovh_ll +
                               xxwobmfm_sub_ll .

       w-newrecid = recid(xxwobmfm_mstr).  
       DOWN 1 WITH FRAME f-c.
   END.
   hide frame f-pop no-pause.
END PROCEDURE.

PROCEDURE xxpro-m-delete.
    find xxwobmfm_mstr where recid(xxwobmfm_mstr) = w-rid[Frame-line(f-b)]
    no-lock no-error.
    if not available xxwobmfm_mstr THEN LEAVE.
    RUN xxpro-access-check(OUTPUT v_accessok).
    IF v_accessok = NO THEN LEAVE.

    find xxwobmfm_mstr where recid(xxwobmfm_mstr) = w-rid[Frame-line(f-b)]
    no-error.
    message "Confirm delete the record?" update v_confirm.
    if v_confirm and available xxwobmfm_mstr then  do:
        FOR EACH xxwobmfd_det WHERE xxwobmfd_par = xxwobmfm_part
            AND xxwobmfd_site    = xxwobmfm_site
            AND xxwobmfd_version = xxwobmfm_version:
            DELETE xxwobmfd_det.
        END.
        delete xxwobmfm_mstr.
    end.   
END PROCEDURE.

PROCEDURE xxpro-m-detail.
    find xxwobmfm_mstr where recid(xxwobmfm_mstr) = w-rid[Frame-line(f-b)]
    no-lock no-error.

    if not available xxwobmfm_mstr then leave .
    {gprun.i ""yywobmfmmta.p"" "(INPUT RECID(xxwobmfm_mstr))"}
    display
        xxwobmfm_version 
        xxwobmfm_date_eff
        xxwobmfm_cost_tot
        xxwobmfm_bom
        xxwobmfm_mtl_tl
        xxwobmfm_lbr_tl
        xxwobmfm_bdn_tl
        xxwobmfm_ovh_tl
        xxwobmfm_sub_tl
        xxwobmfm_mtl_ll
        xxwobmfm_lbr_ll
        xxwobmfm_bdn_ll
        xxwobmfm_ovh_ll
        xxwobmfm_sub_ll
    with frame f-b.

END PROCEDURE.

PROCEDURE xxpro-m-compare.
    DEFINE VARIABLE v_versionlist AS CHAR FORMAT "x(20)".

    MESSAGE "������Ҫ�Ƚϵİ汾,���ŷָ�" UPDATE v_versionlist.
    IF v_versionlist = "" THEN LEAVE.
    {gprun.i ""yywobmfmmtb.p"" "(input v_part, input v_site, input v_versionlist)"}

    find xxwobmfm_mstr where recid(xxwobmfm_mstr) = w-rid[Frame-line(f-b)]
    no-lock no-error.
    if not available xxwobmfm_mstr then leave .
    display
        xxwobmfm_version 
        xxwobmfm_date_eff
        xxwobmfm_cost_tot
        xxwobmfm_bom
        xxwobmfm_mtl_tl
        xxwobmfm_lbr_tl
        xxwobmfm_bdn_tl
        xxwobmfm_ovh_tl
        xxwobmfm_sub_tl
        xxwobmfm_mtl_ll
        xxwobmfm_lbr_ll
        xxwobmfm_bdn_ll
        xxwobmfm_ovh_ll
        xxwobmfm_sub_ll
    with frame f-b.

END PROCEDURE.


/********************/
PROCEDURE xxpro-access-check:
    DEFINE OUTPUT PARAMETER p_accessok AS LOGICAL.
    p_accessok = NO.
    FIND FIRST CODE_mstr WHERE CODE_fldname = "xxwobmfmmt" AND CODE_value = GLOBAL_userid NO-LOCK NO-ERROR.
    IF AVAILABLE CODE_mstr THEN p_accessok = YES.
END PROCEDURE.

/********************/
PROCEDURE xxpro-m-varchk.
    find xxwobmfm_mstr where recid(xxwobmfm_mstr) = w-rid[Frame-line(f-b)]
    no-lock no-error.

    if not available xxwobmfm_mstr then leave .

    DEFINE VARIABLE v_caltot AS DECIMAL.
    DEFINE VARIABLE v_partot AS DECIMAL.
    ASSIGN
        v_caltot = 0
        v_partot = 0.
    FOR EACH xxwobmfd_det NO-LOCK 
        WHERE xxwobmfd_par = xxwobmfm_part
        AND   xxwobmfd_site = xxwobmfm_site
        AND   xxwobmfd_version = xxwobmfm_version:
        ASSIGN v_caltot = v_caltot + xxwobmfd_cost_tot * xxwobmfd_qty.
    END.
    v_caltot = v_caltot /*+ xxwobmfm_mtl_tl*/ + xxwobmfm_lbr_tl + xxwobmfm_bdn_tl
        + xxwobmfm_ovh_tl + xxwobmfm_sub_tl.
    v_partot = xxwobmfm_cost_tot /*- xxwobmfm_mtl_tl*/ .
    IF v_caltot <> v_partot THEN DO:
        MESSAGE "�ۼӳɱ�����ɱ����ڲ���:" + STRING(v_caltot - v_partot) + "���ܵ��·�������!"
            VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
    END.
    ELSE DO:
        MESSAGE "���ɱ����ۼӳɱ��޲���!"
            VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
    END.
END PROCEDURE.
