/* GUI CONVERTED from adcsrp01.p (converter v1.71) Tue Oct  6 14:15:28 1998 */
/* adcsrp01.p - CUSTOMER MASTER REPORT                                  */
/* COPYRIGHT qad.inc. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK. */
/* web convert adcsrp01.p (converter v1.00) Fri Oct 10 13:57:05 1997 */
/* web tag in adcsrp01.p (converter v1.00) Mon Oct 06 14:17:21 1997 */
/*F0PN*/ /*K12B*/ /*V8#ConvertMode=WebReport                            */
/*V8:ConvertMode=FullGUIReport                                 */
/* REVISION: 1.0      LAST MODIFIED: 09/16/86   BY: PML  13             */
/* REVISION: 6.0      LAST MODIFIED: 03/08/90   BY: pml *D001*          */
/* REVISION: 6.0      LAST MODIFIED: 12/13/90   BY: dld *D257*          */
/* REVISION: 6.0      LAST MODIFIED: 07/16/91   BY: afs *D776*          */
/* REVISION: 7.0      LAST MODIFIED: 11/22/91   BY: afs *F056*          */
/* REVISION: 7.4      LAST MODIFIED: 08/25/93   BY: tjs *H082*          */
/* REVISION: 7.4      LAST MODIFIED: 10/15/93   BY: jjs *H181*          */
/* REVISION: 7.4      LAST MODIFIED: 10/18/93   BY: cdt *H086*          */
/* REVISION: 7.4      LAST MODIFIED: 11/30/93   BY: tjs *H081*          */
/*           7.2                     08/30/94   BY: bcm *FQ43*          */
/* REVISION: 8.5      LAST MODIFIED: 07/07/95   BY: cdt *J057*          */
/* REVISION: 8.5      LAST MODIFIED: 11/01/96   BY: *H0NT* Suresh Nayak */
/* REVISION: 8.6      LAST MODIFIED: 03/17/97   BY: *K07Z* Arul Victoria */
/* REVISION: 8.6      LAST MODIFIED: 10/16/97   BY: gyk *K12B*           */
/* REVISION: 8.6      LAST MODIFIED: 10/29/97   BY: *H1G4* Manish K.     */

/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan    */

/*GUI global preprocessor directive settings */
&GLOBAL-DEFINE PP_PGM_RP TRUE
&GLOBAL-DEFINE PP_ENV_GUI TRUE


/*GUI preprocessor directive settings */
&SCOPED-DEFINE PP_GUI_CONVERT_MODE REPORT

{mfdtitle.i "e+ "}

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE adcsrp01_p_1 " 企业物料转移数据 "
/* MaxLen: Comment: */

&SCOPED-DEFINE adcsrp01_p_2 " 银行帐户数据 "
/* MaxLen: Comment: */

&SCOPED-DEFINE adcsrp01_p_3 " 客户数据 "
/* MaxLen: Comment: */

&SCOPED-DEFINE adcsrp01_p_4 " 客户资信数据 "
/* MaxLen: Comment: */

&SCOPED-DEFINE adcsrp01_p_5 " 客户运费数据 "
/* MaxLen: Comment: */

&SCOPED-DEFINE adcsrp01_p_6 " 客户地址 "
/* MaxLen: Comment: */

&SCOPED-DEFINE adcsrp01_p_7 "推销员[1]"
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */

/*J057**
       * /* DEFINE csbd_det WORKFILE - REMOVE WHEN DATABASE UPDATED */
       * {adcsbdef.i "new shared"} */

define variable code like cm_addr.
define variable code1 like cm_addr.
define variable name like ad_name.
define variable name1 like ad_name.
define variable zip like ad_zip.
define variable zip1 like ad_zip.
define variable type like cm_type.
define variable type1 like cm_type.
define variable region like cm_region.
define variable region1 like cm_region.
define variable slspsn like sp_addr.
define variable slspsn1 like slspsn.
define variable under as character format "x(78)".
/*H181*/ define variable bk_acct_type like csbd_type.
/*H181*/ define variable bk_acct_type_desc like glt_desc.
/*H181*/ define variable bk_acct_type_code like csbd_type.
/*H1G4*/ define variable ec_ok like mfc_logical no-undo.

/*H1G4*/ /* CHECK IF INTRA-EC IS INSTALLED */
/*H1G4*/ {gprun.i ""txecck.p"" "(output ec_ok)"}


/*GUI preprocessor Frame A define */
&SCOPED-DEFINE PP_FRAME_NAME A

