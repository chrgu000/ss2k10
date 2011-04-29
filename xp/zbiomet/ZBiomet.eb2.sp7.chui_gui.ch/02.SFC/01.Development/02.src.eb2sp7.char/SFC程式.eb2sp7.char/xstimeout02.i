


if wtimeout = 99999 then do:
    readkey .
end.
else do:
    readkey pause  wtimeout  .  /*if lastkey = -1 then {1} . */ 
    if lastkey = -1 then do:
            hide message no-pause.
            undo,retry.  
    end. 
end.
