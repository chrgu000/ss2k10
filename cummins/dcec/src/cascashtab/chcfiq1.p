/* GUI CONVERTED from chcfiq1.p (converter v1.71) Sun Oct 21 21:39:25 2007 */
/* chgliq1.p - GENERAL LEDGER TRANSACTION INQUIRY -- BY ACCOUNT               */
/* gltriq1.p - GENERAL LEDGER TRANSACTION INQUIRY -- BY ACCOUNT               */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.16.3.1 $                                                          */
/*V8:ConvertMode=Report                                                       */
/* REVISION: 1.0      LAST MODIFIED: 03/06/87   BY: JMS                       */
/* REVISION: 4.0      LAST MODIFIED: 12/30/87   BY: WUG *A137*                */
/*                                 : 02/24/88   BY: JMS                       */
/*                                 : 10/31/88   by: jms *A507*                */
/* REVISION: 5.0      LAST MODIFIED: 04/03/89   by: jms *B066*                */
/*                                 : 07/10/89   by: jms *B759*                */
/* REVISION: 6.0      LAST MODIFIED: 09/04/90   by: jms *D034*                */
/*                                   01/03/91   by: jms *D287*                */
/*                                   09/20/91   by: jms *D869*                */
/* REVISION: 7.0      LAST MODIFIED: 01/24/92   by: jms *F058*                */
/*                                   05/13/92   by: jms *F488*                */
/*                                   08/24/92   by: jms *F864*                */
/*                                   09/10/92   by: jms *F881*                */
/* Revision: 7.3      Last edit:     11/19/92   By: jcd *G339*                */
/*                    LAST MODIFED:  03/10/93   by: skk *G752*                */
/* REVISION: 7.4      LAST MODIFIED: 09/07/93   BY: JJS "H159"                */
/*                           major re-write originally named gltriq3.p        */
/*                                   02/08/94   by: jjs *H279*                */
/*                           name change from gltriq3.p to gltriq1.p          */
/*                                   04/05/94   by: jjs *H316*                */
/*                                   10/10/94   by: bcm *H559*                */
/*                                   10/17/95   by: jzs *H0GG*                */
/* REVISION: 8.6      LAST MODIFIED: 12/17/96   BY: rxm *J1C8*                */
/* REVISION: 8.6      LAST MODIFIED: 10/15/97   BY: ckm *K117*                */
/* REVISION: 8.6E     LAST MODIFIED: 06/08/98   BY: Mohan CK *K1RK*           */
/* REVISION: 8.6E     LAST MODIFIED: 06/19/98   BY: *L01J* Mansour Kazemi     */
/* REVISION: 8.6E     LAST MODIFIED: 07/30/98   BY: *L05B* Brenda Milton      */
/* REVISION: 8.6E     LAST MODIFIED: 02/02/99   BY: *J398* Prashanth Narayan  */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane   */
/* REVISION: 9.1      LAST MODIFIED: 08/14/00   BY: *N0L1* Mark Brown         */
/* REVISION: 9.1      LAST MODIFIED: 09/22/00   BY: *N0VY* BalbeerS Rajput    */
/* REVISION: 9.1      LAST MODIFIED: 01/31/01   BY: *M111* Jose Alex          */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* Revision: 1.16     BY: Jean Miller           DATE: 04/25/02   ECO: *P05V*  */
/* $Revision: 1.16.3.1 $  BY: Ajay Nair             DATE: 11/05/04   ECO: *P2ST*  */
/* $Revision: 9.2     LAST MODIFIED: 10/13/07   BY: Leo Zhou   ECO: *CLZ1*  */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/


/*GUI preprocessor directive settings */
&SCOPED-DEFINE PP_GUI_CONVERT_MODE REPORT

{mfdtitle.i "2+ "}

{gliq1def.i "new"}  /* DEFINE SHARED VARIABLES */

define variable entity like en_entity no-undo.
define variable mc-error-number like msg_nbr no-undo.
define variable eff_dt like gltr_eff_dt no-undo.   /*CLZ1*/
define variable eff_dt1 like gltr_eff_dt no-undo.  /*CLZ1*/

/* New combined FRAME A with extended criteria */

/*GUI preprocessor Frame A define */
&SCOPED-DEFINE PP_FRAME_NAME A

FORM /*GUI*/ 
   
 RECT-FRAME       AT ROW 1 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1 COLUMN 3 NO-LABEL VIEW-AS TEXT SIZE-PIXELS 1 BY 1
 SKIP(.1)  /*GUI*/
entity        colon 34 space(3) acct
   eff_dt        colon 30 space(3) eff_dt1 label "To"     /*CLZ1*/
   with frame a side-labels attr-space width 80 NO-BOX THREE-D /*GUI*/.

 DEFINE VARIABLE F-a-title AS CHARACTER INITIAL "".
 RECT-FRAME-LABEL:SCREEN-VALUE in frame a = F-a-title.
 RECT-FRAME-LABEL:HIDDEN in frame a = yes.
 RECT-FRAME:HEIGHT-PIXELS in frame a =
  FRAME a:HEIGHT-PIXELS - RECT-FRAME:Y in frame a - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME a = FRAME a:WIDTH-CHARS - .5.  /*GUI*/

