/* xxphead.i - INCLUDE FILE TO PRINT PAGE HEADING FOR REPORTS                */
/* Copyright 2010 SoftSpeed gz         copy from mfphead.i                   */
/* All rights reserved worldwide.  This is an unpublished work.              */
/* SS - 101115.1 By: zhangyun                                                */

define variable rtitle  as character format "x(100)".
define variable co_name as character format "x(30)".
define variable len_raw as integer.
define variable vhead1  as character format "x(12)".
define variable vhead2  as character format "x(12)".

find ls_mstr where ls_mstr.ls_domain = global_domain and  ls_addr = "~~reports"
 and ls_type = "company"
   no-lock no-error.

if available ls_mstr then
   find ad_mstr  where ad_mstr.ad_domain = global_domain and  ad_addr = ls_addr
   no-lock no-error.

if available ad_mstr then
   co_name = fill(" ",max((15 - integer({gprawlen.i &strng=ad_name} / 2)),1)) +
                  ad_name.

find first xdn_ctrl no-lock where xdn_domain = global_domain
       and xdn_type = v_type no-error.
if available xdn_ctrl then do:
   assign vhead1 = xdn_isonbr vhead2 = xdn_isover.
end.

if global_usrc_right_hdr_disp < 2
then len_raw = {gprawlen.i &strng=substring(dtitle,16,50)}.
else len_raw = {gprawlen.i &strng=substring(dtitle,22,44)}.

if global_usrc_right_hdr_disp < 2
then rtitle = fill(" ",44) + substring(dtitle,22,52 - (len_raw - 46)).
else rtitle = fill(" ",50) + substring(dtitle,28,46 - (len_raw - 40)).

form
   header
   co_name         at 53
   getTermLabelRtColon("ISO-TABLE_NBR",9) format "x(9)" to 120
   trim(vhead1)           skip
   rtitle
   getTermLabelRtColon("VERSION_VERIFY",14) format "x(14)" to 120
   trim(vhead2)
   getTermLabel("RCPT_NBR",12) + ":" at 1
   trim(v_nbr)
   getTermLabelRtColon("DATE",9) format "x(9)" to 120
   today
/*   getTermLabelRtColon("TIME",9) format "x(9)" to 123 */
/*   string(Time,"hh:mm:ss")                            */

with frame phead page-top width 132 no-box.
view {1} frame phead.
