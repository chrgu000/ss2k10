/* ictrrp03.p - TRANSACTION ACCOUNTING REPORT                           */
/* Copyright 1986-2005 QAD Inc., Carpinteria, CA, USA.                  */
/* All rights reserved worldwide.  This is an unpublished work.         */
/* $Revision: 1.28 $                                                     */
/* REVISION: 1.0      LAST MODIFIED: 04/15/86   BY: PML */
/* REVISION: 4.0      LAST MODIFIED: 02/12/88   BY: FLM *A175*/
/* REVISION: 4.0      LAST MODIFIED: 11/30/88   BY: MLB *A544*/
/* REVISION: 5.0      LAST MODIFIED: 11/03/89   BY: MLB *B006*/
/* REVISION: 5.0      LAST MODIFIED: 01/16/90   BY: MLB *B508**/
/* REVISION: 6.0      LAST MODIFIED: 09/03/90   BY: pml *D064**/
/* REVISION: 7.0      LAST MODIFIED: 10/30/91   BY: pma *F003**/
/* REVISION: 7.0      LAST MODIFIED: 10/30/91   BY: pma *F268**/
/* REVISION: 7.0      LAST MODIFIED: 07/20/91   BY: pma *F781**/
/* Revision: 7.3      Last Modified: 08/03/92   By: mpp *G024**/
/* Revision: 7.3      Last Modified: 10/30/92   By: jcd *G256**/
/* Revision: 7.3      Last Modified: 03/19/93   By: pma *G848**/
/* Revision: 7.3      Last Modified: 09/15/93   By: pxd *GF20**/
/* Revision: 7.3      Last Modified: 09/11/94   By: rmh *GM10**/
/* Revision: 7.3      Last Modified: 09/18/94   By: qzl *FR49**/
/* Revision: 7.3      Last Modified: 06/05/95   By: qzl *G0QM**/
/* Revision: 7.3      Last Modified: 01/29/96   By: jym *G1LG**/
/* Revision: 8.6      Last Modified: 10/09/97   By: gyk *K0Q1* */
/* Revision: 8.6      Last Modified: 11/21/97   By: bvm *K1BF* */

/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane */
/* REVISION: 8.6E     LAST MODIFIED: 08/31/98   BY: *J2Y2* Poonam Bahl */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan   */
/* REVISION: 9.0      LAST MODIFIED: 03/10/99   BY: *M0B8* Hemanth Ebenezer */
/* REVISION: 9.0      LAST MODIFIED: 03/13/99   BY: *M0BD* Alfred Tan       */
/* REVISION: 9.1      LAST MODIFIED: 10/01/99   BY: *N014* Jeff Wootton     */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00 BY: *N08T* Annasaheb Rahane */
/* REVISION: 9.1      LAST MODIFIED: 08/13/00 BY: *N0KS* myb                */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* Revision: 1.16   BY: Hualin Zhong          DATE: 09/19/01  ECO: *N12H*  */
/* Revision: 1.17   BY: Patrick Rowan         DATE: 04/24/01  ECO: *P00G*  */
/* Revision: 1.18   BY: Rajiv Ramaiah         DATE: 04/16/01  ECO: *N1GM*  */
/* Revision: 1.19   BY: Chris Green   DATE: 11/29/01  ECO: *N16J*  */
/* Revision: 1.20  BY: Narathip W. DATE: 05/03/03 ECO: *P0R5* */
/* Revision: 1.22  BY: Paul Donnelly (SB) DATE: 06/28/03 ECO: *Q00G* */
/* Revision: 1.23  BY: Pawel Grzybowski   DATE: 08/20/03 ECO: *P109* */
/* Revision: 1.24  BY: Orawan S.          DATE: 10/08/03 ECO: *P13T* */
/* Revision: 1.26  BY: Preeti Sattur      DATE: 09/21/04 ECO: *P2L8* */
/* Revision: 1.27  BY: Shivganesh Hegde   DATE: 06/28/05 ECO: *P3QZ* */
/* $Revision: 1.28 $ BY: Narathip W.        DATE: 07/07/05 ECO: *P3S8* */
/* $Revision: 1.28 $ BY: Bill Jiang        DATE: 04/15/07 ECO: *SS - 20070415.1* */
/* $Revision: 1.28 $ BY: Bill Jiang        DATE: 04/23/08 ECO: *SS - 20080423.1* */

/*-Revision end---------------------------------------------------------------*/


/*V8:ConvertMode=Report                                 */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/* SS - 20070415.1 - B */
/*
{mfdtitle.i "1+ "}
*/
{ssmfdtitle.i "1+ "}

{ssictrrp0301.i}

