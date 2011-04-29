/* woworla.p - PRINT / RELEASE WORK ORDERS 1st subroutine               */
/* Copyright 1986-2001 QAD Inc., Carpinteria, CA, USA.                  */
/* All rights reserved worldwide.  This is an unpublished work.         */
/*F0PN*/ /*V8:ConvertMode=Maintenance                                   */
/*K1Q4*/ /*V8:RunMode=Character,Windows                                 */
/* REVISION: 1.0       LAST EDIT: 06/30/86      MODIFIED BY: EMB        */
/* REVISION: 1.0       LAST EDIT: 01/29/87      MODIFIED BY: EMB *A19*  */
/* REVISION: 2.0       LAST EDIT: 07/24/87      MODIFIED BY: EMB *A75*  */
/* REVISION: 2.0       LAST EDIT: 11/18/87      MODIFIED BY: EMB *A75*  */
/* REVISION: 2.0       LAST EDIT: 12/04/87      MODIFIED BY: EMB *A75*  */
/* REVISION: 4.0       LAST EDIT: 01/06/88      MODIFIED BY: RL  *128*  */
/* REVISION: 4.0       LAST EDIT: 06/13/88      MODIFIED BY: EMB *A288* */
/* REVISION: 4.0       LAST EDIT: 07/22/88      MODIFIED BY: EMB *A347* */
/* REVISION: 4.0       LAST EDIT: 04/14/89      MODIFIED BY: EMB **     */
/* REVISION: 5.0       LAST EDIT: 06/23/89      MODIFIED BY: MLB *B159* */
/* REVISION: 7.0       LAST EDIT: 09/14/92      MODIFIED BY: emb *F892* */
/* REVISION: 7.3       LAST EDIT: 12/31/92      MODIFIED BY: pma *G382* */
/* REVISION: 7.3       LAST EDIT: 02/09/93      MODIFIED BY: emb *G656* */
/* REVISION: 7.3       LAST EDIT: 06/21/93      MODIFIED BY: qzl *GC35* */
/* REVISION: 7.3       LAST EDIT: 09/23/93      MODIFIED BY: pxd *GF80* */
/* REVISION: 7.2       LAST EDIT: 03/18/94      MODIFIED BY: ais *FM19* */
/* Oracle changes (share-locks)    09/13/94           BY: rwl *GM56*    */
/* REVISION: 8.6       LAST EDIT: 05/20/98      BY: *K1Q4* Alfred Tan   */
/* REVISION: 9.1       LAST EDIT: 08/12/00      BY: *N0KC* myb          */
/* REVISION: 9.1      LAST MODIFIED: 11/23/01   BY: *M1QS* Kirti Desai  */
/* REVISION: eB sp5 chui  LAST MODIFIED: 03/27/07  BY: *ss - eas058* Apple Tam */

/*G382*/ /* DECLARE COMMON VARIABLES */
/*G382*/ {mfdeclre.i}

/*G382   define shared variable mfguser as character. */
     define shared workfile pkdet no-undo
        field pkpart like pk_part
/*G656*/    field pkop as integer
        field pkstart like pk_start
        field pkend like pk_end
        field pkqty like pk_qty
        field pkltoff like ps_lt_off.

     define shared variable comp like ps_comp.
/*F892*/ define shared variable site like ptp_site no-undo.

     define variable qty as decimal initial 1 no-undo.
     define variable level as integer initial 1 no-undo.

     define variable maxlevel as integer initial 99 no-undo.
     define variable record as integer extent 100 no-undo.
     define variable save_qty as decimal extent 100 no-undo.
     define variable i as integer no-undo.

     define variable effstart as date no-undo.
     define variable effend as date no-undo.
     define variable eff_start as date extent 100 no-undo.
     define variable eff_end as date extent 100 no-undo.
/*M1QS*/ define variable l_mfguser as character format "x(18)" no-undo.

     define shared variable eff_date as date.

/*FM19*/ define shared variable phantom like mfc_logical.

/*G382*/ /*DEFINE VARIABLES FOR BILL OF MATERIAL EXPLOSION*/
/*G382*/ {gpxpld01.i "shared"}

     {mfdel.i pkdet}
     hide message no-pause.

/*M1QS*/ l_mfguser = mfguser + "         ".

