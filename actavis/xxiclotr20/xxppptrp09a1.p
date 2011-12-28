/* GUI CONVERTED from ppptrp08.p (converter v1.78) Fri Oct 29 14:37:38 2004 */
/* ppptrp08.p - INVENTORY DETAIL REPORT                                 */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                  */
/* All rights reserved worldwide.  This is an unpublished work.         */
/* $Revision: 1.9.1.12 $                                              */
/*V8:ConvertMode=FullGUIReport                                          */
/* REVISION: 6.0      LAST MODIFIED: 05/17/90   BY: WUG                 */
/* REVISION: 7.0      LAST MODIFIED: 09/25/91   BY: pma *F003*          */
/* REVISION: 7.0      LAST MODIFIED: 09/30/93   BY: pxd *GG10*          */
/* REVISION: 8.5      LAST MODIFIED: 10/26/94   BY: taf *J038*          */
/* REVISION: 7.3      LAST MODIFIED: 10/25/95   BY: jym *G1B5*          */
/* REVISION: 8.6      LAST MODIFIED: 10/09/97   BY: gyk *K0PW*          */
/* REVISION: 8.6      LAST MODIFIED: 10/16/97   BY: *J23C*  Manmohan Pardesi  */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane          */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan         */
/* REVISION: 8.6E     LAST MODIFIED: 01/01/00   BY: *J3NF* Sachin Shinde      */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane   */
/* REVISION: 9.1      LAST MODIFIED: 08/13/00   BY: *N0KQ* myb                */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* Revision: 1.9.1.4  BY: A.R. Jayram DATE: 05/12/02 ECO: *N1J5*              */
/* Revision: 1.9.1.6  BY: Paul Donnelly (SB) DATE: 06/28/03 ECO: *Q00K*       */
/* Revision: 1.9.1.8  BY: Rajaneesh S.       DATE: 08/27/03 ECO: *N2K5*       */
/* Revision: 1.9.1.9  BY: Geeta Kotian       DATE: 11/26/03 ECO: *P1CG*       */
/* $Revision: 1.9.1.12 $  BY: Michael Hansen  DATE: 07/14/04 ECO: *Q06H*      */
/*-Revision end---------------------------------------------------------------*/

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/
/* ss - 100508.1 by: jack */  /* 显示原厂到期日 ld__dte01*/

/* DISPLAY TITLE */

/*GUI global preprocessor directive settings */
&GLOBAL-DEFINE PP_PGM_RP TRUE
&GLOBAL-DEFINE PP_ENV_GUI TRUE


/*GUI preprocessor directive settings */
&SCOPED-DEFINE PP_GUI_CONVERT_MODE REPORT

/*
{mfdtitle.i "1+ "}
*/
{mfdtitle.i "100604.1 "}

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE ppptrp08_p_1 "Variance %"
/* MaxLen: Comment: */

&SCOPED-DEFINE ppptrp08_p_2 "Summary/Detail"
&SCOPED-DEFINE ppptrp09_p_2 "F-复检日/Y-原厂日"
/* MaxLen: Comment: */

&SCOPED-DEFINE ppptrp08_p_3 "Ref"
/* MaxLen: Comment: */

&SCOPED-DEFINE ppptrp08_p_4 "Ext Current Cost"
/* MaxLen: Comment: */

&SCOPED-DEFINE ppptrp08_p_5 "Ext Std Cost"
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */

define variable abc     like pt_abc       no-undo.
define variable abc1    like pt_abc       no-undo.
define variable loc     like ld_loc       no-undo.
define variable loc1    like ld_loc       no-undo.
define variable site    like ld_site      no-undo.
define variable site1   like ld_site      no-undo.
define variable part    like pt_part      no-undo.
define variable part1   like pt_part      no-undo.
define variable lot     like ld_lot       no-undo.
define variable lot1    like ld_lot       no-undo.
define variable line    like pt_prod_line no-undo.
define variable line1   like pt_prod_line no-undo.

