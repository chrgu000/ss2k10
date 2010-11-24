/* xxdcsmt.p - dcsdata Mantence                                              */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                       */
/* All rights reserved worldwide.  This is an unpublished work.              */
/*F0PN*/ /*V8:ConvertMode=Maintenance                                        */
/*K1Q4*/ /*V8:RunMode=Character,Windows                                      */
/* REVISION: 2.0      LAST MODIFIED: 02/02/87   BY: EMB *A9*                 */
/* REVISION: 2.0      LAST MODIFIED: 03/12/87   BY: EMB *A41*                */
/* REVISION: 8.6      LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan        */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00 BY: *N08T* Annasaheb Rahane    */
/* REVISION: 9.1      LAST MODIFIED: 08/13/00 BY: *N0KR* myb                 */

/* DISPLAY TITLE */
{mfdtitle.i "100826.1"}
{cxcustom.i "xxdcsmt.p"}

define variable del-yn  like mfc_logical initial no.
define variable dptdesc like dpt_desc.
define variable eledesc as   character format "x(12)" label "说明".
/* DISPLAY SELECTION FORM */
form
   xxdcs_period       colon 25 label "期间"
   xxdcs_element      colon 25 label "分配因素" eledesc colon 48
   xxdcs_dept         colon 25 label "分配范围" dptdesc skip(1)
   xxdcs_amt          colon 25 label "分配金额"
with frame a side-labels width 80 attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

/* DISPLAY */
view frame a.
repeat with frame a:
   prompt-for xxdcs_period xxdcs_element xxdcs_dept editing:
     if frame-field = "xxdcs_dept" then do:
      {mfnp.i dpt_mstr xxdcs_dept dpt_dept
               xxdcs_dept dpt_dept dpt_dept}
     if recno <> ? then
         display dpt_dept @ xxdcs_dept dpt_desc @ dptdesc.
     end.
     else if frame-field = "xxdcs_element" then do:
        {mfnp01.i code_mstr xxdcs_element code_value
                  "'xxdcs_element' and code__qadc01 = ''" code_fldname code_fldval}
        IF recno<> ? THEN DO:
            DISP code_value @ xxdcs_element code_cmmt @ eledesc WITH FRAME a.
        END.
     end.
     else do:
        /* FIND NEXT/PREVIOUS RECORD */
        {mfnp.i xxdcs_mstr xxdcs_period xxdcs_period xxdcs_period
                xxdcs_period xxdcs_period}
        if recno <> ? then do:
          display xxdcs_period xxdcs_element xxdcs_dept xxdcs_amt.
        end.
        find xxdcs_mstr using xxdcs_period where
             xxdcs_period = input xxdcs_period and
             xxdcs_element = input xxdcs_element and
             xxdcs_dept = input xxdcs_dept
             no-error.
        if avail xxdcs_mstr then do:
           find first dpt_mstr no-lock where dpt_dept = xxdcs_dept no-error.
           if avail dpt_mstr then do:
              assign dptdesc:screen-value = dpt_desc.
           end.
           else do:
              assign dptdesc:screen-value = "".
           end.
           find first code_mstr no-lock where code_fldname ="xxdcs_element" and
                      code_value = xxdcs_element no-error.
           if avail code_mstr then do:
              assign eledesc:screen-value = code_cmmt.
           end.
           else do:
              assign eledesc:screen-value = "".
           end.
        end.
     end.
   end.

   if input xxdcs_perio = "" then do:
      {pxmsg.i &MSGTEXT=""分配期间不可以为空"" &ERRORLEVEL=3}
      /* BLANK INVENTORY MOVEMENT CODE NOT ALLOWED */
      undo, retry.
   end.
   if input xxdcs_element = "" or
      not can-find (first code_mstr no-lock where code_fldname = "xxdcs_element"
                      and code__qadc01 = "" and code_value = input xxdcs_element)
          then do:
      {pxmsg.i &MSGTEXT=""分配因素输入错误"" &ERRORLEVEL=3}
      /* BLANK INVENTORY MOVEMENT CODE NOT ALLOWED */
      undo, retry.
   end.
   if input xxdcs_dept = "" or
      not can-find(first dpt_mstr no-lock where dpt_dept = input xxdcs_dept)
      then do:
      {pxmsg.i &MSGTEXT=""分配部门输入错误"" &ERRORLEVEL=3}
      /* BLANK INVENTORY MOVEMENT CODE NOT ALLOWED */
      undo, retry.
   end.


   /* ADD/MOD/DELETE  */
   find xxdcs_mstr using xxdcs_period where
        xxdcs_period = input xxdcs_period and
        xxdcs_element = input xxdcs_element and
        xxdcs_dept = input xxdcs_dept no-error.
   if not available xxdcs_mstr then do:
      {mfmsg.i 1 1}
      create xxdcs_mstr.
      assign xxdcs_period xxdcs_element xxdcs_dept.
   end.
   recno = recid(xxdcs_mstr).

   display xxdcs_period xxdcs_element xxdcs_dept.

   ststatus = stline[2].
   status input ststatus.
   del-yn = no.

   do on error undo, retry:
      set xxdcs_amt go-on("F5" "CTRL-D" ).

      /* DELETE */
      if lastkey = keycode("F5") or lastkey = keycode("CTRL-D")
      then do:
         del-yn = yes.
         {mfmsg01.i 11 1 del-yn}
         if not del-yn then undo, retry.
         delete xxdcs_mstr.
         clear frame a.
         del-yn = no.
      end.
   end.
end.
status input.
