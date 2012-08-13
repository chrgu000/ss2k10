{mfdtitle.i "d+ "}
DEFINE VAR part1 LIKE pt_part.
DEFINE VAR part2 LIKE pt_part.
DEFINE VAR date1 LIKE dsd_per_date INITIAL 01/01/09.
DEFINE VAR date2 LIKE dsd_per_date INITIAL 12/31/09.
DEFINE VAR shipfrmsite1 LIKE pt_site.
DEFINE VAR shipfrmsite2 LIKE pt_site.
DEFINE VAR shiptosite1 LIKE pt_site.
DEFINE VAR shiptosite2 LIKE pt_site.
DEFINE VAR showyn AS LOGICAL INITIAL NO.

FORM
    part1        LABEL "零件号" COLON 20 part2        LABEL "To" COLON 55
    date1        LABEL "需求日期" COLON 20  date2     LABEL "To" COLON 55
    shipfrmsite1 LABEL "发运地" COLON 20 shipfrmsite2 LABEL "To" COLON 55
    shiptosite1  LABEL "发送到" COLON 20 shiptosite2  LABEL "To" COLON 55
    showyn  LABEL "只显示短缺量"  COLON 20

    WITH FRAME  a SIDE-LABELS WIDTH 80 ATTR-SPACE NO-BOX THREE-D.


REPEAT:
    UPDATE part1 part2 date1 date2 shipfrmsite1 shipfrmsite2 shiptosite1 shiptosite2  showyn WITH FRAME a.
    {mfselprt.i "printer" 132}
    IF part1 = hi_char THEN part1 = "".
    IF part2 = "" THEN part2 = hi_char.
    IF date1 = hi_date THEN date1 = low_date.
    IF date2 = low_date THEN date2 = hi_date.
    IF shipfrmsite1 = hi_char THEN shipfrmsite1 = "".
    IF shipfrmsite2 = "" THEN shipfrmsite2 = hi_char.
    IF shiptosite1 = hi_char  THEN shiptosite1 = "".
    IF shiptosite2 = "" THEN shiptosite2 = hi_char.

IF showyn = NO THEN DO:
 FOR EACH dsd_det WHERE dsd_part >=part1 AND dsd_part <= part2 AND dsd_per_date >= date1 AND dsd_per_date <= date2 
     AND dsd_site >= shiptosite1 AND dsd_site <=shiptosite2 AND dsd_shipsite >=shipfrmsite1 AND  dsd_shipsite <=shipfrmsite2.
    FIND LAST pod_det WHERE pod_site = dsd_shipsite AND pod_part = dsd_part AND (pod_due_date= ? OR pod_due_date > TODAY) AND pod_status <> "C"  NO-LOCK NO-ERROR.
    IF AVAILABLE pod_det THEN
    DISP dsd_nbr dsd_req dsd_site dsd_shipsite dsd_shipdate dsd_due_date dsd_per_date 
         dsd_part dsd_qty_con dsd_qty_rcvd dsd_qty_ship dsd_transit dsd_qty_con - dsd_qty_ship LABEL "短缺量"  pod_nbr pod_line WITH WIDTH 200 STREAM-IO.
    ELSE 
         DISP dsd_nbr dsd_req dsd_site dsd_shipsite dsd_shipdate dsd_due_date dsd_per_date 
         dsd_part dsd_qty_con dsd_qty_rcvd dsd_qty_ship dsd_transit dsd_qty_con - dsd_qty_ship LABEL "短缺量"  WITH WIDTH 200 STREAM-IO.
 END.
END.
IF showyn = YES THEN DO:
 FOR EACH dsd_det WHERE dsd_part >=part1 AND dsd_part <= part2 AND dsd_per_date >= date1 AND dsd_per_date <= date2 
     AND dsd_site >= shiptosite1 AND dsd_site <=shiptosite2 AND dsd_shipsite >=shipfrmsite1 AND  dsd_shipsite <=shipfrmsite2.
    FIND LAST pod_det WHERE pod_site = dsd_shipsite AND pod_part = dsd_part AND (pod_due_date= ? OR pod_due_date > TODAY) AND pod_status <> "C"  NO-LOCK NO-ERROR.
    IF AVAILABLE pod_det AND dsd_qty_con - dsd_qty_ship >0 THEN
    DISP dsd_nbr dsd_req dsd_site dsd_shipsite dsd_shipdate dsd_due_date dsd_per_date 
         dsd_part dsd_qty_con dsd_qty_rcvd dsd_qty_ship dsd_transit dsd_qty_con - dsd_qty_ship LABEL "短缺量"  pod_nbr pod_line WITH WIDTH 200 STREAM-IO.
    ELSE IF dsd_qty_con - dsd_qty_ship >0 THEN
         DISP dsd_nbr dsd_req dsd_site dsd_shipsite dsd_shipdate dsd_due_date dsd_per_date 
         dsd_part dsd_qty_con dsd_qty_rcvd dsd_qty_ship dsd_transit dsd_qty_con - dsd_qty_ship LABEL "短缺量"  WITH WIDTH 200 STREAM-IO.
 END.
END.


{mfreset.i}
{mfgrptrm.i} /*Report-to-Window*/

END.