define variable grade   like ld_grade     no-undo.
define variable grade1  like ld_grade     no-undo.
define variable assay   like ld_assay     no-undo.
define variable assay1  like ld_assay     no-undo.
define variable stat    like ld_status    no-undo.
define variable stat1   like ld_status    no-undo.

define variable expire  like ld_expire    no-undo.
define variable expire1 like ld_expire    no-undo.

define variable expire2  like ld_expire    NO-UNDO LABEL "原厂到期".
define variable expire3 like ld_expire    no-undo.

define variable ext_std as decimal label {&ppptrp08_p_5}
   format "->>>,>>>,>>9.99" no-undo.
define variable ext_cur as decimal label {&ppptrp08_p_4}
   format "->>>,>>>,>>9.99" no-undo.
define variable cost_var as decimal label {&ppptrp08_p_1}
   format "->>>,>>9.9%" no-undo.
define variable acc as decimal extent 2
   format "->>>,>>>,>>9.99" no-undo.
define variable ld-printed        like mfc_logical no-undo.
define variable total_qty_oh      like in_qty_oh  no-undo.
define variable first-loc         like mfc_logical no-undo.
define variable parts_printed     as   integer    no-undo.
define variable locations_printed as   integer    no-undo.
define variable summary           as   logical label {&ppptrp08_p_2}  format {&ppptrp08_p_2}.
define variable summary1           as   logical label {&ppptrp09_p_2}
   format {&ppptrp09_p_2} INITIAL YES.

define variable ll_esignature like mfc_logical no-undo
                label "Display E-Signature Details".
define variable ll_is_needed like mfc_logical no-undo.

/* SELECT FORM */

/*GUI preprocessor Frame A define */
&SCOPED-DEFINE PP_FRAME_NAME A

FORM /*GUI*/ 
   
 RECT-FRAME       AT ROW 1.4 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1   COLUMN 3 NO-LABEL
 SKIP(.1)  /*GUI*/
line           colon 18
   line1          label {t001.i} colon 49 skip
   part           colon 18
   part1          label {t001.i} colon 49 skip
   lot            colon 18
   lot1           label {t001.i} colon 49 skip
   abc            colon 18
   abc1           label {t001.i} colon 49
   site           colon 18
   site1          label {t001.i} colon 49
   loc            colon 18
   loc1           label {t001.i} colon 49
   grade          colon 18
   grade1         label {t001.i} colon 49
   assay          colon 18
   assay1         label {t001.i} colon 49
   stat           colon 18
   stat1          label {t001.i} colon 49
    summary1        colon 30
    expire         colon 18
   expire1        label {t001.i} colon 49 
 
   expire2         colon 18
   expire3        label {t001.i} colon 49 skip (1)
   summary        colon 30
   ll_esignature  colon 30
 SKIP(.4)  /*GUI*/
with frame a side-labels width 80 attr-space NO-BOX THREE-D /*GUI*/.

 DEFINE VARIABLE F-a-title AS CHARACTER.
 F-a-title = &IF DEFINED(GPLABEL_I)=0 &THEN
   &IF (DEFINED(SELECTION_CRITERIA) = 0)
   &THEN " Selection Criteria "
   &ELSE {&SELECTION_CRITERIA}
   &ENDIF 
&ELSE 
   getTermLabel("SELECTION_CRITERIA", 25).
&ENDIF.
 RECT-FRAME-LABEL:SCREEN-VALUE in frame a = F-a-title.
 RECT-FRAME-LABEL:WIDTH-PIXELS in frame a =
  FONT-TABLE:GET-TEXT-WIDTH-PIXELS(
  RECT-FRAME-LABEL:SCREEN-VALUE in frame a + " ", RECT-FRAME-LABEL:FONT).
 RECT-FRAME:HEIGHT-PIXELS in frame a =
  FRAME a:HEIGHT-PIXELS - RECT-FRAME:Y in frame a - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME a = FRAME a:WIDTH-CHARS - .5. /*GUI*/

/*GUI preprocessor Frame A undefine */
&UNDEFINE PP_FRAME_NAME



/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

