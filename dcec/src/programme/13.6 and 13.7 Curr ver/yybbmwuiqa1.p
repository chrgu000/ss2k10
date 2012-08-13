/* GUI CONVERTED from bmwuiqa.p (converter v1.75) Sun Aug 13 21:23:46 2000 */
/* bmwuiqa.p - WHERE-USED INQUIRY                                       */
/* Copyright 1986-2000 QAD Inc., Carpinteria, CA, USA.                  */
/* All rights reserved worldwide.  This is an unpublished work.         */
/*F0PN*/ /*K124*/
/*V8:ConvertMode=Report                                        */
/* REVISION: 1.0      LAST EDIT:     06/11/86   BY: EMB                 */
/* REVISION: 2.1      LAST EDIT:     09/02/87   BY: WUG *A94*           */
/* REVISION: 4.0      LAST EDIT:     12/30/87   BY: WUG *A137*          */
/* REVISION: 4.0      LAST EDIT:     04/28/88   BY: EMB                 */
/* REVISION: 5.0      LAST EDIT:     05/03/89   BY: WUG *B098*          */
/* REVISION: 5.0      LAST EDIT:     08/16/90   BY: WUG *D051*          */
/* REVISION: 6.0      LAST EDIT:     01/07/91   BY: bjb *D248*          */
/* REVISION: 7.2      LAST MODIFIED: 11/02/92   BY: pma *G265*          */
/* REVISION: 7.3      LAST MODIFIED: 10/26/93   BY: ais *GG68*          */
/* REVISION: 7.3      LAST MODIFIED: 12/20/93   BY: ais *GH69*          */
/* REVISION: 7.3      LAST MODIFIED: 12/29/93   BY: ais *FL07*          */
/* REVISION: 8.6      LAST MODIFIED: 10/15/97   BY: mur *K124*          */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan    */
/* REVISION: 9.0      LAST MODIFIED: 07/30/99   BY: *J3J4* Jyoti Thatte  */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane */
/* REVISION: 9.1      LAST MODIFIED: 07/04/00   BY: *N0F3* Rajinder Kamra   */
/* REVISION: 9.1      LAST MODIFIED: 08/11/00   BY: *N0KK* jyn              */

/*G265***********************************************************************/
/*             THIS PROGRAM COMBINES BMWUIQ.P & FMWUIQ.P                    */
/*       BOTH PROGRAMS NAMED THE DETAIL FRAME 'HEADING";  THIS              */
/*       COMBIND PROGRAM USES FRAMES BM & FM.  WHERE THESE FRAME            */
/*       NAMES ARE USED, THE PREVIOUS PROGRAMS USED 'HEADING'               */
/*G265***********************************************************************/

     /* DISPLAY TITLE */

/*GUI preprocessor directive settings */
&SCOPED-DEFINE PP_GUI_CONVERT_MODE REPORT

     {mfdtitle.i "b+ "}   /*FL07*/

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE bmwuiqa_p_1 "Ph"
/* MaxLen: Comment: */

&SCOPED-DEFINE bmwuiqa_p_2 "层次"
/* MaxLen: Comment: */

&SCOPED-DEFINE bmwuiqa_p_3 "起始日"
/* MaxLen: Comment: */

&SCOPED-DEFINE bmwuiqa_p_4 "层次"
/* MaxLen: Comment: */

/*N0F3
 * &SCOPED-DEFINE bmwuiqa_p_5 "BOM"
 * /* MaxLen: Comment: */
 *N0F3*/

&SCOPED-DEFINE bmwuiqa_p_6 "/no"
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */

     define variable comp like ps_comp.
     define variable level as integer.
     define variable maxlevel as integer format ">>>" label {&bmwuiqa_p_2}.
