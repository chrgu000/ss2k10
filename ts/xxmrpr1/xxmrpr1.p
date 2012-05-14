/* GUI CONVERTED from mrworp11.p (converter v1.78) Fri Oct 29 14:37:25 2004 */
/* mrworp11.p - PLANNED ORDER REPORT                                    */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                  */
/* All rights reserved worldwide.  This is an unpublished work.         */
/* $Revision: 1.7.1.6 $                                                 */
/*V8:ConvertMode=FullGUIReport                                          */
/* Revision: 1.0      LAST MODIFIED: 07/16/86   BY: PML       */
/* REVISION: 1.0      LAST MODIFIED: 06/26/86   BY: EMB       */
/* REVISION: 1.0      LAST MODIFIED: 09/16/86   BY: EMB *12*  */
/* REVISION: 2.1      LAST MODIFIED: 10/19/87   BY: WUG *A94* */
/* REVISION: 4.0      LAST MODIFIED: 02/16/88   BY: FLM *A175**/
/* REVISION: 4.0      LAST MODIFIED: 06/14/88   BY: flm *A268**/
/* REVISION: 4.0      LAST MODIFIED: 05/30/89   BY: emb *A740**/
/* REVISION: 6.0      LAST MODIFIED: 09/11/90   BY: emb *D040**/
/* REVISION: 6.0      LAST MODIFIED: 01/02/91   BY: emb *D276**/
/* REVISION: 7.3      LAST MODIFIED: 11/19/92   BY: jcd *G348**/
/* REVISION: 7.5      LAST MODIFIED: 03/24/95   BY: tjs *J014**/
/* REVISION: 8.6      LAST MODIFIED: 10/15/97   BY: ckm *K0ZX**/
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane        */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan       */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane */
/* REVISION: 9.1      LAST MODIFIED: 08/13/00   BY: *N0KR* myb              */
/* REVISION: 9.1      LAST MODIFIED: 09/07/00   BY: *N0RL* BalbeerS Rajput  */
/* Revision: 1.7.1.5  BY: Paul Donnelly (SB) DATE: 06/28/03 ECO: *Q00J* */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* $Revision: 1.7.1.6 $    BY: Subramanian Iyer      DATE: 11/25/03  ECO: *P13Q*  */
/*-Revision end---------------------------------------------------------------*/
/******************************************************************************/
/* All patch markers and commented out v_code have been removed from the source */
/* v_code below. For all future modifications to this file, any v_code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/


/*GUI global preprocessor directive settings */
&GLOBAL-DEFINE PP_PGM_RP TRUE
&GLOBAL-DEFINE PP_ENV_GUI TRUE


/*GUI preprocessor directive settings */
&SCOPED-DEFINE PP_GUI_CONVERT_MODE REPORT

{mfdtitle.i "1+ "}

define variable site         like si_site.
define variable site1        like si_site.
define variable nbr          like mrp_nbr.
define variable nbr1         like mrp_nbr.
define variable part         like wo_part.
define variable part1        like wo_part.
define variable prod_line    like pt_prod_line.
define variable prod_line1   like pt_prod_line.
define variable bom          like wo_bom_code.
define variable bom1         like wo_bom_code.
define variable due          like wo_due_date.
define variable due1         like wo_due_date.
define variable rel          like wo_rel_date.
define variable rel1         like wo_rel_date.
define variable desc1        like pt_desc1.
define variable pm_code      like pt_pm_code.
define variable show_phantom like mfc_logical initial no
   label "Show Phantom Items".
define variable bom_code     like pt_bom_code.
define variable blnk         like wo_part initial "                  ".
define variable len as integer.
define variable show_base    like mfc_logical initial true
   label "Include Base Process Orders".
define variable show_by      like mfc_logical initial false
   label "Include By-Product Orders".
define variable  item_sort   like mfc_logical initial true
   format "Item Number/BOM Formula"
   label "Sort by Item Number or BOM/Formula".
define variable buyer        like pt_buyer.
define variable v_code         like pt_pm_code LABEL "����M/L".


/*GUI preprocessor Frame A define */
&SCOPED-DEFINE PP_FRAME_NAME A

