/* GUI CONVERTED from resqwb.p (converter v1.78) Fri Oct 29 14:37:53 2004 */
/* resqwb.p - PRODUCTION LINE WORK BENCH                                      */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.24 $                                                          */
/*V8:ConvertMode=Maintenance                                                  */
/* REVISION: 7.0    LAST MODIFIED: 12/04/91     BY: smm *F230*                */
/* REVISION: 7.0    LAST MODIFIED: 03/29/92     BY: emb *F331*                */
/* REVISION: 7.0    LAST MODIFIED: 04/06/92     BY: smm *F364*                */
/* REVISION: 7.0    LAST MODIFIED: 04/13/92     BY: smm *F383*                */
/* REVISION: 7.0    LAST MODIFIED: 05/16/92     BY: emb *F531*                */
/* REVISION: 7.3    LAST MODIFIED: 12/08/92     BY: emb *G468*                */
/* REVISION: 7.3    LAST MODIFIED: 01/07/93     BY: emb *G524*                */
/* REVISION: 7.3    LAST MODIFIED: 01/25/93     BY: emb *G590*                */
/* REVISION: 7.3    LAST MODIFIED: 04/22/93     BY: rwl *GA13*                */
/* REVISION: 7.3    LAST MODIFIED: 08/12/94     BY: pxd *FQ12*                */
/* REVISION: 7.2    LAST MODIFIED: 09/01/94     BY: ais *FQ68*                */
/* REVISION: 7.2    LAST MODIFIED: 09/10/94     BY: pxd *FQ99*                */
/* REVISION: 7.3    LAST MODIFIED: 09/15/94     by: slm *GM63*                */
/* REVISION: 7.3    LAST MODIFIED: 09/21/94     by: ljm *GM77*                */
/* REVISION: 7.3    LAST MODIFIED: 10/04/94     by: pxd *FS05*                */
/* REVISION: 7.3    LAST MODIFIED: 10/06/94     by: pxd *FS21*                */
/* REVISION: 7.5    LAST MODIFIED: 10/24/94     BY: mwd *J034*                */
/* REVISION: 7.4    LAST MODIFIED: 11/06/94     by: rwl *GO29*                */
/* REVISION: 7.4    LAST MODIFIED: 11/09/94     by: srk *GO05*                */
/* REVISION: 7.4    LAST MODIFIED: 12/14/94     BY: WUG *FU58*                */
/* REVISION: 7.5    LAST MODIFIED: 12/20/94     BY: tjs *J014*                */
/* REVISION: 7.4    LAST MODIFIED: 02/06/95     by: pxd *F0H5*                */
/* REVISION: 7.4    LAST MODIFIED: 03/22/95     by: ais *F0NP*                */
/* REVISION: 7.2    LAST MODIFIED: 04/10/95     by: ais *F0Q2*                */
/* REVISION: 7.3    LAST MODIFIED: 11/22/95     by: dzn *G1F0*                */
/* REVISION: 7.4    LAST MODIFIED: 11/29/95     by: jym *G1FB*                */
/* REVISION: 7.4    LAST MODIFIED: 02/05/96     BY: jym *G1M8*                */
/* REVISION: 8.5      LAST MODIFIED: 12/17/96   BY: *G2JN* Julie Milligan     */
/* REVISION: 8.5      LAST MODIFIED: 05/12/97   BY: *J1R2* Julie Milligan     */
/* REVISION: 8.5      LAST MODIFIED: 12/22/97   BY: *H1HM* Thomas Fernandes   */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane          */
/* REVISION: 8.6E     LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan         */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan         */
/* REVISION: 9.0      LAST MODIFIED: 11/09/98   BY: *M012* Mugdha Tambe       */
/* REVISION: 9.0      LAST MODIFIED: 01/29/98   BY: *M066* John Pison         */
/* REVISION: 9.0      LAST MODIFIED: 03/13/99   BY: *M0BD* Alfred Tan         */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane   */
/* REVISION: 9.1      LAST MODIFIED: 08/12/00   BY: *N0KP* Mark Brown         */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* Old ECO marker removed, but no ECO header exists *F0NQ*                    */
/* Revision: 1.21        BY: Rajesh Thomas       DATE: 05/02/01  ECO: *M15B*  */
/* Revision: 1.23      BY: Jean Miller         DATE: 05/15/02  ECO: *P05V*  */
/* $Revision: 1.24 $  BY: Ed van de Gevel  DATE: 03/24/03 ECO: *Q005* */
/* $Revision: 1.24 $  BY: Mage Chen  DATE: 03/24/06 ECO: *ts01* */
/*  $Revision: by ken SS - 111011.1 B*/
/*-Revision end---------------------------------------------------------------*/

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/
/*SS - 111011.1
{mfdtitle.i "2+ "}
*/

