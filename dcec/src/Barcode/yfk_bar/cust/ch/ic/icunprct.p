{mfdtitle.i}
{bcdeclre.i NEW}
{bcini.i}
{bcwin.i}

DEFINE VARIABLE bccode LIKE b_co_code LABEL "����".
DEFINE VARIABLE bcpart LIKE b_co_part LABEL "�����".
DEFINE VARIABLE bcdpart LIKE pod_part LABEL "�����".
DEFINE VARIABLE bcqty LIKE b_co_qty_cur LABEL "��������".
DEFINE VARIABLE bcsite LIKE pod_site LABEL "�ص�".
DEFINE VARIABLE bcloc LIKE pod_loc LABEL "��λ".
DEFINE VARIABLE bclot LIKE pod_lot_next LABEL "����".
DEFINE VARIABLE bcstatus LIKE b_co_status LABEL "����״̬".

DEFINE VARIABLE accode LIKE ac_code LABEL "�ʺ�".
DEFINE VARIABLE sbsub LIKE sb_sub LABEL "���ʺ�".
DEFINE VARIABLE ccctr LIKE cc_ctr LABEL "�ɱ�����".
DEFINE VARIABLE pjproject LIKE pj_project LABEL "��Ŀ".

/*buffer record id used to exec CIM */
DEFINE VARIABLE bfid AS INTEGER.  /*indicate the buffer id*/
DEFINE VARIABLE active AS LOGICAL.  /*if barcode active*/

DEFINE BUTTON btn_iss LABEL "���".
DEFINE BUTTON btn_quit LABEL "�˳�".

DEF FRAME a
    SKIP(1)
    "����:" AT 1 SKIP
    bccode NO-LABEL AT 1 SKIP(.3) 
    bcpart COLON 8 SKIP(.3) 
    bcqty COLON 8  SKIP(.3)
    bcsite COLON 8  SKIP(.3)
    bcloc COLON 8  SKIP(.3)
    bclot COLON 8  SKIP(.3)
    accode COLON 8  SKIP(.3)
    sbsub COLON 8  SKIP(.3)
    ccctr COLON 8  SKIP(.3)
    pjproject COLON 8  SKIP(.3)
     space(15) btn_iss SPACE(2) btn_quit
WITH  SIZE 30 BY 18 TITLE "�ƻ������"  SIDE-LABELS  NO-UNDERLINE THREE-D.

ON 'value-changed':U OF bccode 
DO:
    ASSIGN bccode.
    {gprun.i ""bccock.p""  "( INPUT bccode,
                                          OUTPUT active,
                                          OUTPUT bcpart,
                                          OUTPUT bcqty,
                                          OUTPUT bcsite,
                                          OUTPUT bcloc,
                                          OUTPUT bclot,
                                          OUTPUT bcstatus )"}
    IF active =YES THEN DO:
        DISP bcpart  bcqty bcsite bcloc  bclot WITH FRAME a.
    END.
    ELSE DO:
        DISP "" @ bcpart  "" @ bcqty  "" @ bcsite  "" @ bcloc "" @ bclot WITH FRAME a.
        STATUS INPUT "�޷�ʶ�������".
    END.
    RETURN.
END.
    
ON 'leave':U OF accode
DO:
    ASSIGN accode.
    FIND FIRST ac_mstr NO-LOCK WHERE ac_code = accode NO-ERROR.
    IF NOT AVAILABLE ac_mstr THEN DO:
        STATUS INPUT "��Ч�ʻ�,�˳�".
        accode = "".
        RETURN.
    END.
    RETURN.
END.

ON 'leave':U OF sbsub
DO:
    ASSIGN sbsub.
    FIND FIRST sb_mstr NO-LOCK WHERE sb_sub = sbsub NO-ERROR.
    IF NOT AVAILABLE sb_mstr THEN DO:
        STATUS INPUT "��Ч���ʻ�,�˳�".
        sbsub = "".
        RETURN.
    END.
    RETURN.
END.

ON 'leave':U OF ccctr
DO:
    ASSIGN ccctr.
    FIND FIRST cc_mstr NO-LOCK WHERE cc_ctr = ccctr NO-ERROR.
    IF NOT AVAILABLE cc_mstr THEN DO:
        STATUS INPUT "��Ч�ɱ�����,�˳�".
        ccctr = "".
        RETURN.
    END.
    RETURN.
END.

ON 'leave':U OF pjproject
DO:
    ASSIGN pjproject.
    FIND FIRST pj_mstr NO-LOCK WHERE pj_project = accode NO-ERROR.
    IF NOT AVAILABLE pj_mstr THEN DO:
        STATUS INPUT "��Ч��Ŀ,�˳�".
        pjproject = "".
        RETURN.
    END.
    RETURN.
END.







ON 'choose':U OF btn_iss
DO:
    ASSIGN bccode
        bcpart
        bcqty
        bcsite
        bcloc
        bclot
        accode
        sbsub
        ccctr
        pjproject.
    IF bcpart = "" OR bcloc = "" OR bcsite = "" OR bcqty = 0
        OR accode = ""  THEN DO:
        MESSAGE "���ϲ�����������ִ��,�����˳�".
        RETURN.
    END.
    {bcco001.i bccode bcpart bcqty bcsite bcloc bclot """"}
    {gprun.i ""mgwrbf.p"" "(INPUT """",
                                     INPUT """",
                                     INPUT """",
                                     INPUT bcpart,
                                     INPUT bclot,
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
                                     INPUT ""icunrc.p"",
                                     INPUT """",
                                     INPUT """",
                                     INPUT """",
                                     INPUT """",
                                     INPUT YES,
                                     INPUT """",
                                     INPUT """",
                                     INPUT """",
                                     INPUT """",
                                     INPUT accode,
                                     INPUT sbsub,
                                     INPUT ccctr,
                                     INPUT pjproject,
                                     INPUT """",
                                     INPUT """",
                                     INPUT """",
                                     INPUT ""ld_det"",
                                     INPUT """",
                                     OUTPUT bfid)"}
/*b_bf_nbr*/  /*b_bf_line*/ /*b_bf_code*/ /*b_bf_part*/  /*b_bf_lot*/   /*b_bf_ser*/   /*b_bf_qty*/  /*b_bf_um*/  /*b_bf_enterdate*/ /*b_bf_tr_date*/ 
/*b_bf_eff_date*/ /*b_bf_trtype*/  /*b_bf_trnbr*/  /*b_bf_ntime*/  /*b_bf_loc*/  /*b_bf_site*/  /*b_bf_program*/  /*b_bf_tosite*/ /*b_bf_toloc*/  
/*b_bf_tolot*/ /*b_bf_toser*/  /*b_bf_tocim*/   /*b_bf_sess*/  /*b_bf_ref*/ /*b_bf_trid1*/  /*b_bf_trid2*/  /*b_bf_bc01*/  /*b_bf_bc02*/    /*b_bf_bc03*/  
/*b_bf_bc04*/   /*b_bf_bc05*/ /*b_bf_emp*/   /*b_bf_par_id*/ /*b_bf_dataset*/ /*b_bf_abs_id*/

        {gprun.i ""mgwrfl.p"" "(input ""icunrc.p"", input bfid)"}
        {gprun.i ""mgecim04.p"" "(input bfid)"} 
        
    ENABLE ALL WITH FRAME a.

    RETURN.
END.


ENABLE ALL WITH FRAME a.
{BCTRAIL.I}



