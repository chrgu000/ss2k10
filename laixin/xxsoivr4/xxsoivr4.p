/* rev: eb21sp3 */
/* By: Neil Gao Date: 20070307 ECO: * ss 20070307.1 * */
/* By: Neil Gao Date: 20070326 ECO: * ss 20070326.1 * */
/* By: Neil Gao Date: 20070410 ECO: * ss 20070410.1 * */
/* By: Neil Gao Date: 20070428 ECO: * ss 20070428.1 * */
/* By: Neil Gao Date: 20070429 ECO: * ss 20070329.1 * */
/*By: Neil Gao 08/04/28 ECO: *SS 20080428* */


/* ss 20070429.1 - 
�һ�ȡ����
 * ss 20070429.1 - */

/* ss 20070428.1 - 
����������˵�����ѡ�������
   ss 20070428.1 - e */


/* DISPLAY TITLE */
{mfdtitle.i "2+ "}
/* define */
define var cust    like so_cust.
define var cust1   like so_cust.
define var ship    like so_ship format "x(10)".
define var ship1   like so_ship format "x(10)".
define var nbr     like so_nbr.
define var nbr1    like so_nbr.
define var part    like pt_part.
define var part1   like pt_part.
define var inv     like ih_inv_nbr.
define var inv1    like ih_inv_nbr.
define var effdate  like ih_inv_date.
define var effdate1 like ih_inv_date.
define var qty1     like idh_qty_inv.
define var qty2     like idh_qty_inv.
define var reqnbr   as char format "x(40)".
define var invnbr   like reqnbr.
define var exrate   like so_ex_rate.
define var inloc    like tr_loc.
define var outloc   like tr_loc.
define buffer absmstr for abs_mstr.
/* ss 20070326.1 */ 
define var absinv like ih_inv_nbr.
define var ifclose as logical.
define var exrate1  like so_ex_rate.
define var exrate2  like so_ex_rate.
define var exruseq  like so_exru_seq.
define var mc-error-number like msg_nbr.
/* form */
form
  cust      colon 15
  cust1     colon 47
  nbr       colon 15
  nbr1      colon 47
  ship      colon 15 
  ship1     colon 47 
  part      colon 15
  part1     colon 47
  effdate   colon 15
  effdate1  colon 47
  skip(1)
 with frame a width 80 side-labels.

 /* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).


repeat:

/* if var = hi then var = "" */

   if cust1 = hi_char then cust1 = "".
   if ship1  = "zzz" then ship1  = "".
   if nbr1  = hi_char then nbr1  = "".
   if part1 = hi_char then part1 = "".
   if effdate1 = hi_date then effdate1 = ?.
   if effdate  = low_date then effdate = ?.
   
   if c-application-mode <> 'web' then
   update cust cust1 nbr nbr1 ship ship1 part part1 effdate effdate1
   with frame a.


   if (c-application-mode <> 'web') then 
   do:
   	
      /*if var = "" then var = hi_char. */
      if cust1 = "" then cust1 = hi_char.
      if ship1 = "" then ship1 = "zzz".
      if nbr1  = "" then nbr1  = hi_char.
      if part1 = "" then part1 = hi_char.
      if effdate1 = ? then effdate1 = hi_date.
      if effdate  = ? then effdate  = low_date.

   end.

   /* OUTPUT DESTINATION SELECTION */
      {gpselout.i &printType = "printer"
               &printWidth = 132
               &pagedFlag = " "
               &stream = " "
               &appendToFile = " "
               &streamedOutputToTerminal = " "
               &withBatchOption = "yes"
               &displayStatementType = 1
               &withCancelMessage = "yes"
               &pageBottomMargin = 6
               &withEmail = "yes"
               &withWinprint = "yes"
               &defineVariables = "yes"}
 
   PUT UNFORMATTED "#def REPORTPATH=$/Minth/xxsoivr2" SKIP.
   PUT UNFORMATTED "#def :end" SKIP.

   for each absmstr no-lock where abs_domain = global_domain and abs_par_id = "" and 
       abs_id  >= "s" +  ship and abs_id <= "s" + ship1 and
       substring(abs_status,2,1) <> ""
/*SS 20080428 - B*/
/*
       and abs_shipto >= cust and abs_shipto <= cust1 and
*/
/*SS 20080428 - E*/
       and absmstr.abs_eff_date >= effdate and absmstr.abs_eff_date <= effdate1,
       each abs_mstr where abs_mstr.abs_domain = global_domain  and 
       absmstr.abs_id = abs_mstr.abs_par_id and  
       abs_mstr.abs_order >= nbr and abs_mstr.abs_order <= nbr1 and 
       abs_mstr.abs_item  >= part and abs_mstr.abs_item <= part1        
       no-lock,
