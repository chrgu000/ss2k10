/* apvomtb.p  - AP VOUCHER MAINTENANCE - Line Distribution              */
/* Copyright 1986-2000 QAD Inc., Carpinteria, CA, USA.                  */
/* All rights reserved worldwide.  This is an unpublished work.         */
/*F0PN*/ /*V8:ConvertMode=Maintenance                                   */
/*V8:RunMode=Character,Windows */
/* REVISION: 4.0      LAST MODIFIED: 04/13/88            by: FLM *A108  */
/* REVISION: 6.0      LAST MODIFIED: 05/09/91            by: MLV *D630* */
/*                                   05/31/91            by: MLV *D667* */
/*                                   06/06/91            by: MLV *D674* */
/*                                   06/14/91            by: MLV *D689* */
/* REVISION: 7.0      LAST MODIFIED: 08/12/91            by: MLV *F001* */
/*                                   08/12/91            by: MLV *F002* */
/*                                   11/01/91            by: MLV *F031* */
/*                                   01/21/92            by: MLV *F090* */
/*                                   02/05/92            by: MLV *F164* */
/*                                   03/22/92            by: TMD *F303* */
/*                                   04/13/92            by: MLV *F365* */
/*                                   05/18/92            by: MLV *F510* */
/*                                   06/24/92            by: JJS *F681* */
/*                                   07/06/92            by: MLV *F725* */
/* REVISION: 7.3      Last Modified: 07/24/92            by: MPP *G004* */
/*                                   08/17/92            by: MLV *G031* */
/*                                   08/26/92            by: MLV *G042* */
/*                                   10/12/92            by: MLV *G053* */
/*                                   12/11/92            by: bcm *G418* */
/*                                   01/12/93            by: jms *G537* */
/*                                   04/05/93            by: bcm *G889* */
/*                                   04/15/93            by: bcm *G957* */
/*                                   04/19/93            by: bcm *G978* */
/*                                   04/30/93            by: bcm *GA58* */
/*                                   06/29/93            by: jms *GD32* */
/* REVISION: 7.4      LAST MODIFIED: 07/13/93            by: wep *H037* */
/*                                   08/08/93            by: bcm *H060* */
/*                                   08/23/93            by: jms *H080* */
/*                                   09/29/93            by: bcm *H143* */
/*                                   02/25/94            by: pcd *H199* */
/*                                   11/29/93            by: bcm *H244* */
/*                                   11/30/93            by: pcd *H249* */
/*                                   12/22/93            by: bcm *GI28* */
/*                                   01/24/94            by: wep *H077* */
/*                                   03/03/94            by: bcm *H290* */
/*                                   04/11/94            by: pmf *FM53* */
/*                                   05/10/94            by: pmf *FO06* */
/*                                   06/14/94            by: bcm *H383* */
/*                                   06/15/94            by: bcm *H387* */
/*                                   06/15/94            by: bcm *H389* */
/*                                   08/10/94            by: bcm *H478* */
/*                                   08/12/94            by: str *H479* */
/*                                   09/06/94            by: bcm *H505* */
/* REVISION: 7.4      LAST MODIFIED: 09/12/94            by: slm *GM17* */
/*                                   09/15/94            by: ljm *GM57* */
/*                                   10/06/94            by: str *FS09* */
/*                                   10/17/94            by: ljm *GN36* */
/*                                   10/27/94            by: ame *FS90* */
/*                                   11/07/94            by: str *FT44* */
/*                                   02/16/95            by: jzw *H0BF* */
/*                                   02/22/95            by: str *F0JB* */
/*                                   02/24/95            by: jzw *H0BM* */
/*                                   03/02/95            by: wjk *F0KL* */
/*                                   04/10/95            by: srk *H0CG* */
/*                                   04/24/95            by: wjk *H0CS* */
/* (Split out apvomtb1.p)            06/19/95            by: jzw *G0Q7* */
/*                                   07/06/95            by: jzw *H0F6* */
/*                                   11/06/95            by: jzw *G1C7* */
/*                                   11/09/95            by: mys *H0GT* */
/*                                   01/24/96            by: jzw *H0J6* */
/*                                   01/31/96            by: jzw *H0J7* */
/* REVISION: 8.5     LAST MODIFIED:  10/02/95            by: mwd *J053* */
/* REVISION: 8.5     LAST MODIFIED:  03/18/96   BY: *J0CV* Robert Wachowicz*/
/* REVISION: 8.5     LAST MODIFIED:  07/09/96            by: ame *H0M0*    */
/*                                   07/15/96   BY: *J0VY* Marianna Deleeuw*/
/* REVISION: 8.5     LAST MODIFIED:  10/25/96            by: rxm *H0NN*    */
/* REVISION: 8.6     LAST MODIFIED:  01/23/97   BY: *K01G* Barry Lass      */
/*                                   02/17/97   BY: *K01R* E. Hughart      */
/*                                   03/10/97   BY: *K084* Jeff Wootton    */
/* REVISION: 8.6     LAST MODIFIED:  08/14/97   BY: *J1Z2* Irine D'mello   */
/* REVISION: 8.6     LAST MODIFIED:  10/03/97   BY: *J22C* Irine D'mello   */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane       */
/* REVISION: 8.6E     LAST MODIFIED: 05/19/98   BY: *J2M1* Dana Tunstall   */
/* REVISION: 8.6E     LAST MODIFIED: 07/23/98   BY: *L03K* Jeff Wootton    */
/* REVISION: 9.0      LAST MODIFIED: 03/10/99   BY: *M0B3* Michael Amaladhas */
/* REVISION: 9.0      LAST MODIFIED: 03/13/99   BY: *M0BD* Alfred Tan        */
/* Pre-86E commented code removed, view in archive revision 1.13           */
/* REVISION: 9.1      LAST MODIFIED: 10/01/99   BY: *N014* Murali Ayyagari  */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane */
/* REVISION: 9.1      LAST MODIFIED: 08/11/00   BY: *N0KK* jyn              */
/* REVISION: 9.1      LAST MODIFIED: 11/22/00   BY: *L15T* Veena Lad        */
/* REVISION: 9.1      LAST MODIFIED: 10/19/00 BY: *N0W0* BalbeerS Rajput  */
/****************************************************************************/
/*!
    apvomtb.p - AP Voucher Maintenance - Line Distribution
*/

