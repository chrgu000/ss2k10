/* apvomta5.p - AP VOUCHER Receiver matching maintenance                      */
/* Copyright 1986-2007 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* REVISION: 7.2      LAST MODIFIED: 10/18/91   BY: mlv *F001*                */
/* REVISION: 7.2      LAST MODIFIED: 03/06/92   BY: pma *F085*                */
/* REVISION: 7.2      LAST MODIFIED: 01/29/92   BY: mlv *F096*                */
/* REVISION: 7.2      LAST MODIFIED: 07/13/92   BY: mlv *F725*                */
/* REVISION: 7.3      LAST MODIFIED: 01/26/93   BY: bcm *G418*                */
/* REVISION: 7.3      LAST MODIFIED: 02/24/93   BY: jms *G742*                */
/* REVISION: 7.3      LAST MODIFIED: 03/23/93   BY: jms *G860*                */
/* REVISION: 7.3      LAST MODIFIED: 06/11/93   BY: jms *GC14*                */
/* REVISION: 7.3      LAST MODIFIED: 07/09/93   BY: jms *GD32*                */
/* REVISION: 7.4      LAST MODIFIED: 07/23/93   BY: wep *H037*                */
/* REVISION: 7.4      LAST MODIFIED: 08/09/93   BY: bcm *H060*                */
/* REVISION: 7.4      LAST MODIFIED: 10/07/93   BY: bcm *H161*                */
/* REVISION: 7.4      PROGRAM SPLIT: 02/25/94   BY: pcd *H199*                */
/*                                   10/01/93   BY: jjs *H149*                */
/*                                   12/08/93   BY: wep *H267*                */
/*                                   01/24/94   by: jms *FL55*                */
/* FL55 modified by pcd as requested by jms 02/25/94                          */
/*                                   03/08/94   by: dpm *H075*                */
/*                                   04/04/94   by: pcd *H315*                */
/*                                   05/09/94   by: pmf *FO06*                */
/*                                   07/19/94   by: pmf *FP44*                */
/*                                   12/08/94   by: str *FU40*                */
/*                                   02/22/95   by: str *F0JB*                */
/*                                   03/22/95   by: pxe *F0KW*                */
/*                                   03/29/95   by: dzn *F0PN*                */
/*                                   04/19/95   by: dpm *H0CT*                */
/* REVISION: 8.5                     03/06/95   by: dpm *J044*                */
/* REVISION: 7.4                     05/04/95   by: jzw *H0DK*                */
/*                                   05/11/95   by: ame *G0MJ*                */
/*                                   07/24/95   by: jzw *G0SL*                */
/*                                   09/26/95   by: jzw *G0YD*                */
/*                                   11/28/95   by: mys *H0HD*                */
/*                                   01/02/96   by: jzs *H0J0*                */
/*                                   01/09/96   by: mys *G1JH*                */
/*                                   01/24/96   by: jzw *H0J6*                */
/* REVISION: 8.5      LAST MODIFIED: 10/03/95   by: mwd *J053*                */
/*                                   02/04/97   by: bkm *H0RZ*                */
/* REVISION: 8.5      LAST MODIFIED: 10/03/97   BY: *J22C* Irine D'mello      */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* Annasaheb Rahane   */
/* REVISION: 8.6E     LAST MODIFIED: 04/10/98   BY: *L00K* RVSL               */
/* REVISION: 8.6E     LAST MODIFIED: 04/14/98   BY: *J2LK* Dana Tunstall      */
/* REVISION: 8.6E     LAST MODIFIED: 05/09/98   BY: *L00Y* Jeff Wootton       */
/* Pre-86E commented code removed, view in archive revision 1.24              */
/* REVISION: 8.6E     LAST MODIFIED: 06/18/98   BY: *J2P7* Dana Tunstall      */
/* REVISION: 8.6E     LAST MODIFIED: 06/24/98   BY: *L032* John Evertse       */
/* REVISION: 8.6E     LAST MODIFIED: 08/04/98   BY: *L03K* Jeff Wootton       */
/* REVISION: 8.6E     LAST MODIFIED: 09/11/98   BY: *J2ZJ* Rajesh Talele      */
/* REVISION: 8.6E     LAST MODIFIED: 10/27/98   BY: *J32T* Prashanth Narayan  */
/* REVISION: 9.0      LAST MODIFIED: 12/02/98   BY: *J35Z* Abbas Hirkani      */
/* REVISION: 9.0      LAST MODIFIED: 12/15/98   BY: *J36Z* Prashanth Narayan  */
/* REVISION: 9.0      LAST MODIFIED: 02/02/99   BY: *J36W* Prashanth Narayan  */
/* REVISION: 9.0      LAST MODIFIED: 03/10/99   BY: *M0B3* Michael Amaladhas  */
/* REVISION: 9.0      LAST MODIFIED: 03/13/99   BY: *M0BD* Alfred Tan         */
/* REVISION: 9.0      LAST MODIFIED: 03/15/99   BY: *M0BG* Jeff Wootton       */
/* REVISION: 9.1      LAST MODIFIED: 10/01/99   BY: *N014* Murali Ayyagari    */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane   */
/* REVISION: 9.1      LAST MODIFIED: 04/19/00   BY: *J3MZ* Ranjit Jain        */
/* REVISION: 9.1      LAST MODIFIED: 06/23/00   BY: *M0NW* Vivek Gogte        */
/* REVISION: 9.1      LAST MODIFIED: 08/11/00   BY: *N0KK* Jacolyn Neder      */
/* REVISION: 9.1      LAST MODIFIED: 11/22/00   BY: *L15T* Veena Lad          */
/* REVISION: 9.1      LAST MODIFIED: 09/22/00   BY: *N0W0* Mudit Mehta        */
/* Revision: 1.51       BY: Katie Hilbert          DATE: 04/01/01 ECO: *P002* */
/* Revision: 1.52       BY: Ed van de Gevel        DATE: 06/29/01 ECO: *N0ZX* */
/* Revision: 1.53       BY: Jean Miller            DATE: 04/01/01 ECO: *P03F* */
/* Revision: 1.55       BY: Ashish Maheshwari      DATE: 01/30/02 ECO: *N182* */
/* Revision: 1.56       BY: John Pison             DATE: 03/05/02 ECO: *N1BT* */
/* Revision: 1.60       BY: Steve Nugent           DATE: 04/17/02 ECO: *P043* */
/* Revision: 1.62       BY: Patrick Rowan          DATE: 04/29/02 ECO: *P05Q* */
/* Revision: 1.64       BY: Patrick Rowan          DATE: 05/15/02 ECO: *P06L* */
/* Revision: 1.65       BY: Patrick Rowan          DATE: 05/24/02 ECO: *P018* */
/* Revision: 1.66       BY: Dan Herman             DATE: 06/18/02 ECO: *P090* */
/* Revision: 1.67       BY: Patrick Rowan          DATE: 08/01/02 ECO: *P0C8* */
/* Revision: 1.68       BY: Gnanasekar             DATE: 09/11/02 ECO: *N1PG* */
/* Revision: 1.69       BY: Patrick Rowan          DATE: 11/15/02 ECO: *P0K4* */
/* Revision: 1.73       BY: Jyoti Thatte           DATE: 12/02/02 ECO: *P0L6* */
/* Revision: 1.74       BY: Karan Motwani          DATE: 12/10/02 ECO: *N21F* */
/* Revision: 1.77       BY: Robin McCarthy         DATE: 02/28/03 ECO: *P0M9* */
/* Revision: 1.78       BY: Jyoti Thatte           DATE: 02/28/03 ECO: *P0MX* */
/* Revision: 1.79       BY: Mercy Chittilapilly    DATE: 05/21/03 ECO: *P0RM* */
/* Revision: 1.81       BY: Paul Donnelly (SB)     DATE: 06/26/03 ECO: *Q00B* */
/* Revision: 1.82       BY: Rajinder Kamra         DATE: 04/25/03 ECO: *Q003* */
/* Revision: 1.83       BY: K Paneesh              DATE: 07/31/03 ECO: *P0YN* */
/* Revision: 1.84       BY: Reena Ambavi           DATE: 08/27/03 ECO: *P110* */
/* Revision: 1.85       BY: Deepali Kotavadekar    DATE: 09/30/03 ECO: *P13S* */
/* Revision: 1.86       BY: Vandna Rohira          DATE: 11/03/03 ECO: *P14V* */
/* Revision: 1.89       BY: Ed van de Gevel        DATE: 12/01/03 ECO: *P0ZG* */
/* Revision: 1.90       BY: Ken Casey              DATE: 02/19/04 ECO: *N2GM* */
/* Revision: 1.91       BY: Bhagyashri Shinde      DATE: 02/25/04 ECO: *P1QH* */
/* Revision: 1.92       BY: Shivanand Hiremath     DATE: 03/12/04 ECO: *P1SL* */
/* Revision: 1.93       BY: Manisha Sawant         DATE: 04/29/04 ECO: *P1ZK* */
/* Revision: 1.94       BY: Preeti Sattur          DATE: 05/19/04 ECO: *P217* */
/* Revision: 1.95       BY: Shivanand Hiremath     DATE: 07/13/04 ECO: *P29R* */
/* Revision: 1.96       BY: Ed van de Gevel        DATE: 08/16/04 ECO: *Q077* */
/* Revision: 1.97       BY: Annapurna Vishwanathan DATE: 01/05/05 ECO: *P323* */
/* Revision: 1.99       BY: Robin McCarthy         DATE: 01/05/05 ECO: *P2P6* */
/* Revision: 1.100      BY: Pankaj Goswami         DATE: 02/16/05 ECO: *P36R* */
/* Revision: 1.101      BY: Sushant Pradhan        DATE: 04/06/05 ECO: *P3FX* */
/* Revision: 1.102      BY: Annapurna V            DATE: 04/19/05 ECO: *P3HF* */
/* Revision: 1.104      BY: Sukhad Kulkarni        DATE: 04/28/05 ECO: *P3JC* */
/* Revision: 1.106      BY: Alok Gupta             DATE: 06/29/05 ECO: *P3QB* */
/* Revision: 1.107      BY: Steve Nugent           DATE: 07/26/05 ECO: *P2PJ* */
/* Revision: 1.107.1.1  BY: Swati Sharma           DATE: 09/29/05 ECO: *P436* */
/* Revision: 1.107.1.4  BY: Steve Nugent           DATE: 03/31/06 ECO: *P4JR* */
/* Revision: 1.107.1.5  BY: Bhavik Rathod          DATE: 05/29/06 ECO: *P4SB* */
/* Revision: 1.107.1.6  BY: Amit Singh             DATE: 06/08/06 ECO: *Q0VR* */
/* Revision: 1.107.1.7  BY: Abhijit Gupta          DATE: 06/09/06 ECO: *P4T7* */
/* Revision: 1.107.1.8  BY: Megha Dubey            DATE: 06/19/06 ECO: *P4T8* */
/* Revision: 1.107.1.9  BY: Sundeep Kalla          DATE: 06/28/06 ECO: *P4T5* */
/* Revision: 1.107.1.11 BY: Megha Dubey            DATE: 07/08/06 ECO: *P4WT* */
/* Revision: 1.107.1.12 BY: Dilip Manawat          DATE: 07/24/06 ECO: *P4Y3* */
/* Revision: 1.107.1.13 BY: Naseem M Torgal        DATE: 10/12/06 ECO: *P50T* */
/* Revision: 1.107.1.14 BY: Steve Nugent           DATE: 10/20/06 ECO: *P3Y6* */
/* Revision: 1.107.1.15 BY: Dilip Manawat          DATE: 10/31/06 ECO: *P56T* */
/* Revision: 1.107.1.16 BY: Abhijit Gupta          DATE: 11/21/06 ECO: *P5G5* */
/* Revision: 1.107.1.17 BY: Preeti Sattur          DATE: 12/22/06 ECO: *P5KD* */
/* Revision: 1.107.1.19 BY: Sarita Gonsalves       DATE: 03/02/07 ECO: *P5NV* */
/* Revision: 1.107.1.20 BY: Deepak Taneja          DATE: 03/12/07 ECO: *P5QZ* */
/* Revision: 1.107.1.21 BY: Deepak Taneja          DATE: 03/20/07 ECO: *P5RH* */
/* Revision: 1.107.1.22 BY: Prashant Menezes       DATE: 03/26/07 ECO: *P5RL* */
/* Revision: 1.107.1.24 BY: Abhijit Gupta          DATE: 04/11/07 ECO: *P5T0* */
/* Revision: 1.107.1.25 BY: Sarita Gonsalves       DATE: 04/19/07 ECO: *P5T9* */
/* Revision: 1.107.1.26 BY: Abhijit Gupta          DATE: 04/24/07 ECO: *P5V5* */
/* Revision: 1.107.1.28 BY: Sundeep Kalla          DATE: 06/05/07 ECO: *P5YC* */
/* Revision: 1.107.1.31 BY: Anju Dubey             DATE: 06/11/07 ECO: *P5YR* */
/* Revision: 1.107.1.32 BY: Deepak Taneja          DATE: 06/29/07 ECO: *P60Y* */
/* Revision: 1.107.1.35 BY: Amandeep Saini         DATE: 07/13/07 ECO: *Q17W* */
/* Revision: 1.107.1.36 BY: Sundeep Kalla          DATE: 07/16/07 ECO: *P61T* */
/* Revision: 1.107.1.37 BY: Nancy Philip           DATE: 08/01/07 ECO: *P5Z4* */
/* $Revision: 1.107.1.38 $ BY: Sarita Gonsalves    DATE: 08/08/07 ECO: *P61N* */
/*-Revision end---------------------------------------------------------------*/
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/*V8:ConvertMode=Maintenance                                                  */

