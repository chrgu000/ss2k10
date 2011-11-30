/* rebkfl.p   - REPETITIVE   BACKFLUSH TRANSACTION                            */
/* Copyright 1986-2005 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/*V8:ConvertMode=NoConvert                                                    */
/* REVISION: 1.0      Create : 07/24/2007   BY: softspeed tommy xie           */

/* SS - 090611.1 By: Roger Xiao */

/* SS - 090611.1 - RNB

    ��mainloop����wo_mstr

   SS - 090611.1 - RNE */

/*
{mfdtitle.i "1+ "}
*/
{mfdtitle.i "090611.1"}


{cxcustom.i "REBKFL.P"}

{gldydef.i new}
{gldynrm.i new}

define buffer next_wr_route      for wr_route.
define buffer reject_to_wr_route for wr_route.
define buffer ptmstr             for pt_mstr.

define variable comp                 as character   no-undo.
define variable conv_qty_proc        as decimal     no-undo.
define variable conv_qty_move        as decimal     no-undo.
define variable conv_qty_rjct        as decimal     no-undo.
define variable conv_qty_scrap       as decimal     no-undo.
define variable cumwo_lot            as character   no-undo.
define variable date_change          as integer     no-undo.
define variable ophist_recid         as recid       no-undo.
define variable rejected           like mfc_logical no-undo.
define variable schedwo_lot          as character   no-undo.
define variable undo_stat          like mfc_logical no-undo.
define variable yn                 like mfc_logical no-undo.
define variable i                    as integer     no-undo.
define variable j                    as integer     no-undo.
define variable oplist               as character   no-undo.
define variable lotserials_req       as log         no-undo.
define variable bomcode              as character   no-undo.
define variable routecode            as character   no-undo.
define variable following_op_req_qty as decimal     no-undo.
define variable backflush_qty        as decimal     no-undo.
define variable std_run_hrs          as decimal     no-undo.
define variable msg_ct               as integer     no-undo.
define variable input_que_op_to_ck   as integer     no-undo.
define variable input_que_qty_chg    as decimal     no-undo.
define variable l_reject_to_wkctr  like wc_wkctr    no-undo.
define variable l_reject_to_mch    like wc_mch      no-undo.
define variable elapse               as decimal   format ">>>>>>>>.999" no-undo.
define variable trans_type           as character initial "BACKFLSH"    no-undo.

{xxretrformmt.i new}
define new shared variable rsn_codes          as character   extent 10.
define new shared variable quantities       like wr_qty_comp extent 10.
define new shared variable scrap_rsn_codes    as character   extent 10.
define new shared variable scrap_quantities like wr_qty_comp extent 10.
define new shared variable reject_rsn_codes   as character   extent 10.
define new shared variable reject_quantities
   like wr_qty_comp extent 10.

/*minth*/ define variable  mch_op like ro_mch_op.
/*mage*/ define new shared variable line1 like ln_line .
/*apple*/ define new shared variable tot-qty like rps_qty_req.
/*mage*/ define  variable trnbr as integer .

define variable   dont_zero_unissuable             as logical
   initial no                                                     no-undo.
define new shared variable wo_recno                as recid.
define new shared variable wr_recno                as recid.
define new shared variable lotserial             like sr_lotser   no-undo.
define            variable inv-issued              as logical     no-undo.
define variable   mfc-recid                        as recid       no-undo.
{&REBKFL-P-TAG1}
define variable   trans-ok                       like mfc_logical no-undo
   initial no.
define variable   move_to_wkctr                  like wc_wkctr    no-undo.
define variable   move_to_mch                    like wc_mch      no-undo.
define variable   consider_output_qty            like mfc_logical no-undo.
define new shared variable h_wiplottrace_procs     as handle      no-undo.
define new shared variable h_wiplottrace_funcs     as handle      no-undo.
define variable   result_status                    as character   no-undo.
{&REBKFL-P-TAG4}
/*mage add 09/01/03 */ define new shared variable qc_loc    as character    no-undo.

{wlfnc.i} /*FUNCTION FORWARD DECLARATIONS*/
{wlcon.i} /*CONSTANTS DEFINITIONS*/

if is_wiplottrace_enabled()
then do:
   {gprunmo.i &program=""wlpl.p"" &module="AWT"
      &persistent="""persistent set h_wiplottrace_procs"""}
   {gprunmo.i &program=""wlfl.p"" &module="AWT"
      &persistent="""persistent set h_wiplottrace_funcs"""}
end. /* IF is_wiplottrace_enabled() */

/* DO NOT RUN PROGRAM UNLESS QAD_WKFL RECORDS HAVE */
/* BEEN CONVERTED SO THAT QAD_KEY2 HAS NEW FORMAT  */
if can-find(first qad_wkfl
    where qad_wkfl.qad_domain = global_domain and  qad_key1 = "rpm_mstr")
then do:
   {pxmsg.i &MSGNUM=5126 &ERRORLEVEL=3}
   message.
   message.
   leave.
end. /* if can-find(first qad_wkfl... */

/*DEFINE VARIABLES FOR CHANGE ATTRIBUTES FEATURE*/
{gpatrdef.i "new shared"}

eff_date = today.

for first gl_ctrl
 where gl_ctrl.gl_domain = global_domain no-lock:
end. /* FOR FIRST gl_ctrl */

for first clc_ctrl
   fields( clc_domain clc_lotlevel)
 where clc_ctrl.clc_domain = global_domain no-lock:
end. /* FOR FIRST clc_ctrl */

if not available clc_ctrl
then do:

   {gprun.i ""gpclccrt.p""}
   for first clc_ctrl
      fields( clc_domain clc_lotlevel)
    where clc_ctrl.clc_domain = global_domain no-lock:
   end. /* FOR FIRST clc_ctrl */
end. /* IF NOT AVAILABLE clc_ctrl */

{gprun.i ""redflt.p""}

main:
repeat:
   {gprun.i ""xxretrin1.p""
             "(output undo_stat)"}
   {&REBKFL-P-TAG5}
   if undo_stat
   then
      undo, leave.

   mainloop:
   repeat:

      {&REBKFL-P-TAG3}

      lotserial = "".
      /*GET ITEM, OP, LINE FROM USER*/
      {gprun.i ""xxretrin2.p""
         "(output undo_stat)"}

      if undo_stat
      then
         undo, leave.

      /*FIND DEFAULT BOM AND ROUTING CODES*/
      {gprun.i ""reoptr1b.p""
         "(input site,
           input line,
           input part,
           input op,
           input eff_date,
           output routing,
           output bom_code,
           output schedwo_lot)"}

      if schedwo_lot = "?"
      then do:
         /* Unexploded schedule with consumption period */
         {pxmsg.i &MSGNUM=325 &ERRORLEVEL=3}
         next-prompt part.
         undo, retry.
      end. /* IF schedwo_lot = "?" */

      /*GET BOM, ROUTING FROM USER*/
      {gprun.i ""retrin3.p""
                "(output undo_stat)"}

      if undo_stat
      then
         undo, leave.

      /*FIND CUM ORDER. */
      {gprun.i ""regetwo.p""
         "(input site,
           input part,
           input eff_date,
           input line,
           input routing,
           input bom_code,
           output cumwo_lot)"}

      /*VALIDATE THE OPERATION */
      {reopval.i
         &part    = part
         &routing = routing
         &op      = op
         &date    = eff_date
         &prompt  = op
         &frame   = "a"
         &leave   = ""no""
         &loop    = "mainloop"}

      /* CREATE IT IF IT DOESN'T EXIST*/
      if cumwo_lot = ?
      then do:
         {gprun.i ""xxrecrtwo.p""
            "(input site,
              input part,
              input eff_date,
              input line,
              input routing,
              input bom_code,
              output cumwo_lot)"}

	 if cumwo_lot = ?
         then
            next mainloop.

         display cumwo_lot @ wo_lot with frame a.
      end. /* IF cumwo_lot = ? */
      else do:
         display cumwo_lot @ wo_lot with frame a.
         for first wo_mstr
            fields( wo_domain wo_assay wo_due_date wo_expire wo_grade wo_loc
            wo_lot
                   wo_lot_next wo_lot_rcpt wo_part wo_rctstat wo_status
                   wo_rctstat_active wo_rel_date wo_routing wo_site)
             where wo_mstr.wo_domain = global_domain and  wo_lot = cumwo_lot
         no-lock:
         end. /* FOR FIRST wo_mstr */

         if wo_status = "c"
         then do:
            {pxmsg.i &MSGNUM=5101 &ERRORLEVEL=3}
            undo, retry.
         end. /* IF wo_status = "c" */
      end. /* ELSE DO */

