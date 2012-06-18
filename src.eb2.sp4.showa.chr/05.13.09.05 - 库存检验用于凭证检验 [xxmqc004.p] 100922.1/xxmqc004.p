/* ss - 100628.1 by: jack */    /* prh__chr01 记录结果 1，2，3，4 , 空未检验  prh__dte01 品检日期*/
/* ss - 100920.1 by: jack */  /* 昭和*/
/* ss - 100922.1 by:jack */
/* ss - 101012.1 by:SamSong */
/* ss - 110104.1 by: jack */  /* 排序修改  */
/* ss - 111024 by: yun */ /* 检验过后调整库存状态 */
/******************************************************************************/

{mfdtitle.i "120606.1"}

{cxcustom.i "xxmqc001.P"}

define variable rdate like tr_effdate.
define variable rdate1 like tr_effdate.
define variable part like tr_part.
define variable part1 like tr_part.
DEFINE variable vendor LIKE po_vend .
DEFINE variable vendor1 LIKE po_vend .
DEFINE variable v_counter AS INTEGER.
DEFINE variable choice AS LOGICAL .
DEFINE variable v_yn1 AS LOGICAL .
DEFINE variable receiver LIKE prh_receiver .
DEFINE variable receiver1 LIKE prh_receiver .
DEFINE variable v_file AS CHARACTER.
DEFINE variable v_loc LIKE ld_loc .
DEFINE variable v_status LIKE loc_status .
DEFINE variable v_status1 LIKE loc_status .

DEFINE  TEMP-TABLE tt
   FIELD t1_receiver LIKE prh_receiver
   FIELD t1_line LIKE prh_line
   FIELD t1_rcp_date LIKE tr_date
    FIELD t1_supp LIKE tr_addr
    FIELD t1_part AS CHAR FORMAT "x(14)"
    FIELD t1_rcvd  LIKE tr_qty_chg
    FIELD t1_serial LIKE tr_serial
    FIELD t1_status LIKE xxmqp_status
    FIELD t1_loc LIKE loc_loc
    FIELD t1_site LIKE loc_site
    /* ss - 110104.1 -b */
    INDEX t1_part t1_part t1_receiver t1_line
    /* ss - 110104.1 -e */
    .
/* ss - 100810.1 -b */
DEFINE VAR v_go AS LOGICAL .
/* ss - 100810.1 -e */

rdate = TODAY.
rdate1 =TODAY .

{&ICTRRP02-P-TAG4}
form

   rdate         colon 20
   rdate1        label "To" colon 49 skip
   vendor           colon 20
   vendor1          label "To" colon 49 skip
    receiver        COLON 20
    receiver1      label "To" colon 49 skip
    part           colon 20
    part1          label "To" colon 49 skip

with overlay frame a side-labels.
{&ICTRRP02-P-TAG5}

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

