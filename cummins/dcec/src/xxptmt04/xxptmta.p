/* GUI CONVERTED from xxptmta.p (converter v1.78) Thu Jan 19 15:47:30 2012 */
/* ppptmta.p - ITEM MAINTENANCE                                               */
/* Copyright 1986-2009 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/*!
    This program is called from a variety of places to manage maintenance of
    some or all item-related data.

    The variable PPFORM is used to track:
    - From where this program is being called
    - Which subset(s) of item master data are valid for maintenance/display

    PPFORM may contain any of these values:
    " " : Item Master Maintenance (ppptmt.p)
    "A" : Indicates Engineering Item Maintenance (ececmt.p or ppptmt04.p)
    "B" : Item Inventory Maintenance (ppptmt01.p)
    "C" : Item Planning Maintenance (ppptmt02.p)
    "D" : Item Cost Maintenance (ppptmt03.p)

    The following types of activities are allowed or restricted based on ppform:

    1) New items may be created only when ppform is " " or "A".
    2) Items may be deleted only when ppform is " ".
    3) Frame "a" (part number, UM, description) is always displayed.  It is only
       maintainable for ppform = " " or "A".  Appearance of other frames is
       enabled for ppform = " " and the appropriate value listed above.
    4) PPPTMTA1.P is called to maintain Item Engineering Data.
    5) PPPTMTC.P is called when ppform is " " or "C" to maintain Item Planning
       Data.
    6) PPPTMTD.P is called when ppform is " " or "D" to maintain Item Costing
       Data.
    7) When ppform is " " and svc_itm_data (in 11.24) is set, FSPTMT1.P is
       called to maintain Item Service Data.
*/

/* REVISION: 6.0      LAST MODIFIED: 03/06/90   BY: emb *D001*                */
/* REVISION: 6.0      LAST MODIFIED: 04/23/90   BY: MLB *D021*                */
/* REVISION: 6.0      LAST MODIFIED: 05/10/90   BY: MLB *D024*                */
/* REVISION: 6.0      LAST MODIFIED: 05/17/90   BY: WUG *D002*                */
/* REVISION: 6.0      LAST MODIFIED: 07/02/90   BY: emb *B724*                */
/* REVISION: 6.0      LAST MODIFIED: 07/31/90   BY: WUG *D051*                */
/* REVISION: 6.0      LAST MODIFIED: 08/17/90   BY: MLB *D055*                */
/* REVISION: 6.0      LAST MODIFIED: 08/31/90   BY: WUG *D051*                */
/* REVISION: 6.0      LAST MODIFIED: 09/11/90   BY: WUG *D069*                */
/* REVISION: 6.0      LAST MODIFIED: 10/25/90   BY: MLB *D141*                */
/* REVISION: 6.0      LAST MODIFIED: 10/31/90   BY: emb *D158*                */
/* REVISION: 6.0      LAST MODIFIED: 11/06/90   BY: pml *D184*                */
/* REVISION: 6.0      LAST MODIFIED: 06/10/91   BY: emb *D682*                */
/* REVISION: 7.0      LAST MODIFIED: 08/28/91   BY: pma *F003*                */
/* REVISION: 7.0      LAST MODIFIED: 11/16/91   BY: pml *F048*                */
/* REVISION: 7.0      LAST MODIFIED: 11/28/91   BY: pml *F061*                */
/* REVISION: 6.0      LAST MODIFIED: 01/07/92   BY: WUG *D981*                */
/* REVISION: 7.0      LAST MODIFIED: 01/11/92   BY: RAM *F033*                */
/* REVISION: 7.0      LAST MODIFIED: 03/11/92   BY: WUG *F281*                */
/* REVISION: 7.0      LAST MODIFIED: 05/14/92   BY: tjs *F495*                */
/* REVISION: 7.0      LAST MODIFIED: 05/26/92   BY: pma *F532*                */
/* REVISION: 7.0      LAST MODIFIED: 05/30/92   BY: pma *F560*                */
/* REVISION: 7.0      LAST MODIFIED: 06/09/92   BY: afs *F601*                */
/* REVISION: 7.0      LAST MODIFIED: 06/22/92   BY: emb *F687*                */
/* REVISION: 7.0      LAST MODIFIED: 07/16/92   BY: emb *F777*                */
/* REVISION: 7.0      LAST MODIFIED: 07/23/92   BY: pma *F782*                */
/* REVISION: 7.3      LAST MODIFIED: 10/12/92   BY: tjs *G035*                */
/* REVISION: 7.0      LAST MODIFIED: 10/29/92   BY: pma *G249*                */
/* REVISION: 7.3      LAST MODIFIED: 02/13/93   BY: pma *G032*                */
/* REVISION: 7.3      LAST MODIFIED: 04/16/93   BY: pma *G961*                */
/* REVISION: 7.3      LAST MODIFIED: 04/30/93   BY: pma *GA44***rev only      */
/* REVISION: 7.3      LAST MODIFIED: 06/15/93   BY: qzl *GC15***Rev Only      */
/* REVISION: 7.3      LAST MODIFIED: 06/29/93   BY: afs *GC22*                */
/* REVISION: 7.3      LAST MODIFIED: 07/29/93   BY: emb *GD82*                */
/* REVISION: 7.3      LAST MODIFIED: 08/05/93   BY: pma *H055*                */
/* REVISION: 7.4      LAST MODIFIED: 08/25/93   BY: dpm *H075*                */
/* REVISION: 7.4      LAST MODIFIED: 02/15/94   BY: pxd *FL60*                */
/* REVISION: 7.2      LAST MODIFIED: 04/07/94   BY: pma *FN30*                */
/* REVISION: 7.2      LAST MODIFIED: 05/31/94   BY: pxd *FO35*                */
/* REVISION: 7.4      LAST MODIFIED: 08/11/94   BY: afs *FQ07*                */
/* REVISION: 7.4      LAST MODIFIED: 09/01/94   BY: bcm *H501*                */
/* REVISION: 7.3      LAST MODIFIED: 09/03/94   BY: bcm *GL93*                */
/* REVISION: 8.5      LAST MODIFIED: 01/05/95   BY: pma *J040*                */
/* REVISION: 8.5      LAST MODIFIED: 01/18/95   BY: taf *J041*                */
/* REVISION: 8.5      LAST MODIFIED: 02/01/95   BY: tjm *J042*                */
/* REVISION: 8.5      LAST MODIFIED: 02/02/95   BY: jlf *J042*                */
/* REVISION: 7.2      LAST MODIFIED: 02/19/95   BY: qzl *F0JL*                */
/* REVISION: 7.4      LAST MODIFIED: 02/23/95   BY: jzw *H0BM*                */
/* REVISION: 7.2      LAST MODIFIED: 03/03/95   BY: qzl *G0G9*                */
/* REVISION: 7.4      LAST MODIFIED: 03/22/95   BY: srk *F0NN*                */
/* REVISION: 8.5      LAST MODIFIED: 03/30/95   BY: dpm *J044*                */
/* REVISION: 7.4      LAST MODIFIED: 05/31/95   BY: qzl *F0SK*                */
/* REVISION: 7.4      LAST MODIFIED: 07/13/95   BY: jzs *G0S6*                */
/* REVISION: 8.5      LAST MODIFIED: 07/27/95   BY: ktn *J05Z*                */
/* REVISION: 7.4      LAST MODIFIED: 11/14/95   BY: str *G1B0*                */
/* REVISION: 8.5      LAST MODIFIED: 01/09/96   BY: wep *J054*                */
/* REVISION: 8.5      LAST MODIFIED: 03/19/96   BY: *J0CV* Robert Wachowicz   */
/* REVISION: 8.5      LAST MODIFIED: 06/18/96   BY: *J0TY* Robert Wachowicz   */
/* REVISION: 8.5      LAST MODIFIED: 07/03/96   BY: *J0XP* Sue Poland         */
/* REVISION: 8.6      LAST MODIFIED: 10/10/96   BY: svs *K007*                */
/* REVISION: 8.6      LAST MODIFIED: 10/18/96   BY: *K017* Jean Miller        */
/* REVISION: 8.6      LAST MODIFIED: 10/11/96   BY: *K003* forrest mori       */
/* REVISION: 8.6      LAST MODIFIED: 10/22/96   BY: *K004* Kurt De Wit        */
/* REVISION: 8.6      LAST MODIFIED: 10/31/96   BY: *J17C* Sue Poland         */
/* REVISION: 8.6      LAST MODIFIED: 11/27/96   BY: *J17Q* Murli Shastri      */
/* REVISION: 8.6      LAST MODIFIED: 01/02/97   BY: *K040* Sue Poland         */
/* REVISION: 8.6      LAST MODIFIED: 06/09/97   BY: *K0D8* Arul Victoria      */
/* REVISION: 8.6      LAST MODIFIED: 06/24/97   BY: *K0DH* Arul Victoria      */
/* REVISION: 8.6      LAST MODIFIED: 10/07/97   BY: *J22Q* Nirav Parikh       */
/* REVISION: 7.4      LAST MODIFIED: 12/22/97   BY: *H1HN* Jean Miller        */
/* REVISION: 8.6E     LAST MODIFIED: 05/15/98   BY: *J2LM* Suresh Nayak       */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane          */
/* REVISION: 8.6E     LAST MODIFIED: 03/24/98   BY: *J2FG* Niranjan R.        */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan         */
/* REVISION: 9.0      LAST MODIFIED: 11/10/98   BY: *M01K* Yelena Karnovskaya */
/* REVISION: 9.0      LAST MODIFIED: 11/25/98   BY: *M002* Mayse Lai          */
/* REVISION: 9.0      LAST MODIFIED: 12/02/98   BY: *J33T* Thomas Fernandes   */
/* REVISION: 9.0      LAST MODIFIED: 03/13/99   BY: *M0BD* Alfred Tan         */
/* REVISION: 9.0      LAST MODIFIED: 03/23/99   BY: *J3C4* Satish Chavan      */
/* REVISION: 9.1      LAST MODIFIED: 06/07/99   BY: *N005* David Morris       */
/* REVISION: 9.1      LAST MODIFIED: 06/17/99   BY: *N00J* Russ Witt          */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* Revision: 1.38     BY: Satish Chavan      DATE: 03/30/00   ECO: *N03T*     */
/* Revision: 1.39     BY: Annasaheb Rahane   DATE: 05/08/00   ECO: *N0B0*     */
/* Revision: 1.44     BY: Satish Chavan      DATE: 05/16/00   ECO: *N0B9*     */
/* REVISION: 9.1      LAST MODIFIED: 08/17/00   BY: *N0LJ* Mark Brown         */
/* Revision: 1.46     BY: Anil Sudhakaran    DATE: 05/24/01   ECO: *M0P1*     */
/* Revision: 1.47     BY: Mark Christian     DATE: 06/05/01   ECO: *M14Z*     */
/* Revision: 1.48     BY: Russ Witt          DATE: 09/21/01   ECO: *P01H*     */
/* Revision: 1.49     BY: Rajiv Ramaiah      DATE: 10/16/02   ECO: *N1X6*     */
/* Revision: 1.50     BY: Veena Lad          DATE: 02/04/03   ECO: *N26B*     */
/* Revision: 1.51     BY: Narathip W.        DATE: 04/16/03   ECO: *P0PW*     */
/* Revision: 1.53     BY: Paul Donnelly (SB) DATE: 06/28/03   ECO: *Q00K*     */
/* Revision: 1.56     BY: Jyoti Thatte       DATE: 09/15/03   ECO: *P106*     */
/* Revision: 1.57     BY: Rajiv Ramaiah      DATE: 11/05/03   ECO: *N2M0*     */
/* Revision: 1.58     BY: Karan Motwani      DATE: 02/23/04   ECO: *N2PR*     */
/* Revision: 1.59     BY: Shivanand H        DATE: 05/25/04   ECO: *P238*     */
/* Revision: 1.60     BY: Abhishek Jha       DATE: 12/23/04   ECO: *P2ZV*     */
/* Revision: 1.61     BY: Vandna Rohira      DATE: 02/14/05   ECO: *P35T*     */
/* Revision: 1.61.2.1 BY: Preeti Sattur      DATE: 11/28/05   ECO: *P49K*     */
/* Revision: 1.61.2.2 BY: Munira Savai       DATE: 12/06/05   ECO: *Q0NB*     */
/* Revision: 1.61.2.3 BY: Deepak Taneja      DATE: 09/20/07   ECO: *P686*     */
/* Revision: 1.61.2.6 BY: Kumar Desai        DATE: 10/19/07   ECO: *Q1DC*     */
/* Revision: 1.61.2.7 BY: Chi Liu            DATE: 01/23/08   ECO: *P6GT*     */
/* Revision: 1.61.2.8.1.1  BY: Alex Joy      DATE: 02/28/08   ECO: *P6M7*     */
/* Revision: 1.61.2.10  BY: Chi Liu          DATE: 02/20/09   ECO: *Q22F*     */
/* Revision: 1.61.2.12  BY: Evan Todd        DATE: 02/26/09   ECO: *Q2D3*     */
/* Revision: 1.61.2.13  BY: Ashim Mishra     DATE: 08/03/09   ECO: *Q374*     */
/* Revision: 1.61.2.15  BY: Sandeep Rohila   DATE: 08/07/09   ECO: *Q376*     */
/* $Revision: 1.61.2.16 $  BY: Evan Todd        DATE: 09/03/09   ECO: *Q3BT*     */
/*-Revision end---------------------------------------------------------------*/

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/
/*V8:ConvertMode=Maintenance                                                  */

