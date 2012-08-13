/* GUI CONVERTED from bmpscp.p (converter v1.69) Fri Jun 13 08:35:58 1997 */
/* bmpscp.p - BILL OF MATERIAL COPY                                           */
/* COPYRIGHT qad.inc. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK.       */
/*F0PN*/ /*V8:ConvertMode=Maintenance                                         */
/* REVISION: 2.0      LAST MODIFIED: 05/01/87   BY: EMB                       */
/* REVISION: 2.0      LAST MODIFIED: 09/02/87   BY: EMB                       */
/* REVISION: 4.0      LAST MODIFIED: 09/30/88   BY: RL                        */
/* REVISION: 6.0      LAST MODIFIED: 06/13/91   BY: emb *D702*                */
/* REVISION: 7.0      LAST MODIFIED: 11/16/91   BY: pml *F048*                */
/* REVISION: 7.0      LAST MODIFIED: 06/18/92   BY: emb *F671*                */
/* REVISION: 7.0      LAST MODIFIED: 09/08/92   BY: emb *g301(F###)*          */
/*                                   11/11/92       pma *G301*                */
/* REVISION: 7.3       LAST EDIT: 02/24/93      MODIFIED BY: sas *G729*/
/* REVISION: 7.3       LAST EDIT: 03/19/93      MODIFIED BY: pma *G790*/
/* REVISION: 7.3       LAST EDIT: 07/29/93      MODIFIED BY: emb *GD82*       */
/* REVISION: 7.3       LAST EDIT: 02/14/94      MODIFIED BY: pxd *FL60*       */
/* REVISION: 7.3       LAST EDIT: 08/18/94      MODIFIED BY: pxd *FQ34*       */
/* REVISION: 7.3       LAST EDIT: 03/28/95      MODIFIED BY: pxd *F0P1*       */
/* REVISION: 8.5       LAST EDIT: 12/21/94      MODIFIED BY: dzs *J011*       */
/* REVISION: 8.5   LAST MODIFIED: 07/30/96      BY: *J12T* Sue Poland         */
/* REVISION: 8.5   LAST MODIFIED: 10/31/96      BY: *J16D* Murli Shastri      */
/* REVISION: 8.5   LAST MODIFIED: 05/07/97      BY: *J1RB* Sue Poland         */
/* REVISION: 8.5   LAST MODIFIED: 10/21/03      BY: Kevin                 */

         /* DISPLAY TITLE */
         {mfdtitle.i "e+ "}/*FL60*/

/*J1RB*/ define new shared variable bom-type like bom_fsm_type initial "".      /*kevin*/

         /* BMPSCPM.P CONTAINS THE COMMON BOM COPY LOGIC USED BY BOTH
            MANUFACTURING AND SERVICE BOM COPY */
/*/*J1RB*/ {gprun.i ""bmpscpm.p"" "(input bom-type)"}*/             /*kevin*/
            {gprun.i ""zzbmpscpm.p""}              /*kevin*/
/*GUI*/ if global-beam-me-up then undo, leave.

