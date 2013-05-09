/* By: Neil Gao Date: 20070103 ECO: * ss 20070103.1 * */
/* By: Neil Gao Date: 20070124 ECO: * ss 20070124.1 * */
/* BY: Micho Yang          DATE: 02/26/08  ECO: *SS - 20080226.1* */
/*By: Neil Gao 08/03/10 ECO: *SS 20080310* */
/* BY: Cosesa Yang          DATE: 11/28/12  ECO: *SS - 20121128.1* */
/* BY: Cosesa Yang          DATE: 12/03/12  ECO: *SS - 20121203.1* */
/* BY: Cosesa Yang          DATE: 12/04/12  ECO: *SS - 20121204.1* */
/* BY: Cosesa Yang          DATE: 12/05/12  ECO: *SS - 20121205.1* */
/* Revision: eb21sp7  BY: Cosesa Yang     DATE: 12/20/12  ECO: *SS - 20121220.1* */
/* Revision: eb21sp7  BY: Cosesa Yang     DATE: 12/21/12  ECO: *SS - 20121221.1* */
/* Revision: eb21sp7  BY: Cosesa Yang     DATE: 12/25/12  ECO: *SS - 20121225.1* */
/* Revision: eb21sp7  BY: Cosesa Yang     DATE: 12/26/12  ECO: *SS - 20121226.1* */
/* Revision: eb21sp7  BY: Cosesa Yang     DATE: 12/27/12  ECO: *SS - 20121227.1* */
/* $Revision: eb21sp7 BY: Cosesa Yang     DATE: 03/12/13  $ECO: *SS - 20130312.1* */
/* $Revision: eb21sp7  $BY: Cosesa Yang     $DATE: 03/29/13  $ECO: *SS - 20130329.1* */
/* SS - 20080222.1 - B */
/* 1)      ����������������:��Ʊ��,������ 
*/                                                                          
/* SS - 20080222.1 - E */
/*Modified By: Martin Tan 08/10/06 ECO: *RCUR* */

/* SS - 20120625.1 - B */
/* 1)      ���ӿͻ����� 
*/                                                                          
/* SS - 20120625.1 - E */
/*Modified By: Yu 25/06/12 ECO: *RCUR* */

/* SS - 20121128.1 - B */
/* ����˰���ͻ����Ƴ���Ϊ30λ�����˵������λ���������ڡ�������Ϲ�˾���� 
   δ���뷢Ʊ��ϸ����ɾ���ֶΣ��ͻ����� 
   �����뷢Ʊ��ϸ���к�˰����Ҫ��ȷ��ʾ��˰
   δ���뷢Ʊ��ϸ���в���ʾRS��ͷ�����۶���
   */
/* SS - 20121128.1 - E */
/* SS - 20121203.1 - B */
/*
δ��Ʊ���м����Ķ���
1�����˵�������ʾΪ��������
2�������˵�һ��������������ǰ��
3��ϵͳ������SI��Ʊ�Ĳ�Ӧ������ʾ��δ��Ʊ��ϸ���ϣ�ĿǰSI��Ʊֱ����7.9.5�˵�����
*/
/* SS - 20121203.1 - E */
/* SS - 20121204.1 - B */
/*������ͳһ����Ϊ����������Ӣ�ĵģ�
1��ORDER��Ϊ���۶���
2��CUR��Ϊ���� 
3������������ӵص� ����custǰ��
*/
/* SS - 20121204.1 - E */
/* SS - 20121220.1 - B */
/*
  ��˰����������
  121220.1 �ܶ�ȡС��λ���� round()ʵ��
   121227.1 ��˰�ܽ�� = ��� + round(˰��,2) - round(������,2) ��last����ֵ���㣩
   ��� = ��� + round(ÿ��۸� * ����,2)
   ˰�� = ˰�� + round((ÿ��۸� * ���� - ÿ��۸� * ���� * ������) ,2) * ˰��
   ������ = ������ + ÿ��۸� * ���� * ������
*/
/* SS - 20121220.1 - E 
{mfdtitle.i "130319.1 "}*/
{mfdtitle.i "130329.1 "}
define var v_nbr01 like xxrqm_nbr.
define var v_nbr02 like xxrqm_nbr.
define var cust    like so_cust.
define var cust1   like so_cust.
define var ship    like so_ship.
define var ship1   like so_ship.
define var date1   as   date.
define var date2   as   date.
define var po      like so_po.
define var po1     like so_po.
define var shipid  like abs_id.
define var shipid1 like abs_id.
define var v_price like sod_price format "->,>>>,>>9.99".
define var desc1 as char format "x(30)".
define var ifiv  as logical.
define var ifreq as logical.
define var v_qty like abs_qty .
define buffer absmstr for abs_mstr .
/*RCUR*/ define variable report_curr like so_curr no-undo.
/*RCUR*/ define variable base_price like sod_price no-undo.
/*RCUR*/ define variable curr_price like sod_price no-undo.
/*RCUR*/ define variable tv_price like sod_price no-undo.
/*RCUR*/ define variable et_rate1 like so_ex_rate no-undo.
/*RCUR*/ define variable et_rate2 like so_ex_rate2 no-undo.
/*RCUR*/ define variable mc-error-number as integer no-undo.
/*RCUR*/ define variable mc-seq as integer no-undo.
 def var mycustpart like cp_cust_part.
 /* SS - 20121128.1 - B */
 def var companyname as char format "x(80)" 
     init "                                                  �������ܽ���ҵ�����ڣ����޹�˾".
 def var adname    like ad_name format "x(30)".
 def var ptdesc1   like pt_desc1 format "x(30)".
 def var taxin     as char format "x(1)" init "N".
 def var taxprice like sod_price format "->,>>>,>>9.99" init 0 .
 def var zkprice   like sod_price format "->,>>>,>>9.99" init 0 .
 def var zkcount   like sod_price format "->,>>>,>>9.99" init 0 .
 def var replaced  like sod_price format "->,>>>,>>9.99" init 0 .
 def var listpr    like sod_price format "->,>>>,>>9.99" init 0 .
 def var listprqty  like sod_price format "->,>>>,>>9.99" init 0.
 /* SS - 20121128.1 - E */

 /* SS - 20121204.1 - B */
 def var sssite1 like sod_site init "nsza" .
 def var sssite2 like sod_site init "nsza" .
 def var ttlistpr  like sod_price format "->,>>>,>>9.99" init 0.
 def var ttlistprqty  like sod_price format "->,>>>,>>9.99" init 0.
def var total1225 like sod_price format "->,>>>,>>9.99" init 0.
def var zktotal  like sod_price init 0.
def var hstotal  like sod_price init 0.
 /* SS - 20121204.1 - B */

/* SS - 20080222.1 - B */
DEF VAR inv LIKE ih_inv_nbr.
DEF VAR inv1 LIKE ih_inv_nbr.
DEF VAR v1_nbr LIKE so_nbr.
DEF VAR v1_nbr1 LIKE so_nbr.
/* SS - 20080222.1 - E */
/* ss - 20130301.1 - b*/
def var v_go as logical.
/* ss - 20130301.1 - e*/

