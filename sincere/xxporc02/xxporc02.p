/* ss - 100713.1 by: jack */
/* ss - 100714.1 by: jack */
/* ss - 100728.1 by: jack */
/* ss - 100809.1 by: jack */
/* ss - 101011.1 by: jack */
/* ss - 101111.1 by: jack */  /* 增加打印时间*/
/*
{mfdtitle.i "100805.1 "}
*/
/*
{mfdtitle.i "100809.1 "}
*/
/*
{mfdtitle.i "101011.1 "}
*/
{mfdtitle.i "101111.1 "}

define variable pages as integer.
DEFINE VARIABLE nbr      LIKE prh_nbr.   /* 工单 */
DEFINE VARIABLE nbr1     LIKE prh_nbr.
DEFINE VARIABLE rcvr     LIKE prh_receiver.  /* 收货单 */
DEFINE VARIABLE rcvr1    LIKE prh_receiver.
DEFINE VARIABLE vend     LIKE prh_vend.      /* 供应商 */
DEFINE VARIABLE vend1    LIKE prh_vend.
DEFINE VARIABLE rcv_date LIKE prh_rcp_date.  /* 收货日期 */
DEFINE VARIABLE rcv_date1 LIKE prh_rcp_date.
DEFINE VARIABLE includereturn  as logical .

DEFINE  variable page-start as integer FORMAT ">>9" .


DEFINE VARIABLE NEW_only1 AS LOGICAL  INITIAL yes.  /* 仅打印新的 */
DEFINE VARIABLE printcmts AS LOGICAL INITIAL yes. /* 打印全部说明 */
DEFINE VAR v_logical1 AS LOGICAL INITIAL YES .  /* 按供应商打印*/

DEFINE VARIABLE duplicate AS CHARACTER FORMAT "x(11)" LABEL "". /* 重复标志 */
DEFINE VARIABLE vendor   LIKE ad_name.                 /* 供应商名称 */
DEFINE VARIABLE rmks     LIKE po_rmks.                 /* 备注 */
DEFINE VARIABLE verision AS INTEGER FORMAT "9" INITIAL 0.           /* 版本 */
DEFINE VARIABLE char1    AS CHARACTER FORMAT "x(12)" LABEL "品质判定" .
DEFINE VARIABLE char2 AS CHARACTER FORMAT "x(12)" LABEL "确认者".

DEFINE VARIABLE l_tr_type LIKE tr_type.       /* 交易类型 */
DEFINE VARIABLE loc     LIKE pod_loc.               /* 库位 */
DEFINE VARIABLE trsite  LIKE tr_site.                /* 地点 */
DEFINE VAR v_cmmt AS CHAR FORMAT "x(90)" .

DEFINE VAR v_desc AS CHAR FORMAT "x(48)" .


DEFINE VARIABLE v_line AS INT FORMAT ">>9" .
DEFINE VARIABLE total-rcvd      LIKE prh_rcvd.     /* 接收数量合计 */
DEFINE VARIABLE total-ps_qty    LIKE prh_ps_qty. /* 装箱单数量合计 */
DEFINE VAR v_serial LIKE tr_serial .
DEFINE VAR v_rev LIKE pod_rev .
DEFINE VAR v_name LIKE ad_name .

define buffer prhhist for prh_hist.
DEFINE  VARIABLE prh_recno AS RECID.
/*ss-min001*/  define variable companyname  as char format "x(28)".
/*ss-min001*/  define variable xdnname      like xdn_name.
/*ss-min001*/  define variable xdnisonbr    like xdn_isonbr.
/*ss-min001*/  define variable xdnisover    like xdn_isover.
/*ss-min001*/  define variable xdntrain1    like xdn_train1 .
/*ss-min001*/  define variable xdntrain2    like xdn_train2 .
/*ss-min001*/  define variable xdntrain3    like xdn_train3 .
/*ss-min001*/  define variable xdntrain4    like xdn_train4 .
/*ss-min001*/  define variable xdntrain5    like xdn_train5 .
/*ss-min001*/  define variable xdnpage1    like xdn_page1 .
/*ss-min001*/  define variable xdnpage2    like xdn_page2 .
/*ss-min001*/  define variable xdnpage3    like xdn_page3 .
/*ss-min001*/  define variable xdnpage4    like xdn_page4 .
/*ss-min001*/  define variable xdnpage5    like xdn_page5 .
/*ss-min001*/  define variable xdnpage6    like xdn_page6 .

