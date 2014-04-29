/* iclotr02.p - INVENTORY TRANSFER SINGLE ITEM (RESTRICTED)             */
/* Copyright 1986-2000 QAD Inc., Carpinteria, CA, USA.                  */
/* All rights reserved worldwide.  This is an unpublished work.         */
/*F0PN*/ /*V8:ConvertMode=Maintenance                                   */
/*K1Q4*/ /*V8:RunMode=Character,Windows                                 */
/* REVISION: 7.0     LAST MODIFIED: 07/02/92    BY: pma *F701*          */
/* REVISION: 8.6     LAST MODIFIED: 06/11/96    BY: aal *K001*          */
/* REVISION: 8.6     LAST MODIFIED: 05/20/98    BY: *K1Q4* Alfred Tan   */
/* REVISION: 9.1     LAST MODIFIED: 03/24/00 BY: *N08T* Annasaheb Rahane */
/* REVISION: 9.1     LAST MODIFIED: 08/13/00 BY: *N0KS* myb              */
/* ADM               LAST MODIFIED: 03/25/04 BY: *ADM* He Shi Yu
                     Print the report to local
                     modi iclotrxx.p,icxferxx.p,icxfer1xx.p,ictransxx.i,tmp_gpselout.i  */
/*ADM1               last modified: 06/25/04  Heshiyu modi the item description         */
/*ADM2               last modified: 07/29/04  Heshiyu Add a field lot_no and can print two times */
/* REVISION  EBSP4   BY: MEL ZHAO DATE 13/03/29 ECO SS-20130329.1           */

/*a-flag*: 20090825 */

/*a-flag*: 20110710**add spec */
/*                                                      *428*
将调 拔至库位栏-----保留上次调拔的库位记忆，不要每次调拔都要输入库位。
*/
/*{mfdtitle.i "A0710"}*/
{mfdtitle.i "140428.1"} /* ss - 20130329 */

{pxmaint.i}

define new shared variable trtype as character.
define new shared variable p_userid as character.
define variable v_frloc like tr_loc no-undo.
define variable v_filename as char format "x(20)" no-undo.
define new shared temp-table prttbl
           field p_nbr     like tr_trnbr
           field p_part     like tr_part
           field p_desc    like pt_desc1
           field p_chg     like tr_qty_chg
           field p_type     like tr_type
           field p_toloc    like tr_loc
           field p_effdate    like tr_effdate
           field p_lot      like tr_lot
           field p_um       like tr_um.

{gldydef.i new}
{gldynrm.i new}
if daybooks-in-use then
    {gprun.i ""nrm.p"" "persistent set h-nrm"}.

    trtype = "SITE/LOC".
    /*{gprun.i ""iclotrxx.p""} **/
    {gprun.i ""xxiclotrxx2.p""}
    find first prttbl no-lock no-error .
    if available prttbl then do:

