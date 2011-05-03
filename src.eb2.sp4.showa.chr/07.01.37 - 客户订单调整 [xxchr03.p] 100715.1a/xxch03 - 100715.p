/* BY: Micho Yang         DATE: 07/07/08  ECO: *SS - 20080707.1* */
/* SS - 090723.1 By: Neil Gao */
/* SS - 090725.1 By: Neil Gao */
/* SS - 090902.1 By: Neil Gao */
/* SS - 100605.1 By: SamSong */

/* SS 090902.1 - B */
/*
ɾ����so_mstr��¼
*/
/* SS 090902.1 - E */

{mfdtitle.i "100605.1"}

define variable T as integer init 0.                        /*�����ʱ��*/
def variable i AS integer INIT 0.
def variable D AS integer init 0.                        /*���������*/
def variable A as date.
DEF variable j as integer INIT 0.
define variable xxsoduedate as date.
define variable xxsoduedate1 as date.
define variable xxsoduetime as char format "99:99" initial "0800".
define variable xxsoduetime1 as char format "99:99" initial "2300".
define variable xxsodinvnbr like xxsod_invnbr.
define variable xxsodinvnbr1 like xxsod_invnbr.
define variable xxsodcust like xxsod_cust.
define variable xxsodrmks2 like xxsod_rmks2.  
define variable ifupdate as logical.              /*��ע*/
define variable str as char extent 15 initial["08:00","09:00","10:00","11:00","13:00","14:00","15:00","16:00","17:00","18:00","19:00","20:00","21:00","22:00","23:00"].      /*������12�������*/
define variable str1 as char extent 16 initial["08:00","09:00","10:00","11:00","12:00","13:00","14:00","15:00","16:00","17:00","18:00","19:00","20:00","21:00","22:00","23:00"].       /*����12�������*/
/* SS 090723.1 - B */
define variable tdate1 as char format "x(11)".
define variable tdate2 as char format "x(11)".
define variable ttime1 as char format "x(5)".
define variable ttime2 as char format "x(5)".
define variable tnbr1 as char.
define variable tnbr2 as char.
define variable tmonth as char.
define variable tpart like pt_part.
define var v_tax LIKE pt_taxable .
define var v_tax1 LIKE pt_taxable .
define var v_curr like vd_curr .
define var tqty01 as deci.
define var fn_i as char init "xxch02".
/* SS 090723.1 - E */

&SCOPED-DEFINE PP_FRAME_NAME A
form
    /* RECT-FRAME       AT ROW 1 COLUMN 1.25
    RECT-FRAME-LABEL AT ROW 1 COLUMN 3 NO-LABEL VIEW-AS TEXT SIZE-PIXELS 1 BY 1
    skip(1)
    */
    xxsoduedate  colon 12 label "�ͻ�����"
    xxsoduedate1 colon 40 label "��"
    xxsoduetime  colon 12 label "�ͻ�ʱ��"
    xxsoduetime1 colon 40 label "��"
    xxsodinvnbr  COLON 12 label "��Ʊ��"
    xxsodinvnbr1 colon 40 label "��"
    xxsodcust    colon 12 label "�ͻ�����"
    skip(1)
    D            colon 12 label "��������"
    T            colon 12 label "����ʱ��"
    xxsodrmks2   colon 12 label "��ע"
    skip(1)     /**����**/   
    "����˵��: ʱ���Ƴ���'����ʱ��'����������,ʱ����ǰ��'����ʱ��'�����븺��;"    colon 5
    "          ����������'��������'��������Ӧ������,�Ƴ�Ϊ����,��ǰΪ����."     COLON 5

    "      ��: ��ǰ1��,��'��������'������'-1';�Ƴ�4Сʱ,��'����ʱ��'������'4';"   COLON 5
    "          �Ƴ�2��1Сʱ,��'��������'������'2',��'����ʱ��'������'1' "         COLON 5
    SKIP(1)
