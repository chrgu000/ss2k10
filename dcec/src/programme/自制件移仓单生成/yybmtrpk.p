/* GUI CONVERTED from yybmtrpk.p (converter v1.75) Mon Apr 1 2008       */
/* yybmtrpk.p - PICKLIST transfer                                       */
/* Copyright 1986-2002 AtosOrigin Inc.,P.R.C.                           */
/* All rights reserved worldwide.  This is an unpublished work.         */
/*F0PN*//*V8:ConvertMode=Report                                         */
/* REVISION: 9.1 LAST MODIFIED: 04/01/08   BY: *Frank Sun* frk          */

     /* DISPLAY TITLE */

/*GUI preprocessor directive settings */
&SCOPED-DEFINE PP_GUI_CONVERT_MODE REPORT

     {mfdtitle.i "b+ "}

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE yybmtrpk_p_1 "Quantity"
/* MaxLen: Comment: */

&SCOPED-DEFINE yybmtrpk_p_2 "As of Date"
/* MaxLen: Comment: */

&SCOPED-DEFINE yybmtrpk_p_4 "Op"
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */

     define new shared workfile pkdet NO-UNDO
/*G1H5*/    field pkpart like ps_comp
/*H100*/    field pkop as integer
/*G1H5*/                          format ">>>>>9"
        field pkstart like pk_start
        field pkend like pk_end
        field pkqty like pk_qty
/*F0HQ*/    field pkbombatch like bom_batch
        field pkltoff like ps_lt_off.

     define new shared variable comp like ps_comp.
/*GH69*/ define new shared variable eff_date as date label {&yybmtrpk_p_2}.
     define variable qty like pk_qty.
/*G1H5*/ define variable part like ps_par.
/*G1H5*/ define variable last_part like ps_par.
     define variable des like pt_desc1.
     define variable um like pt_um.
     define variable loc like pt_loc.
/*G234*/ define new shared variable site like in_site
/*H100*/    no-undo.
/*G265*/ define new shared variable transtype as character format "x(4)".
/*G1H5*/ define variable op as integer label {&yybmtrpk_p_4} format ">>>>>9".
/*FM19*/ define new shared variable phantom like mfc_logical initial yes.

/*H0PC*/ define variable ln_to_disp as integer.
/*J2N9*/ define variable aval as logical no-undo.
/*J2N9*/ define variable batchqty like bom_batch no-undo.
/*J2N9*/ define variable batchdesc1 like pt_desc1 no-undo.
/*J2N9*/ define variable batchdesc2 like pt_desc2 no-undo.
{gplabel.i &ClearReg=yes} /* EXTERNAL LABEL INCLUDE */

/*N0F3*/ define variable disp_pkqty AS DECIMAL /*like pk_qty*/ FORMAT "->>>>>>>9" no-undo.
         DEF VAR trpknbr AS CHAR FORMAT "x(22)" LABEL "移仓单号".
         DEF VAR ccdate AS CHAR.
         DEF VAR pcdate AS CHAR.
         DEF VAR prouting LIKE ro_routing.
         DEF VAR pwkctr LIKE ro_wkctr.
         DEF VAR puttrpknbr AS CHAR.
         DEF STREAM trpk.
         DEF VAR notewkctr LIKE mfc_logical INIT NO COLUMN-LABEL "说明" 
             VIEW-AS RADIO-SET RADIO-BUTTONS 不注明加工库位,NO,注明加工库位,YES.
         DEF VAR loc1 LIKE pt_loc. 

/*H100*/ {gpxpld01.i "new shared"}

     eff_date = today.

/*G265*/ transtype = "BM".

     part = global_part.
/*G234*/ site = global_site.
     
/*GUI preprocessor Frame A define */
&SCOPED-DEFINE PP_FRAME_NAME A

FORM /*GUI*/ 
        
 RECT-FRAME       AT ROW 1 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1 COLUMN 3 NO-LABEL VIEW-AS TEXT SIZE-PIXELS 1 BY 1
 SKIP(.1)  /*GUI*/
            part colon 15
/*H0PC*/    pt_desc1 no-label
            trpknbr COLON 58 NO-ATTR-SPACE
