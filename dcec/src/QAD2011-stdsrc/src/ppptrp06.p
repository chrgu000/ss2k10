/* GUI CONVERTED from ppptrp06.p (converter v1.78) Thu Mar 22 02:32:40 2012 */
/* ppptrp06.p - INVENTORY VALUATION REPORT AS OF DATE                   */
/* Copyright 1986-2012 QAD Inc., Santa Barbara, CA, USA.                */
/* All rights reserved worldwide.  This is an unpublished work.         */
/*K0R1                                                                  */
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
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane    */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan   */
/* REVISION: 9.1      LAST MODIFIED: 10/01/99   BY: *N014* Jeff Wootton */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane */
/* REVISION: 9.1      LAST MODIFIED: 04/19/00   BY: *J3PB* Kirti Desai      */
/* REVISION: 9.1      LAST MODIFIED: 06/26/00   BY: *M0NY* Falguni Dalal    */
/* REVISION: 9.1      LAST MODIFIED: 08/13/00   BY: *N0KQ* myb              */
/* REVISION: 9.1      LAST MODIFIED: 08/21/00   BY: *N0MD* BalbeerS Rajput  */
/* Old ECO marker removed, but no ECO header exists *F0PN*                  */
/* Old ECO marker removed, but no ECO header exists *FM86*                  */
/* Revision: 1.8.1.10     BY: Patrick Rowan      DATE: 04/24/01 ECO: *P00G* */
/* Revision: 1.8.1.11     BY: Dan Herman         DATE: 06/06/02 ECO: *P07Y* */
/* Revision: 1.8.1.13     BY: Paul Donnelly (SB) DATE: 06/28/03 ECO: *Q00K* */
/* Revision: 1.8.1.14     BY: Reena Ambavi       DATE: 12/09/03 ECO: *P1DJ* */
/* Revision: 1.8.1.15     BY: Reena Ambavi       DATE: 01/08/04 ECO: *P1FX* */
/* Revision: 1.8.1.16     BY: Reena Ambavi       DATE: 01/21/04 ECO: *Q05F* */
/* Revision: 1.8.1.17     BY: Manish Dani        DATE: 01/27/04 ECO: *P1LD* */
/* Revision: 1.8.1.18     BY: Somesh Jeswani     DATE: 07/07/04 ECO: *P28R* */
/* Revision: 1.8.1.19     BY: Gaurav Kerkar      DATE: 07/22/04 ECO: *P2BY* */
/* Revision: 1.8.1.20     BY: Vandna Rohira      DATE: 10/18/04 ECO: *P2NM* */
/* Revision: 1.8.1.21     BY: Priya Idnani       DATE: 05/07/05 ECO: *P3KJ* */
/* Revision: 1.8.1.22     BY: Alok Gupta         DATE: 06/17/05 ECO: *P3PQ* */
/* Revision: 1.8.1.23     BY: Abhishek Jha       DATE: 08/29/05 ECO: *P3ZQ* */
/* Revision: 1.8.1.24     BY: Bharath Kumar      DATE: 09/12/05 ECO: *P40R* */
/* Revision: 1.8.1.24.1.1 BY: Ambrose Almeida    DATE: 07/13/06 ECO: *P4XD* */
/* Revision: 1.8.1.24.1.2 BY: Rijoy Ravindran    DATE: 03/12/09 ECO: *Q2KH* */
/* Revision: 1.8.1.24.1.3 BY: Ruchita Shinde     DATE: 08/06/09 ECO: *Q377* */
/* Revision: 1.8.1.24.1.4    BY: Prabu M          DATE: 12/14/09 ECO: *Q3PH* */
/* $Revision: 1.8.1.24.1.5 $  BY: Lyn Zhao      DATE: 02/10/12      ECO: *Q57G* */
/*-Revision end---------------------------------------------------------------*/

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/* TEMPORARILY TR_HIST RECORDS ARE NOT CREATED IN LD_DET.          */
/* THIS LOGIC PREVENTS LD_DET LOCKING PROBLEM WITH ANY             */
/* MAINTENANCE FUNCTION USING LD_DET                               */

/*V8:ConvertMode=FullGUIReport                                          */


