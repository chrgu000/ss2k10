/* rerpmt.p - REPETITIVE PART SCHEDULE MAINTENANCE                            */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.8.2.8 $                                                       */
/*V8:ConvertMode=Maintenance                                                  */
/* REVISION: 5.0      LAST MODIFIED: 04/11/89   BY: EMB */
/* REVISION: 5.0      LAST MODIFIED: 09/26/89   BY: MLB *B316* (b) */
/* REVISION: 6.0      LAST MODIFIED: 07/06/90   BY: EMB *D040*/
/* REVISION: 6.0      LAST MODIFIED: 03/28/91   BY: emb *D463*/
/* REVISION: 6.0      LAST MODIFIED: 04/11/91   BY: emb *D522*/
/* REVISION: 7.0      LAST MODIFIED: 10/11/91   BY: emb *F024*/
/* REVISION: 7.0      LAST MODIFIED: 02/29/92   BY: smm *F230*/
/* REVISION: 7.0      LAST MODIFIED: 03/24/92   BY: pma *F089*/
/* REVISION: 7.0      LAST MODIFIED: 03/29/92   BY: emb *F331*/
/* REVISION: 7.0      LAST MODIFIED: 06/17/92   BY: emb *F662*/
/* REVISION: 7.3      LAST MODIFIED: 10/12/92   BY: emb *G071*/
/* REVISION: 7.3      LAST MODIFIED: 01/13/93   BY: emb *G689*/
/* REVISION: 7.3      LAST MODIFIED: 01/12/94   BY: emb *GI44*/
/* REVISION: 7.3      LAST MODIFIED: 07/20/94   BY: pxd *GK84*/
/* REVISION: 7.3      LAST MODIFIED: 10/31/94   BY: WUG *GN76*/
/* REVISION: 7.3      LAST MODIFIED: 10/24/94   BY: ljm *GN62*/
/* REVISION: 8.5      LAST MODIFIED: 12/09/94   BY: mwd *J034*/
/* REVISION: 7.3      LAST MODIFIED: 03/13/95   BY: pxe *F0MF*/
/* REVISION: 7.3      LAST MODIFIED: 07/21/95   BY: dzs *F0TB*/
/* REVISION: 7.3      LAST MODIFIED: 11/29/95   BY: jym *G1F8*/
/* REVISION: 7.3      LAST MODIFIED: 02/09/96   BY: emb *G1MZ*/
/* REVISION: 8.5      LAST MODIFIED: 03/13/96   BY: jym *G1PZ*/
/* REVISION: 8.5      LAST MODIFIED: 01/17/97   BY: *G2JV* Julie Milligan     */
/* REVISION: 8.5      LAST MODIFIED: 08/26/97   BY: *H1D9* Manmohan Pardesi   */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane          */
/* REVISION: 8.6E     LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan         */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan         */
/* REVISION: 9.1      LAST MODIFIED: 03/16/99   BY: *N00J* Russ Witt          */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane   */
/* REVISION: 9.1      LAST MODIFIED: 08/12/00   BY: *N0KP* Mark Brown         */
/* REVISION: 9.1      LAST MODIFIED: 11/08/00   BY: *N0TN* Jean Miller        */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* Revision: 1.8.2.5   BY: Jean Miller        DATE: 05/21/02      ECO: *P05V* */
/* Revision: 1.8.2.7   BY: Paul Donnelly (SB) DATE: 06/28/03      ECO: *Q00K* */
/* $Revision: 1.8.2.8 $ BY: Bhavik Rathod          DATE: 12/27/04  ECO: *P31J*  */
/* $Revision: 1.8.2.8 $ BY: Bill Jiang          DATE: 04/29/08  ECO: *SS - 20080429.1*  */
/*-Revision end---------------------------------------------------------------*/

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/* DISPLAY TITLE */
{mfdtitle.i "1+ "}

define new shared variable wo_recno as recid.
define new shared variable prev_status like wo_status.
define new shared variable prev_qty like wo_qty_ord.

define variable rpq_qty  like rps_qty_req extent 8 format ">,>>>,>>9.9<<<<<<".
define variable comp_qty like rps_qty_comp extent 8.
define variable open_qty like rps_qty_req extent 8.

