/* GUI CONVERTED from sosoiq.p (converter v1.78) Fri Oct 29 14:38:08 2004 */
/* sosoiq.p - SALES ORDER INQUIRY                                       */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                  */
/* All rights reserved worldwide.  This is an unpublished work.         */
/* $Revision: 1.13 $                                                     */
/*V8:ConvertMode=Report                                        */
/* REVISION: 1.0      LAST MODIFIED: 08/14/86   BY: PML - 04   */
/* REVISION: 1.0      LAST MODIFIED: 01/17/86   BY: EMB        */
/* REVISION: 4.0      LAST MODIFIED: 12/23/87   BY: pml        */
/* REVISION: 4.0      LAST EDIT: 12/30/87       BY: WUG *A137* */
/* REVISION: 5.0      LAST MODIFIED: 01/30/89   BY: MLB *B024* */
/* REVISION: 5.0      LAST EDIT: 05/03/89       BY: WUG *B098* */
/* REVISION: 6.0      LAST EDIT: 04/05/90       BY: ftb *D002* */
/* REVISION: 6.0      LAST EDIT: 12/27/90       BY: pml *D272* */
/* REVISION: 6.0      LAST MODIFIED: 02/04/91   BY: afs *D328* */
/* Revision: 7.3      Last edit: 11/19/92       By: jcd *G339* */
/* REVISION: 7.3      LAST MODIFIED: 10/17/94   BY: afs *FS51* */
/* REVISION: 7.4      LAST MODIFIED: 11/18/96   BY: *H0PF* Suresh Nayak       */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane          */
/* REVISION: 8.6E     LAST MODIFIED: 02/25/98   BY: *K1JL* Beena Mol          */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan         */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane   */
/* REVISION: 9.1      LAST MODIFIED: 08/12/00   BY: *N0KN* myb                */
/* Revision: 1.11     BY: Paul Donnelly (SB)  DATE: 06/28/03  ECO: *Q00L*     */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* Revision: 1.12     BY: Katie Hilbert          DATE: 11/14/03  ECO: *Q04M*  */
/* $Revision: 1.13 $    BY: Dayanand Jethwa        DATE: 01/28/04  ECO: *P1LM*  */
/* ss - 121009.1 by: Steven */ /*Add column Qty Pick,CrStat,Qty Inv*/

/*-Revision end---------------------------------------------------------------*/
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/* DISPLAY TITLE */

/*GUI preprocessor directive settings */
&SCOPED-DEFINE PP_GUI_CONVERT_MODE REPORT
/*
{mfdtitle.i "1+ "}
*/
{mfdtitle.i "121009.1"}

define variable cust     like so_cust  no-undo.
define variable nbr      like so_nbr   no-undo.
define variable part     like pt_part  no-undo.
define variable qty_open like sod_qty_ship label "Qty Open" no-undo.
define variable po       like so_po    no-undo.
define variable site     like so_site  no-undo.
/* ss - 121009.1 - B */
define variable qty_pick like lad_qty_pick  no-undo.              
define variable qty_inv  like ld_qty_oh     no-undo.
/* ss - 121009.1 - E */

part = global_part.

/*GUI preprocessor Frame A define */
&SCOPED-DEFINE PP_FRAME_NAME A

FORM /*GUI*/ 
   
 RECT-FRAME       AT ROW 1 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1 COLUMN 3 NO-LABEL VIEW-AS TEXT SIZE-PIXELS 1 BY 1
 SKIP(.1)  /*GUI*/
part  colon 15
         view-as fill-in size 20 by 1   
   nbr   colon 48
   cust  colon 68
   po    colon 15
   site  colon 48
with frame a side-labels  width 80 attr-space NO-BOX THREE-D /*GUI*/.

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

{wbrp01.i}

