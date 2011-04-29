/* fatrbla.p Fixed Assets Transfer Business Logic                             */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.12.1.11 $                                                        */
/*V8:ConvertMode=Maintenance                                                  */
/* REVISION: 9.1     LAST MODIFIED: 10/26/99     BY: *N021* Pat Pigatti       */
/* REVISION: 9.1     LAST MODIFIED: 08/14/00     BY: *N0L0* Jacolyn Neder     */
/* REVISION: 9.2     LAST MODIFIED: 03/13/02     BY: *M1NB* Alok Thacker      */
/* Revision: 1.12.1.7      BY: Rajesh Lokre        DATE: 04/03/03 ECO: *M1RX* */
/* Revision: 1.12.1.9      BY: Paul Donnelly (SB)  DATE: 06/26/03 ECO: *Q00C* */
/* Revision: 1.12.1.10    BY: Shivanand H.        DATE: 11/14/03 ECO: *P19Q* */
/* $Revision: 1.12.1.11 $ BY: Sandy Brown (OID) DATE: 12/06/03 ECO: *Q04L* */
/*-Revision end---------------------------------------------------------------*/
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/*----rev history-------------------------------------------------------------------------------------*/
/* SS - 100521.1  By: Roger Xiao */  /*sub changed*/




{mfdeclre.i}

define input parameter  l-asset   like fa_id       no-undo.
define input parameter  l-old-loc like fa_faloc_id no-undo.
define input parameter  l-new-loc like fa_faloc_id no-undo.
define input parameter  l-new-sub like faloc_sub   no-undo.
define input parameter  l-new-cc  like faloc_cc    no-undo.
define input parameter  l-date    like fa_disp_dt  no-undo.
define output parameter l-err-nbr like msg_nbr     no-undo.

define variable l-seq     like fabd_seq    no-undo.
define variable l-old-seq like faba_glseq  no-undo.
define variable l-period  like fabd_yrper  no-undo.
define variable l-accamt  like fabd_accamt no-undo.

define buffer fabadet for faba_det.
define buffer fabddet for fabd_det.

for last faba_det
   fields( faba_domain faba_fa_id faba_glseq)
    where faba_det.faba_domain = global_domain and  faba_fa_id = l-asset
   no-lock
   use-index faba_fa_id:
   l-old-seq = faba_glseq.
end. /* FOR LAST faba_det */

for first faloc_mstr
   fields( faloc_domain faloc_id faloc_entity)
    where faloc_mstr.faloc_domain = global_domain and  faloc_id = l-new-loc
   no-lock:
end. /* FOR FIRST faloc_mstr */

for first fa_mstr
    where fa_mstr.fa_domain = global_domain and  fa_id = l-asset
   exclusive-lock:

   /* Create an fabd_det record for non-depreciating asset */
   if fa_dep = no
   then do:
      for first fabk_mstr
         fields( fabk_domain fabk_id fabk_calendar fabk_post)
          where fabk_mstr.fabk_domain = global_domain and  fabk_post = yes
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

      run create-fabd-det (fabk_id, fa_dep).
   end.  /* IF fa_dep = NO */

   if fa_dep = yes
   then do:
      for each fab_det
          where fab_det.fab_domain = global_domain and  fab_fa_id = fa_id
         exclusive-lock
         break by fab_fabk_id:

         if first-of(fab_fabk_id)
         then do:

            /* FIND THE CORRESPONDING PERIOD FOR THE TRANSFER DATE */
            for first fabk_mstr
               fields( fabk_domain fabk_id fabk_calendar fabk_post)
                where fabk_mstr.fabk_domain = global_domain and  fabk_id =
                fab_fabk_id
               no-lock:
            end. /* FOR FIRST fabk_mstr */

            if not available fabk_mstr
            then do:
               l-err-nbr = 4214.  /* INVALID BOOK CODE */
               return.
            end. /* IF NOT AVAILABLE fabk_mstr */
            else do:
               {gprunp.i "fapl" "p" "fa-get-per"
                  "(input  l-date,
                    input  fabk_calendar,
                    output l-period,
                    output l-err-nbr)"}

               if l-err-nbr > 0
               then
                  return.
            end. /* ELSE DO */

            /* UPDATE DEPRECIATION DETAIL */
            for last fabddet
               fields( fabd_domain fabddet.fabd_fa_id fabddet.fabd_fabk_id
               fabddet.fabd_resrv fabddet.fabd_yrper fabddet.fabd_accamt)
                where fabddet.fabd_domain = global_domain and
                fabddet.fabd_fa_id   = fab_fa_id
               and   fabddet.fabd_fabk_id = fab_fabk_id
               no-lock
               use-index fabd_fa_id:

               if l-period <= fabddet.fabd_yrper
               then do:
                  for each fabd_det
                      where fabd_det.fabd_domain = global_domain and
                      fabd_det.fabd_fa_id   = fa_id
                     and   fabd_det.fabd_fabk_id = fab_fabk_id
                     and   fabd_det.fabd_yrper  >= l-period
                     exclusive-lock
                     break by fabd_det.fabd_yrper:

                     /* UPDATE THE TRANSFER FLAG FOR */
                     /* ALL DEPRECIATION RECORDS FOR */
                     /* THE TRANSFER PERIOD.         */
                     if fabd_det.fabd_yrper        = l-period
                and fabd_det.fabd_transfer = no
                     then
                        assign
                           fabd_det.fabd_transfer   = yes
                           fabd_det.fabd_trn_loc    = l-old-loc
                           fabd_det.fabd_trn_entity = fa_mstr.fa_entity
                           fabd_det.fabd_trn_glseq  = l-old-seq.

                     /* UPDATE ALL OTHER DEPRECIATION      */
                     /* RECORDS WITH THE ENTITY, LOC, ETC. */
                     assign
                        fabd_det.fabd_entity     = faloc_entity
                        fabd_det.fabd_faloc_id   = l-new-loc
                        fabd_det.fabd_mod_userid = global_userid
                        fabd_det.fabd_mod_date   = today.

                  end.  /* for each fabd_det */
               end.  /* if l-period <= fabd_yrper */
               else do:
                  /* ASSET IS FULLY DEPRECIATED WHEN TRANSFERRED   */
                  /* SO CREATE AN fabd_det FOR THE TRANSFER PERIOD */
                  run create-fabd-det (input fab_det.fab_fabk_id, fa_dep).
               end. /* ELSE DO */

            end.  /* FOR LAST fabddet */
         end.  /* IF FIRST-OF(fab_det) */

         /* UPDATE BOOK FIELDS */
         assign
            fab_mod_userid = global_userid
            fab_mod_date   = today.
      end.  /* FOR EACH fab_det */
   end.  /* IF fa_dep = YES */

   /* UPDATE ASSET HEADER FIELDS */
   assign
      fa_faloc_id   = l-new-loc
      fa_entity     = faloc_entity
      fa_mod_userid = global_userid
      fa_mod_date   = today.

   /* CREATE NEW SET OF ACCOUNTS */
   for each fabadet
       where fabadet.faba_domain = global_domain and  fabadet.faba_glseq =
       l-old-seq
      and   fabadet.faba_fa_id = l-asset
      no-lock:

      create faba_det. faba_det.faba_domain = global_domain.
      buffer-copy fabadet
         except oid_faba_det faba_glseq
         to faba_det.
      faba_det.faba_domain = global_domain.
      assign
         faba_det.faba_glseq = l-old-seq + 1
