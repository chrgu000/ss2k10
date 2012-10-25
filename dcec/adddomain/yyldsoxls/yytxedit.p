/* GUI CONVERTED from txedit.p (converter v1.78) Thu Aug 13 04:23:57 2009 */
/* txedit.p - qad DISPLAY / EDIT TAX DETAIL                                */
/* Copyright 1986-2009 QAD Inc., Santa Barbara, CA, USA.                   */
/* All rights reserved worldwide.  This is an unpublished work.            */
/* Revision: 7.3      CREATED:       01/05/92   By: bcm              *G413**/
/* Revision: 7.4      LAST MODIFIED: 07/13/93   By: bcm              *H028**/
/*                                   09/29/93   By: bcm              *H143**/
/*                                   11/05/93   By: bcm              *H212**/
/*                                   03/17/94   By: bcm              *H296**/
/*                                   03/30/94   By: bcm              *H307**/
/*                                   04/13/94   By: bcm              *H339**/
/*                                   08/31/94   By: bcm              *H498**/
/*                                   09/08/94   By: bcm              *H509**/
/*                                   12/02/94   By: bcm              *H606**/
/*                                   02/23/95   By: jzw              *H0BM**/
/*                                   03/27/95   By: tvo              *H0BJ**/
/*                                   11/16/95   By: ais              *H0H4**/
/* Revision: 8.5      LAST MODIFIED: 11/14/95   By: taf              *J053**/
/* Revision: 8.5      LAST MODIFIED: 07/17/96   By: smp              *J0WF**/
/* Revision: 8.6      LAST MODIFIED: 11/25/96   By: jzw              *K01X**/
/* Revision: 8.6      LAST MODIFIED: 01/13/97   By: rxm              *H0Q1**/
/* Revision: 8.6      LAST MODIFIED: 03/31/97   By: rxm              *J1M9**/
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane       */
/* REVISION: 8.6E     LAST MODIFIED: 05/09/98   BY: *L00Y* Jeff Wootton    */
/* REVISION: 8.6E     LAST MODIFIED: 07/31/98   BY: *L049* Jim Josey       */
/* REVISION: 9.0      LAST MODIFIED: 10/01/98   BY: *J2CZ* Reetu Kapoor    */
/* REVISION: 9.0      LAST MODIFIED: 03/13/99   BY: *M0BD* Alfred Tan      */
/* REVISION: 9.1      LAST MODIFIED: 01/03/00   BY: *L0NV* Vihang Talwalkar */
/* REVISION: 9.1      LAST MODIFIED: 02/24/00   BY: *M0K0* Ranjit Jain      */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane */
/* REVISION: 9.1      LAST MODIFIED: 05/08/00   BY: *J3P2* Manish K.        */
/* REVISION: 9.1      LAST MODIFIED: 03/07/00   BY: *N0F3* Rajinder Kamra   */
/* REVISION: 9.1      LAST MODIFIED: 04/26/00   BY: *N059* Larry Leeth      */
/* REVISION: 9.1      LAST MODIFIED: 09/07/00   BY: *L138* Jose Alex        */
/* REVISION: 9.1        BY: Larry Leeth       DATE: 10/06/00  ECO: *N0RP*   */
/* REVISION: 9.1      LAST MODIFIED: 10/24/00   BY: *J3Q5* Kaustubh K.      */
/* REVISION: 9.1      LAST MODIFIED: 11/03/00   BY: *M0VT* Veena Lad        */
/* REVISION: 9.1      LAST MODIFIED: 11/27/00   BY: *L12B* Santosh Rao      */
/* Revision: 1.32     BY: Murali Ayyagari    DATE: 11/06/00  ECO: *N0V1*    */
/* REVISION: 9.1      LAST MODIFIED: 11/28/00   BY: *N0W4* BalbeerS Rajput  */
/* Old ECO marker removed, but no ECO header exists *F0PN*                  */
/* Revision: 1.35       BY: Rajaneesh S.         DATE: 05/05/01 ECO: *M16G* */
/* Revision: 1.36       BY: Niranjan R.          DATE: 03/15/02 ECO: *P020* */
/* Revision: 1.38       BY: Deirdre O'Brien      DATE: 10/21/02 ECO: *N13P* */
/* Revision: 1.39       BY: Katie Hilbert        DATE: 12/31/02 ECO: *P0LM* */
/* Revision: 1.41       BY: Paul Donnelly (SB)   DATE: 06/28/03 ECO: *Q00M* */
/* Revision: 1.42       BY: Rajaneesh S.         DATE: 01/06/04 ECO: *P1GK* */
/* Revision: 1.43       BY: Prashant Parab       DATE: 02/02/04 ECO: *P1KR* */
/* Revision: 1.45       BY: Antony LejoS         DATE: 08/20/06 ECO: *P52Q* */
/* Revision: 1.45.1.1   BY: Sundeep Kalla        DATE: 01/10/08 ECO: *P6JH* */
/* Revision: 1.45.1.2   BY: Nafees Khan          DATE: 09/15/08 ECO: *Q1T2* */
/* $Revision: 1.45.1.8 $ BY: John Corda           DATE: 06/23/09 ECO: *Q320* */
/*-Revision end---------------------------------------------------------------*/

/***************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/
/* ************************************************************************** */
/* Note: This code has been modified to run when called inside an MFG/PRO API */
/* method as well as from the MFG/PRO menu, using the global variable         */
/* c-application-mode to conditionally execute API- vs. UI-specific logic.    */
/* Before modifying the code, please review the MFG/PRO API Development Guide */
/* in the QAD Development Standards for specific API coding standards and     */
/* guidelines.                                                                */
/* ************************************************************************** */

/* CHANGES MADE TO THIS PROGRAM SHOULD BE PROPAGATED TO FXTXEDIT.P.           */

/* RESTRUCTURED txedit .p SO THAT THE PROCEDURES                      */
/* "calculateRecoverableAmount", "calculateBaseCurrencyTax",          */
/* AND "calculateTaxAndNonTaxAmount" CAN BE USED FOR ALL TAX TYPES.   */


