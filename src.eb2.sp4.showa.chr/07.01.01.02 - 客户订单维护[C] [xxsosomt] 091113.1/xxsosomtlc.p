/* sosomtlc.p  - PROGRAM TO UPDATE FIELDS IN FRAME set_tax IN SALES ORDER */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                    */
/* All rights reserved worldwide.  This is an unpublished work.           */
/* $Revision: 1.6.2.7 $                                                           */
/*V8:ConvertMode=Maintenance                                              */
/* REVISION: 8.5         CREATED BY: 11/05/96  BY: *H0NR* Suresh Nayak    */
/* REVISION: 8.5        MODIFIED BY: 07/14/97  BY: *H1BY* Sue Poland      */
/* REVISION: 8.6      LAST MODIFIED: 05/20/98 BY: *K1Q4* Alfred Tan       */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00 BY: *N08T* Annasaheb Rahane */
/* REVISION: 9.1      LAST MODIFIED: 04/25/00 BY: *N0CG* Santosh Rao      */
/* REVISION: 9.1      LAST MODIFIED: 08/12/00 BY: *N0KN* myb              */
/* Revision: 1.6.2.6   BY: Katie Hilbert  DATE: 04/01/01 ECO: *P002*      */
/* $Revision: 1.6.2.7 $        BY: Rajaneesh S.   DATE: 06/19/02 ECO: *N1H7*      */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/
/*
  THIS ROUTINE WAS DERIVED FROM sosomtlb.p AND IS USED BY SALES ORDER TO
  UPDATE THE FIELDS IN THE FRAME settax. THE PROGRAM sosomtlb.p HAD UPDATE
  STATEMENTS FOR THE FIELD (sod_taxc and sod_taxable) IN 2 FRAMES. HENCE IT WAS
  ALLOWING THE USER WHO DOES NOT HAVE ACCESS TO THIS FIELD (SET UP IN
  36.5.4 FIELD SECURITY MAINTENANCE) TO UPDATE THIS FIELD. THIS FILE WAS
  CREATED TO FIX THIS PROBLEM .

  CALLED BY sosomtlb.p (USED BY SALES ORDERS )
*/
/* ss - 090803.1 by: jack */
/* ss - 090916.1 by: jack */
/* ss - 091113.1 by: jack */

{mfdeclre.i}
{gplabel.i} /* EXTERNAL LABEL INCLUDE */
{pxmaint.i}

define shared variable l_loop_seta  like mfc_logical no-undo.
define shared variable so_recno     as recid.
define shared variable sod_recno    as recid.
define shared variable zone_to      like txz_tax_zone.
define shared variable zone_from    like txz_tax_zone.
define shared variable tax_usage    like so_tax_usage no-undo.
define shared variable tax_env      like so_tax_env no-undo.
define shared variable old_sod_site like sod_site no-undo.

define input parameter this-is-rma  as  logical.

/* ss - 090803.1 -b */
define shared variable new_line like mfc_logical.
/* ss - 090803.1 -e */

l_loop_seta = no.
find so_mstr where recid(so_mstr) = so_recno exclusive-lock no-error.
find sod_det where recid(sod_det) = sod_recno exclusive-lock no-error .

/* DEFINE OTHER FORMS */
form
   sod_tax_usage   colon 25
   sod_tax_env     colon 25
   space(2)
   sod_taxc        colon 25
   sod_taxable     colon 25
   sod_tax_in      colon 25
with frame set_tax row 13 overlay centered
   side-labels attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame set_tax:handle).

if sod_taxable then do:

   /* TEST FOR CHANGE IN SITE */
   if old_sod_site <> sod_site then do:
      {pxmsg.i &MSGNUM=955 &ERRORLEVEL=2}
      /* NEW SITE SPECIFIED; CHECK TAX ENVIRONMENT */
      sod_tax_env = "".
   end.

   /* INITIALIZE TEMPORARY NO-UNDO VARS */
   assign
      tax_usage = sod_tax_usage
      tax_env   = sod_tax_env.
