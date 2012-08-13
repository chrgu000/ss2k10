/* GUI CONVERTED from bmpscpm.p (converter v1.69) Tue Sep  9 10:20:11 1997 */
/* zzbmpscpm1.p - MANUFACTURING/SERVICE BILL OF MATERIAL COPY SUBPROGRAM         */
/* COPYRIGHT qad.inc. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK.       */
/*V8:ConvertMode=Maintenance                                                  */
/* REVISION: 8.5         CREATED: 05/07/97      BY: *J1RB* Sue Poland         */
/* REVISION: 8.5         CREATED: 08/07/97      BY: *J1QF* Russ Witt          */
/*!
    This routine is called by BMPSCP.P to copy "normal" BOM structures.  It
    is also called by FSPSCP.P to copy service BOM structures.

    Variations in performance of these two processes should be kept to a
    minimum.  Currently, the main difference may be found in the handling
    of the Destination Description field - as manufacturing BOMs generally
    expect the existence of pt_mstr, and service BOMs never expect pt_mstr,
    default logic for this field varies.

    The input value for bom-type identifies the type of structure being
    copied to.  It will be blank when manufacturing BOMs are being copied,
    and will contain "FSM" when service BOMs are being copied.  In either
    case, the Source BOM used for the copy may be of either type.
*/
/* REVISION: 8.5         MODIFIED: 10/23/03      BY: Kevin             */
/*For copy the bom in the same site*/
/*copy from zzbmpscpm.p*/

         {mfdeclre.i}

         /*define input parameter bom-type like bom_fsm_type.*/         /*kevin*/
        def shared var bom-type like bom_fsm_type.              /*kevin*/

         def shared var site1 like si_site.             /*kevin*/
         def shared var site2 like si_site.             /*kevin*/
        def shared var sel-yn as logic initial "No".                    /*kevin*/
         define new shared variable comp like ps_comp.
         define new shared variable ps_recno as recid.

         define shared variable part1          like ps_par label "源结构".
         define shared variable part2          like ps_par label "目标结构".
         define shared variable dest_desc      like pt_desc1
                                        label "目的地描述".
         define shared variable desc1          like pt_desc1 no-undo.
         define shared variable desc3          like pt_desc1 no-undo.
         define shared variable um1            like pt_um label "UM".
         define shared variable um2            like pt_um label "UM".
         define variable yn             like mfc_logical.
         define variable unknown_char   as character initial ?.
         define variable found_any      like mfc_logical.
         define variable to_batch_qty   like pt_batch.
         define variable from_batch_qty like pt_batch.
         define variable to_batch_um    like pt_um.
         define variable from_batch_um  like pt_um.
         define variable conv           like ps_um_conv.
         define variable um             like pt_um.
         define variable copy_conv      like um_conv.
         define variable formula_yn     like bom_formula.
         define variable config_yn      like mfc_logical.
         define variable qtyper_b       like ps_qty_per_b.
         define variable msgnbr         as   integer no-undo.

         {fsconst.i}    /* SSM CONSTANTS */

         define shared buffer ps_from for ps_mstr.
         define buffer bommstr for bom_mstr.

         def var ps_from_recno as recid format "->>>>>>9".              /*kevin*/
        define variable first_sw_call as logical initial true.      /*kevin*/
        def var framename as char format "x(40)".           /*kevin*/  

         
/*GUI preprocessor Frame A define */
&SCOPED-DEFINE PP_FRAME_NAME A

FORM /*GUI*/ 
            
 RECT-FRAME       AT ROW 1 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1 COLUMN 3 NO-LABEL VIEW-AS TEXT SIZE-PIXELS 1 BY 1
 SKIP(.1)  /*GUI*/
part1          colon 30
            desc1          no-label at 52
            um1            colon 30
            part2          colon 30
            desc3          no-label at 52
            um2            colon 30
            dest_desc      colon 30
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

/*added by kevin,10/14/2003*/
form
 SKIP(.1)  /*GUI*/
   ps_from.ps__chr02 format "x(2)" label "选择"
   /*ps_from.ps_par*/
   ps_from.ps_comp
  ps_from.ps_ref
  ps_from.ps_start
  ps_from.ps_qty_per
  ps_from.ps_op
   skip(.1)
   with frame c center /*column 5*/ row 12 overlay
   width 80 title framename THREE-D stream-io /*GUI*/.