{mfdeclre.i}
{gplabel.i} /* EXTERNAL LABEL INCLUDE */
{cxcustom.i "PPPTMTA.P"}

&SCOPED-DEFINE QXO-TABLE pt_mstr
{qxodef.i}
/* COMMON API CONSTANTS AND VARIABLES */
{mfaimfg.i}

{pxmaint.i}
{pxpgmmgr.i}
{pxsevcon.i}

/*  THE DATABASE FIELD pt_net_wt    BELOW WAS FORMERLY pt_weight         */
/*  THE DATABASE FIELD pt_net_wt_um BELOW WAS FORMERLY pt_weight_um      */

/* NEW SHARED */
define new shared variable promo_old       like pt_promo.
define new shared variable new_part        like mfc_logical.
define new shared variable csset           like cs_set        initial "".
define new shared variable s_mtl           like sct_mtl_tl.
define new shared variable s_lbr           like sct_lbr_tl.
define new shared variable s_bdn           like sct_bdn_tl.
define new shared variable s_ovh           like sct_ovh_tl.
define new shared variable s_sub           like sct_sub_tl.
define new shared variable global_category like sc_category.
define new shared variable site            like si_site       initial "".
define new shared variable undo_all        like mfc_logical   no-undo.

define new shared variable undo_del        as logical.
define new shared variable frtitle         as character format "x(24)".
define new shared variable inrecno         as recid.
define new shared variable sct1recno       as recid.
define new shared variable sct2recno       as recid.
define new shared variable transtype       as character.
define new shared variable startrow        as integer.

define new shared frame a1.
define new shared frame a2.
define new shared frame b.
define new shared frame b1.
define new shared frame c.
define new shared frame d.
define new shared frame d0.
define new shared frame d1.

define new shared workfile sptwkfl
   fields element  like spt_element column-label "Element"
   fields primary  like mfc_logical column-label "Pri"
   fields prim2    like mfc_logical
   fields ao       like spt_ao      column-label "A/O"
   fields cst_tl   like spt_cst_tl  column-label "This Level"
   fields old_cst_tl like spt_cst_tl
   fields cst_ll   like spt_cst_ll  column-label "Lower Level"
   fields cst_tot  like spt_cst_tl  column-label "Total"
   fields cat_desc as character     column-label "Category"
   fields seq      like spt_pct_ll
   fields part     like pt_part.

/* SHARED */
define shared variable ppform as character.

/* QXO EVENT NAME */
define variable cEventName as character no-undo initial "pt_mstr".

define variable ptRowID as rowid no-undo.
define variable ptOID as decimal no-undo.

/* LOCAL */
define variable del-yn           like mfc_logical initial yes.
define variable old_site         like pt_site.
define variable msg-nbr          like msg_nbr.
define variable bom_code         like pt_bom_code.
define variable bomValue         like bom_batch.
define variable old_lot_ser      like pt_lot_ser.
define variable source_part      like pt_part     no-undo.
define variable pt_bom_codesv    like pt_bom_code.
define variable pt_pm_codesv     like pt_pm_code.
define variable pt_networksv     like pt_network.
define variable regen_add        like mfc_logical initial no.
define variable part_node        like anx_node.
define variable temp_um          like pt_um.
define variable cfg              like pt_cfg_type format "x(3)" no-undo.
define variable valid_mnemonic   like mfc_logical no-undo.
define variable btb-type         like pt_btb_type format "x(8)" no-undo.
define variable btb-type-desc    like glt_desc    no-undo.
define variable atp-enforcement  like pt_atp_enforcement
   format "x(8)"  label "ATP Enforce"   no-undo.
