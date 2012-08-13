/* xgfgimp.p               生产线产品下线导入接口                 */
/* Last Modified: 2005.12.19               by: hou          *H01* */
/*                2006.02.26               by: hou          *H02* */
/*                2006.03.01               by: hou          *H03* */
/*                2006.03.21               by: hou          *H04* */

{mfdtitle.i "ao"}

def var file_name_input as CHAR FORMAT "x(60)".
DEF VAR FILE_name_bak   AS CHAR FORMAT "x(60)".
DEF VAR FILE_name_error AS CHAR FORMAT "x(60)".
DEF VAR FILE_error      AS CHAR FORMAT "x(60)".
DEF VAR FILE_name_short AS CHAR FORMAT "x(60)".
DEF VAR FILE_list AS CHAR FORMAT "x(60)".
def var ptdesc    like pt_desc1.
DEF VAR l_slash     AS CHAR.
def var tmp_file    as char.
def var wait_time as inte format ">>>>>>>>9" label "间隔时间(秒)" init 30.
/* def var run_type as INT label "运行状态" . */
DEF VAR RUN_yn   as LOG label "开始运行" format "Y/N" init no.
DEF VAR RIGHT_yn AS LOG LABEL "导入正确" INIT NO.

DEF VAR RUN_times AS INT.
if opsys = "unix" then assign l_slash = "/".
else if opsys = "msdos" or opsys = "win32" then assign l_slash = "~\".
else if opsys = "vms"   then l_slash = "]".

DEF TEMP-TABLE tmp-xwo
    FIELD tmp-lnr       AS CHAR 
    FIELD tmp-part      AS CHAR 
    FIELD tmp-lot       AS CHAR
    FIELD tmp-qty-lot   AS CHAR
    FIELD tmp-serial    AS CHAR
    FIELD tmp-wrk-date  AS CHAR
    FIELD tmp-wrk-time  AS CHAR 
    FIELD tmp-due-date  AS CHAR
    FIELD tmp-due-time  AS CHAR
    FIELD tmp-cust      AS CHAR 
    FIELD tmp-loc-des   AS CHAR 
    FIELD tmp-line      AS INTE.
DEF VAR date1       AS DATE.
DEF VAR date2       AS DATE.
DEF VAR time1       AS INTE.
DEF VAR time2       AS INTE.
DEF VAR qty         AS INTE.
DEF VAR i     AS INTE.
DEF TEMP-TABLE tmp-list
    FIELD list-name AS CHAR FORMAT "x(60)".

form wait_time 
     run_yn
     with frame a side-label with width 80.
DEF VAR LOG_date AS DATE LABEL "日期".
DEF VAR LOG_time AS CHAR LABEL "时间".
DEF VAR LOG_msg  AS CHAR FORMAT "x(160)" LABEL "信息提示".
DEF VAR LOG_file AS CHAR FORMAT "x(30)" LABEL "文件名".

define new shared variable parpart like pt_part.
define new shared workfile pkkdet no-undo
    field pkkpart like ps_comp
    field pkkop as char format "x(20)" 
    field pkkqty like pk_qty.

FORM LOG_date LOG_time LOG_file LOG_msg WITH FRAME d DOWN ATTR-SPACE WIDTH 320.

FUNCTION DATE_CHK RETURNS DATE (INPUT_date AS CHAR).
    DEF VAR i AS INTE.
    DEF VAR yy AS INTE.
    DEF VAR mm AS INTE.
    DEF VAR dd AS INTE.
    DEF VAR tmp-date AS DATE.
    IF LENGTH(INPUT_date) <> 10 THEN DO:
        RETURN ?.
    END.
    ELSE DO:
        i = 1.
        DO WHILE i > 10:
            IF NOT (SUBSTRING(INPUT_date,i,1) >= "0" AND SUBSTRING(INPUT_date,i,1) <= "9") AND (i <> 3 OR i <> 6) THEN DO: 
                RETURN ?.
            END.
            i = i + 1.
        END.
        yy = inte(SUBSTRING(INPUT_date,7,4)).

        dd = inte(SUBSTRING(INPUT_date,4,2)).
        mm = inte(SUBSTRING(INPUT_date,1,2)).
        IF yy <= 1900 THEN RETURN ?.
        IF mm > 12 THEN RETURN ?.
        tmp-date = DATE(mm,1,yy) + 31.
        tmp-date = tmp-date - DAY(tmp-date).
        IF dd > DAY(tmp-date) THEN RETURN ?.
    END.
    RETURN DATE(mm,dd,yy).