/*J1RB*  define new shared variable comp like ps_comp.
.         define variable part1 like ps_par label "Source Structure".
.         define variable part2 like ps_par label "Destination Structure".
./*J16D*/ define variable dest_desc like pt_desc1
.                                   label "Destination Description".
.         define variable desc1 like pt_desc1 no-undo.
./*J16D*  define variable desc2 like pt_desc1 no-undo. */
.         define variable desc3 like pt_desc1 no-undo.
./*J16D*  define variable desc4 like pt_desc1 no-undo. */
./*J16D*/ define variable um1   like pt_um label "UM".
./*J16D*/ define variable um2   like pt_um label "UM".
.         define buffer ps_from for ps_mstr.
.         define new shared variable ps_recno as recid.
.         define variable yn like mfc_logical.
.         define variable unknown_char as character initial ?.
.         define variable found_any like mfc_logical.
.         define variable to_batch_qty like pt_batch.
.         define buffer bommstr for bom_mstr.
./*G301*/ define variable from_batch_qty like pt_batch.
./*G301*/ define variable to_batch_um like pt_um.
./*G301*/ define variable from_batch_um like pt_um.
./*G301*/ define variable conv like ps_um_conv.
./*G301*/ define variable um like pt_um.
./*G301*/ define variable copy_conv like um_conv.
./*G301*/ define variable formula_yn like bom_formula.
./*G790*/ define variable config_yn like mfc_logical.
./*G790*/ define variable qtyper_b like ps_qty_per_b.
.
./*FQ34*/  /* moved form 5 positions to right for translation */
.         form
.            part1          colon 30
.            desc1          no-label at 52
./*J16D*/    um1            colon 30
./*J16D*     desc2          no-label at 52 */
.            part2          colon 30
.            desc3          no-label at 52
./*J16D*/    um2            colon 30
./*J16D*     desc4          no-label at 52 */
./*J16D*/    dest_desc      colon 30
.         with frame a side-labels width 80 attr-space.
.
.         repeat:
./*J16D*/    clear frame a no-pause.
.            display part1 part2 with frame a.
.            do on error undo, retry with frame a:
.
.              /* WITH THIS FUNCTION, THE USER MAY COPY ANY BOM STRUCTURE
.                 (INCLUDING A SERVICE BOM) TO A 'NORMAL' BOM STRUCTURE */
.
./*J16D*/      assign dest_desc = "".
.              set part1 part2 with frame a editing:
.
.	        if frame-field = "part1" then do:
.	           /* FIND NEXT/PREVIOUS RECORD */
./*G301             {mfnp.i ps_mstr part1 ps_par part1 ps_par ps_par}  */
./*G301*/           {mfnp.i bom_mstr part1 bom_parent part1
.                        bom_parent bom_parent}
.
.	           if recno <> ? then do:
.
.	               assign
./*G301*/                    part1 = bom_parent
./*J16D* /*G301*/            desc1 = bom_desc          */
./*J16D*	                    desc2 = "".               */
./*J16D*/                    um1   = bom_batch_um.
.
./*G301*/               find pt_mstr no-lock where pt_part = bom_parent no-error.
.
.	               if available pt_mstr then
./*G301*/               do:
.		          assign part1 = pt_part.
./*J16D* /*G301*/              if desc1 = "" then assign */
.		              desc1 = pt_desc1.
./*J16D*		              desc2 = pt_desc2. */
./*G301*/               end.
.
./*J16D*		       desc2 = "". */
./*J16D*	               display part1 desc1 desc2. */
./*J16D*/	       display part1 desc1 um1.
.	           end.    /* if recno <> ? */
.	           recno = ?.
.	       end.    /* if frame-field = "part1" */
.	       else if frame-field = "part2" then do:
.
.	           /* FIND NEXT/PREVIOUS RECORD - DISPLAY NON-SERVICE
.	               BOMS ONLY    */
./*J12T* /*G301*/   {mfnp.i bom_mstr part2 bom_parent part1 bom_parent bom_parent} */
./*J12T*/           {mfnp05.i bom_mstr bom_fsm_type "bom_fsm_type = "" "" "
.                        bom_parent "input part2"}       	
.
.	           if recno <> ? then do:
.
./*G301*/                assign
./*G301*/                    part2 = bom_parent
./*J16D* /*G301*/            desc3 = bom_desc          */
./*J16D*/                    um2   = bom_batch_um.
./*J16D* /*G301*/            desc4 = "".               */
.
./*J16D*/                if bom_desc <> "" then
./*J16D*/                   assign dest_desc = bom_desc.
./*J16D*/                else
./*J16D*/                   assign dest_desc = "".
.
./*G301*/                find pt_mstr no-lock where pt_part = bom_parent no-error.
./*G301*/                if available pt_mstr then do:
./*G301*/                    assign part2 = pt_part
./*J16D* /*G301*/                if desc3 = "" then assign */
./*G301*/                        desc3     = pt_desc1.
./*J16D* /*G301*/                desc4 = pt_desc2. */
./*J16D*/                        if dest_desc  = "" then
./*J16D*/                           dest_desc = pt_desc1.
./*G301*/                end.
.
./*J16D*	                display part2 desc3 desc4. */
./*J16D*/	        display part2 desc3 um2 dest_desc.
.	           end.    /* if recno <> ? */
./*J16D*/           else
./*J16D*/              assign um2 = um1.
.	       end.    /* if frame-field = "part2" */
.	       else do:
.	           status input.
.	           readkey.
.	           apply lastkey.
.	       end.
.              end.  /* editing */
.
./*J16D*/      if input part2 = "" then do:
./*J16D*/         {mfmsg.i 40 4}
./*J16D*/         next-prompt part2 with frame a.
./*J16D*/         undo,retry .
./*J16D*/      end.
.	
.	       assign
.	           desc1 = ""
./*J16D*	           desc2 = ""   */
.	           desc3 = ""
./*J16D*	           desc4 = ""   */
./*G301*/           from_batch_qty = 0
./*G301*/           from_batch_um = ""
.	           to_batch_qty = 1
./*G301*/           to_batch_um = ""
./*G301*/           formula_yn = no.
.
./*G301*/       find bom_mstr no-lock where bom_parent = part1 no-error.
./*G301*/       if available bom_mstr then /*G729*/  do:
./*J12T*/            /* SOURCE BOM FOR THE COPY MAY BE A SERVICE BOM */
./*J12T* /*G729*/    {fsbomv.i bom_parent 2}     */
./*G301*/            assign part1 = bom_parent
./*J16D* /*G301*/                   desc1 = bom_desc */
./*G301*/                   from_batch_qty = bom_batch
./*G301*/                   from_batch_um = bom_batch_um
./*G301*/                   formula_yn = bom_formula.
./*G729*/       end.    /* if available bom_mstr */
.
.	       find pt_mstr where pt_part = part1 no-lock no-error.
.	       if available pt_mstr then
./*G301*/       do:
.	           assign
.	               part1 = pt_part.
./*G301*/           if desc1 = "" then assign
.	              desc1 = pt_desc1.
./*J16D*	              desc2 = pt_desc2. */
./*G301*/           if from_batch_um = "" then
./*G301*/              from_batch_um = pt_um.
./*G790*/           config_yn = no.
./*G790*/           if pt_pm_code = "C" then config_yn = yes.
./*G301*/       end.     /* if available pt_mstr then do */
.
./*G301*/       if from_batch_qty = 0 then from_batch_qty = 1.
./*J16D*	       display part1 desc1 desc2 with frame a. */
./*J16D*/       display part1 desc1 um1 with frame a.
.
./*G301*/       find bom_mstr no-lock where bom_parent = part2 no-error.
./*G301*/       if available bom_mstr then do:
.
./*J12T*             SERVICE BOM INDICATION NO LONGER IS IN QAD_WKFL
./*G729*/           if can-find(qad_wkfl
./*G729*/               where qad_key1 = "bom_fsm"
./*G729*/               and   qad_key2 = part2)
.*J12T*/
./*J12T*/            /* PREVENT USER FROM COPYING INTO A SERVICE BOM */
./*J12T*/            if bom_fsm_type = "FSM"
./*G729*/            then do:
./*G729*/                {mfmsg.i 7492 3}
.                        /* CONTROLLED BY SERVICE/SUPPORT MODULE */
./*G729*/                next-prompt part2 with frame a.
./*G729*/                undo , retry .
./*G729*/            end.
.
./*G301*/            assign part2        = bom_parent
./*J16D* /*G301*/           desc3        = bom_desc */
./*J16D*/                   um2          = bom_batch_um
./*G301*/                   to_batch_qty = bom_batch
./*G301*/                   to_batch_um  = bom_batch_um.
./*G301*/            if not formula_yn then formula_yn = bom_formula.
.
./*J16D*/            if bom_desc <> "" then
./*J16D*/               assign dest_desc = bom_desc.
./*J16D*/            else
./*J16D*/               assign dest_desc = "".
.
./*G301*/       end.    /* if available bom_mstr */
.
.	       find pt_mstr where pt_part = part2 no-lock no-error.
.	       if available pt_mstr then
./*G301*/       do:
.
.	           assign part2 = pt_part.
./*G301*/           if desc3 = "" then assign
.	               desc3 = pt_desc1.
./*J16D*	               desc4 = pt_desc2. */
./*G301*/           if to_batch_um = "" then
./*G301*/               to_batch_um = pt_um.
./*J16D*/           if dest_desc  = "" then
./*J16D*/              dest_desc = pt_desc1.
./*G301*/       end.
.
./*G301*/       if not available bom_mstr and not available pt_mstr
./*G301*/       then assign to_batch_qty = from_batch_qty
./*G301*/                   to_batch_um = from_batch_um.
.
./*G301*/       if to_batch_qty = 0 then to_batch_qty = 1.
./*J16D*	       display part2 desc3 desc4 with frame a. */
./*J16D*/       display part2 desc3 um2 dest_desc with frame a.
.
.               hide frame b.
.
./*G301*/       /* Added section */
.               if not can-find (first ps_mstr where ps_par = part1) then do:
.	           {mfmsg02.i 100 3 """("" + part1 + "")""" }
.	           /* NO BILL OF MATERIAL EXISTS */
.	           undo, retry.
.               end.
.
./*J011*/       find first ps_mstr no-lock where  ps_par = part1
./*J011*/                              and  ps_ps_code = "J" no-error.
./*J011*/       if available ps_mstr then do:
./*J011*/            {mfmsg.i 6515 3}
.                    /* JOINT PRODUCT STRUCTURE MAY NOT BE COPIED */
./*J011*/            undo, retry.
./*J011*/       end.
.
./*J011*/       find first ps_mstr no-lock where  ps_par = part2
./*J011*/                              and  ps_ps_code = "J" no-error.
./*J011*/       if available ps_mstr then do:
./*J011*/            {mfmsg.i 6515 3}
.                    /* JOINT PRODUCT STRUCTURE MAY NOT BE COPIED */
./*J12T*/            next-prompt part2 with frame a.
./*J011*/            undo, retry.
./*J011*/       end.
.
./*G301*/       copy_conv = 1.
./*G301*/       if from_batch_um <> to_batch_um then do:
./*G301*/            {gprun.i ""gpumcnv.p""
.	               "(to_batch_um, from_batch_um, part1, output copy_conv)"}
./*G301*/            if copy_conv = ? then do:
./*G301*/                {mfmsg.i 33 4}
.                        /* NO UNIT OF MEASURE CONVERSION EXISTS */
./*G301*/                undo, retry.
./*G301*/            end.
./*G301*/       end.
./*G301*/       /* End of added section */
.
./*G301*/       /* Added section */
.	       if formula_yn then do:
.	           {mfmsg.i 263 3} /* Formula controlled */
.	           undo, retry.
.	       end.
./*G301*/       /* End of added section */
.
.               yn = yes.
.               if can-find (first ps_mstr where ps_par = part2) then do:
.	           {mfmsg02.i 200 2 """("" + part2 + "")""" }
.	           /* PART NUMBER HAS EXISTING BILL OF MATERIAL */
.	           input clear.
.	           yn = no.
.               end.
.
.            end.    /* do on error with frame a */
.
.
./*J16D*/    set dest_desc with frame a.
.
./*J16D*     IF THE DEST_DECS DEFAULTS TO ITEM DESC, AND THE USER DOES NOT
.            MODIFY IT, THEN DEST_DESC SHOULD NOT BE POPULATED              */
./*J16D*/    if ((available bom_mstr
./*J16D*/    and bom_desc = "") or (not available bom_mstr))
./*J16D*/    and dest_desc not entered
./*J16D*/    then
./*J16D*/       assign desc3 = "".
./*J16D*/    else
./*J16D*/       assign desc3 = dest_desc.
.
.            {mfmsg01.i 12 1 yn} /* "Is all information correct"*/
.            if yn = no then undo, retry.
.
.            found_any = no.
.
.            for each ps_from where ps_par = part1
./*G790/*G301*/ and ps_from.ps_end = ? or ps_from.ps_end >= today */
./*G790*/       and (ps_from.ps_end = ? or ps_from.ps_end >= today)
.            no-lock with frame b:
.
./*F671*/        /* added section */
.                if not can-find (bom_mstr where bom_parent = part2) then do:
.
.	           create bom_mstr.
.	           assign bom_parent = part2
.		          bom_userid = global_userid
.	                bom_mod_date = today
./*G301*/                   bom_batch = to_batch_qty
./*G301*/                bom_batch_um = to_batch_um
./*G301*/                    bom_desc = desc3
./*J12T*/                bom_fsm_type = " "
./*G301*/                 bom_formula = formula_yn.
.
.                end.
./*F671*/        /* end of added section */
.
./*J16D*/        else do:
./*J16D*/           find bom_mstr exclusive-lock where bom_parent = part2
./*J16D*/           no-error.
./*J16D*/           assign bom_desc = desc3.
./*J16D*/        end.
.
.	       pause 0 no-message.
.	       find ps_mstr where ps_mstr.ps_par = part2
.	           and ps_mstr.ps_comp = ps_from.ps_comp
.	           and ps_mstr.ps_ref = ps_from.ps_ref
./*G301*/           and ps_mstr.ps_start = ps_from.ps_start
./*G301*/           and ps_mstr.ps_end = ps_from.ps_end
.	           no-error.
.
.	       if not available ps_mstr then do:
.
./*G301*/            /* Start of added section */
.	           overlap-check: do:
.	             check1: do:
.		      for each ps_mstr no-lock where ps_mstr.ps_par = part2
.		          and ps_mstr.ps_comp = ps_from.ps_comp
.		          and ps_mstr.ps_ref = ps_from.ps_ref
.		          and
.		          ( (ps_mstr.ps_end = ? and ps_from.ps_end = ?)
.		              or (ps_mstr.ps_start = ? and ps_from.ps_start = ?)
.		              or ((ps_from.ps_start >= ps_mstr.ps_start
.		              or ps_mstr.ps_start = ?)
.		              and ps_from.ps_start <= ps_mstr.ps_end)
.		          or (ps_from.ps_start <= ps_mstr.ps_end
.		              and ps_from.ps_end >= ps_mstr.ps_start)
.		          ):
.		              leave check1.
.		      end.
.		      leave overlap-check.
.	             end.  /* check1 do */
.	             {mfmsg.i 122 4}     /* DATE RANGES MAY NOT OVERLAP */
.	             undo, next.
.	           end.    /* overlap-check */
./*G301*/           /* End of added section */
.
.	           create ps_mstr.
.	           assign
.	               ps_mstr.ps_par = part2
.	               ps_mstr.ps_comp = ps_from.ps_comp
.	               ps_mstr.ps_ref = ps_from.ps_ref
.	               ps_mstr.ps_scrp_pct = ps_from.ps_scrp_pct
.	               ps_mstr.ps_ps_code = ps_from.ps_ps_code
.	               ps_mstr.ps_lt_off = ps_from.ps_lt_off
.	               ps_mstr.ps_start = ps_from.ps_start
.	               ps_mstr.ps_end = ps_from.ps_end
.	               ps_mstr.ps_rmks = ps_from.ps_rmks
.	               ps_mstr.ps_op = ps_from.ps_op
.	               ps_mstr.ps_item_no = ps_from.ps_item_no
.	               ps_mstr.ps_mandatory = ps_from.ps_mandatory
.	               ps_mstr.ps_exclusive = ps_from.ps_exclusive
.	               ps_mstr.ps_process = ps_from.ps_process
.	               ps_mstr.ps_qty_type = ps_from.ps_qty_type
.	               ps_mstr.ps_fcst_pct = ps_from.ps_fcst_pct
.	               ps_mstr.ps_default = ps_from.ps_default
.	               ps_mstr.ps_group = ps_from.ps_group
.	               ps_mstr.ps_critical = ps_from.ps_critical
.	               ps_mstr.ps_user1 = ps_from.ps_user1
.	               ps_mstr.ps_user2 = ps_from.ps_user2.
.
.	           ps_recno = recid(ps_mstr).
.
.	           /* CYCLIC PRODUCT STRUCTURE CHECK */
.	           {gprun.i ""bmpsmta.p""}
.	           if ps_recno = 0 then do:
.	               {mfmsg02.i 206 2 ps_mstr.ps_comp}
.	               /* "CYCLIC PRODUCT STRUCTURE - "
.		           + part2 + " - " + ps_mstr.ps_comp + " NOT ADDED */
.	               pause 5.
.	               undo, next.
.	           end.
.
./*FL60*/            for each in_mstr exclusive-lock where in_part = ps_mstr.ps_comp:
./*FL60*/                if available in_mstr then in_level = 99999.
./*FL60*/            end.
.
./*FL60              /* LOW LEVEL CODE UPDATE */        */
./*FL60              {gprun.i ""bmpsmtb.p""}            */
.
.	       end.   /* if not available ps_mstr */
.
./*G301*/       /* Start of added section */
.	       find pt_mstr where pt_part = ps_mstr.ps_comp no-lock no-error.
.	       find bommstr no-lock where bommstr.bom_parent = ps_mstr.ps_comp
.	           no-error.
.
.	       if available pt_mstr then um = pt_um.
.	       else if available bommstr then um = bommstr.bom_batch_um.
.
.	       conv = 1.
.	       if um <> to_batch_um and ps_mstr.ps_qty_type = "P" then do:
.	           {gprun.i ""gpumcnv.p""
.	               "(um, to_batch_um, ps_mstr.ps_comp, output conv)"}
.	           if conv = ? then do:
.	               {mfmsg02.i 4600 4 """("" + ps_mstr.ps_comp + "")""" }
.	               /* COMPONENT UM IS DIFFERENT THAN PARENT UM */
.	               {mfmsg.i 33 4}  /* NO UOM CONVERSION EXISTS */
.	               pause 5.
.	               undo, next.
.	           end.
.	       end.
./*G301*/       /* End of added section */
.
./*G790*/       if config_yn and ps_from.ps_qty_per_b = 0 and ps_from.ps_qty_type = ""
./*G790*/       then qtyper_b = ps_from.ps_qty_per.
./*G790*/       else qtyper_b = ps_from.ps_qty_per_b.
.
./*G301*/       ps_mstr.ps_qty_per_b = ps_mstr.ps_qty_per_b +
./*G790/*G301*/         ((ps_from.ps_qty_per_b * copy_conv             */
./*G790*/               ((qtyper_b * copy_conv
./*G301*/                 * if ps_mstr.ps_qty_type = "" then 1 else to_batch_qty)
./*G301*/              / if ps_from.ps_qty_type = "" then 1 else from_batch_qty).
.
./*G301*/       ps_mstr.ps_qty_per =
./*F0P1/*G301*/          ps_mstr.ps_qty_per_b  */
./*J16D*/                ps_mstr.ps_qty_per +
./*F0P1*/                ps_from.ps_qty_per.
./*J16D* /*G301*/     / if ps_mstr.ps_qty_type = "" then 1 else to_batch_qty. */
.
./*G301*/       if ps_mstr.ps_qty_type = "P" then
./*G301*/           ps_mstr.ps_batch_pct =
./*G301*/               (ps_mstr.ps_qty_per_b * conv) / (.01 * to_batch_qty).
.
.	       display
.	           ps_mstr.ps_comp
.	           ps_mstr.ps_ref
.	           ps_mstr.ps_qty_per
.	           ps_mstr.ps_ps_code
.	           ps_mstr.ps_start
.	           ps_mstr.ps_end
.	       with frame b width 80 no-attr-space.
.
.	       found_any = yes.
.
.	       /* STORE MODIFY DATE AND USERID */
.	       ps_mstr.ps_mod_date = today.
.	       ps_mstr.ps_userid = global_userid.
.
.            end.     /* for each ps_mstr */
.
.            {mfmsg.i 7 1}
.
.            if found_any then do:
.                {inmrp.i &part=part2 &site=unknown_char}
.            end.
.
.         end.   /* repeat */
.*J1RB*/