FORM /*GUI*/ 
   
 RECT-FRAME       AT ROW 1.4 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1   COLUMN 3 NO-LABEL
 SKIP(.1)  /*GUI*/


    due     colon 20 due1  label "To"   colon 49 
    part    colon 20
         View-as fill-in size 18 by 1   
   part1 label "To"   colon 49
         View-as fill-in size 18 by 1   skip
   prod_line colon 20 
   prod_line1 label "TO" colon 49 
   skip
   site    colon 20 site1 label "To"   colon 49 skip
   nbr     colon 20 nbr1  label "To"   colon 49 skip
   rel     colon 20 rel1  label "To"   colon 49 skip

   buyer          colon 38
   v_code           colon 38 LABEL "����M/L"
   item_sort      colon 38
 SKIP(.4)  /*GUI*/
with frame a side-labels width 80 attr-space NO-BOX THREE-D /*GUI*/.

 DEFINE VARIABLE F-a-title AS CHARACTER.
 F-a-title = &IF DEFINED(GPLABEL_I)=0 &THEN
   &IF (DEFINED(SELECTION_CRITERIA) = 0)
   &THEN " Selection Criteria "
   &ELSE {&SELECTION_CRITERIA}
   &ENDIF 
&ELSE 
   getTermLabel("SELECTION_CRITERIA", 25).
&ENDIF.
 RECT-FRAME-LABEL:SCREEN-VALUE in frame a = F-a-title.
 RECT-FRAME-LABEL:WIDTH-PIXELS in frame a =
  FONT-TABLE:GET-TEXT-WIDTH-PIXELS(
  RECT-FRAME-LABEL:SCREEN-VALUE in frame a + " ", RECT-FRAME-LABEL:FONT).
 RECT-FRAME:HEIGHT-PIXELS in frame a =
  FRAME a:HEIGHT-PIXELS - RECT-FRAME:Y in frame a - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME a = FRAME a:WIDTH-CHARS - .5. /*GUI*/

/*GUI preprocessor Frame A undefine */
&UNDEFINE PP_FRAME_NAME

v_code = "L".

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

assign
   site  = global_site
   site1 = global_site.

{wbrp01.i}


/*GUI*/ {mfguirpa.i true "printer" 132 " " " " " "  }

/*GUI repeat : */
/*GUI*/ procedure p-enable-ui:


   if nbr1 = hi_char
   then
      nbr1 = "".
   if part1 = hi_char
   then
      part1 = "".
   if prod_line1 = hi_char
   then 
   		prod_line = "".
   if bom1 = hi_char
   then
      bom1 = "".
   if site1 = hi_char
   then
      site1 = "".
   if rel = low_date
   then
      rel = ?.
   if rel1 = hi_date
   then
      rel1 = ?.
   if due = low_date
   then
      due = ?.
   if due1 = hi_date
   then
      due1 = ?.
		
   if c-application-mode <> 'web'
   then
      
run p-action-fields (input "display").
run p-action-fields (input "enable").
end procedure. /* p-enable-ui, replacement of Data-Entry GUI*/

/*GUI*/ procedure p-report-quote:


   {wbrp06.i &command = update
      &fields = " due due1 part part1  site site1
        nbr nbr1 rel rel1    buyer v_code
       item_sort"
      &frm = "a"}

   if (c-application-mode <> 'web')
   or (c-application-mode  = 'web'
   and (c-web-request begins 'data'))
   then do:

      /* CREATE BATCH INPUT STRING */
      bcdparm = "".
      {mfquoter.i part     }
      {mfquoter.i part1    }
      {mfquoter.i prod_line}
      {mfquoter.i prod_line1   }
      {mfquoter.i site     }
      {mfquoter.i site1    }
      {mfquoter.i nbr      }
      {mfquoter.i nbr1     }
      {mfquoter.i rel      }
      {mfquoter.i rel1     }
      {mfquoter.i due      }
      {mfquoter.i due1     }
      {mfquoter.i buyer    }
      {mfquoter.i v_code     }
      {mfquoter.i item_sort   }

      if nbr1 = ""
      then
         nbr1 = hi_char.
      if part1 = ""
      then
         part1 = hi_char.
      if prod_line = ""
      then 
      	 prod_line = hi_char.
      if bom1 = ""
      then
         bom1 = hi_char.
      if site1 = ""
      then
         site1 = hi_char.
      if rel = ?
      then
         rel = low_date.
      if rel1 = ?
      then
         rel1 = hi_date.
      if due = ?
      then
         due = low_date.
      if due1 = ?
      then
         due1 = hi_date.

   end. /* IF (c-application-mode <> 'web') ... */

   /* OUTPUT DESTINATION SELECTION */
   
/*GUI*/ end procedure. /* p-report-quote */
/*GUI - Field Trigger Section */