{mfdeclre.i}
{cxcustom.i "APVOMTA5.P"}
{gplabel.i}
{apconsdf.i}

/* GET AUTHORIZED ENTITIES FOR THE USER */
{glsec.i}

/* DEFINE GPRUNP VARIABLES OUTSIDE OF INTERNAL PROCEDURES */
{gprunpdf.i "mcpl" "p"}

define input-output  parameter l_ctr like mfc_integer no-undo.
define input         parameter pvoID as integer no-undo.

/* LOCAL VARIABLE DEFINITIONS */
define variable ext_open      like vod_amt     format "->>,>>>,>>9.99"
                                               label "Ext Open".
define variable stdcst        like prh_pur_std label "GL Cost".
define variable ext_rate_var  like vod_amt     format "->>,>>>,>>9.99"
                                               label "Ext Rate Var".
define variable varstd        like vod_amt     format "->>,>>>,>>9.99"
                                               label "Ext PPV".
define variable ext_usage_var like vod_amt     format "->>,>>>,>>9.99"
                                               label "Ext Usage Var".
define variable invqty         like vph_inv_qty.
define variable inv_amt        like vph_curr_amt.
define variable old_qty        like vph_inv_qty.
define variable old_cost       like vph_inv_cost.
define variable was_open       like mfc_logical.
define variable now_open       like mfc_logical.
define variable first_vo       like mfc_logical.
define variable set_zero       as   integer initial 1.
define variable set_memo       as   integer initial 1.
define variable glvalid        like mfc_logical.
define variable vp-part        like vp_part.
define variable undo_loopg     like mfc_logical.
define variable rndamt         like glt_amt.

define shared variable l_flag        like mfc_logical no-undo.
define shared variable auto-select   like mfc_logical.
define shared variable process_gl    like mfc_logical.
define shared variable taxchanged    as   logical no-undo.
define shared variable rndmthd       like rnd_rnd_mthd.
define shared variable close_pvo     like mfc_logical label "Close Line".

/* DEFINE VARIABLES USED IN GPGLEF.P (GL CALENDAR VALIDATION) */
{gpglefdf.i}

define shared variable gpglef2 like mfc_logical no-undo.

define variable ext_open_fmt  as   character.
define variable ext_open_old  as   character.
define variable invcst_fmt    as   character.
define variable invcst_old    as   character.
define variable ext_rate_fmt  as   character.
define variable ext_rate_old  as   character.
define variable varstd_fmt    as   character.
define variable varstd_old    as   character.
define variable ext_usage_fmt as   character.
define variable ext_usage_old as   character.
define variable newcst        like prh_pur_std no-undo.
define variable pending_vo_accrual_acct like pvo_accrual_acct no-undo.
define variable pending_vo_accrual_sub like pvo_accrual_sub no-undo.
define variable pending_vo_accrual_cc like pvo_accrual_cc no-undo.
define variable pending_vo_project like pvo_project no-undo.
define variable pending_vo_ex_rate like pvo_ex_rate no-undo.
define variable pending_vo_ex_rate2 like pvo_ex_rate2 no-undo.
define variable last_voucher like pvo_last_voucher no-undo.
define variable prev_vouchered_qty like pvo_vouchered_qty no-undo.
define variable SPACES as character no-undo.
define variable RECEIVER_TYPE as character initial "07" no-undo.
define variable lv_error_num as integer no-undo.
define variable lv_name      as character no-undo.

/* Variable l_tax_usage USED TO STORE TAX USAGE from SUBSTR(vph__qadc01,1,8) */
define variable l_tax_usage   like pvo_tax_usage no-undo.
/* Variable l_taxc IS USED TO STORE TAX CLASS from SUBSTR(vph__qadc01,9,3) */
define variable l_taxc        like pvo_taxc      no-undo.
define variable savedAddr     as character no-undo.
define variable l_entity_ok   like mfc_logical no-undo.
define variable l_count       as integer no-undo.

define buffer   pvomstr       for pvo_mstr.
define buffer   vphhist1      for vph_hist.
/* VARIABLE DEFINITIONS AND COMMON PROCEDURE TO GET NEW pvod_det FIELDS FROM  */
/* THE qtbl_ext TABLE USING gpextget.i.                                       */
{pocnpvod.i}

define variable detail_ctr as integer no-undo.
define variable first_po_cost as decimal no-undo.
define variable edit_details as logical no-undo.
define variable multi_det as logical no-undo.
define variable ext_multi_det as logical no-undo.
define variable l_pvod_pur_cost like prh_pur_cost no-undo.
define variable l_pvod_pur_cost1 like l_pvod_pur_cost.
define variable pvod-trx-cost like pvod_pur_cost no-undo.
define variable usage_var as logical no-undo.
define variable l_vph_acct    like vph_acct.
define variable l_vph_sub     like vph_sub.
define variable l_vph_cc      like vph_cc.
define variable l_vph_project like vph_project.

{&APVOMTA5-P-TAG3}

/* DEFINE SHARED CURRENCY DEPENDENT FORMATTING VARIABLES */
{apcurvar.i}

{apvomta.i}

/* DEFINE TEMP-TABLE FOR pvo_mstr/vph_hist JOIN */
define temp-table tt_pvo_mstr          no-undo
   field tt_pvo_id                     like pvo_id
   field tt_pvo_receiver               like pvo_internal_ref
   field tt_pvo_order                  like pvo_order
   field tt_pvo_line                   like pvo_line
   field tt_pvo_vouchered_qty          like pvo_vouchered_qty
   field tt_vph_ref                    like vph_ref
   index primary is unique
         tt_pvo_id
   index sort_order
         tt_pvo_receiver
         tt_pvo_line.

define shared frame d.
define shared frame f.
define shared frame m.
define shared frame match_detail.

{apvofmfm.i}

{etvar.i } /* COMMON EURO VARIABLES */

define variable l_purcst           like purcst       no-undo.
define variable l_purcst2          like purcst       no-undo.
define variable l_pur_cost         like prh_pur_cost no-undo.
define variable l_msg_txt          as   character    no-undo.
define variable l_rcpt_rate        like vo_ex_rate   no-undo.
define variable l_rcpt_rate2       like vo_ex_rate2  no-undo.
define variable rcp_to_vo_ex_rate  like vo_ex_rate   no-undo.
define variable rcp_to_vo_ex_rate2 like vo_ex_rate2  no-undo.
define variable l_lastkey          as   integer      no-undo.
for first ap_mstr
   fields (ap_domain ap_amt ap_curr ap_ref
           ap_base_amt ap_effdate)
   where recid(ap_mstr) = ap_recno
no-lock: end.

for first vo_mstr
   fields (vo_domain vo_confirmed vo_curr
           vo_ex_rate vo_ex_rate2
           vo_ex_ratetype vo_ref)
   where recid(vo_mstr) = vo_recno
no-lock: end.

for first gl_ctrl
   fields (gl_domain gl_verify)
    where gl_domain = global_domain
no-lock: end.

for first apc_ctrl
   fields (apc_domain apc_confirm)
    where apc_domain = global_domain
no-lock: end.

/* SAVE ASIDE STANDARD FIELD FORMATS */
assign
   ext_open_old  = ext_open:format
   invcst_old    = invcst:format
   ext_rate_old  = ext_rate_var:format
   varstd_old    = varstd:format
   ext_usage_old = ext_usage_var:format.

/* SET FORMAT VARIABLES FOR CURRENCY DEPENDENT DISPLAY */
ext_open_fmt = ext_open_old.
{gprun.i ""gpcurfmt.p"" "(input-output ext_open_fmt,
                          input rndmthd)"}
invcst_fmt = invcst_old.
{gprun.i ""gpcurfmt.p"" "(input-output invcst_fmt, input rndmthd)"}

ext_rate_fmt = ext_rate_old.
{gprun.i ""gpcurfmt.p"" "(input-output ext_rate_fmt,
                          input rndmthd)"}
varstd_fmt = varstd_old.
{gprun.i ""gpcurfmt.p"" "(input-output varstd_fmt, input rndmthd)"}

ext_usage_fmt = ext_usage_old.
{gprun.i ""gpcurfmt.p"" "(input-output ext_usage_fmt,
                          input rndmthd)"}