define variable atp-enforce-desc like glt_desc     no-undo.
define variable l_comm_code      like comd_comm_code no-undo.
define variable error_flag       like mfc_logical               no-undo.
define variable err_mess_no      like msg_nbr                   no-undo.
define variable v_std_cost       like sct_cst_tot               no-undo.
define variable v_std_cost_set   like sct_sim                   no-undo.
define variable l_pt_article     like pt_article                no-undo.
define variable l_pt_break_cat   like pt_break_cat              no-undo.
define variable l_pt_buyer       like pt_buyer                  no-undo.
define variable l_pt_desc1       like pt_desc1                  no-undo.
define variable l_pt_desc2       like pt_desc2                  no-undo.
define variable l_pt_group       like pt_group                  no-undo.
define variable l_pt_part        like pt_part                   no-undo.
define variable l_pt_part_type   like pt_part_type              no-undo.
define variable l_pt_prod_line   like pt_prod_line              no-undo.
define variable l_pt_site        like pt_site                   no-undo.
define variable l_ana_build      like mfc_logical initial no    no-undo.
define variable old_desc1        like pt_desc1                  no-undo.
define variable old_desc2        like pt_desc2                  no-undo.
define variable old_um           like pt_um                     no-undo.

define variable err-flag         as integer.
define variable ps-recno         as recid.
define variable msg              as character no-undo.
define variable apm-ex-prg       as character format "x(10)"    no-undo.
define variable apm-ex-sub       as character format "x(24)"    no-undo.
define variable cfglabel         as character format "x(24)" label "" no-undo.
define variable l_err_msg        as character no-undo.
define variable item_def_div     as character format "x(8)"     no-undo.
define variable prgrp1_desc      as character format "x(26)"    no-undo.
define variable prgrp2_desc      as character format "x(26)"    no-undo.

/* Define Handles for the programs. */
{pxphdef.i gpsecxr}

/*@MODULE APM BEGIN*/
define new shared frame f_apmdata.

/* Variable added to perform delete during CIM. Record is deleted
* Only when the value of this variable is set to "X" */
define variable batchdelete as character format "x(1)" no-undo.

/* DEFINE NEW SHARED TEMPORARY TABLES */
{ifttdiv.i  "new" }
{ifttpgrp.i "new" }
{ifttprgp.i "new" }
{ifttptdv.i "new" }
{ifttptpf.i "new" }

{ppacdef.i &type="new shared"}

define variable item_prig1  like tt-prgrp_prig         no-undo.
define variable item_prig2  like tt-prgrp_prig         no-undo.

/* Local variable to store screen buffer value */
define variable cPart as character no-undo.

define variable lCustomOK as logical no-undo.

/* Item Master API dataset definition */
{pppdspt.i "reference-only"}

{xxppptapm1.i}        /* DEFINE f_apmdata */
/*@MODULE APM END*/

/* NEW FORM DEFINITION TO INCLUDE THE batchdelete VARIABLE */

/*GUI preprocessor Frame A define */
&SCOPED-DEFINE PP_FRAME_NAME A

FORM /*GUI*/  
 RECT-FRAME       AT ROW 1 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1 COLUMN 3 NO-LABEL VIEW-AS TEXT SIZE-PIXELS 1 BY 1
 SKIP(.1)  /*GUI*/
{ppptmtaa.i}
 SKIP(.4)  /*GUI*/
with frame a side-labels width 80 attr-space NO-BOX THREE-D /*GUI*/.

 DEFINE VARIABLE F-a-title AS CHARACTER INITIAL "".
 RECT-FRAME-LABEL:SCREEN-VALUE in frame a = F-a-title.
 RECT-FRAME-LABEL:HIDDEN in frame a = yes.
 RECT-FRAME:HEIGHT-PIXELS in frame a =
  FRAME a:HEIGHT-PIXELS - RECT-FRAME:Y in frame a - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME a = FRAME a:WIDTH-CHARS - .5.  /*GUI*/

/*GUI preprocessor Frame A undefine */
&UNDEFINE PP_FRAME_NAME



/* SET EXTERNAL LABELS */
if c-application-mode <> "API" then
   setFrameLabels(frame a:handle).

/* ITEM MAINTENANCE FRAME INCLUDE FILE */
FORM /*GUI*/  
 RECT-FRAME       AT ROW 1.4 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1   COLUMN 3 NO-LABEL
 SKIP(.1)  /*GUI*/
{xxppptmta2.i}
 SKIP(.4)  /*GUI*/
with frame a1 
side-labels width 80 attr-space NO-BOX THREE-D /*GUI*/.

 DEFINE VARIABLE F-a1-title AS CHARACTER.
 F-a1-title = (getFrameTitle("ITEM_DATA",15)).
 RECT-FRAME-LABEL:SCREEN-VALUE in frame a1 = F-a1-title.
 RECT-FRAME-LABEL:WIDTH-PIXELS in frame a1 =
  FONT-TABLE:GET-TEXT-WIDTH-PIXELS(
  RECT-FRAME-LABEL:SCREEN-VALUE in frame a1 + " ", RECT-FRAME-LABEL:FONT).
 RECT-FRAME:HEIGHT-PIXELS in frame a1 =
  FRAME a1:HEIGHT-PIXELS - RECT-FRAME:Y in frame a1 - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME a1 = FRAME a1:WIDTH-CHARS - .5. /*GUI*/


/* SET EXTERNAL LABELS */
if c-application-mode <> "API" then
   setFrameLabels(frame a1:handle).

FORM /*GUI*/  
 RECT-FRAME       AT ROW 1.4 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1   COLUMN 3 NO-LABEL
 SKIP(.1)  /*GUI*/
{ppptmta3.i}
 SKIP(.4)  /*GUI*/
with frame b 
side-labels width 80 attr-space NO-BOX THREE-D /*GUI*/.

 DEFINE VARIABLE F-b-title AS CHARACTER.
 F-b-title = (getFrameTitle("ITEM_INVENTORY_DATA",28)).
 RECT-FRAME-LABEL:SCREEN-VALUE in frame b = F-b-title.
 RECT-FRAME-LABEL:WIDTH-PIXELS in frame b =
  FONT-TABLE:GET-TEXT-WIDTH-PIXELS(
  RECT-FRAME-LABEL:SCREEN-VALUE in frame b + " ", RECT-FRAME-LABEL:FONT).
 RECT-FRAME:HEIGHT-PIXELS in frame b =
  FRAME b:HEIGHT-PIXELS - RECT-FRAME:Y in frame b - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME b = FRAME b:WIDTH-CHARS - .5. /*GUI*/


/* SET EXTERNAL LABELS */
if c-application-mode <> "API" then
   setFrameLabels(frame b:handle).

FORM /*GUI*/  
 RECT-FRAME       AT ROW 1.4 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1   COLUMN 3 NO-LABEL
 SKIP(.1)  /*GUI*/
{ppptmta4.i}
 SKIP(.4)  /*GUI*/
with frame c 
side-labels width 80 attr-space NO-BOX THREE-D /*GUI*/.

 DEFINE VARIABLE F-c-title AS CHARACTER.
 F-c-title = (getFrameTitle("ITEM_PLANNING_DATA",26)).
 RECT-FRAME-LABEL:SCREEN-VALUE in frame c = F-c-title.
 RECT-FRAME-LABEL:WIDTH-PIXELS in frame c =
  FONT-TABLE:GET-TEXT-WIDTH-PIXELS(
  RECT-FRAME-LABEL:SCREEN-VALUE in frame c + " ", RECT-FRAME-LABEL:FONT).
 RECT-FRAME:HEIGHT-PIXELS in frame c =
  FRAME c:HEIGHT-PIXELS - RECT-FRAME:Y in frame c - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME c = FRAME c:WIDTH-CHARS - .5. /*GUI*/


/* SET EXTERNAL LABELS */
if c-application-mode <> "API" then
   setFrameLabels(frame c:handle).

FORM /*GUI*/  
 RECT-FRAME       AT ROW 1.4 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1   COLUMN 3 NO-LABEL
 SKIP(.1)  /*GUI*/
{ppptmta5.i}
 SKIP(.4)  /*GUI*/
