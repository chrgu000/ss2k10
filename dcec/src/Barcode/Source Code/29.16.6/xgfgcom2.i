listblock:
do on error undo, leave:

    find first ttfg
    exclusive-lock 
    where recid(ttfg) = w-rid[Frame-line(f)]
    no-error.
    
    ttfg_flag = not ttfg_flag.
    disp ttfg_flag.
end.
