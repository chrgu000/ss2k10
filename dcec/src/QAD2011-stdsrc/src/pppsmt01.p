/* GUI CONVERTED from pppsmt01.p (converter v1.78) Tue Oct  6 19:38:45 2009 */
/* pppsmt01.p - ITEM SITE INVENTORY MAINTENANCE                         */
/* Copyright 1986-2009 QAD Inc., Santa Barbara, CA, USA.                */
/* All rights reserved worldwide.  This is an unpublished work.         */
/* REVISION: 7.0      LAST MODIFIED: 10/09/91   BY: pma *F003*          */
/* REVISION: 7.0      LAST MODIFIED: 03/11/92   BY: pma *F087*          */
/* REVISION: 7.0      LAST MODIFIED: 07/23/92   BY: pma *F782*          */
/* REVISION: 7.3      LAST MODIFIED: 08/12/93   BY: ram *GE15*          */
/* REVISION: 7.3      LAST MODIFIED: 02/15/94   BY: pxd *FL60*          */
/* REVISION: 7.3      LAST MODIFIED: 06/06/94   BY: ais *FO63*          */
/* REVISION: 7.3      LAST MODIFIED: 06/28/94   BY: pxd *FP14*          */
/*           7.3                     09/03/94   BY: bcm *GL93*          */
/* REVISION: 8.5      LAST MODIFIED: 10/17/94   BY: mwd *J034*          */
/* REVISION: 8.5      LAST MODIFIED: 01/05/95   BY: pma *J040*          */
/* REVISION: 7.2      LAST MODIFIED: 05/04/95   BY: qzl *F0R6*          */
/* REVISION: 8.5      LAST MODIFIED: 12/05/96   BY: *G2HJ* Murli Shastri      */
/* REVISION: 8.5      LAST MODIFIED: 07/07/97   BY: *J1PS* Felcy D'Souza      */
/* REVISION: 8.6      LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan         */
/* REVISION: 9.0      LAST MODIFIED: 02/22/99   BY: *M08Y* Niranjan R.        */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00 BY: *N08T* Annasaheb Rahane     */
/* REVISION: 9.1      LAST MODIFIED: 08/13/00 BY: *N0KQ* myb                  */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* Old ECO marker removed, but no ECO header exists *H1HP*                    */
/* Revision: 1.10.1.6  BY: Zheng Huang DATE: 01/31/02 ECO: *P000*             */
/* Revision: 1.10.1.8  BY: Paul Donnelly (SB) DATE: 06/28/03 ECO: *Q00K*      */
/* Revision: 1.10.1.9  BY: Rajinder Kamra  DATE: 06/23/03  ECO *Q003*         */
/* Revision: 1.10.1.10.2.2  BY: Ken Casey  DATE: 02/22/05 ECO: *P38T*         */
/* Revision: 1.10.1.10.2.3  BY: Chi Liu    DATE: 12/12/07 ECO: *P6BR*         */
/* Revision: 1.10.1.10.2.5  BY: Archana Kirtane  DATE: 02/01/08  ECO: *P6KY*  */
/* Revision: 1.10.1.10.2.6  BY: Chi Liu          DATE: 02/20/09  ECO: *Q22F*  */
/* $Revision: 1.10.1.10.2.8 $  BY: Evan Todd        DATE: 09/02/09  ECO: *Q3BT*  */
/*-Revision end---------------------------------------------------------------*/

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/
/*V8:ConvertMode=Maintenance                                                  */

{mfdtitle.i "1+ "}
{pxmaint.i}

/* COMMON API CONSTANTS AND VARIABLES */
{mfaimfg.i}

/* Item Site Inventory API Dataset definition */
{ppdsps01.i "reference-only"}

define variable part like in_part.
define variable site like in_site.

/* Local variables to replace "input" screen variables */
define variable cPart as character.
define variable cSite as character.
define variable lCustomOK as logical no-undo.

{pxphdef.i gpcodxr}
{pxphdef.i ppitxr}

&SCOPED-DEFINE QXO-EVENT ItemSiteInventoryMaintenance
&SCOPED-DEFINE QXO-TABLE in_mstr
{qxodef.i}

define variable inrecno as recid no-undo.

{pxpgmmgr.i}


/*GUI preprocessor Frame A define */
&SCOPED-DEFINE PP_FRAME_NAME A

FORM /*GUI*/  
 RECT-FRAME       AT ROW 1 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1 COLUMN 3 NO-LABEL VIEW-AS TEXT SIZE-PIXELS 1 BY 1
 SKIP(.1)  /*GUI*/
{ppptmta1.i}
   site colon 19
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



