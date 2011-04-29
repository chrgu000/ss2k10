/* xxshadmtp.i  -- Shipping Advise Maintenance */
/* REVISION: eb SP5 create 04/21/04 BY: *EAS036A* Apple Tam */

form
   consignee2[1]  at 1
   consignee2[2]  at 1
   consignee2[3]  at 1
   consignee2[4]  at 1
   consignee2[5]  at 1
with frame p1 no-labels width 40 title "Consignee".
/* SET EXTERNAL LABELS */
setFrameLabels(frame p1:handle).
form
   notify2[1]     at 1
   notify2[2]     at 1
   notify2[3]     at 1
   notify2[4]     at 1
   notify2[5]     at 1
with frame p2 no-labels width 40 col 41 title "Notify".
/* SET EXTERNAL LABELS */
setFrameLabels(frame p2:handle).


FORM 
   consignee  colon 11 label "Consignee"
   notify     label "Notify"
   etdhk      label "ETD HK"
   ex_date    label "EX-FACT DATE"       /* micho */   
   eta        colon 5  label "ETA"
   eta_date   no-label
   consig     label "Consig"
   dc-loc     label "DC/Main"
   desc_line1 colon 26 label "Vessel Name/Housing AWB "
   desc_line2 colon 26 label "B/L No. / Master AWB    "
   desc_line3 colon 26 label "Country of Origin       "
   desc_line4 colon 26 label "Flight No.              "
   forwarder  colon 11 label "Forwarder"  format "x(28)" 
   container  label "Cont. No."  /*"Container No."*/
   method     colon 8 label "Method"
   method_desc  no-label    
with frame p3 side-labels width 80 .
    
