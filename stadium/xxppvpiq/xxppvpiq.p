/* xxppvpiq.p - VENDOR PART INQUIRY                                       */
/* Copyright 1986-2001 QAD Inc., Carpinteria, CA, USA.                  */
/* All rights reserved worldwide.  This is an unpublished work.         */
/* web convert ppvpiq.p (converter v1.00) Fri Oct 10 13:57:54 1997 */
/* web tag in ppvpiq.p (converter v1.00) Mon Oct 06 14:18:32 1997 */
/*F0PN*/ /*K194*/ /*                                                    */
/*V8:ConvertMode=Report                                        */
/* REVISION: 1.0      LAST MODIFIED: 01/20/86   BY: PML                 */
/* REVISION: 2.0      LAST MODIFIED: 07/15/87   BY: EMB                 */
/* REVISION: 2.1      LAST MODIFIED: 10/16/87   BY: WUG *A94*           */
/* REVISION: 2.1      LAST MODIFIED: 12/14/87   BY: pml *A108*          */
/* REVISION: 4.0      LAST EDIT:     12/30/87   BY: WUG *A137*          */
/* REVISION: 4.0      LAST MODIFIED: 06/07/88   BY: flm *A268*          */
/* REVISION: 5.0      LAST MODIFIED: 02/03/89   BY: pml *c0028*         */
/* REVISION: 5.0      LAST EDIT:     05/03/89   BY: WUG *B098*          */
/* REVISION: 5.0      LAST MODIFIED: 10/13/92   BY: pma *G179*          */
/* Revision: 7.3        Last edit: 11/19/92             By: jcd *G339*  */
/* REVISION: 7.3      LAST MODIFIED: 10/07/94   BY: jxz *FS19*          */
/* REVISION: 7.4      LAST MODIFIED: 01/14/97   BY: *H0R3* Russ Witt    */
/* REVISION: 8.6      LAST MODIFIED: 11/10/97   BY: bvm *K194*          */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane */
/* REVISION: 9.1      LAST MODIFIED: 08/13/00   BY: *N0KQ* myb              */
/* REVISION: 9.1      LAST MODIFIED: 09/17/01   BY: *N12H* Hualin Zhong */

/* DISPLAY TITLE */
{mfdtitle.i "120912.1"}

define variable part like vp_part.
define variable vend like vp_vend.
define variable desc1 like pt_desc1.
define variable vend_part like vp_vend_part.
/*FS19*/ define new shared variable vppart like vp_part.
/*FS19*/ define new shared variable vpvend like vp_vend.

part = global_part.

/*G179  form                                           */
/*G179     part                                        */
/*G179     desc1          no-label format "x(16)"      */
/*G179     vend                                        */
/*G179     vend_part                                   */
/*G179  with frame a no-underline width 80 attr-space. */

/*G179*/ form
/*G179*/    part        colon 15  desc1  no-label
/*G179*/    vend        colon 15
/*G179*/    vend_part   colon 15
/*G179*/ with frame a side-labels width 80 attr-space.

         /* SET EXTERNAL LABELS */
         setFrameLabels(frame a:handle).

/*K194*/ {wbrp01.i}

         repeat:

/*K194*/ if c-application-mode <> 'web' then
           update part vend vend_part with frame a editing:

      if frame-field = "part" then do:
         /* FIND NEXT/PREVIOUS RECORD */
         {mfnp.i vp_mstr part vp_part part vp_part vp_part}

         if recno <> ? then do:
/*N12H*/    assign
               part = vp_part
               vend = vp_vend
               vend_part = vp_vend_part
               desc1 = "".
            find pt_mstr where pt_part = part no-lock no-error.
            if available pt_mstr then desc1 = pt_desc1.
            display part desc1 vend vend_part with frame a.
         end.
/*FS19*/ assign vppart = input part.
      end.
/*FS19*/ else if frame-field = "vend" then do:
/*FS19*/   /*FIND NEXT/PREVIOUS RECORD */
/*FS19*/   {mfnp05.i vp_mstr vp_partvend "vp_part = input part"
                     vp_vend_part "input vend_part"}
/*FS19*/   assign vpvend = input vend.
/*FS19*/ end.
      else do:
         status input.
         readkey.
         apply lastkey.
      end.
   end.

/*K194*/ {wbrp06.i &command = update &fields = "  part vend vend_part" &frm = "a"}

