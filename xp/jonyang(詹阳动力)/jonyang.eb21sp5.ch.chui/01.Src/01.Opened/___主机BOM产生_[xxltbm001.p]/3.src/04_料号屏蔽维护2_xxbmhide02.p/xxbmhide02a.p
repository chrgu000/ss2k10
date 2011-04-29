/* wowamta.p - WORK ORDER BILL MAINTENANCE                                    */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.12 $                                                          */
/*V8:ConvertMode=Maintenance                                                  */
/* REVISION: 8.5      LAST MODIFIED: 05/07/96   BY: *J0LS* Kieu Nguyen        */
/* REVISION: 8.5      LAST MODIFIED: 03/24/97   BY: *G2KT* Russ Witt          */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane          */
/* REVISION: 8.6E     LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan         */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan         */
/* REVISION: 9.1      LAST MODIFIED: 03/06/00   BY: *N05Q* Vincent Koh        */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane   */
/* REVISION: 9.1      LAST MODIFIED: 08/12/00   BY: *N0KC* myb                */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* Revision: 1.9        BY: Katie Hilbert        DATE: 04/01/01 ECO: *P008*   */
/* Revision: 1.10  BY: Jean Miller DATE: 05/17/02 ECO: *P05V* */
/* $Revision: 1.12 $ BY: Paul Donnelly (SB) DATE: 06/28/03 ECO: *Q00N* */
/*-Revision end---------------------------------------------------------------*/

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

{mfdeclre.i }
{gplabel.i} /* EXTERNAL LABEL INCLUDE */



define shared variable desc1 like pt_desc1.
define shared variable desc2 like pt_desc1.
define shared variable wodesc1 like pt_desc1.
define shared variable wodesc2 like pt_desc1.
define shared variable part like wo_part.
define shared variable nbr like wod_nbr.
define shared variable lot like wod_lot.
define shared variable status_name like wo_status format "x(12)".
define shared variable wod_recno as recid.
define shared variable undo_all like  mfc_logical initial no no-undo.

define shared variable v_yn as logical format "Yes/No".

define shared frame a.
   
form
   wo_nbr         colon 25
   wo_lot         colon 50
   part           colon 25
   wodesc1        no-label at 47 no-attr-space
   status_name    colon 25
   wodesc2        no-label at 47 no-attr-space
                  skip(1)
   wod_part       colon 25 label "Component Item"
   desc1          no-label at 47 no-attr-space
   wod_op         colon 25
   desc2          no-label at 47 no-attr-space
                  skip(1)
   wod_qty_req    colon 25
   wod_bom_qty    colon 55 label "Qty Per Unit"
   wod_qty_iss    colon 25
                  skip(1)
   v_yn           colon 25    label "主机BOM不显示"
                  skip(1)

with frame a side-labels width 80 attr-space.


/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

/* DISPLAY */
view frame a.

undo_all = yes.

