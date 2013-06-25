/* xxbmsurp.p - bom Substitute Report                                        */
/*V8:ConvertMode=Report                                                      */
/* Environment: Progress:10.1B   QAD:eb21sp7    Interface:Character          */
/* REVISION: 120703.1 LAST MODIFIED: 07/03/12 BY:                            */
/* REVISION END                                                              */

/* DISPLAY TITLE */
{mfdtitle.i "130529.1"}
{gpcdget.i "UT"}
define variable flhload as character format "x(60)".
define temp-table tmp_mstr
       fields tmp_part like pt_part.
define temp-table tmpd_det
       fields tmpd_par like ps_par
       fields tmpd_comp like ps_comp
       fields tmpd_ref  like ps_ref
       fields tmpd_sub_part like pts_sub_part
       fields tmpd_start like ps_start
       fields tmpd_end   like ps_end
       fields tmpd_qty_per like ps_qty_per.
form
   skip(1)
   flhload colon 14  view-as fill-in size 40 by 1 skip(1)
with frame a side-labels width 80.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).
assign flhload = OS-GETENV("HOME").
display flhload with frame a.
{wbrp01.i}
repeat:
   find first usrw_wkfl where
              usrw_key1 = "common_filename" and
              usrw_key2 = global_userid no-lock no-error.
   if available usrw_wkfl then do:
      if usrw_key3 <> "" then do:
         assign flhload =  usrw_key3.
      end.
   end.
   if c-application-mode <> 'web' then
   update flhload with frame a.

   {wbrp06.i &command = update &fields = " flhload "
      &frm = "a"}

     IF SEARCH(flhload) = ? THEN DO:
         {mfmsg.i 4839 3}
         next-prompt flhload.
         undo, retry.
     END.
     else do:
          do transaction:
             find first usrw_wkfl where
                        usrw_key1 = "common_filename" and
                        usrw_key2 = global_userid exclusive-lock no-error.
             if not available usrw_wkfl then do:
                 create usrw_wkfl.
                 assign usrw_key1 = "common_filename"
                        usrw_key2 = global_userid.
             end.
             assign usrw_key3 = flhload.
          end.
     end.

   if (c-application-mode <> 'web') or
      (c-application-mode = 'web' and
      (c-web-request begins 'data'))
   then do:
      hide frame b.
      hide frame c.
   end.

   /* OUTPUT DESTINATION SELECTION */
   {gpselout.i &printType = "Page"
               &printWidth = 320
               &pagedFlag = " nopage"
               &stream = " "
               &appendToFile = " "
               &streamedOutputToTerminal = " "
               &withBatchOption = "no"
               &displayStatementType = 1
               &withCancelMessage = "no"
               &pageBottomMargin = 6
               &withEmail = "no"
               &withWinprint = "no"
               &defineVariables = "yes"}
     empty temp-table tmp_mstr no-error.
     empty temp-table tmpd_det no-error.
     input from value(flhload).
     repeat:
        create tmp_mstr.
        import tmp_part.
     end.
     input close.
     for each tmp_mstr no-lock where tmp_part > "" and tmp_part <= "ZZZZZZZZ":
         for each ps_mstr no-lock where ps_comp = tmp_part
             break by ps_par by ps_start:
             if last-of(ps_par) then do:
                find first tmpd_det exclusive-lock where tmpd_par = ps_par
                       and tmpd_comp = ps_comp and tmpd_ref = ps_ref
                       and tmpd_start = ps_start no-error.
                if not available tmpd_det then do:
                   create tmpd_det.
                   assign tmpd_par = ps_par
                          tmpd_comp = ps_comp
                          tmpd_ref = ps_ref
                          tmpd_start = ps_start.
                end.
                   assign tmpd_qty_per = ps_qty_per.
             end.
         end.
     end.
     put unformat getTermLabel("PARENT_ITEM",18) "~t"
                  getTermLabel("COMPONENT_ITEM",18) "~t"
                  getTermLabel("REFERENCE",18) "~t"
                  getTermLabel("START_EFFECTIVE",18) "~t"
                  getTermLabel("SUBSTITUTE_ITEM",18) "~t"
                  getTermLabel("END_EFFECTIVE",18) "~t"
                  getTermLabel("QTY_PER",12) skip.
                   .
     for each tmpd_det no-lock with width 320 frame d:
         export delimiter "~t" tmpd_par
                               tmpd_comp
                               tmpd_ref
                               tmpd_start
                               tmpd_sub_part
                               tmpd_end
                               tmpd_qty_per.
     end.
   {mfreset.i}

end.

{wbrp04.i &frame-spec = a}