/* BEGIN E-SIGNATURES CODE */
{essinsup.i &CATEGORY="0006"
            &PROGRAM_TYPE="REPORT"
            &TOP_TABLE="ld_det"
            &REPORT_WIDTH=250}

assign ll_is_needed  = isEsigConfigured("0006")
       ll_esignature = ll_is_needed.

if not ll_is_needed then
   assign ll_esignature:sensitive in frame a = no
          ll_esignature:hidden in frame a    = yes.
/* END E-SIGNATURES CODE */

/* REPORT BLOCK */

{wbrp01.i}

/*GUI*/ {mfguirpa.i true "printer" 250 " " " " " "  }

/*GUI repeat : */
/*GUI*/ procedure p-enable-ui:


   if line1 = hi_char
   then
      line1 = "".
   if lot1  = hi_char
   then
      lot1  = "".
   if part1 = hi_char
   then
      part1 = "".
   if abc1  = hi_char
   then
      abc1  = "".
   if site1 = hi_char
   then
      site1 = "".
   if loc1  = hi_char
   then
      loc1  = "".
   if grade1 = hi_char
   then
      grade1 = "".
   if stat1  = hi_char
   then
      stat1  = "".
   if expire = low_date
   then
      expire = ?.
   if expire1 = hi_date
   then
      expire1 = ?.
    if expire2 = low_date
   then
      expire2 = ?.
   if expire3 = hi_date
   then
      expire3 = ?.

   if c-application-mode <> 'web'
   then
      
run p-action-fields (input "display").
run p-action-fields (input "enable").
end procedure. /* p-enable-ui, replacement of Data-Entry GUI*/

/*GUI*/ procedure p-report-quote:


   if ll_is_needed then
   do:
      {wbrp06.i &command = update
                &fields = " line line1 part part1 lot lot1
                            abc abc1 site site1 loc loc1 grade grade1
                            assay assay1 stat stat1  summary1 expire
                            expire1  expire2 expire3 summary ll_esignature "
                &frm = "a"}
   end.
   else
   do:
      {wbrp06.i &command = update
                &fields = "  line line1 part part1  lot lot1 abc abc1 site site1
                             loc loc1 grade grade1 assay assay1 stat stat1 summary1 expire expire1 expire2
                             expire3 summary"
                &frm = "a"}
   end.

   if (c-application-mode <> 'web')
   or (c-application-mode = 'web' and
      (c-web-request begins 'data'))
   then do:

      bcdparm = "".

      {mfquoter.i line   }
      {mfquoter.i line1  }
      {mfquoter.i part   }
      {mfquoter.i part1  }
      {mfquoter.i lot    }
      {mfquoter.i lot1   }
      {mfquoter.i abc    }
      {mfquoter.i abc1   }
      {mfquoter.i site   }
      {mfquoter.i site1  }
      {mfquoter.i loc    }
      {mfquoter.i loc1   }
      {mfquoter.i grade  }
      {mfquoter.i grade1 }
      {mfquoter.i assay  }
      {mfquoter.i assay1 }
      {mfquoter.i stat   }
      {mfquoter.i stat1  }
      /*
      {mfquoter.i expire }
      {mfquoter.i expire1}
      */
      {mfquoter.i expire2 }
      {mfquoter.i expire3}

      {mfquoter.i summary}
      {mfquoter.i ll_esignature}

      if line1 = ""
      then
         line1 = hi_char.
      if part1 = ""
      then
         part1 = hi_char.
      if lot1  = ""
      then
         lot1  = hi_char.
      if abc1  = ""
      then
         abc1  = hi_char.
      if site1 = ""
      then
         site1 = hi_char.
      if loc1  = ""
      then
         loc1 = hi_char.
      if grade1 = ""
      then
         grade1 = hi_char.
      if stat1  = ""
      then
         stat1  = hi_char.
      if expire = ?
      then
         expire = low_date.
      
      if expire1 = ?
      then
         expire1 = hi_date.

      if expire2 = ?
      then
         expire2 = low_date.
      
      if expire3 = ?
      then
         expire3 = hi_date.

   end. /* IF (c-application-mode <> 'web') OR .. */

   /* E-Signature Persistent Procedure initialization */
   if  ll_esignature then
      run initESig.

   /* OUTPUT DESTINATION SELECTION */
   
