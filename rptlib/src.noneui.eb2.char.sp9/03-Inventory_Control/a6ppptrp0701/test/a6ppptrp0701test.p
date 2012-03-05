/* ppptrp07.p - INVENTORY VAL AS OF DATE BY LOCATION                        */
/* Copyright 1986-2005 QAD Inc., Carpinteria, CA, USA.                      */
/* All rights reserved worldwide.  This is an unpublished work.             */
/* $Revision: 1.9.1.12.3.14 $                                               */
/*K0R5*/ /*                                                                 */
/*V8:ConvertMode=FullGUIReport                                              */
/* REVISION: 7.0      LAST MODIFIED: 09/04/91   BY: pma *F003*              */
/* REVISION: 7.0      LAST MODIFIED: 02/03/92   BY: pma *F134*              */
/* REVISION: 7.0      LAST MODIFIED: 03/11/92   BY: WUG *F280*              */
/* REVISION: 7.0      LAST MODIFIED: 07/15/92   BY: pma *F770*              */
/* REVISION: 7.0      LAST MODIFIED: 08/03/92   BY: pma *F828*              */
/* REVISION: 7.0      LAST MODIFIED: 09/14/92   BY: pma *F893*              */
/* Revision: 7.3      Last modified: 10/31/92   By: jcd *G259*              */
/* REVISION: 7.3      LAST MODIFIED: 03/25/93   BY: pma *G869*              */
/* REVISION: 7.3      LAST MODIFIED: 02/18/94   BY: pxd *FM27*              */
/* Oracle changes (share-locks)      09/12/94   BY: rwl *GM42*              */
/* REVISION: 7.2      LAST MODIFIED: 01/09/95   BY: ais *F0DB*              */
/* REVISION: 7.3      LAST MODIFIED: 06/02/95   by: dzs *G0NZ*              */
/* REVISION: 7.3      LAST MODIFIED: 10/13/95   by: str *G0ZG*              */
/* REVISION: 8.6      LAST MODIFIED: 10/10/97   by: mzv *K0R5*              */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane        */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan       */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane */
/* REVISION: 9.1      LAST MODIFIED: 04/20/00   BY: *J3PB* Kirti Desai      */
/* REVISION: 9.1      LAST MODIFIED: 08/08/00   BY: *M0QW* Falguni Dalal    */
/* REVISION: 9.1      LAST MODIFIED: 08/13/00   BY: *N0KQ* myb              */
/* REVISION: 9.1      LAST MODIFIED: 08/21/00   BY: *N0MD* BalbeerS Rajput  */
/* Old ECO marker removed, but no ECO header exists *F0PN*                  */
/* Revision: 1.9.1.11      BY: Patrick Rowan    DATE: 04/24/01  ECO: *P00G* */
/* Revision: 1.9.1.12      BY: Dan Herman       DATE: 06/06/02  ECO: *P07Y* */
/* Revision: 1.9.1.12.3.1  BY: K Paneesh        DATE: 08/25/03  ECO: *P108* */
/* Revision: 1.9.1.12.3.2  BY: Reena Ambavi     DATE: 12/08/03  ECO: *P1DJ* */
/* Revision: 1.9.1.12.3.3  BY: Reena Ambavi     DATE: 12/15/03  ECO: *P1FX* */
/* Revision: 1.9.1.12.3.4  BY: Manish Dani      DATE: 01/27/04  ECO: *P1LD* */
/* Revision: 1.9.1.12.3.5  BY: Somesh Jeswani   DATE: 07/07/04  ECO: *P28R* */
/* Revision: 1.9.1.12.3.8  BY: Preeti Sattur    DATE: 08/03/04  ECO: *P2D0* */
/* Revision: 1.9.1.12.3.11 BY: Vandna Rohira    DATE: 10/15/04  ECO: *P2NM* */
/* Revision: 1.9.1.12.3.12 BY: Tejasvi Kulkarni DATE: 11/25/04  ECO: *P2T2* */
/* Revision: 1.9.1.12.3.13 BY: Gaurav Kerkar    DATE: 12/03/04  ECO: *P2SJ* */
/* $Revision: 1.9.1.12.3.14 $ BY: Gaurav Kerkar  DATE: 01/19/05  ECO: *P34M* */
/* $Revision: 1.9.1.12.3.14 $ BY: Bill Jiang  DATE: 06/06/06  ECO: *SS - 20060606.1* */

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/* SS - 20060606.1 - B */
/*
1. 标准输入输出
*/
/* SS - 20060606.1 - E */

/* SS - 20060606.1 - B */
{a6ppptrp0701.i "new"}
/* SS - 20060606.1 - E */

