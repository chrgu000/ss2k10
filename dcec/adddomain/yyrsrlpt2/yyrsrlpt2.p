/* yyrsrlpt2.p -                                                              */
/*V8:ConvertMode=Report                                                       */
/*-Revision end---------------------------------------------------------------*/

/* DISPLAY TITLE */
{mfdtitle.i "120921.1"}
define variable v_ponbr    like sch_nbr no-undo.
define variable v_part1    like pt_part no-undo.
define variable v_part2    like pt_part no-undo.
define variable v_vend     like vd_addr no-undo.
define variable v_vddesc   like vd_sort no-undo.
define variable v_site     like si_site no-undo.
define variable v_sidesc   like si_desc no-undo.
define variable v_buyer    like pt_buyer no-undo.
define variable v_list_net as logical no-undo.
define variable v_list_fp  like schd_fc_qual no-undo.
define variable v_list_zero as logical no-undo.
define variable v_noexport  as logical no-undo.
define variable v_releaseid like sch_rlse_id no-undo.
define variable v_datefmt   as character no-undo.


form
   space(1)
   v_ponbr colon 20
   v_vend  colon 20 v_vddesc no-label colon 30
   v_site  colon 20 v_sidesc no-label colon 30
   v_part1 colon 20 v_part2 colon 44
   v_buyer colon 20
   v_list_net colon 20
   v_list_fp colon 20
   v_list_zero colon 20
   v_noexport colon 20
   v_releaseid colon 20
   v_datefmt colon 20
with frame a side-labels width 80 attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

{wbrp01.i}

repeat:

   if c-application-mode <> 'web' then
      prompt-for v_ponbr
                 v_part1
                 v_part2
                 v_buyer
                 v_list_net
                 v_list_fp
                 v_list_zero
                 v_noexport
                 v_releaseid
                 v_datefmt
                 with frame a
   editing:

      if frame-field = "v_ponbr" then do:

         /* FIND NEXT/PREVIOUS RECORD */
         {mfnp.i scx_ref v_ponbr
                 " scx_domain = global_domain and scx_type = 2 and
         scx_po "  v_ponbr scx_po scx_po}

         if recno <> ? then do:
            assign v_vddesc = ""
                   v_sidesc = "".
            find first vd_mstr no-lock where vd_domain = global_domain and
                       vd_addr = scx_shipfrom no-error.
            if available vd_mstr then do:
               assign v_vddesc = vd_sort.
            end.
            find first si_mstr no-lock where si_domain = global_domain and
                       si_site = scx_shipto no-error.
            if available si_mstr then do:
               assign v_sidesc = si_desc.
            end.
            display scx_po @ v_ponbr
                    scx_shipfrom @ v_vend v_vddesc
                    scx_shipto @ v_site v_sidesc
            with frame a.
         end.
      end.
      else do:
         status input.
         readkey.
         apply lastkey.
      end.
   end.
   status input.

   {wbrp06.i &command = prompt-for
             &fields = " v_ponbr
   						           v_part1
                         v_part2
                         v_buyer
                         v_list_net
                         v_list_fp
                         v_list_zero
                         v_noexport
                         v_releaseid
                         v_datefmt " &frm = "a"}
	 
   if (c-application-mode <> 'web') or
      (c-application-mode = 'web' and
      (c-web-request begins 'data'))
   then do:
      hide frame b.
   end.

   /* OUTPUT DESTINATION SELECTION */
   {gpselout.i &printType = "terminal"
               &printWidth = 80
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
   for each scx_ref no-lock where scx_domain = global_domain and
            (SCX_po = INPUT v_ponbr OR INPUT v_ponbr = "") AND
             scx_part >= INPUT v_part1 and (scx_part <= INPUT v_part2 OR INPUT v_part2 = "")
            with frame b width 80 no-attr-space down:

      /* SET EXTERNAL LABELS */
      setFrameLabels(frame b:handle).

      {mfrpchk.i}

      display scx_shipfrom scx_shipto scx_part.

   end.

   {mfreset.i}
   {mfgrptrm.i} 
   {pxmsg.i &MSGNUM=8 &ERRORLEVEL=1}

end.

{wbrp04.i &frame-spec = a}
