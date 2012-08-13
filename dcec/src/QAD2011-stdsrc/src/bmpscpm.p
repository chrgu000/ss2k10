/* GUI CONVERTED from bmpscpm.p (converter v1.78) Fri Nov 16 02:34:00 2007 */
/* bmpscpm.p - MANUFACTURING/SERVICE BILL OF MATERIAL COPY SUBPROGRAM         */
/* Copyright 1986-2007 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* REVISION: 8.5         CREATED: 05/07/97      BY: *J1RB* Sue Poland         */
/* REVISION: 8.5         CREATED: 08/07/97      BY: *J1QF* Russ Witt          */
/* REVISION: 8.5      LAST MODIFIED: 01/29/98   BY: *J2CW* Santhosh Nair      */
/* REVISION: 9.0      LAST MODIFIED: 11/20/98   BY: *J352* Sandesh Mahagaokar */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane          */
/* REVISION: 8.6E     LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan         */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan         */
/* REVISION: 9.0      LAST MODIFIED: 03/13/99   BY: *M0BD* Alfred Tan         */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane   */
/* REVISION: 9.1      LAST MODIFIED: 08/11/00   BY: *N0KK* jyn                */
/* Revision: 1.19     BY: Nikita Joshi          DATE: 03/06/02  ECO: *N1BZ*   */
/* Revision: 1.20     BY: Nikita Joshi          DATE: 04/11/02  ECO: *N1GD*   */
/* Revision: 1.22     BY: Paul Donnelly (SB)    DATE: 06/26/03  ECO: *Q00B* */
/* Revision: 1.23     BY: Shivaraman V.         DATE: 09/29/04  ECO: *P2MF* */
/* Revision: 1.24     BY: Mugdha Tambe          DATE: 05/22/05  ECO: *P3M5* */
/* Revision: 1.25     BY: Shivaraman V.         DATE: 11/21/05  ECO: *P48F* */
/* Revision: 1.26     BY: Archana Kirtane       DATE: 07/27/07  ECO: *P630* */
/* $Revision: 1.27 $     BY: Namita Patil          DATE: 11/15/07  ECO: *P66S* */
/*-Revision end---------------------------------------------------------------*/
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/
/*V8:ConvertMode=Maintenance                                                  */
/*!
    This routine is called by BMPSCP.P to copy "normal" BOM structures.  It
    is also called by FSPSCP.P to copy service BOM structures.

    Variations in performance of these two processes should be kept to a
    minimum.  Currently, the main difference may be found in the handling
    of the Destination Description field - as manufacturing BOMs generally
    expect the existence of pt_mstr, and service BOMs never expect pt_mstr,
    default logic for this field varies.

    The input value for bom-type identifies the type of structure being
    copied to.  It will be blank when manufacturing BOMs are being copied,
    and will contain "FSM" when service BOMs are being copied.  In either
    case, the Source BOM used for the copy may be of either type.
*/

{mfdeclre.i}
{gplabel.i} /* EXTERNAL LABEL INCLUDE */

define input parameter bom-type like bom_fsm_type.

define new shared variable comp like ps_comp.
define new shared variable ps_recno as recid.

define variable part1          like ps_par label "Source Structure" no-undo.
define variable part2          like ps_par label "Destination Structure" no-undo.
define variable dest_desc      like pt_desc1
                               label "Destination Description" no-undo.
define variable desc1          like pt_desc1 no-undo.
define variable desc3          like pt_desc1 no-undo.
define variable um1            like pt_um label "UM" no-undo.
define variable um2            like pt_um label "UM" no-undo.
define variable yn             like mfc_logical no-undo.
define variable unknown_char   as character initial ?.
define variable found_any      like mfc_logical.
define variable to_batch_qty   like pt_batch.
define variable from_batch_qty like pt_batch.
define variable to_batch_um    like pt_um.
define variable from_batch_um  like pt_um.
define variable conv           like ps_um_conv.
define variable um             like pt_um.
define variable copy_conv      like um_conv.
define variable formula_yn     like bom_formula.
define variable config_yn      like mfc_logical.
define variable qtyper_b       like ps_qty_per_b.
define variable msgnbr         as   integer    no-undo.
define variable l_ptstatus     like isd_status no-undo.
define variable l_add_comp     like mfc_logical
                               label "Combine Common Components".
{fsconst.i}    /* SSM CONSTANTS */