/* SS - 090611.1 - B */
find first wo_mstr where wo_mstr.wo_domain = global_domain and  wo_lot = cumwo_lot exclusive-lock no-error .
if not avail wo_mstr then do:
    message "�ۼƼӹ���������,����������" /*view-as alert-box title ""*/ . 
    disp "" @ routing "" @ bom_code "" @ wo_lot with frame a. 
    undo,retry.
end.
/* SS - 090611.1 - E */

      for first wr_route
         fields( wr_domain wr_auto_lbr wr_desc wr_lot wr_mch wr_milestone wr_op
                wr_part wr_run wr_wkctr)
          where wr_route.wr_domain = global_domain and  wr_lot = cumwo_lot
         and wr_op    = op
      no-lock:
      end. /* FOR FIRST wr_route */

      if not available wr_route
      then do:

         /* OPERATION DOES NOT EXIST */
         {pxmsg.i &MSGNUM=106 &ERRORLEVEL=3}
         next-prompt op with frame a.
         undo, retry.
      end. /* IF NOT AVAILABLE wr_route */

      if not wr_milestone
      then do:

         if is_wiplottrace_enabled()
         then do:

            if prev_milestone_operation(cumwo_lot, op) <> ?
               or (prev_milestone_operation(cumwo_lot, op) = ?
                   and not wr_milestone)
               and is_operation_queue_lot_controlled
               (cumwo_lot,
               prev_milestone_operation(cumwo_lot, op),
               OUTPUT_QUEUE)
            then do:

               {pxmsg.i &MSGNUM=8465 &ERRORLEVEL=3}
               /*WIP LOT TRACE IS ENABLED AND OPERATION IS A */
               /*NON-MILESTONE                               */
               undo, retry.
            end. /* IF pre_milestone_operation(cumwo_lot, .... */
         end. /* IF is_wiplottrace_enabled() */

         if not wr_milestone
            and not is_wiplottrace_enabled()
         then
            /* OPERATION NOT A MILESTONE */
            {pxmsg.i &MSGNUM=560 &ERRORLEVEL=2}

      end. /* IF NOT wr_milestone */

      display wr_desc with frame a.


      assign
         wkctr              = ""
         mch                = ""
         dept               = ""
         qty_proc           = 0
         um                 = ""
         conv               = 1
         qty_rjct           = 0
         rjct_rsn_code      = ""
         rejque_multi_entry = no
         to_op              = op
         qty_scrap          = 0
         scrap_rsn_code     = ""
         outque_multi_entry = no
         mod_issrc          = no
         start_run          = ""
         act_run_hrs        = 0
         stop_run           = ""
         earn_code          = ""
         rsn_codes          = ""
         quantities         = 0
         scrap_rsn_codes    = ""
         scrap_quantities   = 0
         reject_rsn_codes   = ""
         reject_quantities  = 0
         act_rsn_codes      = ""
         act_hrs            = 0
         prod_multi_entry   = no
         rsn                = ""
         act_run_hrs        = 0
         move_next_op       = no
         act_setup_hrs      = 0
         setup_rsn          = ""
         act_multi_entry    = no
         act_setup_hrs20    = 0
         down_rsn_code      = ""
         stop_multi_entry   = no
         non_prod_hrs       = 0
	 .
      
      {gprun.i ""resetmno.p""
         "(input cumwo_lot,
           input op,
           output move_next_op)"}

      assign
         wkctr = wr_wkctr
         mch   = wr_mch.

      for first wc_mstr
         fields( wc_domain wc_dept wc_desc wc_mch wc_wkctr)
          where wc_mstr.wc_domain = global_domain and  wc_wkctr = wkctr
           and wc_mch   = mch
      no-lock:
      end. /* FOR FIRST wc_mstr */

      dept = wc_dept.
      for first dpt_mstr
         fields( dpt_domain dpt_dept dpt_desc)
          where dpt_mstr.dpt_domain = global_domain and  dpt_dept = wc_dept
      no-lock:
      end. /* FOR FIRST dpt_mstr */

      for first wo_mstr
         fields( wo_domain wo_assay wo_due_date wo_expire wo_grade wo_loc wo_lot
                wo_lot_next wo_lot_rcpt wo_part wo_rctstat wo_status
                wo_rctstat_active wo_rel_date wo_routing wo_site)
          where wo_mstr.wo_domain = global_domain and  wo_lot = cumwo_lot
      no-lock: /* FOR FIRST wo_mstr */
      end. /* FOR FIRST wo_mstr */

      for first pt_mstr
         fields( pt_domain pt_desc1 pt_loc pt_lot_ser pt_part pt_rctwo_active
                pt_rctwo_status pt_site pt_um pt_article)
          where pt_mstr.pt_domain = global_domain and  pt_part = wo_part
      no-lock:
      end. /* FOR FIRST pt_mstr */

      um = pt_um.

      for first ea_mstr
         fields( ea_domain ea_desc ea_earn ea_type)
          where ea_mstr.ea_domain = global_domain and  ea_type = "1"
      no-lock:
      end. /* FOR FIRST ea_mstr */

      if available ea_mstr
      then
         earn_code = ea_earn.
/*apple add**********************************************************/
        find first rps_mstr where rps_mstr.rps_domain = global_domain
	                      and rps_part = part
			      and rps_site = site
			      and rps_line = line
			      and rps_due_date = eff_date
			      no-lock no-error.
	if available rps_mstr then do:
	   qty_proc = rps_qty_req - rps_qty_comp.
	   tot-qty  = qty_proc.
	end.
/*apple add**********************************************************/

      display
         qty_proc          
         act_run_hrs       
         earn_code         
         qty_scrap         
         scrap_rsn_code    
         outque_multi_entry
         qty_rjct          
         rjct_rsn_code     
         rejque_multi_entry
         to_op             
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
      with frame d.

      if is_wiplottrace_enabled()
      then do:

         run init_bkfl_input_wip_lot_temptable in h_wiplottrace_procs.
         run init_bkfl_output_wip_lot_temptable in h_wiplottrace_procs.
         run init_bkfl_scrap_wip_lot_temptable in h_wiplottrace_procs.
         run init_bkfl_reject_wip_lot_temptable in h_wiplottrace_procs.
      end. /* if is_wiplottrace_enabled() */

      /* LOOPC ADDED TO BRING THE CURSOR CONTROL TO SECOND         */
      /* FRAME DURING UNDO,RETRY                                   */
/*mage*/ line1 = line.

      loopc:
      do with frame d on error undo, retry:

         for first wr_route
            fields( wr_domain wr_auto_lbr wr_desc wr_lot wr_mch wr_milestone
            wr_op
                   wr_part wr_run wr_wkctr)
             where wr_route.wr_domain = global_domain and  wr_lot = cumwo_lot
              and wr_op  = op
         no-lock:
         end. /* FOR FIRST wr_route */

         for each sr_wkfl exclusive-lock
             where sr_wkfl.sr_domain = global_domain and  sr_userid = mfguser:
            delete sr_wkfl.
         end. /* FOR EACH sr_wkfl */

         for each pk_det exclusive-lock
             where pk_det.pk_domain = global_domain and  pk_user = mfguser:
            delete pk_det.
         end. /* FOR EACH pk_det */

         /*DELETE LOTW_WKFL*/
         {gprun.i ""gplotwdl.p""}

