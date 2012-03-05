/* ardrmta.p - AR DEBIT/CREDIT MEMO MAINTENANCE - Detail Lines                */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.18.1.24 $                                                     */
/*V8:ConvertMode=Maintenance                                                  */
/* REVISION: 6.0      LAST MODIFIED: 08/22/90   BY: MLB *D055*                */
/*                                   09/06/90   BY: MLB *D065*                */
/*                                   10/17/90   BY: PML *D109*                */
/*                                   10/22/90   BY: MLB *D123*                */
/*                                   10/31/90   BY: afs *D160*                */
/*                                   11/02/90   BY: MLB *D170*                */
/*                                   01/03/91   BY: MLB *D238*                */
/*                                   02/28/91   BY: afs *D387*                */
/*                                   03/12/91   BY: MLB *D360*                */
/*                                   03/26/91   BY: MLB *D451*                */
/*                                   04/02/91   BY: bjb *D507*                */
/*                                   05/31/91   BY: MLV *D667*                */
/*                                   06/06/91   BY: MLV *D674*                */
/* REVISION: 7.0      LAST MODIFIED: 10/16/91   BY: MLV *F023*                */
/*                                   11/07/91   BY: MLV *F031*                */
/*                                   02/05/92   BY: MLV *F164*                */
/*                                   03/22/92   BY: TMD *F302*                */
/*                                   04/11/92   BY: afs *F356*                */
/*                                   04/14/92   BY: jms *F390*                */
/*                                   04/14/92   BY: jms *F391*                */
/*                                   06/19/92   BY: tmd *F458*                */
/*                                   06/24/92   BY: jjs *F681*                */
/* REVISION: 7.3      LAST MODIFIED: 07/22/92   BY: mpp *G003*                */
/*                                   11/10/92   BY: mpp *G307*                */
/*                                   01/12/93   BY: mpp *G534*                */
/*                                   01/25/93   BY: mpp *G587*                */
/*                                   03/10/93   BY: bcm *G796*                */
/*                                   04/09/93   BY: jms *G933*                */
/* REVISION: 7.4      LAST MODIFIED: 06/24/93   BY: wep *H021*                */
/*                                   09/08/93   BY: bcm *H106*                */
/*                                   11/17/93   BY: bcm *H230*                */
/*                                   11/23/93   BY: bcm *H240*                */
/*                                   05/13/94   BY: pmf *FO14*                */
/*                                   06/22/94   BY: pmf *FP06*                */
/*                                   06/27/94   BY: wep *H409*                */
/*                                   09/15/94   BY: ljm *GM57*                */
/*                                   10/17/94   BY: ljm *GN36*                */
/*                                   12/27/94   BY: srk *G0B2*                */
/*                                   02/23/95   BY: jzw *H0BM*                */
/*                                   04/10/95   BY: jpm *H0CH*                */
/*                                   04/22/95   BY: wjk *H0CS*                */
/*                                   01/24/96   BY: jzw *H0J6*                */
/*                                   02/01/96   BY: jzw *H0JK*                */
/* REVISION: 8.5      LAST MODIFIED: 12/19/95   BY: taf *J053*                */
/*                                   04/02/96   BY: jpm *J0GW*                */
/*                                   07/25/96   BY: taf *J11H*                */
/*                                   07/30/96   BY: jwk *H0M6*                */
/* REVISION: 8.6      LAST MODIFIED: 12/30/96   BY: *K03F* Jeff Wootton       */
/* REVISION: 8.6      LAST MODIFIED: 01/23/97   BY: bjl *K01G*                */
/*                                   02/17/97   BY: *K01R* E. Hughart         */
/*                                   04/21/97   *K0C3* Jeff Wootton           */
/*                                   05/06/97   *K0CX* E. Hughart             */
/* REVISION: 8.6      LAST MODIFIED: 06/27/97   BY: *J1VK* Irine D'mello      */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane          */
/* REVISION: 8.6E     LAST MODIFIED: 05/15/98   BY: *J2M2* Dana Tunstall      */
/* REVISION: 8.6E     LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan         */
/* REVISION: 8.6E     LAST MODIFIED: 06/02/98   BY: *L01K* Jaydeep Parikh     */
/* REVISION: 8.6E     LAST MODIFIED: 09/01/98   BY: *J2Y9* Abbas Hirkani      */
/* REVISION: 9.0      LAST MODIFIED: 03/10/99   BY: *M0B3* Michael Amaladhas  */
/* REVISION: 9.0      LAST MODIFIED: 03/13/99   BY: *M0BD* Alfred Tan         */
/* REVISION: 9.1      LAST MODIFIED: 06/10/99   BY: *J3GB* Jose Alex          */
/* REVISION: 9.1      LAST MODIFIED: 06/23/99   BY: *K20Y* Hemali Desai       */
/* REVISION: 9.1      LAST MODIFIED: 08/05/99   BY: *K217* Rajesh Lokre       */
/* REVISION: 9.1      LAST MODIFIED: 10/01/99   BY: *N014* Jeff Wootton       */
/* REVISION: 9.1      LAST MODIFIED: 10/22/99   BY: *N04P* Robert Jensen      */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane   */
/* REVISION: 9.1      LAST MODIFIED: 08/11/00   BY: *N0KK* jyn                */
/* REVISION: 9.1      LAST MODIFIED: 01/03/01   BY: *M0Z9* Vinod Nair         */
/* REVISION: 9.1      LAST MODIFIED: 01/31/01   BY: *M10C* Veena Lad          */
/* REVISION: 9.1      LAST MODIFIED: 02/13/01   BY: *N0WW* Mudit Mehta        */
/* REVISION: 9.1      LAST MODIFIED: 03/14/01   BY: *N0X6* Vinod Nair         */
/* Old ECO marker removed, but no ECO header exists *F001*                    */
/* Old ECO marker removed, but no ECO header exists *K06X*                    */
/* Revision: 1.18.1.14    BY: Katie Hilbert      DATE: 04/01/01 ECO: *P002*   */
/* Revision: 1.18.1.15    BY: Vinod Nair         DATE: 06/08/01 ECO: *M18H*   */
/* Revision: 1.18.1.16    BY: Vihang Talwalkar   DATE: 10/22/01 ECO: *P01V*   */
/* Revision: 1.18.1.17    BY: Ed van de Gevel    DATE: 12/03/01 ECO: *N16R*   */
/* Revision: 1.18.1.18    BY: Sandeep Parab      DATE: 04/15/02 ECO: *M1WP*   */
/* Revision: 1.18.1.21    BY: Dipesh Bector      DATE: 06/24/02 ECO: *M1ZR*   */
/* $Revision: 1.18.1.24 $ BY: Ashish Maheshwari  DATE: 07/31/02 ECO: *N1PZ*   */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

