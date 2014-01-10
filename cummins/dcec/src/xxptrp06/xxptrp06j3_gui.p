/* GUI CONVERTED from ppptrp07.p (converter v1.78) Tue Nov  9 23:14:18 2010 */
/* ppptrp07.p - INVENTORY VAL AS OF DATE BY LOCATION                        */
/* Copyright 1986-2009 QAD Inc., Santa Barbara, CA, USA.                    */
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
/* Revision: 1.9.1.39  BY: Abhishek Jha       DATE: 08/29/05 ECO: *P3ZQ*    */
/* Revision: 1.9.1.40  BY: Bharath Kumar      DATE: 09/12/05 ECO: *P40R*    */
/* Revision: 1.9.1.40.3.1 BY: Masroor Alam    DATE: 06/16/05 ECO: *P4TR*    */
/* Revision: 1.9.1.40.3.2 BY: Ambrose A       DATE: 07/13/06 ECO: *P4XD*    */
/* Revision: 1.9.1.40.3.3 BY: Ambrose A       DATE: 10/19/07 ECO: *P6B8*    */
/* Revision: 1.9.1.40.3.4 BY: Rijoy Ravindran DATE: 03/12/09 ECO: *Q2KH*    */
/* Revision: 1.9.1.40.3.5 BY: Ruchita Shinde  DATE: 08/06/09 ECO: *Q377*    */
/* Revision: 1.9.1.40.3.6 BY: Prabu M          DATE: 12/14/09 ECO: *Q3PH* */
/* $Revision: 1.9.1.40.3.7 $ BY: Chandrakant Ingle DATE: 10/08/10 ECO: *Q4G8* */
/*-Revision end---------------------------------------------------------------*/

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/
/* LD_DET AND TR_HIST RECORDS ARE CREATED IN TEMPORARY TABLES.              */
/* THIS LOGIC PREVENTS LD_DET LOCKING PROBLEM WITH ANY                      */
/* MAINTENANCE FUNCTION USING LD_DET                                        */
/*V8:ConvertMode=FullGUIReport                                              */
/* ss - 130315.1 by: jack */
/* ss - 130321.1 by: jack */
/* ss - 130322.1 by: jack */
/* DISPLAY TITLE */


/*GUI global preprocessor directive settings */
&GLOBAL-DEFINE PP_PGM_RP TRUE
&GLOBAL-DEFINE PP_ENV_GUI TRUE


/*GUI preprocessor directive settings */
&SCOPED-DEFINE PP_GUI_CONVERT_MODE REPORT
{mfdtitle.i "130420.1 "}

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
   format "->>>,>>>,>>>,>>9.99" no-undo.
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

define variable l_msg1 as character format "x(255)" no-undo.
define variable l_msg2 as character format "x(64)" no-undo.

define variable loc_ext_std  like ext_std     no-undo.
define variable site_ext_std like ext_std     no-undo.
define variable tot_ext_std  like ext_std     no-undo.
define variable l_nettable   like mfc_logical no-undo.
define variable l_avail_stat like mfc_logical no-undo.
define variable l_non_consign_qoh like in_qty_oh no-undo.
define variable l_temp_qty_loc like tr_qty_loc no-undo.



define variable l_cust_consignqty  like in_qty_oh no-undo.
define variable l_supp_consignqty  like in_qty_oh no-undo.
define variable l_trnbr            like tr_trnbr no-undo.

/* THE NEXT 1 LINE WILL BE REMOVED WHEN */
/* tr_qty_lotserial IS IN THE SCHEMA.   */
define variable tr_qty_lotserial like tr_qty_loc no-undo.
/* ss - 130315.1 -b */
define variable inti as integer.
define variable l_excel like mfc_logical initial no
   label "output to Excel" no-undo.
define variable fName as character format "x(50)".
DEFINE VAR v_total_qty LIKE ld_qty_oh .

DEFINE VAR effdate LIKE tr_effdate .
define variable i as integer.
/* ss - 130321.1 -b */
define variable cost_qty like mfc_logical initial NO 
       label "Include Cost Inventory" no-undo.
/* ss - 130321.1 -e */
{xxptrp06.i "new"}
define  temp-table tmploc01  /*费用类库位列表*/
     fields t01_site like loc_site
     fields t01_lock like loc_loc
     index p1 t01_site t01_lock.
/* SELECT FORM */
/* s s- 130315.1 -e */
   /* ss - 130321.1 -b */
    DEFINE VAR v_go AS LOGICAL .
/* ss - 130321.1 -e */

/* ss - 130315.1 -e */

/*JJ*/ define variable v_all_qty like trgl_gl_amt label "Qty Total" format "->>>,>>>,>>>,>>9.99<<<" .
/*JJ*/ define variable v_all_amt like v_all_qty label "Amount Total" format "->>>,>>>,>>>,>>9.99<<<".

/* CONSIGNMENT VARIABLES */
{pocnvars.i}
{pocnvar2.i}


/* TEMP-TABLE STORING QUANTITY, ITEM NO. AND LOCATION         */
/* FOR A SITE                                               */
define temp-table t_trhist no-undo
   field t_trhist_domain             like tr_domain
   field t_trhist_part               like tr_part
   field t_trhist_effdate            like tr_effdate
   field t_trhist_site               like tr_site
   field t_trhist_loc                like tr_loc
   field t_trhist_serial                like tr_serial
    field t_trhist_ref                like tr_ref
   field t_trhist_trnbr              like tr_trnbr
   field t_trhist_ship_type          like tr_ship_type
   field t_trhist_nbr                like tr_nbr
   field t_trhist_type               like tr_type
   field t_trhist_program            like tr_program
   field t_trhist_qty_loc            like tr_qty_loc
   field t_trhist_status             like tr_status
   field t_trhist_rmks               like tr_rmks
   field t_trhist_rev                like tr_rev
   field t_trhist_qty_cn_adj         like tr_qty_lotserial
   index t_trhist is primary unique
         t_trhist_domain t_trhist_part /* t_trhist_effdate */ t_trhist_site
         t_trhist_loc t_trhist_serial t_trhist_effdate t_trhist_trnbr /* t_trhist_ship_type */ .