repeat:

   if c-application-mode <> 'web' then
      update
         part
         nbr
         cust
         po
         site
      with frame a
   editing:

      if frame-field = "part" then do:
         /* FIND NEXT/PREVIOUS RECORD */
         {mfnp.i sod_det part  " sod_det.sod_domain = global_domain and sod_part "
            part sod_part sod_part}

         if recno <> ? then do:
            part = sod_part.
            display part with frame a.
            recno = ?.
         end.
      end.
      else do:
         status input.
         readkey.
         apply lastkey.
      end.
   end.

   {wbrp06.i &command = update &fields = "  part nbr cust po  site"
      &frm = "a"}

   if (c-application-mode <> 'web') or
      (c-application-mode = 'web' and
      (c-web-request begins 'data'))
   then do:

      hide frame b.
      hide frame c.
      hide frame d.
      hide frame e.
      hide frame f.
      hide frame g.

   end.

   /* OUTPUT DESTINATION SELECTION */
   {gpselout.i &printType = "terminal"
               &printWidth = 80
               &pagedFlag = " "
               &stream = " "
               &appendToFile = " "
               &streamedOutputToTerminal = " "
               &withBatchOption = "no"
               &displayStatementType = 1
               &withCancelMessage = "yes"
               &pageBottomMargin = 6
               &withEmail = "yes"
               &withWinprint = "yes"
               &defineVariables = "yes"}
/*GUI*/ RECT-FRAME:HEIGHT-PIXELS in frame a = FRAME a:HEIGHT-PIXELS - RECT-FRAME:Y in frame a - 2.


   if part <> "" then
      for each sod_det
         where sod_domain = global_domain
         and  (sod_part = part
         and  (sod_site = site or site = ""))
      no-lock with frame b width 180 no-attr-space:
         /* SET EXTERNAL LABELS */
         setFrameLabels(frame b:handle).
         
/*GUI*/ {mfguichk.i } /*Replace mfrpchk*/

         find so_mstr
            where so_domain = global_domain
             and  so_nbr = sod_nbr
         no-lock.
         if  (so_nbr = nbr or nbr = "" )
         and (so_cust = cust or cust = "" )
         and (so_po = po or po = "")
         then do:
            qty_open = sod_qty_ord - sod_qty_ship.
            /* ss - 121009.1 - B */
            qty_pick =0. qty_inv = 0.
            for each lad_det no-lock where lad_domain = sod_domain
            and lad_dataset = "sod_det" and lad_nbr = sod_nbr
            and lad_line = string(sod_line) and lad_part = sod_part:
                qty_pick = qty_pick + lad_qty_pick.
            end.
            for each ld_det no-lock where ld_domain = sod_domain
            and ld_site = sod_site and ld_part = sod_part ,
            each is_mstr no-lock where is_domain = sod_domain 
            and is_status = ld_status and is_avail = yes :
                qty_inv = qty_inv + ld_qty_oh. 
            end.
            /* ss - 121009.1 - E */
            display
               so_nbr
               so_cust
               sod_line
               sod_qty_ord
               qty_open
               /* ss - 121009.1 - B */
               qty_pick
               so_stat
               qty_inv
               /* ss - 121009.1 - E */
               sod_um
               sod_due_date
               sod_site WITH STREAM-IO /*GUI*/ .
         end.
      end.

   else
   if nbr <> "" then
      loopc:
      for each so_mstr
         where so_domain = global_domain
         and ( so_nbr = nbr
         and  (so_cust = cust or cust = "" )
         and  (so_po = po or po = ""))
      no-lock with frame c width 180 no-attr-space:
         /* SET EXTERNAL LABELS */
         setFrameLabels(frame c:handle).
         
/*GUI*/ {mfguichk.i } /*Replace mfrpchk*/

         for each sod_det
            where sod_det.sod_domain = global_domain
            and ( sod_nbr = so_nbr
            and  (sod_site = site or site = ""))
         no-lock on endkey undo, leave loopc 
         with frame c width 180 no-attr-space:
            
