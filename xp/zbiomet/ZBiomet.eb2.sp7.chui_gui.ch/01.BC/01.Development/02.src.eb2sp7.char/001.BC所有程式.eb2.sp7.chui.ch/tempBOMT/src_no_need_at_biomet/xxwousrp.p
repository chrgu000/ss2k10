/* REVISION: eb    BY: Micho Yang  Date: 09/05/05    */
 {mfdtitle.i "a+ "}

define var  wo_lot_yn like mfc_logical init yes .
define var nbr like wo_nbr.
define var nbr1 like wo_nbr.

define var  lot_wo_yn like mfc_logical init no .
define var part like wo_part.
define var part1 like wo_part.
define var lot2 like tr_serial.
define var lot1 like tr_serial.
define var v_flag like mfc_logical.
define var wpo like po_nbr.
define var wrm like tr_lot.
define var SUMISSQTY like tr_qty_loc.

define buffer trhist for tr_hist.

Form
     wo_lot_yn label  "1. �q�LWO�d��LOT���"    colon  25
     skip(1)
     nbr      colon  20
     nbr1    colon  50
     skip(1)
     lot_wo_yn label "2. �q�LLOT�d��WO���"      colon  25
     skip(1)
     part     colon  20
     lot2       label "�帹"  colon  20 
     skip(1)
      
   "�ϥΤ�k:  1) �Τ��ܨ䤤���@�Ӭd�ߤ覡                             " at 2 skip
   "           2) �p�G��ܲ�2�جd�ߤ覡�A�N�@�w�n��J�d�߱���            " at 2 skip
   "           3) �ӳ�����s����MFG/PRO���                            " at 2 skip(1)
with frame a side-labels .

         /* SET EXTERNAL LABELS */
         setFrameLabels(frame a:handle).

/*K0PW*/ {wbrp01.i}