{mfdeclre.i}
{cxcustom.i "ARDRMTA.P"}
{gplabel.i} /* EXTERNAL LABEL INCLUDE */

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE ardrmta_p_1 "Batch Control"
/* MaxLen: Comment: */

&SCOPED-DEFINE ardrmta_p_6 "Tax Usage"
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */

{gldydef.i}
{gldynrm.i}

/* HANDLE FOR PROCESSING-LOGIC SUBPROGRAM ARDRMTPL.P */
define shared variable h_rules as handle no-undo.

/* VARIABLES ASSIGNED IN ARDRMTH.P, USED IN ARDRMTA.P */
{ardrmtha.i}

define shared variable rndmthd      like rnd_rnd_mthd.
define shared variable ar_amt_fmt   as character.
define shared variable ar_recno     as recid.
define shared variable del-yn       like mfc_logical initial no.
define shared variable do_tax       like mfc_logical.
define shared variable arnbr        like ar_nbr.
define shared variable jrnl         like glt_ref.
define shared variable bactrl       like ar_amt
   label {&ardrmta_p_1}.
define shared variable batch        like ar_batch.
define shared variable artotal      like ar_amt.
define shared variable old_amt      like ar_amt.
define shared variable ardnbr       like ard_nbr.
define shared variable old_cust     like ar_cust.
define shared variable old_effdate  like ar_effdate.
define shared variable base_amt     like ar_amt.
define shared variable gltline      like glt_line.
define shared variable undo_header  like mfc_logical no-undo.

define new shared variable ard_recno    as recid.
define new shared variable tax_recno    as recid.
define new shared variable undo_all     like mfc_logical.
define new shared variable curr_amt     like glt_amt.
define new shared variable taxcode      like ard_tax.
define new shared variable base_det_amt like glt_amt.
define new shared variable undo_trl2    like mfc_logical.
define new shared variable maint        like mfc_logical no-undo.
define new shared variable recalc_tax   like mfc_logical initial true.
define new shared variable taxable_in   like ad_tax_in no-undo
   initial false.

define variable term-disc      as decimal.
define variable tax            like ard_amt extent 3.
define variable taxable_amt    like ard_amt.
define variable i              as integer.
define variable tax_date       like tax_effdate.
define variable valid_acct     like mfc_logical.
define variable tax_tr_type    like tx2d_tr_type.
define variable tax_nbr        like tx2d_nbr.
define variable tax_usage      like tx2_tax_usage label {&ardrmta_p_6}.
define variable tax_class      like ad_taxc no-undo.
define variable tax_edit       like mfc_logical.

define variable tax_total      like tx2d_totamt.
define variable tax_view       like yes_char.
define variable tax_taxable    like ad_taxable initial false.
define variable tax_in         like ad_tax_in initial false.
define variable set_txrec_vars like mfc_logical initial false.
define variable undo_taxpop    like mfc_logical no-undo.
define variable retval         as integer.
define variable tmpamt         as decimal.
define variable tot_tax_used   as decimal no-undo.
define variable base_tot_tax_used as decimal no-undo.
define variable argl_ref       like glt_ref no-undo.
define variable base_ard_amt   like ard_amt no-undo.
define variable base_tax_included like ar_amt no-undo.
define variable base_tot_tax_included like ar_amt no-undo.
define variable tax_included   like ard_amt no-undo.
define variable tot_tax_included like ar_amt no-undo.
define variable taxin_tran_amt like ard_amt no-undo.
define variable mc-error-number like msg_nbr no-undo.
define variable disp_tax like yes_char no-undo.
define variable l_old_ard_amt  like ard_amt  no-undo.
define variable l_old_ard_desc like ard_desc no-undo.
define variable entity_ok      like mfc_logical no-undo.
define variable l_gltamt       like glt_amt     no-undo.
define variable l_gltcurramt   like glt_amt     no-undo.
define variable l_tmpamt       like glt_amt     no-undo.

{&ARDRMTA-P-TAG1}

define buffer arddet for ard_det.

/* DEFINE VARIABLES FOR GPGLEF.P (GL CALENDAR VALIDATION) */
{gpglefdf.i}

/* DEFINE SHARED FRAME B */
{ardrfmb.i}

/* Define Logistics tables */
{lgardefs.i &type="lg"}

/* GET ENTITY SECURITY INFORMATION */
{glsec.i}

