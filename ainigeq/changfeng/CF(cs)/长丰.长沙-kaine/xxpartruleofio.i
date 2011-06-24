/* SS - 091112.1 By: Kaine Zhang */

if sPartFromSerial = "IO" then do:
    if sPartFromColor = "B" then sPartFromColor = "G".
    else if sPartFromColor = "G" then sPartFromColor = "B".
end.
