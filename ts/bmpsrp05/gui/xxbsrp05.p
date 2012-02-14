/* GUI CONVERTED from bmpsrp05.p (converter v1.78) Tue Jun 14 00:11:49 2005 */
/* bmpsrp05.p - SUMMARIZED BILL OF MATERIAL COST REPORT                      */
/* Copyright 1986-2005 QAD Inc., Carpinteria, CA, USA.                       */
/* All rights reserved worldwide.  This is an unpublished work.              */
/* $Revision: 1.6.1.12 $                                                              */
/*V8:ConvertMode=FullGUIReport                                               */
/* REVISION: 5.0      LAST MODIFIED: 01/09/90   BY: MLB  *B494*              */
/* REVISION: 5.0      LAST MODIFIED: 03/27/90   BY: RAM  *B635*              */
/* REVISION: 6.0      LAST MODIFIED: 10/26/90   BY: emb  *D145*              */
/* REVISION: 6.0      LAST MODIFIED: 07/02/91   BY: emb  *D743*              */
/* REVISION: 7.0      LAST MODIFIED: 09/25/91   BY: pma  *F003*              */
/* Revision: 7.3      Last edit:     09/27/93   By: jcd  *G247*              */
/* REVISION: 7.3      LAST MODIFIED: 04/28/93   BY: pma  *GA41*              */
/* REVISION: 7.3      LAST MODIFIED: 04/28/93   BY: qzl  *GB28*              */
/* REVISION: 7.3      LAST MODIFIED: 10/21/93   BY: pxd  *GG43* rev only     */
/* REVISION: 7.3      LAST MODIFIED: 10/29/93   BY: ais  *GG77*              */
/* REVISION: 7.3      LAST MODIFIED: 12/29/93   BY: ais  *FL07*              */
/* REVISION: 7.2      LAST MODIFIED: 03/03/94   BY: ais  *FM55*              */
/* REVISION: 7.3      LAST MODIFIED: 12/06/94   BY: cdt  *GO70*              */
/* REVISION: 7.3      LAST MODIFIED: 03/08/95   BY: pxd  *F0JP*              */
/* REVISION: 7.3      LAST MODIFIED: 07/31/96   BY: *G2B9* Julie Milligan    */
/* REVISION: 8.6      LAST MODIFIED: 10/14/97   BY: GYK    *K0ZF*            */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane         */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan        */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane  */
/* REVISION: 9.1      LAST MODIFIED: 07/04/00   BY: *N0F3* Mudit Mehta       */
/* REVISION: 9.1      LAST MODIFIED: 08/11/00   BY: *N0KK* jyn               */
/* Old ECO marker removed, but no ECO header exists *F0PN*                   */
/* Revision: 1.6.1.6       BY: Samir Bavkar     DATE: 04/12/02  ECO: *P000*  */
/* Revision: 1.6.1.7  BY: Amit Chaturvedi DATE: 07/26/02 ECO: *N1PJ* */
/* Revision: 1.6.1.9  BY: Paul Donnelly (SB) DATE: 06/26/03 ECO: *Q00B*      */
/* Revision: 1.6.1.10 BY: Rajinder Kamra     DATE: 06/23/03 ECO: *Q003*      */
/* Revision: 1.6.1.11 BY: Nishit Vadhavkar   DATE: 12/11/03 ECO: *P1F4*      */
/* $Revision: 1.6.1.12 $       BY: Priya Idnani       DATE: 06/13/05 ECO: *P3PB*      */
/*-Revision end---------------------------------------------------------------*/

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/* DISPLAY TITLE */

/*GUI global preprocessor directive settings */
&GLOBAL-DEFINE PP_PGM_RP TRUE
&GLOBAL-DEFINE PP_ENV_GUI TRUE


/*GUI preprocessor directive settings */
&SCOPED-DEFINE PP_GUI_CONVERT_MODE REPORT

{mfdtitle.i "081125.1"}

define new shared variable comp         like ps_comp.
define new shared variable pline        like pt_prod_line.
define new shared variable pline1       like pt_prod_line.
define new shared variable site         like si_site.
define new shared variable maxlevel     as   integer
   format ">>>" label "Levels"          no-undo.
define new shared variable eff_date     as   date label "As of Date".
define new shared variable l_gl_std     like mfc_logical no-undo.

define variable extmtl like sct_mtl_tl  format "->>>>>>>>9.99<<<<<<<"  no-undo.
define variable extlbr like sct_lbr_tl  format "->>>>>>>>9.99<<<<<<<"  no-undo.
define variable extbdn like sct_bdn_tl  format "->>>>>>>>9.99<<<<<<<"  no-undo.
define variable extovh like sct_ovh_tl  format "->>>>>>>>9.99<<<<<<<"  no-undo.
define variable extsub like sct_sub_tl  format "->>>>>>>>9.99<<<<<<<"  no-undo.
define variable exttot like sct_cst_tot format "->>>>>>>>9.99<<<<<<<"  no-undo.

