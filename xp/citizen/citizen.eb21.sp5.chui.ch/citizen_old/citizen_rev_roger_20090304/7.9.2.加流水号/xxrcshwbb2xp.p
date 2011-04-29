/* rcshwbb2.p - Shipper Workbench Consume Requirements Subprogram             */
/* Copyright 1986-2006 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/*V8:ConvertMode=Maintenance                                                  */
/* REVISION: 8.6    LAST MODIFIED: 09/20/96      BY: TSI *K005*               */
/* REVISION: 8.6    LAST MODIFIED: 11/21/96      BY: *K003* Vinay Nayak-Sujir */
/* REVISION: 8.6    LAST MODIFIED: 12/03/96      BY: *K02T* Chris Theisen     */
/* REVISION: 8.6    LAST MODIFIED: 12/06/96      BY: *K02F* Chris Theisen     */
/* REVISION: 8.6    LAST MODIFIED: 10/13/97      BY: *K0JC* John Worden       */
/* REVISION: 8.6    LAST MODIFIED: 11/11/97      BY: *K18W* Suresh Nayak      */
/* REVISION: 8.6E   LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane            */
/* REVISION: 8.6E   LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan           */
/* REVISION: 8.6E   LAST MODIFIED: 06/01/98   BY: *K1NF* Niranjan R.          */
/* REVISION: 8.6E   LAST MODIFIED: 07/22/98   BY: *J2M7* Niranjan R.          */
/* REVISION: 8.6E   LAST MODIFIED: 12/15/98   BY: *K1YG* Seema Varma          */
/* REVISION: 8.6E   LAST MODIFIED: 06/16/99   BY: *K214* Kedar Deherkar       */
/* REVISION: 8.6E   LAST MODIFIED: 08/06/99   BY: *K21H* Santosh Rao          */
/* REVISION: 9.1    LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane     */
/* REVISION: 9.1    LAST MODIFIED: 04/24/00   BY: *L0PR* Kedar Deherkar       */
/* REVISION: 9.1    LAST MODIFIED: 08/12/00   BY: *N0KP* myb                  */
/* Revision: 1.12.1.9  BY: Paul Donnelly (SB) DATE: 06/28/03 ECO: *Q00N*      */
/* Revision: 1.12.1.10 BY: Geeta Kotian       DATE: 04/28/04 ECO: *P1WY*      */
/* Revision: 1.12.1.11 BY: Reena Ambavi       DATE: 05/28/04 ECO: *P242*      */
/* Revision: 1.12.1.12 BY: cnl                DATE: 03/14/06 ECO: *P4L2*      */
/* $Revision: 1.12.1.13 $  BY: Masroor Alam   DATE: 04/27/06 ECO: *P4QN* */

/* LAST MODIFIED: 2008/05/07   BY: Softspeed roger xiao   ECO: *xp001*      */
/*-Revision end---------------------------------------------------------------*/
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/
/*-Revision end---------------------------------------------------------------*/

{mfdeclre.i}
{gplabel.i} /* EXTERNAL LABEL INCLUDE */

/*INPUT PARAMETERS*/
define input parameter abs_recid as recid no-undo.
define input parameter absship_recid as recid no-undo.

/*LOCAL VARIABLES */
define variable peg_qty like absr_qty no-undo.
define variable open_qty like absr_qty no-undo.
define variable cum_open_qty as decimal no-undo.
define variable cum_all_qty as decimal no-undo.
define variable ship_cmplt as decimal no-undo.
define variable item_all_qty as decimal no-undo.
define variable shipid as character no-undo.

define variable first_column as character no-undo.
define variable disp_line as character no-undo.
define variable gwt_um as character no-undo.
define variable cnsm_req as logical no-undo.

define variable cmmts like mfc_logical label "Comments" no-undo.
define variable part_order like abs_order no-undo.
define variable part_order_line like abs_line no-undo.
define variable l_abs_pick_qty like sod_qty_pick no-undo.
define variable l_abs_tare_wt  like abs_nwt no-undo.
define variable l_twt_um       as character no-undo.
define variable l_first        as logical initial true no-undo.
define variable l_recid        as recid   no-undo.
define variable l_curr_recid   as recid   no-undo.
define variable l_fst_cum_open as decimal initial 0 no-undo.
define variable l_fst_cum_all  as decimal initial 0 no-undo.
define variable l_prev_openqty like absr_qty        no-undo.
define variable cancel_bo      like mfc_logical     no-undo.
define query    q_schd_det     for  schd_det scrolling.
define variable l_confirmed    like mfc_logical no-undo.

