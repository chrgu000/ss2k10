/* xxcsmrp.p - Consume Detail REPORT                                         */
/*V8:ConvertMode=FullGUIReport                                               */
/*-Revision end--------------------------------------------------------------*/

{mfdtitle.i "111111.1"}

define variable part  like pt_part.
define variable part1 like pt_part.

form
	 skip(.1)
   part   colon 15
   part1  colon 50 label {t001.i} skip(2)
with frame a side-labels width 80 attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

{wbrp01.i}

repeat:

   if part1 = hi_char then part1 = "".

if c-application-mode <> 'web' then
   update part part1 with frame a.

{wbrp06.i &command = update &fields = " part part1"
          &frm = "a"}

if (c-application-mode <> 'web') or
(c-application-mode = 'web' and
(c-web-request begins 'data')) then do:

   if part1 = "" then part1 = hi_char.

end.

   /* SELECT PRINTER */
   {mfselprt.i "printer" 80}
   {mfphead2.i}

   for each xcsm_det no-lock where xcsm_part >= part and 
   				 (xcsm_part <= part1 or part1 = ""),
   		 each pt_mstr no-lock where pt_domain = global_domain
   		 			                  and pt_part = xcsm_part
       with frame b width 80 no-attr-space:
                /* SET EXTERNAL LABELS */
                setFrameLabels(frame b:handle).
                {mfrpchk.i}         /*G348*/
			
      display xcsm_part pt_prod_line pt_desc1 pt_um pt_pm_code pt_abc xcsm_qty.

   end.
   {mftrl080.i}
end.

{wbrp04.i &frame-spec = a}
