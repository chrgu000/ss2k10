/* xxpppcmt.p - PRICE LIST MAINTENANCE Added Normal or Trial price list            */
/* GUI CONVERTED from pppcmt.p (converter v1.76) Wed May 22 11:22:15 2002 */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.19 $                                                          */
/*V8:ConvertMode=Maintenance                                                  */
/* REVISION: 6.0      LAST MODIFIED: 02/20/91   BY: afs *D355**/
/* REVISION: 6.0      LAST MODIFIED: 11/06/91   BY: WUG *D916**/
/* REVISION: 7.0      LAST MODIFIED: 11/16/91   BY: pml *F048**/
/* REVISION: 7.0      LAST MODIFIED: 04/24/92   BY: tjs *F425**/
/* REVISION: 7.0      LAST MODIFIED: 08/18/92   BY: tjs *F835**/
/* REVISION: 7.3      LAST MODIFIED: 10/01/92   BY: tjs *G035**/
/* REVISION: 7.3      LAST MODIFIED: 04/12/93   BY: pma *G940**/
/* REVISION: 7.4      LAST MODIFIED: 09/09/93   BY: cdt *H086**/
/* REVISION: 7.4      LAST MODIFIED: 03/02/94   BY: cdt *H287**/
/* REVISION: 7.4      LAST MODIFIED: 05/19/94   BY: afs *FO24**/
/* REVISION: 7.4      LAST MODIFIED: 09/01/94   BY: afs *H502**/
/* REVISION: 7.4      LAST MODIFIED: 10/06/94   BY: afs *H554**/
/* REVISION: 7.4      LAST MODIFIED: 11/06/94   BY: ljm *GO15**/
/* REVISION: 7.4      LAST MODIFIED: 02/10/95   BY: cpp *F0HN**/
/* REVISION: 7.4      LAST MODIFIED: 02/10/95   BY: cpp *F0HP**/
/* REVISION: 7.4      LAST MODIFIED: 03/22/95   BY: rxm *H0C6**/
/* REVISION: 7.4      LAST MODIFIED: 10/17/95   BY: ais *H0GH**/
/* REVISION: 7.4      LAST MODIFIED: 12/07/95   BY: rxm *H0FS**/
/* REVISION: 7.4      LAST MODIFIED: 02/06/96   BY: rxm *G1MD**/
/* REVISION: 7.4      LAST MODIFIED: 03/11/96   BY: rxm *G1MF**/
/* REVISION: 7.4      LAST MODIFIED: 09/10/96   BY: *H0MN* Suresh Nayak       */
/* REVISION: 7.4      LAST MODIFIED: 09/12/96   BY: *H0MT* Suresh Nayak       */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane          */
/* REVISION: 8.6E     LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan         */
/* REVISION: 8.6E     LAST MODIFIED: 06/22/98   BY: *L020* Charles Yen        */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane   */
/* REVISION: 9.1      LAST MODIFIED: 07/29/00   BY: *N0GV* Mudit Mehta        */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* Old ECO marker removed, but no ECO header exists *M0P3*                    */
/* Revision: 1.15       BY: Anil Sudhakaran      DATE: 04/09/01  ECO: *M0P3*  */
/* Revision: 1.17       BY: Anil Sudhakaran      DATE: 05/24/01  ECO: *N0YW*  */
/* Revision: 1.18       BY: Ashutosh Pitre       DATE: 11/27/01  ECO: *M1QZ*  */
/* $Revision: 1.19 $    BY: Jean Miller          DATE: 05/17/02  ECO: *P05V*  */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/* DISPLAY TITLE */
{mfdtitle.i "2+ "}

define variable mc-error-number like msg_nbr no-undo.

define variable del-yn        like mfc_logical initial no.
define variable i             as integer.
define variable qty_label     as character format "x(7)" extent 3.
define variable amt_label     as character format "x(14)" extent 3.
define variable list_label    as character format "x(24)"
   .
define variable price         as character.
define variable discount      as character.
define variable markup        as character.
define variable ptable_label  as character format "x(23)".
define variable min_label     as character format "x(14)".
define variable max_label     as character format "x(14)".
define variable pcamttype     like pc_amt_type.
define variable old_db        like si_db.
define variable err_flag      as integer.
define variable base_curr1    like base_curr.
define variable base_curr2    like base_curr.
define variable glxcst_tl     like sct_cst_tot.
/*xx*/  define variable pctype like pc_user1 .

