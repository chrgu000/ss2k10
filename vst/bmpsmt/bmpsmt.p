/* bmpsmt.p - Product Structure Maintenance                                   */
/* Copyright 1986-2001 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.8.1.8.2.1 $                                                       */
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
/* Revision: 1.2        BY: Evan Bishop      DATE: 06/01/00     ECO: *N0B9*  */
/* Revision: 1.8.1.7    BY: Paul Donnelly    DATE: 07/20/00     ECO: *N0DP*  */
/* Revision: 1.8.1.8    BY: Mark Christian   DATE: 05/05/01     ECO: *N0YF*  */
/* $Revision: 1.8.1.8.2.1 $  BY: Anil Sudhakaran  DATE: 10/09/01   ECO: *M1F3*  */
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

/* REVISION: ADM1      LAST MODIFIED: 04/07/03  BY: *Derek Chu (ADM)       */
/*                     - allow user to input comments                      */
/* REVISION: ADM1a     LAST MODIFIED: 11/12/03  BY: *Derek Chu (ADM)       */
/*                     - DO NOT allow user to modify BOM with status = AC  */
/* REVISION: ADM1b     LAST MODIFIED: 05/21/04  BY: *Derek Chu (ADM)       */
/*                     - control QUOT part# by quot user list              */

/* DISPLAY TITLE */
/*ADM1 {mfdtitle.i "b+ "} */
{mfdtitle.i "b+d1b"}

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

define variable overlap-error as integer initial 3 no-undo.
define variable overlap-warning as integer initial 2 no-undo.

define buffer ps_mstr1               for ps_mstr.

/* Variable added to perform delete during CIM.
 * Record is deleted only when the value of this variable
 * Is set to "X" */
define variable batchdelete as character format "x(1)" no-undo.

/*ADM1*/
define new shared variable cmtindx     like cmt_indx.
define variable comments   like mfc_logical
                           label "Comments" initial no no-undo.
/*ADM1*/
/*ADM1b   define variable compmsg as character format "x(30)" no-undo. **/
/*ADM1a*/ define variable needtochkps as logical .
/*ADM1a*/ define variable env_chkps as char .

/*ADM1b*/ {quotuser.i}

needtochkps = No.
assign env_chkps = os-getenv("CHKPS").
if env_chkps = ? or env_chkps = "Yes" then
   needtochkps = Yes.

/* Display selection form */
form
   ps_par   colon 25
   bomdesc  colon 25
with frame a side-labels width 80 attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

form
   ps_comp        colon 25
   des            no-labels at 47
   rev            colon 25
   des2           no-labels at 47
   ps_ref         colon 25
   ps_start       colon 25
   ps_end         colon 59
   skip(1)
   ps_qty_per     format "->>>,>>>,>>9.9<<<<<<<<" colon 25
   um             no-labels
   ps_scrp_pct    colon 59 format ">9.99%"
   ps_lt_off      colon 59
   ps_op          colon 59
   ps_item_no     colon 59
   ps_ps_code     colon 25
   ps_fcst_pct    colon 59
   psstart        colon 25
   ps_group       colon 59
   psend          colon 25
   ps_process     colon 59
   ps_rmks        colon 25
/*ADM1*/ comments colon 65
with frame b side-labels width 80 attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame b:handle).

/* Display */
view frame a.
view frame b.

bom_recno = ?.

