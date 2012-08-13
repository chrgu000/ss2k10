/* pppsmt02.p - PART SITE PLANNING MAINTENANCE                              */
/* Copyright 1986-2003 QAD Inc., Carpinteria, CA, USA.                      */
/* All rights reserved worldwide.  This is an unpublished work.             */
/* $Revision: 1.22.2.8.3.1 $                                               */
/*V8:ConvertMode=Maintenance                                                */
/* REVISION: 6.0      LAST MODIFIED: 07/31/90   BY: emb                     */
/* REVISION: 6.0      LAST MODIFIED: 10/31/90   BY: emb *D158*              */
/* REVISION: 6.0      LAST MODIFIED: 02/18/91   BY: emb *D342*              */
/* REVISION: 6.0      LAST MODIFIED: 02/18/91   BY: emb *D357*              */
/* REVISION: 7.0      LAST MODIFIED: 02/20/92   BY: emb *F227*              */
/* REVISION: 7.0      LAST MODIFIED: 07/24/92   BY: pma *F782*              */
/* REVISION: 7.0      LAST MODIFIED: 11/09/92   BY: pma *G299*              */
/* REVISION: 7.3      LAST MODIFIED: 06/15/93   BY: qzl *GC15*              */
/* REVISION: 7.3      LAST MODIFIED: 07/29/93   BY: emb *GD82*              */
/* REVISION: 7.3      LAST MODIFIED: 08/12/93   BY: ram *GE15*              */
/* REVISION: 7.3      LAST MODIFIED: 11/19/93   BY: pxd *GH42*              */
/* REVISION: 7.3      LAST MODIFIED: 02/03/94   BY: ais *FL79*              */
/* REVISION: 7.3      LAST MODIFIED: 02/03/94   BY: pxd *FM16*              */
/* REVISION: 7.3      LAST MODIFIED: 02/15/94   BY: pxd *FL60*              */
/* REVISION: 7.3      LAST MODIFIED: 06/28/94   BY: pxd *FP14*              */
/*           7.3                     09/03/94   BY: bcm *GL93*              */
/*           7.3                     09/11/94   BY: rmh *GM19*              */
/* REVISION: 8.5      LAST MODIFIED: 10/16/94   BY: dzs *J005*              */
/* REVISION: 8.5      LAST MODIFIED: 10/17/94   BY: mwd *J034*              */
/*           7.3                     11/06/94   BY: rwl *GO27*              */
/* REVISION: 7.3      LAST MODIFIED: 12/20/94   BY: ais *F0B7*              */
/* REVISION: 7.3      LAST MODIFIED: 03/16/95   BY: pxd *F0NB*              */
/* REVISION: 7.2      LAST MODIFIED: 05/04/95   BY: qzl *F0R6*              */
/* REVISION: 8.5      LAST MODIFIED: 08/25/95   BY: tjs *J070*              */
/* REVISION: 7.2      LAST MODIFIED: 05/31/95   BY: qzl *F0SK*              */
/* REVISION: 7.3      LAST MODIFIED: 01/24/96   BY: bcm *G1KV*              */
/* REVISION: 8.5      LAST MODIFIED: 03/09/96   BY: jxz *J078*              */
/* REVISION: 8.6      LAST MODIFIED: 10/11/96   BY: flm *K003*              */
/* REVISION: 8.6      LAST MODIFIED: 10/22/96   BY: *K004* Kurt De Wit      */
/* REVISION: 8.6      LAST MODIFIED: 12/05/96   BY: *G2HJ* Murli Shastri    */
/* REVISION: 8.6      LAST MODIFIED: 12/13/96   BY: *J1BZ* Russ Witt        */
/* REVISION: 8.6      LAST MODIFIED: 02/28/97   BY: *J1JQ* Murli Shastri    */
/* REVISION: 8.6      LAST MODIFIED: 05/22/97   BY: *K0D8* Arul Victoria    */
/* REVISION: 8.6      LAST MODIFIED: 06/03/97   BY: *K0G1* Arul Victoria    */
/* REVISION: 8.6      LAST MODIFIED: 06/24/97   BY: *K0DH* Arul Victoria    */
/* REVISION: 8.6      LAST MODIFIED: 09/30/97   BY: *K0H6* Joe Gawel        */
/* REVISION: 8.6      LAST MODIFIED: 10/10/97   BY: *J1PS* Felcy D'Souza    */
/* REVISION: 8.6      LAST MODIFIED: 11/20/97   BY: *K19Y* Manmohan Pardesi */
/* REVISION: 8.6      LAST MODIFIED: 12/08/97   BY: *J27P* Thomas Fernandes */
/* REVISION: 8.6      LAST MODIFIED: 01/16/98   BY: *K1BL* Bryan Merich     */