define input parameter i_part like tr_part.
define input parameter i_part1 like tr_part.
/* SS - 20080424.1 - B */
define input parameter i_nbr like tr_nbr.
define input parameter i_nbr1 like tr_nbr.
define input parameter i_so_job like tr_so_job.
define input parameter i_so_job1 like tr_so_job.
define input parameter i_lot like tr_lot.
define input parameter i_lot1 like tr_lot.
define input parameter i_loc like tr_loc.
define input parameter i_loc1 like tr_loc.
/* SS - 20080424.1 - E */
define input parameter i_efdate like tr_effdate.
define input parameter i_efdate1 like tr_date.
define input parameter i_glref  like trgl_gl_ref.
define input parameter i_glref1 like trgl_gl_ref.
define input parameter i_entity like en_entity.
define input parameter i_entity1 like en_entity.
define input parameter i_acct like glt_acct.
define input parameter i_acct1 like glt_acct.
define input parameter i_sub like glt_sub.
define input parameter i_sub1 like glt_sub.
define input parameter i_cc like glt_cc.
define input parameter i_cc1 like glt_cc.
define input parameter i_proj like glt_project.
define input parameter i_proj1 like glt_project.
define input parameter i_trdate like tr_date.
define input parameter i_trdate1 like tr_date.
define input parameter i_trtype like tr_type.
/* SS - 20070415.1 - E */

/* EXTERNAL LABEL INCLUDE */
{gplabel.i}

{cxcustom.i "ICTRRP03.P"}

/* ********** Begin Translatable Strings Definitions ********* */

{&ICTRRP03-P-TAG1}
&SCOPED-DEFINE ictrrp03_p_1 "Detail by GL Account"
{&ICTRRP03-P-TAG2}
/* MaxLen: Comment: */

&SCOPED-DEFINE ictrrp03_p_2 "Detail by Transaction"
/* MaxLen: Comment: */

&SCOPED-DEFINE ictrrp03_p_3 "Quantity @ Unit Cost!Item Description"
/* MaxLen: 53 Comment: Two 26-character column headings */

&SCOPED-DEFINE ictrrp03_p_4 "DR Acct!CR Acct"
/* MaxLen: 17 Comment: 8 char abbreviations for Debit Account, Credit Account */

&SCOPED-DEFINE ictrrp03_p_5 "Sub-Acct!Sub-Acct"
/* MaxLen: 17 Comment: 8 char abbreviations for Sub-Account */

&SCOPED-DEFINE ictrrp03_p_6 "CC!CC"
/* MaxLen: 17 Comment: 8 char abbreviations for Cost Center */

&SCOPED-DEFINE ictrrp03_p_7 "DR Amount!CR Amount"
/* MaxLen: 27 Comment: Debit Account and Credit Account (13 characters each) */

&SCOPED-DEFINE ictrrp03_p_8 "Order!Item"
/* MaxLen: 37 Comment: Two 18-character column headings, Order Number and Item Number */

/* ********** End Translatable Strings Definitions ********* */

{&ICTRRP03-P-TAG3}
/* SS - 20070416.1 - B */
define variable part like tr_part.
define variable part1 like tr_part.
/* SS - 20070416.1 - E */
/* SS - 20080424.1 - B */
define variable nbr like tr_nbr.
define variable nbr1 like tr_nbr.
define variable so_job like tr_so_job.
define variable so_job1 like tr_so_job.
define variable lot like tr_lot.
define variable lot1 like tr_lot.
define variable loc like tr_loc.
define variable loc1 like tr_loc.
/* SS - 20080424.1 - E */
define variable trdate like tr_date.
define variable trdate1 like tr_date.
{&ICTRRP03-P-TAG4}
define variable glref  like trgl_gl_ref.
define variable glref1 like trgl_gl_ref.
define variable efdate like tr_effdate.
define variable efdate1 like tr_date.
define variable trtype like tr_type.
define variable desc1 like pt_desc1.
define variable desc2 like pt_desc2
   column-label {&ictrrp03_p_3} format "x(26)".
define variable tr_yn like mfc_logical label {&ictrrp03_p_2}
   initial yes.
define variable gl_yn like mfc_logical label {&ictrrp03_p_1}
   initial yes.
define variable entity like en_entity.
define variable entity1 like en_entity.
define variable acct like glt_acct.
define variable acct1 like glt_acct.
define variable sub like glt_sub.
define variable sub1 like glt_sub.
define variable proj like glt_project.
define variable proj1 like glt_project.
define variable cc like glt_cc.
define variable cc1 like glt_cc.

define buffer trhist for tr_hist.

