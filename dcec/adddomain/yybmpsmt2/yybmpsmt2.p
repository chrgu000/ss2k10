/* GUI CONVERTED from bmpsmt.p (converter v1.78) Sun Sep 26 23:23:31 2010 */
/* bmpsmt.p - Product Structure Maintenance                                   */
/* Copyright 1986-2010 QAD Inc., Santa Barbara, CA, USA.                      */
/* All rights reserved worldwide.  This is an unpublished work.               */
/*                                                                            */
/* Interactive maintenance program to create, update, delete product          */
/* structures, using Progress native user interface.                          */
/*                                                                            */
/*                                                                            */
/* REVISION: 1.0       LAST MODIFIED: 06/12/86  BY: EMB                       */
/* REVISION: 1.0       LAST MODIFIED: 09/08/86  BY: EMB                       */
/* REVISION: 1.0       LAST MODIFIED: 10/02/86  BY: EMB *25*                  */
/* REVISION: 1.0       LAST MODIFIED: 11/03/86  BY: EMB *36*                  */
/* REVISION: 1.0       LAST MODIFIED: 11/03/86  BY: EMB *39*                  */
/* REVISION: 2.0       LAST MODIFIED: 03/12/87  BY: EMB *A41*                 */
/* REVISION: 4.0       LAST MODIFIED: 01/04/88  BY: RL  *A117*                */
/* REVISION: 4.0       LAST MODIFIED: 01/05/88  BY: RL  *A126*                */
/* REVISION: 4.0       LAST MODIFIED: 03/07/88  BY: WUG *A183*                */
/* REVISION: 4.0       LAST MODIFIED: 04/19/88  BY: emb *A207*                */
/* REVISION: 5.0       LAST MODIFIED: 12/30/88  BY: emb *B001*                */
/* REVISION: 6.0       LAST MODIFIED: 11/05/90  BY: emb *D176*                */
/* REVISION: 6.0       LAST MODIFIED: 09/09/91  BY: emb *D852*                */
/* REVISION: 7.0       LAST MODIFIED: 03/16/92  BY: emb *F308*                */
/* REVISION: 7.0       LAST MODIFIED: 03/24/92  BY: pma *F089*                */
/* REVISION: 7.0       LAST MODIFIED: 05/27/92  BY: pma *F533*                */
/* REVISION: 7.0       LAST MODIFIED: 06/01/92  BY: emb *F562*                */
/* REVISION: 7.0       LAST MODIFIED: 10/07/92  BY: emb *G141*                */
/* REVISION: 7.3       LAST MODIFIED: 02/24/93  BY: sas *G740*                */
/* REVISION: 7.3       LAST MODIFIED: 06/11/93  BY: qzl *GC10*                */
/* REVISION: 7.3       LAST MODIFIED: 07/29/93  BY: emb *GD82*                */
/* REVISION: 7.3       LAST MODIFIED: 09/07/93  BY: pxd *GE64*                */
/* REVISION: 7.3       LAST MODIFIED: 10/07/93  BY: pxd *GG22*                */
/* REVISION: 7.3       LAST MODIFIED: 02/16/94  BY: pxd *FL60*                */
/* REVISION: 7.3       LAST MODIFIED: 04/22/94  BY: pxd *FN07*                */
/* REVISION: 7.3       LAST MODIFIED: 08/08/94  BY: str *FP93*                */
/* REVISION: 7.3       LAST MODIFIED: 09/11/94  BY: slm *GM32*                */
/* REVISION: 7.3       LAST MODIFIED: 09/15/94  BY: qzl *FR35*                */
/* REVISION: 7.2       LAST MODIFIED: 09/19/94  BY: ais *FR55*                */
/* REVISION: 7.3       LAST MODIFIED: 09/27/94  BY: qzl *FR88*                */
/* REVISION: 7.3       LAST MODIFIED: 11/06/94  BY: ame *GO19*                */
/* REVISION: 7.3       LAST MODIFIED: 12/16/94  BY: pxd *F09W*                */
/* REVISION: 8.5       LAST MODIFIED: 01/07/95  BY: dzs *J005*                */
/* REVISION: 8.5       LAST MODIFIED: 02/16/95  BY: tjs *J005*                */
/* REVISION: 7.2       LAST MODIFIED: 03/20/95  BY: qzl *F0NG*                */
/* REVISION: 8.5       LAST MODIFIED: 09/18/95  BY: kxn *J07Z*                */
/* REVISION: 7.3       LAST MODIFIED: 12/14/95  BY: bcm *F0WG*                */
/* REVISION: 8.5       LAST MODIFIED: 04/10/96  BY: *J04C* Markus Barone      */
/* REVISION: 8.5       LAST MODIFIED: 07/31/96  BY: *G2B7* Julie Milligan     */
/* REVISION: 8.5       LAST MODIFIED: 12/23/96  BY: *J1CT* Russ Witt          */
/* REVISION: 8.5       LAST MODIFIED: 11/20/97  BY: *J26Q* Viswanathan        */
/* REVISION: 8.5       LAST MODIFIED: 01/06/98  BY: *J296* Viswanathan        */
/* REVISION: 8.5       LAST MODIFIED: 03/09/98  BY: *J29L* Kawal Batra        */
/* REVISION: 8.6       LAST MODIFIED: 05/20/98  BY: *K1Q4* Alfred Tan         */
/* REVISION: 9.1       LAST MODIFIED: 07/20/99  BY: *N015* Mugdha Tambe       */
/* REVISION: 9.1       LAST MODIFIED: 03/24/00  BY: *N08T* Annasaheb Rahane   */
/* REVISION: 9.1       LAST MODIFIED: 06/16/00  BY: *F0PN* Annasaheb Rahane   */
/* Revision: 1.2       BY: Evan Bishop            DATE: 06/01/00 ECO: *N0B9*  */
/* Revision: 1.8.1.7   BY: Paul Donnelly          DATE: 07/20/00 ECO: *N0DP*  */
/* Revision: 1.8.1.8   BY: Mark Christian         DATE: 05/05/01 ECO: *N0YF*  */
/* Revision: 1.8.1.9   BY: Anil Sudhakaran        DATE: 11/28/01 ECO: *M1F3*  */
/* Revision: 1.8.1.11  BY: Paul Donnelly (SB)     DATE: 06/26/03 ECO: *Q00B*  */
/* Revision: 1.8.1.12  BY: Matthew Lee            DATE: 10/19/04 ECO: *P2QD*  */
/* Revision: 1.8.1.13  BY: Gaurav Kerkar          DATE: 23/02/05 ECO: *P39G*  */
/* Revision: 1.8.1.14  BY: SurenderSingh Nihalani DATE: 07/14/05 ECO: *P3TH*  */
/* Revision: 1.8.1.16  BY: Sundeep Kalla        DATE: 05/11/06 ECO: *P4R6*    */
/* Revision: 1.8.1.17  BY: Archana Kirtane      DATE: 07/03/07 ECO: *P5YP*    */
/* Revision: 1.8.1.19  BY: Ruchita Shinde       DATE: 12/26/08 ECO: *Q21D*    */
/* Revision: 1.8.1.20  BY: Archana Kirtane      DATE: 12/16/08 ECO: *Q23G*    */
/* Revision: 1.8.1.20.2.1  BY: Evan Todd        DATE: 02/19/09  ECO: *Q2D3*   */
/* Revision: 1.8.1.20.2.3  BY: Archana Kirtane  DATE: 03/17/09  ECO: *Q1SD*   */
/* Revision: 1.8.1.20.2.4  BY: Evan Todd        DATE: 09/02/09  ECO: *Q3BT*   */
/* $Revision: 1.8.1.20.2.5 $  BY: Ravi Swami        DATE: 09/27/10  ECO: *Q4D4*   */
/* $Revision:eb21sp12  $ BY: Jordan Lin            DATE: 08/24/12  ECO: *SS-20120824.1*   */

