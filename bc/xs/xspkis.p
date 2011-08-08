define variable vernbr as character format "x(20)".
define variable tcnbr as character format "x(30)".
define variable vcust like xxtc_cust.
define variable WMESSAGE as character format "x(40)".
define variable ret-ok as logical initial yes.
assign vernbr = "110805.1".
{mfdtitle.i vernbr}
{xsdfsite.i}
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

  find first xxtc_hst no-lock where xxtc_nbr = tcnbr no-error.
  if available xxtc_hst then do:
      if xxtc_stat = "C" or xxtc_cust <> "" then do:
         find first cm_mstr no-lock where cm_addr = xxtc_cust no-error.
         if available cm_mstr then do:
            assign vcust = vcust + xxtc_cust + "-" + cm_sort.
         end.
         else do:
            assign vcust = vcust + tcnbr.
         end.
      end.
      else do:
         assign wmessage = "��̨�ѻ���!".
         display  skip WMESSAGE NO-LABEL with fram framea1.
         undo,retry.
      end.
  end.
  else do:
       assign wmessage = "̨����δ�ҵ�!".
       display  skip WMESSAGE NO-LABEL with fram framea1.
       undo,retry.
  end.
  hide all.
  hide frame framea1.

  display "[̨������n]"   + "*" + TRIM ( wDefSite ) + vernbr  format "x(40)" skip(2) with fram framea2 no-box.

  display "̨��:" + trim(tcnbr) format "x(40)"  skip with frame framea2 no-box.
  display vcust  format "x(40)" no-label with frame framea2 no-box.
  display "����:" + string(today) no-label format "x(40)" skip(2) with frame framea2 no-box.
  /* LABEL 4 - END */
  display "ȷ��Ҫ������?"       format "x(40)" skip
  skip with fram framea2 no-box.

  update ret-ok no-label with frame framea2 no-box.

  if ret-ok then do:
     find first xxtc_hst exclusive-lock where xxtc_nbr = tcnbr no-error.
     if available xxtc_hst then do:
           assign xxtc_cust = ""
                  xxtc_stat = "R"
                  xxtc_date = today
                  xxtc_mod_date = today
                  xxtc_mod_usr = global_userid.
     end.
     assign wmessage = "��̨���ճɹ�!".
  end.
  hide all.
  hide frame framea1.
  hide frame framea2.

  assign ret-ok = no.
  display "[̨������n]"   + "*" + TRIM ( wDefSite ) + vernbr  format "x(40)" skip(6) with fram framea3 no-box.
  display "�������ջ��˳�?"     format "x(40)"
    skip with fram framea3 no-box.
  update ret-ok no-label with frame framea3 no-box.
    display  skip WMESSAGE NO-LABEL with fram framea3.
  if not ret-ok then do:
     leave.
  end.

  /*
  if availabl xxtc_hst and xxtc_cust <> "" then do:
      assign wmessage = "̨��:[" + tcnbr + "]�ڿͻ�:[" + "]������ȷ������.".
     display  skip WMESSAGE NO-LABEL with fram framea1.
    assign tcnbr = "".
    undo , retry.
  end.
  */

end.

