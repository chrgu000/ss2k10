define variable vernbr as character format "x(20)".
define variable tgnbr as character format "x(30)" no-undo.
define variable WMESSAGE as character format "x(40)".
define variable ret-ok as logical initial yes.
define variable vqty as character format "X(30)" no-undo.
define variable vldqty as decimal.
define variable vtrloc as character.
define variable vtrstat as character.
define variable sstat as character.
define variable vcimfile as character.
define variable part as character format "x(30)".
define variable qtyreq as decimal format "->>>,>>>,>>9".
define variable i as integer.
define variable j as integer.
define variable vtitle as character.
assign vtitle = "[盘点录入]" .
assign vernbr = "927".
/* {mfdtitle.i vernbr} */
{mfdeclre.i}
{xsdfsite.i}
define variable wtimeout as integer init 99999 .
find first code_mstr where code_fldname = "BARCODE" AND CODE_value ="wtimeout" no-lock no-error. /*  Timeout - All Level */
if AVAILABLE(code_mstr) Then wtimeout = 60 * decimal(code_cmmt).
find first code_mstr where code_fldname = "BARCODE" AND CODE_value ="xssoi11wtimeout" no-lock no-error. /*  Timeout - Program Level */
if AVAILABLE(code_mstr) Then wtimeout = 60 * decimal(code_cmmt).

