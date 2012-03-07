/* xxpopoim.p - pod_due_date,pod_per_date,pod_need,pod_stat cim modify       */
/*by Ken chen 111031.1                                                       */
/*by Ken chen 111220.1                                                       */
/*by Ken chen 111228.1                                                       */
/*by Ken chen 120113.1                                                       */
/*by Ken chen 120119.1                                                       */
/*120119.1 导入失败则给出失败的栏位                                          */
/*120130.1 fixbug 已收货采购单项次修改失败                                   */
/*120203.1 fixbug 有寄售的采购单项次修改失败                                 */
/*V8:ConvertMode=Report                                                      */
/*V8:RunMode=Character,Windows                                               */
/*-Revision end--------------------------------------------------------------*/
{mfdtitle.i "120206.1"}

DEFINE NEW SHARED VARIABLE file_name AS CHARACTER FORMAT "x(50)".
DEFINE NEW SHARED VARIABLE v_qty_oh LIKE IN_qty_oh.
DEFINE NEW SHARED VARIABLE fn_i AS CHARACTER.
DEFINE NEW SHARED VARIABLE v_tr_trnbr LIKE tr_trnbr.
DEFINE NEW SHARED VARIABLE v_flag AS CHARACTER.

DEFINE NEW SHARED TEMP-TABLE xxpod_det
   FIELD xxpod_nbr LIKE po_nbr
   FIELD xxpod_line LIKE pod_line
   FIELD xxpod_due_date LIKE pod_due_date
   FIELD xxpod_per_date LIKE pod_per_date
   FIELD xxpod_need LIKE pod_need
   FIELD xxpod_status LIKE pod_status
   FIELD xxpod_error AS CHARACTER FORMAT "x(48)"
   INDEX index1 xxpod_nbr xxpod_line.

FORM /*GUI*/
    SKIP(1)
   FILE_name COLON 20 skip(1)
   "注意:文件格式为逗号(,)隔开的文本文件" colon 16 skip
   "栏位顺序依次为：" colon 20
   "采购单号,项次,截止日期,履行日期,需求日期,状态" colon 20 skip(2)
with frame a side-labels width 80 .

find first usrw_wkfl no-lock where usrw_domain = global_domain
       and usrw_key1 = "xxpopoim.p" and usrw_key2 = global_userid no-error.
if available usrw_wkfl then do:
   assign file_name = usrw_key3.
end.

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
       {wbrp06.i &command = update &fields = "file_name" &frm = "a"}

       IF SEARCH(FILE_name) = ? THEN DO:
           MESSAGE "文件不存在,请重新输入" VIEW-AS ALERT-BOX.
           next-prompt FILE_name.
           undo, retry.
       END.
    find first usrw_wkfl where usrw_domain = global_domain
           and usrw_key1 = "xxpopoim.p" and usrw_key2 = global_userid no-error.
    if not available usrw_wkfl then do:
       create usrw_wkfl.
       assign usrw_domain = global_domain
              usrw_key1 = "xxpopoim.p"
              usrw_key2 = global_userid.
    end.
    if file_name <> usrw_key3 then do:
       assign usrw_key3 = file_name.
    end.

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

    {gprun.i ""xxpopoim01.p""}

     IF v_flag = "1" THEN DO:
        PUT "无数据,请重新输入".
     END.

     IF v_flag = "2" THEN DO:
         FOR EACH xxpod_det WHERE xxpod_error <> "" NO-LOCK:
             DISP xxpod_det WITH WIDTH 200.
         END.
     END.

     IF v_flag = "3" THEN DO:
         FOR EACH xxpod_det  NO-LOCK:
             DISP xxpod_det WITH WIDTH 200.
         END.
     END.


     {mfrtrail.i}
end.

{wbrp04.i &frame-spec = a}
