/* xxc.p - compile procedure                                                 */
/*V8:ConvertMode=Maintenance                                                 */
/* Environment: Progress:10.1B   QAD:eb21sp7    Interface:Character          */
/* REVISION END                                                              */

{mfdtitle.i "23YO"}
{xxecdc.i}
/* ********** Begin Translatable Strings Definitions ********* */
&SCOPED-DEFINE xxlvgen_p_1 " Continue?"
/* ********** End Translatable Strings Definitions ********* */

define variable yn like mfc_logical initial yes.
define variable l_prod as character format 'x(30)'.
define variable uid    as character format "x(20)".
define variable loc_phys_addr as character format "x(20)".
define variable daysto        as integer initial 30.
define variable days          as integer.
define variable datestr       as character.
define variable key1          as character format "x(20)".
define variable key2          as character format "x(20)".
define variable histfn        as character format "x(40)".
define variable cLoadFile     as logical initial "NO".
define variable md5           as character.
define variable rev           as character.

{gpcdget.i "UT"}
form
   skip(1)
   l_prod colon 20
   loc_phys_addr colon 20
   uid    colon 20
   daysto colon 20
   key1   colon 20
   key2   colon 20
   skip(1)
   rev    colon 20
   histfn colon 20
   cLoadFile colon 20
   skip(2)
   yn label {&xxlvgen_p_1}
with frame a side-labels width 80.
/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

assign uid = global_userid
       loc_phys_addr = getMAC().
{gprun.i ""gpgetver.p"" "(input '4', output rev)"}
display l_prod loc_phys_addr uid daysto key1 key2 with frame a.