/*! parameters:
    called_by   integer         0 - apvomt.p
                                1 - aprvmt.p
*/

         {mfdeclre.i}
/*N0W0*/ {cxcustom.i "APVOMTB.P"}
{gplabel.i} /* EXTERNAL LABEL INCLUDE */

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE apvomtb_p_1 "Ln"
/* MaxLen: Comment: */

&SCOPED-DEFINE apvomtb_p_2 "Control"
/* MaxLen: Comment: */

&SCOPED-DEFINE apvomtb_p_3 "Batch Ctrl"
/* MaxLen: Comment: */

&SCOPED-DEFINE apvomtb_p_4 "Ctrl"
/* MaxLen: Comment: */

&SCOPED-DEFINE apvomtb_p_5 " Tax Distribution "
/* MaxLen: Comment: */

&SCOPED-DEFINE apvomtb_p_6 " Distribution "
/* MaxLen: Comment: */

&SCOPED-DEFINE apvomtb_p_7 " Batch / Voucher "
/* MaxLen: Comment: */

&SCOPED-DEFINE apvomtb_p_8 "Tot"
/* MaxLen: Comment: */

&SCOPED-DEFINE apvomtb_p_9 "Tax"
/* MaxLen: Comment: */

&SCOPED-DEFINE apvomtb_p_10 "Vchr All"
/* MaxLen: Comment: */

&SCOPED-DEFINE apvomtb_p_11 "Voucher"
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */

         {gldydef.i}
         {gldynrm.i}
/*N0W0*/ {&APVOMTB-P-TAG1}

         define input parameter called_by as integer.

         define new shared variable base_det_amt like glt_amt.
         define new shared variable undo_all     like mfc_logical.
         define new shared variable tax_flag     like mfc_logical.
         define new shared variable recalc_tax   like mfc_logical.
         define new shared variable vod_amt_old  as character.
         define new shared variable vod_amt_fmt  as character.

         define shared variable base_amt like ap_amt.
         define shared variable jrnl like glt_ref.
         define shared variable old_amt like ap_amt.
         define shared variable aptotal like ap_amt label {&apvomtb_p_2}.
         define shared variable fill-all like mfc_logical label {&apvomtb_p_10}.
         define shared variable new_vchr like mfc_logical.
         define shared variable ap_recno as recid.
         define shared variable vo_recno as recid.
         define shared variable vd_recno as recid.
         define shared variable old_vend like ap_vend.
         define shared variable vod_recno as recid.
         define shared variable curr_amt like glt_curr_amt.
         define shared variable ba_recno as recid.
         define shared variable totinvdiff like ap_amt.
         define shared variable yes_char   as character format "x(1)".
         define shared variable no_char    as character format "x(1)".
         define shared variable old_vo_amt like ap_amt.
         define shared variable zone_to    like txe_zone_to.
         define shared variable zone_from  like txe_zone_from.
         define shared variable tax_class  like ad_taxc no-undo.
         define shared variable tax_usage     like tx2_tax_usage no-undo.
         define shared variable tax_taxable like ad_taxable no-undo.
         define shared variable tax_in      like ad_tax_in no-undo.
         define shared variable process_tax like mfc_logical.
         define shared variable tax_tr_type like tx2d_tr_type.
         define shared variable pmt_exists  like mfc_logical.
         define shared variable taxchanged  as logical no-undo.
         define shared variable rndmthd     like rnd_rnd_mthd.
/*L15T*/ define shared variable l_flag      like mfc_logical no-undo.

         define variable yn            like mfc_logical.
         define variable del-yn        like mfc_logical initial no.
         define variable apref         like ap_ref.
         define variable vchr_ln       like vod_ln.
         define variable last_ln       like vod_ln.
         define variable vchr_type     like vod_type label "".
         define variable set_sub       as integer initial 0.
         define variable set_mtl       as integer initial 0.
         define variable gltline       like glt_line.
         define variable term-disc     as decimal.
         define variable taxable_amt   like ard_amt.
         define variable i             as integer.
         define variable tax           like ard_amt.
         define variable glvalid       like mfc_logical.
         define variable tax_nbr       like tx2d_nbr.
         define variable tax_env       like txed_tax_env.
         define variable tax_edit      like mfc_logical initial false.
/*N014*  define variable tax_acct      like vod_acct. */
/*N014*  define variable tax_cc        like vod_cc. */
         define variable tax_total     like tx2d_totamt.
         define variable vtclass       as character extent 3.
         define variable j             as integer.
         define variable new_vchr1     like mfc_logical.
         define variable undo_taxpop   like mfc_logical initial false.
         define variable retval        as integer.
         define variable rndamt        like glt_amt.
/*J2M1*/ define variable edit_flag     like mfc_logical initial yes no-undo.
/*L03K*/ define variable mc-error-number like msg_nbr no-undo.

         /* DEFINE SHARED CURRENCY DEPENDENT FORMATTING VARIABLES */
         {apcurvar.i}

         define new shared frame c.

         define workfile vtw_wkfl
            field vtw_class  like vt_class format "x(2)"
            field vtw_amt    as decimal
            field vtw_entity like vod_entity.
         define buffer voddet    for vod_det.
         define buffer vod_buff  for vod_det.

         /* DEFINE VARIABLES FOR GPGLEF.P (GL CALENDAR VALIDATION) */
         {gpglefdf.i}

         /*V8! pause 0 before-hide. */

         /*MOVED FORM FROM BELOW*/