/*marked by kevin,10/23/2003
         repeat:
/*GUI*/ if global-beam-me-up then undo, leave.

            clear frame a no-pause.
/*GUI*/ RECT-FRAME-LABEL:SCREEN-VALUE in frame a = F-a-title.
            display part1
                    part2
            with frame a.
            do on error undo, retry with frame a:
/*GUI*/ if global-beam-me-up then undo, leave.


              assign dest_desc = "".

              set part1
                  part2
              with frame a editing:

                 if frame-field = "part1" then do:
                   /* FIND NEXT/PREVIOUS RECORD - ALL BOM_MSTR'S ARE
                      VALID FOR "SOURCE" */
                   {mfnp.i bom_mstr part1 bom_parent part1
                           bom_parent bom_parent}

                   if recno <> ? then do:

                      assign
                        part1 = bom_parent
                        desc1 = bom_desc
                        um1   = bom_batch_um.

                      if bom-type <> fsm_c then do:
                         find pt_mstr where pt_part = bom_parent
                         no-lock no-error.

                         if available pt_mstr then
/*J1QF*/                 do:
                            assign part1 = pt_part.
/*J1QF*                            desc1 = pt_desc1.  */
/*J1QF*/                    if bom_desc = "" then desc1 = pt_desc1.
/*J1QF*/                 end.
                      end.   /* if bom-type <> fsm_c */

                      display part1
                              desc1
                              um1
                      with frame a.

                   end.    /* if recno <> ? */
                   recno = ?.

                 end.   /* if frame-field = "part1" */

                 else if frame-field = "part2" then do:

                   /* FIND NEXT/PREVIOUS RECORD - BOMS TO DISPLAY DEPEND
                   IN THE INPUT BOM-TYPE PARAMETER */
                   {mfnp05.i bom_mstr bom_fsm_type "bom_fsm_type = bom-type "
                        bom_parent "input part2"}

                   if recno <> ? then do:

                      assign
                        part2 = bom_parent
/*J1QF*/                desc3 = bom_desc
                        um2   = bom_batch_um.

                      if bom_desc <> "" then
                      assign dest_desc = bom_desc.
                      else
                      assign dest_desc = "".

                      if bom-type <> fsm_c then do:
                         find pt_mstr no-lock where pt_part = bom_parent
                         no-error.
                         if available pt_mstr then do:
                            assign part2 = pt_part.
/*J1QF*/                    if bom_desc = "" then assign
                                   desc3     = pt_desc1.
                            if dest_desc  = "" then
                            dest_desc = pt_desc1.
                         end.    /* if available pt_mstr */
                      end.    /* if bom-type <> fsm_c */

                      display part2
                              desc3
                              um2
                              dest_desc
                      with frame a.

                   end.    /* if recno <> ? */

                   else

                   assign um2 = um1.

                 end.    /* if frame-field = "part2" */
                 else do:
                   status input.
                   readkey.
                   apply lastkey.
                 end.
              end.  /* editing */

              if part2 = "" then do:
                 {mfmsg.i 40 3}     /* BLANK NOT ALLOWED */
                 next-prompt part2 with frame a.
                 undo,retry .
              end.

              if bom-type = fsm_c and
              can-find(pt_mstr where pt_part = part2) then do:
                {mfmsg.i 7494 3}
                /* SSM STRUCTURE CODE CANNOT EXIST IN ITEM MASTER */
                next-prompt part2 with frame a.
                undo, retry.
              end.

              assign
                desc1 = ""
                desc3 = ""
                from_batch_qty = 0
                from_batch_um = ""
                to_batch_qty = 1
                to_batch_um = ""
                config_yn  = no
                formula_yn = no.

              find bom_mstr no-lock where bom_parent = part1 no-error.
              if available bom_mstr then
                    assign part1            = bom_parent
