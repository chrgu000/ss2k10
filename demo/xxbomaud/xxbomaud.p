/* SS - 110105.1 By: Kaine Zhang */

{mfdtitle.i "110105.1"}

{xxpartbomfunc.i}
{xxgetbomlisttable.i "new shared"}

define variable sBom like ps_par no-undo.
define variable dteEffect as date initial today no-undo.
define variable sStatusA like pt_status no-undo.
define variable sStatusB like pt_status no-undo.
define variable bConfirm as logical no-undo.

form
    sBom        colon 15    label "Bom"
    dteEffect   colon 15    label "Effect Date"
    sStatusA    colon 15    label "Status"
    sStatusB    colon 15    label "To"
with frame a side-labels width 80.
setframelabels(frame a:handle).

assign sBom = global_part.

display
    sBom
    dteEffect
with frame a.



/* SS - 110105.1 - B
{wbrp01.i}
SS - 110105.1 - E */
repeat:
    update
        sBom
        dteEffect
    with frame a.

    find first pt_mstr
        no-lock
        where pt_domain = global_domain
            and pt_part = sBom
        no-error.
    if not(available(pt_mstr)) then do:
        {pxmsg.i &msgnum = 16}
        undo, retry.
    end.
    if not(canAccessBom(sBom)) then do:
        {pxmsg.i &msgnum = 90000}
        undo, retry.
    end.

    sStatusA = pt_status.
    display
        sStatusA
    with frame a.

    do on error undo, leave:
        update
            sStatusB
        with frame a.
        if sStatusB = sStatusA then do:
            {pxmsg.i &msgnum = 90001}
            undo, retry.
        end.
        if not(canAccessBom(sBom)) then do:
            {pxmsg.i &msgnum = 90000}
            undo, retry.
        end.
        /* todo check sStatus */
        find first qad_wkfl  
            no-lock
            where qad_domain = global_domain 
                and qad_key1 = "pt_status" 
                and qad_key2 = sStatusB
            no-error.
        if not available qad_wkfl then do:
            {pxmsg.i &msgnum = 19}
            undo, retry.
        end.

    end.

    /* SS - 110105.1 - B
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
    SS - 110105.1 - E */
    
    {gprun.i
        ""xxgetbomlist.p""
        "(
            input sBom,
            input sBom,
            input 0,
            input 0,
            input dteEffect,
            input 0
        )"
    }

    /* SS - 110105.1 - B
    for each t_bomlist_tmp with down frame b:
        display
            t_bomlist_par
            t_bomlist_comp
            .
        down.
    end.

    {mfreset.i}
	{mfgrptrm.i}
	SS - 110105.1 - E */
    
    bConfirm = no.
    {pxmsg.i &msgnum = 12 &confirm = bConfirm}
    if bConfirm then do:
        find first pt_mstr
            where pt_domain = global_domain
                and pt_part = sBom
            no-error.
        if available(pt_mstr) then pt_status = sStatusB.


        for each t_bomlist_tmp:
            find first pt_mstr
                where pt_domain = global_domain
                    and pt_part = t_bomlist_comp
                no-error.
            if available(pt_mstr) then pt_status = sStatusB.
        end.

    end.
end.
/* SS - 110105.1 - B
{wbrp04.i &frame-spec = a}
SS - 110105.1 - E */


