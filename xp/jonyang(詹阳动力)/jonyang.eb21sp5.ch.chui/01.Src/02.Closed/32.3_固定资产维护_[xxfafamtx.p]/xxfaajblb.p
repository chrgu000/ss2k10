/* faajblb.p - DEPRECIATION DETAIL ADJUSTMENT                              */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                     */
/* All rights reserved worldwide.  This is an unpublished work.            */
/* $Revision: 1.23.1.13 $                                                        */
/*V8:ConvertMode=NoConvert                                                 */
/* REVISION: 9.1     LAST MODIFIED: 08/26/99     BY: PJP *N021*            */
/* REVISION: 9.1     LAST MODIFIED: 08/14/00     BY: *N0KW* Jacolyn Neder  */
/* REVISION: 9.2     LAST MODIFIED: 03/13/02     BY: *M1NB* Alok Thacker   */
/* Revision: 1.23.1.7     BY: Manish Dani           DATE: 12/20/02  ECO: *M1YW*  */
/* Revision: 1.23.1.8  BY: Rajesh Lokre DATE: 04/03/03 ECO: *M1RX* */
/* Revision: 1.23.1.10  BY: Paul Donnelly (SB) DATE: 06/26/03 ECO: *Q00C* */
/* Revision: 1.23.1.12    BY: Dorota Hohol      DATE: 09/01/03 ECO: *P0YS* */
/* $Revision: 1.23.1.13 $ BY: Sandy Brown (OID) DATE: 12/06/03 ECO: *Q04L* */


/* SS - 100505.1  By: Roger Xiao */  /* v_backward 追溯调整or not */
/* SS - 110319.1  By: Roger Xiao */  /*追溯调整时可输入追溯至指定期间,调整原值时可调整残值*/
/*-Revision end---------------------------------------------------------------*/


/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

{mfdeclre.i}
{cxcustom.i "FAAJBLB.P"}
define parameter buffer fa_mstr for fa_mstr.
define parameter buffer fab-det for fab_det.
define parameter buffer faadj_mstr for faadj_mstr.
define input parameter  v_perfrom     like fabd_yrper no-undo.  /*追溯至期间*/
define input parameter  v_per_assign  as logical no-undo .      /*是否按v_perfrom*/
define input parameter  v_backward    as logical no-undo .      /*是否追溯*/
define input parameter  v_salv_amt    like fab_salvamt    no-undo.
define output parameter l-err-nbr as integer initial 0 no-undo.

define variable l-cost          like fab_det.fab_amt  no-undo.
define variable l-seq           like fabd_seq         no-undo.
define variable l-salvamt       like fab_salvamt      no-undo.
define variable l-delta-salvamt like fab_salvamt      no-undo.

define buffer b-fabd for fabd_det.

{gprunp.i "fapl" "p" "fa-get-cost"
   "(input  fab-det.fab_fa_id,
     input  fab-det.fab_fabk_id,
     output l-cost)"}

if faadj_type = "3"
then do:

   /* CALCULATE CHANGES TO SALVAGE VALUE */
   {gprunp.i "fapl" "p" "fa-get-salvage"
      "(input  fab-det.fab_fa_id,
        input  fab-det.fab_fabk_id,
        output l-salvamt)"}
   if can-find(first famt_mstr  where famt_mstr.famt_domain = global_domain and
      famt_id = faadj_famt_id and
      famt_salv = yes) then
      l-delta-salvamt = fa_salvamt - l-salvamt.
   else
      l-delta-salvamt = - l-salvamt.

end.  /* IF faadj_type = "3" */