END FUNCTION.

FUNCTION TIME_CHK RETURNS INTEGER (INPUT_time AS CHAR).
    DEF VAR i AS INTE.
    DEF VAR hh AS INTE.
    DEF VAR mm AS INTE.
    DEF VAR ss AS INTE.
    IF LENGTH(INPUT_time) <> 8 THEN DO:
        RETURN ?.
    END.
    ELSE DO:
        i = 1.
        DO WHILE i > 8:
            IF NOT (SUBSTRING(INPUT_time,i,1) >= "0" AND SUBSTRING(INPUT_time,i,1) <= "9") AND (i <> 3 OR i <> 6) THEN DO: 
                RETURN ?.
            END.
            i = i + 1.
        END.
        ss = inte(SUBSTRING(INPUT_time,7,2)).
        mm = inte(SUBSTRING(INPUT_time,4,2)).
        hh = inte(SUBSTRING(INPUT_time,1,2)).
        IF hh > 24 THEN RETURN ?.
        IF mm > 60 THEN RETURN ?.
        IF ss > 60 THEN RETURN ?.
    END.
    RETURN hh * 3600 + mm * 60 + ss.
END FUNCTION.

FUNCTION Inte_CHK RETURNS INTEGER (INPUT_inte AS CHAR).
    DEF VAR i AS INTE.
    IF INPUT_inte = "" THEN RETURN ?.
    i = 1.
    DO WHILE i < LENGTH(INPUT_inte) :
        IF NOT (SUBSTRING(INPUT_inte,i,1) >= "0" AND SUBSTRING(INPUT_inte,i,1) <= "9") THEN DO: 
            RETURN ?.
        END.
        i = i + 1.
    END.
    RETURN INTE(INPUT_inte).
END FUNCTION.

