/* sosomta1.p - PROCESS SALES ORDER HEADER FRAMES                             */
/* Copyright 1986-2003 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.56.1.2 $                                                          */
/*V8:ConvertMode=Maintenance                                                  */
/* REVISION: 8.5      LAST MODIFIED: 02/21/96   BY: sxb *J053*                */
/* REVISION: 8.5      LAST MODIFIED: 03/04/96   BY: tjs *J053*                */
/* REVISION: 8.5      LAST MODIFIED: 04/09/96   BY: *J04C* Sue Poland         */
/* REVISION: 8.5      LAST MODIFIED: 04/26/96   BY: *J0KJ* Dennis Hensen      */
/* REVISION: 8.5      LAST MODIFIED: 05/13/96   BY: *J0M3* Sue Poland         */
/* REVISION: 8.5      LAST MODIFIED: 05/23/96   BY: *J0NH* Sue Poland         */
/* REVISION: 8.5      LAST MODIFIED: 05/23/96   BY: *J0R6* Sue Poland         */
/* REVISION: 8.5      LAST MODIFIED: 07/19/96   BY: *J0ZZ* T. Farnsworth      */
/* REVISION: 8.5      LAST MODIFIED: 08/27/96   BY: *G2D5* Suresh Nayak       */
/* REVISION: 8.6      LAST MODIFIED: 10/22/96   BY: *K004* Elke Van Maele     */
/* REVISION: 8.6      LAST MODIFIED: 11/05/96   BY: *K01T* Stephane Collard   */
/* REVISION: 8.6      LAST MODIFIED: 05/06/97   BY: *K0CZ* Kieu Nguyen        */
/* REVISION: 8.6      LAST MODIFIED: 06/11/97   BY: *K0DQ* Taek-Soo Chang     */
/* REVISION: 8.6      LAST MODIFIED: 07/01/97   BY: *H1B3* Seema Varma        */
/* REVISION: 8.6      LAST MODIFIED: 07/15/97   BY: *K0G6* Arul Victoria      */
/* REVISION: 8.6      LAST MODIFIED: 07/11/97   BY: *K0DH* Kieu Nguyen        */
/* REVISION: 8.6      LAST MODIFIED: 09/27/97   BY: *K0HB* Kieu Nguyen        */
/* REVISION: 8.6      LAST MODIFIED: 11/17/97   BY: *J26C* Aruna Patil        */
/* REVISION: 8.6      LAST MODIFIED: 12/17/97   BY: *J288* Surekha Joshi      */
/* REVISION: 8.6      LAST MODIFIED: 12/29/97   BY: *J28V* Surekha Joshi      */
/* REVISION: 8.6      LAST MODIFIED: 01/08/98   BY: *J29J* Surekha Joshi      */
/* REVISION: 8.6      LAST MODIFIED: 01/15/98   BY: *K1FK* Jim Williams       */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane          */
/* REVISION: 8.6E     LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan         */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan         */
/* REVISION: 9.0      LAST MODIFIED: 12/23/98   BY: *M045* Raphael Thoppil    */
/* REVISION: 9.0      LAST MODIFIED: 12/28/98   BY: *J2ZM* Reetu Kapoor       */
/* REVISION: 9.0      LAST MODIFIED: 02/16/99   BY: *J3B4* Madhavi Pradhan    */
/* REVISION: 9.0      LAST MODIFIED: 03/13/99   BY: *M0BD* Alfred Tan         */
/* REVISION: 9.1      LAST MODIFIED: 10/01/99   BY: *N014* Patti Gaultney     */
/* REVISION: 9.1      LAST MODIFIED: 10/27/99   BY: *N03P* Mayse Lai          */
/* REVISION: 9.1      LAST MODIFIED: 03/06/00   BY: *N05Q* Luke Pokic         */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane   */
/* REVISION: 9.1      LAST MODIFIED: 04/25/00   BY: *N0CG* Santosh Rao        */
/* REVISION: 9.1      LAST MODIFIED: 06/30/00   BY: *N0DX* Mudit Mehta        */
/* REVISION: 9.1      LAST MODIFIED: 07/24/00   BY: *J3Q2* Ashwini G.         */
/* REVISION: 9.1      LAST MODIFIED: 08/12/00   BY: *N0KN* Mark Brown         */
/* REVISION: 9.1      LAST MODIFIED: 09/28/00   BY: *M0T7* Rajesh Kini        */
/* REVISION: 9.1      LAST MODIFIED: 10/03/00   BY: *L14Q* Abhijeet Thakur    */
/* REVISION: 9.1      LAST MODIFIED: 10/16/00   BY: *N0WB* BalbeerS Rajput    */
/* REVISION: 9.1      LAST MODIFIED: 02/21/01   BY: *M125* Satish Chavan      */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* Revision: 1.42      BY: Katie Hilbert        DATE: 04/01/01 ECO: *P002*    */
/* Revision: 1.43      BY: Nikita Joshi         DATE: 06/19/01 ECO: *M1BP*    */
/* Revision: 1.44      BY: Jean Miller          DATE: 08/08/01 ECO: *M11Z*    */
/* Revision: 1.45      BY: Russ Witt            DATE: 09/21/01 ECO: *P01H*    */
/* Revision: 1.46      BY: Russ Witt            DATE: 10/17/01 ECO: *P02C*    */
/* Revision: 1.47      BY: Rajiv Ramaiah        DATE: 10/25/01 ECO: *M1MP*    */
/* Revision: 1.48      BY: Ed van de Gevel      DATE: 12/03/01 ECO: *N16R*    */
/* Revision: 1.51      BY: Patrick Rowan        DATE: 03/14/02 ECO: *P00G*    */
/* Revision: 1.52      BY: Deepak Rao           DATE: 07/08/02 ECO: *N1NH*    */
/* Revision: 1.53      BY: Reetu Kapoor         DATE: 08/28/02 ECO: *P0GX*    */
/* Revision: 1.54      BY: Nishit V             DATE: 10/16/02 ECO: *N1X1*    */
/* Revision: 1.55      BY: Laurene Sheridan     DATE: 12/10/02 ECO: *M219*    */
/* Revision: 1.56      BY: Narathip W.          DATE: 05/08/03 ECO: *P0RL*    */
/* Revision: 1.56.1.1  BY: Shoma Salgaonkar     DATE: 07/16/03 ECO: *N2J7*    */
/* $Revision: 1.56.1.2 $     BY: Narathip W.          DATE: 08/07/03 ECO: *P0Z6*    */
/*----rev history-------------------------------------------------------------------------------------*/
/* SS - 110120.1  By: Roger Xiao */
/*-Revision end---------------------------------------------------------------*/



/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/******************************************************************************/
/* Due to the introduction of the module Project Realization Management (PRM) */
/* the term Material Order (MO) replaces all previous references to Service   */
/* Engineer Order (SEO) in the user interface. Material Order is a type of    */
/* Sales Order used by an engineer to obtain inventory needed for service     */
/* work. In PRM, a material order is used to obtain inventory for project     */
/* work.                                                                      */
/******************************************************************************/

/* Note: This program is called by SOSOMT1.P.  It was initially split from
   SOSOMT.P due to compile size limits.  */

{mfdeclre.i}
{cxcustom.i "SOSOMTA1.P"}
{gplabel.i} /* EXTERNAL LABEL INCLUDE */
{pxmaint.i} /* PERSISTENT PROCEDURE PROGRAM MANAGER */
{pxphdef.i sosoxr} /* DEFINES HANDLE FOR SO HEADER ROP */

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE sosomta1_p_1 "Line Pricing"
/* MaxLen: Comment: */

&SCOPED-DEFINE sosomta1_p_2 "Comments"
/* MaxLen: Comment: */

