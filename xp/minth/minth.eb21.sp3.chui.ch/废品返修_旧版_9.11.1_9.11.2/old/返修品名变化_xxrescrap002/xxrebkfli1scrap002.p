/* rebkfli1.p - REPETITIVE                                                    */
/* Copyright 1986-2005 QAD Inc., Carpinteria, CA, USA.                  */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.5.3.12 $                                                      */
/*V8:ConvertMode=Maintenance                                                  */
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
/* $Revision: 1.5.3.12 $     BY: Matthew Lee  DATE: 01/26/05 ECO: *P356* */
/*-Revision end---------------------------------------------------------------*/

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/* BACKFLUSH TRANSACTION SUBPROGRAM - GET 2ND FRAME DATA FROM USER            */

{mfdeclre.i}
{gplabel.i} /* EXTERNAL LABEL INCLUDE */

define input parameter cumwo_lot as character.
define input parameter cumwo_op as integer.
define output parameter undo_stat like mfc_logical no-undo.

/************start tx01************
define shared variable rsn_codes as character extent 10.
define shared variable quantities like wr_qty_comp extent 10.
define shared variable scrap_rsn_codes as character extent 10.
define shared variable scrap_quantities like wr_qty_comp extent 10.
define shared variable reject_rsn_codes as character extent 10.
define shared variable reject_quantities like wr_qty_comp extent 10.
************end tx01************/
define shared variable h_wiplottrace_procs as handle no-undo.
define shared variable h_wiplottrace_funcs as handle no-undo.
define variable message_text as character format "x(30)".
/*apple*/ define shared variable tot-qty like rps_qty_req.
/*apple*/ define variable qty_yn as logical initial yes.

{xxretrforscrap002.i}
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

do with frame d on error undo, retry:
/************ move ****************
   {regetwcm.i &framename=bkfl1}
************ move ****************/
/*********** start move **********/
   find wc_mstr where wc_mstr.wc_domain = global_domain 
      and wc_wkctr = wkctr and wc_mch = mch no-lock no-error.

   if available wc_mstr then
   find dpt_mstr no-lock where dpt_mstr.dpt_domain = global_domain 
      and dpt_dept = wc_dept no-error.

   if available dpt_mstr then do:
      dept = dpt_dept.
   end.
/*********** end move ************/

