/* xxinvmt.p  xxinv_mt��ά����ʽ                                       */
/* ����˵���� ��Ʊ�ŵ������                                           */
/* �Զ�������ƣ�xxinv_mstr ,xxship_det                                */

/*----rev history-------------------------------------------------------------*/
/*ԭ�汾20100706,ԭ��ʽ��xxinvmt.p                                            */
/* SS - 110307.1  By: Roger Xiao   �����޸�:��bug,,ԭ��û���κ�У��,����Ҳδ��*/
/* SS - 110408.1  By: Roger Xiao                                              */ 
/*unique-index nbr + vend <--����һ����Ʊ�Ŷ�Ӧ�����Ӧ�̵����               */
/* SS - 120530.1  BY: ZY                                                      */
/*-Revision end---------------------------------------------------------------*/
/*SS - 120530.1
 *  ����xxship__chr01�����������
 *  ����xxship__chr01����Ƿ�����
**/

{mfdtitle.i "120530.1"}

/* SS - 110307.1 - B
��Щ�ֶ���ȫû���κεط�����,���������ȼ�:

        xxinv_mstr:
              30 xxinv_refer         �ο���
              40 xxinv_section       Section
              50 xxinv_duedate   ��������
              60 xxinv_date      ������Ʊ����
              70 xxinv_curr      ��������
              80 xxinv_value     �۸�
             150 xxinv_value1    �۸�
             110 xxinv_pkg       ����
             120 xxinv_vandate   ��������
             130 xxinv_plandate  �ƻ�����
             140 xxinv_rate      �Ի���


        xxship_det:
              70 xxship_curr     ��������
             100 xxship_rate     ����
             110 xxship_site     ?
             150 xxship_pkg      ����

   SS - 110307.1 - E */





define variable v_nbr as char format "x(12)" no-undo.
define variable vend  as char format "x(8)"  no-undo.
define variable del-yn like mfc_logical initial no.
define variable vend_desc as char format "x(30)".

FORM
    vend        label "��Ӧ��"       colon 10
    vend_desc   label "��Ӧ������"   colon 40
    v_nbr       label "��Ʊ��"       colon 10
with frame a side-labels width 80 attr-space  .

setFrameLabels(frame a:handle).

FORM
  xxinv_pm      label "��˰"    colon 10 xxinv_site  label "��  ��"   colon 40
  xxinv_con     label "��ͬ��"  colon 10 xxinv_curr  label "��������" colon 40
  xxinv_refer   label "�ο���"  colon 10 xxinv_value label "��ͬ�ܼ�" colon 40
  xxinv_section label "Section" colon 10 xxinv_pkg   label "��ͬ����" colon 40

  xxinv_date     label "��Ʊ����" colon 10
  xxinv_duedate  label "��������" colon 40
  xxinv_plandate label "�ƻ�����" colon 10
  xxinv_vandate  label "��������" colon 40
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
        message "����:��Ч��Ӧ��,����������" .
        next-prompt vend with frame a .
        undo,retry.
    end.
    else do:
        find first cu_mstr where cu_curr = vd_curr no-lock no-error .
        if not avail cu_mstr then do:
            message "����:��Ч��Ӧ�̱ұ�,����������" .
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