MAIN-LOOP:
repeat:
     
     update wait_time 
      run_yn with frame a.
     /*run_yn = no.*/
     MESSAGE "Start Running......". 
     if input run_yn = yes then 
     LOOP-1:
     REPEAT: 
        
        OUTPUT TO TERMINAL.
         
        for each xgpl_ctrl NO-LOCK:

            FILE_list = "TMP" + string(today,"99999999") + STRING(TIME) + string(RANDOM(0,100000)) + ".tmp".
            
            OUTPUT TO VALUE("TM" + FILE_list) KEEP-MESSAGES.
            if opsys = "unix" then DO:
               UNIX SILENT cd VALUE(xgpl_prd_dir + l_slash).
               UNIX SILENT ls VALUE(xgpl_lnr + "*.txt") > VALUE(FILE_list).
            END.
            ELSE IF OPSYS = "msdos" OR OPSYS = "win32" THEN DO:
               DOS DIR VALUE(xgpl_prd_dir + l_slash + xgpl_lnr + "*.txt") /B > VALUE(FILE_list) .
            END.
            OUTPUT CLOSE.
            OS-DELETE VALUE("TM" + FILE_list).

            tmp_file = "tmp" + string(time) + string(random(0,999),"999").
            output to VALUE(tmp_file) no-echo.
            FOR EACH tmp-list.
                DELETE tmp-list.
            END.
            INPUT FROM value(FILE_list) NO-ECHO.
             REPEAT:
               CREATE tmp-list.
               IMPORT tmp-list.
             END.
            INPUT CLOSE.
            OUTPUT CLOSE.
            IF SEARCH(tmp_file) <> ? THEN OS-DELETE VALUE(tmp_file).
            IF SEARCH(FILE_list) <> ? THEN OS-DELETE VALUE(FILE_list).
            loop-input:
            FOR EACH tmp-list WHERE list-name <> "":
               RIGHT_yn = NO.
               FILE_name_input = xgpl_prd_dir + l_slash + list-name.
               FILE_name_bak   = xgpl_bak_dir + l_slash + list-name.
               FILE_error      = xgpl_err_dir + l_slash + list-name.
               FILE_name_error = xgpl_err_dir + l_slash + (string(year(today) * 10000 + month(today) * 100 + day(today)) + "ERROR.LOG").
               
               LOG_date = TODAY.
               LOG_time = STRING(TIME,"HH:MM:SS").

               IF SEARCH(file_name_input) = ? THEN DO:
                   LOG_msg  = "SQL导出文件被删除".
                   LOG_file = FILE_name_input.
                   DISP LOG_date LOG_time LOG_msg LOG_file  WITH FRAME d DOWN .
                   DOWN WITH FRAME d.
                   PAUSE 0.

                   OUTPUT TO value(FILE_name_error + "") APPEND.               
                      PUT UNFORMAT TODAY SPACE STRING(TIME,"HH:MM:SS") " SQL导出文件 " FILE_name_input " 未找到......" SKIP.
                   OUTPUT CLOSE.
                   NEXT loop-input.
               END.
               OUTPUT TO VALUE("TM" + FILE_list) KEEP-MESSAGES.
               IF OPSYS = "unix" THEN DO:
                  unix silent mv value(file_name_input) value(FILE_name_bak).
               END.
               ELSE IF opsys = "msdos" or opsys = "win32" THEN DO:
                  DOS MOVE value(file_name_input) value(FILE_name_bak).  
               END.
               PAUSE 0.
               OUTPUT CLOSE.
               OS-DELETE VALUE("TM" + FILE_list).

               IF SEARCH(file_name_bak) = ? THEN DO:
                   LOG_msg  = "Progress导入文件未找到".
                   LOG_file = FILE_name_bak.
                   DISP LOG_date LOG_time LOG_msg LOG_file  WITH FRAME d DOWN .
                   DOWN WITH FRAME d.
                   PAUSE 0.
                  
                   OUTPUT TO value(FILE_name_error) APPEND.
                      PUT UNFORMAT TODAY SPACE STRING(TIME,"HH:MM:SS") " Progress导入文件 " file_name_bak " 未找到......" SKIP.
                   OUTPUT CLOSE.
                   NEXT loop-input.
               END.
               FOR EACH tmp-xwo:
                   DELETE tmp-xwo.
               END.
               OUTPUT TO VALUE(FILE_name_error + ".tmp") KEEP-MESSAGES.
                   i = 0.
                   INPUT FROM VALUE(file_name_bak) NO-ECHO. 
                        REPEAT:
                            i = i + 1.
                            CREATE tmp-xwo.
                            IMPORT DELIMITER "~009" tmp-xwo EXCEPT tmp-line.
                            ASSIGN tmp-line = i.
                       END.
                   INPUT CLOSE.
               OUTPUT CLOSE.
               RIGHT_yn = NO.
               INPUT-LOOP:
               DO TRANSACTION ON ERROR UNDO INPUT-LOOP,LEAVE INPUT-LOOP:
/*H02*         FOR EACH tmp-xwo WHERE tmp-line > 0 NO-LOCK: */
/*H02*/        FOR EACH tmp-xwo WHERE tmp-line > 0 NO-LOCK break by tmp-lot:
                   RIGHT_yn = YES.
                   LOG_msg = "".
                   FIND pt_mstr WHERE pt_part = tmp-part NO-LOCK NO-ERROR.
                   IF NOT AVAIL pt_mstr THEN DO: 
                      RIGHT_yn = NO.
                      LOG_msg = LOG_msg + "料号-" + tmp-part.
                   END.
                   FIND FIRST cm_mstr WHERE cm_addr = tmp-cust NO-LOCK NO-ERROR.
                   IF NOT AVAIL cm_mstr THEN DO: 
                      RIGHT_yn = NO.
                      LOG_msg = LOG_msg + "客户-" + tmp-cust.
                   END.
                   FIND FIRST loc_mstr WHERE loc_loc = tmp-loc-des NO-LOCK NO-ERROR.
                   qty = INTE_CHK(tmp-qty-lot).
                   IF qty = ? THEN DO:
                      RIGHT_yn = NO.
                      LOG_msg = LOG_msg + "数量-" + tmp-qty-lot.
                   END.
                   IF NOT AVAIL loc_mstr THEN DO:
                      RIGHT_yn = NO.
                      LOG_msg = LOG_msg + "库位-" + tmp-loc-des.
                   END.
                   date1 = DATE_CHK(tmp-wrk-date).
                   IF date1 = ? THEN DO:
                      RIGHT_yn = NO.
                      LOG_msg = LOG_msg + "上线日期-" + tmp-wrk-date.
                   END.
                   date2 = DATE_CHK(tmp-due-date).
                   IF date2 = ? THEN DO:
                      RIGHT_yn = NO.
                      LOG_msg = LOG_msg + "下线日期-" + tmp-due-date.
                   END.
                   time1 = TIME_CHK(tmp-wrk-time).
                   IF time1 = ? THEN DO:
                      RIGHT_yn = NO.
                      LOG_msg = LOG_msg + "上线时间-" + tmp-wrk-time.
                   END.
                   time2 = TIME_CHK(tmp-due-time).
                   IF time2 = ? THEN DO:
                      RIGHT_yn = NO.
                      LOG_msg = LOG_msg + "下线时间-" + tmp-due-time.
                   END.
/*                    time1 = (int(substr(tmp-wrk-time,1,2)) * 60 * 60 + int(substr(tmp-wrk-time,4,2)) * 60 + int(substr(tmp-wrk-time,7,2))).  */
/*                    time2 = (int(substr(tmp-due-time,1,2)) * 60 * 60 + int(substr(tmp-due-time,4,2)) * 60 + int(substr(tmp-due-time,7,2))).  */

/*H03**Add Begin **/
                   FIND xwo_srt WHERE xwo_lnr = tmp-lnr AND xwo_part = tmp-part 
                   AND xwo_serial = tmp-serial 
/*est*/              AND xwo_lot = tmp-lot  NO-ERROR . 
                   if avail xwo_srt then do:
                      right_yn = no.
                      log_msg = log_msg + "记录已存在-" + tmp-lnr + tmp-part + tmp-serial .
                   end.
/**H03**Add End ***/

                   IF RIGHT_yn = NO THEN DO:
                      LOG_msg  = "文件第" + string(tmp-line) + "行错误：" + LOG_msg.
                      LOG_file = FILE_name_input.
                      DISP LOG_date LOG_time LOG_msg LOG_file  WITH FRAME d DOWN .
                      DOWN WITH FRAME d.
                      PAUSE 0.
                      OUTPUT TO value(FILE_name_error) APPEND.
                         PUT UNFORMAT TODAY SPACE STRING(TIME,"HH:MM:SS") " SQL导出 " FILE_name_input  LOG_msg SKIP.
                      OUTPUT CLOSE.

/*H03*/               undo input-loop,leave input-loop.                    
                   END.
/*H03**            ELSE DO:   **/
                       find first pt_mstr where pt_part = tmp-part no-lock no-error.
                       
                       FIND xwo_srt WHERE xwo_lnr = tmp-lnr 
                                       AND xwo_part = tmp-part 
                                       AND xwo_serial = tmp-serial 
/*est*/              AND xwo_lot = tmp-lot   NO-ERROR .
                       IF NOT AVAIL xwo_srt then do:
                           CREATE xwo_srt.          
                           ASSIGN xwo_lnr = tmp-lnr 
                                  xwo_part = tmp-part 
                                  xwo_pt_desc = pt_desc1
                                  xwo_serial = tmp-serial.

/*H03**Add Begin ***/
                           ASSIGN xwo_date = TODAY
                                  xwo_time = TIME
                                  xwo_lot = tmp-lot
                                  xwo_qty_lot = qty
                                  xwo_wrk_date = date1
                                  xwo_wrk_time = time1
                                  xwo_due_date = date2
                                  xwo_due_time = time2
                                  xwo_cust = tmp-cust
                                  xwo_loc_des = tmp-loc-des .
/*H03**Add End *****/
/*H04*/                    {xgxwoo.i xwo_lot qty}

