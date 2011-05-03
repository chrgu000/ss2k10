/* ss - 091012.1 by: jack */
/* ss - 091028.1 by: jack */
/* ss - 091102.1 by: jack */

/******************************************************************************/

{mfdtitle.i "091102.1 "}
{cxcustom.i "xxmqc001.P"}

define variable trdate like tr_effdate.
define variable trdate1 like tr_effdate.
define variable part like tr_part.
define variable part1 like tr_part.
DEFINE VAR vend LIKE po_vend .
DEFINE VAR vend1 LIKE po_vend .
DEFINE VAR v_counter AS INT .
DEFINE VAR choice AS LOGICAL .
DEFINE VAR v_yn1 AS LOGICAL .

DEFINE  TEMP-TABLE tt
   FIELD t1_rcp_date LIKE tr_date
    FIELD t1_addr LIKE tr_addr
    FIELD t1_part LIKE tr_part
    FIELD t1_qty_chg LIKE tr_qty_chg
    FIELD t1_serial LIKE tr_serial
    FIELD t1_status LIKE xxmqc_status
    .

trdate = TODAY.
trdate1 =TODAY .

{&ICTRRP02-P-TAG4}
form
   
   trdate         colon 20
   trdate1        label "To" colon 49 skip
   vend           colon 20
   vend1          label "To" colon 49 skip
    part           colon 20
    part1          label "To" colon 49 skip
   
with overlay frame a side-labels.
{&ICTRRP02-P-TAG5}

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

{wbrp01.i}
repeat:

    if trdate = low_date then trdate = TODAY.
    if trdate1 = hi_date then trdate1 = TODAY.
    if vend1 = hi_char then vend1 = "".
    if part1 = hi_char then part1 = "".
  
   {&ICTRRP02-P-TAG6}

   if c-application-mode <> 'web' then
   {&ICTRRP02-P-TAG7}
   UPDATE trdate trdate1 vend vend1 part part1  
   with frame a.

   {wbrp06.i &command = update &fields = "   trdate trdate1 vend vend1 part part1" &frm = "a"}

   {&ICTRRP02-P-TAG8}
   if (c-application-mode <> 'web') or
      (c-application-mode = 'web' and
      (c-web-request begins 'data'))
   then do:

      bcdparm = "".
       {mfquoter.i trdate      }
      {mfquoter.i trdate1     }
      {mfquoter.i vend        }
      {mfquoter.i vend1        }
      {mfquoter.i part        }
      {mfquoter.i part1       }
     

      {&ICTRRP02-P-TAG12}
      if trdate = ? then trdate = TODAY.
      if trdate1 = ? then trdate1 = TODAY.
      if vend1 = "" then vend1 = hi_char.
      if part1 = "" then part1 = hi_char.
     
      {&ICTRRP02-P-TAG13}

   end.
  /*
   /* OUTPUT DESTINATION SELECTION */
   {gpselout.i &printType = "printer"
               &printWidth = 132
               &pagedFlag = " "
               &stream = " "
               &appendToFile = " "
               &streamedOutputToTerminal = " "
               &withBatchOption = "yes"
               &displayStatementType = 1
               &withCancelMessage = "yes"
               &pageBottomMargin = 6
               &withEmail = "yes"
               &withWinprint = "yes"
               &defineVariables = "yes"}
               */
  /* {mfphead.i}
   */
       
  for each tt :
  delete tt .
  end .
