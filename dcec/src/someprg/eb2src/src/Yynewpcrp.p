/* pppcrp01.p - PART MASTER PRICE LIST                                  */
/* Copyright 1986-2003 QAD Inc., Carpinteria, CA, USA.                  */
/* All rights reserved worldwide.  This is an unpublished work.         */
/* $Revision: 1.17 $                                                         */
/*V8:ConvertMode=FullGUIReport                                 */
/* REVISION: 6.0      LAST MODIFIED: 08/04/90   BY: PML      */
/* REVISION: 6.0      LAST MODIFIED: 02/20/91   BY: afs *D355**/
/* REVISION: 7.0      LAST MODIFIED: 09/04/91   BY: pma *F003*          */
/* REVISION: 7.0      LAST MODIFIED: 06/01/92   BY: pma *F563*          */
/* REVISION: 7.4      LAST MODIFIED: 10/22/92   BY: mpp *G483*          */
/* REVISION: 7.3      LAST MODIFIED: 01/20/94   BY: afs *FL45*          */
/* REVISION: 7.3      LAST MODIFIED: 08/27/94   BY: rxm *GL58*          */
/* REVISION: 7.2      LAST MODIFIED: 03/01/95   BY: qzl *F0KZ*          */
/* REVISION: 8.5      LAST MODIFIED: 05/30/95   BY: tjs *J04X*          */
/* REVISION: 8.6      LAST MODIFIED: 10/07/97   BY: mzv *K0MF*          */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane    */
/* REVISION: 8.6E     LAST MODIFIED: 06/22/98   BY: *L020* Charles Yen  */
/* REVISION: 9.0      LAST MODIFIED: 11/19/98   BY: *J34S* Seema Varma  */
/* REVISION: 9.0      LAST MODIFIED: 11/24/98   BY: *J354* Poonam Bahl  */
/* REVISION: 9.0      LAST MODIFIED: 03/13/99   BY: *M0BD* Alfred Tan   */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane */
/* REVISION: 9.1      LAST MODIFIED: 08/13/00   BY: *N0KQ* myb              */
/* REVISION: 9.1      LAST MODIFIED: 08/21/00   BY: *N0MB* Mudit Mehta      */
/* Old ECO marker removed, but no ECO header exists *F0PN*               */
/* Revision: 1.16       BY: Kedar Deherkar     DATE: 01/28/02 ECO: *N187* */
/* $Revision: 1.17 $    BY: Vandna Rohira      DATE: 03/21/03 ECO: *N2B3* */
/* $Revision: eb2+ sp7     BY: judy liu         DATE: 08/25/05  ECO: *judy*   */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/* DISPLAY TITLE */
{mfdtitle.i "2+ "}

define variable mc-error-number like msg_nbr no-undo.

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE pppcrp01_p_1 "Amount"
/* MaxLen: Comment: */

&SCOPED-DEFINE pppcrp01_p_3 "Min Qty"
/* MaxLen: Comment: */

&SCOPED-DEFINE pppcrp01_p_4 "Net Price"
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */

define variable line       like pt_prod_line.
define variable line1      like pt_prod_line.
define variable part       like pt_part.
define variable part1      like pt_part.
define variable type       like pc_amt_type /*tfq pt_part_type*/ .
define variable type1      like pc_amt_type /*tfq pt_part_type*/ .
define variable ptgroup    like pt_group.
define variable group1     like pt_group.
define variable added      like pt_added initial ?.
define variable added1     like pt_added initial ?.
define variable pm         like pt_pm_code.
define variable pm1        like pt_pm_code.
define variable pclist1     like pc_list.
define variable pclist2     like pc_list.
define variable curr       like pc_curr.
define variable curr1      like pc_curr .
define variable i          as   integer.
define variable pcdate     like glt_effdate initial today.
define variable net_price  like pt_price label {&pppcrp01_p_4}.
define variable list_pr    like net_price.
define variable found-one  like mfc_logical.
define variable exrate     like exr_rate.
define variable exrate2    like exr_rate.
define variable exratetype like exr_ratetype.
define variable tmp-price  like pt_price.
define variable disc_pct   like sod_disc.
define variable v_header_display like mfc_logical no-undo.
define variable only-disp-new-price as logical label "只显示最新价格" initial yes . 
define buffer pcmstr for pc_mstr.
define variable vdname like ad_name .
define variable pcdate1 like pcdate .

/* DEFINED TEMP TABLE tt-disp TO AVOID MULTIPLE DISPLAY */
/* OF A PRICE LIST FOR THE SAME ITEM.                   */

