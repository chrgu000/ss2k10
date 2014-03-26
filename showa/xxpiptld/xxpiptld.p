/* xxpiptld.p - piptcr.p cim load                                            */
/*V8:ConvertMode=Report                                                      */
/* Environment: Progress:10.1B   QAD:eb21sp7    Interface:Character          */
/* REVISION: 140218.1 LAST MODIFIED: 07/06/12 BY:Zy                          */
/* REVISION END                                                              */

/* DISPLAY TITLE */
{mfdtitle.i "140304.1"}
{xxpiptld.i "new"}
{gpcdget.i "UT"}
define variable yn as logical.

form
   skip(1)
   flhload colon 14 view-as fill-in size 40 by 1
   effdate colon 14 skip(1)
   cloadfile colon 14 skip(2)
with frame a side-labels width 80.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).
assign flhload = os-getenv("HOME").
find first qad_wkfl where
           qad_key1 = "xxpiptld.p_filename" and
           qad_key2 = global_userid no-error.
if available qad_wkfl then do:
   if qad_key3 <> "" then do:
      assign flhload =  qad_key3.
   end.
end.

display flhload with frame a.

{wbrp01.i}
repeat:

   if c-application-mode <> 'web' then
   update flhload effdate cloadfile with frame a.

   {wbrp06.i &command = update &fields = " flhload effdate cloadfile "
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
   /* OUTPUT DESTINATION SELECTION */
   {gpselout.i &printType = "terminal"
               &printWidth = 320
               &pagedFlag = " "
               &stream = " "
               &appendToFile = " "
               &streamedOutputToTerminal = " "
               &withBatchOption = "no"
               &displayStatementType = 1
               &withCancelMessage = "yes"
               &pageBottomMargin = 6
               &withEmail = "yes"
               &withWinprint = "yes"
               &defineVariables = "yes"}
   {mfmsg.i 832 1}
   {mfphead.i}
   find first qad_wkfl where
              qad_key1 = "xxpiptld.p_filename" and
              qad_key2 = global_userid no-error.
   if available qad_wkfl then do:
          assign qad_key3 = flhload.
   end.
   else do:
       create qad_wkfl.
       assign qad_key1 = "xxpiptld.p_filename"
              qad_key2 = global_userid
              qad_key3 = flhload.
   end.
   empty temp-table b_tag no-error.
   for each b_tag exclusive-lock: delete b_tag. end.
   {gprun.i ""xxpiptld0.p""}
     assign yn = yes.
     if not can-find(first b_tag) then do:
          {mfmsg.i 1310 1}
          assign yn = no.
     end.

     for each b_tag no-lock by b_tag.tag_sn with width 320 frame c:
      /* SET EXTERNAL LABELS */
      setFrameLabels(frame c:handle).
         display b_tag.
     end.
   {mfrtrail.i}
   /* 12 = Is all information correct  */
   if cloadfile and can-find(first b_tag) then do:
      if can-find(first b_tag where tag_chk <> "") then do:
         {pxmsg.i &MSGNUM=2486 &ERRORLEVEL=3 &MSGARG1=''}
      end.
      else do:
           {pxmsg.i &MSGNUM=12 &ERRORLEVEL=2 &CONFIRM=yn}
           if yn then do:
              for each b_tag no-lock:
                  find first tag_mstr exclusive-lock where
                             tag_mstr.tag_nbr = b_tag.tag_nbr no-error.
                  if available tag_mstr then do:
                     assign tag_mstr.tag_cnt_qty = b_tag.tag_cnt_qty
                      tag_mstr.tag_cnt_dt = b_tag.tag_cnt_dt.
                  end.
                  else do:
                       buffer-copy b_tag to tag_mstr.
                  end.
              end.
           end.
      end.  /*  else  if can-find(first b_tag  do:  */
   end.

end.

{wbrp04.i &frame-spec = a}
