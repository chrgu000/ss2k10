define variable vernbr as character format "x(20)".
define variable tcnbr as character format "x(30)".
define variable WMESSAGE as character format "x(40)".
define variable ret-ok as logical initial yes.
define variable procall as logical initial yes.
define variable vtrloc as character initial "P-ALL".
define variable vtrstat as character.
define variable sstat as character no-undo.
define variable vcimfile as character.
define variable part as character format "x(30)".
define variable qtyreq as decimal format "->>>,>>>,>>9".
define variable qtytemp as decimal format "->>>,>>>,>>9".
define variable trrecid as recid.

assign vernbr = ".620".
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
  display "[����ȡ��n]"   + "*" + TRIM ( wDefSite ) + vernbr  format "x(40)" skip(6) with fram framea1 no-box.

  /* LABEL 4 - END */
  display "����ȡ�ϵ��Ż�E�˳�"       format "x(40)" skip
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
      assign wmessage = "ȡ�ϵ��Ų���Ϊ��!".
      display  skip WMESSAGE NO-LABEL with fram framea1.
      undo ,retry.
  end.
  assign wmessage = "......".

  find first xxwd_det no-lock where xxwd_type = "P" and xxwd_type + xxwd_nbr = tcnbr no-error.
  if not available xxwd_det then do:
    assign wmessage = "ȡ�ϵ�δ�ҵ�!".
    display  skip WMESSAGE NO-LABEL with fram framea1.
    undo,retry.
  end.
  else do:
     find first xxwd_det no-lock where  xxwd_type = "P" and xxwd_type + xxwd_nbr = tcnbr
            and xxwd_stat <> "C" no-error.
     if not available xxwd_det then do:
        assign wmessage = "ȡ�ϵ��ѽ���,��ȷ������!".
         display  skip WMESSAGE NO-LABEL with fram framea1.
         undo,retry.
     end.
  end.
  hide all.
  hide frame framea1.

  display "[����ȡ��n]"   + "*" + TRIM ( wDefSite ) + vernbr  format "x(40)" skip(2) with fram framea2 no-box.

  display "ȡ�ϵ�:" + trim(tcnbr) format "x(40)"  skip with frame framea2 no-box.
  /* LABEL 4 - END */
  display "����ȫ��?" format "x(40)" skip skip with fram framea2 no-box.
  update procall no-label with frame framea2 no-box.
  if procall then do:
     assign vcimfile = "xspktr.p" + string(today,"999999") + string(time).
     output to value(vcimfile + ".bpi").
         for each xxwd_det no-lock where xxwd_type = "P" and xxwd_type + xxwd_nbr = tcnbr
              and xxwd_qty_plan - xxwd_qty_iss > 0
              and xxwd_stat <> "C" and upper(xxwd_loc) <> "P-All":
            find first loc_mstr no-lock where loc_site = wdefsite and
                       loc_loc = xxwd_loc no-error.
            if available loc_mstr then do:
               assign sstat = loc_stat.
            end.
            find first ld_det no-lock where ld_site = wdefsite and ld_loc = xxwd_loc
                 and ld_part = xxwd_part and ld_lot = xxwd_lot no-error.
            if available ld_det then do:
               assign qtytemp = min(ld_qty_oh, truncate(xxwd_qty_plan - xxwd_qty_iss,0)).
            end.
            else do:
               next.
            end.
            put unformat '"' xxwd_part '"' skip.
            put unformat qtytemp " - ".
            put unformat '"p' xxwd_nbr '" "' trim(string(xxwd_sn,">>>>>>>>>>9")) '"' skip.
            put unformat '"-" "-" "-" "-"' skip.
            put unformat '- "' xxwd_loc '" "' xxwd_lot '"' skip.
            put unformat '- "' vtrloc '" -' skip.
            if vtrstat <> sstat then do:
              put unformat "yes" skip.
            end.
            put unformat "yes" skip.
            put unformat "." skip.
         end.
     output close.
     assign trrecid = current-value(tr_sq01).
    batchrun  = yes.
    input from value(vcimfile + ".bpi").
    output to value(vcimfile + ".bpo") keep-messages.
    hide message no-pause.
    aloop:
    do on stop undo aloop,leave aloop:
          {gprun.i ""iclotr04.p""}
    end.
    hide message no-pause.
    output close.
    input close.
    batchrun  = no.

/*    if not getsaveLogstat() then do:                              */
         os-delete value(vcimfile + ".bpi") no-error.
         os-delete value(vcimfile + ".bpo") no-error.