/* LD_DET AND TR_HIST RECORDS ARE CREATED IN TEMPORARY TABLES.          */
/* THIS LOGIC PREVENTS LD_DET LOCKING PROBLEM WITH ANY                  */
/* MAINTENANCE FUNCTION USING LD_DET                                    */

/* DISPLAY TITLE */
{mfdtitle.i "2+ "}

/*  DEFINING VARIABLES AS NO-UNDO */

define variable abc    like pt_abc       no-undo.
define variable abc1   like pt_abc       no-undo.
define variable loc    like ld_loc       no-undo.
define variable loc1   like ld_loc       no-undo.
define variable site   like ld_site      no-undo.
define variable site1  like ld_site      no-undo.
define variable part   like pt_part      no-undo.
define variable part1  like pt_part      no-undo.
define variable vend   like pt_vend      no-undo.
define variable vend1  like pt_vend      no-undo.
define variable line   like pt_prod_line no-undo.
define variable line1  like pt_prod_line no-undo.

define variable ext_std as decimal label "Ext GL Cost"
   format "->>>,>>>,>>9.99" no-undo.
define variable ptloc_ext_std as decimal
   format "->>>,>>>,>>9.99" no-undo.

define variable neg_qty       like mfc_logical initial yes
   label "Include Negative Inventory" no-undo.
define variable net_qty       like mfc_logical initial yes
   label "Include Non-nettable Inventory" no-undo.
define variable inc_zero_qty  like mfc_logical initial no
   label "Include Zero Quantity" no-undo.
define variable zero_cost     like mfc_logical initial yes
   label "Accept Zero Initial Cost" no-undo.
define variable l_recalculate like mfc_logical initial no
   label "Recalculate Deleted Locations" no-undo.

define variable total_qty_oh      like in_qty_oh  no-undo.
define variable parts_printed     as   integer    no-undo.
define variable locations_printed as   integer    no-undo.
define variable as_of_date        like tr_effdate no-undo.

define variable tr_recno      as   recid        no-undo.
define variable trrecno       as   recid        no-undo.
define variable std_as_of     like glxcst       no-undo.
define variable part_group    like pt_group     no-undo.
define variable part_group1   like pt_group     no-undo.
define variable part_type     like pt_part_type no-undo.
define variable part_type1    like pt_part_type no-undo.
define variable cst_date      like tr_effdate   no-undo.

define variable l_msg1 as character format "x(64)" no-undo.
define variable l_msg2 as character format "x(64)" no-undo.

define variable loc_ext_std  like ext_std     no-undo.
define variable site_ext_std like ext_std     no-undo.
define variable tot_ext_std  like ext_std     no-undo.
define variable l_nettable   like mfc_logical no-undo.
define variable l_avail_stat like mfc_logical no-undo.
define variable l_non_consign_qoh like in_qty_oh no-undo.

define buffer trhist for tr_hist.

/* CONSIGNMENT VARIABLES */
{pocnvars.i}
{pocnvar2.i}

/* TEMP-TABLE STORING QUANTITY ON HAND, ITEM NO. AND LOCATION */
/* FOR A SITE                                                 */
define temp-table t_lddet no-undo
   field t_lddet_site like ld_site
   field t_lddet_part      like ld_part
   field t_lddet_loc       like ld_loc
   field t_lddet_qty       like in_qty_oh
   field t_lddet_avail_stat like mfc_logical
   field t_lddet_net like mfc_logical
   field t_lddet_cust_consign_qty like ld_cust_consign_qty
   field t_lddet_supp_consign_qty like ld_supp_consign_qty
   index t_lddet is primary unique
   t_lddet_site t_lddet_part t_lddet_loc.

/* TEMP-TABLE STORING GL COST, ITEM DESCRIPTION, UM AND ITEM ABC. */
/* FOR ALL SITES                                                  */
define temp-table t_sct no-undo
   field t_sct_part  like pt_part
   field t_sct_desc1     like pt_desc1
   field t_sct_desc2     like pt_desc2
   field t_sct_um        like pt_um
   field t_sct_abc       like in_abc
   field t_sct_std_as_of like std_as_of
   index t_sct is primary unique
   t_sct_part.

/* TEMP-TABLE STORING INVENTORY STATUS TO AVOID MULTIPLE SCANNING */
/* OF IS_MSTR                                                     */
define temp-table t_stat no-undo
   field t_stat_stat like is_status
   field t_stat_net  like is_nettable
   index t_stat is primary unique
   t_stat_stat.

