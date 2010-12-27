/* mfworla.i - CREATE PICKLIST REQUIREMENTS / ALLOCATIONS               */
/* Copyright 1986-2005 QAD Inc., Carpinteria, CA, USA.                  */
/* All rights reserved worldwide.  This is an unpublished work.         */
/* $Revision: 1.20 $                                                         */
/*V8:ConvertMode=Maintenance                                            */
/* REVISION: 1.0     LAST MODIFIED: 06/18/86    BY: emb                 */
/* REVISION: 1.0     LAST MODIFIED: 10/28/86    BY: emb *39*            */
/* REVISION: 1.0     LAST MODIFIED: 01/29/87    BY: emb *A19*           */
/* REVISION: 1.0     LAST MODIFIED: 02/19/87    BY: emb *A25*           */
/* REVISION: 2.0     LAST MODIFIED: 07/24/87    BY: emb *A75*           */
/* REVISION: 2.0     LAST MODIFIED: 12/08/87    BY: emb *A109*          */
/* REVISION: 4.0     LAST MODIFIED: 06/30/88    BY: emb *A256*          */
/* REVISION: 4.0     LAST MODIFIED: 06/13/88    BY: emb *A288*          */
/* REVISION: 4.0     LAST MODIFIED: 07/22/88    BY: emb *A347*          */
/* REVISION: 4.0     LAST MODIFIED: 08/24/88    BY: emb *A347*          */
/* REVISION: 4.0     LAST MODIFIED: 12/16/88    BY: emb                 */
/* REVISION: 4.0     LAST MODIFIED: 02/09/89    BY: emb *A643*          */
/* REVISION: 4.0     LAST MODIFIED: 01/09/90    BY: emb *A799*          */
/* REVISION: 5.0     LAST MODIFIED: 02/28/90    BY: wug *B596*          */
/* REVISION: 6.0     LAST MODIFIED: 05/02/90    BY: mlb *D024*          */
/* REVISION: 6.0     LAST MODIFIED: 07/06/90    BY: emb *D040*          */
/* REVISION: 6.0     LAST MODIFIED: 08/24/90    BY: emb *D061*          */
/* REVISION: 6.0     LAST MODIFIED: 03/08/91    BY: emb *D413*          */
/* REVISION: 6.0     LAST MODIFIED: 05/01/91    BY: emb *D609*          */
/* REVISION: 6.0     LAST MODIFIED: 08/29/91    BY: emb *D841*          */
/* REVISION: 7.0     LAST MODIFIED: 09/04/91    BY: pma *F003*          */
/* REVISION: 7.0     LAST MODIFIED: 10/09/91    BY: emb *F024*          */
/* REVISION: 7.0     LAST MODIFIED: 10/12/92    BY: pma *G174*          */
/* REVISION: 7.3     LAST MODIFIED: 10/19/92    BY: emb *G208*          */
/* REVISION: 7.3     LAST MODIFIED: 12/29/92    BY: pma *G382*          */
/* REVISION: 7.3     LAST MODIFIED: 02/09/93    BY: emb *G656*          */
/* REVISION: 7.3     LAST MODIFIED: 03/03/93    BY: emb *G870*          */
/* REVISION: 7.0     LAST MODIFIED: 03/22/93    BY: ram *G892*          */
/* REVISION: 7.3     LAST MODIFIED: 09/03/93    BY: pma *GE81*          */
/* REVISION: 7.3     LAST MODIFIED: 01/27/94    BY: pma *FL71*          */
/* REVISION: 7.3     LAST MODIFIED: 02/15/94    BY: pxd *FL60*          */
/* REVISION: 7.3     LAST MODIFIED: 03/30/94    BY: pma *FN18*          */
/* REVISION: 7.3     LAST MODIFIED: 06/15/94    BY: pxd *FO90*          */
/* REVISION: 7.3     LAST MODIFIED: 07/11/94    BY: ais *FO71*          */
/* Oracle changes (share-locks)    09/12/94           BY: rwl *FR19*    */
/* REVISION: 7.3     LAST MODIFIED: 10/10/94    BY: pxd *FR91*          */
/* REVISION: 7.3     LAST MODIFIED: 10/26/94    BY: pxd *FS81*          */
/* REVISION: 7.3     LAST MODIFIED: 11/16/94    BY: pxd *FT74*          */
/* REVISION: 7.3     LAST MODIFIED: 11/30/94    BY: emb *FU13*          */
/* REVISION: 7.2     LAST MODIFIED: 03/17/95    BY: ais *F0JR*          */
/* REVISION: 7.2     LAST MODIFIED: 07/06/95    BY: dzs *F0T2*          */
/* REVISION: 7.2     LAST MODIFIED: 11/09/95    BY: rvw *F0W0*          */
/* REVISION: 8.5     LAST MODIFIED: 11/18/97    BY: *J1PS* Felcy D'Souza*/
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane    */
/* REVISION: 8.6E     LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan   */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan   */
/* REVISION: 9.1      LAST MODIFIED: 01/18/99   BY: *N00J* Russ Witt    */
/* REVISION: 9.1      LAST MODIFIED: 08/13/00   BY: *N0KR* Mark Brown   */
/* REVISION: 9.1      LAST MODIFIED: 11/07/00   BY: *N0TN* Jean Miller  */
/* Old ECO marker removed, but no ECO header exists *F0PN*              */
/* Revision: 1.14  BY: Katie Hilbert DATE: 04/01/01 ECO: *P008*         */
/* Revision: 1.16  BY: Paul Donnelly (SB) DATE: 06/28/03 ECO: *Q00G*    */
/* Revision: 1.19  BY: Somesh Jeswani     DATE: 12/15/04 ECO: *P2ZY*    */
/* $Revision: 1.20 $   BY: Surajit Roy        DATE: 12/30/04 ECO: *P2QK*    */
/* 100716.1  $  BY: mage chen  DATE: 07/16/10    ECO: *P45S*  */

