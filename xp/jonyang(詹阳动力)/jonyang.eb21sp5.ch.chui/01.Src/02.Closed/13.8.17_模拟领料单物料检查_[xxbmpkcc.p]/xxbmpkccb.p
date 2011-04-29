/* bmpkccb.p - SIMULATED PICKLIST COMPONENT AVAILABILITY CHECK          */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                  */
/* All rights reserved worldwide.  This is an unpublished work.         */
/* $Revision: 1.36 $                                                         */
/*V8:ConvertMode=Report                                                 */
/* REVISION: 1.0     LAST EDIT:     05/07/86   BY: EMB                  */
/* REVISION: 1.0     LAST EDIT:     01/29/87   BY: EMB *A19*            */
/* REVISION: 4.0     LAST EDIT:     12/30/87   BY: WUG *A137*           */
/* REVISION: 2.1     LAST EDIT:     01/07/88   BY: RL  *A132*           */
/* REVISION: 4.0     LAST EDIT:     08/03/88   BY: flm *A375*           */
/* REVISION: 4.0     LAST EDIT:     11/04/88   BY: flm *A520*           */
/* REVISION: 4.0     LAST EDIT:     11/15/88   BY: emb *A535*           */
/* REVISION: 4.0     LAST EDIT:     02/21/89   BY: emb *A654*           */
/* REVISION: 5.0     LAST EDIT:     05/03/89   BY: WUG *B098*           */
/* REVISION: 5.0     LAST MODIFIED: 06/23/89   BY: MLB *B159*           */
/* REVISION: 5.0     LAST MODIFIED: 07/27/89   BY: BJJ *B215*           */
/* REVISION: 6.0     LAST MODIFIED: 05/18/90   BY: WUG *D002*           */
/* REVISION: 6.0     LAST MODIFIED: 07/11/90   BY: WUG *D051*           */
/* REVISION: 7.0     LAST MODIFIED: 10/26/92   BY: emb *G234*           */
/* REVISION: 7.0     LAST MODIFIED: 11/03/92   BY: pma *G265*           */
/* REVISION: 7.4     LAST MODIFIED: 09/01/93   BY: dzs *H100*           */
/* REVISION: 7.3     LAST MODIFIED: 12/23/93   BY: ais *GI30*           */
/* REVISION: 7.2     LAST MODIFIED: 12/29/93   BY: ais *FL07*           */
/* REVISION: 7.4     LAST MODIFIED: 01/21/94   BY: pxd *FL47*           */
/* REVISION: 7.2     LAST MODIFIED: 02/21/94   BY: ais *FM19*           */
/* REVISION: 7.4     LAST MODIFIED: 04/18/94   BY: ais *H357*           */
/* REVISION: 7.4     LAST MODIFIED: 08/11/94   BY: pxd *FQ05            */
/* REVISION: 7.2     LAST MODIFIED: 02/09/95   BY: qzl *F0HQ*           */
/* REVISION: 7.4     LAST MODIFIED: 04/10/95   BY: jpm *H0CH*           */
/* REVISION: 7.4     LAST MODIFIED: 12/19/95   BY: bcm *G1H5*           */
/* REVISION: 8.5     LAST MODIFIED: 09/19/94   BY: dzs *J020*           */
/* REVISION: 7.4     LAST MODIFIED: 01/16/96   BY: jym *G1JF*           */
/* REVISION: 7.4     LAST MODIFIED: 01/30/96   BY: jym *G1LP*           */
/* REVISION: 8.6     LAST MODIFIED: 10/15/97   BY: mur *K119*           */
/* REVISION: 8.6     LAST MODIFIED: 01/12/98   BY: *H1J4* Viswanathan   */

