/* xxshadmtc.i  -- Shipping Advise Maintenance */
/* REVISION: eb SP5 create 04/21/04 BY: *EAS036A* Apple Tam */
/* SS - 091230.1  By: Roger Xiao */

form
   sqnbr    colon 3   label "SQ"
   pltnbr   colon 12  label "Plt"
   sonbr    colon 20  label "SO"
/* SS - 091230.1 - B */
   soline   colon 33  label "Ln"
   part3    colon 43  label "Item"
   desc1     format "x(13)" no-label    
/* SS - 091230.1 - E */
/* SS - 091230.1 - B 
   part3    colon 35  label "Item"
   desc1    colon 57  format "x(21)" no-label    
   SS - 091230.1 - E */
   destin   colon 12              
   consign  colon 39              
   loc      colon 50
   desc2    colon 58 format "x(20)" no-label
   type     colon 5
   "(Carton/Pallet)" at 9
   ship_via colon 36
   "(Air/Sea)"  at 40
   po1      colon 60 format "x(20)"
   method   colon 7
   modesc   colon 18 format "x(59)" no-label
   forw     colon 10 format "x(28)"
   ref      
with frame a2 attr-space side-labels width 80.
/* SET EXTERNAL LABELS */
setFrameLabels(frame a2:handle).

form
  ctn_line    colon 3 label "LN"
  ctnnbr_fm   label "CTN # Fm"
  ctnnbr_to   label "To"
  ctn_qty     colon 55
  qtyper      colon 22
  ext_qty     colon 55
  netwt       colon 22
  "KG"
  ext_netwt   colon 55
  grosswt     colon 22
  "KG"
  ext_grosswt colon 55
  "CBM / CTN: (L*H*W)" at 13
  length      /*colon 22*/ no-label 
  "*"
  height      no-label
  "*"
  width       no-label
  "=="
  cbm         no-label
  "CBM"
  p_ext_grosswt colon 14
  "(L*H*W)"
  p_length      no-label 
  "*"
  p_height      no-label
  "*"
  p_width       no-label
  "="
  p_cbm         no-label
  "CBM"

with frame e attr-space side-labels width 80.
/* SET EXTERNAL LABELS */
setFrameLabels(frame e:handle).