/*!
    txedit.p    Display/edit tax detail for a transaction

*/
/*!
                receives the following parameters
        I/O     Name        Like            Description
        -----   ----------- --------------- ------------------------------
        input   tr_type     tx2d_tr_type    Transaction Type Code
        input   ref         tx2d_ref        Document Reference
        input   nbr         tx2d_nbr        Number (Related Document)
        input   line        tx2d_line       Line Number (0 = ALL)
        input   tax_env     txe_tax_env     Tax Environment For Transaction
        output  tax_total   tx2d_totamt     Total Taxes for Transaction

    Each transaction type (SO,VO,...) will have its own control loop.  This is
    unfortunate, but necessary since the files are not standard, i.e., some
    contain trailers, some do not, names aren't always the same, etc.

*/
/***************************************************************************/
/*V8:ConvertMode=Maintenance                                               */
{mfdeclre.i}
{cxcustom.i "TXEDIT.P"}
{gplabel.i} /* EXTERNAL LABEL INCLUDE */

/* Define Handles for the programs. */
{pxphdef.i txtxxr}
/* End Define Handles for the programs. */

{pxmaint.i}

define input  parameter tr_type       like tx2d_tr_type no-undo.
define input  parameter ref           like tx2d_ref     no-undo.
define input  parameter nbr           like tx2d_nbr     no-undo.
define input  parameter line          like tx2d_line    no-undo.
define input  parameter tax_env       like txed_tax_env no-undo.
define input  parameter l_curr        like tx2d_curr    no-undo.
define input  parameter l_ex_ratetype like exr_ratetype no-undo.
define input  parameter l_ex_rate     like exr_rate     no-undo.
define input  parameter l_ex_rate1    like exr_rate2    no-undo.
define input  parameter l_tax_date    like tx2d_effdate no-undo.
define output parameter tax_total     like tx2d_totamt  no-undo.

define shared variable rndmthd      like rnd_rnd_mthd.

/* l_txchg IS SET TO TRUE WHEN TAXES ARE BEING EDITED AND NOT */
/* JUST VIEWED IN DR/CR MEMO MAINTENANCE                      */
define shared variable l_txchg      like mfc_logical.

define variable retval              as integer no-undo.
define variable tax_type            like tx2_tax_type extent 8 no-undo.
define variable titles              as character
                                    format "x(17)" extent 8 no-undo.
define variable taxes               like tx2d_totamt
                                    format "->>>>>,>>9.99" extent 8 no-undo.
define variable tx2d_recid          as recid no-undo.
define variable tax_line            like tx2d_line initial 0 no-undo.
define variable tax_trl             like tx2d_trl no-undo.
define variable tax_code            like tx2d_tax_code no-undo.
define variable pct_field           as decimal
                                    format "->>9.99<<%" decimals 4
                                    label "Tax Rate" no-undo.
define variable edit_base           like tx2d_totamt
                                    format "->>>>,>>9.99" no-undo.
define variable edit_recov          like tx2d_totamt
                                    format "->>>>,>>9.99" no-undo.
define variable edit_tax            like tx2d_totamt
                                    format "->>>>,>>9.99" no-undo.
define variable nonrecov_amt        like tx2d_totamt
                                    format "->>>>,>>9.99"
                                    label "Non-Recover Tax" no-undo.
define variable include_tax         like mfc_logical
                                    label "Tax In" no-undo.
define variable ontop_amt           like tx2d_totamt
                                    format "->>>>,>>9.99"
                                    label "Additional Taxes" no-undo.
define variable tax_by              as logical
                                    format "Line/Total"
                                    label "Tax By" no-undo.
define variable type_desc           like code_desc no-undo.
define variable taxc_desc           like code_desc no-undo.
define variable usage_desc          like code_desc no-undo.
define variable i                   as integer no-undo.
define variable j                   as integer no-undo.
define variable last_type           as integer initial 0 no-undo.
define variable exrate              like glt_ex_rate no-undo.
define variable exrate2             like glt_ex_rate2 no-undo.
define variable entity_exrate       like glt_ex_rate no-undo.
define variable entity_exrate2      like glt_ex_rate2 no-undo.
define variable mc-error-number     like msg_nbr no-undo.
define variable disp-char18         as character no-undo.
define variable l_taxtot            like tx2d_totamt no-undo.
define variable l_ship_date         like so_ship_date no-undo.
define variable pBaseCurrency       like gl_base_curr no-undo.
define variable l_old_tottax        like tx2d_tottax no-undo.
define variable l_process_gl        like mfc_logical no-undo.
define variable l_vodamt            as   decimal     no-undo.

/*COMMON API CONSTANTS AND VARIABLES*/
{mfaimfg.i}

/*TAX TEMP-TABLE, */
{mftxit01.i}
{mftdit01.i}

if c-application-mode = "API" then do on error undo, return:

   /*GET HANDLE OF API CONTROLLER*/
   {gprun.i ""gpaigh.p"" "(output ApiMethodHandle,
                           output ApiProgramName,
                           output ApiMethodName,
                           output apiContextString)"}
/*GUI*/ if global-beam-me-up then undo, leave.


   run getTransTaxAmount in ApiMethodHandle
      (output table ttTransTaxAmount).


end.  /* If c-application-mode = "API" */

assign disp-char18 = getTermLabel("TOTAL_TAXES",29) + ":":U.

/**** FORMS ****/


/*GUI preprocessor Frame A define */
&SCOPED-DEFINE PP_FRAME_NAME A

FORM /*GUI*/ 
   
 RECT-FRAME       AT ROW 1.4 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1   COLUMN 3 NO-LABEL
 SKIP(.1)  /*GUI*/
titles[1] to 18 taxes[1] format "->>>>,>>>,>>9.99"
   titles[5] to 58 taxes[5] format "->>>>,>>>,>>9.99"
   titles[2] to 18 taxes[2] format "->>>>,>>>,>>9.99"
   titles[6] to 58 taxes[6] format "->>>>,>>>,>>9.99"
   titles[3] to 18 taxes[3] format "->>>>,>>>,>>9.99"
   titles[7] to 58 taxes[7] format "->>>>,>>>,>>9.99"
   titles[4] to 18 taxes[4] format "->>>>,>>>,>>9.99"
   titles[8] to 58 taxes[8] format "->>>>,>>>,>>9.99"
   disp-char18 no-label to 58 tax_total format "->>>>,>>>,>>9.99"

 SKIP(.4)  /*GUI*/