/*N014*  ADDED V8! space(.2) TO FORM BELOW */
         form
            vod_det.vod_acct
/*N014*/    vod_det.vod_sub                      /*V8! space(.2) */
            vod_det.vod_cc                       /*V8! space(.2) */
/*N014*            vod_det.vod_entity                   /*V8! space(.2) */ */
            vod_det.vod_project                  /*V8! space(.2) */
/*N014*/    vod_det.vod_entity                   /*V8! space(.2) */
/*N014*     vod_det.vod_desc */
/*N014*/    vod_det.vod_desc    format "x(14)"   /*V8! space(.2) */
            vod_det.vod_amt
         with frame v down width 80
            title color normal (getFrameTitle("TAX_DISTRIBUTION",24)).

            /* SET EXTERNAL LABELS */
            setFrameLabels(frame v:handle).

         form
            ba_batch       colon 10
            ba_ctrl        colon 31 format "->>>>>>>,>>>,>>9.999"
                           label {&apvomtb_p_3}
            ba_total       colon 57 format "->>>>>>>,>>>,>>9.999"
                           label {&apvomtb_p_8}
            ap_ref         colon 10 format "x(8)" label {&apvomtb_p_11}
            ap_curr        no-label
            aptotal        colon 31 label {&apvomtb_p_4}
            ap_amt         colon 57 label {&apvomtb_p_8}
         with side-labels frame c
            title color normal (getFrameTitle("BATCH_/_VOUCHER",23)) width 80.

            /* SET EXTERNAL LABELS */
            setFrameLabels(frame c:handle).

         do on endkey undo, leave:
            find ap_mstr where recid(ap_mstr) = ap_recno no-lock no-error.
            find vo_mstr where recid(vo_mstr) = vo_recno no-lock no-error.
            find vd_mstr where recid(vd_mstr) = vd_recno no-lock no-error.
            find ba_mstr where recid(ba_mstr) = ba_recno
            exclusive-lock
            no-error.
            new_vchr1 = new_vchr.

            find first gl_ctrl no-lock.
            if gl_vat or gl_can then
            find first vtc_ctrl no-lock.
            find first icc_ctrl no-lock no-error.
            if not available icc_ctrl then create icc_ctrl.
            if recid(icc_ctrl) = -1 then .
            find first apc_ctrl no-lock.

/*N0W0*/    {&APVOMTB-P-TAG2}
            assign
               vod_amt_old = vod_amt:format in frame v

               /* SET FORMAT FOR VOUCHER DETAIL AMT */
               vod_amt_fmt = vod_amt_old.
            {gprun.i ""gpcurfmt.p"" "(input-output vod_amt_fmt,
                                      input rndmthd)"}

            assign ap_amt:format  in frame c = ap_amt_fmt
                   aptotal:format in frame c = ap_amt_fmt.

/*N0W0*/    {&APVOMTB-P-TAG3}
            display
               ba_batch
               ba_ctrl
               ba_total + ap_amt @ ba_total
               ap_ref
               aptotal
               ap_amt
               ap_curr
            with frame c.

            last_ln = 0.

            if not pmt_exists then
/*N0W0*/    {&APVOMTB-P-TAG4}
            mainloop:
            repeat:
               /* INPUT DISTRIBUTION ENTRIES */

               loopg:
               repeat with frame g width 80:
                  /* DISPLAY SELECTION FORM */
                  form
                     vchr_ln       label {&apvomtb_p_1}
/*N014*              /*V8! space(.5) */ */
/*N014*/             /*V8! space(.2) */
                     vod_acct
                     /*V8! view-as fill-in size 8.5 by 1 */
/*N014*/             /*V8! space(.2) */
/*N014*/             vod_sub                          /*V8! space(.2) */
/*N014*              vod_cc        no-label           /*V8! space(.2) */ */
/*N014*/             vod_cc                           /*V8! space(.2) */
/*N014*              vod_entity                       /*V8! space(.2) */ */
                     vod_project                      /*V8! space(.2) */
/*N014*/             vod_entity                       /*V8! space(.2) */
                     vod_tax_at    column-label {&apvomtb_p_9}
                     /*V8! space(.2) */
                     vod_desc
/*N014*              format "x(21)" */
/*N014*/             format "x(8)"
                     /*V8! space(.2) */
                     vod_amt
                     /*V8! view-as fill-in size 16 by 1 space(.2) */
                     vod_type
                     /*V8! view-as fill-in size 3 by 1 */
                  with frame g
                  width 80
                  title color normal (getFrameTitle("DISTRIBUTION",19))
                  no-attr-space.

                  /* SET EXTERNAL LABELS */
                  setFrameLabels(frame g:handle).

                  aptotal:format in frame c = ap_amt_fmt.

                  display aptotal with frame c.

                  /* SEE IF ANY DETAIL RECORDS EXIST */
                  find last vod_det where vod_ref = vo_ref no-lock no-error.
                  if not available vod_det then do:
                     vchr_ln = 1.
                     vchr_type = "".
/*N0W0*/             {&APVOMTB-P-TAG5}
                     display
                        vchr_ln
                        vd_pur_acct @ vod_acct
/*N014*/                vd_pur_sub @ vod_sub
                        vd_pur_cc @ vod_cc
                        vchr_type @ vod_type
                     with frame g.
/*N0W0*/             {&APVOMTB-P-TAG6}

                  /* DISPLAY vod_tax_at USING THE VARIABLES yes_char AND */
                  /* no_char, AS "y" AND "n" WOULD NOT BE TRANSLATED     */
                  /* DEFAULT vod_tax_at TO TAXABLE STATUS OF THE HEADER  */

                    if {txnew.i} then
                       if tax_taxable = yes then
                          display yes_char @ vod_tax_at with frame g.
                       else
                          display no_char  @ vod_tax_at with frame g.