/*-Revision end---------------------------------------------------------------*/

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

         /*********************************************************/
         /* NOTES:   1. Patch FL60 sets in_level to a value       */
         /*             of 99999 when in_mstr is created or      */
         /*             when any structure or network changes are */
         /*             made that affect the low level codes.     */
         /*          2. The in_levels are recalculated when MRP   */
         /*             is run or can be resolved by running the  */
         /*             mrllup.p utility program.                 */
         /*********************************************************/

/************************************************************************/
/* "{1}" = "nodelete" (optional so wod_det records won't be deleted)    */
/*          means that this code is being called from wowomta1.p and    */
/*          will be used for calculating lower level phantom            */
/*          requirements                                                */
/* "{1}" = "" (no parameter has been passed)                            */
/*          means that this code is being called from wowomta.p and     */
/*          will be used for calculating single level non-phantom       */
/*          requirements                                                */
/************************************************************************/

define variable temp_var1 as decimal.
define variable temp_var2 as decimal.

for each pkdet:
   pkltoff = pkltoff + lt_off.
end.

for each pkdet
      where (pkstart = ? or pkstart <= wo_rel_date)
      and (pkend = ? or pkend >= wo_rel_date)
      break by pkpart by pkop:

   accumulate pkqty (total by pkop).

   if first-of (pkop) then temp_var1 = pkltoff.
   else temp_var1 = min(temp_var1,pkltoff).

   if last-of (pkop) then do:

      find first wod_det exclusive-lock  where wod_det.wod_domain =
      global_domain and  wod_lot = wo_lot
         and wod_nbr = wo_nbr and wod_part = pkpart
         and wod_op = pkop no-error.
      if not available wod_det then do:

         create wod_det. wod_det.wod_domain = global_domain.
         assign
            wod_nbr = wo_nbr
            wod_lot = wo_lot
            wod_part = pkpart
            wod_op = pkop
            wod_iss_date = wo_rel_date
            wod_site = wo_site.
         if wod_qty_req = 0
         then
            wod_iss_date = prev_release.
         if temp_var1 <> 0 then do:
            wod_iss_date = ?.
            {mfdate.i prev_release wod_iss_date temp_var1 wod_site}
         end.
      end.

      find pt_mstr  where pt_mstr.pt_domain = global_domain and  pt_part =
      wod_part no-lock no-error.
      if available pt_mstr then
      assign
         wod_critical = pt_critical
         wod_loc = pt_loc.

/*ss - 100726.1-b*/
       if available pt_mstr and pt_um = "EA" then  assign
                 oldwod_qty_req = wod_qty_req
                 wod_qty_req = round(wod_qty_req , 0).
           else assign
                 oldwod_qty_req = wod_qty_req
                 wod_qty_req = round(wod_qty_req , 2).
