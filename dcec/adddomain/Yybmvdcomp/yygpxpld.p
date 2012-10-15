/* GUI CONVERTED from gpxpld.p (converter v1.78) Thu Apr 15 22:59:10 2010 */
/* gpxpld.p - EXPLODE BILL OF MATERIAL                                        */
/* Copyright 1986-2010 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* REVISION: 7.0      LAST MODIFIED: 12/02/92   BY: pma *G382*                */
/* REVISION: 7.3      LAST MODIFIED: 02/08/93   BY: emb *G656*                */
/* REVISION: 7.3      LAST MODIFIED: 06/22/93   BY: qzl *GC35*                */
/* REVISION: 7.3      LAST MODIFIED: 10/10/94   BY: pxd *FR91*                */
/* REVISION: 7.3      LAST MODIFIED: 11/30/94   BY: emb *FU13*                */
/* REVISION: 7.3      LAST MODIFIED: 11/16/95   BY: rvw *G1DF*                */
/* REVISION: 7.3      LAST MODIFIED: 01/16/96   BY: jym *G1JF*                */
/* REVISION: 7.3      LAST MODIFIED: 12/17/96   BY: *G2J7* Murli Shastri      */
/* REVISION: 8.5      LAST MODIFIED: 10/09/98   BY: *J31Z* Felcy D'Souza      */
/* REVISION: 8.6E     LAST MODIFIED: 03/29/00   BY: *L0VK* Vandna Rohira      */
/* REVISION: 9.1      LAST MODIFIED: 04/25/00   BY: *N0CD* Santosh Rao        */
/* REVISION: 9.1      LAST MODIFIED: 08/13/00   BY: *N0KS* myb                */
/* REVISION: 9.1      LAST MODIFIED: 08/17/00   BY: *N0LT* Vandna Rohira      */
/* REVISION: 9.1      LAST MODIFIED: 01/17/00   BY: *M0Y8* Mark Christian     */
/* Revision: 1.16  BY: Paul Donnelly (SB) DATE: 06/26/03 ECO: *Q00F* */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* Revision: 1.17     BY: Vivek Gogte          DATE: 06/10/04  ECO: *P25Q*    */
/* Revision: 1.17.2.1 BY: Sandeep Panchal      DATE: 08/29/08  ECO: *Q1JC*    */
/* Revision: 1.17.2.2 BY: Alex Joy             DATE: 12/22/08  ECO: *Q223*  */
/* Revision: 1.17.2.3 BY: Chandrakant Ingale   DATE: 02/18/10  ECO: *Q3VH*  */
/* $Revision: 1.17.2.4 $  BY: Rajat Kulshreshtha  DATE: 04/15/10 ECO: *Q40C* */
/* $Revision:eb21sp12  $ BY: Jordan Lin            DATE: 09/06/12  ECO: *SS-20120906.1*   */

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/
/*-Revision end---------------------------------------------------------------*/

/*G382*******************************************************************/
/*G382                                                                  */
/*G382                      MODIFIED FROM GPOPEX.P                      */
/*G382                                                                  */
/*G382*******************************************************************/

/*FR91 ************************************************************************
**      gpxpld.p has ben modified with this change to multiply pk_qty
**      by tmprnd which has the following value:
**
**      define variable tmprnd as decimal initial 10000000000000000.
**
**      Programs that call gpxpld.p have to divide the pk_qty field by the
**      same value. This was done to fix the precision issue that was raised
**      by SR102072 on scrap percentage calculations.
**
**FR91 **********************************************************************/

/* Backs out FR91          */

/*V8:ConvertMode=Maintenance                                                  */

{mfdeclre.i}

{gpxpld02.i}