define variable level     as   integer     no-undo.
define variable part      like pt_part     no-undo.
define variable part1     like pt_part     no-undo.
define variable buyer     like pt_buyer    no-undo.
define variable buyer1    like pt_buyer    no-undo.
define variable um        like pt_um       no-undo.
define variable pmcode    like pt_pm_code  no-undo.
define variable mtl       like extmtl      no-undo.
define variable lbr       like extlbr      no-undo.
define variable bdn       like extbdn      no-undo.
define variable ovh       like extovh      no-undo.
define variable sub       like extsub      no-undo.
define variable unittot   like exttot      no-undo.
define variable csset     like sct_sim     no-undo.
define variable item-code as   character   no-undo.
define variable get-next  as   logical     no-undo.
define variable onlybom   as   logical     no-undo.
define variable l_linked  like mfc_logical no-undo.
define variable des       as   character   format "x(27)" no-undo.
define variable sum_usage like ps_qty_per  column-label "Summarized!Usage"
   no-undo.
define variable newpage   like mfc_logical initial yes
   label  "New Page Each Parent"                              no-undo.
define variable details_printed like mfc_logical              no-undo.
define variable i               as   integer                  no-undo.
define variable l_part          as   character initial "bmpsrp05.p" no-undo.
/* SS - 20080526.1 - B */ define buffer ptmstr for pt_mstr.
/* SS - 20080526.1 - B */ define variable desc1       as   character   format "x(27)" no-undo.
/* SS - 20080526.1 - B */ define variable desc2       as   character   format "x(27)" no-undo.
/* SS - 20080526.1 - B */ define variable rmks        as   character   format "x(8)" initial "*****"  no-undo.
/* SS - 20080526.1 - B */ define variable deltot like sct_cst_tot format "->>>>>>>>9.99<<<<<<<"  no-undo.

DEF VAR v_vend AS CHAR.

/* SS - 20080526.1 - B */  define new shared  temp-table  tmp_det
   field  tmp_par   like ps_par
   field  tmp_comp  like ps_comp
   field  tmp_qty   like ps_qty_per
   field  tmp_mtl   like  sct_mtl_tl
   field  tmp_sub   like sct_sub_tl 
   field  tmp_tot   like sct_sub_tl
   INDEX index1 tmp_par tmp_comp .


/*GUI preprocessor Frame A define */
&SCOPED-DEFINE PP_FRAME_NAME A

FORM /*GUI*/      
 RECT-FRAME       AT ROW 1.4 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1   COLUMN 3 NO-LABEL
 SKIP(.1)  /*GUI*/
skip(1)
   part         colon 20     part1 label {t001.i} colon 45
   pline        colon 20    pline1 label {t001.i} colon 45
   buyer        colon 20    buyer1 label {t001.i} colon 45
   skip(1)
   eff_date     colon 30
   maxlevel     colon 30
   newpage      colon 30 skip(1)
   site         colon 30 skip (1)
   csset        colon 30
   cs_desc      colon 30
   cs_method    colon 30
   cs_type      colon 30
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

assign
   site     = global_site
   eff_date = today.

for first si_mstr
   fields( si_domain si_cur_set si_db si_site)
    where si_mstr.si_domain = global_domain and  si_site = site
   no-lock:

   csset = si_cur_set.
end. /* FOR FIRST si_mstr */

for first icc_ctrl
    where icc_ctrl.icc_domain = global_domain no-lock:
end. /* FOR FIRST icc_ctrl */

{wbrp01.i}


/*GUI*/ {mfguirpa.i true "printer" 132 " " " " " "  }

/*GUI repeat : */
/*GUI*/ procedure p-enable-ui:


   if pline1 = hi_char then pline1 = "".
   if part1  = hi_char then part1  = "".
   if buyer1 = hi_char then buyer1 = "".

   details_printed = no.

   if c-application-mode <> 'web'
   then
      
run p-action-fields (input "display").
run p-action-fields (input "enable").
end procedure. /* p-enable-ui, replacement of Data-Entry GUI*/

