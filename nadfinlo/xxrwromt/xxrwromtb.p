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

find first ro_det where recid(ro_det) = ro_recid exclusive-lock.
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
         if int(myii1) = 0 then myii1 = "".
         int(entry(2,ro_vend,"/"))  no-error.
         if not error-status:error then do:
           myii2 = entry(2,ro_vend,"/").
           if int(myii2) = 0 then myii2 = "".
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
   myii1               colon 25
   myii2               colon 65
   ro_wipmtl_part      colon 25
   ro__dec01           colon 60
with frame bb width 80 attr-space side-labels overlay row 10.

/* SET EXTERNAL LABELS */
setFrameLabels(frame bb:handle).

ststatus = stline[1].
status input ststatus.
   update
      ro_tool
      myii1 myii2
      ro_wipmtl_part
      ro__dec01
   with frame bb.
   find first pt_mstr no-lock where pt_part = ro_tool no-error.
   if not available pt_mstr then do:
      {mfmsg.i 16 3}
      display ro_tool with frame bb.
      next-prompt ro_tool with frame bb.
      undo , retry.
   end.
   if myii1 > myii2 then do:
     message "����������<=ģǻ��".
     undo,retry.
   end.
ro_vend = string(myii1) + "/" + string(myii2).

/*
/* VALIDATE WIP PART OF THE ROUTING OPERATION */
{pxrun.i &PROC = 'validateWIPMaterial' &PROGRAM = 'rwroxr.p'
         &PARAM="(input ro_wipmtl_part)"
         &NOAPPERROR = True
         &CATCHERROR = True }
*/