/* gpicgl.p -- CREATE GLT-DET RECORDS FOR INVENTORY TRANSACTIONS             */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                       */
/* All rights reserved worldwide.  This is an unpublished work.              */
/* $Revision: 1.31 $                                                        */
/*V8:ConvertMode=Maintenance                                                 */

/* REVISION: 7.0      LAST MODIFIED: 06/08/92   BY: pma *F564*               */
/* REVISION: 7.0      LAST MODIFIED: 06/25/92   BY: pma *F686*               */
/* REVISION: 7.0      LAST MODIFIED: 07/21/92   BY: pma *F785*               */
/* REVISION: 7.0      LAST MODIFIED: 09/25/92   BY: pma *G093*               */
/* Revision: 7.3          Last edit: 09/27/93   By: jcd *G247*               */
/* REVISION: 7.0      LAST MODIFIED: 09/02/93   BY: qzl *GE73*               */
/* REVISION: 7.3      LAST MODIFIED: 10/26/93   BY: ais *GG70*               */
/* REVISION: 7.3      LAST MODIFIED: 09/11/94   BY: rmh *GM09*               */
/* REVISION: 7.3      LAST MODIFIED: 09/22/94   BY: rmh *FR70*               */
/* REVISION: 7.3      LAST MODIFIED: 10/05/94   BY: pxd *FR90*               */
/* REVISION: 7.3      LAST MODIFIED: 03/29/95   BY: emb *G1ML*               */
/* REVISION: 8.5      LAST MODIFIED: 06/20/95   BY: taf *J053*               */
/* REVISION: 7.3      LAST MODIFIED: 04/24/96   BY: rvw *G1RT*               */
/* REVISION: 8.6      LAST MODIFIED: 06/27/96   BY: bjl *K001*               */
/* REVISION: 8.6      LAST MODIFIED: 11/19/96   BY: *H0PF* Suresh Nayak      */
/*                                   12/04/96   BY: EJH *K013*               */
/*                                   02/17/97   BY: *K01R* E. Hughart        */
/* REVISION: 8.6E     LAST MODIFIED: 05/09/98   BY: *L00Y* Jeff Wootton      */
/* REVISION: 8.6E     LAST MODIFIED: 06/15/98   BY: *J2P3* Dana Tunstall     */
/* Old ECO marker removed, but no ECO header exists *F0PN*                   */
/* REVISION: 8.6E     LAST MODIFIED: 07/15/98   BY: *L024* Steve Goeke       */
/* REVISION: 9.0      LAST MODIFIED: 11/30/98   BY: *M00P* Jeff Wootton      */
/* REVISION: 9.0      LAST MODIFIED: 03/13/99   BY: *M0BD* Alfred Tan        */
/* REVISION: 9.0      LAST MODIFIED: 05/06/99   BY: *J3FB* Kedar Deherkar    */
/* REVISION: 9.1      LAST MODIFIED: 06/29/99   BY: *N00D* Adam Harris       */
/* REVISION: 9.1      LAST MODIFIED: 08/13/99   BY: *N01L* Adam Harris       */
/* REVISION: 9.1      LAST MODIFIED: 10/01/99   BY: *N014* Murali Ayyagari   */
/* REVISION: 9.1      LAST MODIFIED: 10/06/99   BY: *N040* Robin McCarthy    */
/* REVISION: 9.1      LAST MODIFIED: 08/14/00   BY: *N0L1* Mark Brown        */
/* REVISION: 9.1      LAST MODIFIED: 09/29/00   BY: *N0VY* BalbeerS Rajput   */
/* Revision: 9.1      LAST MODIFIED: 01/30/01   BY: *N0W7* Jean Miller       */
/* $Revision: 1.31 $       BY: Manjusha Inglay       DATE: 07/29/02  ECO: *N1P4*  */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/
/*****************************************************************************/

{mfdeclre.i}
{cxcustom.i "GPICGL.P"}

{gldydef.i}
/* NRM vars */
{gldynrm.i}

