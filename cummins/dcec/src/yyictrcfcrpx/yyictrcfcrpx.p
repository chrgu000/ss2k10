/*yyictrcfcrp01.p for report the transaction of the items during a period    */
/*Last modified: 02/03/2004, By: Kevin, to cancel the 'loc' criteria         */
/*Last modified: 08/16/2012, By: Henri                                       */
/*cj*convertion to eb2  menu 60.3.23                                         */

{mfdtitle.i "4.2"}
{xxppptrp07.i "new"}
{yyictrcfcrpx.i "new"}
define variable site like si_site no-undo.
define variable site1 like si_site no-undo.
define variable effdate like tr_effdate no-undo initial today.
define variable effdate1 like tr_effdate no-undo initial today.
define variable line like pt_prod_line no-undo.
define variable line1 like pt_prod_line no-undo.
define variable type like pt_part_type no-undo.
define variable type1 like pt_part_type no-undo.
define variable group1 like pt_group no-undo.
define variable group2 like pt_group no-undo.
define variable part like pt_part no-undo.
define variable part1 like pt_part no-undo.
define variable loc LIKE tr_loc no-undo.
define variable loc1 LIKE tr_loc no-undo.
define variable keeper as char label "保管员" no-undo.
define variable keeper1 as char no-undo.
define variable fname   as char no-undo format "x(100)".
define variable amtf    as decimal format "->,>>>,>>>,>>9.<<<<".
define variable amtt    as decimal format "->,>>>,>>>,>>9.<<<<".

DEFINE VARIABLE yn_zero AS LOGICAL INITIAL yes
     LABEL "Suppress Zero"
     VIEW-AS TOGGLE-BOX
     SIZE 13 BY 1.39 NO-UNDO.

DEFINE VAR yn_total AS  LOGICAL INITIAL YES.

define variable qty like tr_qty_loc.
define variable edqty like tr_qty_loc.
define variable bgqty like tr_qty_loc.
define variable inqty like tr_qty_loc.
define variable outqty like tr_qty_loc.
define variable tot_edqty like tr_qty_loc.
define variable tot_bgqty like tr_qty_loc.
define variable tot_inqty like tr_qty_loc.
define variable tot_outqty like tr_qty_loc.
define variable rctpo like tr_qty_loc.
define variable rcttr like tr_qty_loc.
define variable rctunp like tr_qty_loc.
define variable rctwo like tr_qty_loc.
define variable isspo like tr_qty_loc.
define variable isstr like tr_qty_loc.
define variable issunp like tr_qty_loc.
define variable issso like tr_qty_loc.
define variable isswo like tr_qty_loc.
define variable invadj like tr_qty_loc.
define variable oth like tr_qty_loc.
define variable cst like tr_qty_loc.
define variable edqty_amt like tr_qty_loc.
define variable msg-nbr as inte.
define variable I AS INTE.
define variable LINECOUNT AS INTE.
define variable ptdesc2 like pt_desc2.
define variable ptprodline like pt_prod_line.
define variable cost_qty like mfc_logical initial yes.

Form
/*GM65*/
 RECT-FRAME       AT ROW 1 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1 COLUMN 3 NO-LABEL VIEW-AS TEXT SIZE-PIXELS 1 BY 1
 SKIP(.1)  /*GUI*/
 site colon 22   site1 colon 49 label {t001.i}
 effdate colon 22       effdate1 colon 49 label {t001.i}
 line colon 22          line1 colon 49 label {t001.i}
 type colon 22          type1 colon 49 label {t001.i}
 group1 colon 22        group2 colon 49 label {t001.i}
 part colon 22          part1 colon 49 label {t001.i}
/* site colon 22          site1 colon 49 label {t001.i} */
/*cj*/ loc colon 22           loc1 colon 49 label {t001.i}
 keeper colon 22        keeper1 colon 49 label {t001.i}
 cost_qty colon 22 skip(1)
 yn_zero colon 22  label "抑制为零数据"
 fname colon 22 view-as fill-in size 50 by 1
/* yn_total colon 49 LABEL "地点汇总" */
 SKIP(.4)  /*GUI*/
with frame a side-labels width 80 attr-space NO-BOX THREE-D /*GUI*/.

