/* ss - 091028.1 by: jack */     /* xxmqc_char[1] = "consignd" 与收货区分*/
/* ss - 091029.1 by: jack */
/* ss - 091102.1 by:jack */
/* ss - 120328.1 by: jack */ /* tr_qty_chg tr_qty_loc */
/* ss - 120621.1 by: zy */ /* 检验后修改库存状态 */

/******************************************************************************/
{mfdtitle.i "120621.1 "}

{cxcustom.i "xxmqc001.P"}

define variable trdate like tr_effdate.
define variable trdate1 like tr_effdate.
define variable part like tr_part.
define variable part1 like tr_part.
DEFINE VAR line LIKE ln_line .
DEFINE VAR line1 LIKE ln_line .
DEFINE VAR v_counter AS INT .
DEFINE VAR choice AS LOGICAL .
DEFINE VAR v_yn1 AS LOGICAL .
DEFINE VAR v_file AS CHAR.
DEFINE  TEMP-TABLE tt
   FIELD t1_rcp_date LIKE tr_date
    FIELD t1_prod_line LIKE tr_addr
    FIELD t1_part LIKE tr_part
    FIELD t1_qty_chg LIKE tr_qty_chg
    FIELD t1_serial LIKE tr_serial
    FIELD t1_status LIKE xxmqc_status
    .
/* ss - 091029.1 -b */
DEFINE  TEMP-TABLE tt2
   FIELD t2_rcp_date LIKE tr_date
    FIELD t2_prod_line LIKE tr_addr
    FIELD t2_part LIKE tr_part
    FIELD t2_qty_chg LIKE tr_qty_chg
    FIELD t2_serial LIKE tr_serial
    FIELD t2_status LIKE xxmqc_status
    .
/* ss - 091029.1 -e */

trdate = TODAY.
trdate1 =TODAY .

{&ICTRRP02-P-TAG4}
form

   trdate         colon 20
   trdate1        label "To" colon 49 skip
   line           colon 20
   line1          label "To" colon 49 skip
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
    if line1 = hi_char then line1 = "".
    if part1 = hi_char then part1 = "".

   {&ICTRRP02-P-TAG6}

   if c-application-mode <> 'web' then
   {&ICTRRP02-P-TAG7}
   UPDATE trdate trdate1 line line1 part part1
   with frame a.

   {wbrp06.i &command = update &fields = "   trdate trdate1 line line1 part part1" &frm = "a"}

   {&ICTRRP02-P-TAG8}
   if (c-application-mode <> 'web') or
      (c-application-mode = 'web' and
      (c-web-request begins 'data'))
   then do:

      bcdparm = "".
       {mfquoter.i trdate      }
      {mfquoter.i trdate1     }
      {mfquoter.i line        }
      {mfquoter.i line1        }
      {mfquoter.i part        }
      {mfquoter.i part1       }


      {&ICTRRP02-P-TAG12}
      if trdate = ? then trdate = TODAY.
      if trdate1 = ? then trdate1 = TODAY.
      if line1 = "" then line1 = hi_char.
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
  FOR EACH tt2:
      DELETE tt2 .
  END.
