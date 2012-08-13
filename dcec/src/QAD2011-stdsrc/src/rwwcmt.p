/* GUI CONVERTED from rwwcmt.p (converter v1.78) Tue Jun 29 23:49:06 2010 */
/* rwwcmt.p - WORK CENTER MAINTENANCE                                         */
/* Copyright 1986-2010 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* REVISION: 1.0      LAST MODIFIED: 04/06/86   BY: PML       */
/* REVISION: 1.0      LAST MODIFIED: 04/29/86   BY: EMB       */
/* REVISION: 2.0      LAST MODIFIED: 03/12/87   BY: EMB *A41* */
/* REVISION: 4.0      LAST MODIFIED: 02/05/88   BY: RL  *A171**/
/* REVISION: 4.0      LAST MODIFIED: 04/18/88   BY: EMB *A201**/
/* REVISION: 5.0      LAST MODIFIED: 07/05/89   BY: EMB *B169**/
/* REVISION: 6.0      LAST MODIFIED: 05/04/90   BY: RAM *D018**/
/* REVISION: 7.2      LAST MODIFIED: 11/16/92   BY: emb *G322**/
/* REVISION: 7.3      LAST MODIFIED: 02/24/93   BY: sas *G729*/
/* REVISION: 7.3      LAST MODIFIED: 02/01/95   BY: pxd *F0GP*/
/* REVISION: 8.5      LAST MODIFIED: 07/31/96   BY: *J12T* Sue Poland         */
/* REVISION: 8.5      LAST MODIFIED: 01/14/97   BY: *J1FL* Murli Shastri      */
/* REVISION: 7.4      LAST MODIFIED: 01/05/98   BY: *H1HW* Jean Miller        */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane          */
/* REVISION: 8.6E     LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan         */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan         */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane   */
/* REVISION: 9.1      LAST MODIFIED: 05/10/00   BY: *L0XH* Kirti Desai        */
/* REVISION: 9.1      LAST MODIFIED: 07/13/00   BY: *N0F1* Jean Miller        */
/* REVISION: 9.1      LAST MODIFIED: 08/12/00   BY: *N0KP* Mark Brown         */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* Revision: 1.8.1.5      BY: Kirti Desai         DATE: 05/07/01  ECO: *N0YJ* */
/* Revision: 1.8.1.6      BY: Vandna Rohira       DATE: 10/19/01  ECO: *M1NH* */
/* Revision: 1.8.1.7      BY: Anil Sudhakaran     DATE: 11/27/01  ECO: *M1KZ* */
/* Revision: 1.8.1.8      BY: Jean Miller         DATE: 05/15/02  ECO: *P05V* */
/* Revision: 1.8.1.9  BY: Niranjan R. DATE: 05/31/02 ECO: *P04Z* */
/* Revision: 1.8.1.11 BY: Paul Donnelly (SB) DATE: 06/28/03 ECO: *Q00L* */
/* Revision: 1.8.1.12 BY: Avishek Chakraborty DATE: 05/07/09 ECO: *Q2V0* */
/* $Revision: 1.8.1.13 $ BY: Ruchita Shinde DATE: 06/24/10 ECO: *Q45Q* */
/*-Revision end---------------------------------------------------------------*/

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/
/*V8:ConvertMode=Maintenance                                                  */

/* Note: Changes made here may be necessary in fswcmt.p also. */

/* DISPLAY TITLE */
{mfdtitle.i "1+ "}

define variable del-yn like mfc_logical initial no.

/* Variable added to perform delete during CIM.
 * Record is deleted only when the value of this variable
 * Is set to "X" */
define variable batchdelete as character format "x(1)" no-undo.

/* DISPLAY SELECTION FORM */

/*GUI preprocessor Frame A define */
&SCOPED-DEFINE PP_FRAME_NAME A

FORM /*GUI*/ 
   
 RECT-FRAME       AT ROW 1 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1 COLUMN 3 NO-LABEL VIEW-AS TEXT SIZE-PIXELS 1 BY 1
 SKIP(.1)  /*GUI*/
wc_wkctr       colon 30 wc_mch
   wc_desc        colon 30
   skip(1)
   wc_dept        colon 30 dpt_desc no-label
   skip(1)
   wc_queue       colon 30
   wc_wait        colon 30
   wc_mch_op      colon 30
   skip(1)
   wc_setup_men   colon 30                    wc_setup_rte   colon 60
   wc_men_mch     colon 30 label "Run Crew"   wc_lbr_rate    colon 60
   wc_mch_wkctr   colon 30 label "Machine"    wc_bdn_rate    colon 60
   wc_mch_bdn     colon 30                    wc_bdn_pct     colon 60
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