if c-application-mode <> "API" then do:
   /* SET EXTERNAL LABELS */
   setFrameLabels(frame a:handle).

   display site       skip(.4)    with frame a.

   display global_part @ pt_part global_site @ site with frame a.
end. /* c-application-mode <> "API" */

FORM /*GUI*/ 
   
 RECT-FRAME       AT ROW 1 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1 COLUMN 3 NO-LABEL VIEW-AS TEXT SIZE-PIXELS 1 BY 1
 SKIP(.1)  /*GUI*/
in_abc             colon 20
   in_iss_date        colon 58
   in_avg_int         colon 20
   in_avg_date        colon 58
   in_cyc_int         colon 20
   in_cnt_date        colon 58
   in_loc             colon 20
   in_rctpo_status    colon 20
   in_rctpo_active    colon 37
   in_rctwo_status    colon 20
   in_rctwo_active    colon 37
 SKIP(.4)  /*GUI*/
with frame c side-labels width 80 attr-space NO-BOX THREE-D /*GUI*/.

 DEFINE VARIABLE F-c-title AS CHARACTER INITIAL "".
 RECT-FRAME-LABEL:SCREEN-VALUE in frame c = F-c-title.
 RECT-FRAME-LABEL:HIDDEN in frame c = yes.
 RECT-FRAME:HEIGHT-PIXELS in frame c =
  FRAME c:HEIGHT-PIXELS - RECT-FRAME:Y in frame c - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME c = FRAME c:WIDTH-CHARS - .5.  /*GUI*/


if c-application-mode <> "API" then do:
   /* SET EXTERNAL LABELS */
   setFrameLabels(frame c:handle).
end. /* c-application-mode <> "API" */
else do:
  /* Get handle to API controller */
  {gprun.i ""gpaigach.p"" "(output ApiMethodHandle)"}
/*GUI*/ if global-beam-me-up then undo, leave.


  if(not valid-handle(ApiMethodHandle)) then do:
    /* API Error */
    {pxmsg.i &MSGNUM=10461 &ERRORLEVEL=4}
    return.
  end.

  /* Get the item site inventory code dataset from the controller */
  run getRequestDataset in ApiMethodHandle(output dataset dsItemSiteInventory bind).
end. /* c-application-mode = "API" */

/* DISPLAY */