/*GUI*/ end procedure. /* p-report-quote */
/*GUI - Field Trigger Section */

/*GUI MFSELxxx removed*/
/*GUI*/ procedure p-report:
/*GUI*/   {gpprtrpa.i "printer" 250 " " " " " " " " }
/*GUI*/   mainloop: do on error undo, return error on endkey undo, return error:



   {mfphead.i}
     
  
   IF summary1 = NO  THEN DO:
 
   for each ld_det
       fields( ld_domain ld_assay ld_date ld_expire ld__dte01 ld_grade ld_loc ld_lot ld_part
        ld_qty_all ld_qty_oh ld_ref ld_site ld_status oid_ld_det)
      
    where ld_det.ld_domain = global_domain and (  ld_part >= part
     and ld_part <= part1
     and ld_site >= site
     and ld_site <= site1
     and ld_loc  >= loc
     and ld_loc  <= loc1
     and (ld_lot >= lot         and
          ld_lot <= lot1)
     and (ld_grade   >= grade   and
          ld_grade   <= grade1)
     and ((ld_assay  >= assay   and
           ld_assay  <= assay1) or
           assay1     = 0)
     and (ld_status  >= stat    and
          ld_status  <= stat1)
     /* and ((ld_expire >= expire  and
           ld_expire <= expire1)
     or  expire  = low_date
     and ld_expire = ?
     or  expire1 = hi_date
     and ld_expire = ?)
     /**** tony added in 2010-06-04 **/
     OR  */ AND ((ld__dte01 >= expire2  and
           ld__dte01 <= expire3)
     or  expire2 = low_date
     and ld__dte01 = ?
     or  expire2 = hi_date
     and ld__dte01 = ?)


   ) no-lock,

   each in_mstr
   fields( in_domain in_abc in_part in_qty_all in_qty_avail in_qty_nonet
   in_qty_oh
           in_qty_ord in_qty_req in_site)
    where in_mstr.in_domain = global_domain and  in_part = ld_part
     and in_site = ld_site
     and in_abc >= abc
     and in_abc <= abc1
    no-lock,

       each is_mstr
   fields( is_domain is_avail is_nettable is_overissue is_status)
    where is_mstr.is_domain = global_domain and  is_status = ld_status
   no-lock,

       each pt_mstr
   fields( pt_domain pt_desc1 pt_desc2 pt_part pt_prod_line pt_um)
    where pt_mstr.pt_domain = global_domain and  pt_part = ld_part
     and (pt_prod_line >= line
     and pt_prod_line  <= line1)
   no-lock
   break by pt_prod_line
         by pt_part
         by ld_site
         by ld_loc
         by ld_lot
         by ld_ref
   with frame c down width 250:

      /* SET EXTERNAL LABELS */
      setFrameLabels(frame c:handle).
      if first-of(ld_site)
      then do
         with frame b down width 250:
         /* SET EXTERNAL LABELS */
         setFrameLabels(frame b:handle).
         if page-size - line-counter < 8
         then
            page.

         display
            pt_prod_line
            in_part
            in_site
            in_abc
            pt_um
            (in_qty_oh + in_qty_nonet) @ in_qty_oh
            in_qty_avail
            in_qty_nonet
            in_qty_req
            in_qty_all
            in_qty_ord WITH STREAM-IO /*GUI*/ .
         down 1.
         put space(3) pt_desc1  pt_desc2 skip.
      end. /* IF  FIRST-OF(ld_site) */

      if summary = no
      then do:
         if  first-of(ld_lot)
         and last-of(ld_lot)
         and ld_ref = ""
         then do:
            display
               space(5)
               ld_loc
               ld_lot
               ld_ref format "x(8)" column-label {&ppptrp08_p_3}
               ld_qty_oh
               ld_qty_all
               ld_date   FORMAT "9999/99/99"
               ld_expire FORMAT "9999/99/99"
               ld__dte01 FORMAT "9999/99/99" LABEL "原厂到期日"
               ld_grade
               ld_assay
               ld_status
               is_avail
               is_nettable
               is_overissue WITH STREAM-IO /*GUI*/ .
         end. /* IF FIRST-OF(ld_lot) AND LAST-OF(ld_lot) ...*/
         else do:
            if first-of(ld_lot)
            then
               display
                  space(5)
                  ld_loc
                  ld_lot
                  ld_ref format "x(8)" column-label {&ppptrp08_p_3}
                  ld_qty_oh
                  ld_qty_all
                  ld_date   FORMAT "9999/99/99"
                  ld_expire FORMAT "9999/99/99"
                  ld__dte01 FORMAT "9999/99/99" LABEL "原厂到期日"
                  ld_grade
                  ld_assay
                  ld_status
                  is_avail
                  is_nettable
                  is_overissue WITH STREAM-IO /*GUI*/ .
            else
               display
                  ld_ref format "x(8)" column-label {&ppptrp08_p_3}
                  ld_qty_oh
                  ld_qty_all
                  ld_date   FORMAT "9999/99/99"
                  ld_expire FORMAT "9999/99/99"
                  ld__dte01 FORMAT "9999/99/99" LABEL "原厂到期日"
                  ld_grade
                  ld_assay
                  ld_status
                  is_avail
                  is_nettable
                  is_overissue WITH STREAM-IO /*GUI*/ .
         end. /* IF FIRST-OF(ld_lot) AND LAST-OF(ld_lot) ... ELSE DO */

        /* BEGIN E-SIGNATURES CODE */
        /* Display the latest E-Signature */
        if ll_esignature then
           run reportLatestESig( buffer ld_det ).
        /* END E-SIGNATURES CODE */

      end. /* IF summary = NO */
      