with frame a side-label width 80 attr-space . /* NO-BOX THREE-D.

DEFINE VARIABLE F-a-title AS CHARACTER INITIAL "".
 RECT-FRAME-LABEL:SCREEN-VALUE in frame a = F-a-title.
 RECT-FRAME-LABEL:HIDDEN in frame a = yes.
 RECT-FRAME:HEIGHT-PIXELS in frame a =
  FRAME a:HEIGHT-PIXELS - RECT-FRAME:Y in frame a - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME a = FRAME a:WIDTH-CHARS - .5.  /*GUI*/
*/
&UNDEFINE PP_FRAME_NAME

setframelabels(frame a:handle).                                                 
form
    xxsod_cust
    xxsod_part
    xxsod_invnbr
    xxsod_due_date1
    xxsod_due_time1
    xxsod_qty_ord
    xxsod_rmks1
with frame b down width 120.
setframelabels(frame b:handle).

main:
repeat:
  if xxsoduedate  = low_date then xxsoduedate = ? .
  if xxsoduedate1 = hi_date  then xxsoduedate1 = ? .
  if xxsodinvnbr1 = hi_char  then xxsodinvnbr1 = "".
  if xxsodcust    = hi_char  then xxsodcust = "".     

  update  xxsoduedate xxsoduedate1 xxsoduetime xxsoduetime1
          xxsodinvnbr xxsodinvnbr1 xxsodcust D T xxsodrmks2 WITH FRAME a .

  if xxsoduedate  = ?  then xxsoduedate  = low_date.
  if xxsoduedate1 = ?  then xxsoduedate1 = hi_date. 
  if xxsodinvnbr1 = "" then xxsodinvnbr1 = hi_char. 

  IF T > 15 OR T < -15 THEN DO:
      MESSAGE "�����������,����'��������'���������������" .
      UNDO,RETRY .
      NEXT-PROMPT T WITH FRAME a.
  END.

  {mfselprt.i "printer" 120}

  for each xxsod_det NO-LOCK 
      where date(int(entry(2,xxsod_due_date1,"-")),int(ENTRY(3,xxsod_due_date1,"-")),int(ENTRY(1,xxsod_due_date1, "-")))  >= xxsoduedate 
      AND date(int(entry(2,xxsod_due_date1,"-")),int(ENTRY(3,xxsod_due_date1,"-")),int(ENTRY(1,xxsod_due_date1, "-"))) <= xxsoduedate1 
      and xxsod_due_time1 >= substring(xxsoduetime,1,2) + ":" + SUBSTRING(xxsoduetime,3,2) 
      and xxsod_due_time1 <= substring(xxsoduetime1,1,2) + ":" + SUBSTRING(xxsoduetime1,3,2)
      and xxsod_invnbr >= xxsodinvnbr 
      and xxsod_invnbr <= xxsodinvnbr1 
      and xxsod_cust = xxsodcust :

       disp   xxsod_cust        LABEL "�ͻ�����" 
               xxsod_part       LABEL "�ͻ�ͼ��"
               xxsod_invnbr     LABEL "��Ʊ����" 
               xxsod_due_date1  LABEL "�ͻ�����"
               xxsod_due_time1  LABEL "�ͻ�ʱ��"   
               xxsod_qty_ord    LABEL "��������" 
               xxsod_rmks1      LABEL "��ע1" 
          with frame b.
          down 1 with frame b. 
  end.   /* for each xxsod_det */

  {mfreset.i} 
  {mfgrptrm.i}        
  message "�Ƿ���� ?"  update ifupdate  .

  if ifupdate then               /*ѡ���Ƿ����*/
  do transaction on error undo , retry :
      for each xxsod_det 
          where date(int(entry(2,xxsod_due_date1,"-")),int(ENTRY(3,xxsod_due_date1,"-")),int(ENTRY(1,xxsod_due_date1, "-")))  >= xxsoduedate 
          AND date(int(entry(2,xxsod_due_date1,"-")),int(ENTRY(3,xxsod_due_date1,"-")),int(ENTRY(1,xxsod_due_date1, "-"))) <= xxsoduedate1  
          and xxsod_due_time1 >= substring(xxsoduetime,1,2) + ":" + SUBSTRING(xxsoduetime,3,2)
          and xxsod_due_time1 <= substring(xxsoduetime1,1,2) + ":" + SUBSTRING(xxsoduetime1,3,2)
          and xxsod_invnbr >= xxsodinvnbr 
          and xxsod_invnbr <= xxsodinvnbr1  
          and xxsod_cust = xxsodcust : 