&SCOPED-DEFINE sosomta1_p_4 "Confirmed"
/* MaxLen: Comment: */

&SCOPED-DEFINE sosomta1_p_6 "Calculate Freight"
/* MaxLen: Comment: */

&SCOPED-DEFINE sosomta1_p_7 "Promise Date"
/* MaxLen: Comment: */

&SCOPED-DEFINE sosomta1_p_8 "Reprice"
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */

{socurvar.i}

/* Input/Output Parameters */
define input  parameter this-is-rma as logical.
define output parameter not_okay    as integer no-undo.
define output parameter rma-recno   as recid.

/* Shared Variables */
define new shared variable l_edittax  like mfc_logical
                                      initial no no-undo.
define new shared variable l_up_sales like mfc_logical no-undo.

define shared variable rndmthd     like rnd_rnd_mthd.
define shared variable oldcurr     like so_curr.
define shared variable line        like sod_line.
define shared variable del-yn      like mfc_logical.
define shared variable qty_req     like in_qty_req.
define shared variable prev_due    like sod_due_date.
define shared variable prev_qty_ord like sod_qty_ord.
define shared variable trnbr       like tr_trnbr.
define shared variable qty         as decimal.
define shared variable part        as character format "x(18)".
define shared variable eff_date    as date.
define shared variable all_days    like soc_all_days.
define shared variable all_avail   like soc_all_avl.
define shared variable sngl_ln     like soc_ln_fmt.
define shared variable so_recno    as recid.
define shared variable cm_recno    as recid.
define shared variable comp        like ps_comp.
define shared variable cmtindx     like cmt_indx.
define shared variable sonbr       like so_nbr.
define shared variable socmmts     like soc_hcmmts label {&sosomta1_p_2}.
define shared variable prev_abnormal like sod_abnormal.
define shared variable promise_date as date label {&sosomta1_p_7}.
define shared variable perform_date as date label "Perform Date".
define shared variable base_amt    like ar_amt.
define shared variable consume     like sod_consume.
define shared variable prev_consume like sod_consume.
define shared variable confirm     like mfc_logical
   format "yes/no" initial yes label {&sosomta1_p_4}.
define shared variable sotrcust    like so_cust.
define shared variable merror      like mfc_logical initial no.
define shared variable so-detail-all like soc_det_all.
define shared variable new_order   like mfc_logical initial no.
define shared variable sotax_trl   like tax_trl.
define shared variable tax_in      like cm_tax_in.
define shared variable rebook_lines as logical initial no no-undo.
define shared variable avail_calc  as integer.
define shared variable so_db       like dc_name.
define shared variable inv_db      like dc_name.
define shared variable mult_slspsn like mfc_logical no-undo.
define shared variable undo_cust   like mfc_logical.
define shared variable freight_ok  like mfc_logical initial yes.
define shared variable old_ft_type like ft_type.
define shared variable calc_fr     like mfc_logical label {&sosomta1_p_6}.
define shared variable undo_flag   like mfc_logical.
define shared variable disp_fr     like mfc_logical.
define shared variable display_trail like mfc_logical initial yes.
define shared variable soc_pc_line like mfc_logical initial yes.
define shared variable socrt_int   like sod_crt_int.
define shared variable impexp      like mfc_logical no-undo.
define shared variable picust      like cm_addr.
define shared variable price_changed like mfc_logical.
define shared variable line_pricing like pic_so_linpri label {&sosomta1_p_1}.
define shared variable reprice     like mfc_logical label {&sosomta1_p_8}
   initial no.
define shared variable balance_fmt as character.
define shared variable limit_fmt   as character.
define shared variable prepaid_fmt as character no-undo.
define shared variable prepaid_old as character no-undo.

/* Local Variables */
define variable in_batch_proces as   logical.
define variable msgnbr          as   integer no-undo.
define variable call-number     like rma_ca_nbr initial " ".
define variable local-undo      as   integer no-undo.
define variable l_old_shipto    like so_ship no-undo.
define variable counter         as   integer no-undo.

define variable emt-bu-lvl    like global_part no-undo.
define variable save_part     like global_part no-undo.
define variable l-shipto      like so_ship     no-undo.
define variable msg-arg       as   character   format "x(24)" no-undo.
define variable l_edit_instat like mfc_logical initial no no-undo.

/* THESE HANDLE FIELDS ARE USED TO GIVE RMA'S DIFFERENT LABELS */

define variable l-hdl-req-date  as  handle.
define variable l-hdl-due-date  as  handle.
{&SOSOMTA1-P-TAG12}

/* SS - 110120.1 - B */
define var v_type    as char format "x(3)" label "单据类别" .
define var v_type_x  as char format "x(3)" label "单据类别" . v_type_x = "SS" .

form 
   v_type    
with frame getnbr 
row 3 
column 10
overlay 
side-labels.
setFrameLabels(frame getnbr:handle).

/* SS - 110120.1 - E */

/* Buffers */
define        buffer bill_cm       for cm_mstr.

{sobtbvar.i }    /* EMT SHARED WORKFILES AND VARIABLES */

define     shared frame a.
define new shared frame sold_to.
define new shared frame ship_to.
define new shared frame ship_to1.
define new shared frame ship_to2.
define new shared frame b.

{sosomt01.i}

/* VARIABLES FOR CONSIGNMENT INVENTORY */
{socnvars.i}
define variable procedure_id as character no-undo.
define variable ccOrder         as logical                      no-undo.

/* DETERMINE IF CUSTOMER CONSIGNMENT IS ACTIVE */
{gprun.i ""gpmfc01.p""
   "(input ENABLE_CUSTOMER_CONSIGNMENT,
     input 10,
     input ADG,
     input CUST_CONSIGN_CTRL_TABLE,
     output using_cust_consignment)"}

/* FIELD SERVICE VARIABLE'S DEFINITION */
{fsconst.i}

for first gl_ctrl
fields(gl_ar_acct gl_ar_cc gl_ar_sub)
no-lock: end. /* FOR FIRST GL_CTRL */

for first pic_ctrl
fields(pic_so_date pic_so_linpri)
no-lock: end. /* FOR FIRST PIC_CTRL */

/* THE LOCAL-UNDO VARIABLE HANDLES UNDO PROCESSING WITHIN SOSOMTA1.P */
/* AS IT HAS THE 'NO-UNDO' ATTRIBUTE, IT GETS SET TO INDICATE THE    */
/* APPROPRIATE PROCESSING FOR THE CALLING ROUTINE (SOSOMT1.P), THEN  */
/* PROCESSING DONE IN THE CURRENT TRANSACTION IS UNDONE.  IF THE     */
/* USER SUCCESSFULLY EXECUTES THE CODE IN THIS PROGRAM (AND HENCE,   */
/* NO 'UNDO' IS NECESSARY), THIS WILL BE SET TO 0 FOR SOSOMT1.P.     */

/* VALUES USED BY THIS UNDO FLAG ARE:            */
/* 1 = NEXT MAINLOOP (WITH NO UNDO)              */
/* 2 = UNDO MAINLOOP, NEXT MAINLOOP              */
/* 3 = UNDO MAINLOOP, RETRY MAINLOOP             */
/* 4 = UNDO MAINLOOP, LEAVE                      */

{&SOSOMTA1-P-TAG13}
assign
   local-undo = 4
   not_okay   = 4. /* undo mainloop, leave */

{&SOSOMTA1-P-TAG1}

for first soc_ctrl
fields(soc_all_days soc_confirm soc_cr_hold soc_det_all
       soc_fob soc_hcmmts soc_print soc_shp_lead soc_so
       soc_so_pre soc_use_btb)
no-lock: end.

