/* apvomtm.p - AP VOUCHER MAINTENANCE SUBPROGRAM                              */
/* Copyright 1986-2005 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.31.2.39.1.14.2.2 $                                                */
/* REVISION: 7.4            CREATED: 01/23/95   by: str *H09W*                */
/*                    LAST MODIFIED: 02/01/95   by: str *H0B2*                */
/*                                   02/08/95   by: str *H0B8*                */
/*                                   03/02/95   by: wjk *F0KL*                */
/*                                   03/20/95   by: wjk *H0C3*                */
/*                                   03/29/95   by: dzn *F0PN*                */
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
/* Revision: 1.31.2.14     BY: Katie Hilbert       DATE: 04/01/01 ECO: *P002* */
/* Revision: 1.31.2.15     BY: Vihang Talwalkar    DATE: 04/01/01 ECO: *M16X* */
/* Revision: 1.31.2.16     BY: Seema Tyagi         DATE: 12/07/01 ECO: *M1R3* */
/* Revision: 1.31.2.17     BY: Dan Herman          DATE: 04/17/02 ECO: *P043* */
/* Revision: 1.31.2.18     BY: Paul Donnelly       DATE: 12/18/01 ECO: *N16J* */
/* Revision: 1.31.2.21     BY: Samir Bavkar        DATE: 02/14/02 ECO: *P04G* */
/* Revision: 1.31.2.24     BY: Luke Pokic          DATE: 07/01/02 ECO: *P09Z* */
/* Revision: 1.31.2.25     BY: Robin McCarthy      DATE: 07/15/02 ECO: *P0BJ* */
/* Revision: 1.31.2.26     BY: Manjusha Inglay     DATE: 07/29/02 ECO: *N1P4* */
/* Revision: 1.31.2.27     BY: Ellen Borden        DATE: 08/15/02 ECO: *P09W* */
/* Revision: 1.31.2.28     BY: Gnanasekar          DATE: 09/11/02 ECO: *N1PG* */
/* Revision: 1.31.2.30     BY: Rajaneesh S.        DATE: 10/10/02 ECO: *M1XP* */
/* Revision: 1.31.2.31     BY: Deepak Rao          DATE: 10/23/02 ECO: *N1XK* */
/* Revision: 1.31.2.33     BY: Hareesh V.          DATE: 10/24/02 ECO: *N1Y2* */
/* Revision: 1.31.2.34     BY: Rajaneesh S.        DATE: 11/21/02 ECO: *N20G* */
/* Revision: 1.31.2.35     BY: Katie Hilbert       DATE: 01/31/03 ECO: *P0MJ* */
/* Revision: 1.31.2.36     BY: Tiziana Giustozzi   DATE: 01/13/03 ECO: *P0MX* */
/* Revision: 1.31.2.37     BY: Orawan S.           DATE: 04/21/03 ECO: *P0Q8* */
/* Revision: 1.31.2.39.1.1  BY: Ed van de Gevel    DATE: 05/28/03 ECO: *N1YC* */
/* Revision: 1.31.2.39.1.2  BY: Paul Donnelly (SB) DATE: 06/26/03 ECO: *Q00B* */
/* Revision: 1.31.2.39.1.5  BY: Rajinder Kamara    DATE: 07/16/03 ECO: *Q013* */
/* Revision: 1.31.2.39.1.6   BY: Ashish Maheshwari DATE: 08/04/03 ECO: *P0TR* */
/* Revision: 1.31.2.39.1.7   BY: Ed van de Gevel   DATE: 08/05/03 ECO: *Q00R* */
/* Revision: 1.31.2.39.1.8   BY: Jean Miller       DATE: 10/05/03 ECO: *Q03S* */
/* Revision: 1.31.2.39.1.9   BY: Ed van de Gevel   DATE: 12/24/03 ECO: *Q04S* */
/* Revision: 1.31.2.39.1.10  BY: Geeta Kotian      DATE: 12/29/03 ECO: *P1HB* */
/* Revision: 1.31.2.39.1.11 BY: Gaurav Kerkar     DATE: 04/06/04 ECO: *P1X1* */
/* Revision: 1.31.2.39.1.12 BY: Ed van de Gevel   DATE: 08/10/04 ECO: *P1P9*  */
/* Revision: 1.31.2.39.1.13 BY: Patrick Rowan DATE: 10/11/04 ECO: *P2P5*  */
/* Revision: 1.31.2.39.1.14 BY: Pankaj Goswami   DATE: 02/04/05 ECO: *P36R* */
/* Revision: 1.31.2.39.1.14.2.1  BY: Bharath Kumar       DATE: 06/22/05 ECO: *P3PG* */
/* $Revision: 1.31.2.39.1.14.2.2 $  BY: Steve Nugent   DATE: 07/26/05  ECO: *P2PJ* */
/*----rev history-------------------------------------------------------------------------------------*/
/* SS - 110114.1  By: Roger Xiao */
/*-Revision end---------------------------------------------------------------*/


/*V8:ConvertMode=Maintenance                                                  */

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/
/* THIS SUBPROGRAM UPDATES THE SECOND VOUCHER HEADER FIELDS.         */

{mfdeclre.i}
{cxcustom.i "APVOMTM.P"}
{gplabel.i} /* EXTERNAL LABEL INCLUDE */

{gldydef.i}
{gldynrm.i}

{xxgpdescm1.i }     /* SS - 110114.1 */

define shared variable ckdref like ckd_ref.
define shared variable ap_recno    as recid.
define shared variable vo_recno    as recid.
define shared variable vd_recno    as recid.
define shared variable batch       like ap_batch.
define shared variable bactrl      like ba_ctrl.
define shared variable aptotal     like ap_amt.
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
define shared variable l_flag      like mfc_logical no-undo.
{&APVOMTM-P-TAG1}
define shared variable first_pass  like mfc_logical.