/*
  PUT UNFORMATTED "#def REPORTPATH=$/QAD Addons/BI Report/" + SUBSTRING(execname,1,LENGTH(execname) - 2) SKIP.
  PUT UNFORMATTED "#def :end" SKIP.
  put "日期;供应商;零件;批序号;数量" skip .
 */

  for each tr_hist WHERE (tr_effdate >= trdate and tr_effdate <= trdate1)
       and (tr_type = "rct-po") 
       AND (tr_addr >= vend AND tr_addr <= vend1) 
       AND (tr_part >= part and tr_part <= part1)
      use-index tr_eff_trnbr
   no-lock break  by tr_effdate by tr_addr by tr_part:

      FIND FIRST xxmqc_det WHERE xxmqc_rcp_date = tr_effdate AND xxmqc_vend = tr_addr AND xxmqc_part = tr_part AND xxmqc_serial  = tr_serial NO-LOCK NO-ERROR .
      IF NOT AVAILABLE  xxmqc_det THEN DO:
   
       FIND FIRST tt WHERE t1_rcp_date = tr_effdate AND t1_addr = tr_addr AND t1_part = tr_part AND t1_serial = tr_serial   NO-LOCK NO-ERROR .
           IF NOT  AVAILABLE tt THEN DO:
               CREATE tt .
               ASSIGN 
                   t1_rcp_date = tr_effdate
                   t1_addr = tr_addr
                   t1_part = tr_part
                   t1_serial = tr_serial
                   t1_qty_chg = tr_qty_chg
                   t1_status = ""
                   .
           END.
           /* ss - 091028.1 -b */
           ELSE DO:
              t1_qty_chg = tr_qty_chg + t1_qty_chg .
           END.
           /* ss - 091028.1 -e */
      END.  /* not available xxmqc_det */
      ELSE DO:
            FIND FIRST tt WHERE t1_rcp_date = tr_effdate AND t1_addr = tr_addr  AND t1_part = tr_part AND t1_serial = tr_serial   NO-LOCK NO-ERROR .
       IF NOT  AVAILABLE tt THEN DO:
           CREATE tt .
           ASSIGN 
               t1_rcp_date = tr_effdate
               t1_addr = tr_addr
               t1_part = tr_part
               t1_serial = tr_serial
               t1_qty_chg = tr_qty_chg
               t1_status = xxmqc_status
               .

      END.
      /* ss - 091028.1 -b */
      ELSE DO:
           t1_qty_chg = tr_qty_chg + t1_qty_chg .
      END.
      /* ss - 091028.1 -e */
      END.  /* available xxmqc_det */
   END.
     
   /* ss - 091012.1 -b */

   v_counter = 0 .
   for each tt :
       v_counter = v_counter + 1 .
   end.
   
   if v_counter = 0  then  do:
       message "无符合条件的发票." .
       undo, retry .
   end.

   hide all no-pause.
   view frame zzz1 .
   /*
   if v_counter >= 20 then message "每次最多显示20行" .
   */
   choice = no .

   message "请移动光标选择,按回车键查看明细" .
   
   sw_block:
   repeat :
          

           /*****不带星号的frame - begin********/
           define var vv_recid as recid .
           define var vv_first_recid as recid .
           define var v_framesize as integer .
           vv_recid       = ? .
           vv_first_recid = ? .
           v_framesize    = 17 .


         
           define frame zzz1.
           form
               t1_rcp_date        column-label "收货日期"
               t1_addr     column-label "供应商"
               t1_part        column-label "零件"
               t1_serial        column-label "批号"  
               t1_qty_chg         column-label "数量"  
               t1_status         column-label "状态"
           with frame zzz1 width 80 v_framesize down 
           title color normal  "检验判断".  

           scroll_loop:
           do with frame zzz1:
               {xxsoivpst003.i 
                   &domain       = "true and "
                   &buffer       = tt
                   &scroll-field = t1_rcp_date
                   &searchkey    = "true"
                   &framename    = "zzz1"
                   &framesize    = v_framesize
                   &display1     = t1_rcp_date
                   &display2     = t1_addr
                   &display3     = t1_part       
                   &display4     = t1_serial       
                    &display5     = t1_qty_chg        
                    &display6     = t1_status           
                    &exitlabel    = scroll_loop
                    &exit-flag    = "true"
                    &record-id    = vv_recid
                    &first-recid  = vv_first_recid
                    &logical1     = true 
            }

         
        end. /*scroll_loop*/

        if keyfunction(lastkey) = "end-error"
            or lastkey = keycode("F4")
            or lastkey = keycode("ESC")
        then do:
                {mfmsg01.i 36 1 choice} /*是否退出?*/
                if choice = yes then do :
                    for each tt exclusive-lock:
                        delete tt .
                    end.
                    clear frame zzz1 all no-pause .
                    choice = no .
                    leave .
                end.
        end.  /*if keyfunction(lastkey)*/  
        
        if keyfunction(lastkey) = "go"
        then do:
            v_yn1 = no . /*v_yn1 = yes 则不可以退出 */
            vv_recid = ? . /*退出前清空vv_recid*/
            if v_yn1 = no then do :
                choice = yes .
                {mfmsg01.i 12 1 choice }  /*是否正确?*/
                if choice then     leave .
            end. 

        end.  /*if keyfunction(lastkey)*/  

        if vv_recid <> ? then do:
            find first tt where recid(tt) = vv_recid no-error .
            if avail tt then do:
               view frame zzz1 .
             message "请输入批核结果1 检验合格  0 不合格  空 为未检验" .
                update t1_status with frame zzz1 .        
            end.
        end.
        /*****不带星号的frame - end********/

END. /*sw_block:*/

   /* ss - 091012.1 -e */

/* 更新*/
FOR EACH tt NO-LOCK:
    FIND FIRST xxmqc_det WHERE xxmqc_rcp_date = t1_rcp_date AND xxmqc_vend = t1_addr AND xxmqc_part = t1_part AND xxmqc_serial  = t1_serial  NO-ERROR .
    IF NOT AVAILABLE xxmqc_det THEN DO:
        CREATE xxmqc_det .
            ASSIGN
                xxmqc_rcp_date = t1_rcp_date
                xxmqc_date = TODAY
                xxmqc_vend = t1_addr
                xxmqc_part = t1_part
                xxmqc_serial = t1_serial
                xxmqc_status = t1_status
                xxmqc_qty = t1_qty_chg
                .
    END.
    ELSE DO:
        /* ss - 091028.1 -b
        IF  xxmqc_status <> t1_status  THEN DO:
        ss - 091028.1 -e */
        /* ss - 091028.1 -b */
        IF xxmqc_status <> t1_status OR xxmqc_qty <> t1_qty_chg THEN DO:
       /* ss - 091028.1 -e */
            ASSIGN 
                xxmqc_status = t1_status
                xxmqc_date = TODAY 
                /* ss - 091028.1 -b */
                xxmqc_qty = t1_qty_chg
                /* ss - 091028.1 -e */ .
        END.
    END.

END.
/* 更新*/
 CLEAR frame zzz1 all no-pause .
 HIDE  all no-pause .
/*
   FOR EACH tt:
 
    EXPORT DELIMITER "," tt .
  end.
  {mfreset.i}
  */
 
  
end.

{wbrp04.i &frame-spec = a}