define input parameter        amt        like glt_amt.
define input parameter        transtype  like tr_type.
define input parameter        nbr        like tr_nbr.
define input parameter        dracct     like glt_acct.
define input parameter        drsub      like glt_sub.
define input parameter        drcc       like glt_cc.
define input parameter        drproj     like glt_project.
define input parameter        cracct     like glt_acct.
define input parameter        crsub      like glt_sub.
define input parameter        crcc       like glt_cc.
define input parameter        crproj     like glt_project.
define input parameter        entity     like glt_entity.
define input parameter        eff_date   like glt_effdate.
define input parameter        glsum_yn   like icc_gl_sum.
define input parameter        glmir_yn   like icc_mirror.
define input-output parameter ref        like glt_ref.
define input parameter        trgl_recno as   recid.
define input parameter        tr_recno   as   recid.

define variable mracct1                  like ma_mr_acct1 no-undo.
define variable mrsub1                   like ma_mr_sub1  no-undo.
define variable mrcc1                    like ma_mr_cc1   no-undo.
define variable mracct2                  like ma_mr_acct2 no-undo.
define variable mrsub2                   like ma_mr_sub2  no-undo.
define variable mrcc2                    like ma_mr_cc2   no-undo.
define variable desc1                    like glt_desc    no-undo.
define variable docnbr                   like glt_doc     no-undo.
define variable cntr                     as   integer     no-undo.
define variable glttemp                  as   recid       no-undo.
define variable sum-lvl                  like apc_sum_lvl no-undo.

define buffer   trgldet                  for  trgl_det.
{&GPICGL-P-TAG1}

if glsum_yn = true
then
   sum-lvl = 2.
else
   sum-lvl = 1.

/* OBTAIN DEFAULT DAYBOOK IF IT EXISTS. */
{gprun.i ""gldydft.p""
   "(input ""IC"",
     input  transtype,
     input  entity,
     output dft-daybook,
     output daybook-desc)"}

find trgl_det
   where recid(trgl_det) = trgl_recno
   exclusive-lock no-error.
find tr_hist
   where recid(tr_hist)  = tr_recno
   no-lock no-error.
   desc1 = transtype + " " + nbr.
if available tr_hist
then
   docnbr = string(tr_trnbr).
else
   docnbr = "".

find first icc_ctrl
   no-lock no-error.

/*GET MIRROR ACCOUNTS IF ANY*/
assign
   mracct1 = ""
   mracct2 = ""
   mrsub1  = ""
   mrsub2  = ""
   mrcc1   = ""
   mrcc2   = "".

