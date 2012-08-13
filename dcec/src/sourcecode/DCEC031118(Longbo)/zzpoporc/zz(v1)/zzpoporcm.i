/* GUI CONVERTED from poporcm.i (converter v1.69) Fri Apr  4 10:01:18 1997 */
/* poporcm.i - PURCHASE ORDER RECEIPT HEADER FRAME MANIPULATION         */
/* COPYRIGHT qad.inc. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK. */
/*F0PN*/ /*V8:ConvertMode=Maintenance                                   */
/*  CREATED: 7.4     LAST MODIFIED: 01/20/95    by: smp *F0F5*          */
/*  CREATED: 7.4     LAST MODIFIED: 03/10/95    by: jpm *H0BZ*          */
/*  MODIFIED 7.4     LAST MODIFIED: 03/29/95    by: aed *G0JV*          */
/*  MODIFIED 7.5     LAST MODIFIED: 05/12/95    by: mwd *J034*          */
/*                                  08/24/95    by: wjk *H0FM*          */
/*  MODIFIED 7.3                    09/05/95    BY: ais *G0W5*          */
/*  MODIFIED 8.5     LAST MODIFIED: 03/29/95    BY: taf *J053*          */
/*  REVISION: 8.5    LAST MODIFIED: 03/08/96    BY: *J0CV* Robert Wachowicz */
/*  REVISION: 8.5    LAST MODIFIED: 04/15/96    BY: *J0J8* Robert Wachowicz */
/*  REVISION: 8.5    LAST MODIFIED: 05/01/96    BY: *J04C* Sue Poland       */
/*  REVISION: 8.5    LAST MODIFIED: 06/20/96    BY: *J0VF* Robert Wachowicz */
/*  REVISION: 8.5    LAST MODIFIED: 06/28/96    BY: *J0WQ* Robert Wachowicz */
/*  REVISION: 8.5    LAST MODIFIED: 07/03/96    BY: *J0WY* Robert Wachowicz */
/*  REVISION: 8.5    LAST MODIFIED: 07/18/96    BY: *J0ZS* T. Farnsworth    */
/*  REVISION: 8.5    LAST MODIFIED: 11/12/96    BY: *J17Y* Sue Poland       */
/*  REVISION: 8.5    LAST MODIFIED: 04/04/97    BY: *J1MR* Sue Poland       */

/*F0F5*     THIS INCLUDE EXPECTS 1 INPUT - &FRAME - THE FRAME NAME TO USE */
/*F0F5*     FRAMES WERE DEFINED IN POPORCM.P.  FRAME A1 IS USED FOR       */
/*F0F5*     RECEIPTS, FRAME A2 IS USED FOR RTS SHIPMENTS                  */


            do transaction:
/*GUI*/ if global-beam-me-up then undo, leave.


/*J0WQ*         do for poc_ctrl: */
                   find first poc_ctrl no-lock.
                   fill-all = poc_rcv_all.
                   rcv_type  = poc_rcv_type.
/*J0WQ*         end.  */

                view frame {&frame}.

                if receivernbr = ? then receivernbr = "".
                if eff_date = ? then eff_date = today.
                move = yes.
                cmmt_yn = no.
                display
                   receivernbr
                   eff_date
                   move          when (porec)
                   fill-all
                   cmmt_yn
                with frame {&frame}.
                receivernbr = "".

                seta:
                do on error undo, retry:
/*GUI*/ if global-beam-me-up then undo, leave.

                   set ordernum
                   with frame {&frame} editing:
                      if frame-field = "ordernum" then do:
                         /* FIND NEXT/PREVIOUS RECORD */
                         /* Do not scroll thru RTS for PO or PO for RTS */