if this-is-rma then do:
   /* DELETE ANY HANGING SR_WKFL'S FROM PREVIOUS RMA     */
   /* MAINTENANCE SHIPMENT/RECEIPT THAT WASN'T COMPLETED */
   for each sr_wkfl where sr_userid = mfguser
   exclusive-lock:
      delete sr_wkfl.
   end.

   /* DELETE ANY HANGING LOTW_WKFL'S FROM PREVIOUS RMA     */
   /* MAINTENANCE RECEIPT THAT WASN'T COMPLETED            */
   {gprun.i ""gplotwdl.p""}

   for first rmc_ctrl
   fields(rmc_all_days rmc_consume rmc_det_all rmc_hcmmts
          rmc_so_nbr rmc_so_pre rmc_swsa)
   no-lock: end.
end.
else
   socmmts = soc_hcmmts.

/* Form Definitions for shared frames a and b */
{sosomt02.i}

/* CREATE SOLD_TO & SHIP_TO FRAMES */
{mfadform.i "sold_to" 1 SOLD-TO}
{mfadform.i "ship_to" 41 SHIP-TO}
{mfadform.i "ship_to1" 41 SHIP-TO}
{mfadform.i "ship_to2" 41 SHIP-TO}

do with frame b:
   if this-is-rma
   then
      assign
         l-hdl-req-date       = so_req_date:handle
         l-hdl-req-date:label = getTermLabel("DUE_DATE", 8)
         l-hdl-due-date       = so_due_date:handle
         l-hdl-due-date:label = getTermLabel("DATE_EXPECTED", 8).
end.   /*DO WITH FRAME b: */

view frame a.
view frame sold_to.
view frame ship_to.
view frame b.

new_order = no.

prompt-for so_nbr with frame a
editing:

   /* ALLOW LAST SO NUMBER REFRESH */
   if keyfunction(lastkey) = "RECALL" or lastkey = 307
   then
      display
         sonbr @ so_nbr
      with frame a.

   /* IF WE'RE MAINTAINING RMA'S, NEXT/PREV ON RMA'S, */
   /* ELSE, NEXT/PREV ON SALES ORDERS.                */
   if this-is-rma then do:

      /* CHANGED THIRD PARAMETER FROM SO_FSM_TYPE = ""RMA"" TO */
      /* SO_FSM_TYPE = RMA_C                                   */
      {mfnp05.i so_mstr so_fsm_type
         "so_fsm_type = rma_c"
         so_nbr
         "input so_nbr"}
   end.
   else do:
      /* FIND NEXT/PREVIOUS RECORD - SO'S ONLY */
      {mfnp05.i so_mstr so_fsm_type
         "so_fsm_type = "" "" "
         so_nbr
         "input so_nbr"}
   end.

   if recno <> ? then do with frame b:

      {mfaddisp.i so_cust sold_to}
      {mfaddisp.i so_ship ship_to}

      display
         so_nbr
         so_cust
         so_bill
         so_ship
      with frame a.

      assign promise_date = ?
             perform_date = ?.

      for first sod_det
      fields(sod_btb_po sod_btb_pod_line sod_btb_type sod_btb_vend
             sod_line sod_nbr sod_per_date sod_qty_inv)
      where sod_nbr = so_nbr no-lock:
      end. /* FOR FIRST SOD_DET */

      if so_conf_date = ? then
         confirm = no.
      else
         confirm = yes.

      if so_slspsn[2] <> "" or
         so_slspsn[3] <> "" or
         so_slspsn[4] <> ""
      then
         mult_slspsn = true.
      else
         mult_slspsn = false.

      /* Display so_ord_date, etc in frame B */
      {sosomtdi.i}

   end. /* IF RECNO <> ? */

end. /* PROMPT-FOR SO_NBR */

do transaction on error undo, leave on endkey undo, return:

   if input so_nbr = "" then do:

      if this-is-rma then do:
         /* GET NEXT RMA NUMBER WITH PREFIX */
         {fsnctrl2.i rmc_ctrl
            rmc_so_nbr
            so_mstr
            so_nbr
            sonbr
            rmc_so_pre
            rma_mstr
            rma_prefix
            ""C""
            rma_nbr}
         for first rmc_ctrl
         fields(rmc_all_days rmc_consume rmc_det_all rmc_hcmmts
                rmc_so_nbr rmc_so_pre rmc_swsa)
         no-lock: end.
      end.   /* if this-is-rma */
      else do:
         /* GET NEXT SALES ORDER NUMBER WITH PREFIX */
         {mfnctrlc.i soc_ctrl soc_so_pre soc_so so_mstr so_nbr sonbr}
         {&SOSOMTA1-P-TAG14}

/* SS - 110120.1 - B 
    0120需求确认:7.1.1.1取消,只修改7.1.1

	view frame getnbr  .

	repeat with frame getnbr :
		update v_type with frame getnbr.
		find first code_mstr 
            where code_fldname = "so_nbr_type"
            and   code_value = v_type 
        no-lock no-error.
		if not avail code_mstr then do:
			message "错误:SO单据类型不存在,请重新输入" .
            undo,retry.
		end.
		else do:
            if code_value = v_type_x then do:
                 {xxmfnctrlc.i soc_ctrl soc_user1 soc_user2 so_mstr so_nbr sonbr}
            end.
            else do:
                 {mfnctrlc.i soc_ctrl soc_so_pre soc_so so_mstr so_nbr sonbr}
            end.
		end.
        leave .
	end.
	hide frame getnbr no-pause .

   SS - 110120.1 - E */
/* SS - 110120.1 - B */
/* SS - 110120.1 - E */

      end.   /* ELSE, THIS IS SO - GET NEXT NUMBER */

   end. /* IF INPUT SO_NBR = "" */
   else   /* TAKE SONBR AS ENTERED BY USER */
      {&SOSOMTA1-P-TAG15}
      sonbr = input so_nbr.
      {&SOSOMTA1-P-TAG16}

end.  /* DO TRANSACTION ON ERROR UNDO.. */

if sonbr = " " then
   return.

