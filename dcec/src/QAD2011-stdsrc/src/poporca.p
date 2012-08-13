/* GUI CONVERTED from poporca.p (converter v1.78) Thu Apr  5 06:41:20 2012 */
/* poporca.p - PURCHASE ORDER RECEIPT W/ SERIAL NUMBER CONTROL                */
/* Copyright 1986-2012 QAD Inc., Santa Barbara, CA, USA.                      */
/* All rights reserved worldwide.  This is an unpublished work.               */
/*                                                                            */
/* REVISION: 7.0     LAST MODIFIED: 11/19/91    BY: pma *F003*                */
/* REVISION: 7.0     LAST MODIFIED: 12/09/91    BY: RAM *F070*                */
/* REVISION: 7.0     LAST MODIFIED: 01/31/92    BY: RAM *F126*                */
/* REVISION: 7.0     LAST MODIFIED: 02/12/92    BY: pma *F190*                */
/* REVISION: 7.0     LAST MODIFIED: 03/03/92    BY: pma *F085*                */
/* REVISION: 7.0     LAST MODIFIED: 03/09/92    BY: RAM *F269*                */
/* REVISION: 7.0     LAST MODIFIED: 03/11/92    BY: pma *F087*                */
/* REVISION: 7.0     LAST MODIFIED: 03/24/92    BY: RAM *F311*                */
/* REVISION: 7.3     LAST MODIFIED: 10/24/92    BY: sas *G240*                */
/* REVISION: 7.3     LAST MODIFIED: 09/27/92    BY: jcd *G247*                */
/* REVISION: 7.3     LAST MODIFIED: 11/10/92    BY: pma *G304*                */
/* REVISION: 7.3     LAST MODIFIED: 12/14/92    BY: tjs *G443*                */
/* REVISION: 7.3     LAST MODIFIED: 01/11/93    BY: bcm *G425*                */
/* REVISION: 7.3     LAST MODIFIED: 01/18/93    BY: WUG *G563*                */
/* REVISION: 7.3     LAST MODIFIED: 02/22/93    BY: tjs *G718*                */
/* REVISION: 7.3     LAST MODIFIED: 04/09/93    BY: WUG *G873*                */
/* REVISION: 7.3     LAST MODIFIED: 04/19/93    BY: tjs *G964*                */
/* REVISION: 7.2     LAST MODIFIED: 05/13/93    BY: kgs *GA90*                */
/* REVISION: 7.2     LAST MODIFIED: 05/26/93    BY: kgs *GB35*                */
/* REVISION: 7.3     LAST MODIFIED: 06/17/93    BY: WUG *GC41*                */
/* REVISION: 7.3     LAST MODIFIED: 06/21/93    BY: WUG *GC57*                */
/* REVISION: 7.3     LAST MODIFIED: 06/30/93    BY: dpm *GC87*                */
/* REVISION: 7.4     LAST MODIFIED: 07/02/93    BY: jjs *H020*                */
/* REVISION: 7.4     LAST MODIFIED: 07/26/93    BY: WUG *H038*                */
/* REVISION: 7.4     LAST MODIFIED: 09/15/93    BY: tjs *H093*                */
/* REVISION: 7.3     LAST MODIFIED: 11/19/93    BY: afs *H236*                */
/* REVISION: 7.3     LAST MODIFIED: 04/19/94    BY: dpm *GJ42*                */
/* REVISION: 7.3     LAST MODIFIED: 07/19/94    BY: dpm *FP45*                */
/* REVISION: 7.3     LAST MODIFIED: 07/28/94    BY: dpm *FP66*                */
/* REVISION: 7.3     LAST MODIFIED: 08/02/94    BY: rmh *FP73*                */
/* REVISION: 7.3     LAST MODIFIED: 09/11/94    BY: rmh *GM16*                */
/* REVISION: 7.3     LAST MODIFIED: 09/20/94    BY: ljm *GM74*                */
/* REVISION: 7.3     LAST MODIFIED: 10/11/94    BY: cdt *FS26*                */
/* REVISION: 7.3     LAST MODIFIED: 10/18/94    BY: cdt *FS54*                */
/* REVISION: 8.5     LAST MODIFIED: 10/24/94    BY: pma *J040*                */
/* REVISION: 7.3     LAST MODIFIED: 10/25/94    BY: cdt *FS78*                */
/* REVISION: 8.5     LAST MODIFIED: 10/27/94    BY: taf *J038*                */
/* REVISION: 7.3     LAST MODIFIED: 10/27/94    BY: ljm *GN62*                */
/* REVISION: 7.3     LAST MODIFIED: 11/10/94    BY: bcm *GO37*                */
/* REVISION: 8.5     LAST MODIFIED: 11/22/94    BY: mwd *J034*                */
/* REVISION: 8.5     LAST MODIFIED: 12/14/94    BY: ktn *J041*                */
/* REVISION: 8.5     LAST MODIFIED: 12/20/94    BY: tjs *J014*                */
/* REVISION: 7.4     LAST MODIFIED: 12/28/94    BY: srk *G0B2*                */
/* REVISION: 7.3     LAST MODIFIED: 03/15/95    BY: pcd *G0HJ*                */
/* REVISION: 7.4     LAST MODIFIED: 03/22/95    BY: dxk *F0NS*                */
/* REVISION: 7.4     LAST MODIFIED: 05/22/95    BY: jym *F0S0*                */
/* REVISION: 8.5     LAST MODIFIED: 06/07/95    BY: sxb *J04D*                */
/* REVISION: 8.5     LAST MODIFIED: 07/31/95    BY: kxn *J069*                */
/* REVISION: 8.5     LAST MODIFIED: 09/26/95    BY: kxn *J07M*                */
/* REVISION: 8.5     LAST MODIFIED: 10/07/95    BY: kxn *J08J*                */
/* REVISION: 7.4     LAST MODIFIED: 07/11/95    BY: jym *G0RY*                */
/* REVISION: 7.4     LAST MODIFIED: 08/07/95    BY: jym *G0TP*                */
/* REVISION  7.4     LAST MODIFIED: 08/15/95    BY: rvw *G0V0*                */
/* REVISION  7.4     LAST MODIFIED: 09/12/95    BY: ais *F0V7*                */
/* REVISION  7.4     LAST MODIFIED: 10/23/95    BY: ais *G19K*                */
/* REVISION  7.4     LAST MODIFIED: 10/31/95    BY: jym *F0TC*                */
/* REVISION: 8.5     LAST MODIFIED: 11/07/95    BY: kxn *J091*                */
/* REVISION: 8.5     LAST MODIFIED: 03/11/96    BY: jpm *J0F5*                */
/* REVISION: 8.5     LAST MODIFIED: 03/28/96    BY: rxm *G1R9*                */
/* REVISION: 8.5     LAST MODIFIED: 05/01/96    BY: *J04C* Sue Poland         */
/* REVISION: 8.5     LAST MODIFIED: 05/14/96    BY: *G1SL* Robin McCarthy     */
/* REVISION: 8.5     LAST MODIFIED: 06/28/96    BY: *J0WR* Sue Poland         */
/* REVISION: 8.5     LAST MODIFIED: 07/03/96    BY: *G1Z8* Ajit Deodhar       */
/* REVISION: 8.5     LAST MODIFIED: 07/29/96    BY: *J12S* Kieu Nguyen        */
/* REVISION: 8.5     LAST MODIFIED: 09/03/96    BY: *J14K* Sue Poland         */
/* REVISION: 8.5     LAST MODIFIED: 01/05/97    BY: *J1DH* Julie Milligan     */
/* REVISION  8.5     LAST MODIFIED: 02/27/97    BY: *H0SN* Suresh Nayak       */
/* REVISION: 8.5     LAST MODIFIED: 04/30/97    BY: *J1QB* Sanjay Patil       */
/* REVISION: 8.5     LAST MODIFIED: 05/13/97    BY: *G2M4* Ajit Deodhar       */
/* REVISION: 8.5     LAST MODIFIED: 10/15/97    BY: *J22T* Niranjan Ranka     */
/* REVISION: 8.6E    LAST MODIFIED: 02/23/98    BY: *L007* A. Rahane          */
/* REVISION: 8.6E    LAST MODIFIED: 04/01/98    BY: *J2HH* A. Licha           */
/* REVISION: 8.6E    LAST MODIFIED: 06/26/98    BY: *J2MG* Samir Bavkar       */
/* REVISION: 8.6E    LAST MODIFIED: 06/30/98    BY: *J2P2* Niranjan R.        */
/* REVISION: 8.6E    LAST MODIFIED: 07/29/98    BY: *J2QC* Niranjan R.        */
/* REVISION: 8.6E    LAST MODIFIED: 08/20/98    BY: *J2WJ* Ajit Deodhar       */
/* REVISION: 9.0     LAST MODIFIED: 01/19/99    BY: *J38P* Surekha Joshi      */
/* REVISION: 9.0     LAST MODIFIED: 03/13/99    BY: *M0BD* Alfred Tan         */
/* REVISION: 9.0     LAST MODIFIED: 04/16/99    BY: *J2DG* Reetu Kapoor       */
/* REVISION: 9.0     LAST MODIFIED: 05/15/99    BY: *J39K* Sanjeev Assudani   */
/* REVISION: 9.1     LAST MODIFIED: 10/25/99    BY: *N002* Bill Gates         */
/* REVISION: 9.1     LAST MODIFIED: 03/06/00    BY: *N05Q* Thelma Stronge     */
/* REVISION: 9.1     LAST MODIFIED: 03/24/00    BY: *N08T* Annasaheb Rahane   */
/* REVISION: 9.1     LAST MODIFIED: 03/28/00    BY: *N090* David Morris       */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* REVISION: 9.1     LAST MODIFIED: 07/28/00    BY: *M0PQ* Falguni Dalal      */
/* REVISION: 9.1      LAST MODIFIED: 05/21/00   BY: Strip/Beautify:  3.0      */
/* REVISION: 9.1     LAST MODIFIED: 06/27/00    BY: *N0DM* Mudit Mehta        */
/* REVISION: 9.1     LAST MODIFIED: 07/14/00    BY: *N0DV* Inna Lyubarsky     */
/* REVISION: 9.1      LAST MODIFIED: 06/15/00   BY: Zheng Huang      *N0DK*   */
/* REVISION: 9.1      LAST MODIFIED: 08/13/00   BY: *N0KQ* myb                */
/* Revision: 1.46     BY: Markus Barone         DATE: 09/01/00  ECO: *N0R3*   */
/* Revision: 1.47     BY: Kaustubh K.           DATE: 09/08/00  ECO: *M0RJ*   */
/* Revision: 1.48     BY: Reetu Kapoor          DATE: 11/28/00  ECO: *M0X2*   */
/* Revision: 1.49     BY: Mudit Mehta           DATE: 09/30/00  ECO: *N0WT*   */
/* Revision: 1.51     BY: Katie Hilbert         DATE: 04/01/01  ECO: *P002*   */
/* Revision: 1.53     BY: Hareesh V.            DATE: 08/16/01  ECO: *M1GR*   */
/* Revision: 1.54     BY: Rajiv Ramaiah         DATE: 09/17/01  ECO: *N12L*   */
/* Revision: 1.55     BY: Manjusha Inglay       DATE: 01/03/02  ECO: *N178*   */
/* Revision: 1.56     BY: Vivek Dsilva          DATE: 02/21/02  ECO: *N19R*   */
/* Revision: 1.57.1.1 BY: Reetu Kapoor          DATE: 03/25/02  ECO: *N1FC*   */
/* Revision: 1.58     BY: Jeff Wootton          DATE: 05/14/02  ECO: *P03G*   */
/* Revision: 1.59     BY: Lena Lim              DATE: 05/30/02  ECO: *P07G*   */
/* Revision: 1.61     BY: Jeff Wootton          DATE: 06/03/02  ECO: *P079*   */
/* Revision: 1.62     BY: Manisha Sawant        DATE: 11/26/02  ECO: *N20M*   */
/* Revision: 1.63     BY: Deepali Kotavadekar   DATE: 01/24/03  ECO: *N23Y*   */
/* Revision: 1.64     BY: Gnanasekar            DATE: 02/12/03  ECO: *N277*   */
/* Revision: 1.66     BY: Pawel Grzybowski      DATE: 03/27/03  ECO: *P0NT*   */
/* Revision: 1.67     BY: Orawan S.             DATE: 05/26/03  ECO: *P0RG*   */
/* Revision: 1.69     BY: Paul Donnelly (SB)    DATE: 06/28/03  ECO: *Q00J*   */
/* Revision: 1.70     BY: Gnanasekar            DATE: 08/05/03  ECO: *P0XW*   */
/* Revision: 1.73     BY: Shoma Salgaonkar      DATE: 09/26/03  ECO: *N2K8*   */
/* Revision: 1.74     BY: Prashant Parab        DATE: 12/04/03  ECO: *P1DD*   */
/* Revision: 1.76     BY: Deepak Rao            DATE: 02/26/04  ECO: *P1QV*   */
/* Revision: 1.77     BY: Vandna Rohira         DATE: 04/27/04  ECO: *P1Z3*   */
/* Revision: 1.78     BY: Max Iles              DATE: 07/01/04  ECO: *N2VQ*   */
/* Revision: 1.83     BY: Priya Idnani          DATE: 10/15/04  ECO: *P2PM*   */
/* Revision: 1.84     BY: Priya Idnani          DATE: 10/27/04  ECO: *Q0F2*   */
/* Revision: 1.87     BY: Dan Herman            DATE: 11/04/04  ECO: *M1V1*   */
/* Revision: 1.88     BY: Tejasvi Kulkarni      DATE: 12/29/04  ECO: *P31T*   */
/* Revision: 1.89     BY: Shivanand H           DATE: 01/06/05  ECO: *P32W*   */
/* Revision: 1.90     BY: Bhagyashri Shinde     DATE: 01/28/05  ECO: *P35C*   */
/* Revision: 1.91     BY: Priyank Khandare      DATE: 02/02/05  ECO: *P35K*   */
/* Revision: 1.92     BY: Ajit Philip           DATE: 14/03/05  ECO: *P3BV*   */
/* Revision: 1.92.1.1 BY: Preeti Sattur         DATE: 06/23/05  ECO: *P3QJ*   */
/* Revision: 1.92.1.2 BY: Anitha Gopal          DATE: 07/07/05  ECO: *P3RL*   */
/* Revision: 1.92.1.3 BY: Rafiq S               DATE: 12/06/05  ECO: *P4B8*   */
/* Revision: 1.92.1.4 BY: Kirti Desai           DATE: 12/28/05  ECO: *P4CF*   */
/* Revision: 1.92.1.5 BY: Munira Savai          DATE: 03/13/06  ECO: *P4K6*   */
/* Revision: 1.92.1.7 BY: SurenderSingh Nihalani DATE: 05/16/06  ECO: *P4PQ* */
/* Revision: 1.92.1.7 BY: SurenderSingh Nihalani DATE: 05/16/06  ECO: *P4PQ* */
/* Revision: 1.92.1.8 BY: Shridhar M             DATE: 05/18/06  ECO: *P4J2* */
/* Revision: 1.92.1.9 BY: SurenderSingh Nihalani DATE: 06/12/06  ECO: *P4S2* */
/* Revision: 1.92.1.10 BY: SurenderSingh Nihalani DATE: 06/19/06 ECO: *P4TZ* */
/* Revision: 1.92.1.11 BY: Munira Savai           DATE: 09/11/06  ECO: *P55G* */
/* Revision: 1.92.1.12 BY: Munira Savai           DATE: 09/13/06  ECO: *P561* */
/* Revision: 1.92.1.15 BY: Devna Sahai            DATE: 03/20/07  ECO: *P5RG* */
/* Revision: 1.92.1.16 BY: Vijaykumar Patil       DATE: 07/02/07  ECO: *P608* */
/* Revision: 1.92.1.17 BY: Deepak Taneja     DATE: 01/16/08  ECO: *P6JQ* */
/* Revision: 1.92.1.19 BY: Antony LejoS      DATE: 16/05/08  ECO: *P6T9* */
/* Revision: 1.92.1.22 BY: Antony LejoS      DATE: 06/06/08  ECO: *P6V4* */
/* Revision: 1.92.1.23 BY: Dipanshu Talwar   DATE: 07/30/08  ECO: *P6YG* */
/* Revision: 1.92.1.25 BY: Kunal Pandya      DATE: 09/22/08  ECO: *Q1TR* */
/* Revision: 1.92.1.26 BY: Ambrose Almeida   DATE: 11/18/08  ECO: *Q20G* */
/* Revision: 1.92.1.28 BY: Swarna M          DATE: 12/19/08  ECO: *Q24C* */
/* Revision: 1.92.1.30 BY: Rajat Kulshreshtha  DATE: 07/09/09 ECO: *Q34B* */
/* Revision: 1.92.1.31 BY: Ravi Swami          DATE: 09/14/09 ECO: *Q39D* */
/* Revision: 1.92.1.32 BY: Avishek Chakraborty DATE: 03/09/10 ECO: *Q3X0* */
/* Revision: 1.92.1.33 BY: Rajat Kulshreshtha  DATE: 03/26/10 ECO: *Q3YX* */
/* Revision: 1.92.1.34 BY: Avishek Chakraborty DATE: 03/31/10 ECO: *Q3Z7* */
/* Revision: 1.92.1.38 BY: Zheng Huang         DATE: 04/23/10 ECO: *Q41G* */
/* Revision: 1.92.1.42 BY: Avishek Chakraborty DATE: 06/02/10 ECO: *Q43W* */
/* Revision: 1.92.1.43 BY: Ambrose Almeida     DATE: 07/09/10 ECO: *Q47K* */
/* Revision: 1.92.1.44 BY: Shivakumar Patil    DATE: 07/12/10 ECO: *Q47B* */
/* Revision: 1.92.1.45 BY: Ravi Swami          DATE: 08/25/10 ECO: *Q4BF* */
/* Revision: 1.92.1.46 BY: Anandhakumar K      DATE: 02/24/11 ECO: *Q4N1* */
/* Revision: 1.92.1.48 BY: Ambrose Almeida     DATE: 01/20/12 ECO: *Q56M* */
/* $Revision: 1.92.1.49 $  BY: Rajalaxmi Ganji     DATE: 04/04/12 ECO: *Q59N* */
/*-Revision end---------------------------------------------------------------*/

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/
/*                                                                            */

