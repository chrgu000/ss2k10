/* bmmamt.p - ADD / MODIFY BILL OF MATERIAL MASTER RECORDS                    */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.8.1.5 $                                                         */
/*V8:ConvertMode=Maintenance                                                  */
/* REVISION: 7.0        LAST EDIT: 12/16/91               BY: emb             */
/* REVISION: 7.0        LAST EDIT: 03/20/92               BY: emb *F308*      */
/* REVISION: 7.0        LAST EDIT: 03/24/92               BY: pma *F089*      */
/* REVISION: 7.0        LAST EDIT: 04/29/92               BY: emb *F447*      */
/* REVISION: 7.0        LAST EDIT: 05/26/92               BY: pma *F533*      */
/* REVISION: 7.0        LAST EDIT: 06/18/92               BY: emb *F671*      */
/* REVISION: 7.0        LAST EDIT: 11/10/92               BY: pma *G309*      */
/* REVISION: 7.3        LAST EDIT: 02/24/93               BY: sas *G740*      */
/* Oracle changes (share-locks)    09/11/94               BY: rwl *FR15*      */
/* REVISION: 7.2        LAST EDIT: 10/20/94               BY: ais *FS62*      */
/* REVISION: 7.0        LAST EDIT: 06/01/95               BY: qzl *F0SL*      */
/* REVISION: 8.5    LAST MODIFIED: 07/31/96  BY: *J12T* Sue Poland          */
/* REVISION: 8.5    LAST MODIFIED: 08/06/96  BY: *G2B7* Julie Milligan      */

/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane */
/* REVISION: 8.6E     LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan         */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan         */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00 BY: *N08T* Annasaheb Rahane */
/* Old ECO marker removed, but no ECO header exists *D852*                    */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* $Revision: 1.8.1.5 $    BY: Anil Sudhakaran       DATE: 11/28/01  ECO: *M1FN*  */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/
/* REVISION: 9.1      LAST MODIFIED: 08/11/00 BY: *N0KK* jyn                  */
/* DISPLAY TITLE */
/* REVISION: 8.5    LAST MODIFIED: 10/16/03  BY: Kevin                  */
/* REVISION: eb2_sp6 retrofit by taofengqin  2005/06/30 *tfq*               */
{mfdtitle.i "b+ "}

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE bmmamt_p_1 "Comments"
/*tfq &SCOPED-DEFINE bmmamt_p_2 "site" */
/*tfq*/ &SCOPED-DEFINE bmmamt_p_3 "comp"
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */

define new shared variable comp like ps_comp.
define new shared variable par like ps_par.
define new shared variable level as integer.
define new shared variable qty as decimal.
define new shared variable parent like ps_par.
define new shared variable ps_recno as recid.
define variable des like pt_desc1.
define variable des2 like pt_desc1.
define variable um like pt_um.
define variable del-yn like mfc_logical initial no.
define variable pt_des1 as character format "x(49)".
define variable rev like pt_rev.
define variable item_no like ps_item_no.
define buffer ps_mstr1 for ps_mstr.

define variable batch_qty like bom_batch.
define variable unknown_char as character initial ?.

define variable batch_size like bom_batch.
define variable cmmts like mfc_logical initial no label {&bmmamt_p_1}.
define new shared variable cmtindx as integer.
define variable ptstatus like pt_status.
define variable bomdesc like bom_desc.
define variable ptdesc1 like pt_desc1.
define variable lines as integer.
   def var msg-nbr as inte.                     /*kevin*/
/* Variable added to perform delete during CIM.
 * Record is deleted only when the value of this variable
 * Is set to "X" */
define variable batchdelete as character format "x(1)" no-undo.
 /*GUI preprocessor Frame A define */
&SCOPED-DEFINE PP_FRAME_NAME A

/* DISPLAY SELECTION FORM */
form
RECT-FRAME       AT ROW 1 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1 COLUMN 3 NO-LABEL VIEW-AS TEXT SIZE-PIXELS 1 BY 1
 SKIP(.1)  /*GUI*/
   bom_parent     colon 27
   bomdesc  colon 27
   bom__chr01 colon 27 label   "�ص�"                 /*kevin*/
   bom__chr02 colon 27 label "��Ӧ���" format "x(18)"             /*kevin*/
   bom_batch_um   colon 27
   cmmts          colon 27
   skip(.1)
