{mfdeclre.i "new global"}
{mf1.i "new global"}
define variable v_i as integer.
session:date-format = 'dmy'.
do on error undo, return error {&GENERAL-APP-EXCEPT}:
      hi_char = chr(1).

      do v_i = 2 to 131071:
         if chr(v_i) > hi_char then hi_char = chr(v_i).
      end. /*DO i = 2 to 131071*/

      assign
         hi_date = 12/31/3999
         low_date = 01/01/1900.
end.
base_curr = "RMB".
IF global_userid = "" THEN global_userid = "MFG".
mfguser="".
global_user_lang = "ch".
global_user_lang_dir = "ch/".
global_domain = "DCEC".
global_db = "DCEC".
execname = "xxivimp.p".

define variable v_key   like usrw_key1 no-undo initial "XXVOIMP-CTRL".
define variable v_pre   like poc_rcv_pre no-undo.
define variable vbank   like ap_bank   no-undo.
define variable vtype   like vo_type   no-undo.
define variable vusr    like vo__qad01 no-undo.
define variable vdirimp as  character  no-undo.
define variable vdirbak as  character  no-undo.
define variable vdirtmp as  character  no-undo.
define variable vdirlog as  character  no-undo.
define variable vdirerr as  character  no-undo.
define stream bf.
define temp-table xf_list
  fields xf_file as character
  fields xf_name as character format "x(78)"
  fields xf_type as character.

define temp-table xiv_m
  fields xiv_receiver like prh_receiver
  fields xiv_line     like prh_line
  fields xiv_part     like prh_part
  fields xiv_qty_ord  like prh_qty_ord
  fields xiv_iv_cost  like sct_cst_tot
  fields xiv_amt      like prh_curr_amt
  fields xiv_inv      like vo_invoice
  fields xiv_inv_amt  like prh_curr_amt
  fields xiv_date     as   date
  fields xiv_po       like po_nbr
  fields xiv_vend     like po_vend
  fields xiv_chk      as   character format "x(60)"
  fields xiv_datec    as   character.

define temp-table xivd_d
  fields xivd_inv like vo_invoice
  fields xivd_po  like po_nbr.

FUNCTION str2Date RETURNS DATE(INPUT datestr AS CHARACTER) forward.

empty temp-table xf_list no-error.

assign v_pre = "RC".
find first poc_ctrl no-lock where poc_domain = global_domain no-error.
if available poc_ctrl then do:
   assign v_pre = poc_rcv_pre.
end.
find first usrw_wkfl no-lock where usrw_domain = global_domain and
           usrw_key1 = v_key and usrw_key2 = v_key no-error.
if available usrw_wkfl then do:
   assign vbank = usrw_key3
          vtype = usrw_key4
          vusr  = usrw_key5
          vdirimp = usrw_charfld[1]
          vdirbak = usrw_charfld[2]
          vdirtmp = usrw_charfld[3]
          vdirlog = usrw_charfld[4]
          vdirerr = usrw_charfld[5].
end.
else do:
     quit.
end.

input from os-dir(vdirimp).
repeat:
  create xf_list.
  import xf_file xf_name xf_type.
end.
input close.

for each xf_list where index(xf_type,"D") > 0 or xf_name = "":
    delete xf_list.
end.

for each xf_list no-lock where:
empty temp-table xiv_m no-error.
empty temp-table xivd_d no-error.
input from value(xf_name).
repeat:
  assign v_key = "".
  import unformat v_key.
/*  if index(entry(1,v_key,"|"),v_pre) > 0 then do: /* 取消收货单必须以RC开头限制 */ */
  if entry(1,v_key,"|") <> "" then do:
     create xiv_m.
     assign xiv_receiver = entry(1,v_key,"|").
            xiv_line     = integer(entry(2,v_key,"|")).
            xiv_part     = entry(3,v_key,"|").
            xiv_qty_ord  = decimal(entry(4,v_key,"|")).
            xiv_iv_cost  = decimal(entry(5,v_key,"|")).
            xiv_amt      = decimal(entry(6,v_key,"|")).
            xiv_inv      = entry(7,v_key,"|").
            xiv_inv_amt  = decimal(entry(8,v_key,"|")).
            xiv_datec    = entry(9,v_key,"|") no-error.
  end.
end.
input close.

for each xiv_m exclusive-lock with width 200:
    if xiv_datec <> "" then assign xiv_date = str2Date(xiv_datec) no-error.
    if xiv_date = ? then assign xiv_date = today.
    find first prh_hist no-lock where prh_domain = global_domain and
               prh_receiver = xiv_receiver and prh_line = xiv_line no-error.
    if available prh_hist then do:
       if prh_part <> xiv_part then do:
          assign xiv_chk = "料号不匹配".
       end.
       assign xiv_vend = prh_vend
              xiv_po = prh_nbr.
    end.
    else do:
         assign xiv_chk = "未找到收货资料".
    end.
    find first vod_det where vod_domain = global_domain and
               vod_ref = xiv_receiver no-lock no-error.
    if available vod_det then do:
       assign xiv_chk = "已存在发票记录".
    END.