define buffer ps_from for ps_mstr.
define buffer bommstr for bom_mstr.


/*GUI preprocessor Frame A define */
&SCOPED-DEFINE PP_FRAME_NAME A

FORM /*GUI*/ 
   
 RECT-FRAME       AT ROW 1 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1 COLUMN 3 NO-LABEL VIEW-AS TEXT SIZE-PIXELS 1 BY 1
 SKIP(.1)  /*GUI*/
part1          colon 30
   desc1          no-label at 52
   um1            colon 30
   part2          colon 30
   desc3          no-label at 52
   um2            colon 30
   dest_desc      colon 30
   l_add_comp     colon 30
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

repeat:
/*GUI*/ if global-beam-me-up then undo, leave.


   l_add_comp = yes.

   clear frame a no-pause.
/*GUI*/ RECT-FRAME-LABEL:SCREEN-VALUE in frame a = F-a-title.
   display
      part1
      part2
   with frame a.
   do on error undo, retry with frame a:
/*GUI*/ if global-beam-me-up then undo, leave.


      dest_desc = "".

      set
         part1
         part2
         with frame a
      editing:

         if frame-field = "part1"
         then do:
            /* FIND NEXT/PREVIOUS RECORD - ALL BOM_MSTR'S ARE
            VALID FOR "SOURCE" */
            {mfnp.i bom_mstr part1  " bom_mstr.bom_domain = global_domain and
            bom_parent "  part1
               bom_parent bom_parent}

            if recno <> ?
            then do:

               assign
                  part1 = bom_parent
                  desc1 = bom_desc
                  um1   = bom_batch_um.

               if bom-type <> fsm_c
               then do:
                  find pt_mstr  where pt_mstr.pt_domain = global_domain and
                  pt_part = bom_parent
                  no-lock no-error.

                  if available pt_mstr then
                  do:
                     part1 = pt_part.

                     if bom_desc = ""  then
                        desc1 = pt_desc1.
                  end.
               end.   /* if bom-type <> fsm_c */

               display
                  part1
                  desc1
                  um1
               with frame a.

            end.    /* if recno <> ? */
            recno = ?.

         end.   /* if frame-field = "part1" */

         else if frame-field = "part2"
         then do:

            /* FIND NEXT/PREVIOUS RECORD - BOMS TO DISPLAY DEPEND
               IN THE INPUT BOM-TYPE PARAMETER */
            {mfnp05.i bom_mstr bom_fsm_type " bom_mstr.bom_domain =
            global_domain and bom_fsm_type  = bom-type "
               bom_parent "input part2"}

            if recno <> ?
            then do:

               assign
                  part2 = bom_parent
                  desc3 = bom_desc
                  um2   = bom_batch_um.

               if bom_desc <> "" then
                  dest_desc = bom_desc.
               else
                  dest_desc = "".

               if bom-type <> fsm_c
               then do:
                  find pt_mstr no-lock  where pt_mstr.pt_domain = global_domain
                  and  pt_part = bom_parent
                  no-error.
                  if available pt_mstr
                  then do:
                     part2 = pt_part.
                     if bom_desc = "" then
                        desc3     = pt_desc1.
                     if dest_desc  = "" then
                        dest_desc = pt_desc1.
                  end.    /* if available pt_mstr */
               end.    /* if bom-type <> fsm_c */

               display
                  part2
                  desc3
                  um2
                  dest_desc
               with frame a.

            end.    /* if recno <> ? */

            else
               um2 = um1.

         end.    /* if frame-field = "part2" */
         else do:
            status input.
            readkey.
            apply lastkey.
         end.
      end.  /* editing */

      if part2 = ""
      then do:
         {pxmsg.i &MSGNUM=40 &ERRORLEVEL=3}     /* BLANK NOT ALLOWED */
         next-prompt part2 with frame a.
         undo,retry .
      end.

      if bom-type = fsm_c and
         can-find(pt_mstr  where pt_mstr.pt_domain = global_domain and  pt_part
         = part2)
      then do:
         /* SSM STRUCTURE CODE CANNOT EXIST IN ITEM MASTER */
         {pxmsg.i &MSGNUM=7494 &ERRORLEVEL=3}
         next-prompt part2 with frame a.
         undo, retry.
      end.

      assign
         desc1          = ""
         desc3          = ""
         from_batch_qty = 0
         from_batch_um  = ""
         to_batch_qty   = 0
         to_batch_um    = ""
         config_yn      = no
         formula_yn     = no
         um1            = ""
         um2            = "".

      find bom_mstr no-lock  where bom_mstr.bom_domain = global_domain and
      bom_parent = part1 no-error.
      if available bom_mstr then
      assign
         part1            = bom_parent
         um1              = bom_batch_um
         desc1            = bom_desc
         from_batch_qty   = bom_batch
         from_batch_um    = bom_batch_um
         formula_yn       = bom_formula.

      /* SOURCE AND DESTINATION BOM CODES MAY BE NEITHER
      FORMULA-CONTROLLED NOR JOINT/CO/BY-PRODUCTS. */
      if formula_yn
      then do:
         {pxmsg.i &MSGNUM=263 &ERRORLEVEL=3} /* FORMULA CONTROLLED */
         undo, retry.
      end.
      find first ps_mstr no-lock  where ps_mstr.ps_domain = global_domain and
      ps_par = part1
         and  ps_ps_code = "J" no-error.
      if available ps_mstr
      then do:
         /* JOINT PRODUCT STRUCTURE MAY NOT BE COPIED */
         {pxmsg.i &MSGNUM=6515 &ERRORLEVEL=3}
         undo, retry.
      end.

      if not can-find (first ps_mstr  where ps_mstr.ps_domain = global_domain
      and  ps_par = part1)
      then do:
         /* NO BILL OF MATERIAL EXISTS */
         {pxmsg.i &MSGNUM=100 &ERRORLEVEL=3 &MSGARG1="""("" + part1 + "")"""}
         undo, retry.
      end.

      /* FOR MANUFACTURING BOM'S, DEFAULT THESE VALUES FROM PT_MSTR
      (IF AVAILABLE).  FOR SERVICE BOM'S, USE ONLY BOM_MSTR. */
      if bom-type <> fsm_c
      then do:
         find pt_mstr  where pt_mstr.pt_domain = global_domain and  pt_part =
         part1 no-lock no-error.
         if available pt_mstr
         then do:
            if desc1 = ""
            then
               desc1 = pt_desc1.
            if from_batch_um = ""
            then
               from_batch_um = pt_um.
            if pt_pm_code = "C"
            then
               config_yn = yes.
         end.     /* if available pt_mstr then do */
      end.     /* if bom-type <> fsm_c */
      else
         dest_desc = bom_desc.

      display
         part1
         desc1
         um1
      with frame a.

      find bom_mstr no-lock  where bom_mstr.bom_domain = global_domain and
      bom_parent = part2 no-error.
      if available bom_mstr
      then do:

         /* PREVENT USER FROM COPYING INTO THE WRONG BOM TYPE */
         if bom_fsm_type <> bom-type
         then do:
            if bom_fsm_type = fsm_c then    /* FROM FSPSCP.P */
               msgnbr = 7492. /* CONTROLLED BY SERVICE/SUPPORT MODULE */
            else
               msgnbr = 7493.             /* ELSE, BMPSCP.P */
            /* THIS IS NOT AN SSM PRODUCT STRUCTURE CODE */
            {pxmsg.i &MSGNUM=msgnbr &ERRORLEVEL=3}
            next-prompt part2 with frame a.
            undo, retry .
         end.

         assign
            part2        = bom_parent
            desc3        = bom_desc
            um2          = bom_batch_um
            formula_yn   = bom_formula
            to_batch_qty = bom_batch
            to_batch_um  = bom_batch_um.

         /* FOR SERVICE BOM'S, THERE'S NO REASON TO LEAVE DEST_DESC
         (AND HENCE BOM_DESC FOR THE NEW BOM CODE) BLANK.  FOR
         MANUFACTURING BOM'S, IF BOM_DESC IS BLANK, DEFAULT
         DESCRIPTION IS PULLED FROM THE ASSOCIATED ITEM. */
         if bom_desc <> "" then
            dest_desc = bom_desc.
         else
         if bom-type <> fsm_c then
            dest_desc = "".

      end.    /* if available bom_mstr */

      if formula_yn
      then do:
         {pxmsg.i &MSGNUM=263 &ERRORLEVEL=3} /* FORMULA CONTROLLED */
         next-prompt part2 with frame a.
         undo, retry.
      end.

      if bom-type <> fsm_c
      then do:
         find pt_mstr  where pt_mstr.pt_domain = global_domain and  pt_part =
         part2 no-lock no-error.
         if available pt_mstr then do:

            if desc3 = "" then
               desc3 = pt_desc1.
            if to_batch_um = "" then
               to_batch_um = pt_um.
            if dest_desc  = "" then
               dest_desc = pt_desc1.

            /* ACCESS UM FROM pt_mstr IF bom_mstr IS NOT AVAILABLE */
            if not available bom_mstr
            then
               um2 = pt_um.

         end.     /* if available pt_mstr */
      end.     /* if bom-type <> fsm_c */

      if not available bom_mstr and
         not available pt_mstr
      then
         assign
            to_batch_qty = from_batch_qty
            to_batch_um  = from_batch_um
            um2          = to_batch_um.

      display
         part2
         desc3
         um2
         dest_desc
         l_add_comp
      with frame a.

      hide frame b.

      find first ps_mstr no-lock
          where ps_mstr.ps_domain = global_domain and   ps_par = part2
         and  ps_ps_code = "J" no-error.
      if available ps_mstr
      then do:
         /* JOINT PRODUCT STRUCTURE MAY NOT BE COPIED */
         {pxmsg.i &MSGNUM=6515 &ERRORLEVEL=3}
         next-prompt part2 with frame a.
         undo, retry.
      end.

      copy_conv = 1.
      if from_batch_um <> to_batch_um
      then do:
         {gprun.i ""gpumcnv.p""
            "(to_batch_um, from_batch_um, part1, output copy_conv)"}
