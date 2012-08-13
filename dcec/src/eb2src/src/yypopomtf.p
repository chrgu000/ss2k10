/* popomtf.p - PURCHASE ORDER MAINTENANCE TRAILER                             */
/* Copyright 1986-2003 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.11.2.19 $                                                               */
/*                                                                            */
/* Revision: 5.1  BY:WUG                  DATE:10/21/88           ECO: *A494* */
/* Revision: 4.0  BY:FLM                  DATE:03/24/89           ECO: *A685* */
/* Revision: 5.0  BY:MLB                  DATE:08/28/89           ECO: *B324* */
/* Revision: 5.0  BY:MLB                  DATE:10/27/89           ECO: *B324* */
/* Revision: 5.0  BY:EMB                  DATE:02/27/90           ECO: *B591* */
/* Revision: 6.0  BY:EMB                  DATE:07/06/90           ECO: *D040* */
/* Revision: 6.0  BY:SVG                  DATE:08/14/90           ECO: *D058* */
/* Revision: 6.0  BY:MLB                  DATE:09/18/90           ECO: *D055* */
/* Revision: 6.0  BY:MLB                  DATE:01/02/90           ECO: *D238* */
/* Revision: 6.0  BY:MLV                  DATE:04/26/91           ECO: *D559* */
/* Revision: 6.0  BY:RAM                  DATE:11/15/91           ECO: *D952* */
/* Revision: 7.0  BY:RAM                  DATE:03/09/92           ECO: *F272* */
/* Revision: 7.0  BY:JJS                  DATE:06/24/92           ECO: *F681* */
/* Revision: 7.3  BY:tjs                  DATE:08/18/92           ECO: *G028* */
/* Revision: 7.3  BY:mpp                  DATE:10/02/92           ECO: *G012* */
/* Revision: 7.3  BY:bcm                  DATE:01/08/93           ECO: *G417* */
/* Revision: 7.3  BY:afs                  DATE:02/11/93           ECO: *G674* */
/* Revision: 7.3  BY:tjs                  DATE:02/23/93           ECO: *G728* */
/* Revision: 7.4  BY:jjs                  DATE:06/22/93           ECO: *H006* */
/* Revision: 7.4  BY:tjs                  DATE:08/12/93           ECO: *H065* */
/* Revision: 7.4  BY:afs                  DATE:10/07/93           ECO: *H162* */
/* Revision: 7.4  BY:bcm                  DATE:04/11/94           ECO: *H334* */
/* Revision: 7.4  BY:qzl                  DATE:06/21/94           ECO: *H397* */
/* Oracle changes (share-locks) BY: rwl   DATE:09/12/94           ECO: *GM41* */
/* Revision: 7.4  BY:jpm                  DATE:09/20/94           ECO: *GM74* */
/* Revision: 7.4  BY:ljm                  DATE:11/06/94           ECO: *GO15* */
/* Revision: 7.4  BY:rxm                  DATE:07/19/95           ECO: *G0QG* */
/* Revision: 7.4  BY:ais                  DATE:09/19/95           ECO: *G0X6* */
/* Revision: 7.4  BY:dxk                  DATE:10/18/95           ECO: *G0XK* */
/* Revision: 8.5  BY:ccc                  DATE:09/18/95           ECO: *J053* */
/* Revision: 8.5  BY:rxm                  DATE:02/14/96           ECO: *H0JJ* */
/* Revision: 8.5  BY:Sue Poland           DATE:05/01/96           ECO: *J04C* */
/* Revision: 8.6  BY:Terry Magovern       DATE:08/05/96           ECO: *K004* */
/* Revision: 8.6E BY:A. Rahane            DATE:02/23/98           ECO: *L007* */
/* Revision: 8.6E BY:Alfred Tan           DATE:05/20/98           ECO: *K1Q4* */
/* Revision: 8.6E BY:Dana Tunstall        DATE:06/01/98           ECO: *J2NJ* */
/* Old ECO marker removed, but no ECO header exists               ECO: *F0PN* */
/* Revision: 8.6E BY:Charles Yen          DATE:06/11/98           ECO: *L020* */
/* Revision: 8.6E BY:Steve Goeke          DATE:07/29/98           ECO: *L053* */
/* Revision: 9.1  BY:Santosh Rao          DATE:05/28/99           ECO: *J3G1* */
/* Revision: 9.1  BY:Patti Gaultney       DATE:10/01/99           ECO: *N014* */
/* Revision: 9.1  BY:Reetu Kapoor         DATE:10/07/99           ECO: *J39R* */
/* Revision: 9.1  BY:Vijaya Pakala        DATE:01/19/00           ECO: *N077* */
/* REVISION: 9.1  BY:Annasaheb Rahane     DATE:03/24/00           ECO: *N08T* */
/* REVISION: 9.1  BY:Manish K.            DATE:04/20/00           ECO: *L0WK* */
/* REVISION: 9.1  BY:Kedar Deherkar       DATE:04/24/00           ECO: *L0WT* */
/* REVISION: 9.1  BY:Abhijeet Thakur      DATE:05/11/00           ECO: *L0XN* */
/* Revision: 1.11.2.11   BY:Jeff Wootton          DATE:02/16/00   ECO: *N059* */
/* Revision: 1.11.2.12   BY:Reetu Kapoor          DATE:11/06/00   ECO: *M0VY* */
/* Revision: 1.11.2.13   BY: Katie Hilbert        DATE: 04/01/01  ECO: *P002* */
/* Revision: 1.11.2.14   BY: Rajesh Kini          DATE: 04/12/01  ECO: *M158* */
/* Revision: 1.11.2.15   BY: Manisha Sawant       DATE: 07/30/01  ECO: *M1FV* */
/* Revision: 1.11.2.15.1.1  BY: Laurene Sheridan  DATE: 10/17/02  ECO: *N13P* */
/* Revision: 1.11.2.18   BY: Rajiv Ramaiah        DATE: 01/21/03  ECO: *N24Q* */
/* $Revision: 1.11.2.19 $          BY: Shilpa Athalye       DATE: 05/28/03  ECO: *N2G4* */
/******************************************************************************/
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
/*                                                                            */
/*V8:ConvertMode=Maintenance                                                  */

