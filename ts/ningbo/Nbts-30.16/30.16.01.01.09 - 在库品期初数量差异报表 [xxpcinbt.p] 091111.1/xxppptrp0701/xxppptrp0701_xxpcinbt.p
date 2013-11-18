/* ppptrp07.p - INVENTORY VAL AS OF DATE BY LOCATION                        */
/* Copyright 1986-2006 QAD Inc., Carpinteria, CA, USA.                      */
/* All rights reserved worldwide.  This is an unpublished work.             */
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
/* Revision: 1.9.1.11  BY: Patrick Rowan      DATE: 04/24/01 ECO: *P00G*    */
/* Revision: 1.9.1.12  BY: Dan Herman         DATE: 06/06/02 ECO: *P07Y*    */
/* Revision: 1.9.1.14  BY: Paul Donnelly (SB) DATE: 06/28/03 ECO: *Q00K*    */
/* Revision: 1.9.1.15  BY: K Paneesh          DATE: 08/25/03 ECO: *P108*    */
/* Revision: 1.9.1.16  BY: Reena Ambavi       DATE: 12/09/03 ECO: *P1DJ*    */
/* Revision: 1.9.1.17  BY: Reena Ambavi       DATE: 01/08/04 ECO: *P1FX*    */
/* Revision: 1.9.1.18  BY: Reena Ambavi       DATE: 01/21/04 ECO: *Q05F*    */
/* Revision: 1.9.1.19  BY: Manish Dani        DATE: 01/27/04 ECO: *P1LD*    */
/* Revision: 1.9.1.20  BY: Somesh Jeswani     DATE: 07/07/04 ECO: *P28R*    */
/* Revision: 1.9.1.25  BY: Preeti Sattur      DATE: 08/03/04 ECO: *P2D0*    */
/* Revision: 1.9.1.28  BY: Vandna Rohira      DATE: 10/18/04 ECO: *P2NM*    */
/* Revision: 1.9.1.29  BY: Tejasvi Kulkarni   DATE: 11/25/04 ECO: *P2T2*    */
/* Revision: 1.9.1.31  BY: Gaurav Kerkar      DATE: 01/19/05 ECO: *P2SJ*    */
/* Revision: 1.9.1.32  BY: Preeti Sattur      DATE: 04/05/05 ECO: *P3FP*    */
/* Revision: 1.9.1.33  BY: Priya Idnani       DATE: 04/20/05 ECO: *P3HP*    */
/* Revision: 1.9.1.34  BY: Priya Idnani       DATE: 05/07/05 ECO: *P3KJ*    */
/* Revision: 1.9.1.36  BY: Steve Nugent       DATE: 05/11/05 ECO: *P3KV*    */
/* Revision: 1.9.1.37  BY: Alok Gupta         DATE: 06/17/05 ECO: *P3PQ*    */
/* Revision: 1.9.1.38  BY: Sushant Pradhan    DATE: 06/28/05 ECO: *P3PT*    */
/* Revision: 1.9.1.39  BY: Abhishek Jha   DATE: 08/29/05 ECO: *P3ZQ*    */
/* Revision: 1.9.1.40  BY: Bharath Kumar   DATE: 09/12/05 ECO: *P40R*    */
/* Revision: 1.9.1.40.3.1  BY: Masroor Alam   DATE: 06/16/05  ECO: *P4TR*   */
/* $Revision: 1.9.1.40.3.2 $ BY: Ambrose A      DATE: 07/13/06  ECO: *P4XD*   */
/*-Revision end---------------------------------------------------------------*/

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/
/* LD_DET AND TR_HIST RECORDS ARE CREATED IN TEMPORARY TABLES.          */
/* THIS LOGIC PREVENTS LD_DET LOCKING PROBLEM WITH ANY                  */
/* MAINTENANCE FUNCTION USING LD_DET                                    */

/*V8:ConvertMode=FullGUIReport                                              */

/* SS - 091109.1 By: Bill Jiang */

/* SS - 091109.1 - B */
{xxppptrp0701.i}