/* UPDATE INDIVIDUAL RECEIVER RECORDS */
loopg:
repeat:

   /* IF l_flag IS true RETURN TO THE CALLING */
   /* PROGRAM WITHOUT PROCEEDING FURTHER      */
   if l_flag = true then
      return.

   assign
      receiver_recid = ?
      global_recid   = ?.

   /* pvoID HAS EITHER BEEN PASSED FROM apvomta.p WHEN AN EXISTING    */
   /* VOUCHERED pvo_mstr HAS BEEN SELECTED FROM THE RECEIVER MATCHING */
   /* DETAIL FRAME, FROM USING NEXT/PREVIOUS, OR AFTER CREATING A NEW */
   /* VPH_HIST RECORD. IN ALL OTHER INSTANCES pvoID WILL BE 0.        */
   if pvoID <> 0 then
      for first pvo_mstr
         where pvo_domain = global_domain
         and   pvo_id = pvoID
      no-lock:
         receiver_recid = recid(pvo_mstr).
      end.

   if set_memo = 0 then
      hide frame m no-pause.

   assign
      ext_open:format      in frame f = ext_open_fmt
      invcst:format        in frame f = invcst_fmt
      varstd:format        in frame f = varstd_fmt
      ext_rate_var:format  in frame f = ext_rate_fmt
      ext_usage_var:format in frame f = ext_usage_fmt.

   assign
      savedAddr = global_addr
      global_addr = vo_ref.

   /* POPULATE PENDING VOUCHER TEMP-TABLE FOR NEXT/PREVIOUS */
   empty temp-table tt_pvo_mstr no-error.

   for each vph_hist no-lock
      where vph_domain = global_domain
      and   vph_ref = vo_ref
   use-index vph_ref,
   each pvo_mstr no-lock
      where pvo_domain = global_domain
      and   pvo_id = vph_pvo_id:

      if can-find(first tt_pvo_mstr where
                        tt_pvo_id = pvo_mstr.pvo_id)
      then next.

      create tt_pvo_mstr.
      assign
         tt_pvo_id            = pvo_mstr.pvo_id
         tt_pvo_receiver      = pvo_mstr.pvo_internal_ref
         tt_pvo_order         = pvo_mstr.pvo_order
         tt_pvo_line          = pvo_mstr.pvo_line
         tt_pvo_vouchered_qty = pvo_mstr.pvo_vouchered_qty
         tt_vph_ref           = vph_hist.vph_ref.

   end.
   l_lastkey = ?.

   /*TO DISPLAY THE RECORD THAT WAS LAST EDITED*/
   for first pvo_mstr
      where recid(pvo_mstr) = receiver_recid
   no-lock:
   end. /* FOR FIRST pvo_mstr */

   if available pvo_mstr
   then do:
      for first tt_pvo_mstr
         fields (tt_pvo_id
                 tt_pvo_receiver
                 tt_pvo_line    )
         where tt_pvo_id       = pvo_mstr.pvo_id
         and   tt_pvo_receiver = pvo_mstr.pvo_internal_ref
         and   tt_pvo_line     = pvo_mstr.pvo_line
      no-lock :
      end. /*FOR FIRST tt_pvo_mstr*/

      if available tt_pvo_mstr
      then do:
         recno = recid(tt_pvo_mstr).
         run display-detail.
      end. /* IF AVAILABLE tt_pvo_mstr */
   end. /* IF AVAILABLE pvo_mstr */

   update
      receiver
      rcvr_line
   go-on (F4 PF4 CTRL-E ESC)
   with frame f editing:

      if frame-field = "receiver"
      then do:

         /* NEXT-PREV ON ATTACHED RECEIVERS ONLY */
         {mfnp06.i
            tt_pvo_mstr
            sort_order
            true
            tt_pvo_receiver
            "input frame f receiver"
            tt_pvo_receiver
            "input frame f receiver"}
         run display-detail.
      end. /* IF FRAME-FIELD = "receiver" */
      else if frame-field = "rcvr_line"
      then do:
         /* NEXT-PREV ON ATTACHED RECEIVER LINES ONLY */
         {mfnp05.i
            tt_pvo_mstr
            sort_order
            "tt_pvo_receiver = input frame f receiver"
            tt_pvo_line
            "input frame f rcvr_line"}
         if recno <> ? then run display-detail.
      end. /* IF FRAME-FIELD = "rcvr_line" */
      else do:
         ststatus = stline[3].
         status input ststatus.
         readkey.
         apply lastkey.
      end. /* ELSE DO */

   end.  /* UPDATE RECEIVER ... EDITING */
   l_lastkey = lastkey.

   /*TO DISPLAY THE RECORD WHEN LINE NUMBER IS ENTERED MANUALLY*/
   for first pvo_mstr
      where recid(pvo_mstr) = receiver_recid
   no-lock:
   end. /* FOR FIRST pvo_mstr */

   if available pvo_mstr
   then do:
      for first tt_pvo_mstr
         fields (tt_pvo_id
                 tt_pvo_receiver
                 tt_pvo_line )
         where tt_pvo_id       = pvo_mstr.pvo_id
         and   tt_pvo_receiver = pvo_mstr.pvo_internal_ref
         and   tt_pvo_line     = pvo_mstr.pvo_line
      no-lock :
      end. /*FOR FIRST tt_pvo_mstr*/

      if available tt_pvo_mstr
      then do:
         recno = recid(tt_pvo_mstr).
         run display-detail.
      end. /*IF AVAILABLE tt_pvo_mstr*/
   end. /* IF AVAILABLE pvo_mstr */

   global_addr = savedAddr.
   /* OBTAIN THE PO RECEIVER ENTITY */
   for first prh_hist
      fields (prh_domain prh_receiver prh_line prh_po_site prh_site)
      where   prh_domain   = global_domain
      and     prh_receiver = receiver
      and     prh_line     = rcvr_line
   no-lock:
      /* VERIFY OPEN GL CALENDAR PERIOD FOR SPECIFIED */
      /* MODULE, ENTITY AND EFFECTIVE DATE            */
      if vo_confirmed then do:

         if prh_po_site <> "" then
            for first si_mstr
               fields (si_domain si_site si_entity)
               where si_domain = global_domain
               and   si_site   = prh_po_site
               no-lock: end.
         else
            for first si_mstr
               fields (si_domain si_site si_entity)
               where si_domain = global_domain
               and   si_site   = prh_site
            no-lock: end.

         if available si_mstr then do:
            {gpglef01.i ""AP"" si_entity ap_effdate}

            if gpglef > 0 then do:
               gpglef2 = no.
       if not batchrun then do:
               {pxmsg.i &MSGNUM=gpglef &ERRORLEVEL=4 &MSGARG1=si_entity}
                  pause.
       end.
               undo loopg, leave loopg.
            end.

         end. /* IF AVAILABLE si_mstr */
      end. /* IF vo_confirmed  */
      /* CHECK IF USER IS AUTHORIZED FOR THE RECEIVER ENTITY */
      for first si_mstr
         fields (si_domain si_site si_entity)
         where si_domain = global_domain
         and   si_site   = prh_site
      no-lock:

         {glenchk.i &entity=si_entity &entity_ok=l_entity_ok}

         if not l_entity_ok then do:

            if batchrun then
               l_flag = true.
            else
               next-prompt receiver with frame f.

            undo loopg, retry loopg.

         end. /* IF NOT l_entity_ok */
      end. /* FOR EACH si_mstr */
   end. /* FOR FIRST prh_hist */

   if    keyfunction(l_lastkey) = "end-error"
      or keyfunction(l_lastkey) = "."
   then do:
      leave loopg.
   end.

   /* EDIT SELECTED ATTACHED RECEIVER */
   if receiver = "" then do:
      /* BLANK NOT ALLOWED */
      if not batchrun then do:
      	 {pxmsg.i &MSGNUM=40 &ERRORLEVEL=3}
			end.
      /* IF AN ERROR IS ENCOUNTERED IN BATCH MODE l_flag IS SET TO true */
      if batchrun then
         l_flag = true.

      undo, retry.
   end. /* IF receiver = "" */
   if pvoID = 0
      and receiver_recid = ?
   then do:

      /* IF MORE THAN ONE PVO_MSTR FOR THE SAME RECEIVER, THE USER MUST */
      /* USE LOOKUP ON THE RECEIVER FIELD TO SELECT THE PENDING VOUCHER */
      l_count = 0.

      cnt_loop:
      for each pvo_mstr
         where pvo_domain       = global_domain
         and   pvo_lc_charge    = ""
         and   pvo_internal_ref = receiver
         and   pvo_line         = rcvr_line
         and   pvo_last_voucher = ""
      no-lock:
         l_count = l_count + 1.

         if l_count > 1 then
            leave cnt_loop.
      end. /* FOR EACH PVO_MSTR */

      if l_count > 1 then do:
         /* MULTIPLE PENDING VOUCHERS EXIST FOR THIS REF#, PLEASE USE LOOKUP */
         if not batchrun then do:
         		{pxmsg.i &MSGNUM=5024 &ERRORLEVEL=4}
				 end.
         /* IF AN ERROR IS ENCOUNTERED IN BATCH MODE l_flag IS SET TO true */
         if batchrun then
            l_flag = true.

         undo loopg, retry loopg.
      end.
   end.   /* IF pvoID = 0 */

   if receiver_recid = ?
      or (receiver <> pvo_internal_ref
      or  rcvr_line <> pvo_line)
   then
      for first pvo_mstr
         where pvo_domain            = global_domain
         and   pvo_lc_charge         = SPACES
         and   pvo_internal_ref_type = {&TYPE_POReceiver}
         and   pvo_internal_ref      = receiver
         and   pvo_line              = rcvr_line
         and   pvo_last_voucher      = ""
      no-lock:
         receiver_recid = recid(pvo_mstr).
      end.
   else
      for first pvo_mstr
         where recid(pvo_mstr) = receiver_recid
      no-lock:
         pvoID = pvo_id.
      end.

   for first vph_hist
      where vph_domain       = global_domain
      and   vph_pvo_id       = pvo_id
      and   vph_pvod_id_line = 0
      and   vph_ref          = vo_ref
   exclusive-lock: end.

   if available vph_hist then do:
      find prh_hist
         where prh_domain   = global_domain
         and   prh_nbr      = vph_nbr
         and   prh_receiver = pvo_internal_ref
         and   prh_line     = pvo_line
      no-lock no-error.

      for each vph_hist
         where vph_domain       = global_domain
         and   vph_pvo_id       = pvo_id
         and   vph_pvod_id_line > 0
         and   vph_ref          = vo_ref
      exclusive-lock:
         /* TEMP BACK OUT THIS VOUCHER'S INV */
         /* QTY FROM TOTAL FOR RECEIVER      */
         run backOutVoucherQuantity
            (input pvo_id,
             input vph_pvod_id_line,
             input vph_inv_qty).
      end. /* FOR EACH vph_hist */

      for first vph_hist
         where vph_domain       = global_domain
         and   vph_pvo_id       = pvo_id
         and   vph_pvod_id_line = 0
         and   vph_ref          = vo_ref
      exclusive-lock:
      end. /* FOR FIRST vph_hist */
   end. /* IF AVAILABLE vph_hist */
   else
      /* IF VPH_HIST NOT AVAILABLE THEN FIND OPEN PRH_HIST   */
      /* USING vpo_det CREATED BY AUTO SELECT PATH.        */
      for first prh_hist
         where prh_domain   = global_domain
         and   prh_receiver = receiver
         and   prh_line     = rcvr_line
         and can-find (vpo_det
                where vpo_domain = global_domain
                and   vpo_ref    = vo_ref
                and   vpo_po     = pvo_order)
         and can-find (first pvo_mstr
                where recid(pvo_mstr)  = receiver_recid
                and   pvo_last_voucher = SPACES)
         no-lock :
      end. /* FOR FIRST prh_hist */

   if available prh_hist then do:

      for first pvo_mstr
         where recid(pvo_mstr) = receiver_recid
      no-lock:

         for each pvod_det
            where pvod_domain = global_domain
            and   pvod_id     = pvo_id
         no-lock:

            run getExtensionRecords
               (input pvod_id,
                input pvod_id_line).

            if pvod_trans_qty = pvod_vouchered_qty
            then
               next.
            else
            do:
               Assign
                  l_pvod_pur_cost  = pvod_pur_cost
                  l_pvod_pur_cost1 = pvod_pur_cost.
               leave.
            end. /* ELSE DO */
         end. /* FOR EACH pvod_det */
      end. /* For FIRST pvo_mstr */

      if not available vph_hist then do:

         assign
            l_tax_usage = pvo_tax_usage
            l_taxc      = pvo_taxc.

         create vph_hist.
         assign
            vph_domain       = global_domain
            vph_pvo_id       = pvo_id
            vph_pvod_id_line = 0
            vph_nbr          = pvo_order
            vph_inv_date     = ap_effdate
            vph_acct         = pvo_accrual_acct
            vph_sub          = pvo_accrual_sub
            vph_cc           = pvo_accrual_cc
            vph_ref          = vo_ref
            vph_project      = pvo_project.

         if recid(vph_hist) = -1 then .

         {&APVOMTA5-P-TAG2}

      end. /* IF NOT AVAILABLE vph_hist */
      else do:
         assign
            {&APVOMTA5-P-TAG4}
            l_tax_usage = right-trim(substring(vph__qadc01,1,8))
            l_taxc      = right-trim(substring(vph__qadc01,9,3)).
      end. /* ELSE DO */

      if vph_inv_qty = 0
         and vph_inv_cost = 0
         and not close_pvo
      then
         set_zero = 0.
      else
         set_zero = 1.

      if prh_type <> ""
         and prh_type <> "S"
      then
         set_memo = 0.
      else
         set_memo = 1.

      if not can-find (first pt_mstr
         where pt_domain = global_domain
         and  pt_part = pvo_part)
      then
         set_memo = 0.

      /* READ PENDING VOUCHER RECORD FOR TOTAL QTY */
      run determineOpenVoucherQuantity
         (input recid(pvo_mstr),
          output rcvd_open,
          output prev_vouchered_qty,
          output last_voucher).

      assign
         old_qty   = vph_inv_qty
         old_cost  = vph_curr_amt
         was_open  = (last_voucher = "")
         invcst    = vph_inv_qty * vph_curr_amt.

      run mc_round_trans_amount
         (input-output invcst).

      if vo_mstr.vo_curr <> base_curr
      then
         run base_cur_prh_cur_vo_cur_check
            (input pvod_pur_std,
             input pvod_ovh_std,
             input pvod_ex_rate,
             input pvod_ex_rate2,
             input-output l_pvod_pur_cost).

      run calc_purcst_stdcst_newcst_ext_open
          (input pvod_pur_std,
           input pvod_ovh_std,
           input l_pvod_pur_cost,
           input pvod_ex_rate,
           input pvod_ex_rate2).

     assign
         ext_open        = ext_open * prh_um_conv
         l_pvod_pur_cost = l_pvod_pur_cost * prh_um_conv
         ext_rate_var    = vph_curr_amt * vph_inv_qty
         rndamt          = l_pvod_pur_cost * vph_inv_qty.

      run mc_round_trans_amount
         (input-output ext_rate_var).

      run mc_round_rndamt.

      ext_rate_var = ext_rate_var - rndamt.

      if last_voucher <> "" then do:
         assign
            ext_usage_var = vph_inv_qty * l_pvod_pur_cost
            rndamt        = rcvd_open * l_pvod_pur_cost.

         run mc_round_trans_amount
            (input-output ext_usage_var).

         run mc_round_rndamt.

         ext_usage_var = ext_usage_var - rndamt.
      end. /* IF last_voucher <> ""  */
      else
         ext_usage_var = 0.

      rndamt = rcvd_open * newcst.

      run mc_round_rndamt.

      varstd = (ext_open - rndamt) * set_zero * set_memo.
      /* NOTE DON'T RE-ROUND; SET_ZERO & SET_MEMO ARE  */
      /* EITHER ZERO OR ONE AND WILL NOT AFFECT ROUND  */

      if set_memo = 1 then do:

         run determine_stdcst_display
             (input vph_pvo_id,
              input-output stdcst,
              output multi_det).

         run determine_ext_cost_display
             (input vph_pvo_id,
              output ext_multi_det).
         display
            receiver
            rcvr_line
            pvo_taxable
            pvo_trans_date
            vph_project    @ pvo_project
            pvo_part
            prh_um
            prh_type
            rcvd_open
            l_pvod_pur_cost @ prh_pur_cost
            ext_open
            vph_inv_qty
            vph_curr_amt
            prh_ps_qty
            pvo_trans_qty
            varstd
            ext_usage_var
         with frame f.

         /* L_PURCST2 IS USED                */
         /* TO DETERMINE IF A WARNING SHOULD */
         /* BE GIVEN BECAUSE THE EXTENDED    */
         /* INVOICE AMOUNT EXCEEDS THE       */
         /* EXTENDED PO AMOUNT               */

         l_purcst2 = ext_open.

         if stdcst <> 0 or
           (stdcst = 0 and not multi_det)
         then display
            stdcst
         with frame f.

         if not ext_multi_det
         then display
            invcst
            ext_rate_var
         with frame f.

         if pvo_consignment then
            display
               0 @ prh_ps_qty
            with frame f.

         if vo_curr <> pvo_curr then do:
            l_msg_txt = string(l_purcst) + " " + string(pvo_curr).
            if not batchrun then do:
	            {pxmsg.i &MSGNUM=2684 &ERRORLEVEL=1 &MSGARG1=l_pur_cost
	                     &MSGARG2=pvo_curr &MSGARG3=l_msg_txt}
	            pause.
            end.
         end.

         for first pod_det
            fields (pod_domain  pod_line  pod_nbr
                    pod_taxable pod_vpart pod_part)
             where pod_domain = global_domain
             and   pod_nbr    = pvo_order
             and   pod_line   = pvo_line
         no-lock:
            display
               pod_vpart
            with frame f.

            /* GET ITEM DESCRIPTION FOR DISPLAY IN RECEIVER */
            /* MATCHING MAINTENANCE                         */
            run get_pt_description
               (input pod_domain,
                input pod_part).
         end.

      end. /* IF SET_MEMO = 1 */

      if set_memo = 0 then do:

         for first pod_det
            fields (pod_domain pod_line    pod_nbr pod_taxable
                    pod_vpart  pod_project pod_part)
             where pod_domain = global_domain
               and pod_nbr            = pvo_order
               and pod_line           = pvo_line
            no-lock:
         end. /* FOR FIRST pod_det */

         hide frame f no-pause.

         assign
            ext_open:format      in frame m = ext_open_fmt
            invcst:format        in frame m = invcst_fmt
            ext_rate_var:format  in frame m = ext_rate_fmt
            ext_usage_var:format in frame m = ext_usage_fmt.

         display
            receiver
            rcvr_line
            pvo_taxable
            pvo_trans_date
            pvo_part
            prh_um
            prh_type
            rcvd_open
            l_pvod_pur_cost @ prh_pur_cost
            ext_open
            vph_inv_qty
            vph_curr_amt
            invcst
            prh_ps_qty
            ext_rate_var
            vph_acct
            vph_sub
            vph_cc
            vph_project
            pvo_trans_qty
            ext_usage_var
         with frame m.

         l_purcst2 = ext_open.

         if pvo_consignment and not batchrun then
            display
               0 @ prh_ps_qty
            with frame f.

         if vo_curr <> pvo_curr then do:
            l_msg_txt = string(l_purcst) + " " + string(pvo_curr).
            if not batchrun then do:
               {pxmsg.i &MSGNUM=2684 &ERRORLEVEL=1 &MSGARG1=l_pur_cost
                        &MSGARG2=pvo_curr &MSGARG3=l_msg_txt}
               pause.
            end.
         end.

         if available pod_det then
            display
               pod_vpart
            with frame m.
      end.  /* IF SET_MEMO = 0 */

   end. /* IF AVAILABLE PRH_HIST */
   else do:
    if not batchrun then do:
      for first prh_hist
         fields(prh_domain prh_receiver prh_line prh_nbr)
         where prh_domain   = global_domain
         and   prh_receiver = receiver
         and   prh_line     = rcvr_line
         and   can-find(first pod_det
         where pod_domain = global_domain
         and   pod_nbr    = prh_nbr
         and   pod_line   = prh_line
         and   pod_consignment)
      no-lock:
      end. /* FOR FIRST prh_hist */
      if available prh_hist
      then
         /* WARNING CONSIGNED QTY. NOT CONSUMED, RECEIVER CAN'T BE VOUCHERED */
         {pxmsg.i &MSGNUM=7643 &ERRORLEVEL=2}
      else
         /* ERROR IF INVALID RECEIVER */
         {pxmsg.i &MSGNUM=2205 &ERRORLEVEL=2}
    end. /* if not batchrun then do: */
      if batchrun then
         l_flag = true.

      undo, retry.
   end. /* ELSE DO */

   for first pvo_mstr
      where pvo_domain = global_domain
      and   pvo_id     = vph_pvo_id
       exclusive-lock,
       first pvod_det no-lock where
             pvod_domain = global_domain
         and pvod_id = pvo_id:

      run getExtensionRecords
         (input pvod_id,
          input pvod_id_line).

      assign
         pending_vo_ex_rate = pvod_ex_rate
         pending_vo_ex_rate2 = pvod_ex_rate2
         pending_vo_accrual_acct = pvo_accrual_acct
         pending_vo_accrual_sub  = pvo_accrual_sub
         pending_vo_accrual_cc   = pvo_accrual_ac
         pending_vo_project      = pvo_project.
   end.
   /* CHECK THAT INVENTORY DOMAIN IS CONNECTED */
   for first si_mstr
      fields (si_domain si_db si_site)
      where si_domain = global_domain
      and   si_site   = prh_site
   no-lock:
      if global_db <> si_db then do:
         {gprunp.i "mgdompl" "p" "ppDomainConnect"
                   "(input si_db,
                     output lv_error_num,
                     output lv_name)"}

         if lv_error_num <> 0 then do:
            /* DOMAIN si_db NOT AVAILABLE */
            if not batchrun then do:
               {pxmsg.i &MSGNUM=lv_error_num &ERRORLEVEL=3 &MSGARG1=lv_name}
               pause.
            end.
            if batchrun then
               l_flag = true.

            undo loopg, retry.
         end.
      end.
   end. /* FOR FIRST si_mstr */
   /* TEMP BACK OUT EXTENDED INVOICE AMOUNT FROM VO TOTAL */
   if not batchrun then do:
      {&APVOMTA5-P-TAG5}
   end.
   rndamt = vph_inv_qty * vph_curr_amt.

   run mc_round_rndamt.

   ap_amt = ap_amt - rndamt.
   /* CONVERT FROM VOUCHER TO BASE CURRENCY */
   run mc_convert_voucher_to_base
      (input rndamt,
       input true,
       output rndamt).

   ap_base_amt = ap_base_amt - rndamt.
   {&APVOMTA5-P-TAG6}
   /* PROMPT FOR INVOICE QUANTITY AND UNIT PRICE */