/*GUI*/ if global-beam-me-up then undo, leave.

         if copy_conv = ?
         then do:
            /* NO UNIT OF MEASURE CONVERSION EXISTS */
            {pxmsg.i &MSGNUM=33 &ERRORLEVEL=4}
            undo, retry.
         end.
      end.    /* if from_bacth_um <> to_batch_um */

      yn = yes.
      if can-find (first ps_mstr  where ps_mstr.ps_domain = global_domain and
      ps_par = part2)
      then do:
         /* PART NUMBER HAS EXISTING BILL OF MATERIAL */
         {pxmsg.i &MSGNUM=200 &ERRORLEVEL=2 &MSGARG1="""("" + part2 + "")"""}
         input clear.
         yn = no.
      end.

      set
         dest_desc
         l_add_comp
      with frame a.

      /* AS ABOVE, MANUFACTURING AND SERVICE BOMS HAVE DIFFERENT
      HANDLING FOR BOM_DESC */
      if bom-type <> fsm_c
      then do:

         /* IF THE DEST_DESC DEFAULTS TO ITEM DESC, AND THE USER DOES NOT
         MODIFY IT, THEN DEST_DESC SHOULD NOT BE POPULATED    */
         if ((available bom_mstr
            and bom_desc = "")
            or (not available bom_mstr))
            and dest_desc not entered
         then
            desc3 = "".
         else
            desc3 = dest_desc.
      end.     /* if bom-type <> fsm_c */
      else
         desc3 = dest_desc.

   end.
