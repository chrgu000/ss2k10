/* apvomtm.p - AP VOUCHER MAINTENANCE SUBPROGRAM                              */
/* Copyright 1986-2001 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/*F0PN*/ /*V8:ConvertMode=Maintenance                                         */
/*K1Q4*/ /*V8:RunMode=Character,Windows                                       */
/* REVISION: 7.4            CREATED: 01/23/95   by: str *H09W*                */
/*                    LAST MODIFIED: 02/01/95   by: str *H0B2*                */
/*                                   02/08/95   by: str *H0B8*                */
/*                                   03/02/95   by: wjk *F0KL*                */
/*                                   03/20/95   by: wjk *H0C3*                */
/*                                   04/19/95   by: wjk *H0CS*                */
/*                                   05/30/95   by: jzw *F0SJ*                */
/*                                   06/13/95   by: jzw *G0Q7*                */
/*                                   07/06/95   by: jzw *H0F6*                */
/* REVISION: 8.5      LAST MODIFIED: 07/11/95   BY: CDT *J057*                */
/* REVISION: 7.4      LAST MODIFIED: 07/19/95   by: jzw *G0SC*                */
/* REVISION: 8.5      LAST MODIFIED: 09/29/95   BY: mwd *J053*                */
/* REVISION: 7.4      LAST MODIFIED: 11/07/95   by: jzw *H0GQ*                */
/*           8.5                     05/15/96   by: jzw *H0L1*                */
/*           8.5                     05/15/96   by: jzw *H0L1*                */
/* REVISION: 8.6      LAST MODIFIED: 06/11/96   BY: ejh *K001*                */
/*                                   07/27/96   by: *J12H* M. Deleeuw         */
/*                                   10/02/96   by: svs *K007*                */
/*                                   12/11/96   by: bjl *K01S*                */
/*                                   02/17/97   by: *K01R*  E. Hughart        */
/*                                   02/05/97   by: *K06X* E. Hughart         */
/*                                   03/13/97   by  *K097* M. Madison         */
/*                                   04/23/97   by  *J1PH* Robin McCarthy     */
/* REVISION: 8.6      LAST MODIFIED: 06/10/97   BY: *H0ZW* Irine D'mello      */
/* REVISION: 8.6      LAST MODIFIED: 07/18/97   BY: *K0GP* Srinivasa          */
/* REVISION: 8.6      LAST MODIFIED: 10/08/97   BY: *K0N1* Jean Miller        */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane          */
/* REVISION: 8.6E     LAST MODIFIED: 04/27/98   BY: RvSl *L00K*               */
/* REVISION: 8.6E     LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan         */
/* REVISION: 8.6E     LAST MODIFIED: 06/08/98   BY: *J2NG* Samir Bavkar       */
/* REVISION: 8.6E     LAST MODIFIED: 06/15/98   BY: *J2NV* Dana Tunstall      */
/* REVISION: 8.6E     LAST MODIFIED: 07/30/98   BY: *L03K* Jeff Wootton       */
/* Pre-86E commented code removed, view in archive revision 1.20              */
/* REVISION: 8.6E     LAST MODIFIED: 08/19/98   BY: *L06B* Jeff Wootton       */
/* REVISION: 8.6E     LAST MODIFIED: 08/25/98   BY: *L07F* Jeff Wootton       */
/* REVISION: 8.6E     LAST MODIFIED: 09/11/98   BY: *J2ZH* Thomas Fernandes   */
/* REVISION: 8.6E     LAST MODIFIED: 09/29/98   BY: *J2ZR* Abbas Hirkani      */
/* REVISION: 8.6E     LAST MODIFIED: 11/16/98   BY: *J34J* Thomas Fernandes   */
/* REVISION: 8.6E     LAST MODIFIED: 12/19/98   BY: *J379* Hemali Desai       */
/* REVISION: 9.0      LAST MODIFIED: 03/10/99   BY: *M0B3* Michael Amaladhas  */
/* REVISION: 9.0      LAST MODIFIED: 03/13/99   BY: *M0BD* Alfred Tan         */
/* REVISION: 9.1      LAST MODIFIED: 10/01/99   BY: *N014* Murali Ayyagari    */
/* REVISION: 9.1      LAST MODIFIED: 01/19/00   BY: *N077* Vijaya Pakala      */
/* REVISION: 9.1      LAST MODIFIED: 02/03/00   BY: *M0JK* Manish K.          */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane   */
/* REVISION: 9.1      LAST MODIFIED: 06/22/00   BY: *L101* Shilpa Athalye     */
/* REVISION: 9.1      LAST MODIFIED: 08/11/00   BY: *N0KK* jyn                */
/* REVISION: 9.1      LAST MODIFIED: 09/12/00   BY: *L140* Vandna Rohira      */
/* REVISION: 9.1      LAST MODIFIED: 11/22/00   BY: *L15T* Veena Lad          */
/* REVISION: 9.1      LAST MODIFIED: 09/22/00   BY: *N0W0* Mudit Mehta        */
/* REVISION: 9.1      LAST MODIFIED: 02/07/01   BY: *M11F* Jose Alex          */
/* REVISION: 9.1      LAST MODIFIED: 02/28/01   BY: *N0X5* Chris Green        */
/* REVISION: 9.1      LAST MODIFIED: 05/09/01   BY: *M16X* Vihang Talwalkar   */
/* REVISION: 9.1      LAST MODIFIED: 12/07/01   BY: *M1R3* Seema Tyagi        */
/* REVISION: 9.1      LAST MODIFIED: 08/28/06   BY: *EAS056* Apple Tam      */
/******************************************************************************/
/*! THIS SUBPROGRAM UPDATES THE SECOND VOUCHER HEADER FIELDS.
*/

         {mfdeclre.i}
/*N0W0*/ {cxcustom.i "APVOMTM.P"}
{gplabel.i} /* EXTERNAL LABEL INCLUDE */

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE apvomtm_p_1 "Control"
/* MaxLen: Comment: */

&SCOPED-DEFINE apvomtm_p_2 "Batch"
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */

         {gldydef.i}
         {gldynrm.i}

         define shared variable ckdref like ckd_ref.
         define shared variable ap_recno    as recid.
         define shared variable vo_recno    as recid.
         define shared variable vd_recno    as recid.
         define shared variable batch       like ap_batch label {&apvomtm_p_2}.
         define shared variable bactrl      like ba_ctrl.
         define shared variable aptotal     like ap_amt label {&apvomtm_p_1}.
         define shared variable ship-name   like ad_name.
         define shared variable new_vchr    like mfc_logical initial no.
         define shared variable desc1 like  bk_desc format "x(30)".
         define shared variable tax_class   like ad_taxc no-undo.
         define shared variable tax_usage   like ad_tax_usage no-undo.
         define shared variable undo_all    like mfc_logical.
         define shared variable ba_recno    as recid.
         define shared variable undo_tframe like mfc_logical.
         define shared variable auto-select like mfc_logical.
         define shared variable po-attached like mfc_logical.
         define shared variable pmt_exists  like mfc_logical.
         define shared variable base_prepay like vo_prepay.
         define shared variable next_loopc  as logical no-undo.
         define shared variable rndmthd     like rnd_rnd_mthd.
         define shared variable old_curr    like ap_curr.
         define shared variable old_effdate like ap_effdate.