if not batchrun then do:
   if set_memo = 1 then
      display
         vph_inv_qty
         vph_curr_amt
      with frame f.

   if set_memo = 0 then
      display
         vph_inv_qty
         vph_curr_amt
      with frame m.
end.
   setf:
   do on error undo, retry:

      if set_memo = 1 then do:

         /* TAX MANAGEMENT TRANSACTION POP-UP. */
         /* PARAMETERS ARE 5 FIELDS            */
         /* AND UPDATEABLE FLAGS,              */
         /* STARTING ROW, AND UNDO FLAG.       */
         if not batchrun  then do:
            {&APVOMTA5-P-TAG7}
         end.
/*
         /* Identify context for QXtend */
         {gpcontxt.i
            &STACKFRAG = 'xxtxtrnpop,xxapvomta5,xxapvomta,xxapvomt'
            &FRAME = 'set_tax' &CONTEXT = 'RECVR'}
*/
         {gprun.i ""xxtxtrnpop.p""
                  "(input-output l_tax_usage,
                    input true,
                    input-output pvo_tax_env,
                    input false,
                    input-output l_taxc,
                    input true,
                    input-output pvo_taxable,
                    input true,
                    input-output pvo_tax_in,
                    input false,
                    input 6,
                    output undo_loopg)"}
/*
         /* Clear context for QXtend */
         {gpcontxt.i
            &STACKFRAG = 'xxtxtrnpop,xxapvomta5,xxapvomta,xxapvomt'
            &FRAME = 'set_tax'}
*/
         display
            pvo_taxable
         with frame f.

         {&APVOMTA5-P-TAG1}

         if l_tax_usage <> right-trim(substring(vph__qadc01,1,8,"RAW"))
            or l_taxc      <> right-trim(substring(vph__qadc01,9,3,"RAW"))
         then
            process_gl = yes.

         assign
            vph__qadc01 = l_tax_usage
                        +  fill(" ",8  - length(l_tax_usage))
                        +  l_taxc
                        +  fill(" ",3  - length(l_taxc)).

         /* GET ITEM DESCRIPTION FOR DISPLAY IN RECEIVER */
         /* MATCHING MAINTENANCE                         */
         run get_pt_description
            (input pod_domain,
             input pod_part).

         /* l_flag IS SET TO true IN BATCH MODE. */
         if undo_loopg then
            if not batchrun then
               undo loopg, retry.
            else do:
               l_flag = true.
               return.
            end.

         if batchrun then
            l_flag = true.

         /* CHECK FOR MULTIPLE PENDING VOUCHER DETAILS WITH DIFFERENT */
         /* PO COSTS. IF MORE THAN ONE EXISTS PROMPT THE USER TO      */
         /* MANUALLY EDIT/VOUCHER THOSE RECORDS.                      */

         detail_ctr = 0.

         for each pvod_det no-lock where
                  pvod_domain = global_domain
              and pvod_id = pvo_id:

             detail_ctr = detail_ctr + 1.

             /* THIS CALL CAN BE REMOVED ONCE pvod_det FIELDS ARE */
             /* ADDED TO THE SCHEMA.                              */
             run getExtensionRecords
                (input pvod_id,
                 input pvod_id_line).

             run convert_pvod_pur_cost
                (input pvod_pur_cost,
                 input pvod_ex_rate,
                 input pvod_ex_rate2,
                 output pvod-trx-cost).

             if detail_ctr = 1 then
                first_po_cost = pvod-trx-cost.
             else do:
                if first_po_cost = pvod-trx-cost
                then do:
                   detail_ctr = detail_ctr - 1.
                   next.
                end.
             end.

             if detail_ctr > 1 then leave.
         end.

         edit_details = no.

         if detail_ctr > 1 then do:
            /* MULTIPLE PENDING VOUCHER DETAIL RECORDS EXIST. EDIT DETAILS? */
            if not batchrun then do:
            	{pxmsg.i &MSGNUM=6697 &ERRORLEVEL=1 &CONFIRM=edit_details}
          	END.
         end.

         if edit_details then do:

            hide frame match_detail.

            /* PROGRAM apvocna5.p ALLOWS USERS TO MANUALLY UPDATE */
            /* INVOICE QUANTITY AND COST INFORMATION RELATED TO   */
            /* PENDING VOUCHER DETAIL RECORDS.                    */
            {gprunmo.i &program="apvocna5.p" &module="ACN"
                       &param="""(input vph_pvo_id,
                                  input rndmthd,
                                  input vo_recno,
                                  input ap_recno,
                                  input new_vchr,
                                  input-output vph_recid,
                                  input-output process_gl,
                                  input-output vodamt[2],
                                  input-output taxchanged,
                                  input-output l_ctr)"""}

            /* REFRESH MATCHING DETAIL FRAME */
            clear frame match_detail all no-pause.

            repeat with frame match_detail
            while available vph_hist:

               find first pvo_mstr where
                  pvo_domain = global_domain and
                  pvo_id = vph_pvo_id
                  no-lock no-error.

               for first vp_mstr
                  where vp_domain = global_domain
                  and   vp_part = pvo_part
                  and   vp_vend = pvo_supplier
               no-lock:
                  vp-part = vp_part.
               end.

               display
                  pvo_internal_ref @ tt_pvo_receiver
                  pvo_line         @ tt_pvo_line
                  vph_nbr
                  pvo_part
                  vp-part
                  vph_inv_qty.

               if frame-line = frame-down then
               leave.

               down.

               find next vph_hist
                  where vph_domain       = global_domain
                  and   vph_ref          = vo_ref
                  and   vph_pvod_id_line = 0
                  and   vph_pvo_id       <> pvo_id
               no-lock no-error.

            end. /* DO ... match_detail */

            clear frame f no-pause.
            view frame f.
            leave loopg.
         end.

         set
            vph_inv_qty
            vph_curr_amt
         go-on (F4 PF4 CTRL-E ESC)
         with frame f.

         /* IF NO ERROR IS ENCOUNTERED IN BATCH MODE SET l_flag TO false */
         if batchrun then
            l_flag = false.

         if keyfunction(lastkey) = "end-error"
            or keyfunction(lastkey) = "."
         then
            undo loopg, retry.

      end. /* IF SET_MEMO = 1 */

      if set_memo = 0 then do:

         /* ONLY SET ACCT/CC/PROJECT WHEN FIRST VOUCHER */
         first_vo = no.

         if pvo_vouchered_qty = 0 then
            first_vo = yes.

         /* TAX MANAGEMENT TRANSACTION POP-UP. */
         /* PARAMETERS ARE 5 FIELDS            */
         /* AND UPDATEABLE FLAGS,              */
         /* STARTING ROW, AND UNDO FLAG.       */
         {&APVOMTA5-P-TAG8}
         {gprun.i ""txtrnpop.p""
                  "(input-output l_tax_usage,
                    input true,
                    input-output pvo_tax_env,
                    input false,
                    input-output l_taxc,
                    input true,
                    input-output pvo_taxable,
                    input true,
                    input-output pvo_tax_in,
                    input false,
                    input 6,
                    output undo_loopg)"}

         display
            pvo_taxable
         with frame m.

         {&APVOMTA5-P-TAG9}

         if l_tax_usage <> right-trim(substring(vph__qadc01,1,8,"RAW"))
            or l_taxc      <> right-trim(substring(vph__qadc01,9,3,"RAW"))
         then
            process_gl = yes.

         vph__qadc01 = l_tax_usage + fill(" ",8  - length(l_tax_usage))
                     + l_taxc      + fill(" ",3  - length(l_taxc)).


         /* GET ITEM DESCRIPTION FOR DISPLAY IN RECEIVER */
         /* MATCHING MAINTENANCE                         */
         run get_pt_description
            (input pod_domain,
             input pod_part).

         if undo_loopg then
            if not batchrun then
               undo loopg, retry.
            else do:
               l_flag = true.
               return.
            end. /* ELSE DO */

         set-memo1:
         do on error undo, retry:

            if batchrun then
               l_flag = true.

            set
               vph_inv_qty
               vph_curr_amt
               vph_acct
               vph_sub
               vph_cc
               vph_project
            go-on (F4 PF4 CTRL-E ESC)
            with frame m.

            /* IF NO ERROR IS ENCOUNTERED IN BATCH MODE SET l_flag TO false */
            if batchrun then
               l_flag = false.

            if keyfunction(lastkey) = "end-error"
               or keyfunction(lastkey) = "."
            then
               undo loopg, retry.

            for first ac_mstr
               fields (ac_domain ac_code ac_curr)
               where ac_domain = global_domain and  ac_code = vph_acct
            no-lock:

               if ac_curr <> vo_curr
                  and ac_curr <> base_curr
               then do:
                  /*ACCT CURR MUST BE EITHER TRANS OR BASE CURR*/
                  if not batchrun then do:
                  	{pxmsg.i &MSGNUM=134 &ERRORLEVEL=3}
								  end.
                  if batchrun then
                     l_flag = true.

                  next-prompt vph_acct with frame m.
                  undo set-memo1, retry.

               end. /* IF ac_curr <> vo_curr ... */
            end. /* FOR FIRST ac_mstr */

            /* INITIALIZE SETTINGS */
            {gprunp.i "gpglvpl" "p" "initialize"}

            /* ACCT/SUB/CC/PROJECT VALIDATION */
            {gprunp.i "gpglvpl" "p" "validate_fullcode"
                      "(input vph_acct,
                        input vph_sub,
                        input vph_cc,
                        input vph_project,
                        output glvalid)"}

            if glvalid = no then do:

               if batchrun then
                  l_flag = true.

               next-prompt
                  vph_acct
               with frame m.

               undo set-memo1, retry.
            end. /* IF glvalid = no  */
            assign
               l_vph_acct    = vph_acct
               l_vph_sub     = vph_sub
               l_vph_cc      = vph_cc
               l_vph_project = vph_project.

         end. /* set-memo1 */

         if l_flag = true then
            return.

      end.  /* IF SET_MEMO = 0 */

      /* IF CONSIGNMENT IS IN USE THEN WARN WHEN A       */
      /* QTY GREATER THAN WHAT HAS BEEN CONSUMED FOR THE */
      /* RECEIVER TO BE SPECIFIED IN THE VOUCHER.        */

      if vph_inv_qty > rcvd_open
         and pvo_consignment
      then do:
         /* MAX QTY TO BE VOUCHERED IS # */
         if not batchrun then do:
         {pxmsg.i &MSGNUM=4929 &ERRORLEVEL=2 &MSGARG1=pvo_trans_qty}
				 end.
         if batchrun then
            l_flag = true.

         next-prompt vph_inv_qty with frame f.
         pause.
      end. /* if vph_inv_qty > rcvd_open and pvo_consignment */

      {&APVOMTA5-P-TAG10}

      /* IF VOUCHER RECEIVER TAX IS YES AND PO LINE IS */
      /* TAX NO THEN SET TAXCHANGED TO YES.  THIS FLAG */
      /* IS USED TO DETERMINE IF TAX ACCOUNT CAN BE    */
      /* UPDATED IN TAX DISTRIBUTION FRAME AND WARNING */
      /* MESSAGE DISPLAYED.                            */
      if pvo_taxable
         and taxchanged = no
      then do:
         for first pod_det
            fields (pod_domain  pod_line  pod_nbr
                    pod_taxable pod_vpart pod_part)
             where pod_domain = global_domain
             and   pod_nbr    = pvo_order
             and   pod_line   = pvo_line
            no-lock:
               if pod_taxable = no then
                  taxchanged = yes.

         end. /* FOR first pod_det */

      end. /* IF pvo_taxble ... */

      if (vph_inv_qty > 0 and rcvd_open < 0)
         or (vph_inv_qty < 0 and rcvd_open > 0)
      then do:
         /* INVALID INVOICE QUANTITY FOR QUANTITY RECEIVED */
         if not batchrun then do:
         {pxmsg.i &MSGNUM=1247 &ERRORLEVEL=3}
				 end.
         if batchrun then
            l_flag = true.

         if set_memo = 1 then
            next-prompt
               vph_inv_qty with frame f.
         else
            next-prompt
               vph_inv_qty with frame m.
         undo setf, retry.
      end. /* IF (vph_inv_qty > 0 and rcvd_open < 0) ... */

      /* RECALCULATE AND DISPLAY EXTENDED RATE */
      /* VARIANCE AND EXTENDED INVOICE COST    */
      assign
         invcst = vph_curr_amt * vph_inv_qty
         rndamt = l_pvod_pur_cost * vph_inv_qty.

      run mc_round_trans_amount
         (input-output invcst).

      run mc_round_rndamt.

      ext_rate_var = invcst - rndamt.

      if set_memo = 1 then do:
         assign
            invcst:format       in frame f = invcst_fmt
            ext_rate_var:format in frame f = ext_rate_fmt.

         display
            invcst
            ext_rate_var
         with frame f.
      end. /* IF set_memo = 1 */
      else do:
         assign
            invcst:format       in frame m = invcst_fmt
            ext_rate_var:format in frame m = ext_rate_fmt.

         display
            invcst
            ext_rate_var
         with frame m.
      end. /* ELSE DO */

      /* CALCULATE EXTENDED USAGE VARIANCE;  ONLY */
      /* DISPLAY IF THE USER CLOSES THE LINE.     */
      assign
         ext_usage_var = vph_inv_qty * l_pvod_pur_cost
         rndamt        = rcvd_open * l_pvod_pur_cost.

      run mc_round_trans_amount
         (input-output ext_usage_var).

      run mc_round_rndamt.

      ext_usage_var = ext_usage_var - rndamt.

      /* SET TOT INV AND CLOSE(FILL PRH_LAST_VO) */
      /* IF NECESSARY                            */


      run updatePendingVoucherQuantity
         (input recid(pvo_mstr),
          input vph_inv_qty).
      /* IF INVOICED QTY <> RECEIVED QTY, THEN GIVE */
      /* USER OPTION TO CLOSE RECEIVER LINE         */
      if pvo_trans_qty - (prev_vouchered_qty + vph_inv_qty) <> 0 then
      setf_sub:
      do on error undo, retry:

         if batchrun then
            l_flag = true.

         close_pvo = no.
