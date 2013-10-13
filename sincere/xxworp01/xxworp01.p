/* xxworp01.p 车间退料分析统计报表                                            */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.13 $                                                          */
/*V8:ConvertMode=FullGUIReport                                                */
/* $Revision: eB2.1 SP6  BY: Apple Tam DATE: 07/02/10  ECO: *SS-2010702.1*    */
/* $Revision: eB2.1 SP6  BY: Apple Tam DATE: 09/01/10  ECO: *SS-2010901.1*    */
/* $Revision: eB2.1 SP6  BY: Apple Tam DATE: 11/10/10  ECO: *SS-2011110.1*    */

/*-Revision end---------------------------------------------------------------*/

/* DISPLAY TITLE */
{mfdtitle.i "130917.1 "}


DEFINE VAR v_file AS CHAR .
define variable site          like tr_site no-undo.
define variable site1          like tr_site no-undo.
define variable loc          like tr_loc no-undo.
define variable loc1          like tr_loc no-undo.
define variable wkctr          like wc_wkctr no-undo.
define variable wkctr1          like wc_wkctr no-undo.
define variable nbr          like wo_nbr no-undo.
define variable nbr1          like wo_nbr no-undo.
define variable part          like wod_part no-undo.
define variable part1          like wod_part no-undo.
define variable rsn          like xxrt_rsn no-undo.
define variable rsn1          like xxrt_rsn no-undo.
define variable effdate          like tr_effdate no-undo.
define variable effdate1          like tr_effdate no-undo.
define variable desc1          like pt_desc1 no-undo.
define variable desc2          like pt_desc1 no-undo.
define variable qty_oh          like ld_qty_oh no-undo.
define variable cmmt as char.
define variable i as integer.



/*===form definition===============================================*/

/* DISPLAY SELECTION FORM */
form
   site      colon 25
   site1     label "To" colon 50
   loc       colon 25
   loc1      label "To" colon 50
   wkctr     colon 25
   wkctr1    label "To" colon 50
   nbr       colon 25
   nbr1      label "To" colon 50
   part      colon 25
   part1     label "To" colon 50
   rsn       colon 25
   rsn1      label "To" colon 50
   effdate   colon 25
   effdate1  label "To" colon 50
   skip(1)
with frame a width 80 side-labels no-attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).



/*===Begin================================================*/
{wbrp01.i}

mainloop:
repeat:

   if site1     = hi_char then site1     = "".
   if loc1     = hi_char then loc1     = "".
   if wkctr1     = hi_char then wkctr1     = "".
   if nbr1     = hi_char then nbr1     = "".
   if part1     = hi_char then part1     = "".
   if rsn1     = hi_char then rsn1     = "".
   if effdate = low_date then effdate = ?.
   if effdate1 = hi_date then effdate1 = ?.

   if c-application-mode <> 'web' then
      update
        site
  site1
  loc
  loc1
  wkctr
  wkctr1
  nbr
  nbr1
  part
  part1
  rsn
  rsn1
  effdate
  effdate1
      with frame a.

   {wbrp06.i &command = update &fields = "  site site1 loc loc1 wkctr wkctr1
     nbr nbr1 part part1 rsn rsn1 effdate effdate1" &frm = "a"}

   if (c-application-mode <> 'web') or
      (c-application-mode = 'web' and
      (c-web-request begins 'data')) then do:

      bcdparm = "".
      {mfquoter.i site      }
      {mfquoter.i site1     }
      {mfquoter.i loc       }
      {mfquoter.i loc1      }
      {mfquoter.i wkctr     }
      {mfquoter.i wkctr1    }
      {mfquoter.i nbr       }
      {mfquoter.i nbr1      }
      {mfquoter.i part      }
      {mfquoter.i part1     }
      {mfquoter.i rsn       }
      {mfquoter.i rsn1      }
      {mfquoter.i effdate   }
      {mfquoter.i effdate1  }

      if site1     = "" then site1     = hi_char.
      if loc1     = "" then loc1     = hi_char.
      if wkctr1     = "" then wkctr1     = hi_char.
      if nbr1     = "" then nbr1     = hi_char.
      if part1     = "" then part1     = hi_char.
      if rsn1     = "" then rsn1     = hi_char.
      if effdate = ? then effdate = low_date.
      if effdate1 = ? then effdate1 = hi_date.

   end.


   /* OUTPUT DESTINATION SELECTION */
   {gpselout.i &printType = "printer"
               &printWidth = 320
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
   {mfphead.i }

/*SS-2011110.1

 v_file =  "xxwo" + GLOBAL_userid + STRING(MONTH(TODAY),"99") + STRING(DAY(TODAY),"99") +  STRING(TIME) + string(random(1,999),"999") + ".csv" .
      OUTPUT TO value(v_file) .
       EXPORT DELIMITER "," "物料编码"  "物料描述"  "单位" "地点"  "生产线体"
                       "退料库位"  "退料单号" "加工单号"  "ID"  "已领数"
             "已退料数量" "原因描述"  "日期"  .
SS-2011110.1*/

   for each xxrt_det where xxrt_domain = global_domain
                       and xxrt_site_to >= site
           and xxrt_site_to <= site1
           and xxrt_loc_to >= loc
           and xxrt_loc_to <= loc1
           and xxrt_wkctr >= wkctr
           and xxrt_wkctr <= wkctr1
           and xxrt_wonbr >= nbr
           and xxrt_wonbr <= nbr1
           and xxrt_wodpart >= part
           and xxrt_wodpart <= part1
           and xxrt_rsn >= rsn
           and xxrt_rsn <= rsn1
           /*and (effdate = ? or xxrt_eff_date >= effdate)
           and (effdate1 = ? or xxrt_eff_date <= effdate1)*/
           and ((xxrt_eff_date >= effdate  and
                 xxrt_eff_date <= effdate1)
           or  effdate  = low_date
           and xxrt_eff_date = ?
           or  effdate = hi_date
           and xxrt_eff_date = ?)
/* ss - 20100901.1 - b*
           and xxrt_method = "1"
* ss - 20100901.1 - e*/
           and xxrt_flag = yes
           no-lock
           break by xxrt_wodpart by xxrt_rsn
           with frame bb width 320 no-attr-space no-box:
      {mfrpchk.i}

         find first pt_mstr where pt_domain = global_domain
                        and pt_part = xxrt_wodpart
            no-lock no-error.
        desc1 = "".
        if available pt_mstr then do:
           desc1 = pt_desc1 + pt_desc2.
        end.


       display xxrt_wodpart   label "物料编码"
               desc1          label "物料描述"
               xxrt_um        label "单位"
               xxrt_site_to   label "地点"
               xxrt_wkctr     label "生产线体"
               xxrt_loc_to    label "退料库位"
               xxrt_nbr       label "退料单号"
               xxrt_wonbr     label "加工单号"
               xxrt_wolot     label "ID"
               xxrt_relqty    label "已领数"
               xxrt_qty_from  label "已退料数量"
               xxrt_rsn       label "原因描述"
               xxrt_remark    label "原因备注" format "x(60)"
               xxrt_eff_date  label "日期"
               .


   end.  /* FOR EACH */

/*output close.*/

   /* REPORT TRAILER */

   {mfrtrail.i}

end.  /* mainloop */

{wbrp04.i &frame-spec = a}
