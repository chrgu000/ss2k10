/* apbkrp.p - AP BANK REPORT                                              */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                    */
/* All rights reserved worldwide.  This is an unpublished work.           */
/* $Revision: 1.6.1.17 $                                                  */
/*V8:ConvertMode=Report                                                   */
/* REVISION: 7.4      LAST MODIFIED: 09/25/93   BY: JJS  *H157*           */
/*                                   02/01/94   BY: wep  *H116*           */
/*                                   05/22/95   BY: jzw  *H0DN*           */
/* REVISION: 8.5      LAST MODIFIED: 05/05/97   BY: rxm  *H0X5*           */
/* REVISION: 8.6      LAST MODIFIED: 10/16/97   BY: das  *K11P*           */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane         */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan        */
/* REVISION: 9.0      LAST MODIFIED: 03/10/99   BY: *M0B3* Michael Amaladhas */
/* REVISION: 9.0      LAST MODIFIED: 03/13/99   BY: *M0BD* Alfred Tan        */
/* REVISION: 9.1      LAST MODIFIED: 06/08/99   BY: *N00G* Jean Miller       */
/* REVISION: 9.1      LAST MODIFIED: 10/01/99   BY: *N014* Brian Compton     */
/* REVISION: 9.1      LAST MODIFIED: 01/10/00   BY: *N073* Reetu Kapoor      */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane  */
/* REVISION: 9.1      LAST MODIFIED: 05/05/00   BY: *N09X* Antony Babu       */
/* REVISION: 9.1      LAST MODIFIED: 08/11/00   BY: *N0KK* jyn               */
/* REVISION: 9.1      LAST MODIFIED: 09/22/00   BY: *N0W0* Mudit Mehta       */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* Revision: 1.6.1.10  BY: Ed van de Gevel    DATE: 11/05/01   ECO: *N15L*    */
/* Revision: 1.6.1.11  BY: Ed van de Gevel    DATE: 12/03/01   ECO: *N16R*    */
/* Revision: 1.6.1.12  BY: Vinod Nair         DATE: 01/29/02   ECO: *N18D*    */
/* Revision: 1.6.1.13  BY: Anitha Gopal       DATE: 03/08/02   ECO: *N1C6*    */
/* Revision: 1.6.1.14  BY: Katie Hilbert      DATE: 05/15/02   ECO: *P06N*  */
/* Revision: 1.6.1.15  BY: Orawan S. DATE: 04/17/03 ECO: *P0Q3* */
/* $Revision: 1.6.1.17 $ BY: Paul Donnelly (SB) DATE: 06/26/03 ECO: *Q00B* */
/*-Revision end---------------------------------------------------------------*/

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/* SS - 090216.1 By: Bill Jiang */

/* DISPLAY TITLE */
/*
{mfdtitle.i "2+ "}
*/
{mfdtitle.i "090216.1"}

/* SS - 090216.1 - B */
{xxapbkrp0001.i "new"}
/* SS - 090216.1 - E */
{cxcustom.i "APBKRP.P"}

define variable bk    like bk_code no-undo.
define variable bk1   like bk_code no-undo.
define variable name  like ad_sort no-undo.
define variable name1 like ad_sort no-undo.
define variable zip   like ad_zip.
define variable zip1  like ad_zip.

define variable titl as character format "x(132)".

form
   bk   colon 12    bk1   colon 46 label {t001.i}
   name colon 12    name1 colon 46 label {t001.i}
   zip  colon 12    zip1  colon 46 label {t001.i}
with frame a width 80 side-labels attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

form
   bk_code     colon 13     ad_date colon 65
   bk_desc     colon 13     ad_lang colon 65
   ad_sort     colon 13
   skip
   ad_line1    colon 13
   ad_line2    colon 13
   ad_line3    colon 13
   ad_city     colon 13     ad_state  ad_zip  ad_format
   ad_country  colon 13     ad_ctry no-label  ad_county colon 56
   skip(1)
   ad_attn   colon 13          ad_attn2  label "[2]" colon 50
   ad_phone  colon 13 ad_ext   ad_phone2 label "[2]" colon 50 ad_ext2
   ad_fax    colon 13          ad_fax2   label "[2]" colon 50