define variable temp_max_price like pc_max_price extent 0 decimals 10
   no-undo.
define variable disp-price-discount-markup as character no-undo format "x(44)".
define variable disp-stock-um as character no-undo format "x(12)".
define variable disp-total-this-level-gl as character no-undo format "x(29)".
define variable disp-site-col as character no-undo format "x(10)".
define variable disp-total-gl-cost as character no-undo format "x(28)".
define variable msg-arg1 as character format "x(16)" no-undo.
define variable msg-arg2 as character format "x(16)" no-undo.
/**xx**/  DEFINE VARIABLE xxid AS INTEGER .

/* Variable added to perform delete during CIM. Record is deleted
 * Only when the value of this variable is set to "X" */
define variable batchdelete as character format "x(1)" no-undo.

/*VARIABLE DEFINITIONS FOR GPFIELD.I*/
{gpfieldv.i}

/* DISPLAY SELECTION FORM */

/*GUI preprocessor Frame A define */
&SCOPED-DEFINE PP_FRAME_NAME A

FORM /*GUI*/ 
   
 RECT-FRAME       AT ROW 1 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1 COLUMN 3 NO-LABEL VIEW-AS TEXT SIZE-PIXELS 1 BY 1
 SKIP(.1)  /*GUI*/
    pc_list        colon 29
   pc_curr        colon 60
   pc_prod_line   colon 29
   pc_part        colon 29   pt_desc1 at 52 no-label
   pc_um          colon 29
    pc_start       colon 29   batchdelete at 52 no-label
/*xx*/   pc_expire      colon 29  pc_user1 colon 60 label "Type(Normal/Trial)" format "X(1)"
   pc_amt_type    colon 29
   disp-price-discount-markup no-label
     /**xx**/   pc_user2 COLON 29 LABEL "Price List ID"   
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

FORM /*GUI*/ 
   
 RECT-FRAME       AT ROW 1 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1 COLUMN 3 NO-LABEL VIEW-AS TEXT SIZE-PIXELS 1 BY 1
 SKIP(.1)  /*GUI*/
list_label     to 29 pt_price base_curr
   disp-stock-um  to 65 pt_um  at 68
   /*V8+*/
        
   disp-total-this-level-gl    at 7
   glxcst_tl                   at 31
   base_curr1 disp-site-col    at 57 pt_site at 68
   disp-total-gl-cost          at 9
   glxcst                      at 31 base_curr2   
   /*V8+*/
        
   qty_label[1]   at  2 amt_label[1] at 11
   qty_label[2]   at 27 amt_label[2] at 36
   qty_label[3]   at 52 amt_label[3] at 61   
   skip
   /*V8+*/
        
   pc_min_qty[1]  at 2  pc_amt[1]  at 10 format "->>>,>>>,>>9.9<<<<"
   pc_min_qty[6]  at 27 pc_amt[6]  at 35 format "->>>,>>>,>>9.9<<<<"
   pc_min_qty[11] at 52 pc_amt[11] at 60 format "->>>,>>>,>>9.9<<<<"
   skip
   pc_min_qty[2]  at 2  pc_amt[2]  at 10 format "->>>,>>>,>>9.9<<<<"
   pc_min_qty[7]  at 27 pc_amt[7]  at 35 format "->>>,>>>,>>9.9<<<<"
   pc_min_qty[12] at 52 pc_amt[12] at 60 format "->>>,>>>,>>9.9<<<<"
   skip
   pc_min_qty[3]  at 2  pc_amt[3]  at 10 format "->>>,>>>,>>9.9<<<<"
   pc_min_qty[8]  at 27 pc_amt[8]  at 35 format "->>>,>>>,>>9.9<<<<"
   pc_min_qty[13] at 52 pc_amt[13] at 60 format "->>>,>>>,>>9.9<<<<"
   skip
   pc_min_qty[4]  at 2  pc_amt[4]  at 10 format "->>>,>>>,>>9.9<<<<"
   pc_min_qty[9]  at 27 pc_amt[9]  at 35 format "->>>,>>>,>>9.9<<<<"
   pc_min_qty[14] at 52 pc_amt[14] at 60 format "->>>,>>>,>>9.9<<<<"
   skip
   pc_min_qty[5]  at 2  pc_amt[5]  at 10 format "->>>,>>>,>>9.9<<<<"
   pc_min_qty[10] at 27 pc_amt[10] at 35 format "->>>,>>>,>>9.9<<<<"
   pc_min_qty[15] at 52 pc_amt[15] at 60 format "->>>,>>>,>>9.9<<<<"            
   skip
 SKIP(.4)  /*GUI*/
