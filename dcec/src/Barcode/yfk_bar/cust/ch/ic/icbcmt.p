{mfdtitle.i}
{bcdeclre.i NEW}
{bcini.i}
/*{bcwin01.i}*/

DEFINE VARIABLE bccode LIKE b_co_code LABEL "�����".
DEFINE VARIABLE bcpart LIKE b_co_part.
DEFINE VARIABLE bcsite LIKE b_co_part LABEL "�ص�".
DEFINE VARIABLE bcloc LIKE b_co_loc LABEL "��λ".
DEFINE VARIABLE bcqty LIKE b_co_qty_cur LABEL "����".
DEFINE VARIABLE bclot LIKE b_co_lot LABEL "���κ�".

DEFINE VARIABLE bfid AS INTEGER.  /*indicate the buffer id*/
DEFINE VARIABLE succeed AS LOGICAL.


DEFINE QUERY q_co FOR t_co_mstr.
DEFINE BROWSE b_co QUERY q_co
    DISPLAY
    t_co_code LABEL "����"
    t_co_part LABEL "���"
    t_co_qty_cur LABEL "����"
    t_co_lot LABEL "����"
    WITH 9 DOWN WIDTH 79
    TITLE "�����嵥".

DEFINE BUTTON btn_save LABEL "����".
DEFINE BUTTON btn_prt1 LABEL "��ӡС����".
DEFINE BUTTON btn_prt2 LABEL "��ӡ˫����".
DEFINE BUTTON btn_prt3 LABEL "��ӡ������".
DEFINE BUTTON btn_quit LABEL "�˳�".

DEFINE FRAME a
    SKIP(.5)
    pt_part COLON 8 LABEL "�����"
    pt_desc1 COLON 8  LABEL "�������" 
    bcsite COLON 8 bcloc COLON 35
    bcqty COLON 8 
    SKIP(1)
    b_co
    SKIP(2)
    SPACE(40) btn_save SPACE(1) btn_prt1 SPACE(1)  btn_prt2 SPACE(1)  btn_prt3 SPACE(1)
    WITH WIDTH 80 TITLE "���������ӡ"  SIDE-LABELS  NO-UNDERLINE THREE-D.

ON 'leave':U OF bcsite
DO:
    ASSIGN bcsite.
    IF bcsite = "" THEN DO:
        STATUS INPUT  "�յص㲻�����˳�".
        RETURN.
    END.
    RETURN.
END.

ON 'leave':U OF bcloc
DO:
    ASSIGN bcsite bcloc.
    ASSIGN bcpart = pt_part:SCREEN-VALUE.
    FIND FIRST ld_det NO-LOCK WHERE ld_part = pt_part:SCREEN-VALUE AND ld_site = bcsite AND ld_loc = bcloc NO-ERROR.
    IF AVAILABLE ld_det THEN DO:
        bcqty = ld_qty_oh.
        DISP bcqty WITH FRAME a.
    END.
    ELSE DO:
        STATUS INPUT "�Ҳ�����棬�˳�".
        RETURN.
    END.
    RETURN.
END.

ON 'enter':U OF bcqty 
DO:
    ASSIGN bcqty.
    FOR EACH t_co_mstr:
        DELETE t_co_mstr.
    END.
    {gprun.i ""bccocr.p"" "(input pt_part:screen-value, INPUT today,
                              input bcqty:screen-value, INPUT ""vend"", input ""0"",
                              INPUT bcsite, INPUT bcloc)"}
    OPEN QUERY q_co FOR EACH t_co_mstr.
    RETURN.
END.

ON 'choose':U OF btn_save 
DO:
    /*{bcrun.i ""bciccomt01.p""}.*/
    RUN exec.
    RETURN.
END.

ON 'choose':U OF btn_prt1 
DO:
    {bcgetprt.i}
    FOR EACH t_co_mstr:
        {gprun.i ""bccopr.p"" "(input t_co_code, input ""SIN"", input pname, input no)"}
    END.
    RETURN.
END.

ON 'choose':U OF btn_prt2 
DO:
    {bcgetprt.i}
    FOR EACH t_co_mstr:
        {gprun.i ""bccopr.p"" "(input t_co_code, input ""DOU"", input pname, input no)"}
    END.
    RETURN.
END.

ON 'choose':U OF btn_prt3 
DO:
    {bcgetprt.i}
    FOR EACH t_co_mstr:
        {gprun.i ""bccopr.p"" "(input t_co_code, input ""FUL"", input pname, input no)"}
    END.
    RETURN.