/* SS 090723.1 - B */
					find first cm_mstr where cm_addr = xxsod_cust no-lock no-error.
					if not avail cm_mstr then next.
					find first cp_mstr where cp_cust = xxsod_cust and cp_cust_part = xxsod_part no-lock no-error.
					if not avail cp_mstr then do:
						message "����: �ͻ����������".
						leave.
					end.
					else tpart = cp_part.
					v_curr = cm_curr .
/* SS 091030.1 - B */
/*
					FIND FIRST pt_mstr WHERE pt_part = tpart no-lock no-error.
  				IF AVAIL pt_mstr THEN v_tax = pt_taxable .
  				find first ad_mstr where ad_addr = xxsod_cust no-lock no-error.
  				if avail ad_mstr then v_tax1 = ad_taxable.
*/
					FIND FIRST pt_mstr WHERE pt_part = tpart NO-LOCK NO-ERROR.
          IF AVAIL pt_mstr THEN v_tax = pt__qad22 .
/* SS 091030.1 - E */
					IF SUBSTRING(xxsod_due_date1,6,2) = "10" THEN tmonth = "A".
					else if SUBSTRING(xxsod_due_date1,6,2) = "11" then tmonth = "B".
					else if SUBSTRING(xxsod_due_date1,6,2) = "12" then tmonth = "C".
					else tmonth = SUBSTRING(xxsod_due_date1,7,1).
					tdate1 = xxsod_due_date1.
					ttime1 = xxsod_due_time1.
					tnbr1  = SUBSTRING(cm_sort,1,2) + substring(xxsod_type,1,1) + substring(xxsod_due_date1,4,1)
									+ tmonth + SUBSTRING(xxsod_project,1,1) + string(int(substring(xxsod_due_date1,9,2))).
					tnbr1 = caps(tnbr1).
/* SS 090723.1 - E */

          A = date(xxsod_due_date1) + D.
          ASSIGN xxsod_rmks1 = xxsodrmks2.

          IF d <> 0 THEN DO:
              ASSIGN xxsod_due_date1 = STRING(YEAR(a),"9999") + "-" + STRING(MONTH(a),"99") + "-" + STRING(DAY(a),"99") .
          END.

          i = 0.
          j = 0.

          updatedatetime:
          REPEAT:
              i = i + 1.

              IF str1[i] = xxsod_due_time1 THEN DO:
                  i = i + T .

                  IF i < 1 THEN DO:
                      ASSIGN xxsod_due_date1 = STRING(YEAR(a - 1),"9999") + "-" + STRING(MONTH(a - 1),"99") + "-" + STRING(DAY(a - 1),"99") .

                      j = i + 16 .
                      xxsod_due_time1 = str1[j] .
                  END.
                  ELSE IF i >= 17 THEN DO:
                      ASSIGN xxsod_due_date1 = STRING(YEAR(a + 1),"9999") + "-" + STRING(MONTH(a + 1),"99") + "-" + STRING(DAY(a + 1),"99") .

                      j = i - 16 .
                      xxsod_due_time1 = str1[j] .
                  END.
                  ELSE DO:
                      xxsod_due_time1 = str1[i] .
                  END.

                  LEAVE.
              END. /* IF str1[i] = xxsod_due_time1 THEN DO: */
          END. /* updatedatetime: */
