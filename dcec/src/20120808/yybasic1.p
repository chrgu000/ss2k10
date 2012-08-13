TRIGGER PROCEDURE FOR ASSIGN OF xxqad_ctrl.xxqad_basic1.

/*如果同步标志为"1" 则启动增量同步,否则退出程序*/
if xxqad_basic1 = "1" then do:

/*初始化*/
for each xxad_mstr :  delete xxad_mstr.    end.

/*正向比较 ad_mstr, 得到新增和修改的记录*/
for each ad_mstr no-lock:

    find first xxad2_mstr where xxad2_addr = ad_addr no-error.
    if not avail xxad2_mstr then do:
       /*创建增量数据*/
       create xxad_mstr.
       assign xxad_addr  = ad_addr
              xxad_name  = ad_name
	      xxad_line1 = ad_line1
	      xxad_line2 = ad_line2
	      xxad_city  = ad_city
	      xxad_state = ad_state
	      xxad_zip   = ad_zip
	      xxad_type  = ad_type
	      xxad_attn  = ad_attn
	      xxad_phone = ad_phone
	      xxad_flg   = "A".    /*新增*/

       /*同步更新备份表*/
       create xxad2_mstr.
       assign xxad2_addr  = ad_addr
              xxad2_name  = ad_name
	      xxad2_line1 = ad_line1
	      xxad2_line2 = ad_line2
	      xxad2_city  = ad_city
	      xxad2_state = ad_state
	      xxad2_zip   = ad_zip
	      xxad2_type  = ad_type
	      xxad2_attn  = ad_attn
	      xxad2_phone = ad_phone.
    end.  /*if not avail xxad2_mstr*/
    else do:
         if xxad2_name  <> ad_name  or
	    xxad2_line1 <> ad_line1 or
	    xxad2_line2 <> ad_line2 or 
	    xxad2_city  <> ad_city  or
	    xxad2_state <> ad_state or
	    xxad2_zip   <> ad_zip   or
	    xxad2_type  <> ad_type  or
	    xxad2_attn  <> ad_attn  or
	    xxad2_phone <> ad_phone then do:

            /*创建增量数据*/
            create xxad_mstr.
	    assign xxad_addr  = ad_addr
              xxad_name  = ad_name
	      xxad_line1 = ad_line1
	      xxad_line2 = ad_line2
	      xxad_city  = ad_city
	      xxad_state = ad_state
	      xxad_zip   = ad_zip
	      xxad_type  = ad_type
	      xxad_attn  = ad_attn
	      xxad_phone = ad_phone
	      xxad_flg   = "C".    /*修改*/

            /*同步更新备份表*/
            assign xxad2_name  = ad_name
	      xxad2_line1 = ad_line1
	      xxad2_line2 = ad_line2
	      xxad2_city  = ad_city
	      xxad2_state = ad_state
	      xxad2_zip   = ad_zip
	      xxad2_type  = ad_type
	      xxad2_attn  = ad_attn
	      xxad2_phone = ad_phone.

         end.  /*Change*/
    end.  /* avail xxad2_mstr*/
end.  /*for each ad_mstr */


/*方向比较原表已删除的数据*/
find first xxad2_mstr no-error.
repeat:
    do transaction:

    if not avail xxad2_mstr then leave.
    find first ad_mstr where ad_addr = xxad2_addr no-lock no-error.
    if not avail ad_mstr then do:
       create xxad_mstr.
       assign xxad_addr  = xxad2_addr
	      xxad_flg   = "D".    /*删除 Delete*/

       delete xxad2_mstr.  /*Delete*/
    end.  /*if not avail ad_mstr*/

    find next xxad2_mstr no-error.
    end.  /*transaction*/
end.  /*repeat*/

/*修改xxqad_ctrl中的标志位,标志为已完成*/
do transaction:
xxqad_basic1 = "2".
end.
end.  /*if xxqad_basic1 = "1"*/