with frame a no-labels width 80
   
   attr-space NO-BOX THREE-D /*GUI*/.

 DEFINE VARIABLE F-a-title AS CHARACTER.
 F-a-title = (getFrameTitle("TOTAL_TAX_AMOUNTS",25)).
 RECT-FRAME-LABEL:SCREEN-VALUE in frame a = F-a-title.
 RECT-FRAME-LABEL:WIDTH-PIXELS in frame a =
  FONT-TABLE:GET-TEXT-WIDTH-PIXELS(
  RECT-FRAME-LABEL:SCREEN-VALUE in frame a + " ", RECT-FRAME-LABEL:FONT).
 RECT-FRAME:HEIGHT-PIXELS in frame a =
  FRAME a:HEIGHT-PIXELS - RECT-FRAME:Y in frame a - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME a = FRAME a:WIDTH-CHARS - .5. /*GUI*/

/*GUI preprocessor Frame A undefine */
&UNDEFINE PP_FRAME_NAME



FORM /*GUI*/ 
   
 RECT-FRAME       AT ROW 1.4 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1   COLUMN 3 NO-LABEL
 SKIP(.1)  /*GUI*/
tax_line             colon 10
   tx2d_nbr             colon 32 label "Related Doc"
   tx2d_totamt          colon 60 label "Trnx Amt"
                        format "-zzzz,zzz,zz9.99"
   tax_trl              colon 10
   include_tax          colon 37
   tx2d_cur_nontax_amt  colon 60 label "Non-Taxable Base"
                        format "-zzzz,zzz,zz9.99"
   tax_by               colon 10
   tax_env              colon 27 label "Tax Env"
   tx2d_tottax          colon 60 label "Taxable Base"
                        format "-zzzz,zzz,zz9.99"
   tx2d_edited          colon 10
   tx2_tax_type         colon 27
   tx2d_cur_tax_amt     colon 60 label "Tax Amt"
                        format "-zzzz,zzz,zz9.99"
   tx2d_effdate         colon 10 label "Tax Date"
   tx2_pt_taxc          colon 34 label "Tax Class"
   tx2d_cur_recov_amt   colon 60 label "Recoverable Tax"
                        format "-zzzz,zzz,zz9.99"
   pct_field            colon 10
   tx2_tax_usage        colon 34
   nonrecov_amt         colon 60 format "-zzzz,zzz,zz9.99"
   tx2_tax_code         colon 10
   tx2_desc             no-labels
   tx2d_cur_abs_ret_amt colon 60 label "Absorb/Retain"
                        format "-zzzz,zzz,zz9.99"
 SKIP(.4)  /*GUI*/
with frame b  width 80
   side-labels attr-space NO-BOX THREE-D /*GUI*/.

 DEFINE VARIABLE F-b-title AS CHARACTER.
 F-b-title = (getFrameTitle("TAX_DETAIL_RECORD",25)).
 RECT-FRAME-LABEL:SCREEN-VALUE in frame b = F-b-title.
 RECT-FRAME-LABEL:WIDTH-PIXELS in frame b =
  FONT-TABLE:GET-TEXT-WIDTH-PIXELS(
  RECT-FRAME-LABEL:SCREEN-VALUE in frame b + " ", RECT-FRAME-LABEL:FONT).
 RECT-FRAME:HEIGHT-PIXELS in frame b =
  FRAME b:HEIGHT-PIXELS - RECT-FRAME:Y in frame b - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME b = FRAME b:WIDTH-CHARS - .5. /*GUI*/


/* SET EXTERNAL LABELS */
setFrameLabels(frame b:handle).

/*MAIN-BEGIN*/

if tr_type = "22"
   or tr_type = "32"
then
   tax_trl:label in frame b = getTermLabel("ENTITY", 8).

{txcurvar.i }  /* DEFINE AND SET CURRENCY DEPENDENT FORMATS */

for first gl_ctrl
    fields( gl_domain gl_rnd_mthd)
     where gl_ctrl.gl_domain = global_domain no-lock :
end.

/* INITIALIZE _OLD CURRENCY DEPENDENT FORMAT VARIABLES */
assign
   gtmtax_old       = taxes[1]:format
   tax_total_old    = tax_total:format
   tx2d_totamt_old  = tx2d_totamt:format
   tx2d_ntaxamt_old = tx2d_cur_nontax_amt:format
   tx2d_tottax_old  = tx2d_tottax:format
   tx2d_taxamt_old  = tx2d_cur_tax_amt:format
   nonrecov_amt_old = nonrecov_amt:format.

/* SET CURRENCY DEPENDENT FORMAT VARIABLES BASED ON RNDMTHD */
{txcurfmt.i }

/* IF NO TAX DETAIL EXISTS THEN LEAVE */

/*TO DO: This might be handled by the Set Controller*/
{pxrun.i &PROC='validateTaxDetailExists' &PROGRAM='txtxxr.p'
         &HANDLE=ph_txtxxr
         &PARAM="(input nbr,
                  input ref,
                  input tr_type,
                  input line)"
         &NOAPPERROR=True &CATCHERROR=True}
if return-value <> {&SUCCESS-RESULT} then do:
   return.
end.

/* LOAD TAX TYPES FROM TAX ENVIRONMENT */
for first code_mstr
    fields( code_domain code_desc code_fldname code_value)
     where code_mstr.code_domain = global_domain and  code_fldname =
     "txe_tax_env" and
          code_value   = tax_env no-lock:
end.

assign
   titles    = ""
   taxes     = 0
   tax_type  = ""
   last_type = 0.

