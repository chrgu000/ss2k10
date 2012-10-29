/* GUI CONVERTED from rebkfli1.p (converter v1.78) Sat Mar 21 05:36:00 2009 */
/* rebkfli1.p - REPETITIVE                                                    */
/* Copyright 1986-2009 QAD Inc., Carpinteria, CA, USA.                  */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* REVISION: 7.3      LAST MODIFIED: 10/31/94   BY: WUG *GN77*                */
/* REVISION: 7.3      LAST MODIFIED: 06/06/96   BY: jym *G1XJ*                */
/* REVISION: 8.7      LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane          */
/* REVISION: 8.7      LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan         */
/* REVISION: 8.6E     LAST MODIFIED: 09/28/98   BY: *J310* Santhosh Nair      */
/* REVISION: 9.1      LAST MODIFIED: 10/25/99   BY: *N002* Bill Gates         */
/* REVISION: 9.1      LAST MODIFIED: 11/17/99   BY: *N04H* Vivek Gogte        */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane   */
/* REVISION: 9.1      LAST MODIFIED: 08/12/00   BY: *N0KP* myb                */
/* Old ECO marker removed, but no ECO header exists *F0PN*               */
/* Revision: 1.5.3.5  BY: Hualin Zhong          DATE: 05/30/01 ECO: *N0YY*    */
/* Revision: 1.5.3.9  BY: Paul Donnelly (SB)    DATE: 06/28/03 ECO: *Q00K*    */
/* Revision: 1.5.3.10      BY: Ken Casey DATE: 02/19/04 ECO: *N2GM* */
/* Revision: 1.5.3.11      BY: Max Iles DATE: 09/30/04 ECO: *N2XQ* */
/* Revision: 1.5.3.12      BY: Matthew Lee  DATE: 01/26/05 ECO: *P356* */
/* $Revision: 1.5.3.12.1.1 $     BY: Denzel Paul  DATE: 03/17/09 ECO: *Q2KV* */
/*-Revision end---------------------------------------------------------------*/
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/* BACKFLUSH TRANSACTION SUBPROGRAM - GET 2ND FRAME DATA FROM USER            */
/*V8:ConvertMode=Maintenance                                                  */
{mfdeclre.i}
{gplabel.i} /* EXTERNAL LABEL INCLUDE */

define input parameter cumwo_lot as character.
define input parameter cumwo_op as integer.
define output parameter undo_stat like mfc_logical no-undo.

define shared variable rsn_codes as character extent 10.
define shared variable quantities like wr_qty_comp extent 10.
define shared variable scrap_rsn_codes as character extent 10.
define shared variable scrap_quantities like wr_qty_comp extent 10.
define shared variable reject_rsn_codes as character extent 10.
define shared variable reject_quantities like wr_qty_comp extent 10.
define shared variable h_wiplottrace_procs as handle no-undo.
define shared variable h_wiplottrace_funcs as handle no-undo.
define variable message_text as character format "x(30)".

{xxretrform.i}
define variable i as integer.
define variable j as integer.
define variable date_change as integer.
define variable elapse as decimal format ">>>>>>>>.999".
define variable undostat like mfc_logical no-undo.
define variable first_op as log.
define variable new_conv like conv.
{wlfnc.i} /*FUNCTION FORWARD DECLARATIONS*/
{wlcon.i}

find wo_mstr  where wo_mstr.wo_domain = global_domain and  wo_lot = cumwo_lot
no-lock.

find last wr_route  where wr_route.wr_domain = global_domain and  wr_lot =
cumwo_lot and wr_op < cumwo_op
   no-lock no-error.
first_op = not available wr_route.

undo_stat = yes.

do with frame bkfl1 on error undo, retry:
/*GUI*/ if global-beam-me-up then undo, leave.

   {regetwcm.i &framename=bkfl1}

   /* THIS PATCH OF CODE HAS BEEN ADDED INORDER TO ENSURE THAT     */
   /* FURTHER PROCESSING DOES NOT HAPPEN IF THE WORKCENTER/MACHINE */
   /*  VALIDATION IN THE .i ABOVE FAILS IN THE BATCHRUN MODE       */
   if undo_stat
   then
      undo, leave.

   do with frame bkfl1 on error undo, retry:
/*GUI*/ if global-beam-me-up then undo, leave.

      set
         dept
         qty_proc
         um
         conv
         qty_scrap
         scrap_rsn_code
            when (not (is_wiplottrace_enabled() and
                       is_operation_queue_lot_controlled(cumwo_lot, op,
                                                         OUTPUT_QUEUE)))
         outque_multi_entry
            when (not (is_wiplottrace_enabled() and
                       is_operation_queue_lot_controlled(cumwo_lot, op,
                                                         OUTPUT_QUEUE)))
         qty_rjct
         rjct_rsn_code
            when (not (is_wiplottrace_enabled() and
                       is_operation_queue_lot_controlled(cumwo_lot, op,
                                                         REJECT_QUEUE)))
         rejque_multi_entry
            when (not (is_wiplottrace_enabled() and
                       is_operation_queue_lot_controlled(cumwo_lot, op,
                                                         REJECT_QUEUE)))
         to_op
            when (not first_op)
         mod_issrc
         move_next_op
         act_run_hrs
         earn_code
         editing:
         global_lot = cumwo_lot.

         {gpbrparm.i &browse=gplu223.p &parm=c-brparm1
                     &val=getTermLabel(""REJECT"",8)}

         {gpbrparm.i &browse=gpbr223.p &parm=c-brparm1
                     &val=getTermLabel(""REJECT"",8)}

         if frame-field = "dept" then do:
            {mfnp05.i dpt_mstr dpt_dept  " dpt_mstr.dpt_domain = global_domain
            and yes "  dpt_dept "input frame bkfl1 dept"}

            if recno <> ? then
               display
                  dpt_dept @ dept
                  dpt_desc.
         end.
         else if frame-field = "earn_code" then do:
            {mfnp05.i ea_mstr ea_earn  " ea_mstr.ea_domain = global_domain and
            yes "  ea_earn "input frame bkfl1 earn_code"}

            if recno <> ? then
               display
                  ea_earn @ earn_code
                  ea_desc.
         end.
         else if frame-field = "rjct_rsn_code" then do:
            {mfnp05.i rsn_ref rsn_type " rsn_ref.rsn_domain = global_domain and
            rsn_type  = ""reject""" rsn_code
               "input frame bkfl1 rjct_rsn_code"}

            if recno <> ? then
                display rsn_code @ rjct_rsn_code.
         end.
         else if frame-field = "scrap_rsn_code" then do:
            {mfnp05.i rsn_ref rsn_type " rsn_ref.rsn_domain = global_domain and
            rsn_type  = ""scrap""" rsn_code
               "input frame bkfl1 scrap_rsn_code"}

            if recno <> ? then
               display rsn_code @ scrap_rsn_code.
         end.
         else if frame-field = "to_op" then do:
            {mfnp05.i wr_route wr_lot
               " wr_route.wr_domain = global_domain and wr_lot  = cumwo_lot and
               wr_op <= cumwo_op"
               wr_op "input frame bkfl1 to_op"}

            if recno <> ? then do:
               display wr_op @ to_op.
            end.
         end.
         else do:
            ststatus = stline[3].
            status input ststatus.
            readkey.
            apply lastkey.
         end.
      end.

      find dpt_mstr  where dpt_mstr.dpt_domain = global_domain and  dpt_dept =
      dept no-lock no-error.

      if not available dpt_mstr then do:
         next-prompt dept.
         {pxmsg.i &MSGNUM=532 &ERRORLEVEL=3}
         undo, retry.
      end.

      display dpt_desc.

      find pt_mstr  where pt_mstr.pt_domain = global_domain and  pt_part = part
      no-lock.

      if um <> pt_um then do:
         {gprun.i ""gpumcnv.p"" "(input  um,
                                  input  pt_um,
                                  input  part,
                                  output new_conv)"}
/*GUI*/ if global-beam-me-up then undo, leave.


         if new_conv = ? then do:
            {pxmsg.i &MSGNUM=33 &ERRORLEVEL=2}
         end.
         else do:
            if not frame bkfl1 conv entered then do:
               conv = new_conv.
               display conv.
            end.
         end.
      end.

      if earn_code > "" then do:
         find ea_mstr  where ea_mstr.ea_domain = global_domain and  ea_earn =
         earn_code no-lock no-error.

         if not available ea_mstr then do:
            {pxmsg.i &MSGNUM=4025 &ERRORLEVEL=3}
            next-prompt earn_code.
            undo , retry.
         end.

         display ea_desc.
      end.
      else display " " @ ea_desc.

      find rsn_ref  where rsn_ref.rsn_domain = global_domain and  rsn_code =
      scrap_rsn_code
         and rsn_type = "scrap" no-lock no-error.

      if not available rsn_ref and scrap_rsn_code > "" then do:
         {pxmsg.i &MSGNUM=534 &ERRORLEVEL=2 &MSGARG1=scrap_rsn_code}
      end.

      find rsn_ref  where rsn_ref.rsn_domain = global_domain and  rsn_code =
      rjct_rsn_code
         and rsn_type = "reject" no-lock no-error.

      if not available rsn_ref and rjct_rsn_code > "" then do:
         {pxmsg.i &MSGNUM=534 &ERRORLEVEL=2 &MSGARG1=rjct_rsn_code}
      end.

      display start_run stop_run.

      if act_run_hrs = 0 then do on error undo, retry:
/*GUI*/ if global-beam-me-up then undo, leave.


         if {gpiswrap.i} then do:
        message_text=getTermLabel("TIME",30) + " (hhmmss)".
            {pxmsg.i &MSGTEXT=message_text &ERRORLEVEL=1}
         end.

         set start_run stop_run.

         if start_run > "" and stop_run = "" then do:
            {pxmsg.i &MSGNUM=5102 &ERRORLEVEL=3}
            undo, retry.
         end.

         {mfctime.i start_run stop_run}
         act_run_hrs = elapse.
         display act_run_hrs.
      end.
/*GUI*/ if global-beam-me-up then undo, leave.


      if not first_op then do:
         find wr_route  where wr_route.wr_domain = global_domain and  wr_lot =
         cumwo_lot and wr_op = to_op
            no-lock no-error.

         if not available wr_route then do:
            {pxmsg.i &MSGNUM=106 &ERRORLEVEL=3}
            next-prompt to_op.
            undo, retry.
         end.

         if to_op > op then do:
            {pxmsg.i &MSGNUM=5110 &ERRORLEVEL=3}
            next-prompt to_op.
            undo, retry.
         end.
      end.

      /* SCRAP OR REJECT WHEN MOVING TO FGI  IS  NOT  ALLOWED   */
      /* BECAUSE  THE  RECEIPT DATA INPUT SCREEN IS THE LAST TO */
      /* DISPLAY AND THAT DATA IS USED TO BUILD THE BKFL OUTPUT */
      /* WIP  LOTS BEHIND THE SCENES.  SINCE NO BKFL OUTPUT WIP */
      /* LOTS YET, THERE IS NO WAY TO VALIDATE  WHAT  IS  BEING */
      /* REJECTED OR SCRAPPED.                                  */

      if is_wiplottrace_enabled() and
         is_operation_queue_lot_controlled(cumwo_lot, op, OUTPUT_QUEUE) then do:
         if is_last_operation(cumwo_lot, op)
            and move_next_op
            and (qty_rjct <> 0 or qty_scrap <> 0) then do:
            {pxmsg.i &MSGNUM=8428 &ERRORLEVEL=3}
            /* RJCT/SCRAP NOT ALLOWED WHEN MOVING FINISHED
            ITEM TO INVENTORY */
            undo, retry.
         end.
      end.

      if rejque_multi_entry then do:
         do i = 1 to 10:
            rsn_codes[i] = reject_rsn_codes[i].
            quantities[i] = reject_quantities[i].
         end.

         /* Identify context for QXtend */
         {gpcontxt.i
            &STACKFRAG = 'resrqrin,rebkfli1,rebkfl'
            &FRAME = 'q' &CONTEXT = 'REJECT'}

         {gprun.i ""resrqrin.p"" "(input  ""reject"",
                                   input  getFrameTitle(""REJECT"",8),
                                   output undostat)"}
/*GUI*/ if global-beam-me-up then undo, leave.


         /* Clear context for QXtend */
         {gpcontxt.i
            &STACKFRAG = 'resrqrin,rebkfli1,rebkfl'
            &FRAME = 'q'}

         if undostat then undo, retry.
         qty_rjct = 0.

         do i = 1 to 10:
            assign
               reject_rsn_codes[i]  = rsn_codes[i]
               reject_quantities[i] = quantities[i]
               qty_rjct             = qty_rjct + quantities[i].
         end.

         display qty_rjct.
      end.

      if outque_multi_entry then do:
         do i = 1 to 10:
            assign
               rsn_codes[i] = scrap_rsn_codes[i]
               quantities[i] = scrap_quantities[i].
         end.

         /* Identify context for QXtend */
         {gpcontxt.i
            &STACKFRAG = 'resrqrin,rebkfli1,rebkfl'
            &FRAME = 'q' &CONTEXT = 'SCRAP'}

         {gprun.i ""resrqrin.p"" "(input  ""scrap"",
                                   input  getFrameTitle(""SCRAP"",8),
                                   output undostat)"}
/*GUI*/ if global-beam-me-up then undo, leave.


         /* Clear context for QXtend */
         {gpcontxt.i
            &STACKFRAG = 'resrqrin,rebkfli1,rebkfl'
            &FRAME = 'q'}

         if undostat then undo, retry.
         qty_scrap = 0.

         do i = 1 to 10:
            assign
               scrap_rsn_codes[i]  = rsn_codes[i]
               scrap_quantities[i] = quantities[i]
               qty_scrap           = qty_scrap + quantities[i].
         end.

         display qty_scrap.
      end.

      if (qty_proc >= 0 and qty_rjct + qty_scrap > qty_proc) or
         (qty_proc < 0 and qty_rjct + qty_scrap < qty_proc) then do:
         {pxmsg.i &MSGNUM=5108 &ERRORLEVEL=3}
         bell.
         next-prompt qty_proc.
         undo, retry.
      end.
      if (qty_proc >= 0 and qty_scrap >= 0 and qty_rjct >= 0) or
         (qty_proc <= 0 and qty_scrap <= 0 and qty_rjct <= 0) then .
      else do:
         /* PROCESS, SCRAP AND REJECT QUANTITIES MUST HAVE SAME SIGN*/
         {pxmsg.i &MSGNUM=1347 &ERRORLEVEL=3}
         next-prompt qty_proc.
         undo, retry.
      end.
   end.
/*GUI*/ if global-beam-me-up then undo, leave.
  /* do with frame bkfl1 */

   undo_stat = no.
end.
/*GUI*/ if global-beam-me-up then undo, leave.