/*GH69*  define variable eff_date like ar_effdate.           */
/*FL07*  /*GH69*/ define variable eff_date as date column-label "As of Dt". */
/*FL07*/ define variable eff_date as date column-label {&bmwuiqa_p_3}.
     define variable parent like ps_comp.
     define variable desc1 like pt_desc1.
     define variable um like pt_um.
     /*define variable phantom like mfc_logical format "Y" label {&bmwuiqa_p_1}.*/
     define variable phantom like mfc_logical format "yes" label "Ph".
     define variable iss_pol like pt_iss_pol format {&bmwuiqa_p_6}.
     /*judy*/  DEFINE VARIABLE xxstatus LIKE pt_status .   
     define variable l_phantom as   character      format "x(3)" no-undo.
     define variable l_iss_pol as   character      format "x(3)" no-undo.
     define variable record as integer extent 100.
     define variable lvl as character format "x(7)" label {&bmwuiqa_p_4}.
/*hj01*/ DEFINE VARIABLE o_char AS CHAR FORMAT "x(3)" INIT "ALL" LABEL "零件状态".
/*hj01*/ DEFINE VARIABLE yn AS LOG INIT NO .
     eff_date = today.
/*G265*/ define shared variable transtype as character format "x(4)".

/*J3J4*/ define variable l_level   as integer initial 0 no-undo.
/*J3J4*/ define variable l_psrecid as recid no-undo.
/*J3J4*/ define variable l_next    like mfc_logical initial yes no-undo.
/*J3J4*/ define variable l_nextptp like mfc_logical initial no  no-undo.

/*J3J4*/ define buffer ptmstr1 for pt_mstr.
/*J3J4*/ define buffer psmstr  for ps_mstr.



     
/*GUI preprocessor Frame A define */
&SCOPED-DEFINE PP_FRAME_NAME A

FORM /*GUI*/ 
        PARENT LABEL "子零件"
        desc1
        um
        eff_date
        maxlevel
/*hj01*/ o_char  /* VIEW-AS COMBO-BOX LIST-ITEM-PAIRS "ALL" ,"ALL" INNER-LINES 8 */
	skip(1)
"**零件状态只能是已有零件状态(代表只显示选定状态的零件),或ALL(代表所有状态),或!O(代表非O)**" AT 10 SKIP(1)
     with frame a side-labels width 80 /* attr-space no-underline */ THREE-D /*GUI*/.

/*GUI preprocessor Frame A undefine */
&UNDEFINE PP_FRAME_NAME
/*
FOR EACH qad_wkfl NO-LOCK where qad_key1 = "PT_STATUS" :
    o_char:ADD-LAST(qad_key2,qad_key2).
END. 
o_char:ADD-LAST("非O","非O") .
*/
     /* SET EXTERNAL LABELS */
 /*    setFrameLabels(frame a:handle). */

     /* SET PARENT TO GLOBAL PART NUMBER */
     parent = global_part.

/*K124*/ {wbrp02.i}
     repeat:

/*K124*/ if c-application-mode <> 'web':u then
        update parent eff_date maxlevel /*hj01*/ o_char VALIDATE(o_char = "ALL" OR o_char = "!O" OR 
                         CAN-FIND(qad_wkfl NO-LOCK where qad_key1 = "PT_STATUS" AND o_char = qad_key2),
                         "零件状态输入错误,请重新输入!" )
	with frame a editing:


           if frame-field = "parent" then do:
          /* FIND NEXT/PREVIOUS RECORD */
          {mfnp.i ps_mstr parent ps_comp parent ps_comp ps_comp}

          if recno <> ? then do:
             parent = ps_comp.
             desc1 = "".

             find pt_mstr where pt_part = parent no-lock no-error.
             if available pt_mstr then desc1 = pt_desc1.
/*G265*/             if not available pt_mstr then do:
/*G265*/                find bom_mstr no-lock where bom_parent = parent
/*G265*/                no-error.
/*G265*/                if available bom_mstr then desc1 = bom_desc.
/*G265*/             end.
             display parent desc1 with frame a.
             recno = ?.
          end.
           end.
           else do:
          status input.
          readkey.
          apply lastkey.
           end.
        end.

/*K124*/ {wbrp06.i &command = update &fields = "parent eff_date maxlevel"
        &frm = "a"}

/*K124*/ if (c-application-mode <> 'web':u) or
/*K124*/ (c-application-mode = 'web':u and
/*K124*/ (c-web-request begins 'data':u)) then do:


        desc1 = "".
        um = "".

/*G265*/    assign parent.
        find pt_mstr use-index pt_part where pt_part = parent
        no-lock no-error.
        if not available pt_mstr then do:
/*G265*/       find bom_mstr no-lock where bom_parent = parent no-error.
/*G265*/       if not available bom_mstr then do:
          hide message no-pause.
          {mfmsg.i 17 3}
          display desc1 um with frame a.
/*K124*/         if c-application-mode = 'web':u then return.
          undo, retry.
/*G265*/       end.
/*G265*/       assign um = bom_batch_um
/*G265*/           desc1 = bom_desc
/*G265*/          parent = bom_parent.
        end.
/*G265*/    else do:
           desc1 = pt_desc1.
           um = pt_um.
           parent = pt_part.
/*G265*/    end.

        display parent desc1 um with frame a.

/*G265      hide frame heading. */
/*G265*/    hide frame bm.
/*G265*/    hide frame fm.



/*K124*/ end.
        /* SELECT PRINTER */
          {mfselprt.i "terminal" 80}.
/*J3J4*/ assign
/*J3J4*/    l_next    = yes
/*J3J4*/    l_nextptp = no
                level     = 0
/*G265      comp = pt_part.  */
/*G265*/    comp      = parent
            maxlevel  = min(maxlevel,99)
            level     = 1.

        find first ps_mstr use-index ps_comp where ps_comp = comp
        no-lock no-error.
        repeat:
/*G265      with frame heading:  */

           
/*GUI*/ {mfguichk.i } /*Replace mfrpchk*/
                                      /*G345*/
           /*DETAIL FORM (BM)*/
           FORM /*GUI*/ 
          lvl
          ps_par
          desc1
          ps_qty_per
          um
          phantom
          ps_ps_code
          iss_pol
 /*judy*/
         xxstatus
         ps_rmks  COLUMN-LABEL "随机带!走  件"  FORMAT "x(1)"
/*judy*/
           with STREAM-IO /*GUI*/  frame bm width 100 no-attr-space.

           /* SET EXTERNAL LABELS */
           setFrameLabels(frame bm:handle).

           /*DETAIL FORM (FM)*/
           FORM /*GUI*/ 
          lvl
          ps_par
/*G265            label "Parent" */
          desc1
          ps_qty_per_b
          ps_qty_type
          um
          phantom
          ps_ps_code
 /*judy*/
         xxstatus
         ps_rmks  COLUMN-LABEL "随机带!走  件"  FORMAT "x(1)"
/*judy*/
/*G265            label "SC" */
           with STREAM-IO /*GUI*/  frame fm width 100 no-attr-space.

           /* SET EXTERNAL LABELS */
           setFrameLabels(frame fm:handle).

           if not available ps_mstr then do:
          repeat:
             level = level - 1.
             if level < 1 then leave.
             find ps_mstr where recid(ps_mstr) = record[level]
             no-lock no-error.
             comp = ps_comp.
             find next ps_mstr use-index ps_comp where ps_comp = comp
             no-lock no-error.
             if available ps_mstr then leave.
          end.
           end.
           if level < 1 then leave.

           if eff_date = ? or (eff_date <> ? and
           (ps_start = ? or ps_start <= eff_date)
           and (ps_end = ? or eff_date <= ps_end)) then do:

          desc1 = "".
          um = "".
          iss_pol = no.
          xxstatus = "".       /*judy*/
          phantom = no.
/*hj01*/    yn = NO .
          find pt_mstr where pt_part = ps_par no-lock no-error.
          if available pt_mstr then do:
             desc1 = pt_desc1.
             um = pt_um.
             iss_pol = pt_iss_pol.
             xxstatus = pt_status.   /*judy*/
             phantom = pt_phantom.
/*hj01--*/  
            CASE o_char :
                WHEN "!O" THEN DO:          
                    IF pt_status <> "o" THEN yn = NO .
                    ELSE yn = YES .
                END.
                WHEN "ALL" THEN DO: 
                    yn = NO.
                END.
                OTHERWISE DO:
                    IF pt_status = o_char THEN yn = NO .
                    ELSE yn = YES .
                END.
            END.
/*--hj01*/
          end.