if not batchrun then do:
         if set_memo = 1 then
            update
               close_pvo
            go-on (F4 PF4 CTRL-E ESC)
            with frame f.
         else
            update
               close_pvo
            go-on (F4 PF4 CTRL-E ESC)
            with frame m.
end.
         /* IF NO ERROR IS ENCOUNTERED SET l_flag TO false IN BATCH MODE */
         if batchrun then
            l_flag = false.

         if keyfunction(lastkey) = "end-error"
            or keyfunction(lastkey) = "."
         then
            undo loopg, retry.

         {&APVOMTA5-P-TAG11}
         if close_pvo = no then do:

            run convert_pvod_pur_cost
               (input l_pvod_pur_cost,
                input pvod_ex_rate,
                input pvod_ex_rate2,
                output pvod-trx-cost).

            /*SET RECEIVED QTY TO INV QTY SINCE NO VAR*/
            assign
               rcvd_open = vph_inv_qty

            /* PURCST IS USED TO DETERMINE IF A WARNING SHOULD BE      */
            /* GIVEN BECAUSE THE EXTENDED INVOICE AMOUNT EXCEEDS THE   */
            /* EXTENDED PO AMOUNT. RECALCULATE PURCST WITH THIS        */
            /* INV QTY(NO QTY VAR)                                     */

            purcst = rcvd_open * pvod-trx-cost * prh_um_conv.
            run mc_round_trans_amount
               (input-output purcst).

            purcst = purcst * vo_ex_rate / vo_ex_rate2
                   * pending_vo_ex_rate2 / pending_vo_ex_rate.

            /* IF VOUCHER WAS STORED IN THE vph_last_vo FIELD FROM */
            /* THE AUTO-SELECT PROCESS, THEN BLANK IT OUT.         */
            if was_open = no then
               run setLastVoucher
                  (input recid(pvo_mstr),
                   input vo_ref,
                   input "").

         end. /* IF close_pvo */
         else
            {&APVOMTA5-P-TAG12}
            run setLastVoucher
               (input recid(pvo_mstr),
                input "",
                input vo_ref).

      end. /* setf_sub */
      else
         run setLastVoucher
            (input recid(pvo_mstr),
             input "",
             input vo_ref).

      if l_flag = true then
         return.

      /* UPDATE RECEIPT IMPORT/EXPORT HISTORY      *
       * RECORD (ieh_hist) WHEN INTRASTAT IS USED  */
      for first iec_ctrl
         fields (iec_domain iec_use_instat)
         where iec_domain = global_domain
      no-lock:

         if iec_use_instat then do:

            /* l_ctr DELETES FULLY VOUCHERED PO INTRASTAT RECORDS */
            {gprun.i ""iehistap.p""
                     "(input pvo_order,
                       input pvo_line,
                       input pvo_internal_ref,
                       input prh_um_conv,
                       input vo_ref,
                       input vo_curr,
                       input vph_inv_qty,
                       input vph_curr_amt,
                       input ap_effdate,
                       input close_pvo,
                       input-output l_ctr)"}
         end. /* IF iec_use_instat */
      end.   /* FOR FIRST iec_ctrl */

      /* IF THE LINE IS CLOSED DISPLAY */
      /* THE EXTENDED USAGE VARIANCE   */
      if close_pvo or
         pvo_trans_qty - (prev_vouchered_qty + vph_inv_qty) = 0
      then do:
         if set_memo = 1 then do:
            assign ext_usage_var:format in frame f = ext_usage_fmt.
            display
               ext_usage_var
            with frame f.
         end. /* IF set_memo = 1  */
         else do:
            assign ext_usage_var:format in frame m = ext_usage_fmt.
            display
               ext_usage_var
            with frame m.
         end. /* ELSE DO */
      end. /* IF close_pvo */

      vph_inv_cost = vph_curr_amt.

      if (pvo_curr <> base_curr) or
         (vo_curr  <> base_curr)
      then do:
         /* CONVERT FROM VOUCHER TO BASE CURRENCY  */
         run mc_convert_voucher_to_base
            (input vph_inv_cost,
             input false,
             output vph_inv_cost).
      end. /* IF (pvo_curr <> base_curr) ... */

      /* ERROR IF INVOICE QTY = 0 AND INVOICE COST <> 0 */
      if vph_inv_qty = 0
         and vph_inv_cost <> 0
      then do:
         /* Invalid quantity/cost combination */
         if not batchrun then do:
         {pxmsg.i &MSGNUM=2206 &ERRORLEVEL=3}
				 end.
         if batchrun then
            l_flag = true.

         if set_memo = 1 then
            next-prompt vph_inv_qty with frame f.
         else
            if set_memo = 0 then
               next-prompt vph_inv_qty with frame m.

         undo setf, retry.
      end. /* IF  vph_inv_qty = 0 */

   end. /* setf */

   if l_flag = true then
      return.

   /* UPDATE DISPLAY */
   if vph_inv_qty  = 0
      and vph_inv_cost = 0
      and not close_pvo
   then
      set_zero = 0.
   else
      set_zero = 1.

   invcst   = vph_inv_qty * vph_curr_amt.

   run mc_round_trans_amount
      (input-output invcst).

   /* WE RE-CONVERT THE PO COST HERE BECAUSE AT THIS POINT IN THE PROGRAM */
   /* IT HAS BEEN CONVERTED TO TRANSACTION COST. HOWEVER, IN ORDER FOR    */
   /* THE base_cur_prh_cur_vo_cur_check PROCEDURE TO RUN CORRECTLY, PO    */
   /* COST MUST BE THE COST RELATED TO THE STOCKING UM.                   */
   l_pvod_pur_cost = l_pvod_pur_cost / prh_um_conv.

   run base_cur_prh_cur_vo_cur_check
       (input pvod_pur_std,
        input pvod_ovh_std,
        input pvod_ex_rate,
        input pvod_ex_rate2,
        input-output l_pvod_pur_cost).

   assign  l_pvod_pur_cost = l_pvod_pur_cost * prh_um_conv.

   run calc_purcst_stdcst_newcst_ext_open
      (input pvod_pur_std,
       input pvod_ovh_std,
       input l_pvod_pur_cost,
       input pvod_ex_rate,
       input pvod_ex_rate2).

   rndamt = (rcvd_open * newcst).

   run mc_round_rndamt.

   assign
      varstd = (ext_open - rndamt) * set_zero * set_memo
      invcst:format in frame f = invcst_fmt
      varstd:format in frame f = varstd_fmt.

   if set_memo = 1 then
      display
         invcst
         varstd
      with frame f.

   if set_memo = 0
      and available vph_hist
   then
      display
         vph_inv_qty
         vph_curr_amt
         invcst
      with frame m.

   /* WARN IF INVCST > POCST */
   if invcst > l_purcst2 then do:
      /*WARNING: EXTENDED INV COST > EXT PO COST*/
      if not batchrun then do:
      {pxmsg.i &MSGNUM=5 &ERRORLEVEL=2}
      end.
   end. /* IF invcst > l_purcst2  */

   /* RECEIPT REOPENED (NO LONGER VOUCHERED) */
   /* IF INV QTY AND COST = 0                */
   if set_zero = 0 then do:
      /* RECEIVER LINE REOPENED, NO LONGER VOUCHERED */
      if not batchrun then do:
      {pxmsg.i &MSGNUM=2207 &ERRORLEVEL=1}
		  end.
      /*BLANK OUT PRH_LAST VO*/
      run setLastVoucher
         (input recid(pvo_mstr),
          input ?,
          input "").

   end. /* IF set_zero = 0  */

   /*UPDATE VOUCHER TOTAL WITH EXTENDED INVOICE TOTAL */
   rndamt = vph_inv_qty * vph_curr_amt.

   run mc_round_rndamt.

   ap_amt = ap_amt + rndamt.

   /* CONVERT FROM VOUCHER TO BASE CURRENCY */
   run mc_convert_voucher_to_base
      (input rndamt,
       input true,
       output rndamt).

   ap_base_amt = ap_base_amt + rndamt.

   /* UPDATE FLAG TO CREATE/CHANGE VOUCHER DETAIL & G/L */
   now_open = if can-find (last pvo_mstr
                 where pvo_domain            = global_domain
                 and   pvo_lc_charge         = SPACES
                 and   pvo_internal_ref_type = {&TYPE_POReceiver}
                 and   pvo_internal_ref      = receiver
                 and   pvo_line              = rcvr_line
                 and   pvo_last_voucher      = SPACES)
               then yes
               else no.

   if old_qty <> vph_inv_qty
      or old_cost <> vph_curr_amt
      or (was_open and not now_open)
      or (not was_open and now_open)
   then
      process_gl = yes.

   if set_memo = 0 and
      (vph_acct <> pending_vo_accrual_acct
      or vph_sub <> pending_vo_accrual_sub
      or vph_cc <> pending_vo_accrual_cc
      or vph_project <> pending_vo_project)
   then
      process_gl = yes.

   /* CALCULATE RATE VARIANCE AS IN APVOMTA4, */
   /* SO APVOMTA2.P CAN CHECK IF IT IS ZERO */
   run mc_get_vo_ex_rate_at_rcpt_date.

   run convert_pvod_pur_cost
      (input l_pvod_pur_cost1,
       input pvod_ex_rate,
       input pvod_ex_rate2,
       output pvod-trx-cost).
   assign
      vodamt[2] = (vph_curr_amt * vph_inv_qty)
      rndamt = (pvod-trx-cost * prh_um_conv * vph_inv_qty).

   run mc_round_trans_amount
      (input-output vodamt[2]).

   if vo_curr <> pvo_curr then
      run convert_receipt_to_voucher
         (input-output rndamt).

   run mc_round_rndamt.

   vodamt[2] = vodamt[2] - rndamt.

   /* ALLOW USER TO CUSTOMIZE VALUE OF VODAMT[2] */
   {apvorate.i}

   /* PROCESS INVENTORY/VARIANCE POPUP */
   assign
      vph_recid = recid(vph_hist)
      prh_recid = recid(prh_hist).

   {gprun.i ""apvomta2.p""
         "(input prh_hist.prh_type,
           input vph_recid,
           input-output process_gl,
           input-output vodamt[2])"}

   for each vphhist1 exclusive-lock
      where vphhist1.vph_domain       = vph_hist.vph_domain
      and   vphhist1.vph_ref          = vph_hist.vph_ref
      and   vphhist1.vph_pvo_id       = vph_hist.vph_pvo_id
      and   vphhist1.vph_pvod_id_line <> 0:
         vphhist1.vph_adj_inv        = vph_hist.vph_adj_inv.
   end. /* FOR EACH vphhist1 */

   /* APVOMTA2 WILL SET PROCESS_GL = YES IF ANY COST UPD */
   if process_gl = yes
      /* This condition implies the voucher is confirmed */
      and not (apc_confirm = no and vo_confirm = yes and not new_vchr)
   then do:

      for first vod_det
         fields (vod_domain vod_ref vod_type)
          where  vod_domain = global_domain and  vod_ref = vo_ref
         and     vod_type = "R"
      no-lock: end. /* FOR FIRST vod_det */

      if available vod_det then do:
         ap_amt = 0.

         /* RE-CALCULATE THE RECEIVER LINES */
         for each vph_hist
            fields (vph_domain vph_ref vph_inv_qty vph_curr_amt)
            where   vph_domain = global_domain
            and     vph_ref = vo_ref
            and vph_pvo_id <> 0
            and vph_pvod_id_line > 0
         no-lock:
            rndamt = vph_inv_qty * vph_curr_amt.

            run mc_round_rndamt.

            ap_amt = ap_amt + rndamt.
         end. /* FOR each vph_hist */

         /* RE-CALCULATE THE NON-RECEIVER LINES */
         for each vod_det
            fields (vod_domain vod_amt vod_type vod_ref)
            where   vod_domain = global_domain
            and     vod_type <> "R"
            and     vod_ref = vo_ref
         no-lock:
            ap_amt = ap_amt + vod_amt.
         end.

      end. /* IF available vod_det */

   end. /* IF process_gl and ... */

   ap_amt:format in frame d = ap_amt_fmt.

   display
      ap_amt
   with frame d.

   for first tt_pvo_mstr
      where tt_pvo_id = pvo_mstr.pvo_id
      no-lock:
   end.
   if available tt_pvo_mstr then delete tt_pvo_mstr.
   for first vph_hist
      where recid(vph_hist) = vph_recid
   no-lock:
   end. /* FOR FIRST vph_hist */
   create tt_pvo_mstr.
   assign
      tt_pvo_id            = pvo_mstr.pvo_id
      tt_pvo_receiver      = pvo_mstr.pvo_internal_ref
      tt_pvo_order         = pvo_mstr.pvo_order
      tt_pvo_line          = pvo_mstr.pvo_line
      tt_pvo_vouchered_qty = vph_hist.vph_inv_qty
      tt_vph_ref           = vph_hist.vph_ref.

   /* REFRESH MATCHING DETAIL FRAME */
   clear frame match_detail all no-pause.

   for first tt_pvo_mstr
      where tt_pvo_id = vph_hist.vph_pvo_id
      no-lock:
   end.

   repeat with frame match_detail
   while available vph_hist:

      find first pvo_mstr
         where pvo_domain = global_domain
         and   pvo_id = vph_pvo_id
      no-lock no-error.

      vp-part = "".

      for first pod_det
         fields (pod_vpart pod_line pod_nbr pod_part pod_taxable pod_project
                 pod_domain)
         where pod_domain = global_domain
         and   pod_nbr            = pvo_order
         and   pod_line           = pvo_line
      no-lock:
         vp-part = pod_vpart.
      end.

      if vp-part = "" then
         for first vp_mstr
            fields (vp_vend_part vp_part vp_vend vp_domain)
            where vp_domain = global_domain
            and   vp_part   = pvo_part
            and   vp_vend   = pvo_supplier
         no-lock:
            vp-part = vp_vend_part.
         end.


      display
         pvo_internal_ref @ tt_pvo_receiver
         pvo_line         @ tt_pvo_line
         vph_nbr
         pvo_part
         vp-part
         vph_inv_qty.


      if frame-line = frame-down then
         leave.

      down.

      find next tt_pvo_mstr
         use-index sort_order
         no-lock no-error.

      if available tt_pvo_mstr then
         for first vph_hist
            where vph_domain       = global_domain
            and   vph_ref          = vo_ref
            and   vph_pvo_id       = tt_pvo_id
            and   vph_pvod_id_line = 0
            no-lock :
         end.
      else
         release vph_hist.

   end. /* DO ... match_detail */

   clear frame f no-pause.

