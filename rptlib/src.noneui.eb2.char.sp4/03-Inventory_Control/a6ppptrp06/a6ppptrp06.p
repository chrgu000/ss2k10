/* ppptrp06.p - INVENTORY VALUATION REPORT AS OF DATE                   */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                  */
/* All rights reserved worldwide.  This is an unpublished work.         */
/* $Revision: 1.8.1.11 $                                                         */
/*K0R1         */
/*V8:ConvertMode=FullGUIReport                                 */
/* REVISION: 5.0      LAST MODIFIED: 01/03/90   BY: MLB               ***/
/* REVISION: 7.0      LAST MODIFIED: 09/11/91   BY: pma *F003*          */
/* REVISION: 7.0      LAST MODIFIED: 02/06/92   BY: pma *F176*          */
/* REVISION: 7.0      LAST MODIFIED: 03/11/92   BY: WUG *F280*          */
/* REVISION: 7.0      LAST MODIFIED: 07/15/92   BY: pma *F770*          */
/* REVISION: 7.0      LAST MODIFIED: 08/03/92   BY: pma *F828*          */
/* REVISION: 7.3      LAST MODIFIED: 10/30/92   BY: jcd *G256*          */
/* REVISION: 7.3      LAST MODIFIED: 03/25/93   BY: pma *G869*          */
/* REVISION: 7.3      LAST MODIFIED: 09/03/93   BY: pma *GE76*          */
/* REVISION: 7.3      LAST MODIFIED: 12/2893    BY: pxd *GI38*          */
/* Oracle changes (share-locks)      09/12/94   BY: rwl *GM42*          */
/* REVISION: 7.3      LAST MODIFIED: 09/18/94   BY: pxd *FR53*          */
/* REVISION: 7.2      LAST MODIFIED: 01/09/95   BY: ais *F0DB*          */
/* REVISION: 7.3      LAST MODIFIED: 02/28/95   by: srk *G0FZ*          */
/* REVISION: 7.3      LAST MODIFIED: 06/02/95   by: dzs *G0NZ*          */
/* REVISION: 7.3      LAST MODIFIED: 10/13/95   by: str *G0ZG*          */
/* REVISION: 7.3     LAST MODIFIED: 09/11/96   by: *G2DS* Murli Shastri */
/* REVISION: 8.5     LAST MODIFIED: 11/06/96   by: *J17P* Murli Shastri */
/* REVISION: 8.6     LAST MODIFIED: 10/10/97   by: mzv *K0R1*           */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan   */
/* REVISION: 9.1      LAST MODIFIED: 10/01/99   BY: *N014* Jeff Wootton */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane */
/* REVISION: 9.1      LAST MODIFIED: 04/19/00   BY: *J3PB* Kirti Desai      */
/* REVISION: 9.1      LAST MODIFIED: 06/26/00   BY: *M0NY* Falguni Dalal    */
/* REVISION: 9.1      LAST MODIFIED: 08/13/00   BY: *N0KQ* myb              */
/* REVISION: 9.1      LAST MODIFIED: 08/21/00   BY: *N0MD* BalbeerS Rajput  */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* Old ECO marker removed, but no ECO header exists *FM86*                    */
/* Revision: 1.8.1.10     BY: Patrick Rowan   DATE: 04/24/01  ECO: *P00G*  */
/* $Revision: 1.8.1.11 $     BY: Dan Herman      DATE: 06/06/02  ECO: *P07Y*  */
/* $Revision: 1.8.1.11 $     BY: Bill Jiang      DATE: 09/28/05  ECO: *SS - 20050928*  */
/* $Revision: 1.8.1.11 $     BY: Bill Jiang      DATE: 05/05/06  ECO: *SS - 20060605.1*  */

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/* SS - 20060603.1 - B */
/*
1. �����˿ͻ�ί��ѡ��Ĵ���
*/
/* SS - 20060603.1 - E */

/* TEMPORARILY TR_HIST RECORDS ARE NOT CREATED IN LD_DET.          */
/* THIS LOGIC PREVENTS LD_DET LOCKING PROBLEM WITH ANY             */
/* MAINTENANCE FUNCTION USING LD_DET                               */

/* SS - 20050928 - B */
/*
{mfdtitle.i "2+ "} /*GI38         */
    */
    {a6mfdtitle.i "2+ "} /*GI38         */
    /* SS - 20050928 - E */

/* SS - 20050928 - B */
{a6ppptrp06.i}