/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane        */
/* REVISION: 8.6E     LAST MODIFIED: 07/07/98   BY: *L03H* Santosh Nair     */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan       */
/* REVISION: 9.0      LAST MODIFIED: 10/16/98   BY: *J32L* Felcy D'Souza    */
/* REVISION: 9.0      LAST MODIFIED: 03/13/99   BY: *M0BD* Alfred Tan       */
/* REVISION: 9.1      LAST MODIFIED: 07/20/99   BY: *N015* Mugdha Tambe     */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane */
/* REVISION: 9.1      LAST MODIFIED: 07/04/00   BY: *N0F3* Rajinder Kamra   */
/* REVISION: 9.1      LAST MODIFIED: 08/11/00   BY: *N0KK* jyn              */
/* Old ECO marker removed, but no ECO header exists *FM19*                    */
/* Old ECO marker removed, but no ECO header exists *H357*                    */
/* Revision: 1.33  BY: Gnanasekar DATE: 03/27/03 ECO: *N2BW* */
/* Revision: 1.35  BY: Paul Donnelly (SB) DATE: 06/26/03 ECO: *Q00B* */
/* $Revision: 1.36 $ BY: Subramanian Iyer DATE: 08/26/03 ECO: *P0VK* */

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/*G265***********************************************************************/
/*       INCORPORATED PATCH D766 FROM FMPKCC.P AS FOLLOWS:                  */
/*----rev history-------------------------------------------------------------------------------------*/
/* SS - 100531.1  By: Roger Xiao */  /*加计划员等*/

/*-Revision end---------------------------------------------------------------*/
/* DISPLAY TITLE */
{mfdtitle.i "100531.1"}

/*           FORMAT  >>>,>>9.9<<<<< WAS  >>>,>>9.9 IN BMPKCC.P              */
/*           FORMAT ->>>,>>9.9<<<<< WAS ->>>,>>9.9 IN BMPKCC.P              */

define new shared workfile pkdet no-undo
   field pkpart like ps_comp
   field pkop as integer format ">>>>>9"
   field pkstart like pk_start
   field pkend like pk_end
   field pkqty like pk_qty format "->>>,>>>,>>9.9<<<<<<<<"
   field pkbombatch like bom_batch
   field pkltoff like ps_lt_off.

define workfile wf-oh no-undo
   field ohpart like ps_comp
   field ohqty like pk_qty.

define new shared variable comp     like ps_comp.
define new shared variable eff_date as   date
   label "As of".
define new shared variable qty      like pt_batch  label "Quantity".

define variable part      like ps_par.
define variable last_part like pt_part.
define variable desc1     like pt_desc1.
define variable um        like pt_um.

define variable qavail as decimal format "->>>,>>>,>>9.9<<<<<<<<"
   label "Short".
define variable qty_oh as decimal format "->>>,>>9.9<<<<<"
   label "Available".
define new shared variable net_oh like mfc_logical initial no
   label "Net OH".
define new shared variable use_up like mfc_logical initial yes
   label "Use up Ph".
define new shared variable site like in_site
   no-undo.
define shared variable transtype as character format "x(4)".
define new shared variable op as integer label "Op" format ">>>>>9".

define new shared variable phantom like mfc_logical initial yes.

define variable aval       as   logical   no-undo.
define variable batchqty   like bom_batch no-undo.
define variable batchdesc1 like pt_desc1  no-undo.
define variable batchdesc2 like pt_desc2  no-undo.

/* SS - 100531.1 - B */
define var v_pm_code as char format "x(1)" .
define var v_buyer   as char format "x(8)" .
define var v_loc     like pt_loc     . 
define var v_qty_tmp like pkqty no-undo .

define temp-table temp1 
    field t1_part     like ld_part 
    field t1_loc      like ld_loc
    field t1_qty_left like ld_qty_oh 
    field t1_status   like ld_status 
    .
/* SS - 100531.1 - E */



{gpxpld01.i "new shared"}

form
   part colon 12
   desc1 no-attr-space no-label
   eff_date to 77 skip

   site colon 12 qty um no-label no-attr-space net_oh use_up
   op colon 12
