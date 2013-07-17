/*a6rqormt.p 客户新订单需求维护....*/

{mfdtitle.i "test7"}

/*定义变量....*/
DEFINE VARIABLE CustPONO LIKE  a6rq_custpono.
DEFINE VARIABLE CustPOLN LIKE  a6rq_custpoln   INIT 1.
DEFINE VARIABLE Customer LIKE  a6rq_cust.
DEFINE VARIABLE site     LIKE  a6rq_site.
DEFINE VARIABLE part     LIKE  a6rq_part.
DEFINE VARIABLE rqqty    as decimal format ">>,>>>,>>9.9<<<"  INIT 0.
DEFINE VARIABLE duedate  LIKE  a6rq_due_date  INIT TODAY.
DEFINE VARIABLE consums  LIKE  a6rq_consums  INIT NO.
DEFINE VARIABLE remark   LIKE  a6rq_rmk1.
DEFINE VARIABLE CustName LIKE  ad_name.
DEFINE VARIABLE SiteName LIKE  si_desc.
DEFINE VARIABLE ptdesc   LIKE  pt_desc1.

/*定义Frames... */
FORM
   Customer COLON 30
   CustName NO-LABEL
   CustPONO COLON 30
   CustPOLN COLON 30
WITH FRAME a WIDTH 80 SIDE-LABELS ATTR-SPACE.

FORM
   site     COLON 30
   SiteName NO-LABEL
   part     COLON 30
   ptdesc   NO-LABEL
   rqqty    COLON 30
   duedate  COLON 30
   consums  COLON 30
   remark   COLON 30
WITH FRAME b WIDTH 80 SIDE-LABEL ATTR-SPACE.

/* SET EXTERNAL LABELS */
setFrameLabels(FRAME  a:HANDLE ).
setFrameLabels(FRAME  b:HANDLE ).


VIEW FRAME a.
VIEW FRAME b.