/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane        */
/* REVISION: 8.6E     LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan       */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan       */
/* REVISION: 9.1      LAST MODIFIED: 06/07/99   BY: *N005* David Morris     */
/* REVISION: 9.1      LAST MODIFIED: 06/17/99   BY: *N00J* Russ Witt        */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane */
/* REVISION: 9.1      LAST MODIFIED: 08/08/00   BY: *M0QW* Falguni Dalal    */
/* REVISION: 9.1      LAST MODIFIED: 08/13/00   BY: *N0KQ* myb              */
/* REVISION: 9.1      LAST MODIFIED: 01/23/01   BY: *M10F* Mark Christian   */
/* Old ECO marker removed, but no ECO header exists *F0PN*               */
/* Revision: 1.22.2.7       BY: Russ Witt       DATE: 09/21/01 ECO: *P01H*    */
/* Revision: 1.22.2.8       BY: Zheng Huang     DATE: 01/31/02 ECO: *P000*    */
/* $Revision: 1.22.2.8.3.1 $    BY: Shivanand H.    DATE: 12/12/03 ECO: *P1FW*    */

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/
/* REVISION: 8.5      LAST MODIFIED: 10/20/03   BY: Kevin               */
/*specification develop by kevin doc speccificationv3.1                 */
/* REVISION:eb2+sp7 retrofit by taofengqin date: 06/22/05               */

/*FL60*/ {mfdtitle.i "2+ "}

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE pppsmt02_p_1 "Auto EMT Processing"
/* MaxLen: Comment: */

&SCOPED-DEFINE pppsmt02_p_2 " Item Planning Data "
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */

define variable yn like mfc_logical no-undo.
define variable del-yn like mfc_logical no-undo.
define variable part like ptp_part no-undo.
define variable site like ptp_site no-undo.
define variable ptp_recno as recid no-undo.

define variable ps-recno as recid no-undo.
define variable bom_code like ptp_bom_code no-undo.
define variable drp_mrp as logical initial no no-undo.

define variable ptp_bom_codesv like ptp_bom_code no-undo.
define variable ptp_pm_codesv  like ptp_pm_code no-undo.
define variable ptp_networksv  like ptp_network no-undo.

define variable ptp_ord_polsv like ptp_ord_pol initial "xyz" no-undo.
define variable cfg like ptp_cfg_type format "x(3)" no-undo.
define variable cfglabel as character format "x(24)" label ""
   no-undo.
define variable cfgcode as character format "x(1)" no-undo.
define variable valid_mnemonic like mfc_logical no-undo.
define variable valid_lngd like mfc_logical no-undo.

define variable btb-type       like pt_btb_type
   format "x(8)" no-undo.
define variable btb-type-desc  like glt_desc     no-undo.
define variable isvalid        like mfc_logical.
define variable btb-type-code  like pt_btb_type no-undo.
define variable atp-type-code  like ptp_atp_enforcement no-undo.
define variable atp-enforcement   like ptp_atp_enforcement
   format "x(8)"  label "ATP Enforce"  no-undo.
define variable atp-enforce-desc like glt_desc     no-undo.
define variable inrecno as recid no-undo.

define new shared variable fname      like lngd_dataset no-undo
   initial "EMT".

define variable emt-auto like mfc_logical
   label {&pppsmt02_p_1} no-undo.
define variable cfexists like mfc_logical.
define variable cfsite  like ptp_site.
define variable cfdel-yn as logical initial no.

{gprun.i ""cfctrl.p"" "(""cf_w_mod"", output cfexists)"}

/*REPLACED FORMS WITH INCLUDE FILES*/
/*REPLACED FORMS WITH INCLUDE FILES*/
&SCOPED-DEFINE PP_FRAME_NAME A
form 

{ppptmta1.i}
   site colon 19 
with frame a side-labels width 80 attr-space NO-BOX THREE-D.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

display site /*V8! skip(.4) */ with frame a.

/*tfq form {pppsmta4.i} */ 
/*tfq*/  form 

{yypppsmta4.i} 
with frame c1 
/*GL93*/ side-labels width 80 attr-space  /*GUI*/.
setFrameLabels(frame c1:handle).

display global_part @ pt_part global_site @ site with frame a.

run get-valid-lngd.

for first soc_ctrl
   fields (soc_atp_enabled)
no-lock: end.

/* DISPLAY */
mainloop:
repeat:
   view frame a.

   view frame c1.
/*added by tfq, 2003/12/09*/
      find first xxbomc_ctrl no-lock no-error.
      if not available xxbomc_ctrl then do:
          message "����: BOM�����ļ�������!" view-as alert-box error.
          pause .
          leave.
      end.
