/*zztlupld.p for upload the transfer list created by ATPU into MFG/PRO*/
/*Revision: 8.5f    Last modified: 12/20/2003   By: Kevin*/
/*Revision: 8.5f    Last modified: 12/23/2003   By: Kevin, change qty_pick = 0 to qty_pick = qty_req*/
/*Revision: eb2+sp7 retrofit by tao fengqin   06/22/2005   */
/*display the title*/
{mfdtitle.i "120816.1"}

def var site like si_site.
def var sidesc like si_desc.
def var src_file as char format "x(40)".
def var msg_file as char format "x(40)".
def var msg-nbr as inte.
/*judy*/
DEF VAR xxyear LIKE glc_year.
DEF VAR xxmonth LIKE glc_per.
DEF VAR xxday AS DATE.
DEF VAR msg_file1 AS CHAR FORMAT "x(40)".
DEF VAR xxstart AS DATE.
/*judy*/
def var i as inte.
def var j as inte.
def var tt as inte .
def var v_data as char extent 38.
def new shared temp-table xxwk
    field xxwk_part like pt_part
    field xxwk_line like ln_line
    field xxwk_site like pt_site
    field xxwk_plan as character extent 31
    field xxwk_errmsg as character format "x(40)" .


    def new shared temp-table xxwk1
    field xxwk1_part like pt_part
    field xxwk1_line like ln_line
    field xxwk1_site like pt_site
    field xxwk1_plan as decimal extent 31 .



define variable xxraw as integer label "数据开始行" initial 5 .
define variable startcolumn as integer .
define variable endcolumn as integer .
define variable endrowmark as character .
define variable excelapp as com-handle.
define variable excelworkbook as com-handle.
define variable excelsheetmain as com-handle.
def var conf-yn as logic.
def stream tl.
def var ok_yn as logic.
define variable outfile as character .
define variable dateformat as character initial "ddmmyy" .
define variable endmonthday as date .

FORM /*GUI*/

 RECT-FRAME       AT ROW 1 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1 COLUMN 3 NO-LABEL VIEW-AS TEXT SIZE-PIXELS 1 BY 1
 SKIP(.1)  /*GUI*/
 /*tfq site colon 22 sidesc no-label skip(1) */
 src_file colon 22 label "导入文件"
 msg_file colon 22 label "日志文件"
 xxyear COLON 22 xxmonth COLON 40 SKIP  /*judy*/
 xxraw    colon 22  label "数据开始行"  skip(1)

   "** 模板格式不允许合并单元格，以空行结束，不允许改变列的位置**" at 5 skip
   "** 数据必须放在SHEET1** "              at 5 skip
          SKIP(.4)  /*GUI*/
with frame a side-labels width 80 attr-space NO-BOX THREE-D /*GUI*/.

 DEFINE VARIABLE F-a-title AS CHARACTER INITIAL "".
 RECT-FRAME-LABEL:SCREEN-VALUE in frame a = F-a-title.
 RECT-FRAME-LABEL:HIDDEN in frame a = yes.
 RECT-FRAME:HEIGHT-PIXELS in frame a =
  FRAME a:HEIGHT-PIXELS - RECT-FRAME:Y in frame a - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME a = FRAME a:WIDTH-CHARS - .5.  /*GUI*/
/*tfq*/   setFrameLabels(frame a:handle) .


mainloop:
repeat:

 DO TRANSACTION ON ERROR UNDO, LEAVE:


     if src_file = "" then src_file = "c:\b.xls".
     if msg_file = "" then msg_file = "c:\schlog.txt".
     /*judy*/
     IF xxyear = 0 THEN  xxyear = year(today).
     IF xxmonth = 0 THEN xxmonth = MONTH(TODAY).
     /*judy*/
      update src_file msg_file xxyear xxmonth xxraw validate(input xxraw > 0 ,"行号小于等于零是不允许的")  with frame a.

       IF SEARCH(src_file) = ? THEN DO:
            MESSAGE "错误:导入文件不存在,请重新输入!" view-as alert-box error.
             NEXT-PROMPT src_file WITH FRAME a.
             UNDO, RETRY.
       END.
       IF msg_file = "" THEN DO:
            MESSAGE "错误:日志文件不能为空,请重新输入!" view-as alert-box error.
             NEXT-PROMPT msg_file WITH FRAME a.
             UNDO, RETRY.
       END.
       if substring(src_file , length(src_file) - 3) <> ".xls"  then
       do:
       MESSAGE "错误:只有EXCEL文件才允许导入,请重新输入!" view-as alert-box error.
             NEXT-PROMPT src_file WITH FRAME a.
             UNDO, RETRY.

       end.