define var v_ipd_tol as char format "x(90)" .
define var v_toloc_name as char format "x(28)" .
define var v_usr_nbr    as char format "x(18)" .
define variable rtitle1 as character format "x(90)".
define variable rtitle2 as character format "x(50)".
define variable v_print as logical format "Y/N" init Yes.

        form
           /* v_print    label "是否打印"  */
            v_print    label "琌ゴ"  /* ss - 20130329 */
        with frame xx side-labels no-underline width 80 attr-space.
        setFrameLabels(frame xx:handle).

        {wbrp01.i}

         if c-application-mode <> 'web' then
            update v_print with frame xx.

         {wbrp06.i &command = update &fields = "v_print"}

        if  v_print = no then next .


        /* Select printer */
        {tmp_gpselout.i
         &printType = "printer"
         &printWidth = 132
         &pagedFlag = bPage
         &stream = " "
         &appendToFile = " "
         &streamedOutputToTerminal = " "
         &withBatchOption = "no"
         &displayStatementType = 1
         &withCancelMessage = "yes"
         &pageBottomMargin = 1
         &withEmail = "yes"
         &withWinprint = "yes"
         &defineVariables = "yes"
        }

    /*rtitle1 = "xxiclot2.p A0710                                    威斯达电器（中山）制造有限公司" .*/
    rtitle1 = "xxiclot2.p A0710                                    吹笷筿竟い籹硑Τそ" . /* ss 20130329 */
    rtitle2 =   substring(dtitle,22,44,"Raw").
    form header
        rtitle1
        getTermLabelRtColon("DATE",9) format "x(9)" to 123
        today           skip
        skip(1)
        getTermLabel("PAGE",8) + ":" at 1
        string(page-number {2}) format "x(8)"
        rtitle2   at 52
        getTermLabelRtColon("TIME",9) format "x(9)" to 123
        string(Time,"hh:mm:ss")
        skip(1)
    with frame phead page-top width 132 no-box.
    {wbgp03.i}
    view frame phead.


    define stream s1.
    v_filename = "TMP_" + execname + trim(p_toloc) + string(today,"999999") + string(time,"hh:mm:ss") + "." + trim(p_userid).
    output stream s1 to value(v_filename).

            v_toloc_name = "" .
            v_usr_nbr    = "" .
            find first prttbl where p_type = "RCT-TR" no-lock no-error.
            if avail prttbl then do:
                find first tr_hist
                    where tr_trnbr = p_nbr
                no-lock no-error.
                if avail tr_hist then do:
                    find first loc_mstr where loc_site = tr_site and loc_loc = p_toloc no-lock no-error.
                    if avail loc_mstr then v_toloc_name = loc_desc .

                    v_usr_nbr = tr_nbr .
                end.
            end.

            /* ss - 20130329 - b */
            display
                 /*"接收单位:"              at 1*/
                 "钡Μ虫"              at 1
                 v_toloc_name             at 14
                 /*"用户名: "               at 52*/
                 "ノめ"               at 52
                 p_userid                 at 63  no-label
                /* "单号: "                 at 80*/
                 "虫腹"                 at 80
                 v_usr_nbr                no-label
                 skip
                 /*"料号                  说明                           转移数量    单位 从库位      至库位      生效日期    交易号" at 1 */
                "腹                  弧                           锣簿计秖    虫 眖畐      畐      ネら戳    ユ腹"  at 1

                 /*"料号                  说明                           转移数量    单位 从库位      至库位      生效日期    交易号" at 1 */
                 skip
                 "------------------" at 1
                 "------------------------" at 23
                 "------------" at 51
                 "--"         at 66
                 "--------" at 71 "--------" at 83 "--------" at 95 "--------" at 107
            with frame fhead width 120 no-label no-box.
            /* ss - 20130329 - e */


            view stream s1 frame phead.
            view stream s1 frame fhead.

         for each prttbl no-lock:
             if p_type = "ISS-TR" then do:
                v_frloc = p_toloc.
                next.
             end.
             display
                 p_part
                 p_desc      at 23
                 p_chg       at 51
                 p_um        at 66
                 v_frloc     at 71
                 p_toloc     at 83
                 p_effdate   at 95
                 p_nbr       at 107
             with frame yyy width 120 no-box no-label down.
             view stream s1 frame yyy.

             find pt_mstr where pt_part = p_part no-lock no-error.
             if available pt_mstr and pt_draw <> "" then do:
                    display pt_draw at 23
                    with frame jjj width 120 no-box no-label down.
                    view stream s1 frame jjj.
             end.

             if p_lot <> "" then do:
              display p_lot with frame yy no-box no-label down.
              view stream s1 frame yy.
             end.

             v_ipd_tol = "" .
             for each ipd_det where ipd_part = p_part
                              and   ipd_routing = 'ITEMSPEC'
                              and  (ipd_start <= today or ipd_start = ?)
                              and  (ipd_end   >= today or ipd_end = ?)
                              no-lock:
                 if ipd_tol <> "" then do:
                    if v_ipd_tol = "" then v_ipd_tol = trim(ipd_det.ipd_tol) .
                    else v_ipd_tol = v_ipd_tol + " " + trim(ipd_det.ipd_tol) .
                 end.
             end.
            if v_ipd_tol <> "" then do:
                display v_ipd_tol at 23
                with frame kkk width 120 no-box no-label down.
                view stream s1 frame kkk.
            end.
         end.  /* for each prttbl....*/
               if 33 - line-counter >= 3 then put skip(33 - line-count - 3).
               else if 66 - line-counter >= 3  then
                   put skip(66 - line-count - 3).
              /* ss - 20130329 - b */
               display
                 /*" 发料人签名：                                                                 领料部门签收:" at 1
                 " 日期:                                                                                日期:" at 1*/
                 " 祇帽                                                                 烩场帽Μ:" at 1
                 " ら戳:                                                                                ら戳:" at 1
               with frame b2 width 120 no-label no-box.
               view stream s1 frame fboot2.
              /* ss - 20130329 - e */
        output stream s1 close.
        {mfreset.i}
    end.   /* if available prttbl...*/

if daybooks-in-use then delete PROCEDURE h-nrm no-error.
