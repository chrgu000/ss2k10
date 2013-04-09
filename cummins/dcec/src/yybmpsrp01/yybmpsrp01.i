/* GUI CONVERTED from bmpsrp.i (converter v1.78) Fri Sep 30 01:41:49 2005 */
/* bmpsrp.i - PRODUCT STRUCTURE REPORT INCLUDE FILE                          */
/* Copyright 1986-2005 QAD Inc., Carpinteria, CA, USA.                       */
/* All rights reserved worldwide.  This is an unpublished work.              */
/* $Revision: 1.16 $                                                         */
/*V8:ConvertMode=Report                                                      */
/* REVISION: 9.0      CREATED: 10/22/98       BY: *J30L* Raphael T.          */
/* REVISION: 9.0      LAST MODIFIED: 03/13/99   BY: *M0BD* Alfred Tan        */
/* REVISION: 9.0      LAST MODIFIED: 07/15/99   BY: *J3J4* Jyoti Thatte      */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane  */
/* REVISION: 9.1      LAST MODIFIED: 08/11/00   BY: *N0KK* jyn               */
/* REVISION: 9.1      LAST MODIFIED: 12/06/00   BY: *M0XK* Vandna Rohira     */
/* Revision: 1.10     BY: Kirti Desai        DATE: 11/19/01  ECO: *M1QD*     */
/* Revision: 1.13     BY: K Paneesh          DATE: 11/20/02  ECO: *N201*     */
/* Revision: 1.15     BY: Paul Donnelly (SB) DATE: 06/26/03  ECO: *Q00B*     */
/* $Revision: 1.16 $  BY: Ajay Nair          DATE: 09/30/05  ECO: *P43P*     */
/*-Revision end---------------------------------------------------------------*/

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/


/*GUI preprocessor directive settings */
&SCOPED-DEFINE PP_GUI_CONVERT_MODE REPORT

PROCEDURE process_report:

   define input parameter comp       like ps_comp     no-undo.
   define input parameter level      as   integer     no-undo.
   define input parameter effdate    like ps_start    no-undo.
   define input parameter isite      like si_site     no-undo.
   define input parameter iqty       like ps_qty_per  no-undo.

   define query q_ps_mstr            for ps_mstr
      fields( ps_domain ps_comp ps_end ps_lt_off ps_op ps_par ps_ps_code
      ps_qty_per
             ps_ref ps_rmks ps_scrp_pct ps_start).

   define buffer bommstr for bom_mstr.

   for first bom_mstr
      fields( bom_domain bom_batch_um bom_desc bom_fsm_type bom_parent)
       where bom_mstr.bom_domain = global_domain and  bom_parent = comp
      no-lock:
   end. /* FOR FIRST bom_mstr */

   for first pt_mstr
      fields( pt_domain  pt_bom_code pt_desc1 pt_desc2 pt_iss_pol
               pt_part pt_phantom pt_rev pt_um )
      no-lock  where pt_mstr.pt_domain = global_domain and  pt_part = comp:
   end. /* FOR FIRST PT_MSTR */
   if available pt_mstr
   and pt_bom_code <> ""
   then
      comp = pt_bom_code.

/*   if sort_ref then */
      open query q_ps_mstr
         for each ps_mstr
            use-index ps_parref
             where ps_mstr.ps_domain = global_domain and  ps_par = comp
            and (string(ps_op) >= op and string(ps_op) <= op1) no-lock.

/*   else                                                                    */
/*      open query q_ps_mstr                                                 */
/*         for each ps_mstr                                                  */
/*            use-index ps_parcomp                                           */
/*             where ps_mstr.ps_domain = global_domain and  ps_par = comp    */
/*            and (ps_op >= op and ps_op <= op1) no-lock.                    */

   get first q_ps_mstr no-lock.

   if not available ps_mstr
   then
      return.
   assign
      phantom   = if available pt_mstr
                  then
                     pt_phantom
                  else
                     no
      l_phantom = if phantom
                  then
                     getTermLabel("YES",3)
                  else
                     ""
      iss_pol   = if available pt_mstr
                  then
                     pt_iss_pol
                  else
                     no
      l_iss_pol = if iss_pol
                  then
                     ""
                  else
                     getTermLabel("NO",3).

   /* DETAIL FORM */
   FORM /*GUI*/
      lvl
      ps_comp
      ps_ref
      desc1
      ps_qty_per
      um
      ps_op
      phantom
      ps_ps_code
      iss_pol
      ps_start
      ps_end
      ps_scrp_pct
      ps_lt_off
   with STREAM-IO /*GUI*/  frame det2 width 132 no-attr-space no-box.

   /* SET EXTERNAL LABELS */
   setFrameLabels(frame det2:handle).

