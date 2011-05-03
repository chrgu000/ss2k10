/* sosorp04.p - SALES SHIPPING REPORT BY ITEM                                 */
/* Copyright 1986-2005 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* REVISION: 6.0      LAST MODIFIED: 04/05/90   BY: pml *D001*                */
/* REVISION: 6.0      LAST MODIFIED: 04/10/90   BY: ftb *D002* added site*/
/* REVISION: 6.0      LAST MODIFIED: 04/20/90   BY: ftb **/
/* REVISION: 6.0      LAST MODIFIED: 03/08/91   BY: afs *D408**/
/* REVISION: 6.0      LAST MODIFIED: 06/13/91   BY: afs *D696**/
/* REVISION: 6.0      LAST MODIFIED: 07/13/91   BY: afs *D769**/
/* REVISION: 6.0      LAST MODIFIED: 10/21/91   BY: afs *D903**/
/* REVISION: 7.0      LAST MODIFIED: 07/16/92   BY: afs *F774**/
/* REVISION: 7.2      LAST MODIFIED: 03/09/93   BY: tjs *G791**/
/* REVISION: 7.3      LAST MODIFIED: 01/20/94   BY: dpm *FL44**/
/* REVISION: 7.3      LAST MODIFIED: 12/12/94   BY: afs *FU52**/
/* REVISION: 7.3      LAST MODIFIED: 05/11/95   BY: jym *F0RM**/
/* REVISION: 7.3      LAST MODIFIED: 04/10/96   BY: jzw *G1P6**/
/* REVISION: 7.3      LAST MODIFIED: 09/17/96   BY: *G2FC* Ajit Deodhar */
/* REVISION: 7.4      LAST MODIFIED: 11/18/96   BY: *H0PF* Suresh Nayak */
/* REVISION: 8.6      LAST MODIFIED: 10/04/97   BY: ckm *K0L4**/
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane          */
/* REVISION: 8.6E     LAST MODIFIED: 04/05/98   BY: *L024* Sami Kureishy      */
/* REVISION: 8.6E     LAST MODIFIED: 06/23/99   BY: *L0FB* Sachin Shinde      */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane   */
/* REVISION: 9.1      LAST MODIFIED: 06/29/00   BY: *N0DX* Mudit Mehta        */
/* REVISION: 9.1      LAST MODIFIED: 08/12/00   BY: *N0KN* Mark Brown         */
/* REVISION: 9.1      LAST MODIFIED: 10/16/00   BY: *N0WC* Mudit Mehta        */
/* Old ECO marker removed, but no ECO header exists *B388*                    */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* Revision: 1.10.1.6   BY: Jean Miller          DATE: 09/17/01  ECO: *N12P*  */
/* Revision: 1.10.1.8   BY: Patrick Rowan        DATE: 03/14/02  ECO: *P00G*  */
/* Revision: 1.10.1.9   BY: Hareesh V.           DATE: 06/21/02  ECO: *N1HY*  */
/* Revision: 1.10.1.11  BY: Paul Donnelly (SB)   DATE: 06/28/03  ECO: *Q00L*  */
/* Revision: 1.10.1.12  BY: Anitha Gopal         DATE: 11/27/03  ECO: *P1CC*  */
/* Revision: 1.10.1.13  BY: Tejasvi Kulkarni     DATE: 12/09/04  ECO: *P2VL*  */
/* $Revision: 1.10.1.13.1.1 $         BY: Ankit Shah           DATE: 12/19/04  ECO: *P4CB*  */
/*-Revision end---------------------------------------------------------------*/
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/* SS - 090927.1 By: Bill Jiang */
/* SS - 090928.1 BY: JACK */  /* 修改为eb2版本*/
/* ss - 091110.1 by: jack */  /* 按客户，零件汇总*/  /* 原来按产品线，零件，失效日期*/
/* ss - 091111.1 by: jack */

/* ss - 091111.2 by: jack */

/* SS - 090927.1 - RNB
[090927.1]

应用于:
  - 发票申请维护 [xxssirm2.p]

修改于以下标准程序:
  - 发货事务报表 [sosorp04.p]

不包括已经处理过的记录(tr_user1 <> '')的记录
  - tr_user1取当前时间,格式为SoftspeedIRYYYYMMDDHHMMSS

同时,事务号必须大于控制文件中指定的起始事务号

另请参考:
  - 发票申请控制文件 [xxssirpm.p]

[090927.1]

SS - 090927.1 - RNE */

