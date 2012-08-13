{mfdtitle.i}
{bcdeclre.i NEW}
{bcini.i}
/*{bcwin01.i}*/

DEFINE VARIABLE afile AS CHARACTER FORMAT "X(256)":U VIEW-AS
     FILL-IN SIZE 38.5 BY 1 LABEL "文件" NO-UNDO.
DEFINE BUTTON btn_file LABEL "打开" SIZE 4 BY 1.
DEFINE TEMP-TABLE t_wo_mstr
    FIELD t_wo_batch LIKE b_wo_batch
    FIELD t_wo_line LIKE b_wo_line
    FIELD t_wo_shift LIKE b_wo_shift
    FIELD t_wo_part LIKE b_wo_part
    FIELD t_wo_pre_qty LIKE b_wo_qty
    FIELD t_wo_ld_qty LIKE b_wo_qty
    FIELD t_wo_qty LIKE b_wo_qty
    FIELD t_wo_date LIKE b_wo_date.

DEFINE TEMP-TABLE t_wot_det
    FIELD t_wot_part LIKE b_wot_part
    FIELD t_wot_qty LIKE b_wot_qty.


DEFINE BUTTON btn_load LABEL "导入".
DEFINE BUTTON btn_cancel LABEL "取消".
DEFINE BUTTON btn_save LABEL "保存".
DEFINE BUTTON btn_bccr LABEL "产生条码".
DEFINE BUTTON btn_quit LABEL "退出".

DEFINE QUERY q_wo FOR t_wo_mstr.
DEFINE BROWSE b_wo QUERY q_wo
    DISP
    t_wo_batch LABEL "批号"
    t_wo_line LABEL "生产线"
    t_wo_shift LABEL "班次"
    t_wo_part LABEL "零件"
    t_wo_pre_qty LABEL "上班余额"
    t_wo_ld_qty LABEL "本班导入"
    t_wo_qty LABEL "数量"
    t_wo_date LABEL "下达日期"
    WITH 6 DOWN WIDTH 79
    TITLE "下达任务列表".

DEFINE QUERY q_co FOR t_co_mstr.
DEFINE BROWSE b_co QUERY q_co
    DISPLAY
    t_co_code LABEL "条码"
    t_co_part LABEL "零件"
    t_co_qty_cur LABEL "数量"
    t_co_lot LABEL "批号"
    t_co_shift LABEL "班次"
    WITH 8  DOWN WIDTH 79
    TITLE "条码清单".

DEFINE FRAME a
    afile  btn_file SKIP(.1)
    b_wo SKIP(.1)
    b_co SKIP(1)
    btn_load btn_cancel btn_save btn_bccr btn_quit
    WITH WIDTH 80 THREE-D SIDE-LABEL.

ON 'choose':U OF btn_file
DO:
    SYSTEM-DIALOG GET-FILE aFile
           FILTERS "????(*.txt)" "*.txt"
                 INITIAL-DIR "c:\"
                         RETURN-TO-START-DIR
                              TITLE "GTI ????" 
                                 SAVE-AS
                                    USE-FILENAME
                                      DEFAULT-EXTENSION ".txt".
     display afile with frame a .
    RETURN.
END.
ON 'choose':U OF btn_load
DO:
    ASSIGN afile.
    RUN LOAD_wo.
    FOR EACH t_wo_mstr:
        FIND FIRST b_wot_det NO-LOCK WHERE t_wo_part = b_wot_part NO-ERROR.
        IF AVAILABLE b_wot_det THEN DO:
            ASSIGN t_wo_pre_qty = b_wot_qty.
        END.
        t_wo_qty = t_wo_pre_qty + t_wo_ld_qty.
    END.
    OPEN QUERY q_wo FOR EACH t_wo_mstr.
    DISP b_wo WITH FRAME a.
    RETURN.
END.
ON 'choose':U OF btn_cancel
DO:
    RUN cancel_wo.
    OPEN QUERY q_wo FOR EACH t_wo_mstr.
    RETURN.
END.
ON 'choose':U OF btn_save
DO:
    RUN save_wo.
    RETURN.