/* if level = 1                                                                */
/* then do:                                                                    */
/*                                                                             */
/*    if page-size - line-counter < 7                                          */
/*    then                                                                     */
/*       page.                                                                 */
/*                                                                             */
/*    display                                                                  */
/*       getTermLabel("PARENT",6)                  @ lvl                       */
/*       parent                                    @ ps_comp                   */
/*       pt_desc1 when (available pt_mstr)         @ desc1                     */
/*       bom_desc when (not available pt_mstr)     @ desc1                     */
/*       pt_um when (available pt_mstr)            @ um                        */
/*       bom_batch_um when (not available pt_mstr) @ um                        */
/*       l_phantom                                 @ phantom                   */
/*       l_iss_pol                                 @ iss_pol                   */
/*    with frame det2 STREAM-IO /*GUI*/ .                                      */
/*                                                                             */
/*    down 1 with frame det2.                                                  */
/*                                                                             */
/*    if available pt_mstr                                                     */
/*    and pt_desc2 > ""                                                        */
/*    then do:                                                                 */
/*                                                                             */
/*       display                                                               */
/*         pt_desc2 @ desc1                                                    */
/*         with frame det2 STREAM-IO /*GUI*/ .                                 */
/*       down 1 with frame det2.                                               */
/*                                                                             */
/*    end.  /* IF AVAILABLE pt_mstr ... */                                     */
/*                                                                             */
/*    if available pt_mstr                                                     */
/*    and pt_rev <> ""                                                         */
/*    then do:                                                                 */
/*                                                                             */
/*       display                                                               */
/*          ("  " + getTermLabel("REVISION",6) + ": " + pt_rev) format "x(24)" */
/*          @ desc1                                                            */
/*       with frame det2 STREAM-IO /*GUI*/ .                                   */
/*       down 1 with frame det2.                                               */
/*                                                                             */
/*    end. /* IF AVAILABLE pt_mstr ... */                                      */
/*                                                                             */
/*    if comp <> parent                                                        */
/*    then do :                                                                */
/*       display                                                               */
/*          (getTermLabel("BOM",3) + ": " + comp) @ desc1                      */
/*          with frame det2 STREAM-IO /*GUI*/ .                                */
/*       down 1 with frame det2.                                               */
/*    end. /* IF comp <> parent */                                             */
/*                                                                             */
/* end.  /* IF level = 1 */                                                    */

   repeat while available ps_mstr with frame det2 down:

/*        if eff_date = ? or (eff_date <> ? and                    */
/*        (ps_start = ? or ps_start <= eff_date)                   */
/*        and  (ps_end = ? or eff_date <= ps_end))                 */
  if (ps_start = ? or ps_start <= effdate) and (ps_end = ? or ps_end >= effdate)
      then do:

         assign
            um = ""
            desc1 = getTermLabel("ITEM_NOT_IN_INVENTORY",24)
            l_iss_pol = "no"
            l_phantom = "no"
            iss_pol = no
            phantom = no.

         for first pt_mstr
            fields( pt_domain pt_bom_code pt_desc1 pt_desc2 pt_iss_pol
                   pt_part pt_phantom pt_rev pt_um)
             where pt_mstr.pt_domain = global_domain and  pt_part = ps_comp
            no-lock:
         end. /* FOR FIRST pt_mstr */

         if available pt_mstr
         then
            assign
               um = pt_um
               desc1 = pt_desc1
               iss_pol = pt_iss_pol
               phantom = pt_phantom
               l_iss_pol = string(iss_pol)
               l_phantom = string(phantom).
         else do:

            for first bommstr
               fields( bom_domain bom_batch_um bom_desc bom_fsm_type bom_parent)
                where bommstr.bom_domain = global_domain and
                bommstr.bom_parent = ps_comp
               no-lock:
            end. /* FOR FIRST bommstr */

/*      assign                                            */
/*         l_phantom = if phantom                         */
/*                     then                               */
/*                       getTermLabel("YES",3)            */
/*                     else                               */
/*                       getTermLabel("NO",3)             */
/*                                                        */
/*         l_iss_pol = if iss_pol                         */
/*                     then                               */
/*                       getTermLabel("YES",3)            */
/*                     else                               */
/*                       getTermLabel("NO",3).            */

            if available bommstr
            then
               assign
                  um = bommstr.bom_batch_um
                  desc1 = bommstr.bom_desc.
         end. /* ELSE DO */

/*           assign                                                         */
/*              lvl = "........"                                            */
/*              lvl = substring(lvl,1,min (level - 1,9)) + string(level).   */
/*                                                                          */
/*           if length(lvl) > 10                                            */
/*           then                                                           */
/*              lvl = substring(lvl,length (lvl) - 9,10).                   */

         lines = 1.
         if ps_rmks > ""
         then
            lines = lines + 1.

         if available pt_mstr
         and pt_desc2 > ""
         then
           lines = lines + 1.

         if available pt_mstr
         and pt_rev > ""
         then
           lines = lines + 1.

