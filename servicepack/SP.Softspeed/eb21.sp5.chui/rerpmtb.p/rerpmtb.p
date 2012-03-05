/* rerpmtb.p - REPETITIVE                                                     */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/*F0PN*/ /*V8:ConvertMode=Maintenance                                         */
/*K1Q4*/
/* REVISION: 7.3               LAST MODIFIED: 10/31/94   BY: WUG *GN77*       */
/* REVISION: 7.3               LAST MODIFIED: 12/13/95   BY: emb *G1GF*       */
/* REVISION: 7.3               LAST MODIFIED: 03/07/96   BY: jym *G1PZ*       */
/* REVISION: 8.6               LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan */
/* REVISION: 9.1               LAST MODIFIED: 08/12/00   BY: *N0KP* myb        */
/* $Revision: 1.4.1.3 $ BY: Paul Donnelly (SB) DATE: 06/28/03 ECO: *Q00K* */
/* $Revision: 1.4.1.3 $ BY: Bill Jiang DATE: 04/29/08 ECO: *SS - 20080429.1* */
/*-Revision end---------------------------------------------------------------*/



/* SUBPROGRAM TO REAPPLY CUM COMPLETED TO THE REPETITIVE SCHEDULE

   THIS ENSURES THAT ALL COMPLETED QUANTITIES ARE APPLIED TO THE EARLIEST
   REQUIREMENTS.
*/
{mgdomain.i}

     define input param part as character no-undo.
     define input param site as character no-undo.
     define input param line as character no-undo.

     define variable key2 as character no-undo.
     define variable qty_to_apply as decimal no-undo.
     define variable cum_completed as decimal no-undo.

/*G1GF*/ define variable rpsrecid as recid no-undo.
/*G1GF*/ define variable rpsqtycomp as decimal no-undo.
/*G1GF*/ define buffer rpsmstr for rps_mstr.

     /* SS - 20080429.1 - B */
     IF execname <> "rerpmt.p" THEN DO:
     /* SS - 20080429.1 - E */
     /*GET CUM COMPLETED*/
     for each rps_mstr no-lock
      where rps_mstr.rps_domain = global_domain and  rps_part = part
     and rps_site = site
     and rps_line = line
     use-index rps_part
     break
/*G1GF*/ by rps_part by rps_site by rps_line
/*G1PZ*  by rps_routing by rps_bom_code */
     by rps_due_date:

/*G1GF*     /* Deleted section */
      *     key2 = rps_part + "/" + rps_site + "/" + rps_line
      *     + "/" + rps_routing + "/" + rps_bom_code + "/".
      *
      *     find qad_wkfl exclusive-lock where qad_key1 = "rpm_mstr"
      *     and qad_key2 = key2 no-error.
      *
      *     if not available qad_wkfl then do:
      *        create qad_wkfl.
      *
      *        assign
      *        qad_key1 = "rpm_mstr"
      *        qad_key2 = key2.
      *     end.
**G1GF*/    /* End of deleted section */

/*G1PZ*     if first-of(rps_bom_code) then do: */
/*G1PZ*/    if first-of(rps_line) then do:

/*G1GF*        qad_decfld[2] = 0. */

/*G1GF*/       rpsqtycomp = 0.
        end.

/*G1GF*     qad_decfld[2] = qad_decfld[2] + rps_qty_comp. */
/*G1GF*/    rpsqtycomp = rpsqtycomp + rps_qty_comp.

/*G1GF*/    /* Added section */
/*G1PZ*     if last-of (rps_bom_code) then do: */
/*G1PZ*/    if last-of (rps_line) then do:

           key2 = rps_part + "/" + rps_site + "/" + rps_line
/*G1PZ*        + "/" + rps_routing + "/" + rps_bom_code */
           + "/".

/*G1PZ*        find qad_wkfl exclusive-lock where qad_key1 = "rpm_mstr" */
/*G1PZ*/       find qad_wkfl exclusive-lock  where qad_wkfl.qad_domain =
global_domain and  qad_key1 = "rps_mstr"
           and qad_key2 = key2 no-error.

           if not available qad_wkfl then do:
          create qad_wkfl. qad_wkfl.qad_domain = global_domain.

          assign
/*G1PZ*           qad_key1 = "rpm_mstr" */
/*G1PZ*/          qad_key1 = "rps_mstr"
          qad_key2 = key2.
           end.

           qad_decfld[2] = rpsqtycomp.

           release qad_wkfl.
        end.
/*G1GF*/    /* End of added section */
     end.
     /* SS - 20080429.1 - B */
     END.
     /* SS - 20080429.1 - E */

     /*REAPPLY IT TO SCHEDULE*/
     for each rps_mstr
/*G1GF*/ no-lock
/*G1GF*  exclusive */
      where rps_mstr.rps_domain = global_domain and  rps_part = part
     and rps_site = site
     and rps_line = line
     use-index rps_part
     break
/*G1GF*/ by rps_part by rps_site by rps_line
/*G1PZ*  by rps_routing by rps_bom_code */
     by rps_due_date:

/*G1PZ*     if first-of(rps_bom_code) then do: */
/*G1PZ*/    if first-of(rps_line) then do:

           key2 = rps_part + "/" + rps_site + "/" + rps_line
/*G1PZ*        + "/" + rps_routing + "/" + rps_bom_code */
           + "/".

           find qad_wkfl
/*G1GF*        exclusive-lock */
/*G1GF*/       no-lock
/*G1PZ*        where qad_key1 = "rpm_mstr" */
/*G1PZ*/        where qad_wkfl.qad_domain = global_domain and  qad_key1 =
"rps_mstr"
           and qad_key2 = key2 no-error.

           if not available qad_wkfl then do:
          create qad_wkfl. qad_wkfl.qad_domain = global_domain.

          assign
/*G1PZ*           qad_key1 = "rpm_mstr" */
/*G1PZ*/          qad_key1 = "rps_mstr"
          qad_key2 = key2.
           end.

           cum_completed = qad_decfld[2].

/*G1GF*/       release qad_wkfl.
        end.

        qty_to_apply = min(rps_qty_req,cum_completed).
/*G1GF*     rps_qty_comp = qty_to_apply. */
        cum_completed = cum_completed - qty_to_apply.

/*G1GF*/    if rps_mstr.rps_qty_comp <> qty_to_apply then do for rpsmstr:
/*G1GF*/       find rpsmstr exclusive-lock
/*G1GF*/       where recid(rpsmstr) = recid(rps_mstr) no-error.
/*G1GF*/       rpsmstr.rps_qty_comp = qty_to_apply.
/*G1GF*/       release rpsmstr.
/*G1GF*/    end.
     end.