repeat:

           if nbr1 = hi_char then nbr1 = "".
	    
           update
	           wo_lot_yn 
		   lot_wo_yn  
           with frame a. 

	   if lot_wo_yn = yes and wo_lot_yn = yes then do:
               message "�����ܨ�̤����@�Ӭ�""YES"",�Э��s��ܱ���! "
                              view-as alert-box INFORMATION BUTTONS OK  TITLE  "Message"   .
               undo , retry .
           end .   /* if lot_wo_yn = yes and wo_lot_yn = yes */

	   if wo_lot_yn = YES then do:
               update
	                   nbr
			   nbr1 
			   with frame a.
	   end. /* if wo_lot_yn = yes */


	   if lot_wo_yn = YES then do:  
	       loopb:
	       repeat:
                   update
	                   part
			   lot2
			   with frame a.

		if part = "" or  lot2 = ""  then do:
                    message "�п�J��ܱ���! "
                            view-as alert-box INFORMATION BUTTONS OK  TITLE  "Message"   .
                    undo loopb  ,retry loopb  .
		end. 
		leave.
		end.
	   end. /* if lot_wo_yn = yes */

            {mfquoter.i wo_lot_yn   }
            {mfquoter.i nbr     }
            {mfquoter.i nbr1   }
            {mfquoter.i lot_wo_yn   }
            {mfquoter.i part     }
            {mfquoter.i lot2    }

            if  nbr1 = "" then nbr1 = hi_char.

            /* SELECT PRINTER */
            {mfselbpr.i "printer" 132}
            {mfphead.i}

  if wo_lot_yn = yes and lot_wo_yn = no then do:
      put "<< �H�U���u��ϥα��p��� >>" at 1 skip .
     for each tr_hist where  tr_nbr >= nbr and tr_nbr <= nbr1 and tr_type = "ISS-WO"  use-index tr_nbr_eff  no-lock  :
         wpo = "".
	 wrm = "".

         if length(tr_hist.tr_serial) = 13 then  do: 
            find first trhist where trhist.tr_serial = tr_hist.tr_serial  and trhist.tr_type = "RCT-PO" and trhist.tr_part = tr_hist.tr_part use-index tr_serial no-lock no-error.
            if available trhist then do:
	       wpo = trhist.tr_nbr.
	       wrm = trhist.tr_lot.
	    end.
	 end.

	 display 
	                  tr_hist.tr_effdate column-label "�o�Ƥ��"
			  tr_hist.tr_nbr     column-label "�u��"
			  tr_hist.tr_lot     column-label "ID"
			  tr_hist.tr_part    column-label "�Ƹ�"
			  tr_hist.tr_serial  column-label "�帹"
			  -(tr_hist.tr_qty_loc) column-label "�o�Ƽƶq"
			  wpo  column-label "���ʳ�"
			  wrm  column-label "RM ��"

		         with width 200    .	 
      end. /* for each tr_hist */
  end.  /* if wo_lot_yn = yes */

  if lot_wo_yn = yes and wo_lot_yn = no then do:
       put "<< �H�U�����ʦ��f��� >>" at 1 skip .
      for each tr_hist where  tr_part  = part  and tr_serial = lot2   and tr_type = "RCT-PO"  use-index tr_serial no-lock  :
           find first ad_mstr where ad_addr = tr_addr no-lock no-error.
	   if available ad_mstr then do:
		  display 
	                  tr_hist.tr_addr	column-label "������"
                          ad_name		column-label "�W��"
			  tr_hist.tr_nbr	column-label "���ʳ�"
			  tr_hist.tr_lot	column-label "RM ��"
 			  tr_hist.tr_part	column-label "�ƫ~"
			  tr_hist.tr_effdate	column-label "���f���"
			  tr_hist.tr_serial     column-label "�帹"
			  tr_hist.tr_qty_loc	column-label "���f�ƶq" at 117
		         with  width 200    .	

	   end. /*  if available ad_mstr */ 
     end. /* for each */

     SUMISSQTY = 0.
     put  SKIP(1) "<< �H�U���u��ϥα��p��� >>" at 1 skip .
     for each tr_hist where  tr_part  = part and tr_serial = lot2  and tr_type = "ISS-WO"  use-index tr_serial no-lock  :
         SUMISSQTY = SUMISSQTY - tr_hist.tr_qty_loc.

         find first wo_mstr where wo_lot =  tr_hist.tr_lot  no-lock no-error .
                  display 
	                  tr_hist.tr_effdate column-label "�o�Ƥ��" at 3
			  tr_hist.tr_nbr     column-label "�u��"
			  tr_hist.tr_lot     column-label "ID"
                 if available wo_mstr then wo_so_job else "" column-label "�P��q��"

		 if available wo_mstr then wo_part else "" column-label   "���~"  format "x(18)"
			  tr_hist.tr_part    column-label "�Ƹ�"
			  tr_hist.tr_serial  column-label "�帹"
			  -(tr_hist.tr_qty_loc) column-label "�o�Ƽƶq"
			  SUMISSQTY          column-label "�֭p�ϥμƶq" at 117
		          with  width 200    .	

     end. /* for each tr_hist */


     put SKIP(1) "<< �H�U��-��L���-�ϥα��p��� >>" at 1 skip .
     for each tr_hist where  tr_part  = part and tr_serial = lot2  and ( tr_type <> "RCT-TR" and  tr_type <> "ISS-TR"   and 
                                                                         tr_type <> "RCT-PO" and  tr_type <> "ISS-WO" ) and
									 tr_qty_loc <> 0  use-index tr_serial no-lock  :

          SUMISSQTY = SUMISSQTY - tr_hist.tr_qty_loc.
                 display 
	                  tr_hist.tr_effdate column-label "������" at 3
			  tr_hist.tr_trnbr   column-label "������X"
			  tr_hist.tr_type    column-label "�������"
                          tr_hist.tr_userid  column-label "�B�zID"
			  tr_hist.tr_nbr     column-label "��ڸ��X"
			  tr_hist.tr_part    column-label "�Ƹ�"
			  tr_hist.tr_serial  column-label "�帹"
			  - tr_hist.tr_qty_loc column-label "����ƶq"
  			  SUMISSQTY          column-label "�֭p�ϥμƶq" at 117
	          with  width 200    .	

     end. /* for each tr_hist */




  end.   /* if lot_wo_yn = yes */



         /* REPORT TRAILER */
         {mfrtrail.i}