/*-Revision end---------------------------------------------------------------*/

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/
/*                                                                            */
/*V8:ConvertMode=Maintenance                                                  */

/*********************************************************/
/* NOTES:   1. Patch FL60 sets in_level to a value       */
/*             of 99999 when in_mstr is created or       */
/*             when any structure or network changes are */
/*             made that affect the low level codes.     */
/*          2. The in_levels are recalculated when MRP   */
/*             is run or can be resolved by running the  */
/*             mrllup.p utility program.                 */
/*********************************************************/
/* DISPLAY TITLE */
{mfdtitle.i " 120824.1"}
/* COMMON API CONSTANTS AND VARIABLES */
{mfaimfg.i}

{pxmaint.i}
define new shared variable comp      like ps_comp.
define new shared variable par       like ps_par.
define new shared variable level     as   integer.
define new shared variable qty       as   decimal.
define new shared variable parent    like ps_par.
define new shared variable ps_recno  as   recid.
define new shared variable bom_recno as   recid.

define variable des                  like pt_desc1               no-undo.
define variable des2                 like pt_desc1               no-undo.
define variable um                   like pt_um                  no-undo.
define variable del-yn               like mfc_logical initial no no-undo.
define variable rev                  like pt_rev                 no-undo.
define variable item_no              like ps_item_no             no-undo.
define variable batch_size           like bom_batch              no-undo.
define variable psstart              like ps_start               no-undo.
define variable psend                like ps_end                 no-undo.
define variable conv                 like ps_um_conv initial 1   no-undo.
define variable bomdesc              like bom_desc               no-undo.
define variable saved-recno          as   recid                  no-undo.

define variable overlap-error as integer initial 3 no-undo.
define variable overlap-warning as integer initial 2 no-undo.

define buffer ps_mstr1               for ps_mstr.

define variable old_qty_per          like ps_qty_per  no-undo.
define variable old_scrp_pct         like ps_scrp_pct no-undo.
define variable old_ps_code          like ps_ps_code  no-undo.
define variable old_lt_off           like ps_lt_off   no-undo.
define variable old_rmks             like ps_rmks     no-undo.
define variable old_op               like ps_op       no-undo.
define variable old_item_no          like ps_item_no  no-undo.
define variable old_process          like ps_process  no-undo.
define variable old_fcst_pct         like ps_fcst_pct no-undo.
define variable old_group            like ps_group    no-undo.

/* Variable added to perform delete during CIM.
 * Record is deleted only when the value of this variable
 * Is set to "X" */
define variable batchdelete as character format "x(1)" no-undo.

 /* *SS-20120827.1*  -b */ 

 def var site like si_site.                     /*kevin*/
         def var msg-nbr as inte.                       /*kevin*/
         def var fc_type as logic.              /*kevin*/
  /* *SS-20120827.1*  -e */ 

/* Define Handles for the programs. */
{pxphdef.i gpsecxr}

/* Use local variables to store the UI and API values */
define variable cPar    like ps_par no-undo.
define variable cRef    like ps_ref no-undo.
define variable cComp   like ps_comp no-undo.
define variable dtStart like ps_start no-undo.

define variable lCustomOK as logical no-undo.

/* Product Structure API dataset definition */
{bmdsps.i "reference-only"}

if c-application-mode = "API" then do on error undo, return:

   /* Get handle of API Controller */
   {gprun.i ""gpaigach.p"" "(output ApiMethodHandle)"}
/*GUI*/ if global-beam-me-up then undo, leave.


   if not valid-handle(ApiMethodHandle) then do:
      /* API Error */
      {pxmsg.i &MSGNUM=10461 &ERRORLEVEL=4}
      return.
   end.

   /* Get the Product Structure API dataset from the controller */
   run getRequestDataset in ApiMethodHandle (output dataset dsProductStructure bind).

end.  /* If c-application-mode = "API" */

/* Display selection form */

/*GUI preprocessor Frame A define */
&SCOPED-DEFINE PP_FRAME_NAME A

FORM /*GUI*/ 
   
 RECT-FRAME       AT ROW 1 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1 COLUMN 3 NO-LABEL VIEW-AS TEXT SIZE-PIXELS 1 BY 1
 SKIP(.1)  /*GUI*/
 /* *SS-20120827.1*   */  site           colon 25       si_desc no-label at 47 skip(1)   /*kevin*/
ps_par   colon 25
   bomdesc  colon 25
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
if c-application-mode <> "API" then
   setFrameLabels(frame a:handle).

FORM /*GUI*/ 
   
 RECT-FRAME       AT ROW 1 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1 COLUMN 3 NO-LABEL VIEW-AS TEXT SIZE-PIXELS 1 BY 1
 SKIP(.1)  /*GUI*/
ps_comp        colon 25
   des            no-labels at 47
   rev            colon 25
   des2           no-labels at 47
   ps_ref         colon 25
   ps_start       colon 25 format "99/99/9999"
   ps_end         colon 59 format "99/99/9999"
   skip(1)
   ps_qty_per     format "->>>,>>>,>>9.9<<<<<<<<" colon 25
   um             no-labels
   ps_scrp_pct    colon 59 format ">9.99%"
   ps_lt_off      colon 59
   ps_op          colon 59
   ps_item_no     colon 59
   ps_ps_code     colon 25
   ps_fcst_pct    colon 59
   psstart        colon 25 format "99/99/9999"
   ps_group       colon 59
   psend          colon 25 format "99/99/9999"
   ps_process     colon 59
   ps_rmks        colon 25
 SKIP(.4)  /*GUI*/
