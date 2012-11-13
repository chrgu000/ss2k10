/* SS - 110801.1 By: Kaine Zhang */

{mfdtitle.i "120704.1"}

{xxbireportvariable.i}
{xxbireportdefault.i}

{xxldrp30var.i}
{xxldrp30form.i}


{wbrp01.i}
repeat on endkey undo, leave:
    {xxldrp30input.i}


    /* output destination selection */
    {gpselout.i
        &printtype = "printer"
        &printwidth = 132
        &pagedflag = "nopage"
        &stream = " "
        &appendtofile = " "
        &streamedoutputtoterminal = " "
        &withbatchoption = "yes"
        &displaystatementtype = 1
        &withcancelmessPartAge = "yes"
        &pagebottommargin = 6
        &withemail = "yes"
        &withwinprint = "yes"
        &definevariables = "yes"
    }
    
    {xxbireporthead.i sBiPath sBiName}
    
    {xxldrp30view.i}

    {xxmfreset.i}
	{mfgrptrm.i}
end.
{wbrp04.i &frame-spec = a}