/*judy*/
       IF xxyear <= YEAR(TODAY) AND xxmonth < MONTH(TODAY)  THEN DO:
          MESSAGE "错误: 不能更新本月之前的生产日程."   VIEW-AS ALERT-BOX ERROR.
          NEXT-PROMPT xxmonth WITH FRAM a.
          UNDO, RETRY.
      END.
      msg_file1 = msg_file + ".1".
      os-delete value(msg_file1) .
/*judy*/
       conf-yn = no.
       message "确认导入" view-as alert-box question buttons yes-no update conf-yn.
       if conf-yn <> yes then undo,retry.

       /******************main loop********************/
       /******************input the external transfer list data into a stream**************/
       for each xxwk:
            delete xxwk.
       end.

       create "Excel.Application" excelapp.
        excelworkbook = excelapp:workbooks:add(src_file).
        excelsheetmain = excelapp:worksheets("sheet1").

       i = xxraw .
       v_data = "".

/*judy*/

       IF xxyear = YEAR(TODAY) AND xxmonth = MONTH(TODAY) THEN DO:
           xxday = TODAY.
           startcolumn = 7 + day(xxday) .
           {gprun.i ""yygetendmonthday.p"" "(input xxday,
                                           input dateformat,
                                           output endmonthday)"}

            endcolumn = day(endmonthday) + 7.
        END.
        ELSE DO:
            xxday = DATE(xxmonth,01,xxyear).
            startcolumn = 7 + day(xxday) .
            {gprun.i ""yygetendmonthday.p"" "(input xxday,
                                           input dateformat,
                                           output endmonthday)"}

            endcolumn = day(endmonthday) + 7.
        END.
       IF WEEKDAY(xxday) = 1 THEN xxstart = xxday - 6.
       ELSE xxstart = xxday +  2 - WEEKDAY(xxday).

        /*DISP  xxstart startcolumn  endcolumn  endmonthday.
        PAUSE.  */
/*judy*/
        v_data = "".
          repeat:    /*asn input repeat*/
           assign  v_data[1] =  excelsheetmain:cells(i,1):text
                   v_data[2] = excelsheetmain:cells(i,2):text
                   v_data[3] = excelsheetmain:cells(i,3):text
                   v_data[4] = excelsheetmain:cells(i,4):text
                   v_data[5] = excelsheetmain:cells(i,5):text
                   v_data[6] = excelsheetmain:cells(i,6):text .
                   do j = startcolumn to endcolumn :
                   v_data[j] =  excelsheetmain:cells(i,j):text .
                   end.
                   i = i + 1 .
                   endrowmark = "" .
                   do j = 1 to endcolumn :
                   endrowmark = endrowmark + trim(v_data[j])   .
                   end.

             if endrowmark = ""  then
                 do:
                 excelapp:visible = false .
                excelworkbook:close(false).
                excelapp:quit.
                release object excelapp.
                release object excelworkbook.
                release object excelsheetmain.
                 leave .
                 end.
            else do:
            if trim(v_data[6]) = "plan" then do:
            create xxwk .
            assign  xxwk_part = trim(v_data[4])
                    xxwk_line = trim(v_data[2])
                    xxwk_site = trim(v_data[3]) .

                    do j = startcolumn to endcolumn :
                    tt = j - startcolumn + 1.
                    xxwk_plan[tt] = trim(v_data[j]) .

                    end.
                   end.
            end.

        end.

        run schedule_check_upload.
        end.
END.
/***********************/