/*J1QF*/                   desc1            = bom_desc
                           from_batch_qty   = bom_batch
                           from_batch_um    = bom_batch_um
                           formula_yn       = bom_formula.

               /* SOURCE AND DESTINATION BOM CODES MAY BE NEITHER
                    FORMULA-CONTROLLED NOR JOINT/CO/BY-PRODUCTS. */
               if formula_yn then do:
                 {mfmsg.i 263 3} /* FORMULA CONTROLLED */
                 undo, retry.
               end.
               find first ps_mstr no-lock where  ps_par = part1
                                   and  ps_ps_code = "J" no-error.
               if available ps_mstr then do:
                    {mfmsg.i 6515 3}
                    /* JOINT PRODUCT STRUCTURE MAY NOT BE COPIED */
                    undo, retry.
               end.

               if not can-find (first ps_mstr where ps_par = part1) then do:
                  {mfmsg02.i 100 3 """("" + part1 + "")""" }
                  /* NO BILL OF MATERIAL EXISTS */
                  undo, retry.
               end.

               /* FOR MANUFACTURING BOM'S, DEFAULT THESE VALUES FROM PT_MSTR
                 (IF AVAILABLE).  FOR SERVICE BOM'S, USE ONLY BOM_MSTR. */
               if bom-type <> fsm_c then do:
                  find pt_mstr where pt_part = part1 no-lock no-error.
                  if available pt_mstr then do:
                     if desc1 = "" then assign
                        desc1 = pt_desc1.
                     if from_batch_um = "" then
                        from_batch_um = pt_um.
                     if pt_pm_code = "C" then config_yn = yes.
                  end.     /* if available pt_mstr then do */
               end.     /* if bom-type <> fsm_c */
               else
                  assign dest_desc = bom_desc.

               if from_batch_qty = 0 then from_batch_qty = 1.
               display part1
                       desc1
                       um1
               with frame a.

               find bom_mstr no-lock where bom_parent = part2 no-error.
               if available bom_mstr then do:

                    /* PREVENT USER FROM COPYING INTO THE WRONG BOM TYPE */
                    if bom_fsm_type <> bom-type
                    then do:
                        if bom_fsm_type = fsm_c then    /* FROM FSPSCP.P */
                            msgnbr = 7492. /* CONTROLLED BY SERVICE/SUPPORT MODULE */
                        else msgnbr = 7493.             /* ELSE, BMPSCP.P */
                            /* THIS IS NOT AN SSM PRODUCT STRUCTURE CODE */
                        {mfmsg.i msgnbr 3}
                        next-prompt part2 with frame a.
                        undo, retry .
                    end.

                    assign part2        = bom_parent
/*J1QF*/                   desc3        = bom_desc
                           um2          = bom_batch_um
                           formula_yn   = bom_formula
                           to_batch_qty = bom_batch
                           to_batch_um  = bom_batch_um.

                    /* FOR SERVICE BOM'S, THERE'S NO REASON TO LEAVE DEST_DESC
                        (AND HENCE BOM_DESC FOR THE NEW BOM CODE) BLANK.  FOR
                        MANUFACTURING BOM'S, IF BOM_DESC IS BLANK, DEFAULT
                        DESCRIPTION IS PULLED FROM THE ASSOCIATED ITEM. */
                    if bom_desc <> "" then
                       assign dest_desc = bom_desc.
                    else if bom-type <> fsm_c then
                       assign dest_desc = "".

               end.    /* if available bom_mstr */

               if formula_yn then do:
                   {mfmsg.i 263 3} /* FORMULA CONTROLLED */
                   next-prompt part2 with frame a.
                   undo, retry.
               end.

               if bom-type <> fsm_c then do:
                  find pt_mstr where pt_part = part2 no-lock no-error.
                  if available pt_mstr then do:

                        if desc3 = "" then assign
                       desc3 = pt_desc1.
                        if to_batch_um = "" then
                           to_batch_um = pt_um.
                        if dest_desc  = "" then
                           dest_desc = pt_desc1.

                  end.     /* if available pt_mstr */
               end.     /* if bom-type <> fsm_c */

               if not available bom_mstr and not available pt_mstr
               then assign to_batch_qty = from_batch_qty
                           to_batch_um = from_batch_um.

               if to_batch_qty = 0 then to_batch_qty = 1.

               display part2
                       desc3
                       um2
                       dest_desc
               with frame a.

               hide frame b.

               find first ps_mstr no-lock where  ps_par = part2
                                and  ps_ps_code = "J" no-error.
               if available ps_mstr then do:
                    {mfmsg.i 6515 3}
                    /* JOINT PRODUCT STRUCTURE MAY NOT BE COPIED */
                    next-prompt part2 with frame a.
                    undo, retry.
               end.

               copy_conv = 1.
               if from_batch_um <> to_batch_um then do:
                    {gprun.i ""gpumcnv.p""
                   "(to_batch_um, from_batch_um, part1, output copy_conv)"}
