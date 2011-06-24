/* SS - 100512.1 By: Kaine Zhang */

{mfdeclre.i}

define input parameter sBarcode as character.
define output parameter sWoPart as character.
define output parameter sLot as character.

&scoped-define SEATPREFIX "003"
&scoped-define SEATDELIMITER "-"
&scoped-define SEATSUFFIX "+"
&scoped-define COMMONDELIMITER "$"


if sBarcode begins {&SEATPREFIX} 
    and index(sBarcode, {&SEATDELIMITER}) > 0
    and r-index(sBarcode, {&SEATSUFFIX}) = length(sBarcode)
then do:
/* 输入的是成品(座椅)条码 */
    assign
        sWoPart = substring(entry(1, sBarcode, {&SEATDELIMITER}), length({&SEATPREFIX}) + 1)
        sLot = replace(entry(2, sBarcode, {&SEATDELIMITER}), {&SEATSUFFIX}, "")
        .
end.
else if index(sBarcode, {&COMMONDELIMITER}) > 0 then do:
/* 输入的是非成品的条码 */
    assign
        sWoPart = entry(1, sBarcode, {&COMMONDELIMITER})
        sLot = entry(2, sBarcode, {&COMMONDELIMITER})
        .
end.
else do:
/* 输入的不是条码.那么我们视它为批号 */
    assign
        sWoPart = ""
        sLot = sBarcode
        .
end.