/*apple     {gprun.i ""rebkfli1.p""*/
/*apple*/   {gprun.i ""xxrebkfli1mt.p""
            "(input cumwo_lot,
              input op,
              output undo_stat)"}

         if undo_stat
         then
            undo main, retry main.

         /*mage del 09/01/03        assign
            conv_qty_proc  = qty_proc * conv
            conv_qty_rjct  = qty_rjct * conv
            conv_qty_scrap = qty_scrap * conv
            conv_qty_move  = if move_next_op
                             then
                                 conv_qty_proc - conv_qty_rjct - conv_qty_scrap
                             else 0.   */

/*mage add 09/01/03 */
       assign
            conv_qty_proc  = qty_proc * conv
            conv_qty_rjct  = qty_rjct * conv
            conv_qty_scrap = qty_scrap * conv
            conv_qty_move  = if move_next_op
                             then
                                 conv_qty_proc -   conv_qty_scrap
                             else 0.    
        find first xkbc_ctrl where xkbc_site = wo_site 
                  and xkbc_domain = global_domain no-lock no-error.   
       if available xkbc_ctrl then qc_loc = xkbc_qc_loc.
         else  qc_loc = wkctr.
/*mage add 09/01/04*/


         /*CHECK QUEUES IF WOULD GO NEGATIVE; IF SO ISSUE MESSAGES     */

         msg_ct = 0.

         /*DETERMINE INPUT QUE OP TO CHECK;
         COULD BE PRIOR NONMILESTONES*/
         {gprun.i ""reiqchg.p""
            "(input cumwo_lot,
              input op,
              input conv_qty_proc,
              output input_que_op_to_ck,
              output input_que_qty_chg)"}

         /*CHECK INPUT QUEUE*/
         {gprun.i ""rechkq.p""
            "(input cumwo_lot,
              input input_que_op_to_ck,
              input ""i"",
              input input_que_qty_chg,
              input-output msg_ct)"}

         /*CHECK OUTPUT QUEUE*/
         {gprun.i ""rechkq.p""
            "(input cumwo_lot,
              input op,
              input ""o"",
              input (conv_qty_proc - conv_qty_scrap
                    - conv_qty_rjct - conv_qty_move),
              input-output msg_ct)"}

         /*CHECK REJECT QUEUE*/
         {gprun.i ""rechkq.p""
            "(input cumwo_lot,
              input to_op,
              input ""r"",
              input conv_qty_rjct,
              input-output msg_ct)"}

         /*CHECK INPUT QUEUE NEXT OP IF MOVE*/
         if move_next_op
         then do:

            for first wr_route
               fields( wr_domain wr_auto_lbr wr_desc wr_lot wr_mch wr_milestone
               wr_op
                      wr_part wr_run wr_wkctr)
                where wr_route.wr_domain = global_domain and  wr_lot = cumwo_lot
                 and wr_op > op
            no-lock:
            end. /* FOR FIRST wr_route */

            if available wr_route
            then do:

               {gprun.i ""rechkq.p""
                  "(input cumwo_lot,
                    input wr_op,
                    input ""i"",
                    input conv_qty_move,
                    input-output msg_ct)"}
            end. /* IF AVAILABLe wr_route */
         end. /* IF move_next_op */

         /*FORCE A PAUSE IF NECESSARY*/
         {gprun.i ""repause.p"" "(input msg_ct)"}

         /*BUILD DEFAULT COMPONENT PART ISSUE LIST*/

         {gprun.i ""recrtcl.p""
            "(input cumwo_lot,
              input op,
              input yes,
              input conv_qty_proc,
              input eff_date,
              input dont_zero_unissuable,
              input wkctr,
              output rejected,
              output lotserials_req)"
         }

         if lotserials_req
         then do:

            {pxmsg.i &MSGNUM=1119 &ERRORLEVEL=1}
         end. /* IF lotserials_req */

         if rejected
         then
            mod_issrc = yes.

         /*MODIFY COMPONENT PART ISSUE LIST*/
         if mod_issrc
         then do:

            hide frame d no-pause.
            hide frame a no-pause.

            display
               site
               part
               op
               line
            with frame b side-labels width 80 attr-space.
