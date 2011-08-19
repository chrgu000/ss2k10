define variable vernbr as character format "x(20)".
define variable tcnbr as character format "x(30)".
define variable WMESSAGE as character format "x(40)".
define variable ret-ok as logical initial yes.
define variable procall as logical initial yes.
define variable vtrloc as character.
define variable vtrstat as character.
define variable sstat as character.
define variable vcimfile as character.
define variable part as character format "x(30)".
define variable qtyreq as decimal format "->>>,>>>,>>9".

assign vernbr = "110808.1".
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
  display "[��������n]"   + "*" + TRIM ( wDefSite ) + vernbr  format "x(40)" skip(6) with fram framea1 no-box.

  /* LABEL 4 - END */
  display "�������ϵ��Ż�E�˳�" format "x(40)" skip
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
      assign wmessage = "���ϵ��Ų���Ϊ��!".
      display  skip WMESSAGE NO-LABEL with fram framea1.
      undo ,retry.
  end.
  assign wmessage = "......".

  find first xxwa_det no-lock where "s" + xxwa_nbr = tcnbr no-error.
  if not available xxwa_det then do:
    assign wmessage = "���ϵ�δ�ҵ�!".
    display  skip WMESSAGE NO-LABEL with fram framea1.
    undo,retry.
  end.
  else do:
     find first xxwd_det no-lock where xxwd_nbr = xxwa_nbr
            and xxwd_recid = xxwa_recid and xxwd_sstat <> "C" no-error.
     if not available xxwd_det then do:
         assign wmessage = "���ϵ��ѽ���,��ȷ������!".
         display  skip WMESSAGE NO-LABEL with fram framea1.
         undo,retry.
     end.
  end.
  hide all.
  hide frame framea1.


  display "[��������n]"   + "*" + TRIM ( wDefSite ) + vernbr  format "x(40)" skip(2) with fram framea2 no-box.

  display "���ϵ�:" + trim(tcnbr) format "x(40)"  skip with frame framea2 no-box.
  /* LABEL 4 - END */
  display "ȫ������?" format "x(40)" skip skip with fram framea2 no-box.

  update procall no-label with frame framea2 no-box.
  if procall then do:
     assign vcimfile = "xspkis.p" + string(today,"999999") + string(time).
     output to value(vcimfile + ".i").
     for each xxwa_det no-lock where "s" + xxwa_nbr = tcnbr:
         for each xxwd_det no-lock where xxwd_nbr = xxwa_nbr
             and xxwd_recid = xxwa_recid
             and min((xxwd_qty_plan - xxwd_qty_siss) , xxwd_qty_piss) > 0
             and xxwd_sstat <> "C":
            run getTrLoc(input xxwd_part,output vtrloc,output vtrstat).
            find first loc_mstr no-lock where loc_site = wdefsite and
                       loc_loc = xxwd_loc no-error.
            if available loc_mstr then do:
               assign sstat = loc_stat.
            end.
            put unformat '"' xxwd_part '"' skip.
            put unformat truncate(min((xxwd_qty_plan - xxwd_qty_siss) , xxwd_qty_piss) , 0) " - ".
            put unformat '"s' xxwd_nbr + "," + string(xxwd_recid) '" "' xxwd_line '"' skip.
            put unformat '"-" "-" "-" "-"' skip.
            put unformat '- "' vtrloc '" "' xxwd_lot '"' skip.
            put unformat '- "' xxwd_line '"' skip.
            if vtrstat <> sstat then do:
              put unformat "yes" skip.
            end.
            put unformat "yes" skip.
            put unformat "." skip.
         end.
     end.
     output close.

      batchrun  = yes.
      input from value(vcimfile + ".i").
      output to value(vcimfile + ".o") keep-messages.
      hide message no-pause.
      {gprun.i ""iclotr04.p""}
      hide message no-pause.
      output close.
      input close.
      batchrun  = no.