/*G265*/          else do:
/*GG68/*G265*/       find bom_mstr no-lock where bom_parent = ps_comp   */
/*GG68/*G265*/       no-error.                                          */
/*GG68*/             find bom_mstr no-lock where bom_parent = ps_par no-error.
/*G265*/             if available bom_mstr then
/*G265*/             assign um = bom_batch_um
/*G265*/                 desc1 = bom_desc.
/*G265*/          end.
/*judy*/
         if phantom
         then
            l_phantom  = getTermLabel("Yes",3).
         else
            l_phantom =  getTermLabel("No",3).

         if iss_pol
         then
            l_iss_pol  = getTermLabel("Yes",3).
         else
            l_iss_pol =  getTermLabel("No",3).
/*judy*/
 
          record[level] = recid(ps_mstr).
          lvl = ".......".
          lvl = substring(lvl,1,min(level - 1,6)) + string(level).
          if length(lvl) > 7 then
          lvl = substring(lvl,length(lvl) - 6,7).

/*G265*/          if transtype = "BM" then do with frame bm down:
             if frame-line = frame-down and frame-down <> 0
             and available pt_mstr and pt_desc2 > "" /*hj01*/ AND yn = NO then down 1
             with frame bm.

/*hj01*/    IF yn = NO THEN display lvl ps_par desc1 ps_qty_per um  
                  l_phantom @ phantom
               ps_ps_code
               l_iss_pol @ iss_pol
/*judy*/   xxstatus   ps_rmks
             with frame bm STREAM-IO /*GUI*/ .

/*G265*/             if available bom_mstr and not available pt_mstr then
/*N0F3 /*G265*/      display {&bmwuiqa_p_5} @ phantom with frame bm. */
/*N0F3*/             /*hj01*/ IF yn = NO THEN display getTermLabel("BOM",3) FORMAT "x(3)" @ phantom with frame bm STREAM-IO /*GUI*/ .
             if available pt_mstr and pt_desc2 > ""
             then do with frame bm:
/*hj01*/        IF yn = NO THEN down 1.
/*hj01*/        IF yn = NO THEN display pt_desc2 @ desc1 WITH STREAM-IO /*GUI*/ .
             end.
/*G265*/          end.
/*G265*/          else do with frame fm down:
             if frame-line = frame-down and frame-down <> 0
             and available pt_mstr and pt_desc2 > "" /*hj01*/ AND yn = NO then down 1
             with frame fm.
/*hj01*/ IF yn = NO THEN
             display lvl ps_par desc1
             ps_qty_per_b ps_qty_type um
             l_phantom @ phantom
             ps_ps_code
             /*judy*/   xxstatus   ps_rmks
             with frame fm STREAM-IO /*GUI*/ .

/*G265*/             if available bom_mstr and not available pt_mstr /*hj01*/ AND yn = NO then
/*N0F3 /*G265*/      display {&bmwuiqa_p_5} @ phantom with frame bm. */
/*N0F3*/             display getTermLabel("BOM",3) FORMAT "x(3)" @ phantom with frame bm STREAM-IO /*GUI*/ .
             if available pt_mstr and pt_desc2 > ""
             then do with frame fm:
/*hj01*/    IF yn = NO THEN down 1.
/*hj01*/    IF yn = NO THEN display pt_desc2 @ desc1 WITH STREAM-IO /*GUI*/ .
             end.
/*G265*/          end.

          if (level < maxlevel or maxlevel = 0 ) /*hj01*/ AND yn = NO then do:
             comp = ps_par.
             level = level + 1.
             find first ps_mstr use-index ps_comp where ps_comp = comp
             no-lock no-error.

/*J3J4*/        if not available ps_mstr then
/*J3J4*/        do:
/*J3J4*/           run p-getbom.
/*J3J4*/        end. /* NOT AVAIL PS_MSTR */


          end.
          else do:
             find next ps_mstr use-index ps_comp where ps_comp = comp
             no-lock no-error.

/*J3J4*/        if not available ps_mstr then
/*J3J4*/        do:
/*J3J4*/           run p-getbom.
/*J3J4*/        end. /* NOT AVAIL PS_MSTR */


          end.
           end.
           else do:
          find next ps_mstr use-index ps_comp where ps_comp = comp
          no-lock no-error.
           end.
        end.


        {mfreset.i}
