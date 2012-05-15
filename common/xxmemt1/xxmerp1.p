/* xxmerp1.p - menu REPORT                                                    */
/*V8:ConvertMode=FullGUIReport                                                */
/*-Revision end---------------------------------------------------------------*/

{mfdtitle.i "24Y5"}

define variable cdref  as character format "x(30)" no-undo.
define variable abc1   as character format "x(30)" no-undo.
define variable dsc    like mnt_label no-undo .
define variable iCnt   as integer no-undo.
define variable folder as character format "x(68)".
define temp-table tmp_ver
       fields xxtv_exec like mnd_exec
       fields xxtv_ver  as   character format "x(12)"
       index xxtv_exec is primary xxtv_exec.

form
   cdref   colon 15
   abc1    colon 15 label {t001.i}
with frame a side-labels width 80 attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

{wbrp01.i}

repeat:

   if abc1 = hi_char then abc1 = "".

if c-application-mode <> 'web' then
   update cdref abc1 with frame a.

{wbrp06.i &command = update &fields = " cdref abc1 "
          &frm = "a"}

if (c-application-mode <> 'web') or
(c-application-mode = 'web' and
(c-web-request begins 'data')) then do:

   if abc1 = "" then abc1 = hi_char.

end.

   /* SELECT PRINTER */
   {mfselprt.i "printer" 80}
   {mfphead2.i}
   empty temp-table tmp_ver no-error.
   for each usrw_wkfl no-lock where {xxusrwdomver.i} {xxand.i}
            usrw_key1 <> "" and usrw_key2 = opsys and
            usrw_charfld[15] = 'version_number':
       create tmp_ver.
       assign xxtv_exec = usrw_key1
              xxtv_ver = usrw_key3.
   end.


   for each usrw_wkfl no-lock where {xxusrwdom0.i} {xxand.i}
            usrw_key1 = global_userid and
            usrw_key2 >= cdref and usrw_key2 <= abc1 and
            usrw_charfld[15] = 'xxmemt1.p'
       with frame b width 80 no-attr-space:
                /* SET EXTERNAL LABELS */
       setFrameLabels(frame b:handle).
       {mfrpchk.i}         /*G348*/
      do iCnt = 1 to 10:
         if usrw_intfld[icnt] = 0 then next.
         assign dsc = entry(icnt,usrw_key6,"#").
         find first mnt_det no-lock where
                    mnt_nbr = entry(iCnt,usrw_key3,"#") and
                    mnt_select = usrw_intfld[iCnt] and
                    mnt_lang = global_user_lang
              no-error.
         if available mnt_det then do:
            assign dsc = mnt_label.
         end.
         assign folder = "".
         find first tmp_ver no-lock where xxtv_exec = entry(icnt,usrw_key4,"#")
                            no-error.
         if available tmp_ver then do:
            assign folder = xxtv_ver.
         end.
         assign folder = entry(iCnt,usrw_key3,"#") + "."
                       + string(usrw_intfld[iCnt])
                       + "-" + dsc + " [" + entry(iCnt,usrw_key4 ,"#") + "] "
                       + folder.
         display folder.
         down 1.
      end.
   end.
   {mftrl080.i}
end.

{wbrp04.i &frame-spec = a}