/*WORKFILES*/
define workfile prior no-undo
   field prior_open_qty as decimal
   field prior_all_qty as decimal.

/*BUFFERS*/
define buffer ship_line  for abs_mstr.
define buffer b_abs_mstr for abs_mstr.

/*CONTAINER WORKBENCH FORMS*/
{xxrcshwbfmxp.i} /*xp001*/

find abs_mstr
   where recid(abs_mstr) = absship_recid
no-lock.

shipid =  abs_id.

find abs_mstr
   where recid(abs_mstr) = abs_recid
no-lock.

find so_mstr
   where so_mstr.so_domain = global_domain
   and   so_nbr            = abs_order
no-lock.

find sod_det
   where sod_det.sod_domain = global_domain
   and   sod_nbr            = abs_order
   and   sod_line           = integer(abs_line)
no-lock.

ship_cmplt = if so_ship_cmplt = 0
             then
                100
             else
                so_ship_cmplt.

for each absr_det
      where absr_det.absr_domain = global_domain
      and   absr_shipfrom        = abs_shipfrom
      and   absr_id              = abs_id
      and absr_rlse_id  = sod_curr_rlse_id[3]
      and   not absr_cnfrmd
   no-lock:

   peg_qty = peg_qty + absr_qty.

end. /* FOR EACH absr_det */

pause 0.