/*G0W5*/                 /* CHANGED '"input ordernum"' to 'frame-value' BELOW */
/*G0W5*/                 /* ('input ordernum' WAS NULL IN SEVERAL TRANSACTIONS*/
/*G0W5*/                 /* - REASON UNKNOWN - PREVENTING THE USER FROM       */
/*G0W5*/                 /* PROVIDING A STARTING POINT FOR SCROLLING)         */
                         {mfnp06.i
                             po_mstr
                             po_nbr
                             "po_type <> ""B"" and po_fsm_type = ports"
                             po_nbr
                             frame-value
                             yes
                             yes }

                         if recno <> ? then do:
                            find ad_mstr
                            where ad_addr = po_vend no-lock no-error.
                            if available ad_mstr then
                               vndname = ad_name.
                            else
                               vndname = "".
                            display po_nbr      @ ordernum
                                    receivernbr
                                    po_vend
                                    po_stat
/*J0WY*/                            "" @ ps_nbr
                            with frame {&frame}.
                         end.
                      end.  /* if frame-field = "ordernum" then */
                      else do:
                         status input.
                         readkey.
                         apply lastkey.
                      end.
                   end. /* editing */
                   /* END EDITING PORTION OF HEADER FRAME */

                   find po_mstr where po_nbr = ordernum
                        exclusive-lock no-error.

                   if not available po_mstr then do:
/*J1MR*               ADDED THE FOLLOWING */
                      if ports = "RTS" then do:
                        {mfmsg.i 7499 3}    /* RTS MASTER RECORD NOT FOUND */
                      end.
                      else do:
/*J1MR*               END ADDED CODE */
                        {mfmsg.i 343 3}
                        /* PURCHASE ORDER DOES NOT EXIST */
/*J1MR*/              end.
                      next-prompt ordernum with frame {&frame}.
                      undo seta, retry.
                   end.

                   if available po_mstr and po_stat = "c" then do:
                      /* PURCHASE ORDER CLOSED */
                      {mfmsg.i 326 3}
                      next-prompt ordernum with frame {&frame}.
                      undo seta, retry.
                   end.
                   if available po_mstr and po_stat = "x" then do:
                      /* PURCHASE ORDER CANCELLED */
                      {mfmsg.i 395 3}
                      next-prompt ordernum with frame {&frame}.
                      undo seta, retry.
                   end.

                   if available po_mstr and po_type = "B" then do:
                      /* BLANKET ORDER NOT ALLOWED */
                      {mfmsg.i 385 3}
                      next-prompt ordernum with frame {&frame}.
                      undo seta, retry.
                   end.

                   if available po_mstr and ports = "RTS"
                    and po_fsm_type <> ports then do:
                      /* Can not process PO's with RTS programs. */
                      {mfmsg.i 7363 3}
                      next-prompt ordernum with frame {&frame}.
                      undo seta, retry.
                   end.

                   if available po_mstr and ports = ""
                    and po_fsm_type <> ports then do:
                      /* Can not process RTS orders with PO programs. */
                      {mfmsg.i 7364 3}
                      next-prompt ordernum with frame {&frame}.
                      undo seta, retry.
                   end.

/*J0ZS************* REPLACE BY GPCURMTH.I ***********************************
** /*J053*/       /* DETERMINE ROUNDING METHOD FROM DOCUMENT CURRENCY OR BASE*/
** /*J053*/        if (gl_base_curr <> po_curr) then do:
** /*J053*/           find first ex_mstr where ex_curr = po_curr
** /*J053*/              no-lock no-error.
** /*J053*/           if not available ex_mstr then do:
** /*J053*               CURRENCY EXCHANGE MASTER DOES NOT EXIST              */
** /*J053*/              {mfmsg.i 964 3}
** /*J053*/              next-prompt ordernum with frame {&frame}.
** /*J053*/              undo seta, retry.
** /*J053*/           end.
** /*J053*/           rndmthd = ex_rnd_mthd.
** /*J053*/        end.
** /*J053*/        else rndmthd = gl_rnd_mthd.
**J0ZS***********************************************************************/

/*J0ZS*/           {gpcurmth.i
		        "po_curr"
		        "3"
		        "undo seta, retry"
		        "next-prompt ordernum with frame {&frame}" }

/*J053*/           /* SET CURRENCY DEPENDENT FORMATS */
/*J053*/           {pocurfmt.i }

                   find ad_mstr where ad_addr = po_vend no-lock no-error.
                   if available ad_mstr then
                      vndname = ad_name.
                   else
                      vndname = "".

                   display
                      receivernbr
                      po_vend
                      po_stat
                      vndname