with frame a width 80 no-underline attr-space side-labels.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

form
   pkpart     column-label "Component!Description"
   pt_phantom  label "Ph"
   pkqty
   um
   qty_oh
   qavail
   pkop       label "Op"
/* SS - 100531.1 - B 
   with frame detail width 80 down.
   SS - 100531.1 - E */
/* SS - 100531.1 - B */
   v_pm_code  column-label "PM"
   v_buyer    column-label "采计"
   v_loc      label "库位"
   with frame detail width 105 down.
/* SS - 100531.1 - E */

/* SET EXTERNAL LABELS */
setFrameLabels(frame detail:handle).

assign
   part = global_part
   site = global_site
   eff_date = today.
/* SS - 100531.1 - B */
if site = "" then do:
    find icc_ctrl where icc_domain = global_domain no-lock no-error.
    site = if avail icc_ctrl then icc_site else "10000" .
end.
/* SS - 100531.1 - E */

{wbrp02.i}
repeat
with frame a:
   for each wf-oh
   exclusive-lock:
      delete wf-oh.
   end. /* FOR EACH wf-oh */

/* SS - 100531.1 - B */
for each temp1: delete temp1. end.
/* SS - 100531.1 - E */

   if c-application-mode <> 'web' then
   update part
      eff_date site qty net_oh use_up
      op
      with frame a
   editing:

      if frame-field = "part"
      then do:

         /* FIND NEXT/PREVIOUS RECORD */
         {mfnp.i bom_mstr part  " bom_mstr.bom_domain = global_domain and
         bom_parent "  part bom_parent bom_parent}

         if recno <> ?
         then do:

            part = bom_parent.

            /* BEGIN OF ADDED SETION */

            /* GET DESCRIPTION,UM,BATCH QTY */
            {gprun.i ""fmrodesc.p"" "(input part,
                 output batchdesc1,
                 output batchdesc2,
                 output batchqty,
                 output um,
                 output aval)"}

            if transtype = "BM"
            then do:

               for first pt_mstr
                  fields( pt_domain pt_bom_code   pt_desc1   pt_desc2
                          pt_joint_type pt_loc     pt_ord_qty
                        /* SS - 100531.1 - B */
                            pt_pm_code pt_buyer
                        /* SS - 100531.1 - E */
                          pt_part       pt_phantom pt_um)
                   where pt_mstr.pt_domain = global_domain and  pt_part = part
               no-lock:
               end. /* FOR FIRST pt_mstr */

               if available pt_mstr
               then
                  batchqty = pt_ord_qty.
               else
                  batchqty = 0.

            end. /* IF TRANSTYPE = "BM" */

            if batchqty = 0
            then
               batchqty = 1.

            display part
               batchdesc1 @ desc1
               batchqty   @ qty
               um
            with frame a.

            recno = ?.
         end. /* IF recno <> ? */
      end. /* IF frame-field = "part" */
      else
      if frame-field = "site"
      then do:
         /* FIND NEXT/PREVIOUS RECORD */
         {mfnp.i si_mstr site  " si_mstr.si_domain = global_domain and si_site
         "  site si_site si_site}
         if recno <> ?
         then do:
            site = si_site.
            display site with frame a.
         end. /* IF recno <> ? */
      end. /* IF frame-field = "site" */
      else do:
         readkey.
         apply lastkey.
      end. /* ELSE DO */
   end. /* EDITING */

   {wbrp06.i &command = update &fields = "  part  eff_date site qty net_oh
        use_up  op" &frm = "a"}

   if    (c-application-mode <> 'web')
      or (c-application-mode = 'web'
          and (c-web-request begins 'data'))
   then do:

      status input "".
      /*V8-*/
      assign part.
      /*V8+*/

      for first bom_mstr
         fields( bom_domain bom_batch_um bom_desc bom_parent)
          where bom_mstr.bom_domain = global_domain and  bom_parent = part
      no-lock:
      end. /* FOR FIRST bom_mstr */

      for first pt_mstr
         fields( pt_domain pt_bom_code   pt_desc1   pt_desc2
                 pt_joint_type pt_loc     pt_ord_qty
                        /* SS - 100531.1 - B */
                            pt_pm_code pt_buyer
                        /* SS - 100531.1 - E */
                 pt_part       pt_phantom pt_um)
          where pt_mstr.pt_domain = global_domain and  pt_part = part
      no-lock:
      end. /* FOR FIRST pt_mstr */

      assign
         desc1 = ""
         um = "".

      if not available pt_mstr
         and not available bom_mstr
      then do:
         {pxmsg.i &MSGNUM=17 &ERRORLEVEL=3}  /* PART NUMBER NOT FOUND */
         if c-application-mode = 'web'
         then
            return.
         undo, retry.
      end. /* IF NOT AVAILABLE pt_mstr */

      /* NOTE: IF bom_mstr IS NOT AVAILABLE THEN pt_mstr IS AVAILABLE */

      /* GET DESCRIPTION,UM,BATCH QTY */
      {gprun.i ""fmrodesc.p""
         "(input (input part),
           output batchdesc1,
           output batchdesc2,
           output batchqty,
           output um,
           output aval)"}

      if qty = 0
      then do:

         if transtype = "BM"
         then do:

            if available pt_mstr
            then do:

               for first ptp_det
                  fields( ptp_domain ptp_bom_code ptp_joint_type ptp_ord_qty
                        /* SS - 100531.1 - B */
                            ptp_pm_code ptp_buyer
                        /* SS - 100531.1 - E */
                          ptp_part     ptp_phantom    ptp_site)
                   where ptp_det.ptp_domain = global_domain and   ptp_part =
                   pt_part
                     and ptp_site = site
               no-lock:
               end. /* FOR FIRST ptp_det */

               if available ptp_det
               then
                  qty = ptp_ord_qty.
               else
                  qty = pt_ord_qty.

            end. /* IF AVAILABLE pt_mstr */

         end. /* IF transtype = "BM" */

         else
            qty = batchqty.

         if qty = 0
         then
            qty = 1.

      end. /* IF qty = 0 */

      display
         batchdesc1 @ desc1
         qty
         um
      with frame a.

      for first si_mstr
         fields( si_domain si_site)
          where si_mstr.si_domain = global_domain and  si_site = site
      no-lock:
      end. /* FOR FIRST si_mstr */

      if not available si_mstr
      then do:
         {pxmsg.i &MSGNUM=708 &ERRORLEVEL=3}

         if c-application-mode = 'web'
         then
            return.
         else
            next-prompt site.
         undo, retry.
      end. /* IF NOT AVAILABLE si_mstr */

      clear frame detail all.
      hide frame detail.

   end. /* IF c-application-mode <> 'web' */

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

   comp = part.

   for first ptp_det
      fields( ptp_domain ptp_bom_code ptp_joint_type ptp_ord_qty
                        /* SS - 100531.1 - B */
                            ptp_pm_code ptp_buyer
                        /* SS - 100531.1 - E */
              ptp_part     ptp_phantom    ptp_site)
       where ptp_det.ptp_domain = global_domain and   ptp_part = part
         and ptp_site = site
   no-lock:
   end. /* FOR FIRST ptp_det */

   if available ptp_det
   then do:
      if index("1234",ptp_joint_type) > 0
      then do:
         {pxmsg.i &MSGNUM=6519 &ERRORLEVEL=1}
         /* MAY NOT INQUIRE/REPORT ON JOINT PRODUCTS */
         if c-application-mode = 'web'
         then
            return.
         undo, retry.
      end. /* IF INDEX("1234",ptp_joint_type) > 0 */
      if ptp_bom_code > ""
      then
         comp = ptp_bom_code.
   end. /* IF AVAILABLE ptp_det */
   else
   if available pt_mstr
   then do:
      if index("1234",pt_joint_type) > 0
      then do:
         {pxmsg.i &MSGNUM=6519 &ERRORLEVEL=1}
         /* MAY NOT INQUIRE/REPORT ON JOINT PRODUCTS */
         if c-application-mode = 'web'
         then
            return.
         undo, retry.
      end. /* IF INDEX("1234",pt_joint_type) > 0 */
      if pt_bom_code > ""
      then
         comp = pt_bom_code.
   end. /* IF AVAILABLE pt_mstr */

   /* explode part by standard picklist logic */
   if comp <> last_part
   then do:
      if use_up
      then do:
         /* EXPLODE WITH use-up PHANTOM ONHAND LOGIC */
         {gprun.i ""bmpkcca.p""}
      end. /* IF use-up */
      else do:
         /* EXPLODE W/OUT use-up PHANTOM ONHAND LOGIC*/
         {gprun.i ""woworla2.p""}
      end. /* ELSE DO */
   end. /* IF comp <> last_part */

/* SS - 100531.1 - B */
for each pkdet 
    where eff_date = ? or (eff_date <> ?
    and (pkstart = ? or pkstart <= eff_date)
    and (pkend = ? or eff_date <= pkend)
    and ((pkop = op) or (op = 0))) no-lock
    break by pkpart:
    if first-of(pkpart) then do:
        for each ld_det 
            use-index ld_part_loc
            where ld_domain = global_domain
            and   ld_part   = pkpart 
            and   ld_site   = site 
            and   ld_qty_oh > 0 
            no-lock :

            /*库存状态:可用,有效*/
            find first is_mstr where is_domain = global_domain and is_status = ld_status no-lock no-error .
            if avail is_mstr and is_avail and is_nettable then do:
                find first temp1 where t1_part = ld_part and t1_loc = ld_loc no-error .
                if not avail temp1 then do:
                    create temp1 .
                    assign t1_part     = ld_part 
                           t1_loc      = ld_loc
                           t1_status   = ld_status
                           t1_qty_left = /*if net_oh then ld_qty_oh - ld_qty_all else*/ ld_qty_oh .
                end.
            end.
        end. /*for each ld_det*/
    end. /*if first-of*/
end. /*for each pkdet*/

for each temp1 where t1_qty_left <= 0 :
    delete temp1 .
end.
/* SS - 100531.1 - E */


   for each pkdet
         where eff_date = ? or (eff_date <> ?
         and (pkstart = ? or pkstart <= eff_date)
         and (pkend = ? or eff_date <= pkend)
         and ((pkop = op) or (op = 0))) no-lock
         break by pkpart
         by pkop with frame detail
/* SS - 100531.1 - B 
   width 80 no-attr-space:
   SS - 100531.1 - E */
/* SS - 100531.1 - B */
 no-attr-space:
/* SS - 100531.1 - E */

      qty_oh = 0.

      for first in_mstr
         fields( in_domain in_part in_qty_all in_qty_avail in_site)
          where in_mstr.in_domain = global_domain and   in_part = pkpart
            and in_site = site
      no-lock:
      end. /* FOR FIRST in_mstr */

      if available in_mstr
      then do:

         qty_oh = in_qty_avail.
         if net_oh then qty_oh = qty_oh - in_qty_all.

         find first wf-oh where ohpart = pkpart no-error.
         if not available wf-oh
         then do:
            create wf-oh.
            assign ohpart = pkpart
                   ohqty  = 0.
         end. /* IF NOT AVAILABLE wf-oh */
         else
            qty_oh = max( (qty_oh - ohqty),0).

      end. /* IF AVAIRLABLE in_mstr */

      for first pt_mstr
         fields( pt_domain pt_bom_code   pt_desc1   pt_desc2
                 pt_joint_type pt_loc     pt_ord_qty
                        /* SS - 100531.1 - B */
                            pt_pm_code pt_buyer
                        /* SS - 100531.1 - E */
                 pt_part       pt_phantom pt_um)
          where pt_mstr.pt_domain = global_domain and  pt_part = pkpart
      no-lock:
      end. /* FOR FIRST pt_mstr */

      desc1 = getTermLabel("ITEM_NOT_IN_INVENTORY",24).
      um = "".

      if available pt_mstr
      then do:
         assign
            desc1 = pt_desc1
            um = pt_um.

         for first ptp_det
            fields( ptp_domain ptp_bom_code ptp_joint_type ptp_ord_qty
                        /* SS - 100531.1 - B */
                            ptp_pm_code ptp_buyer
                        /* SS - 100531.1 - E */
                    ptp_part     ptp_phantom    ptp_site)
             where ptp_det.ptp_domain = global_domain and   ptp_part = pkpart
               and ptp_site = site
         no-lock:
         end. /* FOR FIRST ptp_det */

      end. /* IF AVAILABLE pt_mstr */
      else do:

         for first bom_mstr
            fields( bom_domain bom_batch_um bom_desc bom_parent)
             where bom_mstr.bom_domain = global_domain and  bom_parent = pkpart
         no-lock:
         end. /* FOR FIRST bom_mstr */

         if available bom_mstr
         then
         assign um = bom_batch_um
             desc1 = bom_desc.
      end. /* ELSE DO */

      if not use_up
      then
         pkqty = pkqty * qty / pkbombatch.

      accumulate pkqty (total by pkop).

      if last-of(pkop)
      then do:
         if (available ptp_det and ptp_phantom) or
            (available pt_mstr and not available ptp_det and
            pt_phantom)
            or not available pt_mstr
         then
            qavail = 0.
         else
            qavail = -1 * min(qty_oh - accum total by pkop pkqty,0).

         display
            pkpart
            pt_phantom when (available pt_mstr and not available ptp_det)
            format "Ph/"
            ptp_phantom when (available ptp_det) @ pt_phantom
            getTermLabel("BOM",3) when (not available pt_mstr
                                    and not available ptp_det)
                                                 @ pt_phantom
            accum total by pkop
            pkqty @ pkqty
            um
            qty_oh
            qavail
            pkop
/* SS - 100531.1 - B */
            pt_pm_code  when (available pt_mstr and not available ptp_det) @ v_pm_code
            ptp_pm_code when (available ptp_det) @ v_pm_code
            pt_buyer    when (available pt_mstr and not available ptp_det) @ v_buyer
            ptp_buyer   when (available ptp_det) @ v_buyer
            v_loc 
/* SS - 100531.1 - E */
            with frame detail.

         down with frame detail.

         display
            desc1 @ pkpart
            with frame detail.

         down with frame detail.

         find first wf-oh where ohpart = pkpart no-error.

         if available wf-oh
         then
            ohqty = ohqty + (accum total by pkop pkqty).

      end. /* IF LAST-OF(pkop) */
/* SS - 100531.1 - B */
      if last-of(pkpart) then do:
          for each temp1 
              where t1_part = pkpart 
              no-lock 
              break by t1_part by t1_loc :
              if first-of(t1_part) then 
              disp 
               "     库存明细:" @ pkqty
              with frame detail.

              disp 
               t1_qty_left @ qty_oh  
               t1_status   @ v_buyer
               t1_loc      @ v_loc 
              with frame detail.
              down with frame detail.

              if last-of(t1_part) then 
              down 1 with frame detail.
          end.
      end. /*if last-of(pkpart)*/
/* SS - 100531.1 - E */

   end. /* FOR EACH pkdet */
   {mfreset.i}
   {pxmsg.i &MSGNUM=8 &ERRORLEVEL=1}
end. /* REPEAT WITH FRAME A */

{wbrp04.i &frame-spec = a}