form 
   v_nbr01  colon 12 label "�����"
   v_nbr02  colon 46 label "��"
   /* SS - 20080222.1 - B */
   inv      COLON 12 LABEL "��Ʊ��"
   inv1     COLON 46 LABEL "��"
   /* SS - 20080222.1 - B */
   /* SS - 20121204.1 - B */
   sssite1  colon 12 label "�ص�"
   sssite2  colon 46 label "��"
   /* SS - 20121204.1 - E */
   cust     colon 12 label "����"
   cust1    colon 46 label "��"
   ship     colon 12 label "������"
   ship1    colon 46 label "��"
   /* SS - 20080222.1 - B */
   v1_nbr      COLON 12 LABEL "������"
   v1_nbr1     COLON 46 LABEL "��"
   /* SS - 20080222.1 - B */
   po       colon 12 label "�ɹ���"
   po1      colon 46 label "��"
   shipid   colon 12 label "���˵�"
   shipid1  colon 46 label "��"
   date1    colon 12 label "��������"
   date2    colon 46 skip(1)
   ifreq    colon 20 label "ֻ��ʾδ����"
   ifiv     colon 20 label "�ѿ���Ʊ"
/*RCUR*/ report_curr colon 20
   skip
with frame a side-label width 80.
setFrameLabels(frame a:handle).

repeat :
	 
   if v_nbr02 = hi_char then v_nbr02 = "".
   if cust1 = hi_char then cust1 = "".
   if ship1 = hi_char then ship1 = "".
   if po1 = hi_char  then po1 = "".
   if shipid1 = hi_char then shipid1 = "".
   if date1 = low_date  then date1 = ?.
   if date2 = hi_date   then date2 = ?.
   /* SS - 20080222.1 - B */
   IF inv1 = hi_char THEN inv1 = "" .
   IF v1_nbr1 = hi_char THEN v1_nbr1 = "" .
       /* SS - 20130319.1 - B */
        if  sssite2 = hi_char then sssite2 = "".
       /* SS - 20130319.1 - E */
   /* SS - 20080222.1 - B */
   update v_nbr01 v_nbr02
       /* SS - 20080222.1 - B */
       inv inv1 
       /* SS - 20080222.1 - B */
       /* SS - 20121204.1 - B */
        sssite1  sssite2
       /* SS - 20121204.1 - E */
       cust cust1 ship ship1 
       /* SS - 20080222.1 - B */
       v1_nbr v1_nbr1 
       /* SS - 20080222.1 - B */
       po po1 shipid shipid1 
       date1 date2 ifreq ifiv 
/*RCUR*/ report_curr    
       with frame a .

  form
        companyname no-label skip(1)
with frame b side-labels page-top WIDTH 320.

/* SET EXTERNAL LABELS */
setFrameLabels(frame b:handle).
       
   if date1 = ? then date1 = low_date.
   if date2 = ? then date2 = hi_date.
   if v_nbr02 = "" then v_nbr02 = hi_char.
   if cust1 = "" then cust1 = hi_char.
   if ship1 = "" then ship1 = hi_char.
   if po1 = ""  then po1 = hi_char.
   if shipid1 = "" then shipid1 = hi_char.
   /* SS - 20080222.1 - B */
   IF inv1 = "" THEN inv1 = hi_char.
   IF v1_nbr1 = "" THEN v1_nbr1 = hi_char.
   /* SS - 20080222.1 - E */
       /* SS - 20130319.1 - B */
        if sssite2 = "" then sssite2 = hi_char.
       /* SS - 20130319.1 - E */
   
 {mfselprt.i "printer" 320}

/*RCUR*/ if report_curr = "" then report_curr = base_curr.
 display companyname with frame b.
 if not ifreq then do:  
  if not ifiv then do: 
   for each xxrqm_mstr where ( xxrqm_nbr >= v_nbr01 and xxrqm_nbr <= v_nbr02 ) 
            /* SS - 20121204.1 - B */
	    and (xxrqm_site >= sssite1 and xxrqm_site <= sssite2 )
	    /* SS - 20121204.1 - E */
	    and ( xxrqm_cust >= cust and xxrqm_cust <= cust1 ) 
            and ( xxrqm_req_date >= date1 and xxrqm_req_date <= date2 )
            /* SS - 20080222.1 - B */
            AND xxrqm_inv_nbr >= inv 
            AND xxrqm_inv_nbr <= inv1
            /* SS - 20080222.1 - B */
            and not xxrqm_invoiced 
            no-lock ,            
       each xxabs_mstr where xxrqm_nbr = xxabs_nbr  
             and (xxabs_par_id >= "s" + shipid and xxabs_par_id <= "s" + shipid1 ) no-lock ,
       each abs_mstr where abs_shipfrom = xxabs_shipfrom and abs_id = xxabs_id no-lock,
       each absmstr  where absmstr.abs_shipfrom = xxabs_shipfrom 
            and absmstr.abs_id = abs_mstr.abs_par_id 
            and absmstr.abs_shipto >= ship and absmstr.abs_shipto <= ship1 no-lock,
       first sod_det where sod_nbr = xxabs_order 
             and sod_line = int(xxabs_line)
             /* SS - 20080222.1 - B */
             AND sod_nbr >= v1_nbr 
             AND sod_nbr <= v1_nbr1
             /* SS - 20080222.1 - B */
             no-lock ,
       first so_mstr where sod_nbr = so_nbr 
             and ( so_po >= po and so_po <= po1 ) no-lock       
       /*first pt_mstr where pt_part = sod_part no-lock */ 
             break by xxrqm_nbr :
             
       find first pt_mstr where pt_part = sod_part no-lock no-error.
            if avail pt_mstr then desc1 = pt_desc1 + pt_desc2 .
               else desc1 = sod_desc .
               
