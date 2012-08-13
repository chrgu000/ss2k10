{mfdtitle.i}
{bcdeclre.i}
 {bcini.i}
 {bcwin.i}

DEFINE INPUT PARAMETER xktype AS CHARACTER.
DEFINE OUTPUT PARAMETER sucess AS LOGICAL INITIAL FALSE.

DEFINE VARIABLE active AS LOGICAL.  /*if barcode active*/

DEFINE VARIABLE bccode LIKE b_co_code LABEL "����".
DEFINE VARIABLE ponbr LIKE po_nbr LABEL "�ɹ�����".
DEFINE VARIABLE podline LIKE pod_line LABEL "��".
DEFINE VARIABLE bcpart LIKE pod_part LABEL "�����".
DEFINE VARIABLE qty_ord LIKE pod_qty_ord LABEL "������".
DEFINE VARIABLE qty_rcvd LIKE pod_qty_rcvd LABEL "������".
DEFINE VARIABLE bcqty LIKE b_co_qty_cur LABEL "��������".
DEFINE VARIABLE bcsite LIKE b_co_site.
DEFINE VARIABLE bcloc LIKE b_co_loc.
DEFINE VARIABLE psite LIKE pod_site LABEL "�ص�".
DEFINE VARIABLE ploc LIKE pod_loc LABEL "��λ".
DEFINE VARIABLE bclot LIKE pod_lot_next LABEL "����".
DEFINE VARIABLE bcstatus LIKE b_co_status LABEL "����״̬".

DEFINE SHARED TEMP-TABLE co_list
    FIELD co_part LIKE pt_part
    FIELD co_qty_req AS DECIMAL
    FIELD co_qty_iss AS DECIMAL
    FIELD co_qty_bo AS DECIMAL
    FIELD co_site LIKE pt_site
    FIELD co_loc LIKE loc_loc.

DEFINE SHARED TEMP-TABLE cot_tmp
    FIELD cot_code LIKE b_co_code
    FIELD cot_part LIKE b_co_part
    FIELD cot_lot LIKE b_co_lot.

DEFINE shared temp-table xkprhhist
             field xkprhnbr      as char format "x(8)"
             field xkprhponbr    as char format "x(8)"
             field xkprhline     as integer format ">,>>>,>>9"
             field xkprhpart     as char format "x(18)"
             field xkprhrctdate  as date format "99/99/99"
             field xkprheffdate  as date format "99/99/99"
             field xkprhqty      as decimal format ">>,>>9.99"
             field xkprhvend     as char format "x(8)"
             field xkprhdsite    as char format "x(8)"
             field xkprhdloc     as char format "x(18)"
             field xkprhssite    as char format "x(18)"
             field xkprhssloc    as char format "x(18)"       
             field xkprhinrcvd   as logical 
             field xkprhregion   as char format "x(8)"
             field xkprhkbid     as char format "x(20)"
             index  xkprhinrcvd xkprhinrcvd xkprhponbr xkprheffdate.

DEFINE QUERY q_prh FOR xkprhhist.
DEFINE QUERY q_co FOR co_list.
DEFINE BROWSE b_co QUERY q_co 
    DISP co_part   LABEL "���"
             co_qty_req LABEL "������"
             co_qty_iss LABEL "������"
             co_qty_bo LABEL "B/O"
             co_site LABEL "�ص�"
             co_loc LABEL "��λ"
    WITH 10 DOWN SEPARATORS /*MULTIPLE*/ SIZE 60 BY 20 TITLE "�����ϸ" THREE-D EXPANDABLE.
DEFINE BUTTON btn_conf LABEL "ȷ��".

FORM
    bccode  SKIP
    b_co SKIP
    btn_conf
WITH FRAME a SIDE-LABEL THREE-D WIDTH 80.

FOR EACH co_list:
    DELETE co_list.
END.
FOR EACH cot_tmp:
    DELETE cot_tmp.
END.


FOR EACH xkprhhist:
     CREATE co_list.
        co_part = xkprhpart.
        co_qty_req = xkprhqty.
        co_qty_iss = 0.
        co_qty_bo = xkprhqty.
        co_site = xkprhdsite.
        co_loc = xkprhdloc.
END.

