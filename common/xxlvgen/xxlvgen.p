/* xxlvgen.p - license generate                                              */
/*V8:ConvertMode=Maintenance                                                 */
/* Environment: Progress:10.1B   QAD:eb21sp7    Interface:Character          */
/* REVISION END                                                              */
/* usrw_charfld[15] record key 'lvctrl' = usrw_domain for EB2                */

{mfdtitle.i "23YP"}
{xxecdc.i}
/* ********** Begin Translatable Strings Definitions ********* */
&SCOPED-DEFINE xxlvgen_p_1 " Continue?"
/* ********** End Translatable Strings Definitions ********* */

define variable yn like mfc_logical initial yes.
define variable l_prod as character format 'x(30)'.
define variable uid    as character format "x(56)".
define variable loc_phys_addr as character format "x(20)".
define variable l_tot_usrs    as integer initial 1.
define variable daysto        as integer initial 30.
define variable days          as integer.
define variable datet         as date.
define variable datestr       as character.
define variable key1          as character format "x(24)".
define variable key2          as character format "x(24)".
define variable key3          as character format "x(24)".
define variable cmmt          as character format "x(56)".
define variable histfn        as character format "x(24)".
define variable cLoadFile     as logical initial "NO".
define variable md5           as character.
define variable rev           as character.
define variable includedom    as character format "x(12)".
{gpcdget.i "UT"}
form
   skip(1)
   l_prod colon 20
   loc_phys_addr colon 20
   rev    colon 20 includedom no-label
   uid    colon 20
   daysto colon 20
   l_tot_usrs colon 20
   key1   colon 20
   key2   colon 20
   key3   colon 20
   skip(1)
   cmmt   colon 20
   histfn colon 20
   cLoadFile colon 20
   skip(2)
   yn  colon 20 label {&xxlvgen_p_1}
with frame a side-labels width 80.
/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

assign loc_phys_addr = getMAC().
{gprun.i ""gpgetver.p"" "(input '4', output rev)"}
if rev = "EB2.1" then do:
    includedom = getTermLabel("DOMAIN",20).
end.
else do:
    includedom = "".
end.
display includedom rev l_prod loc_phys_addr with frame a.