/*H0PC*/    eff_date colon 15
/*H0PC*/    site
        qty
        pt_um no-label no-attr-space
        notewkctr COLON 15  
        loc1 
/*frk*    op colon 68*/
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
/*G234*/ /* CHANGED FRAME */

/*K110*/ {wbrp02.i}
     repeat
/*G265*/ with frame a:
         ASSIGN trpknbr = "" loc1 = "" notewkctr = NO.
         DISP trpknbr loc1 notewkctr WITH FRAME a.
/*K110*/ if c-application-mode <> 'web' then
        update part eff_date  site qty notewkctr /*trpknbr*/ with frame a editing:

/*G234*/       if frame-field = "part" then do:
          /* FIND NEXT/PREVIOUS RECORD */
/*G265            {mfnp.i ps_mstr part   ps_par part   ps_par ps_par} */
/*G265*/          {mfnp.i bom_mstr part bom_parent part bom_parent bom_parent}
          if recno <> ? then do:
/*G265               part = ps_par. */
/*G265*/             part = bom_parent.

             /* GET DESCRIPTION,UM,BATCH QTY */
             {gprun.i ""fmrodesc.p"" "(input part,
                                       output batchdesc1,
                                       output batchdesc2,
                                       output batchqty,
                                       output um,
                                       output aval)"}

             for first pt_mstr
                 fields (pt_bom_code pt_desc1 pt_desc2 pt_joint_type
                         pt_loc pt_ord_qty pt_part pt_um) no-lock
                 where pt_part = part:
             end. /* FOR FIRST pt_mstr */

             if transtype = "BM" then do:
                if available pt_mstr then
                   batchqty = pt_ord_qty.
                else
                   batchqty = 0.
             end. /* IF TRANSTYPE = "BM" */

             if batchqty = 0 then batchqty = 1.

             display part
                     batchdesc1 @ pt_desc1
                     batchqty   @ qty
                     um         @ pt_um
                     with frame a.

/*J2N9*  END ADD SECTION */
             recno = ?.
          end.
/*G234*/       /* Added section */
           end.
           else
           if frame-field = "site" then do:
          /* FIND NEXT/PREVIOUS RECORD */
          {mfnp.i si_mstr site   si_site site si_site si_site}
          if recno <> ? then do:
             site = si_site.
             display site with frame a.
             recno = ?.
          end.
           end.
           else do:
          readkey.
          apply lastkey.
           end.
/*G234*/       /* End of added section */
        end.

/*K110*/ {wbrp06.i &command = update &fields = "part eff_date site qty"
      &frm = "a"}

/*K110*/ if (c-application-mode <> 'web') or
/*K110*/ (c-application-mode = 'web' and
/*K110*/ (c-web-request begins 'data')) then do:

/*G265*/    assign part.
/*frk*/     IF notewkctr THEN do:
            UPDATE loc1 WITH FRAME a.
/*frk*/     FIND FIRST loc_mstr NO-LOCK WHERE loc_site = site 
                   AND loc_loc = loc1 NO-ERROR NO-WAIT.
            IF NOT AVAIL loc_mstr THEN DO:
               {mfmsg.i 709 3}
                UNDO, RETRY.
            END.
/*frk*/     END.
/*frk*/     ELSE DO:
                loc1 = "".
/*frk*/     END.
            DISP loc1 WITH FRAME a.
/*G265*/    find bom_mstr where bom_parent = part no-lock no-error.
        find pt_mstr where pt_part = part no-lock no-error.
/*G265      if not available pt_mstr then do:  */
/*G265*/    if not available pt_mstr and not available bom_mstr then do:
           {mfmsg.i 17 3} /*ERROR: ITEM NUMBER NOT FOUND.*/
/*K110*/       if c-application-mode = 'web' then return.
           undo, retry.
        end.

/*G234*/    /* Added section */
        find si_mstr no-lock where si_site = site no-error.
        if not available si_mstr then do:
           {mfmsg.i 708 3}