/* USED FOR SCROLLING WINDOW SWCSBD.P */
define shared variable supp_bank   like ad_addr no-undo.
define shared variable vchr_logistics_chrgs  like mfc_logical
       label "Voucher Logistics Charges" initial no no-undo.
define shared variable incl_blank_suppliers  like mfc_logical no-undo.
define shared variable close_pvo  like mfc_logical label "Close Line".

define variable confirm_undo       as logical no-undo.
define variable valid_acct         as logical no-undo.
define variable csbdtype           as character format "X(5)" no-undo.
define variable calcd_disc_date    as date no-undo.
define variable calcd_due_date     as date no-undo.
define variable retval             as integer.
define variable fixed_rate_not_used like mfc_logical no-undo.
define variable curr-is-union      like mfc_logical no-undo.
define variable curr-is-member     like mfc_logical no-undo.
define variable vo-union           like mu_union_curr no-undo.
define variable po-union           like mu_union_curr no-undo.
define variable base-union         like mu_union_curr no-undo.
define variable entity_ok          like mfc_logical   no-undo.
define variable l_getrate          like mfc_logical   no-undo.
define variable use-log-acctg      as logical no-undo.

define new shared variable rcvd_open like pvo_trans_qty.

define shared frame a.
define shared frame voucher.
define shared frame order.
define shared frame vohdr1.
define shared frame vohdr2.
define shared frame vohdr2a.
define shared frame vohdr3.

{&APVOMTM-P-TAG21}
define buffer apmstr1 for ap_mstr.
define buffer vomstr1 for vo_mstr.
{&APVOMTM-P-TAG29}

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

/* GET ENTITY SECURITY INFORMATION */
{glsec.i}

{etvar.i}
define variable l_rate1 like vo_ex_rate no-undo.
define variable l_rate2 like vo_ex_rate  no-undo.
{&APVOMTM-P-TAG2}

find ap_mstr where recid(ap_mstr) = ap_recno exclusive-lock.
find vo_mstr where recid(vo_mstr) = vo_recno exclusive-lock.
find vd_mstr where recid(vd_mstr) = vd_recno no-lock.

find first gl_ctrl  where gl_domain = global_domain no-lock.
find first apc_ctrl where apc_domain = global_domain no-lock.
find first adc_ctrl where adc_domain = global_domain no-lock no-error.

/* CHECK IF LOGISTICS ACCOUNTING IS ENABLED */
{gprun.i ""lactrl.p"" "(output use-log-acctg)"}

if use-log-acctg then
   for first lac_ctrl
      fields(lac_domain lac_blank_suppliers)
      where lac_domain = global_domain
   no-lock: end.

{&APVOMTM-P-TAG22}
if vd_misc_cr then do:
   pause 0.
   if ap_remit <> "" then do:
      find ad_mstr where ad_domain = global_domain and
                         ad_addr =   ap_remit
      exclusive-lock no-error.
      if available ad_mstr then
      display
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
      with frame vohdr3.
   end.
   else do on error undo, leave:
      create ad_mstr.
      assign
         ad_domain = global_domain
         ad_format = 0.
      {&APVOMTM-P-TAG3}
      if available adc_ctrl then
         ad_format = adc_format.
      hide frame vohdr2 no-pause.
      {&APVOMTM-P-TAG4}
      display ad_format with frame vohdr3.
      undo, leave.
   end.
   remit:
   do on error undo, retry:

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
         run display-message
            (input 40,
             input 4).
         next-prompt ad_name.
         undo remit, retry.
      end.

      if input ad_format <> 0 then do:
         find first code_mstr where
                    code_domain = global_domain and
                    code_fldname = "ad_format" and
                    code_value = string(input ad_format)
         no-lock no-error.
         if not available code_mstr then do:
            /* Code does not exist in generalized codes */
            {pxmsg.i &MSGNUM=716 &ERRORLEVEL=4}
            next-prompt ad_format.
            undo remit, retry.
         end.
      end.

      if ap_remit = "" then do:

         if input ad_name <> "" then do:

            {mfactrl.i "vdc_ctrl.vdc_domain = global_domain"
               "vdc_ctrl.vdc_domain" "ad_mstr.ad_domain = global_domain"
               vdc_ctrl vdc_nbr ad_mstr ad_addr ap_remit}

            create ad_mstr.
            {&APVOMTM-P-TAG5}
            assign
               ad_domain  = global_domain
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
               ad_type    = "remit-to"
               ad_temp    = yes.
         end.

      end.
      else
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
   end. /* end of remit */

   if batchrun
   then do:

      for first code_mstr
         fields( code_domain code_fldname code_value)
         where code_domain = global_domain and
               code_fldname = "ad_format"
      no-lock: end. /* FOR FIRST code_mstr */

      if available code_mstr
      then do:
         for first code_mstr
            fields(code_domain code_fldname code_value)
             where code_domain  = global_domain and
                   code_fldname = "ad_format"  and
                   code_value   = string(input ad_format)
         no-lock: end.

         if not available code_mstr then
            l_flag = true.

      end. /* IF AVAILABLE code_mstr */

      else
      if input ad_format <> 0 then
         l_flag = true.

   end. /* IF batchrun */

   /* IF l_flag IS true RETURN TO THE CALLING */
   /* PROGRAM WITHOUT PROCEEDING FURTHER      */
   if l_flag = true then
      return.

end. /* end of miscellaneous supplier */

else do:
   if ap_remit <> "" then do:
      find ad_mstr where ad_domain = global_domain
                     and ad_addr = ap_remit
      exclusive-lock no-error.
      if available ad_mstr then
         delete ad_mstr.
      assign
         vo_separate = no
         ap_remit    = "".
   end.
end.

{&APVOMTM-P-TAG6}