with frame b side-labels width 80 attr-space NO-BOX THREE-D /*GUI*/.

 DEFINE VARIABLE F-b-title AS CHARACTER INITIAL "".
 RECT-FRAME-LABEL:SCREEN-VALUE in frame b = F-b-title.
 RECT-FRAME-LABEL:HIDDEN in frame b = yes.
 RECT-FRAME:HEIGHT-PIXELS in frame b =
  FRAME b:HEIGHT-PIXELS - RECT-FRAME:Y in frame b - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME b = FRAME b:WIDTH-CHARS - .5.  /*GUI*/


/* SET EXTERNAL LABELS */
if c-application-mode <> "API" then
   setFrameLabels(frame b:handle).

/* Display */
if c-application-mode <> "API" then do:
   view frame a.
   view frame b.
end.

bom_recno = ?.

mainloop:
repeat:
/*GUI*/ if global-beam-me-up then undo, leave.

 /* *SS-20120827.1* -b  */
/************tfq added begin********************/
   find first xxbomc_ctrl where xxbomc_ctrl.xxbomc_domain = global_domain no-lock no-error.                

            if not available xxbomc_ctrl then do:
                message "错误:BOM控制文件还未生成,请首先维护BOM控制文件!" 
view-as alert-box error.
                leave mainloop.
            end.
 /********************tfq added end*****************/           
 /* *SS-20120827.1* -e  */

   /* Get the next product structure from the API controller */
   if c-application-mode = "API" then do:
      run getNextRecord in ApiMethodHandle (input "ttProductStructure").
      if return-value = {&RECORD-NOT-FOUND} then
         leave.
   end. /* if c-application-mode = "API" */

   /* Initialize delete flag before each display of frame */
   batchdelete = "".

   if c-application-mode <> "API" then do:
      clear frame b no-pause.
/*GUI*/ RECT-FRAME-LABEL:SCREEN-VALUE in frame b = F-b-title.

 /* *SS-20120827.1* -b  */
/*************tfq added begin**********************************/
/*added by kevin, 10/16/2003 for site control*/
            fc_type = no.
            update site editing:
                {mfnp.i si_mstr site si_site site si_site si_site}
                if recno <> ? then
                    disp si_site @ site si_desc.
            end.
                 find si_mstr no-lock where  /* *SS-20120827.1*   */ si_mstr.si_domain = global_domain and si_site = site no-error.
                 if not available si_mstr or (si_db <> global_db) then do:
                     if not available si_mstr then msg-nbr = 708.
                     else msg-nbr = 5421.
                     /*tfq {mfmsg.i msg-nbr 3} */
                     {pxmsg.i
               &MSGNUM=msg-nbr
               &ERRORLEVEL=3
                          }
                     undo, retry.
                 end.

                {gprun.i ""gpsiver.p""
                "(input si_site, input recid(si_mstr), output return_int)"}
/*GUI*/ if global-beam-me-up then undo, leave.

/*J034*/          if return_int = 0 then do:
/*J034*/           /*tfq  {mfmsg.i 725 3}  */
            {pxmsg.i
               &MSGNUM=725
               &ERRORLEVEL=3
                           }
  /* USER DOES NOT HAVE */
/*J034*/                                /* ACCESS TO THIS SITE*/
/*J034*/             undo,retry.
/*J034*/          end.
                  disp si_site @ site si_desc.