define variable route          like rps_routing extent 7.
define variable bom_code       like rps_bom_code extent 7.
define variable default-route  like pt_routing.
define variable default-bom    like pt_bom_code.
define variable passed         like mfc_logical.
define variable prompt-routing like mfc_logical no-undo.

define variable days as character format "x(10)" extent 8 no-undo.

define variable ii as integer.
define variable due_date as date extent 9.
define variable rel_date as date extent 9.
define variable del-yn like mfc_logical.
define variable start_date like pk_start.
define variable due_date1 as date.
define variable rpsnbr like mrp_nbr.
define variable rpsrecord like rps_record.
define variable leadtime like pt_mfg_lead.
define variable i as integer.
define variable ptstatus like pt_status.
define variable rps_start like rps_due_date.
define variable scrap_pct as decimal.

{mfdatev.i} /* Declaration of variables neseccary for mfdate.i */

define variable using_new_repetitive as logical.
define variable use_op_yield  as logical no-undo.
define variable yield_pct like wo_yield_pct no-undo.
define variable part-or-routing as character no-undo.
define variable yield-op like ro_op no-undo.

define buffer rpsmstr for rps_mstr.

for first mrpc_ctrl
   fields( mrpc_domain mrpc_op_yield)
 where mrpc_ctrl.mrpc_domain = global_domain no-lock: end.

/* Assign the initial value of days */
days[1] = getTermLabel("MONDAY",9) + ":".
days[2] = getTermLabel("TUESDAY",9) + ":".
days[3] = getTermLabel("WEDNESDAY",9) + ":".
days[4] = getTermLabel("THURSDAY",9) + ":".
days[5] = getTermLabel("FRIDAY",9) + ":".
days[6] = getTermLabel("SATURDAY",9) + ":".
days[7] = getTermLabel("SUNDAY",9) + ":".
days[8] = getTermLabel("TOTAL",9) + ":".

find mfc_ctrl  where mfc_ctrl.mfc_domain = global_domain and  mfc_field =
"rpc_using_new" no-lock no-error.
using_new_repetitive = available mfc_ctrl and mfc_logical = true.

/* DO NOT RUN PROGRAM UNLESS QAD_WKFL RECORDS HAVE */
/* BEEN CONVERTED SO THAT QAD_KEY2 HAS NEW FORMAT  */
if can-find(first qad_wkfl  where qad_wkfl.qad_domain = global_domain and
qad_key1 = "rpm_mstr")
   and using_new_repetitive
then do:
   /* Utility: utrecov2.p must be run prior to executing this program */
   {pxmsg.i &MSGNUM=5126 &ERRORLEVEL=3}
   message.
   message.
   leave.
end.

assign
   start_date = today
   rps_start  = today.

find first rpc_ctrl  where rpc_ctrl.rpc_domain = global_domain no-lock no-error.
if available rpc_ctrl then do:

   if rpc_wk_start < 8 then do:

      if rpc_wk_start = 0 then rps_start = rps_start - rpc_sch_bck.
      else do:
         if weekday(today) >= rpc_wk_start
         then
            rps_start = rps_start - weekday(rps_start) + rpc_wk_start.
         else
            rps_start = rps_start - weekday(rps_start) + rpc_wk_start - 7.
      end.

   end.

end.

/* DISPLAY SELECTION FORM */
form
   rps_part  colon 16
   pt_desc1  no-label
   skip
   rps_site  colon 16
   rps_line
   start_date
with frame a side-labels width 80 attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

{rerpfm01.i}

/* DISPLAY */

display
   global_part @ rps_part
   global_site @ rps_site
with frame a.

find first rps_mstr no-lock  where rps_mstr.rps_domain = global_domain and
rps_part = global_part
   and rps_site = global_site no-error.

if available rps_mstr then
   display rps_line with frame a.

display
   start_date with frame a.
display
   days with frame b.

