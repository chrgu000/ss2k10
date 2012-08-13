TRIGGER PROCEDURE FOR ASSIGN OF xxqad_ctrl.xxqad_basic1.

/*���ͬ����־Ϊ"1" ����������ͬ��,�����˳�����*/
if xxqad_basic1 = "1" then do:

/*��ʼ��*/
for each xxad_mstr :  delete xxad_mstr.    end.

/*����Ƚ� ad_mstr, �õ��������޸ĵļ�¼*/
for each ad_mstr no-lock:

    find first xxad2_mstr where xxad2_addr = ad_addr no-error.
    if not avail xxad2_mstr then do:
       /*������������*/
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
	      xxad_flg   = "A".    /*����*/

       /*ͬ�����±��ݱ�*/
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

            /*������������*/
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
	      xxad_flg   = "C".    /*�޸�*/

            /*ͬ�����±��ݱ�*/
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


/*����Ƚ�ԭ����ɾ��������*/
find first xxad2_mstr no-error.
repeat:
    do transaction:

    if not avail xxad2_mstr then leave.
    find first ad_mstr where ad_addr = xxad2_addr no-lock no-error.
    if not avail ad_mstr then do:
       create xxad_mstr.
       assign xxad_addr  = xxad2_addr
	      xxad_flg   = "D".    /*ɾ�� Delete*/

       delete xxad2_mstr.  /*Delete*/
    end.  /*if not avail ad_mstr*/

    find next xxad2_mstr no-error.
    end.  /*transaction*/
end.  /*repeat*/

/*�޸�xxqad_ctrl�еı�־λ,��־Ϊ�����*/
do transaction:
xxqad_basic1 = "2".
end.
end.  /*if xxqad_basic1 = "1"*/

