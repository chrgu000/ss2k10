/* SS - 110801.1 By: Kaine Zhang */

{mfdtitle.i "110801.1"}

{xxbireportvariable.i}
{xxbireportdefault.i}

{xxwooprp70var.i}
{xxwooprp70form.i}


{wbrp01.i}
repeat on endkey undo, leave:
    {xxwooprp70input.i}


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

    {xxwooprp70getdata.i}

    {xxbireporthead.i sBiPath sBiName}

    {xxwooprp70view.i}

    {xxmfreset.i}
	{mfgrptrm.i}
end.
{wbrp04.i &frame-spec = a}





