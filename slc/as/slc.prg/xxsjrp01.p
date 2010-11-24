/* By: Neil Gao Date: 20070413 ECO: * ss 20070413.1 * */

{mfdtitle.i "1+ "}

/* ss 20070410.1 - b */
define new shared variable sntype 				 as char init "lcsnlz" .
define new shared variable snnbr					 as char format "x(11)".
define new shared variable snnbr1					 like snnbr.
define new shared variable rdate           like prh_rcp_date.
define new shared variable rdate1          like prh_rcp_date.
define new shared variable part            like pt_part.
define new shared variable part1           like pt_part.
define new shared variable site            like pt_site.
define new shared variable site1           like pt_site.
define new shared variable noprinter				as logical init yes.
define variable confirm-yn like mfc_logical init yes.
define variable oldname like pt_desc1.
define variable j as integer.
/* ss 20070410.1 - e */

form
   snnbr            colon 15 label "单据号"
   snnbr1           label "至" colon 49 skip
   rdate            colon 15
   rdate1           label "To" colon 49 skip
   part             colon 15
   part1            label "To" colon 49 skip
   site             colon 15
   site1            label "To" colon 49 skip(1)
   noprinter				colon 30   label "未打印单据" skip
with frame a side-labels width 80 attr-space.
{&POPORP06-P-TAG2}

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).


{wbrp01.i}
repeat:

   {&POPORP06-P-TAG3}
   if snnbr1 = hi_char then snnbr1 = "".
   if rdate = low_date then rdate = ?.
   if rdate1 = hi_date then rdate1 = ?.
   if part1 = hi_char then part1 = "".
   if site1 = hi_char then site1 = "".

   if c-application-mode <> 'web' then
   update
      {&POPORP06-P-TAG4}
      snnbr snnbr1 rdate rdate1 part part1 site site1 noprinter
   with frame a.

   {&POPORP06-P-TAG5}
   {wbrp06.i &command = update
      &fields = " snnbr snnbr1 rdate rdate1 part part1
        site site1 noprinter "
      &frm = "a"}


      {&POPORP06-P-TAG7}
      bcdparm = "".
      {mfquoter.i snnbr           }
      {mfquoter.i snnbr1          }
      {mfquoter.i rdate           }
      {mfquoter.i rdate1          }
      {mfquoter.i part            }
      {mfquoter.i part1           }
      {mfquoter.i site            }
      {mfquoter.i site1           }

      if rdate = ? then rdate = low_date.
      if rdate1 = ? then rdate1 = today.
      if snnbr1 = "" then snnbr1 = hi_char.
      if part1 = "" then part1 = hi_char.
      if site1 = "" then site1 = hi_char.
      

   {mfselprt.i "printer" 132}
   
FORM  HEADER
  "隆鑫工业有限公司四轮车本部" at 40 skip
	"散件转仓单" at 48 skip(1)
	"转仓原库区: SJ01" at 1 
	"制单日期:" at 38 today string(time,"hh:mm am")
	"单据号:" at 75 tr_vend_lot format "x(11)" skip
	"转仓现库区: BZ01" at 1
WITH STREAM-IO FRAME ph2 PAGE-TOP WIDTH 132 NO-BOX.

   for each tr_hist use-index tr_vend_lot where tr_domain = global_domain
                                            and tr_vend_lot >= snnbr and tr_vend_lot <= snnbr1
                                            and tr_effdate >= rdate and tr_effdate <= rdate1
                                            and tr_part >= part and tr_part <= part1
                                            and tr_site = "12000"
                                            and tr_loc = "BZ01"
                                            and tr_type = "rct-tr" no-lock,
       each pt_mstr where pt_domain = global_domain
                      and pt_part = tr_part no-lock
       break by tr_vend_lot by pt_loc by tr_part:
       	
       	{gprun.i ""xxaddoldname.p"" "(input tr_part,output oldname)"}
       	find first vd_mstr where vd_domain = global_domain and vd_addr = substring(tr_serial,7) no-lock no-error.
       	find first cd_det where cd_domain = global_domain and cd_ref = tr_part and cd_type = "SC" and cd_lang = "ch" no-lock no-error.
        
        
        view frame ph2.
              	
   			display
   				tr_part       column-label "物料编码"
   				pt_desc1      column-label "物料名称"
   				oldname       column-label "老机型"
   				pt_loc        column-label "库"
   				tr_serial     column-label "批序号"
   				vd_sort       column-label "供应商" format "x(10)"
   				tr_qty_chg    column-label "转仓数量"
   			with width 150.
   			oldname = "".
   				
   				put "描述:" at 1.
					do j = 1 to 15 : 
				        	if (avail cd_det and cd_cmmt[j] <> "") then put cd_cmmt[j] skip.
				        	else 
				        	do:
				        		  if (not avail cd_det and avail pt_mstr) then
				        		  do:
						        			put pt_mstr.pt_desc2 skip.
						        			leave.
				        		  end.
				          end.
				  end.
   				
   				if last-of(tr_vend_lot) or last-of(pt_loc) then
   					do:
   						put "-----------------------------------------------------------------------------------------------" skip.
   						put "转仓人:                             搬运人:                                        接收人:" skip.
   						page.
   					end.
   							
   end. /*for each tr_hist*/

 	 {mfreset.i}
	 {mfgrptrm.i}

   {pxmsg.i &MSGNUM=9 &ERRORLEVEL=1}
end.

/*V8-*/
{wbrp04.i &frame-spec = a}
/*V8+*/
