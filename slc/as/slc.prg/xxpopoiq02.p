/* popoiq02.p - PURCHASE ORDER RECEIPT HISTORY INQUIRY                  */
/* Copyright 1986-2006 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.         */
/*                                                                            */
/*               (replaced mfpoiq01.p which used tr_hist)     */
/* REVISION: 4.0     LAST MODIFIED: 04/15/88    BY: FLM *A108**/
/* REVISION: 4.0     LAST MODIFIED: 12/30/87    BY: WUG *A137**/
/* REVISION: 4.0     LAST MODIFIED: 12/09/88    BY: RL  *C0028*/
/* REVISION: 5.0     LAST MODIFIED: 05/03/89    BY: WUG *B098**/
/* REVISION: 5.0     LAST MODIFIED: 06/29/89    BY: RL  *B166**/
/* REVISION: 6.0     LAST MODIFIED: 05/24/90    BY: WUG *D002**/
/* REVISION: 6.0     LAST MODIFIED: 08/14/90    BY: RAM *D030**/
/* REVISION: 6.0     LAST MODIFIED: 09/19/91    BY: RAM *D868**/
/* Revision: 7.3     LAST MODIFIED: 11/19/92    By: jcd *G339* */
/* REVISION: 7.3     LAST MODIFIED: 09/20/94    BY: jpm *GM74**/
/* REVISION: 7.3     LAST MODIFIED: 11/07/94    BY: ljm *GO15**/
/* REVISION: 7.4     LAST MODIFIED: 04/10/96    BY: jzw *G1LD**/
/* REVISION: 7.4     LAST MODIFIED: 11/19/96    BY: *H0PG* Suresh Nayak */
/* REVISION: 7.4     LAST MODIFIED: 03/24/97    BY: *H0VG* Aruna Patil  */
/* REVISION: 8.6     LAST MODIFIED: 03/09/98    BY: *K1L2* Beena Mol    */
/* REVISION: 8.6     LAST MODIFIED: 05/20/98    BY: *K1Q4* Alfred Tan   */
/* REVISION: 8.6     LAST MODIFIED: 03/09/98    BY: *K1L2* Beena Mol    */
/* REVISION: 8.6     LAST MODIFIED: 05/20/98    BY: *K1Q4* Alfred Tan   */
/* REVISION: 8.6     LAST MODIFIED: 06/03/98    BY: *K1RS* A.Shobha     */
/* REVISION: 8.6E    LAST MODIFIED: 07/08/98    BY: *L020* Charles Yen   */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane */
/* REVISION: 9.1      LAST MODIFIED: 08/13/00   BY: *N0KQ* myb              */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* Old ECO marker removed, but no ECO header exists *K1L2*                    */
/* Revision: 1.13.1.3         BY: Dan Herman      DATE: 04/17/02  ECO: *P043* */
/* Revision: 1.13.1.4  BY: Hareesh V. DATE: 06/21/02 ECO: *N1HY* */
/* Revision: 1.13.1.6  BY: Paul Donnelly (SB) DATE: 06/28/03 ECO: *Q00J* */
/* Revision: 1.13.1.7   BY: Robin McCarthy      DATE: 08/11/05  ECO: *P2PJ* */
/* $Revision: 1.13.1.7.1.1 $  BY: Sumaiya Mujawar     DATE: 06/21/06  ECO: *P4VB* */
/*-Revision end---------------------------------------------------------------*/

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/*V8:ConvertMode=Report                                                       */
{mfdtitle.i "1+ "}
{apconsdf.i}

define variable mc-error-number like msg_nbr no-undo.

define variable vend            like po_vend                            no-undo.
define variable nbr             like po_nbr                             no-undo.
define variable sord            like pod_so_job                         no-undo.
define variable part            like pt_part                            no-undo.
define variable receiver        like prh_receiver                       no-undo.
define variable rcp_date        like prh_rcp_date                       no-undo.
define variable base_cost       like prh_pur_cost                       no-undo.
define variable base_rpt        like po_curr                            no-undo.
define variable disp_curr       as character format "x(1)" label "C"    no-undo.
define variable pvod_ex_rate    like prh_ex_rate                        no-undo.
define variable pvod_ex_rate2   like prh_ex_rate2                       no-undo.
define variable pvod_trans_qty  like pvo_trans_qty                      no-undo.
define variable pvod_pur_cost   like prh_pur_cost                       no-undo.

