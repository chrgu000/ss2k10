{mfdtitle.i}

    batchrun = yes.
    input from value("c:\bkflh.txt").
    output to value("c:\bkflh" + ".out") keep-messages.
       
    hide message no-pause.
       
    {gprun.i ""rebkfl.p""}
       
    hide message no-pause.
      
    output close.
    input close.
    batchrun = no.
