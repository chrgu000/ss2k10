/* bmpsrp5a.p - BOM SUMMARY SUB-ROUTINE                                 */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                  */
/* All rights reserved worldwide.  This is an unpublished work.         */
/* $Revision: 1.4.1.9 $                                                         */
/*V8:ConvertMode=Report                                        */
/*  REVISION: 5.0       LAST EDIT: 01/09/90      MODIFIED BY: MLB *B494*/
/*  REVISION: 6.0       LAST EDIT: 10/26/90      MODIFIED BY: emb *D145*/
/*  REVISION: 7.3       LAST EDIT: 10/19/93      MODIFIED BY: ais *GG43*/
/*  REVISION: 8.6       LAST EDIT: 10/14/97      MODIFIED BY: gyk *K0ZF* */
/*  REVISION: 9.1       LAST EDIT: 08/11/00      BY: *N0KK* jyn          */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* Revision: 1.4.1.7  BY: Samir Bavkar DATE: 04/15/02 ECO: *P000* */
/* $Revision: 1.4.1.9 $ BY: Paul Donnelly (SB) DATE: 06/26/03 ECO: *Q00B* */
/* $Revision: 1.4.1.9 $ BY: Micho Yang         DATE: 05/26/08  ECO: *SS - 20080526.1* */
/*-Revision end---------------------------------------------------------------*/

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/*GG43*/ {mfdeclre.i}
{wbrp02.i}

define shared variable comp like ps_comp.
define shared variable site like si_site.
define shared variable maxlevel as integer no-undo.
define shared variable l_gl_std like mfc_logical no-undo.

define variable qty as decimal initial 1 no-undo.
define variable level as integer initial 1 no-undo.
define variable record as integer extent 1000 no-undo.
define variable save_qty as decimal extent 1000 no-undo.
define variable i as integer no-undo.
define variable effstart as date no-undo.
define variable effend as date no-undo.
define variable eff_start as date extent 1000 no-undo.
define variable eff_end as date extent 1000 no-undo.
define variable par like ps_par.
define variable l_linked like mfc_logical no-undo.

define buffer ptmstr for pt_mstr.

