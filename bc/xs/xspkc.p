define variable vernbr as character format "x(20)".
define variable tcnbr as character format "x(30)".
define variable WMESSAGE as character format "x(40)".
define variable ret-ok as logical initial yes.
define variable vitem as character.
define variable vtrloc as character.
define variable vtrstat as character.
define variable sstat as character.
define variable vcimfile as character.
define variable part as character format "x(30)".
define variable qtyreq as decimal format "->>>,>>>,>>9".

assign vernbr = "110808.2".
{mfdtitle.i vernbr}
{xsdfsite.i}
{xspkpub.i}
define variable wtimeout as integer init 99999 .
find first code_mstr where code_fldname = "BARCODE" AND CODE_value ="wtimeout" no-lock no-error. /*  Timeout - All Level */
if AVAILABLE(code_mstr) Then wtimeout = 60 * decimal(code_cmmt).
find first code_mstr where code_fldname = "BARCODE" AND CODE_value ="xssoi11wtimeout" no-lock no-error. /*  Timeout - Program Level */
if AVAILABLE(code_mstr) Then wtimeout = 60 * decimal(code_cmmt).

repeat:
  hide all.
  assign tcnbr = "".
  display "[取/送料单关闭]"   + "*" + TRIM ( wDefSite ) + vernbr  format "x(40)" skip(6) with fram framea1 no-box.

  /* LABEL 4 - END */
  display "输入单号或按E退出"       format "x(40)" skip
  skip with fram framea1 no-box.

  UPDATE tcnbr WITH  fram framea1 NO-LABEL EDITING:
  readkey pause wtimeout.
  if lastkey = -1 then quit.
  if LASTKEY = 404 Then Do: /* DISABLE F4 */
     pause 0 before-hide.
     undo, retry.
  end.
       apply lastkey.
  end.
  IF tcnbr = "e" THEN  LEAVE.
  if tcnbr = "" then do:
      assign wmessage = "单号不可为空!".
      display  skip WMESSAGE NO-LABEL with fram framea1.
      undo ,retry.
  end.
  assign wmessage = "......".

  find first xxwa_det no-lock where xxwa_nbr = substring(tcnbr,2) no-error.
  if not available xxwa_det then do:
    assign wmessage = "取/送料单未找到!".
    display  skip WMESSAGE NO-LABEL with fram framea1.
    undo,retry.
  end.
  hide all.
  hide frame framea1.

  display "[取/送料单关闭]"   + "*" + TRIM ( wDefSite ) + vernbr  format "x(40)" skip(2) with fram framea2 no-box.

  display "单号:" + trim(tcnbr) format "x(40)"  skip with frame framea2 no-box.
  /* LABEL 4 - END */
  display "项次/A(全部)/E退出" format "x(40)" skip skip with fram framea2 no-box.

  update vitem no-label with frame framea2 no-box.
  if vitem = "E" then do:
     leave.
  end.
  else if vitem = "A" then do: /* 关闭全部 */
      hide frame frameac.
      hide all.
      assign ret-ok = no.
      display "[取/送料单关闭]" + "*" + TRIM ( wDefSite ) + vernbr  format "x(40)" skip(4) with fram frameac no-box.
      display "单号:" + trim(tcnbr) format "x(40)"  skip with fram frameac no-box.
      display "全部关闭"  format "x(40)"  skip with fram frameac no-box.
      display "继续或退出?" format "x(40)" skip with fram frameac no-box.
      update ret-ok no-label with frame frameac no-box.
      display  skip WMESSAGE NO-LABEL with fram frameac.
      if not ret-ok then do:
         leave.
      end.

     for each xxwa_det exclusive-lock where xxwa_nbr = substring(tcnbr,2):
		     if substring(tcnbr,1,1) = "p" then do:
		     	  assign xxwa_pstat = "C".
		   	 end.
		   	 else do:
		   	 	  assign xxwa_sstat = "C".
		   	 end.
         for each xxwd_det exclusive-lock where xxwd_nbr = xxwa_nbr and
                  xxwd_recid = xxwa_recid:
              if substring(tcnbr,1,1) = "p" then do:
                 assign xxwd_pstat = "C".
              end.
              else do:
                  assign xxwd_sstat = "C".
              end.
         end.
     end.
  end.
  else do:
     for each xxwa_det no-lock where xxwa_nbr = substring(tcnbr,2):
         hide frame frameac.
         hide all.
         if not can-find(first xxwd_det no-lock where xxwd_nbr = xxwa_nbr and
            xxwd_recid = xxwa_recid and trim(vitem) <> string(xxwa_sn)) then do:
              hide frame frameac.
              assign ret-ok = no.
              display "[取/送料单关闭]" + "*" + TRIM ( wDefSite ) + vernbr  format "x(40)" skip(4) with fram frameae no-box.
              display "单号:" + trim(tcnbr) format "x(40)"  skip with fram frameae no-box.
              display "项次:" + trim(vitem) + "未找到" format "x(40)"  skip with fram frameae no-box.
              display "退出?" format "x(40)" skip with fram frameae no-box.
              update ret-ok no-label with frame frameae no-box.
              display  skip WMESSAGE NO-LABEL with fram frameae.
              if ret-ok then do:
                 leave.
              end.
         end.
         else do:
              hide all.
              hide frame frameac.
              hide frame framea1.
              hide frame frameae.
              find first xxwd_det no-lock where xxwd_nbr = xxwa_nbr and
                         xxwd_recid = xxwa_recid and
                         trim(vitem) <> string(xxwa_sn) no-error.
              assign ret-ok = yes.
              display "[取/送料单关闭]" + "*" + TRIM ( wDefSite ) + vernbr  format "x(40)" skip(4) with fram frameaf no-box.
              display "单号:" + trim(tcnbr) format "x(40)"  skip with fram frameaf no-box.
              display "项次:" + trim(vitem) format "x(40)"  skip with fram frameaf no-box.
              if substring(vitem,1,1) = "P" then do:
                   display "状态:" + trim(xxwd_pstat) format "x(40)"  skip with fram frameaf no-box.
               end.
               else do:
                   display "状态:" + trim(xxwd_sstat) format "x(40)"  skip with fram frameaf no-box.
               end.
              display "关闭?" format "x(40)" skip with fram frameaf no-box.
              update ret-ok no-label with frame frameaf no-box.
              display skip WMESSAGE NO-LABEL with fram frameaf.
              if not ret-ok then do:
                 leave.
              end.
              find first xxwd_det exclusive-lock where xxwd_nbr = xxwa_nbr and
                         xxwd_recid = xxwa_recid and trim(vitem) <> string(xxwa_sn) no-error.
              if available xxwd_det then do:
                 if substring(vitem,1,1) = "P" then do:
                    assign xxwd_pstat = "C".
                 end.
                 else do:
                    assign xxwd_sstat = "C".
                 end.
              end.

         end.
     end.
  end.
  hide all.
  hide frame framea1.
  hide frame framea2.

  assign ret-ok = no.
  display "[取/送料单关闭]" + "*" + TRIM ( wDefSite ) + vernbr  format "x(40)" skip(6) with fram framea3 no-box.
  display "继续或退出?"     format "x(40)"
    skip with fram framea3 no-box.
  update ret-ok no-label with frame framea3 no-box.
    display  skip WMESSAGE NO-LABEL with fram framea3.
  if not ret-ok then do:
     leave.
  end.

end.
