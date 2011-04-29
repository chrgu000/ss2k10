/* GUI CONVERTED from ictrrp04.p (converter v1.71) Tue Oct  6 14:32:15 1998 */
/* ictrrp04.p - TRANSACTION AUDIT TRAIL AVERAGE COST                    */
/* COPYRIGHT qad.inc. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK. */
/* web convert ictrrp04.p (converter v1.00) Fri Oct 10 13:57:13 1997 */
/* web tag in ictrrp04.p (converter v1.00) Mon Oct 06 14:17:34 1997 */
/*F0PN*/ /*K15Z*/ /*V8#ConvertMode=WebReport                            */
/*V8:ConvertMode=FullGUIReport                                 */
/* REVISION: 7.0      LAST MODIFIED: 03/06/92   BY: pma *F085**/
/* REVISION: 7.2      LAST MODIFIED: 10/25/95   BY: jym *F0VQ**/
/* REVISION: 8.6      LAST MODIFIED: 10/24/97   BY: bvm *K15Z**/

/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan   */

/*GUI global preprocessor directive settings */
&GLOBAL-DEFINE PP_PGM_RP TRUE
&GLOBAL-DEFINE PP_ENV_GUI TRUE


/*GUI preprocessor directive settings */
&SCOPED-DEFINE PP_GUI_CONVERT_MODE REPORT

{mfdtitle.i "e+ "}

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE ictrrp04_p_1 "数量"
/* MaxLen: Comment: */

&SCOPED-DEFINE ictrrp04_p_2 "单位成本"
/* MaxLen: Comment: */

&SCOPED-DEFINE ictrrp04_p_3 "库存价值"
/* MaxLen: Comment: */

&SCOPED-DEFINE ictrrp04_p_4 "期末  :"
/* MaxLen: Comment: */

&SCOPED-DEFINE ictrrp04_p_5 "变更  :"
/* MaxLen: Comment: */

&SCOPED-DEFINE ictrrp04_p_6 "开始  :"
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */


     define variable part like pt_part.
     define variable part1 like pt_part.
     define variable site like tr_site.
     define variable site1 like tr_site.
     define variable nbr like tr_nbr.
     define variable nbr1 like tr_nbr.
     define variable trdate like tr_date.
     define variable trdate1 like tr_date.
     define variable efdate like tr_effdate.
     define variable efdate1 like tr_date.
     define variable glref  like trgl_gl_ref.
     define variable glref1 like trgl_gl_ref.
     define variable gltnbr like glt_ref format "x(18)".
     define variable gltamt like glt_amt.
     define variable i as integer.
     define variable glt_yn like mfc_logical.
     define variable beg_cost like tr_price label {&ictrrp04_p_2}.
     define variable end_cost like tr_price.
     define variable beg_inv  like glt_amt label {&ictrrp04_p_3}.
     define variable end_inv  like glt_amt.
     define variable end_qty  like tr_begin_qoh label {&ictrrp04_p_1}.
     define variable XZ AS  CHARACTER FORMAT "x" label "只显示无参考号记录(Y/N)".
     define variable XZ1 AS  CHARACTER FORMAT "x" label "只显示有差异记录(Y/N)".
xz = "Y".
XZ1 = "Y".     
/*GUI preprocessor Frame A define */
&SCOPED-DEFINE PP_FRAME_NAME A

FORM /*GUI*/ 

        
 RECT-FRAME       AT ROW 1.4 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1   COLUMN 3 NO-LABEL
 SKIP(.1)  /*GUI*/
part           colon 20
        part1          label {t001.i} colon 49 skip
        site           colon 20
        site1          label {t001.i} colon 49 skip
        nbr            colon 20
        nbr1           label {t001.i} colon 49 skip
        efdate         colon 20
        efdate1        label {t001.i} colon 49 skip
        trdate         colon 20
        trdate1        label {t001.i} colon 49 skip
        glref          colon 20
        glref1         label {t001.i} colon 49 skip 
        xz             colon 20 skip
        xz1            colon 20 skip(1)
      SKIP(.4)  /*GUI*/
