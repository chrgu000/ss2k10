/* SS - 100524.1 By: Kaine Zhang */

/* 测试,windows打印机方式打印标签是否可行 */

{mfdtitle.i "100524.1"}

def var s as char no-undo.
def var s1 as char no-undo.
def var i as int.

s = "/home/mfg/kof/tmp/test.txt".

form
    s colon 15 label "文件" format "x(50)"
    skip
with frame a side-labels width 80.
setframelabels(frame a:handle).





{wbrp01.i}
repeat on endkey undo, leave:
    if c-application-mode <> 'web' then
        update
            s
        with frame a .

    {wbrp06.i
        &command = update
        &fields = "
            s
            "
        &frm = "a"
    }



    if (c-application-mode <> 'web')
        or (c-application-mode = 'web' and (c-web-request begins 'data'))
    then do:
        bcdparm = "".
        {mfquoter.i s    }
    end.

    /* output destination selection */
    {gpselout.i
        &printtype = "printer"
        &printwidth = 132
        &pagedflag = " "
        &stream = " "
        &appendtofile = " "
        &streamedoutputtoterminal = " "
        &withbatchoption = "yes"
        &displaystatementtype = 1
        &withcancelmessAge = "yes"
        &pagebottommargin = 6
        &withemail = "yes"
        &withwinprint = "yes"
        &definevariables = "yes"
    }


    input from value(s).

    repeat:
        import unformatted s1.
        i = i + 1.
        put 
            unformatted 
            i at 1
            "++"
            s1
            .
    end.
    input close.



    {mfreset.i}
	{mfgrptrm.i}
end.
{wbrp04.i &frame-spec = a}