/*N0W0*/               {&APVOMTB-P-TAG7}

                     find ac_mstr where
/*N014*/             ac_code = vd_pur_acct
/*N014*              ac_code = substring(vd_pur_acct,1,(8 - global_sub_len))
*/
                     no-lock no-error.

                     if available ac_mstr then do:
                        display ac_desc @ vod_desc with frame g.
                     end.
                     if vo_po <> ""
                     and not can-find(po_mstr where po_nbr = vo_po)
                     and not can-find(first prh_hist where prh_nbr = vo_po)
                     and can-find(first wo_mstr where wo_nbr = vo_po) then do:
                        find first wo_mstr where wo_nbr = vo_po
                        no-lock no-error.
                        if available wo_mstr then do:
                           display
                              wo_acct @ vod_acct
/*N014*/                      wo_sub @ vod_sub
                              wo_cc @ vod_cc
                              wo_project @ vod_project
                           with frame g.
                           find ac_mstr where
/*N014*/                   ac_code = wo_acct
/*N014*                  ac_code = substring(wo_acct,1,(8 - global_sub_len)) */
                           no-lock no-error.
                           if available ac_mstr then
                              display ac_desc @ vod_desc with frame g.
                        end.
                     end.
                  end. /* IF NOT AVAILABLE VOD_DET */
                  if available vod_det then do:

                     /*DISPLAY EXISTING DETAIL RECORDS*/
                     vchr_ln = vod_ln + 1.
                     vchr_type = "".
/*J2M1*/             /* REFRESH SCREEN FIRST TIME AND AFTER EDIT */
/*J2M1**             if last_ln <= 12 then do: */
/*J2M1*/             if edit_flag then do:
                        clear frame g all no-pause.
                        for each vod_det where vod_ref = vo_ref:

                           assign vod_amt:format in frame g = vod_amt_fmt.

                           if {txnew.i} then do:

/*N0W0*/                      {&APVOMTB-P-TAG8}
                              display
                                 vod_ln @ vchr_ln
                                 vod_acct
/*N014*/                         vod_sub
                                 vod_cc
/*N014*                                 vod_entity */
                                 vod_project
/*N014*/                         vod_entity
                                 substring(vod_tax_at,1,1) @ vod_tax_at
                                 vod_desc
                                 vod_amt
                                 vod_type
                              with frame g.
/*N0W0*/                      {&APVOMTB-P-TAG9}
                           end.
                           else
                           display vod_ln @ vchr_ln
                              vod_acct
/*N014*/                      vod_sub
                              vod_cc
/*N014*                              vod_entity */
                              vod_project
/*N014*/                      vod_entity
                              vod_tax_at
                              vod_desc
                              vod_amt
                              vod_type
                           with frame g.

                           down 1 with frame g.
                        end.
                     end.
                  end. /* IF AVAILABLE VOD_DET */

                  if apc_confirm = no and vo_confirm = yes and not new_vchr1
                     then do:
                     {mfmsg.i 2214 2}
                     /* VOUCHER CONFIRMED.                      */
                     /* NO MODIFICATIONS WITH GL IMPACT ALLOWED */
                     pause.
                     leave mainloop.
                  end.

                  display vchr_ln with frame g.
                  setg-1:
                  do on error undo, retry:
                     set vchr_ln with frame g editing:
                        /*NEXT/PREVIOUS*/
                        {mfnp01.i vod_det vchr_ln vod_ln vo_ref vod_ref vod_ref}
                        if recno <> ? then do:
/*N0W0*/                   {&APVOMTB-P-TAG10}
                           assign vod_amt:format in frame g = vod_amt_fmt.
                           display
                              vod_ln @ vchr_ln
                              vod_acct
/*N014*/                      vod_sub
                              vod_cc
/*N014*                              vod_entity */
/*N014*                              vod_project vod_desc */
/*N014*/                      vod_project
/*N014*/                      vod_entity
/*N014*/                      vod_desc
                              vod_amt vod_type
                           with frame g.
                           if {txnew.i} then
/*N0W0*/                      {&APVOMTB-P-TAG11}
                              display substring(vod_tax_at,1,1) @ vod_tax_at
                              with frame g.
/*N0W0*/                      {&APVOMTB-P-TAG12}
                           else
                              display vod_tax_at with frame g.
                        end.
                        else  /* NEW (EMPTY) RECORD*/
                           /* IF GLOBAL TAX MANAGEMENT,   */
                           /* DEFAULT VOD_TAX_AT to "N"   */
                           /* ELSE DEFAULT vod_tax_at     */
                           /* TO TAXABLE STATUS OF HEADER */
                           if {txnew.i} then
                              if tax_taxable = yes then
                                 display yes_char @ vod_tax_at with frame g.
                              else
                                 display no_char  @ vod_tax_at with frame g.

                     end.
                     if not can-find(vod_det where vod_ref = vo_ref and
                     vod_ln = vchr_ln) then do:
                        {mfmsg.i 1 1} /* ADDING NEW RECORD */
/*J2M1*/                assign edit_flag = no.
                     end.
/*J2M1*/             else assign edit_flag = yes.
                  end. /* SETG-1 */

                  ststatus = stline[3].
                  status input ststatus.
                  apply lastkey.

                  find first vod_det
                  where vod_ref = vo_ref
                  and vod_ln = vchr_ln
                  exclusive-lock no-error.
                  if not available vod_det then do:
                     create vod_det.
                     vod_entity = ap_entity.
/*N0W0*/             {&APVOMTB-P-TAG13}
                     display vod_entity with frame g.
                     if gl_vat then do:
                        if vd_taxable then vod_tax_at = vtc_vt_class.
                        else do:
                           find first vt_mstr where vt_tax_pct = 0 and
                           vt_start <= today and
                           vt_end >= today no-lock no-error.
                           if available vt_mstr then vod_tax_at = vt_class.
                        end.
                        display vod_tax_at with frame g.
                     end.

                     setg-2:
                     do on error undo, retry:

/*N0W0*/                {&APVOMTB-P-TAG14}
                        prompt-for
                           vod_det.vod_acct
/*N014*/                   vod_sub
                           vod_cc
/*N014*                           vod_entity */
                           vod_project
/*N014*/                   vod_entity
                           vod_tax_at
                        with frame g.
/*N0W0*/                {&APVOMTB-P-TAG15}

                        assign
                           vod_ref = vo_ref
                           vod_dy_code = dft-daybook
                           vod_ln = vchr_ln
                           vod_acct
/*N014*/                   vod_sub
                           vod_cc
                           vod_project
                           vod_tax_at
                           vod_entity
                           vod_type = "".
                        if recid(vod_det) = -1 then .
/*N0W0*/                {&APVOMTB-P-TAG16}

                        if {txnew.i} then do:
/*L03K*/                   assign
                              vod_tax_usage = tax_usage
                              vod_taxc      = tax_class

                              /* DEFAULT TO TAXABLE STATUS OF THE HEADER */
                              vod_taxable   = tax_taxable

                              /* DEFAULT TO TAX INCLUDED STATUS OF THE HEADER */
                              vod_tax_in    = tax_in

                              vod_tax_env   = vo_tax_env
                              recalc_tax    = true.
                              /* SET WHEN ADDING NEW DETAIL*/
                        end.

                        if vo_curr <> base_curr then do:
                           find ac_mstr where
/*N014*/                   ac_code = vod_acct
/*N014*                  ac_code = substring(vod_acct,1,(8 - global_sub_len)) */
                           no-lock no-error.
                           if available ac_mstr
/*L03K*                    BEGIN DELETE
 *                         and ac_curr <> vo_curr
 *                         and ac_curr <> base_curr then do:
 *L03K*                    END DELETE */
/*L03K*/                   then do:
/*L03K*/                      /* CHECK ACCOUNT CURRENCY AGAINST VOUCHER, */
/*L03K*/                      /* WITH UNION TRANSPARENCY ALLOWED         */
/*L03K*/                      {gprunp.i "mcpl" "p" "mc-chk-transaction-curr"
                               "(input ac_curr,
                                 input vo_curr,
                                 input ap_effdate,
                                 input true,
                                 output mc-error-number)"}
/*L03K*/                      if mc-error-number <> 0 then do:
                                 {mfmsg.i 134 3}
                                 /*ACCT CURR MUST BE EITHER TRANS OR BASE CURR*/
                                 next-prompt vod_det.vod_acct with frame g.
                                 undo setg-2, retry.
                              end.
/*L03K*/                   end.
                        end.

                        /* TRY THE WHOLE ACCOUNT FIELD FIRST */
                        find al_mstr where al_code = vod_acct no-lock no-error.
/*N014*                BEGIN DELETE  - It is redundant
 *                        /* THERE MIGHT BE A SUB-ACCOUNT SPECIFIED */
 *                       if not available al_mstr then
 *                          find al_mstr where
 *                          al_code = substring(vod_acct,1,(8 - global_sub_len))
 *                          no-lock no-error.
 *N014*                 END DELETE */

                        if available al_mstr then do:
                           vod_desc = al_desc.
                        end.
                        else do:
                           find ac_mstr where
/*N014*/                   ac_code = vod_acct
/*N014*                 ac_code = substring(vod_acct,1,(8 - global_sub_len)) */
                           no-lock no-error.
                           if available ac_mstr then do:
                              vod_desc = ac_desc.
                           end.
                        end.

/*N014*                        {gprun.i ""gpglver1.p"" "(input vod_acct,
 *                                                 input ?,
 *                                                 input vod_cc,
 *N014*                                                 output glvalid)" } */

/*N014*/                /* INITIALIZE SETTINGS */
/*N014*/                {gprunp.i "gpglvpl" "p" "initialize"}

/*N014*/                /* ACCT/SUB/CC/PROJECT VALIDATION */
/*N014*/                {gprunp.i "gpglvpl" "p" "validate_fullcode"
                          "(input vod_acct,
                            input vod_sub,
                            input vod_cc,
                            input vod_project,
                            output glvalid)"}

                        if glvalid = no then do:
                           next-prompt vod_acct with frame g.
                           undo, retry.
                        end.

                        /* VERIFY ENTITY*/
                        if vod_entity <> glentity then do:
                           find en_mstr where en_entity = vod_entity no-lock
                           no-error.
                           if not available en_mstr then do:
                              {mfmsg.i 3061 3}
                              /*INVALID ENTITY*/
                              next-prompt vod_entity with frame g.
                              undo, retry.
                           end.
                           release en_mstr.
                        end.

                        /* VALIDATE ENTITY FOR DAYBOOKS */
                        if daybooks-in-use then do:
                           {gprun.i ""gldyver.p"" "(input ""AP"",
                                                    input ""VO"",
                                                    input ap_dy_code,
                                                    input vod_entity,
                                                    output daybook-error)"}
                           if daybook-error then do:
                              {mfmsg.i 1674 2}
                              /* WARNING: DAYBOOK DOES NOT MATCH ANY DEFAULT */
                              pause.
                           end.
                        end.

                        /* VERIFY GL CALENDAR FOR SPECIFIED ENTITY */
                        /* (SKIP VALIDATION IF RECURRING VOUCHER)  */
                        if vo_confirmed
                        and called_by <> 1 then do:
                           {gpglef02.i &module = ""AP""
                                       &entity = vod_entity
                                       &date   = ap_effdate
                                       &prompt = "vod_entity"
                                       &frame  = "g"
                                       &loop   = "setg-2"}
                        end.

                        /* THIS CODE WILL NOT EXECUTE WHEN {txnew.i} */
                        if gl_vat or gl_can then do:
                           /* Use the Voucher Tax Date for taxes not effdate */
                           find last vt_mstr where vt_class = vod_tax_at and
                           vt_start <= vo_tax_date and vt_end >= vo_tax_date
                           no-lock no-error.
                           if not available vt_mstr then do:
                              if gl_vat then do:
                                 {mfmsg.i 111 3}
                                 /* VAT CLASS MUST EXIST */
                              end.
                              else do:
                                 {mfmsg.i 131 3}
                                 /* GST CLASS MUST EXIST */
                              end.
                              next-prompt vod_tax_at with frame g.
                              undo, retry.
                           end.
                           /* VALIDATE FEWER THAN 4 TAX CLASSES */
                           {gpvatchk.i &counter = j
                                       &buffer = vod_buff
                                       &ref = vo_ref
                                       &buffref = vod_ref
                                       &file = vod_det
                                       &taxc = vod_tax_at
                                       &frame = g
                                       &undo_yn = true
                                       &undo_label = setg-2}
                        end.
                        else if gl_can = no and gl_vat = no and vod_tax_at <> ""
                        and vod_tax_at <> no_char and vod_tax_at <> yes_char
                        then do:
                           {mfmsg.i 117 3}
                           /*ERROR: TAX FIELD MUST BE Y,N, OR BLANK*/
                           next-prompt vod_tax_at with frame g.
                           undo, retry.
                        end.