/* PROCEDURE TO FIND THE INVENTORY STATUS IN TEMP TABLE T_STAT   */
/* IF NOT AVAILABLE THEN SEARCH IN IS_MSTR, THIS AVOIDS MULTIPLE */
/* SCANNING OF IS_MSTR                                           */

PROCEDURE ck_status:

   define input  parameter pr_status     like is_status   no-undo.
   define output parameter pr_avail_stat like mfc_logical no-undo.
   define output parameter pr_nettable   like mfc_logical no-undo.

   for first t_stat
      where t_stat_stat = pr_status
   no-lock:
   end. /* FOR FIRST T_STAT */

   if not available t_stat then do:

      for first is_mstr
         fields(is_status is_nettable)
         where is_status = pr_status no-lock:
      end. /* FOR FIRST IS_MSTR */

      if available is_mstr then do:

         create t_stat.
         assign
            t_stat_stat   = is_status
            t_stat_net    = is_nettable
            pr_nettable   = is_nettable
            pr_avail_stat = yes.
      end. /* IF AVAILABLE IS_MSTR */
      else
      assign
         pr_nettable   = no
         pr_avail_stat = no.
   end. /* IF NOT AVAILABLE T_STAT */
   else
   assign
      pr_nettable   = t_stat_net
      pr_avail_stat = yes.

END PROCEDURE. /* PROCEDURE CK_STATUS */

/* SELECT FORM */
form
   part           colon 15
   part1          label {t001.i} colon 49 skip
   line           colon 15
   line1          label {t001.i} colon 49 skip
   vend           colon 15
   vend1          label {t001.i} colon 49 skip
   abc            colon 15
   abc1           label {t001.i} colon 49
   site           colon 15
   site1          label {t001.i} colon 49
   loc            colon 15
   loc1           label {t001.i} colon 49
   part_group     colon 15
   part_group1    label {t001.i} colon 49 skip
   part_type      colon 15
   part_type1     label {t001.i} colon 49 skip(1)
   as_of_date     colon 35
   neg_qty        colon 35 skip
   net_qty        colon 35
   inc_zero_qty   colon 35
   zero_cost      colon 35
   customer_consign   colon 35
   supplier_consign   colon 35
   l_recalculate      colon 35
with frame a side-labels width 80 attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

/* FORM FOR SITE AND LOCATION */
form
   site at 1
   loc  at 15
with frame phead1 side-labels width 132.

setFrameLabels(frame phead1:handle).

/* REPORT BLOCK */

{pxmsg.i
   &MSGNUM = 3715
   &MSGBUFFER = l_msg1
   }
l_msg1 = "* " + l_msg1.
{pxmsg.i
   &MSGNUM = 3716
   &MSGBUFFER = l_msg2
   }
l_msg2 = "* " + l_msg2.

{wbrp01.i}

/* DETERMINE IF CUSTOMER CONSIGNMENT IS ACTIVE */
{gprun.i ""gpmfc01.p""
   "(input ENABLE_CUSTOMER_CONSIGNMENT,
     input 10,
     input ADG,
     input CUST_CONSIGN_CTRL_TABLE,
     output using_cust_consignment)"}

/* DETERMINE IF SUPPLIER CONSIGNMENT IS ACTIVE */
{gprun.i ""gpmfc01.p""
   "(input ENABLE_SUPPLIER_CONSIGNMENT,
     input 11,
     input ADG,
     input SUPPLIER_CONSIGN_CTRL_TABLE,
     output using_supplier_consignment)"}

{gplngn2a.i
   &file = ""cncix_ref""
   &field = ""report""
   &code = customer_consign_code
   &mnemonic = "customer_consign"
   &label    = customer_consign_label}

{gplngn2a.i
   &file = ""cnsix_ref""
   &field = ""report""
   &code = supplier_consign_code
   &mnemonic = "supplier_consign"
   &label    = supplier_consign_label}