define input parameter i_part    like pt_part.
define input parameter i_part1   like pt_part.
define input parameter i_line    like pt_prod_line.
define input parameter i_line1   like pt_prod_line.
define input parameter i_vend    like pt_vend.
define input parameter i_vend1   like pt_vend.
define input parameter i_abc     like pt_abc .
define input parameter i_abc1    like pt_abc .
define input parameter i_site         like in_site.
define input parameter i_site1        like in_site.
define input parameter i_part_group   like pt_group    .
define input parameter i_part_group1  like pt_group    .
define input parameter i_part_type    like pt_part_type.
define input parameter i_part_type1   like pt_part_type.

define input parameter i_as_of_date   like tr_effdate  .
define input parameter i_neg_qty like mfc_logical.
define input parameter i_net_qty      like mfc_logical.
define input parameter i_inc_zero_qty like mfc_logical.
define input parameter i_zero_cost    like mfc_logical.
define input parameter i_customer_consign as character.
define input parameter i_supplier_consign as character.
/* SS - 20050928 - E */
/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE ppptrp06_p_2 "Ext GL Cost"
/* MaxLen: Comment: */

&SCOPED-DEFINE ppptrp06_p_4 "Include Zero Quantity"
/* MaxLen: Comment: */

&SCOPED-DEFINE ppptrp06_p_5 "Accept Zero Initial Cost"
/* MaxLen: Comment: */

&SCOPED-DEFINE ppptrp06_p_7 "Include Negative Inventory"
/* MaxLen: Comment: */

&SCOPED-DEFINE ppptrp06_p_8 "Include Non-nettable Inventory"
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */

/* DEFINING VARIABLES AS NO-UNDO */

define variable abc     like pt_abc       no-undo.
define variable abc1    like pt_abc       no-undo.
define variable part    like pt_part      no-undo.
define variable part1   like pt_part      no-undo.
define variable vend    like pt_vend      no-undo.
define variable vend1   like pt_vend      no-undo.
define variable line    like pt_prod_line no-undo.
define variable line1   like pt_prod_line no-undo.
define variable ext_std as   decimal label {&ppptrp06_p_2}
   format "->>>,>>>,>>9.99" no-undo.
define variable acc as decimal format "->>>,>>>,>>9.99" no-undo.

define variable neg_qty like mfc_logical initial yes
   label {&ppptrp06_p_7} no-undo.
define variable total_qty_oh like in_qty_oh    no-undo.
define variable pl-printed   as logical        no-undo.
define variable first-prod   as logical        no-undo.
define variable as_of_date   like tr_effdate   no-undo.

define variable part_group   like pt_group     no-undo.
define variable part_group1  like pt_group     no-undo.
define variable part_type    like pt_part_type no-undo.
define variable part_type1   like pt_part_type no-undo.
define variable site         like in_site      no-undo.
define variable site1        like in_site      no-undo.
define variable net_qty      like mfc_logical initial yes
   label {&ppptrp06_p_8} no-undo.
define variable inc_zero_qty like mfc_logical
   label {&ppptrp06_p_4} no-undo.

define variable tr_recno     as recid          no-undo.
define variable trrecno      as recid          no-undo.
define variable std_as_of    like glxcst       no-undo.
define variable cst_date     like tr_effdate   no-undo.

define variable zero_cost    like mfc_logical initial yes
   label {&ppptrp06_p_5} no-undo.

define variable l_msg1 as character format "x(64)" no-undo.
define variable l_msg2 as character format "x(64)" no-undo.

/* CONSIGNMENT VARIABLES */
{pocnvars.i}
define variable using_cust_consignment like mfc_logical no-undo.
define variable mnemonic_valid as logical no-undo.
define variable ENABLE_CUSTOMER_CONSIGNMENT as character no-undo
   initial "enable_customer_consignment".
define variable CUST_CONSIGN_CTRL_TABLE as character no-undo
   initial "cnc_ctrl".
define variable EXCLUDE as character no-undo initial "1".
define variable INCLUDE as character no-undo initial "2".
define variable ONLY as character no-undo initial "3".
define variable customer_consign_code as character no-undo
   initial "1".
define variable customer_consign as character no-undo
   label "Customer Consigned".
define variable customer_consign_label as character no-undo.
define variable supplier_consign_code as character no-undo
   initial "1".
define variable supplier_consign as character no-undo
   label "Supplier Consigned".