trans2:
do transaction on error undo, retry:

   old_ft_type = "".

   find so_mstr where so_nbr = sonbr exclusive-lock no-error.

   if not available so_mstr then do:
      if this-is-rma and not available rmc_ctrl then
      for first rmc_ctrl
      fields(rmc_all_days rmc_consume rmc_det_all rmc_hcmmts
             rmc_so_nbr rmc_so_pre rmc_swsa)
      no-lock: end.

      for first soc_ctrl
      fields(soc_all_days soc_confirm soc_cr_hold soc_det_all
             soc_fob soc_hcmmts soc_print soc_shp_lead soc_so
             soc_so_pre soc_use_btb)
      no-lock: end.

      clear frame sold_to.
      clear frame ship_to.
      clear frame b.

      {&SOSOMTA1-P-TAG2}

      /* ADDING NEW RECORD */
      run p-mfmsg (input 1, input 1).
      {&SOSOMTA1-P-TAG17}

      create so_mstr.
      new_order = yes.
      assign
         so_nbr       = sonbr
         so_ord_date  = today
         so_due_date  = today + soc_shp_lead
         so_print_so  = soc_print
         so_fob       = soc_fob
         confirm      = soc_confirm
         /* SET SO_PRINT_PL SO IT DOES NOT PRINT WHILE IT IS */
         /* BEING CREATED. IT IS RESET TO YES IN SOSOMTC.P   */
         so_print_pl  = no
         so_userid    = global_userid
         socmmts      = soc_hcmmts.

      /* FOR RMA'S, HEADER INFORMATION IS ALSO    */
      /*  STORED IN RMA_MSTR */
      if this-is-rma then do:
         create rma_mstr.
         assign
            rma_nbr   = sonbr
            rma_ord_date = today
            so_req_date = today + soc_shp_lead
            rma_req_date = so_req_date
            so_due_date = today
            rma_exp_date = so_due_date
            rma_prt_rec = so_print_so
            rma_prefix = "C"
            socmmts = rmc_hcmmts
            confirm = yes
            so_fsm_type = rma_c.

         if recid(rma_mstr) = -1 then .
      end.    /* if this-is-rma */

   end. /* IF NOT AVAILABLE SO_MSTR */

   else do: /* IF AVAILABLE SO_MSTR */

      /* SECONDARY SO */
      if so_secondary then do:
         /* IF SECONDARY SO AND PO CHANGE LOAD NOT YET ACKNOWLEDGED */
         /* OR PO CHANGES NOT YET ACKNOWLEDGED, THEN ERROR...      */
         if can-find(trq_mstr where trq_doc_type = "SO"
                                and trq_doc_ref  = so_nbr
                                and (trq_msg_type = "ORDRSP-S" or
                                     trq_msg_type = "ORDRSP-C"))
         then do:
            run p-mfmsg (input 2812, input 3).
            /* Modification is not allowed on Processed Secondary SO */
            if not batchrun then pause.
            not_okay = 3. /* undo mainloop, retry mainloop */
            return.
         end. /* if can-find trq_mstr */

      end.  /* secondary SO */

      /* ENSURE WE HAVE THE CORRECT ORDER TYPE */
      if (not this-is-rma and so_fsm_type <> "")
      or (this-is-rma and so_fsm_type <> rma_c)
      then do:
         if so_fsm_type = " " then
            /* THIS IS A SALES ORDER. USE SALES ORDER MAINT FOR UPDATES */
            msgnbr = 1282.
         else
         if so_fsm_type = seo_c then
            /* THIS IS A MATERIAL ORDER. USE MO MAINT FOR UPDATE */
            msgnbr = 3360.
         else
         if so_fsm_type = scontract_c then
            /* THIS IS A SERVICE CONTRACT. USE CONTRACT MAINT FOR UPDATE */
            msgnbr = 1280.
         else
         if so_fsm_type = rma_c then
            /* THIS IS AN RMA. CANNOT PROCESS */
            msgnbr = 7190.
         else
         if so_fsm_type = "PRM" then
            /* THIS IS A PRM PENDING INVOICE. CANNOT PROCESS */
            /* CHECKING FOR INVOICED CALL */
            msgnbr = 3435.
         else
         if so_fsm_type = fsmro_c then
            /* THIS IS AN INVOICED CALL. USE CALL MAINTENANCE/CAR FOR UPDATE. */
            msgnbr = 2450.
         run p-mfmsg (input msgnbr, input 3).

         local-undo = 3.
         leave trans2.      /* Nothing's been modified - no undo needed. */

      end. /* IF SO_FSM_TYPE <> "" */

      /* EDITING EXISTING RECORD */
      run p-mfmsg (input 10, input 1).

      if this-is-rma then
      for first rma_mstr
      fields(rma_cmtindx rma_contract rma_crprlist rma_ctype
             rma_cust_ven rma_enduser rma_exp_date rma_nbr
             rma_ord_date rma_prefix rma_prt_rec rma_pr_list
             rma_req_date rma_rstk_pct)
      where rma_nbr = so_nbr and
            rma_prefix = "C" no-lock:
      end. /* FOR FIRST RMA_MSTR */

      {gprun.i ""gpsiver.p""
         "(input so_site,
           input ?,
           output return_int)"}

      if return_int = 0 then do:

         display
            so_nbr
            so_cust
            so_bill
            so_ship
         with frame a.

         /* Display so_ord_date, etc with frame b */
         {sosomtdi.i}

         /* USER DOES NOT HAVE ACCESS TO THIS SITE*/
         run p-mfmsg (input 725, input 3).
         local-undo = 3.
         leave trans2.      /* Nothing's been modified - no undo needed. */

      end. /* IF RETURN_INT = 0 */

      /* CHECK FOR BATCH SHIPMENT RECORD */
      in_batch_proces = no.
      {sosrchk.i so_nbr in_batch_proces}
      if in_batch_proces then do:
         local-undo = 3.
         leave trans2.      /* Nothing's been modified - no undo needed. */
      end.

      {mfaddisp.i so_cust sold_to}
      if not available ad_mstr then do:
         hide message no-pause.
         /* CUSTOMER DOES NOT EXIST */
         run p-mfmsg (input 3, input 2).
      end. /* IF NOT AVAILABLE AD_MSTR */

      {mfaddisp.i so_ship ship_to}

      if so_conf_date = ? then
         confirm = no.
      else
         confirm = yes.

      new_order = no.

      for first ft_mstr
      fields(ft_terms ft_type)
      where ft_terms = so_fr_terms
      no-lock:
         old_ft_type = ft_type.
      end.

      if so_sched then do:
         run p-mfmsg (input 8210, input 2).
         /* ORDER WAS CREATED BY SCHEDULED ORDER MAINT */
      end.

   end. /* ELSE IF AVAILABLE SO_MSTR */

   /* FOR RMAs CONSUME FORECAST FLAG ON THE HEADER SHOULD DEFAULT */
   /* FROM RMA/RTS CONTROL FILE                                   */
   if this-is-rma then
      assign
         so-detail-all = rmc_det_all
         consume       = rmc_consume
         all_days      = rmc_all_days.
   else
      assign
         so-detail-all = soc_det_all
/* SS - 110120.1 - B 
         consume       = yes
   SS - 110120.1 - E */
/* SS - 110120.1 - B */
         consume       = /*if v_type = v_type_x */  if sonbr begins "ss" then no else yes
/* SS - 110120.1 - E */
         all_days      = soc_all_days.

   recno = recid(so_mstr).

   /* CHECK FOR COMMENTS*/
   if so_cmtindx <> 0 then
      socmmts = yes.

   display
      so_nbr
      so_cust
      so_bill
      so_ship
   with frame a.

   /* Create a record for the Sales Order Header if this is emt */
   if soc_use_btb and so_primary then do:
      {gprunp.i "soemttrg" "p" "create-temp-so-mstr"
         "(input so_nbr)"}
   end.

   assign
      promise_date = ?
      perform_date = ?
      sotrcust = so_cust.

   for first sod_det
   fields(sod_btb_po sod_btb_pod_line sod_btb_type sod_btb_vend
          sod_line sod_nbr sod_per_date sod_qty_inv)
   where sod_nbr = so_nbr
   no-lock:
   end. /* FOR FIRST SOD_DET */

   if so_slspsn[2] <> "" or
      so_slspsn[3] <> "" or
      so_slspsn[4] <> ""
   then
      mult_slspsn = true.
   else
      mult_slspsn = false.

   /* Display SO ORder Date, etc in Frame B */
   {sosomtdi.i}

   /* FOR RMA'S, THE USER MAY OPTIONALLY ATTACH A CALL */
   /* NUMBER TO THE ORDER.  CALL FSRMACA.P TO GET THAT */
   /* CALL NUMBER, AND, IF ENTERED, DEFAULT RELEVANT   */
   /* CALL FIELDS TO THE RMA BEING CREATED.            */
   if this-is-rma and new_order then do on error undo, retry:

      display so_nbr with frame a.

      {gprun.i ""fsrmaca.p""
         "(input  recid(rma_mstr),
           input  recid(so_mstr),
           output call-number)"}

      if call-number = "?" then undo, retry.

      assign
         so-detail-all = rmc_det_all.

      display
         so_ship
         so_bill
         so_cust
      with frame a.

      display
         so_po
      with frame b.

   end.    /* if this-is-rma and... */

   l_old_shipto = so_ship.

   /* GET SOLD-TO, BILL-TO, AND SHIP-TO CUSTOMER */
   /* FOR RMA'S, ALSO GET THE END USER        */
   assign
      so_recno  = recid(so_mstr)
      undo_cust = true.

   {&SOSOMTA1-P-TAG3}