define variable qty as decimal initial 1 no-undo.
define variable tempqty as decimal no-undo.
define variable batchqty like bom_batch initial 1 no-undo.
define variable level as integer initial 1 no-undo.
define variable conv like um_conv initial 1 no-undo.
define variable par_type like ps_qty_type initial "" no-undo.
define variable phantom like mfc_logical no-undo.
define variable maxlevel as integer initial 99 no-undo.
define variable numrec as integer initial 0 no-undo.
define variable i as integer no-undo.
define variable iss_pol like mfc_logical no-undo.
define variable effstart as date no-undo.
define variable effend as date no-undo.

define variable record as integer extent 100 no-undo.
define variable save_qty as decimal extent 100 no-undo.
define variable save_batchqty as decimal extent 100 no-undo.
define variable save_conv as decimal extent 100 no-undo.
define variable save_par_type as character extent 100 no-undo.
define variable save_start as date extent 100 no-undo.
define variable save_end as date extent 100 no-undo.
define variable l_loc    like pt_loc        no-undo.
 /* *SS-20120906.1* -b  */ 
/**************tfq added begin***************************************/
define shared temp-table xxpk_det 
        field xxpk_user like pk_user
        field xxpk_part like pk_part
        field xxpk_ref like pk_reference
        field xxpk_op like ps_op  .
               
/*************tfq added end******************************************/
 /* *SS-20120906.1* -e  */ 
define variable assy_op like ps_op             no-undo.
define variable l_qty   as   decimal initial 1 no-undo.
for each qad_wkfl
   where qad_domain = global_domain
     and qad_key1   = mfguser
     and qad_key3   = "FLRSTKIT"
   exclusive-lock:
   delete qad_wkfl.
end. /* FOR EACH qad_wkfl ... */