Procedure schedule_check_upload:

         define variable xxwpart like pt_part .
         define variable  xxline like ln_line .
         define variable  xxsite like pt_site .
         define variable errmsg as character format "x(40)" .
        for each xxwk1:
        delete xxwk1 .
        end.
        /*FOR EACH xxwk:
            DISP xxwk WITH 3 COLUMNS.
        END.*/
        for each xxwk  break  by xxwk_site by xxwk_line by xxwk_part :
             /*MESSAGE xxwk_line xxwk_part xxwk_site.
             PAUSE.*/
            if first-of(xxwk_part) then
             do:
                     ok_yn = yes.

                    {gprun.i ""yyschupld1.p"" "(input xxwk_site,
                                               input xxwk_line,
                                               input xxwk_part,
                                               input-output ok_yn ,
                                               output errmsg
                                               )"}

                     if ok_yn = no then xxwk_err = errmsg .
                     else  do:
                         create xxwk1 .
                         assign xxwk1_site = xxwk_site
                                xxwk1_part = xxwk_part
                                xxwk1_line = xxwk_line .
                                do i = 1 to 31 :
                                     xxwk1_plan[i] = decimal(xxwk_plan[i]) .

                                end.
                     end .

             end.  /*first-of  */
             else do:
                if ok_yn = no
                then xxwk_err = errmsg .
                else  do:
                    find first xxwk1 where xxwk1_part = xxwk_part and xxwk1_line = xxwk_line
                    and xxwk1_site = xxwk_site  no-error .
                      if available xxwk1 then
                      do:
                                do i = 1 to 31 :
                                     xxwk1_plan[i]  = xxwk1_plan[i] + decimal(xxwk_plan[i]) .

                                  end.
                         end.
                    end .
              end.
        end.

            find first xxwk where xxwk_err <> "" no-lock no-error .
            if available xxwk then
            do:
              output to value(msg_file) .
            for each  xxwk where xxwk_err <> "" no-lock :
            export xxwk .
            end.
            output close .
            end.
            else do:
            /*****************
                  for each xxwk1 where xxwk1_part = "10G0BA-98" no-lock :
                  display xxwk1_part xxwk1_line xxwk1_part xxwk1_plan[1] xxwk1_plan[2] .
                  end.
              ************/
                for each xxwk1 no-lock break by xxwk1_site by xxwk1_line by xxwk1_part:
                if first-of(xxwk1_part) then
             do:

                   outfile = xxwk1_site + xxwk1_line + xxwk1_part .
                 output to value(outfile) .

                     put '"' + TRIM(xxwk1_part) + '"' +
               ' "' + TRIM(xxwk1_site) + '"' +
                 ' "' + TRIM(xxwk1_line) + '"' +
                 ' "' + STRING(xxstart) + '"'  format "x(80)"  at 1 skip .
     /*judy*/
                   /*MESSAGE xxday - xxstart - 1  "a".
                   PAUSE.*/
                     DO j = 1 TO xxday - xxstart :
                         PUT  " -  " .
                     END.

                   tt =  xxday - xxstart + 1 .
                   /*MESSAGE tt "= tt".
                   PAUSE.*/
       /*judy*/
                         i = 1 .
                           j = 1 .
                           repeat :
                              /*MESSAGE "TT" tt.
                               PAUSE.*/
                               put xxwk1_plan[j] " " .
                               i = i + 1.
                               j = j + 1 .
                               tt = tt + 1 .
                               if i > endcolumn - startcolumn + 1 then
                               do:
                                       put "" skip .
                                       leave .
                               end.
                               if tt > 7 then
                               do:
                                       put "" skip .
                                       tt = 1 .
                               end.

                         end.  /*repeat*/
                        put  "." skip
                     "." skip .
                output close .
              /* message "cimload file created" .
                pause . */
               /* OS-COMMAND notepad  value(outfile) . */

                batchrun = yes .
               output to value(msg_file1) APPEND.
               input from value(outfile) .
               {gprun.i ""rerpmt.p""}
               input close .
               output close .

                end.   /*first-of(xxwk1_ponbr)*/




            end. /*for each */

            end.  /*else do*/


            find first xxwk where xxwk_err <> "" no-lock no-error .
            if not available xxwk then
            do:
            for each xxwk1 break by  xxwk1_site by xxwk1_line by xxwk1_part :
            if first-of(xxwk1_part) then
            do:
               output to value(msg_file) APPEND.
                  for each rps_mstr no-lock where rps_domain = global_domain
                        and rps_part = xxwk1_part
                        and rps_site = xxwk1_site
                        and rps_line = xxwk1_line and rps_due_date >= xxday  /*judy*/
                        and rps_due_date <= endmonthday   :
                      export rps_part rps_site rps_line rps_due_date rps_qty_req rps_bom_code rps_routing " 成功上载 " .
                   end.
                output close .
            end.
            end.
            end.
           OS-COMMAND silent notepad value(msg_file) .

      os-delete value(msg_file) .

End procedure.

/*****************/