/******************************************************************************/
/* THIS PROGRAM WAS CLONED TO kbporca.p 05/14/02, REMOVING UI.                */
/* CHANGES TO THIS PROGRAM MAY ALSO NEED TO BE APPLIED TO kbporca.p           */
/* CHANGES MADE IN THIS PROGRAM MAY ALSO HAVE TO BE MADE TO PORVISA.P         */
/******************************************************************************/

/*V8:ConvertMode=Maintenance                                                  */
{mfdeclre.i}
{cxcustom.i "POPORCA.P"}
/* SEVERITY PREPROCESSOR CONSTANT DEFINITION INCLUDE FILE */
{pxmaint.i}
{gplabel.i} /* EXTERNAL LABEL INCLUDE */

/*MAIN-BEGIN*/

{porcdef.i}

/* VARIABLE DEFINITION FOR GL CALENDAR VALIDATION */
{gpglefdf.i}

/*@MODULE PRM BEGIN*/
/* SHARED TEMP-TABLES FOR PRM */
{pjportt.i}
/*@MODULE PRM END*/

/* REORGANIZED VARIABLES */

/* NEW SHARED VARIABLES, BUFFERS AND FRAMES */
define new shared variable conv_to_pod_um      like pod_um_conv.
define new shared variable line                like pod_line
                                               format ">>>"           no-undo.
define new shared variable lotserial_qty       like sr_qty            no-undo.
define new shared variable podtype             like pod_type.
define new shared variable rct_site            like pod_site.
define new shared variable total_lotserial_qty like pod_qty_chg.
define new shared variable total_received      like pod_qty_rcvd.
define new shared variable trans_um            like pt_um.
define new shared variable trans_conv          like sod_um_conv.
define new shared variable undo_all            like mfc_logical.
define new shared variable cline               as   character.
define new shared variable issue_or_receipt    as   character.
define new shared variable lotserial_control   as   character.
define new shared variable multi_entry like mfc_logical
   no-undo
   label "Multi Entry".

/* SHARED VARIABLES, BUFFERS AND FRAMES */
define shared variable h_wiplottrace_procs as   handle                no-undo.
define shared variable h_wiplottrace_funcs as   handle                no-undo.
define shared variable qopen               like pod_qty_rcvd
   label "Qty Open".
define shared variable vendlot             like tr_vend_lot           no-undo.
define shared variable fill-all            like mfc_logical           no-undo.
define shared variable prm-avail           like mfc_logical           no-undo.
define shared frame b.

/* LOCAL VARIABLES, BUFFERS AND FRAMES */
define variable lotserials_req like mfc_logical                       no-undo.
define variable leave_loop     like mfc_logical initial no            no-undo.
define variable cancel_bo      like mfc_logical                       no-undo.
define variable chg_attr       like mfc_logical label "Chg Attribute" no-undo.
define variable cmmt_yn        like mfc_logical label "Comments"      no-undo.
define variable cont           like mfc_logical initial yes           no-undo.
define variable del-yn         like mfc_logical initial no            no-undo.
define variable due            like pod_due                           no-undo.
define variable err_flag       like mfc_logical                       no-undo.
define variable ln_stat        like mfc_logical                       no-undo.
define variable packing_qty    like pod_ps_chg                        no-undo.
define variable qty_left       like tr_qty_chg                        no-undo.
define variable receipt_um     like pod_rum                           no-undo.
define variable reset_um       like mfc_logical initial no            no-undo.
define variable serial_control like mfc_logical initial no            no-undo.
define variable shipqtychg     like pod_qty_chg
   column-label "Ship Qty"                                            no-undo.
define variable undo-taxes     like mfc_logical                       no-undo.
define variable undotran       like mfc_logical                       no-undo.
define variable yn             like mfc_logical                       no-undo.
define variable ponbr          like pod_nbr                           no-undo.
define variable poline         like pod_line                          no-undo.
define variable lotnext        like pod_lot_next                      no-undo.
define variable lotprcpt       like pod_lot_rcpt                      no-undo.
define variable newlot         like pod_lot_next                      no-undo.
define variable trans-ok       like mfc_logical                       no-undo.
define variable srlot          like sr_lotser                         no-undo.
define variable almr           like alm_pgm                           no-undo.
define variable errsite        like pod_site                          no-undo.
define variable errloc         like pod_loc                           no-undo.
define variable l_getlot       like mfc_logical                       no-undo.
define variable cancel-prm     like mfc_logical                       no-undo.
define variable need-to-validate-defaults like mfc_logical            no-undo.
define variable default-receipts-valid    like mfc_logical            no-undo.
define variable invalid-prm-po-ln-rcpt    like mfc_logical            no-undo.

define variable mess_desc      as   character                         no-undo.
define variable templot        as   character                         no-undo.
define variable csz            as   character format "X(38)"          no-undo.
define variable dwn            as   integer                           no-undo.
define variable first_down     as   integer initial 0                 no-undo.
define variable i              as   integer                           no-undo.
define variable msgnbr         as   integer                           no-undo.
define variable w-int1         as   integer                           no-undo.
define variable w-int2         as   integer                           no-undo.
define variable alm_recno      as   recid                             no-undo.
define variable filename       as   character                         no-undo.
define variable ii             as   integer                           no-undo.
define variable use_pod_um_conv   as  logical                         no-undo.
define variable l_use_pod_um_conv like mfc_logical                    no-undo.
{&POPORCA-P-TAG1}

define variable vQuantityReceived as decimal no-undo.
define variable vSiteId           as character no-undo.
define variable vLocation         as character no-undo.
define variable l_remove_srwkfl   like mfc_logical no-undo.
define variable l_flag            like mfc_logical no-undo.
define variable l_continue        like mfc_logical initial no  no-undo.
define variable l_scan            like mfc_logical initial yes no-undo.
define variable l_undo            like mfc_logical             no-undo.
define variable l_multi_return    like mfc_logical no-undo.
define variable l_sr_wkfl_recid   as   recid                   no-undo.

define variable l_delete_sr_wkfl like mfc_logical no-undo.
define variable l_update_sr_wkfl like mfc_logical no-undo.
define variable l_error          like mfc_logical no-undo.

define variable l_exit_yn        like mfc_logical initial no no-undo.
define variable l_route          like mfc_logical initial no no-undo.
define variable l_total          like sr_qty                 no-undo.
define variable l_conv_to_pod_um like pod_um_conv            no-undo.
define variable l_trans_conv     like sod_um_conv            no-undo.
define variable l_prompt         as   character              no-undo.

/* TEMP-TABLE t_sr_wkfl STORES THE LIST OF DEFAULT sr_wkfl      */
/* RECORDS (NOT CREATED BY THE USER)                            */
define temp-table t_sr_wkfl no-undo
   field t_sr_userid like sr_userid
   field t_sr_lineid like sr_lineid
   field t_sr_site   like sr_site
   field t_sr_loc    like sr_loc
   field t_sr_lotser like sr_lotser
   field t_sr_ref    like sr_ref
   field t_sr_qty    like sr_qty
   index t_sr_lineid is unique t_sr_userid t_sr_lineid.

{&POPORCA-P-TAG4}
/*WORKFILE FOR POD RECEIPT ATTRIBUTES*/
define shared workfile attr_wkfl no-undo
   field chg_line     like sr_lineid
   field chg_assay    like tr_assay
   field chg_grade    like tr_grade
   field chg_expire   like tr_expire
   field chg_status   like tr_status
   field assay_actv   as   logical
   field grade_actv   as   logical
   field expire_actv  as   logical
   field status_actv  as   logical.

/* TEMP-TABLE ADDED TO COLLECT THE LINES WHICH ARE SHIPPED, */
/* WHICH CAN BE USED WHILE CALCULATING THE TAXES            */
define temp-table tt_po_tax
   field tt_po     like po_nbr
   field tt_line   like pod_line
   index tt_po_line_indx tt_po tt_line.

define temp-table tt_po_lineqty no-undo
   field tt_part    like pt_part
   field tt_site    like pt_site
   field tt_loc     like pt_loc
   field tt_tpoline like pod_line
   field tt_qty     like mrp_qty
   index tt_index_part tt_part
         tt_site
         tt_loc.

define output parameter table for tt_po_tax.
define buffer b_pod_det for pod_det.

{mfaimfg.i}  /* Common API constants and variables */

{popoit01.i} /* Define API purchase order temp tables  */
{mfctit01.i} /* Define API transaction comments temp tables */

if c-application-mode = "API" then do:

   /* Get handle of API controller */
   {gprun.i ""gpaigh.p"" "(output ApiMethodHandle,
                           output ApiProgramName,
                           output ApiMethodName,
                           output ApiContextString)"}
/*GUI*/ if global-beam-me-up then undo, leave.


   /* Get current purchase order transaction detail record */
   run getPurchaseOrderTransDet in ApiMethodHandle
      (output table ttPurchaseOrderTransDet).

   /* Get purchase order transaction comment temp-table */
   run getPurchaseOrderTransDetCmt in ApiMethodHandle
      (output table ttPurchaseOrderTransDetCmt).

end. /* IF c-application-mode = "API" */

assign issue_or_receipt = getTermLabel("RECEIPT",8).

FORM /*GUI*/  with frame c 5 down width 80 THREE-D /*GUI*/.


/*@MODULE WIPLOTTRACE BEGIN*/
{wlfnc.i} /*FUNCTION FORWARD DECLARATIONS*/
{wlcon.i}
/*@MODULE WIPLOTTRACE END*/

/* SET EXTERNAL LABELS */
setFrameLabels(frame c:handle).

FORM /*GUI*/ 
   pod_line             space(.3)   
   pod_part             view-as fill-in size 16 by 1   
   pt_um                space(.3)   
   qopen                space(.3)   
   pod_um               space(.3)   
   shipqtychg           space(.3)   
   pod_rum              space(.3)   
   pod_project          space(.3)   
   pod_due_date         space(.3)   
   pod_type
with frame cship 5 down width 80 THREE-D /*GUI*/.


/* SET EXTERNAL LABELS */
setFrameLabels(frame cship:handle).

FORM /*GUI*/ 
   
 RECT-FRAME       AT ROW 1 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1 COLUMN 3 NO-LABEL VIEW-AS TEXT SIZE-PIXELS 1 BY 1
 SKIP(.1)  /*GUI*/
po_nbr         colon 12   label "Order"
   po_vend
   po_stat
   ps_nbr         format "x(12)" to 78
 SKIP(.4)  /*GUI*/
with frame b side-labels no-attr-space width 80 NO-BOX THREE-D /*GUI*/.

 DEFINE VARIABLE F-b-title AS CHARACTER INITIAL "".
 RECT-FRAME-LABEL:SCREEN-VALUE in frame b = F-b-title.
 RECT-FRAME-LABEL:HIDDEN in frame b = yes.
 RECT-FRAME:HEIGHT-PIXELS in frame b =
  FRAME b:HEIGHT-PIXELS - RECT-FRAME:Y in frame b - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME b = FRAME b:WIDTH-CHARS - .5.  /*GUI*/


/* SET EXTERNAL LABELS */
setFrameLabels(frame b:handle).

FORM /*GUI*/  with frame e down no-attr-space width 80 THREE-D /*GUI*/.


/* SET EXTERNAL LABELS */
setFrameLabels(frame e:handle).

FORM /*GUI*/ 
   
 RECT-FRAME       AT ROW 1 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1 COLUMN 3 NO-LABEL VIEW-AS TEXT SIZE-PIXELS 1 BY 1
 SKIP(.1)  /*GUI*/
line           colon 15
   receipt_um     colon 36
   site           colon 54
   location       colon 68 label "Loc"
   lotserial_qty  colon 15
   wolot          colon 36 label "ID"
   lotserial      colon 54 label "Lot/Ser"
   packing_qty    colon 15 label "Packing Qty"
   woop           colon 36 label "WO Op"
   lotref         colon 54
   cancel_bo      colon 15 label "Cancel B/O"

   pod__qad04[1]  colon 54 label "Supplier Lot" format "x(22)"
   pod_part       colon 15 /*7.0*/ no-attr-space
   multi_entry    colon 54

   chg_attr       colon 73
   pod_vpart      /*7.0 colon 54 */
   colon 15
   no-attr-space
   cmmt_yn        colon 54 label "Cmmts"
 SKIP(.4)  /*GUI*/
with frame d side-labels attr-space width 80 NO-BOX THREE-D /*GUI*/.

 DEFINE VARIABLE F-d-title AS CHARACTER INITIAL "".
 RECT-FRAME-LABEL:SCREEN-VALUE in frame d = F-d-title.
 RECT-FRAME-LABEL:HIDDEN in frame d = yes.
 RECT-FRAME:HEIGHT-PIXELS in frame d =
  FRAME d:HEIGHT-PIXELS - RECT-FRAME:Y in frame d - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME d = FRAME d:WIDTH-CHARS - .5.  /*GUI*/


/* SET EXTERNAL LABELS */
setFrameLabels(frame d:handle).

{&POPORCA-P-TAG5}
/*@MODULE WIPLOTTRACE BEGIN*/
if is_wiplottrace_enabled() then
   run init_poline_bkfl_input_output.
/*@MODULE WIPLOTTRACE END*/

for first poc_ctrl
      fields( poc_domain poc_ln_stat)  where poc_ctrl.poc_domain =
      global_domain no-lock:
end. /* FOR FIRST POC_CTRL */
ln_stat = if available poc_ctrl and poc_ln_stat = "x" then yes else no.

/*@TO-DO  copy the following to INIT procedure in porcxu.p*/
for first clc_ctrl
      fields( clc_domain clc_lotlevel)  where clc_ctrl.clc_domain =
      global_domain no-lock:
end. /* FOR FIRST CLC_CTRL */

if not available clc_ctrl then do:
   {gprun.i ""gpclccrt.p""}
