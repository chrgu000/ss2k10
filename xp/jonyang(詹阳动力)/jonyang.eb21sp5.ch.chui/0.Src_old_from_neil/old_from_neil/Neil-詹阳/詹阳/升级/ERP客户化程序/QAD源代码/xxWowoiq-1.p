/* GUI CONVERTED from wowoiq.p (converter v1.71) Tue Oct  6 14:58:38 1998 */
/* wowoiq.p - WORK ORDER INQUIRY                                        */
/* COPYRIGHT qad.inc. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK. */
/* web convert wowoiq.p (converter v1.00) Thu Feb 26 14:03:48 1998 */
/* web tag in wowoiq.p (converter v1.00) Thu Feb 26 14:03:39 1998 */
/*F0PN*/ /*K1K3*/ /*V8#ConvertMode=WebReport                            */
/*V8:ConvertMode=Report                                        */
/* REVISION: 1.0      LAST MODIFIED: 04/15/86   BY: PML                 */
/* REVISION: 1.0      LAST MODIFIED: 05/07/86   BY: EMB                 */
/* REVISION: 2.1      LAST MODIFIED: 09/10/87   BY: WUG *A94*           */
/* REVISION: 4.0      LAST EDIT: 12/30/87       BY: WUG *A137*          */
/* REVISION: 5.0      LAST EDIT: 05/03/89       BY: WUG *B098*          */
/* REVISION: 5.0      LAST MODIFIED: 11/14/89   BY: MLB *B391*          */
/* REVISION: 5.0      LAST MODIFIED: 03/15/90   BY: emb *B357*          */
/* Revision: 7.3      Last edit: 11/19/92       By: jcd *G339*          */
/* REVISION: 7.0      LAST MODIFIED: 08/30/94   BY: ais *FQ61*          */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane */
/* REVISION: 8.6E     LAST MODIFIED: 02/26/98   BY: *K1K3* Beena Mol    */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan   */

/* ********** Begin Translatable Strings Definitions ********* */

/*K1K3*/ /* DISPLAY TITLE */

/*GUI preprocessor directive settings */
&SCOPED-DEFINE PP_GUI_CONVERT_MODE REPORT

/*K1K3*/ {mfdtitle.i "e+ "}

&SCOPED-DEFINE wowoiq_p_1 "短缺量"
/* MaxLen: Comment: */

&SCOPED-DEFINE wowoiq_p_2 "    短缺量"
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */

     define variable nbr like wo_nbr.
     define variable lot like wo_lot.
     define variable due like wo_due_date.
     define variable so_job like wo_so_job.
     define variable part like pt_part.
/*FQ61*/ define variable site like wo_site.
     define variable s_qty_open as character format "x(10)"
        label {&wowoiq_p_2}.
/*B357*/ define variable qty_open as decimal label {&wowoiq_p_1}.
/*LW*/define variable open_ref like wo_qty_ord LABEL "短缺量".
     define variable STAT like WO_STATUS .
     define variable DESC1 like pt_DESC1 .
     define variable DESC2 like pt_DESC2 .
     define variable DESC3 as character format "x(48)" LABEL "摘要".
     define variable nbr1 as character format "x(8)" LABEL "采购单".
     define variable qty like pod_qty_ord.
     define variable qty_rcvd like pod_qty_rcvd.
     define variable bz as character format "x(14)" LABEL "子件已全部发放".

/*K1K3* /* DISPLAY TITLE */
 *     {mfdtitle.i "e+ "} */
     part = global_part.

/*FQ61**
       * form
       *    part
       *    nbr
       *    lot
       *    due
       *    so_job
       * with frame a no-underline.
**FQ61**/

/*FQ61*/ 
/*GUI preprocessor Frame A define */
&SCOPED-DEFINE PP_FRAME_NAME A

FORM /*GUI*/ 
/*FQ61*/    
 RECT-FRAME       AT ROW 1 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1 COLUMN 3 NO-LABEL VIEW-AS TEXT SIZE-PIXELS 1 BY 1
 SKIP(.1)  /*GUI*/
part        at 2
/*FQ61*/    nbr
            STAT