FORM /*GUI*/ 
   
 RECT-FRAME       AT ROW 1.4 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1   COLUMN 3 NO-LABEL
 SKIP(.1)  /*GUI*/
code           colon 15
   code1          label {t001.i} colon 49 skip
   name           colon 15
   name1          label {t001.i} colon 49 skip
   zip            colon 15
   zip1           label {t001.i} colon 49 skip
   type           colon 15
   type1          label {t001.i} colon 49 skip
   region         colon 15
   region1        label {t001.i} colon 49 skip
   slspsn         colon 15
   slspsn1        label {t001.i} colon 49 skip
 SKIP(.4)  /*GUI*/
with frame a side-labels /*FQ43*/ width 80 NO-BOX THREE-D /*GUI*/.

 DEFINE VARIABLE F-a-title AS CHARACTER.
 F-a-title = &IF (DEFINED(SELECTION_CRITERIA) = 0)
  &THEN " 选择条件 "
  &ELSE {&SELECTION_CRITERIA}
  &ENDIF .
 RECT-FRAME-LABEL:SCREEN-VALUE in frame a = F-a-title.
 RECT-FRAME-LABEL:WIDTH-PIXELS in frame a =
  FONT-TABLE:GET-TEXT-WIDTH-PIXELS(
  RECT-FRAME-LABEL:SCREEN-VALUE in frame a + " ", RECT-FRAME-LABEL:FONT).
 RECT-FRAME:HEIGHT-PIXELS in frame a =
  FRAME a:HEIGHT-PIXELS - RECT-FRAME:Y in frame a - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME a = FRAME a:WIDTH-CHARS - .5. /*GUI*/

/*GUI preprocessor Frame A undefine */
&UNDEFINE PP_FRAME_NAME



/*H181*/ FORM /*GUI*/ 
        csbd_bank
        bk_acct_type
        csbd_edi
        csbd_branch
        csbd_bk_acct
        csbd_beg_date
        csbd_end_date
     with STREAM-IO /*GUI*/  down frame csbd width 80
     title color normal {&adcsrp01_p_2}.

under = fill("=",30) + {&adcsrp01_p_6} + fill("=",30).

/*J057****** REMOVED WHEN csbd_det WAS ADDED TO THE DATABASE ***************
/*H181*/ /* BUILD csbd_det WORKFILES - DELETE WHEN DATABASE UPDATED */     *
     /* * BUILDS FILES FOR ALL EXISTING CUSTOMER/SUPPLIER BANKS */     *
     /* r INDICATES THAT THE FILES ARE TO BE BUILT              */     *
     /* ? RECID IS BLANK (USED ONLY IF DELETING)                */     *
            {gprun.i ""adcsbsrv.p"" "(input ""*"",                 *
                        input ""r"",                   *
                       input ?)"}                      *
 *J057*/


/*K12B*/ {wbrp01.i}

/*GUI*/ {mfguirpa.i true  "printer" 80 }

/*GUI repeat : */
/*GUI*/ procedure p-enable-ui:

   if code1 = hi_char then code1 = "".
   if name1 = hi_char then name1 = "".
   if type1 = hi_char then type1 = "".
   if zip1 = hi_char then zip1 = "".
   if region1 = hi_char then region1 = "".
   if slspsn1 = hi_char then slspsn1 = "".


/*K12B*/ if c-application-mode <> 'web':u then
         
run p-action-fields (input "display").
run p-action-fields (input "enable").
end procedure. /* p-enable-ui, replacement of Data-Entry GUI*/

/*GUI*/ procedure p-report-quote:


/*K12B*/ {wbrp06.i &command = update &fields = "  code code1 name name1 zip zip1
type type1 region region1 slspsn slspsn1" &frm = "a"}

/*K12B*/ if (c-application-mode <> 'web':u) or
/*K12B*/ (c-application-mode = 'web':u and
/*K12B*/ (c-web-request begins 'data':u)) then do:


   bcdparm = "".
   {mfquoter.i code      }
   {mfquoter.i code1     }
   {mfquoter.i name      }
   {mfquoter.i name1     }
   {mfquoter.i zip       }
   {mfquoter.i zip1      }
   {mfquoter.i type      }
   {mfquoter.i type1     }
   {mfquoter.i region    }
   {mfquoter.i region1   }
   {mfquoter.i slspsn    }
   {mfquoter.i slspsn1   }

   if code1 = "" then code1 = hi_char.
   if name1 = "" then name1 = hi_char.
   if type1 = "" then type1 = hi_char.
   if zip1 = "" then zip1 = hi_char.
   if region1 = "" then region1 = hi_char.
   if slspsn1 = "" then slspsn1 = hi_char.


/*K12B*/ end.
      /* Select printer */
      
/*GUI*/ end procedure. /* p-report-quote */
/*GUI - Field Trigger Section */

/*GUI MFSELxxx removed*/
/*GUI*/ procedure p-report:
/*GUI*/   {gpprtrpa.i  "printer" 80}
/*GUI*/   mainloop: do on error undo, return error on endkey undo, return error:




      {mfphead2.i}


   for each cm_mstr
    where (cm_addr >= code and cm_addr <= code1)
      and (cm_sort >= name and cm_sort <= name1)
      and (cm_type >= type and cm_type <= type1)
      and (cm_region >= region and cm_region <= region1)
      and (cm_slspsn[1] >= slspsn and cm_slspsn[1] <= slspsn1)
/*wl*/   no-lock by cm_addr by sort:

      find ad_mstr where ad_addr = cm_addr no-lock.
      if (ad_zip >= zip and ad_zip <= zip1) then do:

/* DISPLAY SELECTION FORM */
FORM /*GUI*/ 
   skip
   cm_addr        colon 10
   ad_name        colon 10
   ad_line1       colon 10
   ad_line2       colon 10
   ad_line3       colon 10
   ad_city        colon 10
   ad_state
   ad_zip         colon 56
   ad_country     colon 10
/*H1G4*/ ad_ctry  colon 42 no-label
   ad_county      colon 56
   ad_attn        colon 10
   ad_attn2       label "[2]" colon 43
   ad_phone       colon 10
   ad_ext
   ad_phone2      label "[2]" colon 43
   ad_ext2
   ad_fax         colon 10
   ad_fax2        label "[2]" colon 43
   ad_date
   with STREAM-IO /*GUI*/  frame a1 title color normal under side-labels width 80
attr-space.

FORM /*GUI*/ 
     cm_sort        colon 10
     cm_type        colon 48
     cm_taxable     colon 68
     cm_taxc        no-label
     cm_slspsn[1]   colon 10 label {&adcsrp01_p_7}
     cm_slspsn[2]   colon 26 label "[2]"
     cm_region      colon 48
/*H086*/ cm_pr_list2    colon 68
/*H086*  cm_pr_list     colon 68 */

     cm_shipvia     colon 10
     cm_curr        colon 48
/*H086*/ cm_pr_list     colon 68
/*H086*  cm_fix_pr      colon 68 */
/*H082*  cm_partial     colon 68 */

     cm_ar_acct     colon 10
     cm_ar_cc       no-label
     cm_lang        colon 48
/*H086*/ cm_fix_pr      colon 68
/*H086*  cm_partial     colon 68 */
/*H082*  cm_class       colon 68 */

     cm_resale      colon 10
     cm_site        colon 48
/*H082*/ cm_class       colon 68

     cm_rmks        colon 10
/*H086*/ cm_partial     colon 68
with STREAM-IO /*GUI*/  frame b title color normal {&adcsrp01_p_3} side-labels width 80
attr-space.

FORM /*GUI*/ 
   cm_cr_limit    colon 15
   cm_disc_pct    colon 41
   cm_bill        colon 61

   cm_cr_terms    colon 15
   cm_fin         colon 41
   cm_high_cr     colon 61

   cm_cr_hold     colon 15
   cm_stmt        colon 41
   cm_high_date   colon 61

   cm_cr_rating   colon 15
   cm_stmt_cyc    colon 41
   cm_sale_date   colon 61

   cm_db          colon 15
   cm_dun         colon 41
   cm_pay_date    colon 61

/*H081*/ cm_cr_review   colon 61
/*H081*/ cm_cr_update   colon 61

/*H181   ad_bk_acct1    colon 15 */
/*H181   ad_bk_acct2    colon 41 label "[2]" */
with STREAM-IO /*GUI*/  frame c title color normal {&adcsrp01_p_4} side-labels width 80
attr-space.

/*H081*/ FORM /*GUI*/ 
/*H081*/    cm_fr_list    colon 15
/*H081*/    cm_fr_min_wt  colon 15
/*H081*/    fr_um         no-label
/*H081*/    cm_fr_terms   colon 15
/*H081*/ with STREAM-IO /*GUI*/  frame d title color normal {&adcsrp01_p_5} side-labels
/*H081*/ width 80 attr-space.

/*K07Z*/ FORM /*GUI*/ 
/*K07Z*/    cm_btb_type    colon 20
/*K07Z*/    cm_ship_lt     colon 55
/*K07Z*/    cm_btb_mthd    colon 20
/*K07Z*/    cm_btb_cr      colon 55
/*K07Z*/ with STREAM-IO /*GUI*/  frame e title color normal {&adcsrp01_p_1}
/*K07Z*/ side-labels width 80 attr-space.

      display cm_addr ad_name ad_line1 ad_line2 ad_line3 ad_city
      ad_state ad_zip ad_country
/*H1G4*/ ad_ctry when ( {txnew.i} or ec_ok )
      ad_county
      ad_attn ad_phone ad_ext ad_attn2 ad_phone2 ad_ext2
      ad_fax ad_fax2 ad_date with frame a1 STREAM-IO /*GUI*/ .

      display cm_sort cm_type cm_region cm_slspsn[1]
      cm_slspsn[2]
      cm_ar_acct cm_ar_cc cm_resale cm_shipvia cm_rmks
/*H0NT** cm_pr_list cm_taxable cm_taxc cm_partial cm_curr cm_lang   */
/*H0NT*/ cm_pr_list
/*H0NT*/ cm_taxable  when (not {txnew.i})
/*H0NT*/ cm_taxc     when (not {txnew.i})
/*H0NT*/ cm_partial cm_curr cm_lang
/*H082*/ cm_fix_pr
/*H086*/ cm_pr_list2
      cm_class cm_site
      with frame b STREAM-IO /*GUI*/ .

/*H0NT*/ if {txnew.i} then
/*H0NT*/    display ad_taxable @ cm_taxable
/*H0NT*/            ad_taxc    @ cm_taxc
/*H0NT*/    with frame b STREAM-IO /*GUI*/ .

      display cm_cr_limit cm_fin cm_high_cr cm_cr_terms cm_dun
      cm_stmt cm_stmt_cyc  cm_disc_pct cm_bill
      cm_high_date cm_db cm_cr_rating cm_pay_date cm_cr_hold
/*H081*/ cm_cr_review cm_cr_update
      cm_sale_date
/*H181* ad_bk_acct1 ad_bk_acct2 */
      with frame c STREAM-IO /*GUI*/ .

/*H081*/ find fr_mstr where fr_list = cm_fr_list
/*H081*/                and fr_site = cm_site
/*H081*/                and fr_curr = cm_curr
/*H081*/ no-lock no-error.
/*H081*/ display cm_fr_list cm_fr_min_wt
/*H081*/ fr_um when (available fr_mstr)
/*H081*/ cm_fr_terms with frame d STREAM-IO /*GUI*/ .


/*K07Z*/ display cm_btb_type cm_ship_lt cm_btb_mthd cm_btb_cr
/*K07Z*/ with frame e STREAM-IO /*GUI*/ .

/*H181 ADDED FOLLOWING SECTION */
      /*DISPLAY ALL BANK ACCOUNTS FOR CUSTOMER */
      for each csbd_det where csbd_addr = cm_addr no-lock:
     /* GET MNEMONIC FOR ACCOUNT TYPE FROM lngd_det */
     {gplngn2a.i &file     = ""csbd_det""
             &field    = ""bk_acct_type""
             &code     = csbd_type
             &mnemonic = bk_acct_type
             &label    = bk_acct_type_desc}

     display csbd_bank
         bk_acct_type
         csbd_edi
         csbd_branch
         csbd_bk_acct
         csbd_beg_date
         csbd_end_date when (csbd_end_date <> hi_date)
         "" when (csbd_end_date = hi_date) @ csbd_end_date
     with frame csbd STREAM-IO /*GUI*/ .
     down 1 with frame csbd.

     /* ALLOW USER TO EXIT IF F4 PRESSED OR MAX LINE/PAGE REACHED */
     
/*GUI*/ {mfguirex.i } /*Replace mfrpexit*/

      end.
/*H181 END OF SECTION */

      
/*GUI*/ {mfguirex.i } /*Replace mfrpexit*/

   end.
end.
   /* REPORT TRAILER  */

   
/*GUI*/ {mfguitrl.i} /*Replace mfrtrail*/

/*GUI*/ {mfgrptrm.i} /*Report-to-Window*/


end.

/*K12B*/ {wbrp04.i &frame-spec = a}

/*GUI*/ end procedure. /*p-report*/
/*GUI*/ {mfguirpb.i &flds=" code code1 name name1 zip zip1 type type1 region region1 slspsn slspsn1 "} /*Drive the Report*/