/* LOAD ANY OTHER TAXES FROM TAX DETAIL */
typeloop2:
for each tx2d_det
    fields( tx2d_domain tx2d_abs_ret_amt tx2d_by_line tx2d_cur_abs_ret_amt
           tx2d_cur_nontax_amt tx2d_cur_recov_amt tx2d_cur_tax_amt
           tx2d_edited tx2d_effdate tx2d_ent_abs_ret_amt
           tx2d_ent_nontax_amt tx2d_ent_recov_amt tx2d_ent_tax_amt
           tx2d_line tx2d_nbr tx2d_nontax_amt tx2d_recov_amt tx2d_ref
           tx2d_taxable_amt tx2d_taxc tx2d_tax_amt tx2d_tax_code
           tx2d_tax_env tx2d_tax_in tx2d_tax_usage tx2d_totamt
           tx2d_tottax tx2d_trl tx2d_tr_type)
     where tx2d_det.tx2d_domain = global_domain and (  tx2d_ref = ref
      and (tx2d_nbr = nbr or nbr = "*")
      and (line = 0 or tx2d_line = line)
      and tx2d_tr_type = tr_type ) :

      if tx2d_tax_code = "00000000" then next typeloop2.

      for first tx2_mstr
          fields( tx2_domain tx2_apr_use tx2_ara_use tx2_by_line tx2_desc
          tx2_pt_taxc
                 tx2_tax_code tx2_tax_pct tx2_tax_type tx2_tax_usage
                 tx2_update_tax)
           where tx2_mstr.tx2_domain = global_domain and  tx2_tax_code =
           tx2d_tax_code no-lock:
      end.

      do j = 1 to last_type:
         if tax_type[j] = tx2_tax_type then do:
            taxes[j] = taxes[j] + tx2d_cur_tax_amt.
            next typeloop2.
         end.
      end.

      if last_type = 8 then do:
         assign
            tax_type[8] = getTermLabel("OTHER",17)
            titles[8]   = fill(" ",16 - length(getTermLabel("OTHER",17)))
                        + getTermLabel("OTHER",17) + ":"
            taxes[8]    = taxes[8] + tx2d_cur_tax_amt.
         next typeloop2.
      end.
      assign
         last_type           = last_type + 1
         tax_type[last_type] = tx2_tax_type
         titles[last_type]   = fill(" ",16 - length(tx2_tax_type)) +
                               tx2_tax_type + ":"
         taxes[j]            = tx2d_cur_tax_amt.
   end.

   if c-application-mode <> "API" then
      view frame b.
   /* DISPLAY TITLES, TAXES & TOTALS */
   do i = 1 to 8:
      tax_total = tax_total + taxes[i].
      if c-application-mode <> "API"
      then do:
         display titles[i] with frame a.
         if titles[i] > "" then
            display taxes[i] with frame a.
      end. /* If c-application-mode <> "API" */
   end.
   if c-application-mode <> "API" then
      display tax_total with frame a.

   /****** LINE ITEMS SECTION *******/
   for first tx2d_det
       fields( tx2d_domain tx2d_abs_ret_amt tx2d_by_line tx2d_cur_abs_ret_amt
              tx2d_cur_nontax_amt tx2d_cur_recov_amt tx2d_cur_tax_amt
              tx2d_edited tx2d_effdate tx2d_ent_abs_ret_amt
              tx2d_ent_nontax_amt tx2d_ent_recov_amt tx2d_ent_tax_amt
              tx2d_line tx2d_nbr tx2d_nontax_amt tx2d_recov_amt tx2d_ref
              tx2d_taxable_amt tx2d_taxc tx2d_tax_amt tx2d_tax_code
              tx2d_tax_env tx2d_tax_in tx2d_tax_usage tx2d_totamt
              tx2d_tottax tx2d_trl tx2d_tr_type)
        where tx2d_det.tx2d_domain = global_domain and (  tx2d_ref = ref and
            (tx2d_nbr = nbr or nbr = "*") and
            (line = 0 or tx2d_line = line) and
             tx2d_tr_type = tr_type ) no-lock:
   end.

   if available tx2d_det then do:

      {pxrun.i &PROC='readTaxMaster' &PROGRAM='txtxxr.p'
               &HANDLE=ph_txtxxr
               &PARAM="(input tx2d_tax_code,
                        buffer tx2_mstr,
                        input FALSE,
                        input FALSE)"
               &NOAPPERROR=True
               &CATCHERROR=True}

      assign
         tax_line = tx2d_line
         tax_trl  = tx2d_trl.

      if tx2d_edited then do:
      {pxrun.i &PROC='calculateTaxPercent' &PROGRAM='txtxxr.p'
               &HANDLE=ph_txtxxr
               &PARAM="(input tx2d_cur_tax_amt,
                        input tx2d_tottax,
                        output pct_field)"
               &NOAPPERROR=True
               &CATCHERROR=True}
      end.

      else
         pct_field = tx2_tax_pct.

      if c-application-mode <> "API"
      then do:
         if tx2_update_tax then
            color display input
               tx2d_totamt
               tx2d_cur_tax_amt
               tx2d_cur_recov_amt
               tx2d_tottax
             with frame b.
         else
            color display normal
               tx2d_totamt
               tx2d_cur_tax_amt
               tx2d_tottax
               tx2d_cur_recov_amt
            with frame b.
      end.  /* If c-application-mode <> "API" */

      tax_by = tx2_by_line.

      /* GET DESCRIPTIONS*/
      /* TAX TYPE */
      {pxrun.i &PROC='getTaxTypeDesc' &PROGRAM='txtxxr.p'
               &HANDLE=ph_txtxxr
               &PARAM="(input tx2_tax_type,
                        output type_desc)"
               &NOAPPERROR=True
               &CATCHERROR=True}
      if return-value = {&RECORD-NOT-FOUND} then
         type_desc = "".

      /* TAX CLASS */
      {pxrun.i &PROC='getTaxClassDesc' &PROGRAM='txtxxr.p'
               &HANDLE=ph_txtxxr
               &PARAM="(input tx2_pt_taxc,
                        output taxc_desc)"
               &NOAPPERROR=True
               &CATCHERROR=True}
      if return-value = {&RECORD-NOT-FOUND} then
         taxc_desc = "".

      /* TAX USAGE */
      {pxrun.i &PROC='getTaxUsageDesc' &PROGRAM='txtxxr.p'
               &HANDLE=ph_txtxxr
               &PARAM="(input tx2_pt_taxc,
                        output usage_desc)"
               &NOAPPERROR=True
               &CATCHERROR=True}
      if return-value = {&RECORD-NOT-FOUND} then
         usage_desc = "".

      /* DISPLAY TAX DETAIL FIELDS */
/* *SS-20120927.1*        {txedit.i}  */
/* *SS-20120927.1*  */               {yytxedit.i}

      recno = recid(tx2d_det).
   end.

   repeat on endkey undo, leave:
/*GUI*/ if global-beam-me-up then undo, leave.

      if c-application-mode = "API" and retry
         then return error return-value.

      if c-application-mode = "API"
      then do:
         find next ttTransTaxAmount
            no-error.

         if not available ttTransTaxAmount then
            leave.

      end. /*if c-application-mode = "API" */

      if c-application-mode <> "API"
      then do:
         display tax_line with frame b.
         update
            tax_line
            tax_trl
         with frame b
         editing:

            /* FIND NEXT/PREVIOUS RECORD */
            if frame-field = "tax_trl" then do:

               /* CHANGED THE EIGHT PARAMETER TO                */
               /* "nbr or nbr = '*') and                        */
               /* (line = 0 or tx2d_line = line))" FROM         */
               /* "((tx2d_nbr = nbr or nbr = '*') and           */
               /*   (line = 0 or tx2d_line = line))"            */

                /* CHANGED THE NINTH PARAMETER TO "((tx2d_nbr"   */
                /* FROM  "true"                                  */

               {mfnp07.i tx2d_det
                      "input tax_trl"
                       tx2d_trl
                       tx2d_ref
                        " tx2d_det.tx2d_domain = global_domain and ref "
                       tx2d_tr_type
                       tr_type
                      "nbr or nbr = '*') and (line = 0 or tx2d_line = line))"
                      "((tx2d_nbr"
                       tx2d_ref_nbr}
            end.
            else do:

               {mfnp05.i tx2d_det
                       tx2d_ref_nbr
                      " tx2d_det.tx2d_domain = global_domain and tx2d_ref  =
                      ref and tr_type = tx2d_tr_type"
                       tx2d_line
                      "input tax_line"}
            end.
            if recno <> ? then do:

               {pxrun.i &PROC='readTaxMaster' &PROGRAM='txtxxr.p'
                        &HANDLE=ph_txtxxr
                        &PARAM="(input tx2d_tax_code,
                                buffer tx2_mstr,
                                input FALSE,
                                input FALSE)"
                        &NOAPPERROR=True
                        &CATCHERROR=True}

               assign
                  tax_line = tx2d_line
                  tax_trl  = tx2d_trl
                  tax_code = tx2d_tax_code.

               if tx2d_edited then do:
                  {pxrun.i &PROC='calculateTaxPercent' &PROGRAM='txtxxr.p'
                           &HANDLE=ph_txtxxr
                           &PARAM="(input tx2d_cur_tax_amt,
                                    input tx2d_tottax,
                                    output pct_field)"
                           &NOAPPERROR=True
                           &CATCHERROR=True}
               end. /* if tx2d_edited */
               else
                  pct_field = tx2_tax_pct.
               if tx2_update_tax then
                  color display input
                     tx2d_totamt
                     tx2d_cur_tax_amt
                     tx2d_tottax
                     tx2d_cur_recov_amt
                  with frame b.
               else
                  color display normal
                     tx2d_totamt
                     tx2d_cur_tax_amt
                     tx2d_tottax
                     tx2d_cur_recov_amt
                  with frame b.

               tax_by = tx2_by_line.
               {pxrun.i &PROC='getTaxTypeDesc' &PROGRAM='txtxxr.p'
                        &HANDLE=ph_txtxxr
                        &PARAM="(input tx2_tax_type,
                                 output type_desc)"
                        &NOAPPERROR=True
                        &CATCHERROR=True}
               if return-value = {&RECORD-NOT-FOUND} then
                  type_desc = "".

               {pxrun.i &PROC='getTaxClassDesc' &PROGRAM='txtxxr.p'
                        &HANDLE=ph_txtxxr
                        &PARAM="(input tx2_pt_taxc,
                                 output taxc_desc)"
                        &NOAPPERROR=True
                        &CATCHERROR=True}
               if return-value = {&RECORD-NOT-FOUND} then
                  taxc_desc = "".

               {pxrun.i &PROC='getTaxUsageDesc' &PROGRAM='txtxxr.p'
                        &HANDLE=ph_txtxxr
                        &PARAM="(input tx2_pt_taxc,
                                output usage_desc)"
                        &NOAPPERROR=True
                        &CATCHERROR=True}
               if return-value = {&RECORD-NOT-FOUND} then
                  usage_desc = "".

               /* DISPLAY TAX DETAIL FIELDS */