end. /* LOOPG */

/*------------------------------------------------------------------*/
PROCEDURE calc_purcst_stdcst_newcst_ext_open:
define input parameter ip_pvod_pur_std like prh_pur_std no-undo.
define input parameter ip_pvod_ovh_std like prh_ovh_std no-undo.
define input parameter ip_pvod_pur_cost like prh_pur_cost no-undo.
define input parameter ip_pvod_ex_rate like prh_ex_rate no-undo.
define input parameter ip_pvod_ex_rate2 like prh_ex_rate2 no-undo.

   /* PURCST IS USED                   */
   /* TO DETERMINE IF A WARNING SHOULD */
   /* BE GIVEN BECAUSE THE EXTENDED    */
   /* INVOICE AMOUNT EXCEEDS THE       */
   /* EXTENDED PO AMOUNT               */

   run convert_pvod_pur_cost
      (input ip_pvod_pur_cost,
       input ip_pvod_ex_rate,
       input ip_pvod_ex_rate2,
       output pvod-trx-cost).

   purcst = rcvd_open * pvod-trx-cost.

   run mc_round_trans_amount
      (input-output purcst).

   if pvo_mstr.pvo_curr = base_curr then do:

      assign
         stdcst   = ip_pvod_pur_std * prh_hist.prh_um_conv * set_memo
         newcst   = (ip_pvod_pur_std - ip_pvod_ovh_std) *
                     prh_um_conv * set_memo
         ext_open = rcvd_open * ip_pvod_pur_cost.

      run mc_round_trans_amount
         (input-output ext_open).

   end. /* IF PVO_CURR ... */
   else do:
      /* CONVERT FROM BASE TO VOUCHER CURRENCY */
      run mc_convert_base_to_voucher
         (input ip_pvod_pur_std * prh_um_conv * set_memo,
          output stdcst).

      run mc_convert_base_to_voucher
         (input (ip_pvod_pur_std - ip_pvod_ovh_std) * prh_um_conv * set_memo,
          output newcst).

      if vo_mstr.vo_curr = pvo_curr
      then
         ext_open =
         rcvd_open *
         ip_pvod_pur_cost.
      else
         /* CONVERT FROM BASE TO VOUCHER CURRENCY */
         run mc_convert_base_to_voucher
            (input rcvd_open * ip_pvod_pur_cost,
             output ext_open).

      run mc_round_trans_amount
         (input-output ext_open).

   end. /* NOT IF PVO_CURR ... */

END PROCEDURE. /* CALC_PURCST_STDCST_NEWCST_EXT_OPEN */

/*------------------------------------------------------------------*/
PROCEDURE mc_get_vo_ex_rate_at_rcpt_date:

   /* GET EXCHANGE RATE BETWEEN VOUCHER AND BASE */
   /* AS OF RECEIPT DATE */
   {gprunp.i "mcpl" "p" "mc-get-ex-rate"
             "(input vo_mstr.vo_curr,
               input base_curr,
               input vo_ex_ratetype,
               input pvo_mstr.pvo_trans_date,
               output l_rcpt_rate,
               output l_rcpt_rate2,
               output mc-error-number)"}

   if mc-error-number <> 0 then
      run mc_warning.

   /* COMBINE PRH-TO-BASE EX RATE WITH BASE-TO-VO EX RATE */
   {gprunp.i "mcpl" "p" "mc-combine-ex-rates"
             "(input pending_vo_ex_rate,
               input pending_vo_ex_rate2,
               input l_rcpt_rate2,
               input l_rcpt_rate,
               output rcp_to_vo_ex_rate,
               output rcp_to_vo_ex_rate2)"}

END PROCEDURE. /* MC_GET_VO_EX_RATE_AT_RCPT_DATE */

PROCEDURE convert_receipt_to_voucher:
   define input-output parameter amt as decimal no-undo.

   /* CONVERT FROM RECEIPT TO VOUCHER CURRENCY */
   {gprunp.i "mcpl" "p" "mc-curr-conv"
             "(input pvo_mstr.pvo_curr,
               input vo_mstr.vo_curr,
               input rcp_to_vo_ex_rate,
               input rcp_to_vo_ex_rate2,
               input amt,
               input false, /* DO NOT ROUND */
               output amt,
               output mc-error-number)"}

   if mc-error-number <> 0 then
      run mc_warning.

END PROCEDURE. /* CONVERT_RECEIPT_TO_VOUCHER */

/*------------------------------------------------------------------*/
PROCEDURE mc_convert_voucher_to_base:
   define input parameter  source_amount as decimal no-undo.
   define input parameter  round_flag    as logical no-undo.
   define output parameter target_amount as decimal no-undo.

   /* CONVERT FROM VOUCHER TO BASE CURRENCY */
   {gprunp.i "mcpl" "p" "mc-curr-conv"
             "(input vo_mstr.vo_curr,
               input base_curr,
               input vo_ex_rate,
               input vo_ex_rate2,
               input source_amount,
               input round_flag,
               output target_amount,
               output mc-error-number)"}

   if mc-error-number <> 0 then
      run mc_warning.

END PROCEDURE. /* MC_CONVERT_VOUCHER_TO_BASE */

/*------------------------------------------------------------------*/
PROCEDURE mc_convert_base_to_voucher:
   define input parameter source_amount as decimal no-undo.
   define output parameter target_amount as decimal no-undo.

   /* CONVERT FROM BASE TO VOUCHER CURRENCY */
   {gprunp.i "mcpl" "p" "mc-curr-conv"
             "(input base_curr,
               input vo_mstr.vo_curr,
               input vo_ex_rate2,
               input vo_ex_rate,
               input source_amount,
               input false, /* DO NOT ROUND */
               output target_amount,
               output mc-error-number)"}

END PROCEDURE. /* MC_CONVERT_BASE_TO_VOUCHER */

/*------------------------------------------------------------------*/
PROCEDURE mc_round_rndamt:

   {gprunp.i "mcpl" "p" "mc-curr-rnd"
             "(input-output rndamt,
               input rndmthd,
               output mc-error-number)"}

   if mc-error-number <> 0 then
      run mc_warning.

END PROCEDURE. /* MC_ROUND_RNDAMT */