with frame b side-labels width 132
   title color normal titl.

/* SET EXTERNAL LABELS */
setFrameLabels(frame b:handle).

/* CHANGED THE COLON POSITION TO 27 FROM 25 AND 82 FROM 80 TO    */
/* MAKE IT CONSISTENT WITH THE POSITION OF THE FIELDS IN FRAME E */

{&APBKRP-P-TAG5}
{&APBKRP-P-TAG1}
form
   bk_check        colon 27  format "999999"
   bk_entity       colon 82
   bk_bk_acct1     colon 27  label "Bk Acct 1" format "x(24)"
   bk_acct         colon 82  bk_sub      no-label bk_cc     no-label
   bk_bk_acct2     colon 27  label "Bk Acct 2" format "x(24)"
   bk_pip_acct     colon 82  bk_pip_sub  no-label bk_pip_cc no-label
   bk_curr         colon 27
with frame c side-labels width 132
   title color normal (getFrameTitle("CHECKING_ACCOUNTS",25)).
{&APBKRP-P-TAG2}
{&APBKRP-P-TAG6}

/* SET EXTERNAL LABELS */
setFrameLabels(frame c:handle).

/* DISPLAY DRAFT ACCOUNTS FORM */

/* CHANGED THE COLON POSITION TO 27 FROM 25 AND 82 FROM 80 TO    */
/* MAKE IT CONSISTENT WITH THE POSITION OF THE FIELDS IN FRAME E */

form
   bk_dftar_acct   colon 27 bk_dftar_sub no-label bk_dftar_cc
   no-label
   bk_dftap_acct   colon 82 bk_dftap_sub no-label bk_dftap_cc no-label
   bk_bkchg_acct   colon 27 bk_bkchg_sub no-label bk_bkchg_cc no-label
   bk_bktx_acct    colon 82 bk_bktx_sub  no-label bk_bktx_cc  no-label
   bk_disc_acct    colon 27 bk_disc_sub  no-label bk_disc_cc  no-label
   bk_cdft_acct    colon 82 bk_cdft_sub  no-label bk_cdft_cc  no-label
   bk_ddft_acct    colon 27 bk_ddft_sub  no-label bk_ddft_cc  no-label
   bk_edft_acct    colon 82 bk_edft_sub  no-label bk_edft_cc  no-label
with frame d side-labels width 132
   title color normal (getFrameTitle("DRAFT_ACCOUNTS",21)).

/* SET EXTERNAL LABELS */
setFrameLabels(frame d:handle).

form
   ad_gst_id      colon 27
   ad_pst_id      colon 27
   ad_vat_reg     colon 27
with frame e side-labels width 132
title color normal (getFrameTitle("TAX_IDS",23)).

/* SET EXTERNAL LABELS */
setFrameLabels(frame e:handle).

{&APBKRP-P-TAG3}
titl = dynamic-function('getTermLabelFillCentered' in h-label,
   input "BANK_ADDRESS",
   input 132,
   input "=").

define temp-table tt_admstr like ad_mstr.

{wbrp01.i}