with frame a side-labels
/*K15Z*/ width 80 NO-BOX THREE-D /*GUI*/.

 DEFINE VARIABLE F-a-title AS CHARACTER.
 F-a-title = &IF (DEFINED(SELECTION_CRITERIA) = 0)
  &THEN " 选择条件 "
  &ELSE {&SELECTION_CRITERIA}
  &ENDIF .
 RECT-FRAME-LABEL:SCREEN-VALUE in frame a = F-a-title.
 RECT-FRAME-LABEL:WIDTH-PIXELS in frame a =
  FONT-TABLE:GET-TEXT-WIDTH-PIXELS(
  RECT-FRAME-LABEL:SCREEN-VALUE in frame a + " ", RECT-FRAME-LABEL:FONT).
 RECT-FRAME:HEIGHT-PIXELS in frame a =
  FRAME a:HEIGHT-PIXELS - RECT-FRAME:Y in frame a - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME a = FRAME a:WIDTH-CHARS - .5. /*GUI*/

/*GUI preprocessor Frame A undefine */
&UNDEFINE PP_FRAME_NAME



/*K15Z*/ {wbrp01.i}

        
/*GUI*/ {mfguirpa.i true  "printer" 132 }

/*GUI repeat : */
/*GUI*/ procedure p-enable-ui:

        if part1 = hi_char then part1 = "".
        if site1 = hi_char then site1 = "".
        if trdate = low_date then trdate = ?.
        if trdate1 = hi_date then trdate1 = ?.
        if efdate = low_date then efdate = ?.
        if efdate1 = hi_date then efdate1 = ?.
        if glref1 = hi_char then glref1 = "".


/*K15Z*/    if c-application-mode <> 'web':u then
            
run p-action-fields (input "display").
run p-action-fields (input "enable").
end procedure. /* p-enable-ui, replacement of Data-Entry GUI*/

/*GUI*/ procedure p-report-quote:


/*K15Z*/ {wbrp06.i &command = update &fields = " part part1 site site1 nbr nbr1
          efdate efdate1 trdate trdate1 glref glref1 xz xz1" &frm = "a"}

/*K15Z*/ if (c-application-mode <> 'web':u) or
/*K15Z*/ (c-application-mode = 'web':u and
/*K15Z*/ (c-web-request begins 'data':u)) then do:


        bcdparm = "".
        {mfquoter.i part    }
        {mfquoter.i part1   }
        {mfquoter.i site    }
        {mfquoter.i site1   }
        {mfquoter.i nbr     }
        {mfquoter.i nbr1    }
        {mfquoter.i efdate  }
        {mfquoter.i efdate1 }
        {mfquoter.i trdate  }
        {mfquoter.i trdate1 }
        {mfquoter.i glref   }
        {mfquoter.i glref1  }

        if part1 = "" then part1 = hi_char.
        if site1 = "" then site1 = hi_char.
        if trdate = ? then trdate = low_date.
        if trdate1 = ? then trdate1 = hi_date.
        if efdate = ? then efdate = low_date.
        if efdate1 = ? then efdate1 = hi_date.
        if glref1 = "" then glref1 = hi_char.

/*K15Z*/ end.

        /* SELECT PRINTER */
            
/*GUI*/ end procedure. /* p-report-quote */
/*GUI - Field Trigger Section */

/*GUI MFSELxxx removed*/
/*GUI*/ procedure p-report:
/*GUI*/   {gpprtrpa.i  "printer" 132}
/*GUI*/   mainloop: do on error undo, return error on endkey undo, return error:



        {mfphead.i}

        FORM /*GUI*/  header
        skip(1)
        with STREAM-IO /*GUI*/  frame a1 page-top
/*K15Z*/    width 132.
        view frame a1.

        gltamt = 0.
        gltnbr = "".
        i = 0.
        glt_yn = no.

        for each trgl_det
/*K15Z*/    no-lock
        where (trgl_type = "RCT-AVG") AND ((trgl_gl_ref = "" and xz = "y") OR XZ = "N"),
        each tr_hist
/*K15Z*/    no-lock
        where (tr_trnbr = trgl_trnbr)
        and (tr_part >= part and tr_part <= part1)
        and (tr_effdate >= efdate and tr_effdate <= efdate1)
/*F0VQ*/    and (tr_date >= trdate and tr_date <= trdate1)
        and ((tr_nbr >= nbr) and (tr_nbr <= nbr1 or nbr1 = ""))
        and (tr_site >= site and tr_site <= site1)
        and (tr_site >= site and tr_site <= site1)
        break by tr_part by tr_site by trgl_trnbr
        with frame b width 200 no-box.
        if xz = "n" and xz1 = "n" then do:
  if first-of(tr_part) and not first(tr_part) then do:
          if page-size - line-counter < 8 then page.
          else put skip(1) fill("=", 200) format "x(200)" skip(1).
           end.
           end.

          
           i = i + 1.
           if trgl_gl_ref >= glref and trgl_gl_ref <= glref1
           then glt_yn = yes.
           if i = 1 then gltnbr = trgl_gl_ref.
           else if i = 2 then gltnbr = gltnbr + "+".
           gltamt = gltamt + trgl_gl_amt.

           if last-of(trgl_trnbr) and glt_yn then do with frame b:

          find pt_mstr where pt_part = tr_part no-lock no-error.
          if available pt_mstr then do:

             if page-size - line-counter < 4 then page.

             end_cost = tr_mtl_std + tr_lbr_std + tr_bdn_std
                  + tr_ovh_std + tr_sub_std.
             end_qty = tr_begin_qoh + tr_qty_loc.
             end_inv = end_cost * end_qty.

             beg_inv = end_inv - gltamt.
             beg_cost = beg_inv / tr_begin_qoh.
             if beg_cost = ? then beg_cost = 0.
             IF (XZ1 = "Y" AND BEG_COST <> END_COST AND BEG_COST <> 0) OR XZ1 = "N" THEN DO:
            
             
             display pt_part tr_site TR_NBR TR_LOT tr_type tr_trnbr
                 gltnbr trgl_cr_acct
                 {&ictrrp04_p_6} @ tr_addr no-label
                 tr_begin_qoh @ end_qty
                 beg_cost
                 beg_inv WITH STREAM-IO /*GUI*/ .
             down.
             display {&ictrrp04_p_5} @ tr_addr
                 tr_qty_loc @ end_qty
                 tr_price @ beg_cost
                 gltamt @ beg_inv WITH STREAM-IO /*GUI*/ .
             down.
             display {&ictrrp04_p_4} @ tr_addr
                 end_qty
                 end_cost @ beg_cost
                 end_inv @ beg_inv WITH STREAM-IO /*GUI*/ .

/*                   if pt_desc1 <> "" then
             put pt_desc1 space(1) pt_desc2 skip.  */

             if tr_msg > 0 then do:
            find msg_mstr where msg_nbr  = tr_msg
            and msg_lang = global_user_lang no-lock no-error.
            if available msg_mstr then
            put msg_desc to 129.
             end.

             put skip(1).

             gltamt = 0.
             gltnbr = "".
             i = 0.
             glt_yn = no.
             END. /* END FOR XZ1 = "Y" */
          end.
           end.

           
/*GUI*/ {mfguirex.i } /*Replace mfrpexit*/

        end. /*for each*/

        /* REPORT TRAILER */

        
/*GUI*/ {mfguitrl.i} /*Replace mfrtrail*/

/*GUI*/ {mfgrptrm.i} /*Report-to-Window*/


     end.

/*K15Z*/ {wbrp04.i &frame-spec = a}

/*GUI*/ end procedure. /*p-report*/
/*GUI*/ {mfguirpb.i &flds=" part part1 site site1 nbr nbr1 efdate efdate1 trdate trdate1 glref glref1 XZ XZ1"} /*Drive the Report*/