END.
ON 'choose':U OF btn_bccr
DO:
    RUN barcode_cr.
    OPEN QUERY q_co FOR EACH t_co_mstr.
    RETURN.
END.


/*REPEAT:
    UPDATE afile btn_file b_wo b_co  btn_load btn_cancel btn_save btn_bccr btn_quit WITH FRAME a.
END.*/

FOR EACH t_wo_mstr:
    DELETE t_wo_mstr.
END.
FOR EACH t_wot_det:
    DELETE t_wot_det.
END.

REPEAT:
 UPDATE afile btn_file WITH FRAME a.
 UPDATE b_wo b_co btn_load btn_cancel btn_save btn_bccr btn_quit WITH FRAME a.
END.
/*
ENABLE ALL WITH FRAME a.
{bctrail.i}
  */
PROCEDURE LOAD_wo:
    DEFINE VARIABLE batchid AS INTEGER.
    DEFINE VARIABLE lline AS CHAR.
    DEFINE VARIABLE shift AS CHAR.
    DEFINE VARIABLE part AS CHAR.
    DEFINE VARIABLE qty AS DECIMAL.
    DEFINE VARIABLE ddate AS DATE.
    
    SELECT MAX( b_wo_batch) INTO batchid FROM b_wo_mstr.
    IF batchid = ?  THEN batchid = 1. ELSE batchid = batchid + 1.

    FOR EACH t_wo_mstr:
        DELETE t_wo_mstr.
    END.

    INPUT FROM VALUE(afile).
    IMPORT DELIMITER "  " shift.
    DO WHILE TRUE:
      IMPORT DELIMITER "    " lline shift part qty ddate.
      IF (NOT lline EQ "生产线") AND (NOT lline EQ "")THEN DO:

          FIND FIRST t_wo_mstr NO-LOCK WHERE  t_wo_part = TRIM(part)  NO-ERROR.
          IF AVAILABLE t_wo_mstr THEN DO:
              MESSAGE "相同零件号不要在一个文件中导入" VIEW-AS ALERT-BOX.
              LEAVE.
          END.

          FIND FIRST t_wo_mstr NO-LOCK WHERE t_wo_line = TRIM(lline) AND t_wo_shift = TRIM(shift)
                    AND t_wo_part = TRIM(part) AND t_wo_ld_qty = qty AND t_wo_date = ddate NO-ERROR.
          IF AVAILABLE t_wo_mstr THEN DO:
              MESSAGE "不要重复导入资料" VIEW-AS ALERT-BOX.
              LEAVE.
          END.

          FIND FIRST b_wo_mstr NO-LOCK WHERE b_wo_line = TRIM(lline) AND b_wo_shift = TRIM(shift)
                    AND b_wo_part = TRIM(part) AND b_wo_ld_qty = qty AND b_wo_date = ddate NO-ERROR.
          IF AVAILABLE b_wo_mstr THEN DO:
              MESSAGE "导入资料与现有资料冲突" VIEW-AS ALERT-BOX.
              LEAVE.
          END.

          FIND FIRST pt_mstr NO-LOCK WHERE pt_part = part NO-ERROR.
          IF AVAILABLE pt_mstr THEN DO:
              IF pt_ord_mult = 0  THEN DO:
                  MESSAGE "发现有零件号为" + part + "订单倍数为0,退出" VIEW-AS ALERT-BOX.
                  LEAVE.
              END.
          END.

        CREATE t_wo_mstr.
        ASSIGN
            t_wo_batch = batchid
            t_wo_line = TRIM(lline)
            t_wo_shift = trim(shift)
            t_wo_part = trim(part)
            t_wo_ld_qty = qty
            t_wo_date = ddate.
        ASSIGN 
            lline = ""
            shift = ""
            part = ""
            qty = ?
            ddate = ?.
      END.
      
    END.
    INPUT CLOSE.

END.

PROCEDURE cancel_wo:
 FOR EACH t_wo_mstr:
     DELETE t_wo_mstr.
 END.
 FOR EACH t_wot_det:
     DELETE t_wot_det.
 END.
END.