setframelabels(frame a:handle) .

 DEFINE VARIABLE F-a-title AS CHARACTER INITIAL "".
 RECT-FRAME-LABEL:SCREEN-VALUE in frame a = F-a-title.
 RECT-FRAME-LABEL:HIDDEN in frame a = yes.
 RECT-FRAME:HEIGHT-PIXELS in frame a =
  FRAME a:HEIGHT-PIXELS - RECT-FRAME:Y in frame a - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME a = FRAME a:WIDTH-CHARS - .5.  /*GUI*/
{yyictrcfcrpx1.i}
repeat:
    if effdate = low_date then effdate = ?.
    if effdate1 = hi_date then effdate1 = ?.
    if line1 = hi_char then line1 = "".
    if type1 = hi_char then type1 = "".
    if group2 = hi_char then group2 = "".
    if part1 = hi_char then part1 = "".
    if site1 = hi_char then site1 = "".
    if loc1 = hi_char then loc1 = "".
    if keeper1 = hi_char then keeper1 = "".

    update site site1 effdate effdate1 line line1 type type1 group1 group2 part part1 /*site site1*/
           /*cj*/ loc loc1 keeper keeper1 cost_qty yn_zero fname with frame a.
    if effdate = ? then do:
       {mfmsg.i 40 3}
       next-prompt effdate with frame a.
       undo,retry.
    end.
    if effdate1 = ? then do:
       {mfmsg.i 40 3}
       next-prompt effdate1 with frame a.
       undo,retry.
    end.
     {yyictrcfcrpx2.i}
    if effdate = ? then effdate = low_date.
    if effdate1 = ? then effdate1 = hi_date.
    if line1 = "" then line1 = hi_char.
    if type1 = "" then type1 = hi_char.
    if group2 = "" then group2 = hi_char.
    if part1 = "" then part1 = hi_char.
    if site1 = "" then site1 = hi_char.
    if loc1 = "" then loc1 = hi_char.
    if keeper1 = "" then keeper1 = hi_char.

{mfselbpr.i "printer" 480}

    status input "Waiting for report process...".
for each tmpld03: delete tmpld03. end.
for each tmploc01: delete tmploc01. end.
for each temptr: delete temptr. end.

/*
for each loc_mstr no-lock where loc_domain = global_domain:
    create tmploc01.
    assign t01_site = loc_site
           t01_loc = loc_loc.
end.
*/
if cost_qty = no then do:  /*费用类库位列表*/
   for each code_mstr no-lock where code_domain = global_domain
        and code_fldname = "INVTR",
       each pld_det no-lock where pld_domain = global_domain and
            pld_inv_acct = code_value
       break by pld_site by pld_loc:
       if first-of(pld_loc) then do:
          find first tmploc01 exclusive-lock where t01_site = pld_site
                 and t01_loc = pld_loc no-error.
          if not available tmploc01 then do:
             create tmploc01.
             assign t01_site = pld_site
                    t01_loc = pld_loc.
          end.
       end.
   end.
end.
{gprun.i ""xxppptrp07.p""
        "(input part,
          input part1,
          input line,
          input line1,
          input ''  /*vend*/,
          input hi_char,
          input ''  /*abc*/,
          input hi_char,
          input site,
          input site1,
          input '' /*loc*/,
          input hi_char,
          input group1,
          input group2,
          input type,
          input type1,
          input keeper,
          input keeper1,
          input effdate - 1,
          input yes,
          input yes,
          input no,
          input yes,
          input cost_qty,
          input 'Include',
          input 'Exclude'
        )"}

  for each tmpld03 no-lock:
      find first temptr exclusive-lock where ttr_part = t03_part
             and ttr_site = t03_site no-error.
      if not available temptr then do:
         create temptr.
         assign ttr_part = t03_part
                ttr_site = t03_site.
      end.
      assign ttr_qtyf = t03_qty
             ttr_cstf = t03_cst.
  end.
for each tmpld03: delete tmpld03. end.
/*  {gprun.i ""xxptrp07.p""       */
/*          "(input part,         */
/*            input part1,        */
/*            input line,         */
/*            input line1,        */
/*            input '',           */
/*            input hi_char,      */
/*            input '',           */
/*            input hi_char,      */
/*            input site,         */
/*            input site1,        */
/*            input group1,       */
/*            input group2,       */
/*            input type,         */
/*            input type1,        */
/*            input keeper,       */
/*            input keeper1,      */
/*            input effdate1,     */
/*            input yes,          */
/*            input yes,          */
/*            input no,           */
/*            input yes,          */
/*            input 'Include',    */
/*            input 'Exclude'     */
/*          )"}                   */