/*GUI*/ {mfgrptrm.i} /*Report-to-Window*/

        {mfmsg.i 8 1}
     end.
     global_part = parent.

/*K124*/ {wbrp04.i &frame-spec = a}

/*J3J4*/ /* IF THE PRODUCT STRUCTURE RECORD IS NOT AVAILABLE THEN THIS  */
/*J3J4*/ /* PROCEDURE EXPLODES FURTHER USING THE PTP_DET AND PT-MSTR    */
/*J3J4*/ /* BY VERIFYING IF THE COMPONENT EXISTS AS A BOM CODE FOR ANY  */
/*J3J4*/ /* OTHER ITEMS.                                                */

/*J3J4*/ PROCEDURE p-getbom:
/*J3J4*/    if l_next = yes then do:
/*J3J4*/       for first ptp_det
/*J3J4*/          fields(ptp_bom_code ptp_part)
/*J3J4*/          where ptp_det.ptp_bom_code = comp
/*J3J4*/       no-lock : end. /* FOR FIRST PTP_DET */
/*J3J4*/       if available ptp_det then do:
/*J3J4*/          l_nextptp = yes.
/*J3J4*/          for first ptmstr1
/*J3J4*/             fields(pt_bom_code pt_desc1 pt_desc2
/*J3J4*/                    pt_iss_pol pt_part pt_phantom pt_status)
/*J3J4*/             where  ptmstr1.pt_part = ptp_part
/*J3J4*/          no-lock : end. /* FOR FIRST PTMSTR1 */
/*J3J4*/       end. /* IF AVAILABLE PTP_DET */
/*J3J4*/       else
/*J3J4*/          for first ptmstr1
/*J3J4*/             fields(pt_bom_code pt_desc1 pt_desc2
/*J3J4*/                    pt_iss_pol pt_part pt_phantom pt_status)
/*J3J4*/             where ptmstr1.pt_bom_code = comp
/*J3J4*/          no-lock : end. /* FOR FIRST PTMSTR1 */

/*J3J4*/       for first psmstr
/*J3J4*/          fields(ps_comp ps_end ps_lt_off ps_par
/*J3J4*/                 ps_ps_code ps_qty_per ps_qty_per_b
/*J3J4*/                 ps_qty_type ps_ref ps_scrp_pct ps_start ps_rmks)
/*J3J4*/          where psmstr.ps_par = comp
/*J3J4*/       no-lock : end. /* FOR FIRST PSMSTR */
/*J3J4*/       if available psmstr then
/*J3J4*/          assign
/*J3J4*/             l_psrecid = recid(psmstr)
/*J3J4*/             l_level = level.
/*J3J4*/    end. /* L_NEXT = YES */
/*J3J4*/    else do:
/*J3J4*/       for first psmstr
/*J3J4*/          fields(ps_comp ps_end ps_lt_off ps_par
/*J3J4*/                 ps_ps_code ps_qty_per ps_qty_per_b
/*J3J4*/                 ps_qty_type ps_ref ps_scrp_pct ps_start ps_rmks)
/*J3J4*/          where recid(psmstr) = l_psrecid
/*J3J4*/       no-lock : end. /* FOR FIRST PSMSTR */
/*J3J4*/       find next ptp_det
/*J3J4*/          where ptp_det.ptp_bom_code = psmstr.ps_par
/*J3J4*/       no-lock no-error.
/*J3J4*/       if available ptp_det then do:
/*J3J4*/          for first ptmstr1
/*J3J4*/             fields(pt_bom_code pt_desc1 pt_desc2
/*J3J4*/                    pt_iss_pol pt_part pt_phantom pt_status)
/*J3J4*/             where ptmstr1.pt_part = ptp_part
/*J3J4*/          no-lock : end. /* FOR FIRST PTMSTR1 */
/*J3J4*/       end. /* IF AVAIL PTP_DET */
/*J3J4*/       else do:
/*J3J4*/          if l_nextptp = yes then
/*J3J4*/          do:
/*J3J4*/             for first ptmstr1
/*J3J4*/             fields(pt_bom_code pt_desc1 pt_desc2
/*J3J4*/                    pt_iss_pol pt_part pt_phantom pt_status)
/*J3J4*/                where ptmstr1.pt_bom_code = psmstr.ps_par
/*J3J4*/             no-lock : end. /* FOR FIRST PTMSTR1 */
/*J3J4*/             l_nextptp = no.
/*J3J4*/          end. /* IF L_NEXTPTP = YES */
/*J3J4*/          else do:
/*J3J4*/             find next ptmstr1
/*J3J4*/                where ptmstr1.pt_bom_code = psmstr.ps_par
/*J3J4*/                and not(can-find (first ptp_det
/*J3J4*/                        where ptp_part = pt_part and
/*J3J4*/                        ptp_bom_code = ptmstr1.pt_bom_code))
/*J3J4*/             no-lock no-error.
/*J3J4*/             l_nextptp = no.
/*J3J4*/          end. /* ELSE IF L_NEXTPTP = NO */
/*J3J4*/       end. /* IF NOT AVAILABLE PTP_DET */
/*J3J4*/       if available ptmstr1 then do:
/*J3J4*/          level = l_level.
/*J3J4*/       end. /* IF AVAILABLE PTMSTR1 */
/*J3J4*/       end. /* ELSE IF L_NEXT = NO */