/* 2 - BASIS ADJUSTMENT  */
/* 3 - METHOD ADJUSTMENT */
/* 4 - LIFE ADJUSTMENT   */
if faadj_type = "2"
or faadj_type = "3"
or faadj_type = "4"
{&FAAJBLB-P-TAG1}
then do:

   {gprunp.i "fapl" "p" "fa-get-salvage"
      "(input  fab-det.fab_fa_id,
        input  fab-det.fab_fabk_id,
        output l-salvamt)"}


   create fab_det. fab_det.fab_domain = global_domain.
   buffer-copy
      fab-det
      except oid_fab_det
      fab-det.fab_resrv
      fab-det.fab_amt
      fab-det.fab_salvamt
      fab-det.fab_famt_id
      fab-det.fab_life
      fab-det.fab_cst_adjper
      fab-det.fab_mod_userid
      fab-det.fab_mod_date
      to fab_det.
   fab_det.fab_domain = global_domain.
   {&FAAJBLB-P-TAG2}
   assign
      fab_det.fab_resrv      = faadj_resrv
      fab_det.fab_amt        = (if faadj_type = "2"
                                then
                                   faadj_amt - l-cost
                                else
                                   0)
      fab_det.fab_salvamt    = l-delta-salvamt
      /* SS - 100505.1 - B */
      /***fab_det.fab_salvamt        = (if faadj_type = "2"
                                then
                                   fab-det.fab_salvamt / fab-det.fab_amt * fab_det.fab_amt
                                else
                                   l-delta-salvamt) 
      暂不添加此自动按比例调整残值功能***/
      /* SS - 100505.1 - E */
      /* SS - 110319.1 - B */
      fab_det.fab_salvamt        = (if faadj_type = "2"
                                then
                                   (v_salv_amt - l-salvamt )
                                else
                                   l-delta-salvamt) 
      /* SS - 110319.1 - E */
      fab_det.fab_famt_id    = faadj_famt_id
      fab_det.fab_life       = faadj_life
      fab_det.fab_cst_adjper = (if faadj_type = "2"
                                then
                                   faadj_yrper
                                else
                                   "")
      fab_det.fab_mod_userid = global_userid
      fab_det.fab_mod_date   = today.
   {&FAAJBLB-P-TAG3}
   if recid(fab_det) = -1
   then .
end. /* IF faadj_type = "2"... */

CASE faadj_type:
   /* BONUS ADJUSTMENT */
   when ("1") then
   {gprun.i ""fabobl.p"" "(buffer fab-det,
        buffer faadj_mstr,
        output l-err-nbr)"}

   /* SUSPEND */
   when ("5") then
   for each b-fabd
       where b-fabd.fabd_domain = global_domain and  b-fabd.fabd_fa_id   =
       fab-det.fab_fa_id
      and   b-fabd.fabd_fabk_id = fab-det.fab_fabk_id
      and   b-fabd.fabd_yrper  >= faadj_yrper
      exclusive-lock:
      b-fabd.fabd_suspend = yes.
   end.  /* FOR EACH fabd_det */

   /* REINSTATE */
   when ("6") then
   {gprun.i ""faspbl.p"" "(buffer fab-det,
        buffer faadj_mstr,
        output l-err-nbr)"}

   /* BASIS, METHOD, AND LIFE ADJUSTMENT */
   otherwise
      do:
      {&FAAJBLB-P-TAG4}
      if  faadj_type = "2"
      {&FAAJBLB-P-TAG5}
      and can-find(first famt_mstr
                    where famt_mstr.famt_domain = global_domain and  famt_id =
                    fab_det.fab_famt_id
                   and   famt_type = "2")
      then do:
         {gprun.i ""faupblc.p"" "(buffer fab_det,
              input faadj_yrper,
              output l-err-nbr)"}
      end.  /* IF  faadj_type = "2"... */
      else
      /* ADDED 4TH AND 5TH PARAMETERS AS THE YEAR FOR ADJUSTMENT */
      /* AND DEPRECIATION CALCULATION FOR FOLLOWING YEARS IS     */
      /* NEEDED OR NOT RESPECTIVELY. THESE PARAMETERS WILL BE    */
      /* zero AND no RESPECTIVELY EXCEPT FOR UTILITY utrgendp.p  */
/* SS - 100505.1 - B 
      {gprun.i ""farcbl.p"" "(buffer fa_mstr,
           buffer fab_det,
           buffer faadj_mstr,
           input  0,
           input  no,
           output l-err-nbr)"}
   SS - 100505.1 - E */
/* SS - 110319.1 - B */
    if v_backward then do :  /*追溯*/
        if v_per_assign = no then do:  /*按过账期间追溯*/
              {gprun.i ""farcbl.p"" "(buffer fa_mstr,
                   buffer fab_det,
                   buffer faadj_mstr,
                   input  0,
                   input  no,
                   output l-err-nbr)"}
        end.
        else do:   /*按指定期间追溯*/
              {gprun.i ""xxfarcblxp.p"" "(buffer fa_mstr,
                   buffer fab_det,
                   buffer faadj_mstr,
                   input  0,
                   input  no,
                   input  v_perfrom ,
                   output l-err-nbr)"}    
        end.
    end.  /*追溯*/
    else do:  /*不追溯*/
          {gprun.i ""xxfarcbl.p"" "(buffer fa_mstr,
               buffer fab_det,
               buffer faadj_mstr,
               input  0,
               input  no,
               output l-err-nbr)"}
    end.  /*不追溯*/
/* SS - 110319.1 - E */
   end.  /* OTHERWISE */
END CASE.