/*FQ61*/    lot         colon 68
/*FQ61*/    due         at 2
/*FQ61*/    so_job
/*FQ61*/    site
/*FQ61*/ with frame a width 80 side-labels no-underline NO-BOX THREE-D /*GUI*/.

 DEFINE VARIABLE F-a-title AS CHARACTER INITIAL "".
 RECT-FRAME-LABEL:SCREEN-VALUE in frame a = F-a-title.
 RECT-FRAME-LABEL:HIDDEN in frame a = yes.
 RECT-FRAME:HEIGHT-PIXELS in frame a =
  FRAME a:HEIGHT-PIXELS - RECT-FRAME:Y in frame a - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME a = FRAME a:WIDTH-CHARS - .5.  /*GUI*/

/*GUI preprocessor Frame A undefine */
&UNDEFINE PP_FRAME_NAME



/*K1K3*/ {wbrp01.i}

         repeat:

/*K1K3*/ if c-application-mode <> 'web':u then
        update part nbr STAT lot due so_job
/*FQ61*/    site
        with frame a editing:

           if frame-field = "part" then do:
          /* FIND NEXT/PREVIOUS RECORD */
          {mfnp.i wo_mstr part wo_part part wo_part wo_part}
          if recno <> ? then do:
             part = wo_part.
             display part with frame a.
             recno = ?.
          end.
           end.
           else do:
          status input.
          readkey.
          apply lastkey.
           end.
        end.

