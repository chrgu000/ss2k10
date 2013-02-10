/*yyldfc.p designed by Philips Li for forecast-loading by excel     03/31/08  */
/*Last Modified by Philips Li              eco:phi002               04/29/08  */
/*Last Modified by Philips Li              eco:phi003               05/06/08  */
{mfdtitle.i "121204.1"}

DEFINE VARIABLE src_file AS CHAR FORMAT "x(40)".
DEFINE VARIABLE lg_file AS CHAR FORMAT "x(40)".
DEFINE VARIABLE cim_file AS CHAR FORMAT "x(40)".
DEFINE VARIABLE j AS INT NO-UNDO.
DEFINE VARIABLE START LIKE ro_start NO-UNDO.
DEFINE VARIABLE colnum AS INT.
DEFINE VARIABLE part LIKE pt_part.
DEFINE VARIABLE site LIKE si_site.

DEF VAR startline AS INT LABEL "数据开始行" INIT 3.
DEF VAR conf-yn AS LOGICAL.
DEF VAR i AS INT.
DEF VAR k AS INT.
/*phi002*/ DEF VAR l AS INT.
/*phi002*/ DEF VAR m AS INT.
/*phi002*/ DEF VAR w AS INT.
/*phi002*/ DEF VAR msum AS INT.
/*phi002*/ DEF VAR wsum AS INT.
/*phi002*/ DEF VAR lwsum AS INT.
DEF VAR fid AS INT.
DEF VAR tid AS INT.
DEF VAR err AS INT.
DEF VAR isvalid AS LOG.
DEF VAR isvalidline AS LOG.
DEF VAR year1 AS INT.
DEF VAR year2 AS INT.
DEF VAR year1end AS INT INIT 0.
DEF VAR year2end AS INT INIT 0.
DEF VAR istwoyears AS LOGICAL.
DEF VAR yea AS INT.
def var vyear as integer.
def var vmonth as integer.
DEF STREAM cim.
define variable vqty as integer.
DEF VAR start_flag AS CHAR format "x(80)" .

DEFINE VARIABLE excelapp AS COM-HANDLE.
DEFINE VARIABLE excelworkbook AS COM-HANDLE.
DEFINE VARIABLE worksheet AS COM-HANDLE.

DEFINE TEMP-TABLE tmpa_data
       fields tad_part like fcs_part
       fields tad_site like fcs_site
       fields tad_year as   integer
       fields tad_month as integer
       fields tad_qty  as decimal
       fields tad_qty_old as decimal
       index tad_year tad_year
       .

define temp-table tmpb_ym
       fields tby_year as integer
       fields tby_month as integer
       fields tby_date as date
       fields tby_sort as character
       fields tby_sn   as integer.

define temp-table tmpc_ret
       fields tcr_part like fcs_part
       fields tcr_site like fcs_site
       fields tcr_year as integer
       fields tcr_qty  as decimal extent 52.

FORM /*GUI*/

 RECT-FRAME       AT ROW 1 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1 COLUMN 3 NO-LABEL VIEW-AS TEXT SIZE-PIXELS 1 BY 1
 SKIP(.1)  /*GUI*/
 /*tfq site colon 22 sidesc no-label skip(1) */
 src_file COLON 22 LABEL "导入文件"
 lg_file COLON 22 LABEL "日志文件"
 startline COLON 22  LABEL "数据开始行"  SKIP(1)
   "** 模板格式不允许合并单元格，以空行结束，不允许改变列的位置，数据必须放在sheet1**"       AT 5 SKIP
   "** 导入完毕之前请勿用excel打开导入文件**  "  AT 5 SKIP

    SKIP(.4)  /*GUI*/
WITH FRAME a SIDE-LABELS WIDTH 80 ATTR-SPACE NO-BOX THREE-D /*GUI*/.

 DEFINE VARIABLE F-a-title AS CHARACTER INITIAL "".
 RECT-FRAME-LABEL:SCREEN-VALUE in frame a = F-a-title.
 RECT-FRAME-LABEL:HIDDEN IN FRAME a = YES.
 RECT-FRAME:HEIGHT-PIXELS IN FRAME a =
 FRAME a:HEIGHT-PIXELS - RECT-FRAME:Y IN FRAME a - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME a = FRAME a:WIDTH-CHARS - .5.  /*GUI*/
 setFrameLabels(FRAME a:HANDLE) .