/*GUI*/ if global-beam-me-up then undo, leave.

   /*@TO-DOEND*/

   for first clc_ctrl
         fields( clc_domain clc_lotlevel)  where clc_ctrl.clc_domain =
         global_domain no-lock:
   end. /* FOR FIRST CLC_CTRL */
end. /* IF NOT AVAILABLE CLC_CTRL */

/*@TO-DO  XUI needs to find po_mstr without recid*/
for first po_mstr
      fields( po_domain po_nbr po_stat po_vend)
      where recid(po_mstr) = po_recno no-lock:
end. /* FOR FIRST PO_MSTR */
/*@TO-DOEND*/

assign
   line           = 1
   proceed        = no
   l_multi_return = no.

/*@MODULE PRM BEGIN*/
run build-prm-temp-table.
/*@MODULE PRM END*/

/* INITIALISE TEMP-TABLE t_sr_wkfl */
empty temp-table t_sr_wkfl.

empty temp-table tt_po_lineqty.
edit-loop:

repeat on endkey undo, leave:
/*GUI*/ if global-beam-me-up then undo, leave.

   lineloop:
   repeat:
/*GUI*/ if global-beam-me-up then undo, leave.


      {&POPORCA-P-TAG6}
      if c-application-mode = "API" and retry
         then return error return-value.

      if c-application-mode <> "API" then
         display po_nbr po_vend po_stat ps_nbr with frame b.

         clear frame c all no-pause.
         clear frame d all no-pause.

         clear frame cship all no-pause.
         clear frame e all no-pause.

      if c-application-mode <> "API" then
         if porec then
            view frame c.
         else
            view frame cship.
      if c-application-mode <> "API" then
         view frame d.


      {&POPORCA-P-TAG7}
      for each pod_det
         fields (pod_domain      pod_bo_chg   pod_cmtindx  pod_due_date
                 pod_fsm_type    pod_line     pod_lot_rcpt pod_nbr
                 pod_op          pod_part     pod_pjs_line pod_project
                 pod_consignment pod_ps_chg   pod_qty_chg  pod_qty_ord
                 pod_qty_rcvd    pod_rma_type pod_rum      pod_rum_conv
                 pod_sched       pod_site     pod_status   pod_taxable
                 pod_taxc        pod_tax_env  pod_tax_in   pod_tax_usage
                 pod_type        pod_um       pod_um_conv  pod_vpart
                 pod_wo_lot      pod__qad04[1])
         no-lock
             where pod_det.pod_domain = global_domain and  pod_nbr = po_nbr
            and pod_line >= line
            and pod_status <> "c"
            and pod_status <> "x"
            use-index pod_nbrln by pod_line:

         if porec then do:
            if pod_rma_type <> "I"  and
               pod_rma_type <> ""   then next.
         end. /* IF POREC */
         else
            if  pod_rma_type <> "O" then next.


         for first si_mstr
               fields( si_domain si_db si_entity si_site)
                where si_mstr.si_domain = global_domain and  si_site = pod_site
                no-lock:
         end. /* FOR FIRST SI_MSTR */

         if available si_mstr and si_db = global_db then do:

            for first pt_mstr
               fields( pt_domain pt_auto_lot pt_loc pt_lot_grp
                      pt_lot_ser pt_part pt_status pt_um)
                where pt_mstr.pt_domain = global_domain and  pt_part = pod_part
                no-lock:
            end. /* FOR FIRST PT_MSTR */

            if porec then do:
               {pxrun.i &PROC='getOpenQuantity' &PROGRAM='porcxr1.p'
                  &PARAM="(input pod_qty_ord,
                                 input pod_qty_rcvd,
                                 output qopen)"
                  &NOAPPERROR=true
                  &CATCHERROR=true
                  }
            end.
            /*@MODULE RTS BEGIN*/
            else
            assign
               qopen  =  - (pod_qty_ord - pod_qty_rcvd).
            /*@MODULE RTS END*/

            {pxrun.i &PROC='getScheduleOpenQuantity' &PROGRAM='porcxr1.p'
               &PARAM="(buffer pod_det,
                              input eff_date,
                              input-output qopen)"
               &NOAPPERROR=true
               &CATCHERROR=true
               }

            /* Display correct label for RTS shipments. */
            assign shipqtychg = pod_qty_chg.

            {&POPORCA-P-TAG8}
            if porec then do:
               if c-application-mode <> "API" then
                  display
                     pod_line
                          space(.2)   
                     pod_part
                           view-as fill-in size 16 by 1   
                     pt_um when (available pt_mstr)
                          space(.2)   
                     qopen
                          space(.2)   
                     pod_um
                           view-as fill-in size 3 by 1 space(.2)   
                     pod_qty_chg
                          space(.2)   
                     pod_rum
                           view-as fill-in size 3 by 1 space(.2)   
                     pod_project
                          space(.2)   
                     pod_due_date
                          space(.2)   
                     pod_type
                           view-as fill-in size 3 by 1   
                  with frame c.

               if frame-line(c) = frame-down(c) then leave.
               if c-application-mode <> "API" then
                  down 1 with frame c.

            end.  /* IF POREC */
            else do:
               if c-application-mode <> "API" then
                  display
                     pod_line
                     pod_part
                     pt_um when (available pt_mstr)
                     qopen
                     pod_um
                     shipqtychg
                     pod_rum
                     pod_project
                     pod_due_date
                     pod_type
                  with frame cship.

               if frame-line(cship) = frame-down(cship) then leave.
               if c-application-mode <> "API" then
                  down 1 with frame cship.
            end. /* ELSE DO */

            {&POPORCA-P-TAG9}
         end.
/*GUI*/ if global-beam-me-up then undo, leave.
  /* IF AVAILABLE SI_MSTR */
      end.
/*GUI*/ if global-beam-me-up then undo, leave.
  /* FOR EACH POD_DET */

      {&POPORCA-P-TAG10}
      line = 0.

      setline:
      do transaction on error undo, retry:
/*GUI*/ if global-beam-me-up then undo, leave.

         if c-application-mode = "API" and retry
            then return error return-value.

         if c-application-mode = "API" then
            find next ttPurchaseOrderTransDet
               where ttPurchaseOrderTransDet.nbr = po_nbr
            no-lock no-error.

         if c-application-mode = "API" and
            not available ttPurchaseOrderTransDet then leave.


         if c-application-mode <> "API" then
         update line with frame d
            editing:
            nppoddet:
            repeat:
/*GUI*/ if global-beam-me-up then undo, leave.

               /* FIND NEXT/PREVIOUS RECORD */
               {mfnp01.i
                  pod_det
                  line
                  pod_line
                  pod_nbr
                   " pod_det.pod_domain = global_domain and po_nbr "
                  pod_nbrln}

               if recno <> ? then do:
                  line = pod_line.

                  for first si_mstr
                        fields( si_domain si_db si_entity si_site)
                         where si_mstr.si_domain = global_domain and  si_site =
                         pod_site no-lock:
                  end. /* FOR FIRST SI_MSTR */

                  if not available si_mstr
                     or (available si_mstr and si_db <> global_db) then
                     next nppoddet.

                  run display-detail.

                  /* do not display pt_desc on help keys from Desktop */
          if not ( {gpiswrap.i} and keyfunction(lastkey) = "help" ) then
             run get_pt_description
                        (input pod_part,
                         input pod_desc).

           end.
/*GUI*/ if global-beam-me-up then undo, leave.
 /* IF RECNO <> ? */
               leave.
            end.  /* NPPODDET: REPEAT: */

            /*@MODULE PRM BEGIN*/
            if prm-avail then do:

               if keyfunction(lastkey) = "END-ERROR"
                  or keyfunction(lastkey) = "GO" then do:

                  need-to-validate-defaults = no.

                  /* NEED TO VALIDATE ALL PO LINES LINKED TO  */
                  /* PRM PROJECT LINES WHERE DEFAULT PO LINE  */
                  /* RECEIPT QUANTITIES ARE TO BE ACCEPTED    */
                  /* - I.E. EACH TTPRM-DET RECORD             */
                  if fill-all then
               for first ttprm-det no-lock:
                     need-to-validate-defaults = yes.
                  end. /* FOR FIRST TTPRM-DET */

                  if need-to-validate-defaults then
                     leave. /* LEAVE UPDATE..EDITING BLOCK */

                  if keyfunction(lastkey) = "END-ERROR" then
                     undo lineloop, leave.

               end.  /* IF KEYFUNCTION(LASTKEY)... */
            end.  /* IF PRM-AVAIL */
            /*@MODULE PRM END*/
            else
               if keyfunction(lastkey) = "end-error" then
               undo lineloop, leave.

         end. /* EDITING */

         if c-application-mode = "API" then
            line = ttPurchaseOrderTransDet.line.


         if (line = 0) then do:         /* NO PO LINE SELECTED */

            if (prm-avail and not need-to-validate-defaults)
               or (not prm-avail) then
               leave lineloop.
            else
            /*@MODULE PRM BEGIN*/
            if prm-avail and need-to-validate-defaults then do:

               /* VALIDATE THE DEFAULT VALUES THAT WERE ASSIGNED */
               /* TO EACH OF THE PO LINES TO BE RECEIVED         */
               {gprunmo.i
                  &program=""pjporvdl.p""
                  &module ="PRM"
                  &param  ="""(input  fill-all,
                                  output default-receipts-valid,
                                  output pod_recno,
                                  output cancel-prm)"""}

               if cancel-prm then do:
                  /* LEAVE LINE DETAILS AND RETURN TO HEADER */
                  /* SINCE WE DON'T WANT TO PROCESS THE PRM  */
                  /* RECORDS ASSOCIATED WITH THE PO          */
                  if c-application-mode <> "API" then
                     run hide-frames.
                  undo, return.
               end. /* IF CANCEL-PRM */

               /* CAN LEAVE THE LINELOOP IF PRM VALIDATIONS OF */
               /* DEFAULT PO LINE VALUES INDICATES NO PROBLEMS */
               /* BUT WHERE PROBLEM LINES EXIST THE FIRST ONE  */
               /* WILL BE IDENTIFIED AND USER WILL BE ALLOWED  */
               /* MAKE THE NECESSARY MODIFICATIONS (STAYS IN   */
               /* LINELOOP)                                    */
               if default-receipts-valid then
                  leave lineloop.
               else
                  /* FIND OUT WHICH LINE IS INVALID AND DISPLAY */
                  for first pod_det
                     fields (pod_domain      pod_bo_chg   pod_cmtindx
                             pod_due_date    pod_fsm_type pod_line
                             pod_lot_rcpt    pod_nbr      pod_op
                             pod_part        pod_pjs_line pod_project
                             pod_consignment pod_ps_chg   pod_qty_chg
                             pod_qty_ord     pod_qty_rcvd pod_rma_type
                             pod_rum         pod_rum_conv pod_sched
                             pod_site        pod_status   pod_taxable
                             pod_taxc        pod_tax_env  pod_tax_in
                             pod_tax_usage   pod_type     pod_um
                             pod_um_conv     pod_vpart    pod_wo_lot
                             pod__qad04[1])
                        no-lock
                        where pod_recno = recid(pod_det):

                     line = pod_line.

                     if c-application-mode <> "API" then
                        run display-detail.
                  end.  /* FOR FIRST POD_DET */

               /*@MODULE PRM END*/
            end.   /* ELSE IF PRM-AVAIL... */
         end.     /* IF LINE = 0 */

         assign
            vendlot = ""
            lotnext = ""
            newlot  = "".

         {pxrun.i &PROC='processRead' &PROGRAM='popoxr1.p'
            &PARAM="(input po_nbr,
                           input line,
                           buffer pod_det,
                           input {&LOCK_FLAG},
                           input {&WAIT_FLAG})"
            &NOAPPERROR=true
            &CATCHERROR=true
            }

         if return-value = {&SUCCESS-RESULT} then do:

            run get_pt_description
               (input pod_part,
                input pod_desc).

            if pod_start_eff[1]  > today
               or pod_end_eff[1] < today
            then do:

               /* SCHEDULED ORDER IS NO LONGER EFFECTIVE */
               {pxmsg.i &MSGNUM=8204 &ERRORLEVEL=2}

            end. /* IF pod_start_eff[1] ... */

            if pod_sched
           and pod_curr_rlse_id [1] = ""
            then do:

               /* NO ACTIVE SCHEDULE EXISTS */
               {pxmsg.i &MSGNUM=2362 &ERRORLEVEL=2}

            end. /* IF pod_sched ... */

            {pxrun.i &PROC='validateSiteDatabase' &PROGRAM='porcxr1.p'
               &PARAM="(input pod_site)"
               &NOAPPERROR=true
               &CATCHERROR=true
               }

            if return-value <> {&SUCCESS-RESULT}
            then do:
               if batchrun
               then
                  undo edit-loop, retry edit-loop.
               else
                  undo setline, retry.
            end. /* IF return-value <> {&SUCCESS-RESULT} */

            /* PONBR AND POLINE NOW ASSIGNED WITH POD_NBR AND POD_LINE        */
            /* IRRESPECTIVE OF TYPE OF PURCHASE ORDER                         */

            assign
               ponbr  = pod_nbr
               poline = pod_line.

         end. /* IF AVAILABLE POD_DET */

         if not available pod_det then do:
            /* LINE ITEM DOES NOT EXIST */
             run displayMessage (input 45,
                                 input {&APP-ERROR-RESULT}).

            if batchrun
            then
               undo edit-loop, retry edit-loop.
            else
               undo setline, retry.

         end. /* IF NOT AVAILABLE POD_DET */

         /*@TO-DO call this in xui*/
         /* PICK UP CURRENTLY EFFECTIVE CUM ORDER*/
         {gprun.i ""poporca5.p""
            "(input pod_nbr,
                    input pod_line,
                    input eff_date)"}