/*G382************************************************************************/
/*                                                                           */
/*      DELETED FOLLOWING LOGIC AND INCORPORATED IT INTO GPXPLD.P            */
/*                                                                           */
/*G382************************************************************************/
/******************************************************************************

find first ps_mstr use-index ps_parcomp where ps_par = comp no-lock no-error.
repeat:

   if not available ps_mstr then do:
      repeat:
     level = level - 1.
     if level < 1 then leave.
     find ps_mstr where recid(ps_mstr) = record[level] no-lock no-error.
     comp = ps_par.
     qty = save_qty[level].
     if level = 1 then effstart = ?. else effstart = eff_start[level - 1].
     if level = 1 then effend   = ?. else effend   = eff_end[level - 1].
     find next ps_mstr use-index ps_parcomp where ps_par = comp
     no-lock no-error.
     if available ps_mstr then leave.
      end.
   end.

   if level < 1 then leave.

   if eff_date = ? or (eff_date <> ? and
   (ps_start = ? or ps_start <= eff_date) and
   (ps_end = ? or eff_date <= ps_end)) then do:

   if ps_ps_code = "X"
/*F892*/ or (not can-find (pt_mstr where pt_part = ps_comp) and ps_ps_code = "")
   then do:
     record[level] = recid(ps_mstr).
     save_qty[level] = qty.

     eff_start[level] = max(effstart,ps_start).
     if effstart = ? then eff_start[level] = ps_start.
     if ps_start = ? then eff_start[level] = effstart.
     eff_end[level] = min(effend,ps_end).
     if effend   = ? then eff_end[level] = ps_end.
     if ps_end   = ? then eff_end[level] = effend.

     if level < maxlevel or maxlevel = 0 then do:
        comp = ps_comp.

/*F892*/    /* Added section */
        find pt_mstr no-lock where pt_part = ps_comp no-error.
        find ptp_det no-lock where ptp_part = ps_comp
        and ptp_site = site no-error.
        if available ptp_det and ptp_bom_code <> ""
           then comp = ptp_bom_code.
        else if available ptp_det then comp = ptp_part.
        else if not available ptp_det and available pt_mstr
           and pt_bom_code <> "" then comp = pt_bom_code.
        else if not available ptp_det and available pt_mstr
           then comp = pt_part.
/*F892*/    /* End of added section */

        qty = qty * ps_qty_per * (100 / (100 - ps_scrp_pct)).

        effstart = max(eff_start[level],ps_start).
        if eff_start[level] = ? then effstart = ps_start.
        if ps_start = ?         then effstart = eff_start[level].
        effend = min(eff_end[level],ps_end).
        if eff_end[level] = ?   then effend = ps_end.
        if ps_end = ?           then effend = eff_end[level].

        level = level + 1.
        find first ps_mstr use-index ps_parcomp where ps_par = comp
        no-lock no-error.
        next.
     end.
      end.
      else do:
     if ps_ps_code = ""
     and ps_qty_per <> 0
/*F892*/ and can-find (pt_mstr where pt_part = ps_comp)
     then do:
        find first pkdet where pkpart = ps_comp
        and pkstart =
        max(if effstart <> ? then effstart else ps_start,
        if ps_start <> ? then ps_start else effstart)
        and pkend =
        min(if effend <> ? then effend else ps_end,
        if ps_end <> ? then ps_end else effend)
        and pkltoff = ps_lt_off no-error.

        if not available pkdet then do:
           create pkdet.
           assign pkpart = ps_comp
              pkqty  = ps_qty_per * qty * (100 / (100 - ps_scrp_pct)).
             pkstart = max(effstart,ps_start).
               pkend = min(effend,ps_end).
             pkltoff = ps_lt_off.
           if effstart = ? then pkstart = ps_start.
           if ps_start = ? then pkstart = effstart.
           if effend = ? then pkend = ps_end.
           if ps_end = ? then pkend = effend.
        end.
        else pkqty = pkqty + ps_qty_per * qty * (100 / (100 - ps_scrp_pct)).
     end.
      end.
   end.
   find next ps_mstr use-index ps_parcomp where ps_par = comp
   no-lock no-error.
end.
*G382**************************************************************************
*G382**************************************************************************
*G382*************************************************************************/

/*FM19*/    /* changed &phantom from 'no' to a passed parameter (phantom)    */
/*GF80*/    /* changed &phantom from 'yes' to 'no'   */
/*GC35*/    /* changed &phantom from 'no' to 'yes'   */
/*ss - eas058     {gpxpldps.i &date=eff_date
            &site=site
            &comp=comp
            &group=null_char
            &process=null_char
            &op=?
            &phantom=phantom
        }
*ss - eas058*/
/*ss - eas058*/    {xxgpxpldps.i &date=eff_date
            &site=site
            &comp=comp
            &group=null_char
            &process=null_char
            &op=?
            &phantom=phantom
        }

/*G382*/    /* Added section */

/*M1QS** /*GM56*/    for each pk_det exclusive where pk_user = mfguser: */

/*M1QS*/ for each pk_det
/*M1QS*/    where pk_user >= mfguser
/*M1QS*/    and   pk_user <= l_mfguser
/*M1QS*/    exclusive-lock:

            find first pkwkfl where pkrecid = recid(pk_det).
            create pkdet.
            assign pkpart = pk_part
            pkstart = pk_start
/*G656*/               pkop = integer(pk_reference)
              pkend = pk_end
              pkqty = pk_qty
            pkltoff = ltoff.
          delete pk_det.
          delete pkwkfl.
        end.
/*G382*/    /* End of added section */