/*K194*/ if (c-application-mode <> 'web') or
/*K194*/ (c-application-mode = 'web' and
/*K194*/ (c-web-request begins 'data')) then do:

   desc1 = "".
   find pt_mstr where pt_part = part no-lock no-error.
   if available pt_mstr then desc1 = pt_desc1.
   display part desc1 with frame a.

   hide frame b.
   hide frame c.
   hide frame d.
   hide frame e.

/*K194*/ end.

   /* SELECT PRINTER */
   {mfselprt.i "terminal" 80}

/*N12H*   if dev <> "terminal" then display part vend. */
/*N12H*/ if dev <> "terminal" then display part vend with frame a.

   if part <> "" then
   for each vp_mstr where vp_part = part
      and (vp_vend = vend or vend = "" )
      and (vp_vend_part = vend_part or vend_part = "" )
      no-lock by vp_part by vp_vend with frame b width 80 no-attr-space:
                                /* SET EXTERNAL LABELS */
                                setFrameLabels(frame b:handle).
                                {mfrpchk.i}                     /*G339*/
      display
      vp_vend
      vp_vend_part
      vp_um vp_vend_lead  vp_q_price vp_curr
/*G179 vp_q_qty  */
      vp_pr_list.
      if vp_mfgr <> "" or vp_mfgr_part <> "" then do:
         down 1.
         put unformat vp_mfgr at 1 " " vp_mfgr_part.
         find first ad_mstr no-lock where ad_addr = vp_mfgr
                and ad_type = "supplier" no-error.
         if available ad_mstr then do:
              put unformat ad_name at 41.
         end.
         put skip.
      end.
   end.

   else if vend <> "" then
   for each vp_mstr where vp_vend = vend
      and (vp_vend_part = vend_part or vend_part = "" )
      no-lock by vp_vend by vp_part with frame c width 80 no-attr-space:
                                /* SET EXTERNAL LABELS */
                                setFrameLabels(frame c:handle).
                                {mfrpchk.i}                     /*G339*/
      display
      vp_part
      vp_vend_part
      vp_um vp_vend_lead  vp_q_price vp_curr.
      if vp_mfgr <> "" or vp_mfgr_part <> "" then do:
         down 1.
         put unformat vp_mfgr at 1 " " vp_mfgr_part.
         find first ad_mstr no-lock where ad_addr = vp_mfgr
                and ad_type = "supplier" no-error.
         if available ad_mstr then do:
              put unformat ad_name at 41.
         end.
         put skip.
      end.
   end.

   else if vend_part <> "" then
   for each vp_mstr where vp_vend_part = vend_part
      no-lock by vp_part with frame d width 80 no-attr-space:
                                /* SET EXTERNAL LABELS */
                                setFrameLabels(frame d:handle).
                                {mfrpchk.i}                     /*G339*/
      display
      vp_part
      vp_vend
      vp_um vp_vend_lead  vp_q_price vp_cur.
/*G179  vp_q_qty vp_pr_list.  */
      if vp_mfgr <> "" or vp_mfgr_part <> "" then do:
         down 1.
         put unformat vp_mfgr at 1 " " vp_mfgr_part.
         find first ad_mstr no-lock where ad_addr = vp_mfgr
                and ad_type = "supplier" no-error.
         if available ad_mstr then do:
              put unformat ad_name at 41.
         end.
         put skip.
      end.
   end.

   else

/*H0R3*   for each vp_mstr */
/*H0R3*/  for each vp_mstr where vp_part >= "" and vp_vend >= ""
/*H0R3*/                     and vp_vend_part >= ""
          no-lock by vp_part by vp_vend with frame e width 80 no-attr-space:

                                /* SET EXTERNAL LABELS */
                                setFrameLabels(frame e:handle).
                                {mfrpchk.i}                     /*G339*/
      display vp_part vp_vend vp_vend_part vp_um.
/*G179   vp_mfgr vp_mfgr_part. */
/*G179*/ if vp_mfgr <> "" or vp_mfgr_part <> "" then do:
/*G179*/    down 1.
/*G179*/    put unformat vp_mfgr at 1 " " vp_mfgr_part.
            find first ad_mstr no-lock where ad_addr = vp_mfgr
                    and ad_type = "supplier" no-error.
            if available ad_mstr then do:
                 put unformat ad_name at 41.
            end.
            put skip.
/*G179*/ end.
   end.

   {mfreset.i}
/*N12H*   {mfmsg.i 8 1} */
/*N12H*/ {pxmsg.i &MSGNUM=8 &ERRORLEVEL=1} /* List complete */
end.
global_part = part.

/*K194*/ {wbrp04.i &frame-spec = a}