MAINLOOP:
repeat:
    hide all.
     /* START  LINE :1002  地点[SITE]  */
     V1002L:
     REPEAT:

        /* --DEFINE VARIABLE -- START */
        hide all.
        define variable V1002           as char format "x(50)".
        define variable PV1002          as char format "x(50)".
        define variable L10021          as char format "x(40)".
        define variable L10022          as char format "x(40)".
        define variable L10023          as char format "x(40)".
        define variable L10024          as char format "x(40)".
        define variable L10025          as char format "x(40)".
        define variable L10026          as char format "x(40)".
        /* --DEFINE VARIABLE -- END */


        /* --FIRST TIME DEFAULT  VALUE -- START  */
        V1002 = wDefSite.
        V1002 = ENTRY(1,V1002,"@").
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V1002 = ENTRY(1,V1002,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        IF aPASS = "Y" then
        leave V1002L.
        /* LOGICAL SKIP END */
                display vtitle + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1002 no-box.

                /* LABEL 1 - START */
                L10021 = "地点设定有误" .
                display L10021          format "x(40)" skip with fram F1002 no-box.
                /* LABEL 1 - END */


                /* LABEL 2 - START */
                L10022 = "1.没有设定默认地点" .
                display L10022          format "x(40)" skip with fram F1002 no-box.
                /* LABEL 2 - END */


                /* LABEL 3 - START */
                L10023 = "2.权限设定有误" .
                display L10023          format "x(40)" skip with fram F1002 no-box.
                /* LABEL 3 - END */


                /* LABEL 4 - START */
                L10024 = "  请查核" .
                display L10024          format "x(40)" skip with fram F1002 no-box.
                /* LABEL 4 - END */
                display "输入或按E退出"       format "x(40)" skip
        skip with fram F1002 no-box.
        Update V1002
        WITH  fram F1002 NO-LABEL
        EDITING:
          readkey pause wtimeout.
          if lastkey = -1 Then quit.
        if LASTKEY = 404 Then Do: /* DISABLE F4 */
           pause 0 before-hide.
           undo, retry.
        end.
           apply lastkey.
        end.

        /* PRESS e EXIST CYCLE */
        IF V1002 = "e" THEN  LEAVE MAINLOOP.
        display  skip WMESSAGE NO-LABEL with fram F1002.

         /*  ---- Valid Check ---- START */

        display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F1002.
        pause 0.
        /* CHECK FOR NUMBER VARIABLE START  */
        /* CHECK FOR NUMBER VARIABLE  END */
        IF not trim(V1002) = "E" THEN DO:
                display skip "Error , Retry " @ WMESSAGE NO-LABEL with fram F1002.
                pause 0 before-hide.
                undo, retry.
        end.
         /*  ---- Valid Check ---- END */

        display  "" @ WMESSAGE NO-LABEL with fram F1002.
        pause 0.
        leave V1002L.
     END.
     PV1002 = V1002.
tagloop:
repeat:
     /* END    LINE :1002  地点[SITE]  */
    hide all.
    hide frame f1002.
    hide frame framead.
  hide all.
  assign tgnbr = "".
  display vtitle  + "*" + TRIM ( wDefSite ) + vernbr  format "x(40)" skip(6) with fram framea1 no-box.

  /* LABEL 4 - END */
  display "输入单号或按E退出"       format "x(40)" skip
  skip with fram framea1 no-box.

  UPDATE tgnbr WITH  fram framea1 NO-LABEL EDITING:
  display  skip WMESSAGE NO-LABEL with fram framea1.
  readkey pause wtimeout.
  if lastkey = -1 then quit.
  if LASTKEY = 404 Then Do: /* DISABLE F4 */
     pause 0 before-hide.
     undo, retry.
  end.
       apply lastkey.
  end.
  IF tgnbr = "e" THEN  LEAVE MainLoop.
  if tgnbr = "" then do:
      assign wmessage = "单号不可为空!".
      display  skip WMESSAGE NO-LABEL with fram framea1.
      readkey pause wtimeout.
      undo,retry.
  end.
  DO i = 1 to length(tgnbr):
     If index("0987654321,", substring(tgnbr,i,1)) = 0 then do:
        assign wmessage = "卡号输入错误.".
        display  skip WMESSAGE NO-LABEL with fram framea1.
        readkey pause wtimeout.
        undo,retry.
     end.
  end.
  find first tag_mstr where tag_site = wDefSite
         and tag_nbr = integer(tgnbr)
         and not tag_void and not tag_posted NO-ERROR .
      IF NOT AVAILABLE tag_mstr then do:
     wmessage = "该盘点卡号已更新或作废".
    display  WMESSAGE NO-LABEL with fram framea1.
    readkey pause wtimeout.
    undo,retry.
  end.
  hide all.
  hide frame framea1.

  display vtitle  + "*" + TRIM ( wDefSite ) + vernbr  format "x(40)" skip with fram framea2 no-box.
  if available tag_mstr then do:
     display "盘点卡号:" + trim(tgnbr) format "x(20)" skip with frame framea2 no-box.
     display "图号:"  + trim(tag_part) format "x(20)" skip with frame framea2 no-box.
     find first pt_mstr no-lock where pt_part = tag_part no-error.
     if available pt_mstr then do:
        display "描述1:" + trim(pt_desc1) format "x(20)" skip with frame framea2 no-box.
     end.
     display "库位:" + trim(tag_loc) format "x(20)" skip with frame framea2 no-box.
     display "批号:" + trim(tag_serial) format "x(20)" skip with frame framea2 no-box.
     assign vldqty = 0
            vqty = "".
     find first ld_det no-lock where ld_site = wDefSite and ld_loc = tag_loc
            and ld_part = tag_part and ld_lot = tag_serial no-error.
     if available ld_det then do:
        assign vldqty = ld_qty_oh
               /* vqty = trim(string(ld_qty_oh)) when */ vqty = "".
     end.
     display skip(1) "盘点数量?" format "x(20)" skip with frame framea2 no-box.
  end.
  qtyloop:
  repeat:
  hide frame frameac.
  hide frame framead.
  update vqty view-as fill-in size 20 by 1 no-label with frame framea2 no-box.
  if upper(vqty) = "E" then do:
     assign WMESSAGE = "".
     leave tagloop.
  end.
  else do:
       DO i = 1 to length(vqty).
          If index("0987654321,", substring(vqty,i,1)) = 0 then do:
             display "项次输入错误." @ wmessage no-label with frame frameac.
             undo,retry.
          end.
       end.
  end.
  ret-ok = no.
  find first code_mstr no-lock where code_fldname = "BarcodeContConfirm"
         and substring(code_value,1,1) = "Y" no-error.
  if available code_mstr then do:
     assign ret-ok = yes.
  end.
  hide all.
  if decimal(vqty) <> vldqty and ret-ok = no then do:
     display vtitle + "*" + TRIM ( V1002 )  format "x(40)" skip with fram framead no-box.
     display "库存数:" + trim(string(vldqty)) format "x(20)" skip with frame framead.
     display "盘点数:" + trim(vqty) format "x(20)" skip with frame framead.

     display skip(2) "确认更新?" skip with frame framead.
     update ret-ok no-label with frame framead no-box.
     if not ret-ok then do:
        undo, retry.
     end.
  end.
  leave qtyloop.
  end. /* qtyloop:*/

  if ret-ok then do:
     {xspitcmt.i}
  end.

  find first tag_mstr where tag_site = wDefSite
         and tag_nbr = integer(tgnbr) no-error.
  if available tag_mstr and tag_cnt_qty = integer(vqty) then do:
       WMESSAGE = "单号" + trim(tgnbr) + "数量" + trim(vqty) + "-OK!".
       tgnbr = "".
  end.
  else do:
       WMESSAGE = "单号" + trim(tgnbr) + "数量" + trim(vqty) + "-失败!".
  end.
  leave tagloop.
end.
  hide all.
  hide frame framea1.
  hide frame framea2.
  hide frame frameac.
  hide frame framead.

end.