repeat:

   if part1 = hi_char then part1 = "".
   if line1 = hi_char then line1 = "".
   if vend1 = hi_char then vend1 = "".
   if abc1 = hi_char then abc1 = "".
   if site1 = hi_char then site1 = "".
   if loc1 = hi_char then loc1 = "".
   if part_group1 = hi_char then part_group1 = "".
   if part_type1 = hi_char then part_type1 = "".
   if as_of_date = ? then as_of_date = today.

   if c-application-mode <> 'web'
   then
      update
         part
         part1
         line
         line1
         vend
         vend1
         abc
         abc1
         site
         site1
         loc
         loc1
         part_group
         part_group1
         part_type
         part_type1
         as_of_date
         neg_qty
         net_qty
         inc_zero_qty
         zero_cost
         customer_consign
         supplier_consign
         l_recalculate
      with frame a.

   {gplngv.i
      &file = ""cncix_ref""
      &field = ""report""
      &mnemonic = "customer_consign"
      &isvalid  = mnemonic_valid}

   if not mnemonic_valid then do:
      {pxmsg.i &MSGNUM=712 &ERRORLEVEL=3} /*INVALID OPTION*/
      next-prompt customer_consign with frame a.
      undo, retry.
   end.

   {gplnga2n.i
      &file = ""cncix_ref""
      &field = ""report""
      &code = customer_consign_code
      &mnemonic = "customer_consign"
      &label    = customer_consign_label}

   {gplngv.i
      &file = ""cnsix_ref""
      &field = ""report""
      &mnemonic = "supplier_consign"
      &isvalid  = mnemonic_valid}

   if not mnemonic_valid then do:
      {pxmsg.i &MSGNUM=712 &ERRORLEVEL=3} /*INVALID OPTION*/
      next-prompt supplier_consign with frame a.
      undo, retry.
   end.

   {gplnga2n.i
      &file = ""cnsix_ref""
      &field = ""report""
      &code = supplier_consign_code
      &mnemonic = "supplier_consign"
      &label    = supplier_consign_label}

   /* ADDED customer_consign, supplier_consign  */

   {wbrp06.i &command = update &fields = "part part1 line line1 vend vend1
        abc abc1 site site1 loc loc1 part_group part_group1 part_type part_type1
        as_of_date neg_qty  net_qty inc_zero_qty   zero_cost
        customer_consign supplier_consign l_recalculate"
      &frm = "a"}

   if using_cust_consignment
      and using_supplier_consignment
      and ((customer_consign_code     = INCLUDE
            and supplier_consign_code = ONLY)
           or(customer_consign_code     = ONLY
              and supplier_consign_code = INCLUDE))
   then do:
      {pxmsg.i &MSGNUM=6425 &ERRORLEVEL=3}
      next-prompt customer_consign with frame a.
      undo, retry.
   end. /* IF using_cust_consignment */

   if (c-application-mode <> 'web') or
      (c-application-mode = 'web' and
      (c-web-request begins 'data')) then do:

      bcdparm = "".
      {mfquoter.i part   }
      {mfquoter.i part1  }
      {mfquoter.i line   }
      {mfquoter.i line1  }
      {mfquoter.i vend   }
      {mfquoter.i vend1  }
      {mfquoter.i abc    }
      {mfquoter.i abc1   }
      {mfquoter.i site   }
      {mfquoter.i site1  }
      {mfquoter.i loc    }
      {mfquoter.i loc1   }
      {mfquoter.i part_group  }
      {mfquoter.i part_group1 }
      {mfquoter.i part_type}
      {mfquoter.i part_type1}
      {mfquoter.i as_of_date}
      {mfquoter.i neg_qty}
      {mfquoter.i net_qty}
      {mfquoter.i inc_zero_qty}
      {mfquoter.i zero_cost}
      {mfquoter.i customer_consign}
      {mfquoter.i supplier_consign}
      {mfquoter.i l_recalculate}

      if part1 = "" then part1 = hi_char.
      if line1 = "" then line1 = hi_char.
      if vend1 = "" then vend1 = hi_char.
      if abc1 = "" then abc1 = hi_char.
      if site1 = "" then site1 = hi_char.
      if loc1 = "" then loc1 = hi_char.
      if part_group1 = "" then part_group1 = hi_char.
      if part_type1 = "" then part_type1 = hi_char.
      if as_of_date = ? then as_of_date = today.
   end.

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
   /* SS - 20060606.1 - B */
   /*
   {mfphead.i}

   form
      header
      l_msg1

   with frame pagefoot page-bottom width 132.

   form
      header
      l_msg2

   with frame pagefoot1 page-bottom width 132.

   hide frame pagefoot.
   hide frame pagefoot1.
   if net_qty then view frame pagefoot.
   else view frame pagefoot1.

   /*TEMPORARILY RE-CREATE ANY NON-PERMANENT LD_DET RECORDS*/

   /* INITIALIZING TEMP-TABLES T_LDDET T_SCT AND T_STAT */
   for each t_lddet exclusive-lock:
      delete t_lddet.
   end. /* FOR EACH T_LDDET */

   for each t_sct exclusive-lock:
      delete t_sct.
   end. /* FOR EACH T_SCT */

   for each t_stat exclusive-lock:
      delete t_stat.
   end. /* FOR EACH T_STAT */

   assign
      cust_consign_qty = 0
      ext_std      = 0
      loc_ext_std  = 0
      site_ext_std = 0
      tot_ext_std  = 0.

   for each in_mstr
      fields(in_part in_site in_abc in_cur_set in_gl_set in_gl_cost_site)
      use-index in_site
   no-lock
      where (in_part >= part and in_part <= part1)
      and   (in_site >= site and in_site <= site1)
      and   (in_abc  >= abc  and in_abc  <= abc1 ),
      first pt_mstr
         fields(pt_part pt_group pt_part_type pt_prod_line
                pt_vend pt_desc1 pt_desc2 pt_um)
      no-lock
         where pt_part = in_part
         and   (pt_group     >= part_group and pt_group     <= part_group1)
         and   (pt_part_type >= part_type  and pt_part_type <= part_type1)
         and   (pt_prod_line >= line       and pt_prod_line <= line1)
         and   (can-find(first ptp_det use-index ptp_part
                   where ptp_part   = pt_part
                   and   ptp_site   = in_site
                   and   (ptp_vend >= vend and ptp_vend <= vend1))
               or (not can-find(first ptp_det use-index ptp_part
                          where ptp_part   = pt_part
                          and   ptp_site   = in_site)
                          and   (pt_vend  >= vend and pt_vend  <= vend1)))
   break by in_site by in_part with frame b width 132:

      /* SET EXTERNAL LABELS */
      setFrameLabels(frame b:handle).

      for first t_sct
         where t_sct_part = in_part no-lock:
      end. /* FOR FIRST T_SCT */

      if not available t_sct then do:

         assign
            ext_std   = 0
            std_as_of = 0.

         /* FIND THE STANDARD COST AS OF DATE */
         {ppptrp6a.i}

         create t_sct.
         assign
            t_sct_part      = in_part
            t_sct_desc1     = pt_desc1
            t_sct_desc2     = pt_desc2
            t_sct_um        = pt_um
            t_sct_abc       = in_abc
            t_sct_std_as_of = std_as_of.
      end. /* IF NOT AVAILABLE T_SCT */

      for each ld_det
            no-lock
            where ld_part = pt_part
            and   ld_site = in_site
            and   (ld_loc >= loc and ld_loc <= loc1):

         find first t_lddet exclusive-lock
            where t_lddet_part = ld_part
            and   t_lddet_site = ld_site
            and   t_lddet_loc  = ld_loc no-error.

         if not available t_lddet then do:

            create t_lddet.
            assign
               t_lddet_site = ld_site
               t_lddet_cust_consign_qty = ld_cust_consign_qty
               t_lddet_supp_consign_qty = ld_supp_consign_qty
               t_lddet_part = ld_part
               t_lddet_loc  = ld_loc.
         end. /* IF NOT AVAILABLE T_LDDET */

         run ck_status(input  ld_status,
            output l_avail_stat,
            output l_nettable).

         if net_qty = yes or not l_avail_stat
            or (l_avail_stat and l_nettable) then
            t_lddet_qty = t_lddet_qty + ld_qty_oh.

      end. /* FOR EACH LD_DET */

      /* ADDED tr_hist LOOP TO CREATE TEMP-TABLE t_lddet FOR ITEMS */
      /* HAVING ZERO QOH FOR WHICH ld_det DOES NOT EXIST. */

      if l_recalculate
      then do:

         for each tr_hist
            fields(tr_part tr_site tr_loc tr_status tr_ship_type
                   tr_lot tr_ref tr_qty_loc tr_effdate)
         no-lock
            where tr_part       = pt_part
            and   tr_site       = in_site
            and   tr_effdate   >= as_of_date
            and   tr_ship_type  = ""
            and   tr_loc       >= loc
            and   tr_loc       <= loc1
            and   not can-find(first ld_det
                         where ld_part = pt_part
                         and   ld_site = in_site
                         and   ld_loc  = tr_loc)
         break by tr_part by tr_site by tr_loc :

            if first-of(tr_loc)
            then do:

               find first t_lddet
                  where t_lddet_part = tr_part
                  and   t_lddet_site = tr_site
                  and   t_lddet_loc  = tr_loc
               exclusive-lock no-error.

               if not available t_lddet
               then do:
                  create t_lddet.
                  assign
                     t_lddet_site = tr_site
                     t_lddet_part = tr_part
                     t_lddet_loc  = tr_loc
                     t_lddet_qty  = 0.
               end. /* IF NOT AVAILABLE t_lddet */

            end. /* IF first-of(tr_loc) */

         end.  /* FOR EACH tr_hist.. */

      end. /* IF l_recalculate */

      if last-of(in_site) then do:

         locations_printed = 0.

         for each t_lddet exclusive-lock
               where t_lddet_site = in_site
               break by t_lddet_loc by t_lddet_part
            with frame b width 132:

            /* SET EXTERNAL LABELS */
            setFrameLabels(frame b:handle).

            if first-of(t_lddet_part) then
            assign
               tot_cust_consign_qty = 0
               tot_supp_consign_qty = 0
               total_qty_oh         = 0
               l_non_consign_qoh    = 0.

            if first-of(t_lddet_loc) then
               parts_printed = 0.

             l_non_consign_qoh = l_non_consign_qoh
                                 + t_lddet_qty
                                 - t_lddet_cust_consign_qty
                                 - t_lddet_supp_consign_qty.

            /* THE VARIABLES total_qty_oh,tot_cust_consign_qty AND    */
            /* tot_supp_consign_qty ARE CALCULATED TO STORE THE       */
            /* QUANTITY ON HAND, CUSTOMER CONSIGNED QTY               */
            /* AND SUPPLIER CONSIGNED QTY RESPECTIVELY.               */

            if net_qty = yes or not t_lddet_avail_stat
               or (t_lddet_avail_stat and t_lddet_net)
            then do:

               total_qty_oh = total_qty_oh + t_lddet_qty.

               /*DETERMINE CONSIGNMENT QUANTITIES */
               if using_cust_consignment
               then
                  tot_cust_consign_qty = tot_cust_consign_qty
                                       + t_lddet_cust_consign_qty.

               if using_supplier_consignment
               then
                  tot_supp_consign_qty = tot_supp_consign_qty
                                         + t_lddet_supp_consign_qty.

            end. /* IF net_qty = yes OR NOT t_lddet_avail_status */

            /*FIND THE STANDARD COST AS OF DATE*/

            for first t_sct
               where t_sct_part = t_lddet_part
            no-lock:
            end. /* FOR FIRST t_sct */

            /* PRINTS SUMMARIZED QTY FOR AN ITEM IN A LOCATION */
            if last-of(t_lddet_part)
            then do:
               /* BACK OUT TR_HIST AFTER AS-OF DATE */
               for each tr_hist
                  fields(tr_part tr_effdate tr_site tr_loc tr_ship_type
                  tr_nbr tr_line tr_serial tr_ref
                  tr_qty_loc tr_bdn_std tr_lbr_std tr_mtl_std tr_ovh_std
                  tr_price tr_status tr_sub_std tr_trnbr tr_type tr_rmks)
                  where tr_part    = t_lddet_part
                  and   tr_effdate > as_of_date
                  and   tr_site    = t_lddet_site
                  and   tr_loc     = t_lddet_loc
                  and   tr_ship_type = ""
               no-lock:

                  if tr_qty_loc = 0
                     and tr_type <> "CN-SHIP"
                     and tr_type <> "CN-USE"
                  then
                     next.

                  run ck_status(input  tr_status,
                                output l_avail_stat,
                                output l_nettable).

                  if (net_qty = yes
                     or not l_avail_stat
                     or (l_avail_stat
                     and l_nettable))
                  then
                     total_qty_oh = total_qty_oh - tr_qty_loc.

                  /* NOTE: CN-ADJ DOES NOT UPDATE THE tr_qty_loc AND NO */
                  /* OTHER TRANSACTIONS ARE CREATED LIKE THOSE CREATED  */
                  /* AT THE TIME OF CN-SHIP OR CN-USE                   */

                  if (tr_type = "CN-ADJ"
                      and tr_program = "socnadj.p")
                  then
                     tot_cust_consign_qty = tot_cust_consign_qty
                                             - tr_qty_loc.
                  else
                  if tr_type = "CN-SHIP"
                     or tr_type = "CN-USE"
                  then do:
                     for first trhist
                        fields(tr_trnbr tr_qty_loc)
                        where trhist.tr_trnbr = integer(tr_hist.tr_rmks)
                     no-lock:
                        assign
                           tot_cust_consign_qty = tot_cust_consign_qty
                                                 - trhist.tr_qty_loc
                           l_non_consign_qoh    = l_non_consign_qoh
                                                  + trhist.tr_qty_loc.
                     end. /* FOR FIRST trhist */
                  end. /* IF tr_type = CN-SHIP */
                  else
                  if (tr_type = "CN-RCT"
                     or tr_type = "CN-ISS"
                     or (tr_type = "CN-ADJ"
                     and tr_program = "pocnadj.p"))
                  then
                     tot_supp_consign_qty  = tot_supp_consign_qty
                                             - tr_qty_loc.
                  else
                      l_non_consign_qoh = l_non_consign_qoh  - tr_qty_loc.

               end. /* FOR EACH tr_hist */

               /* SINCE THE VALUES IN THE VARIABLES total_qty_oh,        */
               /* tot_cust_consign_qty and tot_supp_consign_qty HAVE     */
               /* QTY ON HAND, CUSTOMER CONSIGNED AND SUPPLIER CONSIGNED */
               /* QTY RESPECTIVELY,THE CONSIGNED QTY VARIABLES ARE ADDED */
               /* SUBTRACTED IN CASE OF 'EXCLUDE' FROM total_qty_oh OR   */
               /* ASSIGNED TO total_qty_oh IN CASE OF 'ONLY' AND IN CASE */
               /* INCLUDE THE VARIABLES ARE DISPLAYED ITSELF BECAUSE     */
               /* THEY HAVE THE RESPECTIVE VALUES.                       */

               if using_cust_consignment
               then do:
                  if customer_consign_code = EXCLUDE
                  then
                     total_qty_oh = total_qty_oh - tot_cust_consign_qty.

                  if customer_consign_code = ONLY
                  then
                     total_qty_oh = tot_cust_consign_qty.

               end. /* IF using_cust_consignment... */

               if using_supplier_consignment
               then do:

                  if supplier_consign_code = EXCLUDE
                  then do:
                     if (not using_cust_consignment and
                         customer_consign_code = ONLY)
                     or (using_cust_consignment and
                         customer_consign_code <> ONLY)
                     then
                        total_qty_oh = total_qty_oh - tot_supp_consign_qty.
                  end. /* IF supplier_consign_code = EXCLUDE */

                  if supplier_consign_code = ONLY
                  then
                     total_qty_oh = tot_supp_consign_qty.

               end. /* IF using_supplier_consignment... */

               if using_supplier_consignment
                  and using_cust_consignment
               then do:

                  /* IF BOTH CUSTOMER AND SUPPLIER CONSIGNEMENT ARE ENABLED   */
                  /* AND BOTH supplier_consign_code AND customer_consign_code */
                  /* "ARE ONLY" THEN total_qty_oh WOULD BE SUM OF THE         */
                  /* tot_supp_consign_qty AND tot_cust_consign_qty            */

                   if supplier_consign_code  = ONLY
                   and customer_consign_code = ONLY
                   then
                      total_qty_oh = tot_supp_consign_qty +
                                     tot_cust_consign_qty.
               end. /* IF using_supplier_consignment AND   */


               /* CALCULATE THE EXTENDED COST BASED ON TOTAL QTY ON-HAND */
               assign
                  ext_std       = round(total_qty_oh * t_sct_std_as_of, 2)
                  ptloc_ext_std = round(total_qty_oh * t_sct_std_as_of, 2).

               /* THE CONDITION FOR CHECKING total_qty_oh HAS BEEN MOVED */
               /* FROM ABOVE BECAUSE total_qty_oh WOULD HAVE THE CORRECT */
               /* VALUE ONLY AFTER BACKING OUT THE QTY.                  */

               if total_qty_oh     > 0
                  or (total_qty_oh = 0
                      and inc_zero_qty)
                  or (total_qty_oh < 0
                      and neg_qty)
                  or (tot_cust_consign_qty <> 0
                      or tot_supp_consign_qty <> 0)
               then do:

                  if parts_printed = 0
                  then do:
                     page.

                     /* REMOVED VIEW FRAME BECAUSE SITE AND LOCATION IS NOT */
                     /* PRINTED ON THE First PAGE DUE TO THE INTRODUCTION   */
                     /* OF if last-of(t_lddet_part) BELOW, BEFORE PRINTING  */
                     /* THE DETAIL                                          */
                     display
                        in_site     @ site
                        t_lddet_loc @ loc
                     with frame phead1 side-labels.

                  end. /* IF PARTS_PRINTED = 0 */

                  display
                     t_lddet_part
                     t_sct_desc1 + " " +
                     t_sct_desc2 format "x(49)" @ pt_desc1
                     t_sct_abc
                     total_qty_oh @ t_lddet_qty
                     t_sct_um
                     t_sct_std_as_of
                     ptloc_ext_std @ ext_std.
                  down.

                  parts_printed = parts_printed + 1.

               end. /* IF total_qty_oh > 0 OR ... */

               loc_ext_std   = loc_ext_std + ext_std.

               if tot_cust_consign_qty <> 0
                  or tot_supp_consign_qty <> 0
               then do:

                  underline t_lddet_qty.

                  if l_non_consign_qoh <> 0
                  then do:
                     down 1.
                     display
                        getTermLabelRtColon("NON-CONSIGNED",19) @ pt_desc1
                        l_non_consign_qoh @ t_lddet_qty.
                  end. /* IF l_non_consign_qoh <> 0 */

                  if tot_cust_consign_qty <> 0
                  then do:
                     down 1.
                     display
                        getTermLabelRtColon("CUSTOMER_CONSIGNED",19) @ pt_desc1
                        tot_cust_consign_qty @ t_lddet_qty.
                  end.  /* IF tot_cust_consign_qty <> 0 */

                  if tot_supp_consign_qty <> 0
                  then do:
                     down 1.
                     display
                        getTermLabelRtColon("SUPPLIER_CONSIGNED",19) @ pt_desc1
                        tot_supp_consign_qty @ t_lddet_qty.
                  end.  /* IF tot_supp_consign_qty <> 0 */

                  down 1.
               end.  /* IF tot_cust_consign_qty <> 0 ...*/
            end. /* IF LAST-OF(t_lddet_part) */

            if last-of(t_lddet_loc)
            then do:
               if parts_printed >= 1
               then do:
                  if line-counter > page-size - 4
                  then
                     page.

                  underline ext_std.
                  down 1.
                  display
                     caps(getTermLabel("LOCATION_TOTAL",15)) format "x(15)"
                         @ t_sct_std_as_of
                     loc_ext_std @ ext_std.
                  down 1.

                  assign
                     site_ext_std = site_ext_std + loc_ext_std
                     loc_ext_std  = 0.

                  locations_printed = locations_printed + 1.
               end. /* IF parts_printed >= 1 */
            end. /* IF LAST-OF(t_lddet_loc) */

            if last(t_lddet_loc)
            then do:
               if locations_printed >= 1
               then do:
                  if line-counter > page-size - 4
                  then
                     page.

                  underline ext_std.
                  down 1.
                  display
                     caps(getTermLabel("SITE_TOTAL",15)) format "x(15)"
                         @ t_sct_std_as_of
                     site_ext_std @ ext_std.
                  down 1.

                  assign
                     tot_ext_std  = tot_ext_std + site_ext_std
                     site_ext_std = 0.

               end. /* IF locations_printed >= 1 */
            end. /* IF LAST(t_lddet_loc) */

            delete t_lddet.

         end. /* FOR EACH T_LDDET */

         if last(in_site) then do:

            if line-counter > page-size - 4 then page.

            underline ext_std.
            down 1.
            display
               caps(getTermLabel("REPORT_TOTAL",15))
                  format "x(15)" @ t_sct_std_as_of
               tot_ext_std @ ext_std.
            down 1.

            tot_ext_std = 0.

         end. /* IF LAST(IN_SITE) */

         /* DELETING TEMP-TABLE STORING GL COST AND ABC */
         for each t_sct exclusive-lock:
            delete t_sct.
         end. /* FOR EACH T_SCT */

      end. /* IF LAST-OF(IN_SITE) */

      {mfrpchk.i}
   end. /* FOR EACH IN_MSTR */

   /* REPORT TRAILER */
   {mfrtrail.i}
   */
   PUT UNFORMATTED "BEGIN: " + STRING(TIME, "HH:MM:SS") SKIP.

   FOR EACH tta6ppptrp0701:
       DELETE tta6ppptrp0701.
   END.

   {gprun.i ""a6ppptrp0701.p"" "(
      INPUT part,
      INPUT part1,
      INPUT LINE,
      INPUT line1,
      INPUT vend,
      INPUT vend1,
      INPUT abc,
      INPUT abc1,
      INPUT site,
      INPUT site1,
      INPUT loc,
      INPUT loc1,
      INPUT part_group,
      INPUT part_group1,
      INPUT part_type,
      INPUT part_type1,

      INPUT AS_of_date,
      INPUT neg_qty,
      INPUT net_qty,
      INPUT inc_zero_qty,
      INPUT zero_cost,
      INPUT customer_consign,
      INPUT supplier_consign,
      INPUT l_recalculate
      )"}

   EXPORT DELIMITER ";" "site" "loc" "part" "desc" "abc" "qty" "um" "sct" "ext" "qty_non_consign" "qty_cust_consign" "qty_supp_consign".
   FOR EACH tta6ppptrp0701:
      EXPORT DELIMITER ";" tta6ppptrp0701.
   END.

   PUT UNFORMATTED "END: " + STRING(TIME, "HH:MM:SS") SKIP.

   {a6mfrtrail.i}
   /* SS - 20060606.1 - E */

end. /* REPEAT */

{wbrp04.i &frame-spec = a}
