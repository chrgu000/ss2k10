{mfdtitle.i}
{bcdeclre.i NEW }
{bcwin.i}



/*DEFINE SHARED VARIABLE batchid LIKE b_shp_batch LABEL "����".*/

DEFINE VARIABLE bfid LIKE b_bf_id.
DEFINE VARIABLE bfparid LIKE b_bf_id.
DEFINE VARIABLE succeed AS LOGICAL.
DEFINE VARIABLE wonbr LIKE wo_nbr.
DEFINE VARIABLE lotnbr LIKE ld_lot.

DEFINE BUTTON btn_exec LABEL "ִ��".
DEFINE BUTTON btn_quit LABEL "�˳�".

DEFINE TEMP-TABLE t_wis
    FIELD t_part LIKE b_wis_part
    FIELD t_lot LIKE b_wis_lot
    FIELD t_qty LIKE b_wis_qty.

DEFINE QUERY q_wis FOR t_wis.
/*DEFINE BROWSE b_rct QUERY q_rct
    DISP
    b_rct_part LABEL "���"
    b_rct_qty LABEL "����"
    b_rct_batch LABEL "����"
    b_rct_ponbr LABEL "����"
    b_rct_podline LABEL "��"
    b_rct_site LABEL "���ص�"
    b_rct_loc LABEL "����λ"
    b_rct_date LABEL "�´�����"
    WITH 12 DOWN WIDTH 29.7
    TITLE "�ջ��嵥".*/

DEFINE BROWSE b_wis QUERY q_wis
    DISP
    t_part LABEL "���"
    t_qty LABEL "����"
    t_lot LABEL "����"
    WITH 12 DOWN WIDTH 28 SCROLLABLE
    TITLE "�س��嵥".

DEFINE FRAME a
   SKIP(1)
    b_wis
    SKIP(.3)
    space(22)   btn_exec /*SPACE(2) btn_qui*/
 WITH  WIDTH 30 TITLE "�ӹ����س�"  SIDE-LABELS  NO-UNDERLINE THREE-D.


ON 'choose':U OF btn_exec
DO:
    btn_exec:SENSITIVE = FALSE.
    STATUS INPUT "��ʼ���лس���ҵ".
    RUN exec.
    RUN gettw.
    OPEN QUERY q_wis FOR EACH t_wis.
    btn_exec:SENSITIVE = TRUE.
    RETURN.
END.






RUN gettw.
OPEN QUERY q_wis FOR EACH t_wis.
REPEAT:
    UPDATE b_wis  btn_exec WITH FRAME a.
END.
/*ENABLE ALL WITH FRAME a.
{bctrail.i}
  */



PROCEDURE exec:
    OUTPUT TO d:\temp\bkfl.LOG APPEND.
    PUT SKIP(10).
    PUT "��ʼ�س�,����:". PUT CONTROL TODAY. PUT "ʱ��:". PUT CONTROL TIME. PUT SKIP.
 FOR EACH t_wis:
     PUT "���:". PUT CONTROL t_part. PUT "����". PUT CONTROL t_qty. PUT "����". PUT CONTROL t_lot. PUT SKIP.
    RUN runcim(INPUT t_part, INPUT t_qty, INPUT t_lot).
 END. /*for each t_wis*/
   OUTPUT CLOSE.
END. /*procedure exec*/


