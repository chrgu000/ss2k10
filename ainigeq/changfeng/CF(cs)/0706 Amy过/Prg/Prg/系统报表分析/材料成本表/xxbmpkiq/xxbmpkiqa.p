/* bmpkiqa.p - SIMULATED PICKLIST INQUIRY                               */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                  */
/* All rights reserved worldwide.  This is an unpublished work.         */
/*F0PN*//*V8:ConvertMode=Report                                        */
/* REVISION: 1.0        LAST EDIT: 05/05/86       BY: EMB               */
/* REVISION: 1.0        LAST EDIT: 01/29/87       BY: EMB *A19*         */
/* REVISION: 2.1        LAST EDIT: 10/20/87       BY: WUG *A94*         */
/* REVISION: 4.0        LAST EDIT: 12/30/87       BY: WUG *A137*        */
/* REVISION: 4.0        LAST EDIT: 07/12/88       BY: flm *A318*        */
/* REVISION: 4.0        LAST EDIT: 08/03/88       BY: flm *A375*        */
/* REVISION: 4.0        LAST EDIT: 11/04/88       BY: flm *A520*        */
/* REVISION: 4.0        LAST EDIT: 11/15/88       BY: emb *A535*        */
/* REVISION: 4.0        LAST EDIT: 02/21/89       BY: emb *A654*        */
/* REVISION: 5.0        LAST EDIT: 05/03/89       BY: WUG *B098*        */
/* REVISION: 5.0        LAST MODIFIED: 06/23/89   BY: MLB *B159*        */
/* REVISION: 6.0        LAST MODIFIED: 07/11/90   BY: WUG *D051*        */
/* REVISION: 7.2        LAST MODIFIED: 10/26/92   BY: emb *G234*        */
/* REVISION: 7.2        LAST MODIFIED: 11/02/92   BY: pma *G265*        */
/* Revision: 7.3        Last edit: 11/19/92       By: jcd *G345*        */
/* REVISION: 7.4        LAST MODIFIED: 08/31/93   BY: dzs *H100*        */
/* REVISION: 7.4        LAST MODIFIED: 12/20/93   BY: ais *GH69*        */
/* REVISION: 7.2        LAST MODIFIED: 03/18/94   BY: ais *FM19*        */
/* REVISION: 7.4        LAST MODIFIED: 04/18/94   BY: ais *H357*        */
/* REVISION: 7.4        LAST MODIFIED: 08/11/94   BY: pxd *FQ05*        */
/* REVISION: 7.2        LAST MODIFIED: 02/09/95   BY: qzl *F0HQ*        */
/* REVISION: 8.5        LAST MODIFIED: 09/19/94   BY: dzs *J020*        */
/* REVISION: 7.4        LAST MODIFIED: 12/19/95   BY: bcm *G1H5*        */
/* REVISION: 7.4        LAST MODIFIED: 01/22/96   BY: jym *G1JF*        */
/* REVISION: 8.5        LAST MODIFIED: 11/19/96   BY: *H0PC* Murli Shastri */
/* REVISION: 8.6        LAST MODIFIED: 09/27/97   BY: mzv *K0J *        */
/* REVISION: 8.6        LAST MODIFIED: 10/15/97   BY: ays *K110*        */
/* REVISION: 8.6E       LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane */
/* REVISION: 8.6E       LAST MODIFIED: 06/17/98   BY: *J2N9* Dana Tunstall */
/* REVISION: 8.6E       LAST MODIFIED: 07/07/98   BY: *L03H* Santosh Nair */
/* REVISION: 9.0        LAST MODIFIED: 12/04/98   BY: *M01Q* D. Belbeck   */
/* REVISION: 9.0        LAST MODIFIED: 03/13/99   BY: *M0BD* Alfred Tan    */
/* REVISION: 9.1        LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane */
/* REVISION: 9.1        LAST MODIFIED: 03/24/00   BY: *N0F3* Rajinder Kamra   */
/* REVISION: 9.1        LAST MODIFIED: 08/11/00   BY: *N0KK* jyn              */

     /* DISPLAY TITLE */
     {xxmfdtitle.i "b+ "}
{xxbmpkiq.i}
DEF SHARED VAR ii_part LIKE pt_part .
DEF SHARED VAR ii_eff_date AS DATE .
DEF SHARED VAR ii_site LIKE IN_site .
DEF SHARED VAR ii_qty LIKE pk_qty .
DEF SHARED VAR ii_op as integer format ">>>>>9" .

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE bmpkiqa_p_1 "Quantity"
/* MaxLen: Comment: */

&SCOPED-DEFINE bmpkiqa_p_2 "As of Date"
/* MaxLen: Comment: */