/* DEFINED TEMP-TABLE TO RECORD AND DISPLAY GL DATA */
define temp-table tt_glt
   field    tt_entity   like gltw_entity
   field    tt_acc      like gltw_acct
   field    tt_sub      like gltw_sub
   field    tt_cc       like gltw_cc
   field    tt_ref      like gltw_ref
   field    tt_line     like gltw_line
   field    tt_desc     like gltw_desc
   field    tt_date     like gltw_date
   field    tt_effdate  like gltw_effdate
   field    tt_amt      like gltw_amt
   field    tt_project  like gltw_project
index tt_idx tt_ref tt_line.

{&ICTRRP03-P-TAG5}
form
   /* SS - 20070416.1 - B */
   part         colon 20
   part1        label {t001.i} colon 49 skip
   /* SS - 20070416.1 - E */
   /* SS - 20080424.1 - B */
   nbr         colon 20
   nbr1        label {t001.i} colon 49 skip
   so_job         colon 20
   so_job1        label {t001.i} colon 49 skip
   lot         colon 20
   lot1        label {t001.i} colon 49 skip
   loc         colon 20
   loc1        label {t001.i} colon 49 skip
   /* SS - 20080424.1 - E */
   efdate         colon 20
   efdate1        label {t001.i} colon 49 skip
   glref          colon 20
   glref1         label {t001.i} colon 49 skip
   entity         colon 20
   entity1        label {t001.i} colon 49 skip
   acct           colon 20
   acct1          label {t001.i} colon 49 skip
   sub            colon 20
   sub1           label {t001.i} colon 49 skip
   cc             colon 20
   cc1            label {t001.i} colon 49 skip
   proj           colon 20
   proj1          label {t001.i} colon 49 skip
   trdate         colon 20
   trdate1        label {t001.i} colon 49 {&ICTRRP03-P-TAG40} skip (1)
   {&ICTRRP03-P-TAG29}
   trtype         colon 35
   tr_yn          colon 35
   gl_yn          colon 35
   {&ICTRRP03-P-TAG30}
with frame a side-labels width 80.
{&ICTRRP03-P-TAG6}

/* SS - 20070415.1 - B */
/*
/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).
*/
part = i_part.
part1 = i_part1.
/* SS - 20080424.1 - B */
nbr = i_nbr.
nbr1 = i_nbr1.
so_job = i_so_job.
so_job1 = i_so_job1.
lot = i_lot.
lot1 = i_lot1.
loc = i_loc.
loc1 = i_loc1.
/* SS - 20080424.1 - E */
efdate = i_efdate.
efdate1 = i_efdate1.
glref = i_glref.
glref1 = i_glref1.
entity = i_entity.
entity1 = i_entity1.
acct = i_acct.
acct1 = i_acct1.
sub = i_sub.
sub1 = i_sub1.
cc = i_cc.
cc1 = i_cc1.
proj = i_proj.
proj1 = i_proj1.
trdate = i_trdate.
trdate1 = i_trdate1.
trtype = i_trtype.
/* SS - 20070415.1 - E */

{wbrp01.i}
/* SS - 20070415.1 - B */
/*
repeat:
*/
   if part1 = hi_char then
      part1 = "".
