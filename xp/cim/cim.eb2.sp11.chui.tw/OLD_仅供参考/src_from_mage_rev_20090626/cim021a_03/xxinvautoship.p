/* xxinvotrarp.p - CS INVOINCE AUTO TRANSFER                  */
/* Copyright SOFTSPEED Inc.   */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* Creation: eb2 sp11  chui  modified: ??/??/??   BY: Ivan?  *this line added by kaine*       */
/* REVISION: eb2 sp11  chui  modified: 08/16/06   BY: Kaine Zhang  *ss-20060816.1*            */
/* REVISION: eb2 sp11  chui  modified: 08/23/06   BY: Kaine Zhang  *ss-20060823.1*            */
/* REVISION: eb2 sp11  chui  modified: 08/23/06   BY: Kaine Zhang  *ss-20060823.2*            */
/* REVISION: eb2 sp11  chui  modified: 12/10/06   BY: Kaine Zhang  *ss-20061210.1*            */

/* ===================================================================== */
/*ss-20060823.1*
 *  if no ld_det exist, err msg maybe lose,
 *  even fail to run shipment
 */

/*ss-20060816.1* do it(shipment) all or none */
/* ===================================================================== */

{mfdtitle.i "1 "}

 /* {xxinvotraa.i "new"} */

define var invno like xxshm_inv_no.
define var site_from like pt_site init "2000" .
define var site_to like pt_site.
define var loc_from  like pt_loc.
define var loc_to like pt_loc.

define var trtotal_qty as integer init 0.
define var trsucc_qty as integer init 0.
define var trallsuccess as logical init true.
define var yn as logical init true.

define var tmpqty like sr_qty.
define var i as integer init 0.
define var j as integer init 0.


/* ***********************ss-20061210.1 B Add********************** */
DEF VAR strPrtInvInputFileName AS CHAR NO-UNDO.
DEF VAR strPrtInvOutputFileName AS CHAR NO-UNDO.
DEF VAR datBegDate AS DATE NO-UNDO.
DEF VAR decBegTime AS DECIMAL NO-UNDO.
/* ***********************ss-20061210.1 E Add********************** */

DEF VAR cimERROR AS logi .

define  temp-table tm1mstr
        field   tm1_part like pt_part
        field tm1_site like si_site
        field tm1_loc like pt_loc
        field tm1_qty like sr_qty
/*     FIELD tm1_so_nbr LIKE so_nbr    */
/*     FIELD tm1_so_line LIKE sod_line */
        field tm1_isenou as logical
        .

form invno colon 15  skip(1)
    "from" colon 16

    site_from colon 15

    loc_from colon 15

with frame a side-labels attr-space width 80.
setFrameLabels(frame a:handle).


        mainloop:
         repeat with frame a:


         clear frame a all no-pause.
         view frame a.
        display
        invno
        site_from
         loc_from
        with frame a.

        update invno with frame a .