/*L15T*/ define shared variable l_flag      like mfc_logical no-undo.
/*N0W0*/ {&APVOMTM-P-TAG1}
/*M11F*/ define shared variable first_pass  like mfc_logical.

         /* USED FOR SCROLLING WINDOW SWCSBD.P */
         define shared variable supp_bank   like ad_addr no-undo.

         define variable confirm_undo       as logical no-undo.
         define variable valid_acct         as logical no-undo.
         define variable csbdtype           as character format "X(5)" no-undo.
         define variable calcd_disc_date    as date no-undo.
         define variable calcd_due_date     as date no-undo.
         define variable retval             as integer.
/*L03K*/ define variable fixed_rate_not_used like mfc_logical no-undo.
/*L03K*/ define variable curr-is-union      like mfc_logical no-undo.
/*L03K*/ define variable curr-is-member     like mfc_logical no-undo.
/*L03K*/ define variable vo-union           like mu_union_curr no-undo.
/*L03K*/ define variable po-union           like mu_union_curr no-undo.
/*L03K*/ define variable base-union         like mu_union_curr no-undo.
/*J379*/ define variable entity_ok          like mfc_logical   no-undo.
/*M11F*/ define variable l_getrate          like mfc_logical   no-undo.
/*eas056*/ define variable p-inv    as logical no-undo.

         define shared frame a.
         define shared frame voucher.
         define shared frame order.
         define shared frame vohdr1.
         define shared frame vohdr2.
/*N014*/ define shared frame vohdr2a.
         define shared frame vohdr3.

         define buffer apmstr1 for ap_mstr.
         define buffer vomstr1 for vo_mstr.

         /* DEFINE VARIABLES FOR DISPLAY OF VAT REG NUMBER AND COUNTRY CODE */
         {apvtedef.i &var="shared"}

         /* DEFINE VARIABLES USED IN GPGLEF.P (GL CALENDAR VALIDATION) */
         {gpglefdf.i}

         /* GET SHARED CURRENCY DEPENDENT FORMATTING VARIABLES */
         {apcurvar.i}

         /*DEFINE FORM A*/
         {apvofma.i}

         /*DEFINE FORM B*/
         {apvofmb.i}

/*J379*/ /* GET ENTITY SECURITY INFORMATION */
/*J379*/ {glsec.i}

/*L00K   start addition */
         {etvar.i}
         define variable l_rate1 like prh_ex_rate no-undo.
         define variable l_rate2 like vo_ex_rate  no-undo.
/*L00K   end addition */
/*N0W0*/ {&APVOMTM-P-TAG2}

         find ap_mstr where recid(ap_mstr) = ap_recno exclusive-lock.
         find vo_mstr where recid(vo_mstr) = vo_recno exclusive-lock.
         find vd_mstr where recid(vd_mstr) = vd_recno no-lock.
         find first gl_ctrl no-lock.
         find first apc_ctrl no-lock.
         find first adc_ctrl no-lock no-error.

         if vd_misc_cr then do:
            pause 0.
            if ap_remit <> "" then do:
               find ad_mstr where ad_addr = ap_remit no-error.
               if available ad_mstr then
                  display ad_name  ad_line1 ad_line2  ad_line3   ad_city
                          ad_state ad_zip   ad_format ad_country ad_county
                  with frame vohdr3.
            end.
            else do on error undo, leave:
               create ad_mstr.
               ad_format = 0.
/*N0W0*/       {&APVOMTM-P-TAG3}
               if available adc_ctrl then
                  ad_format = adc_format.
               hide frame vohdr2 no-pause.
/*N0W0*/       {&APVOMTM-P-TAG4}
               display ad_format with frame Vohdr3.
               undo, leave.
            end.
            remit: do on error undo, retry:
               prompt-for ad_name
                          ad_line1
                          ad_line2
                          ad_line3
                          ad_city
                          ad_state
                          ad_zip
                          ad_format
                          ad_country
                          ad_county
               with frame vohdr3.
               if input ad_name = "" and ap_remit <> "" then do:
                     /* Blank not allowed */
                     {mfmsg.i 40 4}
                     next-prompt ad_name.
                     undo remit, retry.
               end.
               if input ad_format <> 0 then do:
                  find first code_mstr where code_fldname = "ad_format" and
                             code_value = string(input ad_format)
                  no-lock no-error.
                  if not available code_mstr then do:
                    /* Code does not exist in generalized codes */
                     {mfmsg.i 716 4}
                     next-prompt ad_format.
                     undo remit, retry.
                  end.
               end.
               if ap_remit = "" then do:
                  if input ad_name <> "" then do:
                     {mfactrl.i cmc_ctrl cmc_nbr ad_mstr ad_addr ap_remit}
                     create ad_mstr.
/*N0W0*/            {&APVOMTM-P-TAG5}
                     assign
                     ad_addr    = ap_remit
                     ad_name
                     ad_line1
                     ad_line2
                     ad_line3
                     ad_city
                     ad_state
                     ad_zip
                     ad_format
                     ad_country
                     ad_county
                     ad_type = "remit-to"
                     ad_temp    = yes.
                  end.
               end.
               else do:
                  assign
                  ad_name
                  ad_line1
                  ad_line2
                  ad_line3
                  ad_city
                  ad_state
                  ad_zip
                  ad_format
                  ad_country
                  ad_county.
               end.
            end. /* end of remit */
         end. /* end of miscellaneous supplier */
         else do:
            if ap_remit <> "" then do:
               find ad_mstr where ad_addr = ap_remit no-error.
               if available ad_mstr then delete ad_mstr.
               assign vo_separate = no ap_remit = "".
            end.
         end.
/*N0W0*/ {&APVOMTM-P-TAG6}
         setb: do on error undo, retry:
            if ap_remit <> "" then vo_separate = yes.
            display vo_separate with frame vohdr2.

/*N0W0*/ {&APVOMTM-P-TAG7}
            set
/*L03K*        BEGIN DELETE
 *L00K*        vo_curr when (new_vchr and not po-attached)
 *L00K*             or (new vo_mstr and et_tk_active = true)
 *L03K*        END DELETE */
/*M16X** /*L03K*/       vo_curr when ((new_vchr and not po-attached) */
/*M16X*/       vo_curr when ((new_vchr
/*M16X*/                     and not po-attached
/*M16X*/                     and not (can-find (first vod_det
/*M16X*/                                           where vod_ref = ap_ref)))
/*M11F** /*L03K*/            or new vo_mstr)  */
/*M11F*/                     or (new vo_mstr
/*M11F*/                     and (po-attached
/*M11F*/                     and first_pass)))
               ap_bank
               vo_invoice
               ap_date
               vo_cr_terms
               vo_disc_date
               vo_due_date
               ap_expt_date
               ap_acct        when (new_vchr)