/*mage*/ line1 = line.
            {gprun.i ""reisslst.p""
               "(input cumwo_lot,
                 input part,
                 input site,
                 input eff_date,
                 input wkctr,
                 input conv_qty_proc,
                 output undo_stat)"}

            hide frame b no-pause.

            if undo_stat
            then do:

               view frame a.
               view frame d.

               /* RESTRICT PROCESS FOR BATCHRUN  */
               if batchrun
               then
                  undo main, leave main.
               else
                  undo, retry.
            end. /* IF undo_stat */
         end. /* IF mod_issrc */

         if is_wiplottrace_enabled() and
            is_operation_queue_lot_controlled(cumwo_lot, op, OUTPUT_QUEUE)
         then do:

            view frame a.
            view frame d.

            if is_operation_queue_lot_controlled(cumwo_lot, op, INPUT_QUEUE)
            then do:

               /* Identify context for QXtend */
               {gpcontxt.i
                  &STACKFRAG = 'wlpl,wlui,wluibi,wlpl,rebkfl'
                  &FRAME = 'yn' &CONTEXT = 'INPUT'}

               if {gpisapi.i}
               then
                  pause 0.

               run get_bkfl_input_wip_lots_from_user
                  in h_wiplottrace_procs
                  (input cumwo_lot,
                   input op,
                   input qty_proc,
                   input conv,
                   input um,
                   input site,
                   input wkctr,
                   input mch,
                   output undo_stat).

               /* Clear context for QXtend */
               {gpcontxt.i
                  &STACKFRAG = 'wlpl,wlui,wluibi,wlpl,rebkfl'
                  &FRAME = 'yn'}

               if undo_stat
               then
                  undo, retry.
            end. /* IF is_operation_queue_lot_controlled ... */

            assign
               move_to_wkctr = wkctr
               move_to_mch   = mch.

            if not is_last_operation(cumwo_lot, op)
               and move_next_op
            then do:

               if {gpisapi.i}
               then
                  pause 0.

               run get_destination_wkctr_mch_from_user in h_wiplottrace_procs
                  (input cumwo_lot,
                   input next_milestone_operation(cumwo_lot, op),
                   output move_to_wkctr,
                   output move_to_mch,
                   output undo_stat).

               if undo_stat
               then
                  undo, retry.
            end. /* IF NOT is_last_operation */

            if not (is_last_operation(cumwo_lot, op)
               and move_next_op)
            then do:

               /* Identify context for QXtend */
               {gpcontxt.i
                  &STACKFRAG = 'wlpl,wlui,wluibo,wlpl,rebkfl'
                  &FRAME = 'yn' &CONTEXT = 'RECEIPT'}

               if {gpisapi.i}
               then
                  pause 0.

               run get_bkfl_output_wip_lots_from_user in h_wiplottrace_procs
                  (input cumwo_lot,
                   input op,
                   input qty_proc,
                   input conv,
                   input um,
                   input move_next_op,
                   input site,
                   input wkctr,
                   input mch,
                   output undo_stat).

               /* Clear context for QXtend */
               {gpcontxt.i
                  &STACKFRAG = 'wlpl,wlui,wluibo,wlpl,rebkfl'
                  &FRAME = 'yn'}

               if undo_stat
               then
                  undo, retry.
            end. /* IF NOT (islast_operation .. */

            if qty_rjct <> 0
            then do:

               if not is_operation_queue_lot_controlled(cumwo_lot,
                  to_op,
                  REJECT_QUEUE)
               then do:

                  {pxmsg.i &MSGNUM=8426 &ERRORLEVEL=3}
                  /*TO OPERATION MUST BE LOT CONTROLLED*/
                  undo, retry.
               end. /* IF NOT is_operation_queue_lot_controlled ... */

               do for reject_to_wr_route:
                  for first reject_to_wr_route
                     fields( wr_domain wr_lot wr_op wr_wkctr wr_mch)
                      where reject_to_wr_route.wr_domain = global_domain and
                      wr_lot = cumwo_lot
                       and wr_op  = to_op
                     no-lock:
                  end. /* FOR FIRST reject_to_wr_route */

                  assign
                     l_reject_to_wkctr = wr_wkctr
                     l_reject_to_mch   = wr_mch.
               end. /* DO FOR reject_to_wr_route */

               /* Identify context for QXtend */
               {gpcontxt.i
                  &STACKFRAG = 'wlpl,wlui,wluibr,wlpl,rebkfl'
                  &FRAME = 'yn' &CONTEXT = 'REJECT'}

               if {gpisapi.i}
               then
                  pause 0.

               run get_bkfl_reject_wip_lots_from_user in h_wiplottrace_procs
                  (input cumwo_lot,
                   input op,
                   input qty_rjct,
                   input conv,
                   input um,
                   input to_op,
                   input site,
                   input l_reject_to_wkctr,
                   input l_reject_to_mch,
                   output undo_stat).

               /* Clear context for QXtend */
               {gpcontxt.i
                  &STACKFRAG = 'wlpl,wlui,wluibr,wlpl,rebkfl'
                  &FRAME = 'yn'}

               if undo_stat
               then
                  undo, retry.
            end. /* IF qty_rjct <> 0 */

            if qty_scrap <> 0
            then do:

               /* Identify context for QXtend */
               {gpcontxt.i
                  &STACKFRAG = 'wlpl,wlui,wluibs,wlpl,rebkfl'
                  &FRAME = 'yn' &CONTEXT = 'SCRAP'}

               if {gpisapi.i}
               then
                  pause 0.

               run get_bkfl_scrap_wip_lots_from_user in h_wiplottrace_procs
                  (input cumwo_lot,
                   input op,
                   input qty_scrap,
                   input conv,
                   input um,
                   input site,
                   input wkctr,
                   input mch,
                   output undo_stat).

               /* Clear context for QXtend */
               {gpcontxt.i
                  &STACKFRAG = 'wlpl,wlui,wluibs,wlpl,rebkfl'
                  &FRAME = 'yn'}

               if undo_stat
               then
                  undo, retry.
            end. /* IF qty_scrap <> 0 */

            if {gpisapi.i}
               then
                  pause 0.

            run bkfl_check_output_scrap_reject in h_wiplottrace_procs
               (input cumwo_lot,
                input op,
                input move_next_op,
                input conv,
                input site,
                input wkctr,
                input mch,
                input move_to_wkctr,
                input move_to_mch,
                output undo_stat).

            if undo_stat
            then
               undo, retry.

            if move_next_op
               and is_last_operation(cumwo_lot, op)
            then do:

               assign
                  mod_issrc = true
                  lotserial = ''.

               run bkfl_create_receive_sr_wkfl in h_wiplottrace_procs
                  (cumwo_lot, conv_qty_move).
            end. /* IF move_next_op */
         end.  /* IF is_wiplottrace_enabled() .. */

         /*FORCE MODIFY FINISHED PART RECEIVE LIST IF ANY COMPONENTS
         L/S CONTROLLED, OR IF FOR SOME REASON THEY ARE NOT ISSUABLE*/
         if move_next_op
            and conv_qty_move <> 0
         then do:

            for first wr_route
               fields( wr_domain wr_auto_lbr wr_desc wr_lot wr_mch wr_milestone
                      wr_op wr_part wr_run wr_wkctr)
                where wr_route.wr_domain = global_domain and  wr_lot = cumwo_lot
                 and wr_op > op
            no-lock:
            end. /* FOR FIRST wr_route */

            if not available wr_route
            then do:

               for first wo_mstr
                  fields( wo_domain wo_assay wo_due_date wo_expire wo_grade
                  wo_loc wo_lot
                         wo_lot_next wo_lot_rcpt wo_part wo_rctstat wo_status
                         wo_rctstat_active wo_rel_date wo_routing wo_site)
                   where wo_mstr.wo_domain = global_domain and  wo_lot =
                   cumwo_lot
               no-lock:
               end. /* FOR FIRST wo_mstr */

               for first pt_mstr
                  fields( pt_domain pt_desc1 pt_loc pt_lot_ser pt_part
                  pt_rctwo_active
                         pt_rctwo_status pt_site pt_um pt_article)
                   where pt_mstr.pt_domain = global_domain and  pt_part =
                   wo_part
               no-lock:
               end. /* FOR FIRST pt_mstr */

               rejected = no.
               if index("LS",pt_lot_ser) = 0
               then do:

 /**mage                 /*ADDED BLANKS FOR TRNBR AND TRLINE*/
                  {gprun.i ""icedit2.p""
                     "(input ""RCT-WO"",
                       input if wo_site > """" then wo_site
                             else pt_site,
                       input if wo_loc > """" then wo_loc
                             else pt_loc,
                       input wo_part,
                       input """",
                       input """",
                       input conv_qty_move,
                       input pt_um,
                       input """",
                       input """",
                       output rejected)"}**********/
 
/*mage**********add **********************************************/
/*mage 08/12/29 if pt_part > "1" and pt_part < "1x"   or pt_article = "wkctrloc" then */