/*SS - 111011.1 B*/

{mfdtitle.i "111011.1"}

/*SS - 111011.1 E*/


define new shared variable undo-input1 like mfc_logical no-undo.
define new shared variable prline       like  rps_line.
define new shared variable site         like  rps_site.
define new shared variable old_sequence like seq_priority.
define new shared variable old_date     like seq_due_date.
define new shared variable lnd_recno    as recid.
define new shared variable qtyreq       like rps_qty_req.
define new shared variable part         like seq_part.
define new shared variable begin_date   like seq_start.
define new shared variable lundo-input2 like mfc_logical no-undo.

define new shared variable used_hours as decimal.
define new shared variable shft_amt as decimal extent 4.
define new shared variable hours as decimal extent 4.
define new shared variable cap as decimal extent 4.
define new shared variable multiple    as decimal initial 1.

define variable del-yn       like mfc_logical.
define variable sw_reset     like mfc_logical.
define variable ptstatus     like pt_status.
define variable bad_sched_qty as  logical.
define variable seqpriority  like seq_priority no-undo.
/*ts01*/ define variable priority1  like seq_priority no-undo.
/*ts01*/ define variable sum  like seq_qty_req no-undo.
/*ts01*/ define variable ii  as integer no-undo.
/*ts01*/ define variable due_date  as date no-undo.
/*ts01*/ define  variable old_priority like seq_priority.
define buffer s1 for seq_mstr.

/* REVISED FORM */

/*GUI preprocessor Frame A define */
&SCOPED-DEFINE PP_FRAME_NAME A

FORM /*GUI*/ 
   
 RECT-FRAME       AT ROW 1 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1 COLUMN 3 NO-LABEL VIEW-AS TEXT SIZE-PIXELS 1 BY 1
 SKIP(.1)  /*GUI*/
prline     colon 16
   ln_desc    colon 27 no-label
   begin_date colon 66
   site       colon 16
   si_desc    colon 27 no-label
   multiple   colon 66 label "Multiple"
 SKIP(.4)  /*GUI*/
with frame a side-labels width 80 NO-BOX THREE-D /*GUI*/.

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
   seq_priority   column-label "Sequence" format ">>>.99"
        bgcolor 15 
   /*SS - 111011.1 B*/
   seq__chr01     COLUMN-LABEL "班次"
   /*SS - 111011.1 E*/
        bgcolor 15 
   seq_part       column-label "Item Number"
        bgcolor 15   
   seq_qty_req    column-label "Quantity"
        bgcolor 15   
   seq_due_date
        bgcolor 15   
   seq__dec01     column-label "New Seq No" format ">>9.9<"
        bgcolor 15   
   seq__log01     column-label "Del" format "***/"
        bgcolor 15   
with frame c down attr-space width 80
title color normal (getFrameTitle("AVAILABLE_SEQUENCE_RECORDS",34)) THREE-D /*GUI*/.


/* SET EXTERNAL LABELS */
setFrameLabels(frame c:handle).

assign
   site = global_site
   begin_date = today.

find first ln_mstr no-lock  where ln_mstr.ln_domain = global_domain and
 ln_site = global_site no-error.
if available ln_mstr then prline = ln_line.

