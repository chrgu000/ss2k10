/* bmwurpa.p - WHERE-USED REPORT                                              */
/* Copyright 1986-2006 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* REVISION: 1.0      LAST EDIT:     06/03/86   BY: EMB                       */
/* REVISION: 1.0      LAST EDIT:     08/29/86   BY: EMB *12*                  */
/* REVISION: 2.1      LAST EDIT:     10/19/87   BY: WUG *A94*                 */
/* REVISION: 4.0      LAST EDIT:     01/05/88   BY: RL  *A118*                */
/* REVISION: 4.0      LAST EDIT:     01/06/88   BY: RL  *A122*                */
/* REVISION: 4.0      LAST EDIT:     02/16/88   BY: FLM *A175*                */
/* REVISION: 6.0      LAST EDIT:     10/30/90   BY: emb *D145*                */
/* REVISION: 7.0      LAST EDIT:     01/02/92   BY: emb                       */
/* REVISION: 7.2      LAST MODIFIED: 11/02/92   BY: pma *G265*                */
/* REVISION: 7.3      LAST MODIFIED: 12/20/93   BY: ais *GH69*                */
/* REVISION: 8.6      LAST MODIFIED: 09/27/97   BY: mzv *K0J *                */
/* REVISION: 8.6      LAST MODIFIED: 10/15/97   BY: ays *K106*                */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane          */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan         */
/* REVISION: 9.0      LAST MODIFIED: 07/30/99   BY: *J3J4* Jyoti Thatte       */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane   */
/* REVISION: 9.1      LAST MODIFIED: 07/07/00   BY: *L10Y* Vandna Rohira      */
/* REVISION: 9.1      LAST MODIFIED: 08/11/00   BY: *N0KK* jyn                */
/* REVISION: 9.1      LAST MODIFIED: 08/21/00   BY: *N0MG* BalbeerS Rajput    */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* Revision: 1.6.1.9  BY: Jean Miller           DATE: 05/25/02   ECO: *P076*  */
/* Revision: 1.6.1.11 BY: Paul Donnelly (SB)    DATE: 06/26/03   ECO: *Q00B*  */
/* Revision: 1.6.1.13 BY: Manish Dani           DATE: 04/15/04   ECO: *P1TV*  */
/* Revision: 1.6.1.14 BY: Reena Ambavi          DATE: 07/06/04   ECO: *P28F*  */
/* Revision: 1.6.1.15 BY: Bhavik Rathod         DATE: 03/29/05   ECO: *P3DH*  */
/* $Revision: 1.6.1.16 $  BY: Preeti Sattur     DATE: 07/12/06   ECO: *P4X5*  */
/*-Revision end---------------------------------------------------------------*/

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/
/*V8:ConvertMode=FullGUIReport                                                */

/* DISPLAY TITLE */
{mfdeclre.i}
{xxbmwua.i}
DEFINE INPUT PARAMETER compx LIKE ps_comp.

DEFINE variable transtype as character format "x(4)" INITIAL "BM".
DEFINE VARIABLE I AS INTEGER.
DEFINE VARIABLE levelx AS CHARACTER.
define variable comp like ps_comp.
define variable level as integer.
define variable maxlevel as integer format ">>>" label "Levels".

define variable eff_date as date label "As of Date".
define variable component like ps_comp.
define variable component1 like ps_comp.
define variable component2 like ps_comp.
define variable skpge like mfc_logical label "New Page each Component".

define variable desc1 like pt_desc1.
define variable um like pt_um.
define variable phantom like mfc_logical format "yes" label "Ph".
define variable iss_pol like pt_iss_pol format "/no".
define variable record as integer extent 1000.
define variable lvl as character format "x(11)" label "Level".
define variable temp_comp like ps_comp.
define variable bombatch like bom_batch.
define variable down1 as character.
define variable line2 like ps_par format "x(24)".
define variable l_leave like mfc_logical initial no  no-undo.