/*GUI*/ if global-beam-me-up then undo, leave.
    /* do on error with frame a */

   /*IS ALL INFORMATION CORRECT */
   {pxmsg.i &MSGNUM=12 &ERRORLEVEL=1 &CONFIRM=yn}
   if yn = no
      then undo, retry.

   found_any = no.

   for each ps_from
      where ps_from.ps_domain =  global_domain
      and  (ps_par            =  part1
         and(ps_from.ps_end   =  ?
            or ps_from.ps_end >= today))
      and ps_from.ps_ps_code  <> 'A'
   no-lock with frame b:
/*GUI*/ if global-beam-me-up then undo, leave.


      if not can-find (bom_mstr  where bom_mstr.bom_domain = global_domain and
      bom_parent = part2
         and bom_fsm_type = bom-type)
      then do:

         create bom_mstr. bom_mstr.bom_domain = global_domain.
         assign
            bom_parent   = part2
            bom_userid   = global_userid
            bom_mod_date = today
            bom_batch    = to_batch_qty
            bom_batch_um = to_batch_um
            bom_desc     = desc3
            bom_fsm_type = bom-type
            bom_formula  = formula_yn.

         if recid(bom_mstr) = -1
         then .
         find bommstr  where bommstr.bom_domain = global_domain and
         bommstr.bom_parent = part1
         no-lock no-error.
         if available bommstr
         then
            assign
               bom_mstr.bom_user1   =  bommstr.bom_user1
               bom_mstr.bom_user2   =  bommstr.bom_user2
               bom_mstr.bom__chr01  =  bommstr.bom__chr01
               bom_mstr.bom__chr02  =  bommstr.bom__chr02
               bom_mstr.bom__chr03  =  bommstr.bom__chr03
               bom_mstr.bom__chr04  =  bommstr.bom__chr04
               bom_mstr.bom__chr05  =  bommstr.bom__chr05
               bom_mstr.bom__dec01  =  bommstr.bom__dec01
               bom_mstr.bom__dec02  =  bommstr.bom__dec02
               bom_mstr.bom__dte01  =  bommstr.bom__dte01
               bom_mstr.bom__dte02  =  bommstr.bom__dte02
               bom_mstr.bom__log01  =  bommstr.bom__log01.

      end.

      else do:
         find bom_mstr exclusive-lock
             where bom_mstr.bom_domain = global_domain and  bom_mstr.bom_parent
             = part2.
         bom_mstr.bom_desc = desc3.
      end.

      pause 0 no-message.
      find ps_mstr  where ps_mstr.ps_domain = global_domain and  ps_mstr.ps_par
      = part2
         and ps_mstr.ps_comp = ps_from.ps_comp
         and ps_mstr.ps_ref = ps_from.ps_ref
         and ps_mstr.ps_start = ps_from.ps_start
         and ps_mstr.ps_end = ps_from.ps_end
         no-error.

      if not available ps_mstr
      then do:
         overlap-check:
         do:
            check1:
            do:
               for each ps_mstr no-lock  where ps_mstr.ps_domain =
               global_domain and (  ps_mstr.ps_par = part2
                  and ps_mstr.ps_comp = ps_from.ps_comp
                  and ps_mstr.ps_ref = ps_from.ps_ref
                  and (  (ps_mstr.ps_end   = ? and ps_from.ps_end   = ?)
                   or (ps_mstr.ps_start = ? and ps_from.ps_start = ?)
                   or (ps_mstr.ps_start = ? and ps_mstr.ps_end   = ?)
                   or (ps_from.ps_start = ? and ps_from.ps_end   = ?)
                   or ((ps_from.ps_start >= ps_mstr.ps_start
                   or ps_mstr.ps_start = ?)
                  and ps_from.ps_start <= ps_mstr.ps_end)
                   or (ps_from.ps_start <= ps_mstr.ps_end
                   and ps_from.ps_end >= ps_mstr.ps_start)
                     ) ) :
                  leave check1.
               end.    /* for each ps_mstr */
               leave overlap-check.
            end.  /* check1 do */
            /* DATE RANGES MAY NOT OVERLAP */
            {pxmsg.i &MSGNUM=122 &ERRORLEVEL=4}
            /* COMPONENT # NOT COPIED */
            {pxmsg.i &MSGNUM=1774 &ERRORLEVEL=1 &MSGARG1=ps_mstr.ps_comp}
            undo, next.
         end.    /* overlap-check */

         do:
            find first pt_mstr
                 where pt_mstr.pt_domain = global_domain and  pt_part = part2
            no-lock no-error.
            if available pt_mstr
            then do:
               assign
                  l_ptstatus                = pt_status
                  substring(l_ptstatus,9,1) = "#".
               for first isd_det
                  fields( isd_domain isd_status isd_tr_type)
                   where isd_det.isd_domain = global_domain and    isd_status
                   = l_ptstatus
                    and   isd_tr_type = "ADD-PS"
               no-lock:
               end. /* FOR FIRST isd_det */
               if available isd_det
               then do:
                  /* RESTRICTED PROCEDURE FOR ITEM STATUS CODE */
                       
                  {pxmsg.i &MSGNUM=358 &ERRORLEVEL=4}   
                  /*V8+*/
                  undo, next.
               end. /* IF AVAILABLE isd_det */
            end. /* IF AVAILABLE pt_mstr */
         end. /* DO */

         create ps_mstr. ps_mstr.ps_domain = global_domain.
         assign
            ps_mstr.ps_par       = part2
            ps_mstr.ps_comp      = ps_from.ps_comp
            ps_mstr.ps_ref       = ps_from.ps_ref
            ps_mstr.ps_scrp_pct  = ps_from.ps_scrp_pct
            ps_mstr.ps_ps_code   = ps_from.ps_ps_code
            ps_mstr.ps_lt_off    = ps_from.ps_lt_off
            ps_mstr.ps_start     = ps_from.ps_start
            ps_mstr.ps_end       = ps_from.ps_end
            ps_mstr.ps_rmks      = ps_from.ps_rmks
            ps_mstr.ps_op        = ps_from.ps_op
            ps_mstr.ps_item_no   = ps_from.ps_item_no
            ps_mstr.ps_mandatory = ps_from.ps_mandatory
            ps_mstr.ps_exclusive = ps_from.ps_exclusive
            ps_mstr.ps_process   = ps_from.ps_process
            ps_mstr.ps_qty_type  = ps_from.ps_qty_type
            ps_mstr.ps_fcst_pct  = ps_from.ps_fcst_pct
            ps_mstr.ps_default   = ps_from.ps_default
            ps_mstr.ps_group     = ps_from.ps_group
            ps_mstr.ps_critical  = ps_from.ps_critical
            ps_mstr.ps_user1     = ps_from.ps_user1
            ps_mstr.ps_user2     = ps_from.ps_user2.

         ps_recno = recid(ps_mstr).

         /* CYCLIC PRODUCT STRUCTURE CHECK */
         {gprun.i ""bmpsmta.p""}