/* SS - 100521.1 - B 
         faba_det.faba_sub = l-new-sub
         faba_det.faba_cc = l-new-cc
   SS - 100521.1 - E */
/* SS - 100521.1 - B */
         faba_det.faba_sub = fabadet.faba_sub
         faba_det.faba_cc  =  if fabadet.faba_acctype = "7" then fabadet.faba_cc else l-new-cc
/* SS - 100521.1 - E */
         faba_det.faba_mod_userid = global_userid
         faba_det.faba_mod_date = today.
   end.  /* for each fabadet */
end.  /* for first fa_mstr */

/* -----------------------------------------------------------*/
PROCEDURE create-fabd-det:
   /* THIS PROCEDURE CREATES A SINGLE DEPRECIATION DETAIL   */
   /* RECORD SO THAT POST TO GL WILL PICK UP THE TRANSFER.  */
   /* THIS RECORD ONLY NEEDS TO BE CREATED IF THE ASSET HAS */
   /* NO OTHER DEPRECIATION DETAIL RECORDS FOR THE TRANSFER */
   /* PERIOD.  THIS WILL HAPPEN IF THE ASSET IS EITHER      */
   /* RETIRED OR IF IT IS NON-DEPRECIATING.                 */

   /* THIS INPUT PARAMETER WILL BE BLANK IF THE ASSET IS */
   /* NON-DEPRECIATING.                                  */
   define input parameter fabkid like fabk_id no-undo.
   define input parameter fadep  like fa_dep  no-undo.

   define variable accamt like fabd_accamt no-undo.

   /* FIND THE LAST DEPRECIATION DETAIL RECORD FOR THE ASSET */
   for last fabddet
       where fabddet.fabd_domain = global_domain and  fabd_fa_id = fa_mstr.fa_id
      and   fabd_fabk_id = fabkid
      use-index fabd_fa_id:
   end. /* FOR LAST fabddet */

   /* COPY THE LAST DEPRECIATION DETAIL RECORD TO A NEW ONE */
   if available fabddet
   then do:
      {gprunp.i "fapl" "p" "fa-get-accdep"
         "(input  fabddet.fabd_fa_id,
           input  fabddet.fabd_fabk_id,
           input  fabddet.fabd_yrper,
           output l-accamt)"}

      create fabd_det. fabd_det.fabd_domain = global_domain.

      {mfnxtsq1.i  "fabd_det.fabd_domain = global_domain and " fabd_det
      fabd_seq fabd_sq01 l-seq}

      buffer-copy
         fabddet
         except oid_fabd_det
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
      fabd_det.fabd_domain = global_domain.

      /* ASSIGN THE TRANSFER VALUES TO THE NEW RECORD */
      assign
         fabd_det.fabd_seq        = l-seq
         fabd_det.fabd_yrper      = l-period
         fabd_det.fabd_post       = no
         fabd_det.fabd_transfer   = yes
         fabd_det.fabd_retire     = no
         fabd_det.fabd_upper      = 0
         fabd_det.fabd_peramt     = 0
         fabd_det.fabd_accamt     = l-accamt
         fabd_det.fabd_accup      = 0
         fabd_det.fabd_adj_yrper  = l-period
         fabd_det.fabd_mod_userid = global_userid
         fabd_det.fabd_mod_date   = today
         fabd_det.fabd_trn_loc    = l-old-loc
         fabd_det.fabd_trn_entity = fa_mstr.fa_entity
         fabd_det.fabd_trn_glseq  = l-old-seq
         fabd_det.fabd_entity     = faloc_mstr.faloc_entity
         fabd_det.fabd_faloc_id   = l-new-loc.

   end.  /* ELSE DO */
END PROCEDURE.  /* create-fabd-det */