/*end added by tfq*/
   do with frame a on endkey undo, leave mainloop:

      prompt-for pt_part site
      editing:
         /* SET GLOBAL PART VARIABLE */

         assign global_part = input pt_part
            global_site = input site.
         if frame-field = "pt_part" then do:
            /* FIND NEXT/PREVIOUS RECORD */
            {mfnp.i ptp_det pt_part ptp_part site
               ptp_site ptp_part}
         end.
         else if frame-field = "site" then do:
            /* Changed search index from "ptp_site" to "ptp_part" */
            /* FIND NEXT/PREVIOUS RECORD */
            {mfnp01.i ptp_det site ptp_site
               ptp_part "input pt_part" ptp_part}
         end.
         else do:
            readkey.
            apply lastkey.
         end.

         /*REPLACED DISPLAYS WITH INCLUDE FILES*/
         if recno <> ? then do:
            find pt_mstr no-lock where pt_part = ptp_part no-error.
            find in_mstr no-lock where in_part = ptp_part
               and in_site = ptp_site no-error.

            display {ppptmta1.i} with frame a.
            display ptp_part @ pt_part ptp_site @ site with frame a.

            btb-type-code = if ptp_btb_type = "" then "01" else ptp_btb_type.
            /* GET DEFAULT BTB TYPE FROM lngd_det */
            {gplngn2a.i &file = ""emt""
               &field = ""btb-type""

               &code  = btb-type-code
               &mnemonic = btb-type
               &label = btb-type-desc}

            if ptp__qad02 = 1 then emt-auto = yes.

            atp-type-code = if ptp_atp_enforcement = "" then "0" else ptp_atp_enforcement.
            /* GET DEFAULT ATP ENFORCEMENT TYPE FROM lngd_det */
            {gplngn2a.i &file = ""atp""
                        &field = ""atp-enforcement""
                        &code  = atp-type-code
                        &mnemonic = atp-enforcement
                        &label = atp-enforce-desc}
  /*tfq          display {pppsmta4.i} with frame c1. */
  /*tfq*/          display {yypppsmta4.i} with frame c1.

            if ptp_bom_code <> "" then
            find bom_mstr no-lock
               where bom_parent = ptp_bom_code no-error.
            else
            find bom_mstr no-lock
               where bom_parent = ptp_part no-error.
            if available bom_mstr and bom_batch <> 0
               then display bom_batch @ ptp_batch with frame c1.
            else display 1 @ ptp_batch with frame c1.
            /* Added following section */
            /* DISPLAY CONFIGURATION TYPE */
            /* GET MNEMONIC cfg AND cfglabel FROM LNGD_DET */

            run get-cfg.
            display cfg with frame c1.
            /* End Section */
         end.
      end.

      /* ADD/MOD/DELETE  */
      del-yn = no.

      if not can-find (pt_mstr where pt_part = input pt_part) then do:
         {pxmsg.i &MSGNUM=16 &ERRORLEVEL=3}
         undo, retry.
      end.

      if not can-find (si_mstr where si_site = input site) then do:
         {pxmsg.i &MSGNUM=708 &ERRORLEVEL=3}
         next-prompt site with frame a.
         undo, retry.
      end.

      find si_mstr where si_site = input site no-lock no-error.
      if available si_mstr and si_db <> global_db then do:
         {pxmsg.i &MSGNUM=5421 &ERRORLEVEL=3}
         /* SITE NOT ASSIGNED TO THIS DATABASE */
         next-prompt site with frame a.
         undo, retry.
      end.

      if available si_mstr then do:
         {gprun.i ""gpsiver.p""
            "(input si_site, input recid(si_mstr), output return_int)"}
         if return_int = 0 then do:
            {pxmsg.i &MSGNUM=725 &ERRORLEVEL=3}
            /* USER DOES NOT HAVE ACCESS TO SITE */
            next-prompt site with frame a.
            undo mainloop, retry mainloop.
         end.
      end.

      find pt_mstr exclusive-lock
         where pt_part = input pt_part no-error.
      if not available pt_mstr then do:
         {pxmsg.i &MSGNUM=16 &ERRORLEVEL=3}
         undo, retry.
      end.
      find in_mstr no-lock where in_part = pt_part
         and in_site = input site no-error.
      find ptp_det exclusive-lock where ptp_part = pt_part
         and ptp_site = input site no-error.

      if not available ptp_det then do:

         /* NEW ITEM */
         {pxmsg.i &MSGNUM=1 &ERRORLEVEL=1}
         create ptp_det.

         assign ptp_part = pt_part
            ptp_joint_type = pt_joint_type
            ptp_cfg_type = pt_cfg_type
            ptp_site = input site.

         if recid(ptp_det) = -1 then .

         find in_mstr where in_site = ptp_site
            and in_part = ptp_part exclusive-lock no-error.

         if available in_mstr then in_level = 99999.

         /*       IN THE CREATION OF IN_MSTR RECORD. ALSO, IN_MSTR RECORD IS     */
         /*       FOUND IN GPINCR.P ROUTINE BEFORE THE CREATION.                 */

         {gprun.i ""gpincr.p"" "(input no,
                                 input pt_part,
                                 input ptp_site,
                                 input si_gl_set,
                                 input si_cur_set,
                                 input pt_abc,
                                 input pt_avg_int,
                                 input pt_cyc_int,
                                 input pt_rctpo_status,
                                 input pt_rctpo_active,
                                 input pt_rctwo_status,
                                 input pt_rctwo_active,
                                 output inrecno)"}
         find in_mstr where recid(in_mstr) = inrecno
            no-lock no-error.

         run create_sct_det.

         ptp_ord_polsv  = ptp_ord_pol.

         if pt_btb_type = "" then pt_btb_type = "01".
         /* GET DEFAULT BTB TYPE FROM lngd_det */
         {gplngn2a.i &file = ""emt""
            &field = ""btb-type""
            &code  = pt_btb_type
            &mnemonic = btb-type
            &label = btb-type-desc}

         if pt_atp_enforcement = "" then pt_atp_enforcement = "0".

         /* GET DEFAULT ATP ENFORCEMENT TYPE FROM lngd_det */
         {gplngn2a.i &file = ""atp""
                     &field = ""atp-enforcement""
                     &code  = pt_atp_enforcement
                     &mnemonic = atp-enforcement
                     &label = atp-enforce-desc}

         display
            pt_ms @ ptp_ms
            pt_plan_ord @ ptp_plan_ord
            in_mrp when (available in_mstr) @ in_mrp
            pt_mrp when (not available in_mstr) @ in_mrp
            pt_ord_pol @ ptp_ord_pol
            pt_ord_qty @ ptp_ord_qty
            pt_ord_per @ ptp_ord_per
            pt_sfty_stk @ ptp_sfty_stk
            pt_sfty_time @ ptp_sfty_tme
            pt_rop @ ptp_rop

            pt_buyer @ ptp_buyer
            pt_vend @ ptp_vend
            pt_pm_code @ ptp_pm_code
            ptp_site @ ptp_po_site
            pt_mfg_lead @ ptp_mfg_lead
            pt_pur_lead @ ptp_pur_lead
            pt_insp_rqd @ ptp_ins_rqd
            pt_insp_lead @ ptp_ins_lead
            pt_cum_lead @ ptp_cum_lead
            pt_timefence @ ptp_timefnce
            pt_network @ ptp_network
            pt_routing @ ptp_routing
            pt_bom_code @ ptp_bom_code

            pt_iss_pol @ ptp_iss_pol
            pt_phantom @ ptp_phantom
            pt_ord_min @ ptp_ord_min
            pt_ord_max @ ptp_ord_max
            pt_ord_mult @ ptp_ord_mult
            pt_op_yield @ ptp_op_yield
            pt_yield_pct @ ptp_yld_pct
            pt_run @ ptp_run
            pt_setup @ ptp_setup

            btb-type
            pt__qad15 @ emt-auto
            pt_rev @ ptp_rev
            pt_run_seq1 @ ptp_run_seq1
            pt_run_seq2 @ ptp_run_seq2
            atp-enforcement
            pt_atp_family @ ptp_atp_family

         with frame c1.

      end.
      else
         do:

         if ptp_btb_type = "" then ptp_btb_type = "01".
         /* GET DEFAULT BTB TYPE FROM lngd_det */
         {gplngn2a.i &file = ""emt""
            &field = ""btb-type""
            &code  = ptp_btb_type
            &mnemonic = btb-type
            &label = btb-type-desc}

         if ptp__qad02 = 1 then emt-auto = yes.

         if ptp_atp_enforcement = "" then ptp_atp_enforcement = "0".
         /* GET DEFAULT ATP ENFORCE CODE FROM lngd_det */
         {gplngn2a.i &file  = ""atp""
                     &field = ""atp-enforcement""
                     &code = ptp_atp_enforcement
                     &mnemonic = atp-enforcement
                     &label = atp-enforce-desc}

   /*tfq      display {pppsmta4.i} with frame c1. */
   /*tfq*/  display {yypppsmta4.i} with frame c1.
      end.   /* else do*/

      /* DISPLAY */

      if ptp_bom_code <> "" then
      find bom_mstr no-lock
         where bom_parent = ptp_bom_code no-error.
      else
      find bom_mstr no-lock
         where bom_parent = ptp_part no-error.
      /* Added parenthesis for when in display statement */
      display
         bom_batch when (available bom_mstr and bom_batch <> 0) @ ptp_batch
         1 when (not available bom_mstr
         or (available bom_mstr and bom_batch = 0)) @ ptp_batch
      with frame c1.

      display {ppptmta1.i} with frame a.
      display ptp_part @ pt_part ptp_site @ site with frame a.
      /* Added following section */
      /* DISPLAY CONFIGURATION TYPE */
      /* GET MNEMONIC cfg AND cfglabel FROM LNGD_DET */

      run get-cfg.
      display cfg with frame c1.
      /* End Section */

      ststatus = stline[2].
      status input ststatus.

      next-prompt ptp_ms with frame c1.

      do on error undo, retry with frame c1:
         assign
            ptp_bom_codesv = ptp_bom_code
            ptp_pm_codesv =  ptp_pm_code
            ptp_networksv  = ptp_network
            ptp_mod_date = today
            ptp_userid = global_userid.

         /* THIS PATCH PREVENTS THE USER FROM MANUALLY ENTERING */
         /* THE CUMULATIVE LEAD TIME ptp_cum_lead               */

         set
            ptp_ms
            ptp_plan_ord
            ptp_timefnce
            ptp_ord_pol
            ptp_ord_qty
            ptp_ord_per
            ptp_sfty_stk
            ptp_sfty_tme
            ptp_rop
            ptp_rev
            ptp_iss_pol
            ptp_buyer
            ptp_vend
            ptp_po_site
            ptp_pm_code validate(input ptp_pm_code <> "","'��/��'���벻����Ϊ��") /*tfq*/
            cfg
            ptp_ins_rqd
            ptp_ins_lead
            ptp_cum_lead
            ptp__dec01   /*tfq*/ 
            ptp_mfg_lead
            ptp_pur_lead
            atp-enforcement
            ptp_atp_family
            ptp_run_seq1
            ptp_run_seq2
            ptp_phantom
            ptp_ord_min
            ptp_ord_max
            ptp_ord_mult   
            ptp_op_yield 
            ptp_yld_pct 
            ptp_run ptp_setup  
            btb-type
            emt-auto
            ptp_network     
            ptp_routing validate(input ptp_pm_code <> "m" or input ptp_routing <> "" or pt_group = "M","�������̴��벻����Ϊ��")  /*tfq*/
            ptp_bom_code validate(input ptp_pm_code <> "m" or input ptp_bom_code <> "" or pt_group = "M","��Ʒ�ṹ���벻����Ϊ��") /*tfq*/
            go-on (F5 CTRL-D)
         with frame c1.

         /* DELETE */
         if lastkey = keycode("F5")
            or lastkey = keycode("CTRL-D")
         then do:
         /*added by tfq, 2003/12/09*/
                     find first ps_mstr where ps__chr01 = ptp_site and (ps_par = ptp_part or ps_comp = ptp_part)
                     no-lock no-error. 
                     if available ps_mstr then do:
                          message "��������ڵص�" + ptp_site + "�Ĳ�Ʒ�ṹ,����������!" view-as alert-box error.
                          undo,retry.
                     end.
            /*end added by tfq*/
            del-yn = yes. 
           /*tfq {mfmsg01.i 11 1 del-yn}  */
            {pxmsg.i
               &MSGNUM=11
               &ERRORLEVEL=1
               &CONFIRM=del-yn
             }

            if del-yn = no then undo, retry.
         end.
         else do:
            /* DO NOT ALLOW UNKNOWN VALUES (QUESTION MARK) */

            {gpchkqst.i &fld=ptp_ms &frame-name=c1}
            {gpchkqst.i &fld=ptp_plan_ord &frame-name=c1}
            {gpchkqst.i &fld=ptp_timefnce &frame-name=c1}
            {gpchkqst.i &fld=ptp_ord_pol &frame-name=c1}
            {gpchkqst.i &fld=ptp_ord_qty &frame-name=c1}
            {gpchkqst.i &fld=ptp_ord_per &frame-name=c1}
            {gpchkqst.i &fld=ptp_sfty_stk &frame-name=c1}
            {gpchkqst.i &fld=ptp_sfty_tme &frame-name=c1}
            {gpchkqst.i &fld=ptp_rop &frame-name=c1}
            {gpchkqst.i &fld=ptp_rev &frame-name=c1}
            {gpchkqst.i &fld=ptp_buyer &frame-name=c1}
            {gpchkqst.i &fld=ptp_vend &frame-name=c1}
            {gpchkqst.i &fld=ptp_po_site &frame-name=c1}
            {gpchkqst.i &fld=ptp_pm_code &frame-name=c1}
            {gpchkqst.i &fld=ptp_mfg_lead &frame-name=c1}
            {gpchkqst.i &fld=ptp_pur_lead &frame-name=c1}
            {gpchkqst.i &fld=ptp_ins_rqd &frame-name=c1}
            {gpchkqst.i &fld=ptp_ins_lead &frame-name=c1}

            {gpchkqst.i &fld=ptp_network &frame-name=c1}
            {gpchkqst.i &fld=ptp_routing &frame-name=c1}
            {gpchkqst.i &fld=ptp_bom_code &frame-name=c1}
            {gpchkqst.i &fld=ptp_iss_pol &frame-name=c1}
            {gpchkqst.i &fld=ptp_phantom &frame-name=c1}
            {gpchkqst.i &fld=ptp_ord_min &frame-name=c1}
            {gpchkqst.i &fld=ptp_ord_max &frame-name=c1}
            {gpchkqst.i &fld=ptp_ord_mult &frame-name=c1}
            {gpchkqst.i &fld=ptp_op_yield &frame-name=c1}
            {gpchkqst.i &fld=ptp_yld_pct &frame-name=c1}
            {gpchkqst.i &fld=ptp_run &frame-name=c1}
            {gpchkqst.i &fld=ptp_setup &frame-name=c1}
            {gpchkqst.i &fld=ptp_run_seq1 &frame-name=c1}
            {gpchkqst.i &fld=ptp_run_seq2 &frame-name=c1}
            {gpchkqst.i &fld=atp-enforcement &frame-name=c1}
            {gpchkqst.i &fld=ptp_atp_family &frame-name=c1}

            if not
               {gpval.v &fld=ptp_network &mfile=ssm_mstr
               &mfld=ssm_network &blank=yes }
            then do:
               {pxmsg.i &MSGNUM=1505 &ERRORLEVEL=3}
               next-prompt ptp_network with frame c1.
               undo, retry.
            end.

            if ptp_yld_pct = 0
            then do:
               {pxmsg.i &MSGNUM=3953 &ERRORLEVEL=3}
               next-prompt ptp_yld_pct with frame c1.
               undo, retry.
            end.

            /* Check removal of pm-code or 'c' when using Adv. Config */
            run cfexists.del.

            /* VALIDATE ATP ENFORCE - MUST BE IN lngd_det */
            {gplngv.i &file     = ""atp""
                      &field    = ""atp-enforcement""
                      &mnemonic = atp-enforcement
                      &isvalid  = isvalid}
            if not isvalid then do:
               {pxmsg.i &MSGNUM=3169 &ERRORLEVEL=3}
               /* INVALID MNEMONIC atp_enforcement */
               next-prompt atp-enforcement.
               undo, retry.
            end.

            /* PICK UP NUMERIC FOR ATP ENFORCE CODE FROM MNEMONIC */
            {gplnga2n.i &file  = ""atp""
                        &field = ""atp-enforcement""
                        &mnemonic = atp-enforcement
                        &code = ptp_atp_enforcement
                        &label = atp-enforce-desc}

            /* ISSUE WARNING IF ATP ENFORCEMENT ACTIVATED HERE BUT NOT  */
            /* ACTIVE IN SALES ORDER CONTROL FILE                       */
            /* ONLY ISSUE ERROR IF TYPE SET TO WARN OR ERROR, OR        */
            /* FAMILY ATP SET TO YES..                                  */
            if available soc_ctrl and soc_atp_enabled = no then do:
               if ((atp-enforcement entered or new ptp_det)
               and ptp_atp_enforcement > "0")
               or ((ptp_atp_family entered or new ptp_det)
               and ptp_atp_family = yes)
               then do:
                 {pxmsg.i &MSGNUM=4095 &ERRORLEVEL=2}
                 /* ATP Enforcement not active in Sales Order Control file */
               end.
            end.

            /* VALIDATE THE RUN SEQUENCES */
            /* VALIDATE RUN SEQUENCE 1 */
            if (ptp_pm_code = "L")
               or (ptp_pm_code <> "L" and ptp_run_seq1 <> "") then do:
               if not ({gpcode.v ptp_run_seq1 pt_run_seq1}) then do:
                  {pxmsg.i &MSGNUM=716 &ERRORLEVEL=3}
                  /* VALUE MUST EXIST IN GENERALIZED CODES */
                  next-prompt ptp_run_seq1.
                  undo, retry.
               end.
            end. /* IF (PTP_PM_CODE = "L") */
            /* VALIDATE RUN SEQUENCE 2 */
            if (ptp_pm_code = "L")
               or (ptp_pm_code <> "L" and ptp_run_seq2 <> "") then do:
               if not ({gpcode.v ptp_run_seq2 pt_run_seq2}) then do:
                  {pxmsg.i &MSGNUM=716 &ERRORLEVEL=3}
                  /* VALUE MUST EXIST IN GENERALIZED CODES */
                  next-prompt ptp_run_seq2.
                  undo, retry.
               end.
            end. /* IF (PTP_PM_CODE = "L") */

            if pt_pm_code <> "F" and ptp_pm_code = "F"
            then do:
               {pxmsg.i &MSGNUM=1267 &ERRORLEVEL=3} /*Family Item can only be
               defined at Item Master Maintenance*/
               next-prompt ptp_pm_code with frame c1.
               undo, retry.
            end.

            /* IF pt_pm_code = "F" THEN ptp_pm_code SHOULD ALSO BE
            VALIDATED TO BE "F" ONLY */
            if pt_pm_code = "F" and ptp_pm_code <> "F"
            then do:
               {pxmsg.i &MSGNUM=1020 &ERRORLEVEL=3} /*Family Item only */
               next-prompt ptp_pm_code with frame c1.
               undo, retry.
            end.

            ptp__qad02 = if emt-auto = no then 0 else 1.

            if ptp_routing > "" then
            if not can-find
               (first ro_det where ro_routing = ptp_routing) then do:
               {pxmsg.i &MSGNUM=126 &ERRORLEVEL=2}

            end.
            if ptp_bom_code > "" then
            if not can-find
               (first ps_mstr where ps_par = ptp_bom_code) then do:
               {pxmsg.i &MSGNUM=100 &ERRORLEVEL=2}

            end.

            if ptp_joint_type = "5" and
               ptp_bom_code <> "" and ptp_bom_code <> ptp_part then do:
               /* BASE PROCESS BOM MUST BE THE SAME AS ITEM NO.*/
               {pxmsg.i &MSGNUM=6533 &ERRORLEVEL=4}
               next-prompt ptp_bom_code with frame c1.
               undo, retry.
            end.
            /* BOM CHANGE. SEE IF THIS IS A CO-PRODUCT. */
            if ptp_joint_type <> "5" and
               (new ptp_det or
               ptp_bom_code <> ptp_bom_codesv) then do:

               find first ps_mstr no-lock
                  where ps_par = ptp_part and ps_comp = ptp_bom_code
                  and ps_joint_type = "1" no-error.
               if available ps_mstr then ptp_joint_type = "1".
               else ptp_joint_type = "".
            end.

            if ptp_joint_type = "1" or ptp_joint_type = "5" then do:
               if ptp_phantom = yes then do:
                  /*A JOINT PROD OR BASE PROCESS MAY NOT BE A PHANTOM*/
                  {pxmsg.i &MSGNUM=6512 &ERRORLEVEL=3}
                  next-prompt ptp_phantom with frame c1.
                  undo, retry.
               end.
               if ptp_pm_code = "C" then do:
                  /* CONFIGURED ITEM NOT ALLOWED */
                  {pxmsg.i &MSGNUM=225 &ERRORLEVEL=3}
                  next-prompt ptp_pm_code with frame c1.
                  undo, retry.
               end.
            end.

            assign
               ps-recno = 1
               bom_code =
               (if ptp_bom_code > "" then ptp_bom_code else ptp_part).

            if (ptp_bom_code  <> ptp_bom_codesv or
               ptp_pm_code       <> ptp_pm_codesv  or
               ptp_network       <> ptp_networksv) and not batchrun
            then do:
               for each  in_mstr where in_part = ptp_part:
                  in_level = 99999.
               end.

               {gprun.i ""bmpsmta1.p""
                  "(pt_part,"""",bom_code,input-output ps-recno)"}
            end.

            if ps-recno = 0 then do:
               {pxmsg.i &MSGNUM=206 &ERRORLEVEL=3}
               /* CYCLIC STRUCTURE NOT ALLOWED. */
               next-prompt ptp_bom_code with frame c1.
               undo, retry.
            end.

            find bom_mstr no-lock where bom_parent = bom_code no-error.
            if (available bom_mstr and (ptp_ll_bom > bom_ll_code
               or drp_mrp))
               or (not available bom_mstr and ptp_ll_bom > 0)
            then do:

               if available bom_mstr
                  then ptp_ll_bom = bom_ll_code.
               else ptp_ll_bom = 0.

               if ptp_pm_code <> "D" and ptp_pm_code <> "P" then do:
                  find in_mstr exclusive-lock where in_part = ptp_part
                     and in_site = ptp_site
                     and in_level > ptp_ll_bom no-error.
                  if available in_mstr then do:
                     assign in_mrp = yes.

                  end.
               end.
            end.
 
            /* VALIDATE CFG MNEMONIC AGAINST LNGD_DET */
            if valid_lngd then do:

               run validate_cfg.
               if not valid_mnemonic and
                  (ptp_pm_code = "C" or (ptp_pm_code <> "C" and
                  cfg <> ""))
               then do:
                  /* INVALID CHARACTER */
                  {pxmsg.i &MSGNUM=3093 &ERRORLEVEL=3}
                  next-prompt cfg with frame c1.
                  undo, retry.
               end.

               run get-cfg2.
            end.
            if ptp_pm_code = "C" and
               valid_lngd and available lngd_det then
               assign ptp_cfg_type = cfgcode.
            else ptp_cfg_type = cfg.

            /* VALIDATE BTB TYPE - MUST BE IN lngd_det */
            {gplngv.i &file     = ""emt""
               &field    = ""btb-type""
               &mnemonic = btb-type
               &isvalid  = isvalid}
            if not isvalid then do:
               {pxmsg.i &MSGNUM=3169 &ERRORLEVEL=3}
               /* INVALID MNEMONIC btb-type */
               next-prompt btb-type.
               undo, retry.
            end.

            /* PICK UP NUMERIC FOR BTB TYPE CODE FROM MNEMONIC */
            {gplnga2n.i &file  = ""emt""
               &field = ""btb-type""
               &mnemonic = btb-type
               &code = ptp_btb_type
               &label = btb-type-desc}
            btb-type = "".
                   /******added by tfq , 06/22/2005 begin *****/
                  if input site = xxbomc_code_site and input ptp_phantom then do:
                       message "���ݿ����ļ�,�ص�" + input site + "������ά�����!" view-as alert-box error.
                       next-prompt ptp_phantom with frame c1.
                       undo,retry.
                  end.
                  
                  def buffer ptpbuf for ptp_det.
                  /*Verify: phantom only can be maintain in one site*/
                  if input ptp_det.ptp_phantom = yes then do:
                      find first ptpbuf where ptpbuf.ptp_part = input pt_part
                                           and ptpbuf.ptp_site <> input site
                                           and ptpbuf.ptp_phantom = yes
                                           no-lock no-error.
                      if available ptpbuf then do:
                         message "������Ѿ����ڵص� '" + ptpbuf.ptp_site + "' �ļƻ�����" view-as alert-box error.
                         next-prompt ptp_det.ptp_phantom with frame c1.
                         undo, retry.
                      end.
                  end.
                  
              if input ptp_det.ptp_pm_code = "m" then do:    
                  /*Verify the routing code against different sites*/
                  find first ptpbuf where ptpbuf.ptp_part = input pt_part 
                                       and ptpbuf.ptp_site <> input site
                                       and ptpbuf.ptp_routing = input ptp_det.ptp_routing no-lock no-error.
                  if available ptpbuf and pt_group <> "M" then do:
                        message "��� '" + ptpbuf.ptp_part "' �ڵص� '" + ptpbuf.ptp_site 
                                 "' �Ѿ�ʹ���˹������� '" + ptpbuf.ptp_routing + "'" view-as alert-box error.
                        next-prompt ptp_det.ptp_routing with frame c1.
                        undo, retry.
                     end.                  
                  
                  /*verify the bom code against different sites*/
                  find first ptpbuf where ptpbuf.ptp_part = input pt_part 
                                       and ptpbuf.ptp_site <> input site
                                       and ptpbuf.ptp_bom_code = input ptp_det.ptp_bom_code no-lock no-error.
                  if available ptpbuf and pt_group <> "M" then do:
                        message "��� '" + ptpbuf.ptp_part "' �ڵص� '" + ptpbuf.ptp_site 
                                 "' �Ѿ�ʹ���˲�Ʒ�ṹ '" + ptpbuf.ptp_bom_code + "'" view-as alert-box error.
                        next-prompt ptp_det.ptp_bom_code.
                        undo mainloop, retry mainloop.
                  end.
             end. /*if input ptp_det.ptp_pm_code = "m"*/
              
                  find pt_mstr where pt_part = input pt_part no-error.                     /*kevin,11/06/2003*/
                  if available pt_mstr then assign pt_phantom = ptp_det.ptp_phantom.               /*kevin,11/06/2003*/
                  
/*end added by tfq, 06/22/2005*/
         end.
      end.

      run check-mrp.

      if del-yn = yes then do:

         run delete_ptp_det.

         clear frame a.

         clear frame c1.
         del-yn = no.
         next mainloop.
      end.
      status input.
   end.
end.
/* END MAIN LOOP */
status input.

PROCEDURE check-mrp:
   define buffer inmstra for in_mstr.
   part = ptp_det.ptp_part.
   site = ptp_det.ptp_site.
   {inmrp.i &part=part &site=site}
   if ptp_ord_pol = "" and ptp_ord_polsv <> ptp_ord_pol then do:
      find inmstra where inmstra.in_part = ptp_part and
         inmstra.in_site = ptp_site no-error.
      if available inmstra then inmstra.in_mrp = yes.
   end.
END PROCEDURE.

PROCEDURE cfexists.del:

   if ptp_pm_codesv = "c" and ptp_det.ptp_pm_code <> "c"
      and cfexists then do:
      find qad_wkfl
         where qad_key1 = "cfpt"
         and qad_key2 = string(ptp_part,"x(18)") +
         string(ptp_site,"x(8)")
         exclusive-lock no-error.
      if available qad_wkfl then do:
         cfdel-yn = no.
        /*tfq {mfmsg01.i 1798 2 cfdel-yn} */
         {pxmsg.i
               &MSGNUM=1798
               &ERRORLEVEL=2
               &CONFIRM=cfdel-yn
             }


         if cfdel-yn then do:
            delete qad_wkfl.
         end.
         else do:
            next-prompt ptp_pm_code.
            undo, retry.
         end.
      end. /*available qad_wkfl*/
   end. /*ptp_pm_codesv = "c"*/
END PROCEDURE.

PROCEDURE delete_ptp_det:
   if cfexists then do:
      /* If the user has decided to delete the record and a */

      {gprunmo.i
         &module = "cf"
         &program = "cfwkflrm.p"
         &param   = """(ptp_det.ptp_part,
                                ptp_det.ptp_site)"""
         }
   end. /*cfexists*/

   ptp_recno = recid(ptp_det).
   find ptp_det exclusive-lock where recid(ptp_det) = ptp_recno.
   find in_mstr where in_mstr.in_site = ptp_site
      and in_mstr.in_part = ptp_part no-error.
   if available in_mstr then in_mstr.in_level = 99999.
   delete ptp_det.
END PROCEDURE.

PROCEDURE get-valid-lngd:
   if can-find(first lngd_det where
      lngd_lang = global_user_lang and

      lngd_dataset = "pt_mstr" and
      lngd_field = "pt_cfg_type") then
      valid_lngd = yes.
   else valid_lngd = no.
END PROCEDURE.

PROCEDURE get-cfg:
   /* GET MNEMONIC cfg AND cfglabel FROM LNGD_DET */
   assign
      cfg = ptp_det.ptp_cfg_type
      cfglabel = ""
      cfgcode = "".

   {gplngn2a.i &file     = ""pt_mstr""
      &field    = ""pt_cfg_type""
      &code     = ptp_cfg_type
      &mnemonic = cfg
      &label    = cfglabel}

END PROCEDURE.

PROCEDURE get-cfg2:
   /* GET cfgcode & cfglabel FROM LNGD_DET */

   {gplnga2n.i &file     = ""pt_mstr""
      &field    = ""pt_cfg_type""
      &mnemonic = cfg
      &code     = cfgcode
      &label    = cfglabel}
END PROCEDURE.

PROCEDURE validate_cfg:

   {gplngv.i &file     = ""pt_mstr""
      &field    = ""pt_cfg_type""
      &mnemonic = cfg
      &isvalid  = valid_mnemonic}
END PROCEDURE.

PROCEDURE create_sct_det:
   find in_mstr exclusive-lock where recid(in_mstr) = inrecno no-error.
   {gpsct04.i &type=""GL""}
   {gpsct04.i &type=""CUR""}
END PROCEDURE.