/* TEMP-TABLE STORING QUANTITY ON HAND, ITEM NO. AND LOCATION */
/* FOR A SITE                                                 */
define temp-table t_lddet no-undo
   field t_lddet_site like ld_site
   field t_lddet_part      like ld_part
   field t_lddet_loc       like ld_loc
   field t_lddet_lot       like ld_lot
   field t_lddet_ref       like ld_ref
   field t_lddet_qty       like in_qty_oh
   field t_lddet_avail_stat like mfc_logical
   field t_lddet_net like mfc_logical
   field t_lddet_cust_consign_qty like ld_cust_consign_qty
   field t_lddet_supp_consign_qty like ld_supp_consign_qty
   FIELD t_lddet_date AS DATE
   FIELD t_lddet_std_as_of LIKE std_as_of
   index t_lddet is primary unique
         t_lddet_site t_lddet_part t_lddet_loc t_lddet_lot .

DEFINE TEMP-TABLE tt LIKE t_lddet .

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

/* CN tr_hist */
/*JJ*/
define temp-table cn_trhist no-undo
   field tr_trnbr like tr_hist.tr_trnbr
   field tr_type like tr_hist.tr_type
   field tr_rmks as int
   field tr_serial like tr_hist.tr_serial
   field tr_ref like tr_hist.tr_ref
   index p1 tr_rmks tr_trnbr
   .

define temp-table cst_trhist no-undo
        field tr_part like tr_hist.tr_part
        field tr_site like tr_hist.tr_site
        field tr_effdate like tr_hist.tr_effdate
        field tr_trnbr like tr_hist.tr_trnbr
        field tr_time like tr_hist.tr_time
        field tr_recid as recid
        index p1 tr_part tr_site tr_effdate tr_time.
/*JJ*/

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

/*GUI preprocessor Frame A define */
&SCOPED-DEFINE PP_FRAME_NAME A

/* ss - 130315.1 -b
FORM /*GUI*/
/*JJ
 RECT-FRAME       AT ROW 1.4 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1   COLUMN 3 NO-LABEL
 SKIP(.1)  /*GUI*/
*/
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
/*JJ
 SKIP(.4)  /*GUI*/
*/
with frame a side-labels width 80 /* attr-space NO-BOX */ THREE-D  /*GUI*/.
ss - 130315.1 -e */

/*JJ*/ cost_qty = no.

/* ss - 130315.1 -b */
FORM /*GUI*/
/*JJ
 RECT-FRAME       AT ROW 1.4 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1   COLUMN 3 NO-LABEL
 SKIP(.1)  /*GUI*/
*/
   as_of_date     colon 15
   days[1] colon 15   days[2] colon 35   days[3] colon 55
   days[4] colon 15   days[5] colon 35   days[6] colon 55
   days[7] colon 15   days[8] colon 35   days[9] colon 55
   part           colon 15
   part1          label {t001.i} colon 49
   line           colon 15
   line1          label {t001.i} colon 49
   abc            colon 15
   abc1           label {t001.i} colon 49
   site           colon 15
   site1          label {t001.i} colon 49
   part_type      colon 15
   part_type1     label {t001.i} colon 49
   part_group     colon 15
   part_group1    label {t001.i} colon 49
   neg_qty        colon 32
   net_qty        colon 70
   inc_zero_qty   colon 24
   zero_cost      colon 60
   customer_consign   colon 24
   supplier_consign   colon 60
    /* ss - 130321.1 -b */
    cost_qty      COLON 24
    /* ss - 130321.1 -e */
   l_excel      colon 24
   fName     colon 22

/*   part           colon 15                                                 */
/*   part1          label {t001.i} colon 49 skip                             */
/*   line           colon 15                                                 */
/*   line1          label {t001.i} colon 49 skip                             */
/*   vend           colon 15                                                 */
/*   vend1          label {t001.i} colon 49 skip                             */
/*   abc            colon 15                                                 */
/*   abc1           label {t001.i} colon 49 skip                             */
/*   site           colon 15                                                 */
/*   site1          label {t001.i} colon 49 skip                             */
/*   part_group     colon 15                                                 */
/*   part_group1    label {t001.i} colon 49 skip                             */
/*   part_type      colon 15                                                 */
/*   part_type1     label {t001.i} colon 49 skip(1)                          */
/*                                                                           */
/*   as_of_date     colon 35                                                 */
/*   neg_qty        colon 35                                                 */
/*   net_qty        colon 35                                                 */
/*   inc_zero_qty   colon 35                                                 */
/*   zero_cost      colon 35                                                 */
/*   customer_consign     colon 35                                           */
/*   supplier_consign     colon 35                                           */
/*JJ
 SKIP(.4)  /*GUI*/
*/
with frame a side-labels width 80 /* attr-space NO-BOX THREE-D */ /*GUI*/.

/* ss - 130315.1 -e */

 DEFINE VARIABLE F-a-title AS CHARACTER.
 F-a-title = &IF DEFINED(GPLABEL_I)=0 &THEN
   &IF (DEFINED(SELECTION_CRITERIA) = 0)
   &THEN " Selection Criteria "
   &ELSE {&SELECTION_CRITERIA}
   &ENDIF
&ELSE
   getTermLabel("SELECTION_CRITERIA", 25).
&ENDIF.

/*JJ
 RECT-FRAME-LABEL:SCREEN-VALUE in frame a = F-a-title.
 RECT-FRAME-LABEL:WIDTH-PIXELS in frame a =
  FONT-TABLE:GET-TEXT-WIDTH-PIXELS(
  RECT-FRAME-LABEL:SCREEN-VALUE in frame a + " ", RECT-FRAME-LABEL:FONT).
 RECT-FRAME:HEIGHT-PIXELS in frame a =
  FRAME a:HEIGHT-PIXELS - RECT-FRAME:Y in frame a - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME a = FRAME a:WIDTH-CHARS - .5. /*GUI*/
*/

/*GUI preprocessor Frame A undefine */
&UNDEFINE PP_FRAME_NAME



/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

/* FORM FOR SITE AND LOCATION */
FORM /*GUI*/
   site at 1
   loc  at 15
with STREAM-IO /*GUI*/  frame phead1 side-labels width 132.

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


/*JJ
/*GUI*/ {mfguirpa.i true "printer" 132 " " " " " "  }
*/

/*GUI repeat : */



if days[1] = 0 then do:
/*JJ*/ days[1] = 30.
/*JJ*/ define var v_i as int .
/*JJ*/ do v_i = 2 to 9 : days[v_i] = days[v_i - 1] + 30. end.
/*JJ*/ customer_consign = "Include".
/*JJ*/ l_excel = yes.
end.

/*GUI - Field Trigger Section */

