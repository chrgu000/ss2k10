/* GUI CONVERTED from socnuacb.i (converter v1.78) Wed Aug 26 02:02:34 2009 */
/* socnuacb.i - Common Customer Consignment Usage Logic                       */
/* Copyright 1986-2009 QAD Inc., Santa Barbara, CA, USA.                      */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* Revision: 1.1         BY: Robin McCarthy       DATE: 10/01/05  ECO: *P3MZ* */
/* Revision: 1.1.2.1     BY: Ed van de Gevel      DATE: 10/22/07  ECO: *P51G* */
/* $Revision: 1.1.2.2 $ BY: Trupti Khairnar DATE: 08/25/09 ECO: *Q39T* */
/*-Revision end---------------------------------------------------------------*/

/* -----  W A R N I N G  -----  W A R N I N G  -----  W A R N I N G  -----  */
/*                                                                          */
/*         THIS PROGRAM IS A BOLT-ON TO STANDARD PRODUCT MFG/PRO.           */
/* ANY CHANGES TO THIS PROGRAM MUST BE PLACED ON A SEPARATE ECO THAN        */
/* STANDARD PRODUCT CHANGES.  FAILURE TO DO THIS CAUSES THE BOLT-ON CODE TO */
/* BE COMBINED WITH STANDARD PRODUCT AND RESULTS IN PATCH DELIVERY FAILURES.*/
/*                                                                          */
/* -----  W A R N I N G  -----  W A R N I N G  -----  W A R N I N G  -----  */

/*V8:ConvertMode=Maintenance                                                  */

{cxcustom.i "SOCNUACB.I"}
define variable op-err as integer no-undo.

      setloop2:
      do on endkey undo loop0, leave loop0
         on error  undo loop0, leave loop0
        :
/*GUI*/ if global-beam-me-up then undo loop0, leave loop0.


         view frame b.

         {gpbrparm.i
             &browse=gplu909.p
             &parm=c-brparm1
             &val="input frame c order"}

         {gpbrparm.i
             &browse=gplu909.p
             &parm=c-brparm2
             &val="string(input frame c line)"}

         set
            tot_qty_consumed
            consumed_um
            lotser
            ref
            multi_entry
         with frame c.

         if tot_qty_consumed < 0
         then do:
            /* ERROR: QUANTITY ENTERED MUST BE A POSITIVE QUANTITY # */
            {pxmsg.i &MSGNUM=8440 &ERRORLEVEL=3 &MSGARG1=tot_qty_consumed}
            undo loop0, leave loop0.
         end. /* IF tot_qty_consumed < 0 */

         if inventory_domain <> global_domain then do:
            /* SWITCH TO INVENTORY DOMAIN */
            run switchDomain
               (input  inventory_domain,
                output undo_flag).

            if undo_flag then do:
               pause.
               hide frame c.
               undo loop0, return.
            end.
         end.

         /* UPDATE CNCIX_MSTR AND CREATE USAGE */
         {gprun.i ""socnucb2.p""
                  "(input-output lotser,
                    input-output ref,
                    input-output consumed_um,
                    input-output lotnext,
                    input-output lotprcpt,
                    input-output tot_qty_consumed,
                    input-output part,
                    input-output undo-input,
                    input-output cncix_qty1,
                    input-output sr_yes,
                    input-output tt_autocr.ac_part,
                    input-output tt_autocr.ac_site,
                    input-output tt_autocr.ac_ship,
                    input-output tt_autocr.ac_cust,
                    input-output tt_autocr.ac_sopart,
                    input-output tt_autocr.ac_order,
                    input-output tt_autocr.ac_line,
                    input-output tt_autocr.ac_loc,
                    input-output tt_autocr.ac_asn_shipper,
                    input-output tt_autocr.ac_auth,
                    input-output tt_autocr.ac_cust_job,
                    input-output tt_autocr.ac_cust_seq,
                    input-output tt_autocr.ac_cust_ref,
                    input-output ac_stock_um,
                    input-output ac_count,
                    input-output ac_lotser,
                    input-output ac_ref,
                    output       op-err)"}
/*GUI*/ if global-beam-me-up then undo loop0, leave.


         if ip_invoice_domain <> global_domain then do:
            /* SWITCH TO INVOICE DOMAIN */
            run switchDomain
               (input  ip_invoice_domain,
                output undo_flag).

            if undo_flag then do:
               pause.
               hide frame c.
               undo loop0, return.
            end.
         end.

         if op-err = 6562 then do:
            /* NO SHIPMENT RECORD EXISTS FOR LOT/SERIAL */
            {pxmsg.i &MSGNUM=6562 &ERRORLEVEL=3 &MSGARG1=lotser}
            next-prompt lotser with frame c.
            undo loop0, leave loop0.
         end.
         else if op-err = 33 then do:
            /* NO UOM CONVERSION EXISTS */
            {pxmsg.i &MSGNUM=33 &ERRORLEVEL=2}
            next-prompt consumed_um with frame c.
            undo loop0, leave loop0.
         end.
         else if op-err = 99 then do:
            undo loop0, leave loop0.
         end.
         else if op-err = 6673 then do:
            undo loop0, leave loop0.
         end.
         else if op-err = 66731 then do:
            /* ERROR: MAXIMUM CONSIGNMENT QUANTITY TO BE INVOICED # */
            {pxmsg.i &MSGNUM=6673 &ERRORLEVEL=3 &MSGARG1=cncix_qty1}
            undo loop0, leave loop0.
         end.

         display
            ac_cust_usage_ref  @ cust_usage_ref
            ac_cust_usage_date @ cust_usage_date
            ac_selfbill_auth   @ selfbill_auth
            ac_eff_date        @ eff-date
         with frame aa.

         setloop3:
         do on error undo loop0, leave loop0:
/*GUI*/ if global-beam-me-up then undo loop0, leave.

            set
               cust_usage_ref
               cust_usage_date
               selfbill_auth   when (using_selfbilling)
               eff-date
               {&SOCNUACB-I-TAG1}
            with frame aa.

         end.
/*GUI*/ if global-beam-me-up then undo loop0, leave.
  /* SETLOOP3 */

         assign
            ac_cust_usage_ref   = cust_usage_ref
            ac_cust_usage_date  = if cust_usage_date = ? then today
                                  else cust_usage_date
            ac_selfbill_auth    = selfbill_auth
            ac_eff_date         = if eff-date = ? then today
                                  else eff-date
            ac_tot_qty_consumed = tot_qty_consumed
            ac_consumed_um      = consumed_um
            ac_consumed_um_conv = trans_conv.

      end.
/*GUI*/ if global-beam-me-up then undo loop0, leave.
 /* SETLOOP2 */