/* ss 20070410.1 - b */
/*
       each so_mstr where so_domain = global_domain and 
       so_nbr = abs_mstr.abs_order and 
       so_cust = absmstr.abs_shipto       
       no-lock,
       each sod_det where sod_domain = global_domain and 
       sod_nbr = so_nbr and sod_line = int( abs_mstr.abs_line)
       no-lock,
*/
/* ss 20070410.1 - e */       
       each pt_mstr where pt_domain = global_domain and 
       pt_part = abs_mstr.abs_item 
       no-lock:
/* ss 20070410.1 - b */
/*
       each ad_mstr where ad_domain = global_domain and 
       ad_addr = so_cust no-lock:
*/
/* ss 20070410.1 - e */

/*SS 20080428 - B*/
       	find first ad_mstr where ad_domain = global_domain and ad_addr = absmstr.abs_shipto
	       	and ( (ad_addr >= cust and ad_addr <= cust1) or
							(ad_ref >= cust and ad_ref <= cust1)) no-lock no-error.
			 	if not avail ad_mstr then next.
/*SS 20080428 - E*/

				assign qty1 = 0
              qty2 = 0
              reqnbr = ""
              invnbr = ""
              inloc  = ""
              outloc = ""
              ifclose = no.

                     
       for each xxabs_mstr where xxabs_domain = global_domain and
         xxabs_par_id = abs_mstr.abs_par_id and xxabs_id = abs_mstr.abs_id 
         no-lock,
         each xxrqm_mstr where xxrqm_domain = global_domain and
           xxrqm_nbr = xxabs_nbr no-lock break by xxabs_nbr :
         if xxrqm_invoiced then qty1 = qty1 + xxabs_ship_qty.
/* ss 20070326.1 - b */
         if xxabs_canceled and xxrqm_invoiced then ifclose = yes.
/* ss 20070326.1 - e */
         if first-of(xxabs_nbr) then do:
            assign reqnbr = reqnbr + xxrqm_nbr + "," .
            if xxrqm_inv_nbr <> "" then invnbr = invnbr + xxrqm_inv_nbr + "," .
         end.
       end.
				absinv = entry(1,invnbr).
/* ss 20070410.1 - b */

			find first ih_hist where ih_domain = global_domain and absinv = ih_inv_nbr and
				ih_nbr = abs_mstr.abs_order and ih_cust = absmstr.abs_shipto no-lock no-error.
			find first idh_hist where idh_domain = global_domain and absinv = idh_inv_nbr and
				idh_nbr = abs_mstr.abs_order and idh_line = int (abs_mstr.abs_line) no-lock no-error.
				if avail idh_hist then do:
					find first ad_mstr where ad_domain = global_domain and ad_addr = ih_cust no-lock no-error.
					find first sch_mstr where sch_nbr = idh_nbr and sch_line = idh_line no-lock no-error.
					if avail sch_mstr then do:
         		find first tr_hist where tr_domain = global_domain and tr_type = "iss-tr" and
         		tr_nbr = idh_nbr and
         		( tr_program = "rcsois.p" or tr_program = "xxncsois.p" or tr_program = "xxrcsois.p") and 
         		tr_ship_id = substring(abs_mstr.abs_par_id,2) and tr_part = idh_part no-lock no-error.
         		if avail tr_hist then outloc = tr_loc.
         
         		find first tr_hist where tr_domain = global_domain and tr_type = "rct-tr" and
						tr_nbr = idh_nbr and
          	( tr_program = "rcsois.p" or tr_program = "xxncsois.p" or tr_program = "xxrcsois.p") and
         		tr_ship_id = substring(abs_mstr.abs_par_id,2) and tr_part = idh_part no-lock no-error.
         		if avail tr_hist then inloc = tr_loc. 
       		end.
       		else do:
           find first tr_hist where tr_domain = global_domain and tr_type = "iss-so" and
           tr_nbr = idh_nbr and tr_line = idh_line and
           ( tr_program = "rcsois.p" or tr_program = "xxncsois.p" or tr_program = "xxrcsois.p") and
           tr_ship_id = substring(abs_mstr.abs_par_id,2) and tr_part = idh_part no-lock no-error.
           if avail tr_hist then assign outloc = tr_loc.
       		end.

/* ss 20070428.1 - b */
/*
       		qty2 = if qty1 < abs_mstr.abs_ship_qty then abs_mstr.abs_ship_qty - qty1 
        	      else 0.
*/
       		qty2 = abs_mstr.abs_ship_qty - qty1 .
       	