with frame b no-labels width 80 attr-space NO-BOX THREE-D /*GUI*/.

 DEFINE VARIABLE F-b-title AS CHARACTER INITIAL "".
 RECT-FRAME-LABEL:SCREEN-VALUE in frame b = F-b-title.
 RECT-FRAME-LABEL:HIDDEN in frame b = yes.
 RECT-FRAME:HEIGHT-PIXELS in frame b =
  FRAME b:HEIGHT-PIXELS - RECT-FRAME:Y in frame b - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME b = FRAME b:WIDTH-CHARS - .5.  /*GUI*/


FORM /*GUI*/ 
   
 RECT-FRAME       AT ROW 1 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1 COLUMN 3 NO-LABEL VIEW-AS TEXT SIZE-PIXELS 1 BY 1
 SKIP(.1)  /*GUI*/
list_label     to 29 pt_price base_curr
   disp-stock-um  to 65 pt_um at 68
   /*V8+*/
        
   disp-total-this-level-gl    at 7
   glxcst_tl                   at 31
   base_curr1 disp-site-col    at 57 pt_site at 68
   disp-total-gl-cost          at 9
   glxcst                      at 31 base_curr2
   skip(1)
   ptable_label at 12 pc_amt[1]      at 31
   min_label    at 17 pc_min_price   at 31
   max_label    at 17 temp_max_price at 31   
   skip(2)
 SKIP(.4)  /*GUI*/
with frame c overlay no-labels row 11 width 80 attr-space NO-BOX THREE-D /*GUI*/.

 DEFINE VARIABLE F-c-title AS CHARACTER INITIAL "".
 RECT-FRAME-LABEL:SCREEN-VALUE in frame c = F-c-title.
 RECT-FRAME-LABEL:HIDDEN in frame c = yes.
 RECT-FRAME:HEIGHT-PIXELS in frame c =
  FRAME c:HEIGHT-PIXELS - RECT-FRAME:Y in frame c - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME c = FRAME c:WIDTH-CHARS - .5.  /*GUI*/


assign
   list_label = " " + getTermLabel("ITEM_MASTER_LIST_PRICE",23) + ":"
   disp-price-discount-markup =
           "P-" + getTermLabel("PRICE",7) + " " +
           "D-" + getTermLabel("DISCOUNT",10) + " " +
           "M-" + getTermLabel("MARKUP_PERCENT",10) + " " +
           "L-" + getTermLabel("LIST",6)
   disp-stock-um = getTermLabelRtColon("STOCK_UM",12)
   disp-total-this-level-gl = getTermLabelRtColon("TOTAL_THIS_LEVEL_GL_COST",29)
   disp-site-col = getTermLabelRtColon("SITE",10)
   disp-total-gl-cost = getTermLabelRtColon("TOTAL_GL_COST",28).

assign
   qty_label = getTermLabel("MINIMUM_QUANTITY",7)
   price     = getTermLabelRt("PRICE",14)
   markup    = getTermLabelRt("MARKUP",13) + "%"
   discount  = getTermLabelRt("DISCOUNT_PERCENT",14)
   amt_label = discount
   ptable_label = getTermLabel("PRICE_TABLE_LIST_PRICE",22) + ":"
   min_label    = getTermLabelRtColon("MINIMUM_PRICE",14)
   max_label    = getTermLabelRtColon("MAXIMUM_PRICE",14).

/* DISPLAY */
view frame a.

display
   disp-price-discount-markup
   base_curr @ pc_curr
with frame a.

