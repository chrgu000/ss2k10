/* xgsrtrp.p 完工产品序列报表                                               */
/* Copy From xwsrtrp.p  2005.12.28                                          */

{mfdtitle.i "f "} 

define variable Lnr   like xwo_lnr .
define variable site like pt_site .
define variable site1 like pt_site.
define variable part like pt_part .
define variable part1 like pt_part .
define variable xwseq like xwo_serial.
define variable xwseq1 like xwo_serial.
define variable xdate  like xwo_date  initial today.
define variable xdate1  as date  initial today.
define variable xwrkdate as date label "上线日期".
define variable xwrkdate1 as date .
define variable xduedate as date label "下线日期".
define variable xduedate1 as date .
define variable wolot like wo_lot label "加工单ID".
define variable wolot1 like wo_lot.

define variable ptdesc as character format "x(40)" column-label "零件描述".
define variable  xTotQty  like wo_qty_ord.

        
         /* SELECT FORM */
         form
            lnr         colon 15
            xdate       colon 15
            xdate1      colon 49 label {t001.i}
            xwrkdate    colon 15 
            xwrkdate1   colon 49 label {t001.i}
            xduedate    colon 15 
            xduedate1   colon 49 label {t001.i}
            xwseq       colon 15
            xwseq1      colon 49 label {t001.i}
            site        colon 15
            site1       colon 49 label {t001.i}
            part        colon 15
            part1       colon 49 label {t001.i}
            wolot       colon 15
            wolot1      colon 49 label {t001.i}
            skip(1)
            
         with frame a side-labels width 80 attr-space.
        setFrameLabels(frame a:handle).

         mainloop: repeat:
                if site1 = hi_char then site1 = "".
                if part1 = hi_char then part1 = "".
                if wolot1 = hi_char then wolot1 = "".
                if xdate = low_date then xdate = ?.
                if xdate1 = hi_date then xdate1 = ?.
                if xwrkdate = low_date then xwrkdate = ?.
                if xwrkdate1 = hi_date then xwrkdate1 = ?.
                if xduedate = low_date then xduedate = ?.
                if xduedate1 = hi_date then xduedate1 = ?.
           xTotQty = 0.
            update  lnr
                    xdate xdate1 
                    xwrkdate xwrkdate1
                    xduedate xduedate1
                    xwseq xwseq1 
                    site site1 
                    part part1 
                    wolot wolot1 
                        with frame a.

                    bcdparm = "".
                    {mfquoter.i site         }
                    {mfquoter.i site1        }
                    {mfquoter.i part        }
                    {mfquoter.i part1       }
                    {mfquoter.i wolot        }
                    {mfquoter.i wolot1       }
                    {mfquoter.i xdate        }
                    {mfquoter.i xdate1       }
                    {mfquoter.i xwrkdate        }
                    {mfquoter.i xwrkdate1       }
                    {mfquoter.i xduedate        }
                    {mfquoter.i xduedate1       }

                if site1 = "" then site1 = hi_char.
                if part1 = "" then part1 = hi_char .
                if wolot1 = "" then wolot1 = hi_char .
                if xwseq1 = "" then xwseq1 = hi_char.
                if xdate = ? then xdate = low_date.
                if xdate1 = ? then xdate1 = hi_date.
                if xwrkdate = ? then xwrkdate = low_date.
                if xwrkdate1 = ? then xwrkdate1 = hi_date.
                if xduedate = ? then xduedate = low_date.
                if xduedate1 = ? then xduedate1 = hi_date.
        
/*          {mfmsg.i 3039 2} */

            /* PRINTER SELECTION */
            {mfselbpr.i "printer" 132}
            {mfphead.i}
        
           for each xwo_srt
               where xwo_lnr = lnr
               and xwo_site >= site and xwo_site <= site1
               and xwo_part >= part and xwo_part <= part1
               and xwo_lot >= wolot and xwo_lot <= wolot1
               and xwo_date >= xdate and xwo_date <= xdate1
               and xwo_serial >= xwseq and xwo_serial <= xwseq1
               and ((xwo_wrk_date >= xwrkdate and xwo_wrk_date <= xwrkdate1) or xwo_wrk_date = ?)
               and ((xwo_due_date >= xduedate and xwo_due_date <= xduedate1) or xwo_due_date = ?)
               no-lock with frame e width 360 stream-io.
               
               xTotQty = xTotQty + 1.

            FIND pt_mstr where pt_part = xwo_part no-lock no-error.
            ptdesc = if available pt_mstr then pt_desc1 + pt_desc2 else "".
        
            FIND wo_mstr where wo_lot = xwo_lot no-lock no-error.
        
            display xwo_date column-label "FIS日期"
                    string(xwo_time,"HH:MM:SS") column-label "FIS时间" 
                    xwo_serial xwo_part ptdesc format "x(40)"
                    xwo_wrk_date column-label "上线日期"
                    string(xwo_wrk_time,"HH:MM:SS") column-label "上线时间"
                    xwo_due_date string(xwo_due_time,"HH:MM:SS") column-label "下线时间"
                    xwo_lot column-label "加工单ID"
                    wo_qty_ord column-label "汇报量" when available wo_mstr
                    xwo_blkflh column-label "扣料"
            with frame e .
            
           end.
        
        put skip(1).
        put "类型: 1 自FIS; 2 手工插单(正常); 3 手工插单(紧急); 4 补FIS配置项; 5 按VX被FIS" format "x(100)" skip(1).
        put "==================================" at 50 skip.
        put "Total Qty:" at 50 xTotQty               skip.
        put "==================================" at 50 skip(1).
        

         /* REPORT TRAILER  */
            
/*          {mfrtrail.i} */

            {mfreset.i}


         end.   