/*GUI MFSELxxx removed*/
/*JJ
/*GUI*/ procedure p-report:
/*GUI*/   {gpprtrpa.i "printer" 132 " " " " " " " " }
***/

{xxptrp06a1.i}

/*GUI*/   mainloop: 

repeat on error undo, return error on endkey undo, return :


   if part1 = hi_char then part1 = "".
   if line1 = hi_char then line1 = "".
   if vend1 = hi_char then vend1 = "".
   if abc1 = hi_char then abc1 = "".
   if site1 = hi_char then site1 = "".
   if loc1 = hi_char then loc1 = "".
   if part_group1 = hi_char then part_group1 = "".
   if part_type1 = hi_char then part_type1 = "".
   if as_of_date = ? then as_of_date = today.

/*JJ   run p-report-quote. */
/* /*GUI*/ procedure p-report-quote: */


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
   /* ss - 130315.1 -b
   {wbrp06.i &command = update &fields = "part part1 line line1 vend vend1
        abc abc1 site site1 loc loc1 part_group part_group1 part_type part_type1
        as_of_date neg_qty  net_qty inc_zero_qty   zero_cost
        customer_consign supplier_consign l_recalculate"
      &frm = "a"}
      ss - 130315.1 -e */
       /* ss -130315.1 -b */
       {wbrp06.i &command = update &fields = " as_of_date days part part1 line line1
        abc abc1 site site1 part_type part_group part_group1 part_type1
         neg_qty  net_qty inc_zero_qty zero_cost
        customer_consign supplier_consign cost_qty l_excel fName"
      &frm = "a"}

       /* ss - 130315.1 -e */

   if using_cust_consignment
      and using_supplier_consignment
      and ((customer_consign_code     = INCLUDE
            and supplier_consign_code = ONLY)
           or(customer_consign_code     = ONLY
              and supplier_consign_code = INCLUDE))
   then do:
      {pxmsg.i &MSGNUM=6425 &ERRORLEVEL=3}
      /*GUI NEXT-PROMPT removed */
      /*GUI UNDO removed */ RETURN ERROR.
   end. /* IF using_cust_consignment */



   if (c-application-mode <> 'web') or
      (c-application-mode = 'web' and
      (c-web-request begins 'data')) then do:

      update as_of_date days[1] days[2] days[3] days[4] days[5] days[6] days[7] days[8] days[9] 
      part part1 line line1 abc abc1 site site1 part_type part_type1 part_group part_group1 
      neg_qty net_qty cost_qty inc_zero_qty zero_cost customer_consign supplier_consign
      cost_qty l_excel 	fname 
	with frame a.

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
      {mfquoter.i cost_qty}
      {mfquoter.i inc_zero_qty}
      {mfquoter.i zero_cost}
      {mfquoter.i customer_consign}
      {mfquoter.i supplier_consign}
      {mfquoter.i l_recalculate}

      {xxptrp06a2.i}


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

   empty temp-table cn_trhist.
   empty temp-table cst_trhist.

/* /*GUI*/ end procedure. /* p-report-quote */ */

/*
   {gpselout.i &printType = "printer"
               &printWidth = 132
               &pagedFlag = "false"
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
*/
{mfselbpr.i "printer" 132 nopage}

define buffer trhist for tr_hist.
/* ss - 130315.1 -b */

   {mfphead.i}

l_msg1 = "Item Number        Site     Description              Line  Qty On Hand        Std.Cost " .
l_msg2 = "------------------ -------- ------------------------ ---- ------------ --------------- " + fill("------------ ",10).
do v_i = 1 to 9:
l_msg1 = l_msg1 +  fill(" ",12 - 2 - length(string(days[v_i]))) + "<=" + string(days[v_i]) + " ".
end.
l_msg1 = l_msg1 +  fill(" ",12 - 2 - length(string(days[9]))) + "> " + string(days[9]) .

disp l_msg1 format 'x(298)' skip
     l_msg2 format 'x(298)' with frame f_msg no-label no-box width 300.

/*JJ

   FORM /*GUI*/
      header
      l_msg1 format 'x(298)' skip
      l_msg2 format 'x(298)'

   with STREAM-IO /*GUI*/  frame pagefoot page-top width 300.

   FORM /*GUI*/
/*
      header
      l_msg2
*/
   with STREAM-IO /*GUI*/  frame pagefoot1 page-bottom width 132.

   hide frame pagefoot.
   hide frame pagefoot1.
   view frame pagefoot.
*/
/*
   if net_qty then view frame pagefoot.
   else view frame pagefoot1.
*/

/*   display "Start:" today string(time,"hh:mm:ss") with frame f_time no-label no-box. */
   disp " " with frame f_time no-label no-box.

   /*TEMPORARILY RE-CREATE ANY NON-PERMANENT LD_DET RECORDS*/

   /* INITIALIZING TEMP-TABLES T_TRHIST T_LDDET T_SCT AND T_STAT */
   empty temp-table t_trhist.

   for each t_lddet exclusive-lock:
      delete t_lddet.
   end. /* FOR EACH T_LDDET */

   for each t_sct exclusive-lock:
      delete t_sct.
   end. /* FOR EACH T_SCT */

   for each t_stat exclusive-lock:
      delete t_stat.
   end. /* FOR EACH T_STAT */

   FOR EACH tt EXCLUSIVE-LOCK :
       DELETE tt .
   END.

   FOR EACH tmploc01 EXCLUSIVE-LOCK:
       DELETE tmploc01.
   END.

   if cost_qty = no then do:  /*费用类库位列表*/
        /*
       for each code_mstr no-lock where code_domain = global_domain
            and code_fldname = "INVTR",
           each pld_det no-lock where pld_domain = global_domain and
                pld_inv_acct = code_value
           break by pld_site by pld_loc:
           if first-of(pld_loc) then do:
              find first tmploc01 exclusive-lock where t01_site = pld_site
                     and t01_loc = pld_loc no-error.
              if not available tmploc01 then do:
                 create tmploc01.
                 assign t01_site = pld_site
                        t01_loc = pld_loc.
              end.
           end.
       end.

       */
/*JJ*/
        for each pld_det no-lock where pld_domain = global_domain break by pld_site by pld_loc:
                if first-of(pld_loc) then do:
                        create tmploc01.
                        assign t01_site = pld_site
                               t01_loc = pld_loc.
                end.
        end.
