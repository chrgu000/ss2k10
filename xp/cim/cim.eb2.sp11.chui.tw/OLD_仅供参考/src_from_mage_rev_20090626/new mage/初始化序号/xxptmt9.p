/* xxptmt1.p - only part number  sale price    ****************/
/* $Revision: 1 BY: mage      DATE: 11/29/04  ECO: *pak*  */


/* DISPLAY TITLE */
{mfdtitle.i "2+ "}

define variable del-yn like mfc_logical initial no.
define variable fieldlen as integer initial 0 no-undo.

define variable fieldname like code_fldname no-undo.
define variable batchdelete as character format "x(1)" no-undo.

{gpfieldv.i}      /* var defs for gpfield.i */

/* DISPLAY SELECTION FORM */
form
   pt_part        colon 25
   pt_desc1       colon 25
   pt_desc2       colon 25  skip(1)
   pt__chr07 format "x(8)"      colon 25 label "機身序號"
   pt__chr08 format "x(8)"      colon 25 label "紙箱序號"
   pt__chr09 format "x(8)"      colon 25 label "卡板序號"

with frame a side-labels width 80 attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

/* DISPLAY */
view frame a.

mainloop:
repeat with frame a:

   /* Initialize delete flag before each display of frame */
   batchdelete = "".

   if input pt_part <> ""   then
      find pt_mstr where pt_part = input pt_part
                          no-lock no-error.
   if available pt_mstr then
      recno = recid(pt_mstr).

   prompt-for pt_part
   editing:

      /* FIND NEXT/PREVIOUS RECORD */
      {mfnp05.i pt_mstr pt_part "pt_part = pt_part"  pt_part   "input pt_part"}

      if recno <> ? then
         display
            pt_part
            pt_desc1
			pt_desc2
			pt__chr07
			pt__chr08
			pt__chr09
			  with frame a.

   end. /* editing: */

find first pt_mstr where pt_part = input pt_part   no-error.
if available pt_mstr then display pt_part pt_desc1 pt_desc2 pt__chr07   with frame a.
else do:
message "Part NUM is not !!!" view-as alert-box.
prompt-for pt_part with frame a.
undo, retry.
end.

 
   update
      pt__chr07
      pt__chr08 
      pt__chr09 with frame a .
  
end. /* prompt-for code_fldname */

status input.