/* *SS-20120927.1*                 {txedit.i} */
/* *SS-20120927.1*  */               {yytxedit.i}

            end.
         end.
      end. /* If c-application-mode <> "API" */

      assign tax_line tax_trl.

      if not available tx2d_det or
         (tx2d_line <> tax_line or tx2d_trl <> tax_trl)
         or c-application-mode = "API"
      then do:
         if c-application-mode <> "API" then
            tax_code = "".
         else do:
            /* * NOTE: THE NAMES OF THE ref AND nbr FIELDS HAVE
               * INTENTIONALLY BEEN CHANGED IN
               * THE TEMP-TABLE RELATIVE TO THE tx2d_det
               * TABLE SCHEMA, AS THE ref FIELD IS
               * USUALLY POPULATED WITH DATA FROM THE nbr
               * FIELD OF OTHER MFG/PRO MODULES, SUCH
               * AS SALES ORDER AND PURCHASE ORDER NUMBERS.
               * NAMING THE TAX DETAIL KEY FIELD
               * THE SAME AS THE CORRESPONDING FIELD IN OTHER
               *  MFG/PRO MODULES ALLOWS THE USE
               * OF BUFFER-COPIES TO EFFICIENTLY TRANSFER THE DATA TO                   *  ttTransTaxAmount FOR USE
               * BY THE txedit.p PROGRAM.
               */
            assign {mfaiset.i nbr      ttTransTaxAmount.refNbr}
                   {mfaiset.i tax_line ttTransTaxAmount.line}
                   {mfaiset.i tax_trl  ttTransTaxAmount.trl}
                   {mfaiset.i tax_code ttTransTaxAmount.taxCode}.
         end. /*c-application-mode = "API"*/

         {pxrun.i &PROC='readTaxDetail' &PROGRAM='txtxxr.p'
                  &HANDLE=ph_txtxxr
                  &PARAM="(input ref,
                           input tax_code,
                           input tax_trl,
                           input tr_type,
                           input nbr,
                           input tax_line,
                           buffer tx2d_det,
                           input FALSE,
                           input FALSE)"
                  &NOAPPERROR=True
                  &CATCHERROR=True}
      end. /* IF NOT AVAILABLE tx2d_det or ... */
      if available tx2d_det then do:
         /* SEARCH FOR THE CORRESPONDING tx2_mstr        */
         {pxrun.i &PROC='readTaxMaster' &PROGRAM='txtxxr.p'
                  &HANDLE=ph_txtxxr
                  &PARAM="(input tx2d_tax_code,
                           buffer tx2_mstr,
                           input FALSE,
                           input FALSE)"
                  &NOAPPERROR=True
                  &CATCHERROR=True}

         if tx2d_edited then do:
            {pxrun.i &PROC='calculateTaxPercent' &PROGRAM='txtxxr.p'
                     &HANDLE=ph_txtxxr
                     &PARAM="(input tx2d_cur_tax_amt,
                              input tx2d_tottax,
                              output pct_field)"
                     &NOAPPERROR=True
                     &CATCHERROR=True}
         end.
         else
            pct_field = tx2_tax_pct.

         if c-application-mode <> "API" then do:
            if tx2_update_tax then
               color display input
                  tx2d_totamt
                  tx2d_cur_tax_amt
                  tx2d_tottax
                  tx2d_cur_recov_amt
               with frame b.
            else
               color display normal
                  tx2d_totamt
                  tx2d_cur_tax_amt
                  tx2d_tottax
                  tx2d_cur_recov_amt
               with frame b.
         end. /* if c-application-mode <> "API" */

         {pxrun.i &PROC='getTaxTypeDesc' &PROGRAM='txtxxr.p'
                  &HANDLE=ph_txtxxr
                  &PARAM="(input tx2_tax_type,
                           output type_desc)"
                  &NOAPPERROR=True
                  &CATCHERROR=True}
         if return-value = {&RECORD-NOT-FOUND} then
            type_desc = "".

         {pxrun.i &PROC='getTaxClassDesc' &PROGRAM='txtxxr.p'
                  &HANDLE=ph_txtxxr
                  &PARAM="(input tx2_pt_taxc,
                           output taxc_desc)"
                  &NOAPPERROR=True
                  &CATCHERROR=True}
         if return-value = {&RECORD-NOT-FOUND} then
            taxc_desc = "".

         {pxrun.i &PROC='getTaxUsageDesc' &PROGRAM='txtxxr.p'
                  &HANDLE=ph_txtxxr
                  &PARAM="(input tx2_pt_taxc,
                           output usage_desc)"
                  &NOAPPERROR=True
                  &CATCHERROR=True}
         if return-value = {&RECORD-NOT-FOUND} then
            usage_desc = "".

         tax_by = tx2_by_line.

         /* DISPLAY TAX DETAIL FIELDS */
/* *SS-20120927.1*  */         {txedit.i}
/* *SS-20120927.1*  */               {yytxedit.i}

         /* UPDATE DISPLAYED TAX AMOUNTS */

         if tx2_update_tax then do:

            /*TO DO: will need to call readTaxDetail with lock*/
            tx2d_recid = recid(tx2d_det).
            for first tx2d_det where recid(tx2d_det) = tx2d_recid
               exclusive-lock:
            end.

            assign
               edit_tax   = tx2d_cur_tax_amt
               edit_recov = tx2d_cur_recov_amt
               edit_base  = tx2d_tottax.

            /* CALL APPROPRIATE PROCEDURES FOR GETTING THE EXCHANGE RATES */
            /* INTO THE VARIABLES entity_exrate AND exrate BASED ON THE   */
            /* VALUE OF tx2d_tax_amt AND tx2d_ent_tax_amt.                */

            if  tx2d_tax_amt     = 0
            and tx2d_ent_tax_amt = 0
            then do:

               {pxrun.i &PROC='calculateExchangeRateUsage'
                        &PROGRAM='txtxxr.p'
                        &HANDLE=ph_txtxxr
                        &PARAM="(input l_curr,
                                 input l_ex_ratetype,
                                 input l_ex_rate,
                                 input l_ex_rate1,
                                 input l_tax_date,
                                 output entity_exrate,
                                 output exrate,
                                 output pBaseCurrency)"}

               if tx2d_tr_type = "13"
               then do:

                  for first so_mstr
                     fields(so_domain so_curr so_exru_seq so_ex_rate
                            so_ex_rate2 so_ex_ratetype so_fix_rate
                            so_nbr so_ship_date so_tax_date)
                     where so_mstr.so_domain = global_domain
                       and so_nbr            = tx2d_ref
                     no-lock:
                  end. /* FOR FIRST so_mstr */

                  /* WHEN so_fix_rate = "no" , BASE:TRANSACTION EXCHANGE RATE */
                  /* FROM THE EXCHANGE RATE MASTER NEEDS TO BE PASSED TWICE   */
                  /* TO THE RESPECTIVE PROCEDURES.                            */

                  /* HENCE ASSIGNING THE VARIABLES entity_exrate and exrate   */
                  /* TO THE VALUE OF entity_exrate SO THAT THE PROCEDURES     */
                  /* COULD BE USED IN COMMON.                                 */

                  if pBaseCurrency <> l_curr
                  then do:
                     if so_fix_rate = no
                     then
                        assign
                           entity_exrate = entity_exrate
                           exrate        = entity_exrate.
                  end. /* IF PBaseCurrency <> l_curr */

               end. /* IF tx2d_tr_type = "13" */

            end. /* IF tx2d_tax_amt = 0 ........ */

            else do:

               {pxrun.i &PROC='calculateExchangeRate' &PROGRAM='txtxxr.p'
                   &HANDLE=ph_txtxxr
                   &PARAM="(buffer tx2d_det,
                            output entity_exrate,
                            output exrate)"
                   &NOAPPERROR=True
                   &CATCHERROR=True}

            end. /* ELSE DO */

            {&TXEDIT-P-TAG1}

            taxloop:
            do on error undo, retry:
/*GUI*/ if global-beam-me-up then undo, leave.

               /* DO NOT RETRY WHEN PROCESSING API REQUEST */
               if retry and c-application-mode = "API" then
                  undo, return.
               l_old_tottax = tx2d_tottax.
               if c-application-mode <> "API" then
                  update
                     tx2d_totamt
                     tx2d_tottax
                     tx2d_cur_tax_amt
                     tx2d_cur_recov_amt
                  with frame b.
               else
                  assign
                     {mfaiset.i tx2d_totamt  ttTransTaxAmount.totamt}
                     {mfaiset.i tx2d_tottax  ttTransTaxAmount.tottax}
                     {mfaiset.i tx2d_cur_tax_amt  ttTransTaxAmount.curTaxAmt}
                     {mfaiset.i tx2d_cur_recov_amt  ttTransTaxAmount.curRecovAmt}.
               if     l_old_tottax    <> tx2d_tottax
                  and index(program-name(2),"apvomth.") > 0
               then
                  /*MESSAGE #7592 - TAX BASE CHANGING NEEDS NON-TAXABLE
                  ADJUSTING DISTRIBUTION LINE*/
                  {pxmsg.i &MSGNUM=7592
                           &ERRORLEVEL=2}

               {pxrun.i &PROC='validateTotalAmount' &PROGRAM='txtxxr.p'
                        &HANDLE=ph_txtxxr
                        &PARAM="(input rndmthd,
                                 input tx2d_totamt)"
                        &NOAPPERROR=True
                        &CATCHERROR=True}

               if return-value <> {&SUCCESS-RESULT} then do:
                  if c-application-mode <> "API"
                  then do:
                     next-prompt tx2d_totamt with frame b.
                     undo taxloop, retry taxloop.
                  end.
                  else
                     undo taxloop, return error.
               end.

               /* VALIDATE TX2D_TOTTAX AMOUNT */
               if edit_base <> tx2d_tottax then do:
                  {pxrun.i &PROC='validateTotalTaxAmount' &PROGRAM='txtxxr.p'
                           &HANDLE=ph_txtxxr
                           &PARAM="(input rndmthd,
                                   input tx2d_tottax)"
                           &NOAPPERROR=True
                           &CATCHERROR=True}

                  if return-value <> {&SUCCESS-RESULT} then do:
                     if c-application-mode <> "API"
                     then do:
                        next-prompt tx2d_tottax with frame b.
                        undo taxloop, retry taxloop.
                     end.
                     else
                        undo taxloop, return error.
                  end.
               end.

               /* VALIDATE TX2D_CUR_TAX_AMT AMOUNT */
               if edit_tax <> tx2d_cur_tax_amt then do:
                  {pxrun.i &PROC='validateCurrentTaxAmount' &PROGRAM='txtxxr.p'
                           &HANDLE=ph_txtxxr
                           &PARAM="(input rndmthd,
                                    input tx2d_cur_tax_amt)"
                           &NOAPPERROR=True
                           &CATCHERROR=True}

                  if return-value <> {&SUCCESS-RESULT} then do:
                     if c-application-mode <> "API"
                     then do:
                        next-prompt tx2d_cur_tax_amt with frame b.
                        undo taxloop, retry taxloop.
                     end.
                     else
                        undo taxloop, return error.

                  end.
               end.

               /* VALIDATE TX2D_CUR_RECOV_AMT AMOUNT */
               if edit_recov <> tx2d_cur_recov_amt then do:
                  {pxrun.i &PROC='validateRecoverableAmount' &PROGRAM='txtxxr.p'
                           &HANDLE=ph_txtxxr
                           &PARAM="(input rndmthd,
                                    input tx2d_cur_recov_amt)"
                           &NOAPPERROR=True
                           &CATCHERROR=True}
                  if return-value <> {&SUCCESS-RESULT} then do:
                     if c-application-mode <> "API"
                     then do:
                        next-prompt tx2d_cur_recov_amt with frame b.
                        undo taxloop, retry taxloop.
                     end.
                     else
                        undo taxloop, return error.

                  end.
               end.
            end.