setb:
do on error undo, retry:

   if ap_remit <> "" then
      vo_separate = yes.

   display
      vo_separate
   with frame vohdr2.

   /*For field vo__qad02 */
   {gpbrparm.i &browse=adlu031.p &parm=c-brparm1 &val=supp_bank}

   if batchrun then
      l_flag = true.

   {&APVOMTM-P-TAG7}
   set
      vo_curr when ((new_vchr
                     and not po-attached
                     and not (can-find (first vod_det
                                        where vod_domain = global_domain and
                                              vod_ref = ap_ref)))
                or  (new vo_mstr and (po-attached and first_pass)))
      ap_bank
      vo_invoice
      ap_date
      vo_cr_terms
      vo_disc_date
      vo_due_date
      ap_expt_date
      {&APVOMTM-P-TAG24}
      ap_acct        when (new_vchr)
      ap_sub         when (new_vchr)
      ap_cc          when (new_vchr)
      ap_disc_acct   when (new_vchr)
      ap_disc_sub    when (new_vchr)
      ap_disc_cc     when (new_vchr)
      ap_entity      when (new_vchr)
      /* ap_rmk **** SS - 110114.1 */
      vo__qad02
      vo_separate    when (ap_remit = "")
      vo_type
      ap_ckfrm
   with frame vohdr2
   editing:

      readkey.
      {&APVOMTM-P-TAG8}

      if keyfunction (lastkey) = "end-error" then do:
         {gprun.i ""apvoundo.p"" "(input po-attached,
                                   output confirm_undo)"}
         if confirm_undo = no then
            assign
               next_loopc = yes
               undo_all   = no.
         else
            undo_all = yes.
         if undo_all then
            undo setb, return.
         return.
      end.
      else
         apply lastkey.

   end. /* EDITING CLAUSE */

   /* VALIDATION FOR DATE */
   if ap_date = ?
   then do:
      /* BLANK NOT ALLOWED */
      {pxmsg.i &MSGNUM=40 &ERRORLEVEL=3}
      next-prompt ap_date with frame vohdr2.
      undo, retry.
   end. /* IF ap_date = ? */

   {&APVOMTM-P-TAG23}
   /* IF NO ERROR IS ENCOUNTERED SET l_flag TO false IN BATCH MODE */
   if batchrun then
      l_flag = false.

   if daybooks-in-use and new vo_mstr
   then do:
      {gprun.i ""gldydft.p"" "(input ""AP"",
                               input ""VO"",
                               input ap_entity,
                               output dft-daybook,
                               output daybook-desc)"}
      assign ap_dy_code = dft-daybook.

   end. /*if daybooks in use */

   if vo_curr = ""
   then do:
      vo_curr = base_curr.
      display vo_curr with frame vohdr2.
   end.

   /* VALIDATE VOUCHER CURRENCY */
   {gprunp.i "mcpl" "p" "mc-chk-valid-curr"
      "(input vo_curr,
        output mc-error-number)"}
   if mc-error-number <> 0 then do:
      run display-message
         (input mc-error-number,
          input 4).
      next-prompt vo_curr with frame vohdr2.
      undo setb, retry.
   end.

   if vo_curr = base_curr or
      not po-attached
   then
      . /* VOUCHER CURRENCY IS OK */
   else do:
      /* FIND FIRST ATTACHED PO */
      for first vpo_det
          where vpo_domain = global_domain and vpo_ref = vo_ref
      no-lock,
          first po_mstr
          where po_domain = global_domain and po_nbr = vpo_po
      no-lock: end.
      {&APVOMTM-P-TAG9}
      if vo_curr = po_curr
      then
         . /* VOUCHER CURRENCY IS OK */
      else do:

         /* CHECK IF VO_CURR IS UNION CURRENCY */
         {gprunp.i "mcpl" "p" "mc-chk-union-curr"
            "(input vo_curr,
              input ap_effdate,
              output curr-is-union)"}
         if curr-is-union then
            vo-union = vo_curr.
         else do:
            /* CHECK IF VO_CURR IS MEMBER OF A UNION */
            {gprunp.i "mcpl" "p" "mc-chk-member-curr"
               "(input vo_curr,
                 input ap_effdate,
                 output vo-union,
                 output curr-is-member)"}
         end.

         if vo-union = ""
         then do:
            /* INVALID TRANSACTION CURRENCY */
            run display-message
               (input 2679,
                input 4).
            next-prompt vo_curr with frame vohdr2.
            undo setb, retry.
         end.

         /* CHECK IF BASE_CURR IS UNION CURRENCY */
         {gprunp.i "mcpl" "p" "mc-chk-union-curr"
            "(input base_curr,
              input ap_effdate,
              output curr-is-union)"}
         if curr-is-union then
            base-union = base_curr.
         else do:
            /* CHECK IF BASE_CURR IS MEMBER OF A UNION */
            {gprunp.i "mcpl" "p" "mc-chk-member-curr"
               "(input base_curr,
                 input ap_effdate,
                 output base-union,
                 output curr-is-member)"}
         end.

         if vo-union = base-union
         then
            . /* VOUCHER CURRENCY IS OK */
         else do:

            /* CHECK IF PO_CURR IS UNION CURRENCY */
            {gprunp.i "mcpl" "p" "mc-chk-union-curr"
               "(input po_curr,
                 input ap_effdate,
                 output curr-is-union)"}
            if curr-is-union then
               po-union = po_curr.
            else do:
               /* CHECK IF PO_CURR IS MEMBER OF A UNION */
               {gprunp.i "mcpl" "p" "mc-chk-member-curr"
                  "(input po_curr,
                    input ap_effdate,
                    output po-union,
                    output curr-is-member)"}
            end.

            if vo-union = po-union
            then
               .
            else do:
               /* INVALID TRANSACTION CURRENCY */
               run display-message
                  (input 2679,
                   input 4).
               next-prompt vo_curr with frame vohdr2.
               undo setb, retry.
            end.

         end. /* VO-UNION <> BASE-UNION */

      end. /* VO_CURR <> PO_CURR */

      {&APVOMTM-P-TAG10}

   end. /* PO-ATTACHED */

   /* IF THE CURRENCY IS CHANGED, THEN RESET THE ROUNDING  */
   /* VALUES AND FORMATS                                   */

   /* THE FIELD FORMATS ARE RESET ONLY FOR THE NEW VOUCHER */
   /* INDEPENDENT OF VO_CURR                               */

   if new_vchr
   then do:

      /* THE ROUNDING METHOD IS RESET IF THE CURRENCY IS CHANGED */

      if vo_curr <> old_curr or
         old_curr = ""
      then do:

         /* GET ROUNDING METHOD FROM CURRENCY MASTER */
         {gprunp.i "mcpl" "p" "mc-get-rnd-mthd"
            "(input vo_curr,
              output rndmthd,
              output mc-error-number)"}

         if mc-error-number <> 0 then do:
            run display-message
               (input mc-error-number,
                input 3).
            undo setb, retry setb.
         end. /* IF MC-ERROR-NUMBER <> 0 */

         if new_vchr
            and not first_pass
         then
            l_getrate = yes.

      end. /* IF VO_CURR <> OLD_CURR ...  */

      /* DETERMINE CURRENCY DEPENDENT FORMATS */
      {apcurfmt.i}

      /* SET CURRENCY FORMATS FOR DISPLAY FRAMES */
      assign
         ap_amt:format in frame vohdr1        = ap_amt_fmt
         aptotal:format in frame vohdr1       = ap_amt_fmt
         vo_prepay:format in frame vohdr2a    = vo_prepay_fmt
         vo_hold_amt:format in frame vohdr2a  = vo_holdamt_fmt
         vo_ndisc_amt:format in frame vohdr2a = vo_ndisc_fmt
         old_curr = vo_curr.

      if aptotal <> 0 then do:
         {gprun.i ""gpcurrnd.p"" "(input-output aptotal,
                        input rndmthd)"}
      end.

   end.  /* IF NEW_VCHR */

   /* VALIDATE BANK, BANK ENTITY, CHECK FORM */
   if ap_bank <> "" then do:

      find bk_mstr where bk_domain = global_domain and
                         bk_code = ap_bank
      no-lock no-error.

      if not available bk_mstr then do:
         /* Not a valid bank */
         run display-message
            (input 1200,
              input 3).
         next-prompt ap_bank with frame vohdr2.
         undo setb, retry.
      end.

      if ap_entity <> bk_entity
      and apc_multi_entity_pay = no
      then do:
         /* Bank entity must match voucher entity */
         run display-message
            (input 115,
             input 3).
         next-prompt ap_bank with frame vohdr2.
         undo setb, retry.
      end.

      /* CHECK BANK ENTITY SECURITY */
      {glenchk.i &entity=bk_entity &entity_ok=entity_ok}

      if not entity_ok then do:
         if batchrun then
            l_flag = true.
         next-prompt ap_bank with frame vohdr2.
         undo setb, retry.
      end.

      {&APVOMTM-P-TAG11}
      display
         bk_desc @ desc1
      with frame vohdr2.

      if bk_curr <> vo_curr then do:

         if bk_curr = base_curr then do:
            /* WARNING: BANK CURR <> VOUCHER CURR */
            run display-message
               (input 93,
                input 2).
            if ap_ckfrm <> "3" then do:
               ap_ckfrm = "3".
               /* WARNING: SETTING CHECK FORM TO 3 */
               run display-message
                  (input 179,
                   input 2).
               display ap_ckfrm with frame vohdr2.
            end.
         end.  /* IF BK_CURR = BASE_CURR */

         else do:
            /* ERROR: BANK CURR MUST EQUAL VO CURR OR BASE */
            run display-message
               (input 181,
                input 3).
            next-prompt ap_bank with frame vohdr2.
            undo setb, retry.
         end. /* BK_CURR <> BASE_CURR */

      end. /* IF BK_CURR <> VO_CURR */

   end. /* IF AP_BANK <> "" */

   {&APVOMTM-P-TAG12}

   /* VALIDATE ACCT/SUB/CC COMBO */
   if new_vchr
   then do:

      /* INITIALIZE SETTINGS */
      {gprunp.i "gpglvpl" "p" "initialize"}
      /* SET PROJECT VERIFICATION TO NO */
      {gprunp.i "gpglvpl" "p" "set_proj_ver" "(input false)"}
      /* AP_ACCT/SUB/CC VALIDATION */
      {gprunp.i "gpglvpl" "p" "validate_fullcode"
         "(input ap_acct,
           input ap_sub,
           input ap_cc,
           input """",
           output valid_acct)"}

      if valid_acct = no then do:
         if batchrun then
            l_flag = true.
         next-prompt ap_acct with frame vohdr2.
         undo setb, retry.
      end.

      /* INITIALIZE SETTINGS */
      {gprunp.i "gpglvpl" "p" "initialize"}
      /* SET PROJECT VERIFICATION TO NO */
      {gprunp.i "gpglvpl" "p" "set_proj_ver" "(input false)"}
      /* AP_DISC_ACCT/SUB/CC VALIDATION */
      {gprunp.i "gpglvpl" "p" "validate_fullcode"
         "(input ap_disc_acct,
           input ap_disc_sub,
           input ap_disc_cc,
           input """",
           output valid_acct)"}

      if valid_acct = no then do:
         if batchrun then
            l_flag = true.
         next-prompt ap_disc_acct with frame vohdr2.
         undo setb, retry.
      end.

      /* VERIFY ENTITY*/
      find en_mstr where en_domain = global_domain and
                         en_entity = ap_entity
      no-lock no-error.

      if not available en_mstr or en_consolidation then do:
         if not available en_mstr then
            /*INVALID ENTITY*/
            run display-message
               (input 3061,
                input 3).
         else
            /*CONSOLIDATION ENTITY*/
            run display-message
               (input 6183,
                input 3).
         next-prompt ap_entity with frame vohdr2.
         undo, retry.
      end.

      release en_mstr.

      /* VALIDATE ENTITY SECURITY */
      /* USER NOT AUTHORIZED FOR THIS ENTITY */
      {glenchk.i &entity=ap_entity &entity_ok=entity_ok}

      if not entity_ok
      then do:
         if batchrun then
            l_flag = true.
         next-prompt ap_entity with frame vohdr2.
         undo setb, retry.
      end. /* IF NOT entity_ok */

      /* VERIFY GL CALENDAR FOR SPECIFIED ENTITY */
      if vo_confirmed
         {&APVOMTM-P-TAG28}
      then do:
         {gpglef02.i &module = ""AP""
            &entity = ap_entity
            &date   = ap_effdate
            &prompt = "ap_entity"
            &frame  = "vohdr2"
            &loop   = "setb"}
      end.

   end. /* IF new_vchr */

   /* USE SUPP BANK TYPE THAT MATCHES CHECK FORM */
   csbdtype = if ap_ckfrm = "1" then "2"
              else
              if ap_ckfrm = "4" then "3"
              else
                 ap_ckfrm.

   if batchrun then
      l_flag = true.

   /* VALIDATE SUPPLIER BANK */
   {&APVOMTM-P-TAG13}
   {gpcsbval.i &addr  = ap_vend
      &bank  = vo__qad02
      &type  = csbdtype
      &date1 = ap_effdate
      &date2 = ap_effdate
      &field = vo__qad02
      &frame = vohdr2
      &loop  = setb}

   /* IF NO ERROR IS ENCOUNTERED SET l_flag TO false IN BATCH MODE */
   if batchrun then
      l_flag = false.

   /* VERIFY CHECK FORM  */
   {gpckfval.i
      &ckfrm         = ap_ckfrm
      &undoloop      = setb
      &curr          = vo_curr
      &error-warning = 3
      &frame         = vohdr2}
   {&APVOMTM-P-TAG14}

   if not vd_pay_spec and (ap_ckfrm = "3" or ap_ckfrm = "4")
   then do:
      /* PAY SPECIFICATION SET TO NO FOR SUPPLIER */
      run display-message
         (input 2662,
          input 2).
      if not batchrun then pause.
   end.

   {&APVOMTM-P-TAG15}
   /* IF SUPPLIER BANK IS BLANK FOR CHECK FORM 3 OR 4 THEN WARN */
   if vo__qad02 = " " and (ap_ckfrm = "3" or ap_ckfrm = "4")
   then do:
      /* SUPPLIER BANK REQUIRED WITH THIS CHECK FORM */
      run display-message
         (input 1841,
          input 2).
      if not batchrun then pause.
   end.

   /* ADDITIONAL CHECK FORM VALIDATION */
   if vd_misc_cr and lookup(ap_ckfrm, "1,2") = 0 then do:
      /* CHECK FORM INVALID FOR MISC CREDITORS */
      run display-message
         (input 2188,
          input 3).
      {&APVOMTM-P-TAG16}
      next-prompt ap_ckfrm with frame vohdr2.
      undo setb, retry.
   end.

   /* RESET EXCHANGE RATE WHEN CURRENCY IS MODIFIED */
   if  base_curr = vo_curr
   and (vo_ex_rate     <> 1
        or vo_ex_rate2 <> 1)
   then
      assign
         vo_ex_rate  = 1
         vo_ex_rate2 = 1.

   if (base_curr <> vo_curr and
      (new_vchr or (ap_effdate <> old_effdate and vo_confirm = no)))
   or l_getrate
   then do:

      assign
         et_eff_date = ap_effdate.

      /* GET EXCHANGE RATE, CREATE USAGE */
      {gprunp.i "mcpl" "p" "mc-create-ex-rate-usage"
         "(input vo_curr,
           input base_curr,
           input vo_ex_ratetype,
           input ap_effdate,
           output vo_ex_rate,
           output vo_ex_rate2,
           output vo_exru_seq,
           output mc-error-number)"}

      if mc-error-number <> 0 then do:
         run display-message
            (input mc-error-number,
             input 3).
         undo, retry.
      end.

      /* ACCT MUST EITHER BE BASE OR EQUAL TO VOUCHER CURR*/
      find ac_mstr where ac_domain = global_domain and
                         ac_code = ap_acct
      no-lock no-error.

      if available ac_mstr then do:

         /* CHECK ACCOUNT CURRENCY AGAINST VOUCHER, */
         /* WITH UNION TRANSPARENCY ALLOWED         */
         {gprunp.i "mcpl" "p" "mc-chk-transaction-curr"
            "(input ac_curr,
              input vo_curr,
              input ap_effdate,
              input true,
              output mc-error-number)"}

         if mc-error-number <> 0 then do:
            /*ACCT CURR MUST MATCH TRANSACTION OR BASE CURR*/
            run display-message
               (input 134,
                input 3).
            next-prompt ap_acct with frame vohdr2.
            undo setb, retry.
         end.
      end.

      /* ACCT MUST EITHER BE BASE OR EQUAL TO VOUCHER CURR*/
      find ac_mstr where ac_domain = global_domain and
                         ac_code = ap_disc_acct
      no-lock no-error.

      if available ac_mstr then do:

         /* CHECK ACCOUNT CURRENCY AGAINST VOUCHER, */
         /* WITH UNION TRANSPARENCY ALLOWED         */
         {gprunp.i "mcpl" "p" "mc-chk-transaction-curr"
            "(input ac_curr,
              input vo_curr,
              input ap_effdate,
              input true,
              output mc-error-number)"}

         if mc-error-number <> 0 then do:
            /*ACCT CURR MUST MATCH TRANSACTION OR BASE CURR*/
            run display-message
               (input 134,
                input 3).
            next-prompt ap_disc_acct with frame vohdr2.
            undo setb, retry.
         end.

      end.

      /* SPOT EXCHANGE RATE */
      {gprunp.i "mcui" "p" "mc-ex-rate-input"
         "(input vo_curr,
           input base_curr,
           input ap_effdate,
           input vo_exru_seq,
           input false,
           input frame-row(vohdr2) + 2,
           input-output vo_ex_rate,
           input-output vo_ex_rate2,
           input-output fixed_rate_not_used)"}

      /* RE-CALCULATE BASE AMOUNTS FOR UNCONFIRMED */
      /* VOUCHER WHEN EXCHANGE RATES ARE MODIFIED  */
      if not new_vchr
      then do:

         if po-attached
         then do:

            /* UPDATE VOUCHER DETAIL RECORDS   */
            {gprun.i ""apvomta4.p""}

            for each pvo_mstr
               fields(pvo_domain pvo_id pvo_order pvo_curr pvo_lc_charge)
                where pvo_domain = global_domain and
                      pvo_order =  vpo_po
            no-lock:

               for each vph_hist
                  fields(vph_domain vph_curr_amt vph_inv_cost vph_inv_qty
                         vph_pvod_id_line vph_pvo_id vph_ref)
                   where vph_domain = global_domain and
                         vph_pvo_id = pvo_id
               exclusive-lock:

                  if (pvo_curr <> base_curr
                  or  vo_curr  <> base_curr)
                  then do:

                     run mcpl-mc-curr-conv
                        (input  vo_curr,
                         input  base_curr,
                         input  vo_ex_rate,
                         input  vo_ex_rate2,
                         input  vph_curr_amt,
                         input  true, /* ROUND */
                         output vph_inv_cost,
                         output mc-error-number).

                     if mc-error-number <> 0 then
                        run display-message
                           (input mc-error-number,
                            input 2).

                  end. /* IF pvo_curr <> base_curr ... */