mainloop:
repeat on error undo, retry:
/*GUI*/ if global-beam-me-up then undo, leave.


   /* RELEASE THE ln_mstr FILE SO THAT ANY LOCK IF ACTIVE WILL BE RELEASED */
   release ln_mstr.

   update
      prline
      site
      begin_date
      multiple
      with frame a
   editing:

      if frame-field = "prline" then do:
         /* FIND /NEXT PREVIOUS */
         {mfnp.i ln_mstr prline  " ln_mstr.ln_domain = global_domain and
          ln_line "  prline ln_line ln_linesite}
         if recno <> ? then
            display
               ln_line @ prline
               ln_desc
            with frame a.
      end.

      else if frame-field = "site" then do:
         /* FIND /NEXT PREVIOUS */
         {mfnp05.i ln_mstr ln_linesite " ln_mstr.ln_domain = global_domain and
          ln_line  = input prline"
            ln_site "input site"}
         if recno <> ? then do:
            find si_mstr no-lock  where si_mstr.si_domain = global_domain and
             si_site = ln_site no-error.
            if available si_mstr
               then display si_site @ site si_desc with frame a.
            else display ln_site @ site "" @ si_desc with frame a.
         end.
      end.

      else do:
         readkey.
         apply lastkey.
      end.

   end. /* editing */

   find si_mstr no-lock  where si_mstr.si_domain = global_domain and  si_site =
    site no-error.
   if not available si_mstr then do:
      /* Site not available */
      {pxmsg.i &MSGNUM=708 &ERRORLEVEL=3}
      next-prompt site.
      undo, retry.
   end.

   {gprun.i ""gpsiver.p""
      "(input si_site, input recid(si_mstr), output return_int)"}
/*GUI*/ if global-beam-me-up then undo, leave.

   if return_int = 0 then do:
      {pxmsg.i &MSGNUM=725 &ERRORLEVEL=3}
      /*USER DOES NOT HAVE ACCESS TO THIS SITE */
      next-prompt site with frame a.
      undo, retry.
   end.

   global_site = site.

   run lock_line.

   if not available ln_mstr then do:
      /* Site production line does not exist */
      {pxmsg.i &MSGNUM=8526 &ERRORLEVEL=3}
      next-prompt prline with frame a.
      undo, retry.
   end.

   display
      ln_desc
      si_desc
   with frame a.

   /* Get begin date of sequence */
   if begin_date = ? then do:
      find first seq_mstr  where seq_mstr.seq_domain = global_domain and
       seq_site = site
                            and seq_line = prline
/*ts01*     no-lock use-index seq_sequence no-error.  */
  /*ts01*/     no-lock use-index seq_site no-error.      
        if available seq_mstr then
         begin_date = seq_due_date.
   end.

   if begin_date = ? then
      begin_date = today.

   display begin_date with frame a.

   if multiple = ? then multiple = 0.

   if multiple < 0 then do:

      /*Multiple may not be negative */
      {pxmsg.i &MSGNUM=319 &ERRORLEVEL=3}
      next-prompt multiple with frame a.
      undo, retry.
   end.

   view frame c.
   sw_reset = yes.

   ststatus = stline[2].
   status input ststatus.
   status input.

   if multiple <> 0 then do:

      for each seq_mstr
          where seq_mstr.seq_domain = global_domain and  seq_site = site
           and seq_line = prline
      no-lock:
/*GUI*/ if global-beam-me-up then undo, leave.

         if truncate((seq_qty_req / multiple),0) * multiple <> seq_qty_req
         then do:
            /*Sched qty not a multiple. Mult set to 0*/
            {pxmsg.i &MSGNUM=320 &ERRORLEVEL=2}
            pause 3.
            multiple = 0.
            display multiple with frame a.
            leave.
         end.
      end.
/*GUI*/ if global-beam-me-up then undo, leave.

   end.

   scrolloop:
   repeat with frame c:
/*GUI*/ if global-beam-me-up then undo, leave.


      pause 0.

      do transaction:
/*GUI*/ if global-beam-me-up then undo, leave.


         run lock_line.

         /* Variables use for rescrad.i                            */
         /* {1} = file-name, eg., pt_mstr                          */
         /* {2} = index to use, eg., pt_part                       */
         /* {3} = field to select records by, eg., pt_part         */
         /* {4} = fields to display from primary file, eg.,
                  "pt_part pt_desc1 pt_price"                      */
         /* {5} = field to hi-light, eg., pt_part                  */
         /* {6} = frame name                                       */
         /* {7} = Selection criteria should be "yes"
                  if no selection used                             */

         /*SS - 111011.1 B*/
         /*
         {rescrad.i seq_mstr "use-index seq_sequence" seq_priority
            "seq_priority seq_part seq_qty_req seq_due_date seq__log01
                   seq__dec01 when seq__dec01 <> 0"
            seq_priority c
            "seq_domain = global_domain and
             seq_line = prline and seq_site = site
                   and seq_due_date >= begin_date"}         
         */
         {rescrad.i seq_mstr "use-index seq_sequence" seq_priority
            "seq_priority seq__chr01 seq_part seq_qty_req seq_due_date seq__log01
                   seq__dec01 when seq__dec01 <> 0"
            seq_priority c
            "seq_domain = global_domain and
             seq_line = prline and seq_site = site
                   and seq_due_date >= begin_date"}
         /*SS - 111011.1 E*/
      end.
/*GUI*/ if global-beam-me-up then undo, leave.


      if keyfunction(lastkey) = "end-error" then leave.

      if recno = ? and not keyfunction(lastkey) = "insert-mode"
         and keyfunction(lastkey) <> "return"

         then next.

      /* If you press return then in modify mode */
      if keyfunction(lastkey) = "return" and recno <> ?
      then do transaction on error undo, retry:
/*GUI*/ if global-beam-me-up then undo, leave.


         run lock_line.

         seq__dec01 = seq_priority.

         update
            seq_qty_req
            seq__dec01
            go-on ("F5" "CTRL-D")
         with frame c.

         if seq__dec01 = 0 then do:
            /* Must enter a sequence number */
            {pxmsg.i &MSGNUM=8531 &ERRORLEVEL=3}
            next-prompt seq__dec01.
            undo, retry.
         end.

         if truncate (seq_qty_req / multiple,0) * multiple <> seq_qty_req
            and  multiple <> 0
         then do:
            {pxmsg.i &MSGNUM=318 &ERRORLEVEL=3}
            /*Sched qty not a multiple of Multiple*/
            next-prompt seq_qty_req.
            undo, retry.
         end.

         ststatus = stline[2].
         status input ststatus.

         if lastkey = keycode("F5") or lastkey = keycode("CTRL-D")
         then do:
            /* MARK OR UNMARK THE RECORDS FOR DELETION .          */
            /* CONFIRM DELETION BEFORE RECALCULATION              */
            seq__log01 = not seq__log01 .
            display seq__log01 with frame c.
            next scrolloop.
 /*ts01*/          due_date = seq_due_date .
         end.

         if seq__dec01 entered then do:

           /*ts01           if can-find (seq_mstr  where seq_mstr.seq_domain = global_domain
             and  seq_line = prline
                                    and seq_site = site
                                    and seq_priority = input seq__dec01) */
/*ts01 */          if can-find (seq_mstr  where seq_mstr.seq_domain = global_domain
             and  seq_line = prline
                                    and seq_site = site and seq_due_date = due_date 
                                    and seq_priority = input seq__dec01) 
            then do:
               /* Sequence number already exists */
               {pxmsg.i &MSGNUM=8520 &ERRORLEVEL=3}
               undo, retry.
            end.

            if truncate (seq_qty_req / multiple,0) * multiple <> seq_qty_req
               and  multiple <> 0
            then do:
               /* Schedule qty not a multiple */
               {pxmsg.i &MSGNUM=318 &ERRORLEVEL=3}
               next-prompt seq_qty_req.
               undo, retry.
            end.

            sw_reset = true.

         end.

         assign
            seq_priority = seq__dec01
            seq_qty_req
            seq__log01 = false
            seq__dec01 = 0.

         display
            seq__log01
            seq_priority
            "" @ seq__dec01
         with frame c.

         next scrolloop.

      end. /* modify mode */

      else
      if keyfunction(lastkey) = "insert-mode"
      or (keyfunction(lastkey) = "return" and recno = ?)
      then do transaction:
/*GUI*/ if global-beam-me-up then undo, leave.


         run lock_line.

         /* PREVIOUS FIND LAST LOGIC WAS FAILING IN ORACLE ENVIRONMENTS */
        /*ts01***del****************************************
         seqpriority = 1.
         for each seq_mstr no-lock  where seq_mstr.seq_domain = global_domain
          and  seq_site = site
            and seq_line = prline
            and seq_priority > 0
         by seq_site descending
         by seq_line descending
         by seq_priority descending:
            seqpriority = truncate(seq_priority + 1, 0).
            leave.
         end.
*ts01**del********************************************/
/*ts01*****add begin**********************************/
for each seq_mstr  where seq_mstr.seq_domain = global_domain
          and  seq_site = site
            and seq_line = prline
	    and seq_due_date >= begin_date
            and seq_priority > 0
	   
         by seq_site  descending
         by seq_line  descending
	 by seq_due_date descending
         by seq_priority descending:
           seq_priority  = 500 + seq_priority .
         end.

for each seq_mstr  where seq_mstr.seq_domain = global_domain
          and  seq_site = site
            and seq_line = prline
	    and seq_due_date >= begin_date
            and seq_priority > 0
       use-index seq_site
       break  by seq_site   
         by seq_line   
	 by seq_due_date  
         by seq_priority  :
	 if first-of(seq_due_date)  then ii = 0.
	 ii = ii + 1.
           seq_priority  = ii .
         end.
      seqpriority = 1.
         for each seq_mstr no-lock  where seq_mstr.seq_domain = global_domain
          and  seq_site = site
            and seq_line = prline
	    and seq_due_date >= begin_date
            and seq_priority > 0
         by seq_site descending
         by seq_line descending
	 by seq_due_date descending
         by seq_priority descending:
            seqpriority = truncate(seq_priority + 1, 0).
            leave.
         end.
/*ts01*****add begin**********************************/

         do on error undo, retry:
/*GUI*/ if global-beam-me-up then undo, leave.


            prompt-for
               seq_priority validate (true,"") /* Validation makes status line */
            with frame c
            editing: /* active in scrolling window   */

               {mfnp06.i seq_mstr seq_sequence
                  " seq_mstr.seq_domain = global_domain and seq_site  = site
                   and seq_line = prline"
                  seq_priority seq_priority
                  seq_priority seq_priority}

               if recno <> ? then do:
                  display
                     seq_priority
                     /*SS - 111011.1 B*/
                     seq__chr01
                     /*SS - 111011.1 E*/
                     seq_part
                     seq_qty_req
                     seq__log01
                     seq_due_date
                  with frame c.
               end.

            end. /* editing */

            if input seq_priority = 0 then do:
               {pxmsg.i &MSGNUM=8531 &ERRORLEVEL=3}
               next-prompt seq_priority with frame c.
               undo, retry.
            end.
         end.
/*GUI*/ if global-beam-me-up then undo, leave.
 /* do on error */

         do:

/*ts01            find seq_mstr  where seq_mstr.seq_domain = global_domain and
             seq_line = prline
               and seq_site = site
               and seq_priority = input seq_priority no-error. */
/*ts01*/           find seq_mstr  where seq_mstr.seq_domain = global_domain and
             seq_line = prline
               and seq_site = site
               and seq_priority = input seq_priority and (seq_due_date >= begin_date  or seq_due_date = input seq_due_date) no-error.

            if available seq_mstr then do:

               display
                  /*SS - 111011.1 B*/
                  seq__chr01
                  /*SS - 111011.1 E*/
                  seq_part
                  seq_qty_req
                  seq_due_date
               with frame c.

               ststatus = stline[2].
               status input ststatus.

               seq__dec01 = seq_priority.

               update
                  seq_qty_req
                  seq__dec01
                  go-on ("F5" "CTRL-D")
               with frame c.

               if lastkey = keycode("F5")
               or lastkey = keycode("CTRL-D")
               then do:
                  /* MARK OR UNMARK THE RECORDS FOR DELETION */
                  /* CONFIRM DELETION BEFORE RECALCULATION   */
                  seq__log01 = not seq__log01 .
                  display seq__log01 with frame c.
                  next scrolloop.
               end.

               if truncate (seq_qty_req / multiple,0) * multiple <> seq_qty_req
                  and  multiple <> 0
               then do:
                  {pxmsg.i &MSGNUM=318 &ERRORLEVEL=3}
                  /*Sched qty not a multiple*/
                  next-prompt seq_qty_req.
                  undo, retry.
               end.

               if seq__dec01 entered then do:
                  if can-find (seq_mstr  where seq_mstr.seq_domain =
                   global_domain and  seq_line = prline
                                          and seq_site = site
                                          and seq_priority = input seq__dec01)
                  then do:
                     {pxmsg.i &MSGNUM=8520 &ERRORLEVEL=3}
                     undo, retry.
                  end.
               end.
               sw_reset = true.

               assign
                  seq_priority = seq__dec01
                  seq_qty_req
                  seq__log01 = false
                  seq__dec01 = 0.

               display
                  seq__log01
                  seq_priority "" @ seq__dec01
               with frame c.

               next scrolloop.

            end.

            else do: /* new records */

               do on error undo, retry:
/*GUI*/ if global-beam-me-up then undo, leave.

                 /*SS - 111011.1 B*/
                                   
                  prompt-for seq__chr01 with frame c
                  editing:

                     {mfnp05.i code_mstr code_fldval
                        " code_mstr.code_domain = global_domain and code_fldname  = ""seq__chr01"" " code_value
                        "input seq__chr01"}

                      if recno <> ? THEN DO:
                          DISPLAY
                             CODE_value @ seq__chr01 with frame c.
                          message CODE_cmmt.
                      END.
                          

                     status input.
                     readkey.
                     apply lastkey.
                  end. /* editing */

                  IF NOT can-find(FIRST code_mstr WHERE code_domain = global_domain AND code_fldname = "seq__chr01" AND code_value = INPUT seq__chr01)  THEN DO:

                      MESSAGE "班次不存在,请重新输入" VIEW-AS ALERT-BOX.
                      next-prompt seq__chr01 with frame c.
                      undo, retry.
                  END.

                 /*SS - 111011.1 E*/

                  prompt-for seq_part with frame c
                  editing:
                     if frame-field = "seq_part" then do:
                        /* FIND/PREVIOUS */
                        {mfnp05.i lnd_det lnd_line
                           " lnd_det.lnd_domain = global_domain and lnd_site  =
                            site and lnd_line = prline"
                           lnd_part "input seq_part"}
  /*ts01                      if recno <> ? then
                           
                          display lnd_part @ seq_part with frame c. */
  /*ts01*/                        if recno <> ? then do:
                           display lnd_part @ seq_part with frame c.
  			   find first pt_mstr no-lock  where pt_domain = global_domain 
			              and pt_part = input seq_part no-error.
		           if available pt_mstr then message pt_desc1 pt_desc2 .
/*ts01*/                 end.
   

                        recno = ?.
                     end. /* frame-field */
                     else do:
                        readkey.
                        apply lastkey.
                     end.
                  end. /* editing */

                  find pt_mstr  where pt_mstr.pt_domain = global_domain and
                   pt_part = input seq_part
                  no-lock no-error.

                  ptstatus = "".
                  if available pt_mstr then ptstatus = pt_status.
                  substring(ptstatus,9,1) = "#".

                  if can-find(isd_det  where isd_det.isd_domain = global_domain
                   and  isd_status = ptstatus
                                        and isd_tr_type = "ADD-RE")
                  then do:
                     {pxmsg.i &MSGNUM=358 &ERRORLEVEL=3 &MSGARG1=pt_status}
                     next-prompt seq_part with frame c.
                     undo, retry.
                  end.

                  find first lnd_det no-lock  where lnd_det.lnd_domain =
                   global_domain and  lnd_line = prline
                     and lnd_site = site
                     and lnd_part = input seq_part no-error.
                  if not available lnd_det then do:
                     {pxmsg.i &MSGNUM=8527 &ERRORLEVEL=3}
                     next-prompt seq_part with frame c.
                     undo, retry.
                  end.

                  /* FIND LAST LOGIC APPEARS TO FAIL IN ORACLE ENVIRONMENTS */
                  do for s1:

                     find first s1 no-lock  where s1.seq_domain = global_domain
                      and
                                s1.seq_site = site
                            and s1.seq_line = prline
                            and s1.seq_priority < input seq_mstr.seq_priority
                     no-error.

                     if not available s1 then
                     display
                        today @ seq_mstr.seq_due_date
                     with frame c.

                     else do:

                        for each s1 no-lock  where s1.seq_domain =
                         global_domain and
                                 s1.seq_site = site and
                                 s1.seq_line = prline and
                                 s1.seq_priority < input seq_mstr.seq_priority
                        by s1.seq_site descending
                        by s1.seq_line descending
                        by s1.seq_priority descending:
                           display
                              s1.seq_due_date @ seq_mstr.seq_due_date
                           with frame c.
                           leave.
                        end.

                     end.

                  end.

                  del-yn = no.

                  find first wo_mstr no-lock
                        where wo_mstr.wo_domain = global_domain and  wo_part =
                         input seq_part
                         and wo_joint_type = ""
                         and wo_status = "P"
                         and wo_site = site
                  no-error.

                  if available wo_mstr then do:

                     part = input seq_part.

                     /* DROP IN PLANNED ORDERS */
                     {gprun.i ""resqwbd.p""}
/*GUI*/ if global-beam-me-up then undo, leave.


                     display
                        qtyreq @ seq_qty_req
                     with frame c.

                     prompt-for
                        seq_qty_req
                        seq_due_date
                     with frame c.

                     qtyreq = input seq_qty_req.
                  end.

                  else do:
                     /* No planned orders exist for this item */
                     {pxmsg.i &MSGNUM=8530 &ERRORLEVEL=1}
                     prompt-for
                        seq_qty_req
                        seq_due_date
                     with frame c.
                     qtyreq = input seq_qty_req.
                  end.

                  if input seq_due_date < lnd_start then do:
                     /* Item not defined on this production line */
                     {pxmsg.i &MSGNUM=8527 &ERRORLEVEL=3}
                     next-prompt seq_due_date with frame c.
                     undo, retry.
                  end.

                  if input seq_due_date < begin_date then
                     begin_date = input seq_due_date.

                  if input seq_due_date = ? then
                     begin_date = today.

                  /* Insertion of sequence records */
                  /* Recalculating production line sequence */
                  {pxmsg.i &MSGNUM=8528 &ERRORLEVEL=1}
/*ts01*/   if input seq_due_date = ? then do:
                    message "生产截止日期不允许为空" view-as alert-box.
		     next-prompt seq_due_date with frame c.
                     undo, retry.
/*ts01*/     end.

                  assign
                     part = input seq_part
                     old_date = input seq_due_date
                     old_sequence = input seq_priority.

                  if input seq_due_date = ? then
                     old_date = today.

                  /* First create records that are inserted */ do:
                  create seq_mstr. seq_mstr.seq_domain = global_domain. end.
                  assign
                     seq_site = site
                     seq_line = prline
                     seq_part = input seq_part
                     seq_qty_req = input seq_qty_req
                     seq_priority = input seq_priority
                     /*SS 111011.1 B*/
                     seq__chr01 = INPUT seq__chr01
                     /*SS 111011.1 E*/
                      .

/*ts01*/          assign seq_due_date = input seq_due_date.

                  if not can-find (seq_mstr  where seq_mstr.seq_domain =
                   global_domain and  seq_site = site
                                              and seq_line = prline
                                              and seq_part = part
					      and seq_priority = old_priority    /*ts01*/
                                              and seq_due_date = old_date)
                  then
                     assign seq_due_date = input seq_due_date.

                  if not can-find (seq_mstr  where seq_mstr.seq_domain =
                   global_domain and  seq_site = site
                                              and seq_line = prline
                                              and seq_part = part
					      and seq_priority = old_priority    /*ts01*/
                                              and seq_due_date = today)
                  then
                     if seq_due_date = ? then seq_due_date = today.

                  if recid(seq_mstr) = -1 then .

                  run validate-concurrency.

                  if not bad_sched_qty
                  then do:

                     assign
                        lundo-input2 = no
                        undo-input1 = yes.

/*ts01*********************************
 /*ts01*/    message "是否重新排程?"  
             VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO-CANCEL
                    TITLE "" UPDATE yn1 AS LOGICAL.

	      if yn1 then do:
 
   /*ts01*                 {gprun.i ""resqwba.p"" "(input yes)"} *******/
    /*ts01*/                 {gprun.i ""xxresqwba.p"" "(input yes)"}  
  /*GUI*/ if global-beam-me-up then undo, leave.


                     if undo-input1 then undo, leave.

                     if lundo-input2 then
                        undo mainloop, retry mainloop.
/*ts01*/     end.

*ts01*******************************************************/

                     sw_reset = yes.
                     hide message no-pause.

                  end.

                  else do:
                     /*Schedule changed by another user*/
                     {pxmsg.i &MSGNUM=321 &ERRORLEVEL=2}
                     pause 3.
                  end.

               end.
/*GUI*/ if global-beam-me-up then undo, leave.
 /* else do */

            end. /* do on error, undo retry */

         end. /* transaction */

      end. /* insert-mode */

      else if
      /*V8+*/
           
      keyfunction(lastkey) = "delete-character"
        
      or lastkey = keycode("F5") then
      do transaction:

         run lock_line.

         seq__log01 = not seq__log01.

         display seq__log01 with frame c.

         next scrolloop.
      end.

      else
      if keyfunction(lastkey) = "go"
      then do:

         if can-find(first seq_mstr  where seq_mstr.seq_domain = global_domain
          and  seq_site = site
                                      and seq_line = prline
                                      and seq_due_date >= begin_date
                                      and seq__log01 )
         then do:

            assign del-yn = no .

            /* RECORD MARKED FOR DELETION WILL BE DELETED, CONTINUE ?   */
            {pxmsg.i &MSGNUM=2941 &ERRORLEVEL=1 &CONFIRM=del-yn}

            if del-yn then do:
               for each seq_mstr exclusive-lock  where seq_mstr.seq_domain =
                global_domain and
                     seq_site = site and seq_line = prline
                     and seq_due_date >= begin_date and seq__log01:
                  delete seq_mstr.
               end.
            end. /* IF DEL-YN THEN */

         end. /* IF CAN-FIND(FIRST SEQ_MSTR */

         do transaction:
/*GUI*/ if global-beam-me-up then undo, leave.

/*ts01*****add begin**********************************/

for each seq_mstr  where seq_mstr.seq_domain = global_domain
          and  seq_site = site
            and seq_line = prline
	    and seq_due_date >= begin_date
            and seq_priority > 0
	   
         by seq_site  descending
         by seq_line  descending
	 by seq_due_date descending
         by seq_priority descending:
           seq_priority  = 500 + seq_priority .
         end.

for each seq_mstr  where seq_mstr.seq_domain = global_domain
          and  seq_site = site
            and seq_line = prline
	    and seq_due_date >= begin_date
            and seq_priority > 0
       use-index seq_site
      break   by seq_site   
         by seq_line   
	 by seq_due_date  
         by seq_priority  :
	 if first-of(seq_due_date)  then ii = 0.
	 ii = ii + 1.
           seq_priority  = ii .
         end.
      
/*ts01*****add begin**********************************/

            run lock_line.
            run validate-concurrency.



            if not bad_sched_qty
            then do:

               /* Recalculating production line sequence */
               {pxmsg.i &MSGNUM=8528 &ERRORLEVEL=1}

               lundo-input2 = no.

  /*ts01*/    message "是否重新排程?"  
             VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO-CANCEL
                    TITLE "" UPDATE yn2 AS LOGICAL.

	      if yn2 then do:
	        
 /*ts01*                 {gprun.i ""resqwba.p"" "(input yes)"} *******/
 /*ts01*/                 {gprun.i ""xxresqwba.p"" "(input yes)"}  
 
/*GUI*/ if global-beam-me-up then undo, leave.


               if lundo-input2 then
                  undo mainloop, retry mainloop.

               sw_reset = yes.
               hide message no-pause.
/*ts01*/      end.
            end.

            else do:
               /*Schedule changed by another user*/
               {pxmsg.i &MSGNUM=321 &ERRORLEVEL=2}
               pause 3.
            end.

         end.
/*GUI*/ if global-beam-me-up then undo, leave.
 /* DO TRANSACTION ... */

      end.

   end.
/*GUI*/ if global-beam-me-up then undo, leave.
 /* scrolloop */

   run clear-leftover-deletions.

end.
/*GUI*/ if global-beam-me-up then undo, leave.
 /* repeat mainloop */

/* * * * * INTERNAL PROCEDURES * * * * * * * * * * * * * * * * * * * * */

PROCEDURE validate-concurrency:
   /* ANYBODY ELSEALTER SCHEDULE?                          */
   /* NOTE - THIS CODE WAS MOVED DUE TO AN ACTION SEGEMENT */
   /*        TO LARGE PROBLEM.  THIS CODE ONLY WORKS UNDER */
   /*        THE CASE WHERE BOTH USERS HAVE DIFFERENT      */
   /*        MULTIPLES, AND MAY ONLY DISPLAY TO ONE OF THE */
   /*        USERS.  THIS WILL NOT CATCH ALL CASES!        */
   bad_sched_qty = false.

   if multiple <> 0 then do:

      for each seq_mstr
          where seq_mstr.seq_domain = global_domain and  seq_site = site
           and seq_line = prline
      no-lock:
         if truncate((seq_qty_req / multiple),0) * multiple <> seq_qty_req
         then do:
            bad_sched_qty = true.
            leave.
         end.
      end.  /* for each seq_mstr */

   end.  /* if multiple <> 0 */

END PROCEDURE.   /* validate-concurrency */

PROCEDURE clear-leftover-deletions:

   do transaction:

      run lock_line.

      /* Clear out any leftover deletions that were not processed */
      for each seq_mstr  where seq_mstr.seq_domain = global_domain and
               seq_site = site and seq_line = prline
           and seq_due_date >= begin_date and
               seq__log01:
         seq__log01 = no.
      end.

   end.

END PROCEDURE. /* clear-leftover-deletions */

/* THIS PROCEDURE HAS BEEN INTRODUCED SO AS TO BE COMPATIBLE WITH ORACLE*/
/* THIS IS BECAUSE ORACLE DOWNGRADES AN EXCLUSIVE-LOCK TO A NO-LOCK AT  */
/* THE END OF THE TRANSACTION. THEREFORE IT IS NECESSARY TO EXCLUSIVELY */
/* RE-LOCK THE ln_mstr FILE AT THE START OF EVERY TRANSACTION IN THE    */
/* PROGRAM TO AVOID CONCURRENCY PROBLEMS.                               */
/* THE ln_mstr IS BEING LOCKED EXCLUSIVELY TO PREVENT CONCURRENT ACCESS */
/* AND NOT BECAUSE ANY FIELDS ARE BEING MODIFIED.                       */

PROCEDURE lock_line:

   do transaction:
      find ln_mstr  where ln_mstr.ln_domain = global_domain and  ln_line =
       prline and ln_site = site
      exclusive-lock no-error.
   end.

END PROCEDURE.