with frame a side-labels width 80 attr-space NO-BOX THREE-D /*GUI*/.

 DEFINE VARIABLE F-a-title AS CHARACTER INITIAL "".
 RECT-FRAME-LABEL:SCREEN-VALUE in frame a = F-a-title.
 RECT-FRAME-LABEL:HIDDEN in frame a = yes.
 RECT-FRAME:HEIGHT-PIXELS in frame a =
  FRAME a:HEIGHT-PIXELS - RECT-FRAME:Y in frame a - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME a = FRAME a:WIDTH-CHARS - .5.  /*GUI*/

/*GUI preprocessor Frame A undefine */
&UNDEFINE PP_FRAME_NAME/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

/* DISPLAY */
view frame a.

mainloop:
repeat with frame a:

   /* Initialize delete flag before each display of frame */
   batchdelete = "".

   ptdesc1 = ?.
   prompt-for bom_parent
   /* Prompt for the delete variable in the key frame at the
    * End of the key field/s only when batchrun is set to yes */
   batchdelete no-label when (batchrun)
   editing:

      /* FIND NEXT/PREVIOUS RECORD - NON-SERVICE BOMS ONLY */
      {mfnp05.i bom_mstr
         bom_fsm_type
         "bom_fsm_type = "" "" "
         bom_parent
         "input bom_parent"}

      if recno <> ? then do:

         bomdesc = "".
         if bom_desc = "" then do:
            find pt_mstr no-lock where pt_part = bom_parent no-error.
            if available pt_mstr then bomdesc = pt_desc1.
         end.
         else do:
            bomdesc = bom_desc.
         end.

         display bom_parent

            bomdesc
            bom__chr01 bom__chr02                 /*kevin*/
            bom_batch_um.

         if bom_cmtindx <> 0 then display true @ cmmts.
         else display false @ cmmts.
      end.    /* if recno <> ? */
      hide frame b.
   end.    /* editing on bom_parent */

   hide frame b.

   bomdesc = "".

   find bom_mstr exclusive-lock using bom_parent no-error.
   if not available bom_mstr then do:

      if input bom_parent = "" then do:
         /* BLANK NOT ALLOWED */
         {pxmsg.i &MSGNUM=40 &ERRORLEVEL=3}
         undo, retry.
      end.

      find pt_mstr no-lock where pt_part = input bom_parent no-error.
      if available pt_mstr then do:
         ptstatus = pt_status.
         substring(ptstatus,9,1) = "#".
         if can-find(isd_det where isd_status = ptstatus
            and isd_tr_type = "ADD-PS") then do:
            /* RESTRICTED PROCEDURE FOR ITEM STATUS CODE */
            {pxmsg.i
               &MSGNUM=358
               &ERRORLEVEL=3
               &MSGARG1=pt_status
            }
            undo, retry.
         end.
      end.
/************************tfq* added begin*******************/
/*added by kevin, 10/16/2003, to forbid users to create the new bom code*/
      message "���ϵ����벻����,����������!" view-as alert-box error.
      undo,retry.
/*end added by kevin, 10/16/2003*/
/***********tfq added end**********************************/
      /* ADDING NEW RECORD */
      {pxmsg.i &MSGNUM=1 &ERRORLEVEL=1}
      create bom_mstr.
      assign bom_parent = caps(input bom_parent).

      if available pt_mstr then
      assign bom_parent = pt_part

         bom_batch_um = pt_um

         bom_formula = pt_formula.
   end.    /* if not available bom_mstr */
   else do:
      /* WARN USER IF HE'S MAINTAINING A SERVICE BOM HERE */
      if bom_fsm_type <> " " then do:
         /* THIS IS AN SSM BILL OF MATERIAL NOT A STANDARD ONE */
         {pxmsg.i &MSGNUM=7487 &ERRORLEVEL=2}

      end.
   end.

   if bom_desc = "" then do:
      find pt_mstr no-lock where pt_part = bom_parent no-error.
      if available pt_mstr then do:
         bomdesc = pt_desc1.
         ptdesc1 = pt_desc1.
      end.
   end.
   else do:
      bomdesc = bom_desc.
   end.

   display bom_parent

      bomdesc
      bom__chr01 bom__chr02                           /*kevin*/
      bom_batch_um.
   if bom_cmtindx <> 0 then display true @ cmmts.
   else display false @ cmmts.

   if bom_formula then do:
      /* Formula controlled */
      {pxmsg.i &MSGNUM=263 &ERRORLEVEL=3}
      undo, retry.
   end.

   parent = bom_parent.

   /* SET GLOBAL PART VARIABLE */
   global_part = parent.
   batch_size = bom_batch.

   ststatus = stline[2].
   status input ststatus.
   del-yn = no.

   do on error undo, retry:
/*GUI*/ if global-beam-me-up then undo, leave.
/******tfq added begin*************************************/
/*added by kevin, 10/16/2003*/
           /*tfq    set bom__chr01 with frame a.*/
                 
               find si_mstr no-lock where si_site = bom__chr01 no-error.
               if not available si_mstr or (si_db <> global_db) then do:
                   if not available si_mstr then msg-nbr = 708.
                   else msg-nbr = 5421.
                   /*tfq {mfmsg.i msg-nbr 3}*/
                /*tfq*/   {pxmsg.i
               &MSGNUM=msg-nbr
               &ERRORLEVEL=3
                           }
                   undo, retry.
               end.
   
               {gprun.i ""gpsiver.p""
               "(input si_site, input recid(si_mstr), output return_int)"}
/*GUI*/ if global-beam-me-up then undo, leave.

/*J034*/       if return_int = 0 then do:
/*J034*/         /*tfq {mfmsg.i 725 3} */   /* USER DOES NOT HAVE */
/*J034*/       /*tfq*/  {pxmsg.i
               &MSGNUM=725
               &ERRORLEVEL=3
                         }                    /* ACCESS TO THIS SITE*/
/*J034*/          undo,retry.
/*J034*/       end.               
/*end added by kevin, 10/16/2003*/
/************tfq added end********************************/
      set

         bomdesc
         bom_batch_um when (bom_batch = 0 or bom_batch = 1)
         cmmts
         go-on ("F5" "CTRL-D").

      assign
         bom_userid = global_userid
         bom_mod_date = today.
      if bomdesc <> ptdesc1 then bom_desc = bomdesc.

      /* DELETE */
      if lastkey = keycode("F5")
         or lastkey = keycode("CTRL-D")
         /* Delete to be executed if batchdelete is set to "x" */
         or input batchdelete = "x":U
      then do:

         /*PATCH G309 OVERRIDES PATCH F671.  IT WAS DEEMED BETTER TO      */
         /*TOTALLY PROHIBIT THE DELETION OF BOM CODES THAT ARE USED IN    */
         /*STRUCTURES RATHER THAN AUTOMATICALLY DELETE THE STRUCTURE.     */
         /*WHATEVER METHOD IS USED MUST BE THE SAME IN FMMAMT.P AS WELL   */

         if can-find (first ps_mstr where ps_par = bom_parent)

            or (can-find (first ps_mstr where ps_comp = bom_parent)
            and not can-find(pt_mstr where pt_part = bom_parent))
         then do:
            /*Delete not allowed, product structure exists*/
            {pxmsg.i &MSGNUM=226 &ERRORLEVEL=3}
            undo mainloop, retry.
         end.

         del-yn = yes.
         /* PLEASE CONFIRM DELETE */
         {pxmsg.i &MSGNUM=11 &ERRORLEVEL=1 &CONFIRM=del-yn}
         if del-yn = no then undo, retry.

         for each cmt_det exclusive-lock where cmt_indx = bom_cmtindx:
            delete cmt_det.
         end.

         lines = 0.
         for each ps_mstr exclusive-lock where ps_par = bom_parent
            with frame b width 80 no-attr-space down:
            pause 0.
            /* SET EXTERNAL LABELS */
            setFrameLabels(frame b:handle).
            display ps_comp ps_ref ps_qty_per ps_ps_code ps_start ps_end.
            {inmrp.i &part=ps_comp &site=unknown_char}
            delete ps_mstr.
            lines = lines + 1.
         end.
         pause before-hide.
         {inmrp.i &part=bom_parent &site=unknown_char}

         delete bom_mstr.
         del-yn = no.
         if lines > 0 then do:
            /* LINE ITEM RECORD(S) DELETED */
            {pxmsg.i
               &MSGNUM=24
               &ERRORLEVEL=1
               &MSGARG1=lines
            }
         end.
         else do:
            /* RECORD DELETED */
            {pxmsg.i &MSGNUM=22 &ERRORLEVEL=1}
         end.

      end.    /* if lastkey ... */
      else do:

         if cmmts = yes then do:
            global_ref = string(bom_parent).
            cmtindx = bom_cmtindx.
            {gprun.i ""gpcmmt01.p"" "(""bom_mstr"")"}
            bom_cmtindx = cmtindx.
            global_ref = "".
         end.
      end.
   end.   /* do on error undo, retry */

end.    /* mainloop repeat */
status input.