/*P2PJ*/       end. /* FOR EACH vph_hist */
            end. /* FOR EACH pvo_mstr */

         end. /* IF po-attached */

         else do :

            /* RECALCULATE THE DETAIL BASE AMOUNTS */
            for each vod_det
               fields( vod_domain vod_ref vod_amt vod_base_amt)
                where vod_domain = global_domain and
                      vod_ref = vo_ref
            exclusive-lock:

               run  mcpl-mc-curr-conv
                  (input  vo_curr,
                   input  base_curr,
                   input  vo_ex_rate,
                   input  vo_ex_rate2,
                   input  vod_amt,
                   input  true, /* ROUND */
                   output vod_base_amt,
                   output mc-error-number).

               if mc-error-number <> 0 then
                  run display-message
                     (input mc-error-number,
                      input 2).

            end. /* FOR EACH vod_det */

         end. /* ELSE DO */

         run mcpl-mc-curr-conv
            (input  vo_curr,
             input  base_curr,
             input  vo_ex_rate,
             input  vo_ex_rate2,
             input  ap_amt,
             input  true, /* ROUND */
             output ap_base_amt,
             output mc-error-number).

         if mc-error-number <> 0 then
            run display-message
               (input mc-error-number,
                input 2).

         run mcpl-mc-curr-conv
            (input  vo_curr,
             input  base_curr,
             input  vo_ex_rate,
             input  vo_ex_rate2,
             input  vo_ndisc_amt,
             input  true, /* ROUND */
             output vo_base_ndisc,
             output mc-error-number).

         if mc-error-number <> 0 then
            run display-message
               (input mc-error-number,
                input 2).

         run mcpl-mc-curr-conv
            (input  vo_curr,
             input  base_curr,
             input  vo_ex_rate,
             input  vo_ex_rate2,
             input  vo_hold_amt,
             input  true, /* ROUND */
             output vo_base_hold_amt,
             output mc-error-number).

         if mc-error-number <> 0 then
            run display-message
               (input mc-error-number,
                input 2).

      end. /* IF NOT new_vchr */

   end.  /* IF NEW AP_MSTR AND VO_CURR <> BASE_CURR */

   assign
      ap_ex_rate = vo_ex_rate
      ap_ex_rate2 = vo_ex_rate2
      ap_ex_ratetype = vo_ex_ratetype
      ap_curr = vo_curr.

   /* COPY RATE USAGE FROM VO TO AP */
   {gprunp.i "mcpl" "p" "mc-copy-ex-rate-usage"
      "(input vo_exru_seq,
        output ap_exru_seq)"}

   assign
      vo_invoice.

   {&APVOMTM-P-TAG17}

   if vo_invoice <> "" then do:

      invoice-loop:
      for each vomstr1 where vomstr1.vo_domain = global_domain
                         and vomstr1.vo_invoice = vo_mstr.vo_invoice
                         and vomstr1.vo_ref <> vo_mstr.vo_ref
      no-lock:

         find first apmstr1 where apmstr1.ap_domain = global_domain and
                                  apmstr1.ap_ref = vomstr1.vo_ref and
                                  apmstr1.ap_type = "VO" and
                                  apmstr1.ap_vend = ap_mstr.ap_vend
         no-lock no-error.

         if available apmstr1 then do:
            /* Supplier invoice previously vouchered, Reference: */
            {pxmsg.i &MSGNUM=2201 &ERRORLEVEL=2 &MSGARG1=apmstr1.ap_ref}
            if not batchrun then pause.
            leave invoice-loop.
         end.

      end.

   end.

   if  vo_disc_date = ?  or vo_due_date = ? then do:

      /* ADD INITIAL READ OF CT_MSTR HERE, SO THAT IT IS */
      /* AVAILABLE WITHIN THIS BLOCK; THIS IS NECESSARY  */
      /* TO READ THE CTD_DET FILE FOR MULT. DUE DATES    */
      /* CREDIT TERMS RECORDS (FO54)                     */
      find ct_mstr where ct_domain = global_domain and
                         ct_code = vo_cr_terms
      no-lock no-error.

      if not available ct_mstr or ct_dating = no then do:
         {gprun.i ""adctrms.p""
            "(input ap_date,
              input vo_cr_terms,
              output calcd_disc_date,
              output calcd_due_date)"}
      end.

      else do:

         /* IF MULT. DUE DATES CREDIT TERMS, GET LAST DUE DATE */
         find last ctd_det where ctd_domain = global_domain and
                                 ctd_code = vo_cr_terms
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

   end.

   display
      vo_disc_date
      vo_due_date
   with frame vohdr2.
   {&APVOMTM-P-TAG18}

   /*  CHECK FOR PAYMENT */
   if vo_applied <> 0 then do:

      find first ckd_det where ckd_domain = global_domain and
                               ckd_voucher = ap_ref
      no-lock no-error.

      repeat:

         if not available ckd_det then leave.
         else do:

            find ck_mstr where ck_domain = global_domain and
                               ck_ref = ckd_ref
            no-lock no-error.

            if available ck_mstr and ck_status <> "VOID"
            then do:
               ckdref = ckd_ref.
               /*PAYMENT APPLIED, DETAIL LINES CANNOT BE MODIF.*/
               {pxmsg.i &MSGNUM=1180 &ERRORLEVEL=2 &MSGARG1=ckdref}
               pmt_exists = yes.
               undo_all = no.
               leave setb.
            end.
            else
            find next ckd_det where ckd_domain = global_domain and
                                    ckd_voucher = ap_ref
            no-lock no-error.

         end.

      end.

      if keyfunction(lastkey) = "END-ERROR" then undo, retry.

   end.