if glmir_yn
then do:
   find first ma_mstr
      where ma_entity  = entity
      and   ma_tr_type = "IC"
      and   ma_acct1   = dracct
      and   ma_acct2   = cracct
      and   ma_sub1    = drsub
      and   ma_sub2    = crsub
      and   ma_cc1     = drcc
      and   ma_cc2     = crcc
   no-lock no-error.

   if not available ma_mstr
   then
      find first ma_mstr
         where ma_entity  = entity
         and   ma_tr_type = "IC"
         and   ma_acct1   = dracct
         and   ma_acct2   = cracct
         and   ma_sub1    = ""
         and   ma_sub2    = ""
         and   ma_cc1     = ""
         and   ma_cc2     = ""
         and   ma_all_sub = yes
         and   ma_all_cc  = yes
         no-lock no-error.

      if not available ma_mstr
      then
         find first ma_mstr
            where ma_entity  = entity
            and   ma_tr_type = "IC"
            and   ma_acct1   = dracct
            and   ma_acct2   = cracct
            and   ma_sub1    = ""
            and   ma_sub2    = ""
            and   ma_cc1     = ""
            and   ma_cc2     = ""
            and   ma_all_sub = no
            and   ma_all_cc  = no
            no-lock no-error.

         if not available ma_mstr
         then
            find first ma_mstr
               where ma_entity  = entity
               and   ma_tr_type = "IC"
               and   ma_acct1   = dracct
               and   ma_acct2   = cracct
               and   ma_sub1    = drsub
               and   ma_sub2    = crsub
               and   ma_cc1     = ""
               and   ma_cc2     = ""
               and   ma_all_sub = no
               and   ma_all_cc  = no
               no-lock no-error.

            if not available ma_mstr
            then
               find first ma_mstr
                  where ma_entity  = entity
                  and   ma_tr_type = "IC"
                  and   ma_acct1   = dracct
                  and   ma_acct2   = cracct
                  and   ma_sub1    = ""
                  and   ma_sub2    = ""
                  and   ma_cc1     = drcc
                  and   ma_cc2     = crcc
                  and   ma_all_sub = no
                  and   ma_all_cc  = no
                  no-lock no-error.

               if not available ma_mstr
               then
                  find first ma_mstr
                     where ma_entity = entity
                     and ma_tr_type  = "IC"
                     and ma_acct1    = dracct
                     and ma_acct2    = cracct
                     and ma_sub1     = drsub
                     and ma_sub2     = crsub
                     and ma_cc1      = ""
                     and ma_cc2      = ""
                     and ma_all_sub  = no
                     and ma_all_cc   = yes
                     no-lock no-error.

                  if not available ma_mstr
                  then
                     find first ma_mstr
                        where ma_entity  = entity
                        and   ma_tr_type = "IC"
                        and   ma_acct1   = dracct
                        and   ma_acct2   = cracct
                        and   ma_sub1    = ""
                        and   ma_sub2    = ""
                        and   ma_cc1     = ""
                        and   ma_cc2     = ""
                        and   ma_all_sub = no
                        and   ma_all_cc  = yes
                        no-lock no-error.

                     if not available ma_mstr
                     then
                        find first ma_mstr
                           where ma_entity  = entity
                           and   ma_tr_type = "IC"
                           and   ma_acct1   = dracct
                           and   ma_acct2   = cracct
                           and   ma_sub1    = ""
                           and   ma_sub2    = ""
                           and   ma_cc1     = ""
                           and   ma_cc2     = ""
                           and   ma_all_sub = yes
                           and   ma_all_cc  = no
                           no-lock no-error.

                        if not available ma_mstr
                        then
                           find first ma_mstr
                              where ma_entity  = entity
                              and   ma_tr_type = "IC"
                              and   ma_acct1   = dracct
                              and   ma_acct2   = cracct
                              and   ma_sub1    = ""
                              and   ma_sub2    = ""
                              and   ma_cc1     = drcc
                              and   ma_cc2     = crcc
                              and   ma_all_sub = yes
                              and   ma_all_cc  = no
                              no-lock no-error.

   if available ma_mstr
   then do:
      assign
         mracct1 = ma_mr_acct1
         mracct2 = ma_mr_acct2
         mrsub1  = ma_mr_sub1
         mrsub2  = ma_mr_sub2.

      if ma_all_cc
      then do:
         assign
            mrcc1 = drcc
            mrcc2 = crcc.
      end. /* IF ma_all_cc */
      else do:
         assign
            mrcc1 = ma_mr_cc1
            mrcc2 = ma_mr_cc2.
      end. /* ELSE DO */

      if ma_all_sub
      then do:
         assign
            mrsub1 = drsub
            mrsub2 = crsub.
      end. /* IF ma_all_sub */
      else do:
         assign
            mrsub1 = ma_mr_sub1
            mrsub2 = ma_mr_sub2.
      end. /* ELSE DO */

   end. /* IF AVAILABLE ma_mstr */

   else do:
      glmir_yn = no.
   end. /* IF NOT AVAILABLE ma_mstr */
end. /* IF glmir_yn */

if ref = ""
            or substring(ref,1,8) <> "IC"
            + substring(string(year(eff_date),"9999"),3,2)
            + string(month(eff_date),"99")
            + string(day(eff_date),"99")
then
   ref = "IC"
            + substring(string(year(eff_date),"9999"),3,2)
            + string(month(eff_date),"99")
            + string(day(eff_date),"99").

if icc_jrnl = 10
   and glsum_yn = yes
then do:
   /* SUMMARIZE BY SESSION ID */
   {gprun.i ""gpicgl10.p"" "(input-output ref, output glttemp)"}