/*N0F3
 * &SCOPED-DEFINE bmpkiqa_p_3 "Item Not in Inventory"
 * /* MaxLen: Comment: */
 *N0F3*/

&SCOPED-DEFINE bmpkiqa_p_4 "Op"
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */

     define new shared workfile pkdet no-undo
/*G1H5**    field pkpart like pk_part **/
/*G1H5*/    field pkpart like ps_comp
/*H100*/    field pkop as integer
/*G1H5*/                          format ">>>>>9"
        field pkstart like pk_start
        field pkend like pk_end
        field pkqty like pk_qty
/*F0HQ*/    field pkbombatch like bom_batch
        field pkltoff like ps_lt_off.

     define new shared variable comp like ps_comp.
/*GH69*  define new shared variable eff_date like ar_effdate.           */
/*GH69*/ define new shared variable eff_date as date label {&bmpkiqa_p_2}.
     define variable qty like pk_qty.
/*G1H5** define variable part like pt_part. **/
/*G1H5** define variable last_part like pt_part. **/
/*G1H5*/ define variable part like ps_par.
/*G1H5*/ define variable last_part like ps_par.
     define variable des like pt_desc1.
     define variable um like pt_um.
     define variable loc like pt_loc.
/*G234*/ define new shared variable site like in_site
/*H100*/    no-undo.
/*G265*/ define shared variable transtype as character format "x(4)".
/*G1H5*/ define variable op as integer label {&bmpkiqa_p_4} format ">>>>>9".
/*G1H5** /*H100*/ define variable op as integer label "Op" format ">>>".   **/
/*FM19*/ define new shared variable phantom like mfc_logical initial yes.

/*H0PC*/ define variable ln_to_disp as integer.
/*J2N9*/ define variable aval as logical no-undo.
/*J2N9*/ define variable batchqty like bom_batch no-undo.
/*J2N9*/ define variable batchdesc1 like pt_desc1 no-undo.
/*J2N9*/ define variable batchdesc2 like pt_desc2 no-undo.

/*N0F3*/ define variable disp_pkqty like pk_qty no-undo.

/*H100*/ {gpxpld01.i "new shared"}

     eff_date = today.

     part = global_part.
/*G234*/ site = global_site.

/*G234**********************************************
       * form
       *    part
       *    pt_desc1 no-attr-space format "x(19)"
       *    qty
       *    pt_um no-attr-space
       *    eff_date
       * With frame a no-underline width 80 attr-space.
**G234*********************************************/

/*G234*/ /* CHANGED FRAME */
/*GH69*/ /* MOVED EFF_DATE TO COLUMN 68 */
     form
        part colon 12
/*H0PC*     pt_desc1 no-label no-attr-space */
/*H0PC*/    pt_desc1 no-label
/*H0PC*     eff_date colon 68 */
/*H0PC*/    eff_date colon 12
/*H0PC*     site colon 12 */
/*H0PC*/    site
        qty
        pt_um no-label no-attr-space
/*H100*/    op colon 68
     with frame a side-labels width 80 attr-space.

     /*
     /* SET EXTERNAL LABELS */
     setFrameLabels(frame a:handle).
/*G234*/ /* CHANGED FRAME */
       */

 part = ii_part .
 eff_date = ii_eff_date .
 site = ii_site .
 qty = ii_qty .
 op = ii_op .

/*K110*/ {wbrp02.i}

    /*
     repeat
/*G265*/ with frame a:
      */

             /*
/*K110*/ if c-application-mode <> 'web' then
        update part  eff_date  site qty   op with frame a editing:

/*G234*/       if frame-field = "part" then do:
          /* FIND NEXT/PREVIOUS RECORD */
/*G265            {mfnp.i ps_mstr part   ps_par part   ps_par ps_par} */
/*G265*/          {mfnp.i bom_mstr part bom_parent part bom_parent bom_parent}
          if recno <> ? then do:
/*G265               part = ps_par. */
/*G265*/             part = bom_parent.
/*J2N9** BEGIN DELETE SECTION
 *           display part
 * /*G265*/          bom_desc @ pt_desc1
 *           with frame a.
 *           find pt_mstr where pt_part = part   no-lock  no-error.
 *
 * /*G265*/             if transtype = "FM" then
 * /*G265*/                display
 * /*G265*/                bom_batch when (bom_batch <> 0) @ qty
 * /*G265*/                1 when (bom_batch = 0) @ qty
 * /*G265*/                bom_batch_um @ pt_um
 * /*G265*/                with frame a.
 * /*G265*/             else
 *           if available pt_mstr then
 *          display
 * /*G265                  pt_desc1  */
 * /*G234*/                pt_ord_qty when (pt_ord_qty <> 0) @ qty
 * /*G234*/                1 when (pt_ord_qty = 0) @ qty
 * /*G265*/                pt_um
 *          with frame a.
 * /*G1H5*/            else display 1 when (qty = 0) @ qty
 * /*G1H5*/                         "" @ pt_um with frame a.
 * /*G1H5** /*G265*/           else display 1 @ qty "" @ pt_um with frame a. **/
 *J2N9** END DELETE SECTION */