with frame d1 
side-labels width 80 attr-space NO-BOX THREE-D /*GUI*/.

 DEFINE VARIABLE F-d1-title AS CHARACTER.
 F-d1-title = (getFrameTitle("ITEM_PRICE_DATA",23)).
 RECT-FRAME-LABEL:SCREEN-VALUE in frame d1 = F-d1-title.
 RECT-FRAME-LABEL:WIDTH-PIXELS in frame d1 =
  FONT-TABLE:GET-TEXT-WIDTH-PIXELS(
  RECT-FRAME-LABEL:SCREEN-VALUE in frame d1 + " ", RECT-FRAME-LABEL:FONT).
 RECT-FRAME:HEIGHT-PIXELS in frame d1 =
  FRAME d1:HEIGHT-PIXELS - RECT-FRAME:Y in frame d1 - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME d1 = FRAME d1:WIDTH-CHARS - .5. /*GUI*/


/* SET EXTERNAL LABELS */
if c-application-mode <> "API" then
   setFrameLabels(frame d1:handle).

FORM /*GUI*/ 
   {ppptmta9.i}
with frame d ? down title color normal frtitle
width 80 no-attr-space THREE-D /*GUI*/.


/* SET EXTERNAL LABELS */
if c-application-mode <> "API" then
   setFrameLabels(frame d:handle).

{&PPPTMTA-P-TAG1}
FORM /*GUI*/  
 RECT-FRAME       AT ROW 1.4 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1   COLUMN 3 NO-LABEL
 SKIP(.1)  /*GUI*/
{ppptmta9.i}
 SKIP(.4)  /*GUI*/
with frame d0 1 down width 80 overlay row startrow no-labels
 no-attr-space NO-BOX THREE-D /*GUI*/.

 DEFINE VARIABLE F-d0-title AS CHARACTER.
 F-d0-title = (getFrameTitle("TOTALS",16)).
 RECT-FRAME-LABEL:SCREEN-VALUE in frame d0 = F-d0-title.
 RECT-FRAME-LABEL:WIDTH-PIXELS in frame d0 =
  FONT-TABLE:GET-TEXT-WIDTH-PIXELS(
  RECT-FRAME-LABEL:SCREEN-VALUE in frame d0 + " ", RECT-FRAME-LABEL:FONT).
 RECT-FRAME:HEIGHT-PIXELS in frame d0 =
  FRAME d0:HEIGHT-PIXELS - RECT-FRAME:Y in frame d0 - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME d0 = FRAME d0:WIDTH-CHARS - .5. /*GUI*/

{&PPPTMTA-P-TAG2}

FORM /*GUI*/  
 RECT-FRAME       AT ROW 1.4 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1   COLUMN 3 NO-LABEL
 SKIP(.1)  /*GUI*/
{ppptmt10.i}
 SKIP(.4)  /*GUI*/
with frame b1 
   side-labels width 80 attr-space NO-BOX THREE-D /*GUI*/.

 DEFINE VARIABLE F-b1-title AS CHARACTER.
 F-b1-title = (getFrameTitle("ITEM_SHIPPING_DATA",26)).
 RECT-FRAME-LABEL:SCREEN-VALUE in frame b1 = F-b1-title.
 RECT-FRAME-LABEL:WIDTH-PIXELS in frame b1 =
  FONT-TABLE:GET-TEXT-WIDTH-PIXELS(
  RECT-FRAME-LABEL:SCREEN-VALUE in frame b1 + " ", RECT-FRAME-LABEL:FONT).
 RECT-FRAME:HEIGHT-PIXELS in frame b1 =
  FRAME b1:HEIGHT-PIXELS - RECT-FRAME:Y in frame b1 - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME b1 = FRAME b1:WIDTH-CHARS - .5. /*GUI*/


/* SET EXTERNAL LABELS */
if c-application-mode <> "API" then
   setFrameLabels(frame b1:handle).

/*@CTRL BEGIN*/
for first soc_ctrl
   fields( soc_domain soc_apm)
   where soc_domain = global_domain no-lock:
end. /* FOR FIRST soc_ctrl */
/*@CTRL END*/

/* SETUP EVENT NAME FOR QXTEND OUTBOUND */
if ppform = "" then do:
   cEventName = "ItemMaintenance".
end.
else if ppform = "a" then do:
   cEventName = "ItemDataMaintenance".
end.
else if ppform = "b" then do:
   cEventName = "ItemInventoryDataMaintenance".
end.

startrow = 6.

/*@MODULE APM BEGIN*/
if soc_apm
then do:

   /*TrM DB NOT CONNECTED */
   {ifapmcon.i "6316" "pause. return"}
   if ppform = "" or
      ppform = "A"
   then do:
      apm-ex-sub = "if/" . /* ASSIGN APM INTERFACE SUB-DIRECTORY */
      for first apm_ctrl fields (apm_domain apm_prig1)
         where apm_domain = global_domain no-lock:
      end. /* for first apm_ctrl fields(apm_prig1) no-lock: */
      if not available apm_ctrl
      then do:
         /* 6323 - TrM CONTROL FILE NOT FOUND.  PLEASE CREATE USING TrM */
         {pxmsg.i &MSGNUM     = 6323
            &ERRORLEVEL = {&APP-ERROR-NO-REENTER-RESULT}
            &PAUSEAFTER = true
            }
         return.
      end. /* if not available apm_ctrl */

      /* LOAD APM PRODUCT GROUPS */
      {gprunex.i
         &module   = 'APM'
         &subdir   = apm-ex-sub
         &program  = 'ifapm015.p'
         &params   = "(output error_flag,
                       output err_mess_no)" }
      if error_flag
      then do:
         {pxmsg.i &MSGNUM     = err_mess_no
            &ERRORLEVEL = {&APP-ERROR-NO-REENTER-RESULT}
            &PAUSEAFTER = true
            }
         return.
      end. /* IF error_flag */

      /* LOAD APM DIVISIONS */
      {gprunex.i
         &module   = 'APM'
         &subdir   = apm-ex-sub
         &program  = 'ifapm004.p'
         &params   = "(output error_flag,
                       output err_mess_no)" }

      if error_flag
      then do:
         {pxmsg.i &MSGNUM     = err_mess_no
            &ERRORLEVEL = {&APP-ERROR-NO-REENTER-RESULT}
            &PAUSEAFTER = true
            }
         return.
      end. /* IF error_flag */

      if apm_prig1 = yes
      then do:
         /* LOAD APM PRICING GROUPS */
         {gprunex.i
            &module   = 'APM'
            &subdir   = apm-ex-sub
            &program  = 'ifapm016.p'
            &params   = "(output error_flag,
                          output err_mess_no)" }
         if error_flag
         then do:
            {pxmsg.i &MSGNUM     = err_mess_no
               &ERRORLEVEL = {&APP-ERROR-NO-REENTER-RESULT}
               &PAUSEAFTER = true
               }
            return.
         end. /* IF error_flag */
      end. /* IF apm_prig1 = Yes */

      /* LOAD APM ITEM PROFILE DETAILS */
      {gprunex.i
         &module   = 'APM'
         &subdir   = apm-ex-sub
         &program  = 'ifapm020.p'
         &params   = "(output error_flag,
           output err_mess_no)" }
      if error_flag
      then do:
         {pxmsg.i &MSGNUM     = err_mess_no
            &ERRORLEVEL = {&APP-ERROR-NO-REENTER-RESULT}
            &PAUSEAFTER = true
            }
         return.
      end. /* IF error_flag */

   end. /* IF PPFORM = "" OR PPFORM = "A" */

end. /* IF soc_apm */
/*@MODULE APM END*/

for each temp_inactive
   exclusive-lock:
   delete temp_inactive.
end. /* FOR EACH temp_inactive */

if c-application-mode = "API" then do on error undo, return:

   /* Get handle of API Controller */
   {gprun.i ""gpaigach.p"" "(output ApiMethodHandle)"}
/*GUI*/ if global-beam-me-up then undo, leave.


   if not valid-handle(ApiMethodHandle) then do:
      /* API Error */
      {pxmsg.i &MSGNUM=10461 &ERRORLEVEL=4}
      return.
   end.

   /* Get the Item API dataset from the controller */
   run getRequestDataset in ApiMethodHandle (output dataset dsItem bind).

end.  /* If c-application-mode = "API" */