if pkdel then do:
   {mfdel.i pk_det " where pk_det.pk_domain = global_domain and  pk_user =
        mfguser"}
end.

hide message no-pause.
 /* *SS-20120906.1* -b  */ 
/*************tfq added begin********************/
for each xxpk_det where xxpk_user = mfguser:
delete xxpk_det .
end.
/*************tfq added end***************/
 /* *SS-20120906.1* -e  */ 
for first ps_mstr
   fields( ps_domain ps_comp ps_end ps_group ps_lt_off ps_op ps_par
   ps_process
   ps_ps_code ps_qty_per ps_qty_per_b ps_qty_type ps_scrp_pct

   ps_ref ps_start)

   where ps_mstr.ps_domain = global_domain and  ps_par = xpldcomp
   use-index ps_parcomp no-lock:
end. /* FOR FIRST PS_MSTR */

if available ps_mstr then do:

   for first bom_mstr
      fields( bom_domain bom_batch bom_batch_um bom_parent)
      where bom_mstr.bom_domain = global_domain and  bom_parent =
      xpldcomp no-lock:
   end. /* FOR FIRST BOM_MSTR */

   if available bom_mstr and bom_batch <> 0 and bom_batch <> 1
   then do:
      assign
         batchqty = bom_batch
         par_type = "B".
   end.
end.
if batchqty <> 0 then bombatch = batchqty.
else bombatch = 1.
repeat:

   if not available ps_mstr then do:
      repeat:
         level = level - 1.
         if level < 1 then leave.

         for first ps_mstr
            fields( ps_domain ps_comp ps_end ps_group ps_lt_off ps_op ps_par
            ps_process
            ps_ps_code ps_qty_per ps_qty_per_b ps_qty_type ps_scrp_pct
            ps_start)
            where recid(ps_mstr) = record[level] no-lock:
         end. /* FOR FIRST PS_MSTR */

         assign
            xpldcomp = ps_par
            qty      = save_qty[level]
            batchqty = save_batchqty[level]
            par_type = save_par_type[level]
            conv     = save_conv[level].

         if level = 1 then do:
            assign
               effstart = ?
               effend   = ?.
         end.
         else do:
            assign
               effstart = save_start[level - 1]
               effend   = save_end[level - 1].
         end.
         find next ps_mstr use-index ps_parcomp
            where ps_mstr.ps_domain = global_domain and  ps_par = xpldcomp
         no-lock no-error.
         if available ps_mstr then leave.
      end.
   end.

   if level < 1 then leave.

   if (level > 1

      or ((can-do(op_list,string(ps_op))
      or ps_op = operation or operation = ?)
      and (ps_group = psgroup or psgroup = "")
      and (ps_process = psprocess or psprocess = "")))

      and (xplddate = ? or (xplddate <> ?
      and (ps_start = ? or ps_start <= xplddate)
      and (ps_end = ? or xplddate <= ps_end))) then do:

      if level = 1 then assy_op = ps_op.
      assign
         phantom = no
         iss_pol = yes.

      for first pt_mstr
         fields( pt_domain pt_bom_code pt_iss_pol pt_loc pt_part
         pt_phantom pt_um)
         where pt_mstr.pt_domain = global_domain and  pt_part = ps_comp
      no-lock:
      end. /* FOR FIRST PT_MSTR */

      if available pt_mstr then do:
         l_loc = pt_loc.
         for first ptp_det
            fields( ptp_domain ptp_bom_code ptp_iss_pol ptp_part
            ptp_phantom
            ptp_site)
            where ptp_det.ptp_domain = global_domain and  ptp_part =
            ps_comp and
            ptp_site = xpldsite no-lock:
         end. /* FOR FIRST PTP_DET */

         if available ptp_det then do:
            assign
               phantom = ptp_phantom
               iss_pol = ptp_iss_pol.
         end.
         else do:
            assign
               phantom = pt_phantom
               iss_pol = pt_iss_pol.
         end.
      end.

      for first in_mstr
         where in_domain = global_domain
           and in_part   = ps_comp
           and in_site   = xpldsite
      no-lock:
         l_loc = in_loc.
      end. /* FOR FIRST in_mstr */

      if ps_ps_code = "X"
         or (not available pt_mstr and ps_ps_code = "")
         or (incl_phtm = yes and phantom = yes and ps_ps_code = "" )
      then do:

         assign
            record[level]        = recid(ps_mstr)
            save_qty[level]      = qty
            save_batchqty[level] = batchqty
            save_par_type[level] = par_type
            save_conv[level]     = conv
            save_start[level]    = max(effstart,ps_start).

         if effstart = ? then save_start[level] = ps_start.
         if ps_start = ? then save_start[level] = effstart.
         save_end[level] = min(effend,ps_end).
         if effend = ? then save_end[level] = ps_end.
         if ps_end = ? then save_end[level] = effend.

         if level < maxlevel or maxlevel = 0 then do:
            xpldcomp = ps_comp.

            if available ptp_det and ptp_bom_code <> ""
               then xpldcomp = ptp_bom_code.
            else
            if available ptp_det and ptp_bom_code = ""
               then xpldcomp = ptp_part.
            else
            if not available ptp_det and available pt_mstr
               and pt_bom_code <> "" then xpldcomp = pt_bom_code.
            else
            if not available ptp_det and available pt_mstr
               and pt_bom_code = "" then xpldcomp = pt_part.

            assign
               conv     = 1
               batchqty = 1
               par_type = "".

            for first bom_mstr
               fields( bom_domain bom_batch bom_batch_um bom_parent)
               where bom_mstr.bom_domain = global_domain and  bom_parent =
               xpldcomp no-lock:
            end. /* FOR FIRST BOM_MSTR */

            if available bom_mstr and bom_batch <> 0
               and bom_batch <> 1  then do:
               assign
                  batchqty = bom_batch
                  par_type = ps_qty_type.

               if available pt_mstr and pt_um <> bom_batch_um
               then do:
                  {gprun.i ""gpumcnv.p""
                     "(bom_batch_um, pt_um, bom_parent, output conv)"}
/*GUI*/ if global-beam-me-up then undo, leave.

                  if conv = ? then conv = 1.
               end.
            end.

            /* WHEN ps_qty_type = "", COMPONENT REQUIREMENT SHOULD */
            /* BE FOR WHOLE BATCH OF THE PARENT RATHER THAN FOR    */
            /* SINGLE PARENT.                                      */

            /* IF batchqty IS EQUAL TO EITHER 0 OR 1 THEN qty WILL */
            /* BE CALCULATED EVEN THOUGH ps_qty_type = "B"         */

            if (ps_qty_type          =  ""  or
               batchqty             =  0   or
               batchqty             =  1)  and
               save_batchqty[level] <> 0   and
               save_batchqty[level] <> 1
               then
               qty = qty * save_batchqty[level].

            if (batchqty <> 1 and
               batchqty <> 0)
               then
            qty = qty * (ps_qty_per_b / (batchqty * conv))
            * (100 / ( 100 - ps_scrp_pct)).
            else
            qty = qty * ps_qty_per
            * (100 / ( 100 - ps_scrp_pct)).

            effstart = max(save_start[level],ps_start).
            if save_start[level] = ? then effstart = ps_start.
            if ps_start = ? then effstart = save_start[level].
            effend = min(save_end[level],ps_end).
            if save_end[level] = ? then effend = ps_end.
            if ps_end = ? then effend = save_end[level].

            assign
               l_qty = qty
               level = level + 1.

            for first ps_mstr
               fields( ps_domain ps_comp ps_end ps_group ps_lt_off ps_op ps_par
               ps_process ps_ps_code ps_qty_per ps_qty_per_b

               ps_qty_type ps_ref ps_scrp_pct ps_start)

               where ps_mstr.ps_domain = global_domain and  ps_par = xpldcomp
               use-index ps_parcomp no-lock:
            end. /* FOR FIRST PS_MSTR */

         end.  /*if level < maxlevel*/
         else do:
            find next ps_mstr use-index ps_parcomp
               where ps_mstr.ps_domain = global_domain and  ps_par = xpldcomp
            no-lock no-error.
         end.
      end. /*if ps_ps_code = "X"*/

      else do:
         if ps_ps_code = ""

            and can-find (pt_mstr  where pt_mstr.pt_domain = global_domain and
            (  pt_part = ps_comp))
            and (iss_pol or incl_nopk)
         then do:
            find first pk_det exclusive-lock
               where pk_det.pk_domain = global_domain and  pk_user      =
               mfguser
               and   pk_part      = ps_comp
               and   pk_reference = string(assy_op)
               and   pk_start     = max(if effstart <> ? then effstart
               else ps_start,
               if ps_start <> ? then ps_start
               else effstart)
               and   pk_end       = min(if effend <> ? then effend
               else ps_end,
               if ps_end <> ? then ps_end
               else effend)
               no-error.

            if available pk_det then do:
               find first pkwkfl where pkrecid = recid(pk_det)
               no-lock no-error.
               if ltoff <> ps_lt_off then
               repeat:
                  find next pk_det exclusive-lock
                     where pk_det.pk_domain = global_domain and  pk_user
                     = mfguser
                     and   pk_part      = ps_comp
                     and   pk_reference = string(assy_op)
                     and   pk_start     = max(if effstart <> ? then effstart
                     else ps_start,
                     if ps_start <> ? then ps_start
                     else effstart)
                     and   pk_end       = min(if effend <> ? then effend
                     else ps_end,
                     if ps_end <> ? then ps_end
                     else effend)
                     no-error.

                  if available pk_det then do:
                     find first pkwkfl where pkrecid = recid(pk_det)
                     no-lock no-error.
                     if ltoff = ps_lt_off then leave.
                  end.
                  else leave.
               end. /* IF LTOFF <> PS_LT_OFF */
            end. /* IF AVAILABLE PK_DET */

            if not available pk_det then do:
               if can-find(first pk_det
                  where pk_det.pk_domain = global_domain and
                  pk_user      = mfguser
                  and   pk_part      = ps_comp
                  and   pk_reference = string(assy_op)
                  and   pk_start     = max(if effstart <> ?
                  then effstart
                  else ps_start,
                  if ps_start <> ?
                  then ps_start
                  else effstart)
                  and   pk_end       = min(if effend <> ?
                  then effend
                  else ps_end,
                  if ps_end <> ?
                  then ps_end
                  else effend) ) then
               find first pk_det exclusive-lock
                  where pk_det.pk_domain = global_domain and  pk_user
                  = mfguser
                  and   pk_part      = ps_comp
                  and   pk_reference = string(assy_op)
                  and   pk_start     = max(if effstart <> ? then effstart
                  else ps_start,
                  if ps_start <> ? then ps_start
                  else effstart)
                  and   pk_end       = min(if effend <> ? then effend
                  else ps_end,
                  if ps_end <> ? then ps_end
                  else effend)
                  no-error.
               else do:

                  create pk_det.
                  pk_det.pk_domain = global_domain.
                  assign pk_user      = mfguser
                     pk_part      = ps_comp
 /* *SS-20120906.1*                       pk_reference = string(assy_op)  */ 
  /* *SS-20120906.1*         */           pk_reference = string(ps_op)  
                     pk_loc       = l_loc
                     pk_start     = max(effstart,ps_start)
                     pk_end       = min(effend,ps_end).
                  if effstart = ? then pk_start = ps_start.
                  if ps_start = ? then pk_start = effstart.
                  if effend = ? then pk_end = ps_end.
                  if ps_end = ? then pk_end = effend.
		   /* *SS-20120906.1* -b  */ 
                    /**************************tfq added begin************/
                            find first xxpk_det where xxpk_user = mfguser
                                and xxpk_part = ps_comp and xxpk_ref = string(assy_op) no-error .
                                if not available xxpk_det then
                                do:
                                create xxpk_det .
                                assign xxpk_user = mfguser
                                       xxpk_part      = ps_comp
                                       xxpk_ref = string(assy_op)
                                       xxpk_op = ps_op .
                                end.
                          /*tfq      if ps_comp = "10z66-01013" then do: 
                                message xxpk_op .
                                pause .
                                end.  */
                    /*************tfq added end*********************/
		    /* *SS-20120906.1* -e  */ 
                  create pkwkfl.
                  assign pkrecid = recid(pk_det)
                     ltoff   = ps_lt_off
                     isspol  = iss_pol.
               end. /* ELSE DO */
            end. /* IF NOT AVAILABLE PK_DET THEN DO */

            tempqty = 0.

            if ps_qty_type = ""
               then
            tempqty = ps_qty_per * qty
            * (batchqty / if conv <> 0 then
            conv else
            1)
            * 100 / (100 - ps_scrp_pct).
            else
            tempqty = ps_qty_per_b * qty
            * 100 / (100 - ps_scrp_pct).

            pk_qty = pk_qty + tempqty.

         end.

         if (iss_pol = no)
            and (phantom = no)
         then do:
            find qad_wkfl
               where qad_domain = global_domain
                 and qad_key1   = mfguser
                 and qad_key2   = ps_comp
                 and qad_key3   = "FLRSTKIT"
               no-lock no-error.

            if not available qad_wkfl
            then do:
               create qad_wkfl.
               assign
                  qad_domain    = global_domain
                  qad_key1      = mfguser
                  qad_key2      = ps_comp
                  qad_key3      = "FLRSTKIT"
                  qad_decfld[1] = l_qty * ps_qty_per.
            end. /* IF NOT AVAILABLE qad_wkfl */
         end. /* IF (iss_pol = no ... */

         find next ps_mstr use-index ps_parcomp
            where ps_mstr.ps_domain = global_domain and  ps_par = xpldcomp
         no-lock no-error.
      end. /*else do (ps_ps_code <> "X")*/
   end. /*if level > 1*/

   else do:
      find next ps_mstr use-index ps_parcomp  where ps_mstr.ps_domain =
         global_domain and  ps_par = xpldcomp
      no-lock no-error.
   end.
end. /*repeat*/