/*GUI*/ if global-beam-me-up then undo, leave.

         if ps_recno = 0
         then do:
            /* "CYCLIC PRODUCT STRUCTURE - "
               + part2 + " - " + ps_mstr.ps_comp + " NOT ADDED */
            {pxmsg.i &MSGNUM=206 &ERRORLEVEL=2 &MSGARG1=ps_mstr.ps_comp}
            pause 5.
            undo, next.
         end.

         for each in_mstr exclusive-lock  where in_mstr.in_domain =
         global_domain and
            in_part = ps_mstr.ps_comp:
            if available in_mstr
            then
               assign
                  in_level = 99999
                  in_mrp   = true.
         end.

      end.
/*GUI*/ if global-beam-me-up then undo, leave.
   /* if not available ps_mstr */

      find pt_mstr
          where pt_mstr.pt_domain = global_domain and  pt_part =
          ps_mstr.ps_comp no-lock no-error.
      find bommstr no-lock
          where bommstr.bom_domain = global_domain and  bommstr.bom_parent =
          ps_mstr.ps_comp no-error.

      if available pt_mstr then
         um = pt_um.
      else
      if available bommstr then
         um = bommstr.bom_batch_um.

      conv = 1.
      if um <> to_batch_um
         and ps_mstr.ps_qty_type = "P"
      then do:
         {gprun.i ""gpumcnv.p""
            "(um, to_batch_um, ps_mstr.ps_comp, output conv)"}