/*end added by kevin, 10/16/2003*/
/*************tfq added end********************************/
 /* *SS-20120827.1* -b  */

      prompt-for ps_par with no-validate frame a
      editing:

         if frame-field = "ps_par"
         then do:
            /* Find next/previous record*/

            recno = bom_recno.

            for first bom_mstr
               fields( bom_domain bom_batch bom_batch_um bom_desc bom_formula
                       bom_fsm_type bom_mod_date bom_parent bom_userid  /* *SS-20120827.1* */ bom__chr01)
               where recid(bom_mstr) = recno no-lock:
            end. /* for first bom_mstr */

            /* Next/prev thru 'non-service' boms */
            {mfnp05.i bom_mstr bom_fsm_type " bom_mstr.bom_domain = global_domain
             and bom_fsm_type  = """""
                bom_parent "input ps_par"}

            if recno <> ?
            then do:
               bom_recno = recno.
               if bom_desc = ""
               then do:
                  for first pt_mstr
                     fields( pt_domain pt_desc1 pt_desc2 pt_formula
                             pt_joint_type pt_part pt_rev pt_status pt_um /* *SS-20120827.1* */ pt_group)
                     no-lock where pt_mstr.pt_domain = global_domain and
                                   pt_part = bom_parent:
                  end. /* for first pt_mstr */

                  if available pt_mstr then bomdesc = pt_desc1.
               end. /* if bom_desc = "" then do: */
               else do:
                  bomdesc = bom_desc.
               end. /* else do: */

               display
                  bom_parent @ ps_par
                  bomdesc
               with frame a.
            end. /* if recno <> ? then do: */
            else bom_recno = ?.
         end. /* if field-frame = "ps_par" */
         else do:
            readkey.
            apply lastkey.
         end. /* else do: */
      end.
/*GUI*/ if global-beam-me-up then undo, leave.
 /* prompt-for */
   end. /* if c-application-mode <> "API" */

   /* Assign the local variables from either the UI or API */
   assign
      cPar = if c-application-mode <> "API" then
                (input ps_par)
              else
                 ttProductStructure.psPar.

   for first pt_mstr
      fields( pt_domain pt_desc1 pt_desc2 pt_formula pt_joint_type
              pt_part pt_rev pt_status pt_um /* *SS-20120827.1* */ pt_group)
      no-lock where pt_mstr.pt_domain = global_domain and pt_part = cPar:
   end. /* for first pt_mstr */

   if available pt_mstr
   then do:
      bomdesc = pt_desc1.
      if c-application-mode <> "API" then
         display bomdesc with frame a.
   end. /* IF AVAILABLE pt_mstr */

   for first bom_mstr
      fields( bom_domain bom_batch bom_batch_um bom_desc bom_formula
              bom_fsm_type bom_mod_date bom_parent bom_userid /* *SS-20120827.1* */ bom__chr01)
      no-lock  where bom_mstr.bom_domain = global_domain and
      bom_parent = cPar:
   end. /* for first bom_mstr */

 /* *SS-20120827.1*  -b */
/****************tfq added begin*************************/
/*judy 07/14/05*//*added by kevin, 11/18/2003*/
/*judy 07/14/05*/   find first ps_mstr where ps_mstr.ps_domain = global_domain and  ps_par = input ps_par  no-lock no-error.
/*judy 07/14/05*/   if not available ps_mstr then do:
/*judy 07/14/05*/      message "该零件/物料单代码无需要维护工序的子零件!" view-as alert-box error.
/*judy 07/14/05*/      undo,retry.
/*judy 07/14/05*/   end.
/*judy 07/14/05*//*end added by kevin, 11/18/2003*/          

/*added by kevin, 11/07/2003 for site control: C plant use the item as*/ 
/**parent,B plant just use the bom code as parent*/
        if xxbomc_part_site = site and not available pt_mstr then do:
            message "根据BOM控制文件,本地点只能使用零件号作为'父零件'!" 
view-as alert-box error.
              undo,retry.
        end.

     
/*end added by kevin, 11/07/2003*/

/*added by kevin, 10/20/2003 for site control*/
          if available pt_mstr then do:
                find ptp_det where ptp_det.ptp_domain = global_domain and  ptp_site = site and ptp_part = input 
                ps_par no-lock no-error.
                if not available ptp_det then do:
                  message "该零件的地点计划数据不存在,请重新输入!" view-as 
alert-box error.
                    undo,retry.
                end.
                if
                   ptp_pm_code = "C" then assign fc_type = yes.

 /*added by kevin, not to control the item of pt_group is "M"*/
              if pt_group = "M" then assign fc_type = yes.

              /*added by kevin, not to control the item of pt_group is "RAW"*/
            if pt_group = "RAW" then assign fc_type = yes.

               /*added by kevin, 2004/03/27, not to control the engine whose 
pt_group begins "58"*/
                  if pt_group begins "58" then assign fc_type = yes.
          end.

        if xxbomc_code_site = site
           and (available pt_mstr and pt_group <> "M" and pt_group <> "RAW") 
                         /*kevin*/
           and (available ptp_det and (/*ptp_pm_code <> "F" and*/ 
ptp_pm_code <> "C")) then do:
              message "根据BOM控制文件,本地点不能使用零件号作为'父零件'!" 
view-as alert-box error.
              undo,retry.
        end.
/*end added by kevin*/
/*************tfq added end************************/
 /* *SS-20120827.1*  -e */

   /* Validate that the Parent Id is valid */
   {pxrun.i &PROC = 'validateParentId' &PROGRAM = 'bmpsxr.p'
           &PARAM = "(INPUT cPar)"
      &CATCHERROR = true
   }

   {pxrun.i &PROC = 'validateBomExists' &PROGRAM = 'bmpscxr.p'
           &PARAM = "(INPUT cPar)"
      &CATCHERROR = true
   }

   if not available bom_mstr
   then do transaction:
/*GUI*/ if global-beam-me-up then undo, leave.


      {pxrun.i
         &PROC       = 'processCreate'
         &PROGRAM    = 'bmpsxr.p'
         &PARAM      = "(INPUT cPar, buffer bom_mstr)"
         &CATCHERROR = true
      }

      /* 1 - ADDING NEW RECORD */
      {pxmsg.i
         &MSGNUM     = 1
         &ERRORLEVEL = {&INFORMATION-RESULT}
      }
 /* *SS-20120827.1*   */     assign bom__chr01 = site.                    
   end. /* TRANSACTION */
   else do:
 /* *SS-20120827.1*  -b */
   if not available pt_mstr and bom__chr01 <> site 
        then do:
         message "物料单代码的地点与输入的地点不一致,请重新输入!" 
                      view-as alert-box error.
                    undo mainloop, retry mainloop.
         end.
   end.
        find first ps_mstr where  ps_mstr.ps_domain = global_domain and  ps_par = input ps_par and ps__chr01 <> site no-lock no-error.
            if available ps_mstr and not fc_type then do:
                 message "该父零件存在 '" + ps__chr01 + " '地点的产品结构" view-as alert-box error.
                  undo,retry.
            end.
            find first ps_mstr where ps_mstr.ps_domain = global_domain and ps_comp = input ps_par and ps__chr01 <> 
site no-lock no-error.
            if available ps_mstr and not fc_type then do:
                     message "该父零件存在 '" + ps__chr01 + " '地点的产品结构" view-as alert-box error.
                     undo,retry.
            end.
/*end added by kevin, 10/16/2003 for site control*/

  /* *SS-20120827.1* -e  */
      {pxrun.i
         &PROC       = 'validateBlankBomFsmType'
         &PROGRAM    = 'bmpsxr.p'
         &PARAM      = "(INPUT bom_fsm_type)"
         &CATCHERROR = true
      }

      bom_recno = recid(bom_mstr).

      if c-application-mode <> "API" then do:
         if bom_desc = ""
         and available pt_mstr
         then
            bomdesc = pt_desc1.
         else
            bomdesc = bom_desc.

         display
            bom_parent @ ps_par
            bomdesc
         with frame a.
      end. /* if c-application-mode <> "API" */

      if bom_formula
      then do:
         /* FORMULA CONTROLLED */
         {pxmsg.i
            &MSGNUM     = 263
            &ERRORLEVEL = {&APP-ERROR-RESULT} }
         undo, retry.
      end. /* IF bom_formula THEN DO: */
      batch_size  = bom_batch.
   end. /* ELSE DO */

   assign
      parent      = cPar
      /* SET GLOBAL PART VARIABLE */
      global_part = cPar.

   if batch_size = 0 then batch_size = 1.

   b-loop:
   repeat:
/*GUI*/ if global-beam-me-up then undo, leave.


      if c-application-mode = "API" and retry then
         undo mainloop, next mainloop.

      /* Initialize delete flag before each display of frame */
      batchdelete = "".

      if c-application-mode <> "API" then do:
         prompt-for
            ps_comp
            ps_ref
            ps_start
            /* Prompt for the delete variable in the key frame at the
             * End of the key field/s only when batchrun is set to yes */
            batchdelete no-label when (batchrun) with frame b
         editing:

            if frame-field = "ps_comp"
            then do:
               /* Find next/previous record */
               {mfnp01.i ps_mstr ps_comp ps_comp parent  " ps_mstr.ps_domain =
                global_domain and ps_par "  ps_parcomp}

               if recno <> ?
               then do:
                  assign
                     um   = ""
                     des  = ""
                     des2 = "".

                  for first pt_mstr
                     fields( pt_domain pt_desc1 pt_desc2 pt_formula pt_joint_type
                             pt_part pt_rev pt_status pt_um   /* *SS-20120827.1*   */pt_group)
                      where pt_mstr.pt_domain = global_domain and  pt_part =
                      ps_comp no-lock:
                  end. /* for first pt_mstr */

                  for first bom_mstr
                     fields( bom_domain bom_batch bom_batch_um bom_desc bom_formula
                              bom_fsm_type bom_mod_date bom_parent bom_userid /* *SS-20120827.1*   */bom__chr01 )
                     no-lock  where bom_mstr.bom_domain = global_domain and
                     bom_parent = ps_comp:
                  end. /* for first bom_mstr */

                  if available bom_mstr then
                     assign
                        um = bom_batch_um
                        des = bom_desc.
                  if available pt_mstr
                  then do:
                     assign
                        um  = pt_um
                        rev = pt_rev.
                     if des = "" then
                        assign
                           des  = pt_desc1
                           des2 = pt_desc2.
                  end. /* if available pt_mstr then do: */

                  display
                     ps_comp
                     des
                     rev
                     des2
                     ps_ref
                     ps_qty_per
                     um
                     ps_scrp_pct
                     ps_ps_code
                     ps_fcst_pct
                     ps_lt_off
                     ps_op
                     ps_start
                     ps_end
                     ps_start @ psstart
                     ps_end   @ psend
                     ps_rmks
                     ps_item_no
                     ps_group
                     ps_process
                  with frame b.
               end. /* recno <> ? */

               /* Under DT UI, the extra "HELP" keys sent by the ProcessAgent
                * cause mfnp01.i to pre-maturely set 'recno' to ?, which
                * in turn causes the find first/find next sequence in mfnp01.i
                * to become inconsistent with CHAR UI.
                *
                * To resolve this, save the recno here (and also just before
                * 'c-block' later on) when the readkey is NOT getting
                * a "HELP" key (ie it's NOT a WidgetWalk trigger). When
                * readkey does encounter a "HELP" key (ie WW trigger),
                * restore 'recno' to the previously saved recid value. */
               if {gpiswrap.i} then do:
                  if keyfunction(lastkey) = "HELP" then
                     assign recno = saved-recno.
                  else assign saved-recno = recno.
               end.

            end. /* frame-field = "ps_comp" */
            else do:
               readkey.
               apply lastkey.
            end. /* else do: */
         end.
/*GUI*/ if global-beam-me-up then undo, leave.
 /* prompt-for */
      end. /* if c-application-mode <> "API" */
 /* *SS-20120827.1*   */

      /*************tfq added begin********************************/
      /*added by kevin, 10/16/2003 for site control*/
                  if xxbomc_part_site = site and not available pt_mstr then 
do:
                     message 
"根据BOM控制文件,本地点只能使用零件号作为'子零件'!" view-as alert-box error.
                        undo,retry.
                  end.
                   /*tfq add field bom__chr01*/  for first bom_mstr
                  fields (bom_batch bom_batch_um bom_desc bom_formula
                           bom_fsm_type bom_mod_date bom_parent bom_userid bom__chr01)
                  no-lock where bom_mstr.bom_domain = global_domain and  bom_parent = ps_comp:
               end. /* for first bom_mstr */

                  if available bom_mstr and  bom__chr01 <> site and not available pt_mstr then do:
                        find first ps_mstr where ps_mstr.ps_domain = global_domain 
			                    and ps_par = cPar 
			                    and ps_comp = cComp 
					    and ps_ref = cRef 
					    and ps_start = dtStart no-error.
                        if not available ps_mstr then do:
                              message 
"子零件物料单代码的地点与输入的地点不一致,请重新输入!" view-as alert-box 
error.
                              undo, retry.
                        end.
                        else do:
                              message 
"子零件物料单代码的地点与输入的地点不一致!" view-as alert-box message.
                        end.
                  end.
/*end added by kevin, 10/16/2003*/
      /*************tfq added end*********************************/
      
      /*****************tfq***************************************/
/*added by kevin, 10/20/2003 for site control*/
    find first ptp_det where ptp_det.ptp_domain = global_domain and ptp_site = site and ptp_part = 
input ps_comp no-lock no-error.
         if not available ptp_det then do:
             message "该零件的地点计划数据不存在,请重新输入!" 
view-as alert-box error.
                       undo,retry.
                  end.
/*end added by kevin, 10/20/2003*/
/*added by kevin, 10/20/2003 for site control*/
        if (available ptp_det and ptp_phantom) or (not available pt_mstr) 
then do:
            find first ps_mstr where ps_mstr.ps_domain = global_domain and ps_par = input ps_comp and ps__chr01 <> 
site no-lock no-error.
            if available ps_mstr then do:
                 message "该子零件存在 '" + ps__chr01 + " '地点的产品结构" 
view-as alert-box error.
                 undo,retry.
            end.
            find first ps_mstr where ps_mstr.ps_domain = global_domain and  ps_comp = input ps_comp and ps__chr01 
<> site no-lock no-error.
            if available ps_mstr then do:
                 message "该子零件存在 '" + ps__chr01 + " '地点的产品结构" 
view-as alert-box error.
                 undo,retry.
            end.
        end.
/*end added by kevin, 10/20/2003*/
/**********************tfq added end***********************/

  /* *SS-20120827.1*   */

      /* Assign the local variables from either the UI or API */
      assign
         cComp   = if c-application-mode <> "API" then
                     (input ps_comp)
                   else
                      ttProductStructure.psComp
         cRef    = if c-application-mode <> "API" then
                     (input ps_ref)
                   else
                      ttProductStructure.psRef
         dtStart = if c-application-mode <> "API" then
                     (input ps_start)
                   else
                      ttProductStructure.psStart.

      if cComp = cPar
      then do:

         /* Cyclic structure not allowed. */
         {pxmsg.i &MSGNUM = 206 &ERRORLEVEL = {&APP-ERROR-RESULT} }

         /* If there is error during batch run(cim) then */
         /* leave the current loop after undoing b-loop, */
         /* this avoids storing of incomplete records.   */
         if batchrun = yes then
            undo b-loop, leave.
         else
            undo, retry.
      end. /* if cComp = cPar then do: */

      assign
         um   = ""
         des  = ""
         des2 = ""
         rev  = "".

      for first pt_mstr
         fields( pt_domain pt_desc1 pt_desc2 pt_formula pt_joint_type
                 pt_part pt_rev pt_status pt_um  /* *SS-20120827.1*   */ pt_group)
          where pt_mstr.pt_domain = global_domain and pt_part = cComp
          no-lock:
      end. /* for first pt_mstr */

      for first bom_mstr
         fields( bom_domain bom_batch bom_batch_um bom_desc bom_formula
                 bom_fsm_type bom_mod_date bom_parent bom_userid /* *SS-20120827.1*   */ bom__chr01)
         no-lock  where bom_mstr.bom_domain = global_domain and
         bom_parent = cComp:
      end. /* for first bom_mstr */

      if available bom_mstr
      then do:

         {pxrun.i &PROC = 'validateBlankBomFsmType' &PROGRAM = 'bmpsxr.p'
                 &PARAM = "(INPUT bom_fsm_type)"
            &CATCHERROR = true
            &NOAPPERROR = true
         }

         if return-value <> {&SUCCESS-RESULT} then do:
            if batchrun = yes then
               undo b-loop, leave.
            else
               undo, retry.
         end.

         assign
            um  = bom_batch_um
            des = bom_desc.
      end.  /* if available bom_mstr */

      if available pt_mstr
      then do:

         {pxrun.i &PROC = 'validateItemNotBaseProcess' &PROGRAM = 'bmpscxr.p'
                 &PARAM = "(INPUT cComp)"
            &CATCHERROR = true
            &NOAPPERROR = true
         }

         if return-value <> {&SUCCESS-RESULT} then do:
            if batchrun = yes then
               undo b-loop, leave.
            else
               undo, retry.
         end. /* if pt_joint_type = "5" then do: */

         assign
            um  = pt_um
            rev = pt_rev.

         if des = "" then
            assign
               des  = pt_desc1
               des2 = pt_desc2.
      end. /* if available pt_mstr then do: */

      find first ps_mstr exclusive-lock where
         ps_domain = global_domain and
         ps_par    = cPar          and
         ps_ref    = cRef          and
         ps_comp   = cComp         and
         ps_start  = dtStart
      no-error.

      if not available ps_mstr
      then do:

 /* *SS-20120827.1*  -b */
 /*judy 07/14/05*//*added by kevin, 11/18/2003*/
/*judy 07/14/05*/ message "产品结构不存在,请重新输入!" view-as alert-box error.
/*judy 07/14/05*/ undo b-loop, retry.
/*judy 07/14/05*//*end added by kevin, 11/18/2003*/
  /* *SS-20120827.1* -e  */

         {pxrun.i &PROC = 'processCreate' &PROGRAM = 'bmpscxr.p'
                 &PARAM = "(INPUT  cPar,
                            INPUT  cComp,
                            INPUT  cRef,
                            INPUT  dtStart,
                            INPUT  '',
                            buffer ps_mstr)"
            &CATCHERROR = true
         }

         /* 1 - ADDING NEW RECORD */
         {pxmsg.i &MSGNUM = 1 &ERRORLEVEL = {&INFORMATION-RESULT} }

         /* Set the defaults on create of record */
         if c-application-mode = "API" then do:
            assign
               {mfaidflt.i ttProductStructure.psQtyPer  ps_qty_per}
               {mfaidflt.i ttProductStructure.psPsCode  ps_ps_code}
               {mfaidflt.i ttProductStructure.psEnd     ps_end}
               {mfaidflt.i ttProductStructure.psRmks    ps_rmks}
               {mfaidflt.i ttProductStructure.psScrpPct ps_scrp_pct}
               {mfaidflt.i ttProductStructure.psLtOff   ps_lt_off}
               {mfaidflt.i ttProductStructure.psOp      ps_op}
               {mfaidflt.i ttProductStructure.psItemNo  ps_item_no}
               {mfaidflt.i ttProductStructure.psFcstPct ps_fcst_pct}
               {mfaidflt.i ttProductStructure.psGroup   ps_group}
               {mfaidflt.i ttProductStructure.psProcess ps_process}.
         end. /* if c-application-mode = "API" */
      end. /* if not available ps_mstr */

      {pxrun.i &PROC = 'preEditStructureValidation' &PROGRAM = 'bmpscxr.p'
              &PARAM = "(buffer ps_mstr)"
         &CATCHERROR = true
         &NOAPPERROR = true
      }

      if return-value <> {&SUCCESS-RESULT}
      then do:
         if batchrun = yes then
            undo b-loop, leave.
         else
            undo, retry.
      end.


      assign
         recno    = recid(ps_mstr)
         ps_recno = recno.

      /* Set global part variable */
      global_part = ps_comp.

      if c-application-mode <> "API" then do:
         display
            ps_comp
            des
            rev
            des2
            ps_ref
            ps_qty_per
            um
            ps_scrp_pct
            ps_ps_code
            ps_fcst_pct
            ps_lt_off
            ps_op
            ps_rmks
            ps_start
            ps_end
            ps_start @ psstart
            ps_end   @ psend
            ps_item_no
            ps_group
            ps_process
         with frame b.
      end. /* if c-application-mode <> "API" */

      if not batchrun
      then do:

         {pxrun.i &PROC = 'validateEffectiveDates' &PROGRAM = 'bmpscxr.p'
                 &PARAM = "(buffer ps_mstr, input overlap-warning)"
            &CATCHERROR = true
            &NOAPPERROR = true
         }

      end.  /* If not batchrun...   */

      if c-application-mode <> "API" then do:
         ststatus = stline[2].
         status input ststatus.
      end. /* if c-application-mode <> "API" */

      assign
         del-yn  = no
         psstart = ps_start
         psend   = ps_end.

      /* We need to save the current recid of the ps_mstr being
       * updated/created, so that it can be used by the editing block
       * under "b-loop: prompt-for ps_comp ..." to restore the right
       * 'recno' value required for mfnp01.i to correctly scroll
       * to the next or previous record under DT UI */
      assign
         saved-recno = recno.

      c-block:
      do on error undo, retry:
/*GUI*/ if global-beam-me-up then undo, leave.


         if c-application-mode = "API" and retry then
            undo mainloop, next mainloop.

         assign
            old_qty_per  = ps_qty_per
            old_ps_code  = ps_ps_code
            old_rmks     = ps_rmks
            old_scrp_pct = ps_scrp_pct
            old_lt_off   = ps_lt_off
            old_op       = ps_op
            old_item_no  = ps_item_no
            old_fcst_pct = ps_fcst_pct
            old_group    = ps_group
            old_process  = ps_process.

         if c-application-mode <> "API" then do:
            set
 /* *SS-20120827.1*
               ps_qty_per
               ps_ps_code
               psstart
               psend
               ps_rmks
               ps_scrp_pct
               ps_lt_off   ***/ 
               ps_op
 /* *SS-20120827.1*
               ps_item_no
               ps_fcst_pct
               ps_group
               ps_process
               go-on ("F5" "CTRL-D")  ***/ 
            with frame b no-validate.
         end. /* if c-application-mode <> "API" */
         else do:
            if ttProductStructure.operation <> {&REMOVE} then
            assign
               ps_qty_per  = ttProductStructure.psQtyPer
               ps_ps_code  = ttProductStructure.psPsCode
               psstart     = ttProductStructure.psStart
               psend       = ttProductStructure.psEnd
               ps_rmks     = ttProductStructure.psRmks
               ps_scrp_pct = ttProductStructure.psScrpPct
               ps_lt_off   = ttProductStructure.psLtOff
               ps_op       = ttProductStructure.psOp
               ps_item_no  = ttProductStructure.psItemNo
               ps_fcst_pct = ttProductStructure.psFcstPct
               ps_group    = ttProductStructure.psGroup
               ps_process  = ttProductStructure.psProcess.
         end. /* if c-application-mode = "API" */

         assign
            comp   = ps_comp
            parent = ps_par.

         /* VALIDATE FIELD SECURITY */
         if old_qty_per <> ps_qty_per
         then do:
            {pxrun.i &PROC='validateFieldAccess' &PROGRAM='gpsecxr.p'
               &HANDLE=ph_gpsecxr
               &PARAM="(input 'ps_qty_per',
                        input '')"
               &NOAPPERROR=true
               &CATCHERROR=true}
            if return-value <> {&SUCCESS-RESULT}
            then do:
               if c-application-mode <> "API" then
                  next-prompt ps_qty_per with frame b.
               undo, retry.
            end.
         end.

         if old_ps_code <> ps_ps_code
         then do:
            {pxrun.i &PROC='validateFieldAccess' &PROGRAM='gpsecxr.p'
               &HANDLE=ph_gpsecxr
               &PARAM="(input 'ps_ps_code',
                        input '')"
               &NOAPPERROR=true
               &CATCHERROR=true}
            if return-value <> {&SUCCESS-RESULT}
            then do:
               if c-application-mode <> "API" then
                  next-prompt ps_ps_code with frame b.
               undo, retry.
            end.
         end.

         if old_rmks <> ps_rmks
         then do:
            {pxrun.i &PROC='validateFieldAccess' &PROGRAM='gpsecxr.p'
               &HANDLE=ph_gpsecxr
               &PARAM="(input 'ps_rmks',
                        input '')"
               &NOAPPERROR=true
               &CATCHERROR=true}
            if return-value <> {&SUCCESS-RESULT}
            then do:
               if c-application-mode <> "API" then
                  next-prompt ps_rmks with frame b.
               undo, retry.
            end.
         end.

         if old_scrp_pct <> ps_scrp_pct
         then do:
            {pxrun.i &PROC='validateFieldAccess' &PROGRAM='gpsecxr.p'
               &HANDLE=ph_gpsecxr
               &PARAM="(input 'ps_scrp_pct',
                        input '')"
               &NOAPPERROR=true
               &CATCHERROR=true}
            if return-value <> {&SUCCESS-RESULT}
            then do:
               if c-application-mode <> "API" then
                  next-prompt ps_scrp_pct with frame b.
               undo, retry.
            end.
         end.

         if old_lt_off <> ps_lt_off
         then do:
            {pxrun.i &PROC='validateFieldAccess' &PROGRAM='gpsecxr.p'
               &HANDLE=ph_gpsecxr
               &PARAM="(input 'ps_lt_off',
                        input '')"
               &NOAPPERROR=true
               &CATCHERROR=true}
            if return-value <> {&SUCCESS-RESULT}
            then do:
               if c-application-mode <> "API" then
                  next-prompt ps_lt_off with frame b.
               undo, retry.
            end.
         end.

         if old_op <> ps_op
         then do:
            {pxrun.i &PROC='validateFieldAccess' &PROGRAM='gpsecxr.p'
               &HANDLE=ph_gpsecxr
               &PARAM="(input 'ps_op',
                        input '')"
               &NOAPPERROR=true
               &CATCHERROR=true}
            if return-value <> {&SUCCESS-RESULT}
            then do:
               if c-application-mode <> "API" then
                  next-prompt ps_op with frame b.
               undo, retry.
            end.
         end.

         if old_item_no <> ps_item_no
         then do:
            {pxrun.i &PROC='validateFieldAccess' &PROGRAM='gpsecxr.p'
               &HANDLE=ph_gpsecxr
               &PARAM="(input 'ps_item_no',
                        input '')"
               &NOAPPERROR=true
               &CATCHERROR=true}
            if return-value <> {&SUCCESS-RESULT}
            then do:
               if c-application-mode <> "API" then
                  next-prompt ps_item_no with frame b.
               undo, retry.
            end.
         end.

         if old_fcst_pct <> ps_fcst_pct
         then do:
            {pxrun.i &PROC='validateFieldAccess' &PROGRAM='gpsecxr.p'
               &HANDLE=ph_gpsecxr
               &PARAM="(input 'ps_fcst_pct',
                        input '')"
               &NOAPPERROR=true
               &CATCHERROR=true}
            if return-value <> {&SUCCESS-RESULT}
            then do:
               if c-application-mode <> "API" then
                  next-prompt ps_fcst_pct with frame b.
               undo, retry.
            end.
         end.

         if old_group <> ps_group
         then do:
            {pxrun.i &PROC='validateFieldAccess' &PROGRAM='gpsecxr.p'
               &HANDLE=ph_gpsecxr
               &PARAM="(input 'ps_group',
                        input '')"
               &NOAPPERROR=true
               &CATCHERROR=true}
            if return-value <> {&SUCCESS-RESULT}
            then do:
               if c-application-mode <> "API" then
                  next-prompt ps_group with frame b.
               undo, retry.
            end.
         end.

         if not ({gpcode.v ps_group})
         then do:
            /* VALUE MUST EXIST IN GENERALIZED CODES */
            {pxmsg.i &MSGNUM=716 &ERRORLEVEL=3 &FIELDNAME=""psGroup""}
            if c-application-mode <> "API" then
               next-prompt ps_group with frame b.
            undo, retry.
         end.

         if old_process <> ps_process
         then do:
            {pxrun.i &PROC='validateFieldAccess' &PROGRAM='gpsecxr.p'
               &HANDLE=ph_gpsecxr
               &PARAM="(input 'ps_process',
                        input '')"
               &NOAPPERROR=true
               &CATCHERROR=true}
            if return-value <> {&SUCCESS-RESULT}
            then do:
               if c-application-mode <> "API" then
                  next-prompt ps_process with frame b.
               undo, retry.
            end.
         end.

         if not ({gpcode.v ps_process})
         then do:
            /* VALUE MUST EXIST IN GENERALIZED CODES */
            {pxmsg.i &MSGNUM=716 &ERRORLEVEL=3 &FIELDNAME=""psProcess""}
            if c-application-mode <> "API" then
               next-prompt ps_process with frame b.
            undo, retry.
         end.

         if     lastkey <> keycode("F5")
             or lastkey <> keycode("CTRL-D")
         then do:

            for first ps_mstr1
               where  ps_mstr1.ps_domain = global_domain
               and    ps_mstr1.ps_par    = parent
               and    ps_mstr1.ps_comp   = comp
               and    ps_mstr1.ps_ref    = ps_mstr.ps_ref
               and   (ps_mstr1.ps_start  = psstart and
                      psstart           <> ?)
               and    recid(ps_mstr1)   <> saved-recno

            no-lock:
               /*DUPLICATE RECORD EXISTS.CANNOT CREATE*/
               {pxmsg.i &MSGNUM = 2142 &ERRORLEVEL = 3 }
               if batchrun = yes
               then
                  undo b-loop, leave.
               else
                  if c-application-mode <> "API" then
                     next-prompt psstart with frame b.
                  undo b-loop, retry.
            end. /*FOR FIRST ps_mstr*/
         end.
/*GUI*/ if global-beam-me-up then undo, leave.
 /*LASTKEY <> KEYCODE("F5")*/

         {pxrun.i &PROC = 'validateNotJointStructure' &PROGRAM = 'bmpscxr.p'
                 &PARAM = "(input ps_ps_code)"
            &CATCHERROR = true
            &NOAPPERROR = true
         }

         if return-value <> {&SUCCESS-RESULT} then do:
            if batchrun = yes then
               undo b-loop, leave.
            else
               undo, retry.
         end. /* if ps_ps_code = "J" then do: */

         /* Delete */
         if c-application-mode <> "API" then do:
            if lastkey = keycode("F5")
            or lastkey = keycode("CTRL-D")
            /* Delete to be executed if batchdelete is set to "x" */
            or input batchdelete = "x":U
            then do:
               del-yn = yes.

               /* 11 - Please confirm delete */
               {pxmsg.i &MSGNUM = 11
                        &ERRORLEVEL = {&INFORMATION-RESULT}
                        &CONFIRM = del-yn
               }

               if del-yn = no then undo, retry.
            end.
         end. /* if c-application-mode <> "API" */
         else do:
            del-yn = (ttProductStructure.operation = {&REMOVE}).
         end. /* if c-application-mode = "API" */

         if del-yn then do:
            {pxrun.i &PROC = 'processDelete' &PROGRAM = 'bmpscxr.p'
                    &PARAM = "(buffer ps_mstr)"
               &CATCHERROR = true
            }

            del-yn = no.

            /* 22 - Record deleted */
            {pxmsg.i &MSGNUM = 22 &ERRORLEVEL = {&INFORMATION-RESULT} }

            if c-application-mode = "API" then
               leave b-loop.

            next b-loop.
         end. /* then do: */
         else do: /* Modify */

            /* Store modify date and userid */
            assign
               ps_start     = psstart
               ps_end       = psend.

            {pxrun.i &PROC = 'validateEffectiveDates' &PROGRAM = 'bmpscxr.p'
                    &PARAM = "(buffer ps_mstr, input overlap-error)"
               &CATCHERROR = true
               &NOAPPERROR = true
            }

            if return-value <> {&SUCCESS-RESULT} then do:
               if batchrun = yes then
                  undo b-loop, leave.
               else do:
                  if c-application-mode <> "API" then
                     next-prompt psstart with frame b.
                  undo c-block, retry.
               end.
            end.

        {pxrun.i &PROC = 'validateCyclicStructures' &PROGRAM = 'bmpscxr.p'
                     &PARAM = "(recid(ps_mstr))"
                     &CATCHERROR = true
                     &NOAPPERROR = true
            }

            if return-value <> {&SUCCESS-RESULT}
            then do:
               if batchrun = yes
               then
                  undo b-loop, leave.
               else
                  undo, retry.
            end.

        {pxrun.i &PROC = 'maintainBatchQtyPer' &PROGRAM = 'bmpscxr.p'
                    &PARAM = "(buffer ps_mstr)"
            }

            {pxrun.i &PROC = 'processWrite' &PROGRAM = 'bmpscxr.p'
                    &PARAM = "(buffer ps_mstr)"
               &CATCHERROR = true
               &NOAPPERROR = true
            }

            if  return-value <> {&SUCCESS-RESULT}
            and return-value <> {&WARNING-RESULT}
            then do:
               if batchrun = yes
               then
                  undo b-loop, leave.
               else
                  undo, retry.
            end. /* IF return-value <> {&SUCCESS-RESULT} */

            if c-application-mode <> "API" then do:
               display
                  ps_start
                  ps_end
               with frame b.
            end. /* if c-application-mode <> "API" */
            else do:
               /* Run any customizations in API mode for ps_mstr */
               run applyCustomizations in ApiMethodHandle
                  (input "ttProductStructure",
                   input (buffer ps_mstr:handle),
                   input "a,b",
                   output lCustomOK).

               if not lCustomOK then
                  undo, retry.

               leave b-loop.
            end. /* if c-application-mode = "API" */

         end. /* Modify */
 /* *SS-20120827.1*   */
        /*********************tfq added begin*********************************/
        /*added by kevin, 11/09/2003*/
             if input ps_op <> 0 then do:
                  find opm_mstr where opm_mstr.opm_domain = global_domain and opm_std_op = input ps_op no-lock 
no-error.
                  if not available opm_mstr then do:
                     message "错误:标准工序不存在,请重新输入!" view-as 
alert-box error.
                     next-prompt ps_op.
                     undo,retry.
                  end.
                /*kevin,12/28/2003
                  if opm__chr01 <> ps__chr01 then do:
                     message 
"错误:标准工序的地点与BOM的地点不一致,请重新输入!" view-as alert-box error.
                     next-prompt ps_op.
                     undo,retry.
                  end.
                */
             end.
/*end added by kevin, 11/09/2003*/
        /*********************tfq added end************************************/


  /* *SS-20120827.1*   */
      end. /* do on error */
   end. /* b-loop: repeat with frame b: */
end. /* mainloop: repeat with frame a: */

if c-application-mode <> "API" then
   status input.