/*GUI*/ if global-beam-me-up then undo, leave.

         /*@TO-DOEND*/

         if (porec               and
            pod_rma_type <> "I"  and
            pod_rma_type <> "")  or
            (not porec           and
            pod_rma_type <> "O") then do:
            /* LINE ITEM DOES NOT EXIST */
             run displayMessage (input 45,
                                 input {&APP-ERROR-RESULT}).

            if batchrun
            then
               undo edit-loop, retry edit-loop.
            else
               undo setline, retry.

         end. /* IF POREC */

         {pxrun.i &PROC='validateStatusId' &PROGRAM='porcxr1.p'
            &PARAM="(input pod_status)"
            &NOAPPERROR=true
            &CATCHERROR=true
            }

         if return-value <> {&SUCCESS-RESULT}
         then do:
            if batchrun
            then
               undo edit-loop, retry edit-loop.
            else
               undo setline, retry.
         end. /* IF return-value <> {&SUCCESS-RESULT} */

         cline = string (line).

         {pxrun.i &PROC='readFirstDetailForLine' &PROGRAM='porcxr2.p'
            &PARAM="(input integer(cline),
                           buffer sr_wkfl,
                           input {&NO_LOCK_FLAG},
                           input {&NO_WAIT_FLAG})"
            &NOAPPERROR=true
            &CATCHERROR=true
            }

         if return-value = {&SUCCESS-RESULT} then newlot = sr_lotser.

         pod_recno = recid (pod_det).

         {pxrun.i &PROC='setAutoLotNumber' &PROGRAM='porcxr1.p'
            &PARAM="(buffer pod_det,
                           input porec,
                           input-output newlot,
                           output trans-ok)"
            &NOAPPERROR=true
            &CATCHERROR=true
            }

         if return-value <> {&SUCCESS-RESULT}
         then do:
            if not batchrun
            then
               undo lineloop, retry.
            else
               undo edit-loop, retry edit-loop.
         end. /* IF return-value <> {&SUCCESS-RESULT} */

         lotserial = newlot.

      end. /*  DO ON ERROR UNDO, RETRY */ /* TRANSACTION */

      assign
         packing_qty = pod_ps_chg
         cancel_bo   = can-find(first poc_ctrl  where poc_ctrl.poc_domain =
         global_domain and  poc_ln_stat = "x")
         wolot       = pod_wo_lot
         woop        = pod_op
         lotserial   = newlot
         lotnext     = newlot
         receipt_um  = pod_rum.

      if c-application-mode <> "API" then
         display
            line
            packing_qty
            cancel_bo
            pod_part
            pod_vpart
            receipt_um
            wolot
            lotnext @ lotserial
            woop
            pod_site @ site
         with frame d.

      {&POPORCA-P-TAG11}
      for first si_mstr
         fields( si_domain si_db si_entity si_site)
          where si_mstr.si_domain = global_domain and  si_site = pod_site
         no-lock:

         {pxrun.i &PROC='validateSiteSecurity' &PROGRAM='icsixr.p'
            &PARAM="(input si_site,
                           input """")"
            &NOAPPERROR=true
            &CATCHERROR=true
            }
         if return-value <> {&SUCCESS-RESULT} then do:
            if c-application-mode <> "API" then
               pause.
            next-prompt line with frame d.
            undo lineloop, retry.
         end. /* IF return-value <> {&SUCCESS-RESULT} */
      end. /* FOR FIRST si_mstr */

      /* Initialize input variables, check for open vouchers. */

      pod_recno = recid(pod_det).

      /*mxb - moved call to checkOpenVouchers into poporca3.p*/
      {gprun.i ""poporca3.p""}
/*GUI*/ if global-beam-me-up then undo, leave.


      do transaction:
/*GUI*/ if global-beam-me-up then undo, leave.

         locloop:
         do on error undo, retry:
/*GUI*/ if global-beam-me-up then undo, leave.

            if c-application-mode = "API" and retry
               then return error return-value.

            ststatus = stline[3].
            status input ststatus.

            {pxrun.i &PROC='readFirstDetailForLine' &PROGRAM='porcxr2.p'
               &PARAM="(input integer(cline),
                           buffer sr_wkfl,
                           input {&NO_LOCK_FLAG},
                           input {&NO_WAIT_FLAG})"
               &NOAPPERROR=true
               &CATCHERROR=true
               }

            assign
               cmmt_yn = no
               chg_attr = no.

            {pxrun.i &PROC='processRead' &PROGRAM='ppitxr.p'
               &PARAM="(input pod_part,
                           buffer pt_mstr,
                           input {&NO_LOCK_FLAG},
                           input {&NO_WAIT_FLAG})"
               &NOAPPERROR=true
               &CATCHERROR=true
               }

            lotprcpt  = pod_lot_rcpt.

            /*mxb - multi-entry is only used to support chui*/
            assign
               i                = 0
               multi_entry      = no.
            for each sr_wkfl
                  fields( sr_domain sr_lineid sr_loc sr_lotser sr_qty
                         sr_ref sr_site sr_userid sr_vend_lot)
                   where sr_wkfl.sr_domain = global_domain and  sr_userid =
                   mfguser
                  and sr_lineid = cline no-lock:
               i = i + 1.
               if i > 1 then do:
                  multi_entry = yes.
                  leave.
               end. /* IF I > 1  */
            end. /*  FOR FIRST SR_WKFL */

            /*mxb - pod__qad04 is only used to support chui*/
            if pod__qad04[1] = ? then
               assign pod__qad04[1] = "".

            if c-application-mode <> "API" then
               display
                  lotserial_qty
                  packing_qty
                  cancel_bo
                  receipt_um
                  wolot
                  woop
                  site
                  location
                  lotserial
                  lotref
                  pod__qad04[1]
                  multi_entry
                  chg_attr
                  cmmt_yn
               with frame d.

            l_getlot = yes.
            if available pt_mstr
               and (porec = yes) and
               (is-return = no) then
            do:

               if ({pxfunct.i &FUNCTION='isAutoLotEnabled' &PROGRAM='clalxr.p'
                  &PARAM="input pt_lot_ser,
                                   input pt_auto_lot,
                                   input pt_lot_grp,
                                   input pod_type,
                                   input yes"
                  })
                  then l_getlot = no.

            end. /* IF AVAILABLE PT_MSTR */

            for last wr_route
               where wr_domain = global_domain
               and   wr_lot    = pod_wo_lot
            no-lock:
            end.
/*GUI*/ if global-beam-me-up then undo, leave.
 /* FOR LAST wr_route */
            if available wr_route
               and (pod_type       = "s"
                    and wr_po_nbr  = pod_nbr
                    and wr_po_line = pod_line
                    and wr_op      = pod_op)
            then
               l_route = yes.
            else
               l_route = no.

            if c-application-mode <> "API" then
            set lotserial_qty
               packing_qty
               cancel_bo
               receipt_um
               wolot
               woop
               /*@MODULE WIPLOTTRACE - enablement*/
               site      when (not multi_entry
               and not (is_wiplottrace_enabled() and pod_type = "s"))
               location  when (not multi_entry
               and not (is_wiplottrace_enabled() and pod_type = "s"))
               lotserial when ((not multi_entry) and l_getlot
               and not (is_wiplottrace_enabled() and pod_type = "s"))
               lotref    when (not multi_entry
               and not (is_wiplottrace_enabled() and pod_type = "s"))
               pod__qad04[1]
               when (not (is_wiplottrace_enabled() and pod_type = "s"))
               multi_entry
               when (not multi_entry
               and not (is_wiplottrace_enabled() and pod_type = "s"))
               /*@TO-DO - enablement*/
               chg_attr  when (porec
                               and (pod_type = ""
                                    or l_route))
               cmmt_yn
               /*@TO-DOEND*/
            with frame d
               editing:
               assign
                  /*@TO-DO - setCharacterValue for global_site, ...*/
                  global_site = input site
                  global_loc  = input location
                  global_lot  = input lotserial.
               /*@TO-DOEND*/

               readkey.
               apply lastkey.
            end. /* EDITING: */

            /* CREATE THE TEMP-TABLE FOR COLLECTING THE LINES EDITED, */
            /* TO BE USED IN RECALCULATING THE TAXES                  */
            for first tt_po_tax
               where tt_po   = pod_nbr
               and   tt_line = pod_line
            no-lock:
            end.
/*GUI*/ if global-beam-me-up then undo, leave.
 /* FOR FIRST tt_po_tax */
            if not available tt_po_tax
            then do:
               create tt_po_tax.
               assign tt_po   = pod_nbr
                      tt_line = pod_line.
            end. /* IF NOT AVAILABLE tt_po_tax */

            if c-application-mode = "API" then do:

               assign
                  {mfaiset.i packing_qty ttPurchaseOrderTransDet.psChg}
                  {mfaiset.i cancel_bo   ttPurchaseOrderTransDet.cancelBO}
                  {mfaiset.i receipt_um  ttPurchaseOrderTransDet.rum}
                  {mfaiset.i wolot       ttPurchaseOrderTransDet.woLot}
                  {mfaiset.i woop        ttPurchaseOrderTransDet.op}
                  {mfaiset.i site        ttPurchaseOrderTransDet.site}
                  multi_entry = yes
                  cmmt_yn     = yes.
               if ttPurchaseOrderTransDet.assay      = ?
                  and ttPurchaseOrderTransDet.assayLog   = ?
                  and ttPurchaseOrderTransDet.grade      = ?
                  and ttPurchaseOrderTransDet.gradeLog   = ?
                  and ttPurchaseOrderTransDet.expire     = ?
                  and ttPurchaseOrderTransDet.expireLog  = ?
                  and ttPurchaseOrderTransDet.rctstat    = ?
                  and ttPurchaseOrderTransDet.rctstatLog = ?
                  then
                     chg_attr    = no.
               else
                  chg_attr    = yes.
            end.

            /*@MODULE PRM BEGIN*/
            /* STORE THE RECEIPT QUANTITY IN THE PRM TEMP TABLE */
            run save-receipt-qty.
            /*@MODULE PRM END*/

            {pxrun.i &PROC='getUMConversionToPOLine' &PROGRAM='porcxr1.p'
               &PARAM="(input receipt_um,
                           buffer pod_det,
                           output conv_to_pod_um,
                           output use_pod_um_conv)"
               &NOAPPERROR=true
               &CATCHERROR=true
               }
            if return-value <> {&SUCCESS-RESULT} then do:
               next-prompt receipt_um with frame d.
               undo, retry.
            end. /* IF CONV_TO_POD_UM = ? */

            if     pod_consignment
               and pod_site <> site
            then do:
               /* CANNOT RECEIVE CONSIGNED ITEM INTO A SITE OTHER THAN */
               /* PO SITE                                              */
               {pxmsg.i &MSGNUM=11169 &ERRORLEVEL=3}
               next-prompt site with frame d.
               undo, retry.
            end.

            {pxrun.i &PROC='validateSiteSecurity' &PROGRAM='icsixr.p'
               &PARAM="(input (input site),
                           input ? )"
               &NOAPPERROR=true
               &CATCHERROR=true
               }
            if return-value <> {&SUCCESS-RESULT} then do:
               next-prompt site with frame d.
               undo, retry.
            end.

            {pxrun.i &PROC='processRead' &PROGRAM='icsixr.p'
               &PARAM="(input  site,
                           buffer si_mstr,
                           input  {&NO_LOCK_FLAG},
                           input  {&NO_WAIT_FLAG})"
               &NOAPPERROR=true
               &CATCHERROR=true}

            /* VERIFY OPEN GL PERIOD FOR LINE ITEM SITE/ENTITY */
            if available si_mstr then do:
               {pxrun.i &PROC='validateDateInGLPeriod' &PROGRAM='glglxr.p'
                        &PARAM="(input site,
                                 input ""IC"",
                                 input eff_date)"
                        &NOAPPERROR=true
                        &CATCHERROR=true
                  }
            end. /* IF AVAILABLE si_mstr */

            if return-value <> {&SUCCESS-RESULT} then do:
               if not available si_mstr
               then
                  /* SITE DOES NOT EXIST */
                  run displayMessage (input 708,
                                      input 3).

               next-prompt site with frame d.
               undo locloop, retry.
            end.

            if available pt_mstr then do:

               /* IN CASE OF RTS RECEIPTS FOR SERIALIZED ITEMS, SKIP THE     */
               /* VALIDATION FOR SERIAL NUMBER USING THE PROCEDURE           */
               /* validateLotSerialUsage WHEN THE SHIPMENT AND RECEIPT FOR   */
               /* THE SERIALIZED ITEM ARE PERFORMED ON THE SAME RTS WITH THE */
               /* SAME SERIAL NUMBER.                                        */

               l_flag = no.

               if pod_fsm_type = "RTS-RCT"
               then do:
                  for first rmd_det
                     fields( rmd_domain rmd_nbr     rmd_part rmd_prefix
                             rmd_qty_acp rmd_ser  rmd_type )
                      where rmd_det.rmd_domain = global_domain and   rmd_nbr
                       = pod_nbr
                     and    rmd_part    = pod_part
                     and    rmd_prefix  = "V"
                     and    rmd_type    = "O"
                     and    rmd_qty_acp > 0
                  no-lock:
                     if rmd_ser <> lotserial
                     then do:
                        for first tr_hist
                           fields( tr_domain tr_nbr     tr_part
                                   tr_program tr_serial)
                            where tr_hist.tr_domain = global_domain and
                            tr_serial  = lotserial
                           and    tr_nbr     = pod_nbr
                           and    tr_part    = pod_part
                           and    tr_program = "fsrtvis.p"
                        no-lock:
                        end. /* FOR FIRST tr_hist */

                        if not available tr_hist
                        then
                           l_flag = yes.

                     end. /* IF rmd_ser <> lotserial */

                  end. /* FOR FIRST rmd_det */

                  if not available rmd_det
                  then
                     l_flag = yes.

               end. /* IF pod_fsm_type = "RTS-RCT" */

               else

                  /* FOR ALL OTHER TRANSACTIONS, EXCEPT RTS RECEIPTS */
                  /* FOR SERIALIZED ITEMS.                           */

                  l_flag = yes.

               if     l_flag       = yes
                  and pod_fsm_type <> "RTS-RCT"
                  and l_route
               then do:
                  run lotserialvalidation
                     (input  pt_lot_ser,
                      input  lotserial,
                      input  site,
                      input  cline,
                      input  lotref,
                      input  pod_nbr,
                      input  pt_part,
                      input  location,
                      input  pod_lot_rcpt,
                      output l_undo).
                  if l_undo
                  then
                     undo, retry.
               end. /* IF l_flag = YES */

            end. /* IF AVAILABLE pt_mstr */

            {pxrun.i &PROC='validateRestrictedTrans' &PROGRAM='porcxr1.p'
               &PARAM="(buffer pt_mstr,
                          input pod_type,
                          input transtype)"
               &NOAPPERROR=true
               &CATCHERROR=true
               }
            if return-value <> {&SUCCESS-RESULT} then
               undo, retry.

            {pxrun.i &PROC='setReceiptSite' &PROGRAM='porcxr1.p'
               &PARAM="(buffer pod_det,
                           buffer wo_mstr,
                          output rct_site)"
               &NOAPPERROR=true
               &CATCHERROR=true
               }

            /*@TO-DO - check on pod_type needs to be in XUI controller*/
            if pod_type = "S" then do:

               for first si_mstr
                  fields (si_domain si_site si_auto_loc)
                  where   si_domain = global_domain
                  and     si_site   = pod_site
               no-lock:
                  if not si_auto_loc
                  then do:
                     if not  multi_entry
                     then do:
                        if not can-find (first loc_mstr
                                            where loc_domain = global_domain
                                            and   loc_site   = site
                                            and   loc_loc    =
                                               if site <> pod_site
                                               then
                                                  pt_loc
                                               else
                                                  location)
                        then do:
                           run displayMessage1 (input 7037,
                                       input 3,
                                       input pt_part).
                           undo locloop, retry.
                        end. /*IF NOT CAN-FIND (FIRST loc_mstr...*/
                     end. /*IF NOT multi_entry*/
                  end. /*IF NOT si_auto_loc*/
               end. /*FOR FIRST si_site*/

               assign
                  undo_all  = false
                  pod_recno = recid(pod_det).

               if c-application-mode = "API" then
                  run setPurchaseOrderTransDetRow in apiMethodHandle
                     (input ttPurchaseOrderTransDet.apiSequence).

               /* SUBCONTRACT WORKORDER UPDATE */
               {gprun.i ""poporca2.p""
                  "(output l_prompt)"}
/*GUI*/ if global-beam-me-up then undo, leave.

               if undo_all
               then do:
                  case l_prompt:
                     when "wolot"
                     then
                        next-prompt wolot with frame d.
                     when "woop"
                     then
                        next-prompt woop with frame d.
                  end case.
                  undo, retry.
               end. /* IF UNDO_ALL */

               if not multi_entry
               then do:
                  /* ACCUMULATE TOTAL QUANTITY FOR THE SAME */
                  /* ITEM/SITE/LOCATION/LOTSER/REF */
                  l_total = 0.
                  for each b_pod_det
                     where b_pod_det.pod_domain =  pod_det.pod_domain
                       and b_pod_det.pod_nbr    =  pod_det.pod_nbr
                       and b_pod_det.pod_part   =  pod_det.pod_part
                       and b_pod_det.pod_line   <> pod_det.pod_line
                  no-lock:
/*GUI*/ if global-beam-me-up then undo, leave.


                     if can-find(first sr_wkfl
                                    where sr_wkfl.sr_domain = global_domain
                                      and sr_wkfl.sr_userid = mfguser
                                      and sr_wkfl.sr_lineid =
                                          string(b_pod_det.pod_line)
                                      and sr_wkfl.sr_site   = site
                                      and sr_wkfl.sr_loc    = location
                                      and sr_wkfl.sr_lotser = lotserial
                                      and sr_wkfl.sr_ref    = lotref  )
                     then do:
                        {pxrun.i &PROC='getUMConversionToPOLine'
                                 &PROGRAM='porcxr1.p'
                                 &PARAM="(input b_pod_det.pod_rum,
                                          buffer b_pod_det,
                                          output l_conv_to_pod_um,
                                          output l_use_pod_um_conv)"
                                 &NOAPPERROR=true
                                 &CATCHERROR=true
                        }

                        {pxrun.i &PROC='getReceiptUMConversion'
                                 &PROGRAM='porcxr1.p'
                                 &PARAM="(input b_pod_det.pod_rum,
                                          input l_conv_to_pod_um,
                                          buffer pt_mstr,
                                          buffer b_pod_det,
                                          output l_trans_conv)"
                                 &NOAPPERROR=true
                                 &CATCHERROR=true
                        }

                        l_total = l_total  + (b_pod_det.pod_qty_chg *
                                              l_trans_conv).

                     end. /* IF CAN-FIND(FIRST sr_wkfl */
                  end.
/*GUI*/ if global-beam-me-up then undo, leave.
 /* FOR EACH b_pod_det */
                  l_total = (lotserial_qty * (trans_conv) )  + l_total.

                  if not is_wiplottrace_enabled()
                     and l_route
                  then do:
                     {pxrun.i &PROC='validateInventory' &PROGRAM='porcxr2.p'
                        &PARAM="(input transtype,
                                    input site,
                                    input location,
                                    input global_part,
                                    input lotserial,
                                    input lotref,
                                    input l_total,
                                    input trans_um,
                                    input ponbr,
                                    input (if lotserial_qty >=0
                                           then
                                              string(poline)
                                           else
                                              """"),
                                    input yes)"
                        &NOAPPERROR=true
                        &CATCHERROR=true}
                  end. /* IF NOT is_wiplottrace_enabled */
                  if return-value <> {&SUCCESS-RESULT}
                  then
                     if batchrun
                     then
                        undo edit-loop, retry edit-loop.
                     else
                        undo locloop, retry.
               end. /* IF NOT multi_entry */

            end. /* IF POD_TYPE = "S" */
            /*@TO-DOEND*/

            assign
               total_lotserial_qty = pod_qty_chg
               trans_um            = receipt_um.

            /* IF receipt_um = pt_um, THE CONVERSION FACTOR SHOULD BE */
            /* DOESN'T ALWAYS EQUAL 1, LEADING TO INVENTORY PROBLEMS  */

            {pxrun.i &PROC='getReceiptUMConversion' &PROGRAM='porcxr1.p'
               &PARAM="(input receipt_um,
                           input conv_to_pod_um,
                           buffer pt_mstr,
                           buffer pod_det,
                           output trans_conv)"
               &NOAPPERROR=true
               &CATCHERROR=true
               }

            if multi_entry then do:

               /* THIS PATCH INSURES THAT AT LEAST ONE sr_wkfl ENTRY IS
               PASSED  TO icsrup2.p ( MULTI ENTRY  MODE HANDLER ) EVEN IF
               RECEIVE ALL IS SET TO NO; SO AS TO BRING CONSISTENCY WITH
               RECEIVE ALL SET TO YES.
               */

               /* CREATE BEGINS */

               {pxrun.i &PROC='processRead' &PROGRAM='ppitxr.p'
                  &PARAM="(input pod_part,
                              buffer pt_mstr,
                              input {&NO_LOCK_FLAG},
                              input {&NO_WAIT_FLAG})"
                  &NOAPPERROR=true
                  &CATCHERROR=true
                  }

               if return-value <> {&SUCCESS-RESULT} or
                  (    return-value = {&SUCCESS-RESULT}
                   and pt_lot_ser   = ""
                   and pod_type     <> "s"
                   and l_route )
                then do:

                  {pxrun.i &PROC='readFirstDetailForLine' &PROGRAM='porcxr2.p'
                     &PARAM="(input integer(cline),
                                 buffer sr_wkfl,
                                 input {&NO_LOCK_FLAG},
                                 input {&NO_WAIT_FLAG})"
                     &NOAPPERROR=true
                     &CATCHERROR=true
                     }

                  if return-value <> {&SUCCESS-RESULT} then do:
                     {pxrun.i &PROC='createPOReceiptDetail' &PROGRAM='porcxr2.p'
                        &PARAM="(buffer sr_wkfl,
                                    input mfguser,
                                    input integer(cline),
                                    input site,
                                    input location,
                                    input lotserial,
                                    input lotref,
                                    input """",
                                    input lotserial_qty)"
                        &NOAPPERROR=true
                        &CATCHERROR=true
                        }
                     {pxrun.i &PROC='processRead' &PROGRAM='porcxr2.p'
                        &PARAM="(input mfguser,
                                    input integer(cline),
                                    input site,
                                    input location,
                                    input lotserial,
                                    input lotref,
                                    buffer sr_wkfl,
                                    input {&LOCK_FLAG},
                                    input {&WAIT_FLAG})"
                        &NOAPPERROR=true
                        &CATCHERROR=true
                        }

                     /* STORE THE ABOVE CREATED DEFAULT sr_wkfl */
                     run p_create_t_sr_wkfl
                        (input        mfguser,
                         input        cline,
                         input        site,
                         input        location,
                         input        lotserial,
                         input        lotref,
                         input        lotserial_qty,
                         input-output table t_sr_wkfl).

                  end. /* IF NOT AVAILABLE SR_WKFL */
                  if available sr_wkfl
                  then
                     sr_vend_lot = pod__qad04[1].
               end. /* IF NOT AVAILABLE PT_MSTR */

               /* CREATE ENDS */

               {pxrun.i &PROC='readFirstDetailForLine' &PROGRAM='porcxr2.p'
                  &PARAM="(input integer(cline),
                              buffer sr_wkfl,
                              input {&LOCK_FLAG},
                              input {&WAIT_FLAG})"
                  &NOAPPERROR=true
                  &CATCHERROR=true
                  }
               l_sr_wkfl_recid = recid(sr_wkfl).
           if lotserial_qty = 0 then do:
                  if available sr_wkfl and (not can-find(first sr_wkfl where                recid(sr_wkfl) <> l_sr_wkfl_recid and sr_lineid = cline))
            then do:
                     total_lotserial_qty = total_lotserial_qty - sr_qty.
                     delete sr_wkfl.
                  end. /* IF AVAILABLE SR_WKFL */
               end. /* IF LOTSERIAL_QTY = 0 */
               else do:
                  if available sr_wkfl then do:
                     /* IF MORE THAN ONE SR_WKFL RECORD EXISTS, THEN THE USER
                     ALREADY ENTERED MULTI-LINE INFORMATION, DO NOT DESTROY
                     THAT */

                     find sr_wkfl  where sr_wkfl.sr_domain = global_domain and
                     sr_userid = mfguser and
                        sr_lineid = cline exclusive-lock no-error.
                     if not ambiguous sr_wkfl then
                     assign
                        sr_site   = site
                        sr_loc    = location
                        sr_lotser = lotserial
                        sr_ref    = lotref
                        sr_qty    = lotserial_qty.
                  end. /* IF AVAIL SR_WKFL */
               end. /* ELSE DO: */

               if i >= 1 then
               assign
                  location = ""
                  lotref   = ""
                  vendlot  = "".

               /*@TO-DO  it seems to be a dead code. i will not be 0 when
               multi_entry is true*/
               if i = 0 then
                  assign vendlot = pod__qad04[1].
               /*@TO_DOEND*/

               if lotprcpt = yes then lotnext = lotserial.

               podtype = pod_type.
               total_lotserial_qty = 0.

               {pxrun.i &PROC='getTotalLotSerialQuantity' &PROGRAM='porcxr2.p'
                  &PARAM="(input integer(cline),
                              output total_lotserial_qty)"
                  &NOAPPERROR=true
                  &CATCHERROR=true
                  }

               if c-application-mode = "API" then
                  run setPurchaseOrderTransDetRow in apiMethodHandle
                     (input ttPurchaseOrderTransDet.apiSequence).

               do on error undo, return error return-value:

                  assign
                     l_delete_sr_wkfl = no
                     l_update_sr_wkfl = no.

                  /* DEFAULT CREATED sr_wkfl RECORD IS DELETED TO AVOID    */
                  /* DELETING IT MANUALLY IN MULTI ENTRY SCREEN. THIS WILL */
                  /* ENSURE EVERY sr_wkfl RECORD IS PASSED FOR VALIDATION  */
                  /* CHECK                                                 */
                  run p_delete_sr_wkfl (input        mfguser,
                                        input        cline,
                                        input        table t_sr_wkfl,
                                        input-output total_lotserial_qty,
                                        input-output l_delete_sr_wkfl).

                  /* IF sr_wkfl IS MODIFIED IN MULTI ENTRY, */
                  /* l_update_sr_wkfl IS SET TO YES         */
                  {gprun.i ""icsrup2.p""
                     "(input        rct_site,
                       input        ponbr,
                       input        poline,
                       input        lotprcpt,
                       input        l_multi_return,
                       output       l_error,
                       input-output lotnext,
                       input-output vendlot,
                       input-output l_update_sr_wkfl)"}
/*GUI*/ if global-beam-me-up then undo, leave.


                  /* IN CASE OF INVENTORY VALIDATION ERROR AND */
                  /* sr_wkfl IS NOT MODIFIED, UNDO locloop.    */
                  if l_error
                  and not l_update_sr_wkfl
                  then do:
                     if not batchrun
                     then
                        undo locloop, retry locloop.
                     else
                        undo locloop, leave locloop.
                  end. /* IF l_error */

                  /* RE-CREATE DEFAULT sr_wkfl, IF sr_wkfl IS NOT UPDATED */
                  /* IN MULTI ENTRY SCREEN. SO THE INVENTORY VALIDATION   */
                  /* CAN BE DONE.                                         */
                  run p_create_default_sr_wkfl
                     (input        l_update_sr_wkfl,
                      input        mfguser,
                      input        cline,
                      buffer       sr_wkfl,
                      input-output table t_sr_wkfl,
                      input-output l_delete_sr_wkfl).
               end.
               /* IF MULTI-ENTRY MODE WAS USED TO PROCESS RECEIPTS FOR A
               SINGLE ITEM/LOT/SERIAL LOCATION, IT IS POSSIBLE THAT
               THEY ARE RETURNING TO THIS PROGRAM HAVING CREATED ONLY 1
               sr_wkfl RECORD.  IF SO, THIS PROGRAM WILL RESET THE
               VALUE OF THE multi_entry FIELD TO "NO" (F0S0 BELOW). IF
               THE USER HAS RETURNED FROM THE MULTI-ENTRY FRAME BY
               PRESSING F4 ON AN ERROR CONDITION FOR SINGLE
               ITEM/LOT/SERIAL, THE PROGRAM IS RETURNING WITH THE
               VALUES IN sr_wkfl THAT CAUSED THE ERROR MESSAGE (BECAUSE
               THEY ARE DEFINED no-undo).  THESE ERRONEOUS VALUES WERE
               THEN OVERWRITING THE GOOD ONES.  TO PREVENT THIS FROM
               OCCURRING, WE DO A FIND ON THE FIRST sr_wkfl HERE TO
               RE-ESTABLISH THE CORRECT VALUES FROM sr_wkfl.
               */

               {pxrun.i &PROC='readFirstDetailForLine' &PROGRAM='porcxr2.p'
                  &PARAM="(input integer(cline),
                              buffer sr_wkfl,
                              input {&NO_LOCK_FLAG},
                              input {&NO_WAIT_FLAG})"
                  &NOAPPERROR=true
                  &CATCHERROR=true
                  }
               if return-value = {&SUCCESS-RESULT} then
               assign
                  site      = sr_site
                  location  = sr_loc
                  lotserial = sr_lotser
                  lotref    = sr_ref
                  lotserial_qty = sr_qty.

               for first si_mstr
                  fields (si_domain si_site si_auto_loc)
                  where   si_domain = global_domain
                  and     si_site   = site
               no-lock:
                  if not si_auto_loc
                  then do:

                     for each sr_wkfl
                        fields (sr_domain sr_site sr_userid sr_lineid sr_loc)
                        where   sr_domain  = global_domain
                        and     sr_site    = site
                        and     sr_userid  = mfguser
                        and     sr_lineid  = cline
                     no-lock:
                        if    (pod_type = "S"
                                  and not can-find (first loc_mstr
                                            where loc_domain = global_domain
                                            and   loc_site   = sr_site
                                            and   loc_loc    =
                                               if sr_site <> pod_site
                                               then
                                                  pt_loc
                                               else
                                                  sr_loc)
                              )
                           or (pod_type <> "S"
                                  and not can-find (first loc_mstr
                                            where loc_domain = global_domain
                                            and   loc_site   = sr_site
                                            and   loc_loc    = sr_loc)
                               )
                        then do:
                           run displayMessage1 (input 7037,
                                                input 3,
                                                input pt_part).
                           undo locloop, retry.
                        end. /*IF NOT CAN-FIND (FIRST loc_mstr...*/
                     end. /*FOR EACH sr_wkfl*/
                  end. /*IF not si_auto_loc */
               end. /*FOR FIRST si_mstr_*/
            end. /* IF MULTI_ENTRY */

            if multi_entry = yes then do:
               /* VERIFY THAT A MULTI_ENTRY WAS ACTUALLY PERFORMED */
               assign
                  i                = 0
                  multi_entry      = no.

               for each sr_wkfl
                     fields( sr_domain sr_lineid sr_loc sr_lotser sr_qty
                            sr_ref sr_site sr_userid sr_vend_lot)
                      where sr_wkfl.sr_domain = global_domain and  sr_userid =
                      mfguser
                     and sr_lineid = cline no-lock:
                  i = i + 1.
                  if i = 1 then
                     assign pod__qad04[1] = sr_vend_lot.

                  if i > 1 then do:
                     multi_entry = yes.
                     leave.
                  end. /* IF I > 1 */
               end. /* FOR EACH SR_WKFL */

               /* FOR RTS RECEIPTS ALREADY PROCESSED IN MULTI-ENTRY MODE,     */
               /* ASSIGN FLAGS SO AS TO STOP RE-ENTRY INTO SINGLE-ENTRY MODE. */

               if pod_fsm_type   = "RTS-RCT"
               then
                  assign
                     l_flag      = yes
                     multi_entry = yes.
            end. /* IF multi_entry = YES */

            if  l_flag       = yes
               and pod_fsm_type = "RTS-RCT"
               and available pt_mstr
               and multi_entry = no
            then do:

               for first rmd_det
                  fields (rmd_domain rmd_nbr rmd_part rmd_prefix rmd_site
                          rmd_loc    rmd_qty_acp rmd_ser rmd_type rmd_iss)
                  where rmd_domain = global_domain
                  and   rmd_nbr    = pod_nbr
                  and   rmd_part   = pod_part
                  and   rmd_line   = pod_line
                  and   rmd_prefix = "V"
                  and   rmd_type   = "I"
               no-lock :
               end. /* FOR FIRST rmd_det */

               if available rmd_det
                  and rmd_iss = no
               then do:

                  l_continue = no.

                  /* PROMPT WARNING MESSAGE ASKING USER IF HE WISHES TO      */
                  /* RECEIVE ITEM WITH LOT/SERIAL DIFFERENT FROM ONE SHIPPED */
                  /* WHEN INV ISSUE = NO AND LOT CONTROL LEVEL > 0.          */

                  if clc_lotlevel > 0
                  then do:

                     /* SERIAL DIFFERS FROM EXPECTED VALUE */
                     /* FOR ITEM RECEIVED. CONTINUE?       */
                     {pxmsg.i &MSGNUM=6379
                              &ERRORLEVEL=2
                              &CONFIRM=l_continue}

                  end. /* IF clc_lotlevel > 0 */

                  else
                     l_continue = yes.

                  if l_continue = no
                  then do:
                     undotran = yes.
                     undo locloop, retry.
                  end. /* IF l_continue */

                  else do:

                     /* IF USER WISHES TO CONTINUE, EXECUTE LOGIC TO   */
                     /* FIND IF THE RECEIVED LOTSERIAL IS PRESENT IN   */
                     /* ANY SITE/LOCATION OTHER THAN THE SHIP-FROM     */
                     /* SITE/LOCATION IN COMBINATION WITH ACTIVE       */
                     /* COMPLIANCE LEVEL.                              */

                     if (can-find (first ld_det
                        where ld_domain = global_domain
                        and   ( ( ld_site <> rmd_site
                                and ld_loc  <> rmd_loc)
                              or (ld_site <> rmd_site))
                        and (ld_lot  = lotserial)
                        and ( ( clc_lotlevel = 1
                              and ld_part = pod_part)
                            or  clc_lotlevel = 2)))
                        or (can-find (first sr_wkfl
                              where sr_domain = global_domain
                              and   sr_userid = mfguser
                              and   sr_lotser = lotserial))
                     then
                        l_scan = yes.
                     else do:
                        l_scan = no.
                        if can-find (first tr_hist
                           where  tr_domain  =  global_domain
                           and    tr_serial  = lotserial
                           and    tr_nbr     <> pod_nbr
                           and    tr_part    = pod_part
                           and    tr_program = "fsrtvis.p")
                        then
                           l_scan = yes.
                     end. /* ELSE DO */

                  end. /* ELSE DO */

               end. /* IF AVAILABLE rmd_det */

               if l_scan = yes
               then do:
                  run lotserialvalidation
                     (input  pt_lot_ser,
                      input  lotserial,
                      input  site,
                      input  cline,
                      input  lotref,
                      input  pod_nbr,
                      input  pt_part,
                      input  location,
                      input  pod_lot_rcpt,
                      output l_undo).
                  if l_undo
                  then
                     undo, retry.
               end. /* IF l_scan = YES */

            end. /* IF l_flag = yes AND ... */

            if multi_entry = no then do:

               /* PERFORM EDITS HERE FOR PURCHASE ORDERS.  RTS
               EDITS ARE DONE LATER... */

               /* ADDED CONDITION FOR RTS RECEIPTS HAVING LOT/SERIAL */
               /* NOT SHIPPED EARLIER BUT FOUND IN INVENTORY.        */

               if (pod_type = "" and pod_fsm_type = "")
                  or (pod_type     = "R"
                  and pod_fsm_type = "RTS-RCT"
                  and l_flag       = yes
                  and l_scan       = yes)
               then do:

                  /* FOR A NEGATIVE RECEIPT AGAINST A CONSIGNED LINE      */
                  /* CHECK WHETHER A POSITIVE RECEIPT EXISTS FOR THE LINE */

                  if pod_consignment and lotserial_qty < 0
                  then do:
                     for each cnsix_mstr no-lock
                         where cnsix_domain         = global_domain
                           and cnsix_part           = pod_part
                           and cnsix_site           = pod_site
                           and cnsix_po_nbr         = pod_nbr
                           and cnsix_pod_line       = pod_line
                           and cnsix_lotser         = lotserial
                           and cnsix_ref            = lotref:
                        accumulate cnsix_qty_consigned (total).
                     end. /* for each cnsix */
                     if (accum total cnsix_qty_consigned)
                        < absolute(lotserial_qty)
                     then do:
                        /* NO CONSIGNED INVENTORY CAN BE RETURNED FOR PO LINE */
                        run displayMessage2 (input 6303,
                                             input 3,
                                             input pod_nbr,
                                             input string(pod_line)).

                        undo lineloop, retry lineloop.
                     end. /* accum */
                  end. /* IF pod_consignment */

                  /* MODIFIED TENTH INPUT PARAMTER SUCH THAT A STRING */
                  /* IS PASSED TO THE PROCEDURE validateInventory     */

                  /* ACCUMULATE TOTAL QUANTITY FOR THE SAME */
                  /* ITEM/SITE/LOCATION/LOTSER/REF */
                  l_total = 0.
                  for each b_pod_det
                     where b_pod_det.pod_domain =  pod_det.pod_domain
                       and b_pod_det.pod_nbr    =  pod_det.pod_nbr
                       and b_pod_det.pod_part   =  pod_det.pod_part
                       and b_pod_det.pod_line   <> pod_det.pod_line
                  no-lock:
/*GUI*/ if global-beam-me-up then undo, leave.


                     if can-find(first sr_wkfl
                                    where sr_wkfl.sr_domain = global_domain
                                      and sr_wkfl.sr_userid = mfguser
                                      and sr_wkfl.sr_lineid =
                                          string(b_pod_det.pod_line)
                                      and sr_wkfl.sr_site   = site
                                      and sr_wkfl.sr_loc    = location
                                      and sr_wkfl.sr_lotser = lotserial
                                      and sr_wkfl.sr_ref    = lotref  )
                     then do:
                        {pxrun.i &PROC='getUMConversionToPOLine'
                                 &PROGRAM='porcxr1.p'
                                 &PARAM="(input b_pod_det.pod_rum,
                                          buffer b_pod_det,
                                          output l_conv_to_pod_um,
                                          output l_use_pod_um_conv)"
                                 &NOAPPERROR=true
                                 &CATCHERROR=true
                        }


                        {pxrun.i &PROC='getReceiptUMConversion'
                                 &PROGRAM='porcxr1.p'
                                 &PARAM="(input b_pod_det.pod_rum,
                                          input l_conv_to_pod_um,
                                          buffer pt_mstr,
                                          buffer b_pod_det,
                                          output l_trans_conv)"
                                 &NOAPPERROR=true
                                 &CATCHERROR=true
                        }

                        l_total = l_total  + (b_pod_det.pod_qty_chg *
                                              l_trans_conv ).

                     end. /* IF CAN-FIND(FIRST sr_wkfl */
                  end.
/*GUI*/ if global-beam-me-up then undo, leave.
 /* FOR EACH b_pod_det */

                  l_total = (lotserial_qty * (trans_conv) )  + l_total.
                  {pxrun.i &PROC='validateInventory' &PROGRAM='porcxr2.p'
                     &PARAM="(input transtype,
                              input site,
                              input location,
                              input global_part,
                              input lotserial,
                              input lotref,
                              input l_total,
                              input trans_um,
                              input ponbr,
                              input (if lotserial_qty >=0
                                     then
                                        string(poline)
                                     else
                                        """"),
                              input yes)"
                    &NOAPPERROR=true
                    &CATCHERROR=true}


                  if return-value <> {&SUCCESS-RESULT}
                  then
                     if batchrun
                     then
                        undo edit-loop, retry edit-loop.
                     else
                        undo locloop, retry.

               end. /* IF (POD_TYPE = "" AND POD_FSM_TYPE = "") */

               /* PERFORM EDITS FOR RTS SHIPMENT/RECEIPTS WITH INVENTORY
               ISSUE/RECEIPT = YES ( -> POD_TYPE = " " INSTEAD OF "R") */

               /* NOTE: FOR RTS RECEIPTS, IT'S JUST LIKE EDITING A PO RECEIPT,
               HOWEVER, AN RTS RETURN IS EDITED AS IF IT'S A RECEIPT FOR A
               NEGATIVE QUANTITY. */

               /*@MODULE RTS BEGIN*/
               /* ACCUMULATE TOTAL QUANTITY FOR THE SAME */
               /* ITEM/SITE/LOCATION/LOTSER/REF */
               l_total = 0.
               for each b_pod_det
                  where b_pod_det.pod_domain =  pod_det.pod_domain
                    and b_pod_det.pod_nbr    =  pod_det.pod_nbr
                    and b_pod_det.pod_part   =  pod_det.pod_part
                    and b_pod_det.pod_line   <> pod_det.pod_line
               no-lock :