/*J2N9*  BEGIN ADD SECTION */

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

/*K110*/ {wbrp06.i &command = update &fields = "part eff_date site qty op"
      &frm = "a"}
          */


/*K110*/ if (c-application-mode <> 'web') or
/*K110*/ (c-application-mode = 'web' and
/*K110*/ (c-web-request begins 'data')) then do:
              /*
/*G265*/    assign part.
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
/*G234*/    /* End of added section */
          */

/*G265      part = pt_part.                            */
/*G265      display part pt_desc1 pt_um with frame a.  */
/*G234      qty = pt_ord_qty.                          */
/*G234      update qty eff_date with frame a.          */

/*FA23*/    /*NOTE: if bom_mstr is not available then  pt_mstr is available*/
/*FA23*/    /*      if  pt_mstr is not available then bom_mstr is available*/

/*J2N9** BEGIN DELETE SECTION
 * /*G265*/    if transtype = "FM" then do:
 * /*G265*/       if available bom_mstr then do:
 * /*G265*/          if qty = 0 then do:
 * /*G265*/             if bom_batch <> 0 then qty = bom_batch.
 * /*G265*/             else qty = 1.
 * /*G265*/          end.
 * /*G265*/          display bom_desc @ pt_desc1 qty bom_batch_um @ pt_um.
 * /*G265*/       end.
 * /*G265*/       else do:
 * /*FQ05/*G265*/    qty = 1.       */
 * /*G265*/          display pt_desc1 qty pt_um.
 * /*G265*/       end.
 * /*G265*/    end.
 * /*G265*/    else do:
 * /*G265*/       if available pt_mstr then do:
 * /*G265*/          if qty = 0 then do:
 * /*G265*/             find ptp_det no-lock where ptp_part = pt_part
 * /*G265*/             and ptp_site = site no-error.
 * /*G265*/             if available ptp_det then qty = ptp_ord_qty.
 * /*G265*/             else qty = pt_ord_qty.
 * /*G265*/             if qty = 0 then qty = 1.
 * /*G265*/          end.
 * /*G265*/          display pt_desc1 qty pt_um.
 * /*G265*/       end.
 * /*G265*/       else do:
 * /*G1H5*/          if qty = 0 then qty = 1.
 * /*G1H5** /*G265*/          qty = 1. **/
 * /*G265*/          display bom_desc @ pt_desc1 qty bom_batch_um @ pt_um.
 * /*G265*/       end.
 * /*G265*/    end.
 *J2N9** END DELETE SECTION */

/*J2N9*  BEGIN ADD SECTION */

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

                /*
                display batchdesc1 @ pt_desc1
                        qty
                        um         @ pt_um
                        with frame a.
                        
/*J2N9*  END ADD SECTION */
        hide frame b.
                */

/*K110*/ end.

           /*
        /* SELECT PRINTER */
            {mfselprt.i "terminal" 80}
            */

        comp = part.

/*G234*/    /* Added section*/
        find ptp_det no-lock where ptp_part = part
        and ptp_site = site no-error.
        if available ptp_det then do:
                       /*
/*J020*/       if index("1234",ptp_joint_type) > 0 then do:
/*J020*/          {mfmsg.i 6519 1}
/*J020*/          /* MAY NOT INQUIRE/REPORT ON JOINT PRODUCTS */
/*K110*/          if c-application-mode = 'web' then return.
/*J020*/          undo, retry.
/*J020*/       end.
                     */
           if ptp_bom_code > "" then comp = ptp_bom_code.
        end.
        else
/*G265*/    if available pt_mstr then
        do:
                      /*
/*J020*/       if index("1234",pt_joint_type) > 0 then do:
/*J020*/          {mfmsg.i 6519 1}
/*J020*/          /* MAY NOT INQUIRE/REPORT ON JOINT PRODUCTS */
/*K110*/          if c-application-mode = 'web' then return.
/*J020*/          undo, retry.
/*J020*/       end.
                    */
           if pt_bom_code > "" then comp = pt_bom_code.
        end.
/*G234*/    /* End of added section*/

        /* explode part by standard picklist logic */
        if comp <> last_part then do:
           hide frame b no-pause.
/*H100            {gprun.i ""woworla2.p""}   */
/*H357* /*H100*/  {gprun.i ""woworla.p""}    */
/*H357*/          {gprun.i ""woworla2.p""}

        end.