/* SS 090723.1 - B */
					IF SUBSTRING(xxsod_due_date1,6,2) = "10" THEN tmonth = "A".
					else if SUBSTRING(xxsod_due_date1,6,2) = "11" then tmonth = "B".
					else if SUBSTRING(xxsod_due_date1,6,2) = "12" then tmonth = "C".
					else tmonth = SUBSTRING(xxsod_due_date1,7,1).
					tdate2 = xxsod_due_date1.
					ttime2 = xxsod_due_time1.
					tnbr2  = SUBSTRING(cm_sort,1,2) + substring(xxsod_type,1,1) + substring(xxsod_due_date1,4,1)
									+ tmonth + SUBSTRING(xxsod_project,1,1) + string(int(substring(xxsod_due_date1,9,2))).
					tnbr2 = caps(tnbr2).
					if tnbr1 <> tnbr2 then do:
						/*����ԭ��������*/
						find first sod_det where sod_nbr = tnbr1 and sod_part = tpart no-error.
						if avail sod_det then do:
							tqty01 = sod_qty_ord.
/* SS 090725.1 - B */
							define var del-yn as logical .
							del-yn = yes.
							if sod_qty_ord = xxsod_qty_ord then do:
								if sod_qty_inv <> 0 or sod_qty_ship <> 0 then del-yn = no.
								/*
								find first abs_mstr where abs_order = sod_nbr and abs_id begins "i" and abs_type = "s"
									and abs_line     = string(sod_line) no-lock no-error.
								if avail abs_mstr then del-yn = no.
								*/
								if del-yn then do:
									for each mrp_det where mrp_det.mrp_dataset = "sod_det" and mrp_det.mrp_part = sod_part
         						and mrp_det.mrp_nbr = sod_nbr and mrp_det.mrp_line = string(sod_line):
  						 			delete mrp_det.
  						 		end.
									for each cmt_det where cmt_indx = sod_det.sod_cmtindx exclusive-lock:
      				  	 delete cmt_det.
   								end.
   								for each lad_det where lad_dataset = "sod_det" and lad_nbr = sod_nbr and lad_line = string(sod_det.sod_line) exclusive-lock:
     								 find ld_det where ld_site = lad_site and ld_loc  = lad_loc and ld_lot  = lad_lot and ld_ref  = lad_ref
                    	and ld_part = lad_part exclusive-lock no-error.
      							if available ld_det then ld_qty_all = ld_qty_all - (lad_qty_all + lad_qty_pick).
      								delete lad_det.
   								end.
   								for each tx2d_det where tx2d_tr_type = "41" and tx2d_ref = sod_nbr and tx2d_line = sod_line exclusive-lock:
      							delete tx2d_det.
   								end.
   								for each sodr_det exclusive-lock   where sodr_nbr  = sod_nbr and sodr_line = sod_line:
   									delete sodr_det.
									end.
									delete sod_det.
/* SS 090902.1 - B */
									/* ɾ����so_mstr*/
									find first sod_det where sod_nbr = tnbr1 no-lock no-error.
									if not avail sod_det then do:
										find first so_mstr where so_nbr = tnbr1 no-error.
										if avail so_mstr then do:
											for each ied_det where ied_type = "1" and	ied_nbr = so_nbr exclusive-lock:
   											delete ied_det.
											end.
											for each ie_mstr where ie_type = "1" and ie_nbr = so_nbr exclusive-lock:
   											delete ie_mstr.
											end.
											for each cmt_det where cmt_indx = so_cmtindx exclusive-lock:
   											delete cmt_det.
											end.
											{gprun.i ""gppihdel.p"" "(1, so_nbr, 0)"}
											{gprun.i ""sosoapm3.p"" "(input so_nbr)"}
											delete so_mstr.
										end. /* if avail so_mstr then do */
									end. /* if not avail sod_det */