/*        if page-size - line-counter < lines                                */
/*        then                                                               */
/*           page.                                                           */
/*                                                                           */
        find first pt_mstr where pt_domain = global_domain and
                   pt_part = ps_comp no-lock no-error.
        find first ptp_det where ptp_domain = global_domain and
                   ptp_site = isite and ptp_part = ps_comp no-lock no-error.
        find first xxwk exclusive-lock where xxwk.parent = parent
               and xxwk.comp = ps_comp and xxwk.op = ps_op
               and xxwk.qty = ps_qty_per no-error.
        if not available xxwk then do:
           create xxwk.
           assign xxwk.parent = parent.
                  xxwk.comp = ps_comp.
                  xxwk.op = ps_op.
                  xxwk.qty = iqty * ps_qty_per .
        end.
           else assign xxwk.qty = xxwk.qty + iqty * ps_qty_per.
           assign xxwk.desc2 = pt_desc2 when available(pt_mstr).
                  xxwk.ref = ps_ref.
                  xxwk.pscode = ps_ps_code.
                  xxwk.sdate = ps_start.
                  xxwk.edate = ps_end.
                  xxwk.rmks = ps_rmks.
            find first opm_mstr where opm_domain = global_domain
                   and opm_std_op = string(ps_op) no-lock no-error.
            if available opm_mstr then do:
                  assign xxwk.wkctr = opm_wkctr.
                  find wc_mstr where wc_domain = global_domain and
                       wc_wkctr = opm_wkctr and wc_mch = opm_mch no-lock no-error.
                  if available wc_mstr then
                         assign xxwk.wcdesc = wc_desc.
            end.


/*                                                                           */
/*        display                                                            */
/*           lvl                                                             */
/*           ps_comp                                                         */
/*           ps_ref                                                          */
/*           desc1                                                           */
/*           ps_qty_per                                                      */
/*           um                                                              */
/*           ps_op                                                           */
/*           l_phantom when (phantom = yes) @ phantom                        */
/*           ps_ps_code                                                      */
/*           l_iss_pol when (iss_pol = no) @ iss_pol                         */
/*           ps_start                                                        */
/*           ps_end                                                          */
/*           ps_lt_off                                                       */
/*           ps_scrp_pct when (ps_scrp_pct <> 0)                             */
/*        with frame det2 STREAM-IO /*GUI*/ .                                */
/*        down with frame det2.                                              */
/*                                                                           */
/*        if available pt_mstr                                               */
/*        and pt_desc2 > ""                                                  */
/*        then do:                                                           */
/*           display                                                         */
/*              pt_desc2 @ desc1                                             */
/*              with frame det2 STREAM-IO /*GUI*/ .                          */
/*           down with frame det2.                                           */
/*        end.  /* IF AVAILABLE pt_mstr ... */                               */

/*       if available pt_mstr                                                */
/*       and pt_rev <> ""                                                    */
/*       then do:                                                            */
/*                                                                           */
/*          display                                                          */
/*             ("  " + getTermLabel("REVISION",6) + ": " + pt_rev)           */
/*             format "x(24)" @ desc1                                        */
/*             with frame det2 STREAM-IO /*GUI*/ .                           */
/*          down with frame det2.                                            */
/*                                                                           */
/*       end. /* IF AVAILABLE pt_mstr ... */                                 */
/*                                                                           */
/*       if length(ps_rmks) <> 0                                             */
/*       then do:                                                            */
/*                                                                           */
/*          display                                                          */
/*             ps_rmks @ desc1                                               */
/*             with frame det2 STREAM-IO /*GUI*/ .                           */
/*          down with frame det2.                                            */
/*       end. /* IF LENGTH(ps_rmks) <> 0 */                                  */

         if level < maxlevel
         or maxlevel = 0
         then do:

            /* THIRD INPUT PARAMETER CHANGED FROM new_parent TO skpge */
find first ptp_det no-lock where ptp_domain = global_domain
       and ptp_part = ps_comp and ptp_site = isite no-error.
            if (available ptp_det and ptp_phantom) or not available ptp_det then do:
            run process_report
               (input ps_comp,
               input level + 1,
               input effdate,
               input isite,
               input xxwk.qty).
end.
            get next q_ps_mstr no-lock.
         end.  /* IF level < maxlevel ... */
         else
            get next q_ps_mstr no-lock.
      end.  /* End of Valid date */
      else
         get next q_ps_mstr no-lock.

   end.  /* End of Repeat loop */

/****************
   if level = 1
   then do:

      if skpge
      then
         page.
      else
         put skip(1).

   end. /* IF level = 1 */