mainloop:
REPEAT:

 DO TRANSACTION ON ERROR UNDO, LEAVE:
     IF src_file = "" THEN src_file = "c:\fcsld.xls".
     IF lg_file = "" THEN lg_file = "d:\fcsld.lg".
     find first usrw_wkfl no-lock where usrw_domain = global_domain
            and usrw_key1 = execname and usrw_key2 = global_userid no-error.
     if available usrw_wkfl then do:
        assign src_file = usrw_charfld[1]
               lg_file = usrw_charfld[2]
               startline = usrw_intfld[1].
     end.
     if startline = 0 then startline = 3.
     isvalid = YES.
     istwoyears = NO.
     empty temp-table tmpa_data no-error.
     empty temp-table tmpb_ym no-error.
     empty temp-table tmpc_ret no-error.
      UPDATE src_file lg_file startline VALIDATE(INPUT startline > 0 ,"行号小于等于零是不允许的")  with frame a.

       IF SEARCH(src_file) = ? THEN DO:
            MESSAGE "错误:导入文件不存在,请重新输入!" VIEW-AS ALERT-BOX ERROR.
             NEXT-PROMPT src_file WITH FRAME a.
             UNDO, RETRY.
       END.

       IF SUBSTRING(src_file , LENGTH(src_file) - 3) <> ".xls"  THEN
       DO:
       MESSAGE "错误:只有EXCEL文件才允许导入,请重新输入!" VIEW-AS ALERT-BOX ERROR.
             NEXT-PROMPT src_file WITH FRAME a.
             UNDO, RETRY.
       END.
       find first usrw_wkfl exclusive-lock where usrw_domain = global_domain
              and usrw_key1 = execname and usrw_key2 = global_userid no-error.
       if not available usrw_wkfl then do:
          create usrw_wkfl. usrw_domain = global_domain.
          assign usrw_key1 = execname
                 usrw_key2 = global_userid.
       end.
        assign usrw_charfld[1] = src_file
               usrw_charfld[2] = lg_file
               usrw_intfld[1] = startline.
       conf-yn = NO.
       MESSAGE "确认导入" VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO UPDATE conf-yn.
       IF conf-yn <> YES THEN UNDO,RETRY.

       CREATE "Excel.Application" excelapp.
       excelworkbook = excelapp:workbooks:ADD(src_file).
       worksheet = excelapp:worksheets("sheet1").
       i = startline.

       colnum = 0.
       REPEAT:
           colnum = colnum + 1.
           IF (TRIM(worksheet:cells(i - 1,colnum):FormulaR1C1)) = "Total" THEN LEAVE.
           IF colnum = 25 THEN DO:
               MESSAGE "导入失败，找不到终止标记TOTAL,请检查起始行!" VIEW-AS ALERT-BOX ERROR.
               UNDO mainloop, RETRY mainloop.
           END.
       END.

       year2end = colnum - 1.

       REPEAT:    /*input repeat*/
          isvalidline = YES.
          site = TRIM(worksheet:cells(i,1):FormulaR1C1).
          part = TRIM(worksheet:cells(i,2):FormulaR1C1).
          do j = 3 to year2end:
             assign vyear = INT(SUBSTRING(TRIM(worksheet:cells(startline - 1,j):FormulaR1C1),4,2))
                    vmonth = INT(SUBSTRING(TRIM(worksheet:cells(startline - 1,j):FormulaR1C1),1,2)).
              FIND FIRST tmpa_data WHERE tad_site = site
                     AND tad_part = part
                     and tad_year = vyear + 2000
                     and tad_month = vmonth
                   NO-LOCK NO-ERROR.
              IF NOT AVAIL tmpa_data THEN DO:
                  CREATE tmpa_data.
                  assign tad_site = site
                         tad_part = part
                         tad_year = vyear + 2000
                         tad_month = vmonth.
              end.
                  assign tad_qty  = decimal(TRIM(worksheet:cells(i,j):FormulaR1C1))
                         tad_qty_old = decimal(TRIM(worksheet:cells(i,j):FormulaR1C1)).
          end.
            /*data checking*/

           /*site checking*/
          FIND FIRST si_mstr WHERE si_domain = global_domain
                 and si_site = site NO-LOCK NO-ERROR.
          IF NOT AVAIL si_mstr THEN DO:
              worksheet:Range(CHR(65 + colnum) + STRING(i)):VALUE = "地点不存在！".
              isvalid = NO.
              isvalidline = NO.
          END.


           /*part not exist in pt_mstr*/
           IF isvalidline = YES THEN DO:
               FIND FIRST pt_mstr WHERE pt_domain = global_domain
                      and pt_part = part NO-LOCK NO-ERROR.
                  IF NOT AVAIL pt_mstr THEN DO:
                  worksheet:Range(CHR(65 + colnum) + STRING(i)):VALUE = "零件号不在pt_mstr中！".
                  isvalid = NO.
                  isvalidline = NO.
                  END.
           END.


           /*part state checking*/
           IF isvalidline THEN DO:
              FIND FIRST pt_mstr WHERE pt_domain = global_domain
                     and pt_part = part NO-LOCK NO-ERROR.
              IF AVAIL pt_mstr THEN DO:
                  FIND FIRST isd_det WHERE isd_domain = global_domain
                         and isd_status MATCHES pt_status + "*"
                                     AND isd_tr_type = "add-fc" NO-LOCK NO-ERROR.
                  IF AVAIL isd_det THEN DO:
                      worksheet:Range(CHR(65 + colnum) + STRING(i)):VALUE = "该零件状态不允许预进行测操作！".
                      isvalid = NO.
                      isvalidline = NO.
                  END.
              END.
           END.

           IF isvalidline THEN DO:
           end.
           i = i + 1 .

             IF worksheet:cells(i,1):FormulaR1C1 = ""  THEN DO:
                LEAVE .
             END.
      END.  /*repeat*/

    excelworkbook:saveas(src_file , , , , , , 1) no-error.
    excelapp:VISIBLE = FALSE .
    excelworkbook:CLOSE(FALSE).
    excelapp:QUIT.
    RELEASE OBJECT excelapp.
    RELEASE OBJECT excelworkbook.
    RELEASE OBJECT worksheet.

 END. /*do transaction*/

 if isvalid = no then do:
   message "发现错误! 请检查日志文件" view-as alert-box error.
   undo,retry.
 end.

  for each tmpa_data no-lock use-index tad_year break by tad_year:
      if first-of(tad_year) then do:
         assign start = ?.
         {fcsdate1.i tad_year start}
         do j = 1 to 52:
           create tmpb_ym.
           assign tby_year = tad_year
                  tby_month = month(start)
                  tby_date = start
                  tby_sort = string(year(start),">>>9") + string(month(start),"99")
                  tby_sn = j.
           assign start = start + 7.
         end.
      end.
  end.

  for each tmpb_ym exclusive-lock break by tby_sort:
      if not first-of(tby_sort) then do:
         delete tmpb_ym.
         next.
      end.
      if integer(substring(tby_sort,1,4)) <> tby_year then do:
         delete tmpb_ym.
      end.
  end.
  for each tmpa_data no-lock:
      find first tmpc_ret exclusive-lock where
           tcr_part = tad_part and
           tcr_site = tad_site and
           tcr_year = tad_year
      no-error.
      if not available tmpc_ret then do:
         create tmpc_ret.
         assign tcr_part = tad_part
                tcr_site = tad_site
                tcr_year = tad_year.
      end.
      assign vqty = TRUNCATE(tad_qty / 4,0).
      find first tmpb_ym no-lock where tby_year = tad_year
            and tby_month = tad_month no-error.
      if available tmpb_ym then do:
          assign i = tby_sn.
      end.
      assign tcr_qty[i + 3] = tad_qty - vqty * 3.
      j = i.
      repeat:
         assign tcr_qty[j] = vqty.
         j = j + 1.
         if j = i + 3 then leave.
      end.
  end.

  FOR EACH tmpc_ret NO-LOCK:
      FOR EACH fcs_sum EXCLUSIVE-LOCK WHERE fcs_domain = GLOBAL_domain
           AND fcs_part = tcr_part AND fcs_site = tcr_site
           AND fcs_year = tcr_year:
           DELETE fcs_sum.
      END.
  END.

  for each tmpc_ret no-lock:
      assign cim_file = execname + tcr_part + tcr_site + string(tcr_year).
      output stream cim to value(cim_file + ".bpi").
          put stream cim unformat '"' tcr_part '" "' tcr_site '" ' tcr_year skip.
          do i = 1 to 52:
             put stream cim unformat tcr_qty[i] ' '.
          end.
          put stream cim skip.
      output stream cim close.
      cimrunprogramloop:
      do on stop undo cimrunprogramloop,leave cimrunprogramloop:
          batchrun = yes.
          input from value(cim_file + ".bpi").
          output to value(lg_file) append.
          hide message no-pause.
             {gprun.i ""fcfsmt01.p""}
          hide message no-pause.
          output close.
          input close.
          batchrun = no.
          assign conf-yn = yes.
          find first fcs_sum NO-LOCK where fcs_domain = global_domain and
                   fcs_part = tcr_part and fcs_site = tcr_site and
                   fcs_year = tcr_year no-error.
          IF AVAILABLE fcs_sum then do:
             do i = 1 to 52:
                if fcs_fcst_qty[i] <> tcr_qty [i] then do:
                   assign conf-yn = no.
                   leave.
                end.
             end.
          END.
          else do:
             assign conf-yn = no.
          end.
          if conf-yn = no then do:
             undo,leave.
          end.
      end.
      os-delete value(cim_file + ".bpi").
  end.
END.