/*DISPLAY*/
mainloop:
repeat:

   /* Get the Item record from the API controller */
   if c-application-mode = "API" then do:
      run getNextRecord in ApiMethodHandle (input "ttItem").
      if return-value = {&RECORD-NOT-FOUND} then
         leave MAINLOOP.
   end. /* if c-application-mode = "API" */

   /* IF WE'VE ADDED A NEW PART & AUTOGEN IS ON, ADD IT TO ANX */
   for first pic_ctrl
      fields( pic_domain pic_item_regen pic__qadc01)
      where pic_domain = global_domain no-lock:
   end. /* FOR FIRST pic_ctrl */

   if available pic_ctrl
   then do:

      if pic_item_regen and regen_add
      then do:
         {gprun.i ""ppptgen.p"" "(input ""6"", input part_node)"}
/*GUI*/ if global-beam-me-up then undo, leave.

         regen_add = no.
      end.

      if substring(pic__qadc01,2,1) = "Y" and l_ana_build
      then do:
         for each anx_det
            where anx_domain = global_domain
            and   anx_node = part_node
            and   anx_type = "6" exclusive-lock:

            /* CREATING TEMP TABLE FOR INACTIVE NODES */
            if not anx_active
            then do:
               create temp_inactive.
               assign
                  temp_inactive_node = part_node
                  temp_inactive_code = anx_code.
            end. /* IF not anx_active */

            delete anx_det.

         end. /* FOR EACH ANX_DET */

         {gprun.i ""ppptgen.p"" "(input ""6"", input part_node)"}
/*GUI*/ if global-beam-me-up then undo, leave.

         l_ana_build = no.

      end.

   end. /* IF AVAIL PIC_CTRL */

   if c-application-mode <> "API" then do:
      hide frame a1 no-pause.
      hide frame b no-pause.
      hide frame b1 no-pause.
      hide frame c no-pause.

      clear frame d no-pause.
      hide frame d1 no-pause.

      hide frame d0 no-pause.
      hide frame d no-pause.

      view frame a.
      if ppform = ""  or ppform = "a"
      then
         view frame a1.

      if ppform = "b" or ppform = ""
      then
         view frame b.

      if ppform = "c"
      then
         view frame c.

      frtitle = getFrameTitle("GENERAL_LEDGER_COST_DATA",18).

      if ppform = "d"
      then do:
         view frame d1.
         view frame d.
      end. /* if ppform = "d" then do: */
   end. /* c-application-mode <> "API" */

   do transaction on endkey undo, leave mainloop:
/*GUI*/ if global-beam-me-up then undo, leave.


      if c-application-mode = "API" and retry then
         undo mainloop, next mainloop.

      if c-application-mode <> "API" then do:
         view frame a.

         if ppform = "" or ppform = "a"
         then
            view frame a1.

         if ppform = "" or ppform = "b"
         then
            view frame b.

         if ppform = "b"
         then
            view frame b1.

         if ppform = "c"
         then
            view frame c.

         if ppform = "d"
         then do:
            view frame d1.

            frtitle = getFrameTitle("GENERAL_LEDGER_COST_DATA",18).
            view frame d.
         end. /* if ppform = "d" then do: */
      end. /* c-application-mode <> "API" */

      /* INITIALIZE batchdelete VARIABLE */
      batchdelete = "".

      if c-application-mode <> "API" then do:
         /* PROMPT-FOR batchdelete VARIABLE ONLY DURING CIM */
         prompt-for pt_mstr.pt_part
            batchdelete no-label when (batchrun) space(0)
            with frame a
         editing:

            /* SET GLOBAL ITEM VARIABLE */
            {pxrun.i &PROC  = 'setSystemDefaultItem' &PROGRAM = 'ppitxr.p'
               &PARAM = "(input pt_part:SCREEN-VALUE)"
               &NOAPPERROR = true
               &CATCHERROR = true
               }

            new_part = no.

            /* FIND NEXT/PREVIOUS RECORD */
            {mfnp.i pt_mstr pt_part  " pt_mstr.pt_domain = global_domain and
                 pt_part "  pt_part pt_part pt_part}

            if recno <> ?
            then do:

               display pt_part pt_desc1 pt_desc2 pt_um
               with frame a.

               if ppform = "" or ppform = "a"
               then
                  display
                     pt_draw
                     pt_rev
                     pt_dsgn_grp
                     pt_drwg_loc
                     pt_drwg_size
                     pt_prod_line
                     pt_group
                     pt_added
                     pt_part_type
                     pt_status
                     pt_break_cat
                     pt_promo
                     pt__chr09
                     pt__chr10
                  with frame a1.

               if ppform = "" or ppform = "b"
               then do:
                  display
                     pt_abc
                     pt_lot_ser
                     pt_site
                     pt_sngl_lot
                     pt_critical
                     pt_loc
                     pt_loc_type
                     pt_auto_lot
                     pt_rctpo_status
                     pt_rctpo_active
                     pt_lot_grp
                     pt_rctwo_status
                     pt_rctwo_active
                     pt_article
                     pt_avg_int
                     pt_cyc_int
                     pt_shelflife
                  with frame b.
               end . /* do: */

               {pxrun.i &PROC  = 'processRead' &PROGRAM = 'ppccxr1.p'
                  &PARAM = "(input  pt_part,
                    buffer comd_det,
                    input  {&NO_LOCK_FLAG},
                    input  {&NO_WAIT_FLAG})"
                  &NOAPPERROR = true
                  &CATCHERROR = true
                  }

               if return-value = {&SUCCESS-RESULT}
               then
                  l_comm_code = comd_comm_code.
               else
                  l_comm_code = "".

               if ppform = "b"
               then
                  display
                     l_comm_code
                     pt_fr_class
                     pt_ship_wt  pt_ship_wt_um
                     pt_net_wt   pt_net_wt_um
                     pt_size     pt_size_um
                  with frame b1.

               if ppform = "c"
               then do:

                  {pxrun.i &PROC  = 'getEmtDescription' &PROGRAM = 'soemxr.p'
                     &PARAM = "(input  pt_btb_type,
                       output btb-type,
                       output btb-type-desc)"
                     &NOAPPERROR = true
                     &CATCHERROR = true
                     }

                  {pxrun.i &PROC  = 'getATPDescription' &PROGRAM = 'soatpxr.p'
                     &PARAM = "(input  pt_atp_enforcement,
                       output atp-enforcement,
                       output atp-enforce-desc)"
                     &NOAPPERROR = true
                     &CATCHERROR = true
                     }

                  define buffer inmstr4 for in_mstr.

                  {pxrun.i &PROC  = 'processRead' &PROGRAM = 'icinxr.p'
                     &PARAM = "(input  pt_part,
                       input  pt_site,
                       buffer inmstr4,
                       input  {&NO_LOCK_FLAG},
                       input  {&NO_WAIT_FLAG})"
                     &NOAPPERROR = true
                     &CATCHERROR = true
                     }

                  display inmstr4.in_mrp when (available inmstr4) @
                     pt_mrp
                     pt_cum_lead
                     pt_ms
                     pt_plan_ord
                     pt_ord_pol
                     pt_ord_qty
                     pt_ord_per
                     pt_sfty_stk
                     pt_sfty_time
                     pt_rop
                     pt_rev
                     pt_buyer
                     pt_vend
                     pt_po_site
                     pt_pm_code
                     pt_mfg_lead
                     pt_pur_lead
                     pt_insp_rqd
                     pt_insp_lead
                     pt_timefence
                     pt_iss_pol
                     pt_phantom
                     pt_ord_min
                     pt_ord_max
                     pt_ord_mult
                     pt_op_yield
                     pt_yield_pct
                     pt_run pt_setup
                     btb-type
                     pt__qad15
                     pt_network
                     pt_routing
                     pt_bom_code
                     pt_run_seq1
                     pt_run_seq2
                     atp-enforcement
                     pt_atp_family
                  with frame c.

                  {pxrun.i &PROC  = 'getConfigTypeDesc' &PROGRAM = 'ppitxr.p'
                     &PARAM = "(input  pt_cfg_type,
                       output cfg,
                       output cfglabel)"
                     &NOAPPERROR = true
                     &CATCHERROR = true
                     }

                  display cfg with frame c.

                  {pxrun.i &PROC  = 'processRead' &PROGRAM = 'bmbmxr.p'
                     &PARAM = "(input  (if pt_bom_code <> ''
                                        then
                                           pt_bom_code
                                        else
                                           pt_part),
                       buffer bom_mstr,
                       input  {&NO_LOCK_FLAG},
                       input  {&NO_WAIT_FLAG})"
                     &NOAPPERROR = true
                     &CATCHERROR = true
                     }

                  {pxrun.i &PROC  = 'getBomBatchValue' &PROGRAM = 'bmbmxr.p'
                     &PARAM = "(buffer bom_mstr,
                       output bomValue)"
                     &NOAPPERROR = true
                     &CATCHERROR = true
                     }

                  display
                     bomValue
                     @ pt_batch with frame c.

               end. /* if ppform = "c" then do: */

               if ppform = "d"
               then
               display pt_price
                  pt_taxc pt_taxable
               with frame d1.

            end. /* IF recno */

         end. /* PROMPT-FOR...EDITING */
      end. /* c-application-mode <> "API" */

      /* ADD/MOD/DELETE  */
      del-yn = no.

      if c-application-mode <> "API" then
         cPart = pt_part:screen-value in frame a.
      else
         cPart = ttItem.ptPart.

      {pxrun.i &PROC  = 'processRead' &PROGRAM = 'ppitxr.p'
         &PARAM = "(input cPart,
           buffer pt_mstr,
           input  {&LOCK_FLAG},
           input  {&WAIT_FLAG})"
         &NOAPPERROR = true
         &CATCHERROR = true
         }

      if return-value <> {&SUCCESS-RESULT}
      then do:
         /* ADD ONLY ON ENGINEERING MAINT */
         if ppform <> "" and ppform <> "a"
         then do:
            /* 16 - ITEM NUMBER DOES NOT EXIST */
            {pxmsg.i &MSGNUM    = 16
               &ERRORLEVEL = {&APP-ERROR-RESULT}
               }
            undo mainloop.
         end. /* IF ppform <> "" AND ppform <> "a" then do: */

         {pxrun.i &PROC = 'validateCreate' &PROGRAM = 'ppitxr.p'
            &PARAM      = "(input cPart)"
            &NOAPPERROR = true
            &CATCHERROR = true
            }

         if return-value <> {&SUCCESS-RESULT}
         then do:
            undo,retry.
         end. /* IF return-value <> {&SUCCESS-RESULT} */

         else if return-value = {&SUCCESS-RESULT}
         then do:

            /* 1 - ADDING NEW RECORD */
            {pxmsg.i &MSGNUM     = 1
               &ERRORLEVEL = {&INFORMATION-RESULT}
               }

            {pxrun.i &PROC = 'processCreate' &PROGRAM = 'ppitxr.p'
               &PARAM      = "(input cPart,
                 input  '',
                 buffer pt_mstr)"
               &NOAPPERROR = true
               &CATCHERROR = true
               }

            if return-value <> {&SUCCESS-RESULT}
            then do:
               undo,retry.
            end. /* IF return-value <> {&SUCCESS-RESULT} */

            new_part = yes.

         end. /* IF return-value = {&SUCCESS-RESULT} */

      end. /* IF return-value <> {&SUCCESS-RESULT} */

      /* STORE MODIFY DATE AND USERID FOR AN ITEM CREATED/MODIFIED */
      {pxrun.i &PROC = 'setModificationInfo' &PROGRAM = 'ppitxr.p'
         &PARAM      = "(buffer pt_mstr)"
         &NOAPPERROR = true
         &CATCHERROR = true
         }

      assign
         pt_bom_codesv = pt_bom_code
         pt_pm_codesv  = pt_pm_code
         pt_networksv  = pt_network
         promo_old     = pt_promo
         recno         = recid(pt_mstr)
         pt_recno      = recid(pt_mstr).

      do on error undo mainloop, leave mainloop:
/*GUI*/ if global-beam-me-up then undo, leave.


         if c-application-mode = "API" and retry then
            undo mainloop, next mainloop.

         if c-application-mode <> "API" then do:
           /* DISPLAY */
            display pt_desc1 pt_desc2 pt_um
            with frame a.

            if ppform = "" or ppform = "a"
            then
               display pt_prod_line pt_added pt_group pt_rev
                  pt_part_type pt_draw pt_status
                  pt_dsgn_grp pt_drwg_loc pt_drwg_size
                  pt_break_cat
                  pt_promo
               with frame a1.

            if ppform = ""
            then
               display
                  pt_abc
                  pt_lot_ser
                  pt_site
                  pt_sngl_lot
                  pt_critical
                  pt_loc
                  pt_loc_type
                  pt_auto_lot
                  pt_lot_grp
                  pt_rctpo_status
                  pt_rctpo_active
                  pt_rctwo_status
                  pt_rctwo_active
                  pt_article
                  pt_avg_int
                  pt_cyc_int
                  pt_shelflife
               with frame b.

            temp_um = input pt_um.

         end. /* c-application-mode <> "API" */
         else do:
            /* For an ADD operation, populate dataset with defaults */
            if ttItem.operation = {&ADD} then
            assign
               {mfaidflt.i ttItem.ptUm          pt_um}
               {mfaidflt.i ttItem.ptDesc1       pt_desc1}
               {mfaidflt.i ttItem.ptDesc2       pt_desc2}
               {mfaidflt.i ttItem.ptProdLine    pt_prod_line}
               {mfaidflt.i ttItem.ptAdded       pt_added}
               {mfaidflt.i ttItem.ptGroup       pt_group}
               {mfaidflt.i ttItem.ptRev         pt_rev}
               {mfaidflt.i ttItem.ptPartType    pt_part_type}
               {mfaidflt.i ttItem.ptDraw        pt_draw}
               {mfaidflt.i ttItem.ptStatus      pt_status}
               {mfaidflt.i ttItem.ptDsgnGrp     pt_dsgn_grp}
               {mfaidflt.i ttItem.ptDrwgLoc     pt_drwg_loc}
               {mfaidflt.i ttItem.ptDrwgSize    pt_drwg_size}
               {mfaidflt.i ttItem.ptBreakCat    pt_break_cat}
               {mfaidflt.i ttItem.ptPromo       pt_promo}
               {mfaidflt.i ttItem.ptAbc         pt_abc}
               {mfaidflt.i ttItem.ptLotSer      pt_lot_ser}
               {mfaidflt.i ttItem.ptSite        pt_site}
               {mfaidflt.i ttItem.ptSnglLot     pt_sngl_lot}
               {mfaidflt.i ttItem.ptCritical    pt_critical}
               {mfaidflt.i ttItem.ptLoc         pt_loc}
               {mfaidflt.i ttItem.ptLocType     pt_loc_type}
               {mfaidflt.i ttItem.ptAutoLot     pt_auto_lot}
               {mfaidflt.i ttItem.ptLotGrp      pt_lot_grp}
               {mfaidflt.i ttItem.ptRctpoStatus pt_rctpo_status}
               {mfaidflt.i ttItem.ptRctpoActive pt_rctpo_active}
               {mfaidflt.i ttItem.ptRctwoStatus pt_rctwo_status}
               {mfaidflt.i ttItem.ptRctwoActive pt_rctwo_active}
               {mfaidflt.i ttItem.ptArticle     pt_article}
               {mfaidflt.i ttItem.ptAvgInt      pt_avg_int}
               {mfaidflt.i ttItem.ptCycInt      pt_cyc_int}
               {mfaidflt.i ttItem.ptShelflife   pt_shelflife}
            temp_um = pt_um.
         end. /* c-application-mode = "API" */

         /* SET */
         if ppform = "" or  ppform = "a"
         then do:

            {pxrun.i &PROC  = 'p-assign-msg'
               &PARAM = "(output l_err_msg)"
               &NOAPPERROR = true
               &CATCHERROR = true
               }

            if not regen_add
            then
               assign
                  l_pt_desc1 = pt_desc1
                  l_pt_desc2 = pt_desc2.

            if c-application-mode <> "API" then do:
               /* ADDED THE FOLLOWING CODE FOR GUI TO SEPARATE THE EDITING */
               /* FROM THE SET STATEMENT AS IT WAS TRAPPING THE 'CTRL-C'   */
               /* AND THROWING THE USER OUT INSTEAD OF COPYING             */
               if ppform = ""
               then
                  ststatus = stline[2].
               else
                  ststatus = stline[3].

               status input ststatus.
            end. /* c-application-mode <> "API" */

            set1:
            do on error undo, retry:
/*GUI*/ if global-beam-me-up then undo, leave.


               if (c-application-mode = "API"
                  or batchrun)
                  and retry
               then
                  undo mainloop, next mainloop.

               if c-application-mode <> "API" then do:
                  set pt_um
                     validate( {gpcode.v pt_um }, l_err_msg)
                     pt_desc1
                     pt_desc2
                  go-on ("F5" "CTRL-D")
                  with frame a.
                  if batchrun
                     and not ({gpcode.v pt_um})
                  then do:
                     /* VALUE MUST EXIST IN GENERALIZED CODES */
                     {pxmsg.i &MSGNUM=716 &ERRORLEVEL=3 &FIELDNAME=""ptUm""}
                     undo set1, retry set1.
                  end. /* IF batchrun AND NOT ({gpcode.v pt_um}) */
               end. /* c-application-mode <> "API" */
               else do:
                  assign
                     old_um    = pt_um
                     old_desc1 = pt_desc1
                     old_desc2 = pt_desc2.

                  if ttItem.operation <> {&REMOVE} then
                  assign
                     pt_um    = ttItem.ptUm
                     pt_desc1 = ttItem.ptDesc1
                     pt_desc2 = ttItem.ptDesc2.

                  /* VALIDATE FIELD SECURITY */
                  if old_um <> pt_um
                  then do:
                     {pxrun.i &PROC='validateFieldAccess' &PROGRAM='gpsecxr.p'
                        &HANDLE=ph_gpsecxr
                        &PARAM="(input 'pt_um',
                                 input '')"
                        &NOAPPERROR=true
                        &CATCHERROR=true}
                     if return-value <> {&SUCCESS-RESULT} then
                        undo set1, retry set1.
                  end.

                  if not ({gpcode.v pt_um})
                  then do:
                     /* VALUE MUST EXIST IN GENERALIZED CODES */
                     {pxmsg.i &MSGNUM=716 &ERRORLEVEL=3 &FIELDNAME=""ptUm""}
                     undo set1, retry set1.
                  end.

                  /* VALIDATE FIELD SECURITY */
                  if old_desc1 <> pt_desc1
                  then do:
                     {pxrun.i &PROC='validateFieldAccess' &PROGRAM='gpsecxr.p'
                        &HANDLE=ph_gpsecxr
                        &PARAM="(input 'pt_desc1',
                                 input '')"
                        &NOAPPERROR=true
                        &CATCHERROR=true}
                     if return-value <> {&SUCCESS-RESULT} then
                        undo set1, retry set1.
                  end.

                  /* VALIDATE FIELD SECURITY */
                  if old_desc2 <> pt_desc2
                  then do:
                     {pxrun.i &PROC='validateFieldAccess' &PROGRAM='gpsecxr.p'
                        &HANDLE=ph_gpsecxr
                        &PARAM="(input 'pt_desc2',
                                 input '')"
                        &NOAPPERROR=true
                        &CATCHERROR=true}
                     if return-value <> {&SUCCESS-RESULT} then
                        undo set1, retry set1.
                  end.

               end. /* c-application-mode = "API" */

               /* DELETE */
               if    ppform <> ""
               and ((c-application-mode <> "API"
                     and (lastkey =  keycode("F5")
                          or lastkey =  keycode("CTRL-D")
                          or input batchdelete   =  "x"))
                    or (c-application-mode = "API"
                        and ttItem.operation = {&REMOVE}))
               then do:
                  /* DELETE NOT ALLOWED */
                  {pxmsg.i &MSGNUM     = 1021
                           &ERRORLEVEL = "3"}
                  undo set1,retry set1.
               end. /*IF ppform <> "AND ...*/

               if c-application-mode <> "API" then do:
                  if ppform = ""
                         and  (lastkey = keycode("F5")
                               or lastkey = keycode("CTRL-D")
                               or input batchdelete = "x")
                  then do:

                     del-yn = yes.

                     /* 11 - PLEASE CONFIRM DELETE */
                     {pxmsg.i &MSGNUM     = 11
                              &ERRORLEVEL = {&INFORMATION-RESULT}
                              &CONFIRM    = del-yn
                     }

                     if not del-yn
                     then
                        undo set1, retry set1.
                  end. /* IF ppform = "" AND ... */

               end. /* c-application-mode <> "API" */
               else do:
                  del-yn = (ttItem.operation = {&REMOVE}).
               end. /* c-application-mode = "API" */
            end.
/*GUI*/ if global-beam-me-up then undo, leave.
 /* SET1 */

            if not regen_add
               and (l_pt_desc1 <> pt_desc1
               or   l_pt_desc2 <> pt_desc2)
            then
               assign part_node   = pt_part
               l_ana_build = yes.

         end. /* IF ppform = "" ... */

         /* DELETE */
         if
            del-yn = yes or
            input batchdelete = "x"
         then do:

            {gprun.i 'ppptdel.p'
               "(input  pt_recno,
                 output undo_del,
                 output msg)"
               }
/*GUI*/ if global-beam-me-up then undo, leave.

            if undo_del
            then
               next mainloop.

            assign ptRowID = rowid({&QXO-TABLE})
                   ptOID = oid_{&QXO-TABLE}.

            {pxrun.i &PROC = 'processDelete' &PROGRAM = 'ppitxr.p'
               &PARAM      = "(buffer pt_mstr)"
               &NOAPPERROR = true
               &CATCHERROR = true
               }
            if return-value <> {&SUCCESS-RESULT}
            then
               next mainloop.

            run fireOutboundEvent (input cEventName,
                                   input '{&QXO-TABLE}',
                                   input ptRowID,
                                   input ptOID,
                                   input 'DELETE').

            if c-application-mode <> "API" then
               clear frame a.
/*GUI*/ RECT-FRAME-LABEL:SCREEN-VALUE in frame a = F-a-title.
            del-yn = no.
            next mainloop.

         end. /* IF del-yn = yes */

         assign qxo_write = true.

         if c-application-mode <> "API" then
            status input.

         if pt_um <> temp_um
         then do:
            {pxrun.i &PROC  = 'validateUMInTransHist' &PROGRAM = 'ppitxr.p'
               &PARAM = "(input pt_part)"
               &NOAPPERROR = true
               &CATCHERROR = true
               }
         end. /* IF pt_um <> temp_um */

         /*@MODULE APM BEGIN*/
         if ppform <> "b" and
            ppform <> "c" and
            ppform <> "d"
         then
         if soc_apm and
            (promo_old <> "" or pt_promo <> "")
         then do:
            /* Future logic will go here to determine subdirectory*/
            apm-ex-prg = "ifprod.p".
            apm-ex-sub = "if/".

            for first si_mstr
               fields( si_domain si_site si_cur_set si_gl_set)
               where si_domain = global_domain and si_site = pt_site
            no-lock:
            end. /* FOR FIRST si_mstr */

            /* RUN INTERNAL PROCEDURE TO OBTAIN COST SET AND COST */
            {pxrun.i &PROC  = 'get_std_cost'
               &PARAM = "(input  pt_part,
                 input  si_site,
                 output v_std_cost,
                 output v_std_cost_set)"
               &NOAPPERROR = true
               &CATCHERROR = true
               }

            /* UPDATE GENERIC ITEM RECORD IN APM */
            {gprunex.i
               &module   = 'APM'
               &subdir   = apm-ex-sub
               &program  = 'ifapm054.p'
               &params   = "(input  pt_part,
                 input  pt_desc1,
                 input  pt_desc2,
                 input  pt_net_wt,
                 input  pt_net_wt_um,
                 input  pt_price,
                 input  pt_promo,
                 input  pt_site,
                 input  pt_taxc,
                 input  pt_um,
                 input  v_std_cost,
                 input  v_std_cost_set,
                 input  pt_pm_code,
                 output error_flag,
                 output err_mess_no)"}

            if error_flag
            then do:
               /* ERROR RETURNED BY IFAPM054.P */
               {pxmsg.i &MSGNUM=err_mess_no
                  &ERRORLEVEL={&APP-ERROR-RESULT}
                  }
               undo, return.
            end. /* IF error_flag */

         end.
/*GUI*/ if global-beam-me-up then undo, leave.
 /* IF soc_apm and (promo_old <> "" and ... )  */
         /*@MODULE APM END*/

         if new_part
         then do:

            undo_all = yes.

            {gprun.i ""xxptmta1.p""}