MAIN:
do transaction on endkey undo:
   clear frame peg-2 all no-pause.

   open query q_schd_det for each schd_det exclusive-lock
      where schd_det.schd_domain =
      global_domain and  schd_type    = 3        and
      schd_nbr     = sod_nbr  and
      schd_line    = sod_line and
      schd_rlse_id = sod_curr_rlse_id[3].
   get first q_schd_det exclusive-lock.

   if not available schd_det
   then do:
      /* NO REQUIRED SHIP SCHEDULE DETAIL RECORDS ARE AVAILABLE */
      {pxmsg.i &MSGNUM=1532 &ERRORLEVEL=4}
      return.
   end. /* IF NOT AVAILABLE schd_det THEN DO */

   repeat while available schd_det
      with frame peg-2:

      /* THE BELOW SECTION MOVED TO INTERNAL PROCEDURE P-OPENQTY */

      run p-openqty.
      assign
         cum_open_qty = cum_open_qty + open_qty
         cum_all_qty  = cum_all_qty + schd_all_qty.

      if available schd_det
      then
         find absr_det
            where absr_det.absr_domain = global_domain
            and   absr_shipfrom        = abs_shipfrom
            and   absr_id              = abs_id
            and   absr_type            = schd_type
            and   absr_nbr             = schd_nbr
            and   absr_line            = schd_line
            and   absr_rlse_id         = schd_rlse_id
            and   absr_date            = schd_date
            and   absr_time            = schd_time
            and   absr_interval        = schd_interval
            and   absr_reference       = schd_reference
         no-lock no-error.

      if available absr_det
         or open_qty <> 0
      then do:
         display
            schd_date
            schd_time
            schd_interval
            schd_reference
            open_qty
            if available absr_det
            then
               absr_qty
            else
               0 @ absr_qty.

         /* OBTAINING THE RECID OF THE FIRST RECORD BEING   */
         /* DISPLAYED, SO THAT IN THE END OF THIS LOOP, THE */
         /* CURSOR IS POSITIONED AT THE CORRECT RECORD      */
         if l_first
         then do:
            assign
               l_recid        = recid(schd_det)
               l_first        = false
               l_fst_cum_open = cum_open_qty - open_qty
               l_fst_cum_all  = cum_all_qty  - schd_all_qty.

            display
               abs_qty
               peg_qty
            with frame peg-1.
         end. /* IF l_first THEN DO */

         if frame-line(peg-2) = frame-down(peg-2)
         then
            leave.

         down 1.
      end. /* IF AVAILABLE ABSR_DET OR OPEN_QTY <> 0 */

      get next q_schd_det exclusive-lock.

   end. /* REPEAT WITH FRAME peg-2 */

   if l_first
   then do:
      /* THERE ARE NO OPEN REQUIREMENTS FOR THIS SCHEDULE ORDER */
      {pxmsg.i &MSGNUM=2985 &ERRORLEVEL=1}
      leave main.
   end. /* IF L_FIRST THEN */

   up frame-line(peg-2) - 1 with frame peg-2.

   /* FINDING THE RECORD THAT WAS ACTUALLY DISPLAYED FIRST */
   if l_recid <> ?
   then
      reposition q_schd_det to recid l_recid.
   get next q_schd_det exclusive-lock.

   create prior.
   assign
      prior_all_qty = if available schd_det
                      then
                         schd_all_qty
                      else
                         0
      cum_all_qty   = l_fst_cum_all
      cum_open_qty  = l_fst_cum_open.

   DETAIL1:
   repeat with frame peg-2:

      display
         peg_qty
      with frame peg-1.

      /* THE BELOW SECTION MOVED TO INTERNAL PROCEDURE P-OPENQTY */

      run p-openqty.

      if available schd_det then
   do:
         find absr_det
            where absr_det.absr_domain = global_domain and
            absr_shipfrom  = abs_shipfrom
            and absr_id        = abs_id
            and absr_type      = schd_type
            and absr_nbr       = schd_nbr
            and absr_line      = schd_line
            and absr_rlse_id   = schd_rlse_id
            and absr_date      = schd_date
            and absr_time      = schd_time
            and absr_interval  = schd_interval
            and absr_reference = schd_reference
         exclusive-lock no-error.

         l_curr_recid = recid(schd_det).
      end. /* IF AVAILABLE SCHD_DET */

      if available absr_det or
         open_qty <> 0 then
      display
         schd_date      when (available schd_det)
         schd_time      when (available schd_det)
         schd_interval  when (available schd_det)
         schd_reference when (available schd_det)
         if available schd_det then open_qty else 0 @ open_qty
         if available absr_det then absr_qty else 0 @ absr_qty.

      prompt-for
         absr_qty

         go-on(F9 cursor-up F5 F10 cursor-down F4 end-error).

         run p_getparent(input abs_recid, output l_confirmed).

      /*****************************************************/
      /* ABSR_QTY ENTERED                                  */
      /*****************************************************/
      if absr_qty entered
      then do:

         if not l_confirmed
         then do:

            /* THE CHECKING OF PEGGED QUANTITY WITH SHIPPED QUANTITY */
            /* WILL NOT BE DONE FOR EACH CONSUME REQUIREMENT LINE.   */
            /* IT WILL BE DONE ONLY WHEN THE USER EXISTS FROM THE    */
            /* CONSUME REQUIREMENT FRAME                             */

            if input absr_qty > (open_qty + (if available absr_det
                                             then
                                                absr_qty
                                             else
                                                0))
            then do:
               /* SHIP LINE PEG QUANTITY GREATER THAN OPEN QUANTITY */
               {pxmsg.i &MSGNUM=1531 &ERRORLEVEL=3}
               undo, retry DETAIL1.
            end. /* IF INPUT absr_qty > (open_qty ... */

            if not available absr_det
               and input absr_qty > 0
            then do:
               create absr_det.
               absr_det.absr_domain = global_domain.
               assign
                  absr_shipfrom   = abs_shipfrom
                  absr_id         = abs_id
                  absr_type       = schd_type
                  absr_nbr        = schd_nbr
                  absr_line       = schd_line
                  absr_rlse_id    = schd_rlse_id
                  absr_date       = schd_date
                  absr_time       = schd_time
                  absr_interval   = schd_interval
                  absr_reference  = schd_reference
                  absr_qty        = input absr_qty
                  absr_ship_id    = shipid
                  schd_all_qty    = schd_all_qty + absr_qty
                  prior_all_qty   = schd_all_qty
                  peg_qty         = peg_qty + absr_qty
                  item_all_qty    = item_all_qty + absr_qty.

            end. /* IF NOT AVAILABLE absr_det */

            else
               if available absr_det
                  and input absr_qty = 0
               then do:
                  assign
                     schd_all_qty  = max(schd_all_qty - absr_qty,0)
                     prior_all_qty = schd_all_qty
                     peg_qty       = max(peg_qty - absr_qty,0)
                     item_all_qty  = item_all_qty - absr_qty.

                  delete absr_det.

               end. /* IF AVAILABLE absr_det AND INPUT absr_qty = 0 */

            else
               if available absr_det
               then
                  assign
                     schd_all_qty  = schd_all_qty - absr_qty + input absr_qty
                     prior_all_qty = schd_all_qty
                     peg_qty       = peg_qty - absr_qty + input absr_qty
                     item_all_qty  = item_all_qty - absr_qty + input absr_qty
                     absr_qty.

            assign
               open_qty = max(schd_discr_qty - schd_all_qty - schd_ship_qty,0)
               open_qty = if (schd_all_qty - item_all_qty + schd_ship_qty) /
                              schd_discr_qty * 100 >= ship_cmplt
                          then
                             0
                          else
                             open_qty
               open_qty = if so_cum_acct
                          then
                             max(schd_cum_qty - sod_cum_qty[1] - cum_open_qty -
                                 cum_all_qty - schd_all_qty,0)
                          else
                             open_qty.

            display
               open_qty.
            pause 0.

         end. /* IF NOT l_confirmed */

         else do:
            /* NO MODIFICATION ALLOWED TO */
            /* CONFIRMED SHIPPER          */
            {pxmsg.i &MSGNUM=6570 &ERRORLEVEL=3}
            undo DETAIL1, retry DETAIL1.
         end. /* ELSE DO */

      end. /* absr_qty ENTERED */


      /*****************************************************/
      /* CURSOR-UP                                         */
      /*****************************************************/
      if    lastkey = keycode("F9")
         or lastkey = keycode("CURSOR-UP")
      then do:

         get prev q_schd_det exclusive-lock.

         if available schd_det
         then do:
            /* POSITIONING CURSOR TO PREVIOUS RECORD THAT WAS */
            /* ACTUALLY DISPLAYED                             */
            repeat while available schd_det:
               assign
                  cum_all_qty    = cum_all_qty  - schd_all_qty
                  cum_open_qty   = cum_open_qty - prior_open_qty
                  l_prev_openqty = open_qty.

               /* FINDING OPEN QTY FOR THE PREVIOUS RECORD OBTAINED */
               run p-openqty.

               for first absr_det
                  fields(absr_domain    absr_cnfrmd  absr_date     absr_id
                         absr_interval  absr_line    absr_nbr      absr_qty
                         absr_reference absr_rlse_id absr_shipfrom
                         absr_ship_id   absr_time    absr_type)
                  where absr_det.absr_domain = global_domain
                  and   absr_shipfrom        = abs_shipfrom
                  and   absr_id              = abs_id
                  and   absr_type            = schd_type
                  and   absr_nbr             = schd_nbr
                  and   absr_line            = schd_line
                  and   absr_rlse_id         = schd_rlse_id
                  and   absr_date            = schd_date
                  and   absr_time            = schd_time
                  and   absr_interval        = schd_interval
                  and   absr_reference       = schd_reference
               no-lock:
               end. /* FOR FIRST ABSR_DET */

               if available absr_det
                  or open_qty <> 0
               then do:

                  up 1 with frame peg-2.

                  /* MOVED THIS CODE ABOVE */

                  delete prior.
                  find prev prior.
                  leave.
               end. /* IF AVAILABLE ABSR_DET OR OPEN_QTY <> 0 */

               else do:
                  assign
                     cum_all_qty  = cum_all_qty  + schd_all_qty
                     cum_open_qty = cum_open_qty + prior_open_qty
                     open_qty     = l_prev_openqty.
               end. /* ELSE DO */

               get prev q_schd_det exclusive-lock.

               if not available schd_det
               then do:
                  /* BEGINNING OF FILE */
                  {pxmsg.i &MSGNUM=21 &ERRORLEVEL=1}
                  reposition q_schd_det to recid l_curr_recid .
                  get next q_schd_det exclusive-lock.
                  leave.
               end. /* IF NOT AVAIL SCHD_DET */
            end. /* REPEAT */
         end. /* IF AVAILABLE SCHD_DET */

         else do:
            /* BEGINNING OF FILE */
            {pxmsg.i &MSGNUM=21 &ERRORLEVEL=1}

            reposition q_schd_det to recid l_curr_recid .
            get next q_schd_det exclusive-lock.

         end. /* ELSE   */
      end. /* CURSOR-UP */

      /*****************************************************/
      /* CURSOR DOWN                                       */
      /*****************************************************/
      else
         if lastkey    = keycode("F10")
            or lastkey = keycode("CURSOR-DOWN")
            or lastkey = keycode("RETURN")
         then do:

            get next q_schd_det exclusive-lock.

            if available schd_det
            then do:
               /* POSITIONING CURSOR TO NEXT RECORD THAT WAS */
               /* ACTUALLY DISPLAYED                         */
               repeat while available schd_det:
                  assign
                     cum_all_qty    = cum_all_qty  + prior_all_qty
                     cum_open_qty   = cum_open_qty + open_qty
                     l_prev_openqty = open_qty.

                  /* FINDING OPEN QTY FOR THE NEXT RECORD OBTAINED */
                  run p-openqty.

                  for first absr_det
                     fields(absr_domain    absr_cnfrmd  absr_date     absr_id
                            absr_interval  absr_line    absr_nbr      absr_qty
                            absr_reference absr_rlse_id absr_shipfrom
                            absr_ship_id   absr_time    absr_type)
                     where absr_det.absr_domain = global_domain
                     and   absr_shipfrom        = abs_shipfrom
                     and   absr_id              = abs_id
                     and   absr_type            = schd_type
                     and   absr_nbr             = schd_nbr
                     and   absr_line            = schd_line
                     and   absr_rlse_id         = schd_rlse_id
                     and   absr_date            = schd_date
                     and   absr_time            = schd_time
                     and   absr_interval        = schd_interval
                     and   absr_reference       = schd_reference
                  no-lock:
                  end. /* FOR FIRST ABSR_DET */

                  if available absr_det
                     or open_qty <> 0
                  then do:

                     down 1 with frame peg-2.

                     /* MOVED THIS CODE ABOVE */

                     create prior.
                     assign

                        prior_open_qty = l_prev_openqty
                        prior_all_qty  = schd_all_qty.

                     leave.
                  end. /* IF AVAILABLE ABSR_DET OR OPEN_QTY <> 0 */

                  else do:
                     assign
                        cum_all_qty  = cum_all_qty  - prior_all_qty
                        cum_open_qty = cum_open_qty - open_qty
                        open_qty     = l_prev_openqty.
                  end. /* ELSE DO */

                  get next q_schd_det exclusive-lock.

                  if not available schd_det
                  then do:
                  /* END OF FILE */
                  {pxmsg.i &MSGNUM=20 &ERRORLEVEL=1}
                  reposition q_schd_det to recid l_curr_recid.
                  get next q_schd_det exclusive-lock.
                  leave.
               end. /* IF NOT AVAILABLE SCHD_DET */
            end. /* REPEAT */
         end. /* IF AVAILABLE SCHD_DET */
         else do:
            /* END OF FILE */
            {pxmsg.i &MSGNUM=20 &ERRORLEVEL=1}

            reposition q_schd_det to recid l_curr_recid.
            get next q_schd_det exclusive-lock.
         end. /* ELSE DO */
      end. /* CURSOR-DOWN */

      else
         if    lastkey              = keycode("F4")
            or keyfunction(lastkey) = "END-ERROR"
            or keyfunction(lastkey) = "END-KEY"
         then do:

         if peg_qty > abs_qty
            and not l_confirmed
         then do:
            /* QUANTITY PEGGED GREATER THAN SHIP LINE QUANTITY */
            {pxmsg.i &MSGNUM=1652 &ERRORLEVEL=3}
            undo DETAIL1, retry DETAIL1.
         end. /* IF peg_qty > abs_qty  */
         else
            undo DETAIL1, leave DETAIL1.
      end. /* ELSE IF LASTKEY = KEYCODE("F4") OR .. */

   end. /* REPEAT WITH FRAME peg-2 */

