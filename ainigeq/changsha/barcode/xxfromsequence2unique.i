/* SS - 100322.1 By: Kaine Zhang */

do while true on error undo, retry:
    assign {2} = next-value({1}) no-error.
    
    if error-status:error then next.
    else leave.
end.
