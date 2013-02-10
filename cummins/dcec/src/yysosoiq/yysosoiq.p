/* sosoiq.p - SALES ORDER INQUIRY                                       */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                  */
/* All rights reserved worldwide.  This is an unpublished work.         */
/* $Revision: 1.9.4.1 $                                                         */
/*K1JL*/ /*                                                             */
/*V8:ConvertMode=Report                                                       */
/* REVISION: 1.0      LAST MODIFIED: 08/14/86   BY: PML - 04                  */
/* REVISION: 1.0      LAST MODIFIED: 01/17/86   BY: EMB                       */
/* REVISION: 4.0      LAST MODIFIED: 12/23/87   BY: pml                       */
/* REVISION: 4.0      LAST EDIT: 12/30/87       BY: WUG *A137*                */
/* REVISION: 5.0      LAST MODIFIED: 01/30/89   BY: MLB *B024*                */
/* REVISION: 5.0      LAST EDIT: 05/03/89       BY: WUG *B098*                */
/* REVISION: 6.0      LAST EDIT: 04/05/90       BY: ftb *D002*                */
/* REVISION: 6.0      LAST EDIT: 12/27/90       BY: pml *D272*                */
/* REVISION: 6.0      LAST MODIFIED: 02/04/91   BY: afs *D328*                */
/* Revision: 7.3      Last edit: 11/19/92       By: jcd *G339*                */
/* REVISION: 7.3      LAST MODIFIED: 10/17/94   BY: afs *FS51*                */
/* REVISION: 7.4      LAST MODIFIED: 11/18/96   BY: *H0PF* Suresh Nayak       */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane          */
/* REVISION: 8.6E     LAST MODIFIED: 02/25/98   BY: *K1JL* Beena Mol          */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan         */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane   */
/* REVISION: 9.1      LAST MODIFIED: 08/12/00   BY: *N0KN* myb                */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* $Revision: 1.9.4.1 $    BY: Dayanand Jethwa       DATE: 01/28/04  ECO: *P1LM*  */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/* DISPLAY TITLE */
{mfdtitle.i "2+ "}

define variable cust like so_cust no-undo.
define variable nbr like so_nbr no-undo.
define variable part like pt_part no-undo.
define variable qty_open like sod_qty_ship label "Qty Open" no-undo.
define variable po like so_po no-undo.
define variable desc1 like pt_desc1 no-undo.
define variable desc2 like pt_desc1 no-undo.
define variable site like so_site no-undo.

part = global_part.

form
 RECT-FRAME       AT ROW 1 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1 COLUMN 3 NO-LABEL VIEW-AS TEXT SIZE-PIXELS 1 BY 1
 SKIP(.1)  /*GUI*/
   part  colon 15
   /*V8!     view-as fill-in size 20 by 1  */
   nbr   colon 48
   cust  colon 68
   po    colon 15
   site colon 48
with frame a side-labels width 80 NO-BOX THREE-D /*GUI*/.

 DEFINE VARIABLE F-a-title AS CHARACTER INITIAL "".
 RECT-FRAME-LABEL:SCREEN-VALUE in frame a = F-a-title.
 RECT-FRAME-LABEL:HIDDEN in frame a = yes.
 RECT-FRAME:HEIGHT-PIXELS in frame a =
  FRAME a:HEIGHT-PIXELS - RECT-FRAME:Y in frame a - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME a = FRAME a:WIDTH-CHARS - .5.  /*GUI*/


/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

{wbrp01.i}