/*GUI*/ if global-beam-me-up then undo, leave.

                    if copy_conv = ? then do:
                        {mfmsg.i 33 4}
                        /* NO UNIT OF MEASURE CONVERSION EXISTS */
                        undo, retry.
                    end.
               end.    /* if from_bacth_um <> to_batch_um */

               yn = yes.
               if can-find (first ps_mstr where ps_par = part2) then do:
               {mfmsg02.i 200 2 """("" + part2 + "")""" }
               /* PART NUMBER HAS EXISTING BILL OF MATERIAL */
               input clear.
               yn = no.
               end.

               set dest_desc with frame a.

               /* AS ABOVE, MANUFACTURING AND SERVICE BOMS HAVE DIFFERENT
                    HANDLING FOR BOM_DESC */
               if bom-type <> fsm_c then do:

                    /* IF THE DEST_DESC DEFAULTS TO ITEM DESC, AND THE USER DOES NOT
                        MODIFY IT, THEN DEST_DESC SHOULD NOT BE POPULATED    */
                    if ((available bom_mstr
                    and bom_desc = "") or (not available bom_mstr))
                    and dest_desc not entered
                    then
                        assign desc3 = "".
                    else
                        assign desc3 = dest_desc.
               end.     /* if bom-type <> fsm_c */
               else assign desc3 = dest_desc.

            end.
/*GUI*/ if global-beam-me-up then undo, leave.
    /* do on error with frame a */

/*added by kevin, 10/22/2003 - for copy ps by selection*/
         sw_block:
         do on endkey undo, leave:
              message "请按 'enter' or 'space', 键去选择成本中心代码.".         
              framename = "第一层子零件选择".      
         /* INCLUDE SCROLLING WINDOW TO ALLOW THE USER TO SCROLL      */
               /* THROUGH (AND SELECT FROM) EXISTING PAYMENTS APPLICATIONS  */
               {swselect.i
                  &detfile      = ps_from
                 &detkey = "where"
                 &searchkey = "ps_from.ps_par = part1 and (ps_from.ps_end = ? or ps_from.ps_end >= today)"
                  &scroll-field = ps_from.ps__chr02
                  &framename    = "c"
                  &framesize    = 10
                  &sel_on       = ""*""
                  &sel_off      = """"
                  &display1   = ps_from.ps__chr02
                  &display2     = ps_from.ps_comp
                  &display4     = ps_from.ps_ref
                  &display4     = ps_from.ps_start
                  &display5     = ps_from.ps_qty_per
                  &display6     = ps_from.ps_op
                  &display7     = """"
                  &display8     = """"
                  &display9     = """"
                  &exitlabel    = sw_block
                  &exit-flag    = first_sw_call 
                  &record-id    = ps_from_recno
                   }
           if keyfunction(lastkey) = "end-error"
            or lastkey = keycode("F4")
            or keyfunction(lastkey) = "."
            or lastkey = keycode("CTRL-E") then do:
               undo sw_block, leave.
            end.        
       end.
       
       hide message no-pause.
          
/*end added by kevin*/

            {mfmsg01.i 12 1 yn} /* IS ALL INFORMATION CORRECT */
            if yn = no then undo, retry.

/*added by kevin, 10/23/2003*/
          if site1 = site2 then 
                {gprun.i ""zzbmpscpm1.p"" "(input bom-type)"}
          esle  {gprun.i ""zzbmpscpm2.p"" "(input bom-type)"}      
/*end added by kevin, 10/23/2003*/

end marked by kevin,10/23/2003*/


            found_any = no.

            for each ps_from where ps_from.ps_par = part1
               and (ps_from.ps_end = ? or ps_from.ps_end >= today)
               and ((ps_from.ps__chr02 <> "" and sel-yn) or not sel-yn)                      /*kevin*/
            no-lock with frame b:
/*GUI*/ if global-beam-me-up then undo, leave.


               if not can-find (bom_mstr where bom_parent = part2
                  and bom_fsm_type = bom-type) then do:

                  create bom_mstr.
                  assign  bom_parent = part2
                          bom_userid = global_userid
                        bom_mod_date = today
                           bom_batch = to_batch_qty
                        bom_batch_um = to_batch_um
                            bom_desc = desc3
                        bom_fsm_type = bom-type
                         bom_formula = formula_yn.
                  if recid(bom_mstr) = -1 then .
                  find bommstr where bommstr.bom_parent = part1
                       no-lock no-error.
                  if available bommstr then
                       assign bom_mstr.bom_user1   =  bommstr.bom_user1
                              bom_mstr.bom_user2   =  bommstr.bom_user2
                              bom_mstr.bom__chr01  =  bommstr.bom__chr01
                              bom_mstr.bom__chr02  =  bommstr.bom__chr02
                              bom_mstr.bom__chr03  =  bommstr.bom__chr03
                              bom_mstr.bom__chr04  =  bommstr.bom__chr04
                              bom_mstr.bom__chr05  =  bommstr.bom__chr05
                              bom_mstr.bom__dec01  =  bommstr.bom__dec01
                              bom_mstr.bom__dec02  =  bommstr.bom__dec02
                              bom_mstr.bom__dte01  =  bommstr.bom__dte01
                              bom_mstr.bom__dte02  =  bommstr.bom__dte02
                              bom_mstr.bom__log01  =  bommstr.bom__log01.

               end.

               else do:
                   find bom_mstr exclusive-lock where bom_mstr.bom_parent = part2.
                   assign bom_mstr.bom_desc = desc3.
               end.

               pause 0 no-message.
               find ps_mstr where ps_mstr.ps_par = part2
               and ps_mstr.ps_comp = ps_from.ps_comp
               and ps_mstr.ps_ref = ps_from.ps_ref
               and ps_mstr.ps_start = ps_from.ps_start
               and ps_mstr.ps_end = ps_from.ps_end
               no-error.

               if not available ps_mstr then do:
                 overlap-check: do:
                 check1: do:
                   for each ps_mstr no-lock where ps_mstr.ps_par = part2
                   and ps_mstr.ps_comp = ps_from.ps_comp
                   and ps_mstr.ps_ref = ps_from.ps_ref
                   and (  (ps_mstr.ps_end   = ? and ps_from.ps_end   = ?)
                   or (ps_mstr.ps_start = ? and ps_from.ps_start = ?)
                   or (ps_mstr.ps_start = ? and ps_mstr.ps_end   = ?)
                   or (ps_from.ps_start = ? and ps_from.ps_end   = ?)
                   or ((ps_from.ps_start >= ps_mstr.ps_start
                   or ps_mstr.ps_start = ?)
                   and ps_from.ps_start <= ps_mstr.ps_end)
                   or (ps_from.ps_start <= ps_mstr.ps_end
                   and ps_from.ps_end >= ps_mstr.ps_start)
                   ):
                      leave check1.
                   end.    /* for each ps_mstr */
                   leave overlap-check.
                   end.  /* check1 do */
                   {mfmsg.i 122 4}     /* DATE RANGES MAY NOT OVERLAP */
                   {mfmsg03.i 1774 1 ps_mstr.ps_comp """" """"}
                   /* COMPONENT # NOT COPIED */
                   undo, next.
                 end.    /* overlap-check */

                 create ps_mstr.
                 assign
                   ps_mstr.ps_par = part2
                   ps_mstr.ps_comp = ps_from.ps_comp
                   ps_mstr.ps_ref = ps_from.ps_ref
                   ps_mstr.ps_scrp_pct = ps_from.ps_scrp_pct
                   ps_mstr.ps_ps_code = ps_from.ps_ps_code
                   ps_mstr.ps_lt_off = ps_from.ps_lt_off
                   ps_mstr.ps_start = ps_from.ps_start
                   ps_mstr.ps_end = ps_from.ps_end
                   ps_mstr.ps_rmks = ps_from.ps_rmks
                   ps_mstr.ps_op = ps_from.ps_op
                   ps_mstr.ps_item_no = ps_from.ps_item_no
                   ps_mstr.ps_mandatory = ps_from.ps_mandatory
                   ps_mstr.ps_exclusive = ps_from.ps_exclusive
                   ps_mstr.ps_process = ps_from.ps_process
                   ps_mstr.ps_qty_type = ps_from.ps_qty_type
                   ps_mstr.ps_fcst_pct = ps_from.ps_fcst_pct
                   ps_mstr.ps_default = ps_from.ps_default
                   ps_mstr.ps_group = ps_from.ps_group
                   ps_mstr.ps_critical = ps_from.ps_critical
                   ps_mstr.ps_user1 = ps_from.ps_user1
                   ps_mstr.ps_user2 = ps_from.ps_user2.

                 ps_recno = recid(ps_mstr).

                 /* CYCLIC PRODUCT STRUCTURE CHECK */
                 /*{gprun.i ""bmpsmta.p""}*/                          /*marked by kevin,2003/12*/
                 {gprun.i ""zzbmpsmta.p""}                            /*added by kevin,2003/12*/
/*GUI*/ if global-beam-me-up then undo, leave.

                 if ps_recno = 0 then do:
                   {mfmsg02.i 206 2 ps_mstr.ps_comp}
                   /* "CYCLIC PRODUCT STRUCTURE - "
                   + part2 + " - " + ps_mstr.ps_comp + " NOT ADDED */
                   pause 5.
                   undo, next.
                 end.

                 for each in_mstr exclusive-lock where
                 in_part = ps_mstr.ps_comp:
                   if available in_mstr then
                   assign in_level = 99999
                   in_mrp = true.
                 end.

               end.   /* if not available ps_mstr */

               find pt_mstr where pt_part = ps_mstr.ps_comp no-lock no-error.
               find bommstr no-lock where bommstr.bom_parent = ps_mstr.ps_comp
               no-error.

               if available pt_mstr then um = pt_um.
               else if available bommstr then um = bommstr.bom_batch_um.

               conv = 1.
               if um <> to_batch_um and ps_mstr.ps_qty_type = "P" then do:
                  {gprun.i ""gpumcnv.p""
                  "(um, to_batch_um, ps_mstr.ps_comp, output conv)"}
/*GUI*/ if global-beam-me-up then undo, leave.

                  if conv = ? then do:
                    {mfmsg02.i 4600 4 """("" + ps_mstr.ps_comp + "")""" }
                    /* COMPONENT UM IS DIFFERENT THAN PARENT UM */
                    {mfmsg.i 33 4}  /* NO UOM CONVERSION EXISTS */
                    pause 5.
                    undo, next.
                  end.
               end.    /* if um <> to_batch_um and... */

               if config_yn
               and ps_from.ps_qty_per_b = 0
               and ps_from.ps_qty_type = ""
               then qtyper_b = ps_from.ps_qty_per.
               else qtyper_b = ps_from.ps_qty_per_b.

               ps_mstr.ps_qty_per_b = ps_mstr.ps_qty_per_b +
                       ((qtyper_b * copy_conv
                         * if ps_mstr.ps_qty_type = "" then 1 else to_batch_qty)
                         / if ps_from.ps_qty_type = "" then 1 else from_batch_qty).

               ps_mstr.ps_qty_per =
                        ps_mstr.ps_qty_per +
                        ps_from.ps_qty_per.

               if ps_mstr.ps_qty_type = "P" then
                  ps_mstr.ps_batch_pct =
                       (ps_mstr.ps_qty_per_b * conv) / (.01 * to_batch_qty).

               display
                 ps_mstr.ps_comp
                 ps_mstr.ps_ref
                 ps_mstr.ps_qty_per
                 ps_mstr.ps_ps_code
                 ps_mstr.ps_start
                 ps_mstr.ps_end
               with frame b width 80 no-attr-space
               stream-io.                                 /*kevin*/

               found_any = yes.

               /* STORE MODIFY DATE AND USERID */
               ps_mstr.ps_mod_date = today.
               ps_mstr.ps_userid = global_userid.

             ps_mstr.ps__chr01 = ps_from.ps__chr01.           /*kevin,11/06/2003 for site control*/

            end.
/*GUI*/ if global-beam-me-up then undo, leave.
     /* for each ps_mstr */

            {mfmsg.i 7 1}

            if found_any then do:
                {inmrp.i &part=part2 &site=unknown_char}
            end.

/*marked by kevin,10/23/2003

         end.
/*GUI*/ if global-beam-me-up then undo, leave.
   /* repeat */
end marked by kevin,10/23/2003*/