/*RCUR* **********************************************/ 
	/* curr_price = sod_price * xxabs_ship_qty / sod_um_conv.  */ /*���׽��*/
	curr_price = round(sod_price * xxabs_ship_qty / sod_um_conv , 2). 
	base_price = curr_price.
	
	if so_curr <> report_curr
	then do:
           if so_curr <> base_curr 
           then do:
               {gprunp.i "mcpl" "p" "mc-curr-conv"
                  "(input base_curr,
                    input report_curr,
                    input so_ex_rate,
                    input so_ex_rate2,
                    input curr_price,
                    input false,   /* NOT ROUND */
                    output base_price,
                    output mc-error-number)"}
               if mc-error-number <> 0
               then do:
                  {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
               end.           
           end. /*if so_curr <> base_curr*/ /*תΪ�������ҽ��*/
           
	   /*������Ҳ����ڻ������ң���Ҫת��Ϊ�������*/           
           if report_curr <> base_curr
           then do:
		/*��ȡ���������������ҵĶһ���*/
		{gprunp.i "mcpl" "p" "mc-create-ex-rate-usage"
                       "(input report_curr,
                         input base_curr,
                         input "" "",
                         input xxrqm_inv_date,
                         output et_rate2,
                         output et_rate1,
                         output mc-seq,
                         output mc-error-number)"}
               if mc-error-number <> 0
               then do:
                  {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
               end.                          
		
		/*����������תΪ������ҽ��*/
               {gprunp.i "mcpl" "p" "mc-curr-conv"
                  "(input report_curr,
                    input base_curr,
                    input et_rate1,
                    input et_rate2,
                    input base_price,
                    input false,   /* NOT ROUND */
                    output base_price,
                    output mc-error-number)"}
               if mc-error-number <> 0
               then do:
                  {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
               end.           
           end. /*if report_curr <> base_curr*/          
	end. /*if so_curr <> report_curr*/
/*	
	if report_curr <> base_curr
	then base_price = curr_price.
*/
       accumulate base_price (total by xxrqm_nbr).
	
/*RCUR* **********************************************/               

       accumulate sod_price * xxabs_ship_qty / sod_um_conv
                  (total by xxrqm_nbr) .   

       /* SS - 20121128.1 - B */

          /* taxin = "N" . */
	  taxprice = 0 .
       if xxrqm_site = "nsza" then do:
         /* taxin = "Y" . */
	  taxprice = 0.17 .
	  end.
	  
	/* SS - 20121227.1 - B */
	zkprice = round((sod_list_pr / sod_um_conv ) , 2) 
	          - round((sod_list_pr / sod_um_conv * sod_disc_pct / 100) , 2) .
	replaced = (sod_price * xxabs_ship_qty / sod_um_conv 
	           - sod_price / sod_um_conv * (sod_disc_pct / 100) * xxabs_ship_qty) .  
	ttlistpr = sod_price / sod_um_conv - sod_price / sod_um_conv * (so_disc_pct / 100) + 
	           round((sod_price / sod_um_conv - sod_price / sod_um_conv * so_disc_pct / 100) , 2) * taxprice .
	ttlistprqty = round(sod_price * xxabs_ship_qty / sod_um_conv , 2) + 
	              round((sod_price / sod_um_conv * xxabs_ship_qty
		      - sod_price / sod_um_conv * xxabs_ship_qty * so_disc_pct / 100) , 2) * taxprice 
		      - sod_price / sod_um_conv * (so_disc_pct / 100) * xxabs_ship_qty .
		    
        accumulate (sod_price / sod_um_conv * xxabs_ship_qty
		    - sod_price / sod_um_conv * xxabs_ship_qty * so_disc_pct / 100) (total by xxrqm_nbr) . 
	accumulate sod_price * xxabs_ship_qty / sod_um_conv * so_disc_pct / 100     (total by xxrqm_nbr) .    

       /* SS - 20121227.1 - E */
       
       find first cm_mstr no-lock where cm_addr = xxrqm_cust no-error.
	  if avail cm_mstr then do:
	      find first ad_mstr no-lock where ad_addr = cm_addr no-error.
	      if avail ad_mstr then adname = ad_name.
	  end.
       /* SS - 20121128.1 - E */

       disp /* xxrqm_nbr  label "�����" */
            xxrqm_req_date label "��������"
            xxrqm_rqby_userid COLUMN-LABEL "������"
            xxrqm_cust label "�ͻ�"
	    adname label "�ͻ�����"
         /* xxrqm_tax_in  label "˰" */
          /*xxrqm_invoiced label "����"
            xxrqm_inv_nbr label "��Ʊ��" */
            /* SS - 20080222.1 - B */
            xxrqm_inv_nbr label "��Ʊ��"
            /* SS - 20080222.1 - B */
            substring(xxabs_par_id,2) format "x(12)" label "���˵�"
            so_po label "�ɹ���"
            sod_nbr COLUMN-LABEL "���۶���"
          /*  sod_line label "���" */
            sod_part  label "�������"
	    desc1  label "���˵��" format "x(30)"
            xxabs_ship_qty format "->>>>>>>>>" label "��Ʊ����"
	    sod_um label "��λ"
            sod_price / sod_um_conv @ sod_price label "�۸�"  
/*RCUR*/    so_curr COLUMN-LABEL "�ұ�"
            sod_price * xxabs_ship_qty / sod_um_conv
            @ v_price label "���"   /*RCUR*/ format "->>,>>>,>>9.99"
	     /* SS - 20121128.1 - B */
	     /* SS - 20121221.1 - B */
	    zkprice format "->>,>>>,>>9.9999" @ zkprice label "�ۿ۵���" 
	    sod_list_pr / sod_um_conv * (so_disc_pct / 100) * xxabs_ship_qty format "->>,>>>,>>9.99" @ zkcount label "�������" 
	    replaced format "->>,>>>,>>9.99" @ replaced label "�ۿۺ���" 
	    /* SS - 20121221.1 - E */
	    so_disc_pct label "����%"  
	    /* SS - 20121219.1 - B */
	    ttlistpr format "->>,>>>,>>9.9999" @ listpr label "��˰����"
	    ttlistprqty format "->>,>>>,>>9.99" @ listprqty label "��˰���"
	    /* SS - 20121219.1 - E */
	    /* SS - 20121128.1 - E */
/*RCUR*/    base_price format "->>,>>>,>>9.99" label "�������"
            with width 320.
            down .
        if last-of( xxrqm_nbr ) then do:
           /* SS - 20121227.1 - B */
	   zktotal = ( accum total by xxrqm_nbr 
	               (sod_price * xxabs_ship_qty / sod_um_conv * so_disc_pct / 100) ).
           hstotal = ( accum total by xxrqm_nbr 
	               (sod_price / sod_um_conv * xxabs_ship_qty
		        - sod_price / sod_um_conv * xxabs_ship_qty * so_disc_pct / 100) ).
	   zktotal = round(zktotal,2).
	   hstotal = round(hstotal * taxprice , 2).
	   total1225 = ( accum total by xxrqm_nbr 
                       ( sod_price * xxabs_ship_qty / sod_um_conv ) ).
	   total1225 = round(total1225 , 2).
           /* SS - 20121227.1 - E */

	   disp "  �ϼ� : "  @ sod_price  
             ( accum total by xxrqm_nbr 
                    ( sod_price * xxabs_ship_qty / sod_um_conv ) )
              @ v_price /*RCUR*/ format "->>,>>>,>>9.99" 
	   
            /* SS - 20121205.1 - B */
	    (total1225 + hstotal - zktotal) @ listprqty format "->>,>>>,>>9.99" 
	    /* SS - 20121205.1 - E */
/*RCUR*/    ( accum total by xxrqm_nbr base_price) @ base_price format "->>,>>>,>>9.99" .
           down 1 .           
        end. 
        if last( xxrqm_nbr ) then do:
           /* SS - 20121227.1 - B */
	   zktotal = ( accum total (sod_price * xxabs_ship_qty / sod_um_conv * so_disc_pct / 100) ).
           hstotal = ( accum total (sod_price / sod_um_conv * xxabs_ship_qty
		        - sod_price / sod_um_conv * xxabs_ship_qty * so_disc_pct / 100) ).
	   zktotal = round(zktotal,2).
	   hstotal = round(hstotal * taxprice , 2).
	   total1225 = ( accum total ( sod_price * xxabs_ship_qty / sod_um_conv ) ).
	   total1225 = round(total1225 , 2).
           /* SS - 20121227.1 - E */
		 
		 down 1.
           put  report_curr  "           �ܺϼ�:           "
/*RCUR**    ( accum total ( sod_price * xxabs_ship_qty / sod_um_conv ) )  /*RCUR*/ format "->>,>>>,>>9.99<<"  */
/*RCUR*/    ( accum total base_price ) format "->>,>>>,>>9.99" at 60     
            /* SS - 20121204.1 - B */
	    "                  ��˰�ܽ�     " 
	    (total1225 + hstotal - zktotal) format "->>,>>>,>>9.99" 
	    /* SS - 20121204.1 - E */
            skip .
        end.
                                 
    end.
  end. /* if not ifiv */
  else do: /*�ѿ���Ʊ*/
  	for each xxrqm_mstr where ( xxrqm_nbr >= v_nbr01 and xxrqm_nbr <= v_nbr02 ) 
	    /* SS - 20121204.1 - B */
	    and (xxrqm_site >= sssite1 and xxrqm_site <= sssite2 )
	    /* SS - 20121204.1 - E */
            and ( xxrqm_cust >= cust and xxrqm_cust <= cust1 ) 
            and ( xxrqm_req_date >= date1 and xxrqm_req_date <= date2 )
            /* SS - 20080222.1 - B */
            AND xxrqm_inv_nbr >= inv 
            AND xxrqm_inv_nbr <= inv1
            /* SS - 20080222.1 - B */
            and  xxrqm_invoiced 
            no-lock ,            
       each xxabs_mstr where xxrqm_nbr = xxabs_nbr  
/*SS 20080310 - B*/
/*
             and (xxabs_par_id >= "s" + shipid and xxabs_par_id <= shipid1 ) no-lock ,
*/
             and (xxabs_par_id >= "s" + shipid and xxabs_par_id <= "S" + shipid1 ) no-lock,
/*SS 20080310 - E*/
       each abs_mstr where abs_shipfrom = xxabs_shipfrom and abs_id = xxabs_id no-lock,
       each absmstr  where absmstr.abs_shipfrom = xxabs_shipfrom 
            and absmstr.abs_id = abs_mstr.abs_par_id 
            and absmstr.abs_shipto >= ship and absmstr.abs_shipto <= ship1 no-lock,
       first idh_hist where idh_nbr = xxabs_order 
             /* SS - 20080222.1 - B */
             AND idh_nbr >= v1_nbr
             AND idh_nbr <= v1_nbr1
             /* SS - 20080222.1 - B */
             and idh_line = int(xxabs_line) and idh_inv_nbr = xxrqm_inv_nbr no-lock ,
       first ih_hist where idh_nbr = ih_nbr and ih_inv_nbr = xxrqm_inv_nbr
             and ( ih_po >= po and ih_po <= po1 ) no-lock       
       /*first pt_mstr where pt_part = sod_part no-lock */ 
             break by xxrqm_nbr :
       find first pt_mstr where pt_part = idh_part no-lock no-error.
            if avail pt_mstr then desc1 = pt_desc1 + pt_desc2 .
               else desc1 = idh_desc .

/*RCUR* **********************************************/ 
	/* curr_price = idh_price * xxabs_ship_qty / idh_um_conv. */ /*���׽��*/
	curr_price = round(idh_price * xxabs_ship_qty / idh_um_conv , 2 ). 
	base_price = curr_price.
	
	if ih_curr <> report_curr
	then do:
           if ih_curr <> base_curr 
           then do:
               {gprunp.i "mcpl" "p" "mc-curr-conv"
                  "(input base_curr,
                    input report_curr,
                    input ih_ex_rate,
                    input ih_ex_rate2,
                    input curr_price,
                    input false,   /* NOT ROUND */
                    output base_price,
                    output mc-error-number)"}
               if mc-error-number <> 0
               then do:
                  {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
               end.           
           end. /*if so_curr <> base_curr*/ /*תΪ�������ҽ��*/
           
	   /*������Ҳ����ڻ������ң���Ҫת��Ϊ�������*/           
           if report_curr <> base_curr
           then do:
		/*��ȡ���������������ҵĶһ���*/
		{gprunp.i "mcpl" "p" "mc-create-ex-rate-usage"
                       "(input report_curr,
                         input base_curr,
                         input "" "",
                         input xxrqm_inv_date,
                         output et_rate2,
                         output et_rate1,
                         output mc-seq,
                         output mc-error-number)"}
               if mc-error-number <> 0
               then do:
                  {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
               end.                          
		
		/*����������תΪ������ҽ��*/
               {gprunp.i "mcpl" "p" "mc-curr-conv"
                  "(input report_curr,
                    input base_curr,
                    input et_rate1,
                    input et_rate2,
                    input base_price,
                    input false,   /* NOT ROUND */
                    output base_price,
                    output mc-error-number)"}
               if mc-error-number <> 0
               then do:
                  {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
               end.           
           end. /*if report_curr <> base_curr*/   
           
	end. /*if ih_curr <> report_curr*/
	
	/*if ih_curr = report_curr 
	then base_price = curr_price. */
	
	accumulate base_price (total by xxrqm_nbr).
/*RCUR* **********************************************/    
               
       accumulate idh_price * xxabs_ship_qty / idh_um_conv
                  (total by xxrqm_nbr) .    
       
       /* SS - 20121128.1 - B */
       
        /*  taxin = "N" . */
	  taxprice = 0 .
       if xxrqm_site = "nsza" then do:
        /*  taxin = "Y" . */
	  taxprice = 0.17 .
	  end.

	/* SS - 20121205.1 - B */
	/* SS - 20121221.1 - B */
	zkprice = round( (idh_list_pr / idh_um_conv ) , 2 ) - round((idh_list_pr / idh_um_conv * idh_disc_pct / 100) , 2 ).
	replaced = idh_price * xxabs_ship_qty / idh_um_conv 
	           - idh_price / idh_um_conv * xxabs_ship_qty * (idh_disc_pct / 100) .           
	ttlistpr = idh_price / idh_um_conv - idh_price / idh_um_conv * (ih_disc_pct / 100)
	          + round((idh_price / idh_um_conv - idh_price / idh_um_conv * ih_disc_pct / 100) , 2) * taxprice.
	ttlistprqty = round(idh_price * xxabs_ship_qty / idh_um_conv , 2) + 
	              round((idh_price / idh_um_conv * xxabs_ship_qty
		    - idh_price / idh_um_conv * xxabs_ship_qty * ih_disc_pct / 100) , 2) * taxprice
		      - idh_price / idh_um_conv * xxabs_ship_qty * (ih_disc_pct / 100).
		    
        accumulate (idh_price / idh_um_conv * xxabs_ship_qty
		    - idh_price / idh_um_conv * xxabs_ship_qty * ih_disc_pct / 100) (total by xxrqm_nbr) . 
	accumulate idh_price * xxabs_ship_qty / idh_um_conv * ih_disc_pct / 100     (total by xxrqm_nbr) .    
       /* SS - 20121221.1 - E */
     /*  accumulate (round(( idh_list_pr * xxabs_ship_qty / idh_um_conv * (1 - ih_disc_pct / 100 ) ) , 2 )
          + round(( idh_list_pr * xxabs_ship_qty / idh_um_conv * taxprice  * (1 - ih_disc_pct / 100 ) ) , 2 )) (total by xxrqm_nbr) . 
        SS - 20121205.1 - E */

       find first cm_mstr no-lock where cm_addr = xxrqm_cust no-error.
	  if avail cm_mstr then do:
	      find first ad_mstr no-lock where ad_addr = cm_addr no-error.
	      if avail ad_mstr then adname = ad_name.
	  end.
	
       /* SS - 20121128.1 - E */
       
       disp /* xxrqm_nbr  label "�����" */
            xxrqm_req_date label "��������"
            xxrqm_rqby_userid COLUMN-LABEL "������"
            xxrqm_cust label "�ͻ�"
	    adname label "�ͻ�����" 
         /* xxrqm_tax_in  label "˰" */
          /*xxrqm_invoiced label "����" */
            xxrqm_inv_nbr label "��Ʊ��" 
            substring(xxabs_par_id,2) format "x(12)" label "���˵�" 
            ih_po label "�ɹ���"
            idh_nbr COLUMN-LABEL "���۶���"
          /*  idh_line label "���" */
            idh_part  label "�������"
	    desc1 label "���˵��"
            xxabs_ship_qty format "->>>>>>>>>" label "��Ʊ����"
	    idh_um label "��λ"
            idh_price / idh_um_conv @ sod_price label "�۸�" 
/*RCUR*/    ih_curr  COLUMN-LABEL "�ұ�"  
            idh_price * xxabs_ship_qty / idh_um_conv
            @ v_price label "���"   /*RCUR*/ format "->>,>>>,>>9.99"	    
	     /* SS - 20121128.1 - B */
	    zkprice format "->>,>>>,>>9.9999" @ zkprice label "�ۿ۵���" 
	    idh_list_pr / idh_um_conv * xxabs_ship_qty * (ih_disc_pct / 100) format "->>,>>>,>>9.99" @ zkcount label "�������" 
	    replaced format "->>,>>>,>>9.99" @ replaced label "�ۿۺ���" 
	    ih_disc_pct label "����%"
    	    ttlistpr  format "->>,>>>,>>9.9999" @ listpr label "��˰����"
	    ttlistprqty format "->>,>>>,>>9.99" @ listprqty label "��˰���"
	    /* SS - 20121128.1 - E */
/*RCUR*/    base_price format "->>,>>>,>>9.99" label "�������"
            with width 320 .
            down .
        if last-of( xxrqm_nbr ) then do:
	   /* SS - 20121227.1 - B */
	   zktotal = ( accum total by xxrqm_nbr 
	               (idh_price * xxabs_ship_qty / idh_um_conv * ih_disc_pct / 100) ).
           hstotal = ( accum total by xxrqm_nbr 
	               (idh_price / idh_um_conv * xxabs_ship_qty
		        - idh_price / idh_um_conv * xxabs_ship_qty * ih_disc_pct / 100) ).
	   zktotal = round(zktotal,2).
	   hstotal = round(hstotal * taxprice , 2).
	   total1225 = ( accum total by xxrqm_nbr 
                       ( idh_price * xxabs_ship_qty / idh_um_conv ) ).
	   total1225 = round(total1225 , 2).
           /* SS - 20121227.1 - E */
	   disp "  �ϼ� : "  @ sod_price  
             ( accum total by xxrqm_nbr 
                    ( idh_price * xxabs_ship_qty / idh_um_conv ) )
              @ v_price /*RCUR*/ format "->>,>>>,>>9.99"
	      
             /* SS - 20121204.1 - B */
	    (total1225 + hstotal - zktotal)  @ listprqty format "->>,>>>,>>9.99" 
	    /* SS - 20121204.1 - E */   

/*RCUR*/     ( accum total by xxrqm_nbr base_price) @ base_price format "->>,>>>,>>9.99" .         
           down 1.           
        end. 
        if last( xxrqm_nbr ) then do:
	   /* SS - 20121227.1 - B */
	   zktotal = ( accum total (idh_price * xxabs_ship_qty / idh_um_conv * ih_disc_pct / 100) ).
           hstotal = ( accum total (idh_price / idh_um_conv * xxabs_ship_qty
		        - idh_price / idh_um_conv * xxabs_ship_qty * ih_disc_pct / 100) ).
	   zktotal = round(zktotal,2).
	   hstotal = round(hstotal * taxprice , 2).
	   total1225 = ( accum total ( idh_price * xxabs_ship_qty / idh_um_conv ) ).
	   total1225 = round(total1225 , 2).
           /* SS - 20121227.1 - E */
        	 down 1.
           put report_curr "            �ܺϼ�:           "   
/*RCUR**     ( accum total ( idh_price * xxabs_ship_qty / idh_um_conv ) ) /*RCUR*/ format "->>,>>>,>>9.99<<" **/
/*RCUR*/    ( accum total base_price ) format "->>,>>>,>>9.99" at 60
            /* SS - 20121204.1 - B */
	    "                  ��˰�ܽ�     " 
	    (total1225 + hstotal - zktotal)  format "->>,>>>,>>9.99"
	    /* SS - 20121204.1 - E */
	    skip .
        end.
    end.
  end. /* else do: */
 end. /* if not ifreq */
 else do: /*ֻ��ʾδ������do*/
   for each absmstr use-index abs_shipto where 
       abs_shipto >= ship and abs_shipto  <= ship1
/*       and abs_shipfrom = "10000" */
       and ( abs_id >= "s" + shipid and  abs_id <= "s" + shipid1 ) 
       and abs_shp_date >= date1 and abs_shp_date <= date2 no-lock ,        
       each abs_mstr use-index abs_par_id where 
            abs_mstr.abs_shipfrom = absmstr.abs_shipfrom  and 
            absmstr.abs_id =  abs_mstr.abs_par_id 
	    /* SS - 20121204.1 - B */
	    and (abs_mstr.abs_site >= sssite1 and abs_mstr.abs_site <= sssite2 )
	    /* SS - 20121204.1 - E */
/*SS 20080310 - B*/
/*
            and abs_mstr.abs__chr01 = "" 
*/
/*SS 20080310 - E*/
            and abs_mstr.abs_ship_qty <> 0 no-lock ,  
       first so_mstr where so_nbr = abs_mstr.abs_order 
             and ( so_po >= po and so_po  <= po1 ) 
	     /* SS - 20121204.1 - B */
	     and ( so_site >= sssite1 and so_site <= sssite2 )
	     /* SS - 20121204.1 - E */
             and ( so_cust >= cust and so_cust <= cust1 )
             /* SS - 20080222.1 - B */
             AND so_nbr >= v1_nbr
             AND so_nbr <= v1_nbr1
             /* SS - 20080222.1 - B */
	     /* SS - 20121128.1 - B */
	     AND substring(so_nbr,1,2) <> "RS"
	     /* SS - 20121128.1 - E */
             no-lock ,     
       first sod_det where sod_nbr = abs_mstr.abs_order 
             and sod_line = int(abs_mstr.abs_line) no-lock 
             break by absmstr.abs_shipto /* SS - 20121205.1 */ by abs_mstr.abs_shp_date:      

        /* ss - 130312.1 -b */
	  v_go  = yes .
        for each ih_hist no-lock where ih_nbr = so_nbr
	    and substring(ih_inv_nbr,1,2) = "SI" , 
            each idh_hist where  idh_nbr = ih_nbr
      	     and idh_inv_nbr = ih_inv_nbr
      	     and idh_line = sod_line no-lock :
	     
	   find first tr_hist no-lock 
	  /*  where tr_nbr = so_nbr and tr_line = sod_line and substring(tr_rmks,1,2) = "SI" */
   	    where tr_rmks = ih_inv_nbr and tr_nbr = ih_nbr and tr_line = idh_line
	    and tr_ship_id = substring(abs_mstr.abs_par_id,2) no-error.
	     if avail tr_hist then do: 
              v_go = no .
	    end .     
	  end.
	   
	 if v_go then do:
	 /* ss - 130312.1 - e*/

/*       
       find first pt_mstr where pt_part = abs_mstr.abs_item no-lock no-error.
       if avail pt_mstr then desc1 = pt_desc1 + pt_desc2 .
          else desc1 = sod_desc . */
       v_qty = 0 .   
       for each xxabs_mstr where xxabs_id = abs_mstr.abs_id  
            and xxabs_shipfrom = abs_mstr.abs_shipfrom
            and xxabs_order = abs_mstr.abs_order 
            and xxabs_line  = abs_mstr.abs_line no-lock :          
            v_qty = v_qty + xxabs_mstr.xxabs_ship_qty .          
       end . 
       
         /* ss - 130312.1 -b */
	  end.
	 /* ss - 130312.1 - e*/

       find first xxabs_mstr where xxabs_id = abs_mstr.abs_id
          and xxabs_shipfrom =abs_mstr.abs_shipfrom
          and xxabs_order = abs_mstr.abs_order
          and xxabs_line  = abs_mstr.abs_line no-lock no-error . 

       if avail xxabs_mstr and not can-find( xxabs_mstr where
                xxabs_id = abs_mstr.abs_id
                and xxabs_shipfrom = abs_mstr.abs_shipfrom
                and xxabs_order = abs_mstr.abs_order
                and xxabs_line  = abs_mstr.abs_line 
                and xxabs_mstr.xxabs_canceled no-lock )
          then do :

	  /* ss - 130306.1 -b */
	  v_go  = yes .
        for each ih_hist no-lock where ih_nbr = so_nbr
	    and substring(ih_inv_nbr,1,2) = "SI" , 
            each idh_hist where  idh_nbr = ih_nbr
      	     and idh_inv_nbr = ih_inv_nbr
      	     and idh_line = sod_line no-lock :
	     
	   find first tr_hist no-lock 
	  /*  where tr_nbr = so_nbr and tr_line = sod_line and substring(tr_rmks,1,2) = "SI" */
   	    where tr_rmks = ih_inv_nbr and tr_nbr = ih_nbr and tr_line = idh_line
	    and tr_ship_id = substring(abs_mstr.abs_par_id,2) no-error.
	     if avail tr_hist then do: 
              v_go = no .
	    end .     
	  end.
	   
	 if v_go then do:
	   /* ss - 130306.1 - e*/

  /* SS - 20121128.1 - B */

        /*  taxin = "N" . */
	  taxprice = 0 .
       if sod_site = "nsza" then do:
         /* taxin = "Y" . */
	  taxprice = 0.17 .
	  end. 

          find first pt_mstr no-lock where pt_part = sod_part no-error.
	  if avail pt_mstr then ptdesc1 = pt_desc1.

	  find first cm_mstr no-lock where cm_addr = so_cust no-error.
	  if avail cm_mstr then do:
	      find first ad_mstr no-lock where ad_addr = cm_addr no-error.
	      if avail ad_mstr then adname = ad_name.
	  end.

   /* SS - 20121128.1 - E */

/*RCUR* **********************************************/ 
	/* curr_price = (abs_mstr.abs_ship_qty - v_qty )
                    * sod_price / sod_um_conv . /*���׽��*/
	*/
	curr_price = round((abs_mstr.abs_ship_qty - v_qty )
                    * sod_price / sod_um_conv , 2 ) . /*���׽��*/
	base_price = curr_price.
	
	if so_curr <> report_curr
	then do:
           if so_curr <> base_curr 
           then do:
               {gprunp.i "mcpl" "p" "mc-curr-conv"
                  "(input base_curr,
                    input report_curr,
                    input so_ex_rate,
                    input so_ex_rate2,
                    input curr_price,
                    input false,   /* NOT ROUND */
                    output base_price,
                    output mc-error-number)"}
               if mc-error-number <> 0
               then do:
                  {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
               end.           
           end. /*if so_curr <> base_curr*/ /*תΪ�������ҽ��*/
           
	   /*������Ҳ����ڻ������ң���Ҫת��Ϊ�������*/           
           if report_curr <> base_curr
           then do:
		/*��ȡ���������������ҵĶһ���*/
		{gprunp.i "mcpl" "p" "mc-create-ex-rate-usage"
                       "(input report_curr,
                         input base_curr,
                         input "" "",
                         input xxrqm_inv_date,
                         output et_rate2,
                         output et_rate1,
                         output mc-seq,
                         output mc-error-number)"}
               if mc-error-number <> 0
               then do:
                  {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
               end.                          
		
		/*����������תΪ������ҽ��*/
               {gprunp.i "mcpl" "p" "mc-curr-conv"
                  "(input report_curr,
                    input base_curr,
                    input et_rate1,
                    input et_rate2,
                    input base_price,
                    input false,   /* NOT ROUND */
                    output base_price,
                    output mc-error-number)"}
               if mc-error-number <> 0
               then do:
                  {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
               end.           
           end. /*if report_curr <> base_curr*/          
	end. /*if so_curr <> report_curr*/

	/*if so_curr = report_curr 
	then base_price = curr_price.*/
	
	tv_price = tv_price + base_price.
/*RCUR* **********************************************/              
         /* 
          v_price = v_price + (abs_mstr.abs_ship_qty - v_qty )
                    * sod_price / sod_um_conv .
		    */
          v_price = v_price + round((abs_mstr.abs_ship_qty - v_qty )
                    * sod_price / sod_um_conv  , 2 ).

          /* SS - 20121204.1 - B */
	  /* SS - 20121221.1 - B */
	  zkprice = round(( sod_list_pr / sod_um_conv ) , 2) - round(( sod_list_pr / sod_um_conv * sod_disc_pct / 100) , 2).
	  replaced = (abs_mstr.abs_ship_qty - v_qty ) * sod_price / sod_um_conv -
	             sod_price / sod_um_conv * (abs_mstr.abs_ship_qty - v_qty ) * (sod_disc_pct / 100).  
	  ttlistpr = sod_price / sod_um_conv - sod_price / sod_um_conv * so_disc_pct / 100
	            + taxprice * round((sod_price / sod_um_conv - sod_price / sod_um_conv * so_disc_pct / 100) , 2). 
	  ttlistprqty = round((abs_mstr.abs_ship_qty - v_qty )* sod_price / sod_um_conv  , 2 )
	               + taxprice * round((sod_price / sod_um_conv * (abs_mstr.abs_ship_qty - v_qty ) 
		    - sod_price / sod_um_conv * (abs_mstr.abs_ship_qty - v_qty ) * so_disc_pct / 100) , 2)
		       - sod_price * (abs_mstr.abs_ship_qty - v_qty ) / sod_um_conv * so_disc_pct / 100 .
                   
	  zktotal = zktotal + sod_price * (abs_mstr.abs_ship_qty - v_qty ) / sod_um_conv * so_disc_pct / 100  .
	 
	  hstotal = hstotal + taxprice * round((sod_price / sod_um_conv * (abs_mstr.abs_ship_qty - v_qty ) 
		    - sod_price / sod_um_conv * (abs_mstr.abs_ship_qty - v_qty ) * so_disc_pct / 100) , 2) .

	  listprqty = v_price .

	  /* SS - 20121221.1 - E */
	  /* SS - 20121204.1 - E */

/* SS - 20120625.1 - B */
/* 1)      ���ӿͻ����� 

          mycustpart = "".
          
          find first cp_mstr no-lock where cp_part = sod_part and cp_cust = so_cust no-error.
          if avail cp_mstr then do:
              mycustpart = cp_cust_part.
          end.
*/                                                                          
/* SS - 20120625.1 - E */
          disp so_cust label "����"
               absmstr.abs_shipto label "������"
             /*  substring(abs_mstr.abs_par_id,2) format "x(12)" @ abs_mstr.abs_shipto label "���˵�" */
	    /*   taxin label "˰" */
               so_po label "�ɹ���"
               /*desc1 label "˵��"*/
	       adname label "�ͻ�����"
               sod_nbr COLUMN-LABEL "���۶���"
            /*   sod_line label "���" */
               sod_part  label "�������" 
	       ptdesc1 format "x(30)" label "���˵��"
	    /* mycustpart label "�ͻ�����" */
               abs_mstr.abs_ship_qty - v_qty  format "->>>>>>>>9" @ abs_mstr.abs_ship_qty label "����" /* "���˵�����" */
	       sod_um label "��λ"
               sod_price / sod_um_conv @ sod_price label "�۸�" 
/*RCUR*/	so_curr  COLUMN-LABEL "�ұ�"        
               (abs_mstr.abs_ship_qty - v_qty ) * 
               sod_price / sod_um_conv  format "->,>>>,>>9.99" @ v_price label "���"  /*RCUR*/ format "->>,>>>,>>9.99"
                /* SS - 20121128.1 - B */
	       zkprice format "->>,>>>,>>9.9999" @ zkprice label "�ۿ۵���" 
	       sod_list_pr / sod_um_conv * (abs_mstr.abs_ship_qty - v_qty ) * (so_disc_pct / 100) format "->>,>>>,>>9.99" @ zkcount label "�������" 
	       replaced format "->>,>>>,>>9.99" @ replaced label "�ۿۺ���"
	       so_disc_pct label "����%"
	       ttlistpr format "->>,>>>,>>9.9999" @ listpr label "��˰����"
	       ttlistprqty format "->>,>>>,>>9.99" @ listprqty label "��˰���"
	       /* SS - 20121128.1 - E */
/*RCUR*/        base_price format "->>,>>>,>>9.99" label "�������"
               substring(abs_mstr.abs_par_id,2) format "x(12)" @ abs_mstr.abs_shipto label "���˵�" 
                abs_mstr.abs_shp_date label "��������"
               with width 320. 
            down. 
            
	  /* ss - 130306.1 -b */
	    end.
	  /* ss - 130306.1 -e */

          end.  
       if not avail xxabs_mstr then do:
/*RCUR* **********************************************/ 
         
	  /* ss - 130306.1 -b */
	  v_go  = yes .
        for each ih_hist no-lock where ih_nbr = so_nbr
	    and substring(ih_inv_nbr,1,2) = "SI" , 
            each idh_hist where  idh_nbr = ih_nbr
      	     and idh_inv_nbr = ih_inv_nbr
      	     and idh_line = sod_line no-lock :
	     
	   find first tr_hist no-lock 
	  /*  where tr_nbr = so_nbr and tr_line = sod_line and substring(tr_rmks,1,2) = "SI" */
   	    where tr_rmks = ih_inv_nbr and tr_nbr = ih_nbr and tr_line = idh_line
	    and tr_ship_id = substring(abs_mstr.abs_par_id,2) no-error.
	     if avail tr_hist then do: 
              v_go = no .
	    end .     
	  end.
	   
	 if v_go then do:
	   /* ss - 130306.1 - e*/
         
	/* curr_price = abs_mstr.abs_ship_qty * sod_price / sod_um_conv .  */ /*���׽��*/
	curr_price = round(abs_mstr.abs_ship_qty * sod_price / sod_um_conv , 2) . /*���׽��*/
	base_price = curr_price.
	
	if so_curr <> report_curr
	then do:
           if so_curr <> base_curr 
           then do:
               {gprunp.i "mcpl" "p" "mc-curr-conv"
                  "(input base_curr,
                    input report_curr,
                    input so_ex_rate,
                    input so_ex_rate2,
                    input curr_price,
                    input false,   /* NOT ROUND */
                    output base_price,
                    output mc-error-number)"}
               if mc-error-number <> 0
               then do:
                  {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
               end.           
           end. /*if so_curr <> base_curr*/ /*תΪ�������ҽ��*/
           
	   /*������Ҳ����ڻ������ң���Ҫת��Ϊ�������*/           
           if report_curr <> base_curr
           then do:
		/*��ȡ���������������ҵĶһ���*/
		{gprunp.i "mcpl" "p" "mc-create-ex-rate-usage"
                       "(input report_curr,
                         input base_curr,
                         input "" "",
                         input xxrqm_inv_date,
                         output et_rate2,
                         output et_rate1,
                         output mc-seq,
                         output mc-error-number)"}
               if mc-error-number <> 0
               then do:
                  {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
               end.                          
		
		/*����������תΪ������ҽ��*/
               {gprunp.i "mcpl" "p" "mc-curr-conv"
                  "(input report_curr,
                    input base_curr,
                    input et_rate1,
                    input et_rate2,
                    input base_price,
                    input false,   /* NOT ROUND */
                    output base_price,
                    output mc-error-number)"}
               if mc-error-number <> 0
               then do:
                  {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
               end.           
           end. /*if report_curr <> base_curr*/          
	end. /*if so_curr <> report_curr*/

	/*if so_curr = report_curr 
	then base_price = curr_price.*/
	
	tv_price = tv_price + base_price.
/*RCUR* **********************************************/   
       
        /*  v_price = v_price + abs_mstr.abs_ship_qty * sod_price / sod_um_conv . */
	 v_price = v_price + round(abs_mstr.abs_ship_qty * sod_price / sod_um_conv , 2 ) .

/* SS - 20120625.1 - B */
/* 1)      ���ӿͻ����� 

          mycustpart = "".
          
          find first cp_mstr no-lock where cp_part = sod_part  and cp_cust = so_cust no-error.
          if avail cp_mstr then do:
              mycustpart = cp_cust_part.
          end.
*/                                                                          
/* SS - 20120625.1 - E */
 
	  /* SS - 20121128.1 - B */
          
	/*  taxin = "N" . */
	  taxprice = 0 .
       if sod_site = "nsza" then do:
         /* taxin = "Y" . */
	  taxprice = 0.17 .
	  end. 

	  /* SS - 20121227.1 - B */
	  zkprice = round(( sod_list_pr / sod_um_conv ) , 2) - round(( sod_list_pr / sod_um_conv * sod_disc_pct / 100) , 2).
	  replaced = abs_mstr.abs_ship_qty * sod_price / sod_um_conv -
	             sod_price / sod_um_conv * abs_mstr.abs_ship_qty * (sod_disc_pct / 100). 
	  ttlistpr =  sod_price / sod_um_conv - sod_price / sod_um_conv * (so_disc_pct / 100)
	            + taxprice * round((sod_price / sod_um_conv - sod_price / sod_um_conv * so_disc_pct / 100) , 2). 
	  ttlistprqty = round(abs_mstr.abs_ship_qty * sod_price / sod_um_conv , 2) 
	                + taxprice * round((sod_price / sod_um_conv * abs_mstr.abs_ship_qty 
		          - sod_price / sod_um_conv * abs_mstr.abs_ship_qty * so_disc_pct / 100) , 2)
			- sod_price / sod_um_conv * abs_mstr.abs_ship_qty * (so_disc_pct / 100) .
                   
	  zktotal = zktotal + sod_price * abs_mstr.abs_ship_qty / sod_um_conv * so_disc_pct / 100  .
	 
	  hstotal = hstotal + taxprice * round((sod_price / sod_um_conv * abs_mstr.abs_ship_qty 
		    - sod_price / sod_um_conv * abs_mstr.abs_ship_qty * so_disc_pct / 100) , 2) .

	  listprqty = v_price .

	  /* SS - 20121227.1 - E */
	  
	  find first pt_mstr no-lock where pt_part = sod_part no-error.
	  if avail pt_mstr then ptdesc1 = pt_desc1.

	  find first cm_mstr no-lock where cm_addr = so_cust no-error.
	  if avail cm_mstr then do:
	      find first ad_mstr no-lock where ad_addr = cm_addr no-error.
	      if avail ad_mstr then adname = ad_name.
	  end.

	  /* SS - 20121128.1 - E */

          disp so_cust label "����"
               absmstr.abs_shipto label "������"
             /*  substring(abs_mstr.abs_par_id,2) format "x(12)" @ abs_mstr.abs_shipto label "���˵�" */
	     /*  taxin label "˰" */
               so_po label "�ɹ���"
               /*desc1 label "˵��"*/
	       adname label "�ͻ�����"
               sod_nbr COLUMN-LABEL "���۶���" 
             /*  sod_line label "���" */
               sod_part  label "�������"
	       ptdesc1 format "x(30)" label "���˵��"
	    /* mycustpart label "�ͻ�����" */
               abs_mstr.abs_ship_qty format "->>>>>>>>9" @ abs_mstr.abs_ship_qty label "����" /* "���˵�����" */
	       sod_um label "��λ"
               sod_price / sod_um_conv @ sod_price label "�۸�" 
/*RCUR*/	so_curr   COLUMN-LABEL "�ұ�"            
               abs_mstr.abs_ship_qty * sod_price / sod_um_conv format "->,>>>,>>9.99" @ v_price label "���" /*RCUR*/ format "->>,>>>,>>9.99"
                /* SS - 20121128.1 - B */
	       zkprice format "->>,>>>,>>9.9999" @ zkprice label "�ۿ۵���" 
	       sod_list_pr / sod_um_conv * abs_mstr.abs_ship_qty * (so_disc_pct / 100) format "->>,>>>,>>9.99" @ zkcount label "�������"
	       replaced format "->>,>>>,>>9.99" @ replaced label "�ۿۺ���"
	       so_disc_pct label "����%"
	       /* SS - 20121219.1 - B */
	       /*
	       sod_list_pr * (1 + taxprice) format "->>,>>>,>>9.99" @ listpr label "��˰����"
	       sod_list_pr * (1 + taxprice) * abs_mstr.abs_ship_qty format "->>,>>>,>>9.99" @ listprqty label "��˰���"
	       */
	       /* SS - 20121219.1 - E */
	       ttlistpr  format "->>,>>>,>>9.9999" @ listpr label "��˰����"
	       ttlistprqty format "->>,>>>,>>9.99" @ listprqty label "��˰���"
	        /* SS - 20121128.1 - E */
/*RCUR*/	base_price format "->>,>>>,>>9.99" label "�������"
                substring(abs_mstr.abs_par_id,2) format "x(12)" @ abs_mstr.abs_shipto label "���˵�"
		abs_mstr.abs_shp_date label "��������"
               with width 320 . 
           down .  

	  /* ss - 130306.1 -b */
	  end.
	   /* ss - 130306.1 - e*/
       end.               
       
     if last( absmstr.abs_shipto ) /* ss - 130329.1  and v_price <> 0 */then do:
          /*20121227*/
	  zktotal = round(zktotal , 2).
	  hstotal = round(hstotal , 2).
	  listprqty = listprqty + hstotal - zktotal .
	  /*20121227*/

          down 1.
          put report_curr "              �ܺϼ�:          "  
/*RCUR***      	v_price /*RCUR*/ format "->>,>>>,>>9.99<<" **/
/*RCUR*/  	v_price format "->>,>>>,>>9.99" at 60 
               
	        "                  ��˰�ܽ�     " 
		 listprqty  format "->>,>>>,>>9.99" .
		 /*
		 "                 �ϼ�˰�       " hstotal
		 "                 �ϼƷ�����       " zktotal. */  
		/* SS - 20121227.1 - E */

/*RCUR*/  tv_price = 0.
          v_price = 0 .
	  /* SS - 20121204.1 - B */
	  listprqty = 0 .
	  zktotal = 0.
	  hstotal = 0.
	  /* SS - 20121204.1 - E */ 
	  
     end .           
   end. /* for each absmstr */
 end. /* else do: */
  {mfreset.i}
  {mfgrptrm.i}
end.
