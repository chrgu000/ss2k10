/* bmmamt.p - use character program to gui for cim_load out of erp            */
/* Copyright 1986-2010 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
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
/* $Revision: 1.8.1.8 $    BY: Anil Sudhakaran       DATE: 11/28/01  ECO: *M1FN*  */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/
/* REVISION: 9.1      LAST MODIFIED: 08/11/00 BY: *N0KK* jyn                  */
/* Revision: 1.8.1.7  BY: Paul Donnelly (SB) DATE: 06/26/03 ECO: *Q00B* */
/* $Revision: 1.8.1.8 $      BY: Priti Jha          DATE: 12/30/10 ECO: *Q4KG* */
/*-Revision end---------------------------------------------------------------*/

/*V8:ConvertMode=Maintenance                                                  */

/* DISPLAY TITLE */
/* {mfdtitle.i "121030.1"} */
{mfdeclre.i}
{gplabel.i &ClearReg = yes}
session:set-wait-stat("").

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE bmmamt_p_1 "Comments"
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

/* Variable added to perform delete during CIM.
 * Record is deleted only when the value of this variable
 * Is set to "X" */
define variable batchdelete as character format "x(1)" no-undo.

/* DISPLAY SELECTION FORM */
form
   bom_parent     colon 27
   bomdesc  colon 27
   bom_batch_um   colon 27
   cmmts          colon 27
with frame a side-labels width 80 attr-space.

/* SET EXTERNAL LABELS */
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
         " bom_mstr.bom_domain = global_domain and bom_fsm_type  = "" "" "
         bom_parent
         "input bom_parent"}

      if recno <> ? then do:

         bomdesc = "".
         if bom_desc = "" then do:
            find pt_mstr no-lock  where pt_mstr.pt_domain = global_domain and
            pt_part = bom_parent no-error.
            if available pt_mstr then bomdesc = pt_desc1.
         end.
         else do:
            bomdesc = bom_desc.
         end.

         display bom_parent

            bomdesc
            bom_batch_um.

         if bom_cmtindx <> 0 then display true @ cmmts.
         else display false @ cmmts.
      end.    /* if recno <> ? */
      hide frame b.
   end.    /* editing on bom_parent */

   hide frame b.

   bomdesc = "".

find bom_mstr exclusive-lock using  bom_parent where bom_mstr.bom_domain =
global_domain  no-error.
   if not available bom_mstr then do:

      if input bom_parent = "" then do:
         /* BLANK NOT ALLOWED */
         {pxmsg.i &MSGNUM=40 &ERRORLEVEL=3}
         undo, retry.
      end.

      find pt_mstr no-lock  where pt_mstr.pt_domain = global_domain and
      pt_part = input bom_parent no-error.
      if available pt_mstr then do:
         ptstatus = pt_status.
         substring(ptstatus,9,1) = "#".
         if can-find(isd_det  where isd_det.isd_domain = global_domain and
         isd_status = ptstatus
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

      /* ADDING NEW RECORD */
      {pxmsg.i &MSGNUM=1 &ERRORLEVEL=1}
      create bom_mstr. bom_mstr.bom_domain = global_domain.
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
      find pt_mstr no-lock  where pt_mstr.pt_domain = global_domain and
      pt_part = bom_parent no-error.
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

         if can-find (first ps_mstr
                       where ps_domain = global_domain
                       and ( ps_par    = bom_parent))

            or (can-find (first ps_mstr
                          where ps_domain = global_domain
                          and ( ps_comp   = bom_parent))
            and not can-find(pt_mstr
                             where pt_domain = global_domain
                             and   pt_part   = bom_parent))

            or (can-find (first ps_mstr
                          where ps_domain  = global_domain
                          and   ps_ps_code = "J"
                          and  (ps_comp    = bom_parent)))
         then do:
            /*Delete not allowed, product structure exists*/
            {pxmsg.i &MSGNUM=226 &ERRORLEVEL=3}
            undo mainloop, retry.
         end.

         del-yn = yes.
         /* PLEASE CONFIRM DELETE */
         {pxmsg.i &MSGNUM=11 &ERRORLEVEL=1 &CONFIRM=del-yn}
         if del-yn = no then undo, retry.

         for each cmt_det exclusive-lock  where cmt_det.cmt_domain =
         global_domain and  cmt_indx = bom_cmtindx:
            delete cmt_det.
         end.

         lines = 0.
         for each ps_mstr exclusive-lock  where ps_mstr.ps_domain =
         global_domain and  ps_par = bom_parent
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