/*N0W0*/                {&APVOMTB-P-TAG17}
                     end.
                  end. /* IF NOT AVAILABLE VOD_DET */
                  else /* VOD_DET AVAILABLE */
                  do:
/*N0W0*/             {&APVOMTB-P-TAG18}
                     /* IF VOUCHER CREATED BY EARLIER VERSION OF */
                     /* APVOMTB.P, IT WILL NOT HAVE VOD_TAX_ENV. */
                     vod_tax_env = vo_tax_env.
                     /* AND WILL NOT HAVE VOD_TAXABLE */
                     vod_taxable = (vod_tax_at = "yes").
                     /* AND WILL NOT HAVE VOD_TAX_IN, WHICH THE  */
                     /* SCHEMA UPDATE WILL HAVE SET TO FALSE.    */

                     assign vod_amt:format in frame g = vod_amt_fmt.
                     display vod_acct
/*N014*/                     vod_sub
                             vod_cc
/*N014*                             vod_entity */
                             vod_project
/*N014*/                     vod_entity
                             vod_desc
                             vod_amt with frame g.
                     /* VERIFY GL CALENDAR FOR SPECIFIED ENTITY */
                     /* (SKIP VALIDATION IF RECURRING VOUCHER)  */
                     if vo_confirmed
                     and called_by <> 1 then do:
                        {gpglef02.i &module = ""AP""
                                    &entity = vod_entity
                                    &date   = ap_effdate
                                    &prompt = "vod_entity"
                                    &frame  = "g"}
                     end.
                     if {txnew.i} then do:
/*N0W0*/                {&APVOMTB-P-TAG19}
                        display substring(vod_tax_at,1,1) @ vod_tax_at
                                with frame g.
/*N0W0*/                {&APVOMTB-P-TAG20}
                        /* GTM IS ABLE TO CHANGE TAX DATA AND RECALCULATE */
                        if vod_tax = "" /* NOT TAX DETAIL LINE */
                        and vod_type <> "R" /* NOT A RECEIVER LINE */
                        then
                           set
                              vod_tax_at
                       with frame g.
                     end.
                     else
                        display vod_tax_at with frame g.

                     /* BACK OUT MEMO TOTAL */
                     ap_amt = ap_amt - vod_amt.
/*L03K*/             ap_base_amt = ap_base_amt - vod_base_amt.

                  end. /* IF AVAILABLE VOD_DET */

                  /* WHETHER VOD-DET IS NEW OR OLD -- */

                  /* DISPLAY vod_tax_at USING THE VARIABLES yes_char AND */
                  /* no_char AS "y" AND "n" WOULD NOT BE TRANSLATED      */

                  if (vod_tax = "" and {txnew.i}
                  and vod_type <> "R" /* R = RECEIVER DETAIL */
                  and (input vod_tax_at  = ""
                    or input vod_tax_at  = yes_char)) or batchrun = yes
                  then do:

                     taxloop:
                     do on error undo, retry:

                        if vod_tax_at = "yes" or
                        input vod_tax_at = yes_char then
                           vod_taxable = true.
                        else
                        if vod_tax_at = "" or input vod_tax_at = "" then
                        do:
/*L03K*/                   assign
                              vod_taxable = false
                              vod_tax_in = false.
                        end.

                        /* TAX MANAGEMENT TRANSACTION POP-UP. */
                        /* PARAMETERS ARE 5 FIELDS AND UPDATEABLE FLAGS, */
                        /* STARTING ROW, AND UNDO FLAG. */
                           {gprun.i ""txtrnpop.p""
                                    "(input-output vod_tax_usage, input true,
                                      input-output vod_tax_env,   input false,
                                      input-output vod_taxc,      input true,
                                      input-output vod_taxable,   input true,
                                      input-output vod_tax_in,    input true,
                                      input 2,
                                      output undo_taxpop)"}
/*L15T**                if undo_taxpop then undo loopg, retry. */

/*L15T*/                /* l_flag IS SET TO true IN BATCH MODE. */
/*L15T*/                if undo_taxpop
/*L15T*/                then
/*L15T*/                   if not batchrun
/*L15T*/                   then
/*L15T*/                      undo loopg, retry.
/*L15T*/                   else do:
/*L15T*/                      l_flag = true.
/*L15T*/                      return.
/*L15T*/                   end. /* ELSE batchrun */
/*N0W0*/                {&APVOMTB-P-TAG21}

                        recalc_tax = true.  /* SET WHEN UPDATING TAX DATA */

                     end. /* TAXLOOP */