/*GUI MFSELxxx removed*/
/*GUI*/ procedure p-report:
/*GUI*/   {gpprtrpa.i "printer" 132 " " " " " " " " }
/*GUI*/   mainloop: do on error undo, return error on endkey undo, return error:



   {mfphead.i}

   /* FIND AND DISPLAY */
   for each wo_mstr
      fields(wo_bom_code wo_domain wo_due_date
             wo_joint_type wo_lot wo_nbr wo_part
             wo_qty_ord wo_rel_date wo_site wo_status)
      where wo_mstr.wo_domain = global_domain
      and (wo_due_date >= due
      and wo_due_date <= due1)
      and (wo_rel_date >= rel
      and wo_rel_date <= rel1)
      and ((wo_nbr >= nbr
      and wo_nbr   <= nbr1)
      and (wo_part >= part
      and wo_part  <= part1)
      and (wo_site >= site
      and wo_site  <= site1)
      and (wo_status = "P")
      AND ( CAN-FIND(FIRST pt_mstr WHERE pt_domain = GLOBAL_domain AND pt_part = wo_part AND (pt_pm_code = "M" OR pt_pm_code = "L") and pt_prod_line >= prod_line and pt_prod_line <= prod_line1)
           OR CAN-FIND(FIRST ptp_det WHERE ptp_domain = GLOBAL_domain AND ptp_part = wo_part AND (ptp_pm_code = "M" OR ptp_pm_code = "L")))
         /* WITHIN BOM v_code RANGE */
       ) NO-LOCK USE-INDEX wo_due_part
      by (if item_sort then wo_part else wo_bom_code) by wo_part by wo_site

      by wo_rel_date with frame f-a width 132 no-attr-space:

      /* SET EXTERNAL LABELS */
      setFrameLabels(frame f-a:handle).

      
/*GUI*/ {mfguichk.i } /*Replace mfrpchk*/


      desc1 = "".
      pm_code = "".

      find pt_mstr
         where pt_mstr.pt_domain = global_domain
         and pt_part             = wo_part
         no-lock
         no-error.

      if available pt_mstr
      then do:
         assign
            desc1   = pt_desc1
            pm_code = pt_pm_code.
      end. /* IF AVAILABLE pt_mstr */

      find ptp_det
         no-lock
         where ptp_det.ptp_domain = global_domain
         and   ptp_part           = wo_part
         and   ptp_site           = wo_site
      no-error.

      if available ptp_det
      then do:
         pm_code = ptp_pm_code.
      end. /* IF AVAILABLE ptp_det */

      if (pm_code = v_code or (v_code = "" AND (pm_code = "M" OR pm_code = "L")))
      and
         (
         (available ptp_det
         and (ptp_phantom = no or show_phantom = yes)
         and (ptp_buyer = buyer or buyer = ""))
         or (not available ptp_det
         and (available pt_mstr and pt_phantom = no or show_phantom = yes)
         and (available pt_mstr and pt_buyer = buyer or buyer = ""))
         )
      then do:

         if available pt_mstr and pt_desc2 > ""
            and page-size - line-counter < 2
         then
            page.

         display
            wo_part
            column-label "Item Number!       BOM/Formula"
            desc1
            wo_site
            ptp_buyer when (available ptp_det) @ pt_buyer
            pt_buyer  when (not available ptp_det)
            pm_code
            wo_nbr @ nbr
            wo_lot
            wo_qty_ord
            pt_um
            wo_rel_date
            wo_due_date WITH STREAM-IO /*GUI*/ .

         if available pt_mstr
         and (pt_desc2 > "" or wo_bom_code > "")
         then do:
            len = length(wo_bom_code).
            bom_code = substring(blnk,1,(18 - len)) +
               substring(wo_bom_code,1,(len)).
            down 1.

            display
               bom_code @ wo_part
               pt_desc2 @ desc1 WITH STREAM-IO /*GUI*/ .
         end. /* IF AVAILABLE pt_mstr */

      end. /* IF (pm_code = v_code or v_code = "") */

   end. /* FOR EACH wo_mstr */

   
/*GUI*/ {mfguitrl.i} /*Replace mfrtrail*/

/*GUI*/ {mfgrptrm.i} /*Report-to-Window*/


end. /* REPEAT: */

{wbrp04.i &frame-spec = a}

/*GUI*/ end procedure. /*p-report*/
/*GUI*/ {mfguirpb.i &flds="due due1 part part1 prod_line prod_line1 site site1 nbr nbr1 rel rel1  buyer v_code  item_sort "} /*Drive the Report*/