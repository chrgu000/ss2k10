/* xkrnrp01.p                     收货单打印                                 */

/* DISPLAY TITLE */

{mfdtitle.i "AO+ "}

define variable rnnbr as char.
DEFINE NEW SHARED VARIABLE xPrtRn as logic initial yes label "打印收货单".
DEFINE NEW SHARED VARIABLE xPrtKb as logic initial yes label "打印看板".

define new shared
workfile temp
    field temp_line like pod_line
    field temp_part like pod_part
    field temp_vend_part like pod_part
    field temp_desc like pt_desc1    
    field temp_um like pod_um
    field temp_uc like pt_ord_mult
    field temp_qty_rcvd like pod_qty_rcvd
    FIELD temp_site LIKE pod_site
    FIELD temp_loc LIKE pod_loc.


FORM /*GUI*/ 
    space(1)
    rnnbr      colon 25 label "收货单号"
    xPrtKb     colon 25 
with frame a side-labels width 80 attr-space .


/* DISPLAY */
view frame a.
mainloop:
repeat with frame a:
   update rnnbr xPrtKb
   with frame a.           
   
   setFrameLabels(frame a:handle).
   
   {mfselbpr.i "printer" 132}

   {gprun.i ""xkrnprt.p"" "(input rnnbr)" }
   {mfreset.i}

end.