define temp-table tt-disp no-undo
   field t_partcode    like pt_part
   field t_list        like pc_list
   field t_curr        like pc_curr
   field t_prod_line   like pc_prod_line
   field t_part        like pc_part
   field t_um          like pc_um
   field t_start       like pc_start
   index t_partcode is primary unique
         t_partcode
         t_list
         t_curr
         t_prod_line
         t_part
         t_um
         t_start.

{gprunpdf.i "mcpl" "p"}

&SCOPED-DEFINE PP_FRAME_NAME A

FORM /*GUI*/ 
        
 RECT-FRAME       AT ROW 1.4 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1   COLUMN 3 NO-LABEL
 SKIP(.1)  /*GUI*/
   part           colon 15
   /*part1          label {t001.i} colon 49*/ skip
   line           colon 15
   line1          label {t001.i} colon 49 skip
   
   ptgroup        colon 15
   group1         label {t001.i} colon 49 skip
   added          colon 15
   added1         label {t001.i} colon 49
   pm             colon 15
   pm1            label {t001.i} colon 49 
   pclist1         colon 15 
   pclist2         label {t001.i} colon 49 
   type           colon 15
   type1          label {t001.i} colon 49    
   curr           colon 15
   curr1          label {t001.i} colon 49
   pcdate         colon 30
   only-disp-new-price colon 30 skip
with frame a side-labels width 80 NO-BOX THREE-D /*GUI*/.

 DEFINE VARIABLE F-a-title AS CHARACTER.
 F-a-title = &IF (DEFINED(SELECTION_CRITERIA) = 0)
  &THEN " Selection Criteria "
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



         /* SET EXTERNAL LABELS */
         setFrameLabels(frame a:handle).

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

/* REPORT BLOCK */

{wbrp01.i}

repeat:

   for each tt-disp exclusive-lock:
      delete tt-disp.
   end. /* FOR EACH tt-disp */

   if part1  = hi_char  then part1  = "".
   if line1  = hi_char  then line1  = "".
   if type1  = hi_char  then type1  = "".
   if group1 = hi_char  then group1 = "".
   if pm1    = hi_char  then pm1    = "".
   if pclist2 = hi_char then pclist2 = "".
   if curr1 = hi_char   then curr1 = "" .
   if added1 = hi_date  then added1 = ?.
   if added  = low_date then added  = ?.
   if pcdate = ?        then pcdate = today.

   if c-application-mode <> "WEB"
   then
      update
         part  /*judy*/
         line
         line1
         /*part
         part1*/  /*judy*/
         ptgroup
         group1
         added
         added1
         pm
         pm1
         pclist1
         pclist2
         type
         type1
         curr
         curr1
         pcdate
         only-disp-new-price
      with frame a.

   {wbrp06.i &command = update
             &fields  = " part
                          line
                          line1
                          ptgroup
                          group1
                          added
                          added1
                          pm
                          pm1
                          pclist1
                          pclist2
                          type
                          type1
                          curr
                          curr1
                          pcdate
                          only-disp-new-price"
             &frm     = "a"}

   if  (c-application-mode <> "WEB")
   or  (c-application-mode = "WEB"
   and (c-web-request begins "DATA"))
   then do:

      bcdparm = "".
      {mfquoter.i line   }
      {mfquoter.i line1  }
      {mfquoter.i part   }
      {mfquoter.i part1  }
      {mfquoter.i type   }
      {mfquoter.i type1  }
      {mfquoter.i ptgroup}
      {mfquoter.i group1 }
      {mfquoter.i added  }
      {mfquoter.i added1 }
      {mfquoter.i pm     }
      {mfquoter.i pm1    }
      {mfquoter.i pclist1 }
      {mfquoter.i pclist2 }
      {mfquoter.i curr   }
      {mfquoter.i curr1   }
      {mfquoter.i pcdate }
      {mfquoter.i only-disp-new-price }

      if part1  = "" then part1  = hi_char.
      if line1  = "" then line1  = hi_char.
      if type1  = "" then type1  = hi_char.
      if pm1    = "" then pm1    = hi_char.
      if group1 = "" then group1 = hi_char.
      if added  = ?  then added  = low_date.
      if added1 = ?  then added1 = hi_date.
    if pcdate = ?  then assign  pcdate1 = pcdate
                                pcdate = today. 
      if pclist2 = "" then pclist2 = hi_char .
      if curr1 = "" then curr1 = hi_char .
   end.