/*GUI global preprocessor directive settings */
&GLOBAL-DEFINE PP_PGM_RP TRUE
&GLOBAL-DEFINE PP_ENV_GUI TRUE


/*GUI preprocessor directive settings */
&SCOPED-DEFINE PP_GUI_CONVERT_MODE REPORT

{mfdtitle.i "1+ "}
/* DEFINING VARIABLES AS NO-UNDO */

define variable abc     like pt_abc       no-undo.
define variable abc1    like pt_abc       no-undo.
define variable part    like pt_part      no-undo.
define variable part1   like pt_part      no-undo.
define variable vend    like pt_vend      no-undo.
define variable vend1   like pt_vend      no-undo.
define variable line    like pt_prod_line no-undo.
define variable line1   like pt_prod_line no-undo.
define variable ext_std as   decimal label "Ext GL Cost"
   format "->>>,>>>,>>>,>>9.99" no-undo.
define variable acc as decimal format "->>>,>>>,>>9.99" no-undo.

define variable neg_qty like mfc_logical initial yes
   label "Include Negative Inventory"          no-undo.
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
   label "Include Non-nettable Inventory"      no-undo.
define variable inc_zero_qty like mfc_logical
   label "Include Zero Quantity" no-undo.

define variable tr_recno     as recid          no-undo.
define variable trrecno      as recid          no-undo.
define variable std_as_of    like glxcst       no-undo.
define variable cst_date     like tr_effdate   no-undo.

define variable zero_cost    like mfc_logical initial yes
   label "Accept Zero Initial Cost" no-undo.

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
define variable tot_cust_consign_qty like in_qty_oh no-undo.
define variable tot_supp_consign_qty like in_qty_oh no-undo.
define variable non_consign_qoh like in_qty_oh no-undo.
define variable l_temp_qty_loc like tr_qty_loc no-undo.



define variable l_cust_consignqty  like in_qty_oh no-undo.
define variable l_supp_consignqty  like in_qty_oh no-undo.

/* THE NEXT 1 LINE WILL BE REMOVED WHEN */
/* tr_qty_lotserial IS IN THE SCHEMA.   */
define variable tr_qty_lotserial like tr_qty_loc no-undo.

/* SELECT FORM */

/*GUI preprocessor Frame A define */
&SCOPED-DEFINE PP_FRAME_NAME A

FORM /*GUI*/ 
   
 RECT-FRAME       AT ROW 1.4 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1   COLUMN 3 NO-LABEL
 SKIP(.1)  /*GUI*/
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
 SKIP(.4)  /*GUI*/
with frame a side-labels width 80 attr-space NO-BOX THREE-D /*GUI*/.

 DEFINE VARIABLE F-a-title AS CHARACTER.
 F-a-title = &IF DEFINED(GPLABEL_I)=0 &THEN
   &IF (DEFINED(SELECTION_CRITERIA) = 0)
   &THEN " Selection Criteria "
   &ELSE {&SELECTION_CRITERIA}
   &ENDIF 
&ELSE 
   getTermLabel("SELECTION_CRITERIA", 25).
&ENDIF.
 RECT-FRAME-LABEL:SCREEN-VALUE in frame a = F-a-title.
 RECT-FRAME-LABEL:WIDTH-PIXELS in frame a =
  FONT-TABLE:GET-TEXT-WIDTH-PIXELS(
  RECT-FRAME-LABEL:SCREEN-VALUE in frame a + " ", RECT-FRAME-LABEL:FONT).
 RECT-FRAME:HEIGHT-PIXELS in frame a =
  FRAME a:HEIGHT-PIXELS - RECT-FRAME:Y in frame a - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME a = FRAME a:WIDTH-CHARS - .5. /*GUI*/

/*GUI preprocessor Frame A undefine */
&UNDEFINE PP_FRAME_NAME



/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

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


/*GUI*/ {mfguirpa.i true "printer" 132 " " " " " "  }

/*GUI repeat : */
/*GUI*/ procedure p-enable-ui:


   if part1 = hi_char then part1 = "".
   if line1 = hi_char then line1 = "".
   if vend1 = hi_char then vend1 = "".
   if abc1 = hi_char then abc1 = "".
   if site1 = hi_char then site1 = "".
   if part_group1 = hi_char then part_group1 = "".
   if part_type1 = hi_char then part_type1 = "".
   if as_of_date = ? then as_of_date = today.

   if c-application-mode <> 'web' then
   