/* SS - 110114.1 - B */
               {gprun.i ""xxgpdescm.p""
                  "(input        frame-row(vohdr2) - 3,
                    input-output ap_rmk)"}
               {xxgpdescm2.i &table=ap_mstr &desc=ap_rmk}
/* SS - 110114.1 - E */
   hide frame vohdr2 no-pause.
   view frame vohdr2a.

   vchr_logistics_chrgs = false.

   /* IF AN EXISTING VOUCHER IS FOR LOGISTICS CHARGE THEN THE DEFAULT  */
   /* SETTING FOR vchr_logistics_chrgs SHOULD BE TRUE/YES.             */
   if not po-attached and not new_vchr and use-log-acctg then do:
      for first vph_hist
         fields(vph_domain vph_pvo_id)
          where vph_domain = global_domain and vph_ref = vo_ref
      no-lock: end.
      if available vph_hist and
         can-find(first pvo_mstr where pvo_domain = global_domain
                                   and pvo_id = vph_pvo_id
                                   and pvo_lc_charge <> "" )
      then
         vchr_logistics_chrgs = true.
   end. /* IF NOT NEW_VCHR */

   display
      vo_prepay
      vo_hold_amt
      vo_ndisc_amt
      vchr_logistics_chrgs
      incl_blank_suppliers
      ap_dy_code
      auto-select
   with frame vohdr2a.

   setc:
   do on error undo, retry:

      if batchrun then
         l_flag = true.

      prompt-for
         vo_prepay
         vo_ndisc_amt
      with frame vohdr2a
      editing:

         readkey.

         if keyfunction (lastkey) = "end-error" then do:
            {gprun.i ""apvoundo.p""
               "(input po-attached,
                 output confirm_undo)"}
            if confirm_undo = no then
               assign
                  next_loopc = yes
                  undo_all = no.
            else
               undo_all = yes.
            hide frame vohdr2a no-pause.
            return.
         end.

         else
            apply lastkey.

      end. /* EDITING CLAUSE */

      assign
         vo_prepay    = decimal(vo_prepay:screen-value)
         vo_ndisc_amt = decimal(vo_ndisc_amt:screen-value).

      /* IF NO ERROR IS ENCOUNTERED IN BATCH MODE SET l_flag TO false */
      if batchrun then
         l_flag = false.

      if vo_prepay <> 0 then do:

         {gprun.i ""gpcurval.p""
            "(input vo_prepay,
              input rndmthd,
              output retval)"}

         if retval <> 0 then do:
            if batchrun then
               l_flag = true.
            next-prompt vo_prepay with frame vohdr2a.
            undo setc, retry setc.
         end.

      end.

      if vo_ndisc_amt <> 0 then do:

         {gprun.i ""gpcurval.p""
            "(input vo_ndisc_amt,
              input rndmthd,
              output retval)"}

         if retval <> 0 then do:
            if batchrun then
               l_flag = true.
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

         if not can-find(dy_mstr where dy_domain = global_domain and
                                       dy_dy_code = ap_dy_code)
         then do:
            /* INVALID DAYBOOK */
            run display-message
               (input 1299,
                input 3).
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
               /* WARNING: DAYBOOK DOES NOT MATCH ANY DEFAULT */
               run display-message
                  (input 1674,
                   input 2).
               if not batchrun then pause.
            end. /* if daybook-error */

            {gprunp.i "nrm" "p" "nr_can_dispense"
               "(input ap_dy_code,
                 input ap_effdate)"}

            {gprunp.i "nrm" "p" "nr_check_error"
               "(output daybook-error,
                 output return_int)"}

            if daybook-error then do:
               run display-message
                  (input return_int,
                   input 3).
               next-prompt ap_dy_code with frame vohdr2a.
               undo setc, retry.
            end.

            find dy_mstr where dy_domain = global_domain and
                               dy_dy_code = ap_dy_code
            no-lock no-error.

            if available dy_mstr then
               assign
                  daybook-desc = dy_desc
                  dft-daybook = ap_dy_code.

         end. /*ELSE DO*/

      end. /* if daybooks-in-use and new vo_mstr */

      /* VCHR_LOGISTICS_CHRGS SHOULD BE ENABLED FOR A NEW VOUCHER WITH NO PO  */
      /* ATTACHED WHEN LOGISTICS ACCOUNTING IS ENABLED.                       */
      {&APVOMTM-P-TAG26}
      if (not po-attached) and use-log-acctg then
      {&APVOMTM-P-TAG27}
         set
            vchr_logistics_chrgs
         with frame vohdr2a.

      if (not po-attached)
         and use-log-acctg
         and vchr_logistics_chrgs
         and lac_blank_suppliers
      then
         set
            incl_blank_suppliers
         with frame vohdr2a.

      /* AUTO SELECT SHOULD BE EDITABLE ONLY FOR NEW VOUCHER */
      if batchrun then
         l_flag = true.

      /* IF THERE ARE NO POs ATTACHED, AUTO-SELECT SHOULD BE ENABLED WHEN */
      /* VCHR_LOGISTICS_CHRGS IS TRUE.                                    */
      if (new_vchr and (po-attached or vchr_logistics_chrgs))
      then do:

         set
            auto-select
         with frame vohdr2a
         editing:

            readkey.

            if keyfunction (lastkey) = "end-error" then do:

               {gprun.i ""apvoundo.p"" "(input po-attached,
                                         output confirm_undo)"}
               if confirm_undo = no then
                  assign
                     next_loopc = yes
                     undo_all = no.
               else
                  undo_all = yes.

               hide frame vohdr2a no-pause.
               return.

            end.
            else
               apply lastkey.

         end. /* EDITING CLAUSE */

      end. /* IF (PO-ATTACHED... */

      /* IF NO ERROR IS ENCOUNTERED SET l_flag TO false IN BATCH MODE */
      if batchrun then
         l_flag = false.

      /* ADD TO VENDOR PREPAY BALANCE*/
      if vo_prepay <> 0 then do:

         base_prepay = vo_prepay.

         if base_curr <> vo_curr then do:

            /* CONVERT FROM FOREIGN TO BASE CURRENCY */
            run mcpl-mc-curr-conv
               (input vo_curr,
                input base_curr,
                input vo_ex_rate,
                input vo_ex_rate2,
                input base_prepay,
                input true, /* ROUND */
                output base_prepay,
                output mc-error-number).

            if mc-error-number <> 0 then do:
               run display-message
                  (input mc-error-number,
                   input 2).
           end. /* IF mc-error-number <> 0 */

         end. /* IF base_curr <> vo_curr */

      end.   /* IF vo_prepay <> 0 */

   end. /* SET C */

   if l_flag = true then
      return.

   {&APVOMTM-P-TAG19}
   {&APVOMTM-P-TAG20}

   undo_tframe = true.

   /* EDIT GTM TAX FIELDS */
   {gprun.i ""apvomte.p""}

   if undo_tframe then
      /* l_flag IS SET TO true IN BATCH MODE IN apvomte.p */
      /* FOR AN ERROR ENCOUNTERED.                        */
      if not l_flag
      then
         undo, retry.
      else
         return.
      {&APVOMTM-P-TAG25}
   undo_all = no.