/*GUI*/ if global-beam-me-up then undo, leave.


            if c-application-mode = "API" and not undo_all then do:
               /* Run any customizations in API mode for pt_mstr */
               run applyCustomizations in ApiMethodHandle
                  (input "ttItem",
                   input (buffer pt_mstr:handle),
                   input "a,a1",
                   output lCustomOK).

               if not lCustomOK then
                  undo_all = true.
            end.

            if not regen_add
               and (l_pt_break_cat <> pt_break_cat
               or   l_pt_group     <> pt_group
               or   l_pt_part_type <> pt_part_type
               or   l_pt_prod_line <> pt_prod_line)
            then
            assign part_node   = pt_part
               l_ana_build = yes.

            if keyfunction(lastkey) = "end-error"
               or undo_all
            then undo mainloop, retry mainloop.

            regen_add = yes.     /*we have a record so we can     */
            part_node = pt_part. /*add this part (node) to anx_det*/

         end. /* IF new_part */

         if not regen_add
         then
            assign
               l_pt_article    = pt_article
               l_pt_break_cat  = pt_break_cat
               l_pt_buyer      = pt_buyer
               l_pt_desc1      = pt_desc1
               l_pt_desc2      = pt_desc2
               l_pt_group      = pt_group
               l_pt_part       = pt_part
               l_pt_part_type  = pt_part_type
               l_pt_prod_line  = pt_prod_line
               l_pt_site       = pt_site.

      end.
/*GUI*/ if global-beam-me-up then undo, leave.
 /* DO ON ERROR */

      if (ppform = "" or ppform = "a")  and not new_part
      then do
         on endkey undo, next mainloop:

         undo_all = yes.
         {gprun.i ""xxptmta1.p""}
/*GUI*/ if global-beam-me-up then undo, leave.


         if c-application-mode = "API" and not undo_all then do:
            /* Run any customizations in API mode for pt_mstr */
            run applyCustomizations in ApiMethodHandle
               (input "ttItem",
                input (buffer pt_mstr:handle),
                input "a,a1",
                output lCustomOK).

            if not lCustomOK then
               undo_all = true.
         end.

         if not regen_add
            and (l_pt_break_cat <> pt_break_cat
            or   l_pt_group     <> pt_group
            or   l_pt_part_type <> pt_part_type
            or   l_pt_prod_line <> pt_prod_line)
         then
            assign part_node   = pt_part
               l_ana_build = yes.

         if keyfunction (lastkey) = "end-error"
            or undo_all
         then do:
            if batchrun
            then
               undo mainloop, retry mainloop.
            else
               next mainloop.
         end. /* IF KEYFUNCTION (LASTKEY) = "END-ERROR" */
      end. /* IF (ppform = "" or ppform = "a") AND ... */

   end. /* DO TRANSACTION WITH frame a */

   if (ppform = "" or ppform = "b")
   then do
     on endkey undo, next mainloop
     on error undo mainloop, next mainloop:
/*GUI*/ if global-beam-me-up then undo, leave.


      {gprun.i ""ppptmtb.p""}
/*GUI*/ if global-beam-me-up then undo, leave.


      if not regen_add
         and (l_pt_article   <> pt_article
         or   l_pt_site      <> pt_site)
      then
         assign part_node   = pt_part
            l_ana_build = yes.

      if keyfunction (lastkey) = "end-error"
      then do:
         if qxo_write then
            run fireOutboundEvent (input cEventName,
                                   input '{&QXO-TABLE}',
                                   input rowid({&QXO-TABLE}),
                                   input oid_{&QXO-TABLE},
                                   input 'WRITE').
         next mainloop.
      end.

   end.
/*GUI*/ if global-beam-me-up then undo, leave.
 /* IF ppform = ...*/
   /*END LOOP B */

   if c-application-mode <> "API" then do:
      hide frame a1 no-pause.
      hide frame b no-pause.
      hide frame b1 no-pause.
   end. /* c-application-mode <> "API" */

   if ppform = "" or ppform = "c"
   then do
      on endkey undo, next mainloop
      on error undo mainloop, next mainloop:
/*GUI*/ if global-beam-me-up then undo, leave.


      {gprun.i ""ppptmtc.p""}
/*GUI*/ if global-beam-me-up then undo, leave.

      if not regen_add
         and l_pt_buyer     <> pt_buyer
      then
         assign part_node   = pt_part
            l_ana_build = yes.

      {mgqqapp.i "pt_app_owner"}

      if keyfunction(lastkey) = "end-error"
      then do:
         if qxo_write then
            run fireOutboundEvent (input cEventName,
                                   input '{&QXO-TABLE}',
                                   input rowid({&QXO-TABLE}),
                                   input oid_{&QXO-TABLE},
                                   input 'WRITE').
         next mainloop.
      end.

   end.
/*GUI*/ if global-beam-me-up then undo, leave.
 /* REPEAT: */
   /* END LOOP C */

   if c-application-mode <> "API" then
      hide frame c no-pause.

   /* COSTING */
   if ppform = "" or ppform = "d"
   then do
      on endkey undo, next mainloop
      on error undo mainloop, next mainloop:
/*GUI*/ if global-beam-me-up then undo, leave.

      {gprun.i ""ppptmtd.p""}
/*GUI*/ if global-beam-me-up then undo, leave.

      if keyfunction(lastkey) = "end-error"
      then do:
         if qxo_write then
            run fireOutboundEvent (input cEventName,
                                   input '{&QXO-TABLE}',
                                   input rowid({&QXO-TABLE}),
                                   input oid_{&QXO-TABLE},
                                   input 'WRITE').
         next mainloop.
      end.
   end.
/*GUI*/ if global-beam-me-up then undo, leave.
 /* IF ppform = "" OR ppform = "d" */

   if ppform = " "
   then do:
      /* SEE IF USER WOULD LIKE TO SEE SERVICE DATA HERE */
      for first svc_ctrl
         fields( svc_domain svc_itm_data)
         where svc_domain = global_domain no-lock:
      end. /* FOR FIRST svc_ctrl */

      if available svc_ctrl and svc_itm_data
      then do
         on endkey undo, next mainloop:
         if c-application-mode <> "API" then do:
            hide frame d0.
            hide frame d1.
         end. /* c-application-mode <> "API" */
         {fsptfrm.i "new"}
         {gprun.i ""fsptmt1.p"" "(input pt_part)"}
/*GUI*/ if global-beam-me-up then undo, leave.

      end. /* IF AVAILABLE svc_ctrl AND ... */
   end.    /* IF ppform = " " */

   /*@MODULE APM BEGIN*/
   /* IF APM FLAG IS IN USE AND pt_promo IS SET */
   if soc_apm and pt_promo <> ""
   and c-application-mode <> "API"
   then do:
      if ppform = "" or
         ppform = "A"
      then do:
         hide frame d.
         hide frame d0.
         hide frame d1.
         /* PROCESS APM DETAILS */
         {gprun.i ""ppptapm1.p"" "( input pt_part)"}
/*GUI*/ if global-beam-me-up then undo, leave.

         hide frame f_apmdata.
      end. /* IF ppform = "" OR ppform = "A" */
   end. /* IF soc_apm */
/*@MODULE APM END*/

   if qxo_write then
      run fireOutboundEvent (input cEventName,
                             input '{&QXO-TABLE}',
                             input rowid({&QXO-TABLE}),
                             input oid_{&QXO-TABLE},
                             input 'WRITE').

end.
/* END MAIN LOOP */
if c-application-mode <> "API" then
   status input.

/*@MODULE APM BEGIN*/
{pppstdcs.i} /* INTERNAL PROCEDURE TO OBTAIN COST SET AND COST */
/*@MODULE APM END*/

               /*MAIN-END*/
/********************************************************************/
/* ==========================================================================
*/
/* ========================================================================== */
/* *************************** INTERNAL PROCEDURES ************************** */
/* ========================================================================== */

/*============================================================================*/
PROCEDURE p-assign-msg:
/*---------------------------------------------------------------------------
Purpose:     TO ASSIGN MESSAGE DESCRIPTION TO A VARIABLE.
Exceptions:  NONE
Notes:
History:
---------------------------------------------------------------------------*/

   define output parameter l_err_msg as character no-undo.

   /* VALUE MUST EXIST IN GENERALIZED CODES. PLEASE RE-ENTER */
   {pxmsg.i &MSGNUM     = 7412
      &ERRORLEVEL = {&APP-ERROR-NO-REENTER-RESULT}
      &MSGBUFFER  = l_err_msg
      }

END PROCEDURE. /* p-assign-msg */
