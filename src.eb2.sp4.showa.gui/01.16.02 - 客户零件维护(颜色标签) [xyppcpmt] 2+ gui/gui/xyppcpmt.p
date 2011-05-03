/* GUI CONVERTED from ppcpmt.p (converter v1.77) Thu Aug 28 22:44:56 2003 */
/* ppcpmt.p - CUSTOMER PART MAINTENANCE                                 */
/* Copyright 1986-2003 QAD Inc., Carpinteria, CA, USA.                  */
/* All rights reserved worldwide.  This is an unpublished work.         */
/* $Revision: 1.7.1.8.4.1 $          */
/*V8:ConvertMode=Maintenance                                            */
/* REVISION: 4.0      LAST MODIFIED: 01/08/88   BY: RL  *A136*          */
/* REVISION: 5.0      LAST MODIFIED: 10/31/89   BY: pml *B372*          */
/* REVISION: 5.0      LAST MODIFIED: 01/24/90   BY: ftb *B532*          */
/* REVISION: 7.0      LAST MODIFIED: 11/16/91   BY: pml *F048*          */
/* REVISION: 7.3      LAST MODIFIED: 03/18/93   BY: WUG *G845*          */
/* REVISION: 7.3      LAST MODIFIED: 06/07/93   BY: WUG *GB78*          */
/* REVISION: 7.3      LAST MODIFIED: 06/17/93   BY: cdt *GC36*          */
/* REVISION: 7.3      LAST MODIFIED: 06/04/94   BY: pxd *FO62*          */
/* REVISION: 7.3      LAST MODIFIED: 05/04/95   BY: qzl *G0M2*          */
/* REVISION: 7.3      LAST MODIFIED: 07/14/95   BY: bcm *F0T8*          */
/* REVISION: 7.3      LAST MODIFIED: 06/10/96   BY: tzp *G1XV*          */
/* REVISION: 7.3      LAST MODIFIED: 06/26/97   BY: *G2NQ* Ajit Deodhar */

/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane    */
/* REVISION: 8.6E     LAST MODIFIED: 03/24/98   BY: *J2FG* Niranjan R.  */
/* REVISION: 8.6E     LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan   */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan   */
/* REVISION: 9.1      LAST MODIFIED: 11/04/98   BY: *N057* Surekha Joshi*/
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane */
/* REVISION: 9.1      LAST MODIFIED: 04/17/00   BY: *N099* Reetu Kapoor */
/* REVISION: 9.1      LAST MODIFIED: 04/27/00   BY: *N09N* Sandeep Rao  */
/* REVISION: 9.1      LAST MODIFIED: 08/13/00   BY: *N0KQ* myb              */
/* Old ECO marker removed, but no ECO header exists *F0PN*               */
/* Old ECO marker removed, but no ECO header exists *M0P0*               */
/* Revision: 1.7.1.8     BY: Anil Sudhakaran  DATE: 04/09/01 ECO: *M0P0*    */
/* $Revision: 1.7.1.8.4.1 $    BY: Deepali KotavadekarDATE: 08/28/03 ECO: *P11Q*  */
/* BY: Micho Yang          DATE: 01/02/07  ECO: *SS - 20080102.1* */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/* SS - 20080102.1 - B */
/* 新增 cp_user1 ：用于存放客户零件对应的颜色信息
*/                                                                         
/* SS - 20080102.1 - E */                                                                    
                                                                    
/* DISPLAY TITLE */
{mfdtitle.i "2+ "}

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE ppcpmt_p_1 "Customer/Ship-to"
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */

/* REINSTATED NO-VALIDATE IN PROMPT-FOR STATEMENT; ADDED VALIDATE    */
/* STATEMENT IN FORM FOR cp_cust_part. BOTH IMPLY THAT NO VALIDATION */
/* IS REQUIRED FOR cp_cust_part FIELD.                               */

define variable del-yn like mfc_logical initial no.

/* Variable added to perform delete during CIM.
* Record is deleted only when the value of this variable
* Is set to "X" */
define variable batchdelete as character format "x(1)" no-undo.

