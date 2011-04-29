/* pppsmt02.p - PART SITE PLANNING MAINTENANCE                              */
/* Copyright 1986-2005 QAD Inc., Carpinteria, CA, USA.                      */
/* All rights reserved worldwide.  This is an unpublished work.             */
/* $Revision: 1.22.2.18 $                                                   */
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
/* Old ECO marker removed, but no ECO header exists *F0PN*                  */
/* Revision: 1.22.2.7     BY: Russ Witt          DATE: 09/21/01  ECO: *P01H* */
/* Revision: 1.22.2.8     BY: Zheng Huang        DATE: 01/31/02  ECO: *P000* */
/* Revision: 1.22.2.10    BY: Paul Donnelly (SB) DATE: 06/28/03  ECO: *Q00K* */
/* Revision: 1.22.2.11    BY: Rajinder Kamra     DATE: 06/23/03  ECO: *Q003* */
/* Revision: 1.22.2.12    BY: Shivanand H.       DATE: 12/12/03  ECO: *P1FW* */
/* Revision: 1.22.2.13    BY: Jean Miller        DATE: 02/23/04  ECO: *Q063* */
/* Revision: 1.22.2.14    BY: Somesh Jeswani     DATE: 10/13/04  ECO: *P2PL* */
/* Revision: 1.22.2.15    BY: Sukhad Kulkarni    DATE: 01/31/05  ECO: *P35W* */
/* Revision: 1.22.2.16    BY: Priyank Khandare   DATE: 02/22/05  ECO: *P397* */
/* Revision: 1.22.2.17    By: Chi Liu            DATE: 05/11/05  ECO: *P3L7*    */
/* $Revision: 1.22.2.18 $    By: Chi Liu            DATE: 05/26/05  ECO: *P3MN*    */

/*----rev history-------------------------------------------------------------------------------------*/
/* $MODIFIED BY: softspeed Roger Xiao         DATE: 2007/11/27  ECO: *xp001*  */
/* SS - 101208.1  By: Roger Xiao */ /* if ptp_vend changed ,modify pt__chr03 to default */
/*-Revision end---------------------------------------------------------------*/


{mfdtitle.i "101208.1"}

/* SS - 101208.1 - B */
    define var v_old_vend like pt_vend .
/* SS - 101208.1 - E */

define var old_insp_rqd  like pt_insp_rqd . /*xp001*/
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
define variable cfglabel as character format "x(24)" label "" no-undo.
define variable cfgcode as character format "x(1)" no-undo.
define variable valid_mnemonic like mfc_logical no-undo.
define variable valid_lngd like mfc_logical no-undo.

define variable btb-type       like pt_btb_type format "x(8)" no-undo.
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
   label "Auto EMT Processing" no-undo.

define variable l_mrp_n2y as logical no-undo.
define variable ptp_det_recid as recid no-undo.

form {ppptmta1.i}
   site colon 19
with frame a side-labels width 80 attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

display
   site
   /*V8! skip(.4) */
with frame a.

form {pppsmta4.i}
with frame c1 title color normal
   (getFrameTitle("ITEM_PLANNING_DATA",26))
   side-labels width 80 attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame c1:handle).

display
   global_part @ pt_part
   global_site @ site
with frame a.

run get-valid-lngd.

for first soc_ctrl
   fields(soc_domain soc_atp_enabled)
   where soc_domain = global_domain
no-lock: end.