/**********
/***xx***/  
FIND FIRST pc_mstr WHERE pc_user2 = "" NO-LOCK NO-ERROR.
IF AVAILABLE pc_mstr THEN DO:
    xxid = 0 .
    FOR LAST pc_mstr WHERE pc_user2 <> "" BY integer(pc_user2):
         xxid = INTEGER(pc_user2) .
    END.
    FOR EACH pc_mstr WHERE pc_user2 = "" :
            xxid = xxid + 1 .
            pc_user2 = STRING(xxid) .         
    END.
END.
/**xx**/
*******************/


main-loop:
repeat with frame a:
/*GUI*/ if global-beam-me-up then undo, leave.


   /* Initialize batchdelete variable */
   batchdelete = "".

   /***
   FOR EACH pc_mstr WHERE pc_user2 <> "" BY integer(pc_user2):
          xxid = INTEGER(pc_user2) .
   END.
   ***/

   prompt-for
      pc_list
      pc_curr
      pc_prod_line
      pc_part
      pc_um
      pc_start
      /* Prompt for batchdelete variable only during CIM */
      batchdelete no-label when (batchrun)
   editing:

      
      /* FIND NEXT/PREVIOUS RECORD */
      {mfnp.i pc_mstr pc_list pc_list pc_prod pc_prod pc_list}

      if recno <> ? then do:
/*xx*/         if pc_user1 = "" then pctype = " " .
/*xx*/         else pctype = "T". 
         find pt_mstr where pt_part = pc_part no-lock no-error.
         display
            pc_list
            pc_curr
            pc_prod_line
            pc_part
            pc_um
/**xx**/  pc_user2
            pc_start
            pc_expire
/*xx*/   pctype @ pc_user1            
            pc_amt_type
         with frame a.

         if      pc_amt_type = "P" then amt_label = price.
         else if pc_amt_type = "M" then amt_label = markup.
         else if pc_amt_type = "D" then amt_label = discount.

         /* Get item cost from default site */
         if available pt_mstr then do:

            find si_mstr where si_site = pt_site no-lock.

            if si_db <> global_db then do:
               old_db = global_db.
               {gprun.i ""gpalias3.p"" "(si_db, output err_flag)" }
/*GUI*/ if global-beam-me-up then undo, leave.

            end. /* if si_db <> global_db then do: */

            {gprun.i ""gpsct05.p""
               "(pt_part, si_site, 3, output glxcst, output curcst)" }
/*GUI*/ if global-beam-me-up then undo, leave.

            glxcst_tl = glxcst.

            {gpsct05.i
               &part=pt_part &site=si_site &cost="sct_ovh_tl"}
            glxcst_tl = glxcst_tl - glxcst.

            {gprun.i ""gpsct05.p""
               "(pt_part, si_site, 1, output glxcst, output curcst)" }
/*GUI*/ if global-beam-me-up then undo, leave.

            if old_db <> global_db then do:
               {gprun.i ""gpalias3.p"" "(old_db, output err_flag)" }
/*GUI*/ if global-beam-me-up then undo, leave.

            end. /* if old_db <> global_db then do: */

         end. /* if available pt_mstr then do: */

         if index("PMD", pc_amt_type) <> 0 then do:

            hide frame c.
            view frame b.
            clear frame b no-pause.
/*GUI*/ RECT-FRAME-LABEL:SCREEN-VALUE in frame b = F-b-title.

            display
               disp-stock-um
               disp-total-this-level-gl
               disp-site-col
               disp-total-gl-cost
            with frame b.

            display
               list_label
               qty_label
               amt_label
            with frame b.

            display pc_min_qty pc_amt with frame b.

            if available pt_mstr then do:
               display pt_desc1.
               display
                  pt_price
                  base_curr
                  pt_um
                  glxcst_tl
                  base_curr @ base_curr1
                  pt_site
                  glxcst
                  base_curr @ base_curr2
               with frame b.
            end. /* if available pt_mstr then do: */

            else do:
               display "" @ pt_desc1.
            end. /* else do: */

         end. /* if index("PMD", pc_amt_type) <> 0 then do: */

         else do:

            hide frame b.
            view frame c.
            clear frame c no-pause.
