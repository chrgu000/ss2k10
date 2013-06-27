/* rwromta.p - ROUTING MAINTENANCE                                            */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.4.1.4 $                                                       */
/*                                                                            */
/* Logic to view and maintain the item related data for the routing operation */
/*                                                                            */
/* REVISION: 7.3      LAST MODIFIED: 10/31/94   BY: WUG *GN77*                */
/* REVISION: 7.3      LAST MODIFIED: 11/03/94   BY: WUG *GN98*                */
/* REVISION: 7.3      LAST MODIFIED: 07/02/96   BY: *G1Z5*  Russ Witt*        */
/* REVISION: 8.6      LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan         */
/* REVISION: 9.1      LAST MODIFIED: 11/17/99   BY: *N04H* Vivek Gogte        */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane   */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* $Revision: 1.4.1.4 $   LAST MODIFIED: 05/17/00   BY: *N0DP* Anup Pereira   */
/* REVISION: 9.1      LAST MODIFIED: 08/12/00   BY: *N0KP* myb                */
/*                                                                            */
/*V8:ConvertMode=Maintenance                                                  */

{mfdeclre.i}

/* EXTERNAL LABEL INCLUDE */
{gplabel.i}

{pxmaint.i}

define input parameter ro_recid as recid.

find ro_det where recid(ro_det) = ro_recid exclusive-lock.

/* lambert 20120905.1 */
define variable myii1 as character no-undo.
define variable myii2 as character no-undo.
define variable thf as logical no-undo .
define variable i as integer no-undo.
myii1 = "".
myii2 = "".
thf = no.
find first pt_mstr no-lock where pt_part = ro_routing 
       and pt_prod_line = "3700" no-error.
if avail pt_mstr then do:
  thf = true.
end.
thf = true.
if thf then do:
  if ro_vend <> "" then do:
     if index(ro_vend , "/") > 1 and index(ro_vend , "/") < length(ro_vend) then do:
       int(entry(1,ro_vend,"/"))  no-error.
       if not error-status:error then do:
         myii1 = entry(1,ro_vend,"/").
         int(entry(2,ro_vend,"/"))  no-error.
         if not error-status:error then do:
           myii2 = entry(2,ro_vend,"/").
         end.
       end.
     end.
  end.
  else do:
     assign myii1 = "" 
            myii2 = "".
  end.
end.
/* lambert 20120905.1 */

form
   ro_tool             colon 25    format "x(18)"
   ro__dec01           colon 60
   myii1               colon 25
   myii2               colon 60
   skip
   ro_wipmtl_part      colon 25
   ro_po_nbr           colon 25
   ro_mv_nxt_op        colon 65
   ro_po_line          colon 25
   ro_auto_lbr         colon 65
with frame b width 80 attr-space no-validate  side-labels overlay row 10.

/* SET EXTERNAL LABELS */
setFrameLabels(frame b:handle).

ststatus = stline[1].
status input ststatus.
if thf then do:
  update
    ro_tool
    ro__dec01
    myii1
    myii2
    ro_wipmtl_part
    ro_po_nbr
    ro_po_line
    ro_mv_nxt_op
    ro_auto_lbr
  with frame b.   
  if myii1 <> "" then do:
     DO i = 1 to length(myii1).
        If index("0987654321.", substring(myii1,i,1)) = 0 then do:
           {pxmsg.i &MSGNUM=4493 &MSGARG1=myii1 &ERRORLEVEL=3}
           next-prompt myii1 with frame b.
           undo,retry.
        end.
     end.
     if int(myii1) = 0 then do:
        {mfmsg.i 317 3}
         next-prompt myii1 with frame b.
         undo,retry.
     end.
  end.
  if myii2 <> "" then do:
     DO i = 1 to length(myii2).
        If index("0987654321.", substring(myii2,i,1)) = 0 then do:
           {pxmsg.i &MSGNUM=4493 &MSGARG1=myii2 &ERRORLEVEL=3}
           next-prompt myii2 with frame b.
           undo,retry.
        end.
     end.
     if int(myii2) = 0 then do:
        {mfmsg.i 317 3}
         next-prompt myii2 with frame b.
         undo,retry.
     end.
  end.
  if int(myii1) > int(myii2) then do:
    message "产出数必须<=模腔数".
    undo,retry.
  end.
  if myii1 <> "" and myii2 <> "" then 
     ro_vend = myii1 + "/" + myii2.
  else 
     ro_vend = "".
end.
else do:
  update
    /*  lambert 20120905.1
    ro_wipmtl_part
    lambert 20120905.1 */
    ro_po_nbr
    ro_po_line
    ro_mv_nxt_op
    ro_auto_lbr
  with frame b.
end.

/* VALIDATE WIP PART OF THE ROUTING OPERATION */
{pxrun.i &PROC = 'validateWIPMaterial' &PROGRAM = 'rwroxr.p'
         &PARAM="(input ro_wipmtl_part)"
         &NOAPPERROR = True
         &CATCHERROR = True }

/* VALIDATE PO AND LINE OF THE ROUTING OPERATION */
{pxrun.i &PROC = 'validateRoutingPO' &PROGRAM = 'rwroxr.p'
         &PARAM = "(input ro_po_nbr,
                    input ro_po_line)"
         &NOAPPERROR = True
         &CATCHERROR = True}
