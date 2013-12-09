/* xxtrrp01.p  rev 20121008.1  henri Zhu       10/08/2012    */
/* xxtrrp01.p  rev 20121119.1  Steven          11/19/2012    */
/* REVISION  EBSP4   BY: MEL ZHAO DATE 13/03/06 ECO SS-20130306.1           */
{mfdtitle.i    "20130306.1" }

define variable part     like  pt_part          no-undo.
define variable part1    like  pt_part          no-undo.
define variable effdate  as date                no-undo.
define variable effdate1 as date                no-undo.
define variable trdate   as date                no-undo.
define variable trdate1  as date                no-undo.
define variable nbr      like  so_nbr           no-undo.
define variable nbr1     like  so_nbr           no-undo.
define variable site     like  pt_site          no-undo.
define variable site1    like  pt_site          no-undo.
define variable so_job   like  tr_so_job        no-undo.
define variable so_job1  like  tr_so_job        no-undo.
define variable loc      like  tr_loc           no-undo.
define variable loc1     like  tr_loc           no-undo.
define variable type     like  pt_part_type     no-undo.

define variable drg      as char format "x(24)" no-undo.
define variable i        as int  format ">>>>>>" no-undo.
define variable qty      like tr_qty_req no-undo.
define variable qty1     like tr_qty_req no-undo.

form
   part           colon 20   part1     label {t001.i} colon 49 skip
   effdate        colon 20   effdate1  label {t001.i} colon 49 skip
   trdate         colon 20   trdate1   label {t001.i} colon 49 skip
   nbr            colon 20   nbr1      label {t001.i} colon 49 skip
   site           colon 20   site1     label {t001.i} colon 49 skip
   so_job         colon 20   so_job1   label {t001.i} colon 49 skip
   loc            colon 20   loc1      label {t001.i} colon 49 skip
   skip(1)
   type           colon 20
   with frame a side-labels width 80 attr-space.
setFrameLabels(frame a:handle).

repeat :
 if part1    = hi_char    then part1    = "".
 if nbr1     = hi_char    then nbr1     = "".
 if site1    = hi_char    then site1    = "".
 if so_job1  = hi_char    then so_job1  = "".
 if loc1     = hi_char    then loc1     = "".
 if effdate  = low_date   then effdate = ?.
 if effdate1 = hi_date    then effdate1 = ?.
 if trdate   = low_date   then trdate = ?.
 if trdate1  = hi_date    then trdate1 = ?.

  update part part1 effdate effdate1 trdate trdate1 nbr nbr1 site site1 so_job so_job1 loc loc1 type
  with frame a .

  bcdparm = "".
  {mfquoter.i part         }
  {mfquoter.i part1        }
  {mfquoter.i effdate      }
  {mfquoter.i effdate1     }
  {mfquoter.i trdate       }
  {mfquoter.i trdate1      }
  {mfquoter.i nbr          }
  {mfquoter.i nbr1         }
  {mfquoter.i site         }
  {mfquoter.i site1        }
  {mfquoter.i so_job       }
  {mfquoter.i so_job1      }
  {mfquoter.i loc          }
  {mfquoter.i loc1         }
  {mfquoter.i type         }

 if part1    = ""   then part1    = hi_char  .
 if nbr1     = ""   then nbr1     = hi_char  .
 if site1    = ""   then site1    = hi_char  .
 if so_job1  = ""   then so_job1  = hi_char  .
 if loc1     = ""   then loc1     = hi_char  .
 if effdate  = ?    then effdate  = low_date .
 if effdate1 = ?    then effdate1 = hi_date  .
 if trdate   = ?    then trdate   = low_date .
 if trdate1  = ?    then trdate1  = hi_date  .

 {mfselbpr.i "printer" 320 }
 /*{mfphead.i}*/

for each tr_hist no-lock /*use-index tr_part_eff*/ where
     (tr_type = type or type = "") and
     tr_part >= part and tr_part <= part1 and
   tr_effdate >= effdate and tr_effdate <= effdate1
   and (tr_type <> "ORD-SO" or type = "ORD-SO")
     and (tr_type <> "ORD-PO" or type = "ORD-PO") and
     tr_nbr >= nbr and tr_nbr <= nbr1 and
     tr_site >= site and tr_site <= site1 and
     tr_so_job >= so_job and tr_so_job <= so_job1 and
     tr_loc >= loc and tr_loc <= loc1 and
     tr_date >= trdate and tr_date <= trdate1 ,
    each pt_mstr no-lock where pt_part = tr_part
   break by tr_part by tr_site by tr_ship_type:
      drg =  "".
      for each ipd_det no-lock where ipd_part = tr_part break by ipd_test:
           drg = drg + ipd_tol.
      end.
      if first-of(tr_part) then do :
      i = 1.
      end.
      else i = i + 1.
      qty = 0 . qty1 = 0 .
      qty = tr_qty_chg + tr_begin_qoh.
      qty1 = tr_qty_loc + tr_loc_begin.
      display
            i                  label "序號"
          tr_site            label "廠別"
          tr_part            label "料號"
          pt_desc1           label "說明"
          drg                label "規格"
          pt_draw            label "圖號"
          tr_um              label "單位"
          tr_date            label "操作日期"
          date(string(tr_effdate))   label "生效日期"           /*ss-20121119.1*/
          tr_trnbr           label "交易號碼"
          trim(tr_type)      label "交易類型"           /*ss-20121119.1*/
          tr_nbr             label "訂單"
          tr_addr            label "地址"
          tr_qty_req         label "需求量"
          tr_qty_loc         label "庫位變動數量"
          tr_so_job          label "銷售/工作"
          trim(tr_loc)       label "庫位"              /*ss-20121119.1*/
      tr_rmks            label "備註"       /*SS-20130306.1*/
          qty1               label "庫位結存"
      qty                label "總結存"
          tr_userid          label "使用者ID"
       with down frame aaa width 320.

    end.  /*for each tr_hist */

   {mfrtrail.i}
end.