/*N014*/       ap_sub         when (new_vchr)
               ap_cc          when (new_vchr)
               ap_disc_acct   when (new_vchr)
/*N014*/       ap_disc_sub    when (new_vchr)
               ap_disc_cc     when (new_vchr)
               ap_entity      when (new_vchr)
               ap_rmk
               vo__qad02
               vo_separate when (ap_remit = "")
               vo_type
               ap_ckfrm
/*N014*        SECTION MOVED TO NEW FRAME VOHDR2A ****
 *             vo_prepay
 *             vo_ndisc_amt
 *             vo_tax_pct[1]  when (new_vchr    and
 *                                 not gl_can   and
 *                                 not gl_vat   and
 *                                 not {txnew.i})
 *             vo_tax_pct[2]  when (new_vchr    and
 *                                 not gl_can   and
 *                                 not gl_vat   and
 *                                 not {txnew.i})
 *             vo_tax_pct[3]  when (new_vchr    and
 *                                 not gl_can   and
 *                                 not gl_vat   and
 *N014*                            not {txnew.i}) */
               with frame vohdr2
            editing:
               readkey.
/*N0W0*/    {&APVOMTM-P-TAG8}

               if keyfunction (lastkey) = "end-error" then do:
                  {gprun.i ""apvoundo.p"" "(input po-attached,
                                            output confirm_undo)"}
                  if confirm_undo = no then do:
                     next_loopc = yes.
                     undo_all = no.
                  end.
                  else undo_all = yes.
/*L140** /*J2ZH*/ apply lastkey. */

/*L140*/          if undo_all then
/*L140*/             undo setb, return.

                  return.
               end.
               else apply lastkey.
            end. /* EDITING CLAUSE */

            if daybooks-in-use and new vo_mstr
            then do:
               {gprun.i ""gldydft.p"" "(input ""AP"",
                                        input ""VO"",
                                        input ap_entity,
                                        output dft-daybook,
                                        output daybook-desc)"}
               assign ap_dy_code = dft-daybook.
/*N014*        display ap_dy_code with frame vohdr2. */
/*N014*        set ap_dy_code with frame vohdr2. */

            end. /*if daybooks in use */

/*L03K*     if vo_curr = "" then vo_curr = base_curr. */
/*L03K*/    if vo_curr = ""
/*L03K*/    then do:
/*L03K*/       vo_curr = base_curr.
/*L03K*/       display vo_curr with frame vohdr2.
/*L03K*/    end.

/*L03K*/    /* VALIDATE VOUCHER CURRENCY */
/*L03K*/    {gprunp.i "mcpl" "p" "mc-chk-valid-curr"
             "(input vo_curr,
               output mc-error-number)"}
/*L03K*/    if mc-error-number <> 0 then do:
/*L03K*/       {mfmsg.i mc-error-number 4}
/*L03K*/       next-prompt vo_curr with frame vohdr2.
/*L03K*/       undo setb, retry.
/*L03K*/    end.

/*L03K*/    if vo_curr = base_curr
/*L03K*/    or not po-attached
/*L03K*/    then . /* VOUCHER CURRENCY IS OK */
/*L03K*/    else do:
/*L03K*/       /* FIND FIRST ATTACHED PO */
/*L03K*/       for first vpo_det
/*L03K*/       where vpo_ref = vo_ref
/*L03K*/       no-lock,
/*L03K*/       first po_mstr
/*L03K*/       where po_nbr = vpo_po
/*L03K*/       no-lock: end.
/*N0W0*/     {&APVOMTM-P-TAG9}
/*L03K*/       if vo_curr = po_curr
/*L03K*/       then . /* VOUCHER CURRENCY IS OK */
/*L03K*/       else do:

/*L03K*/          /* CHECK IF VO_CURR IS UNION CURRENCY */
/*L03K*/          {gprunp.i "mcpl" "p" "mc-chk-union-curr"
                   "(input vo_curr,
                     input ap_effdate,
                     output curr-is-union)"}
/*L03K*/          if curr-is-union then
/*L03K*/             vo-union = vo_curr.
/*L03K*/          else do:
/*L03K*/             /* CHECK IF VO_CURR IS MEMBER OF A UNION */
/*L03K*/             {gprunp.i "mcpl" "p" "mc-chk-member-curr"
                      "(input vo_curr,
                        input ap_effdate,
                        output vo-union,
                        output curr-is-member)"}
/*L03K*/          end.
/*L03K*/          if vo-union = ""
/*L03K*/          then do:
/*L03K*/             {mfmsg.i 2679 4}
/*L03K*/             /* INVALID TRANSACTION CURRENCY */
/*L03K*/             next-prompt vo_curr with frame vohdr2.
/*L03K*/             undo setb, retry.
/*L03K*/          end.

/*L03K*/          /* CHECK IF BASE_CURR IS UNION CURRENCY */
/*L03K*/          {gprunp.i "mcpl" "p" "mc-chk-union-curr"
                   "(input base_curr,
                     input ap_effdate,
                     output curr-is-union)"}
/*L03K*/          if curr-is-union then
/*L03K*/             base-union = base_curr.
/*L03K*/          else do:
/*L03K*/             /* CHECK IF BASE_CURR IS MEMBER OF A UNION */
/*L03K*/             {gprunp.i "mcpl" "p" "mc-chk-member-curr"
                      "(input base_curr,
                        input ap_effdate,
                        output base-union,
                        output curr-is-member)"}
/*L03K*/          end.

/*L03K*/          if vo-union = base-union
/*L03K*/          then . /* VOUCHER CURRENCY IS OK */
/*L03K*/          else do:

/*L03K*/             /* CHECK IF PO_CURR IS UNION CURRENCY */
/*L03K*/             {gprunp.i "mcpl" "p" "mc-chk-union-curr"
                      "(input po_curr,
                        input ap_effdate,
                        output curr-is-union)"}
/*L03K*/             if curr-is-union then
/*L03K*/                po-union = po_curr.
/*L03K*/             else do:
/*L03K*/                /* CHECK IF PO_CURR IS MEMBER OF A UNION */
/*L03K*/                {gprunp.i "mcpl" "p" "mc-chk-member-curr"
                         "(input po_curr,
                           input ap_effdate,
                           output po-union,
                           output curr-is-member)"}
/*L03K*/             end.

/*L03K*/             if vo-union = po-union
/*L03K*/             then .
/*L03K*/             else do:
/*L03K*/                {mfmsg.i 2679 4}
/*L03K*/                /* INVALID TRANSACTION CURRENCY */
/*L03K*/                next-prompt vo_curr with frame vohdr2.
/*L03K*/                undo setb, retry.
/*L03K*/             end.
/*L03K*/          end. /* VO-UNION <> BASE-UNION */
/*L03K*/       end. /* VO_CURR <> PO_CURR */
/*N0W0*/       {&APVOMTM-P-TAG10}
/*L03K*/    end. /* PO-ATTACHED */

            /* IF THE CURRENCY IS CHANGED, THEN RESET THE ROUNDING  */
            /* VALUES AND FORMATS                                   */