/*GUI*/ if global-beam-me-up then undo, leave.


                  if can-find(first sr_wkfl
                                 where sr_wkfl.sr_domain = b_pod_det.pod_domain
                                   and sr_wkfl.sr_userid = mfguser
                                   and sr_wkfl.sr_lineid =
                                       string(b_pod_det.pod_line)
                                   and sr_wkfl.sr_site   = site
                                   and sr_wkfl.sr_loc    = location
                                   and sr_wkfl.sr_lotser = lotserial
                                   and sr_wkfl.sr_ref    = lotref  )
                  then do:

                     {pxrun.i &PROC='getUMConversionToPOLine'
                              &PROGRAM='porcxr1.p'
                              &PARAM="(input b_pod_det.pod_rum,
                                       buffer b_pod_det,
                                       output l_conv_to_pod_um,
                                       output l_use_pod_um_conv)"
                              &NOAPPERROR=true
                              &CATCHERROR=true
                     }

                     {pxrun.i &PROC='getReceiptUMConversion'
                              &PROGRAM='porcxr1.p'
                              &PARAM="(input b_pod_det.pod_rum,
                                       input l_conv_to_pod_um,
                                       buffer pt_mstr,
                                       buffer b_pod_det,
                                       output l_trans_conv)"
                              &NOAPPERROR=true
                              &CATCHERROR=true
                     }

                     l_total = l_total  + (b_pod_det.pod_qty_chg *
                                           l_trans_conv).
                  end. /* IF CAN-FIND(FIRST sr_wkfl */
               end.