define input parameter i_part   like pt_part      no-undo.
define input parameter i_part1  like pt_part      no-undo.
define input parameter i_line   like pt_prod_line no-undo.
define input parameter i_line1  like pt_prod_line no-undo.
define input parameter i_vend   like pt_vend      no-undo.
define input parameter i_vend1  like pt_vend      no-undo.
define input parameter i_abc    like pt_abc       no-undo.
define input parameter i_abc1   like pt_abc       no-undo.
define input parameter i_site   like ld_site      no-undo.
define input parameter i_site1  like ld_site      no-undo.
define input parameter i_loc    like ld_loc       no-undo.
define input parameter i_loc1   like ld_loc       no-undo.
define input parameter i_part_group        like pt_group     no-undo.
define input parameter i_part_group1       like pt_group     no-undo.
define input parameter i_part_type         like pt_part_type no-undo.
define input parameter i_part_type1        like pt_part_type no-undo.
define input parameter i_as_of_date        like tr_effdate no-undo.
define input parameter i_neg_qty           like mfc_logical no-undo.
define input parameter i_net_qty           like mfc_logical no-undo.
define input parameter i_inc_zero_qty      like mfc_logical no-undo.
define input parameter i_zero_cost         like mfc_logical no-undo.
define input parameter i_customer_consign as character no-undo.
define input parameter i_supplier_consign as character no-undo.
define input parameter i_l_recalculate like mfc_logical no-undo.
/* SS - 091109.1 - E */

/* DISPLAY TITLE */
/*
{mfdtitle.i "1+ "}
*/
{xxmfdtitle.i "091109.1"}
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
define variable l_recalculate like mfc_logical initial yes
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
define variable l_temp_qty_loc as integer no-undo.

define buffer trhist for tr_hist.

define variable l_cust_consignqty  like in_qty_oh no-undo.
define variable l_supp_consignqty  like in_qty_oh no-undo.
define variable l_trnbr            like tr_trnbr no-undo.

/* THE NEXT 1 LINE WILL BE REMOVED WHEN */
/* tr_qty_lotserial IS IN THE SCHEMA.   */
define variable tr_qty_lotserial like tr_qty_loc no-undo.

/* CONSIGNMENT VARIABLES */
{pocnvars.i}
{pocnvar2.i}

/* TEMP-TABLE STORING QUANTITY ON HAND, ITEM NO. AND LOCATION */
/* FOR A SITE                                                 */
define temp-table t_lddet no-undo
   field t_lddet_site like ld_site
   field t_lddet_part      like ld_part
   field t_lddet_loc       like ld_loc
   /* SS - 091109.1 - B */
   field t_lddet_lot       like ld_lot
   field t_lddet_ref       like ld_ref
   /* SS - 091109.1 - E */
   field t_lddet_qty       like in_qty_oh
   field t_lddet_avail_stat like mfc_logical
   field t_lddet_net like mfc_logical
   field t_lddet_cust_consign_qty like ld_cust_consign_qty
   field t_lddet_supp_consign_qty like ld_supp_consign_qty
   index t_lddet is primary unique

   t_lddet_site t_lddet_part t_lddet_loc
   /* SS - 091109.1 - B */
   t_lddet_lot
   t_lddet_ref
   /* SS - 091109.1 - E */
   .

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
         fields( is_domain is_status is_nettable)
          where is_mstr.is_domain = global_domain and  is_status = pr_status
          no-lock:
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

/* SS - 091109.1 - B */
ASSIGN
   part = i_part
   part1 = i_part1
   line = i_line
   line1 = i_line1
   vend = i_vend
   vend1 = i_vend1
   abc = i_abc
   abc1 = i_abc1
   site = i_site
   site1 = i_site1
   loc = i_loc
   loc1 = i_loc1
   part_group = i_part_group
   part_group1 = i_part_group1
   part_type = i_part_type
   part_type1 = i_part_type1
   as_of_date = i_as_of_date
   neg_qty = i_neg_qty
   net_qty = i_net_qty
   inc_zero_qty = i_inc_zero_qty
   zero_cost = i_zero_cost
   /*
   customer_consign = i_customer_consign
   supplier_consign = i_supplier_consign
   */
   l_recalculate = i_l_recalculate 
   .
/* SS - 091109.1 - E */

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