/*ss - 100726.1-e*/

      if "{1}" = "nodelete" then do:
         {mfwday.i prev_release wod_iss_date temp_var2 wod_site}
         if temp_var2 = ? then temp_var2 = temp_var1.
         else temp_var2 = min(temp_var1,temp_var2).
      end.
      else temp_var2 = temp_var1.

      qty = accum total by pkop pkqty.

      if wo_site <> prev_site and wod_site = prev_site
         then wod_site = wo_site.

      find ptp_det no-lock  where ptp_det.ptp_domain = global_domain and
      ptp_part = wod_part
         and ptp_site = wod_site no-error.

      if (available ptp_det and ptp_phantom)
         or (not available ptp_det and available pt_mstr and pt_phantom)
         then phantom-loop = yes.

      if index("EAR",wo_status) > 0
         and ((available ptp_det and ptp_iss_pol = yes)
         or (not available ptp_det and available pt_mstr
         and pt_iss_pol = yes))
         or wo_status = "E"
      then do:

         /*      IN THE CREATION OF IN_MSTR RECORD. ALSO, IN_MSTR RECORD IS     */
         /*      FOUND IN GPINCR.P ROUTINE BEFORE THE CREATION.                 */

         find si_mstr  where si_mstr.si_domain = global_domain and  si_site =
         wod_site no-lock no-error.
         {gprun.i ""gpincr.p"" "(input no,
                          input wod_part,
                          input wod_site,
                          input if available si_mstr then
                                   si_gl_set
                                else """",
                          input if available si_mstr then
                                   si_cur_set
                                else """",
                          input pt_abc,
                          input pt_avg_int,
                          input pt_cyc_int,
                          input pt_rctpo_status,
                          input pt_rctpo_active,
                          input pt_rctwo_status,
                          input pt_rctwo_active,
                          output recno)"}

         find in_mstr exclusive-lock where recid(in_mstr) = recno.

         in_qty_req = in_qty_req + (qty * assy_qty) / bombatch.
      end.

      if use_op_yield = yes then
         run ip-get-yield (input wod_op, output yield_pct).

      oldwod_qty_req = 0.
      if wod_iss_date <> wo_rel_date
         or temp_var2 <> 0
         or "{1}" = "nodelete"
         or wod_qty_req <> (qty * assy_qty) / bombatch
         or (use_op_yield = yes and wod_yield_pct <> yield_pct)
      then do:

/*ss - 100727.1 - b*
         if "{1}" = "nodelete"
         then
         assign
            oldwod_qty_req = wod_qty_req
            wod_qty_req = wod_qty_req + (qty * assy_qty) / bombatch.
         else
         assign
            oldwod_qty_req = 0
            wod_qty_req = (qty * assy_qty) / bombatch.
*ss - 100727.1 - e*/

/*ss - 100727.1 - b***************************************************************/
        if "{1}" = "nodelete"
           then  do:
              if pt_um = "EA" then  assign
                 oldwod_qty_req = wod_qty_req
                 wod_qty_req = round(wod_qty_req + (qty * assy_qty) / bombatch, 0).
           else assign
                 oldwod_qty_req = wod_qty_req
                 wod_qty_req = round(wod_qty_req + (qty * assy_qty) / bombatch, 2).
     end.
     else do:
              if pt_um = "EA" then  assign
                 oldwod_qty_req = 0
                 wod_qty_req = round( (qty * assy_qty) / bombatch, 0).
           else assign
                 oldwod_qty_req = 0
                 wod_qty_req = round( (qty * assy_qty) / bombatch, 2).
     end.
 /**ss - 100727.1 - e ****************************************************************/

         /* Adjust wod_qty_req for routing yield impact if not     */
         /* co/by product    */
         if use_op_yield = yes and wo_joint_type = "" then do:
            /* If this is a phantom, qty reqd has been adjusted already */