/*J0WY*/              "" @ ps_nbr
                   with frame {&frame}.

                   if available po_mstr then do:
                      pook = no.
                      chkpodsite:
                      for each pod_det where pod_nbr = po_nbr no-lock:
/*GUI*/ if global-beam-me-up then undo, leave.

                         find si_mstr where si_site = pod_site no-lock no-error.
                         if available si_mstr and si_db = global_db then do:
/*J034*                    ** CHECK FOR AT LEAST ONE ACCESSIBLE SITE, TOO **/
/*J034*/                   {gprun.i ""gpsiver.p""
              "(input si_site, input recid(si_mstr), output return_int)"}
/*GUI*/ if global-beam-me-up then undo, leave.

/*J034*/                   if return_int = 1 then do:
                              pook = yes.
                              leave chkpodsite.
/*J034*/                   end. /* IF RETURN_INT = 1  */
                         end.
                      end.
/*GUI*/ if global-beam-me-up then undo, leave.

                      if not pook then do:
/*J0J8                   {mfmsg.i 352 3}
 *                          /* No PO lines available to receive */
 */
/*J0J8*/                 {mfmsg.i 2328 3} /* NOT AUTHORIZED FOR THIS SITE*/
                         next-prompt ordernum with frame {&frame}.
                         undo seta, retry.
                      end.
                      /* MAKE SURE THAT CENTRAL DATABASE IS CONNECTED */

                     if available po_mstr then do:
                        find first pod_det
                            where pod_nbr = po_nbr no-lock no-error.
/*J17Y*/                /* CURRENTLY, FOR RTS'S, POD_PO_DB IS BLANK (AS
                            RTS'S DON'T SUPPORT MULTIPLE-DB ENVIRONMENTS)
                            SO PREVENT THIS ERROR CONDITION IN THAT CASE. */
                        if global_db <> ""
