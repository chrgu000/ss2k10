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
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/


/* SS - 101124.1  By: Roger Xiao */
/* SS - 101124.1  By: Roger Xiao */ /*rebuild ,to fix the bug of 101124 */
/*-Revision end---------------------------------------------------------------*/

/* SS - 101124.1 - B */
define var v_ii        as integer .
define var v_qty_level like ps_qty_per extent 20 .
define var v_qty_per   like ps_qty_per  .
/* SS - 101124.1 - E */



PROCEDURE process_report:

   define input parameter comp       like ps_comp     no-undo.
   define input parameter level      as   integer     no-undo.
   define input parameter skpge      like mfc_logical no-undo.

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

   if sort_ref
   then
      open query q_ps_mstr
         for each ps_mstr
            use-index ps_parref
             where ps_mstr.ps_domain = global_domain and  ps_par = comp
            and (ps_op >= op and ps_op <= op1) no-lock.

   else
      open query q_ps_mstr
         for each ps_mstr
            use-index ps_parcomp
             where ps_mstr.ps_domain = global_domain and  ps_par = comp
            and (ps_op >= op and ps_op <= op1) no-lock.

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
/* SS - 101020.1 - B 
   form
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
   with frame det2 width 132 no-attr-space no-box.
   SS - 101020.1 - E */
/* SS - 101020.1 - B */
    form
        lvl
        ps_comp
        ps_ref
        desc1
        ps_qty_per
        um
        v_qty_bc label "板材重量"
        v_qty_xc label "型材重量"
        ps_op
        phantom
        ps_ps_code
        iss_pol
        ps_start
        ps_end
        ps_scrp_pct
        ps_lt_off
    with frame det2 width 160 no-attr-space no-box.
/* SS - 101020.1 - E */

   /* SET EXTERNAL LABELS */
   setFrameLabels(frame det2:handle).

   if level = 1
   then do:

      if page-size - line-counter < 7
      then
         page.

      display
         getTermLabel("PARENT",6)                  @ lvl
         parent                                    @ ps_comp
         pt_desc1 when (available pt_mstr)         @ desc1
         bom_desc when (not available pt_mstr)     @ desc1
         pt_um when (available pt_mstr)            @ um
         bom_batch_um when (not available pt_mstr) @ um
         l_phantom                                 @ phantom
         l_iss_pol                                 @ iss_pol
      with frame det2.

      down 1 with frame det2.

      if available pt_mstr
      and pt_desc2 > ""
      then do:

         display
           pt_desc2 @ desc1
           with frame det2.
         down 1 with frame det2.

      end.  /* IF AVAILABLE pt_mstr ... */

      if available pt_mstr
      and pt_rev <> ""
      then do:

         display
            ("  " + getTermLabel("REVISION",6) + ": " + pt_rev) format "x(24)"
            @ desc1
         with frame det2.
         down 1 with frame det2.

      end. /* IF AVAILABLE pt_mstr ... */

      if comp <> parent
      then do :
         display
            (getTermLabel("BOM",3) + ": " + comp) @ desc1
            with frame det2.
         down 1 with frame det2.
      end. /* IF comp <> parent */

    /* SS - 101124.1 - B */
    v_qty_level = 1 .  /*all level to 1 */
    /* SS - 101124.1 - E */

   end.  /* IF level = 1 */

   repeat while available ps_mstr with frame det2 down:

      if eff_date = ? or (eff_date <> ? and
      (ps_start = ? or ps_start <= eff_date)
      and  (ps_end = ? or eff_date <= ps_end))
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

      assign
         l_phantom = if phantom
                     then
                       getTermLabel("YES",3)
                     else
                       getTermLabel("NO",3)

         l_iss_pol = if iss_pol
                     then
                       getTermLabel("YES",3)
                     else
                       getTermLabel("NO",3).

            if available bommstr
            then
               assign
                  um = bommstr.bom_batch_um
                  desc1 = bommstr.bom_desc.
         end. /* ELSE DO */

         assign
            lvl = "........"
            lvl = substring(lvl,1,min (level - 1,9)) + string(level).

         if length(lvl) > 10
         then
            lvl = substring(lvl,length (lvl) - 9,10).

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

         if page-size - line-counter < lines
         then
            page.

/* SS - 101124.1 - B */
         
         v_qty_level[level] = ps_qty_per . /*current level record now ,and all above level have been recorded */
         v_ii = 0.
         do v_ii = level + 1 to 20 :
            v_qty_level[v_ii] = 1 . 
         end.

         v_qty_per = 1 .
         v_ii = 0.
         do v_ii = 1 to level :
             v_qty_per = v_qty_per * v_qty_level[v_ii]  . 
         end.        


        v_qty_bc = 0 .
        v_qty_xc = 0 .
        if ps_comp begins "Y" then  v_qty_bc =  v_qty_per .
        if ps_op = 82 or ps_op = 84 then do:
            find first um_mstr 
                use-index um_part
                where um_domain = global_domain
                and um_part     = ps_comp 
                and um_um       = um
                and um_alt_um   = "KG"
            no-lock no-error .
            if avail um_mstr then v_qty_xc = v_qty_per * um_conv .
        end.
        v_tot_bc = v_tot_bc + v_qty_bc .
        v_tot_xc = v_tot_xc + v_qty_xc .
/* SS - 101124.1 - E */

         display
            lvl
            ps_comp
            ps_ref
            desc1
            ps_qty_per
            um
            ps_op
            l_phantom when (phantom = yes) @ phantom
            ps_ps_code
            l_iss_pol when (iss_pol = no) @ iss_pol
            ps_start
            ps_end
            ps_lt_off
            ps_scrp_pct when (ps_scrp_pct <> 0)
/* SS - 101020.1 - B */
            v_qty_bc when v_qty_bc <> 0 
            v_qty_xc when v_qty_xc <> 0
/* SS - 101020.1 - E */
         with frame det2.
         down with frame det2.

         if available pt_mstr
         and pt_desc2 > ""
         then do:
            display
               pt_desc2 @ desc1
               with frame det2.
            down with frame det2.
         end.  /* IF AVAILABLE pt_mstr ... */

         if available pt_mstr
         and pt_rev <> ""
         then do:

            display
               ("  " + getTermLabel("REVISION",6) + ": " + pt_rev)
               format "x(24)" @ desc1
               with frame det2.
            down with frame det2.

         end. /* IF AVAILABLE pt_mstr ... */

         if length(ps_rmks) <> 0
         then do:

            display
               ps_rmks @ desc1
               with frame det2.
            down with frame det2.
         end. /* IF LENGTH(ps_rmks) <> 0 */

         if level < maxlevel
         or maxlevel = 0
         then do:

            /* THIRD INPUT PARAMETER CHANGED FROM new_parent TO skpge */

            run process_report
               (input ps_comp,
               input level + 1,
               input skpge).

            get next q_ps_mstr no-lock.
         end.  /* IF level < maxlevel ... */
         else
            get next q_ps_mstr no-lock.
      end.  /* End of Valid date */
      else
         get next q_ps_mstr no-lock.

   end.  /* End of Repeat loop */

   if level = 1
   then do:

      if skpge
      then
         page.
      else
         put skip(1).

   end. /* IF level = 1 */

   close query q_ps_mstr.

END PROCEDURE.