/*------------------------------------------------------------------*/
PROCEDURE mc_round_trans_amount:

   define input-output parameter amount as decimal no-undo.

   {gprunp.i "mcpl" "p" "mc-curr-rnd"
             "(input-output amount,
               input rndmthd,
               output mc-error-number)"}

   if mc-error-number <> 0 then
      run mc_warning.

END PROCEDURE. /* MC_ROUND_TRANS_AMOUNT */

/*------------------------------------------------------------------*/
PROCEDURE mc_warning:
		if not batchrun then do:
   {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
	  end.
END PROCEDURE. /* MC_WARNING */

/*------------------------------------------------------------------*/
PROCEDURE base_cur_prh_cur_vo_cur_check:
define input parameter ip_pvod_pur_std like prh_pur_std no-undo.
define input parameter ip_pvod_ovh_std like prh_ovh_std no-undo.
define input parameter ip_pvod_ex_rate like prh_ex_rate no-undo.
define input parameter ip_pvod_ex_rate2 like prh_ex_rate2 no-undo.
define input-output parameter io_pvod_pur_cost like prh_pur_cost no-undo.

   if base_curr <> vo_mstr.vo_curr then do:

      /* CONVERT FROM BASE TO VOUCHER CURRENCY */
      run mc_convert_base_to_voucher
         (input ip_pvod_pur_std * prh_hist.prh_um_conv * set_memo,
          output stdcst).

      run mc_convert_base_to_voucher
         (input (ip_pvod_pur_std - ip_pvod_ovh_std)
                * prh_hist.prh_um_conv * set_memo,
          output newcst).

   end.  /* IF base_curr <> vo_mstr.vo_curr  */

   run convert_pvod_pur_cost
      (input io_pvod_pur_cost,
       input ip_pvod_ex_rate,
       input ip_pvod_ex_rate2,
       output io_pvod_pur_cost).

   if vo_mstr.vo_curr <> pvo_mstr.pvo_curr then do:

      run mc_get_vo_ex_rate_at_rcpt_date.

      assign
         l_purcst   = round(rcvd_open * io_pvod_pur_cost
                                      * prh_hist.prh_um_conv,2)
         l_pur_cost = io_pvod_pur_cost.

      run convert_receipt_to_voucher
         (input-output io_pvod_pur_cost).
         ext_open = io_pvod_pur_cost * rcvd_open.

      run mc_round_trans_amount
         (input-output ext_open).

   end. /* IF vo_mstr.vo_curr <> pvo_mstr.pvo_curr */

END PROCEDURE. /* BASE_CUR_PRH_CUR_VO_CUR_CHECK */

/*------------------------------------------------------------------*/
PROCEDURE determineOpenVoucherQuantity:
   define input  parameter ip_recid        as integer no-undo.
   define output parameter op_open_qty     as decimal no-undo.
   define output parameter op_vouchered    as decimal no-undo.
   define output parameter op_last_voucher as character no-undo.

   define variable last_voucher   as character no-undo.

   define buffer pvomstr for pvo_mstr.

   for first pvomstr
      fields (pvo_last_voucher pvo_vouchered_qty pvo_trans_qty)
      where recid(pvomstr) = ip_recid
   no-lock:
      assign
         op_last_voucher = pvo_last_voucher
         op_vouchered    = pvo_vouchered_qty
         op_open_qty     = pvo_trans_qty - pvo_vouchered_qty.
   end.

END PROCEDURE.  /* determineOpenVoucherQuantity */

/*------------------------------------------------------------------*/
PROCEDURE backOutVoucherQuantity:
   define input  parameter ip_pvo_id        as integer no-undo.
   define input  parameter ip_pvod_id_line  as integer no-undo.
   define input  parameter ip_vouchered_qty as decimal no-undo.

   define variable work_vouchered_qty as decimal no-undo.
   define variable l_sign             as integer no-undo initial 1.
   define buffer pvomstr for pvo_mstr.

   work_vouchered_qty = ip_vouchered_qty.

   if work_vouchered_qty = 0 then leave.

   for first pvomstr
      where pvo_domain = global_domain
      and   pvo_id = ip_pvo_id
   exclusive-lock:

      pvo_vouchered_qty = pvo_vouchered_qty - ip_vouchered_qty.

   end.  /* FOR FIRST pvomstr */

   /* BACK OUT ONLY pvod_det RECORDS CORRESPONDING TO
      vph_hist LINE */
   for each pvod_det
      where pvod_domain  = global_domain
      and   pvod_id      = ip_pvo_id
      and   pvod_id_line = ip_pvod_id_line
   exclusive-lock:

       run getExtensionRecords
          (input pvod_id,
           input pvod_id_line).

       if work_vouchered_qty   >=  pvod_vouchered_qty
          and ip_vouchered_qty > 0
       then do:
          assign
             work_vouchered_qty = work_vouchered_qty - pvod_vouchered_qty
             pvod_vouchered_qty = 0.

          {gpextset.i &OWNER = 'ADG'
                      &TABLENAME = 'pvod_det'
                      &REFERENCE = '10074a'
                      &KEY1 = global_domain
                      &KEY2 = string(pvod_id)
                      &KEY3 = string(pvod_id_line)
                      &DEC2 = pvod_vouchered_qty}
       end.
       else do:
          assign
             pvod_vouchered_qty = pvod_vouchered_qty - work_vouchered_qty
             work_vouchered_qty = 0.

          {gpextset.i &OWNER = 'ADG'
                      &TABLENAME = 'pvod_det'
                      &REFERENCE = '10074a'
                      &KEY1 = global_domain
                      &KEY2 = string(pvod_id)
                      &KEY3 = string(pvod_id_line)
                      &DEC2 = pvod_vouchered_qty}

       end.
       pvod_vouchered_qty = pvod_vouchered_qty * l_sign.

       if work_vouchered_qty = 0 then leave.
   end. /* FOR EACH pvod_det */
END PROCEDURE.  /* backOutVoucherQuantity */

/*------------------------------------------------------------------*/
PROCEDURE updatePendingVoucherQuantity:
   define input  parameter ip_recid         as integer no-undo.
   define input  parameter ip_voucher_qty   as decimal no-undo.

   define variable work_voucher_qty as decimal no-undo.
   define variable open_qty as decimal no-undo.
   define buffer pvomstr for pvo_mstr.

   for first pvomstr
      where recid(pvomstr) = ip_recid
   exclusive-lock:
      pvo_vouchered_qty = pvo_vouchered_qty + ip_voucher_qty.
   end.

   work_voucher_qty = ip_voucher_qty.

   for each pvod_det exclusive-lock where
            pvod_domain = global_domain
        and pvod_id = pvomstr.pvo_id
       break by pvod_id:

       run getExtensionRecords
          (input pvod_id,
           input pvod_id_line).

       if work_voucher_qty >= (pvod_trans_qty - pvod_vouchered_qty)
       then do:

          if (pvod_trans_qty > 0 and
             (pvod_trans_qty - pvod_vouchered_qty = 0)) or
             (pvod_trans_qty < 0 and
             (pvod_trans_qty - pvod_vouchered_qty = 0))
          then next.

          assign
             usage_var = no
             open_qty = pvod_trans_qty - pvod_vouchered_qty
             work_voucher_qty = work_voucher_qty -
                               (pvod_trans_qty - pvod_vouchered_qty)
             pvod_vouchered_qty = pvod_trans_qty.

          run create_update_vph_hist
             (input open_qty,
              input vph_hist.vph_curr_amt,
              input pvod_id,
              input pvod_id_line,
              input usage_var).

          {gpextset.i &OWNER = 'ADG'
                      &TABLENAME = 'pvod_det'
                      &REFERENCE = '10074a'
                      &KEY1 = global_domain
                      &KEY2 = string(pvod_id)
                      &KEY3 = string(pvod_id_line)
                      &DEC2 = pvod_vouchered_qty}

       end.

       else do:

          assign
             usage_var = no
             pvod_vouchered_qty = pvod_vouchered_qty + work_voucher_qty.

          run create_update_vph_hist
              (input work_voucher_qty,
               input vph_hist.vph_curr_amt,
               input pvod_id,
               input pvod_id_line,
               input usage_var).

          {gpextset.i &OWNER = 'ADG'
                      &TABLENAME = 'pvod_det'
                      &REFERENCE = '10074a'
                      &KEY1 = global_domain
                      &KEY2 = string(pvod_id)
                      &KEY3 = string(pvod_id_line)
                      &DEC2 = pvod_vouchered_qty}

          work_voucher_qty = 0.

       end.

       /* IF THERE IS POSITIVE MATERIAL USAGE VARIANCE, ADD IT TO THE */
       /* LAST PENDING VOUCHER DETAIL RECORD.                         */
       if last-of(pvod_id) and work_voucher_qty > 0 then do:

          assign
             usage_var = yes
             pvod_vouchered_qty = pvod_vouchered_qty + work_voucher_qty.

          run create_update_vph_hist
              (input work_voucher_qty,
               input vph_hist.vph_curr_amt,
               input pvod_id,
               input pvod_id_line,
               input usage_var).

          {gpextset.i &OWNER = 'ADG'
                      &TABLENAME = 'pvod_det'
                      &REFERENCE = '10074a'
                      &KEY1 = global_domain
                      &KEY2 = string(pvod_id)
                      &KEY3 = string(pvod_id_line)
                      &DEC2 = pvod_vouchered_qty}

          work_voucher_qty = 0.

       end.

   end.
END PROCEDURE. /* updatePendingVoucherQuantity */

/*------------------------------------------------------------------*/
PROCEDURE setLastVoucher:
   define input  parameter ip_recid     as integer no-undo.
   define input  parameter ip_curr_vo   as character no-undo.
   define input  parameter ip_new_vo    as character no-undo.

   define buffer pvomstr for pvo_mstr.

   /* UPDATE pvo_last_vo WHEN NEW VALUE IS "" AND pvo_vouchered_qty IS 0 */
   for first pvomstr
      where recid(pvomstr) = ip_recid
   exclusive-lock:
      if (pvo_vouchered_qty     <> 0
          or ip_new_vo           = ""
          or (pvo_vouchered_qty  = 0
              and close_pvo))
         and (pvo_last_voucher   = ip_curr_vo
              or ip_curr_vo      = ?)
      then
         pvo_last_voucher = ip_new_vo.
   end. /* FOR FIRST pvo_mstr */

END PROCEDURE.  /* setLastVoucher */

/*------------------------------------------------------------------*/
PROCEDURE get_pt_description:
   define input parameter p_pod_domain like pt_domain no-undo.
   define input parameter p_pod_part   like pt_part   no-undo.

   define buffer b_ptmstr for pt_mstr.

   for first b_ptmstr
      fields (pt_domain pt_desc1 pt_desc2 pt_part)
      where pt_domain = p_pod_domain
      and   pt_part   = p_pod_part
   no-lock:
   if not batchrun then do:
      {pxmsg.i &MSGNUM=2685 &ERRORLEVEL=1 &MSGARG1=pt_desc1 &MSGARG2=pt_desc2}
   end.
  end.

END PROCEDURE. /* PROCEDURE get_pt_description */
/*------------------------------------------------------------------*/
PROCEDURE determine_stdcst_display:

   define input parameter i_pvo_id like pvo_id no-undo.
   define input-output parameter o_std_cst as decimal no-undo.
   define output parameter o_multi_det as logical no-undo.

   define variable p_detail_ctr as integer no-undo.
   define variable first_item_cost as decimal no-undo.

   /* IF THE PENDING VOUCHER HAS MULTIPLE DETAIL RECORDS WITH */
   /* DIFFERENT ITEM COSTS (stdcst) THEN DISPLAY <BLANK> FOR  */
   /* ITEM COST.                                              */
   assign
      o_multi_det = no
      p_detail_ctr = 0.

   for each pvod_det no-lock where
            pvod_domain = global_domain
        and pvod_id = i_pvo_id:

       run getExtensionRecords
          (input pvod_id,
           input pvod_id_line).

       p_detail_ctr = p_detail_ctr + 1.

       if p_detail_ctr = 1 then
          first_item_cost = pvod_pur_std.
       else do:
          if first_item_cost = pvod_pur_std then do:
             p_detail_ctr = p_detail_ctr - 1.
             next.
          end.
       end.

       if p_detail_ctr > 1 then do:
          assign
             o_std_cst = 0
             o_multi_det = yes.
          leave.
       end.
   end.
END PROCEDURE. /* PROCEDURE determine_stdcst_display */

/*------------------------------------------------------------------*/
PROCEDURE determine_ext_cost_display:

   define input parameter i_pvo_id like pvo_id no-undo.
   define output parameter o_multi_det as logical no-undo.

   define variable p_detail_ctr as integer no-undo.
   define variable first_item_cost as decimal no-undo.

   /* IF THE PENDING VOUCHER HAS MULTIPLE DETAIL RECORDS WITH */
   /* DIFFERENT PO COSTS THEN DISPLAY <BLANK> FOR EXTENDED    */
   /* INVOICE AND EXTENDED RATE VARIANCE FIELDS.              */
   assign
      o_multi_det = no
      p_detail_ctr = 0.

   for each pvod_det no-lock where
            pvod_domain = global_domain
        and pvod_id = i_pvo_id:

       run getExtensionRecords
          (input pvod_id,
           input pvod_id_line).

       p_detail_ctr = p_detail_ctr + 1.

       if p_detail_ctr = 1 then
          first_item_cost = pvod_pur_cost.
       else do:
          if first_item_cost = pvod_pur_cost then do:
             p_detail_ctr = p_detail_ctr - 1.
             next.
          end.
       end.

       if p_detail_ctr > 1 then do:
          o_multi_det = yes.
          leave.
       end.
   end.
END PROCEDURE. /* PROCEDURE determine_ext_cost_display */

/*----------------------------------------------------------*/
PROCEDURE create_update_vph_hist:
define input parameter ip_qty_vouchered as decimal no-undo.
define input parameter ip_invoice_cost as decimal no-undo.
define input parameter ip_pvo_id like pvod_id no-undo.
define input parameter ip_pvod_id_line like pvod_id_line no-undo.
define input parameter ip_usage_var as logical no-undo.

define buffer vphhist for vph_hist.

/* FIND THE PENDING VOUCHER DETAIL RECORD TO GET THE TAX INFORMATION */
/* ACCOUNT AND PROJECT INFORMATION FOR THE vph_hist RECORD.          */
for first pvod_det no-lock where
          pvod_domain = global_domain
      and pvod_id = ip_pvo_id
      and pvod_id_line = ip_pvod_id_line:
end.

/* CREATE A vph_hist RECORD IF ONE DOESN'T ALREADY EXIST */
/* IF THE PENDING VOUCHER THIS DETAIL RECORD BELONGS TO  */
/* WAS SELECTED VIA AUTO-SELECT, A vph_hist RECORD WILL  */
/* ALREADY EXIST FOR THIS DETAIL RECORD.                 */
if not can-find(first vphhist where
                      vphhist.vph_domain = global_domain
                  and vphhist.vph_ref = vo_mstr.vo_ref
                  and vphhist.vph_pvo_id = ip_pvo_id
                  and vphhist.vph_pvod_id_line = ip_pvod_id_line)
then do:
   /* CREATE vph_hist RECORD FOR PENDING VOUCHER DETAILS */
   create vphhist.
   assign
      vphhist.vph_domain       = global_domain
      vphhist.vph_ref          = vo_mstr.vo_ref
      vphhist.vph_pvo_id       = integer(ip_pvo_id)
      vphhist.vph_pvod_id_line = integer(ip_pvod_id_line)
      vphhist.vph_inv_qty      = ip_qty_vouchered
      vphhist.vph_curr_amt     = ip_invoice_cost
      vphhist.vph_inv_cost     = ip_invoice_cost
      vphhist.vph_nbr          = pvo_mstr.pvo_order
      vphhist.vph_inv_date     = ap_mstr.ap_effdate
      vphhist.vph_acct         = l_vph_acct
      vphhist.vph_sub          = l_vph_sub
      vphhist.vph_cc           = l_vph_cc
      vphhist.vph_project      = l_vph_project
      vphhist.vph__qadc01      = l_tax_usage                       +
                                 fill(" ",8 - length(l_tax_usage)) +
                                 l_taxc                            +
                                 fill(" ",3 - length(l_taxc)).
end.
else do:
   /* UPDATE EXISTING vph_hist RECORD */
   for first vphhist exclusive-lock where
             vphhist.vph_domain = global_domain
         and vphhist.vph_ref = vo_mstr.vo_ref
         and vphhist.vph_pvo_id = ip_pvo_id
         and vphhist.vph_pvod_id_line = ip_pvod_id_line:

       assign
          vphhist.vph_curr_amt = ip_invoice_cost
          vphhist.vph_inv_cost = vphhist.vph_curr_amt
          vphhist.vph_acct     = l_vph_acct
          vphhist.vph_sub      = l_vph_sub
          vphhist.vph_cc       = l_vph_cc
          vphhist.vph_project  = l_vph_project
          vphhist.vph__qadc01  = l_tax_usage                       +
                                 fill(" ",8 - length(l_tax_usage)) +
                                 l_taxc                            +
                                 fill(" ",3 - length(l_taxc)).


       if ip_usage_var then
          vphhist.vph_inv_qty = vphhist.vph_inv_qty + ip_qty_vouchered.
       else
          vphhist.vph_inv_qty = ip_qty_vouchered.

   end.
end.

/* CONVERT FROM VOUCHER TO BASE CURRENCY  */
/* WHEN FOREIGN CURRENCY                  */
if (pvo_mstr.pvo_curr <> base_curr) or
   (vo_mstr.vo_curr  <> base_curr)
then do:
   run mc_convert_voucher_to_base
      (input vphhist.vph_inv_cost,
       input false,
       output vphhist.vph_inv_cost).
end. /* IF (pvo_curr <> base_curr) ... */
END PROCEDURE.

/* THIS PROCEDURE CAN BE REMOVED ONCE THE NEW pvod_det FIELDS */
/* HAVE BEEN INTRODUCED INTO THE SCHEMA.                      */
PROCEDURE getExtensionRecords:
define input parameter ip_pvod_id like pvo_id no-undo.
define input parameter ip_pvod_id_line like pvod_id_line no-undo.

run getExtTableRecord
   (input "10074a",
    input global_domain,
    input ip_pvod_id,
    input ip_pvod_id_line,
    output pvod_trans_qty,
    output pvod_vouchered_qty,
    output pvod_pur_cost,
    output pvod_pur_std,
    output pvod-dummy-dec1,
    output pvod_trans_date,
    output pvod-dummy-char).

run getExtTableRecord
   (input "10074b",
    input global_domain,
    input ip_pvod_id,
    input ip_pvod_id_line,
    output pvod_ex_rate,
    output pvod_ex_rate2,
    output pvod_exru_seq,
    output pvod-dummy-dec1,
    output pvod-dummy-dec2,
    output pvod-dummy-date,
    output pvod_ex_ratetype).

run getExtTableRecord
   (input "10074c",
    input global_domain,
    input ip_pvod_id,
    input ip_pvod_id_line,
    output pvod_mtl_std,
    output pvod_lbr_std,
    output pvod_bdn_std,
    output pvod_ovh_std,
    output pvod_sub_std,
    output pvod-dummy-date,
    output pvod-dummy-char).
END PROCEDURE.

PROCEDURE convert_pvod_pur_cost:
define input parameter ip_pur_cost like pvod_pur_cost no-undo.
define input parameter ip_ex_rate like pvod_ex_rate no-undo.
define input parameter ip_ex_rate2 like pvod_ex_rate2 no-undo.
define output parameter op_pur_cost like pvod_pur_cost no-undo.

/* CONVERT pvod_pur_cost TO TRANSACTION CURR */
{gprunp.i "mcpl" "p" "mc-curr-conv"
           "(input  base_curr,
             input  pvo_mstr.pvo_curr,
             input  ip_ex_rate2,
             input  ip_ex_rate,
             input  ip_pur_cost,
             input  false,
             output op_pur_cost,
             output mc-error-number)"}

if mc-error-number <> 0 and not batchrun then do:
   {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
end.

END PROCEDURE.

PROCEDURE display-detail :
   if available tt_pvo_mstr then .
   if available vo_mstr then .

   if recno <> ? then do:

      for first prh_hist
         fields(prh_domain prh_curr prh_curr_amt prh_line prh_nbr
                prh_ovh_std prh_part prh_ps_nbr prh_ps_qty
                prh_pur_cost prh_pur_std prh_rcp_date prh_rcvd
                prh_receiver prh_site prh_sub prh_taxc
                prh_tax_env prh_tax_in prh_tax_usage prh_type prh_um
                prh_um_conv prh_vend)
          where prh_domain   = global_domain
          and   prh_receiver = tt_pvo_receiver
          and   prh_line     = tt_pvo_line
      no-lock: end.

      for first pvo_mstr no-lock
         where pvo_domain = global_domain
         and   pvo_id     = tt_pvo_id,
      first vph_hist
         where vph_domain = global_domain
         and   vph_pvo_id            = pvo_id
         and   vph_pvod_id_line      = 0
         and   vph_ref               = vo_ref
      no-lock:
         receiver_recid = recid(pvo_mstr).
      end.

      for each pvod_det
         where pvod_domain = global_domain
         and   pvod_id     = pvo_id
      no-lock:

         run getExtensionRecords
           (input pvod_id,
            input pvod_id_line).

         if pvod_trans_qty = pvod_vouchered_qty
         then
            next.
         else
         do:
            assign
               l_pvod_pur_cost = pvod_pur_cost
               receiver        = pvo_internal_ref
               rcvr_line       = pvo_line.
            leave.
         end. /* ELSE DO */
      end. /* FOR EACH pvod_det */

        /* READ PENDING VOUCHER RECORD FOR TOTAL QTY */
      run determineOpenVoucherQuantity
         (input recid(pvo_mstr),
          output rcvd_open,
          output prev_vouchered_qty,
          output last_voucher).

      /* IF NOT "CLOSED" BY THIS */
      /* INVOICE, DON'T SHOW VAR */
      if last_voucher <> vo_ref
         and not close_pvo
      then
         set_zero = 0.
      else
         set_zero = 1.

      if prh_type <> ""
         and prh_type <> "S"
      then
         set_memo = 0.
      else
         set_memo = 1.

      rcvd_open = pvo_trans_qty - prev_vouchered_qty.

      run base_cur_prh_cur_vo_cur_check
          (input pvod_pur_std,
           input pvod_ovh_std,
           input pvod_ex_rate,
           input pvod_ex_rate2,
           input-output l_pvod_pur_cost).

      if available vph_hist then do:
         assign
            rcvd_open    = rcvd_open + vph_inv_qty
            invcst       = vph_inv_qty * vph_curr_amt.

         run mc_round_trans_amount
            (input-output invcst).

         assign
            invqty       = vph_inv_qty
            inv_amt      = vph_curr_amt
            ext_rate_var = vph_curr_amt * vph_inv_qty
            rndamt       = l_pvod_pur_cost * vph_inv_qty.

         run mc_round_trans_amount
            (input-output ext_rate_var).

         run mc_round_rndamt.

         ext_rate_var = ext_rate_var - rndamt.

         if last_voucher <> "" then do:
            assign
               ext_usage_var = vph_inv_qty * l_pvod_pur_cost
               rndamt        = rcvd_open * l_pvod_pur_cost.

            run mc_round_trans_amount
               (input-output ext_usage_var).

            run mc_round_rndamt.

            ext_usage_var = ext_usage_var - rndamt.
         end. /* IF LAST_VOUCHER <> "" */
         else
            ext_usage_var = 0.

      end. /* IF AVAILABLE VPH_HIST */
      else
         assign
            invcst        = 0
            invqty        = 0
            inv_amt       = 0
            ext_rate_var  = 0
            ext_usage_var = 0.

      run calc_purcst_stdcst_newcst_ext_open
         (input pvod_pur_std,
          input pvod_ovh_std,
          input l_pvod_pur_cost,
          input pvod_ex_rate,
          input pvod_ex_rate2).

      if vo_curr <> pvo_curr then
         ext_open = l_pvod_pur_cost * rcvd_open.

      rndamt   = (rcvd_open * newcst).

      run mc_round_rndamt.

      varstd = (ext_open - rndamt) * set_zero * set_memo.
      run determine_stdcst_display
          (input pvo_id,
           input-output stdcst,
           output multi_det).

      run determine_ext_cost_display
          (input pvo_id,
           output ext_multi_det).

      display
         receiver
         rcvr_line
         pvo_taxable
         pvo_trans_date
         pvo_project
         pvo_part
         prh_um
         prh_type
         rcvd_open
         l_pvod_pur_cost @ prh_pur_cost
         ext_open
         invqty         @ vph_inv_qty
         inv_amt        @ vph_curr_amt
         prh_ps_qty
         pvo_trans_qty
         varstd
         ext_usage_var
      with frame f.

      if stdcst <> 0 or
        (stdcst = 0 and not multi_det)
      then display
         stdcst
      with frame f.

      if not ext_multi_det
      then display
         invcst
         ext_rate_var
      with frame f.
      if pvo_consignment then
         display
            0 @ prh_ps_qty
         with frame f.

      if keyfunction(l_lastkey) <> "end-error"
      then
         if vo_curr <> pvo_curr
         then do:
            l_msg_txt = string(l_purcst) + " " + string(pvo_curr).
            if not batchrun then do:
              {pxmsg.i &MSGNUM=2684 &ERRORLEVEL=1 &MSGARG1=l_pur_cost
               &MSGARG2=pvo_curr &MSGARG3=l_msg_txt}
              pause.
            end.
         end.

      for first pod_det
         fields (pod_domain  pod_line  pod_nbr
                 pod_taxable pod_vpart pod_part)
          where pod_domain = global_domain
          and   pod_nbr    = pvo_order
          and   pod_line   = pvo_line
      no-lock:
         display
            pod_vpart
         with frame f.

         /* GET ITEM DESCRIPTION FOR DISPLAY IN RECEIVER */
         /* MATCHING MAINTENANCE                         */
         run get_pt_description
            (input pod_domain,
             input pod_part).
      end.
   end.  /* IF RECNO <> ? */

   if receiver_recid <> ? then do:
      for first pvo_mstr
         fields (pvo_domain pvo_id pvo_line pvo_order pvo_part pvo_shipto)
         where recid(pvo_mstr) = receiver_recid
      no-lock:

         if frame-field = "receiver"
         then do:
            display
               pvo_line @ rcvr_line
            with frame f.
         end. /*IF FRAME-FIELD = "receiver"*/

      end.
   end.

END PROCEDURE. /*PROCEDURE display-detail*/