{wbrp01.i}
repeat:

    if rdate = low_date then rdate = TODAY.
    if rdate1 = hi_date then rdate1 = TODAY.
    if vendor1 = hi_char then vendor1 = "".
     if  receiver1  = hi_char then receiver1 = "".
    if part1 = hi_char then part1 = "".

   {&ICTRRP02-P-TAG6}

   if c-application-mode <> 'web' then
   {&ICTRRP02-P-TAG7}
   UPDATE rdate rdate1 vendor vendor1  receiver receiver1  part part1
   with frame a.

   {wbrp06.i &command = update &fields = " rdate rdate1 vendor vendor1
             receiver receiver1  part part1" &frm = "a"}

   {&ICTRRP02-P-TAG8}
   if (c-application-mode <> 'web') or
      (c-application-mode = 'web' and
      (c-web-request begins 'data'))
   then do:

      bcdparm = "".
       {mfquoter.i rdate      }
      {mfquoter.i rdate1     }
      {mfquoter.i vendor        }
      {mfquoter.i vendor1        }
     {mfquoter.i receiver        }
      {mfquoter.i receiver1        }
      {mfquoter.i part        }
      {mfquoter.i part1       }


      {&ICTRRP02-P-TAG12}
      if rdate = ? then rdate = TODAY.
      if rdate1 = ? then rdate1 = TODAY.
      if vendor1 = "" then vendor1 = hi_char.
      if receiver1 = "" then receiver1 = hi_char.
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

  /* ss - 100810.1 -b */
  v_go = NO .
  /* ss - 100810.1 -e */

  for each  prh_hist NO-LOCK USE-INDEX prh_rcp_date  WHERE   (prh_rcp_date >= rdate AND prh_rcp_date <= rdate1)
                   AND (prh_receiver >= receiver AND prh_receiver <= receiver1 ) AND (prh_vend >= vendor AND prh_vend <= vendor1)
                    AND (prh_part >= part AND prh_part <= part1)  /* ss - 100922.1 -b  AND prh__chr01 = "" ss - 100922.1 -e */    AND prh_rcvd <> 0 ,
      EACH tr_hist  NO-LOCK use-index tr_nbr_eff WHERE  tr_type = "rct-po" AND tr_nbr = prh_nbr AND  tr_lot = prh_receiver AND tr_line = prh_line AND tr_qty_loc <> 0
      BREAK BY prh_receiver :


     /*
    FOR EACH     tr_hist WHERE    (tr_type = "rct-po")  AND (tr_effdate >= rdate and tr_effdate <= rdate1)
       AND (tr_addr >= vendor AND tr_addr <= vendor1)
      AND (tr_lot >= receiver AND tr_lot <= receiver1)
       AND (tr_part >= part and tr_part <= part1)
      use-index tr_eff_trnbr
   no-lock break  by tr_effdate by tr_addr by tr_part:
   */



      FIND FIRST xxmqp_det WHERE  xxmqp_receiver = tr_lot AND xxmqp_line = tr_line  NO-LOCK NO-ERROR .
      IF NOT AVAILABLE  xxmqp_det THEN DO:

           FIND FIRST tt WHERE t1_receiver = tr_lot AND t1_line = tr_line  NO-LOCK NO-ERROR .
               IF NOT  AVAILABLE tt THEN DO:
                   CREATE tt .
                   ASSIGN
                       t1_rcp_date = tr_effdate
                       t1_supp = tr_addr
                       t1_part = tr_part
                       t1_serial = tr_serial
                       t1_rcvd = tr_qty_loc
                       t1_receiver = tr_lot
                       t1_line = tr_line
                     /*  t1_status = "" */
                       t1_loc = tr_loc
                       t1_site = tr_site
                       .
                   IF tr_addr  BEGINS "c"  THEN
                       t1_status = ""  .
                   ELSE
                       t1_status = "1" .
               END.

      END.  /* not available xxmqp_det */
      ELSE DO:
                FIND FIRST tt WHERE t1_receiver = tr_lot AND
                           t1_line = tr_line NO-LOCK NO-ERROR.
                   IF NOT  AVAILABLE tt THEN DO:
                       CREATE tt .
                       ASSIGN
                               t1_rcp_date = tr_effdate
                               t1_supp = tr_addr
                               t1_part = tr_part
                               t1_serial = tr_serial
                               t1_rcvd = tr_qty_loc
                               t1_receiver = tr_lot
                               t1_line = tr_line
                               t1_status = xxmqp_status
                               t1_loc = tr_loc
                               t1_site = tr_site
                               .

                  END.

      END.  /* available xxmqp_det */



   END.
   /* ss - 091012.1 -b */

    /* ss - 100810.1 -b */
  IF   v_go  THEN DO:
  UNDO , RETRY .
  END .
/*   ss - 100810.1 -e */

   v_counter = 0 .
   for each tt :
       v_counter = v_counter + 1 .
   end.

   if v_counter = 0  then  do:
       message "无符合条件的数据." .
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
          /* ss - 110104.1 -b
           vv_recid       = ? .
           ss - 110104.1 -e */

           vv_first_recid = ? .
           v_framesize    = 17 .




           define frame zzz1.
           form
               t1_receiver COLUMN-LABEL "收货单"
               t1_line     COLUMN-LABEL "项次"
               t1_part     column-label "零件"
               t1_serial   column-label "批号"
               t1_rcp_date column-label "收货日期"
               t1_rcvd     column-label "数量"
               t1_status   column-label "状态"
           with frame zzz1 width 80 v_framesize down
           title color normal  "检验判断".

           scroll_loop:
           do with frame zzz1:
               /* ss - 110104.1 -b
               {xxsoivpst003.i
                   &domain       = "true and "
                   &buffer       = tt
                   &scroll-field = t1_receiver
                   &searchkey    = "true"
                   &framename    = "zzz1"
                   &framesize    = v_framesize
                   &display1     = t1_receiver
                   &display2     = t1_line
                   &display3     = t1_part
                   &display4    = t1_serial
                    &display5     = t1_rcp_date
                    &display6     = t1_rcvd
                    &display7     = t1_status
                   &exitlabel    = scroll_loop
                    &exit-flag    = "true"
                    &record-id    = vv_recid
                    &first-recid  = vv_first_recid
                    &logical1     = true
            }
            ss - 110104.1 -e */
               /* ss - 110104.1 -b */
               {xxsoivpst003.i
                   &domain       = "true and "
                   &buffer       = tt
                   &scroll-field = t1_part
                   &searchkey    = "true"
                   &framename    = "zzz1"
                   &framesize    = v_framesize
                   &display1     = t1_receiver
                   &display2     = t1_line
                   &display3     = t1_part
                   &display4    = t1_serial
                    &display5     = t1_rcp_date
                    &display6     = t1_rcvd
                    &display7     = t1_status
                   &exitlabel    = scroll_loop
                    &exit-flag    = "true"
                    &record-id    = vv_recid
                    &first-recid  = vv_first_recid
                    &logical1     = true
            }
               /* ss - 110104.1 -e */


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
             message "请输入批核结果1 检验合格  2 不合格   空 为未检验" .
                update t1_status with frame zzz1 .


            end.

        end.
        /*****不带星号的frame - end********/

END. /*sw_block:*/

   /* ss - 091012.1 -e */

/* 更新*/
FOR EACH tt WHERE t1_status <> ""  NO-LOCK:
    FIND FIRST xxmqp_det WHERE  xxmqp_receiver = t1_receiver AND
               xxmqp_line = t1_line  NO-ERROR .
    IF NOT AVAILABLE xxmqp_det THEN DO:
        CREATE xxmqp_det .
            ASSIGN
                xxmqp_receiver = t1_receiver
                xxmqp_line = t1_line
                xxmqp_rcp_date = t1_rcp_date
                xxmqp_date = TODAY
                xxmqp_vend = t1_supp
                xxmqp_part = t1_part
                xxmqp_serial = t1_serial
                xxmqp_status = t1_status
                xxmqp_qty = t1_rcvd
                xxmqp_loc = t1_loc
                .
    END.
    ELSE DO:
        xxmqp_status = t1_status .
    END.
  /* ss - 100922.1 -b
   FIND FIRST prh_hist WHERE  prh_receiver = t1_receiver AND prh_line = t1_line NO-ERROR .
   IF AVAILABLE prh_hist  THEN DO:
       ASSIGN
           prh__chr01 = t1_status
           prh__dte01 = TODAY .
   END.
   ss - 100922.1 -e */

END.
ASSIGN v_file = "xxmqc004.cim." + string(today,"99999999") + string(time).
output to value(v_file + ".in").
FOR EACH tt NO-LOCK:
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
    input from value(v_file + ".in").
    output to value(v_file + ".ou") keep-messages.
    hide message no-pause.
    {gprun.i ""icldmt.p""}
    hide message no-pause.
    output close.
    input close.
    batchrun  = no.

    os-delete value(v_file + ".in").
    os-delete value(v_file + ".ou").
/* 更新*/
 CLEAR frame zzz1 all no-pause .
 HIDE  FRAME zzz1 no-pause .

end.

{wbrp04.i &frame-spec = a}