if only-disp-new-price = yes then
do:

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
   for each pc_mstr
      fields (pc_amt   pc_amt_type pc_curr pc_expire
              pc_list  pc_min_qty  pc_part pc_prod_line
              pc_start pc_um)
/*judy*/      
       /*where ((pc_part >= part and
              pc_part <= part1) or
              pc_part = "")*/
         where ((pc_part = part OR part = "")  or
              pc_part = "")
/*judy*/
        and (pc_amt_type >= type and pc_amt_type <= type1)      
        and  (pc_list  >=  pclist1 and pc_list <=   pclist2 )
        and  (pc_curr  >=  curr    and   pc_curr  <= curr1 )
        and  (pc_start <= pcdate    or pc_start = ?)
        and  (pcdate   <= pc_expire or pc_expire = ?)
      no-lock
      break by pc_list by pc_curr:

      if first-of(pc_curr)
      then
         v_header_display = yes.

      for each pt_mstr
/*judy*/  /*where (pt_part      >= part        and pt_part      <= part1) */
/*judy*/  where (pt_part      = part OR part = "") 
          and (pt_prod_line >= line        and pt_prod_line <= line1)
          /*tfq and (pt_part_type >= type        and pt_part_type <= type1) */
           and (pt_group     >= ptgroup     and pt_group     <= group1)
           and (pt_pm_code   >= pm          and pt_pm_code   <= pm1)
           and ((pt_added    >= added       and pt_added     <= added1)
            or  pt_added = ?)
           and (pt_prod_line = pc_prod_line or  pc_prod_line = "")
           and (pt_part      = pc_part      or  pc_part      = "")
         no-lock use-index pt_prod_part
         break by pt_prod_line by pt_part
         with frame b width 132 down:

         /* SET EXTERNAL LABELS */
         setFrameLabels(frame b:handle).
/********************tfq************************
         if first-of (pt_prod_line)
         then do:
            if v_header_display
            then do:
               if line-counter <> 0
               then
                  page.

               form header
                  getTermLabel("PRICE_LIST",30) + ": " + pc_list + "  " +
                  getTermLabel("CURRENCY",7) + ": " + pc_curr + "  " +
                  getTermLabel("EFFECTIVE",30) + ": " +
                     string(pcdate) format "x(94)"
               with frame p1 page-top width 132.

               view frame p1.
            end. /* IF V_HEADER_DISPLAY */

            v_header_display = no.

            if page-size - line-counter < 7
            then
               page.

            find pl_mstr
               where pl_prod_line = pt_prod_line
               no-lock no-error.

         end.