define buffer ptmstr for pt_mstr.

define temp-table item-bom
   field  item like pt_part
   field  bom  like pt_bom_code
   field  par  like ps_par
   field  ref  like ps_ref
   index  item-bom-par is unique item bom par ref.

eff_date = today.
i = 1.

/* GO THRU ITEM PLANNING DETAIL TABLE TO FIND THE PART */
/* AND THEN CHECK FOR ITS BOM                          */
procedure p_find_ptp_det:

   define input  parameter ip-check-level   like mfc_logical no-undo.
   define input  parameter ip-find-psmstr   like mfc_logical no-undo.

   define variable l_ptp_avail like mfc_logical no-undo.

   l_ptp_avail = no.

   if ip-find-psmstr
   then
      find first ps_mstr
         where  recid(ps_mstr) =  -1
         no-lock no-error.


   for each ptp_det
      fields ( /* ptp_domain */ ptp_bom_code ptp_part)
      where /* ptp_domain   = global_domain and */
             ptp_bom_code = comp
   no-lock:

      l_ptp_avail = yes.

      if ip-find-psmstr
      then do:

         find first ps_mstr
            use-index ps_comp
            where /* ps_domain = global_domain and */
               ps_comp   = ptp_det.ptp_part
            no-lock no-error.

         if not available ps_mstr
         then
            next.

      end. /* IF ip-find-psmstr */

      run p_check_item_bom(input  ptp_det.ptp_part,
                           input  ptp_det.ptp_bom_code,
                           input  ps_mstr.ps_par,
                           input  ps_mstr.ps_ref,
                           input  ip-check-level,
                           output l_leave).


      if l_leave
      then do:

         l_leave = false.
         leave.

      end. /* IF l_leave */

   end. /* FOR EACH ptp_det */

   if not l_ptp_avail
   then do:
      for each pt_mstr
         fields( /* pt_domain */ pt_part pt_bom_code)
         where /* pt_domain   = global_domain and */
               pt_bom_code = comp
      no-lock:

         if ip-find-psmstr
         then do:
            for first ps_mstr
               fields(/* ps_domain */   ps_comp     ps_par      ps_ref
                      ps_start     ps_end      ps_qty_per
                      ps_ps_code   ps_scrp_pct ps_lt_off
                      ps_qty_per_b ps_qty_type)
               use-index ps_comp
               where /* ps_domain = global_domain and */
                 ps_comp   = pt_part
            no-lock:
            end. /* FOR FIRST ps_mstr */

            if not available ps_mstr
            then
               next.

         end. /* IF ip-find-psmstr */

         run p_check_item_bom(input  pt_part,
                              input  pt_bom_code,
                              input  ps_mstr.ps_par,
                              input  ps_mstr.ps_ref,
                              input  ip-check-level,
                              output l_leave).
         if l_leave
         then do:
            l_leave = false.
            leave.
         end. /* IF l_leave */
      end. /* FOR EACH pt_mstr */
   end. /* IF NOT l_ptp_avail */
end procedure. /* PROCEDURE p_find_ptp_det */


/* CHECK IF THE GIVEN COMBINATION OF PART, BOM CODE, PARENT AND  */
/* REFERENCE NUMBER IS ALREADY EXISTING. IF NOT EXISTING THEN WE */
/* CREATE THE TEMP TABLE OTHERWISE WE CLEAR THE ps_mstr BUFFER   */
procedure p_check_item_bom:

   define input  parameter ip-item          like ptp_part     no-undo.
   define input  parameter ip-bom           like ptp_bom_code no-undo.
   define input  parameter ip-par           like ps_par       no-undo.
   define input  parameter ip-ref           like ps_ref       no-undo.
   define input  parameter ip-check-level   like mfc_logical  no-undo.
   define output parameter op-leave         like mfc_logical  no-undo.

   for first item-bom
      where  item-bom.item = ip-item
      and    item-bom.bom  = ip-bom
      and    item-bom.par  = ip-par
      and    item-bom.ref  = ip-ref
   no-lock:
   end. /* FOR FIRST item-bom */

   if not available item-bom
   then do:

      run p_create_item_bom(input ip-item,
                            input ip-bom,
                            input ip-par,
                            input ip-ref).

      op-leave = true.

   end.  /* IF NOT AVAILABLE item-bom */
   else do:
      if  (ip-check-level
           and level >= maxlevel
           and maxlevel <> 0)
      or not ip-check-level
      then do:

         find first ps_mstr
            where  recid(ps_mstr) =  -1
            no-lock no-error.

         op-leave = true.

      end. /* IF  (ip-check-level... */

   end. /* ELSE DO */

