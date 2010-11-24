/* ppvpiq.p - VENDOR PART INQUIRY                                             */
/* Copyright 1986-2006 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.5.2.7 $                                                       */
/*                                                                            */
/*V8:ConvertMode=Report                                                       */
/* REVISION: 1.0      LAST MODIFIED: 01/20/86   BY: PML                       */
/* REVISION: 2.0      LAST MODIFIED: 07/15/87   BY: EMB                       */
/* REVISION: 2.1      LAST MODIFIED: 10/16/87   BY: WUG *A94*                 */
/* REVISION: 2.1      LAST MODIFIED: 12/14/87   BY: pml *A108*                */
/* REVISION: 4.0      LAST EDIT:     12/30/87   BY: WUG *A137*                */
/* REVISION: 4.0      LAST MODIFIED: 06/07/88   BY: flm *A268*                */
/* REVISION: 5.0      LAST MODIFIED: 02/03/89   BY: pml *c0028*               */
/* REVISION: 5.0      LAST EDIT:     05/03/89   BY: WUG *B098*                */
/* REVISION: 5.0      LAST MODIFIED: 10/13/92   BY: pma *G179*                */
/* Revision: 7.3      Last edit:     11/19/92   By: jcd *G339*                */
/* REVISION: 7.3      LAST MODIFIED: 10/07/94   BY: jxz *FS19*                */
/* REVISION: 7.4      LAST MODIFIED: 01/14/97   BY: *H0R3* Russ Witt          */
/* REVISION: 8.6      LAST MODIFIED: 11/10/97   BY: bvm *K194*                */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane   */
/* REVISION: 9.1      LAST MODIFIED: 08/13/00   BY: *N0KQ* myb                */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* Revision: 1.5.2.3  BY: Hualin Zhong          DATE: 09/19/01  ECO: *N12H*   */
/* Revision: 1.5.2.5  BY: Paul Donnelly (SB)    DATE: 06/28/03  ECO: *Q00K*   */
/* Revision: 1.5.2.6  BY: Max Iles              DATE: 02/14/05  ECO: *P36M*   */
/* $Revision: 1.5.2.7 $        BY: cnl                   DATE: 03/23/06  ECO: *P4LK*   */
/*-Revision end---------------------------------------------------------------*/

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/* DISPLAY TITLE */
{mfdtitle.i "1+ "}

define variable part like vp_part.
define variable vend like vp_vend.
define variable desc1 like pt_desc1.
define variable vend_part like vp_vend_part.
define new shared variable vppart like vp_part.
define new shared variable vpvend like vp_vend.
define variable xxdesc as character format "x(210)".
define buffer bufvpmstr for vp_mstr.

part = global_part.

form
   part        colon 15  desc1  no-label
   vend        colon 15
   vend_part   colon 15
with frame a side-labels width 80 attr-space.
          

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

{wbrp01.i}