mainloop:
do with frame a:

   ststatus = stline[1].
   status input ststatus.

   prompt-for wo_nbr wo_lot
   editing:

      if frame-field = "wo_nbr" then do:
         nbr = input wo_nbr.
         /* FIND NEXT/PREVIOUS RECORD */
         {mfnp.i wo_mstr wo_nbr  " wo_mstr.wo_domain = global_domain and wo_nbr
         "  wo_nbr wo_nbr wo_nbr}
      end.

      else if frame-field = "wo_lot" then do:
         /* FIND NEXT/PREVIOUS RECORD */
         if nbr = "" then do:
            {mfnp.i wo_mstr wo_lot  " wo_mstr.wo_domain = global_domain and
            wo_lot "  wo_lot wo_lot wo_lot}
         end.
         else do:
            {mfnp01.i wo_mstr wo_lot wo_lot nbr  " wo_mstr.wo_domain =
            global_domain and wo_nbr "  wo_nbr}
         end.
      end.

      else do:
         readkey.
         apply lastkey.
      end.

      if recno <> ? then do:

         assign
            part = ""
            wodesc1 = ""
            wodesc2 = ""
            status_name = ""
            part = wo_part.

         {mfwostat.i status_name wo_status}

         find pt_mstr  where pt_mstr.pt_domain = global_domain and  pt_part =
         wo_part no-lock no-error.
         if available pt_mstr then
         assign
             wodesc1 = pt_desc1
             wodesc2 = pt_desc2.

         find first wod_det no-lock  where wod_det.wod_domain = global_domain
         and  wod_nbr = wo_nbr
                                       and wod_lot = wo_lot
         no-error.

         assign
            desc1 = ""
            desc2 = "".

         if not available wod_det then clear frame a.

         display wo_nbr wo_lot part wodesc1 wodesc2 status_name.

         if available wod_det then do:

            find pt_mstr  where pt_mstr.pt_domain = global_domain and  pt_part
            = wod_part no-lock no-error.

            if available pt_mstr then
            assign
               desc1 = pt_desc1
               desc2 = pt_desc2.

            v_yn =  if wod__chr02 = "Y" then yes else no.
            display
               wod_part
               wod_op
               desc1 desc2 
               wod_qty_req
               wod_bom_qty 
               wod_qty_iss
               v_yn 
               with frame a.
         end. /* IF AVAILABLE WO_DET */

      end. /* IF RECNO <> ? */

   end. /* PROMPT-FOR...EDITING */

   if input wo_nbr = "" and input wo_lot = "" then undo, retry.
   assign
      nbr = input wo_nbr
      lot = input wo_lot.

   if nbr <> "" and lot <> "" then
      find wo_mstr  where wo_mstr.wo_domain = global_domain and  wo_nbr = nbr
      and wo_lot = lot no-lock no-error.
   if not available wo_mstr then
      if nbr = "" and lot <> "" then
         find wo_mstr  where wo_mstr.wo_domain = global_domain and  wo_lot =
         lot no-lock no-error.
   if not available wo_mstr then
      if nbr <> "" and lot = "" then
         find first wo_mstr  where wo_mstr.wo_domain = global_domain and
         wo_nbr = nbr no-lock no-error.
   if nbr <> "" or lot <> "" then
      if not available wo_mstr then do:
         {pxmsg.i &MSGNUM=510 &ERRORLEVEL=3} /*  WORK ORDER DOES NOT EXIST.*/
         next-prompt wo_nbr.
         if nbr = "" then next-prompt wo_lot.
         undo, retry.
      end.

   /* SKIP WORK ORDERS CREATED BY CALL ACTIVITY RECORDING */
   if wo_fsm_type = "FSM-RO" then do:
      {pxmsg.i &MSGNUM=7492 &ERRORLEVEL=3}    /* FIELD SERVICE CONTROLLED */
      next-prompt wo_nbr.
      if nbr = "" then next-prompt wo_lot.
      undo, retry.
   end.

   /* SKIP WORK ORDERS CREATED FOR PROJECT ACTIVITY RECORDING */
   if wo_fsm_type = "PRM" then do:
      {pxmsg.i &MSGNUM=3426 &ERRORLEVEL=3}    /* CONTROLLED BY PRM MODULE */
      next-prompt wo_nbr.
      if nbr = "" then next-prompt wo_lot.
      undo, retry.
   end.

   {gprun.i ""gpsiver.p"" "(input wo_site, input ?, output return_int)"}
   if return_int = 0 then do:
      /* USER DOES NOT HAVE ACCESS TO SITE XXXX */
      {pxmsg.i &MSGNUM=2710 &ERRORLEVEL=3 &MSGARG1=wo_site}
      undo , retry.
   end.

   assign
      part = ""
      status_name = ""
      wodesc1 = ""
      wodesc2 = "".

   if available wo_mstr then do:
      assign
         lot = wo_lot
         part = wo_part
         nbr = wo_nbr.
      find pt_mstr  where pt_mstr.pt_domain = global_domain and  pt_part =
      wo_part no-lock no-error.
      if available pt_mstr then
      assign
         wodesc1 = pt_desc1
         wodesc2 = pt_desc2.
      {mfwostat.i status_name wo_status}
   end.

   display wo_nbr wo_lot part wodesc1 wodesc2 status_name.

   find first wod_det no-lock  where wod_det.wod_domain = global_domain and
   wod_nbr = wo_nbr
      and wod_lot = wo_lot
   no-error.

   assign
      desc1 = ""
      desc2 = "".

   if available wod_det then do:

      find pt_mstr  where pt_mstr.pt_domain = global_domain and  pt_part =
      wod_part no-lock no-error.

      if available pt_mstr then
      assign
         desc1 = pt_desc1
         desc2 = pt_desc2.

      v_yn =  if wod__chr02 = "Y" then yes else no.
      display
        wod_part
        wod_op
        desc1 desc2 
        wod_qty_req
        wod_bom_qty 
        wod_qty_iss
        v_yn 
      with frame a.

   end.

   if index("1234",wo_joint_type) <> 0 then do:
      /* WORK ORDER BILLS & ROUTINGS CANNOT EXIST FOR CO-BY-PRODUCTS */
      {pxmsg.i &MSGNUM=6526 &ERRORLEVEL=3}
      undo, retry.
   end.

   if index("R,C",wo_status) = 0
   then do:
        message "错误:仅维护限R,C状态工单".
        undo,retry.
   end.


   undo_all = no.
end.