/*    if not getsaveLogstat() then do:                              */
/*       os-delete value(vcimfile + ".i") no-error.                 */
/*       os-delete value(vcimfile + ".o") no-error.                 */
/*    end.                                                          */

    for each xxwa_det no-lock where "s" + xxwa_nbr = tcnbr:
         for each xxwd_det exclusive-lock where xxwd_nbr = xxwa_nbr
             and xxwd_recid = xxwa_recid:
             for each tr_hist no-lock where
                      tr_nbr = 's' + xxwd_nbr + "," + string(xxwd_recid)
                  and tr_part = xxwd_part and tr_type = "rct-tr":
                  accum tr_qty_loc(total).
             end.
             assign xxwd_qty_piss = accum total tr_qty_loc.
             if xxwd_qty_plan - xxwd_qty_piss = 0 then assign xxwd_sstat = "C".
         end.
     end.
  end.
  else do: /* if procall then do:*/
      hide all.
      hide frame framea1.
      hide frame framea2.
      repeat:   /*�Ϻ�/���*/
      display "[��������n]"   + "*" + TRIM ( wDefSite ) + vernbr  format "x(40)" skip(5) with fram framep no-box.
      display "���ϵ�:" + trim(tcnbr) format "x(40)"  skip with frame framep no-box.
      display "�Ϻ�/��λ�E�˳�" format "x(40)" skip with frame framep no-box.
      update part no-label with frame framep no-box.
      if part = "E" then leave.
      find first xxwd_det no-lock where "s" + xxwd_nbr = trim(tcnbr) and
                (xxwd_part = part or trim(string(xxwd_recid)) = part) no-error.
      if available xxwd_det then do:
         assign recno = recid(xxwd_det).
         assign part = xxwd_part.
      end.
      else do:
        assign wmessage = "�ϺŻ����δ�ҵ�!".
        display  skip WMESSAGE NO-LABEL with fram framep no-box.
        undo,retry.
      end.
      repeat: /*����*/
        hide all.
        hide frame framea1.
        hide frame framea2.
        hide frame framep.
        display "[��������n]"   + "*" + TRIM ( wDefSite ) + vernbr  format "x(40)" skip(4) with fram frameq no-box.
        display "���ϵ�:" + trim(tcnbr) format "x(40)"  skip with frame frameq no-box.
        display "�Ϻ�:" + part format "x(40)" skip with frame frameq no-box.
        display "�ƻ���:" + string(truncate(min((xxwd_qty_plan - xxwd_qty_siss) , xxwd_qty_piss) , 0)) format "x(40)" skip with frame frameq no-box.
        display "����:"  skip with frame frameq no-box.
        update qtyreq no-label with frame frameq no-box.
        if qtyreq > truncate(min((xxwd_qty_plan - xxwd_qty_siss) , xxwd_qty_piss) , 0) then do:
           assign ret-ok = no.
            hide frame frameq.
            display "[��������n]"   + "*" + TRIM ( wDefSite ) + vernbr  format "x(40)" skip(3) with fram framer no-box.
            display "���ϵ�:" + trim(tcnbr) format "x(40)"  skip with frame framer no-box.
            display "�Ϻ�:" + part format "x(40)" skip with frame framer no-box.
            display "�ƻ���:" + string(truncate(min(xxwd_qty_plan - xxwd_qty_siss ,xxwd_qty_piss) , 0 )) format "x(40)" skip with frame framer no-box.
            display "����:" + string(qtyreq) format "x(40)"  skip with frame framer no-box.
            assign wmessage = "���������ڼƻ���!�������˳�.".
            display  skip WMESSAGE NO-LABEL skip with fram framer no-box.
            update ret-ok no-label with frame framer.
            if not ret-ok then do:
               undo,retry.
            end.
        end.
        leave.
      end.  /* repeate ����*/

     assign vcimfile = "xspktr.p" + string(today,"999999") + string(time).
     output to value(vcimfile + ".i").
     for each xxwa_det no-lock where "s" + xxwa_nbr = tcnbr:
         for each xxwd_det no-lock where xxwd_nbr = xxwa_nbr
             and xxwd_recid = xxwa_recid and xxwd_qty_plan > xxwd_qty_piss
             and xxwd_sstat <> "C" and xxwd_part = part:
            find first loc_mstr no-lock where loc_site = wdefsite and
                       loc_loc = xxwd_loc no-error.
            if available loc_mstr then do:
               assign sstat = loc_stat.
            end.
            put unformat '"' xxwd_part '"' skip.
            put unformat truncate(min((xxwd_qty_plan - xxwd_qty_siss) , xxwd_qty_piss),0) " - ".
            put unformat '"p' xxwd_nbr + "," + string(xxwd_recid) '" "' xxwd_line '"' skip.
            put unformat '"-" "-" "-" "-"' skip.
            put unformat '- "' vtrloc '" "' xxwd_lot '"' skip.
            put unformat '- "' xxwd_line '"' skip.
            if vtrstat <> sstat then do:
              put unformat "yes" skip.
            end.
            put unformat "yes" skip.
            put unformat "." skip.
         end.
     end.
     output close.

      batchrun  = yes.
      input from value(vcimfile + ".i").
      output to value(vcimfile + ".o") keep-messages.
      hide message no-pause.
      {gprun.i ""iclotr04.p""}
      hide message no-pause.
      output close.
      input close.
      batchrun  = no.

    for each xxwa_det no-lock where "s" + xxwa_nbr = tcnbr:
         for each xxwd_det exclusive-lock where xxwd_nbr = xxwa_nbr
             and xxwd_recid = xxwa_recid and xxwd_part = part:
             for each tr_hist no-lock where
                      tr_nbr = 's' + xxwd_nbr + "," + string(xxwd_recid)
                  and tr_part = xxwd_part and tr_type = "rct-tr":
                  accum tr_qty_loc(total).
             end.
             assign xxwd_qty_piss = accum total tr_qty_loc.
             if xxwd_qty_plan - xxwd_qty_piss <= 0 then assign xxwd_sstat = "C".
         end.
     end.
      end. /* repeat:   �Ϻ�/���*/
  end. /*  if procall else do: */
  hide all.
  hide frame framea1.
  hide frame framea2.

  assign ret-ok = no.
  display "[��������n]"   + "*" + TRIM ( wDefSite ) + vernbr  format "x(40)" skip(6) with fram framea3 no-box.
  display "�������˳�?"     format "x(40)"
    skip with fram framea3 no-box.
  update ret-ok no-label with frame framea3 no-box.
    display  skip WMESSAGE NO-LABEL with fram framea3.
  if not ret-ok then do:
     leave.
  end.

end.