/*JJ*/
   end.


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
                )
         /* ss - 130315.1 -b
         and   (can-find(first ptp_det use-index ptp_part
                   where ptp_det.ptp_domain = global_domain
                   and   (ptp_part          = pt_part
                   and   ptp_site           = in_site
                   and   (ptp_vend >= vend and ptp_vend <= vend1)))
               or (not can-find(first ptp_det use-index ptp_part
                          where ptp_det.ptp_domain = global_domain
                          and   ptp_part           = pt_part
                          and   ptp_site           = in_site)
                          and   (pt_vend  >= vend and pt_vend  <= vend1)))
           ss - 130315.1 -e */
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
         {xxppptrp6ja.i}

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
             where ld_det.ld_domain = global_domain and  ld_part = pt_part
            and   ld_site = in_site
           /* ss - 130315.1 -b and   (ld_loc >= loc and ld_loc <= loc1)
           ss - 130315.1 -e */:

/*fyk*/  find first tmploc01 no-lock where t01_site = ld_site and t01_loc = ld_loc
/*fyk*/       no-error.
/*fyk*/  if available tmploc01 then do:
/*fyk*/     next.
/*fyk*/  end.

          /* ss - 130321.1 -b */
            /* IF cost_qty = NO  THEN DO:                                                           */
            /*    FIND FIRST pld_det WHERE pld_domain = GLOBAL_domain                               */
            /*        AND pld_site = ld_site AND pld_loc = ld_loc                                   */
            /*        AND CAN-FIND ( FIRST CODE_mstr WHERE CODE_domain = GLOBAL_domain              */
            /*        AND CODE_fldname = "InvTR" AND CODE_value = pld_inv_acct ) NO-LOCK NO-ERROR . */
            /*    IF AVAILABLE pld_det  THEN NEXT .                                                 */
            /* END.                                                                                 */
          /* ss - 130321.1 -e */

         find first t_lddet exclusive-lock
            where t_lddet.t_lddet_part = ld_part
            and   t_lddet.t_lddet_site = ld_site
            and   t_lddet.t_lddet_loc  = ld_loc
            AND t_lddet.t_lddet_lot = ld_lot
            no-error.

         if not available t_lddet then do:

            create t_lddet.
            assign
               t_lddet.t_lddet_site             = ld_site
               t_lddet.t_lddet_cust_consign_qty = ld_cust_consign_qty
               t_lddet.t_lddet_supp_consign_qty = ld_supp_consign_qty
               t_lddet.t_lddet_part             = ld_part
               t_lddet.t_lddet_loc              = ld_loc
               t_lddet.t_lddet_lot = ld_lot
               t_lddet.t_lddet_ref = ld_ref
         t_lddet.t_lddet_date = ld_date
                .
         end.
         else
            assign
               t_lddet.t_lddet_cust_consign_qty = t_lddet.t_lddet_cust_consign_qty
                                        + ld_cust_consign_qty
               t_lddet.t_lddet_supp_consign_qty = t_lddet.t_lddet_supp_consign_qty
                                        + ld_supp_consign_qty.

         run ck_status(input  ld_status,
            output l_avail_stat,
            output l_nettable).

         if net_qty = yes or not l_avail_stat
            or (l_avail_stat and l_nettable) then
            t_lddet.t_lddet_qty = t_lddet.t_lddet_qty + ld_qty_oh.

         /* ss - 130321.2 -b
         MESSAGE "hi1"  t_lddet.t_lddet_loc  t_lddet.t_lddet_qty t_lddet.t_lddet_lot .
         */


      end. /* FOR EACH LD_DET */

      for last tr_hist
         where tr_hist.tr_domain = global_domain
         and   tr_hist.tr_trnbr >= 0
      no-lock :
      end.
      if available tr_hist then
         l_trnbr = tr_hist.tr_trnbr .

      /*CREATING t_trhist RECORDS.*/
      for each tr_hist
         fields(tr_domain tr_part tr_effdate tr_site tr_loc tr_trnbr
         tr_ship_type tr_nbr tr_type tr_program tr_qty_loc tr_status
         tr_rmks tr_rev tr_serial tr_ref ) use-index tr_part_eff
         where  tr_hist.tr_domain     = global_domain
            and tr_hist.tr_part       = pt_part
            and tr_hist.tr_effdate    > as_of_date
            and tr_hist.tr_site       = in_site
            /* ss - 130315.1 -b
            and (tr_hist.tr_loc      >= loc
            and  tr_hist.tr_loc      <= loc1)
            ss - 130315.1 -e */
            and tr_hist.tr_trnbr     <= l_trnbr
            and tr_hist.tr_ship_type  = ""
      no-lock:
         /* NEXT SECTION WILL BE REMOVED WHEN   */
         /* tr_qty_lotserial  IS IN THE SCHEMA  */


/*fyk*/  find first tmploc01 no-lock where t01_site = tr_hist.tr_site and t01_loc = tr_hist.tr_loc
/*fyk*/       no-error.
/*fyk*/  if available tmploc01 then do:
/*fyk*/     next.
/*fyk*/  end.
         tr_qty_lotserial = 0.
         {gpextget.i &OWNER     = 'T2:T3'
                     &TABLENAME = 'tr_hist'
                     &REFERENCE = 'lotSerialQty'
                     &KEY1      = string(tr_hist.tr_trnbr)
                     &DEC1      = tr_qty_lotserial}

         create t_trhist.
         assign
            t_trhist_domain             = tr_hist.tr_domain
            t_trhist_part               = tr_hist.tr_part
            t_trhist_effdate            = tr_hist.tr_effdate
            t_trhist_site               = tr_hist.tr_site
            t_trhist_loc                = tr_hist.tr_loc
            t_trhist_serial             = tr_hist.tr_serial
            t_trhist_ref                = tr_hist.tr_ref
            t_trhist_trnbr              = tr_hist.tr_trnbr
            t_trhist_ship_type          = tr_hist.tr_ship_type
            t_trhist_nbr                = tr_hist.tr_nbr
            t_trhist_type               = tr_hist.tr_type
            t_trhist_program            = tr_hist.tr_program
            t_trhist_qty_loc            = tr_hist.tr_qty_loc
            t_trhist_status             = tr_hist.tr_status
            t_trhist_rmks               = tr_hist.tr_rmks
            t_trhist_rev                = tr_hist.tr_rev
            t_trhist_qty_cn_adj         = tr_qty_lotserial.

      end. /* FOR EACH tr_hist */

      /* ADDED tr_hist LOOP TO CREATE TEMP-TABLE t_lddet FOR ITEMS  */
      /* HAVING ZERO QOH FOR WHICH ld_det DOES NOT EXIST. */
  /* ss - 130315.1 -b */
      /*
      if l_recalculate
      then do:
          ss - 130321.1 -e */
         for each tr_hist
            fields(tr_domain tr_part tr_site tr_loc tr_status tr_ship_type
                   tr_lot tr_ref tr_qty_loc tr_effdate tr_serial tr_ref )
            use-index tr_part_eff
         no-lock
            where tr_hist.tr_domain     = global_domain
            and   tr_hist.tr_part       = pt_part
            and   tr_hist.tr_site       = in_site
            and   tr_hist.tr_effdate   >= as_of_date
            and   tr_hist.tr_ship_type  = ""
            /* and   tr_loc       >= loc
            and   tr_hist.tr_loc       <= loc1 */
            and   not can-find(first ld_det
                         where ld_domain = global_domain
                         and   ld_part   = pt_part
                         and   ld_site   = in_site
                         and   ld_loc    = tr_hist.tr_loc
                         AND ld_lot = tr_hist.tr_serial)
         break by tr_hist.tr_part by tr_hist.tr_site by tr_hist.tr_loc BY tr_hist.tr_serial /* ss - 130321.1 -e */:
/*fyk*/  find first tmploc01 no-lock where t01_site = tr_hist.tr_site and t01_loc = tr_hist.tr_loc
/*fyk*/       no-error.
/*fyk*/  if available tmploc01 then do:
/*fyk*/     next.
/*fyk*/  end.
              /* ss - 130321.1 -b */
         /*  IF FIRST-OF(tr_loc)  THEN DO:                                                               */
         /*   v_go = YES .                                                                               */
         /*     IF cost_qty = NO  THEN DO:                                                               */
         /*        FIND FIRST pld_det WHERE pld_domain = GLOBAL_domain                                   */
         /*            AND pld_site = tr_site AND pld_loc = tr_loc                                       */
         /*            AND CAN-FIND ( FIRST CODE_mstr WHERE CODE_domain = GLOBAL_domain                  */
         /*            AND CODE_fldname = "InvTR" AND CODE_value = pld_inv_acct ) NO-LOCK NO-ERROR .     */
         /*        IF AVAILABLE pld_det  THEN v_go = NO . .                                              */
         /*     END.                                                                                     */
         /*  END.                                                                                        */
         /*                                                                                              */
         /*  IF v_go = NO  THEN NEXT .                                                                   */
          /* ss - 130321.1 -e */

            if first-of(tr_hist.tr_serial)
            then do:

               find first t_lddet
                  where t_lddet.t_lddet_part = tr_hist.tr_part
                  and   t_lddet.t_lddet_site = tr_hist.tr_site
                  and   t_lddet.t_lddet_loc  = tr_hist.tr_loc
                   /* ss - 130321.1 -b */
                    AND t_lddet.t_lddet_lot = tr_hist.tr_serial
                   /* ss - 130321.1 -e */
               exclusive-lock no-error.

               if not available t_lddet
               then do:
                  create t_lddet.
                  assign
                     t_lddet.t_lddet_site = tr_hist.tr_site
                     t_lddet.t_lddet_part = tr_hist.tr_part
                     t_lddet.t_lddet_loc  = tr_hist.tr_loc
                     t_lddet.t_lddet_qty  = 0
                      /* ss - 130321.1 -b */
                       t_lddet.t_lddet_lot = tr_hist.tr_serial
                       t_lddet.t_lddet_ref = tr_hist.tr_ref
                      /* ss - 130321.1 -e */
                      .
                   /* ss - 130321.2 -b
         MESSAGE "hi2"  t_lddet.t_lddet_loc  t_lddet.t_lddet_qty t_lddet.t_lddet_lot .
         */

               end. /* IF NOT AVAILABLE t_lddet */

            end. /* IF first-of(tr_loc) */

         end.  /* FOR EACH tr_hist.. */
     /* ss - 130321.1 -b
      end. /* IF l_recalculate */
      */

     /* ss - 130315.1 -e */

      if last-of(in_site) then do:

         locations_printed = 0.

         for each t_lddet exclusive-lock
               where t_lddet.t_lddet_site = in_site
               break by t_lddet.t_lddet_loc by t_lddet.t_lddet_part
              BY t_lddet.t_lddet_lot /* by   t_lddet.t_lddet_ref */
            with frame b width 132:

            /* SET EXTERNAL LABELS */
            setFrameLabels(frame b:handle).

            if first-of(t_lddet.t_lddet_lot) then
            assign
               tot_cust_consign_qty = 0
               tot_supp_consign_qty = 0
               total_qty_oh         = 0
               l_non_consign_qoh    = 0
               l_supp_consignqty    = 0
               l_cust_consignqty    = 0.

            if first-of(t_lddet.t_lddet_loc) then
               parts_printed = 0.

             l_non_consign_qoh = l_non_consign_qoh
                                 + t_lddet.t_lddet_qty
                                 - t_lddet.t_lddet_cust_consign_qty
                                 - t_lddet.t_lddet_supp_consign_qty.

            /* THE VARIABLES total_qty_oh,tot_cust_consign_qty AND    */
            /* tot_supp_consign_qty ARE CALCULATED TO STORE THE       */
            /* QUANTITY ON HAND, CUSTOMER CONSIGNED QTY               */
            /* AND SUPPLIER CONSIGNED QTY RESPECTIVELY.               */

            if net_qty = yes or not t_lddet.t_lddet_avail_stat
               or (t_lddet.t_lddet_avail_stat and t_lddet.t_lddet_net)
            then do:

               total_qty_oh = total_qty_oh + t_lddet.t_lddet_qty.

                /* ss - 130321.2 -b
         MESSAGE "hi3"  t_lddet.t_lddet_loc  t_lddet.t_lddet_qty t_lddet.t_lddet_lot total_qty_oh .
         */


               /*DETERMINE CONSIGNMENT QUANTITIES */
               if using_cust_consignment
               then
                  tot_cust_consign_qty = tot_cust_consign_qty
                                       + t_lddet.t_lddet_cust_consign_qty.

               if using_supplier_consignment
               then
                  tot_supp_consign_qty = tot_supp_consign_qty
                                         + t_lddet.t_lddet_supp_consign_qty.

            end. /* If net_qty = yes or not t_lddet_avail_status */

            /*FIND THE STANDARD COST AS OF DATE*/

            for first t_sct
               where t_sct_part = t_lddet.t_lddet_part
            no-lock:
            end. /* FOR FIRST t_sct */

            /* PRINTS SUMMARIZED QTY FOR AN ITEM IN A LOCATION */
            if last-of(t_lddet.t_lddet_lot)
            then do:
               /* BACK OUT TR_HIST AFTER AS-OF DATE */
               for each t_trhist
                  where t_trhist_domain    = global_domain
                  and   t_trhist_part      = t_lddet.t_lddet_part
                  and   t_trhist_effdate   > as_of_date
                  and   t_trhist_site      = t_lddet.t_lddet_site
                  and   t_trhist_loc       = t_lddet.t_lddet_loc
                  and   t_trhist_serial    = t_lddet.t_lddet_lot
                 /* and   t_trhist_ref       = t_lddet.t_lddet_ref */
                  and   t_trhist_trnbr    <= l_trnbr
                  and   t_trhist_ship_type = ""
               no-lock:

                  if t_trhist_qty_loc = 0
                     and t_trhist_type <> "CN-SHIP"
                     and t_trhist_type <> "CN-USE"
                     and t_trhist_type <> "CN-ADJ"
                  then
                     next.

                  run ck_status(input  t_trhist_status,
                                output l_avail_stat,
                                output l_nettable).

                  if (net_qty = yes
                     or not l_avail_stat
                     or (l_avail_stat
                     and l_nettable))
                  then
                     if t_trhist_type <> "CN-ADJ"
                     then
                        total_qty_oh = total_qty_oh - t_trhist_qty_loc.
                     else
                     if   ( t_trhist_type    = "CN-ADJ"
                        and t_trhist_qty_loc <> 0)
                     then
                        total_qty_oh = total_qty_oh - t_trhist_qty_loc.

                  /* NOTE: CN-ADJ DOES NOT UPDATE THE tr_qty_loc AND NO */
                  /* OTHER TRANSACTIONS ARE CREATED LIKE THOSE CREATED  */
                  /* AT THE TIME OF CN-SHIP OR CN-USE                   */

                  if (t_trhist_type = "CN-ADJ"
                      and t_trhist_program = "socnadj.p")
                  then
                     tot_cust_consign_qty = tot_cust_consign_qty
                                          - t_trhist_qty_cn_adj.
                  else
                  if t_trhist_type = "CN-SHIP"
                     or t_trhist_type = "CN-USE"
                  then do:
                     for first trhist
                        fields(tr_domain tr_trnbr tr_qty_loc tr_serial tr_ref)
                        where trhist.tr_domain = global_domain
                        and   trhist.tr_trnbr  = integer(t_trhist.t_trhist_rmks)
                     no-lock:
                        l_temp_qty_loc = trhist.tr_qty_loc.
                     end. /* FOR FIRST trhist */

   find first cn_trhist no-error.
   if not avail cn_trhist then do:
   for each tr_hist no-lock where tr_hist.tr_domain = global_domain and
        tr_hist.tr_type = 'CN-SHIP' and
        tr_hist.tr_part >= part and
	tr_hist.tr_part <= part1 :
        create cn_trhist.
        buffer-copy tr_hist except tr_rmks to cn_trhist.
        cn_trhist.tr_rmks = int(tr_hist.tr_rmks).
   end.
   for each tr_hist no-lock where tr_hist.tr_domain = global_domain and
        tr_hist.tr_type = 'CN-USE' and
        tr_hist.tr_part >= part and
	tr_hist.tr_part <= part1:
        create cn_trhist.
        buffer-copy tr_hist except tr_rmks to cn_trhist.
        cn_trhist.tr_rmks = int(tr_hist.tr_rmks).
   end.
   end.