/*         editing:                                  */
/*              {xxinvomfnp14.i xxshm_mstr xxshm_inv */
/*             "and 1 = 1 "                          */
/*             "xxshm_log[4]" false                  */
/*             1 1                                   */
/*             1 1                                   */
/*             1 1 }                                 */
/*                                                   */
/*                                                   */
/* /*                                                */
/*     for first {1}    where                        */
/*          {3}          and                         */
/*          {4}   = {5}  and                         */
/*          {6}   = {7}  and                         */
/*          {8}   = {9}  and                         */
/*          {10} >= {11} use-index {2} no-lock:      */
/*                                                   */
/*      */                                           */
/*                                                   */
/*                                                   */
/*             if recno <> ? then do:                */
/*             invno = xxshm_inv_no.                 */
/*             display invno  with frame a.          */
/*             end.                                  */
/*         end.     /*end editing*/                  */
/*         status input.                             */

        if invno matches("*cs") then do:
             {pxmsg.i &MSGNUM=8113 &ERRORLEVEL=3}
             /* message "Not available this CS Invoice, please retry again.". */
             next-prompt invno with frame a.
            undo, retry.
        end.        /* end if not input xxshm_inv_no matches("*cs") */

        FIND FIRST xxshm_mstr where xxshm_inv_no = invno and xxshm_log[4] = false  no-lock no-error.
        if not available xxshm_mstr then do:
             {pxmsg.i &MSGNUM=8113 &ERRORLEVEL=3}
            next-prompt invno with frame a.
             undo, retry.
        end.    /* END if not available xxshm_mstr */

        loop1:
        do on error undo, retry with frame a:
            set
             site_from
             loc_from
             with frame a.

             for first si_mstr where si_site =  site_from no-lock:
            end. /* FOR FIRST si_mstr */
            if not available si_mstr then do :
                  {pxmsg.i &MSGNUM=708 &ERRORLEVEL=3}
                undo loop1 ,retry.
            end.     /*end if not available si_mstr */

            for first loc_mstr where loc_site = site_from and loc_loc = loc_from no-lock:
            end.
            if not available loc_mstr then do :
                 {pxmsg.i &MSGNUM=709 &ERRORLEVEL=3}
                undo loop1 ,retry.
             end.    /* end if not available loc_mstr */
        end.   /*end do on error */



        for each tm1mstr:
            delete tm1mstr.
        end.
        i = 0.
        j = 0.

        for each xxshd_det where xxshm_inv_no = xxshd_inv_no :

            find first so_mstr where so_nbr = xxshd_so_nbr no-lock no-error.
            if avail so_mstr then do:
                if so_invoiced then do:
                    /* Invoice printed but not posted */
                    {pxmsg.i &MSGNUM=603 &ERRORLEVEL=3}
                    undo mainloop,retry mainloop .
                end.
            end.

        end.
        for each xxshd_det where xxshm_inv_no = xxshd_inv_no use-index xxshd_inv_so:
            if not xxshd_log[2]  then do:
                i = i + 1.

                /*ss-20060823.2*  todo: FIND problem? qty need conv  */
                find first tm1mstr where tm1_part  = xxshd_so_part no-error .
                if not available tm1mstr then do:
                    create tm1mstr.
                    assign tm1_part = xxshd_so_part
                     tm1_site = site_from
                     tm1_loc = loc_from
                     tm1_qty = xxshd_so_qty
                     tm1_isenou = false
                      .
                end.    /* end if not available tm1mstr */
                else do:
                    tm1_qty = tm1_qty + xxshd_so_qty.
                end.
            end.
            else do:
                j = j + 1.
            end.
        end.    /* for each xxshd_det */
        trtotal_qty = 0.

        /* ********************ss-20060823.1 B Del*******************
         *  for each tm1mstr , each ld_det where tm1_site = ld_site  and tm1_part = ld_part and tm1_loc = ld_loc:
         *      trtotal_qty = trtotal_qty + 1.
         *      if tm1_qty <= ld_qty_oh then tm1_isenou = true.
         *  end.    /* for each tm1mstr */
         * ********************ss-20060823.1 E Del*******************/


        /* ***********************ss-20060823.1 B Add********************** */
        /*ss-20060823.1*  1. premiss: location detail NOT USE _lot _ref.  */
        /*ss-20060823.1*  2. IF 1 IS OK, THEN (ld_site + ld_loc + ld_part) IS UNIQUE.  */
        /*ss-20060823.1*     ELSE maybe appear bug  */
        FOR EACH tm1mstr:
            trtotal_qty = trtotal_qty + 1.

            FOR FIRST ld_det where tm1_site = ld_site  and tm1_part = ld_part and tm1_loc = ld_loc:
            END.
            IF tm1_qty <= (IF AVAILABLE ld_det THEN ld_qty_oh ELSE 0) THEN tm1_isenou = TRUE.
        END.
        /* ***********************ss-20060823.1 E Add********************** */


        if trtotal_qty > 0 then do:
            for first tm1mstr where tm1_isenou = false:
            end.
            if  available tm1mstr then do :
                message tm1_part + "庫存不夠,操作終止".
                undo mainloop,retry.
            end.    /* if  available tm1mstr */

            else do:
                message "是否發運?" update yn.
                if yn then do:

                    /* ********************ss-20060816.1 B Del*******************
                     *  message "Processing ......".
                     *  cimERROR = NO .
                     *  FOR EACH xxshd_det WHERE xxshd_inv_no = invno  BY xxshd_so_nbr BY xxshd_so_line :
                     *      STATUS DEFAULT "Shipping " + xxshd_so_nbr + "-" + STRING(xxshd_so_line) + " " + xxshd_so_part + STRING(xxshd_so_qty) .
                     *      {xxinvautoshipu.i}
                     *
                     *          FIND LAST tr_hist WHERE tr_trnbr > 0 AND tr_part = xxshd_so_part AND tr_type = "ISS-SO" AND tr_nbr = xxshd_so_nbr
                     *                  AND tr_loc = loc_FROM AND abs(tr_qty_chg) = xxshd_so_qty NO-LOCK NO-ERROR.
                     *          IF AVAIL tr_hist THEN ASSIGN xxshd_log[2] = YES .
                     *          ELSE DO:
                     *              MESSAGE "發運不成功: " + xxshd_so_nbr + "-" + STRING(xxshd_so_line) + " " + xxshd_so_part + STRING(xxshd_so_qty)
                     *                  VIEW-AS ALERT-BOX .
                     *              cimERROR = YES .
                     *          END.
                     *  END.
                     *  IF cimError = NO  THEN DO:
                     *      MESSAGE "此INVOICE全部發運成功！" VIEW-AS ALERT-BOX .
                     *  END.
                     * ********************ss-20060816.1 E Del*******************/


                    /* ***********************ss-20060816.1 B Add********************** */
                    /* ss-20061210.1 */  ASSIGN datBegDate = TODAY decBegTime = TIME .
                    tranlp:
                    DO TRANSACTION ON ERROR UNDO, LEAVE:
                        message "Processing ......".
                        cimERROR = NO .

                        FOR EACH xxshd_det WHERE xxshd_inv_no = invno  BY xxshd_so_nbr BY xxshd_so_line :
                            STATUS DEFAULT "Shipping " + xxshd_so_nbr + "-" + STRING(xxshd_so_line) + " " + xxshd_so_part + STRING(xxshd_so_qty) .
                            {xxinvautoshipu.i}

                            FIND LAST tr_hist WHERE tr_trnbr > 0 AND tr_part = xxshd_so_part AND tr_type = "ISS-SO" AND tr_nbr = xxshd_so_nbr
                                AND tr_loc = loc_FROM AND abs(tr_qty_chg) = xxshd_so_qty
                                /* ***********************ss-20061210.1 B Add********************** */
                                AND tr_line = xxshd_so_line
                                AND (
                                    (tr_date = datBegDate AND tr_time >= decBegTime)
                                    OR
                                    (tr_date > datBegDate)
                                    )
                                /* ***********************ss-20061210.1 E Add********************** */
                                NO-LOCK NO-ERROR.
                            IF AVAIL tr_hist THEN ASSIGN xxshd_log[2] = YES .
                            ELSE DO:
                                MESSAGE "發運不成功: " + xxshd_so_nbr + "-" + STRING(xxshd_so_line) + " " + xxshd_so_part + STRING(xxshd_so_qty)
                                    VIEW-AS ALERT-BOX .
                                cimERROR = YES .
                            END.
                        END.

                        IF cimError = NO  THEN DO:
                            MESSAGE "此INVOICE全部發運成功！" VIEW-AS ALERT-BOX .
                        END.
                        ELSE DO:
                            MESSAGE "have errors, please check data" VIEW-AS ALERT-BOX.
                            /* *ss-20061210.1*  UNDO tranlp, LEAVE tranlp.  */
                            /* *ss-20061210.1* */ UNDO mainloop, LEAVE mainloop.
                        END.
                    END.
                    /* ***********************ss-20060816.1 E Add********************** */


                    /* ***********************ss-20061210.1 B Add********************** */
                    printinvlp:
                    DO TRANSACTION ON ERROR UNDO, LEAVE:
                        MESSAGE "Update Invoice Date ......" .
                        ASSIGN
                            strPrtInvInputFileName = "./ssi" + STRING(TIME, "99999") + mfguser
                            strPrtInvOutputFileName = "./sso" + STRING(TIME, "99999") + mfguser
                            cimError = NO
                            .

                        FOR EACH xxshd_det WHERE xxshd_inv_no = invno BREAK BY xxshd_so_nbr:
                            IF FIRST-OF(xxshd_so_nbr) THEN DO:
                                {xxprintinv01.i}
                                
                                FOR FIRST so_mstr WHERE so_nbr = xxshd_so_nbr AND (NOT so_to_inv) AND so_invoiced NO-LOCK:
                                END.
                                IF NOT AVAILABLE so_mstr THEN DO:
                                    MESSAGE "Print Invoice Fail: " xxshd_so_nbr .
                                    UNDO mainloop, RETRY mainloop.
                                END.
                            END.
                        END.
                    END.
                    /* ***********************ss-20061210.1 E Add********************** */
                end.
            end.