/* SS 090902.1 - E */
								end.
								else do:
									message "����: ����ɾ��".
									undo,retry.
								end.
							end.
							else do:
/* SS 090725.1 - E */
								OUTPUT TO VALUE(fn_i + ".inp").
								put unformat """" + trim(tnbr1) + """" skip.
								put "-" skip.
								put "-" skip.
								put "-" skip.
								put "-" skip.
								put "-" skip.
								put "-" skip.
								put unformat string(sod_line) skip.
								put "-" skip.
								put unformat string(sod_qty_ord - xxsod_qty_ord) skip.
								put "-" skip.
								put "-" skip.
								IF sod_taxable THEN DO:
        					put "-" skip.
        				END.
								put "." skip.
								put "." skip.
								put "-" skip.
								put "-" skip.
								put "." skip.
								OUTPUT CLOSE .
								
								INPUT FROM VALUE(fn_i + ".inp") .
        				OUTPUT TO VALUE(fn_i + ".cim") .
        				batchrun = YES.
        				{gprun.i ""sosomt.p""}
       					batchrun = NO.
        				INPUT CLOSE .
        				OUTPUT CLOSE .
              	
								find first sod_det where sod_nbr = tnbr1 and sod_part = tpart no-lock no-error.
								if not avail sod_det or sod_qty_ord <> tqty01 - xxsod_qty_ord then do:
/* SS 091030.1 - B */
/*
									message "����:����ʧ��".
*/
/*fdfdfdfd*/   message "sosomt.p" view-as alert-box .

									if not avail sod_det then message "����:" tnbr1 "������,����ʧ��".
									else message "����:" tnbr1 "����" sod_qty_ord "����ʧ��".
/* SS 091030.1 - E */
									undo ,leave.
								end.
								unix silent value("rm -rf " + trim(fn_i)  + ".inp").
								unix silent value("rm -rf " + trim(fn_i)  + ".cim").
								
/* SS 090725.1 - B */
							end. /* else */