define variable supplier_consign_label as character no-undo.
define variable cust_consign_qty     as decimal no-undo.
define variable supp_consign_qty     as decimal no-undo.
define variable tot_cust_consign_qty like in_qty_oh no-undo.
define variable tot_supp_consign_qty like in_qty_oh no-undo.
define variable consign_loc as character no-undo.
define variable intrans_loc as character no-undo.
define variable translt_days as decimal no-undo.
define variable auto_replenish as logical no-undo.
define variable non_consign_qoh like in_qty_oh no-undo.

/* SELECT FORM */
form
   part           colon 15
   part1          label {t001.i} colon 49 skip
   line           colon 15
   line1          label {t001.i} colon 49 skip
   vend           colon 15
   vend1          label {t001.i} colon 49 skip
   abc            colon 15
   abc1           label {t001.i} colon 49 skip
   site           colon 15
   site1          label {t001.i} colon 49 skip
   part_group     colon 15
   part_group1    label {t001.i} colon 49 skip
   part_type      colon 15
   part_type1     label {t001.i} colon 49 skip(1)

   as_of_date     colon 35
   neg_qty        colon 35
   net_qty        colon 35
   inc_zero_qty   colon 35
   zero_cost      colon 35
   customer_consign     colon 35
   supplier_consign     colon 35
with frame a side-labels width 80 attr-space.

/* SET EXTERNAL LABELS */
/* SS - 20050928 - B */
/*
setFrameLabels(frame a:handle).
*/
part = i_part.
part1 = i_part1.
LINE = i_line.
line1 = i_line1.
vend = i_vend.
vend1 = i_vend1.
abc = i_abc.
abc1 = i_abc1.
site = i_site.
site1 = i_site1.
part_group = i_part_group.
part_group1 = i_part_group1.
part_type = i_part_type.
part_type1 = i_part_type1.

AS_of_date = i_as_of_date.
neg_qty = i_neg_qty.
net_qty = i_net_qty.
inc_zero_qty = i_inc_zero_qty.
zero_cost = i_zero_cost.
customer_consign = i_customer_consign.
supplier_consign = i_supplier_consign.
/* SS - 20050928 - E */

/* REPORT BLOCK */
/* SS - 20050928 - B */
/*

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
*/
/* SS - 20050928 - E */

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

/* SS - 20060605.1 - B */
/*
if using_cust_consignment then do:
   {gplngn2a.i
      &file = ""cncix_ref""
      &field = ""report""
      &code = customer_consign_code
      &mnemonic = "customer_consign"
      &label    = customer_consign_label}
end.  /* if using_cust_consignment */

if using_supplier_consignment then do:
   {gplngn2a.i
      &file = ""cnsix_ref""
      &field = ""report""
      &code = supplier_consign_code
      &mnemonic = "supplier_consign"
      &label    = supplier_consign_label}
end.  /* if using_supplier_consignment */
*/
/* SS - 20060605.1 - E */

/* SS - 20050928 - B */
/*
repeat:
    */
    /* SS - 20050928 - E */

   if part1 = hi_char then part1 = "".
   if line1 = hi_char then line1 = "".
   if vend1 = hi_char then vend1 = "".
   if abc1 = hi_char then abc1 = "".
   if site1 = hi_char then site1 = "".
   if part_group1 = hi_char then part_group1 = "".
   if part_type1 = hi_char then part_type1 = "".
   if as_of_date = ? then as_of_date = today.