/*mage 08/12/29*/ if   pt_article = "wkctrloc" then  

            {gprun.i ""icedit2.p""
                     "(input ""RCT-WO"",
                       input if wo_site > """" then wo_site
                             else pt_site,
                       input if wo_loc > """" then wo_loc
                             else line1,
                       input wo_part,
                       input """",
                       input """",
                       input conv_qty_move - conv_qty_rjct,
                       input pt_um,
                       input """",
                       input """",
                       output rejected)"}
            	      else  {gprun.i ""icedit2.p""
                     "(input ""RCT-WO"",
                       input if wo_site > """" then wo_site
                             else pt_site,
                       input if wo_loc > """" then wo_loc
                             else pt_loc,
                       input wo_part,
                       input """",
                       input """",
                       input conv_qty_move - conv_qty_rjct,
                       input pt_um,
                       input """",
                       input """",
                       output rejected)"}

               
                  {gprun.i ""icedit2.p""
                     "(input ""RCT-WO"",
                       input if wo_site > """" then wo_site
                             else pt_site,
                       input qc_loc,
                       input wo_part,
                       input """",
                       input """",
                       input   conv_qty_rjct,
                       input pt_um,
                       input """",
                       input """",
                       output rejected)"}

 
/*mage**********add **********************************************/

               end. /* IF INDEX("LS,pt_lot_ser) = 0 */                
               /*mage del * 09/01/05 ********************************* 	       
               if index("LS",pt_lot_ser) > 0
                  or mod_issrc
                  or rejected
               then do:
*mage del * 09/01/05 *********************************/

/*mage del * 09/01/05 *********************************/ 	       
               if index("LS",pt_lot_ser) > 0
                  or mod_issrc
                then do:
/*mage del * 09/01/05 *********************************/
/*mage***09/01/03*******add **********************************************/
             create sr_wkfl. sr_wkfl.sr_domain = global_domain.

                     assign
                        sr_userid = mfguser
                        sr_lineid = "+" + wo_part
                        sr_site   = wo_site
                        sr_loc    = wo_loc
                        sr_qty    = conv_qty_move - conv_qty_rjct.

                     if sr_loc = ""
                     then
           if   pt_article = "wkctrloc" then 
	                  sr_loc = line1.
	                  else  sr_loc = pt_loc.

                   release sr_wkfl .
                      
                     create sr_wkfl. sr_wkfl.sr_domain = global_domain.

                     assign
                        sr_userid = mfguser
                        sr_lineid = "+" + wo_part
                        sr_site   = wo_site
                        sr_loc    = qc_loc
                        sr_qty    = conv_qty_rjct.
                        sr_rev    = "qc".
                     if sr_loc = ""
                     then
                      sr_loc = line1.

                      release sr_wkfl .
        
/*mage**********add **********************************************/

                  hide frame d no-pause.
                  hide frame a no-pause.

                  display
                     site
                     part
                     op
                     line
                  with frame b side-labels width 80 attr-space.

                  {&REBKFL-P-TAG6}
                  /*MODIFY FINISHED PART RECEIVE LIST*/
/*mage*/                  {gprun.i ""xxrercvlst.p""
                     "(input cumwo_lot,
                       input conv_qty_move,
                       output undo_stat)"}

                  {&REBKFL-P-TAG7}
                  hide frame b no-pause.

                  if undo_stat
                  then do:

                     view frame a.
                     view frame d.
                     if batchrun
                     then
                        undo main, leave main.
                     else
                        undo, retry.
                  end. /* IF undo_stat */
               end. /* IF INDEX("LS,pt_lot_ser) <> 0 ... */

               else do:
                  do transaction:
                     create sr_wkfl. sr_wkfl.sr_domain = global_domain.

                     assign
                        sr_userid = mfguser
                        sr_lineid = "+" + wo_part
                        sr_site   = wo_site
                        sr_loc    = wo_loc
                        sr_qty    = conv_qty_move - conv_qty_rjct.

                     if sr_loc = ""
                     then
/*mage                        sr_loc = pt_loc. */
/*mage del         if pt_part > "1" and pt_part < "1x"  then*/
/*mage add*/       if   pt_article = "wkctrloc" then 
	      sr_loc = line1.
	      else  sr_loc = pt_loc.
                     /* MOVED RESTRICTED TRANSACTION VALIDATION FROM */
                     /* icedit FILES TO worcat01.p FOR "RCT-WO"      */
                     /* TRANSACTIONS.WHEN LOT/SERIAL  = "" IN ITEM   */
                     /* MASTER MAINTENANCE,ITEM WILL NOW BE RECEIVED */
                     /* WITH THE RESPECTIVE VALID STATUS             */
                     /* CHANGE ATTRIBUTES.INITIALIZE ATTRIBUTE */
                     /* VARIABLES WITH CURRENT SETTINGS        */
                     assign
                        chg_assay   = wo_assay
                        chg_grade   = wo_grade
                        chg_expire  = wo_expire
                        chg_status  = wo_rctstat
                        assay_actv  = yes
                        grade_actv  = yes
                        expire_actv = yes
                        status_actv = yes.

                     if wo_rctstat_active = no
                     then do:

                        for first in_mstr
                           fields( in_domain in_part in_site
                              in_rctwo_active in_rctwo_status)
                           no-lock  where in_mstr.in_domain = global_domain and
                            in_part = wo_part
                                     and in_site = wo_site:
                        end. /* FOR FIRST in_mstr */
                        if available in_mstr
                           and in_rctwo_active = yes
                        then
                           chg_status = in_rctwo_status.
                        else
                        if available pt_mstr
                           and pt_rctwo_active
                        then
                           chg_status = pt_rctwo_status.
                        else
                           assign
                              chg_status  = ""
                              status_actv = no.
                     end. /* IF wo_rctstat_active = NO */

                     /* TO CHECK WHETHER "RCT-WO" IS RESTRICTED */
                     /* FOR RECEIVING INVENTORY STATUS.ALSO TO  */
                     /* CHECK FOR STATUS CONFLICT MESSAGE       */
                     {gprun.i ""worcat01.p""
                        "(input recid(wo_mstr),
                          input sr_site,
                          input sr_loc,
                          input sr_ref,
                          input sr_lotser,
                          input eff_date,
                          input sr_qty,
                          input-output chg_assay,
                          input-output chg_grade,
                          input-output chg_expire,
                          input-output chg_status,
                          input-output assay_actv,
                          input-output grade_actv,
                          input-output expire_actv,
                          input-output status_actv,
                          output trans-ok)"}

                     if not trans-ok
                     then do:

                        next-prompt qty_proc.
                        undo loopc,retry loopc.
                     end. /* IF NOT trans-ok */

/*mage 09/01/03 add ****************************************************************************************************/
                    release sr_wkfl.
		     create sr_wkfl. sr_wkfl.sr_domain = global_domain.

                     assign
                        sr_userid = mfguser
                        sr_lineid = "+" + wo_part
                        sr_site   = wo_site
                        sr_loc    = qc_loc
                        sr_qty    = conv_qty_rjct.
                        sr_rev    = "qc".
                     if sr_loc = ""
                     then
                      sr_loc = line1.
 
                     /* MOVED RESTRICTED TRANSACTION VALIDATION FROM */
                     /* icedit FILES TO worcat01.p FOR "RCT-WO"      */
                     /* TRANSACTIONS.WHEN LOT/SERIAL  = "" IN ITEM   */
                     /* MASTER MAINTENANCE,ITEM WILL NOW BE RECEIVED */
                     /* WITH THE RESPECTIVE VALID STATUS             */
                     /* CHANGE ATTRIBUTES.INITIALIZE ATTRIBUTE */
                     /* VARIABLES WITH CURRENT SETTINGS        */
                     assign
                        chg_assay   = wo_assay
                        chg_grade   = wo_grade
                        chg_expire  = wo_expire
                        chg_status  = wo_rctstat
                        assay_actv  = yes
                        grade_actv  = yes
                        expire_actv = yes
                        status_actv = yes.

                     if wo_rctstat_active = no
                     then do:

                        for first in_mstr
                           fields( in_domain in_part in_site
                              in_rctwo_active in_rctwo_status)
                           no-lock  where in_mstr.in_domain = global_domain and
                            in_part = wo_part
                                     and in_site = wo_site:
                        end. /* FOR FIRST in_mstr */
                        if available in_mstr
                           and in_rctwo_active = yes
                        then
                           chg_status = in_rctwo_status.
                        else
                        if available pt_mstr
                           and pt_rctwo_active
                        then
                           chg_status = pt_rctwo_status.
                        else
                           assign
                              chg_status  = ""
                              status_actv = no.
                     end. /* IF wo_rctstat_active = NO */

                     /* TO CHECK WHETHER "RCT-WO" IS RESTRICTED */
                     /* FOR RECEIVING INVENTORY STATUS.ALSO TO  */
                     /* CHECK FOR STATUS CONFLICT MESSAGE       */
                     {gprun.i ""worcat01.p""
                        "(input recid(wo_mstr),
                          input sr_site,
                          input sr_loc,
                          input sr_ref,
                          input sr_lotser,
                          input eff_date,
                          input sr_qty,
                          input-output chg_assay,
                          input-output chg_grade,
                          input-output chg_expire,
                          input-output chg_status,
                          input-output assay_actv,
                          input-output grade_actv,
                          input-output expire_actv,
                          input-output status_actv,
                          output trans-ok)"}

                     if not trans-ok
                     then do:

                        next-prompt qty_proc.
                        undo loopc,retry loopc.
                     end. /* IF NOT trans-ok */
                    release sr_wkfl.

/*mage 09/01/03 add ****************************************************************************************************/


                  end. /* DO TRANSACTION */
               end. /* ELSE DO */
            end. /* IF NOT AVAILABLE wr_route */
         end. /* IF move_next_op AND ... */

         if is_wiplottrace_enabled() and
            is_operation_queue_lot_controlled(cumwo_lot, op, OUTPUT_QUEUE)
         then do:

            if is_last_operation(cumwo_lot, op)
               and move_next_op
            then do:

               /*IN THIS CASE WE DIDN'T GET OUTPUT WIP LOTS        */
               /*FROM THE USER; WE USE THE LOTSER'S ENTERED        */
               /*IN SR_WKFL FOR THE FINISHED MATERIAL INSTEAD.     */
               /*THE BACKFLUSH SUBROUTINE REBKFLA.P WILL BACKFLUSH */
               /*THIS LIST INTO WIP, THEN RECEIVE.P WILL MOVE      */
               /*IN TO FINISHED GOODS INVENTORY.                   */

               run init_bkfl_output_wip_lot_temptable
                  in h_wiplottrace_procs.

               for each sr_wkfl no-lock
                      where sr_wkfl.sr_domain = global_domain and  sr_userid =
                      mfguser and sr_lineid = "+" + part
                     break by sr_lotser by sr_ref:
                  accumulate sr_qty (sub-total by sr_ref).

                  if last-of(sr_ref)
                  then
                     run create_bkfl_output_wip_lot_temptable
                        in h_wiplottrace_procs
                        (input sr_lotser,
                        input sr_ref,
                        (accum sub-total by sr_ref sr_qty) / conv).
               end. /* FOR EACH sr_wkfl */
            end. /* IF is_last_operation */

            /*CHECK FOR COMBINED LOTS - INPUT WIP AND COMPONENTS */
            /*TO A PARTICULAR OUTPUT WIP LOT                     */

            run bkfl_check_for_combined_lots in h_wiplottrace_procs
               (input cumwo_lot,
                input op,
                input conv,
                output result_status).

            if result_status = FAILED_EDIT
            then do:

               view frame a.
               view frame d.

               if batchrun
               then
                  undo main, leave main.
               else
                  undo, retry.
            end. /* IF result_status = FAILED_EDIT */

            /*CHECK FOR SPLIT LOTS - OUTPUT WIP AND COMPONENTS */
            /*TO A PARTICULAR INPUT WIP LOT                    */

            consider_output_qty = yes.

            run bkfl_check_for_split_lots in h_wiplottrace_procs
               (input cumwo_lot,
               input op,
               input conv,
               input consider_output_qty,
               output result_status).

            if result_status = FAILED_EDIT
            then do:

               view frame a.
               view frame d.

               if batchrun
               then
                  undo main, leave main.
               else
                  undo, retry.
            end. /* IF result_status = FAILED_EDIT */

            /*CHECK FOR MAX LOT SIZE EXCEEDED*/

            run bkfl_max_lotsize_check in h_wiplottrace_procs
               (input cumwo_lot,
                input op,
                input conv).
         end. /* IF is_wiplottrace_enabled() AND ... */

         for first wo_mstr
            fields( wo_domain wo_assay wo_due_date wo_expire wo_grade wo_loc
            wo_lot
                   wo_lot_next wo_lot_rcpt wo_part wo_rctstat wo_status
                   wo_rctstat_active wo_rel_date wo_routing wo_site)
             where wo_mstr.wo_domain = global_domain and  wo_lot = cumwo_lot
         no-lock:
         end. /* FOR FIRST wo_mstr */

         wo_recno = recid(wo_mstr).

         for first wr_route
            fields( wr_domain wr_auto_lbr wr_desc wr_lot wr_mch wr_milestone
            wr_op
                   wr_part wr_run wr_wkctr)
             where wr_route.wr_domain = global_domain and  wr_lot = cumwo_lot
              and wr_op  = op
         no-lock:
         end. /* FOR FIRST wr_route */

         wr_recno = recid(wr_route).

         /* PATCH N1V0 HAS ENABLED CIM LOAD */
         {mpwindow.i
            wo_part
            op
            "if wo_routing = """" then wr_part else wo_routing"
            eff_date
            }

         view frame a.
         view frame d.

         yn = yes.
         {pxmsg.i &MSGNUM=32 &ERRORLEVEL=1 &CONFIRM=yn}
         if yn <> yes
         then
            undo, retry.

         /* TO CHECK THE CUMULATIVE ORDER IS NOT CLOSED */
         /* DURING USER INTERFACE                       */
         if can-find(wo_mstr
             where wo_mstr.wo_domain = global_domain and   wo_lot    = cumwo_lot
            and   wo_status  = "C"
            no-lock)
         then do:

            /* CUM ORDER IS CLOSED */
            {pxmsg.i &MSGNUM=5101 &ERRORLEVEL=3}
            undo main, retry main.

         end. /*  IF CAN-FIND(wo_mstr ... */

         /* TO CHECK THE CUMULATIVE ORDER IS NOT EXPIRED */
         /* DURING USER INTERFACE                        */
         if not can-find(wo_mstr
             where wo_mstr.wo_domain = global_domain and (  wo_lot   = cumwo_lot
            and  (eff_date >= wo_rel_date or wo_rel_date = ?)
            and  (eff_date <= wo_due_date or wo_due_date = ?)
            ) no-lock)
         then do:

            /* CUM ORDER HAS EXPIRED */
            {pxmsg.i &MSGNUM=5124 &ERRORLEVEL=3}
            undo main, retry main.

         end. /* IF NOT CAN-FIND(wo_mstr) */

         {&REBKFL-P-TAG2}

         /* NOW THAT WE HAVE LAST INPUT FROM USER, RECHECK INVENTORY*/
         {gprun.i ""reoptr1f.p""
            "(input """",
              output inv-issued)"}

         if inv-issued
         then
            undo, retry.
      end. /* DO WITH FRAME bkfl1 */

/*mage add 09/01/20*/      trans_type = "BACKFLSH".

      /*************************************/
      /*  GOT ALL DATA AND VALIDATED IT,   */
      /*  NOW WE CAN DO SOMETHING WITH IT  */
      /*************************************/

      /*NO TRANSACTION SHOULD BE PENDING HERE*/
      {gprun.i ""gpistran.p""
         "(input 1,
           input """")"}

      /*CREATE OP_HIST RECORD*/
      {gprun.i ""reophist.p""
         "(input trans_type,
           input cumwo_lot,
           input op,
           input emp,
           input wkctr,
           input mch,
           input dept,
           input shift,
           input eff_date,
           output ophist_recid)"}
      {&REBKFL-P-TAG9}

      /*ISSUE COMPONENTS*/
      {gprun.i ""rebkflis.p""
         "(input cumwo_lot,
           input eff_date,
           input ophist_recid)"}

      {&REBKFL-P-TAG8}
      /*REGISTER QTY PROCESSED FOR NONMILESTONES*/
      {gprun.i ""rebkflnm.p""
         "(input cumwo_lot,
           input op,
           input eff_date,
           input shift,
           input trans_type,
           input conv_qty_proc)"}

      /* REUPOPST.P IS INCLUDED TO FIND THE ALTERNATE WORK CENTER    */
      /* RUN RATE WHEN THE WORK CENTER OR MACHINE DEFINED DURING     */
      /* BACKFLUSH IS DIFFERENT FROM THE ONE DEFINED IN WORK ORDER   */
      /* ROUTING AND TO POPULATE OP_STD_RUN WITH THE CORRECT VALUE.  */
      /* IF THE RATE SET UP IN WORK CENTER/ROUTING(wcr_rate) IS ZERO,*/
      /* THE STANDARD RUN TIME IN THE OPERATION HISTORY(op_std_run)IS*/
      /* NOT CHANGED EVEN IF ALTERNATE WORK CENTER OR MACHINE IS USED*/
      /* FOR REPORTING.                                              */

      if (input wkctr <> wr_wkctr
         or input mch <> wr_mch) then
      do:
         {gprun.i ""reupopst.p"" "(input ophist_recid)"}
      end. /*END OF IF INPUT(INPUT WKCTR */

      /*LABOR AND BURDEN TRANSACTIONS*/
      std_run_hrs = 0.

      do transaction:
         for first wr_route
            fields( wr_domain wr_auto_lbr wr_desc wr_lot wr_mch wr_milestone
            wr_op
                   wr_part wr_run wr_wkctr)
             where wr_route.wr_domain = global_domain and  wr_lot = cumwo_lot
              and wr_op  = op
         no-lock:
         end. /* FOR FIRST wr_route */

         if wr_auto_lbr
         then
            std_run_hrs = conv_qty_proc * wr_run.
      end. /* DO TRANSACTION */