PROCEDURE SAVE_wo:
 DEFINE VARIABLE i AS INTEGER.
 DEFINE VARIABLE j AS INTEGER.
 FOR EACH t_co_mstr:
     i = i + 1.
 END.
 IF i = 0  THEN DO :
     MESSAGE "条码未生成，不能保存" VIEW-AS ALERT-BOX.
     RETURN.
 END.

DO ON ERROR UNDO:

 SELECT MAX( b_wo_batch) INTO j FROM b_wo_mstr.
 IF j = ?  THEN j = 1. ELSE j = j + 1.

 FOR EACH t_wo_mstr:
     CREATE b_wo_mstr.
     ASSIGN
         b_wo_batch = j
         b_wo_line = t_wo_line
         b_wo_shift = t_wo_shift
         b_wo_part = t_wo_part
         b_wo_pre_qty = t_wo_pre_qty
         b_wo_ld_qty = t_wo_ld_qty
         b_wo_qty = t_wo_qty
         b_wo_date = t_wo_date.


     FOR EACH t_co_mstr WHERE t_co_part = t_wo_part AND t_co_line = t_wo_line 
         AND t_co_shift = t_wo_shift AND t_co_date = t_wo_date AND t_co_woqty = t_wo_qty:
         CREATE b_wod_det.
         ASSIGN
             b_wod_batch = j
             b_wod_line = t_wo_line
             b_wod_shift = t_wo_shift
             b_wod_part = t_wo_part
             b_wod_code = t_co_code
             b_wod_status = ""
             b_wod_printed = NO
             b_wod_rct_date = t_wo_date.
     END.
     j = j + 1.
 END.

 FOR EACH t_co_mstr:
     FIND FIRST b_co_mstr NO-LOCK WHERE b_co_code = t_co_code NO-ERROR.
     IF AVAILABLE b_co_mstr THEN DO:
         DEFINE VARIABLE vv LIKE b_co_code.
         vv = b_co_code.
         CREATE b_co_mstr.
         ASSIGN
              b_co_code = SUBSTRING(vv,1, (length(vv) - 3)) + STRING(INT(SUBSTRING(vv,length(vv) - 2 , 3)) + 1, "999")
              b_co_part = t_co_part 
              b_co_um = t_co_um
              b_co_lot = t_co_lot
              b_co_status = t_co_status 
              b_co_desc1 = t_co_desc1 
              b_co_desc2 =  t_co_desc2
              b_co_qty_ini =  t_co_qty_ini 
              b_co_qty_cur =  t_co_qty_cur 
              b_co_qty_std  =  t_co_qty_std
              b_co_ser =  t_co_ser
              b_co_ref =  t_co_ref
              b_co_format = t_co_format
              b_co_wodate = t_co_wodate
              b_co_usrid = GLOBAL_userid
              b_co_parcode = t_co_parcode
              b_co_wolot = t_co_wolot
              b_co_absid = t_co_absid
              b_co_shift = t_co_shift.
     END.
     ELSE DO:
         CREATE b_co_mstr.
         ASSIGN
              b_co_code = t_co_code
              b_co_part = t_co_part 
              b_co_um = t_co_um
              b_co_lot = t_co_lot
              b_co_status = t_co_status 
              b_co_desc1 = t_co_desc1 
              b_co_desc2 =  t_co_desc2
              b_co_qty_ini =  t_co_qty_ini 
              b_co_qty_cur =  t_co_qty_cur 
              b_co_qty_std  =  t_co_qty_std
              b_co_ser =  t_co_ser
              b_co_ref =  t_co_ref
              b_co_format = t_co_format
              b_co_wodate = t_co_wodate
              b_co_usrid = GLOBAL_userid
              b_co_parcode = t_co_parcode
              b_co_wolot = t_co_wolot
              b_co_absid = t_co_absid
              b_co_shift = t_co_shift.
     END.
 END.

 FOR EACH t_wot_det:
     FIND FIRST b_wot_det WHERE b_wot_part = t_wot_part NO-ERROR.
     IF AVAILABLE b_wot_det THEN DO:
         ASSIGN b_wot_qty = t_wot_qty.
     END.
     ELSE DO:
         CREATE b_wot_det.
         ASSIGN b_wot_part = t_wot_part
             b_wot_qty = t_wot_qty.
     END.
 END.

 {bcco002.i ""FINI-CRE""}
 STATUS INPUT "已保存".