/*GUI preprocessor Frame A undefine */
&UNDEFINE PP_FRAME_NAME



/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

/* SET INITIAL DEFAULTS */
entity = glentity.

{wbrp01.i}

eff_dt1 = date(month(today),1,year(today)) - 1.   /*CLZ1*/
eff_dt  = date(month(eff_dt1),1,year(eff_dt1)).   /*CLZ1*/

mainloop:
repeat:

      
   if eff_dt = low_date then eff_dt = ?.  /*CLZ1*/
   if eff_dt1 = hi_date then eff_dt = ?.  /*CLZ1*/

   if c-application-mode <> 'web' then
   update
      entity
      acct
      eff_dt   /*CLZ1*/
      eff_dt1  /*CLZ1*/
        with frame a
   editing:

      if frame-field = "entity" then do:
/*21*/ {mfnp.i en_mstr entity "en_mstr.en_domain = global_domain and en_entity" entity en_entity en_entity}      
         if recno <> ? then
            display en_entity @ entity with frame a.
      end.

      else if frame-field = "acct" then do:
/*21*/  {mfnp01.i ac_mstr acct ac_code true " ac_mstr.ac_domain = global_domain and ac_active "
ac_active}
         if recno <> ? then
               display ac_code @ acct with frame a.
      end.

      else do:
         readkey.
         apply lastkey.
      end.

   end.  /* FRAME A EDITING */

   {wbrp06.i &command = update &fields = "entity acct eff_dt eff_dt1" &frm = "a"}  /*CLZ1*/

   if eff_dt  = ? then eff_dt = low_date.  /*CLZ1*/
   if eff_dt1 = ? then eff_dt = hi_date.   /*CLZ1*/

   if (c-application-mode <> 'web') or
      (c-application-mode = 'web' and
      (c-web-request begins 'data'))
   then do:
     
      /* VALIDATIONS */
/*21*/   
   find en_mstr where en_entity = entity and en_domain = global_domain no-lock no-error.
      if not available en_mstr then do:
         {pxmsg.i &MSGNUM=3061 &ERRORLEVEL=3}  /* INVALID ENTITY */
         if c-application-mode = 'web' then return.
         undo mainloop, retry.
      end.

/*21*/     
     find ac_mstr where ac_code = acct and ac_domain = global_domain no-lock no-error.
      if not available ac_mstr then do:
         {pxmsg.i &MSGNUM=3052 &ERRORLEVEL=3}  /* INVALID ACCOUNT CODE */
         if c-application-mode = 'web' then return.
         else  next-prompt acct with frame a.
         undo mainloop, retry.
      end.

   end.  /* if (c-application-mode <> 'web') ... */

   iq_title = en_name + "    " + ac_code + "-" + ac_desc.

/*
   /* SELECT OUTPUT DEVICE */
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

   output_dev = path.
*/

             /* SELECT PRINTER */
             {mfselprt.i "printer" 132}
/*GUI*/ RECT-FRAME:HEIGHT-PIXELS in frame a = FRAME a:HEIGHT-PIXELS - RECT-FRAME:Y in frame a - 2.


             {mfphead.i}

   hide frame a.

   /* DISPLAY JOURNAL LINES AND CURRENCY TOTALS */
   for each xcftr_hist where xcftr_acct = acct 
                         and xcftr_entity = entity
                         and xcftr_ref <> "cashflowinitial"
                         and xcftr_domain = global_domain
                             no-lock with frame b:
   /**CLZ1 Add Begin**/
   find first gltr_hist where gltr_domain = xcftr_domain
          and gltr_ref = xcftr_ref and gltr_eff_dt >= eff_dt
	  and gltr_eff_dt <= eff_dt1 no-lock no-error.

   if not avail gltr_hist then next.
   /**CLZ1 Add End**/

   FORM /*GUI*/  xcftr_ref xcftr_glt_line xcftr_ac_code xcftr_curr_amt 
       xcftr_amt format "->>,>>>,>>>,>>9.99"
with STREAM-IO /*GUI*/  frame b.
/* SET EXTERNAL LABELS */
setFrameLabels(frame b:handle).

   display xcftr_ref xcftr_glt_line xcftr_ac_code xcftr_sub xcftr_cc xcftr_pro xcftr_curr_amt xcftr_amt
   with frame b width 180 STREAM-IO /*GUI*/ .

   end.  

         if c-application-mode <> 'web':u then
            pause before-hide.

   /* RESET OUTPUT DEVICE */
   {mfreset.i}
/*GUI*/ {mfgrptrm.i} /*Report-to-Window*/


end. /* MAINLOOP */

{wbrp04.i  &frame-spec = a}