/*G1H5** /*H100*/    if op = 999 then op = 0. **/

        for each pkdet
        where eff_date = ? or (eff_date <> ?
        and (pkstart = ? or pkstart <= eff_date)
/*H100      and (pkend = ? or eff_date <= pkend)) */
/*H100*/    and (pkend = ? or eff_date <= pkend)
/*H100*/    and ((op = pkop) or (op = 0)))
        break by pkpart
/*G1JF*/          by pkop
        with frame b:

                    /*
                /* SET EXTERNAL LABELS */
                setFrameLabels(frame b:handle).
                    */

                {mfrpchk.i}                     /*G345*/
           find pt_mstr where pt_part = pkpart no-lock no-error.
/*H100         des = "ITEM NOT IN INVENTORY". */
/*L03H** /*H100*/       des = "Item not in Inventory". */
/*N0F3 /*L03H*/ des = {&bmpkiqa_p_3}. */
                
                /*
/*N0F3*/        des = getTermLabel("ITEM_NOT_IN_INVENTORY",24).
                    */
           loc = "".
           if available pt_mstr then do:
          des = pt_desc1.
          loc = pt_loc.
           end.
/*F0HQ*/       pkqty = pkqty * qty / pkbombatch.
/*G1JF*        accumulate pkqty (total by pkpart). */
/*G1JF*/       accumulate pkqty (total by pkop).
/*G1JF*        if last-of(pkpart) then do: */
/*G1JF*/       if last-of(pkop) then do:
/*H0PC* * * BEGIN COMMENT OUT *
./*G234*/          if frame-down - frame-line < 2
./*G234*/          and frame-line <> 0
./*G234*/          and available pt_mstr and pt_desc2 > ""
./*G234*/          then down 1.
**H0PC* * * END COMMENT OUT */

/*H0PC* * * BEGIN ADD SECTION */
           ln_to_disp = if des > ""
                and (available pt_mstr and pt_desc2 > "") then
                   3
                else if des > ""
                or (available pt_mstr and pt_desc2 > "") then
                   2
                else
                   1.

                   /*
           if (frame-down - frame-line + 1) < ln_to_disp
           and frame-line <> 0 then
              down 2.

           if (page-size - line-counter) < ln_to_disp then
              page.
              */

/*H0PC* * * END ADD SECTION */

/*H100            display pkpart  space(2) */
/*H100            loc space(2)             */
/*H100            des space(2)             */
/*H0PC*  /*H100*/ display pkpart  space(1) */

/*N0F3*/          disp_pkqty = accum total by pkop pkqty.

                  CREATE tta6bmpkiq.
                  ASSIGN
		              tta6bmpkiq_par_part = part 
                      tta6bmpkiq_part = pkpart
                      tta6bmpkiq_part_desc = des
                      tta6bmpkiq_loc  = loc
                      tta6bmpkiq_qty = DISP_pkqty
                      tta6bmpkiq_um = pt_um
                      tta6bmpkiq_op = pkop
                      .
                          /*
/*H0PC*/          display pkpart format "x(26)" space(1)
/*H100*/          loc space(1)
/*G1H5** /*H100*/          des space(1) **/
/*F0HQ*           (accum total by pkpart pkqty) * qty label "Quantity" */
/*G1JF* /*F0HQ*/          (accum total by pkpart pkqty) label "Quantity" */
/*N0F3* /*G1JF*/ /*F0HQ*/          (accum total by pkop pkqty) label {&bmpkiqa_p_1}*/
/*N0F3*/          disp_pkqty label {&bmpkiqa_p_1}
/*G234*           format "->>>,>>>,>>9.9999" */
/*G234*/          format "->>,>>>,>>>,>>9.9<<<<<<<<"
          pt_um    space(1)
/*G1H5*/          pkop label {&bmpkiqa_p_4} format ">>>>>9"
/*G1H5** /*H100*/          pkop label "Op" format ">>>" **/
/*H0PC* /*G1H5*/  skip des at 3  */
          with width 80 no-attr-space.


/*H0PC*/          if des > "" then do:
/*H0PC*/            down 1.
/*H0PC*/            display "  " + des @ pkpart.
/*H0PC*/          end.

/*G234*/          /* Added section */
          if available pt_mstr and pt_desc2 > "" then do:
             down 1.
/*H0PC*              display pt_desc2 @ des. */
/*H0PC*/             display "  " + pt_desc2 @ pkpart .
          end.
/*G234*/          /* End of added section */
                        */
           end.
        end.

        /*
        {mfreset.i}
        {mfmsg.i 8 1}
          */

/*G234*/    global_part = part.
/*G234*/    global_site = site.

            /*
     end.
              */

/*G234*  global_part = part. */

/*K110*/ {wbrp04.i &frame-spec = a}
