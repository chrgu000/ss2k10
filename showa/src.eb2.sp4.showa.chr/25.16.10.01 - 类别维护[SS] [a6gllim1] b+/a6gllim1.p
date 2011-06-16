/* a6gllim1.p - 类别维护                      */
/* BY: Micho Yang          DATE: 04/23/08  ECO: *SS - 20080423.1* */

    /* DISPLAY TITLE */
    {mfdtitle.i "b+ "}

    define variable sums_desc like fm_desc.
    define variable sums_into like usrw_key3.
    define variable del-yn like mfc_logical initial no.
    define new shared variable usrw_recno as recid.

    DEF BUFFER f1 FOR usrw_wkfl .
    DEF BUFFER f2 FOR usrw_wkfl .

define variable fmtcode  as CHAR extent 7.
define variable fmtdesc  as character format "x(24)"  extent 7.
define variable knt      as integer.
define variable oldsum   as CHAR.
define variable level    as character format "x(8)"   extent 7.
define variable i        as integer.
define variable maxlevel as integer.
define variable old_curr   like ac_curr.
define variable begdt      like glc_start.
define variable old_type   like ac_type.
define variable old_fpos   like ac_fpos.
define variable input_fpos like ac_fpos no-undo.
define variable mc-error-number like msg_nbr no-undo.

    /* DISPLAY SELECTION FORM */
    FORM
        usrw_key2       COLON 25    LABEL "项目"
        usrw_charfld[1] COLON 25    FORMAT "x(24)"  LABEL "说明"
        
        usrw_key3       COLON 25    LABEL "汇总至" fmtdesc[1] NO-LABEL level[1] NO-LABEL
       fmtcode[2] no-label at 27 fmtdesc[2] no-label level[2] no-label
       fmtcode[3] no-label at 27 fmtdesc[3] no-label level[3] no-label
       fmtcode[4] no-label at 27 fmtdesc[4] no-label level[4] no-label
       fmtcode[5] no-label at 27 fmtdesc[5] no-label level[5] no-label
       fmtcode[6] no-label at 27 fmtdesc[6] no-label level[6] no-label
       fmtcode[7] no-label at 27 fmtdesc[7] no-label level[7] no-label
    
        usrw_key4       COLON 25    LABEL "类型"   "S(汇总项)/D(明细项)" 
        usrw_logfld[1]     COLON 25    LABEL "有效的"
        WITH FRAME a SIDE-LABELS WIDTH 80 ATTR-SPACE .

    /* SET EXTERNAL LABELS */
    setFrameLabels(frame a:handle).

    /* DISPLAY */
    view frame a.

    mainloop:
    REPEAT WITH FRAME a :
        PROMPT-FOR usrw_key2 EDITING :
            /* FIND NEXT/PREVIOUS RECORD */
            {a6mfnp.i usrw_wkfl usrw_key2 usrw_key2 usrw_key2 usrw_key2 usrw_index1}

            if recno <> ? then do:
                DISP " " @ fmtdesc[1] .
                DISP " " @ level[1] .
                DO i = 2 TO 7:
                    DISP 
                        " " @ fmtcode[i]
                        " " @ fmtdesc[i]
                        " " @ level[i] .
                END.

                display 
                    usrw_key2 usrw_charfld[1] 
                    usrw_key3 usrw_key4 usrw_logfld[1] with frame a.  

                /*
                find f1 WHERE f1.usrw_key1 = "glsum"
                    AND f1.usrw_key2 = usrw_wkfl.usrw_key3 NO-LOCK no-error.
                if available f1 then display f1.usrw_charfld[1].
                else display "" @ f1.usrw_charfld[1] .
                */
            end.
        END. /* PROMPT-FOR usrw_key2 EDITING : */

        /* ADD/MOD/DELETE  */
        find usrw_wkfl WHERE usrw_wkfl.usrw_key1 = "glsum"
            AND usrw_wkfl.usrw_key2 = INPUT usrw_wkfl.usrw_key2 no-error.
        IF not available usrw_wkfl then do:
            {mfmsg.i 1 1}   /* Adding new record */
            create usrw_wkfl.
            assign 
                usrw_wkfl.usrw_key1 = "glsum" 
                usrw_wkfl.usrw_key2 = CAPS(INPUT usrw_wkfl.usrw_key2) .
        end.

        recno = recid(usrw_wkfl).
        usrw_recno = recno.

        ststatus  =  stline[2].
        status input ststatus.
        del-yn = no.

        display usrw_wkfl.usrw_key2 usrw_wkfl.usrw_charfld[1] 
                usrw_wkfl.usrw_key3 usrw_wkfl.usrw_key4 usrw_wkfl.usrw_logfld[1]
                with frame a.

         display
            " " @ fmtdesc[1].
         display
            " " @ level[1].

         do i = 2 to 7:
            display
               " " @ fmtcode[i]
               " " @ fmtdesc[i]
               " " @ level[i].
         end. /* do i = 2 to 7: */

         if usrw_wkfl.usrw_key3 <> "" then do:
            find f2 where f2.usrw_key2 = usrw_wkfl.usrw_key3 no-lock no-error.
            if available f2 then do:
               maxlevel = 1.
               knt = 1.
               fmtdesc[knt] = f2.usrw_charfld[1].
               do while maxlevel < 99:
                  if f2.usrw_key3 <> "" then do:
                     maxlevel = maxlevel + 1.
                     oldsum = f2.usrw_key3.
                     find f2 where f2.usrw_key2 = oldsum
                        no-lock no-error.
                     if available f2 and knt < 7 then do:
                        knt = knt + 1.
                        fmtcode[knt] = f2.usrw_key2.
                        fmtdesc[knt] = f2.usrw_charfld[1].
                     end. /* if available fm_mstr and knt < 7 then do: */
                  end. /* if fm_sums_into 0 */
                  else leave.
               end. /* do while maxlevel < 99 */
            end. /* if available fm_mstr */
            do i = 1 to min(knt,7):

               level[i] = getTermLabel("LEVEL",5) + " " +
               string((maxlevel - (i - 1)),">9").
               if i = 1 then
                  display fmtdesc[i] level[i] with frame a.
               else
                  display fmtcode[i] fmtdesc[i] level[i] with frame a.
            end. /* do i = 1 to min(knt,7): */
         end. /* if ac_fpos <> 0 */

        loopa: 
        DO on error undo, retry:
            /* 类型默认为S,S表示汇总项目，D表示明细项目 */
            usrw_wkfl.usrw_key4 = "S" .
            usrw_wkfl.usrw_logfld[1] = YES .
            DISP usrw_wkfl.usrw_logfld[1] WITH FRAME a .

            set 
                usrw_wkfl.usrw_charfld[1] 
                usrw_wkfl.usrw_key3 usrw_wkfl.usrw_key4 usrw_wkfl.usrw_logfld[1]
            go-on("F5" "CTRL-D").

            IF not(usrw_wkfl.usrw_key4 = "S" OR usrw_wkfl.usrw_key4 = "D") THEN DO:
                MESSAGE "错误: 项目类型错误,只能输入S或者D" .
                NEXT-PROMPT usrw_wkfl.usrw_key4 WITH FRAME a.
                UNDO,RETRY .
            END.

            /* 检查：只允许明细项的类型为D，汇总项的类型为S */
            FOR FIRST f1 WHERE f1.usrw_key1 = "glsum" AND f1.usrw_key3 = usrw_wkfl.usrw_key2
                NO-LOCK :
            END.
            IF AVAIL f1 AND usrw_wkfl.usrw_key4 = "D" THEN DO:
                MESSAGE "错误: 此项目是一个汇总项,不允许将类型改为D" .
                NEXT-PROMPT usrw_wkfl.usrw_key4.
                UNDO,RETRY .
            END.      

            /* DELETE */
            if lastkey = keycode("F5") or lastkey = keycode("CTRL-D") then do:
                del-yn = yes.
                {mfmsg01.i 11 1 del-yn}
                if del-yn = no then undo loopa.
            end.

            if del-yn then do:
                /*CHECK FOR FORMAT POSITIONS USING FORMAT POSITION
                  FOR SUMS INTO*/
                sums_into = usrw_wkfl.usrw_key2 .
                if can-find (first usrw_wkfl where usrw_wkfl.usrw_key1 = "glsum" AND 
                    usrw_wkfl.usrw_key3 = sums_into) then do:
                    {mfmsg.i 3042 3} /* CANNOT DELETE--FORMAT POSITION USED AS'SUMS INTO' */
                    undo loopa.
                end.

                /* CHECK FOR ACCOUNT MASTERS USING FORMAT POSITION */
                /* micho 未完成
                if can-find (first ac_mstr where ac_fpos = fm_mstr.fm_fpos)
                   then do:
                   {mfmsg.i 3003 3}
                   undo loopa.
                end.
                */
    
               /* OK TO DELETE */
               delete usrw_wkfl .
               clear frame a.
               del-yn = no.
               next mainloop.
            end. /* if del-yn then do: */
            else do:
                 display
                    " " @ fmtdesc[1].
                 display
                    " " @ level[1].
        
                 do i = 2 to 7:
                    display
                       " " @ fmtcode[i]
                       " " @ fmtdesc[i]
                       " " @ level[i].
                 end. /* do i = 2 to 7: */
        
                 if usrw_wkfl.usrw_key3 <> "" then do:
                    find f2 where f2.usrw_key2 = usrw_wkfl.usrw_key3 no-lock no-error.
                    if available f2 then do:
                       maxlevel = 1.
                       knt = 1.
                       fmtdesc[knt] = f2.usrw_charfld[1].
                       do while maxlevel < 99:
                          if f2.usrw_key3 <> "" then do:
                             maxlevel = maxlevel + 1.
                             oldsum = f2.usrw_key3.
                             find f2 where f2.usrw_key2 = oldsum
                                no-lock no-error.
                             if available f2 and knt < 7 then do:
                                knt = knt + 1.
                                fmtcode[knt] = f2.usrw_key2.
                                fmtdesc[knt] = f2.usrw_charfld[1].
                             end. /* if available fm_mstr and knt < 7 then do: */
                          end. /* if fm_sums_into 0 */
                          else leave.
                       end. /* do while maxlevel < 99 */
                    end. /* if available fm_mstr */
                    do i = 1 to min(knt,7):
        
                       level[i] = getTermLabel("LEVEL",5) + " " +
                       string((maxlevel - (i - 1)),">9").
                       if i = 1 then
                          display fmtdesc[i] level[i] with frame a.
                       else
                          display fmtcode[i] fmtdesc[i] level[i] with frame a.
                    end. /* do i = 1 to min(knt,7): */
                 end. /* if ac_fpos <> 0 */

                if usrw_wkfl.usrw_key3 = usrw_wkfl.usrw_key2 then do:
                   {mfmsg.i 3012 3} /* INVALID FORMAT POSITION */
                   next-prompt usrw_wkfl.usrw_key3 with frame a.
                   undo loopa, retry.
                end.
    
                sums_into = usrw_wkfl.usrw_key3.
                find f1 WHERE f1.usrw_key1 = "glsum" 
                    AND f1.usrw_key2 = sums_into no-lock no-error.
                if not available f1 AND sums_into <> "" then do:
                    {mfmsg.i 3012 3} /* INVALID FORMAT POSITION */
                    next-prompt usrw_wkfl.usrw_key3 with frame a.
                    undo loopa, retry.
                end.
                /*
                if available f1 then display f1.usrw_charfld[1] @ sums_desc
                   with frame a.
                  */

                /* CHECK FOR CYCLICAL FORMAT POSITIONS */
                {gprun.i ""a6gllim1a.p""}
                if usrw_recno = 0 then do:
                   {mfmsg.i 3043 3} /* CYCLICAL FORMAT POSITION */
                   next-prompt usrw_wkfl.usrw_key3 with frame a.
                   undo loopa, retry.
                end.
            end. /* else do: */
        end. /* DO on error undo, retry: */
    END. /* REPEAT WITH FRAME a : */
    STATUS INPUT .