form
   ard_det.ard_acct         colon 10
   ard_det.ard_sub          no-label
   ard_det.ard_cc           no-label
   ard_det.ard_project      no-label
   ard_det.ard_entity       colon 10
   ard_det.ard_desc         colon 51
   ard_det.ard_amt          colon 51
with frame d width 80 side-labels
   title color normal (getFrameTitle("TAX_DISTRIBUTION",24)).

/* SET EXTERNAL LABELS */
setFrameLabels(frame d:handle).

ard_det.ard_amt:format = ar_amt_fmt.

find first gl_ctrl no-lock no-error.

maint = true. /*SET FOR NEW TAXES, WILL ALLOW VIEW OF TAX DETAIL*/
{&ARDRMTA-P-TAG2}

/* If logistics active, point to first table */
if lgData then do:
   find first lgml_lgdet no-lock no-error.
end.

mainloop:
repeat:

   find ar_mstr where recid(ar_mstr) = ar_recno
      no-lock no-error.

   display ar_amt with frame b.

   loopc:
   repeat with frame c width 80:
      /* LOOPC IS THE TRANSACTION FOR ONE DETAIL LINE */

      find ba_mstr where ba_batch = ar_batch and ba_module = "AR"
         exclusive-lock no-error.
      find ar_mstr where recid(ar_mstr) = ar_recno
         exclusive-lock no-error.

      /* DISPLAY SELECTION FORM */

      form
         ard_acct         colon 10
         ard_sub          no-label
         ard_cc           no-label
         ard_project      no-label
         ard_tax_at       colon 51
         ard_entity       colon 10
         ard_desc         colon 51
         ard_taxc         colon 10
         ard_amt          colon 51
      with frame c 1 down width 80 side-labels.

      /* SET EXTERNAL LABELS */
      setFrameLabels(frame c:handle).

      ard_amt:format = ar_amt_fmt.

      display artotal with frame b.
      taxcode = "".

      /* DEFAULT ard_tax_at TO HEADER TAXABLE STATUS */
      if hdr_tax_taxable then
         display yes_char @ ard_tax_at with frame c.
      else
         display no_char @ ard_tax_at with frame c.

      display ar_entity @ ard_entity.

      /* VAT TO GTM CONVERTED MEMO STORES VAT CLASS    */
      /* IN ard_tax_at INSTEAD OF YES/NO, HENCE DETAIL */
      /* MODIFICATION IS NOT ALLOWED FOR THE CONVERTED */
      /* MEMOS                                         */

      if can-find(first ard_det
                     where ard_det.ard_nbr  =  ar_nbr
                     and   ard_det.ard_ref  =  ""
                     and   ard_det.ard_type <> "F"
                     and   lookup(ard_det.ard_tax_at,"Yes,No") = 0)
      then do:
         /* DETAIL MODIFICATION NOT ALLOWED */
         /* FOR VAT TO GTM CONVERTED MEMOS  */
         {pxmsg.i &MSGNUM=5255
                  &ERRORLEVEL=4}
         leave loopc.
      end. /* IF CAN-FIND(FIRST... */

      /* If not Logistics, process normally */
      if not lgData then do:

         prompt-for ard_det.ard_acct
            ard_sub
            ard_cc
            ard_project
            ard_entity
            ard_tax_at
            editing:

            if frame-field = "ard_acct" then do:

               /* FIND NEXT/PREVIOUS RECORD */
               {mfnp01.i ard_det ard_acct ard_acct ar_nbr ard_nbr
                  ard_nbr}
               if recno <> ? then do:
                  /*DISPLAY EXISTING RECORD */
                  if ard_tax_at = "yes" then
                     assign disp_tax = yes_char.
                  else
                  assign
                     disp_tax = no_char.

                  display
                     ard_acct
                     ard_sub
                     ard_cc
                     ard_project
                     ard_entity
                     disp_tax @ ard_tax_at
                     ard_desc
                     ard_amt.
                  /*OVERRIDE DEFAULT TAX VARS WITH THOSE ON FILE*/
                  assign
                     tax_class      = ard_taxc
                     tax_usage      = ard_tax_usage
                     set_txrec_vars = true.

                  /*SET REMAINING TAX MGT FIELDS*/
                  taxcode = ard_tax.
               end.
               else do:
                  /*DEFAULT TAX VARIABLES FROM TEMP FIELDS */
                  /*IF NOT PREVIOUSLY SET ON A FOUND RECORD*/
                  if not set_txrec_vars then
                  assign
                     tax_class = hdr_tax_class
                     tax_usage = hdr_tax_usage.
               end.
            end.
            else do:
               status input.
               readkey.
               apply lastkey.
            end.
         end.
      end. /* if not lgData */
      else do:
         /* Read data from the Logistics tables */
         run SetLogData.
      end.
      {&ARDRMTA-P-TAG8}
      {&ARDRMTA-P-TAG9}
      if ar_curr <> base_curr
      then do:
         if can-find (first ac_mstr where ac_code =
            input ard_acct and
            ac_curr <> ar_curr   and
            ac_curr <> base_curr)
         then do:
            /* ACCT CURRENCY MUST MATCH TRANSACTION OR */
            /* BASE CURRENCY                           */
            {pxmsg.i &MSGNUM=134 &ERRORLEVEL=3}
            /* Do not retry for Logistics, just fail */
            if lgData then return.
            next-prompt ard_acct with frame c.
            undo loopc, retry.
         end. /* IF CAN-FIND(FIRST AC_MSTR..) */
      end.    /* IF AR_CURR <> BASE_CURR      */

      /* VALIDATE ACCT/SUB/CC COMBO */

      /* INITIALIZE SETTINGS */
      {gprunp.i "gpglvpl" "p" "initialize"}

      /* ACCT/SUB/CC VALIDATION */
      {gprunp.i "gpglvpl" "p" "validate_fullcode"
         "(input input ard_acct,
           input input ard_sub,
           input input ard_cc,
           input input ard_project,
           output valid_acct)"}
      if valid_acct = no then do:
         next-prompt ard_acct with frame c.
         if lgData then return.
         undo loopc, retry.
      end.

      /* VERIFY ENTITY */
      if input ard_entity <> glentity then do:
         find en_mstr where en_entity = input ard_entity
            no-lock no-error.
         if not available en_mstr then do:
            {pxmsg.i &MSGNUM=3061 &ERRORLEVEL=3} /*INVALID ENTITY*/
            if lgData then return.
            next-prompt ard_entity with frame c.
            undo loopc, retry.
         end.
         release en_mstr.
      end.

      /* CHECK ENTITY SECURITY */
      {glenchk.i &entity="input ard_entity" &entity_ok=entity_ok}
      if not entity_ok
      then do:
         if lgData
         then
            return.
         next-prompt ard_entity with frame c.
         undo loopc, retry.
      end. /* IF NOT entity_ok */

      /* VERIFY ENTITY FOR DAYBOOKS */
      if daybooks-in-use then do:
         {gprun.i ""gldyver.p"" "(input ""AR"",
                                  input ar_type,
                                  input ar_dy_code,
                                  input input ard_entity,
                                  output daybook-error)"}
         if daybook-error then do:
            {pxmsg.i &MSGNUM=1674 &ERRORLEVEL=2}
            /* WARNING: DAYBOOK DOES NOT MATCH ANY DEFAULT */
            pause.
         end.
      end.

      /* VERIFY GL CALENDAR FOR SPECIFIED ENTITY */
      {gpglef02.i &module = ""AR""
         &entity = "input ard_entity"
         &date   = ar_effdate
         &prompt = "ard_entity"
         &frame  = "c"
         &loop   = "loopc"}

      /* OBTAIN tax_in SETTING FROM HEADER */
      assign
         tax_in     = hdr_tax_in
         taxable_in = hdr_tax_in.

      if input ard_tax_at <> "" and input ard_tax_at <> no_char
         and input ard_tax_at <> yes_char
      then do:
         /*ERROR: TAX FIELD MUST BE Y,N, OR BLANK*/
         {pxmsg.i &MSGNUM=117 &ERRORLEVEL=3}
         if lgData then return.
         next-prompt ard_tax_at with frame c.
         undo loopc, retry.
      end.
      else
      if input ard_tax_at = "" or
         input ard_tax_at = yes_char then do:
         tax_taxable = true.

         taxloop2:
         do on error undo, retry:
            /* DO NOT SELECT TAX LINES */
            if taxcode <> "t" then do:

               /* No pop up tax windows for logistics */
               if not lgData then do:
                  /* TAX MANAGEMENT TRANSACTION POP-UP. */
                  /* PARAMETERS ARE 5 FIELDS */
                  /* AND UPDATEABLE FLAGS, */
                  /* STARTING ROW, AND UNDO FLAG. */
                  {gprun.i ""txtrnpop.p""
                        "(input-output tax_usage,   input true,
                          input-output tax_env,     input false,
                          input-output tax_class,   input true,
                          input-output tax_taxable, input false,
                          input-output tax_in,      input false,
                          input 12,
                          output undo_taxpop)"}

                  {&ARDRMTA-P-TAG3}
                  if undo_taxpop then undo loopc, retry.
               end.
               {&ARDRMTA-P-TAG4}

               recalc_tax = true.  /* WHEN UPDATING TAX DATA*/
            end. /* IF TAXCODE <> "T" */
         end.

         display yes_char @ ard_tax_at with frame c.
      end.
      {&ARDRMTA-P-TAG10}
      {&ARDRMTA-P-TAG11}
      {&ARDRMTA-P-TAG5}
      /* ADD/MOD/DELETE  */

      find first ard_det
      where ard_nbr     = ar_nbr            and
            ard_ref     = ""                and
            ard_type    = input ard_project and
            ard_acct    = input ard_acct    and
            ard_sub     = input ard_sub     and
            ard_cc      = input ard_cc      and
            ard_entity  = input ard_entity  and
            (substring(right-trim(ard_tax_at),1,1) =
            input ard_tax_at)              and
            (ard_tax = taxcode or taxcode = "")
            {&ARDRMTA-P-TAG12}
            exclusive-lock no-error.

      {&ARDRMTA-P-TAG13}
      if not available ard_det then do:
         {pxmsg.i &MSGNUM=1 &ERRORLEVEL=1} /* ADDING NEW RECORD */
         create ard_det.
         assign
            ard_nbr = ar_nbr
            ard_acct
            ard_sub
            ard_cc
            ard_entity
            ard_project
            ard_dy_code = dft-daybook
            /* NOTE - FOR FIRST ARD_DET, */
            /* NRM-SEQ-NUM HAS NOT BEEN DETERMINED YET, */
            /* SO IT WILL BE ASSIGNED AFTER ARARGL.P. */
            ard_type = input ard_project
            ard_taxc      = tax_class
            ard_tax_usage = tax_usage.
         if input ard_tax_at = no_char then
               ard_tax_at = "no".                /* ENTERED AS Y/N, */
         if input ard_tax_at = yes_char then  /* STORE AS YES/NO */
            ard_tax_at = "yes".
         find ac_mstr where ac_code =
            ard_acct
            no-lock no-error.
         if available ac_mstr then do:
            ard_desc = ac_desc.
            display ard_desc with frame c.
         end.
      end.
      else do:   /*UPDATE*/

         /* UPDATE FOR TAX FIELDS */
         assign
            ard_taxc      = tax_class
            ard_tax_usage = tax_usage.
         if input ard_tax_at = no_char then
            ard_tax_at = no_char.
         if input ard_tax_at = yes_char then
            ard_tax_at = yes_char.

         if ard_tax_at = no_char then
            ard_tax_at = "no".         /* ENTERED AS Y/N, */
         if ard_tax_at = yes_char then /* STORE AS YES/NO */
            ard_tax_at = "yes".

         assign
            l_old_ard_amt  = ard_amt
            l_old_ard_desc = ard_desc.

      end.
      recno = recid(ard_det).
      ststatus = stline[2].
      status input ststatus.
      del-yn = no.

      /* IF TAX DISTRIBUTION RECORD, GIVE WARNING THAT THE */
      /* RECORD CANNOT BE UPDATED                          */
      if ard_tax = "t" then do:
         if lgData then do:
            {pxmsg.i &MSGNUM=931 &ERRORLEVEL=3}
            return.
         end.
         {pxmsg.i &MSGNUM=931 &ERRORLEVEL=2}
         next-prompt ard_acct with frame c.
         undo loopc, retry.
      end.

      /* If Logstics, set from table */
      if lgData then do:
         ard_amt = lgml_ard_amt.
      end.

      display ard_desc ard_amt.
      setb:
      do on error undo, retry:
         /* If not Logistics, process normally */
         if not lgData then do:
            set ard_desc ard_amt go-on (F5 CTRL-D).
            /* DELETE */
            if lastkey = keycode("F5")
               or lastkey = keycode("CTRL-D") then do:
               del-yn = yes.
               /*CONFIRM DELETE*/
               {pxmsg.i &MSGNUM=11 &ERRORLEVEL=1 &CONFIRM=del-yn}
               if not del-yn then undo setb.
            end.
         end.
         /* VALIDATE VALUE INPUT FOR ARD_AMT AGAINST RNDMTHD */
         if (input ard_amt <> 0)
         then do:
            {gprun.i ""gpcurval.p"" "(input input ard_amt,
                                      input rndmthd,
                                      output retval)"}
            if (retval <> 0)
            then do:
               if lgData then return.
               next-prompt ard_amt with frame c.
               undo setb, retry.
            end.
         end.
      end.

      /* BACK OUT GENERAL LEDGER TRANSACTIONS WHILE DELETING MEMO */
      /* OR WHILE MODIFYING MEMO TO CHANGE ONLY AMOUNT FOR AN     */
      /* EXISTING LINE. THIS IS DONE TO AVOID BACK OUT            */
      /* TRANSACTIONS BEING CREATED WHEN MEMO IS MODIFIED TO      */
      /* CHANGE ONLY DESCRIPTION.                                 */

      if del-yn or
         (not new ard_det and ard_amt <> l_old_ard_amt)
      then do:

         /* INCREMENT JOURNAL FOR FIRST CALL TO arargl.p */
         if jrnl = ""
         then do :
            /* GET NEXT JOURNAL REFERENCE NUMBER  */
            {mfnctrl.i arc_ctrl arc_jrnl glt_det glt_ref jrnl}
            release glt_det.
         end. /* IF jrnl = "" */

         assign
            curr_amt = - l_old_ard_amt.
         /* CONVERT INTO BASE HERE.*/
         run calc_base_amt in h_rules
            (- l_old_ard_amt,
            buffer ar_mstr,
            buffer gl_ctrl,
            output base_amt).

         assign
            ard_recno    = recid(ard_det)
            undo_all     = yes
            base_det_amt = base_amt.

         {gprun.i ""arargl.p""}
         if undo_all then undo mainloop, leave.

         /* BACK OUT MEMO TOTAL */
         run update_ar_amt in h_rules
            (- l_old_ard_amt,
            buffer ar_mstr).

         run update_ar_base_amt in h_rules
            (buffer ar_mstr).

         for first cm_mstr
               where cm_addr = ar_bill exclusive-lock:
         end. /* FOR FIRST cm_mstr ... */
         if available cm_mstr then
            run update_cm_balance in h_rules
               (base_amt,
               buffer ar_mstr,
               buffer cm_mstr).

         run update_ba_total in h_rules
            (- l_old_ard_amt,
            buffer ba_mstr).
      end. /* IF NOT NEW ard_det ... */

      if del-yn then do:
         delete ard_det.
         clear frame c.
         del-yn = no.

         /*DELETE TAX DISTRIBUTION RECORDS IF ALL TAXABLE LINES */
         if not can-find(first ard_det where
            ard_nbr = ar_nbr and ard_tax_at = "yes")
         then do:
            find first ard_det where ard_nbr = ar_nbr and
               ard_tax  = "t" no-lock no-error.
            if available ard_det then do:
               /*DELETE tx2d_det AND ARD_DET RECORDS, WRITE */
               /*REVERSING GL'S                             */
               {ardeltx.i &looplabel = deltax}

               /* DELETE tx2d_det RECORDS */
               tax_tr_type = "18".  /*DR/CR MEMOS*/
               tax_nbr     = "".    /*DON'T KNOW HOW TO USE YET*/
               {gprun.i ""txdelete.p"" "(input tax_tr_type,
                                         input ar_nbr,
                                         input tax_nbr)"}

            end.
         end.

         display ar_amt with frame b.
         next loopc.
      end.

      /* IF NEW ard_det RECORD CREATED OR IF ard_amt IS MODIFIED */
      /* UPDATE GL TRANSACTION FILE                              */

      if new ard_det or (not new ard_det and ard_amt <> l_old_ard_amt)
      then do:

         /* INCREMENT JOURNAL FOR FIRST CALL TO arargl.p */
         if jrnl = ""
         then do :
            /* GET NEXT JOURNAL REFERENCE NUMBER  */
            {mfnctrl.i arc_ctrl arc_jrnl glt_det glt_ref jrnl}
            release glt_det.
         end. /* IF jrnl = "" */

         curr_amt = ard_amt.
         run calc_base_amt in h_rules
            (ard_amt,
            buffer ar_mstr,
            buffer gl_ctrl,
            output base_amt).
         assign
            base_det_amt = base_amt
            ard_recno = recid(ard_det)
            undo_all = yes.
         {gprun.i ""arargl.p""}
         if undo_all then undo mainloop, leave.

         /* ASSIGN DAYBOOK ENTRY NUMBER */
         /* (GENERATED BY CREATION OF GL REFERENCE LINE 1) */
         ard_dy_num = nrm-seq-num.

         /* UPDATE MEMO TOTAL */

         run update_ar_amt in h_rules
            (ard_amt,
            buffer ar_mstr).

         run update_ar_base_amt in h_rules
            (buffer ar_mstr).

         find cm_mstr where cm_addr = ar_bill
            exclusive-lock.
         run update_cm_balance in h_rules
            (base_amt,
            buffer ar_mstr,
            buffer cm_mstr).

         run update_ba_total in h_rules
            (ard_amt,
            buffer ba_mstr).

      end. /* IF NEW ard_det ... */

      display ar_amt with frame b.

      /* IF ONLY DESCRIPTION MODIFIED THEN UPDATE ONLY glt_desc */
      if not new ard_det            and
         l_old_ard_desc <> ard_desc and
         l_old_ard_amt  =  ard_amt
      then do:
         /* RECREATE JOURNAL REFERENCE NUMBER */
         assign
            argl_ref = "AR"
            + substring(string(year(ar_effdate),"9999"),3,2)
            + string(month(ar_effdate),"99")
            + string(day(ar_effdate),"99")
            + string(integer(jrnl),"999999").

         /* FIND GL ENTRY FOR THE ABOVE REFERENCE (argl_ref) */
         for first glt_det
         where glt_ref     = argl_ref                and
               glt_entity  = ard_entity              and
               glt_acct    = ard_acct                and
               glt_sub     = ard_sub                 and
               glt_cc      = ard_cc                  and
               glt_project = ard_project             and
               glt_doc     = ar_nbr
               exclusive-lock:
         end. /* FOR FIRST glt_det ... */
         if available glt_det then
         assign
            glt_desc = ard_desc.
         release glt_det.
      end. /* IF NOT NEW ard_det ... */

       /* If Logsitics, set the next table */
      if lgData then do:
         find next lgml_lgdet no-error.
         /* If no more tables, then done. */
         if not available lgml_lgdet then leave loopc.
      end.

   end. /* loopc */

   do transaction:

      /* CHECK FOR EXISTING TAX LINES */
         if can-find(first ard_det where ard_nbr = ar_nbr
            and ard_tax_at = "yes")
         then do:
            recalc_tax = true.
            {gprun.i ""ardrmtb.p""}
            if undo_all then
               undo mainloop, leave.

            /*IF TAX INCLUDED = yes THEN REDUCE ar_amt, ar_sales_amt  */
            /*ard_amt, glt_amt, glt_curr_amt, gl_ecur_amt, cm_balance */
            /*ba_total BY TAX AMOUNTS                                 */

            else do:

               assign
                  taxin_tran_amt        = 0
                  tax_included          = 0
                  tot_tax_included      = 0
                  tot_tax_used          = 0
                  base_tax_included     = 0
                  base_tot_tax_included = 0
                  base_tot_tax_used     = 0.

               /* SELECT ALL TAX LINES FOR THIS MEMO */
               for each tx2d_det no-lock where tx2d_ref = ar_nbr
                     and tx2d_tr_type = "18"
                     break by tx2d_tax_code:

                  /* IF TAX INCLUDED IS YES */
                  if tx2d_tax_in = yes then do:

                     assign
                        tot_tax_included  = tot_tax_included +
                                            tx2d_cur_tax_amt
                        tax_included      = tax_included +
                                            tx2d_cur_tax_amt
                        taxin_tran_amt    = taxin_tran_amt +
                                            tx2d_totamt
                        base_tax_included = base_tax_included +
                                            tx2d_tax_amt
                        base_tot_tax_included = base_tot_tax_included +
                                                tx2d_tax_amt.

                     if last-of(tx2d_tax_code) then do:

                        assign
                           tot_tax_used      = 0
                           base_tot_tax_used = 0.

                        find tx2_mstr where
                           tx2_tax_code = tx2d_tax_code no-lock no-error.
                        /* PRO-RATE TAX AMONG ard_det's HAVING SAME */
                        /* TAX CLASS AND TAX USAGE                  */

                        for each ard_det exclusive-lock
                            where ard_nbr       = ar_nbr
                              and ard_tax       <> "T"
                              and ard_tax_at    = "yes"
                              and ard_taxc      = tx2_pt_taxc
                              and ard_tax_usage = tx2_tax_usage
                              break by ard_nbr:

                           tmpamt = ((ard_amt / taxin_tran_amt) * tax_included).

                           {gprunp.i "mcpl" "p" "mc-curr-rnd"
                              "(input-output tmpamt,
                                input gl_rnd_mthd,
                                output mc-error-number)"}
                           if mc-error-number <> 0 then do:
                              {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=3}.
                           end.

                           /* REDUCE ard_amt BY PRO-RATED TAX AMOUNT */

                           if last-of(ard_nbr)
                           then
                              /* ADJUST THE ROUNDING DIFFERENCE */
                              assign
                                 base_ard_amt = ard_amt
                                 ard_amt      = ard_amt
                                               - (tax_included - tot_tax_used)
                                 tmpamt       = base_ard_amt - ard_amt.
                           else
                              assign
                                 base_ard_amt = ard_amt
                                 ard_amt      = ard_amt - tmpamt.

                           tot_tax_used = tot_tax_used + tmpamt.

                           if ar_curr <> base_curr then do:

                              /* CONVERT FROM FOREIGN TO BASE CURRENCY */
                              {gprunp.i "mcpl" "p" "mc-curr-conv"
                                 "(input ar_curr,
                                   input base_curr,
                                   input ar_ex_rate,
                                   input ar_ex_rate2,
                                   input base_ard_amt,
                                   input true, /* ROUND */
                                   output base_ard_amt,
                                   output mc-error-number)"}.
                              if mc-error-number <> 0 then do:
                                 {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=3}.
                              end.

                              l_tmpamt = tmpamt.

                              /* CONVERT FROM FOREIGN TO BASE CURRENCY */
                              {gprunp.i "mcpl" "p" "mc-curr-conv"
                                 "(input ar_curr,
                                   input base_curr,
                                   input ar_ex_rate,
                                   input ar_ex_rate2,
                                   input tmpamt,
                                   input true, /* ROUND */
                                   output tmpamt,
                                   output mc-error-number)"}.
                              if mc-error-number <> 0 then do:
                                 {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=3}.
                              end.

                              /* REDUCE base_ard_amt BY PRO-RATED TAX */
                              /* AMOUNT IN BASE CURRENCY              */

                              if last-of(ard_nbr) then
                              /* ADJUST THE ROUNDING DIFFERENCE    */
                              assign base_ard_amt = base_ard_amt -
                                 (base_tax_included - base_tot_tax_used).
                              else
                              assign base_ard_amt = base_ard_amt - tmpamt.

                              base_tot_tax_used = base_tot_tax_used + tmpamt.
                           end. /* IF ar_curr <> base_curr */

                           /* RECREATE JOURNAL REFERENCE NUMBER */
                           argl_ref = "AR"
                              + substring(string(year(ar_effdate),"9999"),3,2)
                              + string(month(ar_effdate),"99")
                              + string(day(ar_effdate),"99")
                              + string(integer(jrnl),"999999").

                           for first arc_ctrl
                              fields (arc_sum_lvl)
                              no-lock:
                           end. /* FOR FIRST arc_ctrl */

                           /* FIND THE CORRECT glt_det SEPARATELY */
                           /* FOR DEBIT AND CREDIT AMOUNT         */
                           if ard_amt < 0
                           then
                              /* GL ENTRY FOR DEBIT MEMO */
                              /* WITH THIS ard_det       */
                              find first glt_det
                                 where glt_ref     = argl_ref
                                 and   glt_entity  = ard_entity
                                 and   glt_acct    = ard_acct
                                 and   glt_sub     = ard_sub
                                 and   glt_cc      = ard_cc
                                 and   glt_project = ard_project
                                 and   (  (glt_doc         =  ar_nbr
                                           and arc_sum_lvl <> 2)
                                       or (arc_sum_lvl     =  2))
                                 and   glt_amt      > 0
                              exclusive-lock no-error.
                           else
                              /* GL ENTRY FOR CREDIT MEMO */
                              /* WITH THIS ard_det        */
                              find first glt_det
                                 where glt_ref     = argl_ref
                                 and   glt_entity  = ard_entity
                                 and   glt_acct    = ard_acct
                                 and   glt_sub     = ard_sub
                                 and   glt_cc      = ard_cc
                                 and   glt_project = ard_project
                                 and   (   (glt_doc         =  ar_nbr
                                            and arc_sum_lvl <> 2)
                                         or (arc_sum_lvl    =  2))
                                 and   glt_amt     < 0
                              exclusive-lock no-error.

                           if available glt_det
                           then do:

                              assign
                                 l_gltcurramt = glt_curr_amt
                                 l_gltamt     = glt_amt.

                              if ar_curr <> base_curr
                              then do:
                                 assign
                                    glt_amt      = l_gltamt
                                                   + (base_ard_amt
                                                   + tmpamt)
                                                   - base_ard_amt
                                    glt_curr_amt = l_gltcurramt
                                                   + (ard_amt
                                                   + l_tmpamt)
                                                   - ard_amt.

                                 find first en_mstr where
                                    en_entity = glt_entity no-lock.

                                 if available en_mstr
                                 then
                                    if en_curr = base_curr
                                    then
                                       glt_ecur_amt = glt_amt.
                                 else
                                 if en_curr = ar_curr
                                 then
                                    glt_ecur_amt = glt_curr_amt.

                              end. /* IF ar_curr <> base_curr */
                              else
                                 /* THE FOLLOWING CALCULATION IS */
                                 /* DONE FOR ADJUSTING THE       */
                                 /* RE-ENTERED REFERENCE. tmpamt */
                                 /* STORES THE TAX AMOUNT FOR    */
                                 /* EVERY DISTRIBUTION LINE.     */

                                 assign
                                    glt_amt      = l_gltamt
                                                   + (ard_amt
                                                   + tmpamt)
                                                   - ard_amt
                                    glt_curr_amt = l_gltamt
                                                   + (ard_amt
                                                   + tmpamt)
                                                   - ard_amt.


                           end. /* IF AVAILABLE glt_det */

                        end. /* FOR EACH ard_det */

                        assign
                           taxin_tran_amt    = 0
                           tax_included      = 0
                           tot_tax_used      = 0
                           base_tax_included = 0
                           base_tot_tax_used = 0
                           base_ard_amt      = 0.

                     end. /* IF LAST-OF(tx2d_tax_code) */

                  end. /* IF tx2d_taxin = yes */

               end. /* FOR EACH tx2d_det */

               /* IF TAX INCLUDED = yes */
               if taxable_in then do:

                  /* REDUCE ar_amt by TOTAL TAX AMOUNT */
                  run update_ar_amt in h_rules
                     (- tot_tax_included,
                     buffer ar_mstr).
                  run update_ar_base_amt in h_rules
                     (buffer ar_mstr).

                  /* REDUCE CUSTOMER BALANCE BY TOTAL TAX AMOUNT */
                  find cm_mstr where cm_addr = ar_bill
                     exclusive-lock.
                  run update_cm_balance in h_rules
                     ( - base_tot_tax_included,
                     buffer ar_mstr,
                     buffer cm_mstr).

                  /* REDUCE BATCH TOTAL BY TOTAL TAX AMOUNT */
                  run update_ba_total in h_rules
                     (- tot_tax_included,
                     buffer ba_mstr).

                  if tot_tax_included <= ar_sales_amt then
                     ar_sales_amt = ar_sales_amt - tot_tax_included.
                  else
                     ar_sales_amt = 0.

                  /* FIND CORRECT GL ENTRY WITH DEBIT OR CREDIT */
                  /* AMOUNT FOR ar_mstr AND REDUCE IT BY SAME   */
                  /* ADJUSTMENT USED ON THE ar_mstr             */
                  if tot_tax_included > 0
                  then
                     find first glt_det
                        where glt_ref    = argl_ref
                        and   glt_entity = ar_entity
                        and   glt_acct   = ar_acct
                        and   glt_sub    = ar_sub
                        and   glt_cc     = ar_cc
                        and   glt_amt    > 0
                     exclusive-lock no-error.
                  else
                     find first glt_det
                        where glt_ref    = argl_ref
                        and   glt_entity = ar_entity
                        and   glt_acct   = ar_acct
                        and   glt_sub    = ar_sub
                        and   glt_cc     = ar_cc
                        and   glt_amt    < 0
                     exclusive-lock no-error.

                  if available glt_det then do:

                     if ar_curr <> base_curr then do:
                        assign glt_curr_amt = glt_curr_amt -
                           tot_tax_included
                           glt_amt      = glt_amt -
                           base_tot_tax_included.

                        find first en_mstr where en_entity =
                           glt_entity no-lock no-error.

                        if available en_mstr then
                           if en_curr = base_curr then
                              glt_ecur_amt = glt_amt.
                        else
                        if en_curr = ar_curr then
                           glt_ecur_amt = glt_curr_amt.

                     end. /* if ar_curr <> base_curr */
                     else
                     assign
                        glt_amt      = glt_amt -
                        base_tot_tax_included
                        glt_curr_amt = glt_curr_amt -
                        tot_tax_included.

                  end. /* IF AVAILABLE glt_det */

               end. /* IF taxable_in */
               leave mainloop.

            end. /* ELSE DO */
         end.
         else
            leave mainloop.
         {&ARDRMTA-P-TAG14}
         {&ARDRMTA-P-TAG15}
   end. /* do transaction */
