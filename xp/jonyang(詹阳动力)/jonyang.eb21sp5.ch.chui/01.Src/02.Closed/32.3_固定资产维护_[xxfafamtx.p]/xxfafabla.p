/* fafabla.p Fixed Assets Layer Functionality                              */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                     */
/* All rights reserved worldwide.  This is an unpublished work.            */
/* $Revision: 1.6.1.18 $                                                */
/*V8:ConvertMode=NoConvert                                                 */
/* REVISION: 9.1      LAST MODIFIED: 10/26/99   BY: *N021* Pat Pigatti     */
/* REVISION: 9.1      LAST MODIFIED: 04/12/00   BY: *N08H* Veena Lad       */
/* REVISION: 9.1      LAST MODIFIED: 08/14/00   BY: *N0L0* Jacolyn Neder   */
/* REVISION: 9.1      LAST MODIFIED: 08/28/00   BY: *N0NV* BalbeerS Rajput */
/* REVISION: 9.1      LAST MODIFIED: 09/28/00   BY: *M0T5* Rajesh Lokre    */
/* Revision: 1.6.1.8  BY: Ashish M.           DATE: 10/11/01  ECO: *M1M1*  */
/* Revision: 1.6.1.9  BY: Seema Tyagi         DATE: 11/06/01  ECO: *N15T*  */
/* Revision: 1.6.1.10 BY: Manisha Sawant      DATE: 02/28/03  ECO: *N27V*  */
/* Revision: 1.6.1.12 BY: Paul Donnelly (SB)  DATE: 06/26/03  ECO: *Q00C*  */
/* Revision: 1.6.1.13 BY: Anup Pereira        DATE: 11/24/03  ECO: *P1BR*  */
/* Revision: 1.6.1.14 BY: Sandy Brown (OID)   DATE: 12/06/03  ECO: *Q04L*  */
/* Revision: 1.6.1.15 BY: Ajay Nair           DATE: 07/18/04  ECO: *P2BC*  */
/* $Revision: 1.6.1.18 $ BY: Pankaj Goswami DATE: 09/23/04  ECO: *P2K3*  */

/* SS - 100521.1  By: Roger Xiao */  /*资产转移标准程式bug修复:无效的账户组合,new sub = old sub ,new cc = new loc cc */
/*-Revision end---------------------------------------------------------------*/

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

{mfdeclre.i}
{gplabel.i}

/* ********** END TRANSLATABLE STRINGS DEFINITION ********* */

define input        parameter l-asset     like fa_mstr.fa_id no-undo.
define input-output parameter l-new-asset like fa_id         no-undo.
define input        parameter l-%         as   decimal       no-undo.
define input        parameter l-amt       as   decimal       no-undo.
define input        parameter l-qty       as   integer       no-undo.
define input        parameter l-new-loc   like fa_faloc_id   no-undo.
define input        parameter l-new-sub   like faloc_sub     no-undo.
define input        parameter l-new-cc    like faloc_cc      no-undo.
define input        parameter l-date      like fa_disp_dt    no-undo.
define input        parameter l-partrf    like mfc_logical   no-undo.
define output       parameter l-err-nbr   like msg_nbr       no-undo.

define buffer famstr    for fa_mstr.
define buffer fabdet    for fab_det.
define buffer fabddet   for fabd_det.
define buffer faddet    for fad_det.
define buffer fabadet   for faba_det.
define buffer faadjmstr for faadj_mstr.
define buffer cmtdet    for cmt_det.
define buffer fabdpar   for fabd_det.

define shared workfile temp-select
   field sel_idr    as character format "x(1)"
   field sel_tag    as character format "x(17)"
   field sel_desc   as character format "x(20)"
   field sel_amt    as decimal   format ">>>,>>>,>>9.99<"
   field sel_serial as character format "x(20)".

define variable l-puramt        like fa_puramt   no-undo.
define variable temp-tag        like fad_tag     no-undo.
define variable temp-fa-amt     like fa_puramt   no-undo.
define variable temp-fa-qty     like fa_qty      no-undo.
define variable mc-error-number like msg_nbr     no-undo.
define variable l-seq           like fabd_seq    no-undo.
define variable l-old-seq       like faba_glseq  no-undo.
define variable l-last-seq      like cmt_seq     no-undo.
define variable l_msgdesc       like msg_desc extent 5 no-undo.
define variable l-period        like fabd_yrper        no-undo.
define variable l_accamt        like fabd_accamt       no-undo.
define variable l_accup         like fabd_accup        no-undo.
define variable l_basis         like fab_amt           no-undo.
define variable l_depamt        like fabd_accamt       no-undo.
define variable l_accpar        like fabd_accamt       no-undo.

/* DEFINED VARIABLES AND TEMP TABLE FOR ADJUSTMENT OF */
/* ACCUMULATED DEPRECIATION AND PERIOD DEPERECIATION. */
define variable l_accper        like fabd_accamt       no-undo.
define variable l_peramt        like fabd_peramt       no-undo.
define variable l_rndper        like fabd_peramt       no-undo.
define variable l_commper       like fabd_peramt       no-undo.
define variable l_yrper         like fabd_yrper        no-undo.

define temp-table tt_fabd
   field tt_domain  like fabd_domain
   field tt_yrper   like fabd_yrper
   field tt_fabk_id like fabd_fabk_id
   index tt_fabd is primary tt_domain tt_yrper tt_fabk_id.

/* ORIGINAL PURCHASE AMOUNT WAS */
{pxmsg.i &MSGNUM=3606 &MSGBUFFER=l_msgdesc[1]}