/*ss - 100727.1 - b*
            if  "{1}" <> "nodelete" then
            assign
               wod_qty_req = wod_qty_req * yield_pct * .01.
            wod_yield_pct = yield_pct.

*ss - 100727.1 - e*/
/*ss - 100727.1 - b***************************************************************/
     if  "{1}" <> "nodelete" then
           if pt_um = "EA" then
            assign
               wod_qty_req = round(wod_qty_req * yield_pct * .01, 0).
         else  wod_qty_req = round(wod_qty_req * yield_pct * .01, 2).
         wod_yield_pct = yield_pct.

 /**ss - 100727.1 - e ****************************************************************/
         end.  /* if use_op_yield...*/

         if ((available ptp_det and ptp_iss_pol = no)
            or (not available ptp_det and available pt_mstr
            and pt_iss_pol = no))
            and index("AR",wo_status) > 0
            then wod_qty_iss = wod_qty_req.

         if temp_var2 = 0 then wod_iss_date = prev_release.
         else do:
            wod_iss_date = ?.
            {mfdate.i prev_release wod_iss_date temp_var2 wod_site}
         end.

         if wod_qty_req > 0
         then temp_var1 = max(wod_qty_req - max(wod_qty_iss,0),0).
         else temp_var1 = min(wod_qty_req - min(wod_qty_iss,0),0).

         {mfmrw.i "wod_det" wod_part wod_nbr wod_lot string(wod_op)
            ? wod_iss_date temp_var1 "DEMAND"
            WORK_ORDER_COMPONENT wod_site}
      end.

      if  (wo_qty_comp + wo_qty_rjct = 0)
      then do:
         find in_mstr  where in_mstr.in_domain = global_domain and  in_site =
         wod_site
            and in_part = wod_part no-lock no-error.
         {gpsct03.i &cost=sct_cst_tot}
         find qad_wkfl  where qad_wkfl.qad_domain = global_domain and  qad_key1
         = "MFWORLA"
            and qad_key2 = wod_lot + wod_part
                           + string(wod_op)
            no-error.
         if not available qad_wkfl then do:
            create qad_wkfl. qad_wkfl.qad_domain = global_domain.
            assign
               qad_key1 = "MFWORLA"
               qad_key2 = wod_lot + wod_part + string(wod_op).
         end.

       /* part_global DETECTS WHETHER A GLOBAL PHANTOM IS PRESENT IN THE   */
       /* PRODUCT STRUCTURE. IF PRESENT IT APPLIES yield_pct               */
       /* TO qad_decfld[1] CALCULATION ELSE USES FORMULA WITHOUT yield_pct */

         if part_global = no
         then do:
             find first pt_mstr
                   where  pt_domain = global_domain
                   and    pt_part   = wod_part no-lock no-error.
             if available pt_mstr and pt_phantom
             then
                part_global = yes.
         end. /* IF part_global = no */

         if part_global = yes
         then
            qad_decfld[1] = (oldwod_qty_req + (qty * assy_qty) / bombatch)
                             * par_bombatch / (wo_qty_ord *(yield_pct * .01)).
         else
            qad_decfld[1] = (oldwod_qty_req + (qty * assy_qty) / bombatch)
                             * par_bombatch / wo_qty_ord .
         assign
            qad_decfld[2] = par_bombatch
            wod_bom_amt = glxcst
            wod_bom_qty = (wod_qty_req / (yield_pct * .01)) / wo_qty_ord.

      end.
   end.
end.

if "{1}" <> "nodelete" then
for each wod_det exclusive-lock  where wod_det.wod_domain = global_domain and
wod_lot = wo_lot
      and wod_nbr = wo_nbr
      use-index wod_nbrpart:

   find first pkdet where pkpart = wod_part
      and pkop = wod_op no-error.
   if available pkdet then next.

   find ptp_det no-lock  where ptp_det.ptp_domain = global_domain and  ptp_part
   = wod_part
      and ptp_site = wod_site no-error.

   if index("EAR",wo_status) > 0
      and index("EAR",prev_status) > 0
      and ((available ptp_det and ptp_iss_pol = yes) or
      (not available ptp_det and available pt_mstr
      and pt_iss_pol = yes))
   then do:
      find in_mstr  where in_mstr.in_domain = global_domain and  in_site =
      wod_site
         and in_part = wod_part exclusive-lock no-error.
      if available in_mstr
         then in_qty_req = in_qty_req - max(wod_qty_req - wod_qty_iss,0).
   end.

   {mfmrwdel.i "wod_det" wod_part wod_nbr wod_lot """"}

   {mfmrw.i "wod_det" wod_part wod_nbr wod_lot string(wod_op)
      ? wod_iss_date 0 "DEMAND" " "  wod_site}

   delete wod_det.
end.

/******************************************************************/

/*   I N T E R N A L    P R O C E D U R E S     */

/******************************************************************/

PROCEDURE ip-get-yield:

   /* This routine will determine operation yield percentage        */
   /* used.                                                         */
   /*                                                               */
   /* INPUT PARAMETERS                                              */
   /*  operation                                                    */
   /*                                                               */
   /* OUTPUT PARAMETERS                                             */
   /*  yield percentage                                             */

   define input parameter  ip_op         like wod_op no-undo.
   define output parameter op_yield_pct  as decimal  no-undo.

   /*  Determine operation yield to be used     */
   op_yield_pct = 100.

   for each tt-routing-yields
         where tt-op   < ip_op:
      op_yield_pct = op_yield_pct * tt-yield-pct * .01.
   end. /* for each tt-routing-yields */
END PROCEDURE.   /* procedure ip-get-yield  */

/******************************************************************/