/*CREATE co_list.
co_part = "a".
co_qty_req = 100.*/
OPEN QUERY q_co  FOR EACH co_list.

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
    IF active NE YES THEN DO:
        STATUS INPUT "�޷�ʶ�������".
        RETURN.
    END.

    FIND FIRST cot_tmp NO-LOCK WHERE cot_code = bccode NO-ERROR.
    IF AVAILABLE cot_tmp THEN DO:
        STATUS INPUT "��������ɨ��,�˳�".
        bcpart = "".
        LEAVE.
    END.
    ELSE DO:
        CREATE cot_tmp.
        ASSIGN cot_code = bccode
            cot_part = bcpart.
    END.

    ASSIGN bccode.
    
    APPLY "ENTER":U TO bccode.
    RETURN.
END.

main-loop:
REPEAT ON ERROR UNDO, LEAVE
              ON ENDKEY UNDO, LEAVE: 
           
      REPEAT:
      PROMPT-FOR bccode  WITH FRAME a.




      FIND FIRST co_list EXCLUSIVE-LOCK WHERE co_part = bcpart NO-ERROR.
        IF AVAILABLE co_list THEN DO:
             co_qty_iss = co_qty_iss + bcqty.
             co_qty_bo = co_qty_req - co_qty_iss.

             bcsite = co_site.
             bcloc = co_loc.
             
                 FIND FIRST b_co_mstr NO-LOCK WHERE b_co_code = bccode NO-ERROR.
                 IF NOT AVAILABLE b_co_mstr THEN DO:
                     CREATE b_co_mstr.
                     ASSIGN
                          b_co_code = bccode
                          b_co_part = bcpart 
                          b_co_um = ""
                          b_co_lot = bclot
                          b_co_status = ""
                          b_co_desc1 =""
                          b_co_desc2 =  ""
                          b_co_qty_ini = bcqty
                          b_co_qty_cur =  bcqty
                          b_co_qty_std  = bcqty
                          b_co_ser = 0
                          b_co_ref = ""
                          b_co_site = bcsite
                          b_co_loc = bcloc
                          b_co_format ="".
                 END.

          {bcco001.i bccode bcpart bcqty bcsite bcloc bclot """" }
             
      END.
      ELSE STATUS INPUT "�޷���Ҫ�����з���ƥ��ļ�¼".

      OPEN QUERY q_co FOR EACH co_list.
    END.  /*repeat*/

    DEFINE VARIABLE yn AS LOGICAL.
    MESSAGE "ȷ�����ɨ�裿" VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO-CANCEL UPDATE yn.
    IF yn = YES THEN DO:

        FOR FIRST b_ct_ctrl:
        END.
        IF b_ct_fifo_stock  THEN DO:
            DEFINE VARIABLE lot1 LIKE ld_lot.
            DEFINE VARIABLE co1 LIKE b_co_code.
            DEFINE VARIABLE lot2 LIKE ld_lot INITIAL "".

            FOR EACH co_list:
                FOR EACH t_co_mstr WHERE t_co_part = co_part:
                      IF t_co_lot > lot2 THEN lot2 = t_co_lot.
                END.
                FOR EACH b_co_mstr WHERE b_co_part = co_part AND b_co_status = "MAT-STOCK" BY b_co_lot:
                    lot1 = b_co_lot.
                    co1 = b_co_code.
                    IF NOT CAN-FIND(t_co_mstr WHERE t_co_code = b_co_code AND t_co_part = co_part) THEN DO:
                     IF lot1 < lot2 THEN DO:
                         MESSAGE "û��ִ���Ƚ��ȳ�,,�������:" + co_part + "����������:" + lot1 + "�������" + co1.
                         LEAVE main-loop.
                     END.
                    END.
                END.
             END.
        END.
    
      FOR EACH co_list NO-LOCK:
         IF co_qty_bo <> 0 THEN DO:
            MESSAGE "��������Ҫ������ƥ�䣡".
            NEXT main-loop.
         END.
         ELSE DO:
           /*��������״̬, �ŵ�xkictrans.i�ﴦ����*/
           /*  CASE xktype:
                 WHEN "INTERNAL" THEN DO:
                     {bcco002.i ""MAT-PROD""}
                 END.
                     
                 WHEN "EXTERNAL" THEN DO:
                      {bcco002.i ""MAT-STOCK""}
                 END.
                    
             END CASE.
           */  
           sucess = TRUE.
           
           LEAVE main-loop. 
         END.  /*��������״̬*/

      END.  /*for each co_list*/
    END.

    ELSE IF yn = NO THEN DO:
       NEXT  main-loop.
    END.

    ELSE IF yn = ? THEN DO:
       LEAVE main-loop.
    END. /*�Ƿ��������ɨ��*/
END. /*repeat*/



/*
        DELETE WIDGET current-window.
        APPLY "CLOSE":U TO THIS-PROCEDURE.
        RETURN NO-APPLY .  */