/*H02*/                    if last-of(tmp-lot) then do:                           
                              /*H01* add by hou begin */
                              /* Create xwosd_det */
    /*est*/                           {bckbcom3.i}
                              for each pkkdet:
                                delete pkkdet.
                              end.
                              
                              parpart = tmp-part.
                              
                              {gprun.i ""xgbmpkiq.p""}
                              
                              for each pkkdet:
                                create xwosd_det.
                                assign	
                                    xwosd_lnr    = tmp-lnr
                                    xwosd_part   = pkkpart
                                    xwosd_date   = today
/*H02*                              xwosd_fg_lot = tmp-serial */
/*H02*/                             xwosd_fg_lot = tmp-lot
                                    xwosd_op     = pkkop
                                    xwosd_qty    = pkkqty * qty
/*H03*/                             xwosd_use_dt = xwo_date
/*H03*/                             xwosd_use_tm = xwo_time
                                    xwosd_bkflh  = no
                                    xwosd_used   = yes.
   
                                
                                find first pt_mstr where pt_part = pkkpart no-lock no-error.
                                if available pt_mstr then 
                                   assign 
                                     xwosd_site = pt_site
                                     xwosd_loc = pt_loc.	

/*H04*/                         {xgxwosdo.i pkkqty * qty}
                              end.
                              /*H01* add by hou end */
                              
                              
/*H02*/                    end.       
                       END.
                       
/*H03***comments begin**                       
                       IF NOT xwo_blkflh AND xwo_wolot = "" THEN DO:
                           ASSIGN xwo_date = TODAY
                                  xwo_time = TIME.
                           ASSIGN xwo_lot = tmp-lot
                                  xwo_qty_lot = qty
                                  xwo_wrk_date = date1
                                  xwo_wrk_time = time1
                                  xwo_due_date = date2
                                  xwo_due_time = time2
                                  xwo_cust = tmp-cust
                                  xwo_loc_des = tmp-loc-des .
                                  
                       END.
**H03***comments end **/
                       
                       RIGHT_yn = YES.
                   
                       IF NEW(xwo_srt) THEN LOG_msg  = "文件成功导入".
                       ELSE DO:
                           LOG_msg = "文件重导成功".
                       END.
                       LOG_file = FILE_name_input.
                       /**
                       DISP LOG_date LOG_time LOG_msg LOG_file   WITH FRAME d DOWN .
                       DOWN WITH FRAME d.
                       PAUSE 0.
                       **/
                       /*
                       OUTPUT TO value(FILE_name_error) APPEND.
                          PUT UNFORMAT TODAY SPACE STRING(TIME,"HH:MM:SS") " SQL导出 " FILE_name_input  LOG_msg SKIP.
                       OUTPUT CLOSE.
                       */
/*H03**            END.  **/

                   IF RIGHT_yn = NO THEN do:
                       
                       UNDO INPUT-LOOP,LEAVE input-loop.

                   END.
               END. /* end for each tmp-xwo */

               IF RIGHT_yn = YES THEN DO:
                   LOG_file = FILE_name_input. 
                   LOG_msg  = "文件成功导入".
                   DISP LOG_date LOG_time LOG_msg LOG_file RIGHT_yn  WITH FRAME d DOWN .
                   DOWN WITH FRAME d.
                   PAUSE 0.
               END.
               END.
               OUTPUT TO VALUE("TM" + FILE_list) KEEP-MESSAGES.
               IF RIGHT_yn = NO THEN 
                   IF SEARCH(FILE_name_bak) <> ? THEN DOS MOVE VALUE(FILE_name_bak) VALUE(FILE_error).

               OUTPUT CLOSE.
               IF SEARCH("TM" + FILE_list) <> ? THEN OS-DELETE VALUE("TM" + FILE_list).
               IF SEARCH(FILE_name_error + ".tmp") <> ? THEN OS-DELETE VALUE(FILE_name_error + ".tmp").
               IF SEARCH(tmp_file) <> ? THEN OS-DELETE VALUE(tmp_file).
            END. /*for each tmp-list*/
                           
        END. /*end for each xgpl_ctrl*/

        PAUSE WAIT_time.
     END. /* end loop1 repeat*/
END. /* end mainloop repeat*/