mainloop:
repeat:

   if bk1 = hi_char then bk1 = "".
   if name1 = hi_char then name1 = "".
   if zip1 = hi_char then zip1 = "".

   if c-application-mode <> "WEB" then
      update
         bk bk1
         name name1
         zip zip1
      with frame a.

   {wbrp06.i &command = update
             &fields = "  bk bk1 name name1 zip zip1"
             &frm = "a"}

   if (c-application-mode <> "WEB") or
      (c-application-mode = "WEB" and
      (c-web-request begins "DATA"))
   then do:

      bcdparm = "".
      {mfquoter.i bk     }
      {mfquoter.i bk1    }
      {mfquoter.i name   }
      {mfquoter.i name1  }
      {mfquoter.i zip    }
      {mfquoter.i zip1   }

      if bk1 = "" then bk1 = hi_char.
      if name1 = "" then name1 = hi_char.
      if zip1 = "" then zip1 = hi_char.
   end.

   /* SELECT OUTPUT DEVICE - CAN BE BATCHED */

   /* OUTPUT DESTINATION SELECTION */
   {gpselout.i &printType = "printer"
      &printWidth = 132
      &pagedFlag = " "
      &stream = " "
      &appendToFile = " "
      &streamedOutputToTerminal = " "
      &withBatchOption = "yes"
      &displayStatementType = 1
      &withCancelMessage = "yes"
      &pageBottomMargin = 6
      &withEmail = "yes"
      &withWinprint = "yes"
      &defineVariables = "yes"}

   /* SS - 090216.1 - B */
   /*
   {mfphead.i}

   /* AD_MSTR IS USED INSTEAD OF BK_MSTR BECAUSE  */
   /* IT CONTAINS THE FIELD ad_sort WHICH BK_MSTR */
   /* DOES NOT                                    */

   /* CLEAN-UP TEMP-TABLE */
   for each tt_admstr
       where ad_domain = global_domain exclusive-lock:
      delete 
   end. /* FOR EACH tt_admstr */

   for each ad_mstr
       where ad_mstr.ad_domain = global_domain and  ad_type  = "our_bank"
      and   ad_addr >= bk
      and   ad_addr <= bk1
      and   ad_sort >= name
      and   ad_sort <= name1
      and   ad_zip  >= zip
      and   ad_zip  <= zip1
      use-index ad_type
      no-lock:

      buffer-copy ad_mstr
      to 
      ad_domain = global_domain.

   end. /* FOR EACH ad_mstr */

   for each bk_mstr
       where bk_mstr.bk_domain = global_domain and  bk_code >= bk
      and   bk_code <= bk1
      no-lock:

      for first tt_admstr
          where ad_domain = global_domain and  ad_addr =
          bk_code
         no-lock:
      end. /* FOR FIRST tt_admstr */

      if not available tt_admstr
      then do:
         for first ad_mstr
             where ad_mstr.ad_domain = global_domain and  ad_mstr.ad_addr  =
             bk_code
            and   ad_mstr.ad_sort >= name
            and   ad_mstr.ad_sort <= name1
            and   ad_mstr.ad_zip  >= zip
            and   ad_mstr.ad_zip  <= zip1
            no-lock:

            buffer-copy ad_mstr
            to 
            ad_domain = global_domain.

         end. /* FOR FIRST ad_mstr */
      end. /* IF NOT AVAILABLE tt_admstr */

   end. /* FOR EACH bk_mstr */

   for each tt_admstr
      use-index ad_sort
       where ad_domain = global_domain no-lock:

      find bk_mstr  where bk_mstr.bk_domain = global_domain and  bk_code =
      ad_addr
         no-lock no-error.

      if available bk_mstr
      then do:

         display
            bk_code
            bk_desc
            ad_sort    @ ad_mstr.ad_sort
            ad_date    @ ad_mstr.ad_date
            ad_lang    @ ad_mstr.ad_lang
            ad_line1   @ ad_mstr.ad_line1
            ad_line2   @ ad_mstr.ad_line2
            ad_line3   @ ad_mstr.ad_line3
            ad_city    @ ad_mstr.ad_city
            ad_state   @ ad_mstr.ad_state
            ad_zip     @ ad_mstr.ad_zip
            ad_format  @ ad_mstr.ad_format
            ad_country @ ad_mstr.ad_country
            ad_ctry    @ ad_mstr.ad_ctry
            ad_county  @ ad_mstr.ad_county
            ad_attn    @ ad_mstr.ad_attn
            ad_attn2   @ ad_mstr.ad_attn2
            ad_phone   @ ad_mstr.ad_phone
            ad_ext     @ ad_mstr.ad_ext
            ad_phone2  @ ad_mstr.ad_phone2
            ad_ext2    @ ad_mstr.ad_ext2
            ad_fax     @ ad_mstr.ad_fax
            ad_fax2    @ ad_mstr.ad_fax2
         with frame b.

         display
            bk_check
            bk_entity
            bk_curr
            bk_bk_acct1
            bk_acct
            bk_sub
            bk_cc
            bk_bk_acct2
            bk_pip_acct
            bk_pip_sub
            bk_pip_cc
            {&APBKRP-P-TAG7}
         with frame c.

         display
            bk_dftar_acct
            bk_dftar_sub
            bk_dftar_cc
            bk_dftap_acct
            bk_dftap_sub
            bk_dftap_cc
            bk_bkchg_acct
            bk_bkchg_sub
            bk_bkchg_cc
            bk_bktx_acct
            bk_bktx_sub
            bk_bktx_cc
            bk_disc_acct
            bk_disc_sub
            bk_disc_cc
            bk_cdft_acct
            bk_cdft_sub
            bk_cdft_cc
            bk_ddft_acct
            bk_ddft_sub
            bk_ddft_cc
            bk_edft_acct
            bk_edft_sub
            bk_edft_cc
         with frame d.

         display
            ad_gst_id    @ ad_mstr.ad_gst_id
            ad_pst_id    @ ad_mstr.ad_pst_id
            ad_vat_reg   @ ad_mstr.ad_vat_reg
         with frame e.

      end. /* IF AVAILABLE bk_mstr */

      {&APBKRP-P-TAG4}
      /* EXIT IF F4 IS PRESSED OR MAXIMUM PAGE OR LINE IS REACHED */
      {mfrpchk.i}

   end.  /* FOR EACH tt_admstr */

   /* RESET OUTPUT DEVICE */

   {mfrtrail.i}
   */
   PUT UNFORMATTED "BEGIN: " + STRING(TIME, "HH:MM:SS") SKIP.

   EMPTY TEMP-TABLE ttxxapbkrp0001.
   {gprun.i ""xxapbkrp0001.p"" "(
      input bk,
      input bk1,
      input NAME,
      input name1,
      input zip,
      input zip1
      )"}
   EXPORT DELIMITER ";" "bk_code" "bk_desc" "ad_sort" "ad_date" "ad_lang" "ad_line1" "ad_line2" "ad_line3" "ad_city" "ad_state" "ad_zip" "ad_format" "ad_country" "ad_ctry" "ad_county" "ad_attn" "ad_attn2" "ad_phone" "ad_ext" "ad_phone2" "ad_ext2" "ad_fax" "ad_fax2" "bk_check" "bk_entity" "bk_curr" "bk_bk_acct1" "bk_acct" "bk_sub" "bk_cc" "bk_bk_acct2" "bk_pip_acct" "bk_pip_sub" "bk_pip_cc" "bk_dftar_acct" "bk_dftar_sub" "bk_dftar_cc" "bk_dftap_acct" "bk_dftap_sub" "bk_dftap_cc" "bk_bkchg_acct" "bk_bkchg_sub" "bk_bkchg_cc" "bk_bktx_acct" "bk_bktx_sub" "bk_bktx_cc" "bk_disc_acct" "bk_disc_sub" "bk_disc_cc" "bk_cdft_acct" "bk_cdft_sub" "bk_cdft_cc" "bk_ddft_acct" "bk_ddft_sub" "bk_ddft_cc" "bk_edft_acct" "bk_edft_sub" "bk_edft_cc" "ad_gst_id" "ad_pst_id" "ad_vat_reg".
   FOR EACH ttxxapbkrp0001:
      EXPORT DELIMITER ";" ttxxapbkrp0001.
   END.

   PUT UNFORMATTED "END: " + STRING(TIME, "HH:MM:SS") SKIP.

   /* REPORT TRAILER  */
   {xxmfrtrail.i}
   /* SS - 090216.1 - E */

end.  /* MAINLOOP */

{wbrp04.i &frame-spec = a}
