/* ppptrp13.p - PART COST REPORT                                        */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                  */
/* All rights reserved worldwide.  This is an unpublished work.         */
/* $Revision: 1.6.1.6 $                                                         */
/*V8:ConvertMode=FullGUIReport                                 */
/* REVISION: 1.0      LAST EDIT: 06/03/86  MODIFIED BY: PML             */
/* REVISION: 1.0      LAST EDIT: 08/27/86  MODIFIED BY: EMB *12*        */
/* REVISION: 4.0      LAST EDIT: 02/09/88  MODIFIED BY: pml             */
/* REVISION: 4.0      LAST MODIFIED: 02/10/88   BY: WUG *A175*          */
/* REVISION: 7.0      LAST MODIFIED: 09/04/91   BY: pma *F003*          */
/* REVISION: 7.3      LAST MODIFIED: 05/28/93   BY: pma *GB41*          */
/* REVISION: 7.3      LAST MODIFIED: 11/01/93   BY: ais *GG77*          */
/* REVISION: 7.3      LAST MODIFIED: 08/16/94   BY: dpm *FQ22*          */
/* REVISION: 7.3      LAST MODIFIED: 08/27/94   BY: rxm *GL58*          */
/* REVISION: 7.3      LAST MODIFIED: 11/03/94   BY: cpp *FT35*          */
/* REVISION: 8.6      LAST MODIFIED: 10/10/97   BY: mzv *K0RH*          */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan   */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00 BY: *N08T* Annasaheb Rahane */
/* REVISION: 9.1      LAST MODIFIED: 07/20/00 BY: *N0GF* Mudit Mehta      */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* $Revision: 1.6.1.6 $    BY: Zheng Huang           DATE: 02/07/02  ECO: *P000*  */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/
/* REVISION: 9.1      LAST MODIFIED: 08/13/00 BY: *N0KQ* myb              */
/* $Revision: 1.6.1.6 $ BY: Paul Donnelly (SB) DATE: 06/28/03 ECO: *Q00K* */
/* $Revision: 1.6.1.6 $ BY: Bill Jiang DATE: 01/24/08 ECO: *SS - 20080124.1* */
/*-Revision end---------------------------------------------------------------*/

/* SS - 20080124.1 - B */
/*
/* DISPLAY TITLE */
{mfdtitle.i "2+ "}
*/
{ssppptrp1301.i}

define input parameter i_line like pt_prod_line.
define input parameter i_line1 like pt_prod_line.
define input parameter i_part like pt_part.
define input parameter i_part1 like pt_part.
define input parameter i_type like pt_part_type.
define input parameter i_type1 like pt_part_type.
define input parameter i_site  like si_site.
define input parameter i_site1 like si_site.
{a6mfdtitle.i "2+ "}
/* SS - 20080124.1 - E */

/* ********** Begin Translatable Strings Definitions ********* */

/* ********** End Translatable Strings Definitions ********* */

define variable line like pt_prod_line.
define variable line1 like pt_prod_line.
define variable part like pt_part.
define variable part1 like pt_part.
define variable type like pt_part_type.
define variable type1 like pt_part_type.

define variable site  like si_site.
define variable site1 like si_site.
define variable buyer like pt_buyer.
define variable buyer1 like pt_buyer.
define variable pldesc like pl_desc.
define variable first_flag as logical initial no.
define variable first_of_flag as logical initial no.

/* SELECT FORM */
form
   line           colon 15
   line1          label {t001.i} colon 49 skip
   part           colon 15
   part1          label {t001.i} colon 49 skip
   type           colon 15
   type1          label {t001.i} colon 49 skip
   site           colon 15
   site1          label {t001.i} colon 49 skip
   buyer          colon 15
   buyer1         label {t001.i} colon 49 skip
with frame a side-labels width 80.

/* SS - 20080124.1 - B */
/*
/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).
*/
LINE = i_line.
line1 = i_line1.
part = i_part.
part1 = i_part1.
TYPE = i_type.
type1 = i_type1.
site = i_site.
site1 = i_site1.
/* SS - 20080124.1 - E */

/* REPORT BLOCK */

