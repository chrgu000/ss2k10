/* xxretrrp.p  - Repetitive Picklist Transfer Report                          */
/* COPYRIGHT DCEC. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK.          */
/* V1                 Developped: 03/28/01      BY: Rao Haobin                */
/* $Revision:eb21sp12  $ BY: Jordan Lin  DATE: 08/13/12  ECO: *SS-20120813.1***/
/* 反映领料单实际转移量的报表                                                 */

{mfdtitle.i "120813.1"}
define variable nbr like tr_nbr.
define variable nbr1 like tr_nbr.
define variable lineno as integer.
define variable vqty like tr_qty_loc.
form
skip(1)
     tr_nbr           label "加工单号  "   at 48
/*   tr_effdate          label "生效日期  " at 48*/
     lineno label "页号" at 80
     with no-box side-labels width 180 frame b.

/*GUI preprocessor Frame A define */
&SCOPED-DEFINE PP_FRAME_NAME A

 FORM /*GUI*/
 RECT-FRAME       AT ROW 1.4 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1   COLUMN 3 NO-LABEL
 SKIP(.1)  /*GUI*/
       nbr             label "加工单号" colon 18
       nbr1           label {t001.i} colon 49
  skip
with frame a side-labels width 80 attr-space NO-BOX THREE-D /*GUI*/.


 DEFINE VARIABLE F-a-title AS CHARACTER.
 F-a-title = " 选择条件 ".
 RECT-FRAME-LABEL:SCREEN-VALUE in frame a = F-a-title.
 RECT-FRAME-LABEL:WIDTH-PIXELS in frame a =
  FONT-TABLE:GET-TEXT-WIDTH-PIXELS(
  RECT-FRAME-LABEL:SCREEN-VALUE in frame a + " ", RECT-FRAME-LABEL:FONT).
 RECT-FRAME:HEIGHT-PIXELS in frame a =
  FRAME a:HEIGHT-PIXELS - RECT-FRAME:Y in frame a - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME a = FRAME a:WIDTH-CHARS - .5. /*GUI*/

/*GUI preprocessor Frame A undefine */
&UNDEFINE PP_FRAME_NAME
/*judy 07/05/05*/  /* SET EXTERNAL LABELS */
/*judy 07/05/05*/  setFrameLabels(frame a:handle).


    /* REPORT BLOCK */


/*GUI*/ {mfguirpa.i true  "printer" 132 }

/*GUI repeat : */
/*GUI*/
procedure p-enable-ui:

       if nbr1 = hi_char then nbr = "".


run p-action-fields (input "display").
run p-action-fields (input "enable").
end procedure. /* p-enable-ui, replacement of Data-Entry GUI*/

/*GUI*/ procedure p-report-quote:


       bcdparm = "".

       {mfquoter.i nbr   }
       {mfquoter.i nbr1   }

       if  nbr1 = "" then nbr1 = hi_char.

       /* SELECT PRINTER */

/*GUI*/ end procedure. /* p-report-quote */

/*GUI*/ procedure p-report:

/*GUI*/   {gpprtrpa.i  "printer" 132}
{mfphead.i}
lineno=0.

for each wo_mstr no-lock where wo_domain = global_domain and
         wo_nbr >= nbr and wo_nbr <= nbr1 with frame x width 160:
         find first pt_mstr no-lock where pt_domain = global_domain
                and pt_part = wo_part no-error.
    display wo_nbr wo_lot wo_part pt_desc1 when (avail pt_mstr) wo_qty_ord with stream-io.
    for each wod_det no-lock where wod_domain = global_domain and
             wod_lot = wo_lot with frame y width 240:
        assign vqty = 0.
        for each tr_hist
           fields(tr_domain tr_qty_loc tr_nbr tr_type)
        no-lock where tr_domain = global_domain
             and tr_lot = wo_lot and tr_type = "iss-wo" and tr_part = wod_part:
             assign vqty = vqty + -1 * tr_qty_loc.
        end.
        find first pt_mstr no-lock where pt_domain = global_domain
               and pt_part = wod_part no-error.
        display wod_part pt_desc2 pt_article column-label "保管员" pt_um
                wod_qty_req vqty column-label "已发数量"
                wod_qty_req - vqty column-label "差异量" with stream-io .
    end.
end.

/* {mfguitrl.i} */


/*judy 07/05/05*/  {mfreset.i}
/*GUI*/ {mfgrptrm.i} /*Report-to-Window*/

end procedure.



/*GUI*/ {mfguirpb.i &flds=" nbr nbr1  "} /*Drive the Report*/


 /*judy 07/05/05*/ /* {mfreset.i}*/