/*GUI*/ if global-beam-me-up then undo, leave.
 /* FOR EACH b_pod_det */
               l_total = (lotserial_qty * (trans_conv) )  + l_total.

               if (pod_type = "" and pod_fsm_type <> "") then do:
                  if (pt_lot_ser <> "S") then do:
                     {gprun.i ""icedit.p""
                        "(input  transtype,
                                input  site,
                                input  location,
                                input  global_part,
                                input  lotserial,
                                input  lotref,
                                input  if pod_fsm_type = ""RTS-RCT"" then
                                          l_total
                                       else
                                          l_total * -1,
                                input  trans_um,
                                input  """",
                                input  """",
                                output undotran)"}
/*GUI*/ if global-beam-me-up then undo, leave.

                  end. /* IF (PT_LOT_SER <> "S") */
                  else if pt_lot_ser = "S" then do:
                     {gprun.i ""icedit5.p""
                        "(input  transtype,
                                input  site,
                                input  location,
                                input  global_part,
                                input  lotserial,
                                input  lotref,
                                input  if pod_fsm_type = ""RTS-RCT"" then
                                          l_total
                                       else
                                          l_total * -1,
                                input  trans_um,
                                input  """",
                                input  """",
                                output undotran)"}
/*GUI*/ if global-beam-me-up then undo, leave.

                  end. /* ELSE IF PT_LOT_SER = "S" */

                  if undotran then
                     undo locloop, retry.

               end. /* IF POD_TYPE = "" AND POD_FSM_TYPE <> "" */

               /* PERFORM OTHER RTS EDITS - THESE ARE THE RTS SHIPMENTS
               AND RECEIPTS WHERE INVENTORY ISSUE/RECEIPT = NO,
               I.E., INSTEAD OF 'RECEIVING' PARTS, THEY ARE ABOUT
               TO BE TRANSFERRED BETWEEN A SUPPLIER SITE/LOCATION AND
               AN INTERNAL WAREHOUSE SITE/LOCAION. */

               else if pod_fsm_type <> ""
                    and  pod_type   <> "M"
                    then do:

                       /* ADDED ELEVENTH INPUT PARAMETER l_flag  */
                       /* TO CONDITIONALIZE THE CALL TO ICEDIT.i */
                       {gprun.i ""fsrtved.p""
                           "(input pod_nbr,
                             input pod_line,
                             input pod_rma_type,
                             input site,
                             input location,
                             input lotserial,
                             input lotref,
                             input lotserial_qty,
                             input trans_conv,
                             input trans_um,
                             input l_flag,
                             output undotran,
                             output msgnbr,
                             output errsite,
                             output errloc)"}
/*GUI*/ if global-beam-me-up then undo, leave.


                  if undotran then do:
                     {pxmsg.i
                        &MSGNUM=msgnbr
                        &ERRORLEVEL={&INFORMATION-RESULT}
                        &MSGARG1=errsite
                        &MSGARG2=errloc
                        &MSGARG3=""""}
                     undo locloop,retry.
                  end. /* IF UNDOTRAN */
               end. /* ELSE IF POD_FSM_TYPE <> "" */
               /*@MODULE RTS END*/

               if pod_type = "" then do:
                  {pxrun.i &PROC='validateReceiptToPOSiteTransfer'
                     &PROGRAM='porcxr2.p'
                     &PARAM="(input rct_site,
                                    input site,
                                    input transtype,
                                    input pod_loc,
                                    input location,
                                    input global_part,
                                    input lotserial,
                                    input lotref,
                                    input (lotserial_qty * trans_conv),
                                    input trans_um,
                                    input ponbr,
                                    input poline)"
                     &NOAPPERROR=true
                     &CATCHERROR=true
                     }
                  if return-value <> {&SUCCESS-RESULT} then undo locloop, retry.
               end.  /* if pod_type = "" */

               {pxrun.i &PROC='readFirstDetailForLine' &PROGRAM='porcxr2.p'
                  &PARAM="(input integer(cline),
                                 buffer sr_wkfl,
                                 input {&LOCK_FLAG},
                                 input {&WAIT_FLAG})"
                  &NOAPPERROR=true
                  &CATCHERROR=true
                  }

               if lotserial_qty = 0 then do:
                  if available sr_wkfl then do:
                     total_lotserial_qty = total_lotserial_qty - sr_qty.
                     delete sr_wkfl.
                  end. /* IF AVAILABLE SR_WKFL */
               end. /* IF LOTSERIAL_QTY = 0 */
               else do:
                  if available sr_wkfl then
                  assign
                     total_lotserial_qty = total_lotserial_qty - sr_qty
                     + lotserial_qty
                     sr_site = site
                     sr_loc = location
                     sr_lotser = lotserial
                     sr_ref = lotref
                     sr_vend_lot = pod__qad04[1]
                     sr_qty = lotserial_qty.
                  else do:
                     {pxrun.i &PROC='createPOReceiptDetail' &PROGRAM='porcxr2.p'
                        &PARAM="(buffer sr_wkfl,
                                       input mfguser,
                                       input integer(cline),
                                       input site,
                                       input location,
                                       input lotserial,
                                       input lotref,
                                       input """",
                                       input lotserial_qty)"
                        &NOAPPERROR=true
                        &CATCHERROR=true
                        }
                     {pxrun.i &PROC='processRead' &PROGRAM='porcxr2.p'
                        &PARAM="(input mfguser,
                                       input integer(cline),
                                       input site,
                                       input location,
                                       input lotserial,
                                       input lotref,
                                       buffer sr_wkfl,
                                       input {&LOCK_FLAG},
                                       input {&WAIT_FLAG})"
                        &NOAPPERROR=true
                        &CATCHERROR=true
                        }
                     assign
                        sr_vend_lot = pod__qad04[1].

                     total_lotserial_qty = total_lotserial_qty
                     + lotserial_qty.

                     if recid(sr_wkfl) = -1 then .
                  end. /* ELSE DO: */
               end. /* IF LOTSERIAL_QTY <> 0 */

               if porec or is-return then do:

                  {pxrun.i &PROC='validateSingleItemOrLotSerialLocation'
                     &PROGRAM='porcxr2.p'
                     &PARAM="(input site,
                                    input location,
                                    input lotserial,
                                    input lotref,
                                    input pod_nbr,
                                    input pod_line,
                                    input yes)"
                     &NOAPPERROR=true
                     &CATCHERROR=true
                     }
                  if return-value <> {&SUCCESS-RESULT} then
                     undo locloop, retry.
               end. /* IF POREC OR IS-RETURN */

               /*@MODULE TAXES BEGIN*/
               /* IF SITE CHANGED ALLOW USER TO CHANGE TAX ENVIRONMENT */
               if site <> pod_site and pod_taxable then do:
                  undo-taxes = true.
                  if c-application-mode = "API" then
                     run setPurchaseOrderTransDetRow in apiMethodHandle
                        (input ttPurchaseOrderTransDet.apiSequence).

                  {gprun.i ""poporctx.p""
                     "(input recid(po_mstr),
                             input site,
                             input pod_site,
                             input pod_taxable,
                             input pod_taxc,
                             input-output pod_tax_usage,
                             input-output pod_tax_env,
                             input-output pod_tax_in,
                             input-output undo-taxes)"}