repeat:

   if c-application-mode <> 'web'
   then
   update part nbr cust po
      site
      with frame a
   editing:

      if frame-field = "part"
      then do:
         /* FIND NEXT/PREVIOUS RECORD */
         {mfnp.i sod_det part " sod_domain = global_domain and sod_part "
         		     part sod_part sod_part}

         if recno <> ?
         then do:
            part = sod_part.
            display part with frame a.
            recno = ?.
         end. /*  IF recno <> ?  */
      end. /*  IF FRAME-FIELD = "part"  */
      else do:
         status input.
         readkey.
         apply lastkey.
      end. /*  IF FRAME-FIELD <> "part"  */
   end. /*  EDITING: */

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

   end. /*  IF (c-application-mode <> 'web') OR ..... */

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

   if part <> ""
   then
      for each sod_det where sod_domain = global_domain
         and sod_part = part
         and (sod_site = site or site = "")
         no-lock with frame b width 80 no-attr-space:

         /* SET EXTERNAL LABELS */
         setFrameLabels(frame b:handle).

         {mfrpchk.i}
         find so_mstr where so_domain = global_domain and
              so_nbr = sod_nbr
            no-lock no-error.
         if (so_nbr = nbr or nbr = "" )
            and (so_cust = cust or cust = "" )
            and (so_po = po or po = "")
         then do:
            qty_open = sod_qty_ord - sod_qty_ship.

            /*display so_nbr so_cust sod_line sod_qty_ord
               qty_open sod_um sod_due_date
               sod_site.*/
/*fm268 begin*/
            assign desc1 = "" desc2 = "".
            find first pt_mstr where pt_domain = global_domain and
                       pt_part=part no-lock no-error.
						if available pt_mstr then do:
					  	 assign desc1 = pt_desc1.
					  	 			  desc2 = pt_desc2.
					  end.
            display so_nbr desc1 desc2 so_cust sod_line sod_qty_ord
               qty_open sod_um sod_due_date
               sod_site with width 140 stream-io.
/*fm268 end*/
         end.  /* IF (so_nbr = nbr OR nbr = "" )  */
      end. /*  FOR EACH sod_det  */

   else
   if nbr <> ""
   then
      loopc:
   for each so_mstr where so_domain = global_domain
      and so_nbr = nbr
      and  (so_cust = cust or cust = "" )
      and  (so_po = po or po = "")
      no-lock with frame c width 80 no-attr-space:

      /* SET EXTERNAL LABELS */

      setFrameLabels(frame c:handle).
      {mfrpchk.i}
      for each sod_det where sod_domain = global_domain
         and sod_nbr = so_nbr
         and  (sod_site = site or site = "")
         no-lock on endkey undo, leave loopc with frame c:
         {mfrpchk.i}
         qty_open = sod_qty_ord - sod_qty_ship.
         /*display so_cust sod_line sod_part
            sod_qty_ord qty_open sod_um sod_due_date
            sod_site.*/
/*fm268 begin*/
				 assign desc1 = "" desc2 = "".
         find first pt_mstr where pt_domain = global_domain
         			  and pt_part=sod_part no-lock no-error.
						if available pt_mstr then do:
					  	 assign desc1 = pt_desc1.
					  	 			  desc2 = pt_desc2.
					  end.	

         display so_cust sod_line sod_part desc1 desc2
            sod_qty_ord qty_open sod_um sod_due_date
            sod_site with width 140 stream-io.
/*fm268 end*/
         down 1.
      end. /*  FOR EACH sod_det  */
   end. /*  FOR EACH so_mstr  */

   else
   if cust <> ""
   then
      loopd:
   for each so_mstr where so_domain = global_domain
   		and   (so_cust = cust)
      and   (so_po = po or po = "")
      no-lock by so_cust by so_nbr
      with frame d width 80 no-attr-space:

      /* SET EXTERNAL LABELS */

      setFrameLabels(frame d:handle).
      {mfrpchk.i}
      for each sod_det where sod_domain = global_domain
      	 and   sod_nbr = so_nbr
         and  (sod_site = site or site = "")
         no-lock by sod_nbr by sod_line
         on endkey undo, leave loopd with frame d:

         {mfrpchk.i}

         qty_open = sod_qty_ord - sod_qty_ship.
         /*display so_nbr sod_line sod_part
            sod_qty_ord qty_open sod_um sod_due_date
            sod_site.*/
/*fm268 begin*/
				 assign desc1 = "" desc2 = "".
         find first pt_mstr where pt_domain = global_domain
         			  and pt_part=sod_part no-lock no-error.
						if available pt_mstr then do:
					  	 assign desc1 = pt_desc1.
					  	 			  desc2 = pt_desc2.
					  end.	

         display so_nbr sod_line sod_part desc1 desc2
            sod_qty_ord qty_open sod_um sod_due_date
            sod_site with width 140 stream-io.
