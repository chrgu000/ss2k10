/* xxbcldrp10.p ---- */
/* Copyright 2011 SoftSpeed gz                                                         */
/* All rights reserved worldwide.  This is an unpublished work.                        */
/* SS - 110322.1 By: Kaine Zhang */


{mfdtitle.i "110322.1"}

define variable sWoNbrA like wo_nbr no-undo.
define variable sWoNbrB like wo_nbr no-undo.
define variable sWoLotA like wo_lot no-undo.
define variable sWoLotB like wo_lot no-undo.
define variable sQadType as character extent 4 no-undo.

assign
    sQadType[1] = "RCT-WO"
    sQadType[2] = "ISS-TR"
    sQadType[3] = "RCT-TR"
    sQadType[4] = "ISS-SO"
    .

    
form
    sWoNbrA colon 15
    sWoNbrB colon 45    label "жа"
    sWoLotA colon 15
    sWoLotB colon 45    label "жа"
    skip
with frame a side-labels width 80.
setframelabels(frame a:handle).

form
with frame b width 320.
setframelabels(frame b:handle).






view frame a.

{wbrp01.i}
repeat on endkey undo, leave:
    if sWoNbrB = hi_char then sWoNbrB = "".
    if sWoLotB = hi_char then sWoLotB = "".
    
    if c-application-mode <> 'web' then
        update
            sWoNbrA 
            sWoNbrB 
            sWoLotA
            sWoLotB
        with frame a.

    {wbrp06.i
        &command = update
        &fields = "
            sWoNbrA 
            sWoNbrB 
            sWoLotA
            sWoLotB
            "
        &frm = "a"
    }



    if (c-application-mode <> 'web')
        or (c-application-mode = 'web' and (c-web-request begins 'data'))
    then do:
        bcdparm = "".
        {mfquoter.i sWoNbrA   }
        {mfquoter.i sWoNbrB   }
        {mfquoter.i sWoLotA  }
        {mfquoter.i sWoLotB  }

        if sWoNbrB = "" then sWoNbrB = hi_char.
        if sWoLotB = "" then sWoLotB = hi_char.
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


    for each wo_mstr
        no-lock
        where wo_nbr >= sWoNbrA
            and wo_nbr <= sWoNbrB
            and wo_lot >= sWoLotA
            and wo_lot <= sWoLotB
        use-index wo_nbr
    :
        for each xbcass_det
            no-lock
            where xbcass_type = sQadType[1]
                and xbcass_order = wo_lot
                and xbcass_line = 0
        :
            display
                xbcass_part         
                xbcass_lot          
                xbcass_is_assembled 
                xbcass_order        
                xbcass_date         
                string(xbcass_time, "HH:MM:SS")
            with frame b.
            down with frame b.
        end.
        
        
    end.

    {mfreset.i}
	{mfgrptrm.i}
end.
{wbrp04.i &frame-spec = a}