/*GUI*/ if global-beam-me-up then undo, leave.

                  if undo-taxes then undo locloop, retry.
               end. /* IF SITE <> POD_SITE AND POD_TAXABLE */
               /*@MODULE TAXES END*/
            end. /* ELSE IF NOT MULTI_ENTRY */

            /*mxb - this can stay in chui because porcat02.p will be
            restructured to expose logic to XUI*/
            /*SET AND UPDATE INVENTORY DETAIL ATTRIBUTES*/
            find first attr_wkfl
               where chg_line = string(pod_line) exclusive-lock no-error.
            if available attr_wkfl
               and (pod_type = ""
               or   l_route)
            then do:

               if status_actv = no
               then do:

                  for first ld_det
                     fields (ld_site ld_loc ld_part ld_lot ld_ref ld_status)
                     where ld_site   = site
                     and   ld_loc    = location
                     and   ld_part   = pod_part
                     and   ld_lot    = lotserial
                     and   ld_ref    = lotref
                     and   ld_domain = global_domain
                  no-lock:
                  end.  /* FOR FIRST ld_det */

                  if available ld_det
                  then
                     chg_status = ld_status.

                  else do:

                     for first loc_mstr
                        fields (loc_site loc_loc loc_status)
                        where loc_site   = site
                        and   loc_loc    = location
                        and   loc_domain = global_domain
                     no-lock:
                     end.  /* FOR FIRST loc_mstr */

                     if available loc_mstr
                     then
                        chg_status = loc_status.

                     else
                        for first si_mstr
                           fields (si_site si_status)
                           where si_site   = site
                           and   si_domain = global_domain
                           no-lock:
                          chg_status = si_status.
                        end.  /* FOR FIRST si_mstr */

                  end. /* ELSE DO: */

               end. /* IF status_actv = no */

               if c-application-mode = "API" then
                     run setPurchaseOrderTransDetRow in apiMethodHandle
                        (input ttPurchaseOrderTransDet.apiSequence).

               do on error undo, return error return-value:
                  {gprun.i ""porcat02.p""
                     "(input  recid(pod_det),
                             input  chg_attr,
                             input  eff_date,
                             input-output chg_assay,
                             input-output chg_grade,
                             input-output chg_expire,
                             input-output chg_status,
                             input-output assay_actv,
                             input-output grade_actv,
                             input-output expire_actv,
                             input-output status_actv)"}
/*GUI*/ if global-beam-me-up then undo, leave.

               end.
               /*TEST FOR ATTRIBUTE CONFLICTS*/
               {pxrun.i &PROC='validateAttributes' &PROGRAM='porcxr1.p'
                  &PARAM="(buffer pod_det,
                                 input  eff_date,
                                 input  chg_assay,
                                 input  chg_grade,
                                 input  chg_expire,
                                 input  chg_status,
                                 input  assay_actv,
                                 input  grade_actv,
                                 input  expire_actv,
                                 input  status_actv)"
                  &NOAPPERROR=true
                  &CATCHERROR=true
                  }
               if return-value <> {&SUCCESS-RESULT} then do:
                  next-prompt site.
                  undo locloop, retry.
               end.

            end. /* IF AVAIL ATTR_WKFL..*/

            /*@MODULE PRM BEGIN*/
            if porec and prm-avail then
               run validate-prm-records.
            if porec and prm-avail and
               invalid-prm-po-ln-rcpt then
                  undo locloop, retry.

            /*@MODULE PRM END*/
         end. /* LOCLOOP: DO ON ERROR..*/

         pod_qty_chg = total_lotserial_qty.

         /*@TO-DO  need to call this in xui.*/
         /* CHECK OPERATION QUEUE QTY'S */
         {gprun.i ""poporca6.p""
            "(input ""receipt"",
                    input pod_nbr,
                    input wolot,
                    input woop,
                    input move)"}
/*GUI*/ if global-beam-me-up then undo, leave.

         /*@TO-DOEND*/

         {pxrun.i &PROC='setTotalReceived' &PROGRAM='porcxr1.p'
            &PARAM="(input use_pod_um_conv,
                          input total_lotserial_qty,
                          input conv_to_pod_um,
                          input pod_qty_rcvd,
                          input pod_um_conv,
                          output total_received)"
            &NOAPPERROR=true
            &CATCHERROR=true
            }

         /* If it's an RTS shipment(issue) all pod_det qty fields are */
         /* expressed in negative numbers.  For correct calculations  */
         /* of pod_bo_chg and ultimately tr_hist back order qty,      */
         /* switch the sign of total_received.                        */

         /*@MODULE RTS BEGIN*/
         if pod_rma_type = "O" then
            total_received = total_received * -1.
         /*@MODULE RTS END*/

         {pxrun.i &PROC='setBackOrder' &PROGRAM='porcxr1.p'
            &PARAM="(input cancel_bo,
                           input total_received,
                           input eff_date,
                           input conv_to_pod_um,
                           buffer pod_det,
                           input total_lotserial_qty,
                           input-output qopen)"
            &NOAPPERROR=true
            &CATCHERROR=true
            }

         assign
            pod_rum_conv = conv_to_pod_um
            pod_rum = receipt_um
            pod_ps_chg = packing_qty.

         /* Only update blanket order if user requests update */
         updt_blnkt = no.

         /*@MODULE wiplottrace BEGIN*/
         if pod_type = 's'
         then
            {gprun.i ""porwiplt.p""
                     "(input  recid(pod_det),
                       input  wolot,
                       input  woop,
                       input  move,
                       input-output table tt_po_lineqty,
                       output undo_all)"}
/*GUI*/ if global-beam-me-up then undo, leave.


         if pod_type = 's' and
            undo_all then undo lineloop, retry lineloop.
         /*@MODULE wiplottrace END*/

         /* UPDT_BLNKT_LIST IS A COMMA SEPARATED LIST OF ALL POD_LINE
         NUMBERS WHICH MUST HAVE THE BLANK PO RELEASE QUANTITY UPDATED

         IF THE USER IS MODIFYING THE RECORD, IT IS POSSIBLE THAT
         OF UPDT_BLNK_LIST HAS BEEN PRVIOUSLY UPDATED TO SHOW UPDT_BLNK =
         YES, IF SO, REMOVE ANY PREVIOUSLY FLAG SETTINGS BECUASE THE USER
         WILL BE PROMPTED AGAIN.
         W-INT1 = THE POSITION THE LINE NUMBER NEEDING REMOVAL STARTS ON
         W-INT2 = THE POSITION THE COMMA AFTER THE LINE NUMBER IS ON
         */

         /*@TO-DO need call poporca4.p in xui*/
         if can-do(updt_blnkt_list,string(pod_line)) then
         assign
            w-int1 = index(updt_blnkt_list, string(pod_line))
            w-int2 = (index(substring(updt_blnkt_list,w-int1),
            ",")) + w-int1 - 1
            updt_blnkt_list =
            substring(updt_blnkt_list,1,w-int1 - 1) +
            substring(updt_blnkt_list,w-int2 + 1).

         if  pod_rma_type = "O"
         and pod_qty_ord  < 0
         then
            total_received = total_received * -1.

         /* OVER-RECEIPT TOLERANCE CHECKS */
         if pod_sched or (not pod_sched and
            (total_received > pod_qty_ord and pod_qty_ord >= 0) or
            (total_received < pod_qty_ord and pod_qty_ord < 0)) then do:

            pod_recno = recid(pod_det).
            if c-application-mode = "API" then
               run setPurchaseOrderTransDetRow in apiMethodHandle
                  (input ttPurchaseOrderTransDet.apiSequence).

            {gprun.i ""poporca4.p"" "(output yn)"}
/*GUI*/ if global-beam-me-up then undo, leave.

            if yn then undo lineloop, retry lineloop.
         end. /* IF POD_SCHED OR (NOT POD_SCHED AND */
         /*@TO-DOEND*/

         if  pod_rma_type = "O"
         and pod_qty_ord  < 0
         then
            total_received = total_received * -1.

         if cmmt_yn then do:
            if c-application-mode <> "API" then
               run hide-frames.

            assign
               cmtindx = pod_cmtindx
               /*@TO-DO - master comments defaults*/ /*mxb*/
               global_ref
               = caps(getTermLabel("RCPT",8)) + ": " + pod_nbr + "/" + string(pod_line).
            /*@TO-DOEND*/

            if c-application-mode = "API" then do:
               {gpttcp.i ttPurchaseOrderTransDetCmt
                     ttTransComment
                     "    ttPurchaseOrderTransDetCmt.nbr  = pod_det.pod_nbr
                      and ttPurchaseOrderTransDetCmt.line = pod_det.pod_line
                     "
                     true
                  }
               run setTransComment in apiMethodHandle
                  (input table ttTransComment).
            end.
            do on error undo, return error return-value:
               {gprun.i ""gpcmmt01.p"" "(input ""pod_det"")"}
/*GUI*/ if global-beam-me-up then undo, leave.

            end.
            pod_cmtindx = cmtindx.
         end. /* IF CMMT_YN */

         /*@MODULE PRM BEGIN*/
         if porec and prm-avail and c-application-mode <> "API" then
            run display-pao-lines.
         /*@MODULE PRM END*/

      end. /* DO TRANSACTION */
   end. /* lineloop: repeat: */
   empty temp-table tt_po_lineqty.

   {&POPORCA-P-TAG12}
   if not batchrun then do:
      do on endkey undo edit-loop, leave edit-loop:
         assign
            l_remove_srwkfl = yes
            yn              = yes.
         if porec then
         /* DISPLAY PURCHASE ORDER LINES BEING RECEIVED? */
         msgnbr  = 340.
         else
         /* DISPLAY ITEMS BEING ISSUED? */
         msgnbr  = 636.

         {pxmsg.i
            &MSGNUM=msgnbr
            &ERRORLEVEL={&INFORMATION-RESULT}
            &CONFIRM=yn}
         /* Display purchase order lines being received ? */

         if yn then do:
            if c-application-mode <> "API" then
               run hide-frames.

            for each pod_det
               fields (pod_domain      pod_bo_chg   pod_cmtindx
                       pod_due_date    pod_fsm_type pod_line
                       pod_lot_rcpt    pod_nbr      pod_op
                       pod_part        pod_pjs_line pod_project
                       pod_consignment pod_ps_chg   pod_qty_chg
                       pod_qty_ord     pod_qty_rcvd pod_rma_type
                       pod_rum         pod_rum_conv pod_sched
                       pod_site        pod_status   pod_taxable
                       pod_taxc        pod_tax_env  pod_tax_in
                       pod_tax_usage   pod_type     pod_um
                       pod_um_conv     pod_vpart    pod_wo_lot
                       pod__qad04[1])
                   where pod_det.pod_domain = global_domain and  pod_nbr =
                   po_nbr and pod_status <> "c"
                  and pod_status <> "x" and pod_qty_chg <> 0 no-lock
                  use-index pod_nbrln ,
                  each sr_wkfl
                  fields( sr_domain sr_lineid sr_loc sr_lotser sr_qty sr_ref
                         sr_site sr_userid sr_vend_lot) no-lock
                   where sr_wkfl.sr_domain = global_domain and  sr_userid =
                   mfguser
                  and sr_lineid = string(pod_line) with width 80:
/*GUI*/ if global-beam-me-up then undo, leave.


               if c-application-mode <> "API" then
                  display
                     pod_line
                     pod_part
                     sr_site
                     sr_loc column-label "Location!Ref"
                     sr_lotser column-label "Lot/Serial!Supplier Lot"
                               format "x(22)"
                     sr_qty with frame e.

               if sr_ref <> "" or sr_vend_lot <> "" then do:
                  if c-application-mode <> "API" then
                     down 1 with frame e.
             /* DISPLAY RECORDS WITH CORRECT ALIGNMENT IN NETUI */
             {gpwait.i &INSIDELOOP=yes &FRAMENAME=e}
                  if c-application-mode <> "API" then
                     display
                        sr_ref @ sr_loc
                        sr_vend_lot @ sr_lotser with frame e.

               end. /* IF SR_REF <> "" OR SR_VEND_LOT <> "" */
               if c-application-mode <> "API" then
                  down 1 with frame e.
           {gpwait.i &INSIDELOOP=yes &FRAMENAME=e}
            end.
/*GUI*/ if global-beam-me-up then undo, leave.
 /* FOR EACH POD_DET..*/
        {gpwait.i &OUTSIDELOOP=yes}
         end. /* IF YN */
      end. /* DO ON ENDKEY..*/

      do on endkey undo edit-loop, leave edit-loop:
         assign
            proceed = no
            yn      = yes.
         /* IS ALL INFORMATION CORRECT */
         /*V8+*/
               {mfgmsg10.i 12 1 yn} /*Is all info correct */
         if yn = ? then
            undo edit-loop, leave edit-loop.   
         l_remove_srwkfl = no.

         if yn then do:
            /* CHECK FOR RECEIPTS OF DIFFERENT ITEMS ON A   */
            /* SINGLE ITEM LOCATION                         */

            {&POPORCA-P-TAG3}
            for each sr_wkfl
                  fields( sr_domain sr_lineid sr_loc sr_lotser sr_qty
                          sr_ref sr_site sr_userid sr_vend_lot)
                   where sr_wkfl.sr_domain = global_domain and  sr_userid =
                   mfguser no-lock:
/*GUI*/ if global-beam-me-up then undo, leave.


               {pxrun.i &PROC='validateSingleItemOrLotSerialLocation'
                  &PROGRAM='porcxr2.p'
                  &PARAM="(input sr_site,
                                    input sr_loc,
                                    input sr_lotser,
                                    input sr_ref,
                                    input po_nbr,
                                    input integer(sr_lineid),
                                    input no)"
                  &NOAPPERROR=true
                  &CATCHERROR=true
                  }
               if return-value <> {&SUCCESS-RESULT} then
                  undo edit-loop, retry edit-loop.

               if sr_qty < 0
               then do:

                  for first pod_det
                     fields (pod_domain      pod_bo_chg   pod_cmtindx
                             pod_due_date    pod_fsm_type pod_line
                             pod_lot_rcpt    pod_nbr      pod_op
                             pod_part        pod_pjs_line pod_project
                             pod_consignment pod_ps_chg   pod_qty_chg
                             pod_qty_ord     pod_qty_rcvd pod_rma_type
                             pod_rum         pod_rum_conv pod_sched
                             pod_site        pod_status   pod_taxable
                             pod_taxc        pod_tax_env  pod_tax_in
                             pod_tax_usage   pod_type     pod_um
                             pod_um_conv     pod_vpart    pod_wo_lot
                             pod__qad04[1])
                     where pod_domain = global_domain
                       and pod_nbr    = po_nbr
                       and pod_line   = integer(sr_lineid)
                  no-lock:
                  end. /* FOR FIRST pod_det */

                  /* FOR A NEGATIVE RECEIPT AGAINST A CONSIGNED LINE      */
                  /* CHECK WHETHER A POSITIVE RECEIPT EXISTS FOR THE LINE */

                  if available pod_det and pod_consignment
                  then do:
                     for each cnsix_mstr no-lock
                         where cnsix_domain         = global_domain
                           and cnsix_part           = pod_part
                           and cnsix_site           = pod_site
                           and cnsix_po_nbr         = pod_nbr
                           and cnsix_pod_line       = pod_line
                           and cnsix_lotser         = sr_lotser
                           and cnsix_ref            = sr_ref:
                        accumulate cnsix_qty_consigned (total).
                     end. /* for each cnsix */
                     if (accum total cnsix_qty_consigned)
                        < absolute(sr_qty)
                     then do:
                        /* NO CONSIGNED INVENTORY CAN BE RETURNED FOR PO LINE */
                        run displayMessage2 (input 6303,
                                             input 3,
                                             input pod_nbr,
                                             input string(pod_line)).

                        undo edit-loop, retry edit-loop.
                     end. /* accum */
                  end. /* IF AVAILABLE pod_det */
               end.