**********************tfq******************************/
/*************tfq*******************************
         if page-size - line-counter < 3
         then
            page.
***************tfq**************************/
         assign
            exrate  = 1
            exrate2 = 1.

         if  base_curr       <>  pc_mstr.pc_curr
         and pc_mstr.pc_curr <> ""
         then do:

            /* GET EXCHANGE RATE */
            {gprunp.i "mcpl" "p" "mc-get-ex-rate"
               "(input  base_curr,
                 input  pc_mstr.pc_curr,
                 input  exratetype,
                 input  pcdate,
                 output exrate2,
                 output exrate,
                 output mc-error-number)"}

            if mc-error-number <> 0
            then do:
               {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=3}
            end.
         end.

         tmp-price = 0.
         if  base_curr       <> pc_mstr.pc_curr
         and pc_mstr.pc_curr <> ""
         then do:
            /* CONVERT FROM BASE TO FOREIGN CURRENCY */
            {gprunp.i "mcpl" "p" "mc-curr-conv"
               "(input  base_curr,
                 input  pc_mstr.pc_curr,
                 input  exrate2,
                 input  exrate,
                 input  pt_price,
                 input  false, /* DO NOT ROUND */
                 output tmp-price,
                 output mc-error-number)"}
         end.
         else
            tmp-price = pt_price.

         /* LOOK FOR PRICE FOR PART AND UM */
         find last pcmstr
            where pcmstr.pc_list    =  pc_mstr.pc_list
              and pcmstr.pc_part    =  pt_part  and pcmstr.pc_um     = pt_um
              and (pcmstr.pc_start  <= pcdate   or  pcmstr.pc_start  = ?)
              and (pcmstr.pc_expire >= pcdate   or  pcmstr.pc_expire = ?)
              and pcmstr.pc_curr    =  pc_mstr.pc_curr
              and (if pc_mstr.pc_amt_type = "L"
                   then
                      pcmstr.pc_amt_type =  "L"
                   else
                      pcmstr.pc_amt_type <> "L")
            no-lock no-error.

         /* LOOK FOR PRICE REGARDLESS OF UM */
         if not available pcmstr
         then
            find last pcmstr
               where (pcmstr.pc_list = pc_mstr.pc_list)
                 and (pcmstr.pc_curr = pc_mstr.pc_curr)
                 and (pcmstr.pc_part = pt_part)
                 and pcmstr.pc_um    = ""
                 and ((pcmstr.pc_start  <= pcdate  or pcmstr.pc_start  = ?) or only-disp-new-price = no )
                 and ((pcmstr.pc_expire >= pcdate  or pcmstr.pc_expire = ?) or only-disp-new-price = no )
                 and (if pc_mstr.pc_amt_type = "L"
                      then
                         pcmstr.pc_amt_type =  "L"
                      else
                         pcmstr.pc_amt_type <> "L")
               no-lock no-error.

         /* LOOK FOR PRICE FOR PRODUCT LINE */
         if not available pcmstr
         then
            find last pcmstr
               where (pcmstr.pc_list      = pc_mstr.pc_list)
                 and (pcmstr.pc_prod_line = pt_prod_line)
                 and (pcmstr.pc_part      = "")
                 and (pcmstr.pc_start  <= pcdate or pcmstr.pc_start  = ?)
                 and (pcmstr.pc_expire >= pcdate or pcmstr.pc_expire = ?)
                 and pcmstr.pc_curr    =  pc_mstr.pc_curr
                 and (if pc_mstr.pc_amt_type = "L"
                      then
                         pcmstr.pc_amt_type =  "L"
                      else
                         pcmstr.pc_amt_type <> "L")
               no-lock no-error.

         /* LOOK FOR PRICE FOR PRICE LIST */
         if not available pcmstr
         then
            find last pcmstr
               where (pcmstr.pc_list      = pc_mstr.pc_list)
                 and (pcmstr.pc_prod_line = ""
                 and  pcmstr.pc_part      = "")
                 and (pcmstr.pc_start  <= pcdate or pcmstr.pc_start  = ?)
                 and (pcmstr.pc_expire >= pcdate or pcmstr.pc_expire = ?)
                 and pcmstr.pc_curr    =  pc_mstr.pc_curr
                 and (if pc_mstr.pc_amt_type = "L"
                      then
                         pcmstr.pc_amt_type =  "L"
                      else
                         pcmstr.pc_amt_type <> "L")
               no-lock no-error.

         if available pcmstr
            and (not can-find (tt-disp where t_partcode  = pt_part
                                         and t_list      = pc_list
                                         and t_curr      = pc_curr
                                         and t_prod_line = pc_prod_line
                                         and t_part      = pc_part
                                         and t_um        = pc_um
                                         and t_start     = pc_start))
         then do:

            create tt-disp.
            assign
               t_partcode  = pt_part
               t_list      = pc_list
               t_curr      = pc_curr
               t_prod_line = pc_prod_line
               t_part      = pc_part
               t_um        = pc_um
               t_start     = pc_start.
/***************tfq*********************************
            if first-of (pt_prod_line)
            then do:
               if available pl_mstr
               then do with frame c:

                  /* SET EXTERNAL LABELS */
                  setFrameLabels(frame c:handle).
                  display
                     skip(1)
                     pt_prod_line
                     pl_desc
                  with frame c side-labels no-box.

               end. /* IF AVAILABLE pl_mstr THEN */
            end. /* IF FIRST-OF (pt_prod_line )... */
******************************tfq************************/
/***********tfq***************************************
            display
               pt_part
               pt_um
               pt_desc1
               tmp-price @ pt_price.

            if pt_desc2 <> ""
            then do:
               down 1.
               display
                  pt_desc2 @ pt_desc1.
            end. /* IF pt_desc2 <> "" THEN */