mainloop:
repeat:
/*GUI*/ if global-beam-me-up then undo, leave.

   if c-application-mode = "API" then do:
     if retry then undo, leave.
     run getNextRecord in ApiMethodHandle(input "ttItemSiteInventory").
     if return-value = {&RECORD-NOT-FOUND} then
        leave mainloop.
   end. /* c-application-mode = "API" */

   if c-application-mode <> "API" then do:
      view frame a.
      view frame c.
   end. /* c-application-mode <> "API" */

   do on endkey undo, leave mainloop:

      if c-application-mode <> "API" then do:
         prompt-for pt_part site with frame a no-validate
         editing:

            /* SET GLOBAL PART VARIABLE */

            assign global_part = input pt_part
               global_site = input site.

            if frame-field = "pt_part" then do:
               /* FIND NEXT/PREVIOUS RECORD */
               {mfnp.i in_mstr pt_part  " in_mstr.in_domain = global_domain and
               in_part "  site in_site in_part}
            end.
            else if frame-field = "site" then do:
               /* FIND NEXT/PREVIOUS RECORD */
               /* Changed search index from "in_site" to "in_part" */
               /* FIND NEXT/PREVIOUS RECORD */
               {mfnp01.i in_mstr site in_site in_part
                  " in_mstr.in_domain = global_domain and input  pt_part" in_part}
            end.
            else do:
               readkey.
               apply lastkey.
            end.

            if recno <> ? then do:
               find pt_mstr where pt_mstr.pt_domain = global_domain and
                  pt_part = in_part no-lock no-error.

               if available pt_mstr then do:

                  display {ppptmta1.i} with frame a.
                  display in_part @ pt_part in_site @ site with frame a.

                  if in_abc = ? then
                  display
                     "" @ in_abc
                     "" @ in_avg_int
                     "" @ in_cyc_int
                  with frame c.
                  else
                  display
                     in_abc
                     in_iss_date
                     in_avg_int
                     in_avg_date
                     in_cyc_int
                     in_cnt_date
                     in_loc
                     in_rctpo_status
                     in_rctpo_active
                     in_rctwo_status
                     in_rctwo_active
                  with frame c.

               end. /* if available pt_mstr */

            end. /* if recno <> ? */
         end. /* prompt-for pt_part site */
      end. /* c-application-mode <> "API" */

      if c-application-mode <> "API" then
         assign
            cPart = input pt_part
            cSite = input site.
      else
         assign
            cPart = ttItemSiteInventory.ptPart
            cSite = ttItemSiteInventory.site.

      /* ADD/MODIFY  */
      /*NOTE: DELETING THE IN_MSTR RECORD SHOULD NOT BE ALLOWED. */
      if not can-find (pt_mstr where pt_mstr.pt_domain = global_domain and
      pt_part = cPart) then do:
         {pxmsg.i &MSGNUM=16 &ERRORLEVEL=3} /* ITEM NUMBER IS NOT AVAILABLE */
         undo, retry.
      end.

      if not can-find (si_mstr  where si_mstr.si_domain = global_domain and
      si_site = cSite) then do:
         {pxmsg.i &MSGNUM=708 &ERRORLEVEL=3} /* SITE IS NOT AVAILABLE */
         if c-application-mode <> "API" then
            next-prompt site with frame a.
         undo, retry.
      end.

      find si_mstr where si_mstr.si_domain = global_domain and
         si_site = cSite no-lock no-error.
      if available si_mstr and si_db <> global_db then do:
         /* SITE NOT ASSIGNED TO THIS DOMAIN */
         {pxmsg.i &MSGNUM=6251 &ERRORLEVEL=3}
         if c-application-mode <> "API" then
            next-prompt site with frame a.
         undo, retry.
      end.

      if available si_mstr then do:
         {gprun.i ""gpsiver.p""
            "(input cSite, input recid(si_mstr), output return_int)"}
/*GUI*/ if global-beam-me-up then undo, leave.

         if return_int = 0 then do:
            {pxmsg.i &MSGNUM=725 &ERRORLEVEL=3}
            /* USER DOES NOT HAVE ACCESS TO SITE */
            if c-application-mode <> "API" then
               next-prompt site with frame a.
            undo mainloop, retry mainloop.
         end.
      end.

      find pt_mstr where pt_mstr.pt_domain = global_domain and
         pt_part = cPart
      exclusive-lock no-error.
      if not available pt_mstr then do:
         {pxmsg.i &MSGNUM=16 &ERRORLEVEL=3} /* ITEM NUMBER IS NOT AVAILABLE */
         undo, retry.
      end.

      find ptp_det where ptp_det.ptp_domain = global_domain and
         ptp_part = pt_part and
         ptp_site = cSite
      no-lock no-error.

      find in_mstr where in_mstr.in_domain = global_domain and
         in_part = pt_part and
         in_site = cSite
      exclusive-lock no-error.

      /* NEW ITEM */
      if not available in_mstr then do:
         {pxmsg.i &MSGNUM=1 &ERRORLEVEL=1} /* CREATING NEW RECORD */

         if c-application-mode <> "API" then
            assign site.

         {gprun.i ""gpincr.p"" "(input no,
              input pt_part,
              input cSite,
              input si_gl_set,
              input si_cur_set,
              input pt_abc,
              input pt_avg_int,
              input pt_cyc_int,
              input pt_rctpo_status,
              input pt_rctpo_active,
              input pt_rctwo_status,
              input pt_rctwo_active,
              output inrecno)"}
/*GUI*/ if global-beam-me-up then undo, leave.


         find in_mstr where recid(in_mstr) = inrecno
         exclusive-lock.

         {gpsct04.i &type=""GL""}
         {gpsct04.i &type=""CUR""}

      end. /* if not available in_mstr */

      if in_abc = ? then in_abc = pt_abc.

      if in_avg_int = ? then  in_avg_int = pt_avg_int.
      if in_cyc_int= ? then in_cyc_int = pt_cyc_int.

      if c-application-mode <> "API" then do:
         display {ppptmta1.i} with frame a.
         display in_part @ pt_part in_site @ site with frame a.
         display
            in_abc
            in_iss_date
            in_avg_int
            in_avg_date
            in_cyc_int
            in_cnt_date
            in_loc
            in_rctpo_status
            in_rctpo_active
            in_rctwo_status
            in_rctwo_active
         with frame c.
      end. /* c-application-mode <> "API" */
      else do:
         assign
            {mfaidflt.i ttItemSiteInventory.ptiAbc in_abc}
            {mfaidflt.i ttItemSiteInventory.inIssDate in_iss_date}
            {mfaidflt.i ttItemSiteInventory.ptiAvgInt in_avg_int}
            {mfaidflt.i ttItemSiteInventory.inAvgDate in_avg_date}
            {mfaidflt.i ttItemSiteInventory.ptiCycInt in_cyc_int}
            {mfaidflt.i ttItemSiteInventory.inCntDate in_cnt_date}
            {mfaidflt.i ttItemSiteInventory.ptiLoc in_loc}
            {mfaidflt.i ttItemSiteInventory.ptiRctpoActive in_rctpo_active}
            {mfaidflt.i ttItemSiteInventory.ptiRctpoStatus in_rctpo_status}
            {mfaidflt.i ttItemSiteInventory.ptiRctwoActive in_rctwo_active}
            {mfaidflt.i ttItemSiteInventory.ptiRctwoStatus in_rctwo_status}.
      end.

      /* RECORD QXTEND OUTBOUND EVENT  */
      {qxotrign.i
         &EVENT-NAME = 'ItemSiteInventoryMaintenance'
         &TABLE-NAME = 'in_mstr'
         &ROW-ID = string(rowid(in_mstr))
         &OID = string(in_mstr.oid_in_mstr)
         &TRIGGER-TYPE = 'WRITE'}.

      setc:
      do on error undo setc, retry:
/*GUI*/ if global-beam-me-up then undo, leave.

         if c-application-mode <> "API" then do:
            set
               in_abc
               in_avg_int
               in_cyc_int
               in_loc
               in_rctpo_status in_rctpo_active
               when ({gppswd3.i &field=""in_rctpo_status""})
                                in_rctwo_status in_rctwo_active
               when ({gppswd3.i &field=""in_rctwo_status""})
            with frame c.
         end. /* c-application-mode <> "API" */
         else do:
            assign
               in_abc     = ttItemSiteInventory.ptiAbc
               in_avg_int = ttItemSiteInventory.ptiAvgInt
               in_cyc_int = ttItemSiteInventory.ptiCycInt
               in_loc     = ttItemSiteInventory.ptiLoc
               in_rctpo_status = ttItemSiteInventory.ptiRctpoStatus
               in_rctwo_status = ttItemSiteInventory.ptiRctwoStatus.
            if {gppswd3.i &field=""in_rctpo_status""} then
               in_rctpo_active = ttItemSiteInventory.ptiRctpoActive.
            if {gppswd3.i &field=""in_rctwo_status""} then
               in_rctwo_active = ttItemSiteInventory.ptiRctwoActive.
         end. /* c-application-mode = "API" */

         {pxrun.i &PROC = 'validateLocation'
                  &PROGRAM = 'icloxr.p'
                  &PARAM = "(input in_site,
                             input in_loc)"
                  &NOAPPERROR = true
                  &CATCHERROR = true}

         if (in_rctpo_active or in_rctpo_status <> "") and
            not can-find (is_mstr  where is_mstr.is_domain = global_domain and
            is_status = in_rctpo_status)
         then do:

            if c-application-mode <> "API" then
               next-prompt in_rctpo_status with frame c.
            /* INVENTORY STATUS IS NOT DEFINED */
            {pxmsg.i &MSGNUM=361 &ERRORLEVEL=3}
            undo setc, retry.

         end. /* IF (IN_RCTPO_ACTIVE ... */

         if (in_rctwo_active or in_rctwo_status <> "") and
            not can-find (is_mstr  where is_mstr.is_domain = global_domain and
            is_status = in_rctwo_status)
         then do:

            if c-application-mode <> "API" then
               next-prompt in_rctwo_status with frame c.
            /* INVENTORY STATUS IS NOT DEFINED */
            {pxmsg.i &MSGNUM=361 &ERRORLEVEL=3}
            undo setc, retry.

         end. /* IF (IN_RCTWO_ACTIVE ... */

         if c-application-mode = "API" then do:
            /* Run any customizations in API mode for in_mstr */
            run applyCustomizations in ApiMethodHandle
               (input "ttItemSiteInventory",
                input (buffer in_mstr:handle),
                input "a,c",
                output lCustomOK).

            if not lCustomOK then
               undo mainloop, retry mainloop.
         end. /* c-application-mode = "API" */

      end.
/*GUI*/ if global-beam-me-up then undo, leave.
 /* setc */

   end. /* do */

end.
/*GUI*/ if global-beam-me-up then undo, leave.
 /* main loop */

if c-application-mode <> "API" then
   status input.