end procedure. /* PROCEDURE p_check_item_bom */


/* CREATE TEMP-TABLE WITH A PART,BOM CODE,PARENT */
/* AND REFERENCE NUMBER COMBINATION              */
procedure p_create_item_bom:

   define input parameter ip-item like pt_part     no-undo.
   define input parameter ip-bom  like pt_bom_code no-undo.
   define input parameter ip-par  like ps_par      no-undo.
   define input parameter ip-ref  like ps_ref      no-undo.

   create item-bom.
   assign
      item-bom.item = ip-item
      item-bom.bom  = ip-bom
      item-bom.par  = ip-par
      item-bom.ref  = ip-ref.

end procedure. /* PROCEDURE p_create_item_bom */


/* form                                */
/*    component1     colon 20          */
/*    component2     label "To"        */
/*    skip(1)                          */
/*    eff_date       colon 25          */
/*    maxlevel       colon 25          */
/*    skpge          colon 25          */
/* with frame a width 80 side-labels.  */
/*                                     */
/* /* SET EXTERNAL LABELS */           */
/* setFrameLabels(frame a:handle).     */
/*                                     */
/* {wbrp02.i}                          */

/* repeat:  */
    ASSIGN component1 = compx
           component2 = compx
           eff_date = TODAY
           maxlevel = 999999
           skpge = YES.

/*    if component2 = hi_char then component2 = "".                           */
/*                                                                            */
/*    if c-application-mode <> 'web' then                                     */
/*       update component1 component2 eff_date maxlevel skpge with frame a .  */
/*                                                                            */
/*    {wbrp06.i &command = update &fields = " component1 component2           */
/*         eff_date maxlevel skpge " &frm = "a"}                              */
/*                                                                            */
/*    if (c-application-mode <> 'web') or                                     */
/*       (c-application-mode = 'web' and                                      */
/*       (c-web-request begins 'data')) then do:                              */
/*                                                                            */
/*       bcdparm = "".                                                        */
/*       {mfquoter.i component1 }                                             */
/*       {mfquoter.i component2 }                                             */
/*       {mfquoter.i eff_date   }                                             */
/*       {mfquoter.i maxlevel   }                                             */
/*       {mfquoter.i skpge      }                                             */
/*                                                                            */
/*       if component2 = "" then component2 = hi_char.                        */
/*    end.                                                                    */
/*                                                                            */
/*    /* OUTPUT DESTINATION SELECTION */                                      */
/*    {gpselout.i &printType = "printer"                                      */
/*                &printWidth = 132                                           */
/*                &pagedFlag = " "                                            */
/*                &stream = " "                                               */
/*                &appendToFile = " "                                         */
/*                &streamedOutputToTerminal = " "                             */
/*                &withBatchOption = "yes"                                    */
/*                &displayStatementType = 1                                   */
/*                &withCancelMessage = "yes"                                  */
/*                &pageBottomMargin = 6                                       */
/*                &withEmail = "yes"                                          */
/*                &withWinprint = "yes"                                       */
/*                &defineVariables = "yes"}                                   */
/*    {mfphead.i}                                                             */

   maxlevel = min(maxlevel,99).

   /*DETAIL FORM (BM)*/