end. /* repeat */
/* REVISION: eb    BY: Micho Yang  Date: 09/05/05    */



 {mfdtitle.i "a+ "}

define var  wo_lot_yn like mfc_logical init yes .
define var nbr like wo_nbr.
define var nbr1 like wo_nbr.

define var  lot_wo_yn like mfc_logical init no .
define var part like wo_part.
define var part1 like wo_part.
define var lot2 like tr_serial.
define var lot1 like tr_serial.
define var v_flag like mfc_logical.
define var wpo like po_nbr.
define var wrm like tr_lot.
define var SUMISSQTY like tr_qty_loc.

define buffer trhist for tr_hist.

Form
     wo_lot_yn label  "1. ͨ��WO����LOT����"    colon  25
     skip(1)
     nbr      colon  20
     nbr1    colon  50
     skip(1)
     lot_wo_yn label "2. ͨ��LOT����WO����"      colon  25
     skip(1)
     part     colon  20
     lot2       label "����"  colon  20
 
     skip(1)
      
   "ʹ�÷���:  1) �û�ѡ�����е�һ����ѯ��ʽ                             " at 2 skip
   "           2) ���ѡ���2�ֲ�ѯ��ʽ����һ��Ҫ�����ѯ����            " at 2 skip
   "           3) �ñ��������κ�MFG/PRO����                            " at 2 skip(1)
with frame a side-labels .

         /* SET EXTERNAL LABELS */
         setFrameLabels(frame a:handle).

/*K0PW*/ {wbrp01.i}