/* ss - 091029.1 -b
  for each tr_hist WHERE (tr_date >= trdate and tr_date <= trdate1)
       and (tr_type = "rct-wo")
       AND (tr_prod_line >= line AND tr_prod_line <= line1)
       AND (tr_part >= part and tr_part <= part1)
      use-index tr_date_trn
   no-lock break  by tr_date by tr_prod_line by tr_part:

      FIND FIRST xxmqc_det WHERE xxmqc_rcp_date = tr_date AND xxmqc_vend = tr_prod_line AND xxmqc_part = tr_part AND xxmqc_serial  = tr_serial  AND xxmqc_char[1] = "consignd" NO-LOCK NO-ERROR .
      IF NOT AVAILABLE  xxmqc_det THEN DO:

       FIND FIRST tt WHERE t1_rcp_date = tr_date AND t1_prod_line = tr_prod_line AND t1_part = tr_part AND t1_serial = tr_serial   NO-LOCK NO-ERROR .
       IF NOT  AVAILABLE tt THEN DO:
           CREATE tt .
           ASSIGN
               t1_rcp_date = tr_date
               t1_prod_line = tr_prod_line
               t1_part = tr_part
               t1_serial = tr_serial
               t1_qty_chg = tr_qty_chg
               t1_status = ""
               .
       END.
       ELSE DO:
           t1_qty_chg = tr_qty_chg + t1_qty_chg .
       END.
      END.  /* not available xxmqc_det */
      ELSE DO:
            FIND FIRST tt WHERE t1_rcp_date = tr_date AND t1_prod_line = tr_prod_line  AND t1_part = tr_part AND t1_serial = tr_serial   NO-LOCK NO-ERROR .
       IF NOT  AVAILABLE tt THEN DO:
           CREATE tt .
           ASSIGN
               t1_rcp_date = tr_date
               t1_prod_line = tr_prod_line
               t1_part = tr_part
               t1_serial = tr_serial
               t1_qty_chg = tr_qty_chg
               t1_status = xxmqc_status
               .

      END.
      ELSE DO:
           t1_qty_chg = tr_qty_chg + t1_qty_chg .
       END.
      END.  /* available xxmqc_det */
   END.

   /* ss - 091012.1 -b */
      ss  - 091029.1 -e */

   /* ss - 091029.1 -b */
  for each tr_hist WHERE (tr_effdate >= trdate and tr_effdate <= trdate1)
       and (tr_type = "rct-wo")
       AND (tr_part >= part and tr_part <= part1)
      use-index tr_eff_trnbr
   no-lock:
     /* ss - 091102.1 -b
      FOR FIRST op_hist WHERE op_date = tr_effdate AND op_wo_lot = tr_lot AND (op_line >= LINE AND op_line <= line1) NO-LOCK :
      ss - 091102.1 -e */
     /* ss - 091102.1 -b */
      FOR FIRST wo_mstr WHERE wo_lot = tr_lot AND (wo_line >= LINE AND wo_line <= line1) NO-LOCK:

      /* ss -091102.1 -e */
      FIND FIRST xxmqc_det WHERE xxmqc_rcp_date = tr_effdate AND xxmqc_vend = wo_line AND xxmqc_part = tr_part AND xxmqc_serial  = tr_serial  AND xxmqc_char[1] = "consignd" NO-LOCK NO-ERROR .
      IF NOT AVAILABLE  xxmqc_det THEN DO:

       FIND FIRST tt2 WHERE t2_rcp_date = tr_effdate AND t2_prod_line = wo_line AND t2_part = tr_part AND t2_serial = tr_serial   NO-LOCK NO-ERROR .
       IF NOT  AVAILABLE tt2 THEN DO:
           CREATE tt2 .
           ASSIGN
               t2_rcp_date = tr_effdate
               t2_prod_line = wo_line
               t2_part = tr_part
               t2_serial = tr_serial
               /* ss - 120328.1 -b
               t2_qty_chg = tr_qty_chg
               ss - 120328.1 -e */
               /* ss - 120328.1 -b */
               t2_qty_chg = tr_qty_loc
               /* ss - 120328.1 -e */
               t2_status = ""
               .
       END.
       ELSE DO:
           /* ss - 120328.1 -b
           t2_qty_chg = tr_qty_chg + t2_qty_chg .
           ss - 120328.1 -e */
           /* ss - 120328.1 -b */
           t2_qty_chg = tr_qty_loc + t2_qty_chg .
           /* ss - 120328.1 -e */
       END.
      END.  /* not available xxmqc_det */
      ELSE DO:
            FIND FIRST tt2 WHERE t2_rcp_date = tr_effdate AND t2_prod_line = wo_line  AND t2_part = tr_part AND t2_serial = tr_serial   NO-LOCK NO-ERROR .
       IF NOT  AVAILABLE tt2 THEN DO:
           CREATE tt2 .
           ASSIGN
               t2_rcp_date = tr_effdate
               t2_prod_line = wo_line
               t2_part = tr_part
               t2_serial = tr_serial
               /* ss - 120328.1 -b
               t2_qty_chg = tr_qty_chg
               ss - 120328.1 -e */
               /* ss - 120328.1 -b */
               t2_qty_chg = tr_qty_loc
               /* ss - 120328.1 -e */
               t2_status = xxmqc_status
               .

      END.
      ELSE DO:
          /* ss - 120328.1 -b
           t2_qty_chg = tr_qty_chg + t2_qty_chg .
           ss - 120328.1 -e */
          /* ss - 120328.1 -b */
          t2_qty_chg = tr_qty_loc + t2_qty_chg .
          /* ss - 120328.1 -e */
       END.
      END.  /* available xxmqc_det */
     END.  /* available op_hist*/
   END.

   FOR EACH tt2  NO-LOCK WHERE t2_part <> ""  BREAK BY t2_rcp_date BY t2_prod_line BY t2_part  :
        CREATE tt .
           ASSIGN
               t1_rcp_date = t2_rcp_date
               t1_prod_line = t2_prod_line
               t1_part = t2_part
               t1_serial = t2_serial
               t1_qty_chg = t2_qty_chg
               t1_status = t2_status
               .
   END.
  /* ss -091029.1 -e */

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
               t1_prod_line     column-label "生产线"
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
                   &display2     = t1_prod_line
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
    FIND FIRST xxmqc_det WHERE xxmqc_rcp_date = t1_rcp_date AND xxmqc_vend = t1_prod_line AND xxmqc_part = t1_part AND xxmqc_serial  = t1_serial  AND xxmqc_char[1] = "consignd" NO-ERROR .
    IF NOT AVAILABLE xxmqc_det THEN DO:
        CREATE xxmqc_det .
            ASSIGN
                xxmqc_rcp_date = t1_rcp_date
                xxmqc_date = TODAY
                xxmqc_vend = t1_prod_line
                xxmqc_part = t1_part
                xxmqc_serial = t1_serial
                xxmqc_status = t1_status
                xxmqc_qty = t1_qty_chg
                xxmqc_char[1] = "consignd"
                .
    END.
    ELSE DO:
        IF  xxmqc_status <> t1_status OR xxmqc_qty <> t1_qty_chg  THEN DO:
            ASSIGN
                xxmqc_status = t1_status
                xxmqc_date = TODAY
                xxmqc_qty = t1_qty_chg .
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
/*ss 120606.1 检验后修改库存状态*/
assign v_file = "xxmqc003.p." + string(today,"99999999") + "-" + string(time).
output to value(v_file + ".bpi").
FOR EACH tt NO-LOCK where t1_status = "1":
    for each ld_det no-lock use-index ld_part_lot where ld_part = t1_part and
               ld_lot = t1_serial:
       put unformat '"' ld_site '" "' ld_loc '" "' ld_part '" "' ld_lot '"'
                    skip.
       if t1_status = "1" then do:
          put unformat '- - - "Y-Y-N"' skip.
       end.
       else if t1_status = "2" then do:
          put unformat '- - - "N-N-N"' skip.
       end.
       else do:
          put unformat '- - - "N-Y-N"' skip.
       end.
    end.
END.
output close.

batchrun  = yes.
input from value(v_file + ".bpi").
output to value(v_file + ".bpo") keep-messages.
hide message no-pause.
{gprun.i ""icldmt.p""}
hide message no-pause.
output close.
input close.
batchrun  = no.

os-delete value(v_file + ".bpi") no-error.
os-delete value(v_file + ".bpo") no-error.

end.

{wbrp04.i &frame-spec = a}