/* NEW ASSET PURCHASE AMOUNT IS */
{pxmsg.i &MSGNUM=3601 &MSGBUFFER=l_msgdesc[2]}

/* OLD ASSET PURCHASE AMOUNT WAS */
{pxmsg.i &MSGNUM=3605 &MSGBUFFER=l_msgdesc[3]}

for first gl_ctrl
   fields( gl_domain gl_rnd_mthd)
    where gl_ctrl.gl_domain = global_domain no-lock:
end. /* FOR FIRST gl_ctrl */

if l-% >= 100
then return.

l-% = l-% / 100.

for last faba_det
   fields(faba_domain faba_fa_id faba_glseq)
   where faba_domain = global_domain
   and   faba_fa_id  = l-asset
   no-lock:
   l-old-seq = faba_glseq.
end. /* FOR LAST faba_det */

do transaction on error undo:

   for first faloc_mstr
      fields( faloc_domain faloc_id
             faloc_entity)
       where faloc_mstr.faloc_domain = global_domain and  faloc_id = l-new-loc
      no-lock:
   end. /* FOR FIRST faloc_mstr */

   /* VALIDATE TRANSFER DATE */
   if l-partrf
   then do:
      if can-find (first fa_mstr
                    where fa_mstr.fa_domain = global_domain and  fa_id = l-asset
                   and  fa_dep = no)
      then do:
         {gprunp.i "fapl" "p" "fa-get-per"
            "(input  l-date,
              input  """",
              output l-period,
              output l-err-nbr)"}
         if l-err-nbr > 0
         then
            return.
      end.  /* IF CAN-FIND fa_mstr ... */

      else do:
         for each fab_det
            fields( fab_domain fab_fa_id
                    fab_fabk_id)
             where fab_det.fab_domain = global_domain and  fab_fa_id = l-asset
            no-lock
            break by fab_fabk_id:

            if first-of (fab_fabk_id)
            then do:
               for first fabk_mstr
                  fields( fabk_domain fabk_id
                          fabk_calendar
                          fabk_post)
                   where fabk_mstr.fabk_domain = global_domain and  fabk_id =
                   fab_fabk_id
                  no-lock:
                  {gprunp.i "fapl" "p" "fa-get-per"
                     "(input  l-date,
                       input  fabk_calendar,
                       output l-period,
                       output l-err-nbr)"}
               end. /* FOR FIRST fabk_mstr */

               if not available fabk_mstr
               then
                  /* INVALID BOOK CODE */
                  l-err-nbr = 4214.

               if l-err-nbr > 0
               then
                  return.
            end. /* IF FIRST-OF fab_fabk_id */

         end. /*  FOR EACH fab_det */
      end. /* ELSE DO */
   end. /*IF l-partrf */

   /* Adjust Asset */
   for first famstr
      exclusive-lock
       where famstr.fa_domain = global_domain and  fa_id = l-asset:
   end. /* FOR FIRST famstr */

   create fa_mstr. fa_mstr.fa_domain = global_domain.
   buffer-copy famstr
      except oid_fa_mstr
         fa_id
         fa_split_from
         fa_split_date
         fa_cmtindx
         fa_puramt
         fa_faloc_id
         fa_entity
         fa_dispamt
         fa_replamt
         fa_salvamt
         fa_insamt
      to fa_mstr
      assign
         l-puramt                = famstr.fa_puramt
         fa_mstr.fa_id           = l-new-asset
         fa_mstr.fa_split_from   = l-asset
         fa_mstr.fa_split_date   = today
         fa_mstr.fa_puramt       = if l-amt <> 0
                                   then l-amt
                                   else l-% * famstr.fa_puramt
         fa_mstr.fa_faloc_id     = if l-partrf
                                   then l-new-loc
                                   else famstr.fa_faloc_id
         fa_mstr.fa_entity       = if l-partrf
                                   then faloc_entity
                                   else famstr.fa_entity
         fa_mstr.fa_dispamt      = l-% * famstr.fa_dispamt
         fa_mstr.fa_replamt      = l-% * famstr.fa_replamt
         fa_mstr.fa_salvamt      = l-% * famstr.fa_salvamt
         fa_mstr.fa_insamt       = l-% * famstr.fa_insamt.
   fa_mstr.fa_domain = global_domain.

   {gprunp.i "mcpl" "p" "mc-curr-rnd"
      "(input-output fa_mstr.fa_puramt,
        input gl_rnd_mthd,
        output mc-error-number)"}
   if mc-error-number <> 0
   then do:
      {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
   end. /* IF mc-error-number */
   {gprunp.i "mcpl" "p" "mc-curr-rnd"
      "(input-output fa_mstr.fa_dispamt,
        input gl_rnd_mthd,
        output mc-error-number)"}
   {gprunp.i "mcpl" "p" "mc-curr-rnd"
      "(input-output fa_mstr.fa_replamt,
        input gl_rnd_mthd,
        output mc-error-number)"}
   {gprunp.i "mcpl" "p" "mc-curr-rnd"
      "(input-output fa_mstr.fa_salvamt,
        input gl_rnd_mthd,
        output mc-error-number)"}
   {gprunp.i "mcpl" "p" "mc-curr-rnd"
      "(input-output fa_mstr.fa_insamt,
        input gl_rnd_mthd,
        output mc-error-number)"}

   assign
      famstr.fa_puramt       = famstr.fa_puramt
                             - fa_mstr.fa_puramt
      famstr.fa_dispamt      = famstr.fa_dispamt
                             - fa_mstr.fa_dispamt
      famstr.fa_replamt      = famstr.fa_replamt
                             - fa_mstr.fa_replamt
      famstr.fa_salvamt      = famstr.fa_salvamt
                             - fa_mstr.fa_salvamt
      famstr.fa_insamt       = famstr.fa_insamt
                             - fa_mstr.fa_insamt.

   /* CREATE fabd_det RECORD FOR NON-DEPRECIATING ASSET */
   if fa_mstr.fa_dep = no
   then do:
      for first fabk_mstr
         fields( fabk_domain fabk_id fabk_calendar fabk_post)
         where fabk_domain = global_domain
         and   fabk_post
         no-lock:
      end. /* FOR FIRST fabk_mstr */

      {gprunp.i "fapl" "p" "fa-get-per"
         "(input  l-date,
           input  """",
           output l-period,
           output l-err-nbr)"}

      if l-err-nbr > 0
      then
         return.

      run create-fabd-det (input fabk_id).
   end.  /* IF fa_dep = NO */
   else do:
      /* Adjust Asset Books */
      for each fabdet
         exclusive-lock
          where fabdet.fab_domain = global_domain and  fab_fa_id = l-asset:

         create fab_det. fab_det.fab_domain = global_domain.
         buffer-copy fabdet
            except oid_fab_det
               fab_fa_id
            to fab_det
            assign
               fab_det.fab_fa_id       = l-new-asset
               fab_det.fab_amt         = l-% * fabdet.fab_amt
               fab_det.fab_ovramt      = l-% * fabdet.fab_ovramt
               fab_det.fab_salvamt     = l-% * fabdet.fab_salvamt
               fab_det.fab_upper       = l-% * fabdet.fab_upper
               fab_det.fab_uplife      = l-% * fabdet.fab_uplife.
         fab_det.fab_domain = global_domain.

         {gprunp.i "mcpl" "p" "mc-curr-rnd"
            "(input-output fab_det.fab_amt,
              input gl_rnd_mthd,
              output mc-error-number)"}
         {gprunp.i "mcpl" "p" "mc-curr-rnd"
            "(input-output fab_det.fab_ovramt,
              input gl_rnd_mthd,
              output mc-error-number)"}
         {gprunp.i "mcpl" "p" "mc-curr-rnd"
            "(input-output fab_det.fab_salvamt,
              input gl_rnd_mthd,
              output mc-error-number)"}

      end. /* FOR EACH fabdet */


      /* Adjust Book Depreciation Records */

      /* TO AVOID ROUNDING ERRORS, FOR EVERY BOOK, IN EACH PERIOD, */
      /* ACC DEPRECIATION = ACC DEPRECIATION + PERIOD DEPRECIATION */
      /* UNITS CONSUMED   = UNITS CONSUMED   + PERIOD ACTUAL UNITS */

      for each fabddet
         exclusive-lock
         where fabddet.fabd_domain = global_domain
         and   fabddet.fabd_fa_id  = l-asset
         break by fabd_fabk_id
               by fabd_resrv
               by fabd_yrper
               by fabd_adj_yrper:

         create fabd_det.
         fabd_det.fabd_domain = global_domain.
         {mfnxtsq1.i  "fabd_det.fabd_domain = global_domain and " fabd_det
         fabd_seq fabd_sq01 l-seq}
         buffer-copy fabddet
            except
               oid_fabd_det
               fabd_fa_id
               fabd_seq
               fabd_entity
               fabd_faloc_id
               fabd_accamt
               fabd_peramt
               fabd_upper
               fabd_accup
               fabd_transfer
               fabd_trn_loc
               fabd_trn_entity
               fabd_trn_glseq
               fabd_mod_userid
               fabd_mod_date
            to fabd_det
            assign
               fabd_det.fabd_fa_id       = l-new-asset
               fabd_det.fabd_seq         = l-seq
               fabd_det.fabd_entity      = if l-partrf
                                              and (fabddet.fabd_yrper
                                                   >= l-period)
                                           then faloc_entity
                                           else fabddet.fabd_entity
               fabd_det.fabd_faloc_id    = if l-partrf
                                              and (fabddet.fabd_yrper
                                                   >= l-period)
                                           then l-new-loc
                                           else fabddet.fabd_faloc_id
               fabd_det.fabd_peramt      = l-% * fabddet.fabd_peramt
               fabd_det.fabd_upper       = l-% * fabddet.fabd_upper
               fabd_det.fabd_mod_userid  = global_userid
               fabd_det.fabd_mod_date    = today.

         if fabd_det.fabd_adj_yrper = l-period
         then
            assign
               fabd_det.fabd_transfer   = yes
               fabd_det.fabd_trn_loc    = fabddet.fabd_faloc_id
               fabd_det.fabd_trn_entity = fabddet.fabd_entity
               fabd_det.fabd_trn_glseq  = l-old-seq.

         if recid(fabd_det) = -1
         then
            .

         {gprunp.i "mcpl" "p" "mc-curr-rnd"
            "(input-output fabd_det.fabd_peramt,
              input gl_rnd_mthd,
              output mc-error-number)"}

         if  first-of(fabddet.fabd_fabk_id)
         or  first-of(fabddet.fabd_resrv)
         then do:
            assign
               l_accamt = 0
               l_accpar = 0
               l_accup  = 0.

            /* FIND ACCUMULATED DEPRECIATION FOR PARENT */
            for each fabdpar
                where fabdpar.fabd_domain = global_domain and  fabdpar.fabd_fa_id
                 = fabddet.fabd_fa_id
               and   fabdpar.fabd_fabk_id = fabddet.fabd_fabk_id
               and   fabdpar.fabd_resrv   = fabddet.fabd_resrv
            no-lock:
               l_accpar = l_accpar + fabdpar.fabd_peramt.
            end. /* FOR EACH fabdpar */

            l_accpar = l-% * l_accpar.

            {gprunp.i "mcpl" "p" "mc-curr-rnd"
                      "(input-output l_accpar,
                        input gl_rnd_mthd,
                        output mc-error-number)"}

            /* OBTAIN THE CORRECT BOOK DETAIL FOR THE DEPRECIATION */
            if first-of(fabddet.fabd_fabk_id)
            then do:
               for first fab_det
                  fields (fab_domain fab_fa_id fab_fabk_id fab_famt_id)
                  where fab_det.fab_domain = global_domain
                  and   fab_fa_id          = fabddet.fabd_fa_id
                  and   fab_fabk_id        = fabddet.fabd_fabk_id
               no-lock:
               end. /* FOR FIRST fab_det */

            end. /* IF FIRST-OF(fabddet.fabd_fabk_id) */

         end. /* IF FIRST-OF(fabddet.fabd_fabk_id) */

         assign
            l_accamt             = fabd_det.fabd_peramt + l_accamt
            fabd_det.fabd_accamt = if fabddet.fabd_accamt <> 0
                                   then
                                      l_accamt
                                   else
                                      0
            l_accup              = fabd_det.fabd_upper + l_accup
            fabd_det.fabd_accup  = l_accup.

         /* ADJUST THE LAST PERIOD DEPRECIATION */
         /* SO THAT THE NET BOOK VALUE IS ZERO. */
         if last-of(fabddet.fabd_fabk_id)
         then do:
            fabd_det.fabd_accamt = fabd_det.fabd_accamt
                                   + (l_accpar - (l_accamt / l-%)).
         end. /* IF LAST-OF(fabddet.fabd_fabk_id) */

      end.  /* FOR EACH fabddet */

      /* RECALCULATING THE ACCUMULATED DEPRECIATION */
      /* FOR EACH PERIOD FOR EACH BOOK.             */

      /* CREATION OF TEMP TABLE BOOK WISE PERIOD WISE       */
      /* FOR PERIODS HAVING PERIOD DEPRECIATION AS NON-ZERO */
      for each fabd_det
         fields (fabd_domain fabd_fa_id  fabd_fabk_id fabd_yrper
                 fabd_post   fabd_peramt fabd_accamt)
      no-lock
         where fabd_domain = global_domain
         and   fabd_fa_id  = l-new-asset
         and   not fabd_post
      break by fabd_fabk_id
            by fabd_yrper:

         accumulate fabd_peramt (total by fabd_yrper).

         if last-of(fabd_yrper)
         then do:
            l_peramt = accum total by fabd_yrper fabd_peramt.
            if l_peramt <> 0
            then do:
               for first tt_fabd
                  where tt_domain  = global_domain
                  and   tt_yrper   = fabd_yrper
                  and   tt_fabk_id = fabd_fabk_id
               exclusive-lock:
               end. /* FOR FIRST tt_fabd */
               if not available tt_fabd
               then do:
                  create tt_fabd.
                  assign
                     tt_domain  = global_domain
                     tt_yrper   = fabd_yrper
                     tt_fabk_id = fabd_fabk_id.
               end. /* IF NOT AVAILABLE tt_fabd */
            end. /* IF l_peramt <> 0 */
         end. /* IF LAST-OF (fabd_yrper) */
      end. /* FOR EACH fabd_det */

      /* ADJUST THE ACCUMULATED DEPRECIATION. */
      for each tt_fabd
      no-lock
      break by tt_fabk_id
            by tt_yrper desc:

         if first-of (tt_fabk_id)
         then do:
            /* GET THE BASIS AMOUNT */
            run ip-get-basis
                (input l-asset,
                 input l-new-asset,
                 input tt_fabk_id,
                 input tt_yrper,
                 output l_basis).
         end. /* IF FIRST-OF (tt_fabk_id) */

         for each fabd_det
            fields (fabd_domain fabd_fa_id  fabd_fabk_id fabd_yrper
                    fabd_post   fabd_peramt fabd_accamt)
            where fabd_domain  = global_domain
            and   fabd_fa_id   = l-new-asset
            and   fabd_fabk_id = tt_fabk_id
            and   fabd_yrper   = tt_yrper
         no-lock
         break by fabd_yrper:
            accumulate fabd_accamt (total by fabd_yrper).
            accumulate fabd_peramt (total by fabd_yrper).

            if last-of(fabd_yrper)
            then
               assign
                  l_accamt = accum total by fabd_yrper fabd_accamt
                  l_peramt = accum total by fabd_yrper fabd_peramt.
         end. /* FOR EACH fabd_det ... */

         /* ADJUST THE DIFFERENTIAL AMOUNT FOR ACCUMLATED    */
         /* DEPRECIATION IN THE LAST RESERVE FOR THE PERIOD. */
         for last fabd_det
            where fabd_domain  = global_domain
            and   fabd_fa_id   = l-new-asset
            and   fabd_fabk_id = tt_fabk_id
            and   fabd_yrper   = tt_yrper
         exclusive-lock:
         end. /* FOR LAST fabd_det */
         if available fabd_det
         then
            assign
               fabd_accamt = fabd_accamt + (l_basis - l_accamt)
               l_basis     = l_basis - l_peramt.
      end. /* FOR EACH tt_fabd */

      for each tt_fabd
      no-lock
      break by tt_fabk_id
            by tt_yrper:
         if first-of (tt_fabk_id)
         then do:
            /* GET THE LAST PERIOD WHERE THE ASSET */
            /* HAS BEEN POSTED.                    */
            assign
               l_yrper = ?
               l_accper = 0.
            for last fabd_det
               fields (fabd_domain fabd_fa_id  fabd_fabk_id fabd_yrper
                       fabd_post   fabd_peramt fabd_accamt)
               where fabd_domain  = global_domain
               and   fabd_fa_id   = l-new-asset
               and   fabd_fabk_id = tt_fabk_id
               and   fabd_post
            no-lock:
            end. /* FOR LAST fabd_det */
            if available fabd_det
            then
               l_yrper = fabd_yrper.

            for each fabd_det
               fields (fabd_domain fabd_fa_id  fabd_fabk_id fabd_yrper
                       fabd_post   fabd_peramt fabd_accamt)
               where fabd_domain   = global_domain
               and   fabd_fa_id    = l-new-asset
               and   fabd_fabk_id  = tt_fabk_id
               and   fabd_yrper    = l_yrper
            no-lock
            break by fabd_yrper:
               accumulate fabd_accamt (total by fabd_yrper).
               if last-of (fabd_yrper)
               then
                  l_accper = accum total by fabd_yrper fabd_accamt.
            end. /* FOR EACH fabd_det */
         end. /* IF FIRST-OF (tt_fabk_id) */

         for each fabd_det
            fields (fabd_domain fabd_fa_id  fabd_fabk_id fabd_yrper
                    fabd_post   fabd_peramt fabd_accamt)
            where fabd_domain  = global_domain
            and   fabd_fa_id   = l-new-asset
            and   fabd_fabk_id = tt_fabk_id
            and   fabd_yrper   = tt_yrper
         no-lock
         break by fabd_yrper:
            accumulate fabd_accamt (total by fabd_yrper).
            accumulate fabd_peramt (total by fabd_yrper).

            if last-of(fabd_yrper)
            then
               assign
                  l_accamt = accum total by fabd_yrper fabd_accamt
                  l_peramt = accum total by fabd_yrper fabd_peramt.
         end. /* FOR EACH fabd_det ... */

         for last fabd_det
            where fabd_domain  = global_domain
            and   fabd_fa_id   = l-new-asset
            and   fabd_fabk_id = tt_fabk_id
            and   fabd_yrper   = tt_yrper
         exclusive-lock:
         end. /* FOR LAST fabd_det */
         if available fabd_det
         then
            assign
               fabd_accamt = fabd_accamt + (l_accper + l_peramt - l_accamt)
               l_accper    = l_accper + l_peramt.

         /* ADJUST THE ROUNDING DIFFERENCE IN THE LAST */
         /* RESERVE OF THE LAST PERIOD FOR THE BOOK.   */
         if last-of(tt_fabk_id)
         then do:
            /* GET THE BASIS AMOUNT */
            run ip-get-basis
                (input l-asset,
                 input l-new-asset,
                 input tt_fabk_id,
                 input tt_yrper,
                 output l_basis).

            for last fabd_det
               where fabd_domain  = global_domain
               and   fabd_fa_id   = l-new-asset
               and   fabd_fabk_id = tt_fabk_id
               and   fabd_yrper   = tt_yrper
            exclusive-lock:
            end. /* FOR LAST fabd_det */
            if available fabd_det
            then
               assign
                  fabd_peramt = fabd_peramt + (l_basis - l_accper)
                  fabd_accamt = fabd_accamt + (l_basis - l_accper).
         end. /* IF LAST-OF(fabd_fabk_id) */
      end. /* FOR EACH tt_fabd */

      /* ADJUST THE ACCUMULATED DEPRECIATION */
      /* TO REFLECT THE CORRECT VALUE.       */
      for each fabd_det
         where fabd_domain = global_domain
         and   fabd_fa_id  = l-new-asset
      exclusive-lock
      break by fabd_fabk_id
            by fabd_yrper:
         if first-of(fabd_fabk_id)
         then do:
            assign
               l_accamt = 0
               l_peramt = 0
               l_accper = 0.
         end. /* IF FIRST-OF (fabd_fabk_id) */

         accumulate fabd_peramt (total by fabd_yrper).
         accumulate fabd_accamt (total by fabd_yrper).

         if last-of (fabd_yrper)
         then do:
            assign
               l_peramt    = accum total by fabd_yrper fabd_peramt
               l_accamt    = accum total by fabd_yrper fabd_accamt.
            assign
               fabd_accamt = fabd_accamt + (l_accper + l_peramt) - l_accamt
               l_accper    = l_accper + l_peramt.
         end. /* IF LAST-OF (fabd_yrper) */
      end. /* FOR EACH fabd_det */
   end. /* ELSE DO */

   /* Adjust Asset Adjustment Records */
   for each faadjmstr
      exclusive-lock
       where faadjmstr.faadj_domain = global_domain and  faadj_fa_id = l-asset:

      create faadj_mstr. faadj_mstr.faadj_domain = global_domain.
      buffer-copy faadjmstr
         except oid_faadj_mstr
            faadj_fa_id
         to faadj_mstr
         assign
            faadj_mstr.faadj_fa_id = l-new-asset
            faadj_mstr.faadj_amt   = l-% * faadjmstr.faadj_amt.
      faadj_mstr.faadj_domain = global_domain.

         {gprunp.i "mcpl" "p" "mc-curr-rnd"
            "(input-output faadj_mstr.faadj_amt,
              input gl_rnd_mthd,
              output mc-error-number)"}

            faadjmstr.faadj_amt = faadjmstr.faadj_amt
                                - faadj_mstr.faadj_amt.
   end.  /* FOR EACH faadjmstr */

   /* CREATE ADJUSTMENT TO ORIGINAL ASSET DEPRECIATION */
   {gprun.i ""fafablb.p""
      "(input l-asset,
        input l-new-asset)"}

   /* Adjust Asset Detail Records */
   if l-qty = 1
   then do:
      for each faddet
         exclusive-lock
          where faddet.fad_domain = global_domain and  fad_fa_id = l-asset:

         create fad_det. fad_det.fad_domain = global_domain.
         buffer-copy faddet
            except oid_fad_det
               fad_fa_id
               fad_tag
            to fad_det
            assign
               fad_det.fad_fa_id  = l-new-asset
               fad_det.fad_tag    = fad_det.fad_fa_id
                                    + "-"
                                    + string(1)
               fad_det.fad_puramt = if l-amt <> 0
                                    then l-amt
                                    else l-% * faddet.fad_puramt.
         fad_det.fad_domain = global_domain.
            {gprunp.i "mcpl" "p" "mc-curr-rnd"
               "(input-output fad_det.fad_puramt,
                 input gl_rnd_mthd,
                 output mc-error-number)"}

            assign
               faddet.fad_puramt = faddet.fad_puramt
                                 - fad_det.fad_puramt.
      end.  /* FOR EACH faddet */
   end.  /* IF l-qty = 1 */
   else do:
      /* ONLY COPY OVER TAGS WHICH WERE SELECTED */
      for each faddet
         exclusive-lock
          where faddet.fad_domain = global_domain and  fad_fa_id = l-asset and
         can-find(first temp-select
                  where temp-select.sel_tag = faddet.fad_tag
                  and   temp-select.sel_idr <> ""):

         create fad_det. fad_det.fad_domain = global_domain.
         buffer-copy faddet
            except oid_fad_det
               fad_fa_id
               fad_tag
            to fad_det
            assign
               fad_det.fad_fa_id = l-new-asset.
         fad_det.fad_domain = global_domain.
            temp-tag = faddet.fad_tag.
            delete faddet.
            fad_det.fad_tag = temp-tag.
      end.  /* FOR EACH fabdet */
      /* ADJUST FA_PURAMT AND QUANTITY BASED ON */
      /* COMPONENTS REMAINING IN OLD ASSET      */
      assign
         temp-fa-qty = 0
         temp-fa-amt = 0.
      for each faddet
         no-lock
          where faddet.fad_domain = global_domain and  faddet.fad_fa_id =
          l-asset:
            assign
               temp-fa-qty = temp-fa-qty + 1
               temp-fa-amt = temp-fa-amt + faddet.fad_puramt.
      end. /* FOR FIRST faddet */
      for first fa_mstr
          where fa_mstr.fa_domain = global_domain and  fa_mstr.fa_id = l-asset
         exclusive-lock:
         assign
            fa_mstr.fa_qty    = temp-fa-qty
            fa_mstr.fa_puramt = temp-fa-amt.
      end. /* FOR FIRST fa_mstr */
      /* ADJUST FA_PURAMT AND QUANTITY BASED ON */
      /* COMPONENTS CREATED FOR NEW ASSET       */
      assign
         temp-fa-qty = 0
         temp-fa-amt = 0.
      for each fad_det
         no-lock
          where fad_det.fad_domain = global_domain and  fad_det.fad_fa_id =
          l-new-asset:
         assign
            temp-fa-qty = temp-fa-qty + 1
            temp-fa-amt = temp-fa-amt + fad_det.fad_puramt.
      end. /* FOR EACH fad_det */
      for first fa_mstr
          where fa_mstr.fa_domain = global_domain and  fa_mstr.fa_id =
          l-new-asset
         exclusive-lock:
         assign
            fa_mstr.fa_qty    = temp-fa-qty
            fa_mstr.fa_puramt = temp-fa-amt.
      end. /* FOR FIRST fa_mstr */
   end.  /* IF qty > 1 */

   /* Copy Asset Account Detail Records */
   for each fabadet
      exclusive-lock
      where fabadet.faba_domain = global_domain
      and   fabadet.faba_fa_id  = l-asset
      and   fabadet.faba_glseq  = l-old-seq:

      /* OLD ASSET ACCOUNTS */
      create faba_det. faba_det.faba_domain = global_domain.
      buffer-copy fabadet
         except
            oid_faba_det
            faba_fa_id
            faba_glseq
         to faba_det
         assign
            faba_det.faba_fa_id  = l-new-asset.

      /* NEW ASSET ACCOUNTS */
      create faba_det. faba_det.faba_domain = global_domain.
      buffer-copy fabadet
         except oid_faba_det
            faba_fa_id