end. /* IF icc_jrnl = 10 AND ... */
/* STANDARD SUMMARY/DETAIL LOGIC */
else do:

   ref = "IC"
            + substring(string(year(eff_date),"9999"),3,2)
            + string(month(eff_date),"99")
            + string(day(eff_date),"99").

   find last glt_det
      where glt_ref >= ref
      and   glt_ref <= ref + fill(hi_char,14)
      no-lock no-error.
   find last gltr_hist
      where gltr_ref >= ref
      and   gltr_ref <= ref + fill(hi_char,14)
      no-lock no-error.

   ref = max(ref + string(1,"999999"),
         max(if available glt_det then glt_ref else "",
             if available gltr_hist then gltr_ref else "")).

   refloop:
   repeat transaction on error undo, retry:
      pause 0 no-message.
      hide message no-pause.

      if not glsum_yn or
         can-find(first gltr_hist where gltr_ref = ref) or
         (can-find(first glt_det where glt_ref     = ref
                                 and   glt_dy_code <> dft-daybook))
         then do while can-find(first gltr_hist where gltr_ref = ref)
            or (can-find(first glt_det where glt_ref     = ref
                                       and   glt_dy_code <> dft-daybook)):
         ref = substring(ref,1,8)
                  + string(integer(substring(ref,9)) + 1,"999999").
      end. /* IF NOT glsum_yn */

      find first glt_det
         where glt_ref   = ref
         and   glt_rflag = false
         no-lock no-error.
      if not available glt_det
         and not locked glt_det
      then do:
         create glt_det.
         assign
            glt_ref     = ref
            glt_rflag   = false
            glt_line    = 0
            glt_effdate = eff_date
            glt_dy_code = dft-daybook.
         glttemp = recid(glt_det).
         {&GPICGL-P-TAG2}
         release glt_det.
         if (not glsum_yn and
            can-find (first glt_det
                         where glt_ref = ref
                         and glt_line  <> 0
                         and glt_rflag = false))
         then
            undo refloop, retry refloop.
         leave refloop.
      end. /* IF NOT AVAILABLE glt_det */
      else
         if not glsum_yn
         then do:
            ref = substring(ref,1,8)
                     + string(integer(substring(ref,9)) + 1,"999999").
         end. /* IF NOT glsum_yn */
         else do:
            leave refloop.
         end. /* ELSE DO */
      end. /* REPEAT */

end. /* WHEN icc_jrnl <> 10 OR glsum_yn = no */

/*CREATE TRGL_DET RECORD FOR MIRROR POSTING*/
if available trgl_det
then
   do transaction:
      trgl_gl_ref = ref.
      if glmir_yn
      then do:
         create trgldet.
         assign
            trgldet.trgl_trnbr    = trgl_det.trgl_trnbr
            trgldet.trgl_gl_ref   = ref
            trgldet.trgl_type     = "MIRROR"
            trgldet.trgl_dr_acct  = ""
            trgldet.trgl_dr_sub   = ""
            trgldet.trgl_dr_cc    = ""
            trgldet.trgl_dr_proj  = drproj
            trgldet.trgl_cr_acct  = ""
            trgldet.trgl_cr_sub   = ""
            trgldet.trgl_cr_cc    = ""
            trgldet.trgl_cr_proj  = crproj
            trgldet.trgl_sequence = recid(trgldet)
            trgldet.trgl_gl_amt   = amt.
         recno = recid(trgldet).
      end. /* IF glmir_yn */
   end. /* DO TRANSACTION */