PROCEDURE runcim:
    DEFINE INPUT PARAMETER t_part LIKE pt_part.
    DEFINE INPUT PARAMETER t_qty LIKE b_wis_qty.
    DEFINE INPUT PARAMETER t_lot LIKE ld_lot.
      mainloop:
      DO ON ERROR UNDO,LEAVE:

             FIND FIRST pt_mstr NO-LOCK WHERE pt_part = t_part NO-ERROR.
             IF AVAILABLE pt_mstr THEN DO:
                  IF pt_status NE "a" THEN DO:
                      RUN errorproc (INPUT t_part, INPUT t_lot, INPUT "LABOR_REP", INPUT "FAILED", INPUT "�����״̬������A").
                      STATUS INPUT "�����״̬������A,�˳�".
                      UNDO, NEXT.
                  END.
             END.

             RUN getwonbr (OUTPUT wonbr).

             PUT "CIM�ӹ������:". PUT CONTROL t_part. PUT "����". PUT CONTROL t_qty. PUT "����". PUT CONTROL t_lot. PUT "�ӹ���". PUT CONTROL wonbr. PUT SKIP.
         /*{bcco001.i b_wis_code b_wis_part b_wis_qty b_wis_site b_wis_loc """" """"}*/
             
             {gprun.i ""mgwrbf.p"" "(INPUT wonbr,
                                                         INPUT """",
                                                         INPUT """",
                                                         INPUT t_part,
                                                         INPUT """",
                                                         INPUT """",
                                                         INPUT t_qty,
                                                         INPUT """",
                                                         INPUT """",
                                                         INPUT """",
                                                         INPUT """",
                                                         INPUT """",
                                                         INPUT """",
                                                         INPUT """",
                                                         INPUT """",
                                                         INPUT "1000",
                                                         INPUT ""wowomt.p"",
                                                         INPUT """",
                                                         INPUT """",
                                                         INPUT """",
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
                                                         INPUT ""wo_mstr"",
                                                         INPUT """",
                                                         OUTPUT bfid)"}
             {gprun.i ""mgwrfl.p"" "(input ""wowomt.p"", input bfid)"}
             {gprun.i ""mgecim13.p"" "(input bfid, output succeed)"} 
             IF NOT succeed  THEN DO:
                 RUN errorproc (INPUT t_part, INPUT t_lot, INPUT "LABOR_REP", INPUT "FAILED", INPUT "CIM�ӹ������ִ���"). 
                 STATUS INPUT "CIM�ӹ������ִ���,�˳�".
                 UNDO, NEXT.
             END.
             ELSE DO:
                 STATUS INPUT "CIM�ӹ�������".
             END.

             DEFINE VARIABLE locsta AS LOGICAL INITIAL FALSE.
             FOR EACH wod_det WHERE wod_nbr = wonbr:
                  FIND FIRST loc_mstr WHERE loc_loc = wod_loc NO-LOCK NO-ERROR.
                  IF AVAILABLE loc_mstr THEN
                       IF loc_status NE  "YNY" THEN DO:
                           FIND FIRST pt_mstr NO-LOCK WHERE pt_part = wod_part NO-ERROR.
                           IF AVAILABLE pt_mstr THEN DO:
                                 IF pt_iss_pol = NO THEN DO:
                                     locsta = TRUE.
                                 END.
                                 ELSE DO:
                                     RUN errorproc (INPUT t_part, INPUT t_lot, INPUT "LABOR_REP", INPUT "FAILED", INPUT "��������״̬Ϊ��YNY,�����Ų���ΪYES").
                                     STATUS INPUT "��������״̬Ϊ��YNY,�����Ų���ΪYES,�˳�".
                                     locsta = FALSE.
                                     LEAVE.
                                 END.
                           END.  /*find pt_mstr*/
                           ELSE DO:
                               RUN errorproc (INPUT t_part, INPUT t_lot, INPUT "LABOR_REP", INPUT "FAILED", INPUT "��������״̬Ϊ��YNY,���Ҳ������������").
                               STATUS INPUT "��������״̬Ϊ��YNY,���Ҳ������������,�˳�".
                               locsta = FALSE.
                               LEAVE.
                           END.

                       END.
                       ELSE DO:
                           locsta = TRUE.
                       END.
                  ELSE DO:
                      locsta = FALSE.
                      RUN errorproc (INPUT t_part, INPUT t_lot, INPUT "LABOR_REP", INPUT "FAILED", INPUT "û�з���������س��λ").
                      STATUS INPUT "û�з���������س��λ,�˳�".
                      LEAVE.
                  END.
             END.
             IF locsta = FALSE THEN DO:
                 UNDO, NEXT.
             END.


             PUT "�ӹ����س����:". PUT CONTROL t_part. PUT "����". PUT CONTROL t_qty. PUT "����". PUT CONTROL t_lot. PUT "�ӹ���". PUT CONTROL wonbr. PUT SKIP.
             {gprun.i ""mgwrbf.p"" "(INPUT wonbr,
                                                         INPUT """",
                                                         INPUT """",
                                                         INPUT t_part,
                                                         INPUT t_lot,
                                                         INPUT """",
                                                         INPUT t_qty,
                                                         INPUT """",
                                                         INPUT """",
                                                         INPUT """",
                                                         INPUT """",
                                                         INPUT """",
                                                         INPUT """",
                                                         INPUT """",
                                                         INPUT """",
                                                         INPUT "1000",
                                                         INPUT ""wowoisrc.p"",
                                                         INPUT """",
                                                         INPUT """",
                                                         INPUT """",
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
                                                         INPUT ""wo_mstr"",
                                                         INPUT """",
                                                         OUTPUT bfid)"}
             {gprun.i ""mgwrfl.p"" "(input ""wowoisrc.p"", input bfid)"}
             {gprun.i ""mgecim12.p"" "(input bfid, output succeed)"} 
             IF NOT succeed  THEN DO:
                 RUN errorproc (INPUT t_part, INPUT t_lot, INPUT "LABOR_REP", INPUT "FAILED", INPUT "�س���ִ���"). 
                 STATUS INPUT "CIM�س���ִ���,�˳�".
                 NEXT.
             END.
             ELSE DO:
                /* RUN succeedproc (INPUT t_part, INPUT t_lot, INPUT "FINI-GOOD",  INPUT "LABOR_REP", INPUT "SUCCEED", INPUT "",INPUT "FINI-RCT"). */
                 STATUS INPUT "CIM�س�����".
             END.




             DEFINE VARIABLE optr LIKE wr_op.  
             SELECT MAX(wr_op) INTO optr FROM wr_route WHERE wr_nbr = wonbr.
             IF optr = ? THEN DO:
                  RUN errorproc (INPUT t_part, INPUT t_lot, INPUT "LABOR_REP", INPUT "FAILED", INPUT "�������û�ж���,�޷��㱨��ʱ"). 
                 STATUS INPUT "�������û�ж���,�޷��㱨��ʱ,�˳�".
                 NEXT.
             END.


             PUT "��ʱ�㱨���:". PUT CONTROL t_part. PUT "����". PUT CONTROL t_qty. PUT "����". PUT CONTROL t_lot.  PUT "�ӹ���". PUT CONTROL wonbr. PUT SKIP.
             {gprun.i ""mgwrbf.p"" "(INPUT wonbr,
                                                         INPUT """",
                                                         INPUT """",
                                                         INPUT t_part,
                                                         INPUT t_lot,
                                                         INPUT optr,
                                                         INPUT t_qty,
                                                         INPUT """",/**/
                                                         INPUT """",
                                                         INPUT """",
                                                         INPUT """",
                                                         INPUT """",
                                                         INPUT """",
                                                         INPUT """",
                                                         INPUT """",
                                                         INPUT "1000",
                                                         INPUT ""sfoptr01.p"",
                                                         INPUT """",
                                                         INPUT """",
                                                         INPUT """",
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
                                                         INPUT ""op_hist"",
                                                         INPUT """",
                                                         OUTPUT bfid)"}
         /*b_bf_nbr*/  /*b_bf_line*/ /*b_bf_code*/ /*b_bf_part*/  /*b_bf_lot*/   /*b_bf_ser*/   /*b_bf_qty*/  /*b_bf_um*/  /*b_bf_enterdate*/ /*b_bf_tr_date*/ 
         /*b_bf_eff_date*/ /*b_bf_trtype*/  /*b_bf_trnbr*/  /*b_bf_ntime*/  /*b_bf_loc*/  /*b_bf_site*/  /*b_bf_program*/  /*b_bf_tosite*/ /*b_bf_toloc*/  
         /*b_bf_tolot*/ /*b_bf_toser*/  /*b_bf_tocim*/   /*b_bf_sess*/  /*b_bf_ref*/ /*b_bf_trid1*/  /*b_bf_trid2*/  /*b_bf_bc01*/  /*b_bf_bc02*/    /*b_bf_bc03*/  
         /*b_bf_bc04*/   /*b_bf_bc05*/ /*b_bf_emp*/   /*b_bf_par_id*/ /*b_bf_dataset*/ /*b_bf_abs_id*/
             {gprun.i ""mgwrfl.p"" "(input ""sfoptr01.p"", input bfid)"}
             {gprun.i ""mgecim14.p"" "(input bfid, output succeed)"} 

             IF NOT succeed  THEN DO:
                 RUN errorproc (INPUT t_part, INPUT t_lot, INPUT "LABOR_REP", INPUT "FAILED", INPUT "��ʱ�㱨���ִ���"). 
                 STATUS INPUT "��ʱ�㱨���ִ���,�˳�".
                 UNDO, LEAVE mainloop.
             END.
             ELSE DO:
                 RUN succeedproc (INPUT t_part, INPUT t_lot, INPUT "FINI-GOOD",  INPUT "LABOR_REP", INPUT "SUCCEED", INPUT "",INPUT "FINI-RCT"). 
                 STATUS INPUT "��ʱ�㱨����".
                  IF succeed = TRUE  THEN STATUS INPUT t_part + "���".
             END.


        
          
     END.  /*do*/
END. /*run cim*/
    /*MESSAGE t_part VIEW-AS ALERT-BOX.*/



PROCEDURE gettw:
    FOR EACH t_wis:
        DELETE t_wis.
    END.
    FOR EACH b_wis_wkfl WHERE b_wis_status = "HOLD":
        FIND FIRST pt_mstr NO-LOCK WHERE pt_part = b_wis_part NO-ERROR.
        IF AVAILABLE pt_mstr THEN DO:
             IF pt_status = "e" THEN DO:
             END.
             ELSE DO:
                 ASSIGN b_wis_status = "TOBK".
             END.
        END.
    END.
    FOR EACH b_wis_wkfl WHERE (b_wis_status = "TOBK" OR b_wis_status = "PRO")
         BREAK BY b_wis_part BY  b_wis_lot:
    ACCUMULATE b_wis_qty (TOTAL BY b_wis_lot).
    IF LAST-OF(b_wis_lot) THEN DO:
        CREATE t_wis.
        ASSIGN t_part = b_wis_part
            t_lot = b_wis_lot
            t_qty = ACCUMU TOTAL BY b_wis_lot b_wis_qty.
    END.
    ASSIGN b_wis_status = "PRO".
    END.
END.

 
PROCEDURE getwonbr:
  DEFINE OUTPUT PARAMETER wonbr LIKE wo_nbr.
  find first woc_ctrl no-lock no-error.
            {mfnctrl.i woc_ctrl woc_nbr wo_mstr wo_nbr wonbr}
END.

PROCEDURE errorproc:
    DEFINE INPUT PARAMETER wpart LIKE b_wis_part.
    DEFINE INPUT PARAMETER wlot LIKE b_wis_lot.

    DEFINE INPUT PARAMETER optype LIKE b_op_type.
    DEFINE INPUT PARAMETER opstatus LIKE b_op_status.
    DEFINE INPUT PARAMETER opdesc LIKE b_op_desc.


    FOR EACH b_wis_wkfl WHERE b_wis_status = "PRO" AND b_wis_part = wpart
        AND b_wis_lot = wlot:

        b_wis_status = "HOLD".
        b_wis_wonbr = wonbr.

        {gprun.i ""mgwrop.p"" "(
            INPUT b_wis_code,
            INPUT b_wis_part,
            INPUT optype,
            INPUT opstatus,
            INPUT b_wis_site,
            INPUT b_wis_loc,
            INPUT b_wis_loc,
            INPUT b_wis_qty,
            INPUT TODAY,
            INPUT TIME,
            INPUT opdesc
            )"}

    END.
END.


PROCEDURE succeedproc:
    DEFINE INPUT PARAMETER wpart LIKE b_wis_part.
    DEFINE INPUT PARAMETER wlot LIKE b_wis_lot.

    DEFINE INPUT PARAMETER bcstatus LIKE b_co_status.

    DEFINE INPUT PARAMETER optype LIKE b_op_type.
    DEFINE INPUT PARAMETER opstatus LIKE b_op_status.
    DEFINE INPUT PARAMETER opdesc LIKE b_op_desc.
    DEFINE INPUT PARAMETER trtype LIKE b_tr_type.


    FOR EACH b_wis_wkfl WHERE b_wis_status = "PRO" AND b_wis_part = wpart
        AND b_wis_lot = wlot:
        FOR FIRST wo_mstr WHERE wo_nbr = wonbr:
        END.
        FIND FIRST b_co_mstr EXCLUSIVE-LOCK WHERE b_co_code = b_wis_code NO-ERROR.
        IF AVAILABLE b_co_mstr THEN DO:
            ASSIGN b_co_status = bcstatus
                         b_co_lot  = wlot
                         b_co_wolot = wo_lot.
        END.

        {wrcotrtime.i b_wis_code bcstatus}
        b_wis_status = "CIMED".
        b_wis_wonbr = wonbr.

        {gprun.i ""mgwrop.p"" "(
            INPUT b_wis_code,
            INPUT b_wis_part,
            INPUT optype,
            INPUT opstatus,
            INPUT b_wis_site,
            INPUT b_wis_loc,
            INPUT b_wis_loc,
            INPUT b_wis_qty,
            INPUT TODAY,
            INPUT TIME,
            INPUT opdesc
            )"}

        {gprun.i ""mgwrtr.p"" "(
            INPUT b_wis_code,
            INPUT b_wis_part,
            INPUT wonbr,
            INPUT trtype,
            INPUT b_wis_site,
            INPUT b_wis_loc,
            INPUT b_wis_loc,
            INPUT b_wis_qty,
            INPUT TODAY,
            INPUT TIME
            )"}
    END.

END.