/*V8:ConvertMode=FullGUIReport*/
/* DISPLAY TITLE */
/*
{mfdtitle.i "1+ "}
*/
/*
{mfdtitle.i "090927.1"}
*/

{mfdtitle.i "091111.2"}   



{cxcustom.i "SOSORP04.P"}

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE sosorp04_p_1 "Summary/Detail"
/* MaxLen: Comment: */

&SCOPED-DEFINE sosorp04_p_2 "Unit Price"
/* MaxLen: Comment: */

&SCOPED-DEFINE sosorp04_p_4 "Qty Shipped"
/* MaxLen: Comment: */

&SCOPED-DEFINE sosorp04_p_10 "%Margin"
/* MaxLen: Comment: */

&SCOPED-DEFINE sosorp04_p_12 "Ext Margin"
/* MaxLen: Comment: */

&SCOPED-DEFINE sosorp04_p_13 "Ext Price"
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */

define variable addr like tr_addr.
define variable addr1 like tr_addr.
define variable so_job like tr_so_job.
define variable so_job1 like tr_so_job.
define variable part like tr_part.
define variable part1 like tr_part.
define variable trdate like tr_effdate.
define variable trdate1 like tr_effdate.
define variable region like cm_region.
define variable region1 like cm_region.
define variable site like tr_site.
define variable site1 like tr_site.
define variable name like ad_name.
define variable ext_price like tr_price label {&sosorp04_p_13}
   format "->,>>>,>>>,>>9.99".
define variable gr_margin like tr_price.
/* SS - 090927.1 - B */
define variable ext_gr_margin like tr_price label {&sosorp04_p_12}
   format "->,>>>,>>9.99<<<".
/* SS - 090927.1 - B */
define variable summary like mfc_logical format {&sosorp04_p_1}
   label {&sosorp04_p_1}.
define variable base_rpt like so_curr.

define variable base_price like tr_price.
define variable disp_curr as character format "x(1)" label "C".
define variable prod_line like tr_prod_line.
define variable prod_line1 like tr_prod_line.
define variable desc2 like pl_desc.
/* SS - 090927.1 - B
define variable pct_margin as decimal format "->>9.99" label {&sosorp04_p_10}.
SS - 090927.1 - E */
/* SS - 090927.1 - B */
define variable pct_margin as decimal format "->>>,>>9.99" label {&sosorp04_p_10}.
/* SS - 090927.1 - E */
define variable unit_cost like tr_mtl_std.
define variable tmp_margin like pct_margin.
define variable region_chk like mfc_logical.
define variable l_first_prod_line like mfc_logical no-undo.
define variable l_first_part      like mfc_logical no-undo.
define variable l_prod_line_ok    like mfc_logical no-undo.
define variable l_part_ok         like mfc_logical no-undo.
define variable l_report_ok       like mfc_logical no-undo.
define variable mc-error-number like msg_nbr no-undo.

/* SS - 090927.1 - B */
DEFINE VARIABLE update-yn LIKE mfc_logical.

DEFINE VARIABLE user1_tr LIKE tr_user1.
DEFINE VARIABLE trnbr_tr LIKE tr_trnbr.
/* SS - 090927.1 - E */

/* ss  - 091110.1 -b */
DEFINE VAR v_logical AS LOGICAL INITIAL NO .
/* ss - 091110.1 -e */

{gprunpdf.i "mcpl" "p"}

/* CONSIGNMENT VARIABLES */
define variable consign_qty_ship like tr_qty_loc.
{socnvars.i}

define buffer rcttrans for tr_hist.

form
   part           colon 15
   part1          label {t001.i} colon 49 skip
    /* ss - 091110.1 -b
    prod_line      colon 15
   prod_line1     label {t001.i} colon 49 skip
   ss - 091110.1 -e */
   trdate         colon 15
   trdate1        label {t001.i} colon 49 skip
   addr           colon 15
   addr1          label {t001.i} colon 49 skip
   so_job         colon 15
   so_job1        label {t001.i} colon 49 skip
   region         colon 15
   region1        label {t001.i} colon 49
    site     colon 15
   site1    label {t001.i} colon 49 skip(1)
   summary        colon 15 skip
   base_rpt       colon 15 skip
     /* ss - 0911110.1 -b */
    v_logical   COLON 15  LABEL "是否为SP件"
    /* ss - 091110.1 -e */
   /* SS - 090927.1 - B */
   update-yn       colon 15 skip
   /* SS - 090927.1 - E */
   
