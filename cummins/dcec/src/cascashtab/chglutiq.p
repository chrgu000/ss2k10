/* GUI CONVERTED from chglutiq.p (converter v1.71) Sun Oct 21 21:39:26 2007 */
/* chglutiq.p - GENERAL LEDGER UNPOSTED TRANSACTION INQUIRY - CAS             */
/* glutriq.p - GENERAL LEDGER UNPOSTED TRANSACTION INQUIRY                    */
/* Copyright 1986-2003 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.7.2.8 $                                                       */
/*V8:ConvertMode=Report                                                       */
/* REVISION: 5.0         LAST MODIFIED:  06/15/89   BY: JMS   *B066*          */
/* REVISION: 6.0         LAST MODIFIED:  07/06/90   by: jms   *D034*          */
/* REVISION: 7.0         LAST MODIFIED:  10/17/91   by: jms   *F058*          */
/*                                                     (major re-write)       */
/*                                       05/15/92   by: jms   *F506*          */
/*                                       05/27/92   by: jms   *F535* (rev)    */
/* REVISION: 7.3         LAST MODIFIED:  11/19/92   By: jcd   *G339*          */
/*                       LAST MODIFIED:  01/16/96   By: mys   *G1K3*          */
/* REVISION: 8.6         LAST MODIFIED:  06/03/96   By: ejh   *K001*          */
/*                                       04/15/97   BY: *K0BN* E. Hughart     */
/* REVISION: 8.6         LAST MODIFIED:  10/16/97   By: gyk *K120*            */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane          */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan         */
/* REVISION: 9.0      LAST MODIFIED: 03/24/99   BY: *K1ZY* Narender S         */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane   */
/* REVISION: 9.1      LAST MODIFIED: 08/08/00   BY: *N0J8* Katie Hilbert      */
/* REVISION: 9.1      LAST MODIFIED: 08/14/00   BY: *N0L1* Mark Brown         */
/* REVISION: 9.1      LAST MODIFIED: 10/31/00   BY: *N0T4* Jyoti Thatte       */
/* REVISION: 9.1      LAST MODIFIED: 10/18/00 BY: *N0VN* Mudit Mehta          */
/* REVISION: 9.1CH    LAST MODIFIED: 05/03/01   BY: *XXCH911* Charles Yen     */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* Revision: 1.7.2.7    BY: Jean Miller        DATE: 04/15/02  ECO: *P05H*    */
/* $Revision: 1.7.2.8 $   BY: Rafal Krzyminski   DATE: 04/22/03  ECO: *P0P3*  */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/* DISPLAY TITLE */

/*GUI preprocessor directive settings */
&SCOPED-DEFINE PP_GUI_CONVERT_MODE REPORT

{mfdtitle.i "1+ "}
{cxcustom.i "GLUTRIQ.P"}

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE glutriq_p_1 "帐户"
/* MaxLen: Comment: */

&SCOPED-DEFINE glutriq_p_2 "期间/年份"
/* MaxLen: Comment: */

&SCOPED-DEFINE glutriq_p_3 "未平衡帐务"
/* MaxLen: Comment: */

&SCOPED-DEFINE glutriq_p_4 "合计 "
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */

define variable ref like glt_ref.
define variable unb like glt_unb column-label "Unb Only".
define variable unb_msg as character format "x(7)".
define variable tot_amt like glt_amt label "Total".
define variable peryr as character format "x(8)" label "Period/Yr".

define variable desc1 like glt_desc format "x(13)".
/*XXCH911*define variable amt like glt_amt. */
/*XXCH911*/ define variable amt as decimal format "->>,>>>,>>9.99".
define variable batch like glt_batch.

/*CF* define variable account as character format "x(22)" label "Account". */
/*CF*/ define variable account as character format "x(18)" label "Account".
define variable curr like ac_curr.
define variable accurr like ac_curr.
define variable corr-flag like glt_det.glt_correction no-undo.
define buffer det for glt_det.
/*XXCH911*/ define var xamt as decimal format "->>,>>>,>>9.99".
/*XXCH911*/ define variable dr_cr as logical format "Dr/Cr".
/*XXCH911*/ define variable drcrtxt as char format "x(2)".
/*XXCH911*/ define variable vchr_status as char format "x(8)".

/* DISPLAY SELECTION FORM*/
{&GLUTRIQ-P-TAG1}


/*GUI preprocessor Frame A define */
&SCOPED-DEFINE PP_FRAME_NAME A

FORM /*GUI*/ 
   ref          view-as fill-in size 14 by 1   
   batch
   curr
   unb
with frame a no-underline width 80 attr-space THREE-D /*GUI*/.

/*GUI preprocessor Frame A undefine */
&UNDEFINE PP_FRAME_NAME


{&GLUTRIQ-P-TAG2}

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).
{wbrp01.i}