/*    form                                         */
/*       lvl                                       */
/*       ps_par                                    */
/*       ps_ref                                    */
/*       desc1                                     */
/*       ps_qty_per                                */
/*       um                                        */
/*       phantom                                   */
/*       ps_ps_code                                */
/*       iss_pol                                   */
/*       ps_start                                  */
/*       ps_end                                    */
/*       ps_scrp_pct                               */
/*       ps_lt_off                                 */
/*    with frame bm width 132 no-attr-space down.  */
/*                                                 */
/*    /* SET EXTERNAL LABELS */                    */
/*    setFrameLabels(frame bm:handle).             */
/*                                                 */
/*    /*DETAIL FORM (FM)*/                         */
/*    form                                         */
/*       lvl                                       */
/*       ps_par                                    */
/*       ps_ref                                    */
/*       ps_qty_per_b                              */
/*       ps_qty_type                               */
/*       bombatch                                  */
/*       um                                        */
/*       phantom                                   */
/*       ps_ps_code                                */
/*       iss_pol                                   */
/*       ps_start                                  */
/*       ps_end                                    */
/*       ps_scrp_pct                               */
/*       ps_lt_off                                 */
/*    with frame fm width 132 no-attr-space down.  */
/*                                                 */
/*    /* SET EXTERNAL LABELS */                    */
/*    setFrameLabels(frame fm:handle).             */

   temp_comp = "".

   for first ps_mstr
      fields( /* ps_domain */ ps_comp     ps_end     ps_lt_off    ps_par
             ps_ps_code  ps_qty_per ps_qty_per_b
             ps_qty_type ps_ref     ps_scrp_pct  ps_start)
      where /* ps_mstr.ps_domain = global_domain and */
            ps_mstr.ps_comp  >= max(temp_comp,component1) and
            ps_mstr.ps_comp  <= component2
   no-lock:
   end.

   down1 = "X".
   repeat:

      if not available ps_mstr then leave.

      assign
         comp = ps_comp
         level = 1
         temp_comp = ps_comp
         component = ps_comp
/*         desc1 = getTermLabel("ITEM_NOT_IN_INVENTORY",24) */
         um = ""
         iss_pol = no
         phantom = no.

      find pt_mstr no-lock
         where /* pt_mstr.pt_domain = global_domain and */
               pt_part = ps_comp
         no-error.

      if available pt_mstr then do:
         assign
            um = pt_um
            desc1 = pt_desc1
            iss_pol = pt_iss_pol
            phantom = pt_phantom.
      end.

      find bom_mstr no-lock
         where /*  bom_mstr.bom_domain = global_domain and */
                bom_parent = ps_comp
         no-error.

      if available bom_mstr then do:

/*         if desc1 = getTermLabel("ITEM_NOT_IN_INVENTORY",24) then         */
/*          desc1 = bom_desc.                                               */

         if um = "" then um = bom_batch_um.
         if transtype = "FM" then do:
            if bom_batch <> 0 then
               bombatch = bom_batch.
            else
               bombatch = 1.
            um = bom_batch_um.
         end.
      end.

/*      if page-size - line-counter < 4 then do:                             */
/*         down1 = "X".                                                      */
/*         page.                                                             */
/*      end.                                                                 */

      /* START DISPLAY */
      line2 = "".

      if available pt_mstr then line2 = pt_desc2.