/*J17Y*/                and pod_po_db <> ""
                        and not connected(pod_po_db) then do:
                            /* Database not available */
                            {mfmsg03.i 2510 3 pod_po_db """" """"}
                            undo seta, retry.
                         end.
                     end.  /* if available po_mstr then do: */
                   end.  /* if available po_mstr then do: */
                end.
/*GUI*/ if global-beam-me-up then undo, leave.

                /* seta */

                seta1:
                do on error undo, retry:
/*GUI*/ if global-beam-me-up then undo, leave.

                   global_addr = po_vend.

/*J04C*             ADDED THE FOLLOWING */
                   /* SPLIT OUT THE SET STATEMENT TO PREVENT "SHIP DATE" FROM */
                   /* DISPLAYING ON THE RTS SHIPMENT SCREEN */
                   if porec then
                        set ps_nbr
                            receivernbr
                            eff_date
                            move
                            fill-all
                            cmmt_yn
                            ship_date
                        with frame a1.

                    else
                        set
/*J0VF*                     ps_nbr  */ /*THESE FIELDS NOT USED IN SHIPPING*/
/*J0VF*                     receivernbr */
                            eff_date
/*J0VF*                     move      */
                            fill-all
                            cmmt_yn
                        with frame a2.
/*J04C*            END ADDED CODE */
/*J04C*            set
.                      ps_nbr       when (porec)
.                      receivernbr  when (porec)
.                      eff_date
.                      move         when (porec)
.                      fill-all
.                      cmmt_yn
./*J0CV*/              ship_date
.                   with frame {&frame}.
.*J04C*/

         /*CKECK TO SEE IF ERS ENABLED AND PACK SLIP FLAG SET IF BLANK PSNBR*/
/*J0WQ*/        if ps_nbr = "" then do:
/*J0WQ*/           find first apc_ctrl no-lock no-error.
/*J0WQ*/           find first poc_ctrl no-lock no-error.
/*J0WQ*/           if (available apc_ctrl and apc_ers_ps_err) and
/*J0WQ*/              (available poc_ctrl and poc_ers_proc) then do:
/*J0WQ*/              {mfmsg.i 2305 2} /*ERS WON'T VOUCHER W/O A PACK SLIP*/
/*J0WQ*/              pause.
/*J0WQ*/           end.
/*J0WQ*/        end. /*PS NBR BLANK*/

                   if eff_date = ? then eff_date = today.
/*J0CV*/           if ship_date = ? then ship_date = eff_date.
                   /* CHECK GL EFFECTIVE DATE */
/*H0FM*/           {gpglef02.i &module = ""IC""
                               &entity = glentity
                               &date   = eff_date
                               &prompt = "eff_date"
                               &frame  = "{&frame}"
                               &loop   = "seta1"}

/*H0FM*            {mfglef.i eff_date} */

                   /* FIND EXCH RATE IF CURRENCY NOT BASE */
                   if base_curr <> po_curr then do:
                      if po_fix_rate then do:
                         exch_rate = po_ex_rate.
                         ent_exch  = po_ent_ex.
                      end.
                      else do:  /*IF NOT FIXED RATE ALLOW FOR SPOT RATE*/
                         {gpgtex5.i &ent_curr = base_curr
                                    &curr = po_curr
                                    &date = eff_date
                                    &exch_from = exd_rate
                                    &exch_to = exch_rate}
                         if exd_rate = exch_rate then
                            ent_exch = exd_ent_rate.
                         else
                            ent_exch = 1 / exd_ent_rate.

                         seta1_sub:
                         do on error undo, retry:
/*GUI*/ if global-beam-me-up then undo, leave.

/*G0JV** Begin commented out section - GUI **
*                           form
*                              ent_exch colon 15
*                              space(2)
* /*H0BZ*/                  with frame seta1_sub
* /*H0BZ*/                  /* attr-space overlay side-labels
* /*H0BZ*/                     centered row frame-row(a) + 4 */ .
**G0JV** End commented-out section */

                            update ent_exch with frame seta1_sub.
                            if ent_exch = 0  then do:
                               {mfmsg.i 317 3}
                               /*ZERO NOT ALLOWED*/
                               undo seta1_sub, retry.
                            end.
                            hide frame seta1_sub.
                            /* SET THE EX_RATE FROM THE ENTERED EXCHANGE RATE */
                            if ent_exch entered then do:
                               {gpgtex7.i  &ent_curr=base_curr
                                           &curr = po_curr
                                           &exch_from=ent_exch
                                           &exch_to=exch_rate}
                            end.
                         end.
/*GUI*/ if global-beam-me-up then undo, leave.
 /*seta1_sub*/

                        /* TRANSACT'N TO BASE, MAKE (INTERNALLY) BASE TO TRANS*/
                         if ent_exch entered and exd_rate <> exd_ent_rate then
                         exch_rate = 1 / ent_exch.

                      end. /*not fixed rate*/
                   end.
                   else exch_rate = 1.0.

                   if receivernbr <> "" and rcv_type = 2 then do:
                     {mfmsg.i 354 4} /*Rcvr # is system assgnd for rcvr type 2*/
                      next-prompt receivernbr with frame {&frame}.
                      undo seta1, retry.
                   end.

                   if can-find(first prh_hist where prh_receiver = receivernbr)
                   then do:
                      {mfmsg.i 355 3}
                      next-prompt receivernbr with frame {&frame}.
                      undo seta1, retry.
                   end.

                   if cmmt_yn then do: /* ADD COMMENTS, IF DESIRED */
                      hide frame {&frame} no-pause.
                      cmtindx = po_cmtindx.
                      global_ref = cmmt-prefix + " " + po_nbr.
                      {gprun.i ""gpcmmt01.p"" "(input ""po_mstr"")"}
/*GUI*/ if global-beam-me-up then undo, leave.

                      po_cmtindx = cmtindx.
                   end.

/*J034*/           hide frame b no-pause.
                end.
/*GUI*/ if global-beam-me-up then undo, leave.

                /* seta1 */
             end.
/*GUI*/ if global-beam-me-up then undo, leave.

             /* transaction */