run p-action-fields (input "display").
run p-action-fields (input "enable").
end procedure. /* p-enable-ui, replacement of Data-Entry GUI*/

/*GUI*/ procedure p-report-quote:


   {gplngv.i
      &file = ""cncix_ref""
      &field = ""report""
      &mnemonic = "customer_consign"
      &isvalid  = mnemonic_valid}

   if not mnemonic_valid then do:
      {pxmsg.i &MSGNUM=712 &ERRORLEVEL=3} /*INVALID OPTION*/
      /*GUI NEXT-PROMPT removed */
      /*GUI UNDO removed */ RETURN ERROR.
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
      /*GUI NEXT-PROMPT removed */
      /*GUI UNDO removed */ RETURN ERROR.
   end.

   {gplnga2n.i
      &file = ""cnsix_ref""
      &field = ""report""
      &code = supplier_consign_code
      &mnemonic = "supplier_consign"
      &label    = supplier_consign_label}

   /* ADDED customer_consign, supplier_consign  */

   {wbrp06.i &command = update &fields = "part part1 line line1 vend
        vend1 abc abc1  site site1  part_group part_group1 part_type part_type1
        as_of_date neg_qty  net_qty inc_zero_qty  zero_cost
        customer_consign supplier_consign"
      &frm = "a"}

   if using_cust_consignment
      and using_supplier_consignment
      and ((customer_consign_code     = INCLUDE
            and supplier_consign_code = ONLY)
           or (customer_consign_code     = ONLY
               and supplier_consign_code = INCLUDE))
   then do:
      {pxmsg.i &MSGNUM=6425 &ERRORLEVEL=3}
      /*GUI NEXT-PROMPT removed */
      /*GUI UNDO removed */ RETURN ERROR.
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
   
/*GUI*/ end procedure. /* p-report-quote */
/*GUI - Field Trigger Section */

/*GUI MFSELxxx removed*/
/*GUI*/ procedure p-report:
/*GUI*/   {gpprtrpa.i "printer" 132 " " " " " " " " }
/*GUI*/   mainloop: do on error undo, return error on endkey undo, return error:

define buffer trhist for tr_hist.


   {mfphead.i}

   FORM /*GUI*/ 
      header
      l_msg1

   with STREAM-IO /*GUI*/  frame pagefoot page-bottom width 132.

   FORM /*GUI*/ 
      header
      l_msg2

   with STREAM-IO /*GUI*/  frame pagefoot1 page-bottom width 132.

   hide frame pagefoot.
   hide frame pagefoot1.
   if net_qty then view frame pagefoot.
   else view frame pagefoot1.

   /* FIND AND DISPLAY */

   mainforloop:
   for each pt_mstr
         fields( pt_domain pt_part pt_group pt_part_type pt_prod_line pt_vend
         pt_desc1 pt_desc2 pt_um)
      no-lock
          where pt_mstr.pt_domain = global_domain and  (pt_part >= part
          and pt_part <= part1)

         and   (pt_prod_line >= line    and pt_prod_line <= line1)
         and   (pt_group  >= part_group and pt_group <= part_group1)
         and (pt_part_type >= part_type and pt_part_type <= part_type1)

         , each in_mstr
         fields( in_domain in_part in_site in_abc in_cur_set in_gl_set
         in_qty_nonet in_qty_oh in_gl_cost_site)
          where in_mstr.in_domain = global_domain and  in_part  =  pt_part
         and   (in_abc  >= abc  and in_abc  <= abc1)
         and   (in_site >= site and in_site <= site1)
      no-lock
         break by pt_prod_line by pt_part
         by in_site
      with frame b width 132 down:

      /* SET EXTERNAL LABELS */
      setFrameLabels(frame b:handle).

      if first-of(pt_prod_line) then do:
         pl-printed = no.
      end.

      for first ptp_det
         fields( ptp_domain ptp_part ptp_site ptp_vend)
          where ptp_det.ptp_domain = global_domain and  ptp_part = pt_part and
          ptp_site = in_site
         use-index ptp_part no-lock:
      end. /* FOR FIRST PTP_DET */

      if ((available ptp_det
         and (ptp_vend >= vend and ptp_vend <= vend1))
         or  (not available ptp_det
         and (pt_vend >= vend and pt_vend <= vend1))) then do:

         setb:
         do on error undo, leave:

            assign
               non_consign_qoh      = 0
               tot_cust_consign_qty = 0
               tot_supp_consign_qty = 0
               total_qty_oh         = 0
               l_supp_consignqty    = 0
               l_cust_consignqty    = 0.

            /* USING IN_MSTR INSTEAD OF LD_DET FOR INVENTORY AS OF TODAY */

            /* CHECK FOR NETTABLE/NON-NETTABLE INVENTORY */

            if net_qty
            then
               total_qty_oh = total_qty_oh +
                              in_qty_oh    + in_qty_nonet.
            else
               total_qty_oh = total_qty_oh + in_qty_oh.

            /*READ LOCATION DETAIL TO DETERMINE CONSIGNMENT QUANTITIES */
            if using_cust_consignment or
               using_supplier_consignment
            then
            for each ld_det no-lock
                   where ld_det.ld_domain = global_domain and  ld_part = in_part
                  and ld_site = in_site:

               non_consign_qoh = non_consign_qoh
                                 + ld_qty_oh
                                 - ld_cust_consign_qty
                                 - ld_supp_consign_qty.

               if using_supplier_consignment
               then
                  tot_supp_consign_qty = tot_supp_consign_qty +
                                         ld_supp_consign_qty.

               if using_cust_consignment
               then
                  tot_cust_consign_qty = tot_cust_consign_qty +
                                         ld_cust_consign_qty.

            end. /* IF using_cust_consignment or using_suplier_consignment  */

            /*BACK OFF TR_HIST SINCE AS_OF_DATE*/

            for each tr_hist
               fields(tr_part    tr_site    tr_loc     tr_nbr
                      tr_effdat  tr_rmks    tr_type    tr_line
                      tr_qty_loc tr_bdn_std tr_lbr_std tr_trnbr
                      tr_mtl_std tr_ovh_std tr_sub_std tr_price
                      tr_domain  tr_status  tr_program tr_ship_type)
               where tr_hist.tr_domain = global_domain
               and   tr_part           = pt_part
               and   tr_effdate        > as_of_date
               and   tr_site           = in_site
               and   tr_effdate        <> ?
               and   tr_ship_type      = ""
            no-lock:

               /* NEXT SECTION WILL BE REMOVED WHEN   */
               /*  tr_qty_lotserial  IS IN THE SCHEMA */
               tr_qty_lotserial = 0.
               {gpextget.i &OWNER     = 'T2:T3'
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

               for first is_mstr
                  fields( is_domain is_status is_nettable)
                   where is_mstr.is_domain = global_domain
                   and   is_status         = tr_status
                   no-lock:
               end. /* FOR FIRST IS_MSTR */

               if net_qty = yes
                  or not available is_mstr
                  or (available is_mstr and is_net)
               then
                  if tr_type <> "CN-ADJ"
                  then
                     total_qty_oh = total_qty_oh - tr_qty_loc.
                  else
                  if       (tr_type = 'CN-ADJ'
                     and tr_qty_loc <> 0)
                  then
                     total_qty_oh = total_qty_oh - tr_qty_loc.
               /* NOTE: CN-ADJ DOES NOT UPDATE THE tr_qty_loc AND NO */
               /* OTHER TRANSACTIONS ARE CREATED LIKE THOSE CREATED  */
               /* AT THE TIME OF CN-SHIP OR CN-USE                   */

               if      tr_type    = "CN-ADJ"
                   and tr_program = "socnadj.p"
               then
                  tot_cust_consign_qty = tot_cust_consign_qty
                                       - tr_qty_lotserial.
               if        (tr_type = "CN-RCT"
                  or      tr_type = "CN-ISS"
                  or     (tr_type = "CN-ADJ"
                  and (tr_program = "pocnadj.p"
                  or   tr_program = "pocnaimt.p")))
               then
                  tot_supp_consign_qty = tot_supp_consign_qty
                                       - tr_qty_loc.
               else
               if    tr_type = "CN-SHIP"
                  or tr_type = "CN-USE"
               then do:
                  for first trhist
                     fields(tr_domain tr_trnbr tr_qty_loc)
                     where trhist.tr_domain = global_domain
                     and   trhist.tr_trnbr  = int64(tr_hist.tr_rmks)
                  no-lock:
                        l_temp_qty_loc = trhist.tr_qty_loc.
                  end. /* FOR FIRST trhist */

                  for first trhist
                     fields(tr_domain tr_trnbr tr_type tr_rmks)
                     where trhist.tr_domain      = global_domain
                     and   trhist.tr_trnbr       > int64(tr_hist.tr_rmks)
                     and  (trhist.tr_type        = "CN-USE" or
                           trhist.tr_type        = "CN-SHIP")
                     and integer(trhist.tr_rmks) = integer(tr_hist.tr_rmks)
                  no-lock:
                     if trhist.tr_trnbr = tr_hist.tr_trnbr
                     then do:

                        assign
                           tot_cust_consign_qty = tot_cust_consign_qty
                                                  - l_temp_qty_loc
                           non_consign_qoh      = non_consign_qoh
                                                  + l_temp_qty_loc.
                     end. /* IF trhist.tr_trnbr.. */
                  end. /* FOR FIRST trhist */
               end. /* IF tr_type = CN-SHIP */
               else
                  /* FOR TRANSACTIONS OTHER THAN THE CONSIGNED TRANSACTIONS */
                  /* ADJUST THE non_consign_qty                             */
                  non_consign_qoh = non_consign_qoh - tr_qty_loc.

            end. /* FOR EACH tr_hist */

            if using_cust_consignment
            then do:
               /* IF "EXCLUDE" THEN SUBTRACT     */
               /* CONSIGNMENT INVENTORY QUANTITY */
               if customer_consign_code = EXCLUDE
               then
                  total_qty_oh = total_qty_oh - tot_cust_consign_qty.

               /* IF "ONLY" THEN  total_qty_oh WOULD BE SAME AS THE */
               /* tot_cust_consign_qty                              */
               if customer_consign_code = ONLY
               then
                  total_qty_oh = tot_cust_consign_qty.
            end. /* IF using_cust_consignment */

            if using_supplier_consignment
            then do:

               /* IF "EXCLUDE" THEN SUBTRACT     */
               /* CONSIGNMENT INVENTORY QUANTITY */
               if supplier_consign_code = EXCLUDE
               then do:
                  if (not using_cust_consignment)
                     or (using_cust_consignment
                        and customer_consign_code <> ONLY)
                  then
                     total_qty_oh = total_qty_oh - tot_supp_consign_qty.
               end. /* IF supplier_consign_code = EXCLUDE */

               /* IF "ONLY" total_qty_oh WOULD BE SAME AS THE */
               /* tot_supp_consign_qty                        */
               if supplier_consign_code = ONLY
               then
                  total_qty_oh = tot_supp_consign_qty.

            end. /* IF using_supplier_consignment */

            if using_supplier_consignment
               and using_cust_consignment
            then do:

               /* IF BOTH CUSTOMER AND SUPPLIER CONSIGNEMENT ARE ENABLED    */
               /*  AND BOTH supplier_consign_code AND customer_consign_code */
               /* "ARE ONLY" THEN total_qty_oh WOULD BE SUM OF THE          */
               /* tot_supp_consign_qty AND tot_cust_consign_qty             */
               if supplier_consign_code     = ONLY
                  and customer_consign_code = ONLY
               then
                  total_qty_oh = tot_supp_consign_qty + tot_cust_consign_qty.
            end. /* IF using_supplier_consignment AND using_cust_consignment */

            ext_std = 0.
            if  (inc_zero_qty or total_qty_oh <> 0)
               and (neg_qty or total_qty_oh >= 0) then do:

               for first pl_mstr
                  fields( pl_domain pl_prod_line pl_desc pl_inv_acct
                  pl_inv_sub pl_inv_cc)
                   where pl_mstr.pl_domain = global_domain and   pl_prod_line =
                   pt_prod_line no-lock:
               end. /* FOR FIRST PL_MSTR */

               if pl-printed = no and (neg_qty or total_qty_oh >= 0)
               then do:

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

                  assign
                     pl-printed = yes
                     first-prod = yes.
               end.

               FORM /*GUI*/ 
                  header         skip (1)

                  getTermLabel("PRODUCT_LINE",30) + ": " +
                  pl_prod_line + "   " +
                  pl_desc format "x(63)" skip

               with STREAM-IO /*GUI*/  frame phead1 page-top no-labels width 132 no-box.

               if available pl_mstr and not first-prod then
               view
                  frame phead1.
               first-prod = no.

               /*FIND THE STANDARD COST AS OF DATE*/
               {ppptrp6a.i}

               /* BEGIN CHANGE SECTION */
               /* CHANGED TO DISPLAY PT_DESC1 ON SEPARATE LINE */

               display pt_part pt_desc1
                  in_site in_abc
                  total_qty_oh pt_um
                  std_as_of
                  ext_std
               with frame b STREAM-IO /*GUI*/ .

               if pt_desc2 <> "" then
                  put  pt_desc2 at 20.

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

               non_consign_qoh = (total_qty_oh - l_cust_consignqty -
                                                 l_supp_consignqty).


               /* END CHANGE SECTION */

               if (tot_cust_consign_qty      <> 0
                  or tot_supp_consign_qty    <> 0)
                  and (customer_consign_code <> EXCLUDE
                  or   supplier_consign_code <> EXCLUDE)
               then do with frame b:
                  underline total_qty_oh.
                  down 1.
                  display
                     getTermLabelRtColon("NON-CONSIGNED",24) @ pt_desc1
                     non_consign_qoh @ total_qty_oh WITH STREAM-IO /*GUI*/ .

                  if tot_cust_consign_qty      <> 0
                     and customer_consign_code <> EXCLUDE
                  then do:
                     down 1.
                     display
                        getTermLabelRtColon("CUSTOMER_CONSIGNED",24) @ pt_desc1
                        tot_cust_consign_qty @ total_qty_oh WITH STREAM-IO /*GUI*/ .
                  end.  /* IF tot_cust_consign_qty <> 0 */

                  if tot_supp_consign_qty      <> 0
                     and supplier_consign_code <> EXCLUDE
                  then do:
                     down 1.
                     display
                        getTermLabelRtColon("SUPPLIER_CONSIGNED",24) @ pt_desc1
                        tot_supp_consign_qty @ total_qty_oh WITH STREAM-IO /*GUI*/ .
                  end.  /* IF tot_supp_consign_qty <> 0 */

                  down 1.

               end.  /* DO WITH frame b */

               down.

            end. /*if inc_zero_qty*/
         end. /*setb*/

         if pl-printed then do:
            accumulate ext_std (total by pt_prod_line).
         end.

      end. /* if available ptp_det  */

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

         display
            caps(getTermLabel("PRODUCT_LINE_TOTAL",18))
               format "x(18)" @ std_as_of
            acc @ ext_std WITH STREAM-IO /*GUI*/ .
      end.

      if last (pt_prod_line) then do with frame b:

         acc = accum total ext_std.

         down 1.
         if page-size - line-counter < 2 then page.
         down 1.
         underline ext_std.
         down 1.

         display
            caps(getTermLabel("REPORT_TOTAL",15))
               format "x(15)" @ std_as_of
            acc  @ ext_std WITH STREAM-IO /*GUI*/ .
      end.

      
/*GUI*/ {mfguichk.i } /*Replace mfrpchk*/

   end.

   /* REPORT TRAILER */
   
/*GUI*/ {mfguitrl.i} /*Replace mfrtrail*/

/*GUI*/ {mfgrptrm.i} /*Report-to-Window*/


end.

{wbrp04.i &frame-spec = a}

/*GUI*/ end procedure. /*p-report*/
/*GUI*/ {mfguirpb.i &flds=" part part1 line line1 vend vend1 abc abc1 site site1 part_group part_group1 part_type part_type1 as_of_date neg_qty net_qty inc_zero_qty zero_cost customer_consign supplier_consign "} /*Drive the Report*/