/*N0W0*/             {&APVOMTB-P-TAG22}
                     display substring(vod_tax_at,1,1) @ vod_tax_at
                     with frame g.

                     if input vod_tax_at = yes_char then vod_tax_at = "yes".
/*N0W0*/             {&APVOMTB-P-TAG23}

                  end. /* IF VOD_TAX = "" ... */
                  /* SET VOD_TAX_AT for NON TAXABLE*/

                  else if {txnew.i} and vod_tax_at = no_char  then do:
/*L03K*/             assign
                        vod_tax_at = "no"
                        vod_taxable = false
                        vod_tax_in = false.
                  end.

/*L03K*/          assign
                     recno = recid(vod_det)
                     del-yn = no.

                  setloopg: do on error undo, retry:

                     assign vod_amt:format in frame g = vod_amt_fmt.

                     display vod_desc
                             vod_type
                     with frame g.

/*N014*/             if (not ({txnew.i} and vod_tax <> "")) or batchrun then do:
/*N014*/                {gprun.i ""gpdesc.p""
                                  "(input        frame-row(g) + 3,
                                    input-output vod_desc)"}

/*N014*/                if keyfunction(lastkey) = "end-error" or
/*N014*/                   keyfunction(lastkey) = "." then
/*N014*/                   undo loopg, retry.
/*N014*/                display vod_desc with frame g.
/*N014*/             end.

/*N0W0*/             {&APVOMTB-P-TAG24}
                     update
/*N014*                  vod_desc when (not ({txnew.i} and vod_tax <> "")) */
                        vod_amt  when (icc_gl_tran = no or vod_type <> "R") and
                                      (not ({txnew.i} and vod_tax <> ""))
                     with frame g editing:
/*N0W0*/             {&APVOMTB-P-TAG25}
                        if vod_type = "R" then
                           ststatus = stline[3].
                        else
                           ststatus = stline[2].
                        status input ststatus.
                        readkey.
                        /* DELETE */
                        if (lastkey = keycode("F5")
                        or lastkey = keycode("CTRL-D"))
                        and (icc_gl_tran = no or vod_type <> "R")
                        then do:
                           del-yn = yes.
                           {mfmsg01.i 11 1 del-yn} /*CONFIRM DELETE*/
                           if del-yn then leave.
                        end.
                        else apply lastkey.
                     end.  /* DISPLAY... EDITING */

/*L03K*/             /* CONVERT FROM FOREIGN TO BASE CURRENCY */
/*L03K*/             {gprunp.i "mcpl" "p" "mc-curr-conv"
                      "(input vo_curr,
                        input base_curr,
                        input vo_ex_rate,
                        input vo_ex_rate2,
                        input vod_amt,
                        input true, /* ROUND */
                        output vod_base_amt,
                        output mc-error-number)"}.
/*L03K*/             if mc-error-number <> 0 then do:
/*L03K*/                {mfmsg.i mc-error-number 2}
/*L03K*/             end.

/*N0W0*/             {&APVOMTB-P-TAG26}
                     /* CHECK FOR NON ZERO AMOUNT */
                     if vod_amt = 0 then do:
/*N0W0*/             {&APVOMTB-P-TAG27}
                        {mfmsg.i 1161 2}
/*N0W0*/             {&APVOMTB-P-TAG28}
                     end.
                     if vod_amt <> 0 then do:
                        {gprun.i ""gpcurval.p"" "(input vod_amt, input rndmthd,
                                                  output retval)"}
                        if retval <> 0 then do:
                           next-prompt vod_amt with frame g.
                           undo setloopg, retry setloopg.
                        end.
                     end.
/*N0W0*/             {&APVOMTB-P-TAG29}
                     if del-yn or vod_amt = 0 then do:
/*N0W0*/             {&APVOMTB-P-TAG30}
                        delete vod_det.
                        clear frame g.
                        del-yn = no.

                        /* DELETE TAX DISTRIBUTION RECORDS IF ALL */
                        /* TAXABLE LINES HAVE BEEN DELETED */
                        if {txnew.i} and not can-find(first vod_det where
                                     vod_ref = vo_ref and vod_tax_at = "yes")
                        then do:
                           find first vod_det where vod_ref = vo_ref
                              and vod_tax > "" no-lock no-error.
                           if available vod_det then do:
                              /*DELETE tx2d_det AND VOD_DET RECORDS, WRITE */
                              /*REVERSING GL'S                             */
                              {apdeltx.i &looplabel = "deltax"}

                              /* DELETE tx2d_det RECORDS */
                              tax_nbr     = "*".    /* FOR ALL RECEIVERS */
                              {gprun.i ""txdelete.p"" "(input tax_tr_type,
                                                        input vo_ref,
                                                        input tax_nbr)"}
                           end.
                        end. /* IF TXNEW.I AND... */

                        ap_amt:format in frame c = ap_amt_fmt.

                        display
                           ba_total + ap_amt @ ba_total
                           ap_amt with frame c.
                        next loopg.
                     end.  /* IF DEL-YN OR... */

                     /* IF TAX DISTRIBUTION RECORD, GIVE ERROR THAT THE */
                     /* RECORD CANNOT BE UPDATED                          */
                     if {txnew.i} and vod_tax <> "" then do:
                        {mfmsg.i 931 4}
                     end.

                     /* UPDATE MEMO TOTAL */
                     assign ap_amt:format in frame c = ap_amt_fmt
                            ap_amt = ap_amt + vod_amt
/*L03K*/                    ap_base_amt = ap_base_amt + vod_base_amt.

                     display ap_amt
                        ba_total + ap_amt @ ba_total with frame c.
                     last_ln = vod_ln.
                  end.  /* SETLOOPG */