{gprun.i ""xxppptrp07.p""
        "(input part,
          input part1,
          input line,
          input line1,
          input ''  /*vend*/,
          input hi_char,
          input ''  /*abc*/,
          input hi_char,
          input site,
          input site1,
          input '' /*loc*/,
          input hi_char,
          input group1,
          input group2,
          input type,
          input type1,
          input keeper,
          input keeper1,
          input effdate1,
          input yes,
          input yes,
          input no,
          input yes,
          input cost_qty,
          input 'Include',
          input 'Exclude'
        )"}

  for each tmpld03 no-lock:
      find first temptr exclusive-lock where ttr_part = t03_part
             and ttr_site = t03_site no-error.
      if not available temptr then do:
         create temptr.
         assign ttr_part = t03_part
                ttr_site = t03_site.
      end.
      assign ttr_qtyt = t03_qty
             ttr_cstt = t03_cst.
  end.

/******Test phease*******
for each pt_mstr
         fields( pt_domain pt_part pt_group pt_part_type pt_prod_line pt_vend
         pt_desc1 pt_desc2 pt_um)
      no-lock
          where pt_mstr.pt_domain = global_domain and  (pt_part >= part
          and pt_part <= part1)
         and   (pt_prod_line >= line    and pt_prod_line <= line1)
         and   (pt_group  >= part_group and pt_group <= part_group1)
         and (pt_part_type >= part_type and pt_part_type <= part_type1)
         , each in_mstr
         fields( in_domain in_part in_site in_abc in_cur_set in_gl_set
         in_qty_nonet in_qty_oh in_gl_cost_site)
          where in_mstr.in_domain = global_domain and  in_part  =  pt_part
         and   (in_abc  >= abc  and in_abc  <= abc1)
         and   (in_site >= site and in_site <= site1)
         and   (in__qadc01 >= keep and in__qadc01 <= keep1)
      no-lock,
******Test phease*******/
      for each tr_hist
       fields(tr_domain tr_part tr_effdate tr_site tr_type tr_qty_loc tr_price)
       use-index tr_part_eff
       where tr_domain = global_domain and
             (tr_part  >= part and tr_part <= part1) and
             (tr_effdate >= effdate and tr_effdate <= effdate1) and
             (tr_site >= site and tr_site <= site1) and tr_qty_loc <> 0 no-lock,
/*      each tmploc01 no-lock where t01_site = in_site and t01_loc = in_loc, */
      each pt_mstr
         fields( pt_domain pt_part pt_group pt_part_type pt_prod_line pt_vend
         pt_desc1 pt_desc2 pt_um)
      no-lock
          where pt_mstr.pt_domain = global_domain and (pt_part = tr_part)
         and (pt_prod_line >= line    and pt_prod_line <= line1)
         and (pt_group  >= group1 and pt_group <= group2)
         and (pt_part_type >= type and pt_part_type <= type1)
/*     ,each in_mstr                                                         */
/*         fields(in_domain in_part in_site in_abc in_cur_set in_gl_set     */
/*         in_qty_nonet in_qty_oh in_gl_cost_site) no-lock                  */
/*          where in_mstr.in_domain = global_domain and in_part = pt_part   */
/*          and (in_site = tr_site)                                         */
/*          and (in__qadc01 >= keeper and in__qadc01 <= keeper1)            */
          break by tr_part by tr_type:

          if first-of(tr_type) then assign qty = 0.