/*GUI*/ if global-beam-me-up then undo, leave.
 /* IF sr_qty < 0 */

            end.  /* FOR EACH SR_WKFL */

            {&POPORCA-P-TAG2}
            proceed = yes.
            leave.
         end.  /* IF YN */
         else do:
     /* User should be able to quit in GUI if a wrong PO is received.
        Here, if the user selects 'No' to all information correct then
        he will be asked to confirm exiting the PO Receipt. */
            if {gpiswrap.i} then
            do:
           /* msgnum 36 - Please confirm exit. */
               {pxmsg.i
                  &MSGNUM=36
                  &ERRORLEVEL={&INFORMATION-RESULT}
                  &CONFIRM=l_exit_yn}
               if l_exit_yn then
               do:
                  proceed = no.
                  l_remove_srwkfl = yes.
                  undo, leave.
               end. /* IF l_exit_yn THEN */
            end. /* IF {gpiswrap.i} THEN DO: */
         end. /*ELSE DO: */
      end. /* do on endkey..*/
   end. /* if not batchrun */
   else do:
      proceed = yes.
      leave.
   end. /* else do: */

   {&POPORCA-P-TAG13}
end. /* edit-loop */

if c-application-mode <> "API" then
   run hide-frames.

if l_remove_srwkfl
then
   for each sr_wkfl exclusive-lock  where sr_wkfl.sr_domain = global_domain and
    sr_userid = mfguser:
      delete sr_wkfl.
end. /* IF l_remove_srwkfl */

/*MAIN-END*/

/* ========================================================================== */
/* *************************** INTERNAL PROCEDURES ************************** */
/* ========================================================================== */

/*============================================================================*/
PROCEDURE build-prm-temp-table:

/*------------------------------------------------------------------
PURPOSE :   Build the temp table required for PRM records.
PARAMETERS:
NOTES:      Added for ECO N05Q to help reduce action segment size.
-----------------------------------------------------------------*/

   /* CREATE TEMP-TABLE RECORD FOR PO LINE WHEN */
   /* PRM MODULE IS ENABLED AND PO LINE IS      */
   /* LINKED TO A PRM PROJECT LINE              */

   if prm-avail and porec then
   for each pod_det
      fields (pod_domain      pod_bo_chg   pod_cmtindx  pod_due_date
              pod_fsm_type    pod_line     pod_lot_rcpt pod_nbr
              pod_op          pod_part     pod_pjs_line pod_project
              pod_consignment pod_ps_chg   pod_qty_chg  pod_qty_ord
              pod_qty_rcvd    pod_rma_type pod_rum      pod_rum_conv
              pod_sched       pod_site     pod_status   pod_taxable
              pod_taxc        pod_tax_env  pod_tax_in   pod_tax_usage
              pod_type        pod_um       pod_um_conv  pod_vpart
              pod_wo_lot      pod__qad04[1])
      no-lock
          where pod_det.pod_domain = global_domain and  pod_nbr =
          po_mstr.po_nbr:
/*GUI*/ if global-beam-me-up then undo, leave.


      if pod_status = "c"
         or pod_status = "x" then next.

      if pod_rma_type <> "I"
         and pod_rma_type <> "" then next.

      if prm-avail
         and pod_det.pod_project  <> ""
         and pod_det.pod_pjs_line <> 0 then do:

         {gprunmo.i
            &program=""pjporca1.p""
            &module="PRM"
            &param="""(buffer pod_det)"""}
      end.  /*  IF PRM-AVAIL */
   end.
/*GUI*/ if global-beam-me-up then undo, leave.
 /* FOR EACH POD_DET */

END PROCEDURE.

/*============================================================================*/
PROCEDURE display-detail:

/*------------------------------------------------------------------
PURPOSE :   Display details in frame d.
PARAMETERS:
NOTES:      Added for ECO N05Q to help reduce action segment size
------------------------------------------------------------------*/

   display
      line
      pod_det.pod_qty_chg @ lotserial_qty
      pod_det.pod_ps_chg  @ packing_qty
      ln_stat             @ cancel_bo
      pod_det.pod_part
      pod_det.pod_vpart
      pod_det.pod_rum     @ receipt_um
      pod_det.pod_wo_lot  @ wolot
      pod_det.pod_op      @ woop
   with frame d.

END PROCEDURE.

/*============================================================================*/
PROCEDURE display-pao-lines:

/*------------------------------------------------------------------
PURPOSE :   Display the PRM Project Activity Order Lines attached that
can be linked to the project line..
PARAMETERS:
NOTES:      Added for ECO N05Q to help reduce action segment size.
------------------------------------------------------------------*/

   for first ttpao-det fields() no-lock
         where ttpao-recno = recid(pod_det):

      hide frame c no-pause.
      hide frame d no-pause.

      /* SELECT PAO LINES LINKED TO PROJECT LINE */
      /* ON WHICH PAR IS TO BE PERFORMED         */
      {gprunmo.i
         &program=""pjporpas.p""
         &module="PRM"
         &param="""(input lotserial_qty,
                    buffer pod_det)"""}

      view frame c.
      view frame d.
   end. /* FOR FIRST TTPAO-DET */

END PROCEDURE.

/*============================================================================*/
PROCEDURE hide-frames:

/*------------------------------------------------------------------
PURPOSE :   Hides the frames c, d and cship.
PARAMETERS:
NOTES:      Added for ECO N05Q to help reduce action segment size
------------------------------------------------------------------*/
   hide frame c     no-pause.
   hide frame cship no-pause.
   hide frame d     no-pause.

END PROCEDURE.

/*============================================================================*/
PROCEDURE init_poline_bkfl_input_output:
/*------------------------------------------------------------------------------
/* TO INITIALIZE WIP LOT TRACE TEMP TABLES*/
poporca.tag.p
init_poline_bkfl_input_output (
)

Parameters:

Exceptions:

PreConditions:

PostConditions:

</Comment1>
<Comment2>
Notes:

</Comment2>
<Comment3>
History:

</Comment3>
------------------------------------------------------------------------------*/

   run init_poline_bkfl_input_wip_lot in h_wiplottrace_procs.

   run init_poline_bkfl_output_wip_lot in h_wiplottrace_procs.

END PROCEDURE.

/*============================================================================*/
PROCEDURE save-receipt-qty:

/*------------------------------------------------------------------
PURPOSE :   Stores the receipt quantity entered into the PRM
temp-table ttprm-det for later reference.
PARAMETERS:
NOTES:
------------------------------------------------------------------*/
   for first ttprm-det exclusive-lock
         where ttprm-nbr  = pod_det.pod_nbr
         and ttprm-line = pod_det.pod_line:

      ttprm-qty = lotserial_qty.
   end. /* FOR FIRST TTPRM-DET */

END PROCEDURE.

/*============================================================================*/
PROCEDURE validate-prm-records:

/*------------------------------------------------------------------
PURPOSE :   Validates the PRM records associated with the purchase
order lines.
PARAMETERS:
NOTES:      Added for ECO N05Q to help reduce action segment size
------------------------------------------------------------------*/

   /* PERFORM PRM VALIDATIONS ON PO LINE RECEIPT */
   {gprunmo.i
      &program=""pjporvil.p""
      &module="PRM"
      &param="""(input site,
                 input location,
                 output invalid-prm-po-ln-rcpt,
                 buffer pod_det)"""}

END PROCEDURE.

/*PROCEDURE WILL DISPLAY THE ITEM DESCRIPTION */
PROCEDURE get_pt_description:
   define input parameter p_pod_part like pt_part  no-undo.
   define input parameter p_pod_desc like pod_desc no-undo.

   define variable p_pt_desc1 like pt_desc1 no-undo.
   define variable p_pt_desc2 like pt_desc2 no-undo.

   for first pt_mstr
      fields(pt_domain  pt_auto_lot pt_loc  pt_lot_grp pt_desc1
             pt_lot_ser pt_status   pt_part pt_um      pt_desc2)
      where pt_domain = global_domain
      and   pt_part   = p_pod_part
   no-lock:
   end. /* FOR FIRST pt_mstr */

   if available pt_mstr
   then
      assign
         p_pt_desc1 = pt_desc1
         p_pt_desc2 = pt_desc2.
   else
      assign
         p_pt_desc1 = p_pod_desc
         p_pt_desc2 = "".

   /* DESCRIPTION: p_pt_desc1 + p_pt_desc2 */
   {pxmsg.i &MSGNUM=2685
            &ERRORLEVEL=1
            &MSGARG1=getTermLabel('DESCRIPTION',45)
            &MSGARG2='":"'
            &MSGARG3=p_pt_desc1
            &MSGARG4=p_pt_desc2}

END PROCEDURE. /* get_pt_description */

PROCEDURE displayMessage:
    define input parameter ipMsgNum as integer no-undo.
    define input parameter ipErrorLevel as integer no-undo.

    {pxmsg.i &MSGNUM=ipMsgNum
             &ERRORLEVEL=ipErrorLevel}

END PROCEDURE. /* displayMessage */

PROCEDURE displayMessage1:
    define input parameter ipMsgNum as integer no-undo.
    define input parameter ipErrorLevel as integer no-undo.
    define input parameter ipMsgArg1 as character no-undo.

    {pxmsg.i &MSGNUM=ipMsgNum
             &ERRORLEVEL=ipErrorLevel
             &MSGARG1=ipMsgArg1}

END PROCEDURE. /* displayMessage1 */

PROCEDURE displayMessage2:
    define input parameter ipMsgNum as integer no-undo.
    define input parameter ipErrorLevel as integer no-undo.
    define input parameter ipMsgArg1 as character no-undo.
    define input parameter ipMsgArg2 as character no-undo.

    {pxmsg.i &MSGNUM=ipMsgNum
             &ERRORLEVEL=ipErrorLevel
             &MSGARG1=ipMsgArg1
             &MSGARG2=ipMsgArg2}

END PROCEDURE. /* displayMessage2 */

/*============================================================================*/
PROCEDURE lotserialvalidation:

/*--------------------------------------------------------------------------
PURPOSE :  For serialized item, ensure there aren't multiple sr_wkfl's
           for the current serial number.
PARAMETERS:
NOTES:      Added 6th and 7th parameters to the validateLotSerialAlreadyUsed
            procedure as po number and item in order to make the validation
            limited only to the same item when Lot control level is 0/1
----------------------------------------------------------------------------*/

   define input  parameter ip_lot_ser   as character     no-undo.
   define input  parameter ip_lotserial as character     no-undo.
   define input  parameter ip_site      as character     no-undo.
   define input  parameter ip_line      as integer       no-undo.
   define input  parameter ip_lotref    as character     no-undo.
   define input  parameter ip_pod_nbr   as character     no-undo.
   define input  parameter ip_part      as character     no-undo.
   define input  parameter ip_location  as character     no-undo.
   define input  parameter ip_lot_rcpt  like mfc_logical no-undo.
   define output parameter op_undo       like mfc_logical no-undo.

   {pxrun.i &PROC='validateLotSerialAlreadyUsed'
      &PROGRAM='porcxr2.p'
      &PARAM="(input ip_lot_ser,
               input ip_lotserial,
               input ip_site,
               input integer(ip_line),
               input ip_lotref,
               input ip_pod_nbr ,
               input ip_part,
               input ip_location )"
      &NOAPPERROR=True
      &CATCHERROR=True}

   if return-value <> {&SUCCESS-RESULT}
   then do:
      next-prompt
         lotserial
      with frame d.
      op_undo = true.
      leave.
   end. /* if return-value <> {&SUCCESS-RESULT} */

   {pxrun.i &PROC='validateLotSerialUsage'
      &PROGRAM='cllotxr.p'
      &PARAM="(input ip_part,
               input ip_lot_ser,
               input ip_lot_rcpt,
               input yes,
               input ip_lotserial)"
      &NOAPPERROR=true
      &CATCHERROR=true}

   if return-value <> {&SUCCESS-RESULT}
   then do:
      next-prompt
         lotserial
      with frame d.
      op_undo = true.
      leave.
   end. /* IF  return-value <> {&SUCCESS-RESULT} */
END PROCEDURE. /* lotserialvalidation */

PROCEDURE p_create_t_sr_wkfl:

   define input        parameter l_mfguser           as   character   no-undo.
   define input        parameter l_cline             as   character   no-undo.
   define input        parameter l_site              like si_site     no-undo.
   define input        parameter l_location          as   character   no-undo.
   define input        parameter l_lotserial         as   character   no-undo.
   define input        parameter l_lotref            as   character   no-undo.
   define input        parameter l_lotserial_qty     like lotserial_qty
                                                                      no-undo.
   define input-output parameter table               for  t_sr_wkfl.

   if not can-find(first t_sr_wkfl
                      where t_sr_userid = l_mfguser
                      and   t_sr_lineid = l_cline)
   then do:
      create t_sr_wkfl.
      assign
         t_sr_userid = l_mfguser
         t_sr_lineid = l_cline
         t_sr_site   = l_site
         t_sr_loc    = l_location
         t_sr_lotser = l_lotserial
         t_sr_ref    = l_lotref
         t_sr_qty    = l_lotserial_qty.
   end. /* IF NOT CAN-FIND(FIRST ... */
END PROCEDURE. /* p_create_t_sr_wkfl */

PROCEDURE p_create_default_sr_wkfl:

   define input        parameter l_update_sr_wkfl    like mfc_logical no-undo.
   define input        parameter l_mfguser           as   character   no-undo.
   define input        parameter l_cline             as   character   no-undo.
   define              parameter buffer sr_wkfl      for  sr_wkfl.
   define input-output parameter table               for  t_sr_wkfl.
   define input-output parameter l_delete_sr_wkfl    like mfc_logical no-undo.

   /* RE-CREATE DEFAULT sr_wkfl, IF sr_wkfl IS NOT UPDATED IN MULTI ENTRY */
   /* SCREEN. SO THE INVENTORY VALIDATION CAN BE DONE.                    */

   if l_delete_sr_wkfl
   then do:

      if not l_update_sr_wkfl
      then do:

         if not can-find(first sr_wkfl
                            where sr_domain = global_domain
                            and   sr_userid = l_mfguser
                            and   sr_lineid = l_cline)
         then do:
            for first t_sr_wkfl
               where t_sr_userid = l_mfguser
               and   t_sr_lineid = l_cline
               no-lock:

               create sr_wkfl.
               assign
                  sr_domain           = global_domain
                  sr_userid           = t_sr_userid
                  sr_lineid           = t_sr_lineid
                  sr_site             = t_sr_site
                  sr_loc              = t_sr_loc
                  sr_lotser           = t_sr_lotser
                  sr_ref              = t_sr_ref
                  sr_qty              = t_sr_qty.
               if recid(sr_wkfl) = -1
               then
                  .
            end. /* FOR FIRST t_sr_wkfl */

         end. /* IF NOT CAN-FIND(FIRST ... */
      end. /* IF NOT l_update_sr_wkfl */

      else do:

         /* DELETE TEMP-TABLE RECORD TO INDICATE DEFAULT sr_wkfl */
         /* IS UPDATED IN MULTI-ENTRY SCREEN                     */

         find first t_sr_wkfl
            where t_sr_userid = l_mfguser
            and   t_sr_lineid = l_cline
            exclusive-lock no-error.

         if available t_sr_wkfl
         then
            delete t_sr_wkfl.

      end. /* ELSE DO */

      l_delete_sr_wkfl = no.
   end. /* IF l_delete_sr_wkfl */
END PROCEDURE. /* p_create_default_sr_wkfl */

PROCEDURE p_delete_sr_wkfl:

   define input        parameter l_mfguser           as   character   no-undo.
   define input        parameter l_cline             as   character   no-undo.
   define input        parameter table               for  t_sr_wkfl.
   define input-output parameter l_tot_lotserial_qty like pod_qty_chg no-undo.
   define input-output parameter l_delete_sr_wkfl    like mfc_logical no-undo.

   define buffer sr_wkfl for sr_wkfl.

   for first t_sr_wkfl
      where t_sr_userid = l_mfguser
      and   t_sr_lineid = l_cline
      no-lock,
      first sr_wkfl
         where sr_domain  = global_domain
         and   sr_userid  = t_sr_userid
         and   sr_lineid  = t_sr_lineid
         and   sr_site    = t_sr_site
         and   sr_loc     = t_sr_loc
         and   sr_lotser  = t_sr_lotser
         and   sr_ref     = t_sr_ref
         exclusive-lock:

         assign
            l_tot_lotserial_qty = 0
            l_delete_sr_wkfl    = yes.

         delete sr_wkfl.

   end. /* FOR FIRST t_sr_wkfl */

END PROCEDURE. /* p_delete_sr_wkfl */