/*fm268 end */
         down 1.
      end. /*  FOR EACH sod_det  */
   end. /*  FOR EACH so_mstr  */

   /* B024* added loope*/
   else
   if po <> ""
   then
      loope:
   for each so_mstr where so_domain = global_domain and so_po = po
      no-lock with frame e width 80 no-attr-space:

     /* SET EXTERNAL LABELS */

      setFrameLabels(frame e:handle).
      {mfrpchk.i}
      for each sod_det where sod_domain = global_domain and sod_nbr = so_nbr
         and  (sod_site = site or site = "")
         no-lock by sod_nbr by sod_line
         on endkey undo, leave loope with frame e:

         {mfrpchk.i}

         qty_open = sod_qty_ord - sod_qty_ship.
         /*display so_nbr  sod_line sod_part
            sod_qty_ord qty_open sod_um sod_due_date
            sod_site.*/
/*fm268 begin*/
         assign desc1 = "" desc2 = "".
         find first pt_mstr where pt_domain = global_domain
         			  and pt_part=sod_part no-lock no-error.
						if available pt_mstr then do:
					  	 assign desc1 = pt_desc1.
					  	 			  desc2 = pt_desc2.
					  end.	
         display so_nbr  sod_line sod_part desc1 desc2
            sod_qty_ord qty_open sod_um sod_due_date
            sod_site with width 140 stream-io.
/*fm268 end*/
         down 1.
      end. /*  FOR EACH sod_det  */
   end. /*  FOR EACH so_mstr  */

   else
   if site <> ""
   then
      loopf:
   for each sod_det where sod_domain = global_domain and sod_site = site
      no-lock by sod_nbr by sod_line
      on endkey undo, leave loopf with frame f width 80:

      /* SET EXTERNAL LABELS */

      setFrameLabels(frame f:handle).
      {mfrpchk.i}
      find so_mstr where so_domain = global_domain and  so_nbr = sod_nbr
         no-lock no-error.
      qty_open = sod_qty_ord - sod_qty_ship.
      /*display so_nbr so_cust sod_line sod_part
         qty_open sod_um sod_due_date sod_site.*/
/*fm268 begin*/
      				 assign desc1 = "" desc2 = "".
         find first pt_mstr where pt_domain = global_domain
         			  and pt_part=sod_part no-lock no-error.
						if available pt_mstr then do:
					  	 assign desc1 = pt_desc1.
					  	 			  desc2 = pt_desc2.
					  end.	
      display so_nbr so_cust sod_line sod_part desc1 desc2
         qty_open sod_um sod_due_date sod_site with width 140 stream-io.
/*fm268 end*/
   end. /*  FOR EACH sod_det  */

   else
   for each sod_det no-lock where sod_domain = global_domain and sod_nbr  >= ""
      and   sod_line >= 0
      by sod_part with frame g width 80
      no-attr-space:
      /* SET EXTERNAL LABELS */
      setFrameLabels(frame g:handle).
      {mfrpchk.i}
      find so_mstr where so_domain = global_domain and so_nbr = sod_nbr
         no-lock no-error.
      qty_open = sod_qty_ord - sod_qty_ship.
      /*display so_nbr so_cust sod_line sod_part
         qty_open sod_um sod_due_date
         sod_site.*/
/*fm268 begin*/
      				 assign desc1 = "" desc2 = "".
         find first pt_mstr where pt_domain = global_domain
         			  and pt_part=sod_part no-lock no-error.
						if available pt_mstr then do:
					  	 assign desc1 = pt_desc1.
					  	 			  desc2 = pt_desc2.
					  end.	
      display so_nbr so_cust sod_line sod_part desc1 desc2
         qty_open sod_um sod_due_date
         sod_site with width 140 stream-io.
/*fm268 end */

   end. /*  FOR EACH sod_det  */

  {mfreset.i}
/*GUI*/ {mfgrptrm.i} /*Report-to-Window*/
   {pxmsg.i &MSGNUM=8 &ERRORLEVEL=1}
end. /*  REPEAT: */

global_part = part.

{wbrp04.i &frame-spec = a}