/*G265*/
/*K110*/ if c-application-mode = 'web' then return.
/*K110*/ else next-prompt site with frame a.
           undo, retry.
        end.

               /* GET DESCRIPTION,UM,BATCH QTY */
               {gprun.i ""fmrodesc.p"" "(input (input part),
                                         output batchdesc1,
                                         output batchdesc2,
                                         output batchqty,
                                         output um,
                                         output aval)"}

                if qty = 0 then do:

                   if transtype = "BM" then do:

                      if available pt_mstr then do:

                         for first ptp_det
                             fields (ptp_bom_code ptp_joint_type ptp_ord_qty
                                     ptp_part ptp_site) no-lock
                             where ptp_part = pt_part
                             and   ptp_site = site:
                         end. /* FOR FIRST ptp_det */

                         if available ptp_det then
                            qty = ptp_ord_qty.
                         else
                            qty = pt_ord_qty.

                      end. /* IF AVAILABLE pt_mstr */

                   end. /* IF TRANSTYPE = "BM" */

                   else do:

                      qty = batchqty.

                   end. /* IF TRANSTYPE = "FM" */

                   if qty = 0 then qty = 1.

                end. /* IF qty = 0 THEN DO */

                display batchdesc1 @ pt_desc1
                        qty
                        um         @ pt_um
                        with frame a.
/*J2N9*  END ADD SECTION */
        hide frame b.

/*K110*/ end.
        

/*frk*    calculate location tranfer number  */
         ASSIGN trpknbr = ""
         ccdate = SUBSTRING(STRING(TODAY),7,2) + SUBSTRING(STRING(TODAY),4,2) + SUBSTRING(STRING(TODAY),1,2).
         FIND FIRST CODE_mstr WHERE CODE_fldname = "tr_pk_list_nbr" NO-ERROR NO-WAIT.
         IF AVAIL CODE_mstr THEN DO:
             IF ccdate <> CODE_cmmt THEN DO:
                ASSIGN CODE_cmmt  = ccdate
                       CODE_value = "001".
                       /*trpknbr = "ML" + ccdate + part + "-" + CODE_value.*/
             END.
             ELSE DO:
                 CODE_value = string(int(CODE_value) + 1,"999").
                 /*ASSIGN trpknbr = "ML" + ccdate + "C-" + CODE_value. */
             END.
             trpknbr = "ML" + ccdate + /*"-" +  + part +*/ "-" + CODE_value. 
         END.
         DISP trpknbr WITH FRAME a.
         RELEASE CODE_mstr.

/*frk*   calculate end                       */

/* SELECT PRINTER */
            {mfselprt.i "terminal" 80}
/*GUI*/ RECT-FRAME:HEIGHT-PIXELS in frame a = FRAME a:HEIGHT-PIXELS - RECT-FRAME:Y in frame a - 2.


        comp = part.
/*frk*/ prouting = part.
/*G234*/    /* Added section*/
        find ptp_det no-lock where ptp_part = part
        and ptp_site = site no-error.
        if available ptp_det then do:
/*J020*/       if index("1234",ptp_joint_type) > 0 then do:
/*J020*/          {mfmsg.i 6519 1}
/*J020*/          /* MAY NOT INQUIRE/REPORT ON JOINT PRODUCTS */
/*K110*/          if c-application-mode = 'web' then return.
/*J020*/          undo, retry.
/*J020*/       end.
           if ptp_bom_code > "" then comp = ptp_bom_code.
/*frk*/    IF ptp_routing > "" THEN prouting = ptp_routing.
        end.
        else
/*G265*/    if available pt_mstr then
        do:
/*J020*/       if index("1234",pt_joint_type) > 0 then do:
/*J020*/          {mfmsg.i 6519 1}
/*J020*/          /* MAY NOT INQUIRE/REPORT ON JOINT PRODUCTS */
/*K110*/          if c-application-mode = 'web' then return.
/*J020*/          undo, retry.
/*J020*/       end.
           if pt_bom_code > "" then comp = pt_bom_code.
/*frk*/    IF pt_routing  > "" THEN prouting = pt_routing.
        end.
/*G234*/    /* End of added section*/

        /* explode part by standard picklist logic */
        if comp <> last_part then do:
           hide frame b no-pause.

/*H357*/          {gprun.i ""woworla2.p""}

        end.

