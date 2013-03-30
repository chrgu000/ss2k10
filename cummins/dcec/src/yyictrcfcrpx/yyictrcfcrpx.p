/*yyictrcfcrp01.p for report the transaction of the items during a period    */
/*Last modified: 02/03/2004, By: Kevin, to cancel the 'loc' criteria         */
/*Last modified: 08/16/2012, By: Henri                                       */
/*cj*convertion to eb2  menu 60.3.23                                         */

{mfdtitle.i "328.2"}
{xxptrp07.i "new"}
{yyictrcfcrpx.i "new"}
def var site like si_site no-undo.
def var site1 like si_site no-undo.
def var effdate like tr_effdate no-undo initial today.
def var effdate1 like tr_effdate no-undo initial today.
def var line like pt_prod_line no-undo.
def var line1 like pt_prod_line no-undo.
def var type like pt_part_type no-undo.
def var type1 like pt_part_type no-undo.
def var group1 like pt_group no-undo.
def var group2 like pt_group no-undo.
def var part like pt_part no-undo.
def var part1 like pt_part no-undo.
DEF VAR loc LIKE tr_loc no-undo.
DEF VAR loc1 LIKE tr_loc no-undo.
def var keeper as char label "保管员" no-undo.
def var keeper1 as char no-undo.
def var fname   as char no-undo format "x(100)".
def var amtf    as decimal format "->>>,>>>,>>>,>>>,>>>,>>>9.<<<".
def var amtt    as decimal format "->>>,>>>,>>>,>>>,>>>,>>>9.<<<".

DEFINE VARIABLE yn_zero AS LOGICAL INITIAL yes
     LABEL "Suppress Zero"
     VIEW-AS TOGGLE-BOX
     SIZE 13 BY 1.39 NO-UNDO.

DEFINE VAR yn_total AS  LOGICAL INITIAL YES.

define variable qty like tr_qty_loc.
def var edqty like tr_qty_loc.
def var bgqty like tr_qty_loc.
def var inqty like tr_qty_loc.
def var outqty like tr_qty_loc.
def var tot_edqty like tr_qty_loc.
def var tot_bgqty like tr_qty_loc.
def var tot_inqty like tr_qty_loc.
def var tot_outqty like tr_qty_loc.

def var rctpo like tr_qty_loc.
def var rcttr like tr_qty_loc.
def var rctunp like tr_qty_loc.
def var rctwo like tr_qty_loc.
def var isspo like tr_qty_loc.
def var isstr like tr_qty_loc.
def var issunp like tr_qty_loc.
def var issso like tr_qty_loc.
def var isswo like tr_qty_loc.
def var invadj like tr_qty_loc.
def var oth like tr_qty_loc.

def var cst like tr_qty_loc.
def var edqty_amt like tr_qty_loc.

def var msg-nbr as inte.

DEF VAR I AS INTE.
DEF VAR LINECOUNT AS INTE.

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
 keeper colon 22        keeper1 colon 49 label {t001.i} skip(1)
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
           /*cj*/ loc loc1 keeper keeper1 yn_zero /* yn_total */ fname with frame a.
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

/*   find si_mstr no-lock where si_domain = global_domain and si_site = site no-error.          */
/*   if not available si_mstr or (si_db <> global_db) then do:                                  */
/*       if not available si_mstr then msg-nbr = 708.                                           */
/*       else msg-nbr = 5421.                                                                   */
/*       /*tfq {mfmsg.i msg-nbr 3}*/                                                            */
/*        {pxmsg.i &MSGNUM=msg-nbr &ERRORLEVEL=3}                                               */
/*        undo, retry.                                                                          */
/*   end.                                                                                       */
/*                                                                                              */
/*                 {gprun.i ""gpsiver.p""                                                       */
/*                 "(input si_site, input recid(si_mstr), output return_int)"}                  */
/* /*GUI*/ if global-beam-me-up then undo, leave.                                               */
/*                                                                                              */
/* /*J034*/          if return_int = 0 then do:                                                 */
/* /*J034*/       /*tfq      {mfmsg.i 725 3}*/                                                  */
/*         {pxmsg.i &MSGNUM=725 &ERRORLEVEL=3}                                                  */
/*     /* USER DOES NOT HAVE */                                                                 */
/* /*J034*/                                /* ACCESS TO THIS SITE*/                             */
/* /*J034*/             undo,retry.                                                             */
/* /*J034*/          end.                                                                       */

    {mfselbpr.i "printer" 420}

    status input "Waiting for report process...".
