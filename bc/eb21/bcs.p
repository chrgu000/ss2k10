
session:date-format = 'mdy'.
{mfdeclre.i "new global"}
{mf1.i "new global"}

define new shared variable menu as character.
define new shared variable menu_log as decimal.
define variable v_i as integer.
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
global_userid = userid(sdbname("qaddb")).
mfguser = "".
global_user_lang = "ch".
global_user_lang_dir = "ch/".
global_domain = "DCEC".
global_db = "DCEC".
execname = "bcs.p".

define variable c-welcome as character format "x(34)" no-undo.
define variable cprt      as character format "x(34)" no-undo.
define variable c-allrightsreserved as character format "x(27)" no-undo.
define variable lv_domain like dom_domain no-undo.
define variable l_error as integer no-undo.
c-allrightsreserved = "保留所有权利". /* getTermLabel("ALL_RIGHTS_RESERVED",27) + ".". */
c-welcome = "* * * 欢  迎  使  用 * * *". /* getTermLabelCentered("MFG/PRO_WELCOME",78). */
assign cprt = "Copyright " + string(year(today) , "9999" ) + " Softspeed CO,LTD.".

form
   skip
   c-welcome colon 3 format "x(30)" no-label
   "SoftSpeed Barcode System" colon 4 skip(1)
   cprt colon 2 no-label
   " (8620) 8552 1040" colon 16
   " 400 538 3200"  colon 20
   "http:~/~/www.softspeed.com.cn~/" colon 6
   c-allrightsreserved colon 16 format "x(20)" no-label skip(1)
   global_userid colon 12 label "User"
   lv_domain     colon 12 dom_name format "x(16)" no-label
with frame welcome side-labels width 40 no-attr-space.

display c-welcome cprt global_userid c-allrightsreserved with frame welcome.

loopdomain:
do on endkey undo, leave:
   find udd_det where udd_userid = global_userid no-lock no-error.
   if ambiguous udd_det then do:
      find first udd_det
       where udd_userid = global_userid
         and udd_primary
      no-lock no-error.
      if available udd_det then lv_domain = udd_domain.
      update lv_domain with frame welcome.
      {us/gp/gprunp.i "mgdompl" "p" "ppUserDomDbValidate"
                "(input lv_domain, input global_userid, output l_error)"}
      if l_error > 0 then undo loopdomain, retry.
   end.
   else if available udd_det then do:
      lv_domain = udd_domain.
      display lv_domain with frame welcome.
   end.
   else do:
      /*DOMAIN IS NOT ASSIGNED TO THE USER*/
      {pxmsg.i &MSGNUM=6170 &ERRORLEVEL=3 &PAUSEAFTER=true}
      quit.
   end.
   find dom_mstr where dom_domain = lv_domain no-lock no-error.
        display dom_name with frame welcome.
   {us/bbi/gprun.i ""gpmdas.p"" "(input lv_domain, output l_error)"}
end.
hide frame welcome.
{us/bbi/gprun.i ""bcmenu0.p""}