/*Gui */
/*by Ken chen 111031.1*/
/*by Ken chen 111220.1*/
/*by Ken chen 111228.1*/
{mfdtitle.i "111228.1"}


DEFINE NEW SHARED VARIABLE file_name AS CHARACTER FORMAT "x(50)".
DEFINE NEW SHARED VARIABLE v_qty_oh LIKE IN_qty_oh.
DEFINE NEW SHARED VARIABLE fn_i AS CHARACTER.
DEFINE NEW SHARED VARIABLE v_tr_trnbr LIKE tr_trnbr.
DEFINE NEW SHARED VARIABLE v_flag AS CHARACTER.


DEFINE NEW SHARED TEMP-TABLE xxso
   FIELD xxso_nbr LIKE so_nbr
   FIELD xxso_effdate LIKE tr_effdate
   FIELD xxso_site LIKE so_site
   FIELD xxso_line LIKE sod_line
   FIELD xxso_part LIKE sod_part
   FIELD xxso_qty LIKE sod_qty_ord
   FIELD xxso_loc LIKE loc_loc
   FIELD xxso_error AS CHARACTER FORMAT "x(24)"
   INDEX index1 xxso_nbr.


DEFINE NEW SHARED TEMP-TABLE xxso1
   FIELD xxso1_nbr LIKE so_nbr
   FIELD xxso1_effdate LIKE tr_effdate
   FIELD xxso1_site LIKE so_site
   FIELD xxso1_line LIKE sod_line
   FIELD xxso1_part LIKE sod_part
   FIELD xxso1_qty LIKE sod_qty_ord
   FIELD xxso1_loc LIKE loc_loc
   FIELD xxso1_lot LIKE tr_lot
   FIELD xxso1_lot_qty LIKE ld_qty_oh
   FIELD xxso1_error AS CHARACTER FORMAT "x(24)"
   INDEX index1 xxso1_nbr.


FORM /*GUI*/ 
    SKIP(1)
   FILE_name COLON 20 
with frame a side-labels width 80 ATTR-SPACE NO-BOX THREE-D.



/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).
{wbrp01.i}

repeat on error undo, retry:
       if c-application-mode <> 'web' then
          update FILE_name with frame a
       editing:
           status input.
           readkey.
           apply lastkey.
       end.
       {wbrp06.i &command = update &fields = "file_name"
          &frm = "a"}

       IF SEARCH(FILE_name) = ? THEN DO:
           MESSAGE "文件不存在,请重新输入" VIEW-AS ALERT-BOX.
           next-prompt FILE_name.
           undo, retry.
       END.


    MESSAGE "正在处理请等待......".

   /* OUTPUT DESTINATION SELECTION */
   {gpselout.i &printType = "window"
               &printWidth = 80
               &pagedFlag = " "
               &stream = " "
               &appendToFile = " "
               &streamedOutputToTerminal = " "
               &withBatchOption = "no"
               &displayStatementType = 1
               &withCancelMessage = "yes"
               &pageBottomMargin = 6
               &withEmail = "yes"
               &withWinprint = "yes"
               &defineVariables = "yes"}
               

    {mfphead.i}

    {gprun.i ""xxsoship01.p""}

     IF v_flag = "1" THEN DO:
        PUT "无数据,请重新输入".
     END.
    
     IF v_flag = "2" THEN DO:
         FOR EACH xxso WHERE xxso_error <> "" NO-LOCK by xxso_nbr by xxso_line:           
             DISP xxso WITH WIDTH 200 STREAM-IO.
         END.
     END.

     IF v_flag = "3" THEN DO:
         FOR EACH xxso1 by xxso1_nbr by xxso1_line:
             DISP xxso1 WITH WIDTH 200 STREAM-IO.
         END.
     END.


     {mfrtrail.i}
end.

{wbrp04.i &frame-spec = a}