/*       if transtype = "BM" then do:                         */
/*          {bmwurpa1.i &frame="bm"                           */
/*             &down=down1                                    */
/*             &level="getTermLabel(""COMPONENT"",11) @ lvl"  */
/*             &comp="component @ ps_par"                     */
/*             &desc1=desc1                                   */
/*             &um=um                                         */
/*             &phantom=phantom                               */
/*             &isspol=iss_pol                                */
/*             &line1=""""                                    */
/*             &line2=line2                                   */
/*             &line3=""""}                                   */
/*       end.                                                 */
/*                                                            */
/*       else do:                                             */
/*          {bmwurpa1.i &frame="fm"                           */
/*             &down=down1                                    */
/*             &level="getTermLabel(""COMPONENT"",11) @ lvl"  */
/*             &comp="component @ ps_par"                     */
/*             &batch=bombatch                                */
/*             &um=um                                         */
/*             &phantom=phantom                               */
/*             &isspol=iss_pol                                */
/*             &line1=desc1                                   */
/*             &line2=line2                                   */
/*             &line3=""""}                                   */
/*       end.                                                 */

      down1 = "".

      repeat:

         if not available ps_mstr
         then do:

            repeat:

               level = level - 1.
               if level < 1 then leave.

               find ps_mstr
                  where recid(ps_mstr) = record[level]
                  no-lock
                  no-error.

               if available ps_mstr
               then
                  comp = ps_par.

               run p_find_ptp_det(input false,
                                  input true).


               if available ps_mstr then
               do:

                  run p_find_ptp_det(input true,
                                     input false).


                level = level + 1.
                leave.

               end. /* IF AVAIL ps_mstr */


               find ps_mstr
                  where recid(ps_mstr) = record[level]
                  no-lock no-error.

               if available ps_mstr
               then
                  comp = ps_comp.

               find next ps_mstr use-index ps_comp
                  where /* ps_mstr.ps_domain = global_domain and */
                        ps_mstr.ps_comp = comp
                  no-lock no-error.

               if available ps_mstr
               then do:

                  run p_find_ptp_det(input false,
                                     input false).

                  leave.

               end.  /* IF AVAILABLE ps_mstr */

            end.  /* REPEAT */

         end. /* IF NOT AVAILABLE ps_mstr */

         if level < 1 then leave.

         if eff_date = ? or (eff_date <> ?
            and (ps_start = ? or ps_start <= eff_date)
            and (ps_end = ? or eff_date <= ps_end))
         then do:

/*            desc1 = getTermLabel("ITEM_NOT_IN_INVENTORY",24).             */
            um = "".
            iss_pol = no.
            phantom = no.

            find ptmstr
               where /* ptmstr.pt_domain = global_domain and */
                      ptmstr.pt_part = ps_par
            no-lock no-error.

            if available ptmstr then do:
               assign
                  um = ptmstr.pt_um
                  desc1 = ptmstr.pt_desc1
                  iss_pol = ptmstr.pt_iss_pol
                  phantom = ptmstr.pt_phantom.
            end.

            find bom_mstr no-lock
               where /* bom_mstr.bom_domain = global_domain and */
                     bom_parent = ps_par
               no-error.

            if available bom_mstr then do:
/*               if desc1 = getTermLabel("ITEM_NOT_IN_INVENTORY",24)         */
/*                  then desc1 = bom_desc.                                   */
               if um = "" then um = bom_batch_um.
               if transtype = "FM" then do:
                  if bom_batch <> 0 then
                     bombatch = bom_batch.
                  else
                     bombatch = 1.
                  um = bom_batch_um.
               end.
            end.

            record[level] = recid(ps_mstr).

            lvl = "........".
            lvl = substring(lvl,1,min (level - 1,10)) + string(level).
            if length(lvl) > 11 then
               lvl = substring(lvl,length (lvl) - 10,11).

 /*           if page-size - line-counter < 2 then page.          */

            line2 = "".
            if available ptmstr then line2 = ptmstr.pt_desc2. 
               create tmp_bom.
				       assign tb_comp  = compx
                      tb_par   = ps_par
                      tb_level = level
                      tb_qty   = ps_qty_per
                      tb_pm    = ptmstr.pt_pm_code when avail ptmstr
                      tb_sn    = i
                      i = i + 1.
                
    
