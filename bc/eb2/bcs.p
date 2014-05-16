
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
global_db = "DCEC".
execname = "bcs.p".

define variable c-welcome as character format "x(34)" no-undo.
define variable cprt      as character format "x(34)" no-undo.
define variable c-allrightsreserved as character format "x(27)" no-undo.
define variable l_error as integer no-undo.
define variable witchdb as character format "x(34)".
c-allrightsreserved = "保留所有权利". /* getTermLabel("ALL_RIGHTS_RESERVED",27) + ".". */
c-welcome = "* * * 欢  迎  使  用 * * *". /* getTermLabelCentered("MFG/PRO_WELCOME",78). */
assign cprt = "Copyright " + string(year(today) , "9999" ) + " Softspeed CO,LTD.".
find first ad_mstr no-lock where ad_addr = "~~screens" no-error.
if available ad_mstr then do:
   assign witchdb = "    " + ad_name.
end.
form
   skip
   c-welcome colon 3 format "x(30)" no-label
   "SoftSpeed Barcode System" colon 4 skip(1)
   cprt colon 2 no-label
   " (8620) 8552 1040" colon 16
   " 400 538 3200"  colon 20
   "http:~/~/www.softspeed.com.cn~/" colon 6
   c-allrightsreserved colon 16 format "x(20)" no-label skip
   witchdb colon 2 no-label
   global_userid colon 12 label "User"
with frame welcome side-labels width 40 no-attr-space.

display c-welcome witchdb cprt global_userid c-allrightsreserved with frame welcome.
color display input witchdb with frame welcome.
pause 5.
hide frame welcome.
{gprun.i ""bcmenu.p""}