/*GUI*/ RECT-FRAME-LABEL:SCREEN-VALUE in frame c = F-c-title.

            temp_max_price = (pc_max_price[1] + (pc_max_price[2] / 100000)).
            display
               disp-stock-um
               disp-total-this-level-gl
               disp-site-col
               disp-total-gl-cost
            with frame c.

            display
               list_label
               ptable_label
               min_label
               max_label
            with frame c.

            display
               pc_amt[1]
               pc_min_price
               temp_max_price
            with frame c.

            if available pt_mstr then do:
               display pt_desc1.
               display
                  pt_price
                  base_curr
                  pt_um
                  glxcst_tl
                  base_curr @ base_curr1
                  pt_site
                  glxcst
                  base_curr @ base_curr2
               with frame c.
            end. /* if available pt_mstr then do: */

            else do:
               display "" @ pt_desc1.
            end. /* else do: */

         end. /* else do: */

      end.  /* if recno <> ? */

      else if frame-field = "pc_part" then do:
         find pt_mstr where pt_part = input pc_part no-lock no-error.
         if available pt_mstr then
            display pt_desc1.
         else
            display "" @ pt_desc1.
      end. /* If recno = ? and frame-field = pc_part */

   end. /* editing: */

   /* VALIDATE CURRENCY CODE */
   if input pc_curr <> base_curr then do:

      {gprunp.i "mcpl" "p" "mc-chk-valid-curr"
         "(input input pc_curr,
                  output mc-error-number)"}
      if mc-error-number <> 0 then do:
         {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=3}
         /* INVALID CURRENCY CODE */
         next-prompt pc_curr.
         undo main-loop, retry.
      end. /* if mc-error-number <> 0 then do: */
   end. /* if input pc_curr <> base_curr then do: */

   if input pc_prod_line <> "" and input pc_part <> "" then do:
      /* Product Line or Item must be blank */
      {pxmsg.i &MSGNUM=49 &ERRORLEVEL=3}
      next-prompt pc_prod_line.
      undo.
   end.

   /* ADD/MOD/DELETE  */

   find first pc_mstr using pc_list and pc_curr and pc_prod_line
                                    and pc_part and pc_um and pc_start
   no-error.

   if not available pc_mstr then do:
      /* ADDING NEW RECORD */
      {pxmsg.i &MSGNUM=1 &ERRORLEVEL=1}
      create pc_mstr.
      xxid = xxid + 1 .
      assign
         pc_list
         pc_curr
         pc_part
         pc_prod_line
         pc_part
         pc_start pc_um.
      /***xx****
      ASSIGN pc_user2 = STRING(xxid) .
                *****xx*****/
      DISPLAY pc_user2 WITH FRAME a .

      if not can-find(pt_mstr where pt_part = pc_part)
         and pc_part <> "" then do:
         /* Item number does not exist */
         {pxmsg.i &MSGNUM=16 &ERRORLEVEL=2}
      end.

      if not can-find(pl_mstr where pl_prod_line = pc_prod_line)
         and pc_prod_line <> "" then do:
         /* Product Line does not exist */
         {pxmsg.i &MSGNUM=59 &ERRORLEVEL=2}
      end.

   end. /* if not available pc_mstr then do: */

   /* STORE MODIFY DATE AND USERID */
   pc_mod_date = today.
   pc_userid = global_userid.

   if pc_curr = "" then assign pc_curr = base_curr.

   if (pc_curr <> input pc_curr) and
      (pc_curr <> "" and input pc_curr <> "" )
   then do:
      /* Currency cannot be changed */
      {pxmsg.i &MSGNUM=84 &ERRORLEVEL=3}
      undo, retry.
   end. /* then do: */

   if      pc_amt_type = "P" then amt_label = price.
   else if pc_amt_type = "M" then amt_label = markup.
   else if pc_amt_type = "D" then amt_label = discount.

   recno = recid(pc_mstr).

   ststatus = stline[2].
   status input ststatus.
   del-yn = no.

   do on error undo, retry with frame a no-validate:
/*GUI*/ if global-beam-me-up then undo, leave.


      update
         pc_expire  pc_user1 
         pc_amt_type pc_user2 
      go-on ("F5" "CTRL-D").

      if pc_expire <> ? and pc_start <> ? and
         pc_expire < pc_start
      then do:
         /* Expiration date precedes start date */
         {pxmsg.i &MSGNUM=6221 &ERRORLEVEL=2}
      end. /* and pc_expire < pc_start then do: */