mainloop:
repeat:

   assign
      unb = no
      curr = base_curr.
   {&GLUTRIQ-P-TAG3}

   if c-application-mode <> 'web' then
   do:
      update ref with frame a editing:

         /* FIND NEXT/PREVIOUS RECORD */
         {mfnp.i glt_det ref  " glt_det.glt_domain = global_domain and glt_ref 
         "  ref glt_ref glt_ref}
         if recno <> ? then do:
            ref = glt_ref.
            display ref with frame a.
            recno = ?.
         end.
      end.

      /* INPUT REMAINING VARIABLES */
      if ref = "" then do:
         unb = yes.
         batch = "".
      end.

      {&GLUTRIQ-P-TAG4}
      update batch curr unb with frame a.
   end.

   {wbrp06.i &command = update &fields = "ref batch curr unb" &frm = "a"}
   {&GLUTRIQ-P-TAG5}

   if (c-application-mode <> 'web') or
      (c-application-mode = 'web' and (c-web-request begins 'data'))
   then do:
      /* CLEAR FRAMES */
      hide frame b.
      hide frame c.
      hide frame d.
      hide frame e.
      hide frame f.
   end.

   /* OUTPUT DESTINATION SELECTION */
   {gpselout.i &printType = "terminal"
               &printWidth = 80
               &pagedFlag = " "
               &stream = " "
               &appendToFile = " "
               &streamedOutputToTerminal = " "
               &withBatchOption = "no"
               &displayStatementType = 1
               &withCancelMessage = "yes"
               &pageBottomMargin = 6
               &withEmail = "yes"
               &withWinprint = "yes"
               &defineVariables = "yes"}

   /* DISPLAY INFORMATION */
   {&GLUTRIQ-P-TAG9}
   FORM /*GUI*/ 
      glt_ref
      glt_batch
      glt_effdate
/*XXCH911*   glt_date */
/*XXCH911*   glt_userid */
      tot_amt
      corr-flag
/*XXCH911*/  xglt_vchr_status
   with STREAM-IO /*GUI*/  frame b 1 down width 80 no-attr-space.
   {&GLUTRIQ-P-TAG10}

   /* SET EXTERNAL LABELS */
   setFrameLabels(frame b:handle).

   if unb = no then do:
   
      if batch = "" then do:
         {&GLUTRIQ-P-TAG6}
         for each glt_det  where glt_det.glt_domain = global_domain and  
         glt_ref >= ref
         no-lock use-index glt_ref
         break by glt_ref
         with frame c width 80 no-attr-space
         on endkey undo, leave:

            if first-of(glt_ref) then do:
               setFrameLabels(frame c:handle).
               
/*GUI*/ {mfguichk.i } /*Replace mfrpchk*/

               {glutriq1.i}
               clear frame c all.
/*XXCH921*/    {chgltiq2.i}
            end.        /*first-of */

/*XXCH921*/ {chgltiq3.i}
            {chcfupsc.i}  

         end.    /*for each */

      end.   /* batch = "" */

      else do:

         for each glt_det  where glt_det.glt_domain = global_domain and  
         glt_batch = batch and
               glt_ref >= ref no-lock
         use-index glt_batch
         break by glt_batch by glt_ref
         with frame d width 80 no-attr-space
         on endkey undo, leave:

            if first-of(glt_ref) then do:
               
/*GUI*/ {mfguichk.i } /*Replace mfrpchk*/

               setFrameLabels(frame d:handle) .
               {glutriq1.i}
               clear frame d all.
/*XXCH921*/    {chgltiq2.i}
            end.

/*XXCH921*/    {chgltiq3.i}
            {chcfupsd.i}

         end.

      end.      /* else do */

   end.    /*if unb*/

  else do:

      if batch = "" then do:
 
         for each glt_det no-lock where glt_det.glt_domain = global_domain and  
         glt_unb = yes and
               glt_ref >= ref
          use-index glt_unb
         break by glt_unb by glt_ref
         with frame e width 80 no-attr-space
         on endkey undo, leave:

            if first-of(glt_ref) then do:
               setFrameLabels(frame e:handle).
               
/*GUI*/ {mfguichk.i } /*Replace mfrpchk*/

               {glutriq1.i}
               clear frame e all.
/*XXCH921*/    {chgltiq2.i}
            end.

/*XXCH921*/    {chgltiq3.i}
               {chcfupse.i}   
  
         end.    /* for each */
    
      end.         /* batch = "" */

      else do:

         for each glt_det  where glt_det.glt_domain = global_domain and  
         glt_batch = batch and
               glt_unb = yes and
               glt_ref >= ref no-lock
         use-index glt_batch
         break by glt_batch by glt_ref
         with frame f width 80 no-attr-space
         on endkey undo, leave:

            if first-of(glt_ref) then do:
               setFrameLabels(frame f:handle).
               
/*GUI*/ {mfguichk.i } /*Replace mfrpchk*/

               {glutriq1.i}
               clear frame f all.
/*XXCH921*/    {chgltiq2.i}
            end.

/*XXCH921*/    {chgltiq3.i}
           {chcfupsf.i}

         end.    /* for each */

      end.   /* else do */

   end.    /* unb */

   {&GLUTRIQ-P-TAG7}
   /* END OF LIST MESSAGE */
   {mfreset.i}
/*GUI*/ {mfgrptrm.i} /*Report-to-Window*/

   {pxmsg.i &MSGNUM=8 &ERRORLEVEL=1}
 
end.

{wbrp04.i &frame-spec = a}
{&GLUTRIQ-P-TAG8}
