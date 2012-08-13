/*----------------------------------------------------------------
  File         xkwobkmo.p
  Description  work order back flush kanban card consume monitor
  Author       Yang Enping
  Created      2004-04-20
  History

------------------------------------------------------------------*/

{mfdtitle.i}
/*0001*----*/
{kbconst.i}
{pxmaint.i}
{pxphdef.i kbknbxr}
{pxphdef.i kbknbdxr}
define buffer bf-knbd_det     for knbd_det.
define buffer bf-knbism_det   for knbism_det.
define buffer bf-knbl_det     for knbl_det.
define variable KanbanTransNbr      as integer            no-undo.

/*----*0001*/
def var interval as int .
form
   interval label "Interval" colon 30
   skip(2)
   with frame a side-labels three-d .

def var dt as date .
def var tm as char format "x(10)".

form
   dt label "Date"
   tm label "Time" 
   with frame b down .
{wbrp01.i}    /* General web report setup */

mainloop:
repeat:

   if c-application-mode <> 'web' then
      update
         interval
      with frame a.

   {wbrp06.i  &command = update
              &fields = " interval "
              &frm = "a" }

   /* Begin batch quoting for batchable reports and postprocessing           */
   /* Of data entry values                                                   */
   if (c-application-mode <> 'web') or
      (c-web-request begins 'data')
   then do:

      bcdparm = "".                  /* if batch can be run */
      {mfquoter.i interval}
   end.  /* if data mode or not web */

   hide frame a.

   repeat:

      {gprun.i ""xkwobk01.p""} .
      dt = today.
      tm = string(time,"HH:MM:SS") .
      disp dt tm with frame b .
      down with frame b .
      pause interval no-message .
      {mfrpchk.i} 
   end.  

end. /* repeat */
{wbrp04.i &frame-spec = a}