/*xx*/  if pc_user1 <> "T" and  pc_user1 <> ""  AND pc_user1 <> "N" then do:
              bell.
              MESSAGE "��������ļ۸�����Ͳ���ȷ������������!"
              message "Error: Price List Type is only allowed  to enter Blank(Normal) or T(rial)" .
             next-prompt pc_user1 with frame a.
              undo , retry .
            end.

      /* DELETE */
      if lastkey = keycode("F5")
      or lastkey = keycode("CTRL-D")
      /* Delete record if batchdelete is set to "x" */
      or input batchdelete = "x"
      then do:
         del-yn = yes.
         /* Please confirm delete */
         {pxmsg.i &MSGNUM=11 &ERRORLEVEL=1 &CONFIRM=del-yn}
         if del-yn = no then undo, retry.
      end. /* then do: */

      /* MANUALLY VALIDATE PRICE LIST TYPE*/
      if index("PMDL", pc_amt_type) = 0 then do:
         /* VALID PRICE LIST TYPES ARE (P), (M), (D), AND (L).*/
         {pxmsg.i &MSGNUM=7527 &ERRORLEVEL=3}
         next-prompt pc_amt_type with frame a.
         undo, retry.
      end.

/**xx*/
       FIND FIRST poc_ctrl NO-LOCK NO-ERROR.
       IF INTEGER(pc_user2) > INTEGER(poc_user1) OR pc_user2 = "" THEN DO:
           bell.
           MESSAGE "��������ĳ��̱��۵�ID�Ų���ȷ������������!"
           next-prompt pc_user2  with frame a.
           undo , retry .
       END.

   end.
/*GUI*/ if global-beam-me-up then undo, leave.
 /* do on error undo, retry with frame a no-validate: */

   if del-yn then do:

      delete pc_mstr.

      clear frame a.
/*GUI*/ RECT-FRAME-LABEL:SCREEN-VALUE in frame a = F-a-title.
      clear frame b.
/*GUI*/ RECT-FRAME-LABEL:SCREEN-VALUE in frame b = F-b-title.
      clear frame c.
/*GUI*/ RECT-FRAME-LABEL:SCREEN-VALUE in frame c = F-c-title.

      display
         base_curr @ pc_curr
      with frame a.

      display
         list_label
         qty_label
         amt_label
      with frame b.

      display
         disp-stock-um
         disp-total-this-level-gl
         disp-site-col
         disp-total-gl-cost
      with frame b.

      del-yn = no.
      next main-loop.

   end. /* if del-yn then do: */

   else do:

      /* GET ITEM COST FROM DEFAULT SITE */
      find pt_mstr where pt_part = pc_part no-lock no-error.

      if available pt_mstr then do:

         find si_mstr where si_site = pt_site no-lock.
         if si_db <> global_db then do:
            old_db = global_db.
            {gprun.i ""gpalias3.p"" "(si_db, output err_flag)" }
/*GUI*/ if global-beam-me-up then undo, leave.

         end. /* if si_db <> global_db then do: */

         {gprun.i ""gpsct05.p""
            "(pt_part, si_site, 3, output glxcst, output curcst)" }
/*GUI*/ if global-beam-me-up then undo, leave.

         glxcst_tl = glxcst.

         {gpsct05.i &part=pt_part &site=si_site &cost="sct_ovh_tl"}
         glxcst_tl = glxcst_tl - glxcst.

         {gprun.i ""gpsct05.p""
            "(pt_part, si_site, 1, output glxcst, output curcst)" }
/*GUI*/ if global-beam-me-up then undo, leave.


         if old_db <> global_db then do:
            {gprun.i ""gpalias3.p"" "(old_db, output err_flag)" }
/*GUI*/ if global-beam-me-up then undo, leave.

         end. /* if old_db <> global_db then do: */

      end. /* if available pt_mstr then do: */

      if pc_amt_type = "P" then
         amt_label = price.
      else if pc_amt_type = "M" then
         amt_label = markup.
      else if pc_amt_type = "D" then
         amt_label = discount.

      /* DISCOUNT TABLE */
      if index("PMD", pc_amt_type) <> 0 then do:

         hide frame c.
         view frame b.
         clear frame b no-pause.