/*fyk*/  find first tmploc01 no-lock where t01_site = tr_site and t01_loc = tr_loc
/*fyk*/       no-error.
/*fyk*/  if available tmploc01 then do:
/*fyk*/     next.
/*fyk*/  end.

         assign qty = qty + tr_qty_loc.
          if last-of(tr_type) then do:
           find first temptr exclusive-lock where ttr_part = tr_part and
                  ttr_site = tr_site no-error.
           if not available temptr then do:
              create temptr.
              assign ttr_part = tr_part
                     ttr_site = tr_site.
           end.
           if tr_type = "rct-po" then do:
                ttr_rctpo = ttr_rctpo + tr_qty_loc.
                ttr_rctpoc = ttr_rctpoc + tr_price * tr_qty_loc.
           end.
           else if tr_type = "rct-tr" then do:
                ttr_rcttr = ttr_rcttr + tr_qty_loc.
                ttr_rcttrc = ttr_rcttrc + tr_price * tr_qty_loc.
           end.
           else if tr_type = "rct-unp" then do:
                ttr_rctunp = ttr_rctunp + tr_qty_loc.
                ttr_rctunpc = ttr_rctunpc + tr_price * tr_qty_loc.
           end.
           else if tr_type = "rct-wo" then do:
                ttr_rctwo = ttr_rctwo + tr_qty_loc.
                ttr_rctwoc = ttr_rctwoc + tr_price * tr_qty_loc.
           end.
           else if tr_type = "iss-prv" then do:
                ttr_isspo = ttr_isspo - tr_qty_loc.
                ttr_isspoc = ttr_isspoc - tr_price * tr_qty_loc.
           end.
           else if tr_type = "iss-tr" then do:
                ttr_isstr = ttr_isstr - tr_qty_loc.
                ttr_isstrc = ttr_isstrc - tr_price * tr_qty_loc.
           end.
           else if tr_type = "iss-unp" then do:
                ttr_issunp = ttr_issunp - tr_qty_loc.
                ttr_issunpc = ttr_issunpc - tr_price * tr_qty_loc.
           end.
           else if tr_type = "iss-so" then do:
                ttr_issso = ttr_issso - tr_qty_loc.
                ttr_isssoc = ttr_isssoc - tr_price * tr_qty_loc.
           end.
           else if tr_type = "iss-wo" then do:
                ttr_isswo = ttr_isswo - tr_qty_loc.
                ttr_isswoc = ttr_isswoc - tr_price * tr_qty_loc.
           end.
           else if (tr_type = "tag-cnt" or tr_type = "cyc-cnt" or tr_type = "cyc-rcnt")
                then do:
                     ttr_invadj = ttr_invadj + tr_qty_loc.
                     ttr_invadjc = ttr_invadjc + tr_price * tr_qty_loc.
                end.
           else do:
                ttr_oth = ttr_oth + tr_qty_loc.
                ttr_othc = ttr_othc + tr_price * tr_qty_loc.
           end.
         end. /*if last-of(tr_type) */
    end.
/*
for each temptr exclusive-lock:
    assign ttr_qtyf = ttr_qtyt - ttr_rctpo - ttr_rcttr - ttr_rctunp - ttr_rctwo - ttr_invadj - ttr_oth
                    + ttr_isspo + ttr_isstr + ttr_issunp + ttr_issso + ttr_isswo.
    assign ttr_cstf = ttr_cstt - ttr_rctpoc - ttr_rcttrc - ttr_rctunpc - ttr_rctwoc - ttr_invadjc - ttr_othc 
                    + ttr_isspoc + ttr_isstrc + ttr_issunpc + ttr_isssoc + ttr_isswoc.
end.
*/
    
if fname = "" then do:
 disp effdate column-label "起始日期" format "9999/99/99"
      effdate1 column-label "截止日期" format "9999/99/99" with frame x stream-io.
      setframelabels(frame x:handle).
    for each temptr no-lock break by ttr_part by ttr_site
        with frame b width 420:
        setframelabels(frame b:handle).
        if first-of(ttr_part) then do:
           assign ptdesc2 = ""
                  ptprodline = "".
           find first pt_mstr no-lock where pt_domain = global_domain
                  and pt_part = ttr_part no-error.
           if available pt_mstr then do:
              assign ptdesc2 = pt_desc2
                     ptprodline = pt_prod_line.
           end.
        end.
        find first ptp_det no-lock where ptp_domain = global_domain
               and ptp_part = ttr_part and ptp_site = ttr_site no-error.
        find first in_mstr no-lock where in_domain = global_domain
               and in_part = ttr_part and in_site = ttr_site no-error.
        display ttr_part
                ttr_site @ pt_site
                ptdesc2 @ pt_desc2
                ptprodline @ pt_prod_line
                in_abc when available (in_mstr)
                in__qadc01 when available (in_mstr)
                in_loc when available (in_mstr)
                ptp_buyer when available ptp_det
                ptp_vend when available ptp_det
                ptp_run_seq2 when available ptp_det
                ttr_qtyf
                ttr_cstf
                ttr_qtyf * ttr_cstf @ amtf
                ttr_rctpo
                ttr_rctpoc
                ttr_rcttr
                ttr_rcttrc
                ttr_rctunp
                ttr_rctunpc
                ttr_rctwo
                ttr_rctwoc
                ttr_isspo
                ttr_isspoc
                ttr_isstr
                ttr_isstrc
                ttr_issunp
                ttr_issunpc
                ttr_issso
                ttr_isssoc
                ttr_isswo
                ttr_isswoc
                ttr_invadj
                ttr_invadjc
                ttr_oth
                ttr_othc
                ttr_qtyt
                ttr_cstt
                ttr_qtyt * ttr_cstt @ amtt with stream-io.

    {mfrpchk.i}
    end.