{wbrp01.i}
/* SS - 20080124.1 - B */
/*
repeat:
*/
/* SS - 20080124.1 - E */

   if part1 = hi_char then part1 = "".
   if line1 = hi_char then line1 = "".
   if type1 = hi_char then type1 = "".
   if site1 = hi_char then site1 = "".
   if buyer1 = hi_char then buyer1 = "".

   /* SS - 20080124.1 - B */
   /*
   if c-application-mode <> 'web' then
   update line line1 part part1 type type1 site site1
      buyer buyer1
   with frame a.

   {wbrp06.i &command = update &fields = "  line line1 part part1 type
        type1 site site1  buyer buyer1" &frm = "a"}
   */
   /* SS - 20080124.1 - E */

   if (c-application-mode <> 'web') or
      (c-application-mode = 'web' and
      (c-web-request begins 'data')) then do:

      bcdparm = "".
      {mfquoter.i line   }
      {mfquoter.i line1  }
      {mfquoter.i part   }
      {mfquoter.i part1  }
      {mfquoter.i type   }
      {mfquoter.i type1  }
      {mfquoter.i site   }
      {mfquoter.i site1  }
      {mfquoter.i buyer  }
      {mfquoter.i buyer1 }

      if part1 = "" then part1 = hi_char.
      if line1 = "" then line1 = hi_char.
      if type1 = "" then type1 = hi_char.
      if site1 = "" then site1 = hi_char.
      if buyer1 = "" then buyer1 = hi_char.

      find first icc_ctrl  where icc_ctrl.icc_domain = global_domain no-lock.
   end.

   /* SS - 20080124.1 - B */
   /*
   /* PRINTER SELECTION */
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

   hide frame b1.
   hide frame b2.
   */
   /* SS - 20080124.1 - E */

   for each pt_mstr no-lock use-index pt_prod_part
          where pt_mstr.pt_domain = global_domain and  (pt_part >= part and
          pt_part <= part1)
         and (pt_prod_line >= line and pt_prod_line <= line1)
         and (pt_part_type >= type and pt_part_type <= type1),
         each in_mstr no-lock
          where in_mstr.in_domain = global_domain and  (in_site >= site and
          in_site <= site1)
         and in_part = pt_part
         /* SS - 20080124.1 - B */
         AND IN_site = pt_site
         /* SS - 20080124.1 - E */
         break by in_site by pt_prod_line
         by pt_part with frame b width 132 no-attr-space:

      /* SS - 20080124.1 - B */
      /*
      /* SET EXTERNAL LABELS */
      setFrameLabels(frame b:handle).
      setFrameLabels(frame b1:handle).
      setFrameLabels(frame b2:handle).

      if first-of(pt_prod_line) then do:
         first_of_flag = yes.
         if first(pt_prod_line) then first_flag = yes.
      end.
      */
      /* SS - 20080124.1 - E */

      find si_mstr  where si_mstr.si_domain = global_domain and  si_site =
      in_site no-lock no-error.
      if si_db <> global_db then next.
      /* SS - 20080124.1 - B */
      /*
      if first-of(in_site) then do:
         first_of_flag = yes.
         if first(in_site) then first_flag = yes.
      end.

      find ptp_det  where ptp_det.ptp_domain = global_domain and  ptp_part =
      pt_part and ptp_site = si_site
      no-lock no-error.
      if available ptp_det then do:
         if ptp_buyer < buyer or ptp_buyer > buyer1 then next.
      end.
      else
         if pt_buyer < buyer or pt_buyer > buyer1 then next.
      if first_of_flag then do:
         if not first_flag then page.
         first_of_flag = no.
         first_flag = no.
         display si_site si_desc with frame b1 width 132.
         find pl_mstr  where pl_mstr.pl_domain = global_domain and
         pl_prod_line = pt_prod_line
         no-lock no-error.
         display pt_prod_line with frame b1.
         if available pl_mstr then
            if available pl_mstr then pldesc = pl_desc.
         else pldesc = "".
         display pldesc with frame b1.
      end.

      form
         header
         skip(1)
         si_site si_desc pt_prod_line pldesc " (" +
         getTermLabel("CONTINUED",20) + ")" format "x(24)"
      with frame a1 page-top side-labels width 132.
      view frame a1.

      form
         space(13) sct_sim sct_mtl_tl sct_lbr_tl sct_bdn_tl
         sct_ovh_tl sct_sub_tl sct_cst_tot sct_cst_date
      with frame b down width 132.

      if page-size - line-counter <= 5 then page.

      display space(9) pt_part pt_um pt_desc1 pt_desc2
      with frame b2 width 132 no-labels.

      if in_cur_set <> "" then do:
         find sct_det  where sct_det.sct_domain = global_domain and  sct_part =
         pt_part
            and sct_sim = in_cur_set
            and sct_site = si_site no-lock no-error.
      end.
      else do:
         find sct_det  where sct_det.sct_domain = global_domain and  sct_part =
         pt_part
            and sct_sim = icc_cur_set
            and sct_site = si_site no-lock no-error.
      end.
      if available sct_det then
      display sct_sim
         sct_mtl_tl + sct_mtl_ll @ sct_mtl_tl
         sct_lbr_tl + sct_lbr_ll @ sct_lbr_tl
         sct_bdn_tl + sct_bdn_ll @ sct_bdn_tl
         sct_ovh_tl + sct_ovh_ll @ sct_ovh_tl
         sct_sub_tl + sct_sub_ll @ sct_sub_tl
         sct_cst_tot sct_cst_date.
      else
      display icc_cur_set @ sct_sim
         0 @ sct_mtl_tl
         0 @ sct_lbr_tl
         0 @ sct_bdn_tl
         0 @ sct_ovh_tl
         0 @ sct_sub_tl
         0 @ sct_cst_tot "" @ sct_cst_date.

      down.
      */
      /* SS - 20080124.1 - E */

      if in_gl_set <> "" then do:
         find sct_det  where sct_det.sct_domain = global_domain and  sct_part =
         pt_part
            and sct_sim = in_gl_set
            and sct_site = in_gl_cost_site no-lock no-error.
      end.
      else do:

         find sct_det  where sct_det.sct_domain = global_domain and  sct_part =
         pt_part
            and sct_sim = icc_gl_set
            and sct_site = in_gl_cost_site no-lock no-error.
      end.
      /* SS - 20080124.1 - B */
      /*
      if available sct_det then
      display sct_sim
         sct_mtl_tl + sct_mtl_ll @ sct_mtl_tl
         sct_lbr_tl + sct_lbr_ll @ sct_lbr_tl
         sct_bdn_tl + sct_bdn_ll @ sct_bdn_tl
         sct_ovh_tl + sct_ovh_ll @ sct_ovh_tl
         sct_sub_tl + sct_sub_ll @ sct_sub_tl
         sct_cst_tot sct_cst_date.
      else
      display icc_gl_set @ sct_sim
         0 @ sct_mtl_tl
         0 @ sct_lbr_tl
         0 @ sct_bdn_tl
         0 @ sct_ovh_tl
         0 @ sct_sub_tl
         0 @ sct_cst_tot "" @ sct_cst_date.

      down.
      */
      CREATE ttssppptrp1301.
      ASSIGN
         ttssppptrp1301_site = si_site
         ttssppptrp1301_part = pt_part
         .
      IF AVAILABLE sct_det THEN DO:
         ASSIGN
            ttssppptrp1301_sim = sct_sim
            ttssppptrp1301_mtl_tl = sct_mtl_tl + sct_mtl_ll
            ttssppptrp1301_lbr_tl = sct_lbr_tl + sct_lbr_ll
            ttssppptrp1301_bdn_tl = sct_bdn_tl + sct_bdn_ll
            ttssppptrp1301_ovh_tl = sct_ovh_tl + sct_ovh_ll
            ttssppptrp1301_sub_tl = sct_sub_tl + sct_sub_ll
            ttssppptrp1301_cst_tot = sct_cst_tot
            ttssppptrp1301_cst_date = sct_cst_date
            .
      END.
      ELSE DO:
         ASSIGN
            ttssppptrp1301_sim = icc_gl_set
            .
      END.
      /* SS - 20080124.1 - E */

      /* SS - 20080124.1 - B */
      /*
      for each sct_det  where sct_det.sct_domain = global_domain and  sct_part
      = pt_part
            and sct_site = si_site
            and sct_sim <> si_gl_set and
            (si_gl_set = "" and sct_sim <> icc_gl_set)
            and sct_sim <> si_cur_set and
            (si_cur_set = "" and sct_sim <> icc_cur_set)
         no-lock with frame b:

         if page-size - line-counter <= 2 then do:
            page.
            display si_site si_desc pt_prod_line pldesc
            with frame b1.
            display pt_part pt_um pt_desc1 pt_desc2  with frame b2
               width 132.
         end.

         display sct_sim
            sct_mtl_tl + sct_mtl_ll @ sct_mtl_tl
            sct_lbr_tl + sct_lbr_ll @ sct_lbr_tl
            sct_bdn_tl + sct_bdn_ll @ sct_bdn_tl
            sct_ovh_tl + sct_ovh_ll @ sct_ovh_tl
            sct_sub_tl + sct_sub_ll @ sct_sub_tl
            sct_cst_tot sct_cst_date.
         down.
         {mfrpexit.i "false"}
      end.
      */
      /* SS - 20080124.1 - E */

      {mfrpexit.i }
   end.

/* SS - 20080124.1 - B */
/*
   /* REPORT TRAILER */
   {mfrtrail.i}

end.
*/
/* SS - 20080124.1 - B */

{wbrp04.i &frame-spec = a}
