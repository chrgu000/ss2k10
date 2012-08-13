define variable date1 like prh_rcp_date no-undo.
define variable date2 like prh_rcp_date no-undo.
define variable po_nbr like po_nbr format "x(8)" no-undo.
define variable po_nbr1 like po_nbr format "x(8)" no-undo.

repeat:

{/eb2/eb2sp12/xrc/mfdtitle.i}
{cxcustom.i "ICTRRP01.P"}
{wbrp01.i}

 date1 = today.
 date2 = today.
 po_nbr= " ".
 po_nbr1= "ZZZZZZZZ ".

 update date1 label "收货时间" colon 22 skip with width 80 side-labels frame a.
 update date2 label "收货时间" colon 22 skip with width 80 side-labels frame a.
update po_nbr label "采购单" colon 22 skip with width 80 side-labels frame a.
 update po_nbr1 label "采购单" colon 22 skip with width 80 side-labels frame a.

{gpselout.i &printType = "printer"
 &printWidth = 132
 &pagedFlag = " "
 &stream = " "                                                              
   ~
  &appendToFile =" "
 &streamedOutputToTerminal = " "
 &withBatchOption = "yes"                                                   
   ~
  &displayStatementType = 1
 &withCancelMessage = "yes"
 &pageBottomMargin = 6
 &withEmail = "yes"                                                         
   ~
  &withWinprint = "yes"                                                     
   ~
   &defineVariables =  "yes"}

 for each prh_ where prh_nbr >= po_nbr and prh_nbr <= po_nbr1 and prh_rcp_date
>= date1 and  prh_rcp_date <= date2.
disp prh_nbr prh_line prh_part prh_receiver prh_rcvd prh_rcp_date .
end.
{mfrpchk.i}
{&ICTRRP02-P-TAG15}
{mfrtrail.i}
end.
 {wbrp04.i &frame-spec = a}