/*L101*/    /* THE FIELD FORMATS ARE RESET ONLY FOR THE NEW VOUCHER */
/*L101*/    /* INDEPENDENT OF VO_CURR                               */

/*L101*/    if new_vchr
/*L101*/    then do:

/*L101*/       /* THE ROUNDING METHOD IS RESET IF THE CURRENCY IS CHANGED */

               if vo_curr <> old_curr or
                  old_curr = ""
               then do:
/*L03K*        {gpcurmth.i "vo_curr" */
/*L03K*                    "3" */
/*L03K*                    "undo setb, retry setb" */
/*L03K*                    "pause 0" } */
/*L03K*/          /* GET ROUNDING METHOD FROM CURRENCY MASTER */
/*L03K*/          {gprunp.i "mcpl" "p" "mc-get-rnd-mthd"
                   "(input vo_curr,
                     output rndmthd,
                     output mc-error-number)"}
/*L03K*/          if mc-error-number <> 0 then do:
/*L03K*/             {mfmsg.i mc-error-number 3}
/*L03K*/             undo setb, retry setb.
/*L03K*/          end. /* IF MC-ERROR-NUMBER <> 0 */

/*M11F*/          if new_vchr
/*M11F*/             and not first_pass
/*M11F*/          then
/*M11F*/             l_getrate = Yes.

/*L101*/       end. /* IF VO_CURR <> OLD_CURR ...  */

               /* DETERMINE CURRENCY DEPENDENT FORMATS */
               {apcurfmt.i}

               /* SET CURRENCY FORMATS FOR DISPLAY FRAMES */
               assign
                  ap_amt:format in frame vohdr1        = ap_amt_fmt
                  aptotal:format in frame vohdr1       = ap_amt_fmt
/*N014*           vo_prepay:format in frame vohdr2     = vo_prepay_fmt */
/*N014*           vo_hold_amt:format in frame vohdr2   = vo_holdamt_fmt */
/*N014*           vo_ndisc_amt:format in frame vohdr2  = vo_ndisc_fmt */
/*N014*/          vo_prepay:format in frame vohdr2a    = vo_prepay_fmt
/*N014*/          vo_hold_amt:format in frame vohdr2a  = vo_holdamt_fmt
/*N014*/          vo_ndisc_amt:format in frame vohdr2a = vo_ndisc_fmt
                  old_curr = vo_curr.

/*J2ZR*/       if aptotal <> 0 then do:
/*J2ZR*/          {gprun.i ""gpcurrnd.p"" "(input-output aptotal,
                        input rndmthd)"}
/*J2ZR*/       end.
            end.  /* IF NEW_VCHR */

/*N014*     CODE RELOCATED BELOW AFTER VALIDATIONS FOR FRAME VOHDR2 FIELDS ***
 *          if vo_prepay <> 0 then do:
 *             {gprun.i ""gpcurval.p"" "(input vo_prepay, input rndmthd,
 *                                       output retval)"}
 *             if retval <> 0 then do:
 *                next-prompt vo_prepay with frame vohdr2.
 *                undo setb, retry setb.
 *             end.
 *          end.
 *
 *          if vo_ndisc_amt <> 0 then do:
 *             {gprun.i ""gpcurval.p"" "(input vo_ndisc_amt, input rndmthd,
 *                                       output retval)"}
 *             if retval <> 0 then do:
 *                next-prompt vo_ndisc_amt with frame vohdr2.
 *                undo setb, retry setb.
 *             end.
 *          end.
 *N014*     END CODE SECTION RELOCATED BELOW */

            /* VALIDATE BANK, BANK ENTITY, CHECK FORM */
            if ap_bank <> "" then do:
               find bk_mstr where bk_code = ap_bank no-lock no-error.
               if not available bk_mstr then do:
                  {mfmsg.i 1200 3}
                  next-prompt ap_bank with frame vohdr2.
                  undo setb, retry.
               end.
               if ap_entity <> bk_entity then do:
                  {mfmsg.i 115 3}
                  next-prompt ap_bank with frame vohdr2.
                  undo setb, retry.
               end.
/*J379*/       /* CHECK BANK ENTITY SECURITY */

/*J379*/       {glenchk.i &entity=bk_entity &entity_ok=entity_ok}
/*J379*/       if not entity_ok then do:
/*J379*/          next-prompt ap_bank with frame vohdr2.
/*J379*/          undo setb, retry.
/*J379*/       end.

/*N0W0*/    {&APVOMTM-P-TAG11}
               display bk_desc @ desc1 with frame vohdr2.

/*L07F*        REINSTATED CODE REMOVED BY L06B */
               if bk_curr <> vo_curr then do:
                  if bk_curr = base_curr then do:
                     {mfmsg.i 93 2}
                     /* WARNING: BANK CURR <> VOUCHER CURR */
                     if ap_ckfrm <> "3" then do:
                        ap_ckfrm = "3".
                        {mfmsg.i 179 2}
                        /* WARNING: SETTING CHECK FORM TO 3 */
                        display ap_ckfrm with frame vohdr2.
                     end.
                  end.  /* IF BK_CURR = BASE_CURR */
                  else do:
                     {mfmsg.i 181 3}
                     /* ERROR: BANK CURR MUST EQUAL VO CURR OR BASE */
                     next-prompt ap_bank with frame vohdr2.
                     undo setb, retry.
                  end. /* BK_CURR <> BASE_CURR */
               end. /* IF BK_CURR <> VO_CURR */
            end. /* IF AP_BANK <> "" */
/*N0W0*/    {&APVOMTM-P-TAG12}

/*N014*     CODE RELOCATED BELOW AFTER VALIDATIONS FOR FRAME VOHDR2 FIELDS ***
 *          /* VALIDATE DAYBOOK */
 *          if daybooks-in-use and new vo_mstr then do:
 *             if not can-find(dy_mstr where dy_dy_code = ap_dy_code)
 *             then do:
 *                {mfmsg.i 1299 3} /* ERROR: INVALID DAYBOOK */
 *                next-prompt ap_dy_code with frame vohdr2.
 *                undo setb, retry.
 *             end.
 *             else do:
 *                /* Added trans, doc, and entity parameter */
 *                {gprun.i ""gldyver.p"" "(input ""AP"",
 *                                         input ""VO"",
 *                                         input ap_dy_code,
 *                                         input ap_entity,
 *                                         output daybook-error)"}
 *                if daybook-error then do:
 *                   {mfmsg.i 1674 2}
 *                   /* WARNING: DAYBOOK DOES NOT MATCH ANY DEFAULT */
 *                   pause.
 *                end. /* if daybook-error */
 *                run nr_can_dispense in h-nrm (input ap_dy_code,
 *                                              input ap_effdate).
 *                run nr_check_error in h-nrm (output daybook-error,
 *                                             output return_int).
 *                if daybook-error then do:
 *                   {mfmsg.i return_int 3}
 *                   next-prompt ap_dy_code with frame vohdr2.
 *                   undo setb, retry.
 *                end.
 *
 *                find dy_mstr where dy_dy_code = ap_dy_code no-lock no-error.
 *                if available dy_mstr then
 *                assign daybook-desc = dy_desc
 *                       dft-daybook = ap_dy_code.
 *             end. /*ELSE DO*/
 *          end. /* if daybooks-in-use and new vo_mstr */
 *N014*     END CODE SECTION RELOCATED BELOW */

            /* VALIDATE ACCT/SUB/CC COMBO */
            if new_vchr then do:
/*N014*               {gpglver1.i &acc=ap_acct &sub=?
 *N014*                          &cc=ap_cc &frame=vohdr2 &loop=setb} */

/*N014*/          /* INITIALIZE SETTINGS */
/*N014*/          {gprunp.i "gpglvpl" "p" "initialize"}
/*N077*/          /* SET PROJECT VERIFICATION TO NO */
/*N077*/          {gprunp.i "gpglvpl" "p" "set_proj_ver" "(input false)"}
/*N014*/          /* AP_ACCT/SUB/CC VALIDATION */
/*N014*/          {gprunp.i "gpglvpl" "p" "validate_fullcode"
                     "(input ap_acct,
                       input ap_sub,
                       input ap_cc,
                       input """",
                       output valid_acct)"}

/*N014*/          if valid_acct = no then do:
/*N014*/             next-prompt ap_acct with frame vohdr2.
/*N014*/             undo setb, retry.
/*N014*/          end.

/*N014*               {gpglver1.i &acc=ap_disc_acct &sub=?
 *N014*                          &cc=ap_disc_cc &frame=vohdr2 &loop=setb} */

/*N014*/          /* INITIALIZE SETTINGS */
/*N014*/          {gprunp.i "gpglvpl" "p" "initialize"}
/*N077*/          /* SET PROJECT VERIFICATION TO NO */
/*N077*/          {gprunp.i "gpglvpl" "p" "set_proj_ver" "(input false)"}
/*N014*/          /* AP_DISC_ACCT/SUB/CC VALIDATION */
/*N014*/          {gprunp.i "gpglvpl" "p" "validate_fullcode"
                     "(input ap_disc_acct,
                       input ap_disc_sub,
                       input ap_disc_cc,
                       input """",
                       output valid_acct)"}

/*N014*/          if valid_acct = no then do:
/*N014*/             next-prompt ap_disc_acct with frame vohdr2.
/*N014*/             undo setb, retry.
/*N014*/          end.
            end.

            /* VERIFY ENTITY*/
            if ap_entity <> glentity then do:
               find en_mstr where en_entity = ap_entity no-lock
               no-error.
               if not available en_mstr then do:
                  {mfmsg.i 3061 3} /*INVALID ENTITY*/
                  next-prompt ap_entity with frame vohdr2.
                  undo, retry.
               end.
               release en_mstr.
            end.

            /* VERIFY GL CALENDAR FOR SPECIFIED ENTITY */
            if new_vchr and vo_confirmed then do:
               {gpglef02.i &module = ""AP""
                           &entity = ap_entity
                           &date   = ap_effdate
                           &prompt = "ap_entity"
                           &frame  = "vohdr2"
                           &loop   = "setb"}
            end.

            /* USE SUPP BANK TYPE THAT MATCHES CHECK FORM */
            csbdtype = if ap_ckfrm = "1" then "2" else
                       if ap_ckfrm = "4" then "3" else
                       ap_ckfrm.

            /* VALIDATE SUPPLIER BANK */
            {gpcsbval.i &addr  = ap_vend
                        &bank  = vo__qad02
                        &type  = csbdtype
                        &date1 = ap_effdate
                        &date2 = ap_effdate
                        &field = vo__qad02
                        &frame = vohdr2
                        &loop  = setb}

/*N0W0*/    {&APVOMTM-P-TAG13}
            /* VERIFY CHECK FORM - MOVED HERE FROM ABOVE */
            {gpckfval.i &ckfrm         = ap_ckfrm
                        &undoloop      = setb
                        &curr          = vo_curr
                        &error-warning = 3
                        &frame         = vohdr2}
/*N0W0*/    {&APVOMTM-P-TAG14}

/*J2NV*/    if not vd_pay_spec and (ap_ckfrm = "3" or ap_ckfrm = "4") then
/*J2NV*/    do:
/*J2NV*/       /* PAY SPECIFICATION SET TO NO FOR SUPPLIER */
/*J2NV*/       {mfmsg.i 2662 2}
/*J2NV*/       pause.
/*J2NV*/    end.

/*N0X5*/    {&APVOMTM-P-TAG15}
            /* IF SUPPLIER BANK IS BLANK FOR CHECK FORM 3 OR 4 THEN WARN */
            if vo__qad02 = " " and (ap_ckfrm = "3" or ap_ckfrm = "4") then
            do:
               /* SUPPLIER BANK REQUIRED WITH THIS CHECK FORM */
               {mfmsg.i 1841 2}
            pause.
            end.

            /* ADDITIONAL CHECK FORM VALIDATION */
/*N0X5* MOVED TAG "APVOMTM-P-TAG15" ABOVE */
            if vd_misc_cr and lookup(ap_ckfrm, "1,2") = 0 then do:
               {mfmsg.i 2188 3} /* CHECK FORM INVALID FOR MISC CREDITORS */
/*N0W0*/    {&APVOMTM-P-TAG16}
               next-prompt ap_ckfrm with frame vohdr2.
               undo setb, retry.
            end.

/*L03K*     if new_vchr then ap_ent_ex = 1. */

/*M11F**    if base_curr <> vo_curr                                      */
/*M11F**    and (new_vchr                                                */
/*M11F**    or (ap_effdate <> old_effdate and vo_confirm = no)) then do: */

/*L03K*        BEGIN DELETE, VALIDATE BEFORE BANK
 *L00K*        if et_tk_active = true then do:
 *L00K*           {etcurval.i
 *L00K*            &curr       = "vo_curr"
 *L00K*            &errlevel   = "4"
 *L00K*            &action     = "undo setb, retry"
 *L00K*            &prompt     =
 *L00K*            "next-prompt vo_curr with frame vohdr2"}
 *L03K*        END DELETE */

/*M11F*/    if (base_curr <> vo_curr
/*M11F*/       and (new_vchr
/*M11F*/       or (ap_effdate <> old_effdate
/*M11F*/       and vo_confirm = no)))
/*M11F*/       or l_getrate
/*M11F*/    then do:

/*L00K*/       assign et_eff_date = ap_effdate.
/*L03K*        BEGIN DELETE
 *L00K*        end.
 *L03K*        END DELETE */

               /*VALIDATE EXCHANGE RATE */