/* DISPLAY */
view frame a.
mainloop:
repeat with frame a:
/*GUI*/ if global-beam-me-up then undo, leave.


   /* Initialize delete flag before each display of frame */
   batchdelete = "".

   ststatus = stline[1].
   status input ststatus.

   prompt-for
      wc_wkctr
      wc_mch
      /* Prompt for the delete variable in the key frame at the
       * End of the key field/s only when batchrun is set to yes */
      batchdelete no-label when (batchrun)
   with no-validate
   editing:

      /* FIND NEXT/PREVIOUS RECORD - STANDARD W/C'S ONLY */
      {mfnp05.i wc_mstr
         wc_wkctr
         " wc_mstr.wc_domain = global_domain and wc_fsm_type  = "" "" "
         wc_wkctr
         "input wc_wkctr"}

      if recno <> ? then do:
         display
            wc_wkctr wc_mch wc_desc wc_dept
            wc_queue wc_wait wc_mch_op
            wc_setup_men wc_men_mch wc_mch_wkctr wc_mch_bdn
            wc_setup_rte wc_lbr_rate wc_bdn_rate wc_bdn_pct.
         find dpt_mstr  where dpt_mstr.dpt_domain = global_domain and  dpt_dept
         = wc_dept no-lock no-error.
         if available dpt_mstr then
            display dpt_desc.
         else
            display " " @ dpt_desc.

      end.    /* if recno <> ? */
   end.    /* prompt-for */

   /* VALIDATE wc_wkctr is NOT BLANK */
   if input wc_wkctr = "" then do:
      {pxmsg.i &MSGNUM=40 &ERRORLEVEL=3} /* BLANK NOT ALLOWED */
      next-prompt wc_wkctr.
      undo, retry.
   end.

   /* ADD/MOD/DELETE  */
find wc_mstr using  wc_wkctr and wc_mch where wc_mstr.wc_domain = global_domain
 exclusive-lock no-error.


   if not available wc_mstr then do:

      /* Adding new record */
      {pxmsg.i &MSGNUM=1 &ERRORLEVEL=1}

      create wc_mstr. wc_mstr.wc_domain = global_domain.
      assign
         wc_wkctr
         wc_mch.
   end.

   else if wc_fsm_type = "FSM" then do:
      {pxmsg.i &MSGNUM=7485 &ERRORLEVEL=2}
      /* THIS IS A SERVICE WORK CENTER */
   end.

   recno = recid(wc_mstr).

   display
      wc_desc wc_dept
      wc_queue wc_wait wc_mch_op
      wc_setup_men wc_men_mch wc_mch_wkctr wc_mch_bdn
      wc_setup_rte wc_lbr_rate wc_bdn_rate wc_bdn_pct.

   find dpt_mstr  where dpt_mstr.dpt_domain = global_domain and  dpt_dept =
   wc_dept no-lock no-error.
   if available dpt_mstr then
      display dpt_desc.
   else
      display " " @ dpt_desc.

   ststatus = stline[2].
   status input ststatus.
   del-yn = no.

   seta:
   do on error undo, retry:
/*GUI*/ if global-beam-me-up then undo, leave.


      assign
         wc_userid   = global_userid
         wc_mod_date = today.

      set wc_desc wc_dept
         wc_queue wc_wait wc_mch_op
         wc_setup_men wc_men_mch wc_mch_wkctr wc_mch_bdn
         wc_setup_rte wc_lbr_rate wc_bdn_rate wc_bdn_pct
      editing:

         if frame-field = "wc_dept" then do:
            /* FIND NEXT/PREVIOUS RECORD */
            {mfnp.i dpt_mstr wc_dept  " dpt_mstr.dpt_domain = global_domain and
            dpt_dept "
               wc_dept dpt_dept dpt_dept}
            if recno <> ? then
               display dpt_dept @ wc_dept dpt_desc.
         end.

         else do:
            ststatus = stline[2].
            status input ststatus.
            readkey.
            apply lastkey.
         end.

         /* DELETE */
         if lastkey = keycode("F5")
         or lastkey = keycode("CTRL-D")
         then do:
            del-yn = yes.
            /* Please confirm delete */
            {pxmsg.i &MSGNUM=11 &ERRORLEVEL=1 &CONFIRM=del-yn}
            if del-yn then leave.
         end.
      end.    /* set ... editing */

      if del-yn
      /* Delete to be executed if batchdelete is set to "x" */
      or input batchdelete = "x":U
      then do:
         if can-find
            (first ro_det  where ro_det.ro_domain = global_domain and  ro_wkctr
            = wc_wkctr and ro_mch = wc_mch)
         then do:
            find first ro_det  where ro_det.ro_domain = global_domain and
            ro_wkctr = wc_wkctr and
                                    ro_mch   = wc_mch
            no-lock.
            /* Delete not allowed, item routing exists */
            {pxmsg.i &MSGNUM=521 &ERRORLEVEL=3 &MSGARG1=ro_routing}
            next mainloop.
         end.

         if can-find
            (first wr_route  where wr_route.wr_domain = global_domain and
            wr_wkctr = wc_wkctr and wr_mch = wc_mch)
         then do:
            find first wr_route  where wr_route.wr_domain = global_domain and
            wr_wkctr = wc_wkctr
                                  and wr_mch = wc_mch
            no-lock.
            /* Delete not allowed, work order exists */
            {pxmsg.i &MSGNUM=522 &ERRORLEVEL=3 &MSGARG1=wr_nbr}
            next mainloop.
         end.

         if can-find (first swc_det  where swc_det.swc_domain = global_domain
         and (  swc_wkctr = wc_wkctr
                                    and   swc_mch   = wc_mch
                                    and ((swc_cat = "1"
                                    and  (swc_set_rate    <> 0 or
                                          swc_run_rate <> 0)) or
                                         (swc_cat = "2"
                                    and  (swc_bdn_rate    <> 0
                                      or  swc_bdn_pct <> 0
                                      or  swc_mch_bdn <> 0)))))
         then do:
            /* Delete not allowed, detail cost records exist */
            {pxmsg.i &MSGNUM=5402 &ERRORLEVEL=3}
            next mainloop.
         end. /* IF CAN-FIND (FIRST swc_det) */

         if can-find
            (first poul_mstr  where poul_mstr.poul_domain = global_domain and
            poul_wkctr = wc_wkctr and poul_mch = wc_mch)
         then do:
            /* DELETE NOT ALLOWED. # EXISTS IN # */
            {pxmsg.i &MSGNUM=904 &ERRORLEVEL=3
                     &MSGARG1=wc_wkctr
                     &MSGARG2=getTermLabel(""WORK_CENTER_LOCATION_DETAIL"",30)}
            next mainloop.
         end.

         for each swc_det  where swc_det.swc_domain = global_domain and
         swc_wkctr = wc_wkctr
                          and   swc_mch   = wc_mch
         exclusive-lock:
            delete swc_det.
         end. /* FOR EACH swc_det */

         delete wc_mstr.
         clear frame a.
/*GUI*/ RECT-FRAME-LABEL:SCREEN-VALUE in frame a = F-a-title.
         del-yn = no.

      end.    /* if del-yn then do */

      else do:

         find dpt_mstr  where dpt_mstr.dpt_domain = global_domain and  dpt_dept
         = wc_dept no-lock no-error.
         if available dpt_mstr then
            display dpt_desc.
         else
            display " " @ dpt_desc.

         if wc_dept <> "" and
            not can-find(first dpt_mstr  where dpt_mstr.dpt_domain =
            global_domain and  dpt_dept = wc_dept)
         then do:
            {pxmsg.i &MSGNUM=532 &ERRORLEVEL=3}
            /* DEPARTMENT DOES NOT EXIST */
            next-prompt wc_dept.
            undo, retry.
         end.

         if wc_mch_op = ?
         then do:
            /* UNKNOWN VALUE (QUESTION MARK) NOT ALLOWED. */
            {pxmsg.i &MSGNUM=1235 &ERRORLEVEL=3}.
            next-prompt wc_mch_op.
            undo,retry.
         end. /*IF wc_mch_op = ?*/
      end.    /* else do, not del-yn, do */

   end.
/*GUI*/ if global-beam-me-up then undo, leave.
    /* seta do on error */

   if available wc_mstr then recno = recid(wc_mstr).

end.
/*GUI*/ if global-beam-me-up then undo, leave.
   /* repeat */

status input.