/*JJ
                     for first trhist
                        fields(tr_domain tr_trnbr tr_type tr_rmks tr_serial tr_ref)
                        where trhist.tr_domain      = global_domain
                        and   trhist.tr_trnbr       > integer(t_trhist.t_trhist_rmks)
                        and  (trhist.tr_type        = "CN-USE" or
                              trhist.tr_type        = "CN-SHIP")
                        and integer(trhist.tr_rmks) = integer(t_trhist.t_trhist_rmks)
                     no-lock:
                        if trhist.tr_trnbr = t_trhist.t_trhist_trnbr
                        then do:
                           assign
                              tot_cust_consign_qty = tot_cust_consign_qty
                                                     - l_temp_qty_loc
                              l_non_consign_qoh    = l_non_consign_qoh
                                                     + l_temp_qty_loc.
                        end. /* IF trhist.tr_trnbr.. */
                     end. /* FOR FIRST trhist */
*/
/*JJ*/               for first cn_trhist
                        where cn_trhist.tr_rmks = integer(t_trhist.t_trhist_rmks) and
                                cn_trhist.tr_trnbr > integer(t_trhist.t_trhist_rmks) :
                        if cn_trhist.tr_trnbr = t_trhist.t_trhist_trnbr then do:
                                assign 
                                tot_cust_consign_qty = tot_cust_consign_qty
                                                     - l_temp_qty_loc
                                l_non_consign_qoh    = l_non_consign_qoh
                                                     + l_temp_qty_loc.
                        end.