/**************** start tx01****************
   do with frame d on error undo, retry:
      set
        qty_proc          
        act_run_hrs       
        earn_code         
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
        act_setup_hrs     
        setup_rsn         
        act_multi_entry   
        act_setup_hrs20   
        down_rsn_code     
        stop_multi_entry  
        non_prod_hrs      
        rsn               
        prod_multi_entry  
      editing:
         global_lot = cumwo_lot.

         {gpbrparm.i &browse=gplu223.p &parm=c-brparm1
                     &val=getTermLabel(""REJECT"",8)}

         {gpbrparm.i &browse=gpbr223.p &parm=c-brparm1
                     &val=getTermLabel(""REJECT"",8)}

         if frame-field = "earn_code" then do:
            {mfnp05.i ea_mstr ea_earn  " ea_mstr.ea_domain = global_domain and
            yes "  ea_earn "input frame d earn_code"}

            if recno <> ? then
               display
                  ea_earn @ earn_code.
         end.
         else if frame-field = "scrap_rsn_code" then do:
            {mfnp05.i rsn_ref rsn_type " rsn_ref.rsn_domain = global_domain and
            rsn_type  = ""scrap""" rsn_code
               "input frame d scrap_rsn_code"}

            if recno <> ? then
               display rsn_code @ scrap_rsn_code.
         end.
         else if frame-field = "rjct_rsn_code" then do:
            {mfnp05.i rsn_ref rsn_type " rsn_ref.rsn_domain = global_domain and
            rsn_type  = ""reject""" rsn_code
               "input frame d rjct_rsn_code"}

            if recno <> ? then
                display rsn_code @ rjct_rsn_code.
         end.
         else if frame-field = "to_op" then do:
            {mfnp05.i wr_route wr_lot
               " wr_route.wr_domain = global_domain and wr_lot  = cumwo_lot and
               wr_op <= cumwo_op"
               wr_op "input frame d to_op"}

            if recno <> ? then do:
               display wr_op @ to_op.
            end.
         end.
         else if frame-field = "setup_rsn" then do:
            {mfnp05.i rsn_ref rsn_code  " rsn_ref.rsn_domain = global_domain and rsn_type = 'setup' " 
	              rsn_code "input frame d setup_rsn"}
            if recno <> ? then display rsn_code @ setup_rsn .
         end.
         else if frame-field = "down_rsn_code" then do:
            {mfnp05.i rsn_ref rsn_type " rsn_ref.rsn_domain = global_domain 
	              and rsn_type  = ""downtime""" rsn_code
                      "input frame d down_rsn_code"}

            if recno <> ? then
               display rsn_code @ down_rsn_code.
         end.
         else if frame-field = "rsn" then do:
            /* FIND NEXT/PREVIOUS RECORD */
            {mfnp05.i rsn_ref rsn_type " rsn_ref.rsn_domain = global_domain 
	              and rsn_type = ""DOWN""" rsn_code
                   "input frame d rsn"}

            if recno <> ?
            then
               display rsn_code @ rsn.
         end. /* ELSE IF frame-field = "op_rsn" */
         else do:
            ststatus = stline[3].
            status input ststatus.
            readkey.
            apply lastkey.
         end.
      end.
**************** end tx01****************/

      find pt_mstr where pt_mstr.pt_domain = global_domain 
         and pt_part = part no-lock no-error.

      if um <> pt_um then do:
         {gprun.i ""gpumcnv.p"" "(input  um,
                                  input  pt_um,
                                  input  part,
                                  output new_conv)"}

         if new_conv = ? then do:
            {pxmsg.i &MSGNUM=33 &ERRORLEVEL=2}
         end.
         else do:
            conv = new_conv.
         end.
      end.

      if earn_code > "" then do:
         find ea_mstr  where ea_mstr.ea_domain = global_domain and  ea_earn =
         earn_code no-lock no-error.

         if not available ea_mstr then do:
            {pxmsg.i &MSGNUM=4025 &ERRORLEVEL=3}
            next-prompt v_part.
            undo , retry.
         end.
      end.

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
/*
      if act_run_hrs = 0 then do on error undo, retry:
         if {gpiswrap.i} then do:
        message_text=getTermLabel("TIME",30) + " (hhmmss)".
            {pxmsg.i &MSGTEXT=message_text &ERRORLEVEL=1}
         end.

         {mfctime.i start_run stop_run}
         act_run_hrs = elapse.
         display act_run_hrs.
      end.
*/
      if not first_op then do:
         find wr_route  where wr_route.wr_domain = global_domain and  wr_lot =
         cumwo_lot and wr_op = to_op
            no-lock no-error.

         if not available wr_route then do:
            {pxmsg.i &MSGNUM=106 &ERRORLEVEL=3}
            next-prompt v_part with frame a.
            undo, retry.
         end.

         if to_op > op then do:
            {pxmsg.i &MSGNUM=5110 &ERRORLEVEL=3}
            next-prompt v_part with frame a.
            undo, retry.
         end.
      end.

/*apple add**************************************************/
      find first rsn_ref where rsn_ref.rsn_domain = global_domain 
	     and rsn_type = "setup" and rsn_code = setup_rsn no-lock no-error.
      if not available rsn_ref and setup_rsn > "" then do:
	 message "错误：准备类型不存在，请重新输入".
         next-prompt v_part with frame a.
         undo, retry.
      end.	

      find rsn_ref  where rsn_ref.rsn_domain = global_domain 
         and rsn_code = down_rsn_code
         and rsn_type = "downtime" no-lock no-error.

      if not available rsn_ref and down_rsn_code > "" then do:
         /* REASON CODE DOES NOT EXIST */
         {pxmsg.i &MSGNUM=534 &ERRORLEVEL=3}
         next-prompt v_part with frame a.
         undo, retry.
      end.

      find first rsn_ref
           where rsn_ref.rsn_domain = global_domain 
	     and rsn_code = rsn and rsn_type = "DOWN" no-lock no-error.
      if not available rsn_ref and rsn <> "" then do:
         /* INVALID REASON CODE */
         {pxmsg.i &MSGNUM=655 &ERRORLEVEL=3}
         next-prompt v_part with frame a.
         undo, retry.
      end. /* IF NOT AVAILABLE rsn_ref */

      find first gl_ctrl
           where gl_ctrl.gl_domain = global_domain no-lock no-error.

      if not available gl_ctrl then do:
	 /* Please create # control */
         {pxmsg.i &MSGNUM=533 &ERRORLEVEL=3  &MSGARG1=msg_var1}
         next-prompt v_part with frame a.
         undo, retry.
      end. /* IF NOT AVAILABLE gl_ctrl */

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
            next-prompt v_part with frame a.
            undo, retry.
         end.
      end.

/************ start tx01**********
      if rejque_multi_entry then do:
         do i = 1 to 10:
            rsn_codes[i] = reject_rsn_codes[i].
            quantities[i] = reject_quantities[i].
         end.

         /* Identify context for QXtend */
         {gpcontxt.i
            &STACKFRAG = 'resrqrin,rebkfli1,rebkfl'
            &FRAME = 'q' &CONTEXT = 'REJECT'}

         {gprun.i ""xxresrqrin.p"" "(input  ""reject"",
                                   input  getFrameTitle(""REJECT"",8),
                                   output undostat)"}

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

         {gprun.i ""xxresrqrin.p"" "(input  ""scrap"",
                                   input  getFrameTitle(""SCRAP"",8),
                                   output undostat)"}

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
************ end tx01**********/

      if act_multi_entry then do:
         do i = 1 to 10:
            rsn_codes[i] = act_rsn_codes[i].
            quantities[i] = act_hrs[i].
         end.

         /* Identify context for QXtend */
         {gpcontxt.i
            &STACKFRAG = 'resrqrin,rebkfli1,rebkfl'
            &FRAME = 'q' &CONTEXT = '准备时间'}

         {gprun.i ""xxresrqrinbcmt.p"" "(input  ""setup"",
                                   input  getFrameTitle(""准备时间"",8),
                                   output undostat)"}

         /* Clear context for QXtend */
         {gpcontxt.i
            &STACKFRAG = 'resrqrin,rebkfli1,rebkfl'
            &FRAME = 'q'}

/*tx01*  if undostat then undo, retry. */
/*************** start tx01 ***************/
         if undostat then do:
	    message "错误： 无效的原因代码".
	    next-prompt v_part with frame a.
	    undo,retry.
	 end.
/*************** end tx01******************/
         act_setup_hrs = 0.

         do i = 1 to 10:
            assign
               act_rsn_codes[i]  = rsn_codes[i]
               act_hrs[i] = quantities[i]
               act_setup_hrs = act_setup_hrs + quantities[i].
         end.

/*tx01*  display act_setup_hrs. */
      end.

      if stop_multi_entry then do:
         do i = 1 to 10:
            rsn_codes[i] = down_rsn_codes[i].
            quantities[i] = act_setup_hrs20s[i].
         end.

         /* Identify context for QXtend */
         {gpcontxt.i
            &STACKFRAG = 'resrqrin,rebkfli1,rebkfl'
            &FRAME = 'q' &CONTEXT = '停工时间'}

         {gprun.i ""xxresrqrinbcmt.p"" "(input  ""downtime"",
                                     input  getFrameTitle(""停工时间"",8),
                                     output undostat)"}

         /* Clear context for QXtend */
         {gpcontxt.i
            &STACKFRAG = 'resrqrin,rebkfli1,rebkfl'
            &FRAME = 'q'}

/*tx01*  if undostat then undo, retry.  */
/*************** start tx01 ***************/
         if undostat then do:
	    message "错误： 无效的原因代码".
	    next-prompt v_part with frame a.
	    undo,retry.
	 end.
/*************** end tx01******************/
         act_setup_hrs20 = 0.

         do i = 1 to 10:
            assign
               down_rsn_codes[i]  = rsn_codes[i]
               act_setup_hrs20s[i] = quantities[i]
               act_setup_hrs20 = act_setup_hrs20 + quantities[i].
         end.

/*tx01*  display act_setup_hrs20. */
      end.

      if prod_multi_entry then do:
         do i = 1 to 10:
            rsn_codes[i] = pd_rsn_codes[i].
            quantities[i] = pd_non_prod_hrs[i].
         end.

         /* Identify context for QXtend */
         {gpcontxt.i
            &STACKFRAG = 'resrqrin,rebkfli1,rebkfl'
            &FRAME = 'q' &CONTEXT = '非生产时间'}

         {gprun.i ""xxresrqrinbcmt.p"" "(input  ""down"",
                                     input  getFrameTitle(""非生产时间"",8),
                                     output undostat)"}

         /* Clear context for QXtend */
         {gpcontxt.i
            &STACKFRAG = 'resrqrin,rebkfli1,rebkfl'
            &FRAME = 'q'}

/*tx01*  if undostat then undo, retry.  */
/*************** start tx01 ***************/
         if undostat then do:
	    message "错误： 无效的原因代码".
	    next-prompt v_part with frame a.
	    undo,retry.
	 end.
/*************** end tx01******************/

         non_prod_hrs = 0.

         do i = 1 to 10:
            assign
               pd_rsn_codes[i]  = rsn_codes[i]
               pd_non_prod_hrs[i] = quantities[i]
               non_prod_hrs = non_prod_hrs + quantities[i].
         end.

/*tx01*  display non_prod_hrs. */
      end.
/*end tx01**/

      if (qty_proc >= 0 and qty_rjct + qty_scrap > qty_proc) or
         (qty_proc < 0 and qty_rjct + qty_scrap < qty_proc) then do:
         {pxmsg.i &MSGNUM=5108 &ERRORLEVEL=3}
         bell.
/*tx01*  next-prompt qty_proc. */
/*tx01*/ next-prompt v_part with frame a. 
         undo, retry.
      end.
/*appel add*********************/

/********* start tx01**************
           if qty_proc < tot-qty * ( 1 - 0.1) or qty_proc > tot-qty * (1 + 0.1) then do:
              message "警告：回冲数量大于或小于排产数量百分之十,是否正确？"  update qty_yn.
	      if qty_yn  then do:
	      end.
	      else do:
		   bell.                   
/*tx01*        	   next-prompt qty_proc.   */
/*tx01*/       	   next-prompt v_part with frame a.
         	   undo, retry.   
	      end.
	   end.
********* end tx01**************/
/*appel add*********************/

      if (qty_proc >= 0 and qty_scrap >= 0 and qty_rjct >= 0) or
         (qty_proc <= 0 and qty_scrap <= 0 and qty_rjct <= 0) then .
      else do:
         /* PROCESS, SCRAP AND REJECT QUANTITIES MUST HAVE SAME SIGN*/
         {pxmsg.i &MSGNUM=1347 &ERRORLEVEL=3}
/*tx01*  next-prompt qty_proc. */
/*tx01*/ next-prompt v_part with frame a.
         undo, retry.
      end.
   end.  /* do with frame bkfl1 */

   undo_stat = no.
/*tx01* end. */