/* ss 20070428.1 - e */

       		exrate = ih_ex_rate / ih_ex_rate2 .
       
       		put UNFORMATTED absmstr.abs_eff_date ";" substring(abs_mstr.abs_par_id,2) ";" idh_nbr ";" 
          	  ih_cust ";" ad_name ";" ih_curr ";" exrate ";"
            	pt_part ";" pt_desc1 ";" pt_desc2 ";" outloc ";" inloc ";"
            	abs_mstr.abs_ship_qty ";" qty1 ";" qty2 ";" idh_um ";" .
       		if qty2 = 0 or ifclose then put "yes" .
       		else put "no" .
       		put UNFORMATTED ";"  idh_price ";" idh_price * abs_mstr.abs_ship_qty ";"  ";" invnbr ";" reqnbr ";"
          	 idh_line  skip.
			
				end. /* if avail idh_hist */
				else do:
		
					find first so_mstr where so_domain = global_domain and
					so_nbr = abs_mstr.abs_order no-lock no-error.
					find first sod_det where sod_domain = global_domain and
					sod_nbr = abs_mstr.abs_order and sod_line = int (abs_mstr.abs_line) no-lock no-error.
					if avail sod_det then do:
						find first ad_mstr where ad_domain = global_domain and ad_addr = so_cust no-lock no-error.
/* ss 20070410.1 - e */       
       

       			if sod_consignment then do:
         			find first tr_hist where tr_domain = global_domain and tr_type = "iss-tr" and
         			tr_nbr = sod_nbr and
         			( tr_program = "rcsois.p" or tr_program = "xxncsois.p" or tr_program = "xxrcsois.p") and 
         			tr_ship_id = substring(abs_mstr.abs_par_id,2) and tr_part = sod_part no-lock no-error.
         			if avail tr_hist then outloc = tr_loc.
         
         			find first tr_hist where tr_domain = global_domain and tr_type = "rct-tr" and
							tr_nbr = sod_nbr and
          		( tr_program = "rcsois.p" or tr_program = "xxncsois.p" or tr_program = "xxrcsois.p") and
         			tr_ship_id = substring(abs_mstr.abs_par_id,2) and tr_part = sod_part no-lock no-error.
         			if avail tr_hist then inloc = tr_loc. 
       			end.
       			else do:
           		find first tr_hist where tr_domain = global_domain and tr_type = "iss-so" and
           		tr_nbr = sod_nbr and tr_line = sod_line and
           		( tr_program = "rcsois.p" or tr_program = "xxncsois.p" or tr_program = "xxrcsois.p") and
           		tr_ship_id = substring(abs_mstr.abs_par_id,2) and tr_part = sod_part no-lock no-error.
           		if avail tr_hist then assign outloc = tr_loc.
       			end.
       
/* ss 20070428.1 - b */
/*  
       			qty2 = if qty1 < abs_mstr.abs_ship_qty then abs_mstr.abs_ship_qty - qty1 
              else 0.
*/
       			qty2 = abs_mstr.abs_ship_qty - qty1 .

/*
   "��������[1]"	"���˵���"	"�ͻ�����"	"�ͻ�����"	"�ͻ�����"	"�ұ�"	����	"Ʒ��"	Ʒ��	���	
   "ת���ֿ�"	"ת��ֿ�"	����	"��Ʊ����"	"δ��Ʊ��"	"��λ"	����	
   "����"	"���"	��ע	��Ʊ��	�����
 */

/* ss 20070429.1 - b */
/*
       exrate = so_ex_rate2 / so_ex_rate .
*/    
						if so_curr <> "CNY" then do:
      			{gprunp.i "mcpl" "p" "mc-create-ex-rate-usage"
               "(input  so_mstr.so_curr,
                 input  'CNY',
                 input  '',
                 input  absmstr.abs_eff_date,
                 output exrate1,
                 output exrate2,
                 output exruseq,
                 output mc-error-number)" }
       			if mc-error-number = 0 then
       			exrate = exrate2 / exrate1 .
      			end.
/* ss 20070429.1 - e */
       
       			put UNFORMATTED absmstr.abs_eff_date ";" substring(abs_mstr.abs_par_id,2) ";" sod_nbr ";" 
            	so_cust ";" ad_name ";" so_curr ";" exrate ";"
            	pt_part ";" pt_desc1 ";" pt_desc2 ";" outloc ";" inloc ";"
            	abs_mstr.abs_ship_qty ";" qty1 ";" qty2 ";" sod_um ";" .
       			if qty2 = 0 or ifclose then put "yes" .
       			else put "no" .
       			put UNFORMATTED ";"  sod_price ";" sod_price * abs_mstr.abs_ship_qty ";"  ";" invnbr ";" reqnbr ";"
           		sod_line  skip.       
       	
/* ss 20070410.1 - b */

				end. /* if avail sod_det */

	 	end. /* else */
/* ss 20070410.1 - e */

   end.      

   {a6mfrtrail.i}

end. /* repeat */