end. /* SET B */

PROCEDURE display-message:
/*-----------------------------------------------------------------------
   Purpose:      To display error message

   Parameters:   1. input i-msgnum - message number
                 2. input i-level - error level

   Note:         Procedure created to remove Error "Action Segment has exceeded
                 its limit of 63488 bytes".
-------------------------------------------------------------------------*/

   define input parameter i-msgnum as integer no-undo.
   define input parameter i-level  as integer no-undo.

   {pxmsg.i &MSGNUM=i-msgnum &ERRORLEVEL=i-level}

   /* IF AN ERROR IS ENCOUNTERED IN BATCH MODE l_flag IS SET TO true */
   if batchrun and i-level >= 3 then
     l_flag = true.

END PROCEDURE.


PROCEDURE mcpl-mc-curr-conv:
/*-----------------------------------------------------------------------
   Purpose:      To convert amount from i-curr1 to i-curr2

   Parameters:   1. input i-curr1 - source currency
                 2. input i-curr2 - target currency
                 3. input i-rate1 - rate1
                 4. input i-rate2 - rate2
                 5. input i-amt   - amount to convert
                 6. input i-round - if rounding is needed
                 7. output o-amt   - converted amount
                 8. output o-error - error number if any

   Note:         Procedure created to remove Error "Action Segment has exceeded
                 its limit of 63488 bytes".
-------------------------------------------------------------------------*/

   define input parameter i-curr1      like exr_curr1 no-undo.
   define input parameter i-curr2      like exr_curr1 no-undo.
   define input parameter i-rate1      like exr_rate  no-undo.
   define input parameter i-rate2      like exr_rate  no-undo.
   define input parameter i-amt        like ard_amt   no-undo.
   define input parameter i-round      as logical     no-undo.
   define output parameter o-amt        like ard_amt   no-undo.
   define output parameter o-error      like mc-error-number no-undo.

   {gprunp.i "mcpl" "p" "mc-curr-conv"
      "(input i-curr1,
        input i-curr2,
        input i-rate1,
        input i-rate2,
        input i-amt,
        input i-round,
        output o-amt,
        output o-error)"}

END PROCEDURE.
