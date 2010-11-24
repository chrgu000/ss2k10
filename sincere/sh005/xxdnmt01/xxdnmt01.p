/* xxdnmt */
/* REVISION: eb2.1 SP3 create 03/13/06 BY: *SS-MIN001* Apple Tam*/

    /* DISPLAY TITLE */
    {mfdtitle.i "1+"}

   define new shared variable p-type   like xdn_type.
   define new shared variable p-prev   like xdn_prev.
   define new shared variable p-name   like xdn_name.
   define new shared variable p-next   like xdn_next.  /*format "999999"*/
   define new shared variable p-isonbr like xdn_isonbr.
   define new shared variable p-isover like xdn_isover.
   define new shared variable p-desc1  like xdn_desc1.
   define new shared variable p-desc2  like xdn_desc2.
   define new shared variable p-desc3  like xdn_desc3.
   define new shared variable p-desc4  like xdn_desc4.
   define new shared variable p-desc5  like xdn_desc5.
   define new shared variable p-train1 like xdn_train1.
   define new shared variable p-train2 like xdn_train2.
   define new shared variable p-train3 like xdn_train3.
   define new shared variable p-train4 like xdn_train4.
   define new shared variable p-train5 like xdn_train5.
   define new shared variable p-page1  like xdn_page1.
   define new shared variable p-page2  like xdn_page2.
   define new shared variable p-page3  like xdn_page3.
   define new shared variable p-page4  like xdn_page4.
   define new shared variable p-page5  like xdn_page5.
   define new shared variable p-page6  like xdn_page6.

   define variable del-yn like mfc_logical initial no.

         /* DISPLAY SELECTION FORM */
    form
         p-type   colon 18 label "类型"
         p-prev   colon 18 label "单号前辍"
         p-name   colon 18 label "表头名称"
         p-next   colon 18 label "下一单号"
         p-isonbr colon 18 label "ISO表号"
         p-isover colon 18 label "ISO版本/修订"
         p-desc1  colon 18 label "说明1"
         p-desc2  colon 18 label "说明2"
         p-desc3  colon 18 label "说明3"
         p-desc4  colon 18 label "说明4"
         p-desc5  colon 18 label "说明5"
         p-train1 colon 18 label "表尾签名1"
         p-page1  colon 50 label "第一联"
         p-train2 colon 18 label "表尾签名2"
         p-page2  colon 50 label "第二联"
         p-train3 colon 18 label "表尾签名3"
         p-page3  colon 50 label "第三联"
         p-train4 colon 18 label "表尾签名4"
         p-page4  colon 50 label "第四联"
         p-train5 colon 18 label "表尾签名5"
         p-page5  colon 50 label "第五联"
         p-page6  colon 50 label "第六联"
    with frame a side-labels width 80.

    /* SET EXTERNAL LABELS */
    setFrameLabels(frame a:handle).