/* SS - 110120.1 - B 
   {gprun.i ""sosomtcm.p""
      "(input this-is-rma,
        input recid(rma_mstr),
        input new_order)"}
   SS - 110120.1 - E */
/* SS - 110120.1 - B */
   {gprun.i ""xxsosomtcm.p""
      "(input this-is-rma,
        input recid(rma_mstr),
        input new_order)"}
/* SS - 110120.1 - E */


   if undo_cust then do:
      local-undo = 3.
      undo trans2, leave.  /* MUST UNDO CREATION OF SO_MSTR */
   end. /* IF UNDO_CUST */

   {&SOSOMTA1-P-TAG4}

   /* SHIP-TO CANNOT BE CHANGED; QUANTITY TO INVOICE EXISTS */
   if l_old_shipto <> "" and
      l_old_shipto <> so_ship
   then do:
      if can-find(first sod_det where sod_nbr = so_nbr and
                                      sod_qty_inv <> 0 )
      then do:
         /* OUTSTANDING QUANTITY TO INVOICE; SHIP-TO TAXES CANNOT BE UPDATED */
         run p-mfmsg (input 2363, input 4).
         display
            l_old_shipto @ so_ship
         with frame a.
         local-undo = 3.
         undo trans2, leave trans2.
      end. /* IF CAN-FIND FIRST SOD_DET */
   end. /* IF SHIP-TO IS CHANGED IN GTM */

   /* WHEN CREATING A NEW RMA, SOSOMTCM.P LOADS IN THE DEFAULT    */
   /* END USER (THE CUSTOMER), AND ALLOWS THE USER TO CHANGE IT.  */
   /* IF HE F4-ED OUT OF SOSOMTCM.P, THEN, RMA_ENDUSER GETS       */
   /* UNDONE AND LEFT BLANK, SO, FIX IT HERE...                   */
   if this-is-rma and new_order then do:

      if rma_enduser = "" then
         assign
            rma_enduser = so_cust
            rma_cust_ven = so_cust.

      for first eu_mstr
      fields(eu_addr eu_type)
      where eu_addr = rma_enduser
      no-lock: end.

      /* IF USER DIDN'T ATTACH A CALL TO THIS RMA */
      /* (AND DEFAULT SOME OF THE CALL FIELDS     */
      /* INTO THIS NEW ORDER), THEN OPTIONALLY    */
      /* DISPLAY SERVICE CONTRACTS FOR THIS END   */
      /* USER.                                    */
      if call-number = " " then do:
         {gprun.i ""fsrmasv.p""
            "(input      rma_enduser,
              input        eu_type,
              input        rmc_swsa,
              input-output rma_contract,
              input-output rma_ctype,
              input-output rma_crprlist,
              input-output rma_pr_list,
              input-output rma_rstk_pct)"}
      end.    /* if call-number = " " */

   end.    /* if this-is-rma and new_order */

   /* SHIP-TO CHANGED; UPDATE TAX DATA ON CONFIRMATION. PREVIOUS */
   /* HEADER TAX ENVIRONMENT BLANKED OUT FOR RECALCULATION LATER */
   {&SOSOMTA1-P-TAG10}
   l_edittax = no.

   if not batchrun and
      l_old_shipto <> "" and
      l_old_shipto <> so_ship
   then do:

      /* ADDED CHECK FOR UPDATION OF INTRASTAT RECORDS WHEN */
      /* THE CHANGED SHIP-TO HAS A DIFFERENT COUNTRY        */

      for first iec_ctrl
         fields (iec_use_instat)
         where iec_use_instat = yes
         no-lock:
      end. /* FOR FIRST iec_ctrl */

      if available iec_ctrl
      then do:

         if can-find (ie_mstr where ie_type = "1"
                                and ie_nbr  = so_mstr.so_nbr)
         then do:

            /* SHIP-TO CHANGED; UPDATE COUNTRY OF */
            /* DEST/DISP FOR INTRASTAT?           */
            {pxmsg.i &MSGNUM=6084
                     &ERRORLEVEL=1
                     &CONFIRM=l_edit_instat}
         end. /* IF CAN-FIND (ie_mstr... */

         if l_edit_instat = yes
         then do:

            for first ad_mstr
               fields (ad_addr ad_ctry)
               where ad_addr = so_mstr.so_ship
               no-lock:

               for first ie_mstr
                  where ie_type = "1"
                  and   ie_nbr  = so_mstr.so_nbr
                  exclusive-lock:

                  ie_ctry_desdisp = ad_ctry.

                  for each ied_det
                     where ied_type = "1"
                     and   ied_nbr  = sod_det.sod_nbr
                     exclusive-lock:
                     ied_ctry_desdisp = ad_ctry.
                  end. /* FOR EACH ied_det */

               end. /* FOR FIRST ie_mstr */

            end. /* FOR FIRST ad_mstr */

         end. /* IF l_edit_instat = yes */

      end. /* IF AVAILABLE iec_ctrl */

      /* SHIP-TO CHANGED; UPDATE TAX DATA? */
      {pxmsg.i &MSGNUM=2351 &ERRORLEVEL=1 &CONFIRM=l_edittax}

      if l_edittax then do:

         /* LOAD DEFAULT TAX CLASS & USAGE */
         for first ad_mstr
         fields(ad_addr ad_city ad_country ad_edi_ctrl ad_inv_mthd
                ad_lang ad_line1 ad_line2 ad_name ad_pst_id ad_ctry
                ad_state ad_taxable ad_taxc ad_tax_in ad_tax_usage ad_zip)
         where ad_addr = so_ship no-lock:
            assign
               so_taxable   = ad_taxable
               so_tax_usage = ad_tax_usage
               so_taxc = ad_taxc.
         end. /* FOR FIRST AD_MSTR */

         if not available ad_mstr then
         for first ad_mstr
         fields(ad_addr ad_city ad_country ad_edi_ctrl
                ad_inv_mthd ad_lang ad_line1 ad_line2 ad_name ad_ctry
                ad_pst_id ad_state ad_taxable ad_taxc ad_tax_in
                ad_tax_usage ad_zip)
         where ad_addr = so_cust no-lock:
               assign
                  so_taxable   = ad_taxable
                  so_tax_usage = ad_tax_usage
                  so_taxc = ad_taxc.
         end. /* FOR FIRST AD_MSTR */

         so_tax_env = "".

      end.  /* IF l_edittax IS TRUE */

   end. /* IF SHIP-TO CHANGED IN GTM AND NOT BATCHRUN */

   for first cm_mstr
   fields(cm_addr cm_ar_acct cm_ar_cc cm_ar_sub cm_balance cm_cr_hold
          cm_cr_limit cm_cr_terms cm_curr cm_disc_pct cm_fix_pr
          cm_fr_list cm_fr_min_wt cm_fr_terms cm_fst_id cm_lang
          cm_partial cm_pst cm_rmks cm_shipvia cm_site cm_slspsn
            /* SS - 110120.1 - B */
             cm__chr01
            /* SS - 110120.1 - E */

          cm_taxable cm_taxc cm_tax_in)
   where cm_mstr.cm_addr = so_cust no-lock:
   end. /* FOR FIRST CM_MSTR */

   for first bill_cm
   fields(cm_addr cm_ar_acct cm_ar_cc cm_ar_sub cm_balance cm_cr_hold
          cm_cr_limit cm_cr_terms cm_curr cm_disc_pct cm_fix_pr
          cm_fr_list cm_fr_min_wt cm_fr_terms cm_fst_id cm_partial
          cm_pst cm_rmks cm_shipvia cm_site cm_slspsn cm_taxable
          cm_taxc cm_tax_in)
   where bill_cm.cm_addr = so_bill no-lock:
   end. /* FOR FIRST BILL_CM */

   for first ad_mstr
   fields(ad_addr ad_city ad_country ad_edi_ctrl
          ad_inv_mthd ad_lang ad_line1 ad_line2 ad_name ad_ctry
          ad_pst_id ad_state ad_taxable ad_taxc ad_tax_in
          ad_tax_usage ad_zip)
   where ad_addr = so_bill no-lock:
   end. /* FOR FIRST AD_MSTR */

   if ad_inv_mthd = "" then do:

      for first ad_mstr
      fields(ad_addr ad_city ad_country ad_edi_ctrl
             ad_inv_mthd ad_lang ad_line1 ad_line2 ad_name ad_ctry
             ad_pst_id ad_state ad_taxable ad_taxc ad_tax_in
             ad_tax_usage ad_zip)
      where ad_addr = so_ship no-lock:
      end. /* FOR FIRST AD_MSTR */

      if ad_inv_mthd = "" then
      for first ad_mstr
      fields(ad_addr ad_city ad_country ad_edi_ctrl
             ad_inv_mthd ad_lang ad_line1 ad_line2 ad_name ad_ctry
             ad_pst_id ad_state ad_taxable ad_taxc ad_tax_in
             ad_tax_usage ad_zip)
      where ad_addr = so_cust no-lock:
      end. /* FOR FIRST AD_MSTR */

   end. /* IF AD_INV_MTHD = "" */

   if new_order then
      so_inv_mthd = ad_inv_mthd.

   if new_order then
      substring(so_inv_mthd,3,1) = substring(ad_edi_ctrl[5],1,1).

   /*SET CUSTOMER VARIABLE USED BY PRICING ROUTINE gppibx.p*/
   picust = so_cust.
   if so_cust <> so_ship and
      can-find(cm_mstr where cm_mstr.cm_addr = so_ship)
   then
      picust = so_ship.

   {&SOSOMTA1-P-TAG11}
   if new_order then
      line_pricing = pic_so_linpri.
   else
      line_pricing = no.

   order-header:
   do on error undo, retry with frame b:

      ststatus = stline[2].
      status input ststatus.
      del-yn = no.

      /* SET DEFAULTS WHEN CREATING A NEW ORDER - */
      /* USE SHIP-TO CUSTOMER INFO FOR DEFAULT IF */
      /* AVAILABLE ELSE USE SOLD-TO INFO          */
      {&SOSOMTA1-P-TAG5}
      if new so_mstr then do:
         {&SOSOMTA1-P-TAG6}

         run assign_new_so.

         assign
            so_cr_terms = bill_cm.cm_cr_terms
            so_curr     = bill_cm.cm_curr
            so_fix_pr   = cm_mstr.cm_fix_pr
            so_disc_pct = cm_mstr.cm_disc_pct
            so_shipvia  = cm_mstr.cm_shipvia
            so_partial  = cm_mstr.cm_partial
            so_rmks     = cm_mstr.cm_rmks
            so_site     = cm_mstr.cm_site

            so_channel  = if so_site = "NKSA" then "DO" else ""   /* SS - 110120.1 */

            so_taxable  = cm_mstr.cm_taxable
            so_taxc     = cm_mstr.cm_taxc
            so_pst      = cm_mstr.cm_pst
            so_fst_id   = cm_mstr.cm_fst_id
            so_pst_id   = ad_pst_id   /*ship-to*/
            so_fr_list   = cm_mstr.cm_fr_list
            so_fr_terms  = cm_mstr.cm_fr_terms
            so_fr_min_wt = cm_mstr.cm_fr_min_wt
            so_userid    = global_userid.

         {gprun.i ""gpsiver.p""
            "(input so_site,
              input ?,
              output return_int)"}

         if return_int = 0 then do:
            /* USER DOESN'T HAVE ACCESS TO DEFAULT SITE XXXX    */
            {pxmsg.i &MSGNUM=2711 &ERRORLEVEL=2 &MSGARG1=so_site}
            so_site = "".
            display so_site with frame b.
         end.

         /* GET DEFAULT TERMS INTEREST FOR ORDER */
         socrt_int = 0.
         if so_cr_terms <> "" then do:
            for first ct_mstr
            fields(ct_code ct_terms_int)
            where ct_code = so_cr_terms no-lock:
               socrt_int = ct_terms_int.
            end. /* FOR FIRST CT_MSTR */
         end. /* SO_CR_TERMS <> "" */

         /* SET NEW TAX DEFAULTS FOR GLOBAL TAX */
         /* LOAD DEFAULT TAX CLASS & USAGE */
         for first ad_mstr
         fields(ad_addr ad_city ad_country ad_edi_ctrl ad_inv_mthd
                ad_lang ad_line1 ad_line2 ad_name ad_pst_id ad_ctry
                ad_state ad_taxable ad_taxc ad_tax_in ad_tax_usage ad_zip)
         where ad_addr = so_ship no-lock:
         end. /* FOR FIRST AD_MSTR */

         if not available ad_mstr then
         for first ad_mstr
         fields(ad_addr ad_city ad_country ad_edi_ctrl ad_inv_mthd
                ad_lang ad_line1 ad_line2 ad_name ad_pst_id ad_ctry
                ad_state ad_taxable ad_taxc ad_tax_in ad_tax_usage ad_zip)
         where ad_addr = so_cust no-lock:
         end. /* FOR FIRST AD_MSTR */

         if available ad_mstr then
            assign
               so_taxable   = ad_taxable
               so_tax_usage = ad_tax_usage
               so_taxc      = ad_taxc.

         /* SET DEFAULTS FOR ALL FOUR SALESPERSONS. */
         do counter = 1 to 4:

            so_slspsn[counter] = cm_mstr.cm_slspsn[counter].

            if cm_mstr.cm_slspsn[counter] <> "" then do:

               for first spd_det
               fields(spd_addr spd_comm_pct spd_cust spd_part spd_prod_ln)
               where spd_addr     = so_slspsn[counter]
                 and spd_prod_ln  = ""
                 and spd_part     = ""
                 and spd_cust = cm_mstr.cm_addr
               no-lock:
                  so_comm_pct[counter] = spd_comm_pct.
               end. /* FOR FIRST SPD_DET */

               if not available spd_det then
               for first sp_mstr
               fields(sp_addr sp_comm_pct)
               where sp_addr = cm_mstr.cm_slspsn[counter] no-lock:
                  so_comm_pct[counter] = sp_comm_pct.
               end. /* FOR FIRST SP_MSTR */

            end. /* IF CM_MSTR.CM_SLSPSN[CTR] <> "" */

         end. /* DO COUNTER = 1 TO 4 */

         if so_slspsn[2] <> "" or
            so_slspsn[3] <> "" or
            so_slspsn[4] <> ""
         then
            mult_slspsn = true.
         else
            mult_slspsn = false.

         if bill_cm.cm_ar_acct <> "" then
            assign
               so_ar_acct = bill_cm.cm_ar_acct
               so_ar_sub  = bill_cm.cm_ar_sub
               so_ar_cc   = bill_cm.cm_ar_cc.
         else
            assign
               so_ar_acct = gl_ar_acct
               so_ar_sub  = gl_ar_sub
               so_ar_cc   = gl_ar_cc.

      end.  /* SET DEFAULTS IF NEW SO_MSTR */

      /* INITIALIZE TRANSPORT DAYS FROM          */
      /* DELIVERY TRANSIT LEAD-TIME (2.16.1).    */
      if available ad_mstr then do:

            {pxrun.i &PROC='getDefaultTransitLTDays'
                     &PROGRAM='sosoxr.p'
                     &HANDLE=ph_sosoxr
                     &PARAM="(input so_site,
                              input ad_ctry,
                              input ad_state,
                              input ad_city,
                              input """",
                              output translt_days)" }
            substring(so_conrep,2,6) = string(translt_days,"999.99").
      end.  /* if available ad_mstr */

      /* LOAD DEFAULT TAX CLASS & USAGE */
      for first ad_mstr
      fields(ad_addr ad_city ad_country ad_edi_ctrl ad_inv_mthd
             ad_lang ad_line1 ad_line2 ad_name ad_pst_id ad_ctry
             ad_state ad_taxable ad_taxc ad_tax_in ad_tax_usage ad_zip)
      where ad_addr = so_ship no-lock:
      end. /* FOR FIRST AD_MSTR */

      if not available ad_mstr then
      for first ad_mstr
      fields(ad_addr ad_city ad_country ad_edi_ctrl ad_inv_mthd
             ad_lang ad_line1 ad_line2 ad_name ad_pst_id ad_ctry
             ad_state ad_taxable ad_taxc ad_tax_in ad_tax_usage ad_zip)
      where ad_addr = so_cust no-lock:
      end. /* FOR FIRST AD_MSTR */

      if available(ad_mstr) then
         tax_in  = ad_tax_in.

      if not new so_mstr and so_invoiced = yes then do:
         run p-mfmsg (input 603, input 2).
         /* INVOICE PRINTED BUT NOT POSTED, PRESS ENTER TO CONTINUE */
         if not batchrun then pause.
      end. /* IF NOT NEW SO_MSTR AND SO_INVOICED = YES */

      if this-is-rma then do:

         for first svc_ctrl
         fields(svc_hold_call)
         no-lock: end.

         assign
            rma_bill_to = so_bill
            rma_ship    = so_ship.

      end. /* IF this-is-rma */

      /* FIND OUT IF THIS IS A CREDITCARD SO */
      ccOrder = can-find(first qad_wkfl
                      where qad_key1
                      begins string(so_nbr, "x(8)")
                      and qad_key2 = "creditcard").

      /* CHECK CREDIT LIMIT */
      if ((bill_cm.cm_cr_limit < bill_cm.cm_balance)
      and not(ccOrder))
      then do:

         if this-is-rma then do:

            if svc_hold_call = 1 then do:
               /* CUSTOMER BALANCE */
               msg-arg = string(bill_cm.cm_balance,balance_fmt).
               {pxmsg.i &MSGNUM=615 &ERRORLEVEL=2 &MSGARG1=msg-arg}
               /* CREDIT LIMIT */
               msg-arg = string(bill_cm.cm_cr_limit,limit_fmt).
               {pxmsg.i  &MSGNUM=617 &ERRORLEVEL=1 &MSGARG1=msg-arg}
               if so_stat = "" then do:
                  /* RMA ORDER PLACED ON CREDIT HOLD */
                  msg-arg = "RMA Order".
                  {pxmsg.i &MSGNUM=690 &ERRORLEVEL=1 &MSGARG1=msg-arg}
                  assign
                     so_stat = "HD".
               end. /* IF SO_STAT = "" */
            end. /* IF SVC_HOLD_CALL = 1 */

            if svc_hold_call = 2 then do:
               /* CUSTOMER BALANCE */
               msg-arg = string(bill_cm.cm_balance,balance_fmt).
               {pxmsg.i &MSGNUM=615 &ERRORLEVEL=4 &MSGARG1=msg-arg}
               /* CREDIT LIMIT */
               msg-arg = string(bill_cm.cm_cr_limit,limit_fmt).
               {pxmsg.i  &MSGNUM=617 &ERRORLEVEL=1 &MSGARG1=msg-arg}
               assign local-undo = 2.
               undo trans2, leave.     /* MUST UNDO RMA CREATION */
            end. /* IF SVC_HOLD_CALL = 2 */

         end. /* IF THIS-IS-RMA */
         else do:
            /* CUSTOMER BALANCE */
            msg-arg = string(bill_cm.cm_balance,balance_fmt).
            {pxmsg.i &MSGNUM=615 &ERRORLEVEL=2 &MSGARG1=msg-arg}
            /* CREDIT LIMIT */
            msg-arg = string(bill_cm.cm_cr_limit,limit_fmt).
            {pxmsg.i  &MSGNUM=617 &ERRORLEVEL=1 &MSGARG1=msg-arg}
         end. /* ELSE DO */
      end. /* IF CM_CR_LIMIT < CM_BALANCE */

      /* CHECK CREDIT HOLD */
      if new so_mstr and bill_cm.cm_cr_hold  then do:

         if this-is-rma then do:

            if svc_hold_call = 1 then do:
               run p-mfmsg (input 614, input 2).
               /* CUSTOMER ON CREDIT HOLD */
               so_stat = "HD".
            end.
            else if svc_hold_call = 2 then do:
               run p-mfmsg (input 614, input 3).
               local-undo = 2.
               undo trans2, leave.     /* MUST UNDO RMA CREATION */
            end.
         end.    /* if this-is-rma */
         else do:
            run p-mfmsg (input 614, input 2).
            so_stat = "HD".
         end.    /* else, this isn't an RMA */
      end.

      if this-is-rma then
         rma-recno = recid(rma_mstr).
      else
         rma-recno = ?.

      /* UPDATE FRAME B - HEADER, TAX, SLSPSNS, FRT, ALLOCS */
      {sosomtdi.i} /* DISPLAY SO_ORD_DATE, ETC IN FRAME B */

      /* IF USING CUSTOMER CONSIGNMENT THEN INITIALIZE THE SALES */
      /* ORDER MASTER CONSIGNMENT RECORD.                        */
      if  new so_mstr
      and using_cust_consignment
      then do:
         procedure_id = "init".
           {gprunmo.i
              &program=""socnso.p""
              &module="ACN"
              &param= """(input procedure_id,
                          input so_nbr,
                          input so_ship,
                          input so_site,
                          input no)"""}

      end. /*IF new so_mstr AND using_cust_consignment */

      undo_flag = true.

      {gprun.i ""sosomtp.p""
               "(input this-is-rma,
                 input using_cust_consignment)"}

      /* IF UNDO_FLAG THEN NEXT MAINLOOP (IN SOSOMT.P). */
      /* JUMP OUT IF S.O. WAS (SUCCESSFULLY) DELETED */
      if not can-find(so_mstr where so_nbr = input so_nbr)
      then do:
         local-undo = 1.
         leave trans2.     /* SO'S ALREADY BEEN DELETED - NOTHING TO UNDO */
      end. /* IF NOT CAN-FIND(SO_MSTR..) */
      if undo_flag then do:
         local-undo = 2.
         undo trans2, leave.  /* AN UNKNOWN ERROR OCCURRED NEEDING UNDO. */
      end. /* IF UNDO_FLAG */

      if (oldcurr <> so_curr) or oldcurr = "" then do:
         /* SET CURRENCY DEPENDENT FORMATS */
         {socurfmt.i}
         /* SET THE CURRENCY DEPENDENT FORMAT FOR PREPAID */
         prepaid_fmt = prepaid_old.
         {gprun.i ""gpcurfmt.p"" "(input-output prepaid_fmt,
                                   input rndmthd)"}
         oldcurr = so_curr.
      end. /* IF OLDCURR <> SO_CURR */

      /* FOR RMAs,IF THE HEADER PERFORM DATE (perform_date) is LEFT */
      /* BLANK, SET IT TO THE HEADER DUE DATE (so_req_date)         */
      if perform_date = ? then do :
         if this-is-rma then
            perform_date = so_req_date.
         else
            perform_date = so_due_date.
      end. /* If perform_date = ? */

      if so_req_date = ? then
         so_req_date = so_due_date.

      if so_fsm_type <> "" and so_pricing_dt = ? then
         so_pricing_dt = so_ord_date.

      if so_pricing_dt = ? then do:
         if pic_so_date = "ord_date" then
            so_pricing_dt = so_ord_date.
         else
         if pic_so_date = "req_date" then
            so_pricing_dt = so_req_date.
         else
         if pic_so_date = "per_date" then
            so_pricing_dt = perform_date.
         else
         if pic_so_date = "prm_date" then
            so_pricing_dt = promise_date.
         else
         if pic_so_date = "due_date" then
            so_pricing_dt = so_due_date.
         else
            so_pricing_dt = today.
      end. /* IF SO_PRICING_DT = ? */

      if this-is-rma then do:
         /* LET USER ENTER OTHER RMA-HEADER-SPECIFIC FIELDS */
         {gprun.i ""fsrmah1.p""
         "(input rma-recno,
           input recid(so_mstr),
           input new_order,
           output undo_flag)"}
         if undo_flag then
            undo order-header, retry order-header.
      end. /* if this-is-rma */

   end. /* ORDER HEADER */

   if rebook_lines then do:
      {gprun.i ""sosomtrb.p""}
      rebook_lines = false.
   end.

   /* DETAIL - FIND LAST LINE */
   line = 0.

   for last sod_det
   fields(sod_btb_po sod_btb_pod_line sod_btb_type sod_btb_vend
          sod_line sod_nbr sod_per_date sod_qty_inv)
   where sod_nbr = so_mstr.so_nbr
   use-index sod_nbrln no-lock:
      line = sod_line.
   end. /* FOR LAST SOD_DET */

   /* Check for custom program set up in menu system */
   if this-is-rma then do:
      {fsmnp02.i ""fsrmamt.p"" 10 """(input so_recno, input rma-recno)"""}
   end.
   else do:
      {fsmnp02.i ""sosomt.p"" 10 """(input so_recno)"""}
   end.

   /* If EMT, determine the Comment Type */
   run determine-bu-lvl
      (output emt-bu-lvl).

   /* COMMENTS */
   assign
      global_lang = so_mstr.so_lang
      global_type = "".

   if socmmts = yes then do:
      assign
         cmtindx    = so_mstr.so_cmtindx
         global_ref = so_mstr.so_cust
         save_part  = global_part
         global_part = emt-bu-lvl.
      {gprun.i ""gpcmmt01.p"" "(input ""so_mstr"")"}
      assign
         so_mstr.so_cmtindx = cmtindx
         global_part = save_part.
      if this-is-rma then
          rma_mstr.rma_cmtindx = cmtindx.
   end. /* IF SOCMMTS = YES */

   /* GET SHIP-TO NUMBER IF CREATING NEW SHIP-TO */
   if so_mstr.so_ship = "qadtemp" + mfguser then do:
      run create-new-shipto
         (output l-shipto).
      so_mstr.so_ship = l-shipto.
   end. /* IF SO_SHIP = "qadtemp" + MFGUSER */

   /* IF THEY'VE MADE IT TO HERE, ALL IS WELL */
   local-undo = 0.

end. /* DO TRANSACTION #2 */

if local-undo = 0 then do:
   /*INITIALIZE QTY ACCUMULATION WORKFILES USED BY BEST PRICING*/
   {gprun.i ""gppiqty1.p"" "(input ""1"",
                    input so_mstr.so_nbr,
                    input yes,
                    input yes)"}
end.  /* if local-undo = 0 */

{&SOSOMTA1-P-TAG7}

hide frame sold_to no-pause.
hide frame ship_to no-pause.
hide frame ship_to1 no-pause.
hide frame ship_to2 no-pause.
hide frame b1 no-pause.
hide frame b no-pause.
hide frame a no-pause.
{&SOSOMTA1-P-TAG8}
not_okay = local-undo.
{&SOSOMTA1-P-TAG9}

PROCEDURE p-mfmsg:
/* ------------------------------------------------------------------
   Purpose:     Display Error Messages
   Parameters:  l_num = Message Number
                l_stat = Severity
   Notes:
   ------------------------------------------------------------------*/
   define input parameter l_num  as integer no-undo.
   define input parameter l_stat as integer no-undo.

   {pxmsg.i &MSGNUM=l_num &ERRORLEVEL=l_stat}

END PROCEDURE. /* PROCEDURE P-MFMSG */

PROCEDURE assign_new_so:
/* ------------------------------------------------------------------
   Purpose:
   Parameters:  <None>
   Notes:
   ------------------------------------------------------------------*/

   if so_mstr.so_cust <> so_mstr.so_ship
   then do:

      if can-find(cm_mstr where cm_mstr.cm_addr = so_ship)
      then do:
         for first cm_mstr
         fields(cm_addr cm_ar_acct cm_ar_cc cm_ar_sub cm_balance
                cm_cr_hold cm_cr_limit cm_cr_terms cm_curr
                cm_disc_pct cm_fix_pr cm_fr_list cm_fr_min_wt
                cm_fr_terms cm_fst_id cm_lang cm_partial cm_pst
                cm_rmks cm_shipvia cm_site cm_slspsn cm_taxable
            /* SS - 110120.1 - B */
             cm__chr01
            /* SS - 110120.1 - E */

                cm_taxc cm_tax_in)
         where cm_mstr.cm_addr = so_mstr.so_ship no-lock:
         end. /* FOR FIRST cm_mstr */
         so_mstr.so_lang = cm_mstr.cm_lang.
      end. /* IF CAN-FIND */

      else do:
         for first ad_mstr
         fields(ad_addr ad_city ad_country ad_edi_ctrl
                ad_inv_mthd ad_lang ad_line1 ad_line2 ad_name ad_ctry
                ad_pst_id ad_state ad_taxable ad_taxc ad_tax_in
                ad_tax_usage ad_zip)
         where ad_addr = so_mstr.so_ship no-lock:
         end. /* FOR FIRST ad_mstr */
         so_mstr.so_lang = ad_lang.
      end. /* ELSE DO */

   end. /* IF so_cust <> so_ship */
   else
      so_mstr.so_lang = cm_mstr.cm_lang.

END PROCEDURE.

PROCEDURE determine-bu-lvl:
/* ------------------------------------------------------------------
   Purpose:     Get EMT Business Level
   Parameters:  p-emt-bu-level Business Unit Level
   Notes:
   ------------------------------------------------------------------*/
   define output parameter p-emt-bu-lvl like global_part.

   p-emt-bu-lvl = "".

   if soc_ctrl.soc_use_btb then do:
      if so_mstr.so_primary and not so_mstr.so_secondary then
         p-emt-bu-lvl = "PBU".
      else if so_mstr.so_primary and so_mstr.so_secondary then
         p-emt-bu-lvl = "MBU".
      else if so_mstr.so_secondary then
         p-emt-bu-lvl = "SBU".
   end.

END PROCEDURE.

PROCEDURE create-new-shipto:
/* ------------------------------------------------------------------
   Purpose:     Create a new ship to record
   Parameters:  <None>
   Notes:
   ------------------------------------------------------------------*/
   define output parameter p-shipto like so_mstr.so_ship.

   find ad_mstr where ad_addr = "qadtemp" + mfguser exclusive-lock.

   /* Get Next Record Number */
   {mfactrl.i cmc_ctrl cmc_nbr ad_mstr ad_addr p-shipto}

   ad_addr = p-shipto.

   create ls_mstr.
   assign
      ls_type = "ship-to"
      ls_addr = p-shipto.

   if recid(ls_mstr) = -1 then.

   /* Ship-To Record Added */
   {pxmsg.i &MSGNUM=638 &ERRORLEVEL=1 &MSGARG1=p-shipto}

END PROCEDURE.