mainloop:
repeat on error undo, retry with frame a:

   prompt-for
      rps_part rps_site
      rps_line
      start_date
   with frame a
   editing:

      if frame-field = "rps_part" then do:

         /* FIND NEXT/PREVIOUS RECORD */
         {mfnp.i rps_mstr rps_part  " rps_mstr.rps_domain = global_domain and
         rps_part "  rps_part rps_part rps_part}

         if recno <> ? then do with frame a:
            find pt_mstr  where pt_mstr.pt_domain = global_domain and  pt_part
            = rps_part no-lock no-error.
            if available pt_mstr then
               display pt_part @ rps_part pt_desc1.
            else
               display " " @ pt_desc1.
         end.

         recno = ?.

      end.

      else if frame-field = "rps_site" then do:
         /* FIND NEXT/PREVIOUS RECORD */
         {mfnp.i si_mstr rps_site  " si_mstr.si_domain = global_domain and
         si_site "  rps_site si_site si_site}
         if recno <> ? then do with frame a:
            display si_site @ rps_site.
         end.
      end.

      else if frame-field = "rps_line" then do:
         /*FIND NEXT/PREVIOUS RECORD */
         {mfnp05.i lnd_det lnd_line
            " lnd_det.lnd_domain = global_domain and lnd_site  = input rps_site
            and lnd_part = input rps_part"
            lnd_line "input rps_line"}
         if recno <> ? then do with frame a:
            find ln_mstr  where ln_mstr.ln_domain = global_domain and  ln_line
            = lnd_line
                           and ln_site = lnd_site
            no-lock no-error.
            if available ln_mstr then
               display ln_line @ rps_line.
         end.
      end.

      else do:
         readkey.
         apply lastkey.
      end.

   end.

   /* ADD/MOD/DELETE */
   find pt_mstr  where pt_mstr.pt_domain = global_domain and  pt_part = input
   rps_part no-lock no-error.
   if available pt_mstr then
      display pt_part @ rps_part pt_desc1.
   else
      display " " @ pt_desc1.

   {gprun.i ""gpsiver.p""
      "(input (input rps_site), input ?, output return_int)"}

   if return_int = 0 then do:
      {pxmsg.i &MSGNUM=725 &ERRORLEVEL=3}
      /*USER DOES NOT HAVE ACCESS TO THIS SITE */
      next-prompt rps_site with frame a.
      undo mainloop, retry.
   end.

   assign
      global_part = input rps_part
      global_site = input rps_site.

   assign
      default-route = ""
      default-bom = ""
      use_op_yield = no
      scrap_pct = 0.

   if available pt_mstr then
      assign
         default-route = pt_routing
         scrap_pct = 1 - pt_yield_pct / 100
         use_op_yield = pt_op_yield
         default-bom = pt_bom_code.

   find ptp_det no-lock  where ptp_det.ptp_domain = global_domain and  ptp_part
   = input rps_part
      and ptp_site = input rps_site no-error.

   if available ptp_det then
      assign
         default-route = ptp_routing
         scrap_pct = 1 - ptp_yld_pct / 100
         use_op_yield = ptp_op_yield
         default-bom = ptp_bom_code.

   find first ln_mstr no-lock  where ln_mstr.ln_domain = global_domain and
   ln_site = input rps_site no-error.

   if available ln_mstr or input rps_line <> "" then do:

      find ln_mstr no-lock  where ln_mstr.ln_domain = global_domain and
      ln_line = input rps_line
         and ln_site = input rps_site no-error.

      if not available ln_mstr then do:
         /* Site Production Line does not exist */
         {pxmsg.i &MSGNUM=8526 &ERRORLEVEL=3}
         next-prompt rps_line.
         undo,retry.
      end.

      find first lnd_det  where lnd_det.lnd_domain = global_domain and
      lnd_line = input rps_line
         and lnd_site = input rps_site
         and lnd_part = input rps_part
      exclusive-lock no-wait no-error.

      if locked lnd_det then do:
         {pxmsg.i &MSGNUM=7006 &ERRORLEVEL=4}
         /*RECORD IS LOCKED. PLEASE TRY AGAIN LATER*/
         undo, retry.
      end.

      if not available lnd_det then do:
         /* Item not defined on this production line */
         {pxmsg.i &MSGNUM=8527 &ERRORLEVEL=3}
         next-prompt rps_line.
         undo,retry.
      end.

   end.

   leadtime = 0.
   if available pt_mstr then
      leadtime = pt_mfg_lead.

   assign start_date.

   if year(start_date) < 0
   then do:
      /*INVALID DATE*/
      {pxmsg.i &MSGNUM=27 &ERRORLEVEL=3}
      next-prompt start_date.
      undo, retry.
   end.

   if start_date = ? then
      start_date = low_date.

   due_date1 = start_date.
   if weekday(due_date1) = 1 then
      due_date1 = due_date1 - 7.
   else
      due_date1 = due_date1 + 1 - weekday(due_date1).

   assign
      rpq_qty = 0
      comp_qty = 0
      open_qty = 0
      route = default-route
      bom_code = default-bom.

   if using_new_repetitive then do:

      define variable r_part as character.
      define variable r_site as character.
      define variable r_line as character.
      define variable key2 as character.

      assign
         r_part = input rps_part
         r_site = input rps_site
         r_line = input rps_line.
   end.

   b-loop:
   repeat with frame b:

      if not can-find (first rps_mstr
                        where rps_mstr.rps_domain = global_domain and  rps_part
                        = input rps_part
                         and rps_site = input rps_site
                         and rps_line = input rps_line
                         and rps_due_date = due_date1 + 1)
         and available pt_mstr
      then do:

         ptstatus = pt_status.
         substring(ptstatus,9,1) = "#".

         if can-find(isd_det  where isd_det.isd_domain = global_domain and
         isd_status = ptstatus
                               and isd_tr_type = "ADD-RE")
         then do:
            if due_date1 > start_date then do:
               {pxmsg.i &MSGNUM=349 &ERRORLEVEL=1}
               leave b-loop.
            end.
            /* Restricted Procedure for item status code # */
            {pxmsg.i &MSGNUM=358 &ERRORLEVEL=3 &MSGARG1=pt_status}
            undo, retry.
         end.

      end.

      assign
         rpq_qty = 0
         comp_qty = 0
         open_qty = 0.

      assign
         route = default-route
         bom_code = default-bom.

      do ii = 1 to 7:

         assign
            due_date[ii] = due_date1 + ii
            rel_date[ii] = ?.

         find rps_mstr using rps_part
            and rps_site
            and rps_line
             where rps_mstr.rps_domain = global_domain and  rps_due_date =
             due_date[ii]
         exclusive-lock no-error.

         if available rps_mstr then do:

            assign
               route[ii] = rps_routing
               bom_code[ii] = rps_bom_code
               rpq_qty[ii]  = rpq_qty[ii] + rps_qty_req
               comp_qty[ii] = comp_qty[ii] + rps_qty_comp
               open_qty[ii] = rpq_qty[ii] - comp_qty[ii]
               rpq_qty[8]   = rpq_qty[8] + rpq_qty[ii]
               comp_qty[8]  = comp_qty[8] + comp_qty[ii]
               rel_date[ii] = rps_rel_date.

            if rel_date[ii] = ? then do:
               {mfdate.i rel_date[ii] due_date[ii] leadtime rps_site}
            end.

         end.

      end.

      del-yn = no.

      display
         due_date[1 for 7]
         rpq_qty
         route
         bom_code
      with frame b.

      do on error undo, retry with frame b:

         ststatus = stline[2].
         status input ststatus.

         set
            rpq_qty[1 for 7]
            route[1 for 7]
            bom_code[1 for 7]
         go-on ("F5" "CTRL-D" "F9" "F10" "PAGE-UP" "PAGE-DOWN")
         with frame b.

         if lastkey = keycode("F9")
         or lastkey = keycode("PAGE-UP")
         then do:
            due_date1 = due_date1 - 7.
            next.
         end.

         else
         if lastkey = keycode("F10")
         or lastkey = keycode("PAGE-DOWN")
         then do:
            due_date1 = due_date1 + 7.
            next.
         end.

         /* DELETE */
         if lastkey = keycode("F5")
         or lastkey = keycode("CTRL-D")
         then do:
            del-yn = yes.
            /* Please confirm delete */
            {pxmsg.i &MSGNUM=11 &ERRORLEVEL=1 &CONFIRM=del-yn}
            if not del-yn then undo, retry.
            assign
               rpq_qty = 0
               open_qty = 0.
         end.

         else
         if rpq_qty[8] <> rpq_qty[1] + rpq_qty[2] + rpq_qty[3] +
                          rpq_qty[4] + rpq_qty[5] + rpq_qty[6] + rpq_qty[7]
            or open_qty[1] <> rpq_qty[1] - comp_qty[1]
            or open_qty[2] <> rpq_qty[2] - comp_qty[2]
            or open_qty[3] <> rpq_qty[3] - comp_qty[3]
            or open_qty[4] <> rpq_qty[4] - comp_qty[4]
            or open_qty[5] <> rpq_qty[5] - comp_qty[5]
            or open_qty[6] <> rpq_qty[6] - comp_qty[6]
            or open_qty[7] <> rpq_qty[7] - comp_qty[7]
         then do:
            rpq_qty[8]  = 0.
            do ii = 1 to 7:
               assign
                  open_qty[ii] = rpq_qty[ii] - comp_qty[ii]
                  rpq_qty[8]   = rpq_qty[8] + rpq_qty[ii]
                  open_qty[8]  = open_qty[8] + open_qty[ii].
            end.

            display rpq_qty[8].

         end.

         do i = 1 to 7:

            find rps_mstr using rps_part
               and rps_site
               and rps_line
                where rps_mstr.rps_domain = global_domain and  rps_due_date =
                due_date[i]
            exclusive-lock no-error.

            if not available rps_mstr and rpq_qty[i] <> 0 then do:
               create rps_mstr. rps_mstr.rps_domain = global_domain.
               assign
                  rps_part
                  rps_site
                  rps_line
                  rps_due_date = due_date[i]
                  rps_rel_date = rel_date[i].

               if length(string(recid(rps_mstr))) > 8  then
                  rpsrecord = integer(substring(string(recid(rps_mstr)),
                              length(string(recid(rps_mstr))) - 7,8)).
               else
                  rpsrecord = recid(rps_mstr).

               do while
                  can-find (rpsmstr  where rpsmstr.rps_domain = global_domain
                  and  rpsmstr.rps_record = rpsrecord):
                  rpsrecord = integer(rpsrecord) + 1.
               end.

               rps_record = rpsrecord.

            end.

            if available rps_mstr then do:

               rpsrecord = recid(rps_mstr).

               find rps_mstr where recid(rps_mstr) = rpsrecord.

               if del-yn = yes then
                  rpq_qty[i] = 0.

               if rpq_qty[i] = 0
                  or rps_routing <> route[i]
                  or rps_bom_code <> bom_code[i]
                  or (rps_due_date < rps_start and
                      not using_new_repetitive)
               then do:

                  find wo_mstr no-lock
                      where wo_mstr.wo_domain = global_domain and  wo_lot =
                      string(rps_record)
                       and wo_part = rps_part
                       and wo_type = "S" and wo_status = "E"
                       and wo_site = rps_site
                       and wo_line = rps_line
                  no-error.

                  if available wo_mstr then do:
                     assign
                        wo_recno = recid(wo_mstr)
                        prev_status = wo_status
                        prev_qty = wo_qty_ord.
                     {gprun.i ""wowomtd.p""}
                  end.

               end.

               if rpq_qty[i] <> 0
               or rps_routing <> route[i]
               or rps_bom_code <> bom_code[i]
               and (rps_due_date >= rps_start and
                    not using_new_repetitive)
               then do:

                  /* Validate Work Order Routing and BOM Codes */
                  {gprun.i ""wortbmv.p""
                     "(input rps_part,
                       input rps_site,
                       input route[i],
                       input bom_code[i],
                       input 3,
                       output passed,
                       output prompt-routing)"}

                  if passed = no then do:
                     if prompt-routing then
                        next-prompt route[i].
                     else next-prompt bom_code[i].
                     undo, retry.
                  end.

                  if route[i] = "" and
                     not can-find (first ro_det  where ro_det.ro_domain =
                     global_domain and
                                         ro_routing = rps_part)
                  then do:
                     next-prompt route[i].
                     /* ROUTING DOES NOT EXISTS */
                     {pxmsg.i &MSGNUM=126 &ERRORLEVEL=3}
                     undo, retry.
                  end.

               end.

               assign
                  rps_routing = route[i]
                  rps_bom_code = bom_code[i].

               if rpq_qty[i] <> rps_qty_req
               or rel_date[i] <> rps_rel_date
               or open_qty[i] <> rpq_qty[i] - comp_qty[i]
               or open_qty[i] <= 0 or rpq_qty[i] = 0
               then do:

                  find wo_mstr no-lock
                      where wo_mstr.wo_domain = global_domain and  wo_lot =
                      string(rps_record)
                       and wo_part = rps_part
                       and wo_type = "S" and wo_status = "E"
                       and wo_site = rps_site
                       and wo_line = rps_line
                  no-error.

                  if available wo_mstr and wo_type = "S" then do:
                     {gprun.i ""rerpexd.p"" "(input-output wo_lot)"}
                  end. /*avail wo_mstr */

                  assign
                     rps_qty_req = rpq_qty[i]
                     rps_rel_date = rel_date[i].

                  if rps_rel_date = ? then do:
                     {mfdate.i rps_rel_date due_date[i]
                        leadtime rps_site}
                  end.

                  if available mrpc_ctrl and mrpc_op_yield = yes
                     and use_op_yield = yes
                  then do:

                     /* Determine if Routing code or part# to be used... */
                     part-or-routing = if rps_routing <> "" then rps_routing
                                       else rps_part.

                     /* pass 9's as oper so all operations used */
                     yield-op = 999999999.

                     /* Calculate yield percentage... */
                     {gprun.i ""gpcmpyld.p""
                        "(input part-or-routing,
                          input rps_rel_date,
                          input yield-op,
                          output yield_pct)"}

                     scrap_pct = 1 - yield_pct / 100.

                  end.

                  if rps_due_date < rps_start
                     and not using_new_repetitive
                  then
                     open_qty[i]= 0.

                  {dateconv.i rps_due_date rpsnbr}

                  rpsnbr = rpsnbr + rps_site.

                  {mfmrw.i "rps_mstr" rps_part rpsnbr
                     string(rps_record) """"
                     rps_rel_date rps_due_date max(open_qty[i],0)
                     "SUPPLYF" REPETITIVE_SCHEDULE rps_site}

                  {mfmrw.i "rps_scrap" rps_part rpsnbr
                     string(rps_record) """" rps_rel_date rps_due_date
                     "max(open_qty[i],0) * scrap_pct"
                     "DEMAND" SCRAP_REQUIREMENT rps_site}

               end. /* if loop */

               if rps_qty_req = 0 then delete rps_mstr.

            end. /* if avail rps_mstr */

         end. /* do i = 1 to 7 */

      end.  /* if rpq_qty[8] <> ? */

      due_date1 = due_date1 + 7.

   end. /* do on error */

   if using_new_repetitive then do:
      /* CANCEL THE POINTER DATE INTO THE REPETITIVE SCHEDULE;
         IF NO MORE SCHEDULE THEN PURGE QAD_WKFL*/
      key2 = r_part + "/" + r_site + "/" + r_line + "/".

      find first rps_mstr  where rps_mstr.rps_domain = global_domain and
      rps_part = r_part
         and rps_site = r_site
         and rps_line = r_line
      no-lock no-error.

      for each qad_wkfl exclusive-lock
          where qad_wkfl.qad_domain = global_domain and  qad_key1 = "rps_mstr"
           and qad_key2 begins key2:
         qad_datefld[1] = ?.
         if not available rps_mstr then delete qad_wkfl.
      end.

      /*REAPPLY SCHEDULE CUMS COMPLETED*/
      /* SS - 20080429.1 - B */
      /*
      {gprun.i ""rerpmtb.p""
         "(input r_part, input r_site, input r_line)"}
      */
      {gprun.i ""ssrerpm1b.p""
         "(input r_part, input r_site, input r_line)"}
      /* SS - 20080429.1 - E */

   end.

end.

status input.
