/* xxsh1201.p - sh1201 item request calc                                     */
/*V8:ConvertMode=Report                                                      */
/* Environment: Progress:10.1C04   QAD:eb21sp6    Interface:Character        */
/* REVISION: 120706.1 LAST MODIFIED: 07/06/12 BY:Zy                          */
/* REVISION END                                                              */

/* DISPLAY TITLE */
{mfdtitle.i "120706.1"}
{xxsh1201.i "new"}
{gpcdget.i "UT"}

form
   skip(1)
   site colon 14
   sdate colon 14
   flhload colon 14  view-as fill-in size 40 by 1 skip(1)
with frame a side-labels width 80.
/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).
find first usrw_wkfl where usrw_domain = global_domain and
           usrw_key1 = "xxsh1201.p_filename" and
           usrw_key2 = global_userid no-error.
if available usrw_wkfl then do:
   if usrw_key3 <> "" then do:
      assign flhload =  usrw_key3.
   end.
end.
if flhload = "" then do:
   assign flhload = os-getenv("HOME").
end.
display flhload with frame a.
find first icc_ctrl no-lock where icc_domain = global_domain.
if available icc_ctrl then do:
   assign site = icc_site.
end.
display site with frame a.
{wbrp01.i}
repeat:
   run getplanItems.
   if c-application-mode <> 'web' then
   update site sdate flhload with frame a.

   {wbrp06.i &command = update &fields = " site sdate flhload "
      &frm = "a"}

   IF SEARCH(flhload) = ? THEN DO:
       {mfmsg.i 4839 3}
       next-prompt flhload.
       undo, retry.
   END.

   if (c-application-mode <> 'web') or
      (c-application-mode = 'web' and
      (c-web-request begins 'data'))
   then do:
      hide frame b.
      hide frame c.
   end.

   {mfselprt.i "printer" 120}
/*
   {mfmsg.i 832 1}
*/
   find first code_mstr no-lock where code_domain = global_domain and
              code_fldname = "xxsh1201.p.horizon.days" and code_value <> "" no-error.
   if available code_mstr then do:
      assign maxArray = integer(code_value) no-error.
   end.
   if maxArray = 0 then assign maxArray = 30.

   find first usrw_wkfl where usrw_domain = global_domain and
              usrw_key1 = "xxsh1201.p_filename" and
              usrw_key2 = global_userid no-error.
   if available usrw_wkfl then do:
      assign usrw_key3 = flhload when locked(usrw_wkfl).
   end.
   else do:
       create usrw_wkfl. usrw_domain = global_domain.
       assign usrw_key1 = execname + "_filename"
              usrw_key2 = global_userid
              usrw_key3 = flhload.
   end.
   empty temp-table xxpln_mstr no-error.
   empty temp-table xxpnd_det no-error.
   empty temp-table temp3 no-error.
   {gprun.i ""xxsh1201a.p""}

     if not can-find(first xxpln_mstr) then do:
          {mfmsg.i 5935 1}
     end.
     else do:
          {gprun.i ""xxsh1201b.p""}
     end.

/*       for each xxpln_mstr no-lock with width 320 frame c:          */
/*        /* SET EXTERNAL LABELS */                                   */
/*        setFrameLabels(frame c:handle).                             */
/*           display xxpln_mstr.                                      */
/*       end.                                                         */
/*       for each temp3 no-lock with width 320 frame d:               */
/*           setFrameLabels(Frame d:handle).                          */
/*           display temp3.                                           */
/*       end.                                                         */

/*   {mfrtrail.i} */
   {mfreset.i}
   {pxmsg.i &MSGNUM=8 &ERRORLEVEL=1}
end.
{wbrp04.i &frame-spec = a}
