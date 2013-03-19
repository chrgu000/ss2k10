/* GUI CONVERTED from yywoissrp.p (converter v1.78) Tue Mar 19 19:20:17 2013  */
/* xxretrrp.p  - Repetitive Picklist Transfer Report                          */
/* COPYRIGHT DCEC. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK.          */
/*V8:ConvertMode=Report                                                       */
/* V1                 Developped: 03/28/01      BY: Rao Haobin                */
/* $Revision:eb21sp12  $ BY: Jordan Lin  DATE: 08/13/12  ECO: *SS-20120813.1***/
/* 反映领料单实际转移量的报表                                                 */


/*GUI preprocessor directive settings */
&SCOPED-DEFINE PP_GUI_CONVERT_MODE REPORT

{mfdtitle.i "120813.1"}
define variable site like wo_site.
define variable site1 like wo_site.
define variable nbr like tr_nbr.
define variable nbr1 like tr_nbr.
define variable date1 like tr_effdate.
define variable date2 like tr_effdate.
define variable ID like WO_lot.
define variable ID1 like WO_lot.
define variable lineno as integer.
define variable vqty like tr_qty_loc.
/* SELECT FORM */

/*GUI preprocessor Frame A define */
&SCOPED-DEFINE PP_FRAME_NAME A

FORM /*GUI*/ 
       
 RECT-FRAME       AT ROW 1 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1 COLUMN 3 NO-LABEL VIEW-AS TEXT SIZE-PIXELS 1 BY 1
 SKIP(.1)  /*GUI*/
site  label "地点" colon 18
       site1 label {t001.i} colon 49
       nbr   label "加工单号" colon 18
       nbr1  label {t001.i} colon 49
       ID    label "加工单ID号" colon 18
       ID1   label {t001.i} colon 49
       date1 label "操作日期" colon 18
       date2 label {t001.i} colon 49
with frame a side-labels width 80 NO-BOX THREE-D /*GUI*/.

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

/* REPORT BLOCK */

{wbrp01.i}
repeat:

       if site1 = hi_char then site1 = "".
       if nbr1 = hi_char then nbr1 = "".
       if id1 = hi_char then id1 = "".
       if date1 = low_date then date1 = ?.
       if date2 = hi_date  then date2 = ?.


   if c-application-mode <> 'web' then
      update site site1  nbr nbr1 id id1 date1 date2 with frame a.

   {wbrp06.i &command = update
      &fields = " site site1  nbr nbr1 id id1 date1 date2" &frm = "a"}

   if (c-application-mode <> 'web') or
      (c-application-mode = 'web' and
      (c-web-request begins 'data'))
   then do:

       {mfquoter.i site   }
       {mfquoter.i site1   }
       {mfquoter.i nbr   }
       {mfquoter.i nbr1   }
       {mfquoter.i id   }
       {mfquoter.i id1   }
       {mfquoter.i date1   }
       {mfquoter.i date2   }

       if  site1 = "" then site1 = hi_char.
       if  nbr1 = "" then nbr1 = hi_char.
       if  id1 = "" then id1 = hi_char.
       if  date1 = ? then date1 = low_date.
       if  date2 = ? then date2 = hi_date.

   end.

   /* OUTPUT DESTINATION SELECTION */
   {gpselout.i &printType = "printer"
               &printWidth = 132
               &pagedFlag = " "
               &stream = " "
               &appendToFile = " "
               &streamedOutputToTerminal = " "
               &withBatchOption = "yes"
               &displayStatementType = 1
               &withCancelMessage = "yes"
               &pageBottomMargin = 6
               &withEmail = "yes"
               &withWinprint = "yes"
               &defineVariables = "yes"}
/*GUI*/ RECT-FRAME:HEIGHT-PIXELS in frame a = FRAME a:HEIGHT-PIXELS - RECT-FRAME:Y in frame a - 2.

   {mfphead.i}

   
for each wo_mstr no-lock where wo_domain = global_domain and
         wo_nbr >= nbr and wo_nbr <= nbr1  AND wo_lot >= id and wo_lot <= id1
         AND  wo_site >= site and wo_site <= site1 with frame x width 160:
         find first pt_mstr no-lock where pt_domain = global_domain
                and pt_part = wo_part no-error.
    display wo_nbr wo_lot wo_part pt_desc1 when (avail pt_mstr) wo_qty_ord with stream-io .
    for each wod_det no-lock where wod_domain = global_domain and
             wod_lot = wo_lot with frame y width 240:
        assign vqty = 0.
        for each tr_hist
           fields(tr_domain tr_qty_loc tr_nbr tr_type)
        no-lock where tr_domain = global_domain
             and tr_lot = wo_lot and tr_type = "iss-wo"
             AND tr_date >= date1 AND  tr_date <= date2 and tr_part = wod_part:
             assign vqty = vqty + -1 * tr_qty_loc.
        end.
        find first pt_mstr no-lock where pt_domain = global_domain
               and pt_part = wod_part no-error.
        display wod_part pt_desc2 pt_article column-label "保管员" pt_um
                wod_qty_req vqty column-label "已发数量"
                wod_qty_req - vqty column-label "差异量" with stream-io.
    end.

      
/*GUI*/ {mfguichk.i } /*Replace mfrpchk*/


   end.

   /* REPORT TRAILER  */
   {mfrtrail.i}

end.

{wbrp04.i &frame-spec = a}