for each tmpld03: delete tmpld03. end.
{gprun.i ""xxptrp07.p""
        "(input part,
          input part1,
          input line,
          input line1,
          input '',
          input hi_char,
          input '',
          input hi_char,
          input site,
          input site1,
          input group1,
          input group2,
          input type,
          input type1,
          input keeper,
          input keeper1,
          input effdate,
          input yes,
          input yes,
          input no,
          input yes,
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
{gprun.i ""xxptrp07.p""
        "(input part,
          input part1,
          input line,
          input line1,
          input '',
          input hi_char,
          input '',
          input hi_char,
          input site,
          input site1,
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

  for each temptr exclusive-lock:
      for each tr_hist
         fields(tr_domain tr_part tr_effdate tr_site tr_type tr_qty_loc)
         use-index tr_part_eff
         where tr_domain = global_domain and
               tr_part  = ttr_part and
               tr_effdate >= effdate and tr_effdate <= effdate1 and
               tr_site = ttr_site no-lock break by tr_type:
         if first-of(tr_type) then assign qty = 0.
         assign qty = qty + tr_qty_loc.
         if last-of(tr_type) then do:
            if tr_type = "rct-po" then ttr_rctpo = qty.
             else if tr_type = "rct-tr" then ttr_rcttr = qty.
             else if tr_type = "rct-unp" then ttr_rctunp = qty.
             else if tr_type = "rct-wo" then ttr_rctwo = qty.
             else if tr_type = "iss-prv" then ttr_isspo = - qty.
             else if tr_type = "iss-tr" then ttr_isstr = - qty.
             else if tr_type = "iss-unp" then ttr_issunp = - qty.
             else if tr_type = "iss-so" then ttr_issso = - qty.
             else if tr_type = "iss-wo" then ttr_isswo = - qty.
             else if (tr_type = "tag-cnt" or tr_type = "cyc-cnt" or tr_type = "cyc-rcnt")
                  then ttr_invadj = ttr_invadj + qty.
             else ttr_oth = ttr_oth + qty.
         end.
      end.
  end.
/*********

起始日期   截止日期
---------- ----------
01/01/1900 31/12/3999

Item Number        Description              Line ABC 保管员   缺省库位      期初库存     采购收货     转移入库   计划外入库   加工单入库     采购退货     转移出库   计划外出库     销售出库   加工单出库     盘点调整         其他     期末库存        GL Cost   期末库存金额
------------------ ------------------------ ---- --- -------- -------- ------------ ------------ ------------ ------------ ------------ ------------ ------------ ------------ ------------ ------------ ------------ ------------ ------------ --------------- ------------
178957             空气阻力指示器           1102 B   c113     b14g3         2,130.0          0.0         60.0          0.0          0.0          0.0        120.0          0.0          0.0        583.0      2,130.0          0.0      1,487.0           72.96   108,491.52
181461             空压机卸荷压力调节器     1102 B   c111     A07I2           867.0          0.0        634.0          0.0          0.0          0.0        634.0          0.0          0.0        326.0        867.0        -16.0        525.0          152.32     79,968.0

*****/



if fname = "" then do:
 disp effdate column-label "起始日期" format "9999/99/99"
      effdate1 column-label "截止日期" format "9999/99/99" with frame x stream-io.
      setframelabels(frame x:handle).
    for each temptr no-lock break by ttr_part by ttr_site
        with frame b width 420:
        setframelabels(frame b:handle).
        if first-of(ttr_part) then do:
           find first pt_mstr no-lock where pt_domain = global_domain
                  and pt_part = ttr_part no-error.
        end.
        find first ptp_det no-lock where ptp_domain = global_domain
               and ptp_part = ttr_part and ptp_site = ttr_site no-error.
        find first in_mstr no-lock where in_domain = global_domain
               and in_part = ttr_part and in_site = ttr_site.
        display ttr_part
                pt_desc2 when available (pt_mstr)
                pt_prod_line when available (pt_mstr)
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
                ttr_rcttr
                ttr_rctunp
                ttr_rctwo
                ttr_isspo
                ttr_isstr
                ttr_issunp
                ttr_issso
                ttr_isswo
                ttr_invadj
                ttr_oth
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