/*G1H5** /*H100*/    if op = 999 then op = 0. **/

        puttrpknbr = "c:\appeb2\" + string(trpknbr) + ".txt".

/*frk*/ OUTPUT STREAM trpk TO value(puttrpknbr).

/*frk*/ PUT STREAM trpk UNFORMATTED "移仓单号,地点,生效日期,子零件,缺省库位,车间库位,数量," SKIP.

        for each pkdet
        where eff_date = ? or (eff_date <> ?
        and (pkstart = ? or pkstart <= eff_date)
/*H100      and (pkend = ? or eff_date <= pkend)) */
/*H100*/    and (pkend = ? or eff_date <= pkend)
/*H100*/    and ((op = pkop) or (op = 0)))
        break by pkpart
/*G1JF*/          by pkop
        with frame b:

                /* SET EXTERNAL LABELS */
                setFrameLabels(frame b:handle).
                
/*GUI*/ {mfguichk.i } /*Replace mfrpchk*/
                     /*G345*/
           find pt_mstr where pt_part = pkpart no-lock no-error.
/*H100         des = "ITEM NOT IN INVENTORY". */
/*L03H** /*H100*/       des = "Item not in Inventory". */
/*N0F3 /*L03H*/ des = {&bmpkiqa_p_3}. */
/*N0F3*/        des = getTermLabel("ITEM_NOT_IN_INVENTORY",24).
           loc = "".
           if available pt_mstr then do:
/*frk*/        ASSIGN 
                  des = pt_desc1
                  loc = pt_loc.
                  
           end.
/*F0HQ*/       pkqty = pkqty * qty / pkbombatch.
/*G1JF*        accumulate pkqty (total by pkpart). */
/*G1JF*/       accumulate pkqty (total by pkop).
/*G1JF*        if last-of(pkpart) then do: */
/*G1JF*/       if last-of(pkop) then do:

/*H0PC* * * BEGIN ADD SECTION */
           ln_to_disp = if des > ""
                and (available pt_mstr and pt_desc2 > "") then
                   3
                else if des > ""
                or (available pt_mstr and pt_desc2 > "") then
                   2
                else
                   1.

           if (frame-down - frame-line + 1) < ln_to_disp
           and frame-line <> 0 then
              down 2.

           if (page-size - line-counter) < ln_to_disp then
              page.
/*H0PC* * * END ADD SECTION */

/*N0F3*/          disp_pkqty = accum total by pkop pkqty.

/*frk*/    FIND FIRST IN_mstr NO-LOCK WHERE IN_part = part AND IN_site = site NO-ERROR NO-WAIT.
           IF AVAIL IN_mstr THEN ASSIGN loc = IN_user1.
                                 
/*frk*/    IF notewkctr = NO THEN DO:

/*frk*/    FIND FIRST ro_det NO-LOCK WHERE ro_routing = prouting  
                                    AND ro__chr01  = site 
                                    AND ro_op = pkop 
                                    NO-ERROR NO-WAIT.
          IF AVAIL ro_det THEN ASSIGN pwkctr = ro_wkctr loc1 = ro_wkctr.
                          ELSE pwkctr = "        ".
          END.
          ELSE DO:
              pwkctr = loc1.
          END.


/*frk*/           pcdate = "20" + SUBSTRING(STRING(eff_date),7,2) + "/"
                                + SUBSTRING(STRING(eff_date),4,2) + "/"
                                + SUBSTRING(STRING(eff_date),1,2).

/*frk*/        
                  PUT STREAM trpk UNFORMATTED TRIM(trpknbr) "," trim(site) "," trim(pcdate) FORMAT "x(10)" "," trim(pkpart) ",".
                  PUT STREAM trpk UNFORMATTED trim(loc) "," trim(pwkctr) "," DISP_pkqty "," SKIP.
                 
           end.
        end.
        OUTPUT STREAM trpk CLOSE.

        {mfreset.i}
/*GUI*/ {mfgrptrm.i} /*Report-to-Window*/

        {mfmsg.i 8 1}

/*G234*/    global_part = part.
/*G234*/    global_site = site.
     end.
        

/*K110*/ {wbrp04.i &frame-spec = a}