/*GUI*/ RECT-FRAME-LABEL:SCREEN-VALUE in frame b = F-b-title.

         display
            pc_list
            pc_curr
            pc_part
            pc_prod_line
            pc_part
            pc_um
            pc_start.

         display
            list_label
            qty_label
            amt_label
         with frame b.

         display
            disp-stock-um
            disp-total-this-level-gl
            disp-site-col
            disp-total-gl-cost
         with frame b.

         display
            pc_min_qty
            pc_amt
         with frame b.

         if available pt_mstr then do:
            display pt_desc1.
            display
               pt_price
               base_curr
               pt_um
               glxcst_tl
               base_curr @ base_curr1
               pt_site
               glxcst
               base_curr @ base_curr2
            with frame b.
         end. /* if available pt_mstr then do: */

         do on error undo, retry:
/*GUI*/ if global-beam-me-up then undo, leave.


            set
               pc_min_qty[01] pc_amt[01] pc_min_qty[02] pc_amt[02]
               pc_min_qty[03] pc_amt[03] pc_min_qty[04] pc_amt[04]
               pc_min_qty[05] pc_amt[05] pc_min_qty[06] pc_amt[06]
               pc_min_qty[07] pc_amt[07] pc_min_qty[08] pc_amt[08]
               pc_min_qty[09] pc_amt[09] pc_min_qty[10] pc_amt[10]
               pc_min_qty[11] pc_amt[11] pc_min_qty[12] pc_amt[12]
               pc_min_qty[13] pc_amt[13] pc_min_qty[14] pc_amt[14]
               pc_min_qty[15] pc_amt[15]
            go-on ("F5" "CTRL-D")
            with frame b width 80.

            /* DELETE */
            if lastkey = keycode("F5")
            or lastkey = keycode("CTRL-D")
            then do:

               del-yn = yes.
               /* Please confirm delete */
               {pxmsg.i &MSGNUM=11 &ERRORLEVEL=1 &CONFIRM=del-yn}

               if del-yn = no then undo, retry.

               delete pc_mstr.

               clear frame a.
/*GUI*/ RECT-FRAME-LABEL:SCREEN-VALUE in frame a = F-a-title.
               clear frame b.
/*GUI*/ RECT-FRAME-LABEL:SCREEN-VALUE in frame b = F-b-title.

               display
                  list_label
                  qty_label
                  amt_label
               with frame b.

               display
                  disp-stock-um
                  disp-total-this-level-gl
                  disp-site-col
                  disp-total-gl-cost
               with frame b.

               del-yn = no.
               next main-loop.

            end. /* then do: */

            do i = 1 to 15:

               if i > 1 then
               if pc_min_qty[i - 1] >= pc_min_qty[i]
                  and (pc_min_qty[i] <> 0 or pc_amt[i] <> 0)
               then do:
                  /* Min quantities must be in ascending order */
                  {pxmsg.i &MSGNUM=63 &ERRORLEVEL=3}
                  next-prompt pc_min_qty[i] with frame b.
                  undo.
               end. /* and (pc_min_qty[i] <> 0 or pc_amt[i] <> 0) then do: */

               if i > 1 then /* disallow a min qty =0 within the list */
               if (pc_min_qty[i - 1] = 0 and pc_min_qty[i] <> 0)
               then do:
                  if pc_amt[i - 1] = 0 then do:
                     /* Min quantities must be in ascending order */
                     {pxmsg.i &MSGNUM=63 &ERRORLEVEL=3}
                     next-prompt pc_min_qty[i] with frame b.
                     undo.
                  end. /* if pc_amt[i - 1] = 0 then do: */
               end.

               if pc_amt_type = "D" or pc_amt_type = "M" then do:
                  if pc_amt[i] <> truncate(pc_amt[i] * 100,0) / 100
                  then do:
                     /* Decimal precision overflow.  Max decimals # */
                     {pxmsg.i &MSGNUM=99 &ERRORLEVEL=3
                              &MSGARG1=getTermLabel(""TWO"",8)}
                     next-prompt pc_amt[i] with frame b.
                     undo, retry.
                  end.
               end. /* if pc_amt_type = "D" or pc_amt_type = "M" then do: */

            end. /* do i = 1 to 15: */

         end.
/*GUI*/ if global-beam-me-up then undo, leave.
 /* do on error retry */

      end. /* if p,m,d */

      /* Price Table */
      else do:

         hide frame b.
         view frame c.
         clear frame c no-pause.