/*GUI*/ procedure p-report-quote:
 /* EDITING */

      {wbrp06.i &command = update &fields = "  part part1 pline pline1  buyer
         buyer1 eff_date maxlevel newpage site csset" &frm = "a"}

      if  (c-application-mode <> 'web')
      or  (c-application-mode = 'web'
      and (c-web-request begins 'data'))
      then do:

         bcdparm = "".
         {mfquoter.i part        }
         {mfquoter.i part1       }
         {mfquoter.i pline       }
         {mfquoter.i pline1      }
         {mfquoter.i buyer       }
         {mfquoter.i buyer1      }
         {mfquoter.i eff_date    }
         {mfquoter.i maxlevel    }
         {mfquoter.i newpage     }
         {mfquoter.i site        }
         {mfquoter.i csset       }

         if pline1 = "" then pline1 = hi_char.
         if part1  = "" then part1  = hi_char.
         if buyer1 = "" then buyer1 = hi_char.

         /* MOVED VALADATIONS BELOW MFQUOTER CALLS FOR GUI CONVERSION. */
         if true
         then do:

            for first si_mstr
               fields( si_domain si_cur_set si_db si_site)
                where si_mstr.si_domain = global_domain and  si_site = site
               no-lock:
            end. /* FOR FIRST si_mstr */

            if not available si_mstr
            then do:

               /* SITE DOES NOT EXIST */
               {pxmsg.i &MSGNUM=708 &ERRORLEVEL=3}
               if c-application-mode = 'web'
               then
                  return.
               else
                  /*GUI NEXT-PROMPT removed */
               /*GUI UNDO removed */ RETURN ERROR.
            end. /* IF NOT AVAILABLE si_mstr */

            if si_db <> global_db
            then do:

               /* SITE IS NOT ASSIGNED TO THIS DOMAIN */
               {pxmsg.i &MSGNUM=6251 &ERRORLEVEL=3}
               if c-application-mode = 'web'
               then
                  return.
               else
                  /*GUI NEXT-PROMPT removed */
               /*GUI UNDO removed */ RETURN ERROR.
            end. /* IF si_db <> global_db */

            if csset = ""
            then do:

               /* BLANK NOT ALLOWED */
               {pxmsg.i &MSGNUM=40 &ERRORLEVEL=3}
               if c-application-mode = 'web'
               then
                  return.
               else
                  /*GUI NEXT-PROMPT removed */
               /*GUI UNDO removed */ RETURN ERROR.
            end. /* IF csset = "" */

            find cs_mstr
                where cs_mstr.cs_domain = global_domain and  cs_set = csset
               no-lock no-error.

            if not available cs_mstr
            then do:

               /* COST SET DOES NOT EXIST */
               {pxmsg.i &MSGNUM=5407 &ERRORLEVEL=3}
               if c-application-mode = 'web'
               then
                  return.
               else
                  /*GUI NEXT-PROMPT removed */
               /*GUI UNDO removed */ RETURN ERROR.
            end. /* IF NOT AVAILABLE cs_mstr */

            display
               cs_desc
               cs_method
               cs_type
            with frame a.

         end. /* IF true */

      end. /* IF  (c-application-mode <> 'web') ... */

      /* OUTPUT DESTINATION SELECTION */
      
/*GUI*/ end procedure. /* p-report-quote */
/*GUI - Field Trigger Section */

/*GUI MFSELxxx removed*/
/*GUI*/ procedure p-report:
/*GUI*/   {gpprtrpa.i "printer" 132 " " " " " " " " }
/*GUI*/   mainloop: do on error undo, return error on endkey undo, return error:
find cs_mstr
                where cs_mstr.cs_domain = global_domain and  cs_set = csset
               no-lock no-error.

define buffer ptmstr for pt_mstr.



      /* CREATE PAGE TITLE BLOCK */
      {mfphead.i}

      FORM /*GUI*/ 
         site
         csset
         skip(1)
      with STREAM-IO /*GUI*/  frame pgtop /* page-top */ side-labels width 132.

      /* SET EXTERNAL LABELS */
      setFrameLabels(frame pgtop:handle).
      display
         site
         csset
      with frame pgtop STREAM-IO /*GUI*/ .

      for first bom_mstr
         fields( bom_domain bom_desc bom_parent)
          where bom_mstr.bom_domain = global_domain and  bom_parent >= part
           and bom_parent <= part1
         no-lock:
      end. /* FOR FIRST bom_mstr */

      for first pt_mstr
         fields( pt_domain pt_bom_code pt_buyer   pt_desc1     pt_desc2
                 pt_vend
                pt_part     pt_pm_code pt_prod_line pt_um pt_phantom)
          where pt_mstr.pt_domain = global_domain and  pt_part >=part
           and pt_part <= part1
         no-lock:
      end. /* FOR FIRST pt_mstr */

      
/*GUI mainloop removed */

      repeat with frame b:

 /* SS - del        FORM /*GUI*/ 
            pk_part format "x(27)"
            pmcode
            sum_usage
            um
            mtl     column-label "Unit Material!Ext Material"
            lbr     column-label "Unit Labor!Ext Labor"
            bdn     column-label "Unit Burden!Ext Burden"
            ovh     column-label "Unit Overhead!Ext Overhead"
            sub     column-label "Unit Sub!Ext Sub"
            unittot column-label "Unit Total!Ext Total"
         with STREAM-IO /*GUI*/  frame b width 132 no-box down. */
/* SS - add*/        FORM /*GUI*/ 
              v_vend                  COLUMN-LABEL "零件供应商"
              pk_part format "x(27)"  column-label "产品/物料"  
            desc1 		    column-label "说明1"
	        desc2 		    column-label "说明2"
            pmcode              column-label "P/M"
            sum_usage 		    column-label "用量"    
            um                      column-label "单位"  
            mtl           column-label "采购成本"
            sub           column-label "转包成本"  
            unittot       column-label "单个成本"
            exttot        column-label  "金额"
	    rmks          column-label "备注"
         with STREAM-IO /*GUI*/  frame b width 240 no-box down. 

         /* SET EXTERNAL LABELS */
      /*   setFrameLabels(frame b:handle). */

         assign
            get-next = no
            onlybom  = no.

         if available bom_mstr
         and available pt_mstr
         then do:

            item-code = pt_part.

            if pt_part = bom_parent
            and pt_prod_line < pline
             or pt_prod_line > pline1
            then
               get-next = yes.
            else
            if pt_part > bom_parent
            then
               assign
                  onlybom   = yes
                  item-code = bom_parent.
         end. /* HAVE BOTH bom_mstr & pt_mstr */
         else
         if available bom_mstr
         then
            assign
               onlybom   = yes
               item-code = bom_parent.
         else
         if available pt_mstr
         then do:

            item-code = pt_part.
            if pt_prod_line < pline
            or pt_prod_line > pline1
            then
               get-next = yes.
         end. /* ONLY pt_mstr AVAILABLE */
         else
            leave.

         if not onlybom
         and available pt_mstr
         and not get-next
         then do:

            for first ptp_det
               fields( ptp_domain ptp_bom_code ptp_buyer ptp_part ptp_pm_code ptp_phantom
                       ptp_vend ptp_site)
                where ptp_det.ptp_domain = global_domain and  ptp_part = pt_part
                 and ptp_site = site
               no-lock:
            end. /* FOR FIRST ptp_det */

            if available ptp_det
            and ptp_buyer < buyer
            and ptp_buyer > buyer1
            then
               get-next = yes.
            else
            if not available ptp_det
            and pt_buyer < buyer
            and pt_buyer > buyer1
            then
               get-next = yes.

         end. /* IF NOT onlybom */

         comp = item-code.

         /* RECOGNIZE SITE LINKS FOR GL COST WHEN A GL STANDARD COST SET IS */
         /* SPECIFIED */

         /* CHECK IF THE COST SET ENTERED IS OF TYPE GL AND STANDARD METHOD */
         for first cs_mstr
            fields( cs_domain cs_desc cs_method cs_set cs_type)
             where cs_mstr.cs_domain = global_domain and  cs_set = csset
            no-lock:

            if cs_type = "GL"
            and cs_method = "STD"
            then
               l_gl_std = true.
         end. /* FOR FIRST cs_mstr */

         /* IF THIS PARENT IS LINKED TO ANOTHER SITE FOR THE COST     */
         /* DISPLAY THE COST FROM THE GL COST SITE (in_gl_cost_site). */
         l_linked = false.
         if l_gl_std
         then
            for first in_mstr
               fields( in_domain in_gl_cost_site in_part in_site)
                where in_mstr.in_domain = global_domain and  in_part = pt_part
                 and in_site = site
               no-lock:
               if in_gl_cost_site <> in_site
               then
                  assign
                     l_linked = true
                          des = "  " + getTermLabel("GL_COST_SOURCE_SITE",12)
                              + ": "
                              + string(in_gl_cost_site).
            end. /* FOR FIRST in_mstr */

         if not get-next
         then do:

            /* CHECK IF COST SIMULATION TOTAL DETAILS EXIST     */
            /* AND IF THEY DO NOT EXIST THEN CREATE THE DETAILS */
            if l_linked
            then do:
               /* FOR FIRST USED TO KEEP THE RECORD IN SCOPE */
               for first sct_det
                  fields(sct_domain sct_bdn_ll sct_bdn_tl sct_cst_date
                         sct_lbr_ll sct_lbr_tl sct_mtl_ll sct_mtl_tl
                         sct_ovh_ll sct_ovh_tl sct_part   sct_sim
                         sct_site   sct_sub_ll sct_sub_tl)
                  where sct_det.sct_domain = global_domain
                  and   sct_sim            = csset
                  and   sct_part           = item-code
                  and   sct_site           = in_gl_cost_site
               no-lock:
               end. /* FOR FIRST sct_det */
               if not available (sct_det)
               then do:
                  {gpsct08.i &part = l_part
                             &set  = csset
                             &site = in_gl_cost_site}
               end. /* IF NOT AVAILABLE (sct_det) */
            end. /* IF l_linked */
            else do:
               /* FOR FIRST USED TO KEEP THE RECORD IN SCOPE */
               for first sct_det
                  fields(sct_domain sct_bdn_ll sct_bdn_tl sct_cst_date
                         sct_lbr_ll sct_lbr_tl sct_mtl_ll sct_mtl_tl
                         sct_ovh_ll sct_ovh_tl sct_part   sct_sim
                         sct_site   sct_sub_ll sct_sub_tl)
                  where sct_det.sct_domain = global_domain
                  and   sct_sim            = csset
                  and   sct_part           = item-code
                  and   sct_site           = site
               no-lock:
               end. /* FOR FIRST sct_det */
               if not available (sct_det)
               then do:
                  {gpsct08.i &part = l_part
                             &set  = csset
                             &site = site}
              end. /* IF NOT CAN-FIND */
           end. /* ELSE DO */
         end. /* IF NOT get-next */

         if not onlybom
         and available pt_mstr
         then do:

            if pt_pm_code <> ""
            and pt_bom_code <> ""
            then
               comp = pt_bom_code.

            for first ptp_det
               fields( ptp_domain ptp_bom_code ptp_buyer ptp_part ptp_pm_code
               ptp_phantom ptp_vend ptp_site)
                where ptp_det.ptp_domain = global_domain and  ptp_part = pt_part
                 and ptp_site = site
               no-lock:
               comp = if ptp_bom_code <> ""
                      then
                         ptp_bom_code
                      else
                         ptp_part.
            end. /* FOR FIRST ptp_det */
         end. /* IF NOT onlybom */

         for first ps_mstr
            fields( ps_domain ps_par)
             where ps_mstr.ps_domain = global_domain and  ps_par = comp
            no-lock:
         end. /* FOR FIRST ps_mstr */
         if not available ps_mstr
         then
            get-next = yes.

         if available sct_det
         and (not get-next)
         and (not l_linked)
         then do:

            /* EXPLODE PART BY MODIFIED PICKLIST LOGIC */
/* SS - 20080526.1 - B */            {gprun.i ""xxbsrp5a.p""}

            for first pk_det
               fields( pk_domain pk_end pk_part pk_qty pk_start pk_user)
                where pk_det.pk_domain = global_domain and (  eff_date  =  ?
                  or (eff_date <> ?
                 and (pk_start =  ?
                  or  pk_start <= eff_date)
                 and (pk_end   =  ?
                  or eff_date  <= pk_end))
               ) no-lock:
            end. /* FOR FIRST pk_det */

            if not available pk_det
            then
               get-next = yes.
         end. /* NOT get-next */

         if available sct_det
         and not get-next
         then do:

            /* SS - 20080728.1 - B */
            /*
            if page-size - line-counter < 7
            then
               page.
               */
            /* SS - 20080728.1 - E */

/* SS - del********************************************************************

            /* DISPLAY END-ITEM */
            if not onlybom
            then
               display
                  string(item-code,"x(19)")
                  + "("
                  + caps(getTermLabel("PARENT",6)) + ")" @ pk_part WITH STREAM-IO /*GUI*/ .

            else
               display
                  string(item-code,"x(19)")
                  + "("
                  + getTermLabel("BOM",6) + ")" @ pk_part WITH STREAM-IO /*GUI*/ .

            down 1.

            display
               "  " + getTermLabel("THIS_LEVEL",12) format "x(12)" @ sum_usage
               "  " + getTermLabel("BOM",6) + " = "
                    + comp when (item-code <> comp)                @ pk_part
               sct_mtl_tl                                          @ mtl
               sct_lbr_tl                                          @ lbr
               sct_bdn_tl                                          @ bdn
               sct_ovh_tl                                          @ ovh
               sct_sub_tl                                          @ sub
               (sct_mtl_tl + sct_lbr_tl + sct_bdn_tl + sct_ovh_tl +
               sct_sub_tl)                                         @ unittot WITH STREAM-IO /*GUI*/ .
            down 1 with frame b.

            display
               "  " + pt_desc1 format "x(26)" when (not onlybom
                     and available pt_mstr)                   @ pk_part
               "  " + bom_desc format "x(26)"
                     when (onlybom)                           @ pk_part
               getTermLabel("LOWER_LEVELS",12) format "x(12)" @ sum_usage
               sct_mtl_ll                                     @ mtl
               sct_lbr_ll                                     @ lbr
               sct_bdn_ll                                     @ bdn
               sct_ovh_ll                                     @ ovh
               sct_sub_ll                                     @ sub
               (sct_mtl_ll + sct_lbr_ll + sct_bdn_ll + sct_ovh_ll +
               sct_sub_ll)                                    @ unittot WITH STREAM-IO /*GUI*/ .
            down 1 with frame b.

            display
               "  " + pt_desc2 format "x(26)"
               when (available pt_mstr)
                                                         @ pk_part
               "  " when (onlybom)                       @ pk_part
               des  when (l_linked)                      @ pk_part
               getTermLabelRt("TOTAL",12) format "x(12)" @ sum_usage
               (sct_mtl_ll + sct_mtl_tl)                 @ mtl
               (sct_lbr_ll + sct_lbr_tl)                 @ lbr
               (sct_bdn_ll + sct_bdn_tl)                 @ bdn
               (sct_ovh_ll + sct_ovh_tl)                 @ ovh
               (sct_sub_ll + sct_sub_tl)                 @ sub
               ( sct_mtl_ll + sct_lbr_ll + sct_bdn_ll + sct_ovh_ll
               + sct_sub_ll + sct_mtl_tl + sct_lbr_tl + sct_bdn_tl
               + sct_ovh_tl + sct_sub_tl)                @ unittot WITH STREAM-IO /*GUI*/ .
            down 2 with frame b.

 * SS - del********************************************************************/

/* SS - * add **************************************************************/

            v_vend = "".
            IF AVAIL ptp_det THEN v_vend = ptp_vend.
            IF AVAIL pt_mstr AND v_vend = "" THEN v_vend = pt_vend .

          display 
                  v_vend 
                  pt_part @ pk_part 
	                      trim(pt_desc1) @ desc1
		                  trim(pt_desc2) @ desc2 
                  (sct_mtl_ll + sct_mtl_tl)                 @ mtl
                  (sct_sub_ll + sct_sub_tl)                 @ sub
	          (sct_mtl_ll + sct_sub_ll   
                  + sct_mtl_tl   + sct_sub_tl)              @ unittot WITH FRAME b.  
             DOWN 1 .

/* SS - * add **************************************************************/

/* SS - * add *************************************************************/
           for each tmp_det :

	             l_linked = false.
                     if l_gl_std
                     then
                        for first in_mstr
                           fields( in_domain in_gl_cost_site in_part in_site)
                           no-lock
                            where in_mstr.in_domain = global_domain and
                            in_part = tmp_comp
                             and in_site = site :
                           if in_gl_cost_site <> in_site
                           then
                              assign
                                 l_linked = true .
                        end. /* FOR FIRST in_mstr */

                      

                     /* CHECK IF COST SIMULATION TOTAL DETAILS EXIST     */
                     /* AND IF THEY DO NOT EXIST THEN CREATE THE DETAILS */
                     if l_linked
                     then do:
                        
                           for first sct_det
                              fields(sct_domain   sct_bdn_ll sct_bdn_tl
                                     sct_cst_date sct_lbr_ll sct_lbr_tl
                                     sct_mtl_ll   sct_mtl_tl sct_ovh_ll
                                     sct_ovh_tl   sct_part   sct_sim
                                     sct_site     sct_sub_ll sct_sub_tl)
                              where sct_det.sct_domain = global_domain
                              and   sct_sim            = csset
                              and   sct_part           = tmp_comp
                              and   sct_site           = in_gl_cost_site
                           no-lock:
                           end. /* FOR FIRST sct_det */
                        
                     end. /* IF l_linked */
                     else do:
                        
                           for first sct_det
                              fields(sct_domain   sct_bdn_ll sct_bdn_tl
                                     sct_cst_date sct_lbr_ll sct_lbr_tl
                                     sct_mtl_ll   sct_mtl_tl sct_ovh_ll
                                     sct_ovh_tl   sct_part   sct_sim
                                     sct_site     sct_sub_ll sct_sub_tl)
                              where sct_det.sct_domain = global_domain
                              and   sct_sim            = csset
                              and   sct_part           = tmp_comp
                              and   sct_site           = site
                           no-lock:
                           end. /* FOR FIRST sct_det */
                        
                     end. /* ELSE DO */

                     if available sct_det
                     then do:
                        assign
                           tmp_mtl   = sct_mtl_tl + sct_mtl_ll
                           tmp_sub   = sct_sub_tl + sct_sub_ll
                           tmp_tot   = tmp_mtl    + tmp_sub .
                           
                     end. /* IF AVAILABLE sct_det */
/* SS -  display tmp_par tmp_comp tmp_qty tmp_tot  .*/ 
                     
	   end.
/* SS - * add **************************************************************/


            /*DISPLAY COMPONENTS*/
            /* IF PARENT IS LINKED TO ANOTHER SITE FOR COST DISPLAY  */
            /* ITS COST AT THE GL SOURCE SITE, DO NOT DISPLAY THE    */
            /* COMPONENTS.                                           */

            if not l_linked
            then
               for each pk_det
                  fields( pk_domain pk_end pk_part pk_qty pk_start pk_user)
                  no-lock
                   where pk_det.pk_domain = global_domain and (  (pk_user  =
                   mfguser)
                    and (eff_date =  ?
                     or (eff_date <> ?
                    and (pk_start =  ?
                     or pk_start  <= eff_date)
                    and (pk_end   =  ?
                     or eff_date  <= pk_end)))
                  ) break by pk_user
                        by pk_part
                  with frame b
                  on endkey undo, leave mainloop:

                  accumulate pk_qty (total by pk_part).

                  if last-of(pk_part)
                  then do:

                     /* IF THIS COMPONENT IS LINKED TO ANOTHER SITE FOR  */
                     /* COST DISPLAY THE COST FROM THE GL COST SITE      */
                     /* (in_gl_cost_site)                                */
                     l_linked = false.
                     if l_gl_std
                     then
                        for first in_mstr
                           fields( in_domain in_gl_cost_site in_part in_site)
                           no-lock
                            where in_mstr.in_domain = global_domain and
                            in_part = pk_part
                             and in_site = site :
                           if in_gl_cost_site <> in_site
                           then
                              assign
                                 l_linked = true
                                      des = "  "
                                          + getTermLabel("GL_COST_SOURCE_SITE",
                                            12)
                                          + ": "
                                          + string(in_gl_cost_site).
                        end. /* FOR FIRST in_mstr */

                     for first ptmstr
                         where ptmstr.pt_domain = global_domain and
                         ptmstr.pt_part = pk_part
                        no-lock:
                     end. /* FOR FIRST ptmstr */

                     /* CHECK IF COST SIMULATION TOTAL DETAILS EXIST     */
                     /* AND IF THEY DO NOT EXIST THEN CREATE THE DETAILS */
                     if l_linked
                     then do:
                        if available (ptmstr)
                        then do:
                           /* FOR FIRST USED TO KEEP THE RECORD IN SCOPE */
                           for first sct_det
                              fields(sct_domain   sct_bdn_ll sct_bdn_tl
                                     sct_cst_date sct_lbr_ll sct_lbr_tl
                                     sct_mtl_ll   sct_mtl_tl sct_ovh_ll
                                     sct_ovh_tl   sct_part   sct_sim
                                     sct_site     sct_sub_ll sct_sub_tl)
                              where sct_det.sct_domain = global_domain
                              and   sct_sim            = csset
                              and   sct_part           = ptmstr.pt_part
                              and   sct_site           = in_gl_cost_site
                           no-lock:
                           end. /* FOR FIRST sct_det */
                        end. /* IF AVAILABLE (ptmstr) */
                        else do:
                          {gpsct08.i &part = l_part
                                     &set  = csset
                                     &site = in_gl_cost_site}
                        end. /* ELSE DO */
                     end. /* IF l_linked */
                     else do:
                        if available (ptmstr)
                        then do:
                           /* FOR FIRST USED TO KEEP THE RECORD IN SCOPE */
                           for first sct_det
                              fields(sct_domain   sct_bdn_ll sct_bdn_tl
                                     sct_cst_date sct_lbr_ll sct_lbr_tl
                                     sct_mtl_ll   sct_mtl_tl sct_ovh_ll
                                     sct_ovh_tl   sct_part   sct_sim
                                     sct_site     sct_sub_ll sct_sub_tl)
                              where sct_det.sct_domain = global_domain
                              and   sct_sim            = csset
                              and   sct_part           = ptmstr.pt_part
                              and   sct_site           = site
                           no-lock:
                           end. /* FOR FIRST sct_det */
                        end. /* IF AVAILABLE (ptmstr) */
                        else do:
                           {gpsct08.i &part = l_part
                                      &set  = csset
                                      &site = site}
                        end. /* ELSE DO*/
                     end. /* ELSE DO */

                     if available sct_det
                     then do:
                        /* SS - del                assign
                           sum_usage = accum total by pk_part pk_qty
                           mtl       = sct_mtl_tl + sct_mtl_ll
                           lbr       = sct_lbr_tl + sct_lbr_ll
                           bdn       = sct_bdn_tl + sct_bdn_ll
                           ovh       = sct_ovh_tl + sct_ovh_ll
                           sub       = sct_sub_tl + sct_sub_ll
                           unittot   = mtl + lbr + bdn + ovh + sub
                           extmtl    = sum_usage * mtl
                           extlbr    = sum_usage * lbr
                           extbdn    = sum_usage * bdn
                           extovh    = sum_usage * ovh
                           extsub    = sum_usage * sub
                           exttot    = sum_usage * unittot.  ****/
/* SS - add*/              assign
                           sum_usage = accum total by pk_part pk_qty
                           mtl       = sct_mtl_tl 
                           lbr       = sct_lbr_tl 
                           bdn       = sct_bdn_tl 
                           ovh       = sct_ovh_tl 
                           sub       = sct_sub_tl 
                           unittot   = mtl + sub
                           extmtl    = sum_usage * mtl
                           extlbr    = sum_usage * lbr
                           extbdn    = sum_usage * bdn
                           extovh    = sum_usage * ovh
                           extsub    = sum_usage * sub
                           exttot    = sum_usage * unittot.   


                        if sct_part = l_part
                        then do:
                           for each spt_det
                              where spt_det.spt_domain = global_domain
                              and   spt_site           = sct_site
                              and   spt_sim            = sct_sim
                              and   spt_part           = sct_part
                              exclusive-lock:

                              delete spt_det.

                           end. /* FOR EACH spt_det */

                           /* DELETES THE CREATED RECORD */
                           delete sct_det.

                        end. /* IF sct_part = l_part */

                     end. /* IF AVAILABLE sct_det */
                     else
                        assign
                           sum_usage = 0
                           mtl       = 0
                           lbr       = 0
                           bdn       = 0
                           ovh       = 0
                           sub       = 0
                           unittot   = 0
                           extmtl    = 0
                           extlbr    = 0
                           extbdn    = 0
                           extovh    = 0
                           extsub    = 0
                           exttot    = 0.

                        /* SS - 20080728.1 - B */
                        /*
                     if page-size - line-counter < 3
                     then
                        page.
                          */
                        /* SS - 20080728.1 - B */

                     for first ptp_det
                        fields( ptp_domain ptp_bom_code ptp_buyer ptp_part
                              ptp_vend ptp_pm_code  ptp_site ptp_phantom )
                         where ptp_det.ptp_domain = global_domain and  ptp_part
                          = ptmstr.pt_part
                          and ptp_site  = site
                          and ptp_buyer >= buyer
                          and ptp_buyer <= buyer1
                        no-lock:
                     end. /* FOR FIRST ptp_det */
/* SS - add ***********************************************************************
                     deltot = 0.
                     if  available ptp_det and ptp_pm_code = "P" 
                         or ptmstr.pt_pm_code = "P" and not available ptp_det then do:
    		 for each tmp_det  no-lock where tmp_par = ptmstr.pt_part:
			     deltot = deltot +  tmp_qty *  tmp_tot .
			     /*ts  display tmp_par tmp_comp tmp_qty tmp_tot  .*/ 

			 end. 
                     end.
                     if deltot <> 0 then do:
		                   mtl       = mtl - deltot .
                           unittot   = unittot - deltot.
                           extmtl    = sum_usage * mtl .
                           exttot    = sum_usage * unittot.
		     end.
* SS - add ************************************************************************/

/* SS - del *************************************************************************
                     display
                        pk_part
                        ptmstr.pt_um @ um
                        ptp_pm_code when (available ptp_det) @ pmcode
                        ptmstr.pt_pm_code when (not available ptp_det) @ pmcode
                        sum_usage
                        mtl
                        lbr
                        bdn
                        ovh
                        sub
                        unittot WITH STREAM-IO /*GUI*/ .

                     down 1 with frame b.

                     display
                        "  " + ptmstr.pt_desc1 format "x(26)" @ pk_part
                        extmtl @ mtl
                        extlbr @ lbr
                        extbdn @ bdn
                        extovh @ ovh
                        extsub @ sub
                        exttot @ unittot WITH STREAM-IO /*GUI*/ .

                     down 1 with frame b.

                     if available ptmstr
                     and ptmstr.pt_desc2 <> ""
                     then
                        display
                           "  " + ptmstr.pt_desc2 format "x(26)" @ pk_part WITH STREAM-IO /*GUI*/ .

                     if l_linked
                     then do:

                        display
                           des format "x(27)" @ pk_part WITH STREAM-IO /*GUI*/ .
                        down 1 with frame b.
                     end. /* IF l_linked */

                     down 1 with frame b.
* SS - del *************************************************************************/

                  v_vend = "".
                     IF AVAIL ptp_det THEN v_vend = ptp_vend.
                     IF AVAIL ptmstr AND v_vend = "" THEN v_vend = ptmstr.pt_vend .


/* SS - add*/        if unittot <> 0   AND NOT (available ptp_det AND ptp_phantom    OR
                            not available ptp_det AND  ptmstr.pt_phantom )    then do:
                     display
                           v_vend 
                           ptmstr.pt_part  @ pk_part 
	                         substring(ptmstr.pt_desc1,1, LENGTH(ptmstr.pt_desc1)) @ desc1
                             substring(ptmstr.pt_desc2,1, LENGTH(ptmstr.pt_desc2)) @ desc2
			                 ptmstr.pt_um @ um
                             ptp_pm_code when (available ptp_det) @ pmcode
                             ptmstr.pt_pm_code when (not available ptp_det) @ pmcode
                             sum_usage
			                 mtl
                             sub
	                        unittot
				exttot
				rmks with frame b. 
                        DOWN 1 .


/* SS - add*/        end.  /*if mtl <> 0 or sub <> 0 then do: */

                  end. /* IF LAST-OF(pk_part) */

                  
/*GUI*/ {mfguirex.i  "false"} /*Replace mfrpexit*/


               end. /* FOR EACH pk_det */

            details_printed = yes.

            /* SS - 20080728.1 - B */
            /*
            if details_printed
            then
               if newpage
               then
                  page.
              */
            /* SS - 20080728.1 - B */
         
/*GUI*/ {mfguichk.i } /*Replace mfrpchk*/

         end. /* AVAILABLE sct_det */

         /* GET THE NEXT bom_mstr AND pt_mstr */

         /* LOGIC FOR FINDING THE NEXT bom_mstr AND pt_mstr RECORDS */

         if available bom_mstr
         and available pt_mstr
         then do:

            if pt_part > bom_parent
            then
               find next bom_mstr
                   where bom_mstr.bom_domain = global_domain and  bom_parent >=
                   part
                    and bom_parent <= part1
                  no-lock no-error.
            else
            if bom_parent > pt_part
            then
               find next pt_mstr
                   where pt_mstr.pt_domain = global_domain and  pt_part >= part
                    and pt_part <= part1
                  no-lock no-error.
            else do:
               find next bom_mstr
                   where bom_mstr.bom_domain = global_domain and  bom_parent >=
                   part
                    and bom_parent <= part1
                  no-lock no-error.
               find next pt_mstr
                   where pt_mstr.pt_domain = global_domain and  pt_part >= part
                    and pt_part <= part1
                  no-lock no-error.
            end. /* ELSE DO , IF bom_parent > pt_part */
         end. /* IF AVAILABLE bom_mstr AND pt_mstr */
         else
         if available bom_mstr
         then
            find next bom_mstr
                where bom_mstr.bom_domain = global_domain and  bom_parent >=
                part
                 and bom_parent <= part1
               no-lock no-error.
         else
         if available pt_mstr
         then
            find next pt_mstr
                where pt_mstr.pt_domain = global_domain and  pt_part >= part
                 and pt_part <= part1
               no-lock no-error.
         else
            leave.

      end. /* MAINLOOP - repeat */

{mfdel.i pk_det " where pk_det.pk_domain = global_domain and  pk_user =
mfguser"}

      hide frame pgtop.
      
/*GUI*/ {mfguitrl.i} /*Replace mfrtrail*/

/*GUI*/ {mfgrptrm.i} /*Report-to-Window*/

end. /* REPEAT */

{wbrp04.i &frame-spec = a}

/*GUI*/ end procedure. /*p-report*/
/*GUI*/ {mfguirpb.i &flds=" part part1 pline pline1 buyer buyer1 eff_date maxlevel newpage site csset "} /*Drive the Report*/