/*    end.                                                          */
         sstat = "".
         for each xxwd_det exclusive-lock where  xxwd_type = "P" and xxwd_type + xxwd_nbr = tcnbr
              and xxwd_qty_plan - xxwd_qty_iss > 0
              and xxwd_stat <> "C" and upper(xxwd_loc) <> "P-All":
              qtytemp = 0.
             for each tr_hist use-index tr_part_trn no-lock where
                      tr_part = xxwd_part and
                      tr_trnbr > integer(trrecid) and
                      tr_type = "iss-tr" and
                      tr_nbr = xxwd_type + xxwd_nbr and
                      tr_serial = xxwd_lot and
                      tr_so_job = trim(string(xxwd_sn,">>>>>>>>>>9")):
                  qtytemp = qtytemp + tr_qty_loc * -1.
             end.
             assign xxwd_qty_iss = xxwd_qty_iss + qtytemp.
             if xxwd_qty_plan - xxwd_qty_iss <= 0 then assign xxwd_stat = "C".
         end.
         assign WMESSAGE = "�������".
  end.
  else do: /* if procall then do:*/
      hide all.
      hide frame framea1.
      hide frame framea2.
      startsing:
      repeat:   /*�Ϻ�/���*/
      display "[����ȡ��n]"   + "*" + TRIM ( wDefSite ) + vernbr  format "x(40)" skip(5) with fram framep no-box.
      display "ȡ�ϵ�:" + trim(tcnbr) format "x(40)"  skip with frame framep no-box.
      display "�Ϻ�/��λ�E�˳�" format "x(40)" skip with frame framep no-box.
      update part no-label with frame framep no-box.
      if part = "E" then leave.
      find first xxwd_det no-lock where  xxwd_type = "P" and xxwd_type + xxwd_nbr = trim(tcnbr) and
                (xxwd_part = part or trim(string(xxwd_sn)) = part) no-error.
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
        assign sstat = "".
        hide all.
        hide frame framea1.
        hide frame framea2.
        hide frame framep.
        display "[����ȡ��n]"   + "*" + TRIM ( wDefSite ) + vernbr  format "x(40)" skip(4) with fram frameq no-box.
        display "ȡ�ϵ�:" + trim(tcnbr) format "x(40)"  skip with frame frameq no-box.
        display "�Ϻ�:" + part format "x(40)" skip with frame frameq no-box.
        display "�ƻ���:" + string(truncate(xxwd_qty_plan - xxwd_qty_iss,0)) format "x(40)" skip with frame frameq no-box.
        display "����:"  skip with frame frameq no-box.
        update qtyreq no-label with frame frameq no-box.
        if qtyreq > xxwd_qty_plan - xxwd_qty_iss or xxwd_qty_plan <= xxwd_qty_iss then do:
           assign ret-ok = no.
            hide frame frameq.
            display "[����ȡ��n]" + "*" + TRIM ( wDefSite ) + vernbr  format "x(40)" skip(3) with fram framer no-box.
            display "ȡ�ϵ�:" + trim(tcnbr) format "x(40)"  skip with frame framer no-box.
            display "�Ϻ�:" + part format "x(40)" skip with frame framer no-box.
            display "�ƻ���:" + string(truncate(xxwd_qty_plan , 0)) format "x(40)" skip with frame framer no-box.
            display "����:" + string(qtyreq) format "x(40)"  skip with frame framer no-box.
            assign wmessage = "ȡ�������ڼƻ���!�������˳�.".
            display  skip WMESSAGE NO-LABEL skip with fram framer no-box.
            update ret-ok no-label with frame framer.
            if not ret-ok then do:
               assign sstat = "err".
               undo ,leave.
            end.
        end.
        leave.
        assign sstat = "err".
      end.  /* repeate ����*/
      if sstat = "err" then do:
          undo,retry.
      end.
     assign vcimfile = "xspktr.p" + string(today,"999999") + string(time).
     output to value(vcimfile + ".bpi").
         for each xxwd_det exclusive-lock where recid(xxwd_det) = recno:
            assign sstat = "".
            find first loc_mstr no-lock where loc_site = wdefsite and
                       loc_loc = xxwd_loc no-error.
            if available loc_mstr then do:
               assign sstat = loc_stat.
            end.
            put unformat '"' xxwd_part '"' skip.
            put unformat qtyreq " - ".
            put unformat '"p' xxwd_nbr '" "' trim(string(xxwd_sn,">>>>>>>>>>9")) '"' skip.
            put unformat '"-" "-" "-" "-"' skip.
            put unformat '- "' xxwd_loc '" "' xxwd_lot '"' skip.
            put unformat '- "' vtrloc '"' skip.
            if vtrstat <> sstat then do:
              put unformat "yes" skip.
            end.
            put unformat "yes" skip.
            put unformat "." skip.
         end.
     output close.
    assign trrecid = current-value(tr_sq01).
    batchrun  = yes.
    input from value(vcimfile + ".bpi").
    output to value(vcimfile + ".bpo") keep-messages.
    hide message no-pause.
    {gprun.i ""iclotr04.p""}
    hide message no-pause.
    output close.
    input close.
    batchrun  = no.
    os-delete value(vcimfile + ".bpi") no-error.
    os-delete value(vcimfile + ".bpo") no-error.
         assign qtytemp = 0
                sstat = "".
         for each xxwd_det exclusive-lock where recid(xxwd_det) = recno:
             find first tr_hist use-index tr_part_trn no-lock where
                      tr_part = xxwd_part and
                      tr_trnbr > integer(trrecid) and
                      tr_type = "rct-tr" and
                      tr_nbr = xxwd_type + xxwd_nbr and
                      tr_serial = xxwd_lot and
                      tr_so_job = trim(string(xxwd_sn,">>>>>>>>>>9")) no-error.
             if available tr_hist then do:
                assign xxwd_qty_iss = xxwd_qty_iss + tr_qty_loc.
                assign sstat = "OK".
                if xxwd_qty_plan - xxwd_qty_iss <= 0 then assign xxwd_stat = "C".
             end.
         end.
      if sstat = "OK" then
          assign WMESSAGE = "�����ɹ�".
      else
          assign WMESSAGE = "����ʧ��".
      assign part = ""
         qtyreq = 0.
      message wMessage view-as alert-box.

      end. /* repeat:   �Ϻ�/���*/


  end. /*  if procall else do: */
  hide all.
  hide frame framea1.
  hide frame framea2.
  assign ret-ok = no.
  display "[����ȡ��n]"   + "*" + TRIM ( wDefSite ) + vernbr  format "x(40)" skip(6) with fram framea3 no-box.
  assign part = ""
         qtyreq = 0.
  display "�������˳�?"     format "x(40)"
    skip with fram framea3 no-box.
  update ret-ok no-label with frame framea3 no-box.
    display  skip WMESSAGE NO-LABEL with fram framea3.
  if not ret-ok then do:
     leave.
  end.

end.