/* SS - 20070415.1 - E */
   /* SS - 20080424.1 - B */
   if nbr1 = hi_char then
      nbr1 = "".
   if so_job1 = hi_char then
      so_job1 = "".
   if lot1 = hi_char then
      lot1 = "".
   if loc1 = hi_char then
      loc1 = "".
   /* SS - 20080424.1 - E */
   if trdate = low_date then
      trdate = ?.
   if trdate1 = hi_date then
      trdate1 = ?.
   if efdate = low_date then
      efdate = ?.
   if efdate1 = hi_date then
      efdate1 = ?.
   if glref1 = hi_char then
      glref1 = "".
   if entity1 = hi_char then
      entity1 = "".
   if acct1  = hi_char then
      acct1  = "".
   if sub1   = hi_char then
      sub1   = "".
   if cc1    = hi_char then
      cc1    = "".
   if proj1  = hi_char then
      proj1  = "".

   for each tt_glt
   exclusive-lock:
      delete tt_glt.
   end. /* FOR EACH tt_glt */

   /* SS - 20070415.1 - B */
   /*
   {&ICTRRP03-P-TAG7}
   if c-application-mode <> 'web' then
   {&ICTRRP03-P-TAG8}
   update
      efdate
      efdate1
      glref
      glref1
      entity
      entity1
      acct
      acct1
      sub
      sub1
      cc
      cc1
      proj
      proj1
      trdate
      trdate1
      {&ICTRRP03-P-TAG31}
      trtype
      tr_yn
      gl_yn
      {&ICTRRP03-P-TAG32}
   with frame a.

   {&ICTRRP03-P-TAG33}
   {wbrp06.i &command = update
       &fields = "  efdate efdate1 glref glref1
    entity entity1
        acct acct1 sub sub1 cc cc1 proj proj1 trdate trdate1 trtype
        tr_yn gl_yn" &frm = "a"}
    */
    /* SS - 20070415.1 - E */

   {&ICTRRP03-P-TAG9}
   if (c-application-mode <> 'web') or
      (c-application-mode = 'web' and
      (c-web-request begins 'data')) then do:

      bcdparm = "".
      {&ICTRRP03-P-TAG10}
      /* SS - 20070416.1 - B */
      {mfquoter.i part         }
      {mfquoter.i part1        }
      /* SS - 20070416.1 - E */
      /* SS - 20080424.1 - B */
      {mfquoter.i nbr         }
      {mfquoter.i nbr1        }
      {mfquoter.i so_job         }
      {mfquoter.i so_job1        }
      {mfquoter.i lot         }
      {mfquoter.i lot1        }
      {mfquoter.i loc         }
      {mfquoter.i loc1        }
      /* SS - 20080424.1 - E */
      {mfquoter.i efdate         }
      {mfquoter.i efdate1        }
      {&ICTRRP03-P-TAG11}
      {mfquoter.i glref          }
      {mfquoter.i glref1         }
      {mfquoter.i entity         }
      {mfquoter.i entity1        }
      {mfquoter.i acct           }
      {mfquoter.i acct1          }
      {mfquoter.i sub            }
      {mfquoter.i sub1           }
      {mfquoter.i cc             }
      {mfquoter.i cc1            }
      {mfquoter.i proj           }
      {mfquoter.i proj1          }
      {&ICTRRP03-P-TAG12}
      {mfquoter.i trdate         }
      {mfquoter.i trdate1        }
      {&ICTRRP03-P-TAG13}
      {mfquoter.i trtype         }
      {mfquoter.i tr_yn          }
      {mfquoter.i gl_yn          }

      {&ICTRRP03-P-TAG14}
      /* SS - 20070416.1 - B */
      if part1 = "" then
         part1 = hi_char.
      /* SS - 20070416.1 - E */
      /* SS - 20080424.1 - B */
      if nbr1 = "" then
         nbr1 = hi_char.
      if so_job1 = "" then
         so_job1 = hi_char.
      if lot1 = "" then
         lot1 = hi_char.
      if loc1 = "" then
         loc1 = hi_char.
      /* SS - 20080424.1 - E */
      if trdate = ? then
         trdate = low_date.
      if trdate1 = ? then
         trdate1 = hi_date.
      if efdate = ? then
         efdate = low_date.
      if efdate1 = ? then
         efdate1 = hi_date.
      if glref1 = "" then
         glref1 = hi_char.
      if entity1 = "" then
         entity1 = hi_char.
      if acct1  = "" then
         acct1  = hi_char.
      if sub1   = "" then
         sub1   = hi_char.
      if cc1    = "" then
         cc1    = hi_char.
      if proj1  = "" then
         proj1  = hi_char.
      {&ICTRRP03-P-TAG15}

   end.
   /* SS - 20070415.1 - B */
   /*
   /* OUTPUT DESTINATION SELECTION */
   {gpselout.i &printType = "printer"
               &printWidth = 132
               &pagedFlag = " "
               &stream = " "
               &appendToFile = " "
               &streamedOutputToTerminal = " "
               &withBatchOption = "yes"
               &displayStatementType = 1
               &withCancelMessage = "yes"
               &pageBottomMargin = 6
               &withEmail = "yes"
               &withWinprint = "yes"
               &defineVariables = "yes"}
   {mfphead.i}

   form header
      skip(1)
   with frame a1 page-top width 132.
   view frame a1.
   */
   define variable l_textfile        as character no-undo.
   /* SS - 20070415.1 - E */

   {&ICTRRP03-P-TAG16}
   for each tr_hist no-lock
          where tr_hist.tr_domain = global_domain and (  (tr_effdate >= efdate
          and tr_effdate <= efdate1
         or tr_effdate = ?)
         {&ICTRRP03-P-TAG34}
         and (tr_type = trtype or trtype = "")
         and (tr_date >= trdate and tr_date <= trdate1
         or tr_date = ?) )
      /* SS - 20070416.1 - B */
      AND tr_part >= part
      AND tr_part <= part1
      /* SS - 20070416.1 - E */
      /* SS - 20080424.1 - B */
      AND tr_nbr >= nbr
      AND tr_nbr <= nbr1
      AND tr_so_job >= so_job
      AND tr_so_job <= so_job1
      AND tr_lot >= lot
      AND tr_lot <= lot1
      AND tr_loc >= loc
      AND tr_loc <= loc1
      /* SS - 20080424.1 - E */
      ,
         each trgl_det no-lock
         {&ICTRRP03-P-TAG17}
          where trgl_det.trgl_domain = global_domain and (  trgl_trnbr =
          tr_trnbr
         and (trgl_gl_ref  >= glref  and trgl_gl_ref  <= glref1)
         and (
         (trgl_dr_acct >= acct and trgl_dr_acct <= acct1)
         or (trgl_cr_acct >= acct and trgl_cr_acct <= acct1)
         )
         and (
         (trgl_dr_sub >= sub and trgl_dr_sub <= sub1)
         or (trgl_cr_sub >= sub and trgl_cr_sub <= sub1)
         )
         and (
         (trgl_dr_cc >= cc and trgl_dr_cc <= cc1)
         or (trgl_cr_cc >= cc and trgl_cr_cc <= cc1)

         )
         and (
         (trgl_dr_proj >= proj and trgl_dr_proj <= proj1)
         or (trgl_cr_proj >= proj and trgl_cr_proj <= proj1)
         )
         /* SS - 20070415.1 - B */
         /*
         and (trgl_gl_amt <> 0)
         */
         /* SS - 20070415.1 - E */
         ) break by tr_effdate by tr_trnbr with frame b width 132 no-box:

      /* SS - 20070415.1 - B */
      /*
      /* SET EXTERNAL LABELS */
      setFrameLabels(frame b:handle).

      find si_mstr  where si_mstr.si_domain = global_domain and  si_site =
      tr_site no-lock no-error.
      if si_entity >= entity and si_entity <= entity1 then do:

      if gl_yn then do:

         {&ICTRRP03-P-TAG35}

         /* PROCEDURE TO CREATE TEMP-TABLE WITH GL DATA */

         run p_tt_glt_create
            (input recid(tr_hist),
             input recid(trgl_det),
             input recid(si_mstr)).

         {&ICTRRP03-P-TAG36}
      end. /* if gl_yn the do */

      if tr_yn then do:
         {&ICTRRP03-P-TAG18}
         form
            tr_effdate
            tr_trnbr
            trgl_type
            tr_nbr       column-label {&ictrrp03_p_8}
            si_entity     column-label "Ent"
            trgl_gl_ref
            desc2
            trgl_dr_acct column-label {&ictrrp03_p_4}
            trgl_dr_sub  column-label {&ictrrp03_p_5}
            trgl_dr_cc   column-label {&ictrrp03_p_6}
            trgl_gl_amt  column-label {&ictrrp03_p_7}
            format "->>>,>>>,>>9.99<<<<<<<<" with width 132.
         {&ICTRRP03-P-TAG19}

         assign
            desc1 = ""
            desc2 = "".
         {&ICTRRP03-P-TAG20}
         find pt_mstr  where pt_mstr.pt_domain = global_domain and  pt_part =
         tr_part no-lock no-error.
         if available pt_mstr then do:
            desc1 = pt_desc1.
            {&ICTRRP03-P-TAG21}
         end.
         if page-size - line-counter < 4 then page.

         if tr_qty_loc <> 0 then

            desc2 = trim(string(tr_qty_loc,"->,>>>,>>9.99<<<<"))
                  + " @ "
                  + if (round(tr_qty_loc * (tr_bdn_std +
                        tr_lbr_std + tr_mtl_std + tr_ovh_std +
                        tr_sub_std),2) = trgl_gl_amt or
                        round(tr_qty_loc * (tr_bdn_std +
                        tr_lbr_std + tr_mtl_std + tr_ovh_std +
                        tr_sub_std),2) = (- 1) * trgl_gl_amt)
                     then trim(string(
                        if (trgl_gl_amt / tr_qty_loc) *
                           (tr_bdn_std + tr_lbr_std + tr_mtl_std +
                           tr_ovh_std + tr_sub_std) >= 0 then
                           (tr_bdn_std + tr_lbr_std + tr_mtl_std +
                           tr_ovh_std + tr_sub_std)
                        else
                           (tr_bdn_std + tr_lbr_std + tr_mtl_std +
                           tr_ovh_std + tr_sub_std) * (-1),
                           "->>,>>>,>>9.99<<<"))
                     else
                        trim (string(trgl_gl_amt / tr_qty_loc,
                        "->>,>>>,>>9.99<<<")).

         if tr_type begins "CN-" then do for trhist:
               for first trhist
                   where trhist.tr_domain = global_domain and  tr_trnbr =
                   integer(tr_hist.tr_rmks)
               no-lock:

               desc2 = trim(string(tr_hist.tr_qty_loc,"->,>>>,>>9.99<<<<"))
                  + " @ "
                  + if (round(tr_hist.tr_qty_loc * (trhist.tr_bdn_std +
                          trhist.tr_lbr_std +
                          trhist.tr_mtl_std +
                          trhist.tr_ovh_std +
                          trhist.tr_sub_std),2) = trgl_gl_amt
                       or
                          round(tr_hist.tr_qty_loc * (trhist.tr_bdn_std +
                             trhist.tr_lbr_std +
                             trhist.tr_mtl_std +
                             trhist.tr_ovh_std +
                             trhist.tr_sub_std),2) = (- 1) * trgl_gl_amt)
                    then
                       trim(string(
                          if (trgl_gl_amt / tr_hist.tr_qty_loc) *
                                (trhist.tr_bdn_std +
                                 trhist.tr_lbr_std +
                                 trhist.tr_mtl_std +
                                 trhist.tr_ovh_std +
                                 trhist.tr_sub_std) >= 0
                          then
                             (trhist.tr_bdn_std +
                              trhist.tr_lbr_std +
                              trhist.tr_mtl_std +
                              trhist.tr_ovh_std +
                              trhist.tr_sub_std)
                          else
                             (trhist.tr_bdn_std +
                              trhist.tr_lbr_std +
                              trhist.tr_mtl_std +
                              trhist.tr_ovh_std +
                              trhist.tr_sub_std) * (-1),"->>,>>>,>>9.99<<<"))
                          else
                             trim (string(trgl_gl_amt /
                                 tr_hist.tr_qty_loc, "->>,>>>,>>9.99<<<")).

               end.  /* for first trhist */
            end.  /* if tr_type begins "CN-" */

         if first-of(tr_trnbr) then do:
            {&ICTRRP03-P-TAG28}
            down 1.
            {&ICTRRP03-P-TAG22}
            display
               tr_effdate
               tr_trnbr
               trgl_type
               tr_nbr.
            {&ICTRRP03-P-TAG23}
         end.

         {&ICTRRP03-P-TAG24}
         display
            si_entity when (available si_mstr)
            trgl_gl_ref
            desc2
            trgl_dr_acct
            trgl_dr_sub
            trgl_dr_cc
            {&ICTRRP03-P-TAG26}
            trgl_gl_amt.
         down 1.

         {&ICTRRP03-P-TAG27}
         if first-of(tr_trnbr) then
            display
               tr_part @ tr_nbr
               desc1 @ desc2.
         display
            trgl_cr_acct @ trgl_dr_acct
            trgl_cr_sub @ trgl_dr_sub
            trgl_cr_cc @ trgl_dr_cc
            (- trgl_gl_amt) @ trgl_gl_amt.
         {&ICTRRP03-P-TAG25}

         {mfrpexit.i "false"}
      end. /*if tr_yn*/
      end.
      */
      CREATE ttssictrrp0301.
      ASSIGN
         ttssictrrp0301_tr_effdate = tr_effdate
         ttssictrrp0301_tr_trnbr = tr_trnbr
         ttssictrrp0301_trgl_type = trgl_type
         ttssictrrp0301_tr_nbr = tr_nbr
         ttssictrrp0301_trgl_gl_ref = trgl_gl_ref
         ttssictrrp0301_trgl_dr_acct = trgl_dr_acct
         ttssictrrp0301_trgl_dr_sub = trgl_dr_sub
         ttssictrrp0301_trgl_dr_cc = trgl_dr_cc
         ttssictrrp0301_trgl_dr_proj = trgl_dr_proj
         ttssictrrp0301_trgl_dr_amt = trgl_gl_amt
         ttssictrrp0301_trgl_cr_acct = trgl_cr_acct
         ttssictrrp0301_trgl_cr_sub = trgl_cr_sub
         ttssictrrp0301_trgl_cr_cc = trgl_cr_cc
         ttssictrrp0301_trgl_cr_proj = trgl_cr_proj
         ttssictrrp0301_trgl_cr_amt = (- trgl_gl_amt)
         ttssictrrp0301_tr_part = tr_part
         .
      IF AVAILABLE si_mstr THEN DO:
         ASSIGN
            ttssictrrp0301_si_entity = si_entity
            .
      END.
      ASSIGN
         ttssictrrp0301_tr_rmks = tr_rmks
         ttssictrrp0301_tr_line = tr_line
         ttssictrrp0301_tr_site = tr_site
         ttssictrrp0301_tr_prod_line = tr_prod_line
         ttssictrrp0301_tr_lot = tr_lot
         ttssictrrp0301_tr_date = tr_date
         ttssictrrp0301_tr_type = tr_type
         ttssictrrp0301_tr_loc = tr_loc
         ttssictrrp0301_tr_qty_loc = tr_qty_loc
         .
      FIND FIRST wo_mstr 
         WHERE wo_domain = GLOBAL_domain
         AND wo_nbr = tr_nbr
         AND wo_lot = tr_lot
         NO-LOCK
         NO-ERROR
         .
      IF AVAILABLE wo_mstr THEN DO:
         ASSIGN
            ttssictrrp0301_wo_part = wo_part
            .
      END.
      /* SS - 20070415.1 - E */
   end. /*for each*/

   /* SS - 20070415.1 - B */
   /*
   /* PRINT GL DISTRIBUTION */
   if gl_yn then do:
      if tr_yn then page.
      {&ICTRRP03-P-TAG37}

      /* PROCEDURE TO DISPLAY TEMP-TABLE DATA */
      run p_tt_glt_display.

      {&ICTRRP03-P-TAG38}
   end.

   /* REPORT TRAILER */

   {mfrtrail.i}

