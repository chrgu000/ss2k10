/* xxboxrp.p - box unpackage                                                  */
/*V8:ConvertMode=FullGUIReport                                                */
/* $Revision: 1.15 $ BY: Paul Donnelly (SB) DATE: 06/28/03 ECO: *Q00G* */
/*-Revision end---------------------------------------------------------------*/

/* DISPLAY TITLE */
{mfdtitle.i "1230329.1"}


define variable order like so_nbr.
define variable order1 like so_nbr.
define variable line   like sod_line.
define variable line1  like sod_line.
define variable cont_id as character format "x(22)".
define variable abc1 as character format "x(22)".
define variable vin as  character format "x(22)".
define variable acc1 as  character format "x(22)".

define variable del-yn as logical initial no.

form
   order    colon 15
   order1   colon 48 label {t001.i}
   line     colon 15
   line1    colon 48 label {t001.i}
   cont_id  colon 15
   abc1 colon 48 label {t001.i}
   vin      colon 15
   acc1     colon 48
    label {t001.i}
   skip(2)
   del-yn colon 20 skip(2)
with frame a side-labels width 80 attr-space.
/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).


{wbrp01.i}
repeat:

   if order1 = hi_char then order1 = "".
   if abc1 = hi_char then abc1 = "".
   if acc1 = hi_char then acc1 = "".

   if c-application-mode <> 'web' then
      update order order1 line line1 cont_id abc1 vin acc1 del-yn with frame a.

   {wbrp06.i &command = update 
   					 &fields = " order order1 line line1 cont_id abc1 vin acc1 del-yn" 
   					 &frm = "a"}

   if (c-application-mode <> 'web') or
      (c-application-mode = 'web' and
      (c-web-request begins 'data'))
   then do:
      if order1 = "" then order1 = hi_char.
      if abc1 = "" then abc1 = hi_char.
      if acc1 = "" then acc1 = hi_char.
   end.

   /* OUTPUT DESTINATION SELECTION */
   {gpselout.i &printType = "printer"
               &printWidth = 132
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

   {mfphead.i}
 

   for each xxbox_mst no-lock where xxbox_domain = global_domain 
        and xxbox_sonbr = order and xxbox_sonbr <= order1
        and xxbox_soline >= line and (xxbox_soline <= line1 or line1 = 0)
        and xxbox_par >= cont_id and xxbox_par <= cont_id
        and xxbox_comp >= vin or xxbox_comp <= acc1
   with frame b width 132 no-attr-space:

      /* SET EXTERNAL LABELS */
      setFrameLabels(frame b:handle).
      {mfrpchk.i}
      display xxbox_sonbr xxbox_soline xxbox_par xxbox_comp.

   end.
	
	
	if del-yn then do:
	    for each xxbox_mst exclusive-lock where xxbox_domain = global_domain 
           and xxbox_sonbr = order and xxbox_sonbr <= order1
           and xxbox_soline >= line and (xxbox_soline <= line1 or line1 = 0)
           and xxbox_par >= cont_id and xxbox_par <= cont_id
           and xxbox_comp >= vin or xxbox_comp <= acc1:
   		    	delete xxbox_mst.
   		end.
  end.
		
   {mfrtrail.i}

end.

{wbrp04.i &frame-spec = a}