/*SOURCE DEBIT ACCOUNT*/
do transaction:

   gllinenum = 0.

   if glmir_yn
      then
         substring(desc1,25,5) = "SRC-1".
      else
         substring(desc1,25,5) = "     ".

   /* CHANGED not gl_sum TO sum-lvl FOR detail */
   /* DELETED PARAMETER h-nrm                  */
   {gprunp.i "gpglpl" "p" "gpgl-create-one-glt"
      "(input entity, /* entity for GL transaction */
        input entity, /* entity to compare to en_entity */
        input dracct, /* acct */
        input drsub,  /* sub-acct */
        input drcc,
        input drproj, /* project */
        input amt,
        input 0, /* curramt */
        input base_curr, /* currency for GL transaction */
        input base_curr, /* currency to compare to en_curr */
        input 1, /* exrate */
        input 1, /* exrate2 */
        input """", /* exratetype */
        input 0, /* exruseq */
        input ref,
        input eff_date,
        input """", /* match glt_desc */
        input desc1, /* desc */
        input """", /* mstr_desc */
        input """", /* gen_desc */
        input """", /* batch */
        input-output gllinenum,
        input ""IC"", /* module */
        input sum-lvl, /* detail */
        input false, /* audit */
        input """", /* addr */
        input docnbr,
        input ""IC"", /* doctype */
        input dft-daybook,
        input daybook-desc,
        input 2, /* variant = old gpgltdet.i */
        input daybooks-in-use,
        input-output nrm-seq-num
        )"}.

   if available trgl_det
   then
      assign
         trgl_det.trgl_dr_line = gllinenum
         trgl_det.trgl_dy_code = dft-daybook
         trgl_det.trgl_dy_num = nrm-seq-num.

end. /*SOURCE DEBIT*/

if glmir_yn
then do:
   /*MIRROR CREDIT ACCT*/
   do transaction:

      assign
         gllinenum             = 0
         substring(desc1,25,5) = "MIR-1".

      /* CHANGED not gl_sum TO sum-lvl FOR detail */
      /* DELETED PARAMETER h-nrm                  */
      {gprunp.i "gpglpl" "p" "gpgl-create-one-glt"
         "(input entity, /* entity for GL transaction */
           input entity, /* entity to compare to en_entity */
           input mracct1, /* acct */
           input mrsub1,  /* sub-acct */
           input mrcc1,
           input crproj, /* project */
           input - amt,
           input 0, /* curramt */
           input base_curr, /* currency for GL tranmsaction */
           input base_curr, /* currency to compare to en_curr */
           input 1, /* exrate */
           input 1, /* exrate2 */
           input """", /* exratetype */
           input 0, /* exruseq */
           input ref,
           input eff_date,
           input """", /* match glt_desc */
           input desc1, /* desc */
           input """", /* mstr_desc */
           input """", /* gen_desc */
           input """", /* batch */
           input-output gllinenum,
           input ""IC"", /* module */
           input sum-lvl, /* detail */
           input false, /* audit */
           input """", /* addr */
           input docnbr,
           input ""IC"", /* doctype */
           input dft-daybook,
           input daybook-desc,
           input 2, /* variant = old gpgltdet.i */
           input daybooks-in-use,
           input-output nrm-seq-num
           )"}.

      if available trgl_det
      then do:
         assign
            trgl_det.trgl_cr_acct = mracct1
            trgl_det.trgl_cr_sub  = mrsub1
            trgl_det.trgl_cr_cc   = mrcc1
            trgl_det.trgl_cr_line = gllinenum
            trgl_det.trgl_dy_code = dft-daybook
            trgl_det.trgl_dy_num  = nrm-seq-num.
      end. /* IF AVAILABLE trgl_det */
   end. /*MIRROR CREDIT ACCT*/

   /*MIRROR DEBIT ACCT*/
   do transaction:

      assign
         gllinenum             = 0
         substring(desc1,25,5) = "MIR-2".

      /* CHANGED not gl_sum TO sum-lvl FOR detail */
      /* DELETED PARAMETER h-nrm                  */
      {gprunp.i "gpglpl" "p" "gpgl-create-one-glt"
         "(input entity, /* entity for GL transaction */
           input entity, /* entity to compare to en_entity */
           input mracct2, /* acct */
           input mrsub2,  /* sub-acct */
           input mrcc2,
           input drproj, /* project */
           input amt,
           input 0, /* curramt */
           input base_curr, /* currency for GL transaction */
           input base_curr, /* currency to compare to en_curr */
           input 1, /* exrate */
           input 1, /* exrate2 */
           input """", /* exratetype */
           input 0, /* exruseq */
           input ref,
           input eff_date,
           input """", /* match glt_desc */
           input desc1, /* desc */
           input """", /* mstr_desc */
           input """", /* gen_desc */
           input """", /* batch */
           input-output gllinenum,
           input ""IC"", /* module */
           input sum-lvl, /* detail */
           input false, /* audit */
           input """", /* addr */
           input docnbr,
           input ""IC"", /* doctype */
           input dft-daybook,
           input daybook-desc,
           input 2, /* variant = old gpgltdet.i */
           input daybooks-in-use,
           input-output nrm-seq-num
           )"}.

      if available trgldet
      then do:
         assign
            trgldet.trgl_dr_acct = mracct2
            trgldet.trgl_dr_sub  = mrsub2
            trgldet.trgl_dr_cc   = mrcc2
            trgldet.trgl_dr_line = gllinenum
            trgldet.trgl_dy_code = dft-daybook
            trgldet.trgl_dy_num  = nrm-seq-num.
      end. /* IF AVAILABLE trgldet */
   end. /*MIRROR DEBIT ACCT*/