/*minth*/      {gprun.i ""xxrelbra.p""
         "(input cumwo_lot,
           input op,
           input wkctr,
           input mch,
           input dept,
           input (act_run_hrs + std_run_hrs),
           input eff_date,
           input earn_code,
           input emp,
           input true,
           input ophist_recid)"}

      do transaction:
         /*REGISTER QTY PROCESSED (REDUCE INQUE, INCREASE OUTQUE)*/
         {gprun.i ""rebkfla.p""
            "(input cumwo_lot,
              input op,
              input ophist_recid,
              input conv_qty_proc)"}

         /*BACKFLUSH LIST OF INPUT WIP LOTS AND OUTPUT WIP LOTS. */
         /*NOTE THAT THIS HAS TO BE DONE IN THE SAME TRANSACTION */
         /*AS REBKFLA.P.                                         */

         if is_wiplottrace_enabled() and
            is_operation_queue_lot_controlled(cumwo_lot, op, OUTPUT_QUEUE)
         then do:

            for first op_hist
               fields( op_domain op_trnbr op_wo_lot op_wo_op)
               where recid(op_hist) = ophist_recid
            no-lock:
            end. /* FOR FIRST op_hist */

            run bkfl_backflush_wip_lots in h_wiplottrace_procs
               (input op_trnbr,
                input wr_lot,
                input wr_op,
                input conv,
                input site,
                input wkctr,
                input mch).
         end. /* IF is_wiplottrace_enabled() AND .. */
      end. /*TRANSACTION*/

      /* ONLY EXECUTE WAREHOUSE INTERFACE CODE IF WAREHOUSING  */
      /* INTERFACE IS ACTIVE                                   */

      if can-find(first whl_mstr  where whl_mstr.whl_domain = global_domain and
       whl_act = true no-lock)
      then do:

         for each sr_wkfl  where sr_wkfl.sr_domain = global_domain and
         sr_userid = mfguser no-lock:

            /* CREATE A TE_MSTR RECORD */

            {gprun.i ""wireoptr.p""
               "(input 'wi-rebkfl',
                 input wkctr,
                 input sr_qty,
                 input sr_site,
                 input sr_loc,
                 input eff_date,
                 input shift,
                 input wo_part,
                 input sr_lotser,
                 input sr_ref,
                 input um,
                 input conv)"}

         end. /* FOR EACH sr_wkfl */

      end. /* IF CAN-FIND ( FIRST whl_mstr ... */

      /*MOVE TO NEXT OP IF WE NEED TO*/
      if move_next_op
      then do:

         for first wr_route
            fields( wr_domain wr_auto_lbr wr_desc wr_lot wr_mch wr_milestone
            wr_op
                   wr_part wr_run wr_wkctr)
             where wr_route.wr_domain = global_domain and  wr_lot = cumwo_lot
              and wr_op > op
         no-lock:
         end. /* FOR FIRST wr_route */
         if available wr_route
         then do
         transaction:

            {gprun.i ""removea.p""
               "(input cumwo_lot,
                 input op,
                 input eff_date,
                 input ophist_recid,
                 input conv_qty_move)"}

            /*MOVE LIST OF INPUT WIP LOTS AND OUTPUT WIP LOTS*/

            if is_wiplottrace_enabled() and
               is_operation_queue_lot_controlled(cumwo_lot, op, OUTPUT_QUEUE)
            then
               run bkfl_move_wip_lots in h_wiplottrace_procs
                  (input op_wo_lot,
                   input op_wo_op,
                   input conv,
                   input site,
                   input wkctr,
                   input mch,
                   input move_to_wkctr,
                   input move_to_mch).
         end. /* IF is_wiplottrace_enabled() AND .. */
         else do:
            {&REBKFL-P-TAG10}
            /*RECEIVE COMPLETED MATERIAL.                            */
            /*THIS SUBPROGRAM PICKS UP INPUT FROM SR_WKFL            */