{mfdeclre.i}
{gplabel.i} /* EXTERNAL LABEL INCLUDE */
{pxmaint.i}

{pxphdef.i popoxr}

/* NEW SHARED VARIABLES */
define new shared variable pod_recno as recid.

/* SHARED VARIABLES */
define shared variable po_recno     as recid.
define shared variable line_opened  as logical.
define shared variable rndmthd      like rnd_rnd_mthd.
define shared variable new_po       like mfc_logical.
define shared variable old_rev      like po_rev.
define shared variable comment_type like po_lang.
define shared variable old_po_stat  like po_stat.
define shared variable blanket      like mfc_logical.

/* LOCAL VARIABLES */
define variable mc-error-number like msg_nbr     no-undo.
define variable valid_acct      like mfc_logical.
define variable reopenLines     like mfc_logical no-undo.
define variable old_ap_acct     like po_ap_acct no-undo.
define variable old_ap_sub      like po_ap_sub no-undo.
define variable old_ap_cc       like po_ap_cc no-undo.

/* DEFINE CURRENCY DEPENDENT ROUNDING VARIABLES */
{pocurvar.i}
{txcurvar.i}

/* DEFINE PO TRAILER VARIABLES */
{potrldef.i }

if c-application-mode = "API"
then do on error undo,return error:

   /* COMMON API CONSTANTS AND VARIABLES */
   {mfaimfg.i}

   /* PURCHASE ORDER API TEMP-TABLE, NAMED USING THE "Api" PREFIX */
   {popoit01.i}


   /* GET HANDLE OF API CONTROLLER */
   {gprun.i ""gpaigh.p""
             "(output ApiMethodHandle,
               output ApiProgramName,
               output ApiMethodName,
               output apiContextString)"}
   /* GET LOCAL PO MASTER TEMP-TABLE */
   create ttPurchaseOrder.
   run getPurchaseOrderRecord in ApiMethodHandle
            (buffer ttPurchaseOrder).

end.  /* If c-application-mode = "API" */

/* DISPLAY SELECTION FORM */
/*GUI preprocessor Frame A define */
&SCOPED-DEFINE PP_FRAME_NAME A

form
RECT-FRAME       AT ROW 1 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1 COLUMN 3 NO-LABEL VIEW-AS TEXT SIZE-PIXELS 1 BY 1
 SKIP(.1)  /*GUI*/
   po_nbr
   po_vend
   po_ship
   SKIP(.4)  /*GUI*/
with frame a attr-space
   side-labels width 80 NO-BOX THREE-D /*GUI*/.

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