/*GUI*/ RECT-FRAME-LABEL:SCREEN-VALUE in frame c = F-c-title.

         temp_max_price = (pc_max_price[1] +  (pc_max_price[2] / 100000)).

         display
            pc_list
            pc_curr
            pc_part
            pc_prod_line
            pc_part
            pc_um pc_start.

         display
            list_label
            ptable_label
            pc_amt[1]
            min_label
            pc_min_price
            max_label
            temp_max_price
         with frame c.

         if available pt_mstr then do:
            display pt_desc1.
            display
               pt_price
               base_curr
               pt_um
               glxcst_tl
               base_curr @ base_curr1
               pt_site
               glxcst
               base_curr @ base_curr2
            with frame c.
         end. /* if available pt_mstr then do: */

         display
            ptable_label
            pc_amt[1]
            min_label
            pc_min_price
            max_label
            temp_max_price
         with frame c.

         do on error undo, retry:
/*GUI*/ if global-beam-me-up then undo, leave.


            set
               pc_amt[1] pc_min_price temp_max_price
            go-on ("F5" "CTRL-D")
            with frame c width 80.

            pc_max_price[1] = truncate(temp_max_price,2).
            pc_max_price[2] = (temp_max_price - pc_max_price[1]) * 100000.

            /* DELETE */
            if lastkey = keycode("F5")
            or lastkey = keycode("CTRL-D")
            then do:
               del-yn = yes.
               /* Please confirm delete */
               {pxmsg.i &MSGNUM=11 &ERRORLEVEL=1 &CONFIRM=del-yn}
               if del-yn = no then undo, retry.
               delete pc_mstr.
               clear frame a.
/*GUI*/ RECT-FRAME-LABEL:SCREEN-VALUE in frame a = F-a-title.
               display base_curr @ pc_curr "" @ pt_desc1.
               del-yn = no.
               next main-loop.
            end. /* then do: */

            /* VERIFICATIONS */
            if temp_max_price > 0 then do:
               if pc_min_price > temp_max_price then do:
                  /* MINIMUM EXCEEDS MAXIMUM */
                  {pxmsg.i &MSGNUM=460 &ERRORLEVEL=3 }
                  next-prompt pc_min_price with frame c.
                  undo, retry.
               end. /* if pc_min_price > temp_max_price then do: */
            end. /* if temp_max_price > 0 then do: */

            if pc_amt[1] > 0 then do:

               if pc_min_price > 0 then do:
                  if pc_amt[1] < pc_min_price then do:
                     msg-arg1 = string(pc_amt[1],">>>>>9.99<<<").
                     msg-arg2 = string(pc_min_price,">>>>>9.99<<<").
                     /* LIST PRICE IS BELOW PRICE TABLE MINIMUM. */
                     {pxmsg.i &MSGNUM=6208 &ERRORLEVEL=4
                              &MSGARG1=pc_part
                              &MSGARG2=msg-arg1
                              &MSGARG3=msg-arg2}
                     next-prompt pc_amt[1] with frame c.
                     undo, retry.
                  end. /* if pc_amt[1] < pc_min_price then do: */
               end. /* if pc_min_price > 0 then do: */

               if temp_max_price > 0 then do:
                  if pc_amt[1] > temp_max_price then do:
                     msg-arg1 = string(pc_amt[1],">>>>>9.99<<<").
                     msg-arg2 = string(temp_max_price,">>>>>9.99<<<").
                     /* LIST PRICE IS ABOVE PRICE TABLE MAXIMUM */
                     {pxmsg.i &MSGNUM=6209 &ERRORLEVEL=4
                              &MSGARG1=pc_part
                              &MSGARG2=msg-arg1
                              &MSGARG3=msg-arg2}
                     next-prompt pc_amt[1] with frame c.
                     undo, retry.
                  end. /* if pc_amt[1] > temp_max_price then do: */
               end. /* if temp_max_price > 0 then do: */

            end. /* if pc_amt[1] > 0 then do: */

         end.
/*GUI*/ if global-beam-me-up then undo, leave.
 /* do on error retry */

      end. /* else do: /* PRICE TABLE */ */

   end.  /* else do: */

end.
/*GUI*/ if global-beam-me-up then undo, leave.
 /* repeat with frame a: */

status input.