part = global_part.

form
   part
   /*V8! view-as fill-in size 10 by 1 space(.5) */
   nbr
   /*V8! space(.5) */
   vend
   /*V8! space(.5) */
   receiver
   /*V8! view-as fill-in size 8 by 1 space(.5) */
   rcp_date
   /*V8! view-as fill-in size 8 by 1 space(.5) */
   sord
   /*V8! space(.5) */
   base_rpt
   /*V8! view-as fill-in size 5 by 1 */
with frame a width 80 no-underline no-attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

{wbrp01.i}

repeat:

   if c-application-mode <> "WEB" then
   update part nbr vend receiver rcp_date sord base_rpt
      with frame a
   editing:

      if frame-field = "part" then do:
         /* FIND NEXT/PREVIOUS RECORD */
         {mfnp.i pod_det part  " pod_det.pod_domain = global_domain and
         pod_part "  part pod_part pod_part}
         if recno <> ? then do:
            part = pod_part.
            display part with frame a.
            recno = ?.
         end.
      end.
      else do:
         status input.
         readkey.
         apply lastkey.
      end.
   end.

   /* CURRENCY CODE VALIDATION */
   if base_rpt <> "" then do:
      {gprunp.i "mcpl" "p" "mc-chk-valid-curr"
         "(input input base_rpt,
           output mc-error-number)"}
      if mc-error-number <> 0 then do:
         {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=3} /* INVALID CURRENCY */
         next-prompt base_rpt.
         next.
      end.
   end.

   {wbrp06.i &command = update &fields = "  part nbr vend receiver
        rcp_date sord base_rpt" &frm = "a"}

   if (c-application-mode <> "WEB") or
      (c-application-mode = "WEB" and
      (c-web-request begins "DATA")) then do:

      hide frame b.
      hide frame c.
      hide frame d.
      hide frame e.
      hide frame f.
      hide frame g.
      hide frame h.

   end.

   /* OUTPUT DESTINATION SELECTION */
   {gpselout.i &printType = "terminal"
               &printWidth = 80
               &pagedFlag = " "
               &stream = " "
               &appendToFile = " "
               &streamedOutputToTerminal = " "
               &withBatchOption = "no"
               &displayStatementType = 1
               &withCancelMessage = "yes"
               &pageBottomMargin = 6
               &withEmail = "yes"
               &withWinprint = "yes"
               &defineVariables = "yes"}

   if part <> "" then
      repeat for prh_hist with frame b width 120 on endkey undo, leave:
      find prev prh_hist  where prh_hist.prh_domain = global_domain and (
      prh_part = part
         and (vend = "" or prh_vend = vend)
         and (nbr = "" or prh_nbr = nbr)
         and (receiver = "" or prh_receiver = receiver)
         and (rcp_date = ? or prh_rcp_date = rcp_date)
         and (base_rpt = prh_curr
         or base_rpt = "")
      ) no-lock.
      if available prh_hist then do:

         for each pvo_mstr no-lock where
                  pvo_domain = global_domain
              and pvo_internal_ref_type = {&TYPE_POReceiver}
              and pvo_lc_charge = ""
              and pvo_internal_ref = prh_receiver
              and pvo_line = prh_line,
             each pvod_det no-lock where
                  pvo_domain = global_domain
              and pvod_id = pvo_id:

             {gpextget.i &OWNER      = 'ADG'
                         &TABLENAME  = 'pvod_det'
                         &REFERENCE  = '10074a'
                         &KEY1       = global_domain
                         &KEY2       = string(pvod_id)
                         &KEY3       = string(pvod_id_line)
                         &DEC1       = pvod_trans_qty
                         &DEC3       = pvod_pur_cost}
            assign
               base_cost = pvod_pur_cost
               disp_curr = "".

            if prh_curr <> base_curr then do:
               if base_rpt <> "" then do:

                  {gpextget.i &OWNER      = 'ADG'
                              &TABLENAME  = 'pvod_det'
                              &REFERENCE  = '10074b'
                              &KEY1       = global_domain
                              &KEY2       = string(pvod_id)
                              &KEY3       = string(pvod_id_line)
                              &DEC1       = pvod_ex_rate
                              &DEC2       = pvod_ex_rate2}

                  {gprunp.i "mcpl" "p" "mc-curr-conv"
                            "(input  base_curr,
                              input  prh_curr,
                              input  pvod_ex_rate2,
                              input  pvod_ex_rate,
                              input  base_cost,
                              input  false, /* DO NOT ROUND */
                              output base_cost,
                              output mc-error-number)"}

               end.  /* IF base_rpt <> "" */
               else
                  disp_curr = getTermLabel("YES",1).

            end.  /* base_curr <> prh_curr */

            if sord <> "" then do:
               find pod_det where
                    pod_det.pod_domain = global_domain
                and pod_nbr = prh_nbr
                and pod_line = prh_line
                and pod_so_job = sord no-lock no-error.

               if not available pod_det then next.
            end. /* IF sord <> "" */

            /* SET EXTERNAL LABELS */
            setFrameLabels(frame b:handle).
            display
               prh_vend
               prh_nbr
               pvod_trans_qty * prh_um_conv
               @ prh_rcvd format "->>>>>>9.99<<<<<<"
               prh_rcp_type
               base_cost @ prh_pur_cost
               disp_curr
               prh_rcp_date
               prh_receiver
               prh_line
               prh_site with down frame b width 120.
         end. /* EACH pvo_mstr, pvod_det */
      end.
   end.

   else
   if nbr <> "" then
      loopc:
   for each prh_hist  where prh_hist.prh_domain = global_domain and  (prh_nbr =
   nbr) no-lock,
       each pvo_mstr no-lock where
            pvo_domain = global_domain
        and pvo_internal_ref_type = {&TYPE_POReceiver}
        and pvo_lc_charge = ""
        and pvo_internal_ref = prh_receiver
        and pvo_line = prh_line,
       each pvod_det no-lock where
            pvod_domain = global_domain
        and pvod_id = pvo_id
      with frame c width 120 on endkey undo, leave loopc:
      /* SET EXTERNAL LABELS */
      setFrameLabels(frame c:handle).
      {mfrpchk.i}
      if (vend = "" or prh_vend = vend)
         and (receiver = "" or prh_receiver = receiver)
         and (rcp_date = ? or prh_rcp_date = rcp_date)
         and (base_rpt = prh_curr
         or base_rpt = "")
      then do:
         {gpextget.i &OWNER      = 'ADG'
                     &TABLENAME  = 'pvod_det'
                     &REFERENCE  = '10074a'
                     &KEY1       = global_domain
                     &KEY2       = string(pvod_id)
                     &KEY3       = string(pvod_id_line)
                     &DEC1       = pvod_trans_qty
                     &DEC3       = pvod_pur_cost}
         assign
            base_cost = pvod_pur_cost
            disp_curr = "".

         if prh_curr <> base_curr then do:
            if base_rpt <> "" then do:

                     {gpextget.i &OWNER      = 'ADG'
                                 &TABLENAME  = 'pvod_det'
                                 &REFERENCE  = '10074b'
                                 &KEY1       = global_domain
                                 &KEY2       = string(pvod_id)
                                 &KEY3       = string(pvod_id_line)
                                 &DEC1       = pvod_ex_rate
                                 &DEC2       = pvod_ex_rate2}

                     {gprunp.i "mcpl" "p" "mc-curr-conv"
                               "(input  base_curr,
                                 input  prh_curr,
                                 input  pvod_ex_rate2,
                                 input  pvod_ex_rate,
                                 input  base_cost,
                                 input  false, /* DO NOT ROUND */
                                 output base_cost,
                                 output mc-error-number)"}

            end.   /* IF base_rpt <> "" */
            else
               disp_curr = getTermLabel("YES",1).
         end.

         if sord <> "" then do:
            find pod_det  where pod_det.pod_domain = global_domain and  pod_nbr
            = prh_nbr
               and pod_line   = prh_line
               and pod_so_job = sord no-lock no-error.
            if not available pod_det then next.
         end. /* IF sord <> "" */

         display
            prh_part
            pvod_trans_qty * prh_um_conv
            @ prh_rcvd format "->>>>>>9.99<<<<<<"
            prh_rcp_type
            base_cost @ prh_pur_cost format "->>>>,>>>,>>9.99<<<"
            disp_curr
            prh_rcp_date
            prh_receiver
            prh_line
            prh_site.
      end.
   end.

   else
   if vend <> "" then
      repeat for prh_hist with frame d width 120 on endkey undo, leave:
      find prev prh_hist  where prh_hist.prh_domain = global_domain and (
      prh_vend = vend
         and (receiver = "" or prh_receiver = receiver)
         and (rcp_date = ? or prh_rcp_date = rcp_date)
         and (base_rpt = prh_curr
         or base_rpt = "")
      ) no-lock.
      if available prh_hist then do:

         for each pvo_mstr no-lock where
                  pvo_domain = global_domain
              and pvo_internal_ref_type = {&TYPE_POReceiver}
              and pvo_lc_charge = ""
              and pvo_internal_ref = prh_receiver
              and pvo_line = prh_line,
             each pvod_det no-lock where
                  pvod_domain = global_domain
              and pvod_id = pvo_id:

             {gpextget.i &OWNER      = 'ADG'
                         &TABLENAME  = 'pvod_det'
                         &REFERENCE  = '10074a'
                         &KEY1       = global_domain
                         &KEY2       = string(pvod_id)
                         &KEY3       = string(pvod_id_line)
                         &DEC1       = pvod_trans_qty}
            if sord <> "" then do:
               find pod_det where pod_det.pod_domain = global_domain and
                    pod_nbr = prh_nbr
                  and pod_line   = prh_line
                  and pod_so_job = sord no-lock no-error.
               if not available pod_det then next.
            end.  /* IF sord <> "" */

            /* SET EXTERNAL LABELS */
            setFrameLabels(frame d:handle).
            display
               prh_nbr
               prh_part
               pvod_trans_qty * prh_um_conv @ prh_rcvd
               prh_rcp_type
               prh_rcp_date
               prh_receiver
               prh_line
               prh_site with frame d down .

            for first pod_det
               where pod_domain = global_domain
               and   pod_nbr    = prh_nbr
               and   pod_line   = prh_line
               and  (sord = "" or pod_so_job = sord)
            no-lock:
            end.
            if available pod_det
            then
               display
                  pod_so_job
               with frame d.
         end.   /* EACH pvo_mstr, pvod_det */
      end.
   end.

   else
   if receiver <> "" then
      repeat for prh_hist with frame e width 120 on endkey undo, leave:
      find prev prh_hist  where prh_hist.prh_domain = global_domain and (
      prh_receiver = receiver
         and (rcp_date = ? or rcp_date = prh_rcp_date)
         and (vend = "" or prh_vend = vend)
         and (base_rpt = prh_curr
         or base_rpt = "")
      ) no-lock.
      if available prh_hist then do:
         for each pvo_mstr no-lock where
                  pvo_domain = global_domain
              and pvo_internal_ref_type = {&TYPE_POReceiver}
              and pvo_lc_charge = ""
              and pvo_internal_ref = prh_receiver
              and pvo_line = prh_line,
             each pvod_det no-lock where
                  pvod_domain = global_domain
              and pvod_id = pvo_id:

             {gpextget.i &OWNER      = 'ADG'
                         &TABLENAME  = 'pvod_det'
                         &REFERENCE  = '10074a'
                         &KEY1       = global_domain
                         &KEY2       = string(pvod_id)
                         &KEY3       = string(pvod_id_line)
                         &DEC1       = pvod_trans_qty
                         &DEC3       = pvod_pur_cost}
            assign
               base_cost = pvod_pur_cost
               disp_curr = "".

            if prh_curr <> base_curr then do:
               if base_rpt <> "" then do:

                  {gpextget.i &OWNER      = 'ADG'
                              &TABLENAME  = 'pvod_det'
                              &REFERENCE  = '10074b'
                              &KEY1       = global_domain
                              &KEY2       = string(pvod_id)
                              &KEY3       = string(pvod_id_line)
                              &DEC1       = pvod_ex_rate
                              &DEC2       = pvod_ex_rate2}

                  {gprunp.i "mcpl" "p" "mc-curr-conv"
                            "(input  base_curr,
                              input  prh_curr,
                              input  pvod_ex_rate2,
                              input  pvod_ex_rate,
                              input  base_cost,
                              input  false, /* DO NOT ROUND */
                              output base_cost,
                              output mc-error-number)"}

               end.   /* IF base_rpt <> "" */
               else
                  disp_curr = getTermLabel("YES",1).
            end.

            if sord <> "" then do:
               find pod_det where pod_det.pod_domain = global_domain and
                    pod_nbr = prh_nbr
                  and pod_line   = prh_line
                  and pod_so_job = sord no-lock no-error.
               if not available pod_det then next.
            end. /* IF sord <> "" */

            /* SET EXTERNAL LABELS */
            setFrameLabels(frame e:handle).
            display
               prh_nbr
               prh_part
               pvod_trans_qty * prh_um_conv
               @ prh_rcvd format "->>>>>>9.99<<<<<<"
               prh_rcp_type
               base_cost @ prh_pur_cost format "->>>>,>>>,>>9.99<<<"
               disp_curr
               prh_rcp_date
               prh_line
               prh_site with frame e down.

         end. /* EACH pvo_mstr, pvod_det */
      end.
   end.

   else
   if rcp_date <> ? then
      repeat for prh_hist with frame f width 120 on endkey undo, leave:
      find prev prh_hist  where  prh_hist.prh_domain = global_domain and
        ( prh_rcp_date = rcp_date
    and ( vend = "" or prh_vend = vend )
    and (base_rpt = prh_curr or base_rpt = "") )
      no-lock.
      if available prh_hist then do:
         for each pvo_mstr no-lock where
                  pvo_domain = global_domain
              and pvo_internal_ref_type = {&TYPE_POReceiver}
              and pvo_lc_charge = ""
              and pvo_internal_ref = prh_receiver
              and pvo_line = prh_line,
             each pvod_det no-lock where
                  pvod_domain = global_domain
              and pvod_id = pvo_id:

             {gpextget.i &OWNER      = 'ADG'
                         &TABLENAME  = 'pvod_det'
                         &REFERENCE  = '10074a'
                         &KEY1       = global_domain
                         &KEY2       = string(pvod_id)
                         &KEY3       = string(pvod_id_line)
                         &DEC1       = pvod_trans_qty
                         &DEC3       = pvod_pur_cost}
            assign
               base_cost = pvod_pur_cost
               disp_curr = "".

            if prh_curr <> base_curr then do:
               if base_rpt <> "" then do:

                  {gpextget.i &OWNER      = 'ADG'
                              &TABLENAME  = 'pvod_det'
                              &REFERENCE  = '10074b'
                              &KEY1       = global_domain
                              &KEY2       = string(pvod_id)
                              &KEY3       = string(pvod_id_line)
                              &DEC1       = pvod_ex_rate
                              &DEC2       = pvod_ex_rate2}

                  {gprunp.i "mcpl" "p" "mc-curr-conv"
                            "(input  base_curr,
                              input  prh_curr,
                              input  pvod_ex_rate2,
                              input  pvod_ex_rate,
                              input  base_cost,
                              input  false, /* DO NOT ROUND */
                              output base_cost,
                              output mc-error-number)"}

               end.   /* IF base_rpt <> "" */
               else
                  disp_curr = getTermLabel("YES",1).
            end.

            if sord <> "" then do:
               find pod_det where pod_det.pod_domain = global_domain and
                    pod_nbr = prh_nbr
                  and pod_line   = prh_line
                  and pod_so_job = sord no-lock no-error.
               if not available pod_det then next.
            end.  /* IF sord <> "" */

            /* SET EXTERNAL LABELS */
            setFrameLabels(frame f:handle).
            display
               prh_nbr
               prh_part
               pvod_trans_qty * prh_um_conv
               @ prh_rcvd format "->>>>>>9.99<<<<<<"
               prh_rcp_type
               base_cost @ prh_pur_cost format "->>>>,>>>,>>9.99<<<"
               disp_curr
               prh_receiver
               prh_line
               prh_site with frame f down.

            end. /* EACH pvo_mstr, pvod_det */
         end.
      end.

   else
   if sord <> "" then
   for each pod_det  where pod_det.pod_domain = global_domain and  pod_so_job =
   sord no-lock
      with frame g width 120:
      /* SET EXTERNAL LABELS */
      setFrameLabels(frame g:handle).
      {mfrpchk.i}
      repeat for prh_hist with frame g width 80
            on endkey undo, leave:
         find prev prh_hist  where prh_hist.prh_domain = global_domain and (
         prh_nbr = pod_nbr
            and prh_line = pod_line and (base_rpt = prh_curr
            or base_rpt = "") ) no-lock.
         if available prh_hist then do:
            for each pvo_mstr no-lock where
                     pvo_domain = global_domain
                 and pvo_internal_ref_type = {&TYPE_POReceiver}
                 and pvo_lc_charge = ""
                 and pvo_internal_ref = prh_receiver
                 and pvo_line = prh_line,
                each pvod_det no-lock where
                     pvod_domain = global_domain
                 and pvod_id = pvo_id:

                {gpextget.i &OWNER      = 'ADG'
                            &TABLENAME  = 'pvod_det'
                            &REFERENCE  = '10074a'
                            &KEY1       = global_domain
                            &KEY2       = string(pvod_id)
                            &KEY3       = string(pvod_id_line)
                            &DEC1       = pvod_trans_qty}

               display
                  prh_vend
                  prh_nbr
                  prh_part
                  pvod_trans_qty * prh_um_conv @ prh_rcvd
                  prh_rcp_type
                  prh_rcp_date
                  prh_receiver
                  prh_line
                  prh_site.
            end. /* EACH pvo_mstr, pvod_det */
         end.
      end.
   end.

   else /* DISPLAY IF NO PARAMETERS INPUT */
   for each prh_hist  where prh_hist.prh_domain = global_domain and  prh_nbr >=
   "" and prh_receiver >= "" and
         prh_part >= "" no-lock,
       each pvo_mstr no-lock where
            pvo_domain = global_domain
        and pvo_internal_ref_type = {&TYPE_POReceiver}
        and pvo_lc_charge = ""
        and pvo_internal_ref = prh_receiver
        and pvo_line = prh_line,
       each pvod_det no-lock where
            pvod_domain = global_domain
        and pvod_id = pvo_id
         by prh_rcp_date descending
      with frame h width 120 on endkey undo, leave:
      /* SET EXTERNAL LABELS */
      setFrameLabels(frame h:handle).
      {mfrpchk.i}
      if (base_rpt <> prh_curr
         and base_rpt <> "") then next.
         {gpextget.i &OWNER      = 'ADG'
                     &TABLENAME  = 'pvod_det'
                     &REFERENCE  = '10074a'
                     &KEY1       = global_domain
                     &KEY2       = string(pvod_id)
                     &KEY3       = string(pvod_id_line)
                     &DEC1       = pvod_trans_qty}
      display
         prh_nbr
         prh_vend
         prh_part
         pvod_trans_qty * prh_um_conv @ prh_rcvd
         prh_rcp_type
         prh_rcp_date
         prh_receiver
         prh_line
         prh_site.
   end.

   {mfreset.i}
   {pxmsg.i &MSGNUM=8 &ERRORLEVEL=1}
end.
global_part = part.

{wbrp04.i &frame-spec = a}
