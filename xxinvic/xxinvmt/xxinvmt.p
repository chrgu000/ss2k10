/* xxinvmt.p  xxinv_mt的维护程式                                       */
/* 程序说明： 发票号导入程序                                           */
/* 自定义表名称：xxinv_mstr ,xxship_det                                */

/*----rev history-------------------------------------------------------------*/
/*原版本20100706,原程式名xxinvmt.p                                            */
/* SS - 110307.1  By: Roger Xiao   本次修改:调bug,,原本没有任何校验,本次也未加*/
/* SS - 110408.1  By: Roger Xiao                                              */ 
/*unique-index nbr + vend <--存在一个发票号对应多个供应商的情况               */
/* SS - 120530.1  BY: ZY                                                      */
/*-Revision end---------------------------------------------------------------*/
/*SS - 120530.1
 *  借用xxship__chr01存放物料批号
 *  借用xxship__chr01存放是否待拆分
**/

{mfdtitle.i "120530.1"}

/* SS - 110307.1 - B
这些字段完全没有任何地方调用,低输入优先级:

        xxinv_mstr:
              30 xxinv_refer         参考号
              40 xxinv_section       Section
              50 xxinv_duedate   出船日期
              60 xxinv_date      开出发票日期
              70 xxinv_curr      货币类型
              80 xxinv_value     价格
             150 xxinv_value1    价格
             110 xxinv_pkg       托数
             120 xxinv_vandate   捆包日期
             130 xxinv_plandate  计划日期
             140 xxinv_rate      对换率


        xxship_det:
              70 xxship_curr     货币类型
             100 xxship_rate     汇率
             110 xxship_site     ?
             150 xxship_pkg      箱数

   SS - 110307.1 - E */





define variable v_nbr as char format "x(12)" no-undo.
define variable vend  as char format "x(8)"  no-undo.
define variable del-yn like mfc_logical initial no.
define variable vend_desc as char format "x(30)".

FORM
    vend        label "供应商"       colon 10
    vend_desc   label "供应商名称"   colon 40
    v_nbr       label "发票号"       colon 10
with frame a side-labels width 80 attr-space  .

setFrameLabels(frame a:handle).

FORM
  xxinv_pm      label "保税"    colon 10 xxinv_site  label "地  点"   colon 40
  xxinv_con     label "合同号"  colon 10 xxinv_curr  label "货币类型" colon 40
  xxinv_refer   label "参考号"  colon 10 xxinv_value label "合同总价" colon 40
  xxinv_section label "Section" colon 10 xxinv_pkg   label "合同托数" colon 40

  xxinv_date     label "发票日期" colon 10
  xxinv_duedate  label "出船日期" colon 40
  xxinv_plandate label "计划日期" colon 10
  xxinv_vandate  label "捆包日期" colon 40
with frame a1 side-labels width 80 attr-space  .
setFrameLabels(frame a1:handle).

