/* xswor020030.i -- */
/* Copyright 200908 Softspeed Inc., Guangzhou, China                     */
/* All rights reserved worldwide.  This is an unpublished work.          */
/* Revision: Version.ui    Modified: 07/01/2009   By: Kaine Zhang     Eco: *ss_20090701* */

/* 物料.批号 */
lp0030:
repeat on endkey undo, retry:
    hide all.
    {xsvarform0030.i}


    assign
        s0030_1 = "物料-批号?"
        s0030_6 = sPromptMessage
        .

    display
        sTitle
        s0030_1
        s0030_2
        s0030_3
        s0030_4
        s0030_5
        s0030_6
    with frame f0030. 
/*Y16s*   clear temp record                                                  */
/*Y16s*/  for each qad_wkfl where qad_key1 = "xswor20.p"                        
/*Y16s*/       and qad_datefld[1] = today - 1:                                  
/*Y16s*/      delete qad_wkfl.                                                  
/*Y16s*/  end.                                                                  
    if not(retry) then s0030 = "".

    update
        s0030
    with frame f0030
    editing:
        {xsreadkey.i}
        if lastkey = keycode("F10")
            or keyfunction(lastkey) = "cursor-down"
        then do:
            if recid(pt_mstr) = ? then
                find first pt_mstr
                    where pt_part >= input s0030
                    use-index pt_part
                    no-lock
                    no-error.
            else
                find next pt_mstr
                    where pt_part >= input s0030
                    use-index pt_part
                    no-lock
                    no-error.
            if available(pt_mstr) then
                display skip
                    pt_part @ s0030
                    pt_desc1 @ sMessage
                with frame f0030.
            else
                display
                    "" @ sMessage
                with frame f0030.
        end.
        else if lastkey = keycode("F9")
            or keyfunction(lastkey) = "cursor-up"
        then do:
            if recid(pt_mstr) = ? then
                find first pt_mstr
                    where pt_part <= input s0030
                    use-index pt_part
                    no-lock
                    no-error.
            else
                find next pt_mstr
                    where pt_part <= input s0030
                    use-index pt_part
                    no-lock
                    no-error.
            if available(pt_mstr) then
                display skip
                    pt_part @ s0030
                    pt_desc1 @ sMessage
                with frame f0030.
            else
                display
                    "" @ sMessage
                with frame f0030.
        end.
        else do:
            apply lastkey.
        end.
    end.
/*Y16S*  if can-find qad_wkfl then prompt repeat else record it in qad_wkfl  */
/*Y16s*/  find first qad_wkfl where qad_key1 = "xswor20.p"
/*Y16s*/         and qad_key3 = s0020 + s0030
/*Y16s*/         and qad_datefld[1] = today
/*Y16s*/         and qad_intfld[1] >= time - 14400 no-lock no-error.
/*Y16s*/  if available qad_wkfl then do:
/*Y16s*/         display "物料-批号重复,请确认" @ sMessage
/*Y16s*/         with frame f0030.
/*Y16s*/         undo detlp, leave detlp.
/*Y16s*/  end.
/*Y16s*/  else do:
/*Y16s*/       create qad_wkfl.
/*Y16s*/       assign qad_key1 = "xswor20.p"
/*Y16s*/              qad_key2 = s0020 + s0030 + string(today) + string(time)
/*Y16s*/              qad_key3 = s0020 + s0030
/*Y16s*/							qad_key4 = s0020 + s0030 + string(today) + string(time)
/*Y16s*/              qad_charfld[1] = wo_nbr
/*Y16s*/              qad_charfld[2] = wo_part
/*Y16s*/							qad_charfld[3] = s0020
/*Y16s*/							qad_charfld[4] = s0030
/*Y16s*/              qad_datefld[1] = today
/*Y16s*/              qad_intfld[1] = time.
/*Y16s*/  end.

    if s0030 = sExitFlag then do:
        undo detlp, leave detlp.
    end.
    else do:
        {xsgetpartlot.i
            s0030
            sPart
            sLot
            sMessage
            f0030
            "lp0030"
            sVendor
        }

        {xsvalidbcldover0.i
            s0010
            sCscfLoc
            sPart
            sLot
            sMessage
            f0030
            "lp0030"
        }

        if sPart <> wo_part
            and not(can-find(first ps_mstr no-lock
                where ps_par = wo_part
                    and ps_comp = sPart
                    and ps_ps_code = "X"
                    and (ps_start <= wo_rel_date or ps_start = ?)
                    and (ps_end >= wo_rel_date or ps_end = ?)
                use-index ps_parcomp
                )
            )
        then do:
            display
                "扫描座椅与工单座椅(独立/配套)不符" @ sMessage
            with frame f0030.
            undo, retry.
        end.

        s0030 = sPart.
    end.

    leave lp0030.
END.