/*N0W0*/          {&APVOMTB-P-TAG31}
               end. /* LOOPG */

               /* CHECK FOR EXISTING TAX LINES IN VOD */
/*N0W0*/       {&APVOMTB-P-TAG32}
               if {txnew.i} then do:
/*N0W0*/       {&APVOMTB-P-TAG33}

                  if can-find(first vod_det where vod_ref = vo_ref)
                  then do:
                     recalc_tax = true.
                     {gprun.i ""apvomth.p""}
                     if undo_all then
                        undo mainloop, leave.
                     else
/*N0W0*/                {&APVOMTB-P-TAG34}
                        leave mainloop.
/*N0W0*/                {&APVOMTB-P-TAG35}
                  end.
                  else
                     leave mainloop.
               end.
               else
               /* WILL BE OMITTED IF {txnew.i} */

               /*CREATE VAT VOD_DET LINES*/
               if process_tax = no then do:
                  if gl_vat or gl_can then do:
                     for each vod_det where vod_det.vod_ref = vo_ref and
                     vod_det.vod_tax = "":
                        find first vt_mstr where vt_ap_acct = vod_det.vod_acct
                        and vt_ap_cc = vod_det.vod_cc
                        and vt_start <= vo_tax_date
                        and vt_end >= vo_tax_date no-lock no-error.
                        if available vt_mstr then vod_det.vod_tax = vt_class.
                     end.
                     leave mainloop.
                  end.
                  else leave mainloop.
               end.
               else do: /*new_vchr*/

                  {apvomtb.i}

                  else leave mainloop.
                  tax_flag = no.

                  /*DISPLAY VAT LINES*/
                  for each vod_det where vod_det.vod_ref =
                      vo_ref and vod_det.vod_tax <> "":

                     assign vod_det.vod_amt:format in frame v = vod_amt_fmt.

                     display vod_det.vod_acct
/*N014*/                     vod_det.vod_sub
                             vod_det.vod_cc
/*N014*                             vod_det.vod_entity */
                             vod_det.vod_project
/*N014*/                     vod_det.vod_entity
                             vod_det.vod_desc
                             vod_det.vod_amt
                     with frame v.

                     if taxchanged then do on endkey undo, leave:
                        {mfmsg.i 96 2} /* PO TAX IS NO VOUCHER TAX IS YES */
                        set vod_det.vod_acct
/*N014*/                    vod_det.vod_sub
                            vod_det.vod_cc
                        with frame v.
                        find ac_mstr where ac_code =
/*N014*/                   vod_det.vod_acct
/*N014*                substring(vod_det.vod_acct,1,(8 - global_sub_len)) */
                           no-lock no-error.
                        if available ac_mstr then do:
                           vod_det.vod_desc = ac_desc.
                           display vod_det.vod_desc with frame v.
                        end.
                     end.

                     down with frame v.

                     tax_flag = yes.

                     /*UPDATE HEADER AMOUNT*/
/*L03K*/             assign
                        ap_amt = ap_amt + vod_det.vod_amt
/*L03K*/                ap_base_amt = ap_base_amt + vod_det.vod_base_amt.
                  end. /* FOR EACH VOD_DET */

                  assign ap_amt:format in frame c = ap_amt_fmt.

                  display ap_amt
                     ba_total + ap_amt @ ba_total with frame c.
                  process_tax = no.

                  if tax_flag then do:
                     if not batchrun then
                     do on endkey undo, retry:
                        /* DO NOT ALLOW ENDKEY, IT WOULD UNDO ALL TAXES. */
                        /* DECISIONS MAY HAVE BEEN ALREADY COMMITTED,    */
                        /* SUCH AS UPDATING AVERAGE COST INCLUDING TAX.  */
                        pause.
                     end.
                     next mainloop.
                  end.
                  else leave mainloop.
               end. /*if new_vchr*/

               /* END OMIT WHEN {txnew.i} */

            end. /*mainloop*/
/*N0W0*/    {&APVOMTB-P-TAG36}

            repeat:
               if ap_amt < 0 and vo_cr_terms <> "" then do:
                  find ct_mstr where ct_code = vo_cr_terms no-lock no-error.
                  if available ct_mstr and ct_dating = yes then do:
                     {mfmsg.i 2200 2} /*invalid terms code - terms deleted*/
                     vo_cr_terms = "".
                     pause.
                  end.
               end.
               leave.
            end.

            if (vo_ndisc_amt > ap_amt and ap_amt > 0) or
            (vo_ndisc_amt < ap_amt and ap_amt < 0)
            then
/*L03K*/       assign
                  vo_ndisc_amt = ap_amt
/*L03K*/          vo_base_ndisc = ap_base_amt.

            if vo_separate and ap_amt < 0 then do:
               {mfmsg.i 4050 2}
               /*VOUCHER AMOUNT NEGATIVE, SETTING SEPARATE CHECK TO NO*/
               vo_separate = no.
            end.

            ba_total = ba_total + ap_amt.

         end. /* DO ON ENDKEY UNDO, LEAVE */

         /* EXECUTE VOUCHER TRAILER FRAME IF VOUCHER IS NOT EMPTY */
/*N0W0*/ {&APVOMTB-P-TAG37}
         if (can-find (first vod_det where vod_ref = vo_ref)
            or can-find (first vph_hist where vph_hist.vph_ref = vo_ref))
            and called_by = 0 then
         do:
/*N0W0*/ {&APVOMTB-P-TAG38}
            hide frame g no-pause.
            /* VOUCHER TRAILER FRAME (HOLD/CONFIRM) */
            {gprun.i ""apvomtb1.p""}
         end.

         do on error undo, retry:
            hide frame c no-pause.
            hide frame g no-pause.
         end.
/*N0W0*/ {&APVOMTB-P-TAG39}