/*JJ*/               end.

                  end. /* IF t_trhist_type = CN-SHIP */
                  else
                  if t_trhist_type = "ISS-TR"
                  then do:
                     /* FIRST ADD TRANSFER QTY TO NON-CONSIGNED INVENTORY. */
                     /* t_trhist_qty_loc IS NEGATIVE FOR ISS-TR TRANSACTIONS.    */
                     l_non_consign_qoh = l_non_consign_qoh - t_trhist_qty_loc.

                     /* NEXT, FIND OUT IF THE TRANSFER IS A SUPPLIER */
                     /* CONSIGNMENT TRANSFER WITHOUT CHANGE OF       */
                     /* OWNERSHIP. IF SO, THEN UPDATE SUPPLIER       */
                     /* CONSIGNMENT AND NON-CONSIGNMENT INVENTORY.   */
                     /* IN THE CASE OF A SUPPLIER CONSIGNED TRANSFER */
                     /* WITHOUT OWNERSHIP CHANGE, THE TRANSACTION    */
                     /* HISTORY NUMBER AND THE TRANSFER QTY WILL BE  */
                     /* STORED IN THE t_trhist_rev FIELD OF THE RCT-TR.    */
                     for first trhist 
                         fields(tr_trnbr tr_qty_loc tr_rev tr_type tr_effdate tr_serial tr_ref) /* use-index tr_trnbr */
                         where trhist.tr_domain = global_domain
                           and trhist.tr_trnbr > t_trhist.t_trhist_trnbr
                           and trhist.tr_type = "RCT-TR"
                           and trhist.tr_effdate = t_trhist.t_trhist_effdate
                                          and
                    integer(substring(trhist.tr_rev,1,index(tr_rev," ") - 1)) =
                    t_trhist.t_trhist_trnbr
                    no-lock:

                    assign
                       tot_supp_consign_qty = tot_supp_consign_qty +
                       decimal(trim(substring(trhist.tr_rev,index(trhist.tr_rev," ") + 1,length(trhist.tr_rev,"RAW"))))
                       l_non_consign_qoh = l_non_consign_qoh -
                       decimal(trim(substring(trhist.tr_rev,index(trhist.tr_rev," ") + 1,length(trhist.tr_rev,"RAW")))).
                     end. /* FOR FIRST trhist */
                  end. /* IF t_trhist_type = "ISS-TR" */
                  else
                  if t_trhist_type = "RCT-TR"
                  then do:
                     /* FIRST BACK OUT TRANSFER QTY FROM NON-CONSIGNED */
                     /* INVENTORY.                                     */
                     l_non_consign_qoh = l_non_consign_qoh - t_trhist_qty_loc.

                     /* NEXT, FIND OUT IF THE TRANSFER IS A SUPPLIER */
                     /* CONSIGNMENT TRANSFER WITHOUT CHANGE OF       */
                     /* OWNERSHIP. IF SO, THEN UPDATE SUPPLIER       */
                     /* CONSIGNMENT AND NON-CONSIGNMENT INVENTORY.   */
                     /* IN THE CASE OF A SUPPLIER CONSIGNED TRANSFER */
                     /* WITHOUT OWNERSHIP CHANGE, THE TRANSACTION    */
                     /* HISTORY NUMBER AND THE TRANSFER QTY WILL BE  */
                     /* STORED IN THE t_trhist_rev FIELD OF THE RCT-TR.    */
                     if t_trhist_rev <> "" then do:
                        assign
                           tot_supp_consign_qty = tot_supp_consign_qty -
                           decimal(trim(substring(t_trhist_rev,index(t_trhist_rev," ") + 1,length(t_trhist_rev,"RAW"))))
                           l_non_consign_qoh = l_non_consign_qoh +
                           decimal(trim(substring(t_trhist_rev,index(t_trhist_rev," ") + 1,length(t_trhist_rev,"RAW")))).
                     end.
                  end. /* IF t_trhist_type = "RCT-TR" */
                  else
                  if    (t_trhist_type = "CN-RCT"
                     or  t_trhist_type = "CN-ISS"
                     or  t_trhist_type = "CN-ADJ")
                     and (t_trhist_program = "pocnadj.p"
                     or   t_trhist_program = "pocnaimt.p"
                     or   t_trhist_program = "iclotr02.p"
                     or   t_trhist_program = "poporc.p")
                  then
                     tot_supp_consign_qty  = tot_supp_consign_qty
                                             - t_trhist_qty_loc.
                  else
                      l_non_consign_qoh = l_non_consign_qoh  - t_trhist_qty_loc.
               end. /* FOR EACH t_trhist */

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

                /* ss - 130321.1 -b
                   MESSAGE "hi5" t_lddet.t_lddet_loc t_lddet.t_lddet_lot total_qty_oh .
                   */

               if total_qty_oh     > 0
                  or (total_qty_oh = 0
                      and inc_zero_qty)
                  or (total_qty_oh < 0
                      and neg_qty)
               then do:


                   /* ss - 130315.1 -b
/*JJ
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
                     with frame phead1 side-labels STREAM-IO /*GUI*/ .

                  end. /* IF PARTS_PRINTED = 0 */
*/


                  display
                     t_lddet_part
                     t_sct_desc1 + " " +
                     t_sct_desc2 format "x(49)" @ pt_desc1
                     t_sct_abc
                     total_qty_oh @ t_lddet_qty
                     t_sct_um
                     t_sct_std_as_of
                     ptloc_ext_std @ ext_std WITH STREAM-IO /*GUI*/ .
                  down.

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
                           l_non_consign_qoh @ t_lddet_qty WITH STREAM-IO /*GUI*/ .
                     end. /* IF l_non_consign_qoh <> 0 */

                     if tot_cust_consign_qty      <> 0
                        and customer_consign_code <> EXCLUDE
                     then do:
                        down 1.
                        display
                           getTermLabelRtColon("CUSTOMER_CONSIGNED",19)
                           @ pt_desc1
                           tot_cust_consign_qty @ t_lddet_qty WITH STREAM-IO /*GUI*/ .
                     end.  /* IF tot_cust_consign_qty <> 0 */

                     if tot_supp_consign_qty  <> 0
                        and supplier_consign_code <> EXCLUDE
                     then do:
                        down 1.
                        display
                           getTermLabelRtColon("SUPPLIER_CONSIGNED",19)
                           @ pt_desc1
                           tot_supp_consign_qty @ t_lddet_qty WITH STREAM-IO /*GUI*/ .
                     end.  /* IF tot_supp_consign_qty <> 0 */

                     down 1.
                    ss - 130315.1 -e */
                   /* ss - 130315.1 -b */
                   ASSIGN
                     t_lddet.t_lddet_qty = total_qty_oh
                     t_lddet.t_lddet_std_as_of = t_sct_std_as_of
                         .
                 /* ss - 130321.1 -b
                   MESSAGE "hi6" t_lddet.t_lddet_lot total_qty_oh .
                   */

                    CREATE tt .
                    BUFFER-COPY t_lddet TO tt .

                   /* ss - 130315.1 -e */

               end. /* IF total_qty_oh > 0 OR ... */


                delete t_lddet.

            end. /* IF LAST-OF(t_lddet_lot) */

             /* ss - 130315.1 -b
            if last-of(t_lddet_loc)
            then do:
               if parts_printed >= 1
               then do:
/*JJ
                  if line-counter > page-size - 4
                  then
                     page.

                  underline ext_std.
                  down 1.
                  display
                    caps(getTermLabel("LOCATION_TOTAL",15)) format "x(15)"
                         @ t_sct_std_as_of
                     loc_ext_std @ ext_std WITH STREAM-IO /*GUI*/ .
                  down 1.