********************tfq*******************************/
            find first ad_mstr where (ad_addr = substring(pcmstr.pc_list,1,LENGTH(pcmstr.pc_list) - 1) OR ad_addr =pcmstr.pc_list) no-lock no-error .
            if available ad_mstr then vdname = ad_name .
                                 else vdname = "" .
            do i = 1 to 15:

               if pcmstr.pc_amt_type = "L"
               then
                  net_price = pcmstr.pc_amt[i].

               if pcmstr.pc_amt_type = "P"
               then do:
                  if base_curr       <> pc_mstr.pc_curr and
                     pc_mstr.pc_curr <> ""
                  then do:
                     /* CONVERT FROM BASE TO FOREIGN CURRENCY */
                     {gprunp.i "mcpl" "p" "mc-curr-conv"
                        "(input  base_curr,
                          input  pc_mstr.pc_curr,
                          input  exrate2,
                          input  exrate,
                          input  pt_price,
                          input  false, /* DO NOT ROUND */
                          output list_pr,
                          output mc-error-number)"}
                  end.
                  net_price = pcmstr.pc_amt[i].
               end.

               if pcmstr.pc_amt_type = "D"
               then do:
                  if base_curr       <> pc_mstr.pc_curr and
                     pc_mstr.pc_curr <> ""
                  then do:
                     /* CONVERT FROM BASE TO FOREIGN CURRENCY */
                     {gprunp.i "mcpl" "p" "mc-curr-conv"
                        "(input  base_curr,
                          input  pc_mstr.pc_curr,
                          input  exrate2,
                          input  exrate,
                          input  pt_price,
                          input  false, /* DO NOT ROUND */
                          output list_pr,
                          output mc-error-number)"}
                  end.
                  assign
                     disc_pct  = pcmstr.pc_amt[i]
                     net_price = list_pr * (1 - (disc_pct / 100)).
               end.

               if pcmstr.pc_amt_type = "M"
               then do:
                  /*RETURN OLD GL COST TOTAL AS GLXCST*/
                  find in_mstr
                     where in_part = pt_part
                       and in_site = pt_site
                     no-lock no-error.

                  {gpsct03.i &cost=sct_cst_tot}

                  if  base_curr       <> pc_mstr.pc_curr
                  and pc_mstr.pc_curr <> ""
                  then do:
                     /* CONVERT FROM BASE TO FOREIGN CURRENCY */
                     {gprunp.i "mcpl" "p" "mc-curr-conv"
                        "(input  base_curr,
                          input  pc_mstr.pc_curr,
                          input  exrate2,
                          input  exrate,
                          input  pt_price,
                          input  false, /* DO NOT ROUND */
                          output list_pr,
                          output mc-error-number)"}
                  end.
                  assign
                     net_price = glxcst * (1 + (pcmstr.pc_amt[i] / 100))
                     disc_pct  = (1 - (net_price / list_pr)) * 100.
               end.
                
               if pcmstr.pc_amt[i] <> 0
               then do:
                  IF pcmstr.pc_start = 01/01/01 THEN NEXT.  /*judy*/
                  display
                      pt_part
                   /*   pt_um  */
                      /*pt_desc1 judy*/
                      pt_desc2 
                      pcmstr.pc_list
                      vdname COLUMN-LABEL "供应商名称"
                      pcmstr.pc_amt[i]
                     @ pcmstr.pc_amt[1] label {&pppcrp01_p_1}
                     format "->>>,>>>,>>9.9<<<<"
                      pcmstr.pc_start 
                      pcmstr.pc_expire
                     /*pcmstr.pc_amt_type
                     pcmstr.pc_min_qty[i]
                     @ pcmstr.pc_min_qty[1] label {&pppcrp01_p_3} judy*/
                     /*round(net_price,2) @ net_pricejudy*/  with width 255 stream-io.
                  down 1.
               end.
            end. /* for i = 1 to 15 */
         end. /* if available pcmstr */
         /*GUI*/ {mfguirex.i  "false"} /*Replace mfrpexit*/

    
      end.  /* for each pt_mstr */
          /*GUI*/ {mfguirex.i } /*Replace mfrpexit*/
   end.  /* for each pc_mstr */
   
      {mfguitrl.i} /*Replace mfrtrail*/
    {mfgrptrm.i}  /*Report-to-Window*/
   /* REPORT TRAILER */
  /*tfq  {mfrtrail.i}  */
end.  /* tfq if only-disp-new-price = yes */
else do:

output to listpri.txt .
put     '"' pclist1 '" ' 
        '"' pclist2 '" ' 
        '"' line    '" '
        '"' line1   '" '
        '"' part    '" '
        '"' part   '" '
        '"' curr    '" '
        '"' curr1    '" ' 
        '"' pcdate1  '" ' skip 
        "c:\pcdet"          skip .

        output close .
        batchrun = yes .
        input from listpri.txt .
        output to pricedet.txt .
        {gprun.i ""yypppcrp.p""}
        output close . 
        input close .
      OS-COMMAND notepad  c:\pcdet.prn .
      OS-DELETE c:\pcdet.prn .
      
      
          
end.  
end.

{wbrp04.i &frame-spec = a}