/*GUI*/ if global-beam-me-up then undo, leave.


            if edit_tax <> tx2d_cur_tax_amt
               or edit_base <> tx2d_tottax
               or edit_recov <> tx2d_cur_recov_amt
            then do:

               /* Inform that the record is manually edited */
               {pxrun.i &PROC = 'taxAmountIsEdited' &PROGRAM = 'txtxxr.p'
                        &HANDLE=ph_txtxxr
                        &PARAM = "(buffer tx2d_det)"}

               j = 0.

               srchloop:
               do i = 1 to last_type:
                  if tax_type[i] = tx2_tax_type then
                     leave srchloop.
               end.

               assign
                  l_txchg     = yes.

               if edit_recov <> tx2d_cur_recov_amt
               then do:

                  if pBaseCurrency <> l_curr
                  then do:

                     /* CHECK IF RECOVERABLE AMT WAS CHANGED */
                     {pxrun.i &PROC='calculateRecoverableAmount'
                              &PROGRAM='txtxxr.p'
                              &HANDLE=ph_txtxxr
                              &PARAM="(input gl_rnd_mthd,
                                       input entity_exrate,
                                       input exrate,
                                       input tx2d_cur_recov_amt,
                                       output tx2d_recov_amt,
                                       output tx2d_ent_recov_amt)"
                              &NOAPPERROR=True
                              &CATCHERROR=True}

                  end. /* IF pBaseCurrency <> l_curr */

                  else do:
                     assign
                        tx2d_recov_amt     = tx2d_cur_recov_amt
                        tx2d_ent_recov_amt = tx2d_cur_recov_amt.

                  end. /* ELSE DO */

                  display tx2d_cur_recov_amt with frame b.

               end. /* if edit_recov */
               /* CHECK IF BASE CURR TAXABLE AMT CHANGED */

               if edit_base <> tx2d_tottax then do:

                  if tx2d_tax_in
                  then
                     l_taxtot = tx2d_totamt - tx2d_cur_tax_amt.
                  else
                     l_taxtot = tx2d_totamt.

                  /* REPLACED FOURTH INPUT PARAMETER FROM tx2d_totamt */
                  /* TO l_taxtot                                      */
                  {pxrun.i &PROC='calculateTaxAndNonTaxAmount' &PROGRAM='txtxxr.p'
                           &HANDLE=ph_txtxxr
                           &PARAM="(input gl_rnd_mthd,
                                    input entity_exrate,
                                    input exrate,
                                    input l_taxtot,
                                    input tx2d_tottax,
                                    input tx2d_cur_nontax_amt,
                                    output tx2d_taxable_amt,
                                    output tx2d_cur_nontax_amt,
                                    output tx2d_nontax_amt,
                                    output tx2d_ent_nontax_amt)"
                           &NOAPPERROR=True
                           &CATCHERROR=True}
                  if c-application-mode <> "API" then
                     display tx2d_cur_nontax_amt with frame b.

               end. /* IF BASE CURR TAXABLE AMT CHANGED */

               tax_total = tax_total - edit_tax + tx2d_cur_tax_amt.
               if i > 8 then
                  taxes[8] = taxes[8] - edit_tax + tx2d_cur_tax_amt.
               else
                  taxes[i] = taxes[i] - edit_tax + tx2d_cur_tax_amt.

               /* BASE CURRENY TAX AMOUNT */
               if edit_tax <> tx2d_cur_tax_amt
               then do:

                  if pBaseCurrency <> l_curr
                  then do:

                     {pxrun.i &PROC='calculateBaseCurrencyTax'
                              &PROGRAM='txtxxr.p'
                              &HANDLE=ph_txtxxr
                              &PARAM="(input gl_rnd_mthd,
                                       input entity_exrate,
                                       input exrate,
                                       input tx2d_cur_tax_amt,
                                       output tx2d_ent_tax_amt,
                                       output tx2d_tax_amt)"
                              &NOAPPERROR=True
                              &CATCHERROR=True}

                  end. /* IF pBaseCurrency <> l_curr */

                  else do:
                     assign
                        tx2d_tax_amt     = tx2d_cur_tax_amt
                        tx2d_ent_tax_amt = tx2d_cur_tax_amt.

                  end. /* ELSE DO */

                  {pxrun.i &PROC='calculateTaxRetainAndAbsorbedAmt' &PROGRAM='txtxxr.p'
                           &HANDLE=ph_txtxxr
                           &PARAM="(buffer tx2d_det,
                                    buffer tx2_mstr)"
                           &NOAPPERROR=True
                           &CATCHERROR=True}

                  if tx2d_tax_in
                  then do:
                     {pxrun.i &PROC='calculateTaxAndNonTaxAmount' &PROGRAM='txtxxr.p'
                              &HANDLE=ph_txtxxr
                              &PARAM="(input gl_rnd_mthd,
                                       input entity_exrate,
                                       input exrate,
                                       input tx2d_totamt - tx2d_cur_tax_amt,
                                       input tx2d_tottax,
                                       input tx2d_cur_nontax_amt,
                                       output tx2d_taxable_amt,
                                       output tx2d_cur_nontax_amt,
                                       output tx2d_nontax_amt,
                                       output tx2d_ent_nontax_amt)"
                              &NOAPPERROR=True
                              &CATCHERROR=True}
                     if c-application-mode <> "API" then
                        display tx2d_cur_nontax_amt with frame b.
                  end. /* IF tx2d_tax_in */

               end. /* IF BASE CURR TAX AMOUNT CHANGED */

               {pxrun.i &PROC='calculateTaxPercent' &PROGRAM='txtxxr.p'
                        &HANDLE=ph_txtxxr
                        &PARAM="(input tx2d_cur_tax_amt,
                                 input tx2d_tottax,
                                 output pct_field)"
                        &NOAPPERROR=True
                        &CATCHERROR=True}
               if c-application-mode <> "API"
               then do:
                  display pct_field with frame b.
                  display
                     taxes[i] when (i <= 8)
                     taxes[8] when (i > 8)
                     tax_total
                  with frame a.
               end. /* c-application-mode <> "API" */

               l_vodamt = (tx2d_cur_tax_amt - tx2d_cur_recov_amt) -
                          (edit_tax - edit_recov).

               if index(program-name(2),"apvomth.") > 0 and
                  l_vodamt <> 0 and
                  tx2d_by_line and
                  tx2d_rcpt_tax_point = yes
               then do:
                  for first prh_hist no-lock
                     where prh_domain   = global_domain
                     and   prh_receiver = tx2d_nbr
                     and   prh_line     = tx2d_line:
                  end. /* for first prh_hist */

                  if available prh_hist then do:
                     for first pvo_mstr no-lock
                        where pvo_domain = global_domain
                        and   pvo_order = prh_nbr
                        and   pvo_internal_ref = tx2d_nbr
                        and   pvo_line = tx2d_line:
                     end. /* for first pvo_mstr */

                     for first vph_hist no-lock
                        where vph_domain = 'demo1'
                        and   vph_pvo_id = pvo_id
                        and   vph_pvod_id_line > 0:
                     end. /* for first vph_hist */
                  end.
/*GUI*/ if global-beam-me-up then undo, leave.
 /* if avialable prh_hist */

                  if available prh_hist and
                     available vph_hist and
                     not (vph_hist.vph_inv_cost <> prh_hist.prh_pur_cost)
                  then do:

                     {gprun.i ""apvomta2.p""
                        "(input prh_type,
                          input recid(vph_hist),
                          input-output l_process_gl,
                          input-output l_vodamt)"}
/*GUI*/ if global-beam-me-up then undo, leave.

                  end. /* if available prh_hist */
               end. /* if index(program-name(2),"apvomth.") > 0 */

            end. /* then do (tax edited) */

            /* DISPLAY TAX DETAIL FIELDS */
/* *SS-20120927.1*             {txedit.i} */ 
/* *SS-20120927.1*  */               {yytxedit.i}

            release tx2d_det.
         end.

      end.

      else do:
         /* MESSAGE #867 - TAX DETAIL DOES NOT EXIST */
         {pxmsg.i
            &MSGNUM=867
            &ERRORLEVEL={&APP-ERROR-RESULT}}
            clear frame b.
/*GUI*/ RECT-FRAME-LABEL:SCREEN-VALUE in frame b = F-b-title.
      end.

   end.
   if c-application-mode <> "API"
   then do:
      hide frame a.
      hide frame b.
   end. /* c-application-mode <> "API" */

/*MAIN-END*/