repeat:

           if nbr1 = hi_char then nbr1 = "".
	    
           update
	           wo_lot_yn 
		   lot_wo_yn  
           with frame a. 

	   if lot_wo_yn = yes and wo_lot_yn = yes then do:
               message "֧��ѡ�������е�һ��Ϊ""YES"",������ѡ������! "
                              view-as alert-box INFORMATION BUTTONS OK  TITLE  "Message"   .
               undo , retry .
           end .   /* if lot_wo_yn = yes and wo_lot_yn = yes */

	   if wo_lot_yn = YES then do:
               update
	                   nbr
			   nbr1 
			   with frame a.
	   end. /* if wo_lot_yn = yes */


	   if lot_wo_yn = YES then do:
  
	       loopb:
	       repeat:
                   update
	                   part
			   lot2
			   with frame a.

		if part = "" or  lot2 = ""  then do:
                    message "������ѡ������! "
                            view-as alert-box INFORMATION BUTTONS OK  TITLE  "Message"   .
                    undo loopb  ,retry loopb  .
		end. 
		leave.
		end.
	   end. /* if lot_wo_yn = yes */

            {mfquoter.i wo_lot_yn   }
            {mfquoter.i nbr     }
            {mfquoter.i nbr1   }
            {mfquoter.i lot_wo_yn   }
            {mfquoter.i part     }
            {mfquoter.i lot2    }

            if  nbr1 = "" then nbr1 = hi_char.

            /* SELECT PRINTER */
            {mfselbpr.i "printer" 132}
            {mfphead.i}

  if wo_lot_yn = yes and lot_wo_yn = no then do:
      put "<< ����Ϊ����ʹ��������� >>" at 1 skip .
     for each tr_hist where  tr_nbr >= nbr and tr_nbr <= nbr1 and tr_type = "ISS-WO"  use-index tr_nbr_eff  no-lock  :
         wpo = "".
	 wrm = "".

         if length(tr_hist.tr_serial) = 13 then  do: 
            find first trhist where trhist.tr_serial = tr_hist.tr_serial  and trhist.tr_type = "RCT-PO" and trhist.tr_part = tr_hist.tr_part use-index tr_serial no-lock no-error.
            if available trhist then do:
	       wpo = trhist.tr_nbr.
	       wrm = trhist.tr_lot.
	    end.
	 end.

	 display 
	                  tr_hist.tr_effdate column-label "��������"
			  tr_hist.tr_nbr     column-label "����"
			  tr_hist.tr_lot     column-label "ID"
			  tr_hist.tr_part    column-label "�Ϻ�"
			  tr_hist.tr_serial  column-label "����"
			  -(tr_hist.tr_qty_loc) column-label "��������"
			  wpo  column-label "�ɹ���"
			  wrm  column-label "RM ��"

		         with width 200    .	 
      end. /* for each tr_hist */
  end. 
 /* if wo_lot_yn = yes */

  if lot_wo_yn = yes and wo_lot_yn = no then do:
       put "<< ����Ϊ�ɹ��ջ����� >>" at 1 skip .
      for each tr_hist where  tr_part  = part  and tr_serial = lot2   and tr_type = "RCT-PO"  use-index tr_serial no-lock  :
           find first ad_mstr where ad_addr = tr_addr no-lock no-error.
	   if available ad_mstr then do:
		  display 
	                  tr_hist.tr_addr	column-label "��Ӧ��"
                          ad_name		column-label "����"
			  tr_hist.tr_nbr	column-label "�ɹ���"
			  tr_hist.tr_lot	column-label "RM ��"
 			  tr_hist.tr_part	column-label "��Ʒ"
			  tr_hist.tr_effdate	column-label "�ջ�����"
			  tr_hist.tr_serial     column-label "����"
			  tr_hist.tr_qty_loc	column-label "�ջ�����" at 117
		         with  width 200    .	

	   end. /*  if available ad_mstr */ 
     end. /* for each */

     SUMISSQTY = 0.
     put  SKIP(1) "<< ����Ϊ����ʹ��������� >>" at 1 skip .
     for each tr_hist where  tr_part  = part and tr_serial = lot2  and tr_type = "ISS-WO"  use-index tr_serial no-lock  :
         SUMISSQTY = SUMISSQTY - tr_hist.tr_qty_loc.

         find first wo_mstr where wo_lot =  tr_hist.tr_lot  no-lock no-error .
                  display 
	                  tr_hist.tr_effdate column-label "��������" at 3
			  tr_hist.tr_nbr     column-label "����"
			  tr_hist.tr_lot     column-label "ID"
                 if available wo_mstr then wo_so_job else "" column-label "���۶���"

		 if available wo_mstr then wo_part else "" column-label   "��Ʒ"  format "x(18)"
			  tr_hist.tr_part    column-label "�Ϻ�"
			  tr_hist.tr_serial  column-label "����"
			  -(tr_hist.tr_qty_loc) column-label "��������"
			  SUMISSQTY          column-label "�ۼ�ʹ������" at 117
		          with  width 200    .	

     end. /* for each tr_hist */


     put SKIP(1) "<< ����Ϊ-��������-ʹ��������� >>" at 1 skip .
     for each tr_hist where  tr_part  = part and tr_serial = lot2  and ( tr_type <> "RCT-TR" and  tr_type <> "ISS-TR"   and 
                                                                         tr_type <> "RCT-PO" and  tr_type <> "ISS-WO" ) and
									 tr_qty_loc <> 0  use-index tr_serial no-lock  :

          SUMISSQTY = SUMISSQTY - tr_hist.tr_qty_loc.
                 display 
	                  tr_hist.tr_effdate column-label "��������" at 3
			  tr_hist.tr_trnbr   column-label "���׺���"
			  tr_hist.tr_type    column-label "��������"
                          tr_hist.tr_userid  column-label "����ID"
			  tr_hist.tr_nbr     column-label "���ݺ���"
			  tr_hist.tr_part    column-label "�Ϻ�"
			  tr_hist.tr_serial  column-label "����"
			  - tr_hist.tr_qty_loc column-label "��������"
  			  SUMISSQTY          column-label "�ۼ�ʹ������" at 117
	          with  width 200    .	

     end. /* for each tr_hist */




  end. 
  /* if lot_wo_yn = yes */



         /* REPORT TRAILER */
         {mfrtrail.i}

end. /* repeat */