/* SS 090725.1 - E */

						end.	/* if avail sod_det */
						else do:
							message "����: ����" tnbr1 "������".
							undo,leave.
						end.
						
						/* �����¶�������*/
						tqty01 = 0.
						find first so_mstr where so_nbr = tnbr2 no-lock no-error.
						if avail so_mstr then do:
							find first sod_det where sod_nbr = tnbr2 and sod_part = tpart no-lock no-error.
							if avail sod_det then do:
								tqty01 = sod_qty_ord.
								OUTPUT TO VALUE(fn_i + ".inp").
								put unformat """" + trim(tnbr2) + """" skip.
								put "-" skip.
								put "-" skip.
								put "-" skip.
								put "-" skip.
								put "-" skip.
								put "-" skip.
								put unformat string(sod_line) skip.
								put "-" skip.
								put unformat string(xxsod_qty_ord + sod_qty_ord) skip.
								put "-" skip.
								/* xxsosomt.p  20100605 ��ʾ�۸� */
								put "-" skip.	
								if sod_taxable THEN DO:
        					put "-" skip.
        				END.
							end. /* if avail sod_det */
							else do: 
								OUTPUT TO VALUE(fn_i + ".inp").
								put unformat """" + trim(tnbr2) + """" skip.
								put "-" skip.
								put "-" skip.
								put "-" skip.
								put "-" skip.
								put "-" skip.
								put "-" skip.
								put "-" skip. /* line*/
								put tpart skip.
								put "-" skip.
								put unformat string(xxsod_qty_ord) skip.
								put "-" skip.
								/* xxsosomt.p 20100605 ��ʾ�۸� */
								put "-" skip. 
								put "-" skip.
								DO i = 1 to 14:
									put " - ". 
								end.
								put unformat substring(xxsod_due_date1,3,2) + substring(xxsod_due_date1,6,2) + substring(xxsod_due_date1,9,2).
								IF v_tax = YES THEN DO:
									put " - - - - - - yes" skip.
         	   			put "-" skip.
          			END.
          			else put skip.
							end.
						end. /* if avail so_mstr then do */
						else do:
							OUTPUT TO VALUE(fn_i + ".inp").
							PUT  unformat """" + trim(tnbr2) + """"  skip.
           	 	put  unformat """" + TRIM(xxsod_cust) + """" skip.
            	put  " - " SKIP.
           	 	put  " - " SKIP.
            	put  unformat SUBSTRING(xxsod_due_date1,3,2) + substring(xxsod_due_date1,6,2) + substring(xxsod_due_date1,9,2).
            	DO i = 1 TO 11 :
            		PUT " - " .
            	END.
            	PUT  unformat TRIM(xxsod_project) skip.
            	/* �������Ǳ�λ�� */
            	IF v_curr <> base_curr THEN PUT   "-" SKIP .
            	put "-" SKIP.
            	PUT "-" SKIP.
            	PUT "-" SKIP.
            	put unformat """" + tpart + """" SKIP.
            	put "-" SKIP.
            	put unformat string(xxsod_qty_ord) SKIP.
            	put " - " SKIP.
           	 	/* xxsosomt.p 100605��ʾ�۸�*/
           	 	put " - " SKIP.
           	 	put " - " skip.
         			DO i = 1 TO 14 :
            		PUT " - " .
          		END.
          		PUT unformat SUBSTRING(xxsod_due_date1,3,2) + substring(xxsod_due_date1,6,2) + substring(xxsod_due_date1,9,2).    
         	   	IF v_tax = YES THEN DO:
								put " - - - - - - yes" skip.
         	   		put "-" skip.
          		END.
          		else put skip.
						end. /* else do: */
						
						put "." skip.
						put "." skip.
						put "-" skip.
						put "-" skip.
						put "." skip.
						OUTPUT CLOSE .
					
						INPUT FROM VALUE(fn_i + ".inp") .
        		OUTPUT TO VALUE(fn_i + ".cim") .
        		batchrun = YES.
        		{gprun.i ""xxsosomt.p""}
       			batchrun = NO.
        		INPUT CLOSE .
        		OUTPUT CLOSE .


						find first sod_det where sod_nbr = tnbr2 and sod_part = tpart no-lock no-error.
						if not avail sod_det or sod_qty_ord <> tqty01 + xxsod_qty_ord then do: 
/* SS 091030.1 - B */
/*
							message "����: ����ʧ��".
*/ 
							if not avail sod_det then message "����:" tnbr2 "������,����ʧ��".
							else message "����:" tnbr2 "����" sod_qty_ord "����ʧ��".

/* SS 091030.1 - E */
							undo,leave.
						end.
						tqty01 = 0.
						unix silent value("rm -rf " + trim(fn_i)  + ".inp").
						unix silent value("rm -rf " + trim(fn_i)  + ".cim").
						
					end. /* if tdate1 <> tdate2 */
					
					/* ��¼�ı���� */
					if tdate1 <> tdate2 or ttime1 <> ttime2 then do:
						create xxsodh_hist.
						assign xxsodh_nbr = tnbr1
									 xxsodh_nbr1 = tnbr2
									 xxsodh_cust = xxsod_cust
									 xxsodh_project = xxsod_project
									 xxsodh_userid = global_userid
									 xxsodh_date = today
									 xxsodh_time = time
									 xxsodh_part = tpart
									 xxsodh_type = xxsod_type
									 xxsodh_due_date = tdate1
									 xxsodh_due_date1 = tdate2
									 xxsodh_due_time = ttime1
									 xxsodh_due_time1 = ttime2
									 xxsodh_qty_ord  = xxsod_qty_ord
									 xxsodh_qty_ord1 = xxsod_qty_ord
									 .
					end.
					
/* SS 090723.1 - E */
      end. /* for each xxsod_det  where */

      ifupdate = no.

  end. /* do transaction on error undo , retry : */

end. /* repeat: */      