repeat:

   if c-application-mode <> 'web' then
      update part vend vend_part with frame a
   editing:

      if frame-field = "part" then do:
         /* FIND NEXT/PREVIOUS RECORD */
         {mfnp.i vp_mstr part  " vp_mstr.vp_domain = global_domain and vp_part
              "  part vp_part vp_part}

         if recno <> ? then do:
            assign
               part = vp_part
               vend = vp_vend
               vend_part = vp_vend_part
               desc1 = "".
            find pt_mstr  where pt_mstr.pt_domain = global_domain and  pt_part
               = part no-lock no-error.
            if available pt_mstr then
               desc1 = pt_desc1.
            display
               part
               desc1
               vend
               vend_part
            with frame a.
         end.
         assign
            vppart = input part.
      end.
      else if frame-field = "vend" then do:
         /*FIND NEXT/PREVIOUS RECORD */
         {mfnp05.i vp_mstr vp_partvend " vp_mstr.vp_domain = global_domain and
              vp_part  = input part"
            vp_vend_part "input vend_part"}
         assign
            vpvend = input vend.
      end.
      else do:
         status input.
         readkey.
         apply lastkey.
      end.
   end.

   {wbrp06.i &command = update &fields = "  part vend vend_part" &frm = "a"}

   if (c-application-mode <> 'web') or
      (c-application-mode = 'web' and
      (c-web-request begins 'data')) then do:

      desc1 = "".
      find pt_mstr  where pt_mstr.pt_domain = global_domain and  pt_part = part
      no-lock no-error.
      if available pt_mstr then
         desc1 = pt_desc1.
      display part desc1 with frame a.

      hide frame b.
      hide frame c.
      hide frame d.
      hide frame e.

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

   if dev <> "terminal" then display part vend with frame a.

   if part <> "" then do:
      for each vp_mstr  where vp_mstr.vp_domain = global_domain and (  vp_part
            = part
            and (vp_vend = vend or vend = "" )
            and (vp_vend_part = vend_part or vend_part = "" )
            ) no-lock by vp_part by vp_vend with frame b width 80 no-attr-space:
         /* SET EXTERNAL LABELS */
         setFrameLabels(frame b:handle).
         {mfrpchk.i}
         find first pt_mstr where pt_domain = global_domain and pt_part = vp_mstr.vp_part no-lock no-error.
         find first cd_det where cd_domain = global_domain and cd_ref = vp_mstr.vp_part and cd_type = "SC" and cd_lang = "CH" no-lock no-error.
         find first bufvpmstr where bufvpmstr.vp_domain = global_domain and bufvpmstr.vp_part = vp_mstr.vp_part and bufvpmstr.vp_vend = "" no-lock no-error.
         if avail cd_det then
         	xxdesc = cd_cmmt[1] + cd_cmmt[2] + cd_cmmt[3].
         display
            vp_mstr.vp_vend
            vp_mstr.vp_part
            bufvpmstr.vp_vend_part when avail bufvpmstr
            vp_mstr.vp_tp_pct
            pt_desc1
            pt_buyer
            xxdesc column-label "×´Ì¬ÃèÊö" when avail cd_det
         with width 400.
         if not scrollonly and
            not spooler and
            (path = "terminal") then do:
            {gpwait.i &INSIDELOOP=yes &FRAMENAME=b}
         end.
         /*
         if vp_mfgr <> "" or vp_mfgr_part <> "" then do:
            down 1.
            display vp_mfgr @ vp_vend vp_mfgr_part @ vp_vend_part.
         end.
         */
      end.
      if not scrollonly and
         not spooler and
         (path = "terminal") then do:
         {gpwait.i &OUTSIDELOOP=yes}
      end.
   end.
   else if vend <> "" then do:
      for each vp_mstr  where vp_mstr.vp_domain = global_domain and (  vp_vend
            = vend
            and (vp_vend_part = vend_part or vend_part = "" )
            ) no-lock by vp_vend by vp_part with frame c width 80 no-attr-space:
         /* SET EXTERNAL LABELS */
         setFrameLabels(frame c:handle).
         {mfrpchk.i}
         
         find first pt_mstr where pt_domain = global_domain and pt_part = vp_part no-lock no-error.
         find first cd_det where cd_domain = global_domain and  cd_ref = vp_mstr.vp_part and cd_type = "SC" and cd_lang = "CH" no-lock no-error.
         find first bufvpmstr where bufvpmstr.vp_domain = global_domain and bufvpmstr.vp_part = vp_mstr.vp_part and bufvpmstr.vp_vend = "" no-lock no-error.
         if avail cd_det then
         	xxdesc = cd_cmmt[1] + cd_cmmt[2] + cd_cmmt[3].
         display
            vp_mstr.vp_vend
            vp_mstr.vp_part
            bufvpmstr.vp_vend_part when avail bufvpmstr
            vp_mstr.vp_tp_pct
            pt_desc1
            pt_buyer
            xxdesc column-label "×´Ì¬ÃèÊö" 
         with width 400.
         
         if not scrollonly and
            not spooler and
            (path = "terminal") then do:
            {gpwait.i &INSIDELOOP=yes &FRAMENAME=c}
         end.
         /*
         if vp_mfgr <> "" or vp_mfgr_part <> "" then do:
            down 1.
            display
               vp_mfgr @ vp_part
               vp_mfgr_part @ vp_vend_part.
         end.
         */
      end.
      if not scrollonly and
         not spooler and
         (path = "terminal") then do:
         {gpwait.i &OUTSIDELOOP=yes}
      end.
   end.
   else if vend_part <> "" then do:
      for each vp_mstr  where vp_mstr.vp_domain = global_domain and
            vp_mstr.vp_vend_part = vend_part
         no-lock by vp_part with frame d width 80 no-attr-space:
         /* SET EXTERNAL LABELS */
         setFrameLabels(frame d:handle).
         {mfrpchk.i}
         
         find first pt_mstr where pt_domain = global_domain and pt_part = vp_mstr.vp_part no-lock no-error.
         find first cd_det where cd_domain = global_domain and cd_ref = vp_mstr.vp_part and cd_type = "SC" and cd_lang = "CH" no-lock no-error.
         find first bufvpmstr where bufvpmstr.vp_domain = global_domain and bufvpmstr.vp_part = vp_mstr.vp_part and bufvpmstr.vp_vend = "" no-lock no-error.
         if avail cd_det then
         	xxdesc = cd_cmmt[1] + cd_cmmt[2] + cd_cmmt[3].
         display
            vp_mstr.vp_vend
            vp_mstr.vp_part
            bufvpmstr.vp_vend_part when avail bufvpmstr
            vp_mstr.vp_tp_pct
            pt_desc1
            pt_buyer
            xxdesc column-label "×´Ì¬ÃèÊö" when avail cd_det
         with width 400.
         
         if not scrollonly and
            not spooler and
            (path = "terminal") then do:
            {gpwait.i &INSIDELOOP=yes &FRAMENAME=d}
         end.
         /*
         if vp_mfgr <> "" or vp_mfgr_part <> "" then do:
            down 1.
            display vp_mfgr @ vp_vend vp_mfgr_part @ vp_part.
         end.
         */
      end.
      if not scrollonly and
         not spooler and
         (path = "terminal") then do:
         {gpwait.i &OUTSIDELOOP=yes}
      end.
   end.
   else do:

      for each vp_mstr  where vp_mstr.vp_domain = global_domain and  vp_mstr.vp_part >=
            "" and vp_mstr.vp_vend >= ""
            and vp_mstr.vp_vend_part >= ""
         no-lock by vp_mstr.vp_part by vp_mstr.vp_vend with frame e width 80 no-attr-space:

         /* SET EXTERNAL LABELS */
         setFrameLabels(frame e:handle).
         {mfrpchk.i}
         
         find first pt_mstr where pt_domain = global_domain and pt_part = vp_mstr.vp_part no-lock no-error.
         find first cd_det where cd_domain = global_domain and cd_ref = vp_mstr.vp_part and cd_type = "SC" and cd_lang = "CH" no-lock no-error.
         find first bufvpmstr where bufvpmstr.vp_domain = global_domain and bufvpmstr.vp_part = vp_mstr.vp_part and bufvpmstr.vp_vend = "" no-lock no-error.
         if avail cd_det then
         	xxdesc = cd_cmmt[1] + cd_cmmt[2] + cd_cmmt[3].
         display
            vp_mstr.vp_vend
            vp_mstr.vp_part
            bufvpmstr.vp_vend_part when avail bufvpmstr
            vp_mstr.vp_tp_pct
            pt_desc1
            pt_buyer
            xxdesc column-label "×´Ì¬ÃèÊö" 
         with width 400.
         
         if not scrollonly and
            not spooler and
            (path = "terminal") then do:
            {gpwait.i &INSIDELOOP=yes &FRAMENAME=e}
         end.
         /*
         if vp_mfgr <> "" or vp_mfgr_part <> "" then do:
            down 1.
            display
               vp_mfgr @ vp_vend
               vp_mfgr_part @ vp_part.
         end.
         */
      end.
      if not scrollonly and
         not spooler and
         (path = "terminal") then do:
         {gpwait.i &OUTSIDELOOP=yes}
      end.
   end.

   {mfreset.i}
   {pxmsg.i &MSGNUM=8 &ERRORLEVEL=1} /* List complete */
end.
global_part = part.

{wbrp04.i &frame-spec = a}