end.
else do:
   {gprun.i ""yyictrcfcrpxx.p"" "(input fname)"}
end.
/* IF yn_total = YES THEN DO:                                                                                         */
/*    for each in_mstr WHERE in_domain = global_domain and                                                            */
/*                           (in_site >= site and in_site <= site1) and                                               */
/*                           (in_part >= part and in_part <= part1) and                                               */
/*                           (in__qadc01 >= keeper and in__qadc01 <= keeper1) no-lock,                                */
/*        each pt_mstr where pt_part = in_part and pt_domain = global_domain and                                      */
/*                           (pt_prod_line >= line and pt_prod_line <= line1) and                                     */
/*                           (pt_part_type >= type and pt_part_type <= type1) and                                     */
/*                           (pt_group >= group1 and pt_group <= group2) no-lock:                                     */
/*                                                                                                                    */
/*       edqty = 0.                                                                                                   */
/*       bgqty = 0.                                                                                                   */
/*       inqty = 0.                                                                                                   */
/*       outqty =0.                                                                                                   */
/*       rctpo = 0.                                                                                                   */
/*       rcttr = 0.                                                                                                   */
/*       rctunp = 0.                                                                                                  */
/*       rctwo = 0.                                                                                                   */
/*       isspo = 0.                                                                                                   */
/*       isstr = 0.                                                                                                   */
/*       issunp = 0.                                                                                                  */
/*       issso = 0.                                                                                                   */
/*       isswo = 0.                                                                                                   */
/*       invadj = 0.                                                                                                  */
/*       oth = 0.                                                                                                     */
/*                                                                                                                    */
/*        edqty = in_qty_oh + in_qty_nonet.                                                                           */
/*                                                                                                                    */
/*        for each tr_hist no-lock where tr_domain = global_domain and tr_part = pt_part                              */
/*                 and tr_site = in_site and tr_effdate >= effdate                                                    */
/*                 and tr_ship_type = ""                                                                              */
/*                 and (tr_qty_loc <> 0 or tr_type = "cst-adj")                                                       */
/*                 /*cj*/ and (tr_loc >= loc and tr_loc <= loc1):                                                     */
/*                                                                                                                    */
/*          if tr_effdate >= effdate and tr_effdate <= effdate1 then do:                                              */
/*             if tr_type = "rct-po" then rctpo = rctpo + tr_qty_loc.                                                 */
/*             else if tr_type = "rct-tr" then rcttr = rcttr + tr_qty_loc.                                            */
/*             else if tr_type = "rct-unp" then rctunp = rctunp + tr_qty_loc.                                         */
/*             else if tr_type = "rct-wo" then rctwo = rctwo + tr_qty_loc.                                            */
/*             else if tr_type = "iss-prv" then isspo = isspo - tr_qty_loc.                                           */
/*             else if tr_type = "iss-tr" then isstr = isstr - tr_qty_loc.                                            */
/*             else if tr_type = "iss-unp" then issunp = issunp - tr_qty_loc.                                         */
/*             else if tr_type = "iss-so" then issso = issso - tr_qty_loc.                                            */
/*             else if tr_type = "iss-wo" then isswo = isswo - tr_qty_loc.                                            */
/*             else if (tr_type = "tag-cnt" or tr_type = "cyc-cnt" or tr_type = "cyc-rcnt")                           */
/*                  then invadj = invadj + tr_qty_loc.                                                                */
/*             else oth = oth + tr_qty_loc.                                                                           */
/*          end.                                                                                                      */
/*                                                                                                                    */
/*            if tr_effdate <= effdate1 then do:                                                                      */
/*                if tr_type begins "Iss" then                                                                        */
/*                    outqty = outqty - tr_qty_loc.                                                                   */
/*                if tr_type begins "rct" then                                                                        */
/*                    inqty = inqty + tr_qty_loc.                                                                     */
/*            end. /* if tr_effdate */                                                                                */
/*            else if tr_qty_loc <> 0 then                                                                            */
/*                edqty = edqty - tr_qty_loc.                                                                         */
/*        end. /* for each tr_hist */                                                                                 */
/*                                                                                                                    */
/*        /*bgqty = max(0, edqty - inqty + outqty ).*/                                                                */
/*       bgqty = edqty - inqty + outqty.                                                                              */
/*                                                                                                                    */
/*        if (yn_zero and (edqty <> 0 or bgqty <> 0 or rctpo <> 0 or rcttr <> 0 or rctunp <> 0 or rctwo <> 0          */
/*          or isspo <> 0 or isstr <> 0 or issunp <> 0 or issso <> 0                                                  */
/*          or isswo <> 0 or invadj <> 0 or oth <> 0))                                                                */
/*           or not yn_zero then do:                                                                                  */
/*                                                                                                                    */
/*           {gpsct03.i &cost=sct_cst_tot}                                                                            */
/*                                                                                                                    */
/*           edqty_amt = edqty * glxcst.                                                                              */
/*                                                                                                                    */
/*           disp pt_part pt_desc2 pt_prod_line pt_abc in__qadc01 label "保管员"                                      */
/*              in_user1 label "缺省库位" bgqty label "期初库存"                                                      */
/*              rctpo label "采购收货" rcttr label "转移入库" rctunp label "计划外入库"                               */
/*              rctwo label "加工单入库" isspo label "采购退货" isstr label "转移出库"                                */
/*              issunp label "计划外出库" issso label "销售出库"                                                      */
/*              isswo label "加工单出库" invadj label "盘点调整" oth label "其他"                                     */
/*              edqty label "期末库存" glxcst edqty_amt label "期末库存金额" with width 300 stream-io.                */
/*                                                                                                                    */
/*        end.                                                                                                        */
/*                                                                                                                    */
/*    end. /*for each in_mstr,each pt_mstr*/                                                                          */
/* END.                                                                                                               */
/*                                                                                                                    */
/*                                                                                                                    */
/*                                                                                                                    */
/*                                                                                                                    */
/* /****************************************************************************************************************/ */
/*                                                                                                                    */
/*                                                                                                                    */
/*  IF yn_total = NO THEN DO:                                                                                         */
/*   FOR EACH si_mstr WHERE si_domain = global_domain and si_site >= site AND si_site <= site1 NO-LOCK.               */
/*                                                                                                                    */
/*                                                                                                                    */
/*    for each in_mstr WHERE in_domain = global_domain and IN_site = si_site and                                      */
/*                           (in_part >= part and in_part <= part1) and                                               */
/*                           (in__qadc01 >= keeper and in__qadc01 <= keeper1) no-lock,                                */
/*        each pt_mstr where pt_domain = global_domain and pt_part = in_part and                                      */
/*                           (pt_prod_line >= line and pt_prod_line <= line1) and                                     */
/*                           (pt_part_type >= type and pt_part_type <= type1) and                                     */
/*                           (pt_group >= group1 and pt_group <= group2) no-lock:                                     */
/*                                                                                                                    */
/*        edqty = 0.                                                                                                  */
/*        bgqty = 0.                                                                                                  */
/*        inqty = 0.                                                                                                  */
/*        outqty =0.                                                                                                  */
/*       rctpo = 0.                                                                                                   */
/*       rcttr = 0.                                                                                                   */
/*       rctunp = 0.                                                                                                  */
/*       rctwo = 0.                                                                                                   */
/*       isspo = 0.                                                                                                   */
/*       isstr = 0.                                                                                                   */
/*       issunp = 0.                                                                                                  */
/*       issso = 0.                                                                                                   */
/*       isswo = 0.                                                                                                   */
/*       invadj = 0.                                                                                                  */
/*       oth = 0.                                                                                                     */
/*                                                                                                                    */
/*        edqty = in_qty_oh + in_qty_nonet.                                                                           */
/*                                                                                                                    */
/*        for each tr_hist no-lock where tr_domain = global_domain                                                    */
/*                 and tr_part = pt_part                                                                              */
/*                 and tr_site = in_site and tr_effdate >= effdate                                                    */
/*                 and tr_ship_type = ""                                                                              */
/*                 and (tr_qty_loc <> 0 or tr_type = "cst-adj")                                                       */
/*                 /*cj*/ and (tr_loc >= loc and tr_loc <= loc1):                                                     */
/*                                                                                                                    */
/*          if tr_effdate >= effdate and tr_effdate <= effdate1 then do:                                              */
/*             if tr_type = "rct-po" then rctpo = rctpo + tr_qty_loc.                                                 */
/*             else if tr_type = "rct-tr" then rcttr = rcttr + tr_qty_loc.                                            */
/*             else if tr_type = "rct-unp" then rctunp = rctunp + tr_qty_loc.                                         */
/*             else if tr_type = "rct-wo" then rctwo = rctwo + tr_qty_loc.                                            */
/*             else if tr_type = "iss-prv" then isspo = isspo - tr_qty_loc.                                           */
/*             else if tr_type = "iss-tr" then isstr = isstr - tr_qty_loc.                                            */
/*             else if tr_type = "iss-unp" then issunp = issunp - tr_qty_loc.                                         */
/*             else if tr_type = "iss-so" then issso = issso - tr_qty_loc.                                            */
/*             else if tr_type = "iss-wo" then isswo = isswo - tr_qty_loc.                                            */
/*             else if (tr_type = "tag-cnt" or tr_type = "cyc-cnt" or tr_type = "cyc-rcnt")                           */
/*                  then invadj = invadj + tr_qty_loc.                                                                */
/*             else oth = oth + tr_qty_loc.                                                                           */
/*          end.                                                                                                      */
/*                                                                                                                    */
/*            if tr_effdate <= effdate1 then do:                                                                      */
/*                if tr_type begins "Iss" then                                                                        */
/*                    outqty = outqty - tr_qty_loc.                                                                   */
/*                if tr_type begins "rct" then                                                                        */
/*                    inqty = inqty + tr_qty_loc.                                                                     */
/*            end. /* if tr_effdate */                                                                                */
/*            else if tr_qty_loc <> 0 then                                                                            */
/*                edqty = edqty - tr_qty_loc.                                                                         */
/*        end. /* for each tr_hist */                                                                                 */
/*                                                                                                                    */
/*        /*bgqty = max(0, edqty - inqty + outqty ).*/                                                                */
/*       bgqty = edqty - inqty + outqty.                                                                              */
/*                                                                                                                    */
/*        if (yn_zero and (edqty <> 0 or bgqty <> 0 or rctpo <> 0 or rcttr <> 0 or rctunp <> 0 or rctwo <> 0          */
/*          or isspo <> 0 or isstr <> 0 or issunp <> 0 or issso <> 0                                                  */
/*          or isswo <> 0 or invadj <> 0 or oth <> 0))                                                                */
/*           or not yn_zero then do:                                                                                  */
/*                                                                                                                    */
/*           {gpsct03.i &cost=sct_cst_tot}                                                                            */
/*                                                                                                                    */
/*           edqty_amt = edqty * glxcst.                                                                              */
/*                                                                                                                    */
/*           disp pt_part pt_desc2 si_site pt_prod_line pt_abc in__qadc01 label "保管员"                              */
/*              in_user1 label "缺省库位" bgqty label "期初库存"                                                      */
/*              rctpo label "采购收货" rcttr label "转移入库" rctunp label "计划外入库"                               */
/*              rctwo label "加工单入库" isspo label "采购退货" isstr label "转移出库"                                */
/*              issunp label "计划外出库" issso label "销售出库"                                                      */
/*              isswo label "加工单出库" invadj label "盘点调整" oth label "其他"                                     */
/*              edqty label "期末库存" glxcst edqty_amt label "期末库存金额" with width 300 stream-io.                */
/*                                                                                                                    */
/*        end.                                                                                                        */
/*                                                                                                                    */
/*    end. /*for each in_mstr,each pt_mstr*/                                                                          */
/*                                                                                                                    */
/*     END. /*site*/                                                                                                  */
/* END.                                                                                                               */

/*GUI*/ {mfgrptrm.i} /*Report-to-Window*/

    status input.

end. /*repeat*/