/* SS - 100521.1 - B 
            faba_sub
   SS - 100521.1 - E */
            faba_cc
            faba_glseq
         to faba_det
         assign
/* SS - 100521.1 - B 
            faba_det.faba_sub   = if l-partrf
                                  then l-new-sub
                                  else fabadet.faba_sub
   SS - 100521.1 - E */
            faba_det.faba_cc    = if l-partrf
                                  then l-new-cc
                                  else fabadet.faba_cc
            faba_det.faba_fa_id = l-new-asset
            faba_det.faba_glseq = 1.
   end.  /* FOR EACH  */

   /* Create comments for old asset */
   create cmt_det. cmt_det.cmt_domain = global_domain.
   {mfrnseq.i cmt_det cmt_det.cmt_indx cmt_sq01}
   fa_mstr.fa_cmtindx = cmt_det.cmt_indx.
   find last cmtdet
    where cmtdet.cmt_domain = global_domain and  cmtdet.cmt_indx =
    famstr.fa_cmtindx
   exclusive-lock no-error.
   if available cmtdet
   then do:
      l-last-seq = cmtdet.cmt_seq.
      buffer-copy cmtdet
         except oid_cmt_det
            cmt_cmmt
            cmt_indx
            cmt_seq
            cmt_ref
            cmt_type
            cmt_lang
        to cmt_det.
      cmt_det.cmt_domain = global_domain.
   end. /* IF AVAIABLE cmtdet */
   else
      l-last-seq = - 1.

   /* NEW LAYERED ASSET CREATED FROM ASSET ID */
   {pxmsg.i &MSGNUM=3747 &MSGBUFFER=l_msgdesc[4]
            &MSGARG1=famstr.fa_id
            &MSGARG2=string(today)}

   assign
      cmt_det.cmt_seq     = l-last-seq + 1
      cmt_det.cmt_indx    = fa_mstr.fa_cmtindx
      cmt_det.cmt_ref     = global_ref
      cmt_det.cmt_lang    = global_lang
      cmt_det.cmt_type    = global_type
      cmt_det.cmt_cmmt[1] = l_msgdesc[4]
      cmt_det.cmt_cmmt[2] = l_msgdesc[1]
                            + string(l-puramt,"->>>,>>>,>>9.99")
                            + "."
      cmt_det.cmt_cmmt[3] = l_msgdesc[2]
                            + string(fa_mstr.fa_puramt,"->>>,>>>,>>9.99")
                            + "."
      l-last-seq          = cmt_det.cmt_seq.

   /* COPY COMMENTS FROM OLD ASSET TO NEW ASSET */
   for each cmtdet
      exclusive-lock
       where cmtdet.cmt_domain = global_domain and  cmtdet.cmt_indx =
       famstr.fa_cmtindx:
      create cmt_det. cmt_det.cmt_domain = global_domain.
      buffer-copy cmtdet
         except oid_cmt_det
            cmt_indx
            cmt_seq
         to cmt_det
         assign
            cmt_det.cmt_indx = fa_mstr.fa_cmtindx
            cmt_det.cmt_seq  = l-last-seq + 1
            l-last-seq       = l-last-seq + 1.
      cmt_det.cmt_domain = global_domain.
   end. /* FOR EACH cmtdet */

   /* CREATE COMMENTS FOR OLD ASSET */
   if famstr.fa_cmtindx = 0
   then do:

      /* NEW LAYERED ASSET # CREATED ON */
      {pxmsg.i &MSGNUM=3748 &MSGBUFFER=l_msgdesc[5]
               &MSGARG1=fa_mstr.fa_id
               &MSGARG2=string(today)}

      create cmt_det. cmt_det.cmt_domain = global_domain.
      {mfrnseq.i cmt_det cmt_det.cmt_indx cmt_sq01}

      assign
         famstr.fa_cmtindx   = cmt_det.cmt_indx
         cmt_det.cmt_lang    = global_lang
         cmt_det.cmt_type    = global_type
         cmt_det.cmt_ref     = global_ref
         cmt_det.cmt_seq     = 0
         cmt_det.cmt_cmmt[1] = l_msgdesc[5]
         cmt_det.cmt_cmmt[2] = l_msgdesc[3]
                               + string(l-puramt,"->>>,>>>,>>9.99")
                               + "."
         cmt_det.cmt_cmmt[3] = l_msgdesc[2]
                               + string(famstr.fa_puramt,"->>>,>>>,>>9.99")
                               + ".".
   end. /* IF famstr.fa_cmtindx */

   else do:

      /* NEW LAYERED ASSET # CREATED ON */
      {pxmsg.i &MSGNUM=3748 &MSGBUFFER=l_msgdesc[5]
               &MSGARG1=fa_mstr.fa_id
               &MSGARG2=string(today)}

      create cmt_det. cmt_det.cmt_domain = global_domain.
      find last cmtdet
       where cmtdet.cmt_domain = global_domain and  cmtdet.cmt_indx =
       famstr.fa_cmtindx
      exclusive-lock
      no-error.
      buffer-copy cmtdet
         except oid_cmt_det
            cmt_cmmt
         to cmt_det
         assign
         cmt_det.cmt_seq = cmtdet.cmt_seq + 1
         cmt_det.cmt_cmmt[1] = l_msgdesc[5]
         cmt_det.cmt_cmmt[2] = l_msgdesc[3]
                               + string(l-puramt,"->>>,>>>,>>9.99")
                               + "."
         cmt_det.cmt_cmmt[3] = l_msgdesc[2]
                               + string(famstr.fa_puramt,"->>>,>>>,>>9.99")
                               + ".".
      cmt_det.cmt_domain = global_domain.
   end. /* ELSE DO */

   /* DELETE TEMP TABLE */
   empty temp-table tt_fabd no-error.