/*GUI*/ {mfguichk.i } /*Replace mfrpchk*/

            qty_open = sod_qty_ord - sod_qty_ship.
            /* ss - 121009.1 - B */
            qty_pick =0. qty_inv = 0.
            for each lad_det no-lock where lad_domain = sod_domain
            and lad_dataset = "sod_det" and lad_nbr = sod_nbr
            and lad_line = string(sod_line) and lad_part = sod_part:
                qty_pick = qty_pick + lad_qty_pick.
            end.
            for each ld_det no-lock where ld_domain = sod_domain
            and ld_site = sod_site and ld_part = sod_part ,
            each is_mstr no-lock where is_domain = sod_domain 
            and is_status = ld_status and is_avail = yes :
                qty_inv = qty_inv + ld_qty_oh. 
            end.
            /* ss - 121009.1 - E */
            
            display
               so_cust
               sod_line
               sod_part
               sod_qty_ord
               qty_open
               /* ss - 121009.1 - B */
               qty_pick
               so_stat
               qty_inv
               /* ss - 121009.1 - E */
               sod_um
               sod_due_date
               sod_site WITH STREAM-IO /*GUI*/ .
            down 1.
         end.
      end.

   else
   if cust <> "" then
      loopd:
      for each so_mstr
         where so_domain = global_domain
         and ((so_cust = cust)
         and  (so_po = po or po = ""))
      no-lock by so_cust by so_nbr
      with frame d width 180 no-attr-space:
         /* SET EXTERNAL LABELS */
         setFrameLabels(frame d:handle).
         
/*GUI*/ {mfguichk.i } /*Replace mfrpchk*/

         for each sod_det
            where sod_domain = global_domain
            and ( sod_nbr = so_nbr
            and  (sod_site = site or site = ""))
         no-lock by sod_nbr by sod_line
         on endkey undo, leave loopd with frame d
         width 180 no-attr-space:
            
/*GUI*/ {mfguichk.i } /*Replace mfrpchk*/

            qty_open = sod_qty_ord - sod_qty_ship.
            /* ss - 121009.1 - B */
            qty_pick =0. qty_inv = 0.
            for each lad_det no-lock where lad_domain = sod_domain
            and lad_dataset = "sod_det" and lad_nbr = sod_nbr
            and lad_line = string(sod_line) and lad_part = sod_part:
                qty_pick = qty_pick + lad_qty_pick.
            end.
            for each ld_det no-lock where ld_domain = sod_domain
            and ld_site = sod_site and ld_part = sod_part ,
            each is_mstr no-lock where is_domain = sod_domain 
            and is_status = ld_status and is_avail = yes :
                qty_inv = qty_inv + ld_qty_oh. 
            end.
            /* ss - 121009.1 - E */
            
            display
               so_nbr
               sod_line
               sod_part
               sod_qty_ord
               qty_open
               /* ss - 121009.1 - B */
               qty_pick
               so_stat
               qty_inv
               /* ss - 121009.1 - E */
               sod_um
               sod_due_date
               sod_site WITH STREAM-IO /*GUI*/ .
            down 1.
         end.
      end.

   else
   if po <> "" then
      loope:
      for each so_mstr
         where so_domain = global_domain
         and   so_po = po
      no-lock with frame e width 180 no-attr-space:
         /* SET EXTERNAL LABELS */
         setFrameLabels(frame e:handle).
         
/*GUI*/ {mfguichk.i } /*Replace mfrpchk*/

         for each sod_det
            where sod_domain = global_domain
            and ( sod_nbr = so_nbr
            and  (sod_site = site or site = ""))
         no-lock by sod_nbr by sod_line
         on endkey undo, leave loope with frame e
         width 180 no-attr-space:
            