{mfdemo.i 07/10/2013 07/22/2013}
REPEAT  WITH  FRAME  a :
    CLEAR FRAME b NO-PAUSE.

    SET Customer  CustPONO   CustPOLN.


    /*稽核客户的合法性..*/
    FIND ad_mstr WHERE ad_addr = Customer NO-LOCK NO-ERROR.
    IF NOT AVAILABLE ad_mstr THEN DO:
        MESSAGE "该客户不存在,请重新输入!".
        UNDO , RETRY.
    END. /*IF NOT AVAILABLE ad_mstr THEN DO:*/
    ELSE ASSIGN CustName = ad_name.
    IF custpono = ''  THEN  DO:
        MESSAGE "客户订单号码,不能为空!".
        UNDO , RETRY.
    END.
    IF custpoln  <= 0  THEN DO :
        MESSAGE "客户订单项次,不能为空 !".
        UNDO , RETRY.
    END.
    /*
    ASSIGN customer = INPUT customer
           custpono = INPUT custpono
           custpoln = INPUT custpoln.*/

    /*是否已经维护过该资料..*/
    FOR FIRST a6rq_mstr WHERE a6rq_cust = Customer
          AND a6rq_custpono = CustPONO AND a6rq_CustPOLN = CustPOLN:
          ASSIGN site    = a6rq_site
                 part    = a6rq_part
                 rqqty   = a6rq_rq_qty
                 duedate = a6rq_due_date
                 consums = a6rq_consums
                 remark  = a6rq_rmk1.

        FIND pt_mstr WHERE pt_part = part NO-LOCK NO-ERROR.
        IF AVAILABLE pt_mstr THEN ASSIGN ptdesc = pt_desc1.

        FIND si_mstr WHERE si_site = site NO-LOCK NO-ERROR.
        IF AVAILABLE si_mstr THEN  ASSIGN SiteName = si_desc.
        DISP Customer
             CustName
             CustPONO
             CustPOLN
            WITH FRAME a.
        DISPLAY site
                SiteName
                part
                ptdesc
                rqqty
                duedate
                consums
                remark
            WITH FRAME b.

        /*稽核该需求是否可以修改...*/
        IF (a6rq_status <>  'R' AND a6rq_status = 'C' ) OR
           ( a6rq_status =  'R' AND a6rq_status <> 'C') THEN DO:
           IF a6rq_status = 'R'  THEN MESSAGE "该客户订单已发布,并等待客户的最终确认,不允许修改!".
           ELSE IF A6rq_status = 'C' THEN MESSAGE "该客户订单已取消,不允许修改!".
           UNDO , RETRY.
        END. /*IF a6rq_status <>  'S'  THEN DO:*/
        ELSE DO :
          /*修改客户需求 */
          ASSIGN
               a6rq_site       =  site
               a6rq_consums    = consums
               a6rq_part       = part
               a6rq_rq_qty     = rqqty
               a6rq_due_date   = duedate
               a6rq_reply      = NO
               a6rq_last_date  = today
               a6rq_last_user  = mfguser
               a6rq_cust       = Customer
               a6rq_rmk1       = remark.
            /*清理历史旧的记录*/
        FOR EACH a6rqd_det WHERE a6rqd_cust = Customer
             AND a6rqd_custpono = custpono
             AND a6rqd_custpoln = custpoln:
                DELETE a6rqd_det.
            END.
            FOR EACH a6rrd_det WHERE a6rrd_cust = customer
                 AND a6rrd_custpono = custpono
                 AND a6rrd_custpoln = custpoln:
                DELETE a6rrd_det.
            END.
        END.   /*ELSE DO :*/

    END. /*FOR FIRST a6rq_mstr WHERE a6rq_cust = Customer AND a6rq_custpono = CustPONO AND a6rq_CustPOLN = CustPOLN :*/

    REPEAT:
        SET site part rqqty  duedate consums  remark with frame b.

            FIND si_mstr WHERE si_site = site NO-LOCK NO-ERROR.
            IF AVAILABLE si_mstr THEN  ASSIGN SiteName = si_desc.
            ELSE DO:
                MESSAGE '地点不存在,请重新输入!'.
                UNDO,RETRY.
            END.

            IF NOT CAN-FIND(pt_mstr WHERE pt_part = part ) THEN DO:
                MESSAGE '该零件不存在,请重新输入!'.
                UNDO , RETRY.
            END.

            IF rqqty <= 0  THEN DO :
                MESSAGE '订购数量不能小于0,请重新输入!'.
                UNDO , RETRY.
            END.

            IF duedate < TODAY  THEN DO:
                MESSAGE '订单日期不能小于今天,请重新输入 '.
                UNDO ,RETRY.
            END.
            LEAVE.
    END.

    IF NOT AVAILABLE a6rq_mstr THEN DO:

  /*建立新的客户需求...*/
        CREATE a6rq_mstr.
        ASSIGN a6rq_site       =  site
               a6rq_custpono   = CustPONO
               a6rq_custpoln   = CustPOLN
               a6rq_cust       = Customer
               a6rq_consums    = consums
               a6rq_part       = part
               a6rq_rq_qty     = rqqty
               a6rq_due_date   = duedate
               a6rq_reply      = NO
               a6rq_crea_date  = today
               /* a6rq_crea_user  = mfguser */
               a6rq_last_date  = today
               a6rq_last_user  = mfguser
               a6rq_status     = 'S'
               a6rq_run        = YES
               a6rq_rmk1       = remark.


     END. /*IF NOT AVAILABLE a6rq_mstr THEN DO:  */

     /*根据产品结构 工作日历 物料计划参数 ,分解客户需求...*/
             {gprun.i ""a6psiq10.p"" "(
                     INPUT part ,
                     INPUT site ,
                     INPUT today ,
                     INPUT ''  ,
                     INPUT CustPONO ,
                     INPUT CustPOLN ,
                     INPUT DUEDATE ,
                     INPUT rqqty ,
                     INPUT customer
                 )" }
END.  /*REPEAT  WITH  FRAME  a :*/