/* DISPLAY SELECTION FORM */

/*GUI preprocessor Frame A define */
&SCOPED-DEFINE PP_FRAME_NAME A

FORM /*GUI*/ 
   
 RECT-FRAME       AT ROW 1 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1 COLUMN 3 NO-LABEL VIEW-AS TEXT SIZE-PIXELS 1 BY 1
 SKIP(.1)  /*GUI*/
cp_cust        colon 25      label {&ppcpmt_p_1}
   validate(true,"")
   space(10)
   ad_name        no-label
   cp_cust_part   colon 25
   validate(true,"")
   skip(1)
   cp_part        colon 25
   pt_desc1 at 50 no-label
   cp_comment     colon 25
   cp_cust_partd  colon 25
   cp_cust_eco    colon 25
   /* SS - 20080102.1 - B */
   cp_user1       COLON 25 LABEL "机种颜色"
   /* SS - 20080102.1 - E */
 SKIP(.4)  /*GUI*/
with frame a side-labels width 80 attr-space NO-BOX THREE-D /*GUI*/.

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

for first soc_ctrl fields (soc__qadl02) no-lock:
end. /* FOR FIRST SOC_CTRL  */

/* DISPLAY */
view frame a.
mainloop:
repeat with frame a:
/*GUI*/ if global-beam-me-up then undo, leave.


   /* Initialize delete flag before each display of frame */
   batchdelete = "".

   /* Prompt for the delete variable in the key frame at the
   * End of the key field/s only when batchrun is set to yes */
   prompt-for
      cp_cust
      cp_cust_part
      batchdelete no-label when (batchrun)

   with no-validate
   editing:
      if frame-field = "cp_cust"
      then do:

         /* FIND NEXT/PREVIOUS RECORD */
         {mfnp.i cp_mstr cp_cust cp_cust cp_cust_part cp_cust_part
            cp_cust}

      end. /* IF FRAME-FIELD = "cp_cust" */

      if frame-field = "cp_cust_part"
      then do:

         /* FIND NEXT/PREVIOUS RECORD */
         {mfnp05.i cp_mstr cp_cust "cp_cust = input cp_cust"
            cp_cust_part "input cp_cust_part"}

      end. /* IF FRAME-FIELD = "cp_cust_part" */

      global_addr = input cp_cust.

      if recno <> ?
      then do:

         display
            cp_cust
            cp_cust_part
            cp_part
            cp_comment.

         display
            cp_cust_partd
            cp_cust_eco
            /* SS - 20080102.1 - B */
            cp_user1     
            /* SS - 20080102.1 - E */
              .

         find pt_mstr
            where pt_part = cp_part
            no-lock no-error.

         display pt_desc1 when (available pt_mstr).

      end. /* IF recno <> ? THEN DO: */
   end. /* EDITING: */

   if input cp_cust <> "" then do:
      find ad_mstr where ad_addr = input cp_cust no-lock no-error.
      if available ad_mstr then do:
         display ad_name.
      end. /* if available ad_mstr then do: */
      else do:
         {pxmsg.i &MSGNUM=13 &ERRORLEVEL=3}
         undo mainloop, retry.
      end. /* else do: */

      /* ALLOWING ONLY VALID CUSTOMER/SHIP-TO/DOCK OR BLANK */
      /* AS CUSTOMER/SHIP-TO VALUES                         */

      if can-find (first ls_mstr
         where  ls_addr = input cp_cust
         and (ls_type = "customer"
         or   ls_type = "ship-to"
         or   ls_type = "dock")) then .
      else
         do:
         /* NOT A VALID CHOICE */
         {pxmsg.i &MSGNUM=13 &ERRORLEVEL=3}
         undo mainloop, retry.
      end. /* ElSE DO */

   end. /* if input cp_cust <> "" then do: */

   if length(input cp_cust_part) > 18 then do:
      {pxmsg.i &MSGNUM=8509 &ERRORLEVEL=2}
      /* Maximum Customer Item length is 18 characters for Sales Orders */
   end. /* if length(input cp_cust_part) > 18 then do: */

   /* ADD/MOD/DELETE  */
   find first cp_mstr where cp_cust = input cp_cust and
      cp_cust_part = input cp_cust_part no-error.
   if not available cp_mstr then do:
      {pxmsg.i &MSGNUM=1 &ERRORLEVEL=1}
      create cp_mstr.
      assign cp_cust_part
         cp_cust.
      find pt_mstr where pt_part = input frame a cp_cust_part
         no-lock no-error.
      if available pt_mstr then
         cp_part = pt_part.
      else
         cp_part = "".
      cp_comment = "".
   end. /* if not available cp_mstr then do: */

   /* STORE MODIFY DATE AND USERID */
   cp_mod_date = today.
   cp_userid = global_userid.

   display cp_part cp_comment.
   display cp_cust_part cp_cust_partd cp_cust_eco
                       /* SS - 20080102.1 - B */
            cp_user1     
            /* SS - 20080102.1 - E */
            .
   recno = recid(cp_mstr).

   ststatus = stline[2].
   status input ststatus.
   del-yn = no.

   seta:
   do on error undo, retry:
/*GUI*/ if global-beam-me-up then undo, leave.

      set cp_part cp_comment cp_cust_partd cp_cust_eco
                      /* SS - 20080102.1 - B */
            cp_user1     
            /* SS - 20080102.1 - E */
         go-on("F5" "CTRL-D" ).
      find pt_mstr no-lock where pt_part = cp_part no-error.
      display pt_desc1 when (available pt_mstr).

      /* DELETE */
      /* Delete to be executed if batchdelete is set or
      * F5 or CTRL-D pressed */
      if lastkey = keycode("F5") or lastkey = keycode("CTRL-D")
         or input batchdelete = "x"
      then do:
         del-yn = yes.
         {mfmsg01.i 11 1 del-yn}
         if not del-yn then undo seta.
      end. /* then do: */

      if del-yn then do:
         delete cp_mstr.
         clear frame a.
/*GUI*/ RECT-FRAME-LABEL:SCREEN-VALUE in frame a = F-a-title.
         del-yn = no.
         next mainloop.
      end. /* if del-yn then do: */
      else do:
         global_part = cp_part.
      end. /* else do: */

      /* VALIDATE THE CUSTOMER ITEM AGAINST ITEM MASTER ONLY IF   */
      /* THE SEARCH FOR CUSTOMER ITEM FIRST BEFORE INVENTORY ITEM */
      /* FLAG IS SET TO NO IN THE SALES ORDER CONTROL FILE.       */

      if not available soc_ctrl or not soc__qadl02 then do:
         /* CUSTOMER ITEM AND ITEM NUMBER MUST BE THE SAME */
         /* WHEN CUSTOMER ITEM IS STOCK ITEM */
         find pt_mstr where pt_part = cp_cust_part no-lock no-error.
         if available pt_mstr then do:
            if cp_cust_part <> cp_part then do:
               /* STANDARD ITEM PRESENT FOR THIS CUSTOMER ITEM */
               {pxmsg.i &MSGNUM=7266 &ERRORLEVEL=3}
               next-prompt cp_part with frame a.
               undo seta, retry.
            end. /* IF CP_CUST_PART <> CP_PART */
         end. /* IF AVAILABLE PT_MSTR */
      end. /* IF NOT SOD__QADL02 */

      /* VALIDATE ITEM NUMBER. DISPLAY ERROR, AND REPROMPT IF IT DOES NOT EXIST */
      find pt_mstr where pt_part = cp_part no-lock no-error.
      if not available pt_mstr then do:
         {pxmsg.i &MSGNUM=16 &ERRORLEVEL=3}
         /* Item Number does not exist */
         next-prompt cp_part with frame a.
         undo seta, retry.
      end. /* if not available pt_mstr then do: */

   end.
/*GUI*/ if global-beam-me-up then undo, leave.
 /* do on error undo, retry: */
end.
/*GUI*/ if global-beam-me-up then undo, leave.
 /* repeat with frame a: */
status input.