/*J3J4*/       bomloop1:
/*J3J4*/       do while available ptmstr1:
/*J3J4*/          l_next = no.
/*J3J4*/          for first ps_mstr
/*J3J4*/          fields(ps_comp ps_end ps_lt_off ps_par
/*J3J4*/                 ps_ps_code ps_qty_per ps_qty_per_b
/*J3J4*/                 ps_qty_type ps_ref ps_scrp_pct ps_start ps_rmks)
/*J3J4*/             where ps_mstr.ps_comp = ptmstr1.pt_part use-index ps_comp
/*J3J4*/          no-lock : end. /* FOR FIRST PS_MSTR */
/*J3J4*/          if available ps_mstr then do:
/*J3J4*/                comp = ptmstr1.pt_part.
/*J3J4*/                leave bomloop1.
/*J3J4*/          end. /* if available ps_mstr */
/*J3J4*/          else if not available ps_mstr then do:
/*J3J4*/             find next  ptp_det where ptp_det.ptp_bom_code = comp
/*J3J4*/             no-lock no-error.
/*J3J4*/                if available ptp_det then do:
/*J3J4*/                   find next ptmstr1
/*J3J4*/                      where ptmstr1.pt_part = ptp_part
/*J3J4*/                   no-lock no-error.
/*J3J4*/                end. /* IF AVAIL PTP_DET */
/*J3J4*/                else  do:
/*J3J4*/                   find next ptmstr1
/*J3J4*/                      where ptmstr1.pt_bom_code = comp
/*J3J4*/                   no-lock no-error.
/*J3J4*/                   if not available ptmstr1 then do:
/*J3J4*/                      for first psmstr
/*J3J4*/                         fields(ps_comp ps_end ps_lt_off ps_par
/*J3J4*/                                ps_ps_code ps_qty_per ps_qty_per_b
/*J3J4*/                                ps_qty_type ps_ref ps_scrp_pct ps_start ps_rmks)
/*J3J4*/                         where recid(psmstr) = l_psrecid
/*J3J4*/                      no-lock : end. /* FOR FIRST PSMSTR */
/*J3J4*/                      find next ptmstr1
/*J3J4*/                         where ptmstr1.pt_bom_code = psmstr.ps_par
/*J3J4*/                         and not(can-find (first ptp_det
/*J3J4*/                                 where ptp_part = pt_part and
/*J3J4*/                                 ptp_bom_code = ptmstr1.pt_bom_code))
/*J3J4*/                      no-lock no-error.
/*J3J4*/                   end. /* IF NOT AVAILABLE PTMSTR1 */
/*J3J4*/                end. /* ELSE DO */
/*J3J4*/          end. /* IF NOT AVAIL PS_MSTR */
/*J3J4*/       end. /* IF AVAILABLE PTMSTR BOMLOOP1 */
/*J3J4*/ END PROCEDURE. /* P-GETBOM */