END.  /*do*/

END.

PROCEDURE barcode_cr:
    DEFINE VARIABLE ord_qty LIKE pt_ord_mult.
    DEFINE VARIABLE mo_qty LIKE pt_ord_mult.
    DEFINE VARIABLE cum_qty LIKE pt_ord_mult.
    FOR EACH t_co_mstr:
        DELETE t_co_mstr.
    END.
    FOR EACH t_wo_mstr:
            cum_qty =  t_wo_qty.
            FIND FIRST pt_mstr NO-LOCK WHERE pt_part = t_wo_part NO-ERROR.
            IF AVAILABLE pt_mstr THEN DO:
                  ord_qty = (IF pt_ord_mult >0 THEN pt_ord_mult ELSE 1).
           END.
           ELSE DO:
                   MESSAGE t_wo_part + "不存在" VIEW-AS ALERT-BOX.
                   UNDO.
           END.

           mo_qty = 0.
           IF ord_qty NE 1 THEN mo_qty = cum_qty MOD ord_qty.
           IF mo_qty > 0  THEN DO:
               FIND FIRST t_wot_det WHERE t_wot_part = t_wo_part NO-ERROR.
               IF AVAILABLE t_wot_det THEN
                   ASSIGN t_wot_qty = mo_qty.
               ELSE DO:
                   CREATE t_wot_det.
                   ASSIGN t_wot_part = t_wo_part
                                t_wot_qty = mo_qty.
               END.
           END.
           ELSE DO:
               FIND FIRST t_wot_det WHERE t_wot_part = t_wo_part NO-ERROR.
               IF AVAILABLE t_wot_det THEN
                   ASSIGN t_wot_qty = 0.
           END.

            {gprun.i ""bccocr.p"" "(t_wo_part, INPUT t_wo_date,
                                 INPUT (cum_qty - mo_qty), INPUT ""vend"", input ""0"",
                                 INPUT """", INPUT """")"}


                DEFINE VARIABLE datemark AS CHARACTER.
                DEFINE VARIABLE tlot LIKE ld_lot.
                /*make the datemark by cdate*/
                DEFINE VARIABLE X1 AS CHARACTER.
                DEFINE VARIABLE x2 AS CHARACTER.
                ASSIGN x1 = string(YEAR(t_wo_date),'9999').
                ASSIGN x2 = STRING(MONTH(t_wo_date),'99').
                FIND FIRST b_ym_ref NO-LOCK WHERE b_ym_ym = x1 NO-ERROR.
                IF AVAILABLE b_ym_ref THEN x1 = b_ym_code. ELSE MESSAGE "年份参照表没有维护".
                FIND FIRST b_ym_ref NO-LOCK WHERE b_ym_ym = x2 NO-ERROR.
               IF AVAILABLE b_ym_ref THEN x2 = b_ym_code. ELSE MESSAGE "月份参照表没有维护".
               /*datemark = SUBSTR(string(YEAR(TODAY),'9999'),3,2) + STRING(MONTH(TODAY),'99') + STRING(DAY(TODAY),'99').*/
               datemark = x1 + x2 + STRING(DAY(t_wo_date),'99').
               tlot = STRING(t_wo_line,"99") + "0" + datemark + t_wo_shift.

               FOR EACH t_co_mstr WHERE t_co_part = t_wo_part  AND t_co_lot = "":
                   ASSIGN 
                       t_co_lot = tlot
                       t_co_shift = t_wo_shift
                       t_co_wodate = t_wo_date
                       t_co_line = t_wo_line
                       t_co_date = t_wo_date
                       t_co_woqty = t_wo_qty.
               END.

    END.

   /*{bcrun.i ""bcbccocr02.p"" "(INPUT ""10-00"", INPUT 10)"}*/
END.