*******************/

   close query q_ps_mstr.

END PROCEDURE.
/***
procedure getSubQty:
 /* -----------------------------------------------------------
    Purpose: 计算BOM用量到table temp3
    Parameters: vv_par:父零件,vv_eff_date:生效日
    Notes:
  -------------------------------------------------------------*/

    define input  parameter vv_part     as character .
    define input  parameter vv_site     like si_site.
    define input  parameter vv_eff_date as date format "99/99/99" .

    define var  vv_comp     like ps_comp no-undo.
    define var  vv_level    as integer   no-undo.
    define var  vv_record   as integer extent 500.
    define var  vv_qty      as decimal initial 1  no-undo.
    define var  vv_save_qty as decimal extent 500 no-undo.

    assign vv_level = 1
           vv_comp  = vv_part
           vv_save_qty = 0
           vv_qty      = 1 .

find first ps_mstr use-index ps_parcomp where ps_domain = global_domain and
           ps_par = vv_comp  no-lock no-error .
repeat:
       if not avail ps_mstr then do:
             repeat:
                vv_level = vv_level - 1.
                if vv_level < 1 then leave .
                find ps_mstr where recid(ps_mstr) = vv_record[vv_level]
                             no-lock no-error.
                vv_comp  = ps_par.
                vv_qty = vv_save_qty[vv_level].
                find next ps_mstr use-index ps_parcomp where ps_domain = global_domain and
                          ps_par = vv_comp  no-lock no-error.
                if avail ps_mstr then do:
                     leave.
                end.
            end.
        end.  /*if not avail ps_mstr*/

        if vv_level < 1 then leave .
        vv_record[vv_level] = recid(ps_mstr).


        if (ps_end = ? or vv_eff_date <= ps_end) then do :
                vv_save_qty[vv_level] = vv_qty.

                vv_comp  = ps_comp .
                vv_qty = vv_qty * ps_qty_per * (100 / (100 - ps_scrp_pct)).
                vv_level = vv_level + 1.


/*                find first temp3 where t3_part = vv_part and           */
/*                           t3_comp = ps_comp no-error.                 */
/*                if not available temp3 then do:                        */
/*                    create temp3.                                      */
/*                    assign                                             */
/*                        t3_part     = caps(vv_part)                    */
/*                        t3_comp     = caps(ps_comp)                    */
/*                        t3_qty_per  = vv_qty                           */
/*                        .                                              */
/*                end.                                                   */
/*                 else t3_qty_per   = t3_qty_per + vv_qty  .             */
       find first pt_mstr where pt_domain = global_domain and
                   pt_part = ps_comp no-lock no-error.
        find first ptp_det where ptp_domain = global_domain and
                   ptp_site = vv_site and ptp_part = ps_comp no-lock no-error.
        find first xxwk exclusive-lock where xxwk.parent = parent
               and xxwk.comp = ps_comp and xxwk.op = ps_op
               and xxwk.qty = ps_qty_per no-error.
        if not available xxwk then do:
           create xxwk.
           assign xxwk.parent = parent.
                  xxwk.comp = ps_comp.
                  xxwk.op = ps_op.
                  xxwk.qty = vv_qty.
        end.
           else xxwk.qty = xxwk.qty + vv_qty.
           assign xxwk.desc2 = pt_desc2 when available(pt_mstr).
                  xxwk.ref = ps_ref.
                  xxwk.pscode = ps_ps_code.
                  xxwk.sdate = ps_start.
                  xxwk.edate = ps_end.
                  xxwk.rmks = ps_rmks.
            find first opm_mstr where opm_domain = global_domain
                   and opm_std_op = string(ps_op) no-lock no-error.
            if available opm_mstr then do:
                  assign xxwk.wkctr = opm_wkctr.
                  find wc_mstr where wc_domain = global_domain and
                       wc_wkctr = opm_wkctr and wc_mch = opm_mch no-lock no-error.
                  if available wc_mstr then
                         assign xxwk.wcdesc = wc_desc.
            end.

               find first ps_mstr use-index ps_parcomp where ps_domain = global_domain and
                        ps_par = vv_comp  no-lock no-error.
        end.   /*if (ps_end = ? or vv_eff_date <= ps_end)*/
        else do:
              repeat:
              find next ps_mstr use-index ps_parcomp where ps_domain = global_domain and
                        ps_par = vv_comp  no-lock no-error.
                  find first ptp_det no-lock where ptp_domain = global_domain
                         and ptp_part = ps_comp and ptp_site = vv_site no-error.
                  if (available ptp_det and ptp_phantom) or not available ptp_det then do:
                      leave.
                  end.
             end.
        end.  /* not (ps_end = ? or vv_eff_date <= ps_end)  */
end. /*repeat:*/

end procedure. /*bom_down*/
***/