/* xxshmta.i  -- Shipping Notes Maintenance */
/* REVISION: eb SP5 create 02/19/04 BY: *EAS033A3* Apple Tam */
/* SS - 091230.1  By: Roger Xiao */

form
   "SN Total:"    at 1
   total_ctn     colon 18
   total_netwt   colon 43
   total_qty     colon 65
   total_grosswt colon 18
   total_cbm     colon 43
with frame aa no-box side-labels width 80 row 20.
/* SET EXTERNAL LABELS */
setFrameLabels(frame aa:handle).


FORM 
    xxsq_sq_nbr     label "SQ"
    xxsq_plt_nbr    label "Plt"
    xxsq_so_order   label "SO"
/* SS - 091230.1 - B */
    xxsq_so_line
/* SS - 091230.1 - E */
    xxsq_shipto     label "Ship-To"
    xxsq_part       label "Item"
    xxsq_qty_open   label "QTY Open"
    xxsq_part_um    label "UM"
    xxsq_qty_ship   label "QTY To Ship"
with frame d2 3 down width 80 .
/* SET EXTERNAL LABELS */
setFrameLabels(frame d2:handle).

form
   sqnbr    colon 3   label "SQ"
   pltnbr   colon 12  label "Plt"
   sonbr    colon 20  label "SO"
/* SS - 091230.1 - B */
   soline   colon 33  label "Ln"
   part3    colon 43  label "Item"
   desc1      format "x(13)" no-label    
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
   forw     colon 10
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
with frame e attr-space side-labels width 80.
/* SET EXTERNAL LABELS */
setFrameLabels(frame e:handle).

form
   xxsnp_shipto      label "Ship-To"
   xxsnp_nbr         label "Plt no."
   xxsnp_ext_grosswt label "Ext Gross Wt"
   xxsnp_length      label "Length"
   xxsnp_height      label "Height"
   xxsnp_width       label "Width"
   xxsnp_cbm         label "CBM"
with frame f 5 down width 80 .
/* SET EXTERNAL LABELS */
setFrameLabels(frame f:handle).

form
   shipto3      colon 8 label "Ship To"
   nbr3         colon 36 label "Pallet No."
   ext_grosswt3 colon 12 label "Ex.Gross Wt"
   length3      label "(L*H*W)"
   "*"
   height3      no-label 
   "*"
   width3       no-label 
   "="
   cbm3         no-label 
   "CBM"
with frame g attr-space side-labels width 80.
/* SET EXTERNAL LABELS */
setFrameLabels(frame g:handle).