end.
*/
/* SS - 20070415.1 - E */

{wbrp04.i &frame-spec = a}

{&ICTRRP03-P-TAG39}

/**************************INTERNAL PROCEDURES**********************/

/* PROCEDURE TO CREATE TEMP-TABLE WITH GL DATA */
PROCEDURE p_tt_glt_create:

   define input parameter tr_recid   as recid no-undo.
   define input parameter trgl_recid as recid no-undo.
   define input parameter si_recid   as recid no-undo.

   define variable l_line as integer no-undo.

   for first tr_hist
      where recid(tr_hist) = tr_recid
   no-lock:
   end. /* FOR FIRST tr_hist */

   for first trgl_det
      where recid(trgl_det) = trgl_recid
   no-lock:
   end. /* FOR FIRST trgl_det */

   for first si_mstr
      where recid(si_mstr) = si_recid
   no-lock:
   end. /* FOR FIRST si_mstr */

   if can-find(last tt_glt
      where tt_ref = trgl_gl_ref)
   then
      l_line = l_line + 1.
   else
      l_line = 1.

   create tt_glt.
   assign
      tt_acc     = trgl_dr_acct
      tt_sub     = trgl_dr_sub
      tt_cc      = trgl_dr_cc
      tt_project = trgl_dr_proj
      tt_ref     = trgl_gl_ref
      tt_line    = l_line
      tt_date    = tr_date
      tt_effdate = tr_effdate
      tt_desc    = tr_type + " " + string(tr_trnbr) + " " + tr_nbr
      tt_amt     = trgl_gl_amt
      tt_entity  = si_entity.

   for first glt_det
      fields(glt_domain glt_ref glt_line glt_entity)
      where glt_domain = global_domain
      and   glt_ref    = trgl_gl_ref
      and   glt_line   = trgl_dr_line
   no-lock:
      tt_entity = glt_entity.
   end. /* FOR FIRST glt_det */
   if not available glt_det
   then do:
      for first gltr_hist
         fields(gltr_domain gltr_ref gltr_line gltr_entity)
         where gltr_domain = global_domain
         and   gltr_ref    = trgl_gl_ref
         and   gltr_line   = trgl_dr_line
      no-lock:
         tt_entity = gltr_entity.
      end. /* FOR FIRST gltr_hist */
   end. /* IF NOT AVAILABLE glt_det */

   if can-find(last tt_glt
      where tt_ref = trgl_gl_ref)
   then
      l_line = l_line + 1.
   else
      l_line = 1.

   create tt_glt.
   assign
      tt_acc     = trgl_cr_acct
      tt_sub     = trgl_cr_sub
      tt_cc      = trgl_cr_cc
      tt_project = trgl_cr_proj
      tt_ref     = trgl_gl_ref
      tt_line    = l_line
      tt_date    = tr_date
      tt_effdate = tr_effdate
      tt_desc    = tr_type + " " + string(tr_trnbr) + " " + tr_nbr
      tt_amt     = - trgl_gl_amt
      tt_entity  = si_entity.

   for first glt_det
      fields(glt_domain glt_ref glt_line glt_entity)
      where glt_domain = global_domain
      and   glt_ref    = trgl_gl_ref
      and   glt_line   = trgl_cr_line
   no-lock:
      tt_entity = glt_entity.
   end. /* FOR FIRST glt_det */
   if not available glt_det
   then do:
      for first gltr_hist
         fields(gltr_domain gltr_ref gltr_line gltr_entity)
         where gltr_domain = global_domain
         and   gltr_ref    = trgl_gl_ref
         and   gltr_line   = trgl_dr_line
      no-lock:
         tt_entity = gltr_entity.
      end. /* FOR FIRST gltr_hist */
   end. /* IF NOT AVAILABLE glt_det */