/*L03K*        {gpgtex5.i &ent_curr = base_curr */
/*L03K*                   &curr = vo_curr */
/*L03K*                   &date = ap_effdate */
/*L03K*                   &exch_from = exd_ent_rate */
/*L03K*                   &exch_to = ap_ent_ex} */
/*L03K*/       /* GET EXCHANGE RATE, CREATE USAGE */
/*L03K*/       {gprunp.i "mcpl" "p" "mc-create-ex-rate-usage"
                "(input vo_curr,
/*L03K*/          input base_curr,
/*L03K*/          input vo_ex_ratetype,
                  input ap_effdate,
/*L03K*/          output vo_ex_rate,
                  output vo_ex_rate2,
/*L03K*/          output vo_exru_seq,
                  output mc-error-number)"}
               if mc-error-number <> 0 then do:
                  {mfmsg.i mc-error-number 3}
                  undo, retry.
               end.

               /* ACCT MUST EITHER BE BASE OR EQUAL TO VOUCHER CURR*/
               find ac_mstr where
/*N014*           ac_code = substring(ap_acct,1,(8 - global_sub_len)) */
/*N014*/          ac_code = ap_acct
                  no-lock no-error.
/*L03K*        if available ac_mstr and */
/*L03K*           ac_curr <> vo_curr and ac_curr <> base_curr then do: */
/*L03K*/       if available ac_mstr then do:
/*L03K*/          /* CHECK ACCOUNT CURRENCY AGAINST VOUCHER, */
/*L03K*/          /* WITH UNION TRANSPARENCY ALLOWED         */
/*L03K*/          {gprunp.i "mcpl" "p" "mc-chk-transaction-curr"
                   "(input ac_curr,
                     input vo_curr,
                     input ap_effdate,
                     input true,
                     output mc-error-number)"}
/*L03K*/          if mc-error-number <> 0 then do:
                     {mfmsg.i 134 3}
                     /*ACCT CURR MUST MATCH TRANSACTION OR BASE CURR*/
                     next-prompt ap_acct with frame vohdr2.
                     undo setb, retry.
                  end.
/*L03K*/       end.

               /* ACCT MUST EITHER BE BASE OR EQUAL TO VOUCHER CURR*/
               find ac_mstr where ac_code =
/*N014*/                  ap_disc_acct
/*N014*           substring(ap_disc_acct,1,(8 - global_sub_len)) */
                  no-lock no-error.
/*L03K*        if available ac_mstr and */
/*L03K*           ac_curr <> vo_curr and ac_curr <> base_curr then do: */
/*L03K*/       if available ac_mstr then do:
/*L03K*/          /* CHECK ACCOUNT CURRENCY AGAINST VOUCHER, */
/*L03K*/          /* WITH UNION TRANSPARENCY ALLOWED         */
/*L03K*/          {gprunp.i "mcpl" "p" "mc-chk-transaction-curr"
                   "(input ac_curr,
                     input vo_curr,
                     input ap_effdate,
                     input true,
                     output mc-error-number)"}
/*L03K*/          if mc-error-number <> 0 then do:
                     {mfmsg.i 134 3}
                     /*ACCT CURR MUST MATCH TRANSACTION OR BASE CURR*/
                     next-prompt ap_disc_acct with frame vohdr2.
                     undo setb, retry.
                  end.
/*L03K*/       end.

               /* SPOT EXCHANGE RATE */
/*L03K*        BEGIN DELETE
 *             setb_sub: do on error undo, retry:
 *                form
 *                   space(1)  ap_ent_ex  space(2)
 *                with frame setb_sub attr-space overlay side-labels
 *                centered row frame-row(vohdr2) + 2.
 *                update ap_ent_ex with frame setb_sub.
 *
 *                if ap_ent_ex = 0  then do:
 *                   {mfmsg.i 317 3} /*ZERO NOT ALLOWED*/
 *                   undo setb_sub, retry.
 *                end.
 *             end. /*setb_sub*/
 *L03K*        END DELETE */
/*L03K*/       {gprunp.i "mcui" "p" "mc-ex-rate-input"
                "(input vo_curr,
                  input base_curr,
                  input ap_effdate,
                  input vo_exru_seq,
                  input false,
                  input frame-row(vohdr2) + 2,
                  input-output vo_ex_rate,
                  input-output vo_ex_rate2,
                  input-output fixed_rate_not_used)"}