end.  /* TRANSACTION */

/*------------------------------------------------------------------*/
PROCEDURE ip-get-basis:
/*------------------------------------------------------------------*/
/* Purpose: This procedure gets the Basis Amount for a given asset  */
/*          for a given book.                                       */
/*------------------------------------------------------------------*/
   define input  parameter ip_old_asset    like fabd_fa_id   no-undo.
   define input  parameter ip_new_asset    like fabd_fa_id   no-undo.
   define input  parameter ip_fabk_id      like fabd_fabk_id no-undo.
   define input  parameter ip_yrper        like fabd_yrper   no-undo.
   define output parameter ip_basis        like fabd_accamt  no-undo.

   define variable l_db                    like mfc_logical  no-undo.

   /* CHECK WHETHER THE METHOD HAS BEEN */
   /* ADJUSTED TO DECLINING BALANCE.    */
   l_db = no.

   for last faadj_mstr
      fields (faadj_domain faadj_fa_id faadj_fabk_id faadj_type faadj_famt_id)
      where faadj_domain  = global_domain
      and   faadj_fa_id   = ip_old_asset
      and   faadj_fabk_id = ip_fabk_id
      and   faadj_type    = "3"
   no-lock:
   end. /* FOR FIRST faadj_mstr */
   if available faadj_mstr
   then do:
      for first famt_mstr
         fields (famt_domain famt_id famt_switchsl famt_type)
         where famt_domain = global_domain
         and   famt_id     = faadj_famt_id
         and   famt_type   = "3"
      no-lock:
      end. /* FOR FIRST famt_mstr */
      if available famt_mstr
         and not famt_switchsl
      then
         l_db = yes.
   end. /* IF AVAILABLE faadj_mstr */

   /* FIND THE BASIS AMOUNT IF THE METHOD IS NOT  */
   /* DECLINING BALANCE OR UNITS OF PRODUCTION OR */
   /* THE METHOD HAS NOT BEEN ADJUSTED TO DB.     */

   /* FIND THE TOTAL BASIS FOR THE ASSET BOOK */
   {gprunp.i "fapl" "p" "fa-get-basis"
             "(input  ip_new_asset,
               input  ip_fabk_id,
               output ip_basis)"}

   if can-find(first famt_mstr
                  where famt_domain = global_domain
                  and   famt_id     = fab_det.fab_famt_id
                  and   famt_type   = "2")
   or can-find(first famt_mstr
                  where famt_domain = global_domain
                  and   famt_id     = fab_det.fab_famt_id
                  and   famt_type   = "3")
   or l_db
   then do:
      for first famt_mstr
         fields (famt_domain famt_id famt_switchsl famt_type)
         where famt_domain = global_domain
         and   famt_id     = fab_det.fab_famt_id
         and   famt_type   = "3"
      no-lock:
      end. /* FOR FIRST famt_mstr */
      if (available famt_mstr
         and not famt_switchsl)
         or  not available famt_mstr
      then do:
         for each fabd_det
            fields (fabd_domain fabd_fa_id   fabd_fabk_id fabd_yrper
                    fabd_post   fabd_peramt  fabd_accamt)
            where fabd_domain   = global_domain
            and   fabd_fa_id    = ip_new_asset
            and   fabd_fabk_id  = ip_fabk_id
            and   fabd_yrper    = ip_yrper
         no-lock
         break by fabd_yrper:
            accumulate fabd_accamt (total by fabd_yrper).
            if last(fabd_yrper)
               and ip_basis >= (accum total by fabd_yrper fabd_accamt)
            then
               ip_basis = accum total by fabd_yrper fabd_accamt.
         end. /* FOR EACH fabd_det */
      end. /* IF (AVAILABLE famt_mstr AND NOT famt_switchsl) OR .. */
   end. /* ELSE DO */