/*K1K3*/ {wbrp06.i &command = update &fields = "  part nbr STAT lot due so_job
          site" &frm = "a"}

/*K1K3*/ if (c-application-mode <> 'web':u) or
/*K1K3*/ (c-application-mode = 'web':u and
/*K1K3*/ (c-web-request begins 'data':u)) then do:

        hide frame b.
        hide frame c.
        hide frame d.
        hide frame e.
        hide frame f.
        hide frame g.
        hide frame H.

/*K1K3*/ end.

        /* SELECT PRINTER */
        {mfselprt.i "terminal" 250}
/*GUI*/ RECT-FRAME:HEIGHT-PIXELS in frame a = FRAME a:HEIGHT-PIXELS - RECT-FRAME:Y in frame a - 2.


        /* FIND AND DISPLAY */
        if part <> "" then
        for each wo_mstr where (wo_part = part)
/*FQ61*/       and (wo_site = site or site = "")
           and (wo_lot = lot or lot = "" )
           and (wo_STATUS = STAT or STAT = "" )

           and (wo_nbr = nbr or nbr = "" )
           and (wo_due_date = due or due = ?)
           and (wo_so_job = so_job or so_job = "" )
           no-lock
/*B391*/          by wo_due_date descending
           with frame b:
          open_ref = max(wo_qty_ORD - (max(wo_qty_COMP,0) + max(wo_qty_RJCT,0)),0).
           FIND PT_MSTR WHERE PT_PART = WO_PART  no-lock no-error.
           if available PT_MSTR THEN DO:
              DESC1 = PT_DESC1.
              DESC2 = PT_DESC2.    
              DESC3 = TRIM(DESC1) + "  " + DESC2 .
              END.
           find first pod_det where pod_wo_lot = wo_lot no-lock no-error.
              if available pod_det then do:
                 nbr1 = pod_nbr.
                 qty = pod_qty_ord.
                 qty_rcvd = pod_qty_rcvd.
                 end.
                 else do:
                 nbr1 = "".
                 qty = 0.
                 qty_rcvd = 0.
                 end.
              if wo_status = "r" OR WO_STATUS = "C"  then  
                   find first wod_det where wod_lot = wo_lot no-lock no-error.
                   if not available wod_det then bz = "无材料".
                   if available wod_det then do:
                 find first wod_det where wod_lot = wo_lot AND TRUNCATE((wod_qty_REQ - wod_qty_iss),4) <> 0 no-lock no-error.
                 if available wod_det then
                    bz = "N".
                    else bz = "Y".
                    end.

                    if wo_status <> "r" AND wo_status <> "c" then bz = "N".
          DISPLAY WO_PART  FORMAT "X(22)"
           
          nbr1 label "采购单"
            qty label "采购订贷量"
            QTY_RCVD LABEL "采购收货量"
           WO_NBR WO_LOT WO_QTY_ORD /*WO_QTY_COMP  */
           OPEN_REF  LABEL "短缺量" 
          
           WO_STATUS wo_due_date   bz WITH FRAME B WIDTH 300.
           do while available pod_det:
            find next pod_det where pod_wo_lot = wo_lot no-lock no-error.
            if available pod_det then do:
            down 1.
            display
            pod_nbr @ nbr1
            pod_wo_lot @ wo_lot
            pod_qty_ord @ qty
            pod_qty_rcvd @ QTY_RCVD.

             end.
             end.
    /*      DISPLAY  AT 5.
    
/*GUI*/ {mfguichk.i } /*Replace mfrpchk*/
                     /*G339*/

          {mfwoiq.i}
*/
           end.

        else if nbr <> "" then
        for each wo_mstr where (wo_nbr = nbr)
           and (wo_lot = lot or lot = "" )
           and (wo_STATUS = STAT or STAT = "" )

/*FQ61*/       and (wo_site = site or site = "")
           and (wo_due_date = due or due = ?)
           and (wo_so_job = so_job or so_job = "" ) no-lock
/*B391*/          by wo_due_date descending
           with frame c:
     open_ref = max(wo_qty_ORD - (max(wo_qty_COMP,0) + max(wo_qty_RJCT,0)),0).
           FIND PT_MSTR WHERE PT_PART = WO_PART  no-lock no-error.
           if available PT_MSTR THEN DO:
              DESC1 = PT_DESC1.
              DESC2 = PT_DESC2.    
              DESC3 = TRIM(DESC1) + "  "+ DESC2 .
              END.
                  find first pod_det where pod_wo_lot = wo_lot no-lock no-error.
              if available pod_det then do:
                 nbr1 = pod_nbr.
                 qty = pod_qty_ord.
                 qty_rcvd = pod_qty_rcvd.
                 end.
                 else do:
                 nbr1 = "".
                 qty = 0.
                 qty_rcvd = 0.
                 end.
                 if wo_status = "r" OR WO_STATUS = "C"  then  
                   find first wod_det where wod_lot = wo_lot no-lock no-error.
                   if not available wod_det then bz = "无材料".
                   if available wod_det then do:
                  find first wod_det where wod_lot = wo_lot AND TRUNCATE((wod_qty_REQ - wod_qty_iss),4) <> 0 no-lock no-error.
                 if available wod_det then
                    bz = "N".
                    else bz = "Y".
                    end.

                    if wo_status <> "r" AND wo_status <> "c" then bz = "N".
          DISPLAY WO_PART FORMAT "X(22)" 
            nbr1 label "采购单"
            qty label "采购订贷量"
           QTY_RCVD LABEL "采购收货量"
           WO_NBR WO_LOT WO_QTY_ORD   OPEN_REF   "" WO_STATUS wo_due_date  bz WITH FRAME c WIDTH 170.
           do while available pod_det:
            find next pod_det where pod_wo_lot = wo_lot no-lock no-error.
            if available pod_det then do:
            down 1.
            display
            pod_nbr @ nbr1
            pod_wo_lot @ wo_lot
            pod_qty_ord @ qty
            pod_qty_rcvd @ qty_rcvd.

             end.
             end.

       /*   DISPLAY DESC3 AT 5.
.
           
         
/*GUI*/ {mfguichk.i } /*Replace mfrpchk*/
                     /*G339*/

          {mfwoiq.i}
*/
        end.
  
        else if STAT <> "" then
        for each wo_mstr where (WO_STAT = STAT)
           AND (wo_lot = lot OR LOT = "")
           and (wo_due_date = due or due = ?)
/*FQ61*/       and (wo_site = site or site = "")
           and (wo_so_job = so_job or so_job = "" ) no-lock
/*B391*/       by wo_due_date descending
        with frame D:
  open_ref = max(wo_qty_ORD - (max(wo_qty_COMP,0) + max(wo_qty_RJCT,0)),0).
           FIND PT_MSTR WHERE PT_PART = WO_PART  no-lock no-error.
           if available PT_MSTR THEN DO:
              DESC1 = PT_DESC1.
              DESC2 = PT_DESC2.    
              DESC3 = TRIM(DESC1) + "  " + DESC2 .
              END.
                 find first pod_det where pod_wo_lot = wo_lot no-lock no-error.
              if available pod_det then do:
                 nbr1 = pod_nbr.
                 qty = pod_qty_ord.
                 qty_rcvd = pod_qty_rcvd.
                 end.
                 else do:
                 nbr1 = "".
                 qty = 0.
                 qty_rcvd = 0.
                 end.
               if wo_status = "r" OR WO_STATUS = "C"  then  
                   find first wod_det where wod_lot = wo_lot no-lock no-error.
                   if not available wod_det then bz = "无材料".
                   if available wod_det then do:
                 find first wod_det where wod_lot = wo_lot AND TRUNCATE((wod_qty_REQ - wod_qty_iss),4) <> 0 no-lock no-error.
                 if available wod_det then
                    bz = "N".
                    else bz = "Y".
                    end.

                    if wo_status <> "r" AND wo_status <> "c" then bz = "N".
          DISPLAY WO_PART FORMAT "X(22)" 
           
          nbr1 label "采购单"
            qty label "采购订贷量"
            QTY_RCVD LABEL "采购收货量"
           WO_NBR WO_LOT WO_QTY_ORD  OPEN_REF  "" WO_STATUS wo_due_date  bz WITH FRAME d WIDTH 170.
           do while available pod_det:
            find next pod_det where pod_wo_lot = wo_lot no-lock no-error.
            if available pod_det then do:
            down 1.
            display
            pod_nbr @ nbr1
            pod_wo_lot @ wo_lot
            pod_qty_ord @ qty
            pod_qty_rcvd @ qty_rcvd.

             end.
             end.

/*          DISPLAY DESC3 AT 5.
          
/*GUI*/ {mfguichk.i } /*Replace mfrpchk*/
                     /*G339*/

           {mfwoiq.i}
*/
        end.
      

        else if lot <> "" then
        for each wo_mstr where (wo_lot = lot)
           and (wo_due_date = due or due = ?)
/*FQ61*/       and (wo_site = site or site = "")
           and (wo_so_job = so_job or so_job = "" ) no-lock
/*B391*/       by wo_due_date descending
        with frame E:
   open_ref = max(wo_qty_ORD - (max(wo_qty_COMP,0) + max(wo_qty_RJCT,0)),0).
           FIND PT_MSTR WHERE PT_PART = WO_PART  no-lock no-error.
           if available PT_MSTR THEN DO:
              DESC1 = PT_DESC1.
              DESC2 = PT_DESC2.    
              DESC3 = TRIM(DESC1) + "  " + DESC2 .
              END.
                  find first pod_det where pod_wo_lot = wo_lot no-lock no-error.
              if available pod_det then do:
                 nbr1 = pod_nbr.
                 qty = pod_qty_ord.
                 qty_rcvd = pod_qty_rcvd.
                 end.
                 else do:
                 nbr1 = "".
                 qty = 0.
                 qty_rcvd = 0.
                 end.
                if wo_status = "r" OR WO_STATUS = "C"  then  
                   find first wod_det where wod_lot = wo_lot no-lock no-error.
                   if not available wod_det then bz = "无材料".
                   if available wod_det then do:
                find first wod_det where wod_lot = wo_lot AND TRUNCATE((wod_qty_REQ - wod_qty_iss),4) <> 0 no-lock no-error.
                 if available wod_det then
                    bz = "N".
                    else bz = "Y".
                    end.

                    if wo_status <> "r" AND wo_status <> "c" then bz = "N".
          DISPLAY WO_PART FORMAT "X(22)" 
           
          nbr1 label "采购单"
            qty label "采购订贷量"
            QTY_RCVD LABEL "采购收货量"
           WO_NBR WO_LOT WO_QTY_ORD   OPEN_REF  "" WO_STATUS wo_due_date  bz WITH FRAME e WIDTH 170.
           do while available pod_det:
            find next pod_det where pod_wo_lot = wo_lot no-lock no-error.
            if available pod_det then do:
            down 1.
            display
            pod_nbr @ nbr1
            pod_wo_lot @ wo_lot
            pod_qty_ord @ qty
            pod_qty_rcvd @ qty_rcvd.

             end.
             end.

 /*         DISPLAY DESC3 AT 5.
          
/*GUI*/ {mfguichk.i } /*Replace mfrpchk*/
                     /*G339*/

           {mfwoiq.i}
*/
        end.

        else if due <> ? then
        for each wo_mstr where (wo_due_date = due)
/*FQ61*/       and (wo_site = site or site = "")
           and (wo_so_job = so_job or so_job = "" ) no-lock
        with frame F:
    open_ref = max(wo_qty_ORD - (max(wo_qty_COMP,0) + max(wo_qty_RJCT,0)),0).
           FIND PT_MSTR WHERE PT_PART = WO_PART  no-lock no-error.
           if available PT_MSTR THEN DO:
              DESC1 = PT_DESC1.
              DESC2 = PT_DESC2.    
              DESC3 = TRIM(DESC1) + "  " + DESC2 .
              END.
                find first pod_det where pod_wo_lot = wo_lot no-lock no-error.
              if available pod_det then do:
                 nbr1 = pod_nbr.
                 qty = pod_qty_ord.
                 qty_rcvd = pod_qty_rcvd.
                 end.
                 else do:
                 nbr1 = "".
                 qty = 0.
                 qty_rcvd = 0.
                 end.
                if wo_status = "r" OR WO_STATUS = "C"  then  
                   find first wod_det where wod_lot = wo_lot no-lock no-error.
                   if not available wod_det then bz = "无材料".
                   if available wod_det then do:
                find first wod_det where wod_lot = wo_lot AND TRUNCATE((wod_qty_REQ - wod_qty_iss),4) <> 0 no-lock no-error.
                 if available wod_det then
                    bz = "N".
                    else bz = "Y".
                    end.

                    if wo_status <> "r" AND wo_status <> "c" then bz = "N".
          DISPLAY WO_PART FORMAT "X(22)" 
          nbr1 label "采购单"
            qty label "采购订贷量"
            QTY_RCVD LABEL "采购收货量"
           WO_NBR WO_LOT WO_QTY_ORD  OPEN_REF  "" WO_STATUS wo_due_date   bz WITH FRAME f WIDTH 170.
           do while available pod_det:
            find next pod_det where pod_wo_lot = wo_lot no-lock no-error.
            if available pod_det then do:
            down 1.
            display
            pod_nbr @ nbr1
            pod_wo_lot @ wo_lot
            pod_qty_ord @ qty
            pod_qty_rcvd @ qty_rcvd.

             end.
             end.

  /*         DISPLAY DESC3 AT 5.
          
/*GUI*/ {mfguichk.i } /*Replace mfrpchk*/
                     /*G339*/

           {mfwoiq.i}
*/
        end.

        else if so_job <> "" then
        for each wo_mstr where wo_so_job = so_job
/*FQ61*/       and (wo_site = site or site = "")
           no-lock
/*B391*/    by wo_due_date descending
        with frame G:
     open_ref = max(wo_qty_ORD - (max(wo_qty_COMP,0) + max(wo_qty_RJCT,0)),0).
           FIND PT_MSTR WHERE PT_PART = WO_PART  no-lock no-error.
           if available PT_MSTR THEN DO:
              DESC1 = PT_DESC1.
              DESC2 = PT_DESC2.    
              DESC3 = TRIM(DESC1) + "  " + DESC2 .
              END.
                  find first pod_det where pod_wo_lot = wo_lot no-lock no-error.
              if available pod_det then do:
                 nbr1 = pod_nbr.
                 qty = pod_qty_ord.
                 qty_rcvd = pod_qty_rcvd.
                 end.
                 else do:
                 nbr1 = "".
                 qty = 0.
                 qty_rcvd = 0.
                 end.
              if wo_status = "r" OR WO_STATUS = "C"  then  
                   find first wod_det where wod_lot = wo_lot no-lock no-error.
                   if not available wod_det then bz = "无材料".
                   if available wod_det then do:
                 find first wod_det where wod_lot = wo_lot AND TRUNCATE((wod_qty_REQ - wod_qty_iss),4) <> 0 no-lock no-error.
                 if available wod_det then
                    bz = "N".
                    else bz = "Y".
                    end.

                    if wo_status <> "r" AND wo_status <> "c" then bz = "N".
          DISPLAY WO_PART FORMAT "X(22)" 
           
          nbr1 label "采购单"
            qty label "采购订贷量"
            QTY_RCVD LABEL "采购收货量"
           WO_NBR WO_LOT WO_QTY_ORD   OPEN_REF   "" WO_STATUS wo_due_date bz WITH FRAME g WIDTH 170.
           do while available pod_det:
            find next pod_det where pod_wo_lot = wo_lot no-lock no-error.
            if available pod_det then do:
            down 1.
            display
            pod_nbr @ nbr1
            pod_wo_lot @ wo_lot
            pod_qty_ord @ qty
            pod_qty_rcvd @ qty_rcvd.

             end.
             end.

    /*      DISPLAY  AT 5.
           
/*GUI*/ {mfguichk.i } /*Replace mfrpchk*/
                     /*G339*/

           {mfwoiq.i}
*/
        end.

        else
        for each wo_mstr
/*FQ61*/       where wo_site = site or site = ""
           no-lock
/*B391*/       by wo_due_date descending
        with frame H:
   open_ref = max(wo_qty_ORD - (max(wo_qty_COMP,0) + max(wo_qty_RJCT,0)),0).
           FIND PT_MSTR WHERE PT_PART = WO_PART  no-lock no-error.
           if available PT_MSTR THEN DO:
              DESC1 = PT_DESC1.
              DESC2 = PT_DESC2.    
              DESC3 = TRIM(DESC1) + "  " + DESC2 .
              END.
                  find first pod_det where pod_wo_lot = wo_lot no-lock no-error.
              if available pod_det then do:
                 nbr1 = pod_nbr.
                 qty = pod_qty_ord.
                 qty_rcvd = pod_qty_rcvd.
                 end.
                 else do:
                 nbr1 = "".
                 qty = 0.
                 qty_rcvd = 0.
                 end.
               if wo_status = "r" OR WO_STATUS = "C"  then  
                   find first wod_det where wod_lot = wo_lot no-lock no-error.
                   if not available wod_det then bz = "无材料".
                   if available wod_det then do:
                find first wod_det where wod_lot = wo_lot AND TRUNCATE((wod_qty_REQ - wod_qty_iss),4) <> 0 no-lock no-error.
                 if available wod_det then
                    bz = "N".
                    else bz = "Y".
                    end.

                    if wo_status <> "r" AND wo_status <> "c" then bz = "N".
          DISPLAY WO_PART FORMAT "X(22)" 
           
          nbr1 label "采购单"
            qty label "采购订贷量"
            QTY_RCVD LABEL "采购收货量"
           WO_NBR WO_LOT WO_QTY_ORD   OPEN_REF  "" WO_STATUS wo_due_date  bz WITH FRAME h WIDTH 170.
           do while available pod_det:
            find next pod_det where pod_wo_lot = wo_lot no-lock no-error.
            if available pod_det then do:
            down 1.
            display
            pod_nbr @ nbr1
            pod_wo_lot @ wo_lot
            pod_qty_ord @ qty
            pod_qty_rcvd @ qty_rcvd.

             end.
             end.

/*          DISPLAY DESC3 AT 5.
           
/*GUI*/ {mfguichk.i } /*Replace mfrpchk*/
                     /*G339*/

           {mfwoiq.i}
*/
        end.

        {mfreset.i}
/*GUI*/ {mfgrptrm.i} /*Report-to-Window*/

        {mfmsg.i 8 1}
     end.
     global_part = part.
/* {mfguirpb.i &flds=" PART NBR STAT LOT DUE SO_JOB SITE"} /*Drive the Report*/*/

/*K1K3*/ {wbrp04.i &frame-spec = a}