mainloop:
repeat:

   view frame a.
   view frame a1.


   update vend v_nbr  with frame a editing:
         if frame-field = "vend" then do:
             {mfnp11.i xxinv_mstr xxinv_vend xxinv_vend " input vend "}
             if recno <> ? then do:
                find first ad_mstr where ad_addr = xxinv_vend no-lock no-error.
                if available ad_mstr then vend_desc = ad_name + ad_line3.
                else vend_desc = "".
                disp
                    xxinv_nbr  @ v_nbr
                    xxinv_vend @ vend
                    vend_desc
                with frame a .

                display
                    xxinv_site
                    xxinv_pm
                    xxinv_con
                    xxinv_refer
                    xxinv_section
                    xxinv_date
                    xxinv_duedate
                    xxinv_pkg
                    xxinv_curr
                    xxinv_value
                with frame a1.
             end . /* if recno <> ? then  do: */
         end.
         else if frame-field = "v_nbr" then do:
             {mfnp11.i xxinv_mstr xxinv_nbr "xxinv_vend = input vend and xxinv_nbr " " input v_nbr "}
             if recno <> ? then do:
                find first ad_mstr where ad_addr = xxinv_vend no-lock no-error.
                if available ad_mstr then vend_desc = ad_name + ad_line3.
                else vend_desc = "".
                disp
                    xxinv_nbr  @ v_nbr
                    xxinv_vend @ vend
                    vend_desc
                with frame a .

                display
                    xxinv_site
                    xxinv_pm
                    xxinv_con
                    xxinv_refer
                    xxinv_section
                    xxinv_date
                    xxinv_duedate
                    xxinv_pkg
                    xxinv_curr
                    xxinv_value
                with frame a1.
             end . /* if recno <> ? then  do: */
         end.
         else do:
                   status input ststatus.
                   readkey.
                   apply lastkey.
         end.
    end. /* update..EDITING */

    if input v_nbr = "" then do:
        {pxmsg.i &MSGNUM=40 &ERRORLEVEL=3}  /*BLANK NOT ALLOWED*/
        undo, retry.
    end. /*INPUT BLANK*/

    find first vd_mstr where vd_addr = vend no-lock no-error .
    if not avail vd_mstr then do:
        message "错误:无效供应商,请重新输入" .
        next-prompt vend with frame a .
        undo,retry.
    end.
    else do:
        find first cu_mstr where cu_curr = vd_curr no-lock no-error .
        if not avail cu_mstr then do:
            message "错误:无效供应商币别,请重新输入" .
            next-prompt vend with frame a .
            undo,retry.
        end.
    end.

    find first xxinv_mstr
        where xxinv_vend = vend
        and   xxinv_nbr  = v_nbr
    no-lock no-error.
    if avail xxinv_mstr then do:
            find first ad_mstr where ad_addr = xxinv_vend no-lock no-error.
            if available ad_mstr then vend_desc = ad_name + ad_line3.
            else vend_desc = "".
            display v_nbr vend_desc  with frame a.

            display
                xxinv_site
                xxinv_pm
                xxinv_con
                xxinv_refer
                xxinv_section
                xxinv_date
                xxinv_duedate
                xxinv_pkg
                xxinv_curr
                xxinv_value
            with frame a1.
    end.

    createloop:
    do on error undo,retry on endkey undo,leave :

        find first xxinv_mstr
            where xxinv_vend = vend
            and   xxinv_nbr  = v_nbr
        exclusive-lock no-error.
        if not available xxinv_mstr then do:
            {pxmsg.i &MSGNUM=1 &ERRORLEVEL=1}
            create xxinv_mstr.
            assign xxinv_nbr  = v_nbr
                   xxinv_vend = vend
                   xxinv_site = "GSA01"
                   xxinv_curr = "JPY"
                   .
            find first vd_mstr where vd_addr = xxinv_vend no-lock no-error .
            if avail vd_mstr then assign xxinv_curr = vd_curr .

        end.
        else do:
            {pxmsg.i &MSGNUM=10 &ERRORLEVEL=1}
        end.


        update
            xxinv_pm
            xxinv_con

            xxinv_refer
            xxinv_section
            xxinv_value
            xxinv_pkg
            xxinv_date
            xxinv_duedate
            xxinv_plandate
            xxinv_vandate
        go-on ("F5" "CTRL-D") with frame a1 no-validate
        editing :
                readkey.
                if lastkey = keycode("F5") or lastkey = keycode("CTRL-D")
                then do:
                        del-yn = yes.
                        {pxmsg.i &MSGNUM=11 &ERRORLEVEL=1 &CONFIRM=del-yn}
                        if not del-yn then undo, retry.
                        if del-yn then do:
                            for each xxinv_mstr where xxinv_nbr = v_nbr and xxinv_vend = vend .
                                delete xxinv_mstr.
                            end.
                            for each xxship_det where xxship_nbr = v_nbr and xxship_vend = vend .
                                delete xxship_det.
                            end.  /* 7end */

                            del-yn = no.
                            v_nbr  = "" .
                            vend   = "" .
                            clear frame a1 no-pause.
                            clear frame a no-pause.
                            next mainloop.
                        end.
                end.
                else apply lastkey.
        end. /* update ...EDITING */

        assign xxinv_mod_user = global_userid
               xxinv_mod_date = today
               .

        hide fram a1 no-pause .
        {gprun.i ""xxinvmta.p"" "(input v_nbr, input vend )"}
    end. /*createloop:*/

end. /* MAINLOOP */

/*{wbrp04.i &frame-spec = a} */