end. /* MAIN: do transaction */

close query q_schd_det.

hide frame peg-1 no-pause.
hide frame peg-2 no-pause.

PROCEDURE p-openqty:

   /* THIS PROCEDURE CALCULATES THE OPEN QUANTITY FOR SCHEDULE */
   /* DETAIL LINES                                             */

   item_all_qty = 0.

   if not so_mstr.so_cum_acct
   then
      for each ship_line
         fields(abs_domain   abs_fa_lot abs_gwt   abs_id     abs_line  abs_loc
                abs_lotser   abs_nwt    abs_order abs_par_id abs_qty   abs_ref
                abs_shipfrom abs_site   abs_vol   abs_vol_um abs_wt_um
                abs__qad02)
         where ship_line.abs_domain    = global_domain
         and   ship_line.abs_shipfrom  = abs_mstr.abs_shipfrom
         and   ship_line.abs_par_id    = abs_mstr.abs_par_id
         and   ship_line.abs_order     = abs_mstr.abs_order
         and   ship_line.abs_line      = abs_mstr.abs_line
      no-lock:
      for each absr_det
            fields(absr_domain  absr_cnfrmd   absr_date    absr_id absr_interval
                   absr_line    absr_nbr      absr_qty     absr_reference
                   absr_rlse_id absr_shipfrom absr_ship_id
                   absr_time    absr_type)
            where absr_det.absr_domain     = global_domain
            and   absr_det.absr_shipfrom   = ship_line.abs_shipfrom
            and   absr_det.absr_id         = ship_line.abs_id
            and   absr_det.absr_type       = schd_det.schd_type
            and   absr_det.absr_nbr        = schd_det.schd_nbr
            and   absr_det.absr_line       = schd_det.schd_line
            and   absr_det.absr_rlse_id    = schd_det.schd_rlse_id
            and   absr_det.absr_date       = schd_det.schd_date
            and   absr_det.absr_time       = schd_det.schd_time
            and   absr_det.absr_interval   = schd_det.schd_interval
            and   absr_det.absr_reference  = schd_det.schd_reference
            and   not absr_cnfrmd
         no-lock:

         item_all_qty = item_all_qty + absr_qty.

      end. /* FOR EACH ABSR_DET */
   end. /* FOR EACH SHIP_LINE */

   assign
      open_qty = max(schd_discr_qty - schd_all_qty - schd_ship_qty, 0)
      open_qty = if (schd_all_qty - item_all_qty + schd_ship_qty) /
                     schd_discr_qty * 100 >= ship_cmplt
                 then
                    0
                 else
                    open_qty
      open_qty = if so_cum_acct
                 then
                    max(schd_cum_qty - sod_det.sod_cum_qty[1] - cum_open_qty -
                        cum_all_qty - schd_all_qty,0)
                 else
                    open_qty.

END PROCEDURE. /* END PROCEDURE */

PROCEDURE p_getparent:

   /* THIS PROCEDURE IS USED TO FIND IF THE */
   /* SHIPPER IS A CONFIRMED SHIPPER        */

   define input parameter  p_recid     as recid no-undo.
   define output parameter p_confirmed as logical initial false no-undo.

   define variable l_par_recid as recid no-undo.

   /* Find top-level parent shipper or preshipper */
   {gprun.i ""gpabspar.p""
            "(input p_recid,
              input 'PS',
              input false,
              output l_par_recid)"}

   find b_abs_mstr no-lock where recid(b_abs_mstr) = l_par_recid
      no-error.

   if available b_abs_mstr
   then do:
      if b_abs_mstr.abs_par_id = ""
      then do:
         if trim(substring(b_abs_mstr.abs_status,2,1)) = "y"
         then do:

                     if not p_confirmed
                     then
                        p_confirmed = yes.

         end. /* IF TRIM(SUBSTRING(b_abs_mstr.abs_status,2,1)) <> "y" */
      end. /* IF b_abs_mstr.abs_par_id = "" */
   end. /* IF AVAILABLE b_abs_mstr */

END PROCEDURE.  /* p_getparent */