/*             if transtype = "BM" then do:  */
/*                {bmwurpa1.i &frame="bm"    */
/*                   &down=""X""             */
/*                   &level=lvl              */
/*                   &comp=ps_par            */
/*                   &ref=ps_ref             */
/*                   &desc1=desc1            */
/*                   &qtyper=ps_qty_per      */
/*                   &um=um                  */
/*                   &phantom=phantom        */
/*                   &pscode=ps_ps_code      */
/*                   &isspol=iss_pol         */
/*                   &start=ps_start         */
/*                   &end=ps_end             */
/*                   &scrap=ps_scrp_pct      */
/*                   &offset=ps_lt_off       */
/*                   &line1=""""             */
/*                   &line2=line2            */
/*                   &line3=ps_rmks}         */
/*             end.                          */
/*                                           */
/*             else do:                      */
/*                {bmwurpa1.i &frame="fm"    */
/*                   &down=""X""             */
/*                   &level=lvl              */
/*                   &comp=ps_par            */
/*                   &ref=ps_ref             */
/*                   &qtyper=ps_qty_per_b    */
/*                   &qtytype=ps_qty_type    */
/*                   &batch=bombatch         */
/*                   &um=um                  */
/*                   &phantom=phantom        */
/*                   &pscode=ps_ps_code      */
/*                   &isspol=iss_pol         */
/*                   &start=ps_start         */
/*                   &end=ps_end             */
/*                   &scrap=ps_scrp_pct      */
/*                   &offset=ps_lt_off       */
/*                   &line1=desc1            */
/*                   &line2=line2            */
/*                   &line3=ps_rmks}         */
/*             end.                          */

            if level < maxlevel or maxlevel = 0
            then do:

               assign
                  comp = ps_par
                  level = level + 1.

               for first ps_mstr
                  fields( /* ps_domain */ ps_comp  ps_end ps_lt_off  ps_par
                         ps_ps_code  ps_qty_per ps_qty_per_b
                         ps_qty_type ps_ref     ps_scrp_pct  ps_start)
                  use-index ps_comp
                  where /* ps_mstr.ps_domain = global_domain  and */
                         ps_mstr.ps_comp   = comp
               no-lock:
               end.

               if available ps_mstr
               then do:

                  run p_find_ptp_det(input false,
                                     input false).

               end. /* IF AVAIL ps_mstr */

            end. /* IF level < maxlevel OR maxlevel = 0 */
            else do:

               find next ps_mstr use-index ps_comp
                  where /* ps_mstr.ps_domain = global_domain and */
                       ps_mstr.ps_comp   = comp
                  no-lock no-error.

               if not available ps_mstr
               then do:
                  if level <> 1
                  then
                     run p_find_ptp_det(input false,
                                        input true).

               end.  /* IF NOT AVAILABLE ps_mstr */
               else
                  run p_find_ptp_det(input false,
                                     input false).

            end. /* ELSE DO */

         end.  /* IF eff_date = ? OR (eff_date <> ?... */
         else do:
            find next ps_mstr use-index ps_comp
               where /* ps_mstr.ps_domain = global_domain and */
                     ps_mstr.ps_comp = comp
               no-lock no-error.

         end. /* ELSE DO */

      end.  /* REPEAT */

/*       {mfrpchk.i}  */
/*       if skpge then page.  */

      for first ps_mstr
         fields(/* ps_domain */ ps_comp     ps_end     ps_lt_off    ps_par
                ps_ps_code  ps_qty_per ps_qty_per_b
                ps_qty_type ps_ref     ps_scrp_pct  ps_start)
         where  /* ps_mstr.ps_domain = global_domain and */
               ps_mstr.ps_comp   > temp_comp
         and   ps_mstr.ps_comp  <= component2
      no-lock: end.

      empty temp-table item-bom.

   end. /* REPEAT */

   /* REPORT TRAILER */
/*    {mfrtrail.i}  */

/* end. /* REPEAT */ */

/* {wbrp04.i &frame-spec = a}  */
/* OUTPUT TO C:\TS\XXXX.TXT.                     */
/* FOR EACH tmp_bom NO-LOCK:                     */
/*     DISPLAY tmp_bom WITH WIDTH 300 STREAM-IO. */
/* END.                                          */