END PROCEDURE. /* ip-get-basis */

/* -----------------------------------------------------------*/
PROCEDURE create-fabd-det:
   /* THIS PROCEDURE CREATES A SINGLE DEPRECIATION DETAIL   */
   /* RECORD SO THAT POST TO GL WILL PICK UP THE TRANSFER.  */
   /* THIS RECORD ONLY NEEDS TO BE CREATED IF THE ASSET HAS */
   /* NO OTHER DEPRECIATION DETAIL RECORDS FOR THE TRANSFER */
   /* PERIOD.                                               */

   define input parameter fabkid like fabk_id no-undo.

   /* FIND THE LAST DEPRECIATION DETAIL RECORD FOR THE ASSET */
   for last fabddet no-lock
      where fabd_domain  = global_domain
      and   fabd_fa_id   = famstr.fa_id
      and   fabd_fabk_id = fabkid
      use-index fabd_fa_id:
   end. /* FOR LAST fabddet */

   /* COPY THE LAST DEPRECIATION DETAIL RECORD TO A NEW ONE */
   if available fabddet
   then do:

      create fabd_det.
      fabd_det.fabd_domain = global_domain.

      /* GET NEXT SEQUENCE NUMBER */
      {mfnxtsq1.i  "fabd_det.fabd_domain = global_domain and "
                    fabd_det fabd_seq fabd_sq01 l-seq}

      buffer-copy
         fabddet
         except
            oid_fabd_det
            fabd_fa_id
            fabd_seq
            fabd_yrper
            fabd_post
            fabd_transfer
            fabd_retire
            fabd_adj_yrper
            fabd_mod_userid
            fabd_mod_date
            fabd_peramt
            fabd_accamt
            fabd_upper
            fabd_accup
            to fabd_det.

      /* ASSIGN THE TRANSFER VALUES TO THE NEW RECORD */
      assign
         fabd_det.fabd_fa_id      = fa_mstr.fa_id
         fabd_det.fabd_seq        = l-seq
         fabd_det.fabd_yrper      = l-period
         fabd_det.fabd_post       = no
         fabd_det.fabd_transfer   = yes
         fabd_det.fabd_retire     = no
         fabd_det.fabd_adj_yrper  = l-period
         fabd_det.fabd_mod_userid = global_userid
         fabd_det.fabd_mod_date   = today
         fabd_det.fabd_trn_loc    = famstr.fa_faloc_id
         fabd_det.fabd_trn_entity = famstr.fa_entity
         fabd_det.fabd_trn_glseq  = l-old-seq
         fabd_det.fabd_entity     = faloc_mstr.faloc_entity
         fabd_det.fabd_faloc_id   = l-new-loc.

   end.  /* IF AVAILABLE fabddet */
END PROCEDURE.  /* create-fabd-det */