DEFINE TEMP-TABLE tmp_det NO-UNDO
    FIELD tmp_receiver  LIKE prh_receiver   LABEL "收货单"
    FIELD tmp_nbr LIKE prh_nbr
    FIELD tmp_line LIKE prh_line
    FIELD tmp_vend      LIKE prh_vend       LABEL "供应商编号"
    FIELD tmp_name      LIKE ad_name        LABEL "供应商名称"
    FIELD tmp_rcp_date  LIKE prh_rcp_date   LABEL "收货日期"
   FIELD tmp_rev  LIKE pod_rev
    FIELD tmp_serial LIKE ld_lot
    FIELD tmp_desc1 LIKE pt_desc1
    FIELD tmp_desc2 LIKE pt_desc2
    FIELD tmp_um LIKE prh_um
    FIELD tmp_part AS CHAR FORMAT "x(14)"
    FIELD tmp_rcvd  AS DECIMAL FORMAT  "->>,>>>,>>>.99"
    FIELD tmp_domain LIKE prh_domain
    /* ss - 100809.1 -b */
        FIELD tmp_cmmt AS CHAR FORMAT "x(76)"

   .
DEFINE VAR v_date AS DATE .

/* ss - 100809. 1-b */
DEFINE VAR v_rcp_date AS DATE .
/* ss - 100809.1 -e */

/* ss - 100809.1 -b */
/* ss - 101111.1 -b
 FORM  HEADER
                        " SINCERE-HOME" AT  45
                            "BG-CC-11"   AT 1   "采   购   退  货  单"   at 40     "收货日期:"  AT 70  v_rcp_date
                          "供应商:"        AT 1      v_name   AT 10
                          "打印日期:"   AT 70     v_date

                          "序号 收货单号  物料编码     物料描述                                           单位    数量        备注"  AT 1
                       "------------------------------------------------------------------------------------------------------------------------" AT 1
                                WITH FRAME phead1 PAGE-TOP NO-BOX  WIDTH 120.

                           /*    DISPLAY tmp_rcp_date tmp_name  v_date  WITH FRAME phead1 . */

ss - 101111.1 -e */
/* ss - 101111.1 -b */
 FORM  HEADER
                        " SINCERE-HOME" AT  45
                            "BG-CC-11"   AT 1   "采   购   退  货  单"   at 40     "收货日期:"  AT 70  v_rcp_date
                          "供应商:"        AT 1      v_name   AT 10
                          "打印日期:"   AT 70     v_date  SPACE(1) "时间:"  STRING(TIME,"hh:mm:ss")

                          "序号 收货单号  物料编码     物料描述                                           单位    数量        备注"  AT 1
                       "------------------------------------------------------------------------------------------------------------------------" AT 1
                                WITH FRAME phead1 PAGE-TOP NO-BOX  WIDTH 120.

                           /*    DISPLAY tmp_rcp_date tmp_name  v_date  WITH FRAME phead1 . */


/* ss - 101111.1 -e */


/* ss - 100809.1 -e */

FORM
    nbr     COLON 15 LABEL "采购单"
    nbr1    COLON 45 LABEL "至"
    rcvr    COLON 15 LABEL "收货单"
    rcvr1   COLON 45 LABEL "至"
    vend    COLON 15 LABEL "供应商"
    vend1   COLON 45 LABEL "至"

    rcv_date    COLON 15 LABEL "收货日期"
    rcv_date1   COLON 45 LABEL "至"
    loc          COLON 15 LABEL "库位"      "库位需要输入"    COLON 30
   NEW_only1    COLON 30 LABEL "仅打印新的"
    v_logical1 COLON 30 LABEL "合并打印"
   includereturn  COLON 30 LABEL "包含负数收货的退货"

    /*
    printcmts   COLON 30 LABEL "打印全部说明"
    */

    WITH FRAME a WIDTH 80 SIDE-LABEL.