with frame a side-labels width 80 attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

{wbrp01.i}

/* DETERMINE IF CUSTOMER CONSIGNMENT IS ACTIVE */
{gprun.i ""gpmfc01.p""
   "(input ENABLE_CUSTOMER_CONSIGNMENT,
     input 10,
     input ADG,
     input CUST_CONSIGN_CTRL_TABLE,
     output using_cust_consignment)"}

repeat:
	/* SS - 090927.1 - B */
	hide all no-pause .
	view frame dtitle .
	/* SS - 090927.1 - E */

   if part1 = hi_char then part1 = "".
   if addr1 = hi_char then addr1 = "".
   if so_job1 = hi_char then so_job1 = "".
   if trdate = low_date then trdate = ?.
   if trdate1 = hi_date then trdate1 = ?.
   /* ss - 091110.1 -b
   if prod_line1 = hi_char then prod_line1 = "".
   ss - 091110.1 -e */
   if site1 = hi_char then site1 = "".
   if region1 = hi_char then region1 = "".

   if c-application-mode <> 'web' then
   update
      part part1
      /* ss - 091110.1 -b
       prod_line prod_line1
       ss - 091110.1 -e */

      trdate trdate1
      addr addr1
      so_job so_job1
      region region1
      site site1
      summary
      base_rpt
        /* SS - 091110.1 - B */
      v_logical
      /* SS - 091110.1 - E */
   /* SS - 090927.1 - B */
      update-yn
      /* SS - 090927.1 - E */
               with frame a.

   {wbrp06.i &command = update &fields = "  part part1 
       /* ss - 091110.1 -b 
       prod_line
        prod_line1 ss - 091110.1 -e */  trdate trdate1 addr addr1 so_job so_job1 region region1
        site site1 summary base_rpt
        /* SS - 091110.1 - B */
      v_logical
      /* SS - 091110.1 - E */

     /* SS - 090927.1 - B */
      update-yn
      /* SS - 090927.1 - E */
          " &frm = "a"}

   if (c-application-mode <> 'web') or
      (c-application-mode = 'web' and
      (c-web-request begins 'data'))
   then do:

      bcdparm = "".

      {mfquoter.i part       }
      {mfquoter.i part1      }
      /* ss - 091110.1 -b
      {mfquoter.i prod_line  }
      {mfquoter.i prod_line1 }
      ss - 091110.1 -e */
      {mfquoter.i trdate     }
      {mfquoter.i trdate1    }
      {mfquoter.i addr       }
      {mfquoter.i addr1      }
      {mfquoter.i so_job     }
      {mfquoter.i so_job1    }
      {mfquoter.i region     }
      {mfquoter.i region1    }
      {mfquoter.i site     }
      {mfquoter.i site1    }
      {mfquoter.i summary    }
      {mfquoter.i base_rpt   }
      /* SS - 090927.1 - B */
      {mfquoter.i update-yn   }
      /* SS - 090927.1 - E */
     /* SS - 091110.1 - B */
      {mfquoter.i update-yn   }
      /* SS - 091110.1 - E */


      if part1 = "" then part1 = hi_char.
      /* ss  091110.1 -b
      if prod_line1 = "" then prod_line1 = hi_char.
      ss - 091110.1 -e */

      if addr1 = "" then addr1 = hi_char.
      if trdate = ? then trdate = low_date.
      if trdate1 = ? then trdate1 = hi_date.
      if so_job1 = "" then so_job1 = hi_char.
      if region1 = "" then region1 = hi_char.
      if site1 = "" then site1 = hi_char.

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

   {mfphead.i}

   form header
      skip(1)
   with frame p1 page-top width 132 attr-space.
   view frame p1.

   /* SELECTION OF REGION OCCURS OUTSIDE THE FOR EACH LOOP(TO USE THE
    * REPORT AT REMOTE DB). THE "OK" FLAG INDICATES IF ANY VALID RECORD
    * HAS BEEN SELECTED FOR THE REPORT, PRODUCT LINE OR PART */
   l_report_ok         = no.

   /* SS - 090927.1 - B */
   user1_tr = "SoftspeedIR" 
      + STRING(YEAR(TODAY),"9999")
      + STRING(MONTH(TODAY),"99")
      + STRING(DAY(TODAY),"99")
      + REPLACE(STRING(TIME,"hh:mm:ss"),":","").
   DO TRANSACTION ON ERROR UNDO:
   /*
   END.
   */
   FIND FIRST mfc_ctrl WHERE /* mfc_domain = GLOBAL_domain
      AND */ mfc_field = "SoftspeedIR_trnbr"
      NO-LOCK NO-ERROR.
   IF AVAILABLE mfc_ctrl THEN DO:
      trnbr_tr = mfc_integer.
   END.
   ELSE DO:
      trnbr_tr = 0.
   END.
   /* SS - 090927.1 - E */
   {&SOSORP04-P-TAG1}
   for each tr_hist     use-index tr_addr_eff
    WHERE /*  tr_hist.tr_domain = global_domain
      /* SS - 090927.1 - B */
      AND*/   /* ss - 091110.1 -b  tr_trnbr > trnbr_tr  ss - 091110.1 -e */
      /* SS - 090927.1 - E */
         (tr_addr      >= addr      and tr_addr      <= addr1)
       
       AND (tr_effdate   >= trdate    and tr_effdate   <= trdate1)
        
       AND  tr_trnbr > trnbr_tr
      and ((tr_part      >= part      and tr_part      <= part1)
           /* ss - 091110.1 -b
           and  (tr_prod_line >= prod_line and tr_prod_line <= prod_line1)
           ss - 091110.1 -e */
      and  (tr_site      >= site      and tr_site      <= site1)
      and  (tr_so_job    >= so_job    and tr_so_job    <= so_job1)
       /* SS - 091110.1 -B */
           AND ( ( v_logical = YES  AND SUBSTRING(tr_so_job,6,1) = "s" )  OR ( v_logical = NO  AND SUBSTRING(tr_so_job,6,1) <> "s" ) )
           /* ss - 091110.1 -e */
      and  ( (tr_type      = "ISS-SO"
         and not(can-find(first cncu_mstr
                             where /* cncu_mstr.cncu_domain = global_domain
                             and  */  cncu_trnbr = tr_trnbr)) )
         or tr_type      = "RCT-SOR"
         or tr_type      = "CN-SHIP")
      and  ((base_rpt = "")
         or (tr_curr = base_rpt))
      {&SOSORP04-P-TAG2})
       /* ss - 091111.2 -b */
       AND tr_user1 = ""
       /* ss - 091111.2 -e */

   /* SS - 090927.1 - B
   no-lock
   SS - 090927.1 - E */
       /* ss  - 091110.1 -b
   break by tr_prod_line by tr_part by tr_effdate
   ss  - 091110.1 -e */
       /* ss - 091110.1 -b */
      BREAK BY tr_addr BY tr_part BY tr_effdate
       /* ss - 091110.1 -e */
   with frame b width 160 no-box:

      
     /* ss - 091111.2 -b 
      /* SS - 090927.1 - B */
      IF tr_user1 <> "" THEN DO:
         NEXT.
      END.
      /* SS - 090927.1 - E */
      ss - 091111.2 -e */

     

      /* SET EXTERNAL LABELS */
      setFrameLabels(frame b:handle).

      form
         tr_part
         pt_um
         pt_desc1
         tr_qty_loc
         ext_price
         ext_gr_margin
         pct_margin
      with frame c down width 132.

      /* SET EXTERNAL LABELS */
      setFrameLabels(frame c:handle).

      {gprunmo.i
         &program = "socnsod1.p"
         &module = "ACN"
         &param = """(input tr_nbr,
                      input tr_line,
                      output consign_flag,
                      output consign_loc,
                      output intrans_loc,
                      output max_aging_days,
                      output auto_replenish)"""}

      if tr_type = "CN-SHIP"
      then
         consign_flag = yes.
      else
         assign
            consign_flag = no
            consign_qty_ship = 0.

      /* GET THE QTY SHIPPED FROM THE "RCT-TR" RECORD */
      for first rcttrans
         where  /* rcttrans.tr_domain = global_domain
         and  */  rcttrans.tr_trnbr  = integer(tr_hist.tr_rmks)
         and   rcttrans.tr_type   = "RCT-TR"
         and   rcttrans.tr_nbr    = tr_hist.tr_nbr
      no-lock:
         consign_qty_ship = rcttrans.tr_qty_loc.
      end.  /* for first rcttrans */

     
      if first-of(tr_part) THEN DO:
   
      assign
         l_first_part     = yes
         l_part_ok        = no.
   
      END.
      /* SAVE THE first-of(tr_part) OCCURRENCE FOR REFERRING TO VALID
       * tr_hist RECORDS. AND INITIALIZE O.K. TO PRINT PART TOTALS VARIABLE.*/
     
      if first-of(tr_addr) THEN DO:
    
      assign
         l_first_prod_line   = yes
         l_prod_line_ok      = no.
    
      END.
      /* SAVE THE first-of(tr_addr) OCCURRENCE FOR REFERRING TO VALID
       * tr_hist RECORDS. INITIALIZE O.K. TO PRINT PRODUCT LINE TOTALS VARIABLE.*/

      /* Check customer region (if customers in this db) */
      if (region > "" or region1 < hi_char) and
         can-find(first cm_mstr  where /* cm_mstr.cm_domain = global_domain and */
         cm_addr >= "")
      then do:
         find cm_mstr  where  /* cm_mstr.cm_domain = global_domain and  */ cm_addr =
         tr_addr no-lock no-error.
         region_chk = (available cm_mstr
                       and cm_region >= region and cm_region <= region1).
      end.
      else
         region_chk = true.

         

      if l_first_prod_line and region_chk then do:

         /* CHECK FOR FIRST VALID RECORD FOR THIS PRDUCT LINE */
         l_first_prod_line  = no.
        
         /* ss - 091110.1 -b
         find pl_mstr  where /* pl_mstr.pl_domain = global_domain and */
         pl_prod_line = tr_prod_line no-lock no-error.

         if available pl_mstr then do:

            desc2 = pl_desc.
            ss -091110.1 -e */
         /* ss -091110.1 -b */
         FIND FIRST ad_mstr WHERE ad_addr = tr_addr NO-LOCK NO-ERROR .
         IF AVAILABLE  ad_mstr THEN DO:
         desc2 = ad_name .
         /* ss - 091110.1 -e */
           
          
            if page-size - line-counter < 3 then page.

            if not summary then
               display with frame b.
            else
               display with frame c.
          /* ss - 091110.1 -b
            put
               {gplblfmt.i &FUNC=getTermLabel(""PRODUCT_LINE"",15)
                           &CONCAT = "': '"}
               pl_prod_line
               " " pl_desc.
               ss - 091110.1 -e */
               /* ss - 091110.1 -b */
               PUT 
                   ad_addr
                   "" ad_name .
               /* ss - 091110.1 -e */
         end.

      end.

      if region_chk then do:

         l_part_ok = yes.

         /* AT-LEAST ONE VALID RECORD FOUND FOR THIS PART BREAK */

         /*Calculate Currency Exchange */
         assign
            base_price = tr_price
            disp_curr = "".

         if base_rpt <> "" and tr_curr <> base_curr
         then do:

            {gprunp.i "mcpl" "p" "mc-curr-conv"
               "(input base_curr,
                 input tr_curr,
                 input tr_ex_rate2,
                 input tr_ex_rate,
                 input base_price,
                 input false,
                 output base_price,
                 output mc-error-number)"}.

            if mc-error-number <> 0 then do:
               {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
            end.

         end. /*IF BASE_RPT <> "" AND TR_CURR <> BASE_CURR*/

         if base_rpt = "" and tr_curr <> base_curr then
            disp_curr = getTermLabel("YES",1).

         assign
            ext_price =  - tr_qty_loc * base_price
            unit_cost = - tr_gl_amt / tr_qty_loc.

         if consign_flag
            and tr_type <> "ISS-SO"
         then
            assign
               ext_price =  consign_qty_ship * base_price
               unit_cost =  tr_gl_amt / consign_qty_ship.

         if tr_ship_type <> " " then
            assign
               unit_cost = tr_mtl_std + tr_lbr_std + tr_bdn_std +
                           tr_ovh_std + tr_sub_std.

         gr_margin = tr_price - unit_cost.

         if base_rpt <> "" and tr_curr <> base_curr
         then do:

            {gprunp.i "mcpl" "p" "mc-curr-conv"
               "(input base_curr,
                 input tr_curr,
                 input tr_ex_rate2,
                 input tr_ex_rate,
                 input gr_margin,
                 input false,
                 output gr_margin,
                 output mc-error-number)"}.

            if mc-error-number <> 0 then do:
               {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
            end.

         end. /*IF BASE_RPT <> "" AND TR_CURR <> BASE_CURR*/

         ext_gr_margin = - tr_qty_loc * gr_margin.

         if consign_flag
            and tr_type <> "ISS-SO"
         then
            ext_gr_margin =  consign_qty_ship * gr_margin.

         if unit_cost = 0 then
            pct_margin = 100.
         else if (- tr_qty_loc) = 0 then
            pct_margin = 0.
         else if ext_price = 0 then
            pct_margin = 0.
         else
            pct_margin = (ext_gr_margin / ext_price) * 100.

         if consign_flag
            and tr_type <> "ISS_SO"
         then do:
            if unit_cost = 0 then pct_margin = 100.
            else
              if consign_qty_ship = 0 then pct_margin = 0.
              else
                if ext_price = 0 then pct_margin = 0.
                else
                  pct_margin = (ext_gr_margin / ext_price) * 100.
         end.  /* if consign_flag */

         if (consign_flag
            and tr_type <> "ISS-SO")
            or  not consign_flag
         then do:
           
             accumulate ext_gr_margin (total by tr_addr by tr_part).
            accumulate tr_qty_loc (total by tr_addr by tr_part).
            accumulate ext_price (total by tr_addr by tr_part).
            accumulate consign_qty_ship (total by tr_addr by tr_part).
         
         end. /* IF (consign_flag AND ... */

      end. /* If region for this line is valid */

      find pt_mstr  where /* pt_mstr.pt_domain = global_domain and  */ pt_part =
      tr_part no-lock no-wait no-error.

      if not summary then do:

         name = "".

         find ad_mstr  where /* ad_mstr.ad_domain = global_domain and */  ad_addr =
         tr_addr no-lock no-wait no-error.
         if available ad_mstr then name = ad_name.

         if l_first_part and region_chk  then do:

            /* CHECK FOR FIRST VALID RECORD FOR THIS PART */
            l_first_part = no.
            
              

            if page-size - line-counter < 4 then page.

            display.

            put
               {gplblfmt.i &FUNC=getTermLabel(""ITEM"",8) &CONCAT = "': '"}
               tr_part " ".

            if available pt_mstr then put
               pt_desc1 " " pt_desc2.

            put
               {gplblfmt.i &FUNC=getTermLabelRt(""UNIT_OF_MEASURE"",4)
                           &CONCAT = "': '"}
               tr_um
               skip.
         end.

         if page-size - line-counter < 3 then page.


         if region_chk then
            display
               tr_trnbr
               tr_ship_type
               tr_effdate
               tr_so_job
               tr_addr
               name format "x(18)"
               (- tr_qty_loc) when (not consign_flag)
                  @ tr_qty_loc label {&sosorp04_p_4}
               consign_qty_ship when (consign_flag)
                  @ tr_qty_loc label {&sosorp04_p_4}
               disp_curr base_price        label {&sosorp04_p_2}
               ext_price
               ext_gr_margin
               pct_margin.

         /* DISPLAY PART TOTALS WHEN AT-LEAST ONE tr_hist RECORD
          * QUALIFIES SELECTION CRITERIA */

         if last-of(tr_part) and l_part_ok then do:

            /* AT-LEAST ONE VALID RECORD FOUND FOR THIS PRODUCT LINE BREAK */
            l_prod_line_ok = yes.

            /* Calculate the margin separately to avoid division by zero */
            
            if (accum total by tr_part (ext_price)) <> 0 then
               tmp_margin =
                  ((accum total by tr_part (ext_gr_margin)) /
                   (accum total by tr_part  (ext_price)) ) * 100.
            
            else
               tmp_margin = 0.
            
            
            if page-size - line-counter < 2 then page.

            underline tr_qty_loc ext_price ext_gr_margin pct_margin
            with frame b.

            display
               getTermLabel("ITEM_TOTAL",17) + ":"  @ name
               (- accum total by tr_part (tr_qty_loc) )
                 + accum total by tr_part (consign_qty_ship)
                  @ tr_qty_loc   FORMAT "->,>>>,>>>,>>9.99<<<"
               accum total by tr_part (ext_price) @ ext_price  FORMAT "->,>>>,>>>,>>9.99<<<"
               accum total by tr_part (ext_gr_margin) @ ext_gr_margin  FORMAT "->,>>>,>>>,>>9.99<<<"
               tmp_margin @ pct_margin
            with frame b.

         end.

         /* DISPLAY PRODUCT LINE TOTALS WHEN AT-LEAST ONE tr_hist RECORD
          * QUALIFIES SELECTION CRITERIA */
         if last-of(tr_addr) and l_prod_line_ok then do:

            l_report_ok = yes.

            /* Calculate the margin separately to avoid division by zero */
            if (accum total by tr_addr (ext_price)) <> 0 then
               tmp_margin =
                  ((accum total by tr_addr (ext_gr_margin)) /
                   (accum total by tr_addr  (ext_price)) ) * 100.
            else
               tmp_margin = 0.

            if page-size - line-counter < 2 then page.

            underline tr_qty_loc ext_price ext_gr_margin pct_margin.

            display
                /* ss - 091111.1 -b
               getTermLabel("PRODUCT_LINE_TOTAL",17) + ":" @ name
               ss  - 091111.1 -e */
                /* SS - 091111.1 -B */
               "客户合计" +  ":" @ name
             /* SS - 091111.1 -E */
               (- accum total by tr_addr (tr_qty_loc) )
                  + accum total by tr_addr (consign_qty_ship)
                  @ tr_qty_loc  FORMAT "->,>>>,>>>,>>9.99<<<"
               accum total by tr_addr (ext_price) @ ext_price  FORMAT "->,>>>,>>>,>>9.99<<<"
               accum total by tr_addr (ext_gr_margin) @ ext_gr_margin  FORMAT "->,>>>,>>>,>>9.99<<<"
               tmp_margin @ pct_margin.

         end.

         /* DISPLAY REPORT TOTALS WHEN AT-LEAST ONE tr_hist RECORD
          * QUALIFIES SELECTION CRITERIA */
         if last(tr_addr)  and l_report_ok then do:

            /* Calculate the margin separately to avoid division by zero */
            if (accum total (ext_price)) <> 0 then
               tmp_margin =
                  ((accum total (ext_gr_margin)) /
                   (accum total  (ext_price)) ) * 100.
            else
               tmp_margin = 0.

            if page-size - line-counter < 2 then page.

            underline tr_qty_loc ext_price ext_gr_margin pct_margin.

            display
               getTermLabel("REPORT_TOTAL",17) + ":" @ name
               (- accum total (tr_qty_loc) )
                  + accum total (consign_qty_ship)
                    @ tr_qty_loc
               accum total  (ext_price) @ ext_price
               accum total  (ext_gr_margin) @ ext_gr_margin
               tmp_margin @ pct_margin.

         end.

      end.  /* not summary */

      if summary then do:

         /* DISPLAY PART TOTALS WHEN AT-LEAST ONE tr_hist RECORD
          * QUALIFIES SELECTION CRITERIA */
         if last-of(tr_part) and l_part_ok then do:

            /* AT-LEAST ONE VALID RECORD FOUND FOR THIS PRODUCT LINE BREAK */
            l_prod_line_ok = yes.

            /* Calculate the margin separately to avoid division by zero */
            if (accum total by tr_part (ext_price)) <> 0 then
               tmp_margin =
                  ((accum total by tr_part (ext_gr_margin)) /
                   (accum total by tr_part  (ext_price)) ) * 100.
            else
               tmp_margin = 0.

            if page-size - line-counter < 2 then page.

            display
               tr_part
            with frame c down width 132.

            if available pt_mstr then
               display
                  pt_um
                  pt_desc1
               with frame c.

            display
              (- accum total by tr_part (tr_qty_loc) )
                 + accum total by tr_part (consign_qty_ship)
                   @ tr_qty_loc  FORMAT "->,>>>,>>>,>>9.99<<<"
               accum total by tr_part (ext_price) @ ext_price  FORMAT "->,>>>,>>>,>>9.99<<<"
               accum total by tr_part (ext_gr_margin) @ ext_gr_margin  FORMAT "->,>>>,>>>,>>9.99<<<"
               tmp_margin @ pct_margin
            with frame c down width 132.

            if available pt_mstr and pt_desc2 <> "" then do:
               down 1 with frame c.
               display pt_desc2 @ pt_desc1 with frame c.
            end.

         end.

         /* DISPLAY PRODUCT LINE TOTALS WHEN AT-LEAST ONE tr_hist RECORD
          * QUALIFIES SELECTION CRITERIA */
         if last-of(tr_addr)  and l_prod_line_ok then do:

            l_report_ok = yes.

            /* Calculate the margin separately to avoid division by zero */
            if (accum total by tr_addr (ext_price)) <> 0 then
               tmp_margin =
                  ((accum total by tr_addr (ext_gr_margin)) /
                   (accum total by tr_addr  (ext_price)) ) * 100.
            else
               tmp_margin = 0.

            if page-size - line-counter < 2 then page.

            underline tr_qty_loc ext_price ext_gr_margin pct_margin
            with frame c.

            display
                /* ss - 091110.1 -b
               getTermLabel("PRODUCT_LINE_TOTAL",23) + ":" @ pt_desc1
                ss - 091110.1 -e */
                /* ss -091110.1 -b */
                "客户合计" + ":" @ pt_desc1
         /* ss - 091110.1 -e */

                (- accum total by tr_addr (tr_qty_loc) )
                  + accum total by tr_addr (consign_qty_ship)
                    @ tr_qty_loc  FORMAT "->,>>>,>>>,>>9.99<<<"
               accum total by tr_addr (ext_price) @ ext_price  FORMAT "->,>>>,>>>,>>9.99<<<"
               accum total by tr_addr (ext_gr_margin) @ ext_gr_margin  FORMAT "->,>>>,>>>,>>9.99<<<"
               tmp_margin @ pct_margin
            with frame c.

         end.

         /* DISPLAY REPORT TOTALS WHEN AT-LEAST ONE tr_hist RECORD
          * QUALIFIES SELECTION CRITERIA */
         if last(tr_addr)  and l_report_ok then do:

            /* Calculate the margin separately to avoid division by zero */
            if (accum total (ext_price)) <> 0 then
               tmp_margin =
                  ((accum total (ext_gr_margin)) /
                   (accum total  (ext_price)) ) * 100.
            else
               tmp_margin = 0.

            if page-size - line-counter < 2 then page.

            underline tr_qty_loc ext_price ext_gr_margin pct_margin
            with frame c.

            display
               getTermLabel("REPORT_TOTAL",23) + ":" @ pt_desc1
               (- accum total (tr_qty_loc) )
                  + accum total (consign_qty_ship)
                    @ tr_qty_loc
               accum total  (ext_price) @ ext_price
               accum total  (ext_gr_margin) @ ext_gr_margin
               tmp_margin @ pct_margin
            with frame c.

         end.

      end. /* summary*/

      {mfrpchk.i}

      /* SS - 090927.1 - B */
      CREATE usrw_wkfl.
      ASSIGN
         /* usrw_domain = GLOBAL_domain */
         usrw_key1 = 'SoftspeedIR_History'
         usrw_key2 = string(tr_trnbr)
         usrw_intfld[1] = tr_trnbr
         usrw_decfld[1] = - tr_qty_loc
         usrw_decfld[4] = - tr_qty_loc
         .

      

      FIND FIRST sod_det 
         WHERE /* sod_domain = GLOBAL_domain
         AND */ sod_nbr = tr_nbr
         AND sod_line = tr_line
         NO-LOCK NO-ERROR.
      IF AVAILABLE sod_det THEN DO:
         ASSIGN
            usrw_decfld[2] = sod_price
            .

         /* 计量单位 */
         IF tr_um <> sod_um THEN DO:
            {gprun.i ""gpumcnv.p"" "(
               input  sod_um,
               input  tr_um,
               input  tr_part,
               output usrw_decfld[5]
               )"}
   
            ASSIGN
               usrw_decfld[1] = tr_qty_loc / usrw_decfld[5]
               usrw_decfld[4] = tr_qty_loc / usrw_decfld[5]
               .
            
         END.
      END.

      ASSIGN
         tr_user1 = user1_tr
         .

      /* ss - 091110.1 -b */
      trnbr_tr = tr_trnbr  .
      /* ss - 091110.1 -e */
      /* SS - 090927.1 - E */
   end. /*for each*/
   /* SS - 090927.1 - B */
   /*
   DO TRANSACTION ON ERROR UNDO:
   */
      IF update-yn = NO THEN DO:
         UNDO.
      END.
   END.
   /* SS - 090927.1 - E */

   /* REPORT TRAILER  */
   {mfrtrail.i}

end.

{wbrp04.i &frame-spec = a}