/*mage 08/12/30 */              {gprun.i ""xxreceive.p""
               "(input cumwo_lot,
                 input eff_date,
                 input ophist_recid)"}

            {gprun.i ""gplotwdl.p""}

            if clc_lotlevel <> 0
               and pt_lot_ser = "L"
            then
            do transaction:
               find wo_mstr
                   where wo_mstr.wo_domain = global_domain and  wo_lot =
                   cumwo_lot exclusive-lock.
               if available wo_mstr
                  and not wo_lot_rcpt
               then
                  wo_lot_next = "".
            end. /* DO TRANSACTION */
         end. /* ELSE DO */
      end. /* IF move_next_op */

      if is_wiplottrace_enabled() and
         is_operation_queue_lot_controlled(cumwo_lot, op, OUTPUT_QUEUE)
      then do:
/*mage del 09/01/06*****************************
         if qty_rjct <> 0
         then
            run bkfl_reject_wip_lots in h_wiplottrace_procs
               (input ophist_recid,
                input conv,
                input to_op,
                input l_reject_to_wkctr,
                input l_reject_to_mch).
*mage del 09/01/06*****************************/

         if qty_scrap <> 0
         then
            run bkfl_scrap_wip_lots in h_wiplottrace_procs
               (input ophist_recid,
                input conv).
      end. /* IF is_wiplottrace_enabled() AND .. */
      else do:
         /*PROCESS SCRAP QUANTITIES*/
         if outque_multi_entry
         then do:

            do i = 1 to 10:
               if scrap_quantities[i] <> 0
               then do:

                  conv_qty_scrap = scrap_quantities[i] * conv.

                  {gprun.i ""reophist.p""
                     "(input trans_type,
                       input cumwo_lot,
                       input op,
                       input emp,
                       input wkctr,
                       input mch,
                       input dept,
                       input shift,
                       input eff_date,
                       output ophist_recid)"}
                  {&REBKFL-P-TAG11}

/*mage*/                  {gprun.i ""xxrescrapa.p""
                     "(input cumwo_lot,
                       input op,
                       input conv_qty_scrap,
                       input scrap_rsn_codes[i],
                       input yes,
                       input emp,
                       input ophist_recid)"}
               end. /* IF scrap_quantities[i] <> 0 */
            end. /* DO i = 1 TO 10: */
         end. /* IF outque_multi_entry */
         else
         if conv_qty_scrap <> 0
         then do:

/*mage*/            {gprun.i ""xxrescrapa.p""
               "(input cumwo_lot,
                 input op,
                 input conv_qty_scrap,
                 input scrap_rsn_code,
                 input yes,
                 input emp,
                 input ophist_recid)"}
         end. /* ELSE IF conv_qty_scrap */

        /*MAGE DEL 08/12/10*********************************************************************************
         /*PROCESS REJECT QUANTITIES*/
         {gprun.i ""rejectb.p""
            "(input cumwo_lot,
              input op,
              input to_op,
              input emp,
              input shift,
              input eff_date,
              input conv_qty_rjct,
              input trans_type)"}

         if rejque_multi_entry
         then do:

            do i = 1 to 10:
               if reject_quantities[i] <> 0
               then do:

                  conv_qty_rjct = reject_quantities[i] * conv.

                  {gprun.i ""reophist.p""
                     "(input trans_type,
                       input cumwo_lot,
                       input to_op,
                       input emp,
                       input wkctr,
                       input mch,
                       input dept,
                       input shift,
                       input eff_date,
                       output ophist_recid)"}
                  {&REBKFL-P-TAG12}
 
                  {gprun.i ""rejecta.p""
                     "(input cumwo_lot,
                       input to_op,
                       input op,
                       input reject_rsn_codes[i],
                       input ophist_recid,
                       input conv_qty_rjct)"}
               end. /* IF reject_quantities[i] <> 0 */
            end. /* DO i = 1 TO 10 */
         end. /* IF rejque_multi_entry */
         else
         if conv_qty_rjct <> 0
         then do:

            {gprun.i ""reophist.p""
               "(input trans_type,
                 input cumwo_lot,
                 input to_op,
                 input emp,
                 input wkctr,
                 input mch,
                 input dept,
                 input shift,
                 input eff_date,
                 output ophist_recid)"}
            {&REBKFL-P-TAG13}
 
            {gprun.i ""rejecta.p""
               "(input cumwo_lot,
                 input to_op,
                 input op,
                 input rjct_rsn_code,
                 input ophist_recid,
                 input conv_qty_rjct)"}
         end. /* ELSE IF conv_qty_rjct <> 0 */
      end. /* ELSE DO */