{wbrp01.i}

rcv_date    = TODAY.
rcv_date1   = TODAY.

REPEAT :
    IF nbr1 = hi_char   THEN nbr1 = "".
    IF rcvr1 = hi_char  THEN rcvr1 = "".
    IF vend = hi_char   THEN vend1 = "".

    IF rcv_date = low_date  THEN rcv_date = ?.
    IF rcv_date1 = hi_date THEN rcv_date1 = ?.

    UPDATE
        nbr     nbr1
        rcvr    rcvr1
        vend    vend1

        rcv_date    rcv_date1
          loc
        NEW_only1
        v_logical1
  includereturn
        /*
        printcmts
        */
        WITH FRAME a.
    {wbrp06.i &COMMAND = UPDATE &FIELDS =" nbr nbr1
                                            rcvr rcvr1
                                            vend vend1

                                            rcv_date rcv_date1
                                            loc
                                            NEW_only1
                                           v_logical1
                                            /*
                                            printcmts
                                            */ " &frm = "a"}
    bcdparm = "".
    {mfquoter.i nbr}
    {mfquoter.i nbr1}
    {mfquoter.i rcvr}
    {mfquoter.i rcvr1}
    {mfquoter.i vend}
    {mfquoter.i vend1}
    {mfquoter.i loc}
    {mfquoter.i rcv_date}
    {mfquoter.i rcv_date1}
    {mfquoter.i NEW_only1}
         {mfquoter.i v_logical1 }
            {mfquoter.i  includereturn  }

        /*
    {mfquoter.i printcmts}
    */

    IF nbr1     = "" THEN nbr1      = hi_char.
    IF rcvr1    = "" THEN rcvr1     = hi_char.
    IF vend1    = "" THEN vend1     = hi_char.
    IF rcv_date = ?  THEN rcv_date  = low_date.
    IF rcv_date1= ?  THEN rcv_date1 = hi_date.

  /*  REPEAT ON ENDKEY UNDO,LEAVE: */
   /*     {mfselbpr.i "printer" 123} */
     {gpselout.i &printType = "printer"
               &printWidth = 132
               &pagedFlag = " "
               &stream = " "
               &appendToFile = " "
               &streamedOutputToTerminal = " "
               &withBatchOption = "yes"
               &displayStatementType = 1
               &withCancelMessage = "yes"
               &pageBottomMargin = 0
               &withEmail = "yes"
               &withWinprint = "yes"
               &defineVariables = "yes"}

        /* 清空临时表 */
        FOR EACH tmp_det:
            DELETE tmp_det.
        END.

   v_date = TODAY .



        FOR EACH prh_hist  USE-INDEX prh_rcp_date   NO-LOCK
            WHERE prh_domain = global_domain
          And prh_nbr >= nbr
                AND prh_nbr <= nbr1
                AND prh_receiver >= rcvr
                AND prh_receiver <= rcvr1
                AND prh_vend >= vend
                AND prh_vend <= vend1
                AND prh_rcp_date >= rcv_date
                AND prh_rcp_date <= rcv_date1
                AND (prh_print = YES OR NOT NEW_only1)
                AND (prh_rcp_type = "R"   or  includereturn ),
            EACH pt_mstr NO-LOCK WHERE pt_domain = prh_domain AND pt_part = prh_part AND pt_loc = loc
             BREAK BY prh_receiver BY prh_nbr BY prh_line :

                    ASSIGN prh_recno = RECID(prh_hist).

                    FIND FIRST tr_hist WHERE tr_domain = prh_domain AND tr_type = "rct-po" AND tr_nbr = prh_nbr AND tr_line = prh_line AND tr_lot = prh_receiver NO-LOCK NO-ERROR .
                    IF AVAILABLE tr_hist  THEN  DO:
                        v_serial = tr_serial  +  "/" + tr_ref .
                    END.
                    ELSE
                        v_serial = "" .

                        IF v_serial = "/" THEN
                        v_serial = "" .

                        FIND FIRST pod_det WHERE pod_domain = prh_domain AND pod_nbr = prh_nbr AND pod_line = prh_line NO-LOCK NO-ERROR .
                        IF AVAILABLE pod_det THEN DO:
                            v_rev = pod_rev .

                        END.
                        ELSE
                            v_rev = "" .

                         FIND FIRST ad_mstr WHERE ad_domain = GLOBAL_domain AND ad_addr = prh_vend NO-LOCK NO-ERROR .
                         IF AVAILABLE ad_mstr THEN
                             v_name = ad_name .
                         ELSE
                             v_name = "" .

                        CREATE tmp_det .
                        ASSIGN
                            tmp_receiver = prh_receiver
                            tmp_nbr = prh_nbr
                            tmp_line = prh_line
                            tmp_part = prh_part
                            tmp_desc1 = pt_desc1
                            tmp_desc2 = pt_desc2
                            tmp_um = prh_um
                            tmp_rcvd = - prh_rcvd
                            tmp_serial = v_serial
                            tmp_rcp_date = prh_rcp_date
                            tmp_name = v_name
                            tmp_rev = v_rev
                            tmp_vend = prh_vend
                            tmp_domain = prh_domain
                            .

                                /* ss - 100809.1 -b */
                        IF AVAILABLE pod_det  THEN DO:
                            FIND FIRST cmt_det WHERE cmt_domain = GLOBAL_domain AND cmt_indx = pod_cmtindx NO-LOCK NO-ERROR .
                            IF AVAILABLE cmt_det  THEN
                                tmp_cmmt = RIGHT-TRIM (cmt_cmmt[1])  + RIGHT-TRIM( cmt_cmm[2])  .
                            ELSE
                                FIND cd_det WHERE cd_domain = GLOBAL_domain AND cd_ref = tmp_part AND cd_type =  "pt"  NO-LOCK NO-ERROR .
                                IF AVAILABLE cd_det  THEN
                                     tmp_cmmt = RIGHT-TRIM (cd_cmmt[1])  + RIGHT-TRIM( cd_cmm[2])  .


                        END.
                        ELSE
                            tmp_cmmt = "" .
                /* ss - 100809.1 -e */


                find prhhist where recid(prhhist) = prh_recno exclusive-lock.
                /* CHANGE PRINT FLAG TO "NO" */
                if available prhhist then
                    prhhist.prh_print = no.
        END.


        /* 显示报表内容 */


    IF v_logical1  THEN  DO:

        FOR EACH tmp_det NO-LOCK BREAK BY tmp_domain  BY tmp_vend  BY tmp_part BY tmp_rcp_date :

            IF FIRST-OF(tmp_rcp_date) THEN DO:

                v_line = 0 .
                 pages = PAGE-NUMBER - 1.
                   page-start = 1 .

                   /* ss - 100809.1 -b
                      FORM  HEADER
                              " SINCERE-HOME" AT  45
                            "BG-CC-12"   AT 1   "采   购   退  货  单"   at 40     "退货日期:"  AT 70  tmp_rcp_date
                          "供应商:"        AT 1      tmp_name   AT 10
                          "打印日期:"   AT 70      v_date


                                WITH FRAME phead1 PAGE-TOP NO-BOX  WIDTH 120.

                          /*      DISPLAY tmp_rcp_date tmp_name  v_date  WITH FRAME phead1 . */
                      VIEW FRAME phead1 .




                    PUT "序号 退货单号  物料编码     物料描述                                           单位    数量        备注"  AT 1 .
                       PUT "------------------------------------------------------------------------------------------------------------------------" AT 1 .
                       ss - 100809.1 -e */
                   /* ss - 100809.1 -b */
                           v_name = tmp_name .
                            v_rcp_date = tmp_rcp_date .

                           VIEW FRAME phead1 .
                   /* ss - 100809.1 -e */

            END.  /* tmp_rcp_date  */    /* first-of(tmp_rcp_date) */

           v_line = v_line + 1 .

           IF PAGE-SIZE - LINE-COUNTER < 9 THEN DO:
                   PUT "------------------------------------------------------------------------------------------------------------------------" AT 1 .
        PUT      "白色联(财务) " AT 5        " 粉红色联(仓库)" AT 20      " 蓝色联(品管)" AT 35            " 绿色联(估价)"  AT 52          " 黄色联(供应商)" AT 67   .
                      PUT       "仓库收货确认:"   AT 20             "品管验货确认:"  AT 52  "页码:" TO 90  page-start   FORMAT ">>9"  " end "     SKIP.
                       page-start  =  page-start  + 1 .
                       PAGE .
                           /* ss - 100809.1 -b */
              VIEW FRAME phead1 .
          END.

          /* ss - 100809.1 -b
            FIND FIRST cmt_det WHERE cmt_domain = global_domain AND cmt_ref =  tmp_part  AND cmt_type = "1" AND cmt_seq = 0 NO-LOCK NO-ERROR .
             IF AVAILABLE cmt_det THEN DO:
             v_cmmt =  RIGHT-TRIM (cmt_cmmt[1])  + RIGHT-TRIM( cmt_cmm[2]) .
            END.
           ELSE
             v_cmmt = "" .
             ss - 100809.1 e */

          PUT UNFORMATTED  v_line AT 1 tmp_receiver AT 6  tmp_part AT 16  tmp_desc1 + ","  +  tmp_desc2 AT 30   tmp_um AT 84  tmp_rcvd AT 92   SKIP .
           PUT UNFORMATTED  /* ss - 100809.1 -b v_cmmt ss - 100809.1 -e */  /* ss - 100809.1 -b */ tmp_cmmt /* ss - 100809.1 -e */ AT 1   tmp_nbr + "/" + STRING(tmp_line) + "/" + tmp_rev AT 78  tmp_serial AT 95 SKIP .

           IF LAST-OF(tmp_rcp_date) THEN DO:
                    put skip(page-size - line-counter - 9).
                     PUT "------------------------------------------------------------------------------------------------------------------------" AT 1 .
        PUT      "白色联(财务) " AT 5        " 粉红色联(仓库)" AT 20      " 蓝色联(品管)" AT 35            " 绿色联(估价)"  AT 52          " 黄色联(供应商)" AT 67   .
                      PUT       "仓库收货确认:"   AT 20             "品管验货确认:"  AT 52  "页码:" TO 90  page-start   FORMAT ">>9"  " end "     SKIP.
                          /* ss - 100728.1 -b */
                  /*   PUT SKIP(1). */
                      /* ss - 100728.1 -e */
                       /*   PAGE .  100716.1 -e */
                      /* ss - 100730.1 -b */
                        IF NOT LAST-OF(tmp_domain) THEN    PAGE .
                      /* ss - 100730.1 -e */

           END.


           /*    {mfrpexit.i}       */
                     {mfrpchk.i}
           END.


    END .  /* v_logical1 */
    ELSE DO:


        FOR EACH tmp_det NO-LOCK BREAK BY tmp_domain BY  tmp_receiver :

            IF FIRST-OF(tmp_receiver) THEN DO:

                v_line = 0 .
                 pages = PAGE-NUMBER - 1.
                  page-start  =   1 .

                    /* ss - 100809.1 -b
                  FORM  HEADER
                        " SINCERE-HOME" AT  45
                            "BG-CC-12"   AT 1   "采   购   退  货  单"   at 40     "收货日期:"  AT 70  tmp_rcp_date
                          "供应商:"        AT 1      tmp_name   AT 10
                          "打印日期:"   AT 70   v_date


                                WITH FRAME phead11 PAGE-TOP  NO-BOX  WIDTH 120.

                   /*    DISPLAY tmp_rcp_date tmp_name v_date  WITH FRAME phead11 .   */
                      VIEW FRAME phead11 .


                       PUT "序号 退货单号  物料编码     物料描述                                           单位    数量        备注"  AT 1 .
                   PUT "------------------------------------------------------------------------------------------------------------------------" AT 1 .          /* tmp_rcp_date  */    /* first-of(tmp_rcp_date) */
                  ss - 100809.1 -e */
                  /* ss - 100809.1 -b */
                  v_name = tmp_name .
                  v_rcp_date = tmp_rcp_date .
                  VIEW FRAME phead1 .
                 /* ss - 100809. 1-e */

                  /* ss - 100809.1 -e */

           END.  /* tmp_rcp_date  */    /* first-of(tmp_rcp_date) */

           v_line = v_line + 1 .

           IF PAGE-SIZE - LINE-COUNTER < 9  THEN DO:
               PUT "------------------------------------------------------------------------------------------------------------------------" AT 1 .
          PUT      "白色联(财务) " AT 5        " 粉红色联(仓库)" AT 20      " 蓝色联(品管)" AT 35            " 绿色联(估价)"  AT 52          " 黄色联(供应商)" AT 67   .
                      PUT       "仓库收货确认:"   AT 20             "品管验货确认:"  AT 52  "页码:" TO 90  page-start   FORMAT ">>9"  " end "     SKIP.
                      page-start =  page-start  + 1 .
                      PAGE .
                      VIEW FRAME phead1 .

           END.

           /* ss - 100809.1 -b
         FIND FIRST cmt_det WHERE cmt_domain = global_domain AND cmt_ref =  tmp_part  AND cmt_type = "1" AND cmt_seq = 0 NO-LOCK NO-ERROR .
             IF AVAILABLE cmt_det THEN DO:
             v_cmmt =  RIGHT-TRIM (cmt_cmmt[1])  + RIGHT-TRIM( cmt_cmm[2]) .
            END.
           ELSE
             v_cmmt = "" .
            ss - 100809.1 -e */

             PUT UNFORMATTED  v_line AT 1 tmp_receiver AT 6  tmp_part AT 16  tmp_desc1 + ","  +  tmp_desc2 AT 30   tmp_um AT 84  tmp_rcvd AT 92   SKIP .
              PUT UNFORMATTED /* ss - 100809.1 -b v_cmmt ss - 100809.1 -e */  /* ss - 100809.1 -b */ tmp_cmmt /* ss - 100809.1 -e */  AT 1   tmp_nbr + "/" + STRING(tmp_line) + "/" + tmp_rev AT 78  tmp_serial AT 95 SKIP .

           IF LAST-OF(tmp_receiver) THEN DO:

                  PUT  skip(page-size - line-counter - 9)  .
                   PUT "------------------------------------------------------------------------------------------------------------------------" AT 1 .
               PUT      "白色联(财务) " AT 5        " 粉红色联(仓库)" AT 20      " 蓝色联(品管)" AT 35            " 绿色联(估价)"  AT 52          " 黄色联(供应商)" AT 67   .
                      PUT       "仓库收货确认:"   AT 20             "品管验货确认:"  AT 52  "页码:" TO 90  page-start   FORMAT ">>9"  " end "     SKIP.
                  /* ss - 100728.1 -b */
                   /*   PUT SKIP(1). */
                      /* ss - 100728.1 -e */
                  /*   PAGE .  100716.1 -e */
                      /* ss - 100730.1 -b */
                        IF NOT LAST-OF(tmp_domain) THEN    PAGE .
                      /* ss - 100730.1 -e */
           END.


  {mfrpchk.i}
      /*
               {mfrpexit.i}
               */
        END.

    END.  /* v_logical1 = no  */


     {mfreset.i}
     {mfgrptrm.i}

END.
{wbrp04.i &frame-spec = a}