/* SS - 20050928 - B */
/*
   if c-application-mode <> 'web' then
   update part
      part1
      line
      line1
      vend
      vend1
      abc
      abc1
      site site1
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
   with frame a.
   */
   /* SS - 20050928 - E */

   if using_cust_consignment then do:
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
   end.  /* if using_cust_consignment */

   if using_supplier_consignment then do:
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
   end.  /* if using_supplier_consignment */

   /* ADDED customer_consign, supplier_consign  */
   /* SS - 20050928 - B */
      /*
   {wbrp06.i &command = update &fields = "part part1 line line1 vend
        vend1 abc abc1  site site1  part_group part_group1 part_type part_type1
        as_of_date neg_qty  net_qty inc_zero_qty  zero_cost
        customer_consign supplier_consign"
      &frm = "a"}
      */
      /* SS - 20050928 - E */
   if not using_cust_consignment then
      customer_consign = " ". /* EXCLUDE */
   if not using_supplier_consignment then
      supplier_consign = " ". /* EXCLUDE */

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

      if part1 = "" then part1 = hi_char.
      if line1 = "" then line1 = hi_char.
      if vend1 = "" then vend1 = hi_char.
      if abc1 = "" then abc1 = hi_char.
      if site1 = "" then site1 = hi_char.
      if part_group1 = "" then part_group1 = hi_char.
      if part_type1 = "" then part_type1 = hi_char.
      if as_of_date = ? then as_of_date = today.
   end.

   /* OUTPUT DESTINATION SELECTION */
   /* SS - 20050928 - B */
   /*
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
   */
   define variable l_textfile        as character no-undo.
   /* SS - 20050928 - E */

   /*****************************************************************************/
   /*****************************************************************************
   /*F828*/    /*TEMPORARILY RE-CREATE ANY NON-PERMANENT LD_DET RECORDS*/
   /*F828*/    do transaction on error undo, retry:
   /*F828*/       for each tr_hist where tr_effdate >= as_of_date no-lock:
   /*F828*/          if not can-find(first ld_det where ld_site = tr_site
   /*F828*/          and ld_loc = tr_loc and ld_part = tr_part)
   /*F828*/          then do:
   /*F828*/              create ld_det.
   /*F828*/              assign
   /*F828*/              ld_part = tr_part
   /*F828*/              ld_site = tr_site
   /*F828*/              ld_loc = tr_loc
   /*F828*/              ld_status = tr_status
   /*F828*/              ld_ref = fill("#",20) + mfguser.
   /*F828*/              release ld_det.
   /*F828*/          end.
   /*F828*/       end.
   /*GE76  MOVED THE PRECEDING CODE INSIDE THE FOR EACH PT_MSTR LOOP*************/
   /*****************************************************************************/
   ******************************************************************************/

   /* FIND AND DISPLAY */

   mainforloop:
   for each pt_mstr
         fields(pt_part pt_group pt_part_type pt_prod_line pt_vend
         pt_desc1 pt_desc2 pt_um)
      no-lock
         where (pt_part >= part         and pt_part <= part1)

         and   (pt_prod_line >= line    and pt_prod_line <= line1)
         and   (pt_group  >= part_group and pt_group <= part_group1)
         and (pt_part_type >= part_type and pt_part_type <= part_type1)

         , each in_mstr
         fields(in_part in_site in_abc in_cur_set in_gl_set
         in_qty_nonet in_qty_oh in_gl_cost_site)
         where in_part  =  pt_part
         and   (in_abc  >= abc  and in_abc  <= abc1)
         and   (in_site >= site and in_site <= site1)
      no-lock
         break by pt_prod_line by pt_part
         by in_site
      with frame b width 132 down:

      /* SET EXTERNAL LABELS */
       /* SS - 20050928 - B */
       /*
      setFrameLabels(frame b:handle).
      */
      /* SS - 20050928 - E */

      if first-of(pt_prod_line) then do:
         pl-printed = no.
      end.

      for first ptp_det
         fields(ptp_part ptp_site ptp_vend)
         where ptp_part = pt_part and ptp_site = in_site
         use-index ptp_part no-lock:
      end. /* FOR FIRST PTP_DET */

      if ((available ptp_det
         and (ptp_vend >= vend and ptp_vend <= vend1))
         or  (not available ptp_det
         and (pt_vend >= vend and pt_vend <= vend1))) then do:

         setb:
         do on error undo, leave:

            assign
               non_consign_qoh = 0
               tot_cust_consign_qty = 0
               tot_supp_consign_qty = 0
            total_qty_oh = 0.

            /* USING IN_MSTR INSTEAD OF LD_DET FOR INVENTORY AS OF TODAY */

            /* CHECK FOR NETTABLE/NON-NETTABLE INVENTORY */

            if net_qty then
            total_qty_oh = total_qty_oh +
            in_qty_oh + in_qty_nonet.
            else
               total_qty_oh = total_qty_oh + in_qty_oh.

            /*READ LOCATION DETAIL TO DETERMINE CONSIGNMENT QUANTITIES */
            if using_cust_consignment or using_supplier_consignment then
            for each ld_det no-lock
                  where ld_part = in_part
                  and ld_site = in_site:

               non_consign_qoh = non_consign_qoh +
               ld_qty_oh - ld_cust_consign_qty -
               ld_supp_consign_qty.

               if using_cust_consignment then do:
                  cust_consign_qty = ld_cust_consign_qty.

                  /* IF "EXCLUDE" THEN SUBTRACT   */
                  /* CONSIGNMENT INVENTORY QTY.   */
                  if customer_consign_code = EXCLUDE then
                     total_qty_oh = total_qty_oh - cust_consign_qty.

                  /* IF "ONLY" THEN SUBTRACT         */
                  /* THE LOCATION QTY ON-HAND AND    */
                  /* ADD CONSIGNMENT INVENTORY QTY.  */
                  if customer_consign_code = ONLY then
                  total_qty_oh = total_qty_oh - ld_qty_oh +
                  cust_consign_qty.

                  tot_cust_consign_qty = tot_cust_consign_qty +
                  cust_consign_qty.

               end. /*If using_cust_consignment*/

               if using_supplier_consignment then do:
                  supp_consign_qty = ld_supp_consign_qty.

                  /* IF "EXCLUDE" THEN SUBTRACT   */
                  /* CONSIGNMENT INVENTORY QTY.   */
                  if supplier_consign_code = EXCLUDE then
                     total_qty_oh = total_qty_oh - supp_consign_qty.

                  /* IF "ONLY" THEN SUBTRACT         */
                  /* THE LOCATION QTY ON-HAND AND    */
                  /* ADD CONSIGNMENT INVENTORY QTY.  */
                  if supplier_consign_code = ONLY then
                  total_qty_oh = total_qty_oh - ld_qty_oh +
                  supp_consign_qty.

                  tot_supp_consign_qty = tot_supp_consign_qty +
                  supp_consign_qty.

               end. /*If using_supplier_consignment*/
            end. /* IF using_cust_consignment or using_suplier_consignment  */

            /*BACK OFF TR_HIST SINCE AS_OF_DATE*/

            for each tr_hist
                  fields(tr_part tr_effdate tr_site tr_loc
                  tr_ship_type tr_qty_loc tr_bdn_std tr_lbr_std
                  tr_mtl_std tr_ovh_std tr_price tr_status
                  tr_nbr tr_line
                  tr_sub_std tr_trnbr tr_type)
                  where tr_part = pt_part
                  and tr_effdate > as_of_date and tr_site = in_site
                  and tr_effdate <> ? and tr_qty_loc <> 0

                  and tr_ship_type = ""
               no-lock:

               for first is_mstr
                  fields(is_status is_nettable)
                  where is_status = tr_status no-lock:
               end. /* FOR FIRST IS_MSTR */

               if net_qty = yes or not available is_mstr
                  or (available is_mstr and is_net) then

               total_qty_oh = total_qty_oh - tr_qty_loc.

               /* DETERMINE CONSIGNMENT ORDER */
               if using_cust_consignment then do:
                  consign_flag = no.

                  if tr_nbr <> "" then do:
                     {gprunmo.i
                        &program = "socnsod1.p"
                        &module = "ACN"
                        &param = """(input tr_nbr,
                          input tr_line,
                          output consign_flag,
                          output consign_loc,
                          output intrans_loc,
                          output max_aging_days,
                          output auto_replenish)"""}
                  end.  /* if tr_nbr <> "" */

                  /* BACK OUT THE QUANTITIES THAT AREN'T APPLICABLE */
                  if (consign_flag and customer_consign_code = EXCLUDE)
                     or
                     ((not consign_flag) and customer_consign_code = ONLY) then
                     total_qty_oh = total_qty_oh + tr_qty_loc.

               end. /* IF using_cust_consignment */
            end. /* FOR EACH TR_HIST */

            ext_std = 0.
            if  (inc_zero_qty or total_qty_oh <> 0)
               and (neg_qty or total_qty_oh >= 0) then do:

               for first pl_mstr
                  fields(pl_prod_line pl_desc pl_inv_acct
                  pl_inv_sub pl_inv_cc)
                  where  pl_prod_line = pt_prod_line no-lock:
               end. /* FOR FIRST PL_MSTR */

               if pl-printed = no and (neg_qty or total_qty_oh >= 0)
               then do:
                   /* SS - 20050928 - B */
                   /*
                  if page-size - line-counter < 6 then page.

                  if available pl_mstr then

                  put skip(1)
                     {gplblfmt.i
                     &FUNC=getTermLabel(""PRODUCT_LINE"",30)
                     &CONCAT="': '"
                     } pl_prod_line space(3)
                     pl_desc space(3)
                     {gplblfmt.i
                     &FUNC=getTermLabel(""INVENTORY_ACCT"",30)
                     &CONCAT="': '"
                     } pl_inv_acct

                     space pl_inv_sub
                     space pl_inv_cc skip.

                  if line-counter > 8 then put skip(1).
                  */
                  /* SS - 20050928 - E */

                  assign
                     pl-printed = yes
                     first-prod = yes.
               end.

               /* SS - 20050928 - B */
               /*
               form
                  header         skip (1)

                  getTermLabel("PRODUCT_LINE",30) + ": " +
                  pl_prod_line + "   " +
                  pl_desc format "x(63)" skip

               with frame phead1 page-top no-labels width 132 no-box.

               if available pl_mstr and not first-prod then
               view
                  frame phead1.
               */
               /* SS - 20050928 - E */
               first-prod = no.

               /*FIND THE STANDARD COST AS OF DATE*/
               {ppptrp6a.i}

               /* BEGIN CHANGE SECTION */
               /* CHANGED TO DISPLAY PT_DESC1 ON SEPARATE LINE */

                   /* SS - 20050928 - B */
                   /*
               display pt_part pt_desc1
                  in_site in_abc
                  total_qty_oh pt_um
                  std_as_of
                  ext_std
               with frame b.

               if pt_desc2 <> "" then
                  put  pt_desc2 at 20.

               /* END CHANGE SECTION */

               if tot_cust_consign_qty <> 0 or
                  tot_supp_consign_qty <> 0 then
            do with frame b:
                  underline total_qty_oh.
                  down 1.
                  display
                     getTermLabelRtColon("NON-CONSIGNED",24) @ pt_desc1
                     non_consign_qoh @ total_qty_oh.

                  if tot_cust_consign_qty <> 0 then do:
                     down 1.
                     display
                        getTermLabelRtColon("CUSTOMER_CONSIGNED",24) @ pt_desc1
                        tot_cust_consign_qty @ total_qty_oh.
                  end.  /* if tot_cust_consign_qty <> 0 */

                  if tot_supp_consign_qty <> 0 then do:
                     down 1.
                     display
                        getTermLabelRtColon("SUPPLIER_CONSIGNED",24) @ pt_desc1
                        tot_supp_consign_qty @ total_qty_oh.
                  end.  /* if tot_supp_consign_qty <> 0 */

                  down 1.

               end.  /* do with frame b */

               down.
               */
               CREATE tta6ppptrp06.
               ASSIGN
                   tta6ppptrp06_part = pt_part
                   tta6ppptrp06_site = IN_site
                   tta6ppptrp06_qty = TOTAL_qty_oh
                   tta6ppptrp06_um = pt_um
                   tta6ppptrp06_ext = ext_std
                   tta6ppptrp06_pl = pl_prod_line
                   .
               /* SS - 20050928 - E */

            end. /*if inc_zero_qty*/
         end. /*setb*/

         /* SS - 20050928 - B */
         /*
         if pl-printed then do:
            accumulate ext_std (total by pt_prod_line).
         end.
         */
         /* SS - 20050928 - E */

      end. /* if available ptp_det  */

      /* SS - 20050928 - B */
      /*
      if last-of(pt_prod_line)
         and pl-printed then do with frame b:

         acc = accum total by pt_prod_line ext_std.
         down 1.

         if page-size - line-counter < 1 then do with frame b:
            page.
            down 1.
         end.

         underline ext_std.
         down 1.

         display caps(getTermLabel("PRODUCT_LINE_TOTAL",18)) format "x(18)" @ std_as_of
            acc @ ext_std.
      end.

      if last (pt_prod_line) then do with frame b:

         acc = accum total ext_std.

         down 1.
         if page-size - line-counter < 2 then page.
         down 1.
         underline ext_std.
         down 1.

         display caps(getTermLabel("REPORT_TOTAL",15)) format "x(15)" @ std_as_of
            acc  @ ext_std.
      end.
      */
      /* SS - 20050928 - E */

      {mfrpchk.i}
   end.

   /*****************************************************************************/
   /*****************************************************************************
   /*F828*/       /*DELETE TEMPORARY LD_DET RECORDS*/
   /*F828*/       for each ld_det where ld_ref = fill("#",20) + mfguser:
   /*F828*/          delete ld_det.
   /*F828*/       end.
   /*F828*/    end.  /*do transaction*/
   /*GE76  MOVED THE PRECEDING CODE INSIDE THE FOR EACH PT_MSTR LOOP*************/
   /*****************************************************************************/
   ******************************************************************************/

   /* REPORT TRAILER */
      /* SS - 20050928 - B */
      /*
   {mfrtrail.i}

end.
   */
   /* SS - 20050928 - E */

{wbrp04.i &frame-spec = a}