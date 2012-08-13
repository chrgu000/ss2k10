/* GUI CONVERTED from sosomtlc.p (converter v1.69) Sun Jul 27 20:06:01 1997 */
/* sosomtlc.p  - PROGRAM TO UPDATE FIELDS IN FRAME set_tax IN SALES ORDER */
/* COPYRIGHT qad.inc. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK.   */
/*V8:ConvertMode=Maintenance                                              */
/* REVISION: 8.5         CREATED BY: 11/05/96  BY: *H0NR* Suresh Nayak    */
/* REVISION: 8.5        MODIFIED BY: 07/14/97  BY: *H1BY* Sue Poland      */

/*
  THIS ROUTINE WAS DERIVED FROM sosomtlb.p AND IS USED BY SALES ORDER TO
  UPDATE THE FIELDS IN THE FRAME settax. THE PROGRAM sosomtlb.p HAD UPDATE
  STATEMENTS FOR THE FIELD (sod_taxc and sod_taxable) IN 2 FRAMES. HENCE IT WAS
  ALLOWING THE USER WHO DOES NOT HAVE ACCESS TO THIS FIELD (SET UP IN
  36.5.4 FIELD SECURITY MAINTENANCE) TO UPDATE THIS FIELD. THIS FILE WAS
  CREATED TO FIX THIS PROBLEM .

  CALLED BY sosomtlb.p (USED BY SALES ORDERS )
*/

    {mfdeclre.i}

    define shared variable l_loop_seta  like mfc_logical no-undo.
    define shared variable so_recno     as recid.
    define shared variable sod_recno    as recid.
    define shared variable zone_to      like txz_tax_zone.
    define shared variable zone_from    like txz_tax_zone.
    define shared variable tax_usage    like so_tax_usage no-undo.
    define shared variable tax_env      like so_tax_env no-undo.
    define shared variable old_sod_site like sod_site no-undo.
/*H1BY* define shared variable temp_zone    like txz_tax_zone.  */
    define input parameter this-is-rma  like mfc_logical.


    l_loop_seta = no.
    find so_mstr where recid(so_mstr) = so_recno exclusive-lock no-error.
    find sod_det where recid(sod_det) = sod_recno exclusive-lock no-error .

      /* DEFINE OTHER FORMS */
     FORM /*GUI*/ 
        
 RECT-FRAME       AT ROW 1 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1 COLUMN 3 NO-LABEL VIEW-AS TEXT SIZE-PIXELS 1 BY 1
 SKIP(.1)  /*GUI*/
sod_tax_usage   colon 25
        sod_tax_env     colon 25
            space(2)
            sod_taxc        colon 25
            sod_taxable     colon 25
            sod_tax_in      colon 25
          SKIP(.4)  /*GUI*/
with frame set_tax row 13 overlay centered
     side-labels attr-space NO-BOX THREE-D /*GUI*/.

 DEFINE VARIABLE F-set_tax-title AS CHARACTER INITIAL "".
 RECT-FRAME-LABEL:SCREEN-VALUE in frame set_tax = F-set_tax-title.
 RECT-FRAME-LABEL:HIDDEN in frame set_tax = yes.
 RECT-FRAME:HEIGHT-PIXELS in frame set_tax =
  FRAME set_tax:HEIGHT-PIXELS - RECT-FRAME:Y in frame set_tax - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME set_tax = FRAME set_tax:WIDTH-CHARS - .5.  /*GUI*/


     if {txnew.i} and sod_taxable then do:

     /* TEST FOR CHANGE IN SITE */
     if old_sod_site <> sod_site then do:
                {mfmsg.i 955 2} /* NEW SITE SPECIFIED; CHECK TAX ENVIRONMENT */
        sod_tax_env = "".
     end.

     /* INITIALIZE TEMPORARY NO-UNDO VARS */
     tax_usage = sod_tax_usage.
     tax_env   = sod_tax_env.

     taxloop:
         do on error  undo, retry
            on endkey undo, leave:
/*GUI*/ if global-beam-me-up then undo, leave.


         sod_tax_usage = tax_usage.
         sod_tax_env   = tax_env.

         /* SUGGEST TAX ENVIRONMENT */
         if sod_tax_env = "" then do:

        /* LOAD DEFAULTS */
        find ad_mstr where ad_addr = so_ship
        no-lock no-error.
        if available ad_mstr then
            zone_to = ad_tax_zone.
        else do:
            find ad_mstr where ad_addr = so_cust
            no-lock no-error.
            if available(ad_mstr) then
            zone_to = ad_tax_zone.
        end.

        /* CHECK FOR SITE ADDRESS */
        find ad_mstr where ad_addr = sod_site no-lock
        no-error.
        if available(ad_mstr) then
            zone_from = ad_tax_zone.
        else do:
                    {mfmsg.i 864 2} /* SITE ADDRESS DOES NOT EXIST */
            zone_from = "".
        end.
        
/*H1BY*         RMA RECEIPTS SHOULD CALCULATE GTM JUST AS S.O. RETURNS
.               WOULD, SO, DO NOT SWITCH FROM/TO ZONES...
.                 /* SWITCH ZONE_FROM AND ZONE_TO WHEN RMA-RECEIPT   *TVO*/
.                 /* BECAUSE THEN WE SHIP FROM THE CUST/SHIP TO OUR SITE */
.                 if this-is-rma and sod_fsm_type = "RMA-RCT" then assign
.                     temp_zone = zone_from
.                     zone_from = zone_to
.                     zone_to   = temp_zone.
.*H1BY*/
        {gprun.i ""txtxeget.p"" "(input  zone_to,
                    input  zone_from,
                    input  so_taxc,
                    output sod_tax_env)"}
/*GUI*/ if global-beam-me-up then undo, leave.


         end. /* sod_tax_env = "" */

         display
         sod_tax_usage
         sod_tax_env
         sod_tax_in
         with frame set_tax.

         update
         sod_tax_usage
         sod_tax_env
                 sod_taxc
                 sod_taxable
         sod_tax_in
         with frame set_tax.

         tax_usage = sod_tax_usage.

         /* VALIDATE TAX ENVIRONMENT */
         /* IF BLANK - SUGGEST AGAIN */
         if sod_tax_env = "" then do:
                 {mfmsg.i 944 3}. /* BLANK TAX ENVIRONMENT NOT ALLOWED */
        tax_env = "".
        next-prompt sod_tax_env with frame set_tax.
        undo taxloop, retry.
         end.

         /* ELSE UNDO TAXLOOP */
         if not {gptxe.v "input sod_tax_env" ""no""}
         then do:
                  {mfmsg.i 869 3} /* TAX ENVIRONMENT DOES NOT EXIST */
         next-prompt sod_tax_env with frame set_tax.
         undo taxloop, retry.
         end.
             l_loop_seta = yes.
     end.
/*GUI*/ if global-beam-me-up then undo, leave.
 /* end of taxloop                    */
     hide frame set_tax.
     end. /* end of if {txnew.i} and sod_taxable   */
     else l_loop_seta = yes.