/* DISPLAY */
mainloop:
repeat:

   view frame a.

   view frame c1.

   do with frame a on endkey undo, leave mainloop:

      prompt-for pt_part site
      editing:
         /* SET GLOBAL PART VARIABLE */

         assign
            global_part = input pt_part
            global_site = input site.

         if frame-field = "pt_part" then do:
            /* FIND NEXT/PREVIOUS RECORD */
            {mfnp.i ptp_det pt_part  " ptp_domain = global_domain and
               ptp_part "  site ptp_site ptp_part}
         end.
         else if frame-field = "site" then do:
            /* Changed search index from "ptp_site" to "ptp_part" */
            /* FIND NEXT/PREVIOUS RECORD */
            {mfnp01.i ptp_det site ptp_site
               ptp_part " ptp_domain = global_domain and input pt_part"
               ptp_part}
         end.
         else do:
            readkey.
            apply lastkey.
         end.

         /* When check-mrp executed, ptp_det was fetched using fields phrase.
          * In DT UI, above mfnp.i neither fetch ptp_det again nor reset recno
          * for "HELP" key.
          * In this situation, it needs to refetch ptp_det here to include
          * fields which were not included in the fields phrase in check-mrp.
          */
         if ({gpiswrap.i} and keyfunction(lastkey) = "HELP"
            and l_mrp_n2y = yes and recno <> ? and ptp_det_recid <> ?
            and (frame-field = "pt_part" or frame-field = "site"))
         then do:
            l_mrp_n2y = no.
            find ptp_det where recid(ptp_det) = ptp_det_recid no-lock no-error.
            input clear.
         end.

         /*REPLACED DISPLAYS WITH INCLUDE FILES*/
         if recno <> ? then do:
            find pt_mstr where pt_domain = global_domain and
                               pt_part = ptp_part
            no-lock no-error.
            find in_mstr where in_domain = global_domain
                           and in_part = ptp_part
                           and in_site = ptp_site
            no-lock no-error.

            display {ppptmta1.i} with frame a.

            display
               ptp_part @ pt_part
               ptp_site @ site
            with frame a.

            btb-type-code = if ptp_btb_type = "" then "01"
                            else ptp_btb_type.
            /* GET DEFAULT BTB TYPE FROM lngd_det */
            {gplngn2a.i &file = ""emt""
               &field = ""btb-type""
               &code  = btb-type-code
               &mnemonic = btb-type
               &label = btb-type-desc}

            emt-auto = if ptp__qad02 = 1
                       then
                          yes
                       else
                          no.

            atp-type-code = if ptp_atp_enforcement = "" then "0"
                            else ptp_atp_enforcement.
            /* GET DEFAULT ATP ENFORCEMENT TYPE FROM lngd_det */
            {gplngn2a.i &file = ""atp""
                        &field = ""atp-enforcement""
                        &code  = atp-type-code
                        &mnemonic = atp-enforcement
                        &label = atp-enforce-desc}

            display {pppsmta4.i} with frame c1.

            if ptp_bom_code <> "" then
            find bom_mstr
                where bom_domain = global_domain
                  and bom_parent = ptp_bom_code
            no-lock no-error.
            else
            find bom_mstr
                where bom_domain = global_domain
                  and bom_parent = ptp_part
            no-lock no-error.

            if available bom_mstr and bom_batch <> 0 then
               display
                  bom_batch @ ptp_batch
               with frame c1.
            else
               display
                  1 @ ptp_batch
               with frame c1.

            /* DISPLAY CONFIGURATION TYPE */
            /* GET MNEMONIC cfg AND cfglabel FROM LNGD_DET */
            run get-cfg.
            display cfg with frame c1.

         end.

      end.

      /* ADD/MOD/DELETE  */
      del-yn = no.

      if not can-find (pt_mstr where pt_domain = global_domain and
                                     pt_part = input pt_part)
      then do:
         {pxmsg.i &MSGNUM=16 &ERRORLEVEL=3}
         undo, retry.
      end.

      if not can-find (si_mstr where si_domain = global_domain and
                                     si_site = input site)
      then do:
         {pxmsg.i &MSGNUM=708 &ERRORLEVEL=3}
         next-prompt site with frame a.
         undo, retry.
      end.

      find si_mstr where si_domain = global_domain
                     and si_site = input site
      no-lock no-error.

      if available si_mstr and si_db <> global_db then do:
         /* SITE NOT ASSIGNED TO THIS DOMAIN */
         {pxmsg.i &MSGNUM=6251 &ERRORLEVEL=3}
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

      find pt_mstr where pt_domain = global_domain
                     and pt_part = input pt_part
      exclusive-lock no-error.
      if not available pt_mstr then do:
         {pxmsg.i &MSGNUM=16 &ERRORLEVEL=3}
         undo, retry.
      end.

      find in_mstr where in_domain = global_domain
                     and in_part = pt_part
                     and in_site = input site
      no-lock no-error.

      find ptp_det where ptp_domain = global_domain
                     and ptp_part = pt_part
                     and ptp_site = input site
      exclusive-lock no-error.

      if not available ptp_det then do:

         /* NEW ITEM */
         {pxmsg.i &MSGNUM=1 &ERRORLEVEL=1}

         create ptp_det.
         assign
            ptp_domain = global_domain
            ptp_part = pt_part
            ptp_joint_type = pt_joint_type
            ptp_cfg_type = pt_cfg_type
            ptp_site = input site.

         if recid(ptp_det) = -1 then .

         find in_mstr where in_domain = global_domain
                        and in_site = ptp_site
                        and in_part = ptp_part
         exclusive-lock no-error.

         if available in_mstr then in_level = 99999.

         /* IN THE CREATION OF IN_MSTR RECORD. ALSO, IN_MSTR RECORD IS     */
         /* FOUND IN GPINCR.P ROUTINE BEFORE THE CREATION.                 */
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

         find in_mstr where recid(in_mstr) = inrecno no-lock no-error.

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

      end. /* if not available ptp_det */

      else do:

         if ptp_btb_type = "" then ptp_btb_type = "01".
         /* GET DEFAULT BTB TYPE FROM lngd_det */
         {gplngn2a.i &file = ""emt""
            &field = ""btb-type""
            &code  = ptp_btb_type
            &mnemonic = btb-type
            &label = btb-type-desc}

         emt-auto = if ptp__qad02 = 1
                    then
                       yes
                    else
                       no.

         if ptp_atp_enforcement = "" then ptp_atp_enforcement = "0".
         /* GET DEFAULT ATP ENFORCE CODE FROM lngd_det */
         {gplngn2a.i &file  = ""atp""
                     &field = ""atp-enforcement""
                     &code = ptp_atp_enforcement
                     &mnemonic = atp-enforcement
                     &label = atp-enforce-desc}

         display {pppsmta4.i} with frame c1.

      end.   /* else do*/

      /* DISPLAY */
      if ptp_bom_code <> "" then
      find bom_mstr
          where bom_domain = global_domain
            and bom_parent = ptp_bom_code
      no-lock no-error.
      else
      find bom_mstr
          where bom_domain = global_domain
            and bom_parent = ptp_part
      no-lock no-error.

      /* Added parenthesis for when in display statement */
      display
         bom_batch when (available bom_mstr and bom_batch <> 0) @ ptp_batch
         1         when (not available bom_mstr or
                         (available bom_mstr and bom_batch = 0)) @ ptp_batch
      with frame c1.

      display {ppptmta1.i} with frame a.

      display
         ptp_part @ pt_part
         ptp_site @ site
      with frame a.

      /* DISPLAY CONFIGURATION TYPE */
      /* GET MNEMONIC cfg AND cfglabel FROM LNGD_DET */
      run get-cfg.
      display cfg with frame c1.

      ststatus = stline[2].
      status input ststatus.

      next-prompt ptp_ms with frame c1.

      do on error undo, retry with frame c1:
		 old_insp_rqd = ptp_ins_rqd . /*xp001*/

        /* SS - 101208.1 - B */
        v_old_vend = ptp_vend .
        /* SS - 101208.1 - E */

         assign
            ptp_bom_codesv = ptp_bom_code
            ptp_pm_codesv =  ptp_pm_code
            ptp_networksv  = ptp_network
            ptp_mod_date = today
            ptp_userid = global_userid.

         /* PREVENTS THE USER FROM MANUALLY ENTERING */
         /* THE CUMULATIVE LEAD TIME ptp_cum_lead    */
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
            ptp_pm_code
            cfg
            ptp_ins_rqd
            ptp_ins_lead
            ptp_cum_lead
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
            ptp_routing
            ptp_bom_code
            go-on (F5 CTRL-D)
         with frame c1.

         /* DELETE */
         if lastkey = keycode("F5")
         or lastkey = keycode("CTRL-D")
         then do:
            del-yn = yes.
            {pxmsg.i &MSGNUM=11 &ERRORLEVEL=1 &CONFIRM=del-yn}
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
               {gpval.v  &domain="ssm_mstr.ssm_domain = global_domain and "
               &fld=ptp_network &mfile=ssm_mstr
               &mfld=ssm_network &blank=yes }
            then do:
               /* Network does not exist */
               {pxmsg.i &MSGNUM=1505 &ERRORLEVEL=3}
               next-prompt ptp_network with frame c1.
               undo, retry.
            end.

            if ptp_yld_pct = 0
            then do:
               /* Value must be greater than zero */
               {pxmsg.i &MSGNUM=3953 &ERRORLEVEL=3}
               next-prompt ptp_yld_pct with frame c1.
               undo, retry.
            end.

            /* VALIDATE ATP ENFORCE - MUST BE IN lngd_det */
            {gplngv.i &file     = ""atp""
                      &field    = ""atp-enforcement""
                      &mnemonic = atp-enforcement
                      &isvalid  = isvalid}
            if not isvalid then do:
               /* INVALID MNEMONIC atp_enforcement */
               {pxmsg.i &MSGNUM=3169 &ERRORLEVEL=3}
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
                 /* ATP Enforcement not active in Sales Order Control file */
                 {pxmsg.i &MSGNUM=4095 &ERRORLEVEL=2}
               end.
            end.

            /* VALIDATE THE RUN SEQUENCES */
            /* VALIDATE RUN SEQUENCE 1 */
            if (ptp_pm_code = "L")
            or (ptp_pm_code <> "L" and ptp_run_seq1 <> "")
            then do:
               if not ({gpcode.v ptp_run_seq1 pt_run_seq1}) then do:
                  /* VALUE MUST EXIST IN GENERALIZED CODES */
                  {pxmsg.i &MSGNUM=716 &ERRORLEVEL=3}
                  next-prompt ptp_run_seq1.
                  undo, retry.
               end.
            end. /* IF (PTP_PM_CODE = "L") */

            /* VALIDATE RUN SEQUENCE 2 */
            if (ptp_pm_code = "L")
            or (ptp_pm_code <> "L" and ptp_run_seq2 <> "")
            then do:
               if not ({gpcode.v ptp_run_seq2 pt_run_seq2}) then do:
                  /* VALUE MUST EXIST IN GENERALIZED CODES */
                  {pxmsg.i &MSGNUM=716 &ERRORLEVEL=3}
                  next-prompt ptp_run_seq2.
                  undo, retry.
               end.
            end. /* IF (PTP_PM_CODE = "L") */

            if pt_pm_code <> "F" and ptp_pm_code = "F"
            then do:
               /*Family Item can only be defined at Item Master Maintenance*/
               {pxmsg.i &MSGNUM=1267 &ERRORLEVEL=3}
               next-prompt ptp_pm_code with frame c1.
               undo, retry.
            end.

            /* IF pt_pm_code = "F" THEN ptp_pm_code SHOULD ALSO BE
            VALIDATED TO BE "F" ONLY */
            if pt_pm_code = "F" and ptp_pm_code <> "F"
            then do:
               /*Family Item only */
               {pxmsg.i &MSGNUM=1020 &ERRORLEVEL=3}
               next-prompt ptp_pm_code with frame c1.
               undo, retry.
            end.

            ptp__qad02 = if emt-auto = no then 0 else 1.

            if ptp_routing > "" then
            if not can-find
               (first ro_det where ro_domain = global_domain and
                                   ro_routing = ptp_routing)
            then do:
               /* Routing does not exist */
               {pxmsg.i &MSGNUM=126 &ERRORLEVEL=2}
            end.

            if ptp_bom_code > "" then
            if not can-find
               (first ps_mstr where ps_domain = global_domain and
                                    ps_par = ptp_bom_code)
            then do:
               /* No bill of material exists */
               {pxmsg.i &MSGNUM=100 &ERRORLEVEL=2}
            end.

            if ptp_joint_type = "5" and
               ptp_bom_code <> "" and ptp_bom_code <> ptp_part
            then do:
               /* BASE PROCESS BOM MUST BE THE SAME AS ITEM NO.*/
               {pxmsg.i &MSGNUM=6533 &ERRORLEVEL=4}
               next-prompt ptp_bom_code with frame c1.
               undo, retry.
            end.

            /* BOM CHANGE. SEE IF THIS IS A CO-PRODUCT. */
            if ptp_joint_type <> "5" and
               (new ptp_det or
               ptp_bom_code <> ptp_bom_codesv)
            then do:

               find first ps_mstr
                   where ps_domain = global_domain
                     and ps_par = ptp_part
                     and ps_comp = ptp_bom_code
                     and ps_joint_type = "1"
               no-lock no-error.

               if available ps_mstr then
                  ptp_joint_type = "1".
               else
                  ptp_joint_type = "".

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

            if (ptp_bom_code <> ptp_bom_codesv or
                ptp_pm_code  <> ptp_pm_codesv  or
                ptp_network  <> ptp_networksv)
            then do:

               for each in_mstr where
                        in_domain = global_domain and
                        in_part = ptp_part:
                  in_level = 99999.
               end.

               {gprun.i ""bmpsmta1.p""
                  "(pt_part,"""",bom_code,input-output ps-recno)"}

            end.

            if ps-recno = 0 then do:
               /* CYCLIC STRUCTURE NOT ALLOWED. */
               {pxmsg.i &MSGNUM=206 &ERRORLEVEL=3}
               next-prompt ptp_bom_code with frame c1.
               undo, retry.
            end.

            find bom_mstr where bom_domain = global_domain
                            and bom_parent = bom_code
            no-lock no-error.

            if (available bom_mstr and (ptp_ll_bom > bom_ll_code
               or drp_mrp))
               or (not available bom_mstr and ptp_ll_bom > 0)
            then do:

               if available bom_mstr then
                  ptp_ll_bom = bom_ll_code.
               else
                  ptp_ll_bom = 0.

               if ptp_pm_code <> "D" and ptp_pm_code <> "P" then do:
                  find in_mstr where
                       in_domain = global_domain
                   and in_part = ptp_part
                   and in_site = ptp_site
                   and in_level > ptp_ll_bom
                  exclusive-lock no-error.
                  if available in_mstr then
                     assign in_mrp = yes.
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
               valid_lngd and available lngd_det
            then
               ptp_cfg_type = cfgcode.
            else
               ptp_cfg_type = "".

            /* VALIDATE BTB TYPE - MUST BE IN lngd_det */
            {gplngv.i &file     = ""emt""
               &field    = ""btb-type""
               &mnemonic = btb-type
               &isvalid  = isvalid}
            if not isvalid then do:
               /* INVALID MNEMONIC btb-type */
               {pxmsg.i &MSGNUM=3169 &ERRORLEVEL=3}
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
         end.
      end.

	  if ptp_ins_rqd <> old_insp_rqd then do:  /*xp001*/
				{gprun.i ""xxppptmtinsp.p""
					     "(input ptp_part,
						   input ptp_site ,
						   input ptp_ins_rqd )"}
				/*xxppptmtinsp.p”Î1.4.7π≤”√*/
	  end. /*xp001*/

    /* SS - 101208.1 - B */
    if ptp_vend <> v_old_vend then do:
        find first code_mstr 
            where code_domain = global_domain
            and code_fldname = "ss-type-def"
            and code_value   = "ss"
        no-lock no-error.
        find first pt_mstr where pt_domain = global_domain and pt_part = ptp_part no-error.
        if avail pt_mstr then 
        assign pt__log01 = Yes 
               pt__chr03 = if not avail code_mstr then "B" else code_cmmt .
    end.
    /* SS - 101208.1 - E */



      if not available in_mstr
      then l_mrp_n2y = yes.
      else l_mrp_n2y = not in_mrp.

      run check-mrp.

      /* only when in_mrp changed from no to yes, l_mrp_n2y is yes */
      if not available in_mstr
      then l_mrp_n2y = no.
      else l_mrp_n2y = l_mrp_n2y and in_mrp.
      ptp_det_recid = recid(ptp_det).

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

   assign
      part = ptp_det.ptp_part
      site = ptp_det.ptp_site.

   {inmrp.i &part=part &site=site}

   if ptp_ord_pol = "" and ptp_ord_polsv <> ptp_ord_pol then do:
      find inmstra where inmstra.in_domain = global_domain and
                         inmstra.in_part = ptp_part and
                         inmstra.in_site = ptp_site
      no-error.
      if available inmstra then
         inmstra.in_mrp = yes.
   end.

END PROCEDURE.

PROCEDURE delete_ptp_det:

   ptp_recno = recid(ptp_det).

   find ptp_det where recid(ptp_det) = ptp_recno exclusive-lock.

   find in_mstr where in_mstr.in_domain = global_domain
                  and in_mstr.in_site = ptp_site
                  and in_mstr.in_part = ptp_part
   no-error.
   if available in_mstr then
      in_mstr.in_level = 99999.

   delete ptp_det.

END PROCEDURE.

PROCEDURE get-valid-lngd:

   if can-find(first lngd_det where
                     lngd_lang = global_user_lang and
                     lngd_dataset = "pt_mstr" and
                     lngd_field = "pt_cfg_type")
   then
      valid_lngd = yes.
   else
      valid_lngd = no.

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

   find in_mstr where recid(in_mstr) = inrecno exclusive-lock no-error.

   {gpsct04.i &type=""GL""}
   {gpsct04.i &type=""CUR""}

END PROCEDURE.