*/

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
/*JJ
                  if line-counter > page-size - 4
                  then
                     page.

                  underline ext_std.
                  down 1.
                  display
                     caps(getTermLabel("SITE_TOTAL",15)) format "x(15)"
                         @ t_sct_std_as_of
                     site_ext_std @ ext_std WITH STREAM-IO /*GUI*/ .
                  down 1.
*/

                  assign
                     tot_ext_std  = tot_ext_std + site_ext_std
                     site_ext_std = 0.

               end. /* IF locations_printed >= 1 */
            end. /* IF LAST(t_lddet_loc) */
            ss - 130315.1 -e */


         end. /* FOR EACH T_LDDET */

         /* ss - 130315.1 -e
         if last(in_site) then do:
/*JJ
            if line-counter > page-size - 4 then page.

            underline ext_std.
            down 1.
            display
               caps(getTermLabel("REPORT_TOTAL",15))
                  format "x(15)" @ t_sct_std_as_of
               tot_ext_std @ ext_std WITH STREAM-IO /*GUI*/ .
            down 1.
*/
            tot_ext_std = 0.

         end. /* IF LAST(IN_SITE) */
         ss - 130315.1 -e */

         /* DELETING TEMP-TABLE STORING GL COST AND ABC */
           /* ss - 130321.1 -b */
         for each t_sct exclusive-lock:
            delete t_sct.
         end. /* FOR EACH T_SCT */


      end. /* IF LAST-OF(IN_SITE) */


/*JJ
/*GUI*/ {mfguichk.i } /*Replace mfrpchk*/
*/

   end. /* FOR EACH IN_MSTR */



     /* ss - 130315.1 -b */
      for each x_ret exclusive-lock :
       delete x_ret .
      end .
     /* 计算发生日期账龄 */
         FOR EACH tt NO-LOCK
              ,EACH pt_mstr NO-LOCK
              WHERE pt_domain = global_domain and
           pt_part = tt.t_lddet_part
                BREAK BY tt.t_lddet_site BY tt.t_lddet_part  BY tt.t_lddet_loc BY  tt.t_lddet_lot /* BY tt.t_lddet_ref */

              :



                IF FIRST-OF(tt.t_lddet_part)  THEN DO:
                      find first x_ret exclusive-lock where
          xr_site = tt.t_lddet_site and
          xr_part = tt.t_lddet_part no-error.
                        if not available x_ret then do:
                           create x_ret.
                           assign
              xr_site = tt.t_lddet_site
                               xr_part = tt.t_lddet_part
                               xr_cst = tt.t_lddet_std_as_of
                               xr_desc1 = pt_desc1
                               xr_prodline = pt_prod_line
                               .
                        end.

                    v_total_qty = 0 .
                END.

                xr_qty_oh = xr_qty_oh + tt.t_lddet_qty .


              effdate = ?.
         /* ss - 130318.1 -b
              IF tt.t_lddet_lot <> "" THEN DO:
               ss -e */
         /*
                 FOR EACH tr_hist NO-LOCK
                    WHERE
                tr_domain = global_domain and
                tr_part = tt.t_lddet_part
                    AND tr_serial = tt.t_lddet_lot
                  /*  AND tr_ref = tt.t_lddet_ref */
                    AND tr_site = tt.t_lddet_site
                     AND tr_loc = tt.t_lddet_loc
                    AND tr_qty_loc > 0 AND tr_type BEGINS "rct-"
                    :
                    effdate = tr_effdate.
                    LEAVE.
                 END.
     */
     /* ss - 130318.1 -b
              END.
        ss -e */

                 /* ss - 130315.1 -b */

                effdate = tt.t_lddet_date .

                IF effdate <> ?  THEN DO:

                    do i = 1 to 9:
                       if as_of_date - effdate >= days[i] then do:
                          assign inti = i.
                       end.
                       else do:
                          leave.
                       end.
                    end.
                END.
                /* ss - 130322.1 -b
                ELSE
                    i = 10 .
                ss - 130322.1 -e */
                 /* ss - 130322.1 -b */
                ELSE
                    i = 1 .
               /* ss - 130322.1 -e */

                if i = 9 and as_of_date - effdate > days[9] then do:
                   assign i  = i + 1.
                end.
                assign inti  = i.

                IF tt.t_lddet_lot = "" THEN DO:
                        inti = 1.
                END.

                   assign
                       xr_qty[inti] = xr_qty[inti] +  tt.t_lddet_qty
                       .

          END. /* EACH tt */


     /* 计算发生日期账龄 */

        if opsys <> "unix" and l_excel then do:
         {gprun.i ""xxptrp06xg.p"" "(input fName)"}
      end.
      else do:
          /* 130321.2  */
	  v_all_qty  = 0.
          v_all_amt = 0.
          for each x_ret no-lock with width 300:
		v_all_qty = v_all_qty + xr_qty_oh.
		v_all_amt = v_all_amt + xr_qty_oh * xr_cst.
          display x_ret with stream-io no-label no-box.
          /*
          FOR EACH tt NO-LOCK WITH WIDTH 300 :
               display tt with stream-io.
               */

/*          /*GUI*/ {mfguichk.i } /*Replace mfrpchk*/ */
	  {mfrpchk.i}
          end.
	  
	  disp v_all_qty v_all_amt "Complete At" today string(time,"hh:mm:ss") with frame f_total side-label width 200.
      end.
        /* ss - 130315.1 -e */

   /* REPORT TRAILER */

/*JJ
/*GUI*/ {mfguitrl.i} /*Replace mfrtrail*/

/*GUI*/ {mfgrptrm.i} /*Report-to-Window*/
*/

	{mfrtrail.i}


	{mfgrptrm.i}

end. /* REPEAT */

/*
{wbrp04.i &frame-spec = a}
*/

/*JJ
/*GUI*/ end procedure. /*p-report*/
*/

/* ss - 130315.1 -b
/*GUI*/ {mfguirpb.i &flds=" part part1 line line1 vend vend1 abc abc1 site site1 loc loc1 part_type part_type1 part_group part_group1 as_of_date neg_qty net_qty inc_zero_qty zero_cost customer_consign supplier_consign l_recalculate "} /*Drive the Report*/

   ss - 130315.1 -e */
/* ss - 130315.1 -b */

/*JJ
/*GUI*/ {mfguirpb.i &flds=" as_of_date days part part1 line line1 /* vend vend1 */ abc abc1 site site1 part_type part_type1 part_group part_group1 neg_qty net_qty inc_zero_qty zero_cost customer_consign supplier_consign cost_qty l_excel fname "} /*Drive the Report*/
/* ss - 130315.1 -e */
*/