*MAGE DEL 08/12/10*********************************************************************************/

/*MAGE ADD 08/12/10*********************************************************************************/
          

         if rejque_multi_entry
         then do:

            do i = 1 to 10:
               if reject_quantities[i] <> 0
               then do:

                  conv_qty_rjct = reject_quantities[i] * conv.

        
           find last xlkh_hist where xlkh_domain = global_domain
        	    use-index xlkh_trnbr no-lock no-error.

              if available xlkh_hist then do:
                 trnbr =  xlkh_trnbr.
	      end.
	      
                create xlkh_hist.
		  assign
		    xlkh_hist.xlkh_domain = global_domain
		    xlkh_hist.xlkh_site = wo_site
		    xlkh_hist.xlkh_line = line1
		    xlkh_hist.xlkh_part = wo_part
		    xlkh_hist.xlkh_barcode = "X" + line + "QC" + reject_rsn_codes[i] 
		    xlkh_hist.xlkh_trnbr = trnbr + 1
		    xlkh_hist.xlkh_date = today
		    xlkh_hist.xlkh_time = time
		    xlkh_hist.xlkh_userid = global_userid
                    xlkh_hist.xlkh_seq = 0
		    xlkh_hist.xlkh_qc_qty = conv_qty_rjct .
 
               end. /* IF reject_quantities[i] <> 0 */
            end. /* DO i = 1 TO 10 */
         end. /* IF rejque_multi_entry */
         else
         if conv_qty_rjct <> 0
         then do:

           find last xlkh_hist where xlkh_domain = global_domain
        	    use-index xlkh_trnbr no-lock no-error.

              if available xlkh_hist then do:
                 trnbr =  xlkh_trnbr.
	      end.
	      
                create xlkh_hist.
		  assign
		    xlkh_hist.xlkh_domain = global_domain
		    xlkh_hist.xlkh_site = wo_site
		    xlkh_hist.xlkh_line = line1
		    xlkh_hist.xlkh_part = wo_part
		    xlkh_hist.xlkh_barcode = "X" + line + rjct_rsn_code 
		    xlkh_hist.xlkh_trnbr = trnbr + 1
		    xlkh_hist.xlkh_date = today
		    xlkh_hist.xlkh_time = time
		    xlkh_hist.xlkh_userid = global_userid
                    xlkh_hist.xlkh_seq = 0
		    xlkh_hist.xlkh_qc_qty = conv_qty_rjct .
 
         end. /* ELSE IF conv_qty_rjct <> 0 */
      end. /* ELSE DO */

/*MAGE ADD 08/12/10*********************************************************************************/

 
 /********* start tx01************/
/** start debug**/
      trans_type = "DOWN".

      /*PROCESS SCRAP QUANTITIES*/
      if prod_multi_entry then do:
         do i = 1 to 10:
            if pd_non_prod_hrs[i] <> 0 then do:
               {gprun.i ""xxrenplfmt.p"" 
                         "(input pd_non_prod_hrs[i],
			   input pd_rsn_codes[i])"}  
	    end. /* IF scrap_quantities[i] <> 0 */
         end. /* DO i = 1 TO 10: */
      end. /* IF act_multi_entry */
      else
         if non_prod_hrs <> 0
         then do:	 
            {gprun.i ""xxrenplfmt.p"" 
                      "(input non_prod_hrs,
 	                input rsn)"}  
         end. /* ELSE IF conv_qty_scrap */
/** end debug**/
      trans_type = "DOWNTIME".

      /*PROCESS SCRAP QUANTITIES*/
      if stop_multi_entry then do:
         do i = 1 to 10:
            if act_setup_hrs20s[i] <> 0 then do:
               {gprun.i ""xxreophist.p""
                         "(input trans_type,
                           input cumwo_lot, 
		    	   input op, 
			   input emp,
                           input wkctr, 
			   input mch, 
			   input dept, 
			   input shift,
                           input eff_date,
			   input down_rsn_codes[i],
                           output ophist_recid)"}
   
/*minth*/      {gprun.i ""redta.p"" 
                         "(input cumwo_lot, 
			   input op,
                           input wkctr, 
			   input mch, 
			   input dept, 
			   input act_setup_hrs20s[i],
                           input eff_date,
                           input earn_code, 
			   input down_rsn_codes[i], 
			   input emp, 
                           input ophist_recid)"}  
	    end. /* IF scrap_quantities[i] <> 0 */
         end. /* DO i = 1 TO 10: */
      end. /* IF act_multi_entry */
      else
         if act_setup_hrs20 <> 0
         then do:	 
            {gprun.i ""xxreophist.p""
                      "(input trans_type,
                        input cumwo_lot, 
			input op, 
			input emp,
                        input wkctr, 
			input mch, 
			input dept, 
			input shift,
                        input eff_date,
			input down_rsn_code,
                        output ophist_recid)"}
   
/*minth*/   {gprun.i ""redta.p"" 
                      "(input cumwo_lot, 
		        input op,
                        input wkctr, 
			input mch, 
			input dept, 
			input act_setup_hrs20,
                        input eff_date,
                        input earn_code, 
			input down_rsn_code, 
			input emp, 
                        input ophist_recid)"}  

         end. /* ELSE IF conv_qty_scrap */
	 
	 trans_type = "SETUP".

         /*PROCESS SCRAP QUANTITIES*/
         if act_multi_entry
         then do:
            do i = 1 to 10:
               if act_hrs[i] <> 0
               then do:
/*apple*/         {gprun.i ""xxreophist.p""
                         "(input trans_type,
                           input cumwo_lot, 
			   input op, 
			   input emp,
                           input wkctr, 
			   input mch, 
			   input dept, 
			   input shift,
                           input eff_date,
			   input act_rsn_codes[i],
                           output ophist_recid)"}

                  /*LABOR AND BURDEN TRANSACTIONS*/
/*minth*/         {gprun.i ""xxrelbra.p"" 
                           "(input cumwo_lot, 
			     input op,
                             input wkctr, 
			     input mch, 
			     input dept, 
			     input act_hrs[i],
                             input eff_date,
                             input earn_code, 
			     input emp, 
			     input false, 
			     input ophist_recid)"}	       
	       end. /* IF scrap_quantities[i] <> 0 */
            end. /* DO i = 1 TO 10: */
         end. /* IF act_multi_entry */
         else
         if act_setup_hrs <> 0
         then do:
            {gprun.i ""xxreophist.p""
                      "(input trans_type,
                        input cumwo_lot, 
			input op, 
			input emp,
                        input wkctr, 
			input mch, 
			input dept, 
			input shift,
                        input eff_date,
			input setup_rsn,
                        output ophist_recid)"}

/*minth*/      {gprun.i ""xxrelbra.p"" 
                         "(input cumwo_lot, 
			   input op,
                           input wkctr, 
			   input mch, 
			   input dept, 
			   input act_setup_hrs,
                           input eff_date,
                           input earn_code, 
			   input emp, 
			   input false, 
			   input ophist_recid)"}
         end. /* ELSE IF conv_qty_scrap */

         for first op_hist where recid(op_hist) = ophist_recid no-lock:
         end.

         if is_wiplottrace_enabled()
            and is_operation_queue_lot_controlled(cumwo_lot, op,
            OUTPUT_QUEUE)
         then do:
            run labor_create_trace_records in h_wiplottrace_procs
                (input op_trnbr, input op_wo_lot, input op_wo_op).
         end.
 /********* end tx01**************/
      global_addr = string(ophist_recid).
      {gprun.i ""reintchk.p""
         "(input cumwo_lot)"}
   end. /* MAINLOOP: */
end. /* MAIN */

if is_wiplottrace_enabled()
then
   delete PROCEDURE h_wiplottrace_procs no-error.
if is_wiplottrace_enabled()
then
   delete PROCEDURE h_wiplottrace_funcs no-error.