/* ss - 091113.1 -b 
 ss - 090803.1 -b 
 ss - 091113.1 -e */
   taxloop:
   do on error  undo, retry
         on endkey undo, leave:
      assign
         sod_tax_usage = tax_usage
         sod_tax_env   = tax_env.

      /* SUGGEST TAX ENVIRONMENT */
      if sod_tax_env = "" then do:

         /* LOAD DEFAULTS */
         for first ad_mstr
               fields(ad_addr ad_tax_zone)
               where ad_addr = so_ship no-lock:
         end. /* FOR FIRST AD_MSTR */

         if available ad_mstr then
            zone_to = ad_tax_zone.
         else do:

            for first ad_mstr
                  fields(ad_addr ad_tax_zone)
                  where ad_addr = so_cust no-lock:
            end. /* FOR FIRST AD_MSTR */

            if available(ad_mstr) then
               zone_to = ad_tax_zone.
         end.

         /* CHECK FOR SITE ADDRESS */

         for first ad_mstr
               fields(ad_addr ad_tax_zone)
               where ad_addr = sod_site no-lock:
         end. /* FOR FIRST AD_MSTR */

         if available(ad_mstr) then
            zone_from = ad_tax_zone.
         else do:
            {pxmsg.i &MSGNUM=864 &ERRORLEVEL=2}
            /* SITE ADDRESS DOES NOT EXIST */
            zone_from = "".
         end.

         {gprun.i ""txtxeget.p"" "(input  zone_to,
                                   input  zone_from,
                                   input  so_taxc,
                                   output sod_tax_env)"}

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

      /* VALIDATE TAX USAGE  */
      {pxrun.i &PROC       = 'validateTaxUsage'
               &PROGRAM    = 'txenvxr.p'
               &PARAM      = "(input sod_tax_usage)"
               &NOAPPERROR = true
               &CATCHERROR = true }

      if return-value <> {&SUCCESS-RESULT}
      then do:
         next-prompt
            sod_tax_usage
         with frame set_tax.
         undo taxloop, retry .
      end. /* IF return-value <> {&SUCCESS-RESULT}  */

      tax_usage = sod_tax_usage.

      /* VALIDATE TAX ENVIRONMENT */
      /* IF BLANK - SUGGEST AGAIN */
      if sod_tax_env = "" then do:
         {pxmsg.i &MSGNUM=944 &ERRORLEVEL=3}
         /* BLANK TAX ENVIRONMENT NOT ALLOWED */
         tax_env = "".
         next-prompt sod_tax_env with frame set_tax.
         undo taxloop, retry.
      end.

      /* ELSE UNDO TAXLOOP */
      if not {gptxe.v "input sod_tax_env" ""no""}
      then do:
         {pxmsg.i &MSGNUM=869 &ERRORLEVEL=3}
         /* TAX ENVIRONMENT DOES NOT EXIST */
         next-prompt sod_tax_env with frame set_tax.
         undo taxloop, retry.
      end.
      l_loop_seta = yes.
   end. /* end of taxloop                    */
   /* ss - 091113.1 -b 
   ss - 090803.1 
  ss - 091113.1 -e */
   
       /* ss - 091113.1 -b
   /* ss - 090803.1 -b */
     taxloop:
   do on error  undo, retry
         on endkey undo, leave:
      assign
         sod_tax_usage = tax_usage
         sod_tax_env   = tax_env.

      /* SUGGEST TAX ENVIRONMENT */
      if sod_tax_env = "" then do:

         /* LOAD DEFAULTS */
         for first ad_mstr
               fields(ad_addr ad_tax_zone)
               where ad_addr = so_ship no-lock:
         end. /* FOR FIRST AD_MSTR */

         if available ad_mstr then
            zone_to = ad_tax_zone.
         else do:

            for first ad_mstr
                  fields(ad_addr ad_tax_zone)
                  where ad_addr = so_cust no-lock:
            end. /* FOR FIRST AD_MSTR */

            if available(ad_mstr) then
               zone_to = ad_tax_zone.
         end.

         /* CHECK FOR SITE ADDRESS */

         for first ad_mstr
               fields(ad_addr ad_tax_zone)
               where ad_addr = sod_site no-lock:
         end. /* FOR FIRST AD_MSTR */

         if available(ad_mstr) then
            zone_from = ad_tax_zone.
         else do:
            {pxmsg.i &MSGNUM=864 &ERRORLEVEL=2}
            /* SITE ADDRESS DOES NOT EXIST */
            zone_from = "".
         end.

         {gprun.i ""txtxeget.p"" "(input  zone_to,
                                   input  zone_from,
                                   input  so_taxc,
                                   output sod_tax_env)"}

      end. /* sod_tax_env = "" */
    /* ss - 090803.1 -b */
     if new_line then do :

          find first pt_mstr where pt_part = sod_part no-lock no-error .
	  if available pt_mstr then
	  /* ss - 090916.1 -b
	   assign 
	        sod_tax_usage = pt__chr02
		sod_tax_env  = pt__chr03
		sod_taxc = pt__chr04
		sod_taxable = pt__log01
		sod_tax_in = pt__log02
             ss - 090916.1 -e */
	     /* ss - 090916.1 -b */
	     	   assign 
	        sod_tax_usage = pt__chr06
		sod_tax_env  = pt__chr07
		sod_taxc = pt__chr08
		sod_taxable = pt__qad22
		sod_tax_in = pt__qad26

	     /* ss - 090916.1 -e */
		.
   
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
      end .
      else do :
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
      end .
      /* ss - 090803.1 -e */

      /* VALIDATE TAX USAGE  */
      {pxrun.i &PROC       = 'validateTaxUsage'
               &PROGRAM    = 'txenvxr.p'
               &PARAM      = "(input sod_tax_usage)"
               &NOAPPERROR = true
               &CATCHERROR = true }

      if return-value <> {&SUCCESS-RESULT}
      then do:
         next-prompt
            sod_tax_usage
         with frame set_tax.
         undo taxloop, retry .
      end. /* IF return-value <> {&SUCCESS-RESULT}  */

      tax_usage = sod_tax_usage.

      /* VALIDATE TAX ENVIRONMENT */
      /* IF BLANK - SUGGEST AGAIN */
      if sod_tax_env = "" then do:
         {pxmsg.i &MSGNUM=944 &ERRORLEVEL=3}
         /* BLANK TAX ENVIRONMENT NOT ALLOWED */
         tax_env = "".
         next-prompt sod_tax_env with frame set_tax.
         undo taxloop, retry.
      end.

      /* ELSE UNDO TAXLOOP */
      if not {gptxe.v "input sod_tax_env" ""no""}
      then do:
         {pxmsg.i &MSGNUM=869 &ERRORLEVEL=3}
         /* TAX ENVIRONMENT DOES NOT EXIST */
         next-prompt sod_tax_env with frame set_tax.
         undo taxloop, retry.
      end.
      l_loop_seta = yes.
   end. /* end of taxloop                    */
   /* ss - 090803.1 -e */
   ss - 091113.1 -e */
   hide frame set_tax.
end. /* end of if sod_taxable   */
else l_loop_seta = yes.