/* SS - 091109.1 - B
repeat:
SS - 091109.1 - E */

   if part1 = hi_char then part1 = "".
   if line1 = hi_char then line1 = "".
   if vend1 = hi_char then vend1 = "".
   if abc1 = hi_char then abc1 = "".
   if site1 = hi_char then site1 = "".
   if loc1 = hi_char then loc1 = "".
   if part_group1 = hi_char then part_group1 = "".
   if part_type1 = hi_char then part_type1 = "".
   if as_of_date = ? then as_of_date = today.

   /* SS - 091109.1 - B
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
   SS - 091109.1 - E */

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

   /* SS - 091109.1 - B
   {wbrp06.i &command = update &fields = "part part1 line line1 vend vend1
        abc abc1 site site1 loc loc1 part_group part_group1 part_type part_type1
        as_of_date neg_qty  net_qty inc_zero_qty   zero_cost
        customer_consign supplier_consign l_recalculate"
      &frm = "a"}
   SS - 091109.1 - E */

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

   /* SS - 091109.1 - B
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
   SS - 091109.1 - E */

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
      fields(in_domain in_part in_site in_abc in_cur_set in_gl_set
             in_gl_cost_site)
      use-index in_site
   no-lock
      where in_mstr.in_domain = global_domain
      and  ((in_part >= part and in_part <= part1)
      and   (in_site >= site and in_site <= site1)
      and   (in_abc  >= abc  and in_abc  <= abc1 )),
      first pt_mstr
         fields(pt_domain pt_part pt_group pt_part_type pt_um
                pt_desc1 pt_desc2 pt_prod_line pt_vend)
      no-lock
         where pt_mstr.pt_domain = global_domain
         and   (pt_part          = in_part
         and   (pt_group     >= part_group and pt_group     <= part_group1)
         and   (pt_part_type >= part_type  and pt_part_type <= part_type1)
         and   (pt_prod_line >= line       and pt_prod_line <= line1)
         and   (can-find(first ptp_det use-index ptp_part
                   where ptp_det.ptp_domain = global_domain
                   and   (ptp_part          = pt_part
                   and   ptp_site           = in_site
                   and   (ptp_vend >= vend and ptp_vend <= vend1)))
               or (not can-find(first ptp_det use-index ptp_part
                          where ptp_det.ptp_domain = global_domain
                          and   ptp_part           = pt_part
                          and   ptp_site           = in_site)
                          and   (pt_vend  >= vend and pt_vend  <= vend1))))
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

      for last tr_hist
         where tr_domain = global_domain
         and   tr_trnbr >= 0
      no-lock :
      end.
      if available tr_hist then
         l_trnbr = tr_trnbr .


      for each ld_det
            no-lock
             where ld_det.ld_domain = global_domain and  ld_part = pt_part
            and   ld_site = in_site
            and   (ld_loc >= loc and ld_loc <= loc1):

         find first t_lddet exclusive-lock
            where t_lddet_part = ld_part
            and   t_lddet_site = ld_site
            and   t_lddet_loc  = ld_loc 
            /* SS - 091109.1 - B */
            AND t_lddet_lot = ld_lot
            AND t_lddet_ref = ld_ref
            /* SS - 091109.1 - E */
            no-error.

         if not available t_lddet then do:
            create t_lddet.
            assign
               t_lddet_site             = ld_site
               t_lddet_cust_consign_qty = ld_cust_consign_qty
               t_lddet_supp_consign_qty = ld_supp_consign_qty
               t_lddet_part             = ld_part
               t_lddet_loc              = ld_loc
               /* SS - 091109.1 - B */
               t_lddet_lot = ld_lot
               t_lddet_ref = ld_ref
               /* SS - 091109.1 - E */
               .
         end.
         else
            assign
               t_lddet_cust_consign_qty = t_lddet_cust_consign_qty
                                        + ld_cust_consign_qty
               t_lddet_supp_consign_qty = t_lddet_supp_consign_qty
                                        + ld_supp_consign_qty.

         run ck_status(input  ld_status,
            output l_avail_stat,
            output l_nettable).

         if net_qty = yes or not l_avail_stat
            or (l_avail_stat and l_nettable) then
            t_lddet_qty = t_lddet_qty + ld_qty_oh.

      end. /* FOR EACH LD_DET */

      /* ADDED tr_hist LOOP TO CREATE TEMP-TABLE t_lddet FOR ITEMS  */
      /* HAVING ZERO QOH FOR WHICH ld_det DOES NOT EXIST. */

      if l_recalculate
      then do:
         for each tr_hist
            fields(tr_domain tr_part tr_site tr_loc 
                   /* SS - 091109.1 - B */
                   tr_serial
                   tr_ref
                   /* SS - 091109.1 - E */
                   tr_status tr_ship_type
                   tr_lot tr_ref tr_qty_loc tr_effdate )
         no-lock
            where tr_domain     = global_domain
            and   tr_part       = pt_part
            and   tr_site       = in_site
            and   tr_effdate   >= as_of_date
            and   tr_ship_type  = ""
            and   tr_loc       >= loc
            and   tr_loc       <= loc1
            and   not can-find(first ld_det
                         where ld_domain = global_domain
                         and   ld_part   = pt_part
                         and   ld_site   = in_site
                         and   ld_loc    = tr_loc
                         /* SS - 091109.1 - B */
                         AND ld_lot = tr_serial
                         AND ld_ref = tr_ref
                         /* SS - 091109.1 - E */
                         )
         break by tr_part by tr_site by tr_loc 
            /* SS - 091109.1 - B */
            BY tr_serial
            BY tr_ref
            /* SS - 091109.1 - E */
            :

            if first-of(
               /* SS - 091109.1 - B
               tr_loc
               SS - 091109.1 - E */
               /* SS - 091109.1 - B */
               tr_ref
               /* SS - 091109.1 - E */
               )
            then do:

               find first t_lddet
                  where t_lddet_part = tr_part
                  and   t_lddet_site = tr_site
                  and   t_lddet_loc  = tr_loc
                  /* SS - 091109.1 - B */
                  AND t_lddet_lot = tr_serial
                  AND t_lddet_ref = tr_ref
                  /* SS - 091109.1 - E */
               exclusive-lock no-error.

               if not available t_lddet
               then do:
                  create t_lddet.
                  assign
                     t_lddet_site = tr_site
                     t_lddet_part = tr_part
                     t_lddet_loc  = tr_loc
                     /* SS - 091109.1 - B */
                     t_lddet_lot = tr_serial
                     t_lddet_ref = tr_ref
                     /* SS - 091109.1 - E */
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
            /* SS - 091109.1 - B */
            BY t_lddet_lot
            BY t_lddet_ref
            /* SS - 091109.1 - E */
            with frame b width 132:

            /* SET EXTERNAL LABELS */
            setFrameLabels(frame b:handle).

            if first-of(
               /* SS - 091109.1 - B
               t_lddet_part
               SS - 091109.1 - E */
               /* SS - 091109.1 - B */
               t_lddet_ref
               /* SS - 091109.1 - E */
               ) then
            assign
               tot_cust_consign_qty = 0
               tot_supp_consign_qty = 0
               total_qty_oh         = 0
               l_non_consign_qoh    = 0
               l_supp_consignqty    = 0
               l_cust_consignqty    = 0.

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

            end. /* If net_qty = yes or not t_lddet_avail_status */

            /*FIND THE STANDARD COST AS OF DATE*/

            for first t_sct
               where t_sct_part = t_lddet_part
            no-lock:
            end. /* FOR FIRST t_sct */

            /* PRINTS SUMMARIZED QTY FOR AN ITEM IN A LOCATION */
            if last-of(
               /* SS - 091109.1 - B
               t_lddet_part
               SS - 091109.1 - E */
               /* SS - 091109.1 - B */
               t_lddet_ref
               /* SS - 091109.1 - E */
               )
            then do:
               /* BACK OUT TR_HIST AFTER AS-OF DATE */
               for each tr_hist
                  fields(tr_domain tr_part tr_effdate tr_site tr_loc
                         /* SS - 091109.1 - B */
                         tr_serial
                         tr_ref
                         /* SS - 091109.1 - E */
                  tr_ship_type tr_nbr tr_line tr_serial tr_ref tr_rev
                  tr_qty_loc tr_bdn_std tr_lbr_std tr_mtl_std tr_ovh_std
                  tr_price tr_status tr_sub_std tr_trnbr tr_type tr_rmks
                  tr_program)
                  where tr_hist.tr_domain = global_domain
                  and   tr_part      = t_lddet_part
                  and   tr_effdate   > as_of_date
                  and   tr_site      = t_lddet_site
                  and   tr_loc       = t_lddet_loc
                  /* SS - 091109.1 - B */
                  AND tr_serial = t_lddet_lot
                  AND tr_ref = t_lddet_ref
                  /* SS - 091109.1 - E */
                  and   tr_trnbr    <= l_trnbr
                  and   tr_ship_type = ""
               no-lock:

                  /* NEXT SECTION WILL BE REMOVED WHEN   */
                  /*  tr_qty_lotserial  IS IN THE SCHEMA */
                  tr_qty_lotserial = 0.
                  {gpextget.i &OWNER = 'T2:T3'
                              &TABLENAME = 'tr_hist'
                              &REFERENCE = 'lotSerialQty'
                              &KEY1      = tr_hist.tr_domain
                              &KEY2      = string(tr_hist.tr_trnbr)
                              &DEC1      = tr_qty_lotserial}

                  if tr_qty_loc = 0
                     and tr_type <> "CN-SHIP"
                     and tr_type <> "CN-USE"
                     and tr_type <> "CN-ADJ"
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
                     if tr_type <> "CN-ADJ"
                     then
                        total_qty_oh = total_qty_oh - tr_qty_loc.

                  /* NOTE: CN-ADJ DOES NOT UPDATE THE tr_qty_loc AND NO */
                  /* OTHER TRANSACTIONS ARE CREATED LIKE THOSE CREATED  */
                  /* AT THE TIME OF CN-SHIP OR CN-USE                   */

                  if (tr_type = "CN-ADJ"
                      and tr_program = "socnadj.p")
                  then
                     tot_cust_consign_qty = tot_cust_consign_qty
                                          - tr_qty_lotserial.
                  else
                  if tr_type = "CN-SHIP"
                     or tr_type = "CN-USE"
                  then do:
                     for first trhist
                        fields(tr_domain tr_trnbr tr_qty_loc)
                        where trhist.tr_domain = global_domain
                        and   trhist.tr_trnbr  = integer(tr_hist.tr_rmks)
                     no-lock:
                        l_temp_qty_loc = trhist.tr_qty_loc.
                     end. /* FOR FIRST trhist */

                     for first trhist
                        fields(tr_domain tr_trnbr tr_type tr_rmks)
                        where trhist.tr_domain      = global_domain
                        and   trhist.tr_trnbr       > integer(tr_hist.tr_rmks)
                        and  (trhist.tr_type        = "CN-USE" or
                              trhist.tr_type        = "CN-SHIP")
                        and integer(trhist.tr_rmks) = integer(tr_hist.tr_rmks)
                     no-lock:
                        if trhist.tr_trnbr = tr_hist.tr_trnbr
                        then do:
                           assign
                              tot_cust_consign_qty = tot_cust_consign_qty
                                                     - l_temp_qty_loc
                              l_non_consign_qoh    = l_non_consign_qoh
                                                     + l_temp_qty_loc.
                        end. /* IF trhist.tr_trnbr.. */
                     end. /* FOR FIRST trhist */
                  end. /* IF tr_type = CN-SHIP */
                  else
                  if tr_type = "ISS-TR"
                  then do:
                     /* FIRST ADD TRANSFER QTY TO NON-CONSIGNED INVENTORY. */
                     /* tr_qty_loc IS NEGATIVE FOR ISS-TR TRANSACTIONS.    */
                     l_non_consign_qoh = l_non_consign_qoh - tr_qty_loc.

                     /* NEXT, FIND OUT IF THE TRANSFER IS A SUPPLIER */
                     /* CONSIGNMENT TRANSFER WITHOUT CHANGE OF       */
                     /* OWNERSHIP. IF SO, THEN UPDATE SUPPLIER       */
                     /* CONSIGNMENT AND NON-CONSIGNMENT INVENTORY.   */
                     /* IN THE CASE OF A SUPPLIER CONSIGNED TRANSFER */
                     /* WITHOUT OWNERSHIP CHANGE, THE TRANSACTION    */
                     /* HISTORY NUMBER AND THE TRANSFER QTY WILL BE  */
                     /* STORED IN THE tr_rev FIELD OF THE RCT-TR.    */
                     for first trhist
                         fields(tr_trnbr tr_qty_loc tr_rev tr_type tr_effdate)
                         where trhist.tr_domain = global_domain
                           and trhist.tr_trnbr > tr_hist.tr_trnbr
                           and trhist.tr_type = "RCT-TR"
                           and trhist.tr_effdate = tr_hist.tr_effdate
                                          and
                    integer(substring(trhist.tr_rev,1,index(tr_rev," ") - 1)) =
                    tr_hist.tr_trnbr
                    no-lock:

                    assign
                       tot_supp_consign_qty = tot_supp_consign_qty +
                       decimal(trim(substring(trhist.tr_rev,index(trhist.tr_rev," ") + 1,length(trhist.tr_rev,"RAW"))))
                       l_non_consign_qoh = l_non_consign_qoh -
                       decimal(trim(substring(trhist.tr_rev,index(trhist.tr_rev," ") + 1,length(trhist.tr_rev,"RAW")))).
                     end. /* FOR FIRST trhist */
                  end. /* IF tr_type = "ISS-TR" */
                  else
                  if tr_type = "RCT-TR"
                  then do:
                     /* FIRST BACK OUT TRANSFER QTY FROM NON-CONSIGNED */
                     /* INVENTORY.                                     */
                     l_non_consign_qoh = l_non_consign_qoh - tr_qty_loc.

                     /* NEXT, FIND OUT IF THE TRANSFER IS A SUPPLIER */
                     /* CONSIGNMENT TRANSFER WITHOUT CHANGE OF       */
                     /* OWNERSHIP. IF SO, THEN UPDATE SUPPLIER       */
                     /* CONSIGNMENT AND NON-CONSIGNMENT INVENTORY.   */
                     /* IN THE CASE OF A SUPPLIER CONSIGNED TRANSFER */
                     /* WITHOUT OWNERSHIP CHANGE, THE TRANSACTION    */
                     /* HISTORY NUMBER AND THE TRANSFER QTY WILL BE  */
                     /* STORED IN THE tr_rev FIELD OF THE RCT-TR.    */
                     if tr_rev <> "" then do:
                        assign
                           tot_supp_consign_qty = tot_supp_consign_qty -
                           decimal(trim(substring(tr_rev,index(tr_rev," ") + 1,length(tr_rev,"RAW"))))
                           l_non_consign_qoh = l_non_consign_qoh +
                           decimal(trim(substring(tr_rev,index(tr_rev," ") + 1,length(tr_rev,"RAW")))).
                     end.
                  end. /* IF tr_type = "RCT-TR" */
                  else
                  if    tr_type = "CN-RCT"
                     or tr_type = "CN-ISS"
                  then
                     tot_supp_consign_qty  = tot_supp_consign_qty
                                             - tr_qty_loc.
                  else
                  if     tr_type    = "CN-ADJ"
                     and tr_program = "pocnadj.p"
                  then
                     tot_supp_consign_qty  = tot_supp_consign_qty
                                           - tr_qty_lotserial.
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
                     if (not using_cust_consignment)
                        or (using_cust_consignment
                           and customer_consign_code <> ONLY)
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

                   if supplier_consign_code = ONLY
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
               then do:

                  /* SS - 091109.1 - B
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
                  SS - 091109.1 - E */
                  /* SS - 091109.1 - B */
                  CREATE ttxxppptrp0701.
                  ASSIGN
                     ttxxppptrp0701_site = in_site
                     ttxxppptrp0701_loc = t_lddet_loc

                     ttxxppptrp0701_part = t_lddet_part
                     ttxxppptrp0701_lot = t_lddet_lot
                     ttxxppptrp0701_ref = t_lddet_ref
                     ttxxppptrp0701_desc = t_sct_desc1 + " " + t_sct_desc2
                     ttxxppptrp0701_abc = t_sct_abc
                     ttxxppptrp0701_qty = total_qty_oh
                     ttxxppptrp0701_um = t_sct_um
                     ttxxppptrp0701_sct = t_sct_std_as_of
                     ttxxppptrp0701_ext = ptloc_ext_std
                     .
                  /* SS - 091109.1 - E */
                  parts_printed = parts_printed + 1.

                  loc_ext_std   = loc_ext_std + ext_std.

                  if customer_consign_code = EXCLUDE
                  then
                     l_cust_consignqty = 0.
                  else
                     l_cust_consignqty = tot_cust_consign_qty.

                  if supplier_consign_code = EXCLUDE
                  then
                     l_supp_consignqty = 0.
                  else
                     l_supp_consignqty = tot_supp_consign_qty.


                  l_non_consign_qoh = (total_qty_oh - l_cust_consignqty -
                                       l_supp_consignqty).

                  /* SS - 091109.1 - B
                  if (  tot_cust_consign_qty    <> 0
                     or tot_supp_consign_qty    <> 0
                     or l_non_consign_qoh       <> 0)
                     and (customer_consign_code <> EXCLUDE
                     or supplier_consign_code   <> EXCLUDE)
                  then do:

                     underline t_lddet_qty.

                     if l_non_consign_qoh <> 0
                     then do:
                        down 1.
                        display
                           getTermLabelRtColon("NON-CONSIGNED",19) @ pt_desc1
                           l_non_consign_qoh @ t_lddet_qty.
                     end. /* IF l_non_consign_qoh <> 0 */

                     if tot_cust_consign_qty      <> 0
                        and customer_consign_code <> EXCLUDE
                     then do:
                        down 1.
                        display
                           getTermLabelRtColon("CUSTOMER_CONSIGNED",19)
                           @ pt_desc1
                           tot_cust_consign_qty @ t_lddet_qty.
                     end.  /* IF tot_cust_consign_qty <> 0 */

                     if tot_supp_consign_qty  <> 0
                        and supplier_consign_code <> EXCLUDE
                     then do:
                        down 1.
                        display
                           getTermLabelRtColon("SUPPLIER_CONSIGNED",19)
                           @ pt_desc1
                           tot_supp_consign_qty @ t_lddet_qty.
                     end.  /* IF tot_supp_consign_qty <> 0 */

                     down 1.
                  end. /* IF tot_cust_consign_qty <> 0 ...*/
                  SS - 091109.1 - E */
                  /* SS - 091109.1 - B */
                  if (   tot_cust_consign_qty   <> 0
                     or  tot_supp_consign_qty   <> 0
                     or  l_non_consign_qoh      <> 0)
                     and (customer_consign_code <> EXCLUDE
                     or   supplier_consign_code <> EXCLUDE)
                  then do:

                     if l_non_consign_qoh <> 0
                     then do:
                        
                        ASSIGN
                        ttxxppptrp0701_qty_non_consign = l_non_consign_qoh
                        .
                        
                     end. /* IF l_non_consign_qoh <> 0 */

                     if tot_cust_consign_qty      <> 0
                        and customer_consign_code <> EXCLUDE
                     then do:
                        
                        ASSIGN
                        ttxxppptrp0701_qty_cust_consign = tot_cust_consign_qty
                        .
                        
                     end.  /* IF tot_cust_consign_qty <> 0 */

                     if tot_supp_consign_qty      <> 0
                        and supplier_consign_code <> EXCLUDE
                     then do:

                        ASSIGN
                        ttxxppptrp0701_qty_supp_consign = tot_supp_consign_qty
                        .
                     end.  /* IF tot_supp_consign_qty <> 0 */

                  end.  /* IF tot_cust_consign_qty <> 0 ...*/
                  /* SS - 091109.1 - E */
               end. /* IF total_qty_oh > 0 OR ... */
            end. /* IF LAST-OF(t_lddet_part) */

            /* SS - 091109.1 - B
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
            SS - 091109.1 - E */

            delete t_lddet.

         end. /* FOR EACH T_LDDET */

         /* SS - 091109.1 - B
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
         SS - 091109.1 - E */
         
         /* DELETING TEMP-TABLE STORING GL COST AND ABC */
         for each t_sct exclusive-lock:
            delete t_sct.
         end. /* FOR EACH T_SCT */

      end. /* IF LAST-OF(IN_SITE) */

      {mfrpchk.i}
   end. /* FOR EACH IN_MSTR */

   /* SS - 091109.1 - B
   /* REPORT TRAILER */
   {mfrtrail.i}

end. /* REPEAT */
   SS - 091109.1 - E */

{wbrp04.i &frame-spec = a}