/*GUI*/ {mfguichk.i } /*Replace mfrpchk*/

   end. /* FOR EACH ld_det ... */
   END. 
   ELSE  DO:
     for each ld_det
       fields( ld_domain ld_assay ld_date ld_expire ld__dte01 ld_grade ld_loc ld_lot ld_part
        ld_qty_all ld_qty_oh ld_ref ld_site ld_status oid_ld_det)
      
    where ld_det.ld_domain = global_domain and (  ld_part >= part
     and ld_part <= part1
     and ld_site >= site
     and ld_site <= site1
     and ld_loc  >= loc
     and ld_loc  <= loc1
     and (ld_lot >= lot         and
          ld_lot <= lot1)
     and (ld_grade   >= grade   and
          ld_grade   <= grade1)
     and ((ld_assay  >= assay   and
           ld_assay  <= assay1) or
           assay1     = 0)
     and (ld_status  >= stat    and
          ld_status  <= stat1)
      and ((ld_expire >= expire  and
           ld_expire <= expire1)
     or  expire  = low_date
     and ld_expire = ?
     or  expire1 = hi_date
     and ld_expire = ?))
      no-lock,

   each in_mstr
   fields( in_domain in_abc in_part in_qty_all in_qty_avail in_qty_nonet
   in_qty_oh
           in_qty_ord in_qty_req in_site)
    where in_mstr.in_domain = global_domain and  in_part = ld_part
     and in_site = ld_site
     and in_abc >= abc
     and in_abc <= abc1
    no-lock,

       each is_mstr
   fields( is_domain is_avail is_nettable is_overissue is_status)
    where is_mstr.is_domain = global_domain and  is_status = ld_status
   no-lock,

       each pt_mstr
   fields( pt_domain pt_desc1 pt_desc2 pt_part pt_prod_line pt_um)
    where pt_mstr.pt_domain = global_domain and  pt_part = ld_part
     and (pt_prod_line >= line
     and pt_prod_line  <= line1)
   no-lock
   break by pt_prod_line
         by pt_part
         by ld_site
         by ld_loc
         by ld_lot
         by ld_ref
   with frame cc down width 250:

      /* SET EXTERNAL LABELS */
      setFrameLabels(frame c:handle).
      if first-of(ld_site)
      then do
         with frame bb down width 250:
         /* SET EXTERNAL LABELS */
         setFrameLabels(frame bb:handle).
         if page-size - line-counter < 8
         then
            page.

         display
            pt_prod_line
            in_part
            in_site
            in_abc
            pt_um
            (in_qty_oh + in_qty_nonet) @ in_qty_oh
            in_qty_avail
            in_qty_nonet
            in_qty_req
            in_qty_all
            in_qty_ord WITH STREAM-IO /*GUI*/ .
         down 1.
         put space(3) pt_desc1  pt_desc2 skip.
      end. /* IF  FIRST-OF(ld_site) */

      if summary = no
      then do:
         if  first-of(ld_lot)
         and last-of(ld_lot)
         and ld_ref = ""
         then do:
            display
               space(5)
               ld_loc
               ld_lot
               ld_ref format "x(8)" column-label {&ppptrp08_p_3}
               ld_qty_oh
               ld_qty_all
               ld_date    FORMAT "9999/99/99"
               ld_expire  FORMAT "9999/99/99"
               ld__dte01  FORMAT "9999/99/99" LABEL "原厂到期日"
               ld_grade
               ld_assay
               ld_status
               is_avail
               is_nettable
               is_overissue WITH STREAM-IO /*GUI*/ .
         end. /* IF FIRST-OF(ld_lot) AND LAST-OF(ld_lot) ...*/
         else do:
            if first-of(ld_lot)
            then
               display
                  space(5)
                  ld_loc
                  ld_lot
                  ld_ref format "x(8)" column-label {&ppptrp08_p_3}
                  ld_qty_oh
                  ld_qty_all
                  ld_date   FORMAT "9999/99/99"
                  ld_expire FORMAT "9999/99/99"
                  ld__dte01 FORMAT "9999/99/99" LABEL "原厂到期日"
                  ld_grade
                  ld_assay
                  ld_status
                  is_avail
                  is_nettable
                  is_overissue WITH STREAM-IO /*GUI*/ .
            else
               display
                  ld_ref format "x(8)" column-label {&ppptrp08_p_3}
                  ld_qty_oh
                  ld_qty_all
                  ld_date  FORMAT "9999/99/99"
                  ld_expire FORMAT "9999/99/99"
                  ld__dte01 FORMAT "9999/99/99" LABEL "原厂到期日"
                  ld_grade
                  ld_assay
                  ld_status
                  is_avail
                  is_nettable
                  is_overissue WITH STREAM-IO /*GUI*/ .
         end. /* IF FIRST-OF(ld_lot) AND LAST-OF(ld_lot) ... ELSE DO */

        /* BEGIN E-SIGNATURES CODE */
        /* Display the latest E-Signature */
        if ll_esignature then
           run reportLatestESig( buffer ld_det ).
        /* END E-SIGNATURES CODE */

      end. /* IF summary = NO */
      
/*GUI*/ {mfguichk.i } /*Replace mfrpchk*/

   end. /* FOR EACH ld_det ... */



   END. /** summary1 ********/

   /* BEGIN E-SIGNATURES CODE */
   /* Display the E-Signature data structure fields */
   if ll_esignature then
      run reportStructureESig.

   /* E-Sig cleaning */
   if ll_esignature then
      run cleanupESig.
   /* END E-SIGNATURES CODE */

   /* REPORT TRAILER */
   
/*GUI*/ {mfguitrl.i} /*Replace mfrtrail*/

/*GUI*/ {mfgrptrm.i} /*Report-to-Window*/


end. /* REPEAT */

{wbrp04.i &frame-spec = a}

/*GUI*/ end procedure. /*p-report*/
/*GUI*/ {mfguirpb.i &flds=" line line1 part part1 lot lot1 abc abc1 site site1 loc loc1 grade grade1 assay assay1 stat stat1  summary1 expire expire1  expire2 expire3 summary ll_esignature  "} /*Drive the Report*/