repeat:
   update l_prod loc_phys_addr uid daysto key1 key2 with frame a.

   if l_prod = "" then do:
     {pxmsg.i &MSGNUM=4452 &ERRORLEVEL=3 &MSGARG1=""l_prod""}
      undo,retry.
   end.

   if loc_phys_addr = "" then do:
     {pxmsg.i &MSGNUM=4452 &ERRORLEVEL=3 &MSGARG1=""loc_phys_addr""}
     next-prompt loc_phys_addr with frame a.
     undo,retry.
   end.

   if uid = "" then do:
     {pxmsg.i &MSGNUM=4452 &ERRORLEVEL=3 &MSGARG1=""uid""}
     next-prompt uid with frame a.
      undo,retry.
   end.

   if daysto <= 0 then do:
     {pxmsg.i &MSGNUM=5904 &ERRORLEVEL=3}
     next-prompt daysto with frame a.
     undo,retry.
   end.
   assign days = today - date(2,27,2012) + daysto.
   if index(l_prod,".") = 0 then
      assign histfn = "xx" + l_prod + "lv.p".
   else
       assign histfn = "xx" + substring(l_prod,3,index(l_prod,".") - 3)
                     + "lv.p".
   display histfn with frame a.
   lab001:
   repeat:
      update rev histfn cLoadFile with frame a.
      if histfn = "" then do:
         {pxmsg.i &MSGNUM=4452 &ERRORLEVEL=3 &MSGARG1=""histfn""}
         next-prompt histfn with frame a.
         undo,retry lab001.
      end.
      leave.
   end. /*lab001: repeat:*/
   update yn with frame a.
   if yn = no then leave.
   assign datestr = getDateStr(daysto,yes).
   assign md5 = getEncode(l_prod, loc_phys_addr ,uid,
                          datestr, key1, key2).

   output to value(histfn).
   if cLoadFile then do:
      put unformat '~{mfdeclre.i~}' skip.
   end.
   else do:
      put unformat '~/*V8:ConvertMode=Maintenance' fill(" ",50) '*~/' skip.
      put unformat '~{mfdtitle.i "' string(today,"999999") '.1"~}' skip.
   end.
   if not cLoadFile then do:
      put unformat 'define variable yn like mfc_logical no-undo.' skip.
      put unformat '~{gpcdget.i "UT"~}' skip(1).
      put unformat 'Form yn colon 40' skip.
      put unformat 'with frame a side-labels width 80 attr-space.' skip.
      put unformat 'setFrameLabels(frame a:handle).' skip(1).
      put unformat 'repeat with frame a:' skip.
      put unformat 'update yn.' skip.
      put unformat 'if not yn then leave.' skip(1).
    end.  /* if not cLoadFile then do:  */
      put unformat 'find first usrw_wkfl exclusive-lock where '.
      if rev = "EB2.1" then do:
      put unformat 'usrw_domain = "lvctrl" and'.
      end.
      put skip.
      put unformat fill(" ",11) 'usrw_key1 = "' l_prod '" and' skip.
      put unformat fill(" ",11) 'usrw_key2 = "' loc_phys_addr '" and' skip.
      put unformat fill(" ",11) 'usrw_key3 = "' uid '" and' skip.
      put unformat fill(" ",11) 'usrw_key4 = "' string(days) '" and' skip.
      put unformat fill(" ",11) 'usrw_key5 = "' key1 '" and' skip.
      put unformat fill(" ",11) 'usrw_key6 = "' key2 '" no-error.' skip.
      put unformat 'if not available usrw_wkfl then do:' skip.
      put unformat fill(" ",10) 'create usrw_wkfl.' skip.
      put unformat fill(" ",10) 'assign '.
      if rev = "EB2.1" then do:
      put unformat 'usrw_domain = "lvctrl"' skip.
      put unformat fill(" ",17).
      end.
      put unformat 'usrw_key1 = "' l_prod '"' skip.
      put unformat fill(" ",17) 'usrw_key2 = "' loc_phys_addr '"' skip.
      put unformat fill(" ",17) 'usrw_key3 = "' uid '"' skip.
      put unformat fill(" ",17) 'usrw_key4 = "' string(days) '"' skip.
      put unformat fill(" ",17) 'usrw_key5 = "' key1 '"' skip.
      put unformat fill(" ",17) 'usrw_key6 = "' key2 '".' skip.
      put unformat 'end. ~/* if not available usrw_wkfl then do: *~/' skip.
      put unformat fill(" ",10) 'assign usrw_charfld[1] = "'
                   entry(1,md5,";") '"' skip.
      put unformat fill(" ",17) 'usrw_charfld[2] = "' entry(2,md5,";") '"' skip.
      put unformat fill(" ",17) 'usrw_charfld[3] = "' entry(3,md5,";") '"' skip.
      put unformat fill(" ",17) 'usrw_charfld[4] = "' entry(4,md5,";") '"' skip.
      put unformat fill(" ",17) 'usrw_charfld[5] = "' entry(5,md5,";") '"' skip.
      put unformat fill(" ",17) 'usrw_charfld[6] = "' entry(6,md5,";") '"' skip.
      put unformat fill(" ",17) 'usrw_charfld[7] = global_userid' skip.
      put unformat fill(" ",17) 'usrw_datefld[1] = today' skip.
      put unformat fill(" ",17) 'usrw_intfld[1] = time.' skip.
      put unformat "leave." skip.
   if not cLoadFile then do:
      put unformat skip 'end.  ~/* repeat with frame a: *~/' skip.
      put unformat '~{pxmsg.i &MSGNUM=5584 &ERRORLEVEL=1 &MSGARG1=""REG""~}'.
      put unformat skip 'status input.' skip.
   end.  /* if not cLoadFile then do:  */
   output close.
   if cLoadFile then do:
      run value(histfn).
      os-delete value(histfn) no-error.
   end.
   else do:
        {pxmsg.i &MSGNUM=4804 &ERRORLEVEL=1 &MSGARG1=histfn}
   end.
end. /* repeat with frame a */
if yn = no then do:
    {pxmsg.i &MSGNUM=4812 &ERRORLEVEL=3}
   pause.
end.

status input.