/*             for each tm1mstr  no-lock :                                                                                                                                                                     */
/*                 find last tr_hist where tr_trnbr > 0 and tr_part = tm1_part and tr_type = "RCT-TR" and tr_date = today and tr_site = site_to and tr_loc = loc_to and tr_qty_chg = tm1_qty no-lock no-error. */
/*                 if  not available tr_hist then do:                                                                                                                                                          */
/*                     trallsuccess = false.                                                                                                                                                                   */
/*                                                                                                                                                                                                             */
/*                 end.    /* end if  not available tr_hist*/                                                                                                                                                  */
/*                 else if available tr_hist then do:                                                                                                                                                          */
/*                     for each xxshd_det where xxshd_inv_no = invno and xxshd_so_part = tm1_part :                                                                                                            */
/*                         xxshd_log[2] = true.                                                                                                                                                                */
/*                     end.                                                                                                                                                                                    */
/*                 end.                                                                                                                                                                                        */
/*             end.  /* end for each tm1mstr */                                                                                                                                                                */
/*                                                                                                                                                                                                             */
/*             for first  xxshd_det where xxshd_inv_no matches("*cs") and xxshd_inv_no = invno and xxshd_log[2] = false no-lock:                                                                               */
/*             end.                                                                                                                                                                                            */
/*             if available xxshd_det then trallsuccess = false.                                                                                                                                               */



        end. /*end if trtotal_qty > 0 */

    end.