/*GUI*/ if global-beam-me-up then undo, leave.

         if conv = ?
         then do:
            /* COMPONENT UM IS DIFFERENT THAN PARENT UM */
            {pxmsg.i &MSGNUM=4600 &ERRORLEVEL=4
                     &MSGARG1="""("" + ps_mstr.ps_comp + "")"""}
            {pxmsg.i &MSGNUM=33 &ERRORLEVEL=4}  /* NO UOM CONVERSION EXISTS */
            pause 5.
            undo, next.
         end.
      end.    /* if um <> to_batch_um and... */

      if config_yn
         and ps_from.ps_qty_per_b = 0
         and ps_from.ps_qty_type = ""
      then
         qtyper_b = ps_from.ps_qty_per.
      else
         qtyper_b = ps_from.ps_qty_per_b.

      if l_add_comp
      then do:
      assign
         ps_mstr.ps_qty_per_b = ps_mstr.ps_qty_per_b
                                + ((qtyper_b * copy_conv
                                    * if ps_mstr.ps_qty_type = ""
                                      then
                                         1
                                      else
                                         to_batch_qty)
                                    / if ps_from.ps_qty_type = ""
                                      then
                                         1
                                      else
                                         from_batch_qty)

         ps_mstr.ps_qty_per   = ps_mstr.ps_qty_per
                                +  ps_from.ps_qty_per.
      end. /* IF l_add_comp */
      else do:
      assign
         ps_mstr.ps_qty_per_b = ((qtyper_b * copy_conv
                                  * if ps_mstr.ps_qty_type = ""
                                    then
                                       1
                                    else
                                       to_batch_qty)
                                  / if ps_from.ps_qty_type = ""
                                    then
                                       1
                                    else
                                       from_batch_qty)
         ps_mstr.ps_qty_per   = ps_from.ps_qty_per.
      end. /* ELSE DO */

      if ps_mstr.ps_qty_type = "P" then
         ps_mstr.ps_batch_pct = (ps_mstr.ps_qty_per_b * conv)
                              / (.01 * to_batch_qty).

      /* SET EXTERNAL LABELS */
      setFrameLabels(frame b:handle).
      display
         ps_mstr.ps_comp
         ps_mstr.ps_ref
         ps_mstr.ps_qty_per
         ps_mstr.ps_ps_code
         ps_mstr.ps_start
         ps_mstr.ps_end
      with frame b width 80 no-attr-space.

      found_any = yes.

      /* STORE MODIFY DATE AND USERID */
      assign
         ps_mstr.ps_mod_date = today
         ps_mstr.ps_userid   = global_userid.

   end.
/*GUI*/ if global-beam-me-up then undo, leave.
     /* for each ps_mstr */

   {pxmsg.i &MSGNUM=7 &ERRORLEVEL=1}

   if found_any
   then do:
      {inmrp.i &part=part2 &site=unknown_char}
   end.

end.   /* repeat */