mainloop:
  repeat:
        view frame a.
        p-next   = "00001".
        p-type   = "".
        p-name   = "".
        p-prev   = "".
        p-isonbr = "".
        p-isover = "".
        p-desc1  = "".
        p-desc2  = "".
        p-desc3  = "".
        p-desc4  = "".
        p-desc5  = "".
        p-train1 = "".
        p-train2 = "".
        p-train3 = "".
        p-train4 = "".
        p-train5 = "".
        p-page1  = "".
        p-page2  = "".
        p-page3  = "".
        p-page4  = "".
        p-page5  = "".
        p-page6  = "".

       display
           p-type
           p-name
           p-prev
           p-next
           p-isonbr
           p-isover
           p-desc1
           p-desc2
           p-desc3
           p-desc4
           p-desc5
           p-train1
           p-train2
           p-train3
           p-train4
           p-train5
           p-page1
           p-page2
           p-page3
           p-page4
           p-page5
           p-page6
       with frame a.

       update p-type with frame a editing:
             {mfnp05.i xdn_ctrl xdn_type
                     " xdn_ctrl.xdn_domain = global_domain and yes "
                       xdn_type "input frame a p-type"}
   /*        {mfnp.i xdn_ctrl p-type xdn_type p-type xdn_type xdn_type}*/
             if recno <> ? then do:
                assign
                p-type   = xdn_type
                p-name   = xdn_name
                p-prev   = xdn_prev
                p-next   = xdn_next
                p-isonbr = xdn_isonbr
                p-isover = xdn_isover
                p-desc1  = xdn_desc1
                p-desc2  = xdn_desc2
                p-desc3  = xdn_desc3
                p-desc4  = xdn_desc4
                p-desc5  = xdn_desc5
                p-train1 = xdn_train1
                p-train2 = xdn_train2
                p-train3 = xdn_train3
                p-train4 = xdn_train4
                p-train5 = xdn_train5
                p-page1  = xdn_page1
                p-page2  = xdn_page2
                p-page3  = xdn_page3
                p-page4  = xdn_page4
                p-page5  = xdn_page5
                p-page6  = xdn_page6.

         display
                p-type
                p-name
                p-prev
                p-next
                p-isonbr
                p-isover
                p-desc1
                p-desc2
                p-desc3
                p-desc4
                p-desc5
                p-train1
                p-train2
                p-train3
                p-train4
                p-train5
                p-page1
                p-page2
                p-page3
                p-page4
                p-page5
                p-page6
            with frame a.

       end. /*recno <> ? */
  end. /*editing*/

        if p-type = "" then do:
           message "错误：类型不能为空, 请重新输入".
           undo, retry.
        end.
        find first xdn_ctrl where xdn_ctrl.xdn_domain = global_domain
               and xdn_type = p-type no-lock no-error.
        if available xdn_ctrl then do:
                 assign
                p-type   = xdn_type
                p-name   = xdn_name
                p-prev   = xdn_prev
                p-next   = xdn_next
                p-isonbr = xdn_isonbr
                p-isover = xdn_isover
                p-desc1  = xdn_desc1
                p-desc2  = xdn_desc2
                p-desc3  = xdn_desc3
                p-desc4  = xdn_desc4
                p-desc5  = xdn_desc5
                p-train1 = xdn_train1
                p-train2 = xdn_train2
                p-train3 = xdn_train3
                p-train4 = xdn_train4
                p-train5 = xdn_train5
                p-page1  = xdn_page1
                p-page2  = xdn_page2
                p-page3  = xdn_page3
                p-page4  = xdn_page4
                p-page5  = xdn_page5
                p-page6  = xdn_page6.
        end.
        else do:
                assign
                p-name   = ""
                p-prev   = ""
                p-next   = ""
                p-isonbr = ""
                p-isover = ""
                p-desc1  = ""
                p-desc2  = ""
                p-desc3  = ""
                p-desc4  = ""
                p-desc5  = ""
                p-train1 = ""
                p-train2 = ""
                p-train3 = ""
                p-train4 = ""
                p-train5 = ""
                p-page1  = ""
                p-page2  = ""
                p-page3  = ""
                p-page4  = ""
                p-page5  = ""
                p-page6  = "".
        end.

    display

           p-name
           p-prev
           p-next
           p-isonbr
           p-isover
           p-desc1
           p-desc2
           p-desc3
           p-desc4
           p-desc5
           p-train1
           p-train2
           p-train3
           p-train4
           p-train5
           p-page1
           p-page2
           p-page3
           p-page4
           p-page5
           p-page6
       with frame a.

    repeat:
     update p-prev
     with frame a editing:
       {mfnp.i xdn_ctrl p-type xdn_type p-prev xdn_prev xdn_nbr}
             if recno <> ? then do:
                assign
                    p-type   = xdn_type
                    p-name   = xdn_name
                    p-prev   = xdn_prev
                    p-next   = xdn_next
                    p-isonbr = xdn_isonbr
                    p-isover = xdn_isover
                    p-desc1  = xdn_desc1
                    p-desc2  = xdn_desc2
                    p-desc3  = xdn_desc3
                    p-desc4  = xdn_desc4
                    p-desc5  = xdn_desc5
                    p-train1 = xdn_train1
                    p-train2 = xdn_train2
                    p-train3 = xdn_train3
                    p-train4 = xdn_train4
                    p-train5 = xdn_train5
                    p-page1  = xdn_page1
                    p-page2  = xdn_page2
                    p-page3  = xdn_page3
                    p-page4  = xdn_page4
                    p-page5  = xdn_page5
                    p-page6  = xdn_page6.

                display
                    p-name
                    p-prev
                    p-next
                    p-isonbr
                    p-isover
                    p-desc1
                    p-desc2
                    p-desc3
                    p-desc4
                    p-desc5
                    p-train1
                    p-train2
                    p-train3
                    p-train4
                    p-train5
                    p-page1
                    p-page2
                    p-page3
                    p-page4
                    p-page5
                    p-page6
                    with frame a.
             end. /*recno <> ? */
       end. /*editing*/

        if p-prev = "" then do:
           message "错误：前辍不能为空. 请重新输入".
           undo, retry.
        end.
        find first xdn_ctrl where xdn_ctrl.xdn_domain = global_domain
               and xdn_type = p-type and xdn_prev = p-prev no-lock no-error.
        if available xdn_ctrl then do:
           assign
                p-type   = xdn_type
                p-name   = xdn_name
                p-prev   = xdn_prev
                p-next   = xdn_next
                p-isonbr = xdn_isonbr
                p-isover = xdn_isover
                p-desc1  = xdn_desc1
                p-desc2  = xdn_desc2
                p-desc3  = xdn_desc3
                p-desc4  = xdn_desc4
                p-desc5  = xdn_desc5
                p-train1 = xdn_train1
                p-train2 = xdn_train2
                p-train3 = xdn_train3
                p-train4 = xdn_train4
                p-train5 = xdn_train5
                p-page1  = xdn_page1
                p-page2  = xdn_page2
                p-page3  = xdn_page3
                p-page4  = xdn_page4
                p-page5  = xdn_page5
                p-page6  = xdn_page6.
        end.
        else do:
                p-next   = "00001" .
            assign
                p-isonbr = ""
                p-isover = ""
                p-desc1  = ""
                p-desc2  = ""
                p-desc3  = ""
                p-desc4  = ""
                p-desc5  = ""
                p-train1 = ""
                p-train2 = ""
                p-train3 = ""
                p-train4 = ""
                p-train5 = ""
                p-page1  = ""
                p-page2  = ""
                p-page3  = ""
                p-page4  = ""
                p-page5  = ""
                p-page6  = "".

        end.
            display
                p-name
                p-prev
                p-next
                p-isonbr
                p-isover
                p-desc1
                p-desc2
                p-desc3
                p-desc4
                p-desc5
                p-train1
                p-train2
                p-train3
                p-train4
                p-train5
                p-page1
                p-page2
                p-page3
                p-page4
                p-page5
                p-page6
            with frame a.

      ststatus = stline[2].
            status input ststatus.
    update
           p-name
           p-next
           p-isonbr
           p-isover
           p-desc1
           p-desc2
           p-desc3
           p-desc4
           p-desc5
           p-train1
           p-train2
           p-train3
           p-train4
           p-train5
           p-page1
           p-page2
           p-page3
           p-page4
           p-page5
           p-page6
   go-on(F5 CTRL-D) with frame a.

        if p-next = "" then do:
           message "错误：下一个单号不能为空,请重新输入".
           undo, retry.
        end.

  if lastkey = keycode("F5") or lastkey = keycode("CTRL-D") then do:
           del-yn = yes.
           {mfmsg01.i 11 1 del-yn}
           if del-yn then do:
           find first xdn_ctrl where xdn_ctrl.xdn_domain = global_domain
                  and xdn_type = p-type no-error.
         if available xdn_ctrl then do:
                        delete xdn_ctrl.
         end.
            clear frame a.
            p-name = "" .
            p-next = "00001".
            p-prev = "" .
            assign
                p-isonbr = ""
                p-isover = ""
                p-desc1  = ""
                p-desc2  = ""
                p-desc3  = ""
                p-desc4  = ""
                p-desc5  = ""
                p-train1 = ""
                p-train2 = ""
                p-train3 = ""
                p-train4 = ""
                p-train5 = ""
                p-page1  = ""
                p-page2  = ""
                p-page3  = ""
                p-page4  = ""
                p-page5  = ""
                p-page6  = "".

    display
           p-name
           p-prev
           p-next
           p-isonbr
           p-isover
           p-desc1
           p-desc2
           p-desc3
           p-desc4
           p-desc5
           p-train1
           p-train2
           p-train3
           p-train4
           p-train5
           p-page1
           p-page2
           p-page3
           p-page4
           p-page5
           p-page6
       with frame a.

           end.
  end.
  else do: /*f5*/

      display
           p-name
           p-prev
           p-next
           p-isonbr
           p-isover
           p-desc1
           p-desc2
           p-desc3
           p-desc4
           p-desc5
           p-train1
           p-train2
           p-train3
           p-train4
           p-train5
           p-page1
           p-page2
           p-page3
           p-page4
           p-page5
           p-page6
       with frame a.

     find first xdn_ctrl where xdn_ctrl.xdn_domain = global_domain
            and xdn_type = p-type no-error.
     if not available xdn_ctrl then do:
        create xdn_ctrl.
        assign
               xdn_domain = global_domain
               xdn_type   = upper(p-type)
               xdn_prev   = upper(p-prev)
               xdn_name   = p-name
               xdn_next   = p-next
               xdn_isonbr = p-isonbr
               xdn_isover = p-isover
               xdn_desc1  = p-desc1
               xdn_desc2  = p-desc2
               xdn_desc3  = p-desc3
               xdn_desc4  = p-desc4
               xdn_desc5  = p-desc5
               xdn_train1 = p-train1
               xdn_train2 = p-train2
               xdn_train3 = p-train3
               xdn_train4 = p-train4
               xdn_train5 = p-train5
               xdn_page1  = p-page1
               xdn_page2  = p-page2
               xdn_page3  = p-page3
               xdn_page4  = p-page4
               xdn_page5  = p-page5
               xdn_page6  = p-page6 .

     end.
     else do:
           assign
                xdn_domain = global_domain
                xdn_type   = upper(p-type)
                xdn_prev   = upper(p-prev)
                xdn_name   = p-name
                xdn_next   = p-next
                xdn_isonbr = p-isonbr
                xdn_isover = p-isover
                xdn_desc1  = p-desc1
                xdn_desc2  = p-desc2
                xdn_desc3  = p-desc3
                xdn_desc4  = p-desc4
                xdn_desc5  = p-desc5
                xdn_train1 = p-train1
                xdn_train2 = p-train2
                xdn_train3 = p-train3
                xdn_train4 = p-train4
                xdn_train5 = p-train5
                xdn_page1  = p-page1
                xdn_page2  = p-page2
                xdn_page3  = p-page3
                xdn_page4  = p-page4
                xdn_page5  = p-page5
                xdn_page6  = p-page6 .
     end.
        end. /*f5*/
  leave.
   end.
end. /*mainloop*/

status input.