/*V8-*/
do transaction on error undo, retry:

   /*V8+*/
   /*V8!
   do transaction on error undo, retry
   on endkey undo, leave:  */

   /* DO NOT RETRY WHEN PROCESSING API REQUEST */
   if retry and c-application-mode = "API" then
      undo , return error.
   for first po_mstr where recid(po_mstr) = po_recno:
   end.

   undo_trl2 = true.
   /* CALCULATE, DISPLAY, AND EDIT TAXES */
 /*tfq  {gprun.i ""pomttrld.p""}  */
 /*tfq*/ {gprun.i ""yypomttrld.p""}
   if undo_trl2 then
      return.

   {pxrun.i &PROC='getEdiPo' &PROGRAM='popoxr.p'
            &PARAM="(input po_inv_mthd,
                     output edi_po)"
            &NOAPPERROR=TRUE &CATCHERROR=TRUE
   }

   /* po_stat IS ASSIGNED WITH "C" WHEN ALL LINES  */
   /* IN pod_det.pod_status ARE EITHER "X" or "C". */

   po_stat = if not (can-find(first pod_det
                              where pod_nbr    = po_nbr
                                and pod_status = " "))
             then
                "c"
             else
                po_stat.

   if c-application-mode <> "API" then
      display
         po_rev
         po_print
         po_ap_acct
         po_ap_sub
         po_ap_cc
         po_shipvia
         po_del_to
         po_prepaid po_stat po_cls_date po_fob
         edi_po
      with frame pomtd.

   settrl:
   do on error undo, retry:
      /* DO NOT RETRY WHEN PROCESSING API REQUEST */
      if retry and c-application-mode = "API" then
         undo, return error.
      assign
         old_ap_acct = po_ap_acct
         old_ap_sub  = po_ap_sub
         old_ap_cc   = po_ap_cc.

      if c-application-mode <> "API" then
         set po_rev
            po_print
            edi_po
            po_ap_acct
            po_ap_sub
            po_ap_cc
            po_del_to
            po_prepaid
            po_stat when (not po_sched)
            po_fob
            po_shipvia
         with frame pomtd no-validate.
      else
         assign
         {mfaiset.i po_rev ttPurchaseOrder.rev}
         {mfaiset.i po_print ttPurchaseOrder.print}
         {mfaiset.i po_ap_acct ttPurchaseOrder.apAcct}
         {mfaiset.i po_ap_cc ttPurchaseOrder.apCc}
         {mfaiset.i po_ap_sub ttPurchaseOrder.apSub}
         {mfaiset.i po_del_to ttPurchaseOrder.delTo}
         {mfaiset.i po_prepaid ttPurchaseOrder.prepaid}
         {mfaiset.i po_stat ttPurchaseOrder.stat}
         {mfaiset.i po_fob ttPurchaseOrder.fob}
         {mfaiset.i po_shipvia ttPurchaseOrder.shipvia}.


      /* CHECKS FOR ACCESS ON PO AP ACCOUNT */
      if po_ap_acct <> old_ap_acct
      then do:
         {pxrun.i &PROC='validatePOAcctPayAcct' &PROGRAM='popoxr.p'
                  &PARAM="(input po_ap_acct)"
                  &NOAPPERROR=true
                  &CATCHERROR=true
         }

         if return-value <> {&SUCCESS-RESULT}
         then do:
            if c-application-mode <> "API"
            then do:
               next-prompt po_ap_acct with frame pomtd no-validate.
               undo settrl, retry settrl.
            end. /* if c-application-mode <> "API" */
            else /* if c-application-mode = "API" */
               undo settrl, return error.
         end.
      end. /* IF po_ap_acct <> old_ap_acct */

      /* CHECKS FOR ACCESS ON PO AP SUB ACCOUNT */
      if po_ap_sub <> old_ap_sub
      then do:
         {pxrun.i &PROC='validatePOAPSubAcct' &PROGRAM='popoxr.p'
                  &PARAM="(input po_ap_sub)"
                  &NOAPPERROR=true
                  &CATCHERROR=true
         }

         if return-value <> {&SUCCESS-RESULT}
         then do:
            if c-application-mode <> "API"
            then do:
               next-prompt po_ap_sub with frame pomtd no-validate.
               undo settrl, retry settrl.
            end. /* if c-application-mode <> "API" */
            else /* if c-application-mode = "API" */
               undo settrl, return error.
         end.
      end. /* IF po_ap_sub <> old_ap_sub */

      /* CHECKS FOR ACCESS ON PO AP COST CENTER */
      if po_ap_cc <> old_ap_cc
      then do:
         {pxrun.i &PROC='validatePOAcctPayCC' &PROGRAM='popoxr.p'
                  &PARAM="(input po_ap_cc)"
                  &NOAPPERROR=true
                  &CATCHERROR=true
         }

         if return-value <> {&SUCCESS-RESULT}
         then do:
            if c-application-mode <> "API"
            then do:
               next-prompt po_ap_cc with frame pomtd no-validate.
               undo settrl, retry settrl.
            end. /* if c-application-mode <> "API" */
            else /* if c-application-mode = "API" */
               undo settrl, return error.
         end.
      end. /* IF po_ap_cc <> old_ap_cc */

      /* VALIDATES PO STATUS */
      {pxrun.i &PROC='validatePOStatus' &PROGRAM='popoxr.p'
               &PARAM="(input po_stat)"
               &NOAPPERROR=true
               &CATCHERROR=true
      }

      if return-value <> {&SUCCESS-RESULT}
      then do:
         if c-application-mode <> "API"
         then do:
            next-prompt po_stat with frame pomtd no-validate.
            undo settrl, retry settrl.
         end. /* if c-application-mode <> "API" */
         else /* if c-application-mode = "API" */
            undo settrl, return error.
      end.  /* if return-value <> {&SUCCESS-RESULT} then do: */

      /* VALIDATES PO FOB */
      {pxrun.i &PROC='validatePOFob' &PROGRAM='popoxr.p'
               &PARAM="(input po_fob)"
               &NOAPPERROR=true
               &CATCHERROR=true
      }

      if return-value <> {&SUCCESS-RESULT}
      then do:
         if c-application-mode <> "API"
         then do:
            next-prompt po_fob with frame pomtd no-validate.
            undo settrl, retry settrl.
         end. /* if c-application-mode <> "API" */
         else /* if c-application-mode = "API" */
            undo settrl, return error.
      end.

      /* VALIDATES PO SHIP VIA */
      {pxrun.i &PROC='validatePOShipVia' &PROGRAM='popoxr.p'
               &PARAM="(input po_shipvia)"
               &NOAPPERROR=true
               &CATCHERROR=true
      }

      if return-value <> {&SUCCESS-RESULT}
      then do:
         if c-application-mode <> "API"
         then do:
            next-prompt po_shipvia with frame pomtd no-validate.
            undo settrl, retry settrl.
         end. /* if c-application-mode <> "API" */
         else /* if c-application-mode = "API" */
            undo settrl, return error.
      end.

      {pxrun.i &PROC='validateAccount' &PROGRAM='glacxr.p'
               &PARAM="(input po_ap_acct,
                        input po_ap_sub,
                        input po_ap_cc)"
               &NOAPPERROR=true &CATCHERROR=true
      }
      if return-value <> {&SUCCESS-RESULT}
      then do:
         if c-application-mode <> "API"
         then do:
            next-prompt po_ap_acct with frame pomtd.
            undo settrl, retry.
         end. /* if c-application-mode <> "API" */
         else /* if c-application-mode = "API" */
            undo settrl, return error.
      end.

      /* TO TEST FOR EURO TRANSPARENCY -                 */
      /* ADDED FOURTH INPUT PARAMETER po_ord_date        */
      /* ADDED FIFTH INPUT PARAMETER AS A LOGICAL FIELD  */
      /* THE FIFTH PARAMETER WILL BE TRUE ONLY IF THE    */
      /* CALL TO popoxr.p IS MADE FROM popomtf.p.        */

      /* ACCOUNT CURRENCY MUST MATCH BASE OR TRANSACTION CURRENCY */

      {pxrun.i &PROC='validateAccountCurrency' &PROGRAM='popoxr.p'
               &HANDLE=ph_popoxr
               &PARAM="(input po_ap_acct,
                        input po_curr,
                        input base_curr,
                        input po_ord_date,
                        input true)"
               &NOAPPERROR=TRUE &CATCHERROR=TRUE
      }

      if return-value <> {&SUCCESS-RESULT}
      then do:
         if c-application-mode <> "API"
         then do:
            next-prompt po_ap_acct with frame pomtd.
            undo settrl, retry settrl.
         end. /* if c-application-mode <> "API" */
         else /* if c-application-mode = "API" */
            undo settrl, return error.
      end.

      /* ADDED THIRD INPUT PARAMETER PO SITE AS '*' */
      /* AND FOURTH INPUT PARAMETER PO LINE AS 0    */
     /*tfq {pxrun.i &PROC='validateShipperExists' &PROGRAM='popoxr.p'
               &PARAM="(input po_stat,
                        input po_nbr,
                        input '*',
                        input 0)"
               &NOAPPERROR=true
               &CATCHERROR=true
      } */
       /*tfq*/ {pxrun.i &PROC='validateShipperExists' &PROGRAM='yypopoxr.p'
               &PARAM="(input po_stat,
                        input po_nbr,
                        input '*',
                        input 0)"
               &NOAPPERROR=true
               &CATCHERROR=true
      }

      if return-value <> {&SUCCESS-RESULT}
      then do:
         /* DO NOT ALLOW TO DELETE ORDER LINE, IF UNCONFIRMED */
         /* SHIPPER EXISTS                                    */
         if c-application-mode <> "API"
         then do:
            next-prompt po_stat with frame pomtd.
            undo settrl, retry.
         end. /* if c-application-mode <> "API" */
         else /* if c-application-mode = "API" */
            undo settrl, return error.
      end.  /* if return-value <> {&SUCCESS-RESULT} then do: */

      /* VALIDATE PREPAID AMOUNT */
      {pxrun.i &PROC='validatePrepaid' &PROGRAM='popoxr.p'
               &PARAM="(input po_prepaid,
                        input rndmthd)"
               &NOAPPERROR=true
               &CATCHERROR=true
      }
      if return-value <> {&SUCCESS-RESULT}
      then do:
         if c-application-mode <> "API"
         then do:
            next-prompt po_prepaid with frame pomtd.
            undo settrl, retry.
         end. /* if c-application-mode <> "API" */
         else /* if c-application-mode = "API" */
            undo settrl, return error.
      end.
      /* UPDATING PO_INV_MTHD TO STORE ITS VALUE WHEN A NEW PO IS */
      /* CREATED OR AN EXISTING PO IS ACCESSED                    */
      {pxrun.i &PROC='getInvoiceMethod'
               &PROGRAM='popoxr.p'
               &PARAM="(input po_print,
                        input edi_po,
                        output po_inv_mthd)"
               &NOAPPERROR=true
               &CATCHERROR=true
      }
   end.  /* settrl: */

   if not new_po
   then do:
      {pxrun.i &PROC='setPOPrint' &PROGRAM='popoxr.p'
               &PARAM="(input old_rev,
                        input po_rev,
                        input-output po_print)"
               &NOAPPERROR=true
               &CATCHERROR=true
      }
   end.

   global_type = comment_type.

   if (old_po_stat = "c" or old_po_stat = "x")
      and po_stat <> "c" and po_stat <> "x"
   then do:

      po_cls_date = ?.
      if c-application-mode <> "API" then
        display po_cls_date with frame pomtd.

      reopenLines = no.
      /* MESSAGE #327 - DO YOU WISH TO REOPEN ALL PO LINE ITEMS? */
      {pxmsg.i
         &MSGNUM=327
         &ERRORLEVEL={&INFORMATION-RESULT}
         &CONFIRM=reopenLines
      }
      if c-application-mode = "API" then
         reopenLines = yes.

      if reopenLines
      then do:
         {pxrun.i &PROC='reopenPOLines' &PROGRAM='popoxr1.p'
                  &PARAM="(input po_nbr,
                           input blanket)"
                   &NOAPPERROR=true
                   &CATCHERROR=true
         }
      end.
   end.

   if ((old_po_stat <> "c" and old_po_stat <> "x") or
       line_opened) /* True if closed line item was opened */
       and index("cx",po_stat) <> 0
   then do:
      po_cls_date = today.

      if c-application-mode <> "API" then
         display po_cls_date with frame pomtd.

      {pxrun.i &PROC='informClosePO'
         &PROGRAM='popoxr.p'
         &NOAPPERROR=true &CATCHERROR=true}

      /* A PAUSE REQUIRES USER INTERACTION HENCE IT SHOULD NOT BE */
      /* THERE DURING CIM LOAD                                    */

      if not batchrun
         and not blanket
         and c-application-mode <> "API"
      then
         pause 2.

      {pxrun.i &PROC='closePO' &PROGRAM='popoxr.p'
               &PARAM="(buffer po_mstr,
                        input blanket,
                        input no)"
                &NOAPPERROR=true
                &CATCHERROR=true
      }
   end.  /* if ((old_po_stat <> "c" and old_po_stat <> "x") or.. */
end. /* transaction */
if c-application-mode <> "API"
then do:
   hide frame pomtd.
   hide frame potot.
end. /* if c-application-mode = "API" */
/*V8!*
hide all no-pause.
if global-tool-bar and
valid-handle(global-tool-bar-handle) then
global-tool-bar-handle:visible = true.    
*/