END PROCEDURE. /* p_tt_glt_create */

/* PROCEDURE TO DISPLAY THE GL DATA FROM THE TEMP-TABLE */
PROCEDURE p_tt_glt_display:

   define variable l_dr_amt       like glt_amt label "Debit Amount"  no-undo.
   define variable l_cr_amt       like glt_amt label "Credit Amount" no-undo.
   define variable l_nbr_entities as   integer                       no-undo.
   define variable l_tmp_fmt      as   character                     no-undo.

   for first gl_ctrl
      fields(gl_domain gl_rnd_mthd)
      where gl_domain = global_domain
   no-lock:
   end. /* FOR FIRST gl_ctrl */

   form
      header
      getTermLabel("GENERAL_LEDGER_DETAIL",34) + " " format "x(35)"
      skip (1)
   with frame jrnl width 132 page-top.

   view frame jrnl.

   l_nbr_entities = 0.

   {&ICTRRP03-P-TAG41}
   form
      tt_entity
      tt_acc
      tt_sub
      tt_cc
      tt_project
      tt_date
      tt_effdate
      tt_desc format "x(28)"
      l_dr_amt
      l_cr_amt
   with frame jrnldet width 132 down no-box.

   /* SET EXTERNAL LABELS */
   setFrameLabels(frame jrnldet:handle).

   do with frame jrnldet:
      {&ICTRRP03-P-TAG42}

      l_tmp_fmt = l_dr_amt:format.
      {gprun.i ""gpcurfmt.p""
        "(input-output l_tmp_fmt,
          input gl_rnd_mthd)"}
      l_dr_amt:format = l_tmp_fmt.

      l_tmp_fmt = l_cr_amt:format.
      {gprun.i ""gpcurfmt.p""
        "(input-output l_tmp_fmt,
          input gl_rnd_mthd)"}
      l_cr_amt:format = l_tmp_fmt.

      for each tt_glt
         no-lock
         break by tt_entity
               by tt_acc
               by tt_sub
               by tt_cc
               by tt_project
               by tt_effdate
         {&ICTRRP03-P-TAG43}
         with frame jrnldet width 132 down no-box:
         {&ICTRRP03-P-TAG44}

         assign
            l_cr_amt = 0
            l_dr_amt = 0.

         if tt_amt < 0
         then
            l_cr_amt = - tt_amt.
         else
            l_dr_amt = tt_amt.

         {&ICTRRP03-P-TAG45}
         accumulate (l_dr_amt) (total by tt_entity by tt_acc).
         accumulate (l_cr_amt) (total by tt_entity by tt_acc).

         if first-of (tt_entity)
         then
            display tt_entity.

         {&ICTRRP03-P-TAG46}
         if first-of (tt_acc)
         then
            display tt_acc.
         {&ICTRRP03-P-TAG47}

         if first-of (tt_sub)
         then
            display tt_sub.

         if first-of (tt_cc)
         then
            display tt_cc.

         {&ICTRRP03-P-TAG48}
         display
            tt_project
            tt_date
            tt_effdate
            tt_desc.
         {&ICTRRP03-P-TAG49}

         if l_dr_amt <> 0
         then
            display l_dr_amt.

         if l_cr_amt <> 0
         then
            display l_cr_amt.

         down 1.

         {mfrpchk.i}

         if last-of(tt_acc)
         then do:
            underline
               l_dr_amt
               l_cr_amt.
            display
               accum total by tt_acc l_dr_amt @ l_dr_amt
               accum total by tt_acc l_cr_amt @ l_cr_amt.
            down 1.
         end. /* IF LAST-OF(tt_acc) */

         if last-of(tt_entity)
         then do:
            l_nbr_entities = l_nbr_entities + 1.
            underline
               l_dr_amt
               l_cr_amt.
            display
               accum total by tt_entity l_dr_amt @ l_dr_amt
               accum total by tt_entity l_cr_amt @ l_cr_amt.
            down 1.
         end. /* IF LAST-OF(tt_entity) */

         if last(tt_entity)
            and l_nbr_entities > 1
         then do:
            underline
               l_dr_amt
               l_cr_amt.
            display
               accum total l_dr_amt @ l_dr_amt
               accum total l_cr_amt @ l_cr_amt.
         end. /* IF LAST(tt_entity) .. */
         {&ICTRRP03-P-TAG50}
      end. /* FOR EACH tt_glt */
   end. /* DO WITH FRAME */
END PROCEDURE. /* p_tt_glt_display */