end. /*IF glmir_yn*/

/*SOURCE CREDIT ACCOUNT*/
do transaction:

   gllinenum = 0.

   if glmir_yn
   then
      substring(desc1,25,5) = "SRC-2".
   else
      substring(desc1,25,5) = "     ".

   /* CHANGED not gl_sum TO sum-lvl FOR detail */
   /* DELETED PARAMETER h-nrm                  */
   {gprunp.i "gpglpl" "p" "gpgl-create-one-glt"
      "(input entity, /* entity for GL transaction */
        input entity, /* entity to compare to en_entity */
        input cracct, /* acct */
        input crsub,  /* sub-acct */
        input crcc,
        input crproj, /* project */
        input - amt,
        input 0, /* curramt */
        input base_curr, /* currency for GL transaction */
        input base_curr, /* currency to compare to en_curr */
        input 1, /* exrate */
        input 1, /* exrate2 */
        input """", /* exratetype */
        input 0, /* exruseq */
        input ref,
        input eff_date,
        input """", /* match glt_desc */
        input desc1, /* desc */
        input """", /* mstr_desc */
        input """", /* gen_desc */
        input """", /* batch */
        input-output gllinenum,
        input ""IC"", /* module */
        input sum-lvl, /* detail */
        input false, /* audit */
        input """", /* addr */
        input docnbr,
        input ""IC"", /* doctype */
        input dft-daybook,
        input daybook-desc,
        input 2, /* variant = old gpgltdet.i */
        input daybooks-in-use,
        input-output nrm-seq-num
        )"}.

   if glmir_yn
      and available trgldet
   then do:
      assign
         trgldet.trgl_cr_acct = cracct
         trgldet.trgl_cr_sub  = crsub
         trgldet.trgl_cr_cc   = crcc
         trgldet.trgl_cr_line = gllinenum
         trgldet.trgl_dy_code = dft-daybook
         trgldet.trgl_dy_num  = nrm-seq-num.
   end. /* IF glmir_yn */
   else
      if available trgl_det
      then do:
         assign
            trgl_det.trgl_cr_line = gllinenum
            trgl_det.trgl_dy_code = dft-daybook
            trgl_det.trgl_dy_num  = nrm-seq-num.
      end. /* IF AVAILABLE trgl_det */
end. /*SOURCE CREDIT ACCOUNT*/

if glttemp <> ?
then
   do transaction:

      for first glt_det
         where recid(glt_det) = glttemp
         exclusive-lock:
         /* DELETE EXISTING EXCHANGE RATE USAGE RECORDS, IF ANY */
         {gprunp.i "mcpl" "p" "mc-delete-ex-rate-usage"
            "(input glt_en_exru_seq)" }
         {gprunp.i "mcpl" "p" "mc-delete-ex-rate-usage"
            "(input glt_exru_seq)" }
         delete glt_det.
      end.  /* FOR FIRST glt_det */
   end. /* DO TRANSACTION */
