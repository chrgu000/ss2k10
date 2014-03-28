/* fcfsre.p - FORECAST CONSUMPTION RECALCULATION                        */
/* Copyright 1986-2000 QAD Inc., Carpinteria, CA, USA.                  */
/* All rights reserved worldwide.  This is an unpublished work.         */
/*F0PN*/ /*V8:ConvertMode=Maintenance                                   */
/* REVISION: 5.0      LAST MODIFIED: 11/07/89   BY: EMB *B386* */
/* REVISION: 6.0      LAST MODIFIED: 07/25/90   BY: emb *D036* */
/* REVISION: 7.0      LAST MODIFIED: 09/01/94   BY: ljm *FQ67* */
/* REVISION: 7.0      LAST MODIFIED: 03/07/95   BY: emb *F0M2* */
/* REVISION: 7.0      LAST MODIFIED: 05/03/96   BY: emb *G1V6* */
/* REVISION: 9.1      LAST MODIFIED: 08/14/00   BY: *N0L0* Jacolyn Neder */


/*G1V6*/ {mfglobal.i}

     define shared variable fcs_recid as recid.
     define shared variable nett like a6fcs_fcst_qty extent 156.
/*FQ67*  define shared variable forward like soc_fcst_fwd. */
/*FQ67*/ define shared variable frwrd like soc_fcst_fwd.
/*FQ67*  define shared variable back    like soc_fcst_bck. */
/*FQ67*/ define shared variable bck    like soc_fcst_bck.

/*G1V6*  define buffer fcs_prev for a6fcs_sum. */
/*G1V6*  define buffer fcs_next for a6fcs_sum. */
     define variable i as integer no-undo.
     define variable ii as integer no-undo.

/*G1V6*/ /* Added section */
     define new shared variable grs like a6fcs_fcst_qty extent 156 no-undo.
     define new shared variable net like a6fcs_fcst_qty extent 156 no-undo.

     define variable fcspart as character no-undo.
     define variable fcssite as character no-undo.
     define variable fcsyear as integer no-undo.
     define variable curyear as integer no-undo.

     find a6fcs_sum no-lock where recid(a6fcs_sum) = fcs_recid no-error.

     assign
         fcspart = a6fcs_part
         fcssite = a6fcs_site
         fcsyear = a6fcs_year
         curyear = a6fcs_year.

     do while can-find (a6fcs_sum WHERE a6fcs_domain = global_domain AND  a6fcs_part = fcspart
     and a6fcs_site = fcssite and a6fcs_year = curyear - 1):
        curyear = curyear - 1.
     end.

     /* Populate net/grs arrays[105-156] with a6fcs_sum data */
     {gprun.i ""a6fsupa.p"" "(fcspart, fcssite, curyear)" }

     /* Roll back net/grs arrays[053-156] to [001-104] */
     {gprun.i ""a6fsupb.p""}

     /* Populate net/grs arrays[105-156] with a6fcs_sum data */
     {gprun.i ""a6fsupa.p"" "(fcspart, fcssite, curyear + 1)" }

     do while true:

        /* consume the appropriate weeks of sales forecasts as prescribed
        by the sales order control file for weeks forward and backwards
        of consumption */
        {gpfsre.i}

        if curyear = fcsyear then leave.

        /* Roll back net/grs arrays[053-156] to [001-104] */
        {gprun.i ""a6fsupb.p""}

        curyear = curyear + 1.

        /* Populate net/grs arrays[105-156] with a6fcs_sum data */
        {gprun.i ""a6fsupa.p"" "(fcspart, fcssite, curyear + 1)" }

     end.

     do i = 1 to 52:
        assign
        nett[i] = min(grs[i],max(net[i],0))

        nett[i + 52] = min(grs[i + 52],max(net[i + 52],0))

        nett[i + 104] = min(grs[i + 104],max(net[i + 104],0)).
     end.

/*G1V6*/ /* End of added section */

/*G1V6** /* Deleted section -- replaced by above logic */
       * find a6fcs_sum where recid(a6fcs_sum) = fcs_recid no-lock no-error.
       **
    *find fcs_prev where fcs_prev.a6fcs_part = a6fcs_sum.a6fcs_part
/*D036*/*and fcs_prev.a6fcs_site = a6fcs_sum.a6fcs_site
    *and fcs_prev.a6fcs_year = a6fcs_sum.a6fcs_year - 1 no-lock no-error.
    *
    *find fcs_next where fcs_next.a6fcs_part = a6fcs_sum.a6fcs_part
/*D036*/*and fcs_next.a6fcs_site = a6fcs_sum.a6fcs_site
    *and fcs_next.a6fcs_year = a6fcs_sum.a6fcs_year + 1 no-lock no-error.
    *
    *nett = 0.
    *do i = 1 to 52:
    *   if available fcs_prev then
    *      nett[i] = fcs_prev.a6fcs_fcst_qty[i] - fcs_prev.fcs_sold_qty[i].
    *
    *   if available a6fcs_sum then
    *      nett[i + 52] = a6fcs_sum.a6fcs_fcst_qty[i]
    *    - a6fcs_sum.fcs_sold_qty[i].
    *
    *   if available fcs_next then
    *      nett[i + 104] = fcs_next.a6fcs_fcst_qty[i]
    *    - fcs_next.fcs_sold_qty[i].
    *end.
    *
/*FQ67* *do i = 1 + max(forward,back) to 156 - max(forward,back): */
/*FQ67*/*do i = 1 + max(frwrd,bck) to 156 - max(frwrd,bck):
    *   if nett[i] >= 0 then next.
/*FQ67* *   do ii = 1 to max(forward,back): */
/*FQ67*/*   do ii = 1 to max(frwrd,bck):
/*FQ67* *      if ii <= back and nett[i - ii] > 0 then do: */
    *
/*FQ67*/*         if ii <= bck and nett[i - ii] > 0 then do:
    *            nett[i - ii] = nett[i - ii] + nett[i].
    *            if nett[i - ii] >= 0 then leave.
    *            nett[i] = nett[i - ii].
    *            nett[i - ii] = 0.
    *         end.
/*FQ67* *         if ii <= forward and nett[i + ii] > 0 then do: */
/*FQ67*/*         if ii <= frwrd and nett[i + ii] > 0 then do:
    *            nett[i + ii] = nett[i + ii] + nett[i].
    *            if nett[i + ii] >= 0 then leave.
    *            nett[i] = nett[i + ii].
    *            nett[i + ii] = 0.
    *         end.
    *      end.
    *   nett[i] = 0.
    *end.
    *
    *do i = 1 to 52:
    *   nett[i] = max(nett[i],0).
/*F0M2*/*   if available fcs_prev
/*F0M2*/*      then nett[i] = min(fcs_prev.a6fcs_fcst_qty[i],nett[i]).
    *
    *   nett[i + 52] = max(nett[i + 52],0).
/*F0M2*/*   if available a6fcs_sum
/*F0M2*/*      then nett[i + 52] = min(a6fcs_sum.a6fcs_fcst_qty[i],nett[i + 52]).
    *
    *   nett[i + 104] = max(nett[i + 104],0).
/*F0M2*/*   if available fcs_next
/*F0M2*/*      then nett[i + 104] = min(fcs_next.a6fcs_fcst_qty[i],nett[i + 104]).
      ***end.
**G1V6*/ /* End of deleted section */