mainloop:
repeat with frame a:
/*
   update l_prod loc_phys_addr with frame a.
*/
  do on error undo, retry:
     prompt-for l_prod loc_phys_addr editing:
       if frame-field = "l_prod" then do:
      /* FIND NEXT/PREVIOUS RECORD */
         {mfnp.i usrw_wkfl l_prod " {xxusrwdom1.i} {xxand.i}
                                    usrw_charfld[15] = 'lvctrl' and usrw_key1 "
                 l_prod usrw_key1 usrw_index1}
             if recno <> ? then do:
                assign l_prod = usrw_key1
                       loc_phys_addr = usrw_key2
                       uid = usrw_key3
                       daysto = usrw_datefld[1] - today
                       l_tot_usrs = usrw_intfld[1]
                       key1 = usrw_key4
                       key2 = usrw_key5
                       key3 = usrw_key6
                       cmmt = usrw_charfld[10].
                display l_prod loc_phys_addr uid daysto l_tot_usrs
                        key1 key2 key3 cmmt with frame a.
             end.
        end.
        else if frame-field = "loc_phys_addr" then do:
          {mfnp05.i usrw_wkfl usrw_index1
                  " {xxusrwdom1.i} {xxand.i} usrw_key1 = input l_prod and
                    usrw_charfld[15] = 'lvctrl' "
                  usrw_key2
                " input loc_phys_addr"}
           if recno <> ? then do:
                assign l_prod = usrw_key1
                       loc_phys_addr = usrw_key2
                       uid = usrw_key3
                       daysto = usrw_datefld[1] - today
                       l_tot_usrs = usrw_intfld[1]
                       key1 = usrw_key4
                       key2 = usrw_key5
                       key3 = usrw_key6
                       cmmt = usrw_charfld[10].
                display l_prod loc_phys_addr uid daysto l_tot_usrs
                        key1 key2 key3 cmmt with frame a.
           end.
        end.
     end.
  end.
   assign l_prod loc_phys_addr.
   if l_prod = "" then do:
     {pxmsg.i &MSGNUM=4452 &ERRORLEVEL=3 &MSGARG1=""l_prod""}
      undo,retry.
   end.

   find first usrw_wkfl no-lock where {xxusrwdom1.i} {xxand.i}
              usrw_key1 = l_prod and usrw_key2 = loc_phys_addr and
              usrw_charfld[15] = 'lvctrl' no-error.
   if available usrw_wkfl then do:
      assign uid = usrw_key3
             daysto = usrw_datefld[1] - today
             l_tot_usrs = usrw_intfld[1]
             key1 = usrw_key4
             key2 = usrw_key5
             key3 = usrw_key6
             cmmt = usrw_charfld[10].
   end.
   else do:
      assign uid = global_userid
             daysto = 30
             l_tot_usrs = 1.
   end.

   if index(l_prod,".") = 0 then
      assign histfn = "xx" + l_prod + "lv.p".
   else
       assign histfn = "xx" + substring(l_prod,3,index(l_prod,".") - 3)
                     + "lv.p".
   display uid daysto l_tot_usrs key1 key2 key3 cmmt histfn with frame a.
   update rev.
   if rev = "EB2.1" then do:
      includedom = getTermLabel("DOMAIN",20).
   end.
   else do:
      includedom = "".
   end.
   display includedom with frame a.
   lab001:
   repeat:
      update  uid daysto l_tot_usrs key1 key2 key3 cmmt
              histfn cLoadFile with frame a.
      if daysto <= 0 then do:
        {pxmsg.i &MSGNUM=5904 &ERRORLEVEL=3}
        next-prompt daysto with frame a.
        undo,retry.
      end.
      if histfn = "" then do:
         {pxmsg.i &MSGNUM=4452 &ERRORLEVEL=3 &MSGARG1=""histfn""}
         next-prompt histfn with frame a.
         undo,retry lab001.
      end.
      leave.
   end. /*lab001: repeat:*/
   update yn with frame a.
   if yn = no then leave.

   assign datet = today + daysto.
   assign datestr = dts(datet).
   assign md5 = getEncode(l_prod + "year!", loc_phys_addr + "month@",
                          uid + "week#", datestr + "day$",
                          key1 + "hour%", key2 + "minutes^",
                          key3 + "second&",
                          trim(string(l_tot_usrs,">>>>>>9")) + "season*").

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
      put unformat fill(" ",11) 'usrw_key2 = "' loc_phys_addr '" no-error.' skip.
      put unformat 'if not available usrw_wkfl then do:' skip.
      put unformat fill(" ",10) 'create usrw_wkfl.' skip.
      put unformat fill(" ",10) 'assign '.
      if rev = "EB2.1" then do:
      put unformat 'usrw_domain = "lvctrl"' skip.
      put unformat fill(" ",17).
      end.
      put unformat 'usrw_key1 = "' l_prod '"' skip.
      put unformat fill(" ",17) 'usrw_key2 = "' loc_phys_addr '".' skip.
      put unformat 'end. ~/* if not available usrw_wkfl then do: *~/' skip.
      put unformat fill(" ",10) 'assign usrw_key3 = "' uid '"' skip.
      put unformat fill(" ",17) 'usrw_key4 = "' key1 '"' skip.
      put unformat fill(" ",17) 'usrw_key5 = "' key2 '"' skip.
      put unformat fill(" ",17) 'usrw_key6 = "' key3 '"' skip.
      put unformat fill(" ",17) 'usrw_charfld[1] = "'
                   entry(1,md5,",") '"' skip.
      put unformat fill(" ",17) 'usrw_charfld[2] = "' entry(2,md5,",") '"' skip.
      put unformat fill(" ",17) 'usrw_charfld[3] = "' entry(3,md5,",") '"' skip.
      put unformat fill(" ",17) 'usrw_charfld[4] = "' entry(4,md5,",") '"' skip.
      put unformat fill(" ",17) 'usrw_charfld[5] = "' entry(5,md5,",") '"' skip.
      put unformat fill(" ",17) 'usrw_charfld[6] = "' entry(6,md5,",") '"' skip.
      put unformat fill(" ",17) 'usrw_charfld[7] = "' entry(7,md5,",") '"' skip.
      put unformat fill(" ",17) 'usrw_charfld[8] = "' entry(8,md5,",") '"' skip.
      put unformat fill(" ",17) 'usrw_charfld[10] = "' cmmt '"' skip.
      put unformat fill(" ",17) 'usrw_charfld[15] = "lvctrl"' skip.
      put unformat fill(" ",17) 'usrw_datefld[1] = '.
      put unformat 'date(' string(month(datet),"99") ","
                           string(day(datet),"99") ","
                           string(year(datet),"9999") ')' skip.
      put unformat fill(" ",17) 'usrw_intfld[1] = ' l_tot_usrs skip.
      put unformat fill(" ",17) 'usrw_datefld[2] = today' skip.
      put unformat fill(" ",17) 'usrw_intfld[2] = time.' skip.
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