/*M1R3*/       /* BEGIN ADD */

               /* RE-CALCULATE BASE AMOUNTS FOR UNCONFIRMED */
               /* VOUCHER WHEN EXCHANGE RATES ARE MODIFIED  */

               if not new_vchr
               then do:

                  {gprunp.i "mcpl" "p" "mc-curr-conv"
                     "(input  vo_curr,
                       input  base_curr,
                       input  vo_ex_rate,
                       input  vo_ex_rate2,
                       input  ap_amt,
                       input  true, /* ROUND */
                       output ap_base_amt,
                       output mc-error-number)"}.

                  if mc-error-number <> 0
                  then do:
                     {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
                  end. /* IF mc-error-number <> 0 */

                  {gprunp.i "mcpl" "p" "mc-curr-conv"
                     "(input  vo_curr,
                       input  base_curr,
                       input  vo_ex_rate,
                       input  vo_ex_rate2,
                       input  vo_ndisc_amt,
                       input  true, /* ROUND */
                       output vo_base_ndisc,
                       output mc-error-number)"}.

                  if mc-error-number <> 0
                  then do:
                     {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
                  end. /* IF mc-error-number <> 0 */

                  {gprunp.i "mcpl" "p" "mc-curr-conv"
                     "(input  vo_curr,
                       input  base_curr,
                       input  vo_ex_rate,
                       input  vo_ex_rate2,
                       input  vo_hold_amt,
                       input  true, /* ROUND */
                       output vo_base_hold_amt,
                       output mc-error-number)"}.

                  if mc-error-number <> 0
                  then do:
                     {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
                  end. /* IF mc-error-number <> 0 */

                  /* RECALCULATE THE DETAIL BASE AMOUNTS */
                  for each vod_det
                     fields(vod_ref vod_amt vod_base_amt)
                     where vod_ref = vo_ref
                     exclusive-lock:

                     {gprunp.i "mcpl" "p" "mc-curr-conv"
                        "(input  vo_curr,
                          input  base_curr,
                          input  vo_ex_rate,
                          input  vo_ex_rate2,
                          input  vod_amt,
                          input  true, /* ROUND */
                          output vod_base_amt,
                          output mc-error-number)"}.

                     if mc-error-number <> 0
                     then do:
                        {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
                     end. /* IF mc-error-number <> 0 */

                  end. /* FOR EACH vod_det */
               end. /* IF NOT new_vchr */

/*M1R3*/       /* END ADD */

            end.  /* IF NEW AP_MSTR AND VO_CURR <> BASE_CURR */

/*N014*     CODE RELOCATED BELOW AFTER VALIDATIONS FOR FRAME VOHDR2 FIELDS ***
 *          if (po-attached and not {apvoconf.i}) then do:
 *             set auto-select
 *             with frame vohdr2
 *             editing:
 *                readkey.
 *
 *                if keyfunction (lastkey) = "end-error" then do:
 *                   {gprun.i ""apvoundo.p"" "(input po-attached,
 *                                             output confirm_undo)"}
 *                   if confirm_undo = no then do:
 *                      next_loopc = yes.
 *                      undo_all = no.
 *                   end.
 *                   else undo_all = yes.
 *                   return.
 *                end.
 *                else apply lastkey.
 *
 *             end. /* EDITING CLAUSE */
 *          end. /* IF (PO-ATTACHED... */
 *N014*     END CODE SECTION RELOCATED BELOW */

/*L03K*     BEGIN DELETE
 *          if base_curr <> vo_curr
 *          and (new_vchr
 *          or (ap_effdate <> old_effdate and vo_confirm = no)) then do:
 *             {gpgtexch.i &ent_curr = base_curr
 *                         &curr = vo_curr
 *                         &exch_from = ap_ent_ex
 *                         &exch_to = vo_ex_rate}
 *          end.
 *L03K*     END DELETE */
/*L03K*/    assign
               ap_ex_rate = vo_ex_rate
/*L03K*/       ap_ex_rate2 = vo_ex_rate2
/*L03K*/       ap_ex_ratetype = vo_ex_ratetype
               ap_curr = vo_curr.

/*L03K*/       /* COPY RATE USAGE FROM VO TO AP */
/*L03K*/       {gprunp.i "mcpl" "p" "mc-copy-ex-rate-usage"
                "(input vo_exru_seq,
                  output ap_exru_seq)"}

            assign vo_invoice.

/*ss-eas056 add**********************************************************/
            if vo_invoice = "" then do:
                     {mfmsg.i 3511 3}
                     next-prompt vo_invoice with frame vohdr2.
                     undo setb, retry.
	    end.

            p-inv = no.
	    if vo_invoice <> "" then do:
               for each vomstr1 where vomstr1.vo_invoice =
                  vo_mstr.vo_invoice
                  and vomstr1.vo_ref <> vo_mstr.vo_ref no-lock:
                  find first apmstr1 where apmstr1.ap_ref =
                     vomstr1.vo_ref and
                     apmstr1.ap_type = "VO" no-lock no-error.
                  if available apmstr1 then do:
		     p-inv = yes.
                  end.
               end.
	       if p-inv = no then do:
	          find first ih_hist where ih_inv_nbr = vo_invoice no-lock no-error.
		  if available ih_hist then p-inv = yes.
	       end.
            end.
            if vo_invoice <> "" and p-inv = yes then do:
                     {mfmsg.i 1165 3}
                     next-prompt vo_invoice with frame vohdr2.
                     undo setb, retry.
            end.
/*ss-eas056 end**********************************************************/

/*ss-eas056 delete**********************************************************
/*N0W0*/    {&APVOMTM-P-TAG17}
            if vo_invoice <> "" then do:
               invoice-loop: for each vomstr1 where vomstr1.vo_invoice =
                  vo_mstr.vo_invoice
                  and vomstr1.vo_ref <> vo_mstr.vo_ref no-lock:
                  find first apmstr1 where apmstr1.ap_ref =
                     vomstr1.vo_ref and
                     apmstr1.ap_type = "VO" and apmstr1.ap_vend =
                       ap_mstr.ap_vend no-lock no-error.
                  if available apmstr1 then do:
                     {mfmsg02.i 2201 2 apmstr1.ap_ref}
/*J34J*/             pause.
                     leave invoice-loop.
                  end.
               end.
            end.
*ss-eas056 end**********************************************************/

            if  vo_disc_date = ?  or vo_due_date = ? then do:

               /* ADD INITIAL READ OF CT_MSTR HERE, SO THAT IT IS */
               /* AVAILABLE WITHIN THIS BLOCK; THIS IS NECESSARY  */
               /* TO READ THE CTD_DET FILE FOR MULT. DUE DATES    */
               /* CREDIT TERMS RECORDS (FO54)                     */
               find ct_mstr where ct_code = vo_cr_terms no-lock no-error.
               if not available ct_mstr or ct_dating = no then do:

                  {gprun.i ""adctrms.p""
                           "(input ap_date,
                             input vo_cr_terms,
                             output calcd_disc_date,
                             output calcd_due_date)"}

               end.
               else do:

                  /* IF MULT. DUE DATES CREDIT TERMS, GET LAST DUE DATE */
                  find last ctd_det where ctd_code = vo_cr_terms
                  no-lock no-error.
                  /*CALCULATE DATES USING LAST CREDIT TERMS RECORD */
                  if available ctd_det then do:
                     {gprun.i ""adctrms.p""
                              "(input ap_date,
                                input ctd_date_cd,
                                output calcd_disc_date,
                                output calcd_due_date)"}

                  end.
               end. /* if available ct_mstr and ct_dating */

               /* REPLACE ONLY UNKNOWN DATES, NOT USER-ENTERED DATES */
               if vo_disc_date = ? then
                  vo_disc_date = calcd_disc_date.
               if vo_due_date = ? then
                  vo_due_date = calcd_due_date.

/*J2NG*/    end.
            display vo_disc_date vo_due_date with frame vohdr2.
/*N0W0*/    {&APVOMTM-P-TAG18}
/*J2NG**    end. */

/*N014*     CODE RELOCATED BELOW AFTER VALIDATIONS FOR FRAME VOHDR2 FIELDS ***
 *          /* ADD TO VENDOR PREPAY BALANCE*/
 *          if vo_prepay <> 0 then do:
 *             find vd_mstr where vd_addr = ap_vend exclusive-lock no-error.
 *             if available vd_mstr then do:
 *                base_prepay = vo_prepay.
 *                if base_curr <> vo_curr then
 *
 *                do:
 * /*L03K*           base_prepay = base_prepay / vo_ex_rate. */
 * /*L03K*/          /* CONVERT FROM FOREIGN TO BASE CURRENCY */
 * /*L03K*/          {gprunp.i "mcpl" "p" "mc-curr-conv"
 *                    "(input vo_curr,
 *                      input base_curr,
 *                      input vo_ex_rate,
 *                      input vo_ex_rate2,
 *                      input base_prepay,
 *                      input true, /* ROUND */
 *                      output base_prepay,
 *                      output mc-error-number)"}.
 * /*L03K*/          if mc-error-number <> 0 then do:
 * /*L03K*/             {mfmsg.i mc-error-number 2}
 * /*L03K*/          end.
 * /*L03K*           {gprun.i ""gpcurrnd.p"" "(input-output base_prepay, */
 * /*L03K*              input gl_rnd_mthd)"} */
 *                end.
 *                vd_prepay = vd_prepay + base_prepay.
 *             end.
 *          end.
 *N014*     END CODE SECTION RELOCATED BELOW */

            /*  CHECK FOR PAYMENT */
            if vo_applied <> 0 then do:
               find first ckd_det where ckd_voucher = ap_ref
               no-lock no-error.
               repeat:
                  if not available ckd_det then leave.
                  else do:
                     find ck_mstr where ck_ref = ckd_ref no-lock
                        no-error.
                     if available ck_mstr and ck_status <> "VOID"
                     then do:
                        ckdref = ckd_ref.
                        {mfmsg02.i 1180 2 ckdref}
                        /*PAYMENT APPLIED, DETAIL LINES CANNOT BE MODIF.*/
                        pmt_exists = yes.
                        undo_all = no.
                        leave setb.
                     end.
                     else find next ckd_det where ckd_voucher = ap_ref
                        no-lock no-error.
                  end.
               end.
               if keyfunction(lastkey) = "END-ERROR" then undo, retry.
            end.

/*N014*     BEGIN NEW SECTION *** */

            hide frame vohdr2 no-pause.
            view frame vohdr2a.

            display
               vo_prepay
               vo_hold_amt
               vo_ndisc_amt
               ap_dy_code
               auto-select
            with frame vohdr2a.

            if not {txnew.i} then
               display vo_tax_pct with frame vohdr2a.

            setc: do on error undo, retry:

               set
                  vo_prepay
                  vo_ndisc_amt
                  vo_tax_pct[1]  when (new_vchr    and
                                       not gl_can   and
                                       not gl_vat   and
                                       not {txnew.i})
                  vo_tax_pct[2]  when (new_vchr    and
                                       not gl_can   and
                                       not gl_vat   and
                                       not {txnew.i})
                  vo_tax_pct[3]  when (new_vchr    and
                                       not gl_can   and
                                       not gl_vat   and
                                       not {txnew.i})
               with frame vohdr2a
               editing:
                  readkey.

                  if keyfunction (lastkey) = "end-error" then do:
                     {gprun.i ""apvoundo.p"" "(input po-attached,
                                               output confirm_undo)"}
                     if confirm_undo = no then do:
                        assign
                           next_loopc = yes
                           undo_all = no.
                     end.
                     else
                        undo_all = yes.
/*L140**             apply lastkey. */
/*L140*/             hide frame vohdr2a no-pause.
                     return.
                  end.
                  else
                     apply lastkey.
               end. /* EDITING CLAUSE */
/*N014*        END NEW CODE FROM ABOVE */

/*N014*        BEGIN CODE RELOCATED FROM ABOVE */
               if vo_prepay <> 0 then do:
                  {gprun.i ""gpcurval.p"" "(input vo_prepay, input rndmthd,
                                            output retval)"}
                  if retval <> 0 then do:
                     next-prompt vo_prepay with frame vohdr2a.
                     undo setc, retry setc.
                  end.
               end.

               if vo_ndisc_amt <> 0 then do:
                  {gprun.i ""gpcurval.p"" "(input vo_ndisc_amt, input rndmthd,
                                            output retval)"}
                  if retval <> 0 then do:
                     next-prompt vo_ndisc_amt with frame vohdr2a.
                     undo setc, retry setc.
                  end.
               end.

               /* VALIDATE DAYBOOK */
               if daybooks-in-use and new vo_mstr then do:
                  display
                     ap_dy_code
                  with frame vohdr2a.

                  set
                     ap_dy_code
                  with frame vohdr2a.

                  if not can-find(dy_mstr where dy_dy_code = ap_dy_code)
                  then do:
                     {mfmsg.i 1299 3} /* ERROR: INVALID DAYBOOK */
                     next-prompt ap_dy_code with frame vohdr2a.
                     undo setc, retry.
                  end.
                  else do:
                     /* Added trans, doc, and entity parameter */
                     {gprun.i ""gldyver.p"" "(input ""AP"",
                                              input ""VO"",
                                              input ap_dy_code,
                                              input ap_entity,
                                              output daybook-error)"}

                     if daybook-error then do:
                        {mfmsg.i 1674 2}
                        /* WARNING: DAYBOOK DOES NOT MATCH ANY DEFAULT */
                        pause.
                     end. /* if daybook-error */

                     run nr_can_dispense in h-nrm (input ap_dy_code,
                                                   input ap_effdate).
                     run nr_check_error in h-nrm (output daybook-error,
                                                  output return_int).
                     if daybook-error then do:
                        {mfmsg.i return_int 3}
                        next-prompt ap_dy_code with frame vohdr2a.
                        undo setc, retry.
                     end.

                     find dy_mstr where dy_dy_code = ap_dy_code
                     no-lock no-error.
                     if available dy_mstr then
                        assign
                           daybook-desc = dy_desc
                           dft-daybook = ap_dy_code.
                  end. /*ELSE DO*/
               end. /* if daybooks-in-use and new vo_mstr */

/*M0JK*/    /* AUTO SELECT SHOULD BE EDITABLE ONLY FOR NEW VOUCHER */
/*M0JK**       if (po-attached and not {apvoconf.i}) then do:      */
/*M0JK*/       if (po-attached and
/*M0JK*/           new_vchr)
/*M0JK*/       then do:
                  set
                     auto-select
                  with frame vohdr2a
                  editing:
                     readkey.

                     if keyfunction (lastkey) = "end-error" then do:
                        {gprun.i ""apvoundo.p"" "(input po-attached,
                                                  output confirm_undo)"}
                        if confirm_undo = no then do:
                           assign
                              next_loopc = yes
                              undo_all = no.
                        end.
                        else
                           undo_all = yes.
/*L140*/                hide frame vohdr2a no-pause.
                        return.
                     end.
                     else
                        apply lastkey.

                  end. /* EDITING CLAUSE */
               end. /* IF (PO-ATTACHED... */

               /* ADD TO VENDOR PREPAY BALANCE*/
               if vo_prepay <> 0 then do:
                  find vd_mstr where vd_addr = ap_vend exclusive-lock no-error.
                  if available vd_mstr then do:
                     base_prepay = vo_prepay.

                     if base_curr <> vo_curr then do:

                        /* CONVERT FROM FOREIGN TO BASE CURRENCY */
                        {gprunp.i "mcpl" "p" "mc-curr-conv"
                                  "(input vo_curr,
                                    input base_curr,
                                    input vo_ex_rate,
                                    input vo_ex_rate2,
                                    input base_prepay,
                                    input true, /* ROUND */
                                    output base_prepay,
                                    output mc-error-number)"}

                        if mc-error-number <> 0 then do:
                           {mfmsg.i mc-error-number 2}
                        end.
                     end.
                     vd_prepay = vd_prepay + base_prepay.
                  end.
               end.   /* IF VO_PREPPAY <> 0 */
/*N014*        END CODE RELOCATED FROM ABOVE */
/*N014*/    end. /* SET C */

/*N0W0*/    {&APVOMTM-P-TAG19}
            if {txnew.i} then do:
/*N0W0*/    {&APVOMTM-P-TAG20}
               undo_tframe = true.
               /* EDIT GTM TAX FIELDS */
               {gprun.i ""apvomte.p""}
               if undo_tframe then
/*L15T*/          /* l_flag IS SET TO true IN BATCH MODE IN apvomte.p */
/*L15T*/          /* FOR AN ERROR ENCOUNTERED.                        */
/*L15T*/          if not l_flag
/*L15T*/          then
                     undo, retry.
/*L15T*/          else
/*L15T*/             return.
            end.

            undo_all = no.

         end. /* SET B */