/*GUI*/ {mfguichk.i } /*Replace mfrpchk*/

            qty_open = sod_qty_ord - sod_qty_ship.
            /* ss - 121009.1 - B */
            qty_pick =0. qty_inv = 0.
            for each lad_det no-lock where lad_domain = sod_domain
            and lad_dataset = "sod_det" and lad_nbr = sod_nbr
            and lad_line = string(sod_line) and lad_part = sod_part:
                qty_pick = qty_pick + lad_qty_pick.
            end.
            for each ld_det no-lock where ld_domain = sod_domain
            and ld_site = sod_site and ld_part = sod_part ,
            each is_mstr no-lock where is_domain = sod_domain 
            and is_status = ld_status and is_avail = yes :
                qty_inv = qty_inv + ld_qty_oh. 
            end.
            /* ss - 121009.1 - E */
            display
               so_nbr
               sod_line
               sod_part
               sod_qty_ord
               qty_open
               /* ss - 121009.1 - B */
               qty_pick
               so_stat
               qty_inv
               /* ss - 121009.1 - E */
               sod_um
               sod_due_date
               sod_site WITH STREAM-IO /*GUI*/ .
            down 1.
         end.
      end.

   else
   if site <> "" then
      loopf:
      for each sod_det
         where sod_domain = global_domain
         and   sod_site = site
      no-lock by sod_nbr by sod_line
      on endkey undo, leave loopf with frame f width 180:
         /* SET EXTERNAL LABELS */
         setFrameLabels(frame f:handle).
         
/*GUI*/ {mfguichk.i } /*Replace mfrpchk*/

         find so_mstr
            where so_domain = global_domain
             and  so_nbr = sod_nbr no-lock no-error.
         qty_open = sod_qty_ord - sod_qty_ship.
         /* ss - 121009.1 - B */
         qty_pick =0. qty_inv = 0.
         for each lad_det no-lock where lad_domain = sod_domain
         and lad_dataset = "sod_det" and lad_nbr = sod_nbr
         and lad_line = string(sod_line) and lad_part = sod_part:
             qty_pick = qty_pick + lad_qty_pick.
         end.
         for each ld_det no-lock where ld_domain = sod_domain
         and ld_site = sod_site and ld_part = sod_part ,
         each is_mstr no-lock where is_domain = sod_domain 
         and is_status = ld_status and is_avail = yes :
             qty_inv = qty_inv + ld_qty_oh. 
         end.
         /* ss - 121009.1 - E */
         display
            so_nbr
            so_cust
            sod_line
            sod_part
            qty_open
            /* ss - 121009.1 - B */
            qty_pick
            so_stat
            qty_inv
            /* ss - 121009.1 - E */            
            sod_um
            sod_due_date
            sod_site WITH STREAM-IO /*GUI*/ .
   end.

   else
      for each sod_det no-lock
         where sod_domain = global_domain
         and   sod_nbr >= ""
         and   sod_line >= 0
         by sod_part
      with frame g width 180 no-attr-space:
         /* SET EXTERNAL LABELS */
         setFrameLabels(frame g:handle).
         
/*GUI*/ {mfguichk.i } /*Replace mfrpchk*/

         find so_mstr
            where so_domain = global_domain
            and   so_nbr = sod_nbr no-lock no-error.
         qty_open = sod_qty_ord - sod_qty_ship.
         /* ss - 121009.1 - B */
         qty_pick =0. qty_inv = 0.
         for each lad_det no-lock where lad_domain = sod_domain
         and lad_dataset = "sod_det" and lad_nbr = sod_nbr
         and lad_line = string(sod_line) and lad_part = sod_part:
             qty_pick = qty_pick + lad_qty_pick.
         end.
         for each ld_det no-lock where ld_domain = sod_domain
         and ld_site = sod_site and ld_part = sod_part ,
         each is_mstr no-lock where is_domain = sod_domain 
         and is_status = ld_status and is_avail = yes :
             qty_inv = qty_inv + ld_qty_oh. 
         end.
         /* ss - 121009.1 - E */
         display
            so_nbr
            so_cust
            sod_line
            sod_part
            qty_open
            /* ss - 121009.1 - B */
            qty_pick
            so_stat
            qty_inv
            /* ss - 121009.1 - E */
            sod_um
            sod_due_date
            sod_site WITH STREAM-IO /*GUI*/ .
      end.
   {mfreset.i}
/*GUI*/ {mfgrptrm.i} /*Report-to-Window*/

   {pxmsg.i &MSGNUM=8 &ERRORLEVEL=1}
end.
global_part = part.

{wbrp04.i &frame-spec = a}