end.

if can-find(first xiv_m where xiv_chk <> "") then do:
   output to value(vdirerr + xf_file).
   put unformat "收货单,行,零件,发票数量,发票成本,金额(不含税),发票,发票金额(不含税),日期,结果" skip.
   for each xiv_m no-lock:
       export delimiter ","  xiv_receiver xiv_line xiv_part xiv_qty_ord
                             xiv_iv_cost xiv_amt xiv_inv xiv_inv_amt xiv_date
                             xiv_chk.
   end.
   output close.
   next.
end.
else do:
     OS-COMMAND SILENT VALUE( "move /y " + xf_name + " " + vdirbak).
end.

/*查找PO list*/
for each xiv_m no-lock:
    find first xivd_d no-lock where xivd_inv = xiv_inv
           and xivd_po = xiv_po no-error.
    if not available xivd_d then do:
       create xivd_d.
       assign xivd_inv = xiv_inv
              xivd_po  = xiv_po.
    end.
end.

for each xiv_m no-lock break by xiv_inv BY xiv_receiver BY xiv_line:
    if first-of(xiv_inv) then do:
       output stream bf to value(vdirtmp + xf_file + ".bpi").
       put stream bf unformat "-" skip "-" skip '"' xiv_inv '"' skip.
       for each xivd_d no-lock where xivd_inv = xiv_inv:
           put stream bf unformat '"' xivd_po '"' skip.
       end.
       put stream bf unformat '.' skip.
       put stream bf unformat '-' skip.
       put stream bf unformat '- "' vbank '" "' xiv_inv '" ' xiv_date.
       put stream bf unformat ' - - - - - - - - - - - - - - "' vtype '"' skip.
       put stream bf unformat '-' skip.
       put stream bf unformat 'N' skip. /* 自动选择 */
       put stream bf unformat '-' skip. /* 税 */
   end.
       put stream bf unformat '"' xiv_receiver '" ' xiv_line skip.
       put stream bf unformat '-' skip. /* 税 */
       put stream bf unformat xiv_qty_ord ' ' xiv_iv_cost skip.
       /*
       put stream bf unformat '-' skip. /* 已结项 */
       */
   if last-of(xiv_inv) then do:
      put stream bf unformat '.' skip.
      put stream bf unformat '.' skip.
      put stream bf unformat '.' skip.
   /*     put stream bf unformat 'n' skip. 查看税细节 */
      put stream bf unformat '- N "' vusr '"' skip. /*确认 = NO*/
      put stream bf unformat '.' skip.
      put stream bf unformat '.' skip.
      output stream bf close.
   end.
   if last-of(xiv_inv) then do:

      /* cim_load */
      batchrun = yes.
      input from value(vdirtmp + xf_file + ".bpi").
      output to value(vdirlog + xf_file + ".bpo").
      hide message no-pause.
      cimrunprogramloop:
      DO TRANSACTION on stop undo cimrunprogramloop,leave cimrunprogramloop:
         {gprun.i ""xxapvomt.p""}
      end.
      hide message no-pause.
      output close.
      input close.
      batchrun = no.
      find ap_mstr NO-LOCK where ap_mstr.ap_domain = global_domain and
                  ap_type = "vo" and
                  ap_ref = xiv_inv NO-ERROR.
      IF AVAILABLE ap_mstr THEN DO:
           OS-COMMAND SILENT VALUE( "move /y " + xf_name + " " + vdirbak).
      END.
   end.
end.


end. /* for each xf_list no-lock where : */

/* 日期YYYY-MM-DD转换为QAD日期格式 */
FUNCTION str2Date RETURNS DATE(INPUT datestr AS CHARACTER):
    DEFINE VARIABLE sstr AS CHARACTER NO-UNDO.
    DEFINE VARIABLE iY   AS INTEGER   NO-UNDO.
    DEFINE VARIABLE iM   AS INTEGER   NO-UNDO.
    DEFINE VARIABLE id   AS INTEGER   NO-UNDO.
    DEFINE VARIABLE od   AS DATE      NO-UNDO.
    if datestr = "" then do:
        assign od = ?.
    end.
    else do:
        ASSIGN sstr = datestr.
        ASSIGN iY = INTEGER(SUBSTRING(sstr,1,INDEX(sstr,"-") - 1)).
        ASSIGN sstr = SUBSTRING(sstr,INDEX(sstr,"-") + 1).

        ASSIGN iM = INTEGER(SUBSTRING(sstr,1,INDEX(sstr,"-") - 1)).
        ASSIGN iD = INTEGER(SUBSTRING(sstr,INDEX(sstr,"-") + 1)).
        ASSIGN od = DATE(im,id,iy).
    end.
    RETURN od.

END FUNCTION.

quit.