mainloop:
repeat with frame a:

   /* Initialize delete flag before each display of frame */
   batchdelete = "".

   clear frame b no-pause.

   prompt-for ps_par with no-validate
   editing:

      if frame-field = "ps_par"
      then do:
         /* Find next/previous record*/

         recno = bom_recno.

         for first bom_mstr
            fields (bom_batch bom_batch_um bom_desc bom_formula
                    bom_fsm_type bom_mod_date bom_parent bom_userid)
            where recid(bom_mstr) = recno no-lock:
         end. /* for first bom_mstr */

         /* Next/prev thru 'non-service' boms */
         {mfnp05.i bom_mstr bom_fsm_type "bom_fsm_type = """""
            bom_parent "input ps_par"}

         if recno <> ?
         then do:
            bom_recno = recno.
            if bom_desc = ""
            then do:
               for first pt_mstr
                  fields (pt_desc1 pt_desc2 pt_formula
                          pt_joint_type pt_part pt_rev pt_status pt_um)
                  no-lock where pt_part = bom_parent:
               end. /* for first pt_mstr */

               if available pt_mstr then bomdesc = pt_desc1.
            end. /* if bom_desc = "" then do: */
            else do:
               bomdesc = bom_desc.
            end. /* else do: */

            display
               bom_parent @ ps_par
               bomdesc.
         end. /* if recno <> ? then do: */
         else bom_recno = ?.
      end. /* if field-frame = "ps_par" */
      else do:
         readkey.
         apply lastkey.
      end. /* else do: */
   end. /* prompt-for */

   for first pt_mstr
      fields (pt_desc1 pt_desc2 pt_formula pt_joint_type
              pt_part pt_rev pt_status pt_um)
      no-lock where pt_part = input ps_par:
   end. /* for first pt_mstr */

/* ADM1a check for pt_status  */
if needtochkps = Yes then do:
   if available pt_mstr and pt_status = "AC" then do:
      if global_user_lang = "tw" then
         compmsg ="狀態是 Active (AC),不能修改.".
      else
         compmsg ="DO NOT Allow change BOM with status is Active (AC).".
     {mfmsg03.i 2685 1 compmsg """" """"}
     undo, retry.
   end.
end.
/* ADM1a End check for pt_status */
/**ADM1b*/ 
          if isquotuser then do:
	     if available pt_mstr and substr(pt_part,1,4) <> "QUOT" then do:
               if global_user_lang = "tw" then
		  compmsg ="您只可處理 QUOT 的物料.".
	       else
	          compmsg ="You only allow to process QUOT Part#".
	       {mfmsg03.i 2685 1 compmsg """" """"}
	       undo,retry.
	     end.
	  end.
          else do: 
	    if available pt_mstr and substr(pt_part,1,4) = "QUOT" then do:
               if global_user_lang = "tw" then
		  compmsg ="只有 QUOT USER 可處理 QUOT 的物料.".
	       else
	          compmsg ="Only QUOT USER allow to process QUOT Part#".
	       {mfmsg03.i 2685 1 compmsg """" """"}
	       undo,retry.
	    end.
          end.
/**ADM1b*/

   for first bom_mstr
      fields (bom_batch bom_batch_um bom_desc bom_formula
              bom_fsm_type bom_mod_date bom_parent bom_userid)
      no-lock where bom_parent = input ps_par:
   end. /* for first bom_mstr */


   /* Validate that the Parent Id is valid */
   {pxrun.i &PROC = 'validateParentId' &PROGRAM = 'bmpsxr.p'
           &PARAM = "(INPUT input ps_par)"
      &CATCHERROR = true
   }

   {pxrun.i &PROC = 'validateBomExists' &PROGRAM = 'bmpscxr.p'
           &PARAM = "(INPUT  input ps_par)"
      &CATCHERROR = true
   }

   if available bom_mstr then do:

      {pxrun.i &PROC = 'validateBlankBomFsmType' &PROGRAM = 'bmpsxr.p'
              &PARAM = "(INPUT bom_fsm_type)"
         &CATCHERROR = true
      }

   end.

   if not available bom_mstr then
   do transaction:

      {pxrun.i &PROC = 'processCreate' &PROGRAM = 'bmpsxr.p'
              &PARAM = "(INPUT  input ps_par, buffer bom_mstr)"
         &CATCHERROR = true
      }

      /* 1 - Adding new record */
      {pxmsg.i
         &MSGNUM=1
         &ERRORLEVEL={&INFORMATION-RESULT}
      }

   end. /* transaction */
   bom_recno = recid(bom_mstr).

   if bom_desc = ""
      and available pt_mstr then
      bomdesc = pt_desc1.
   else
      bomdesc = bom_desc.

   display
      bom_parent @ ps_par
      bomdesc.


   if bom_formula
   then do:
      /* Formula controlled */
      {pxmsg.i &MSGNUM = 263 &ERRORLEVEL = {&APP-ERROR-RESULT} }
      undo, retry.
   end. /* if bom_formula then do: */

   assign
      parent      = bom_parent
      /* Set global part variable */
      global_part = parent
      batch_size  = bom_batch.

   if batch_size = 0 then batch_size = 1.

   b-loop:
   repeat with frame b:

      /* Initialize delete flag before each display of frame */
      batchdelete = "".

      prompt-for
         ps_comp
         ps_ref
         ps_start
         /* Prompt for the delete variable in the key frame at the
          * End of the key field/s only when batchrun is set to yes */
         batchdelete no-label when (batchrun)
         editing:

         if frame-field = "ps_comp"
         then do:
            /* Find next/previous record */
            {mfnp01.i ps_mstr ps_comp ps_comp parent ps_par ps_parcomp}

            if recno <> ?
            then do:
               assign
                  um   = ""
                  des  = ""
                  des2 = "".

               for first pt_mstr
                  fields (pt_desc1 pt_desc2 pt_formula pt_joint_type
                          pt_part pt_rev pt_status pt_um)
                  where pt_part = ps_comp no-lock:
               end. /* for first pt_mstr */

               for first bom_mstr
                  fields (bom_batch bom_batch_um bom_desc bom_formula
                           bom_fsm_type bom_mod_date bom_parent bom_userid)
                  no-lock where bom_parent = ps_comp:
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
/*ADM1*/
               comments = no.
               if available ps_mstr then 
	          if ps_cmtindx <> 0 then comments = yes.
/*ADM1*/

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
/*ADM1*/          (if ps_cmtindx <> 0 then yes else no) @ comments
                  ps_item_no
                  ps_group
                  ps_process.
            end. /* recno <> ? */
         end. /* frame-field = "ps_comp" */
         else do:
            readkey.
            apply lastkey.
         end. /* else do: */
      end. /* prompt-for */

      if input ps_comp = input ps_par
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
      end. /* if input ps_comp = input ps_par then do: */

      assign
         um   = ""
         des  = ""
         des2 = ""
         rev  = "".

      for first pt_mstr
         fields (pt_desc1 pt_desc2 pt_formula pt_joint_type
                 pt_part pt_rev pt_status pt_um)
         where pt_part = input ps_comp no-lock:
      end. /* for first pt_mstr */

      for first bom_mstr
         fields (bom_batch bom_batch_um bom_desc bom_formula
                 bom_fsm_type bom_mod_date bom_parent bom_userid)
         no-lock where bom_parent = input ps_comp:
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
                 &PARAM = "(INPUT input ps_comp)"
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



      find first ps_mstr exclusive-lock
         using ps_par and ps_comp and ps_ref and ps_start no-error.

      if not available ps_mstr
      then do:


         {pxrun.i &PROC = 'processCreate' &PROGRAM = 'bmpscxr.p'
                 &PARAM = "(INPUT  input ps_par,
                            INPUT  input ps_comp,
                            INPUT  input ps_ref,
                            INPUT  input ps_start,
                            INPUT  '',
                            buffer ps_mstr)"
            &CATCHERROR = true
         }

         /* 1 - ADDING NEW RECORD */
         {pxmsg.i &MSGNUM = 1 &ERRORLEVEL = {&INFORMATION-RESULT} }


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

/*ADM1*/
               comments = no.
               if available ps_mstr then 
	          if ps_cmtindx <> 0 then comments = yes.
/*ADM1*/
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
/*ADM1*/          (if ps_cmtindx <> 0 then yes else no) @ comments
         ps_start
         ps_end
         ps_start @ psstart
         ps_end   @ psend
         ps_item_no
         ps_group
         ps_process.

      if not batchrun
      then do:

         {pxrun.i &PROC = 'validateEffectiveDates' &PROGRAM = 'bmpscxr.p'
                 &PARAM = "(buffer ps_mstr, input overlap-warning)"
            &CATCHERROR = true
            &NOAPPERROR = true
         }

      end.  /* If not batchrun...   */

      ststatus = stline[2].
      status input ststatus.

      assign
         del-yn  = no
         psstart = ps_start
         psend   = ps_end.

      c-block:
      do on error undo, retry:

         set
            ps_qty_per
            ps_ps_code
            psstart
            psend
            ps_rmks
            ps_scrp_pct
            ps_lt_off
            ps_op
            ps_item_no
            ps_fcst_pct
            ps_group
            ps_process
/*ADM1*/    comments
            go-on ("F5" "CTRL-D").

         assign
            comp   = ps_comp
            parent = ps_par.


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
/*ADM1* delete cmt_det where delete bom record*/
        if ps_mstr.ps_cmtindx > 0 then do:
           for each cmt_det exclusive-lock where cmt_indx = ps_mstr.ps_cmtindx:
               delete cmt_det.
           end.
	end.
/*ADM1* delete cmt_det where delete bom record*/
            {pxrun.i &PROC = 'processDelete' &PROGRAM = 'bmpscxr.p'
                    &PARAM = "(buffer ps_mstr)"
               &CATCHERROR = true
            }

            del-yn = no.

            /* 22 - Record deleted */
            {pxmsg.i &MSGNUM = 22 &ERRORLEVEL = {&INFORMATION-RESULT} }

         end. /* then do: */
         else do: /* Modify */
/*ADM1*/
         if comments = yes then do:
	    cmtindx = ps_mstr.ps_cmtindx.
	    global_ref = ps_mstr.ps_par + " / " + ps_mstr.ps_comp.
	    {gprun.i ""gpcmmt01.p"" "(input ""ps_mstr"")"}
	     ps_mstr.ps_cmtindx = cmtindx.
	    view frame a.
	 end.
/*ADM1*/
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
                  next-prompt psstart.
                  undo c-block, retry.
               end.
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

            display
               ps_start
               ps_end.

         end. /* Modify */

      end. /* do on error */
   end. /* b-loop: repeat with frame b: */
end. /* mainloop: repeat with frame a: */

status input.