{mfdel.i pk_det " where pk_det.pk_domain = global_domain and  pk_user =
mfguser"}

/* SS - 20080526.1 - B */
define  shared  temp-table  tmp_det
   field  tmp_par   like ps_par
   field  tmp_comp  like ps_comp
   field  tmp_qty   like ps_qty_per
   field  tmp_mtl   like  sct_mtl_tl
   field  tmp_sub   like sct_sub_tl 
   field  tmp_tot   like sct_sub_tl
   INDEX index1 tmp_par tmp_comp .

for each tmp_det :
    delete tmp_det .
end.
/* SS - 20080526.1 - E */

hide message no-pause.

find first ps_mstr use-index ps_parcomp  where ps_mstr.ps_domain =
global_domain and  ps_par = comp
no-lock no-error.

repeat:
   l_linked = false.
   if l_gl_std then
      for first in_mstr no-lock
       where in_mstr.in_domain = global_domain and  in_part = comp
      and in_site = site:
         if in_gl_cost_site <> in_site then
            l_linked = true.
      end. /* FOR FIRST IN_MSTR */

   if not available ps_mstr or l_linked then do:
      repeat:
         level = level - 1.
         if level < 1 then leave.
         find ps_mstr where recid(ps_mstr) = record[level]
         no-lock no-error.
         comp = ps_par.

         qty = save_qty[level].
         if level = 1 then effstart = ?.
         else effstart = eff_start[level - 1].
         if level = 1 then effend   = ?.
         else effend   = eff_end[level - 1].
         find next ps_mstr use-index ps_parcomp  where ps_mstr.ps_domain =
         global_domain and  ps_par = comp
         no-lock no-error.
         if available ps_mstr then leave.
      end.
   end.
   if level < 1 then leave.

   par = ps_par.
   if ps_ps_code = "" and ps_qty_per <> 0 then do:

      find pt_mstr  where pt_mstr.pt_domain = global_domain and  pt_part =
      ps_comp no-lock no-error.
      if available pt_mstr then do:

         find first pk_det  where pk_det.pk_domain = global_domain and  pk_part
         = ps_comp
            and pk_reference = ps_ref and pk_user = mfguser
            and pk_start =
            max(if effstart = ? then low_date else effstart,
            if ps_start <> ? then ps_start else low_date)
            and pk_end =
            min(if effend = ? then hi_date else effend,
            if ps_end <> ? then ps_end else hi_date) no-error.

         if not available pk_det then do:
            create pk_det. pk_det.pk_domain = global_domain.
            assign pk_user = mfguser
               pk_part = ps_comp
               pk_reference = ps_ref
               pk_start = max(if effstart = ? then low_date else effstart,
               if ps_start <> ? then ps_start else low_date)
               pk_end = min(if effend = ? then hi_date else effend,
               if ps_end <> ? then ps_end else hi_date).
         end.

         pk_qty = pk_qty + ps_qty_per * qty * (100 / (100 - ps_scrp_pct)).

         /* SS - 20080526.1 - B */
         FOR first ptmstr where ptmstr.pt_domain = global_domain and ptmstr.pt_part = ps_par no-lock :
         END.
         if available ptmstr then do: 
            FOR first ptp_det where ptp_domain = global_domain and ptp_part = ps_par no-lock :
            END.
            if available ptp_det and ptp_pm_code = "P" or  not available ptp_det and ptmstr.pt_pm_code = "P"  then do:
             FIND FIRST tmp_det where tmp_par = ps_par and tmp_comp = ps_comp no-error .
             if not available  tmp_det then do:
                   create tmp_det .
                   assign tmp_par = ps_par 
                     tmp_comp = ps_comp .
             end.
             tmp_qty = ps_qty_per * (100 / (100 - ps_scrp_pct)) .
            end.
         end.
         /* SS - 20080526.1 - E */
      end.
   end.
   if (ps_ps_code = "" or ps_ps_code = "X")
      and ps_qty_per <> 0 and level < 1000
      and (level < maxlevel or maxlevel = 0) then do:

      record[level] = recid(ps_mstr).
      save_qty[level] = qty.

      eff_start[level] = max(effstart,ps_start).
      if effstart = ? then eff_start[level] = ps_start.
      if ps_start = ? then eff_start[level] = effstart.
      eff_end[level] = min(effend,ps_end).
      if effend   = ? then eff_end[level] = ps_end.
      if ps_end   = ? then eff_end[level] = effend.

      comp = ps_comp.
      find ptp_det no-lock  where ptp_det.ptp_domain = global_domain and
      ptp_part = ps_comp
         and ptp_site = site no-error.
      if available ptp_det then do:
         if ptp_bom_code <> "" then
            comp = ptp_bom_code.
      end.
      else find pt_mstr no-lock  where pt_mstr.pt_domain = global_domain and
      pt_mstr.pt_part = ps_comp no-error.
      if available pt_mstr and pt_mstr.pt_bom_code <> "" then
         comp = pt_mstr.pt_bom_code.

      qty = qty * ps_qty_per * (100 / (100 - ps_scrp_pct)).

      effstart = max(eff_start[level],ps_start).
      if eff_start[level] = ? then effstart = ps_start.
      if ps_start = ?         then effstart = eff_start[level].
      effend = min(eff_end[level],ps_end).
      if eff_end[level] = ?   then effend = ps_end.
      if ps_end = ?           then effend = eff_end[level].

      level = level + 1.
      find first ps_mstr use-index ps_parcomp  where ps_mstr.ps_domain =
      global_domain and  ps_par = comp
      no-lock no-error.
   end.
   else
   find next ps_mstr use-index ps_parcomp  where ps_mstr.ps_domain =
   global_domain and  ps_par = comp
   no-lock no-error.

end.
{wbrp04.i}