END.

REPEAT:

PROMPT-FOR pt_part WITH FRAME a EDITING:
        {bcnp.i "pt_mstr" "pt_part"}
         IF recno <> ? THEN DO:
             display
              pt_part pt_desc1             WITH FRAME a.
         END.
 END. /*promtp-for*/
 
 
     UPDATE bcsite bcloc bcqty b_co btn_save btn_prt1 btn_prt2 btn_prt3  WITH FRAME a.
 END.


PROCEDURE exec:

    mainloop:
    DO ON ERROR UNDO,LEAVE:

        DEFINE VARIABLE lotnbr LIKE ld_lot.
        {gprun.i ""bcltcr.p"" "(input bcpart , output lotnbr)"}

        FOR EACH t_co_mstr:
                       IF t_co_loc = "s001a" THEN t_co_status = "FINI-GOOD". ELSE t_co_status = "MAT-STOCK".
            CREATE b_co_mstr.
            ASSIGN
                 b_co_code = t_co_code
                 b_co_part = t_co_part 
                 b_co_um = t_co_um
                 b_co_lot = lotnbr
                 b_co_status = t_co_status
                 b_co_desc1 = t_co_desc1 
                 b_co_desc2 =  t_co_desc2
                 b_co_qty_ini =  t_co_qty_ini 
                 b_co_qty_cur =  t_co_qty_cur 
                 b_co_qty_std  =  t_co_qty_std
                 b_co_ser =  t_co_ser
                 b_co_ref =  t_co_ref
                 b_co_site = bcsite
                 b_co_loc = bcloc
                 b_co_format = t_co_format.
            CREATE b_cot_det.
            ASSIGN 
                b_cot_code = t_co_code
                b_cot_status = "MAT-CRE"
                b_cot_date = TODAY
                b_cot_time = TIME.
        END.

        {gprun.i ""mgwrbf.p"" "(INPUT """",
                                             INPUT """",
                                             INPUT """",
                                             INPUT bcpart,
                                             INPUT """",
                                             INPUT """",
                                             INPUT bcqty,
                                             INPUT """",
                                             INPUT TODAY,
                                             INPUT """",
                                             INPUT """",
                                             INPUT """",
                                             INPUT """",
                                             INPUT """",
                                             INPUT bcloc,
                                             INPUT bcsite,
                                             INPUT ""iclotr04.p"",
                                             INPUT bcsite,
                                             INPUT bcloc,
                                             INPUT lotnbr,
                                             INPUT """",
                                             INPUT YES,
                                             INPUT """",
                                             INPUT """",
                                             INPUT """",
                                             INPUT """",
                                             INPUT """",
                                             INPUT """",
                                             INPUT """",
                                             INPUT """",
                                             INPUT """",
                                             INPUT """",
                                             INPUT """",
                                             INPUT """",
                                             INPUT """",
                                             OUTPUT bfid)"}
              /*b_bf_nbr*/  /*b_bf_line*/ /*b_bf_code*/ /*b_bf_part*/  /*b_bf_lot*/   /*b_bf_ser*/   /*b_bf_qty*/  /*b_bf_um*/  /*b_bf_enterdate*/ /*b_bf_tr_date*/ 
              /*b_bf_eff_date*/ /*b_bf_trtype*/  /*b_bf_trnbr*/  /*b_bf_ntime*/  /*b_bf_loc*/  /*b_bf_site*/  /*b_bf_program*/  /*b_bf_tosite*/ /*b_bf_toloc*/  
              /*b_bf_tolot*/ /*b_bf_toser*/  /*b_bf_tocim*/   /*b_bf_sess*/  /*b_bf_ref*/ /*b_bf_trid1*/  /*b_bf_trid2*/  /*b_bf_bc01*/  /*b_bf_bc02*/    /*b_bf_bc03*/  
              /*b_bf_bc04*/   /*b_bf_bc05*/ /*b_bf_emp*/   
                {gprun.i ""mgwrfl.p"" "(input ""iclotr04.p"", input bfid)"}
                {gprun.i ""mgecim06.p"" "(input bfid, output succeed)"} 
            IF succeed THEN STATUS INPUT "�ɹ�".
            ELSE DO:
                STATUS INPUT "����".
                UNDO, LEAVE mainloop.
            END.
    END. /*do*/
END.  /*procedure*/