end. /*mainloop*/
{&ARDRMTA-P-TAG6}

undo_header = false.
/* THERE IS NO RETURN FROM THIS PROGRAM WITH undo_header = true. */
hide frame c.
{&ARDRMTA-P-TAG7}

/* New procedure to read AR data from Logistics tables */
PROCEDURE SetLogData:
   define variable ext_tax as logical no-undo.
   /* Get the tax environment for this application */
   {gprunmo.i &module = "LG"
      &program = "lgtaxenv.p"
      &param = """(input ar_mstr.ar_app_owner, output ext_tax,
                   output ar_tax_env, output tax_class)"""}

   /* If external taxes are enabled, Setup the taxes */
   if ext_tax = yes then do:
      tax_usage = lgml_lgdet.lgml_ard_tax_usage.
      /* Display is required to put the value */
      /* into the 'input' variables used above. */
      if lgml_lgdet.lgml_ard_entity <> "" then
         display lgml_ard_entity @ ard_entity with frame c.
      display
         lgml_ard_acct @ ard_acct
         lgml_ard_sub @ ard_sub
         lgml_ard_cc @ ard_cc
         lgml_ard_project @ ard_project
         tax_class @ ard_taxc
      with frame c.
      /* Does line have an associated tax record? */
      /* Set tax_at if a tax line exists for this entry */
      for first lgmlx_lgdet where lgmlx_tx2d_line = lgml_tx2d_line
            no-lock:
      end.
      if available lgmlx_lgdet then
         display yes_char @ ard_tax_at with frame c.
      else
         display no_char @ ard_tax_at with frame c.
   end.
END PROCEDURE.
