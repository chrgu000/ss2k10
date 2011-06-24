/* SS - 090904.1 By: Kaine Zhang */

assign
    i = 0
    sBarcode = "".
for each xcard_det
    no-lock
    where xcard_vin = xcar_vin
        and xcard_status = ""
    use-index xcard_vin_seat
:
    i = i + 1.
    sBarcode[i] = xcard_seat.
    if i = 8 then leave.
end.

display
    sBarcode
with frame a.

