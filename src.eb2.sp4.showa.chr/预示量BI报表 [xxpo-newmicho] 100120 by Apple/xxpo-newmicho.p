/*----rev history-------------------------------------------------------------------------------------*/
/* Revision: eb2sp4	BY: Micho Yang  DATE: 10/30/08  ECO: *SS - 20081106.1* */
/* Revision: eb2sp4 BY: Ken Chen    ECO: *SS - 090416.1* */
/* SS - 090717.1 By: Roger Xiao */
/* SS - 090818.1 By: Roger Xiao */
/* SS - 100120   By: Apple Tam */

/*----rev description---------------------------------------------------------------------------------*/

/* SS - 20081106.1 - RNB
1. �޸� ��Ԥʾ�� ������ʾ������
   SS - 20081106.1 - RNE */

/* SS - 090717.1 - RNB
   roger: ��������,�����µ����ⶩ����
   SS - 090717.1 - RNE */

/* SS - 090818.1 - RNB
   roger: ���ⶩ����Ϊ������,�޸�Ϊ��
   SS - 090818.1 - RNE */


/*----main program-----------------------------------------------------------------------------------*/

/* SS - 090416.1 - B */   
   /*
   {ParseParam.i} 
   */
   

FUNCTION GetField RETURNS CHARACTER (INPUT src AS CHAR, INPUT idx AS INT, INPUT deli AS CHAR).
    DEF VAR val AS CHAR.
    DEF VAR startPos AS INT.
    DEF VAR findPos AS INT.
    DEF VAR i AS INT.

    startPos = 1.
    i = 0.
    REPEAT WHILE(i <= idx):
      findPos = INDEX(src, deli, startPos).
      IF(findPos = 0 AND i < idx) THEN
        return "".

      IF(i < idx) THEN
        startPos = findPos + 1.

      i = i + 1.
    END.

    IF(findPos = 0) THEN
      val = SUBSTRING(src, startPos).
    ELSE
      val = SUBSTRING(src, startPos, findPos - startPos).

    return val.

END FUNCTION.

FUNCTION GetParam RETURNS CHAR (INPUT pname AS CHAR).
    DEF VAR str AS CHAR.
    DEF VAR str1 AS CHAR.
    DEF VAR str2 AS CHAR.
    DEF VAR i AS INT.

    i = 0.
    REPEAT WHILE TRUE:
        str = GetField(SESSION:PARAMETER, i, ";").
        IF(str = "") THEN
            RETURN "".

        str1 = GetField(str, 0, "=").
        str1 = TRIM(str1).
        IF(str1 = pname) THEN DO:
            str2 = GetField(str, 1, "=").
            TRIM(str2).
            RETURN str2.
        END.
        
        i = i + 1.
    END.

    RETURN "".
    
END FUNCTION.

FUNCTION ToDate RETURNS DATE (INPUT datestring AS CHAR).
    DEF VAR strYear AS CHAR.
    DEF VAR strMonth AS CHAR.
    DEF VAR strDay AS CHAR.
    DEF VAR findPos AS INT.

    strYear = GetField(datestring, 0,"-").
    strMonth = GetField(datestring, 1, "-").
    strDay = GetField(datestring, 2, "-").

    RETURN DATE(INTEGER(strMonth), INTEGER(strDay), INTEGER(strYear)).

END FUNCTION.

/* SS - 090416.1 - E */ 


   
   
   DEFINE VARIABLE  startdate AS DATE.
   DEFINE VARIABLE  enddate AS DATE.
   DEFINE VARIABLE  nextdate AS DATE.
   DEFINE VARIABLE  next2date AS DATE.
   DEFINE VARIABLE  ponbr AS CHARACTER FORMAT "x(8)".
   DEFINE VARIABLE  vend AS CHARACTER FORMAT "x(18)".
   DEFINE VARIABLE  planer AS CHARACTER FORMAT "x(18)".
   DEF VAR str_due_date AS CHAR.
   DEF VAR buyer as char format "x(8)".
   DEF VAR st as char format "x(8)".
   DEF VAR adddate AS DATE.
   DEF VAR onedate AS DATE.
   DEF VAR mm as int.
   DEF VAR yy as int.
   DEF VAR i AS INTEGER.
   DEF VAR m AS INTEGER.
   DEF VAR c AS integer.
   DEF VAR a AS integer.
   DEF VAR n AS INTEGER format ">>>9" label "����ǰ".
   DEF VAR n1 AS CHAR.
   def var np as char.         /*�ɹ�������*/
   DEF VAR ch AS CHAR.     /* ȫ��Ԥʾ��*/

   DEFINE TEMP-TABLE npod_det 
         FIELD  npod_vend  LIKE  po_vend
         FIELD  npod_name LIKE ad_name FORMAT "X(56)"
         FIELD  npod_attn LIKE ad_attn
         FIELD  npod_fax  LIKE ad_fax
         FIELD  npod_part LIKE pt_part
         FIELD  npod_desc1 LIKE pt_desc1
         FIELD  npod_desc2 LIKE pt_desc2
         FIELD  npod_qty   LIKE pod_qty_ord
         FIELD  npod_next   LIKE pod_qty_ord
         FIELD  npod_next2   LIKE pod_qty_ord
         FIELD  npod_due_date LIKE pod_due_date
         FIELD  npod_um     LIKE pod_um
     	   FIELD  npod_nbr   like pod_nbr
         FIELD  npod_draw  LIKE pt_draw
	      FIELD  npod_buyer LIKE pt_buyer
	      FIELD  npod_line LIKE pod_line
	      FIELD  npod_st LIKE pt_status
	      FIELD  npod_output as int
         INDEX npod is UNIQUE  primary npod_vend npod_part npod_due_date  .

   DEF TEMP-TABLE empty1
        field empty1_item  as integer label "���" 
        field empty1_part like mrp_part LABEL "���ͼ��"
        field empty1_duedate like mrp_due_date LABEL "�ɹ�����"
        field empty1_qty like mrp_qty       LABEL "�ɹ�����"
        FIELD empty1_t LIKE pt_ord_per     LABEL "��������"
        field empty1_remark like vd_rmks FORMAT "x(7)"      LABEL "��ע"
        field empty1_addr like vd_addr label  "��Ӧ�̴���"
        field empty1_sort like vd_sort label "�ͻ�����"
        field empty1_yn as integer                LABEL "�ͻ�����(Y/N)"
        INDEX empty1 is UNIQUE  primary empty1_part  empty1_duedate empty1_qty empty1_item.
   DEF TEMP-TABLE empty2
       field empty2_ord_on as char  label "�ɹ�����" 
       field empty2_addr like vd_addr label "��Ӧ�̴���"
       field empty2_part like mrp_part LABEL "���ͼ��"
       field empty2_qty like mrp_qty       LABEL "�ɹ�����"
       field empty2_duedate like mrp_due_date LABEL "�ɹ�����"
       field empty2_month as integer label "�·�"
   
       INDEX empty2 is UNIQUE  primary empty2_part empty2_duedate /*empty2_qty */. 

FUNCTION ok_date RETURNS INTEGER  (INPUT one_date AS date, vend_str AS CHAR) FORWARD.
/* 
   startdate = ToDate(GetParam("startdate")).
   enddate  = todate(GetParam("enddate")).
   nextdate = ToDate(GetParam("nextdate")).
   next2date  = todate(GetParam("next2date")). 

   planer = GetParam("planer").  

   vend = GetParam("vend").

ponbr = "P0803HD4".
*/

   ponbr = GetParam("ponbr").
   ponbr = upper(ponbr).
   ch = GetParam("choice").
   ch = upper(ch).

   /* �Ӷ���������Ҷ�Ӧ����onedate���ƻ�Աbuyer����Ӧ��vend */
   Find first pod_det WHERE pod_nbr = ponbr NO-error.
   IF AVAILABLE pod_det  THEN do:
        onedate = pod_due_date.
        Find first pt_mstr WHERE pt_part = pod_part.
        IF AVAILABLE pt_mstr  THEN buyer = pt_buyer.
        Find first po_mstr WHERE po_nbr = pod_nbr.
        IF AVAILABLE po_mstr  THEN vend = po_vend.
   end.
 
   /* ĳ�µ�һ�� */
   mm = MONTH(onedate) .
   yy = YEAR(onedate).
   startdate = DATE(STRING( yy ) +  '/' + STRING( mm ) + '/01') .
   
   /* ĳ��ĩ���һ�� */
   mm = mm + 1.
   IF mm > 12 THEN do:
       mm = mm - 12.
       yy = yy + 1.
   END.
   enddate = DATE(STRING( yy ) +  '/' + STRING( mm ) + '/01') - 1.
   
   /* ����ĩ���һ�� */
   mm = mm + 1.
   IF mm > 12 THEN do:
       mm = mm - 12.
       yy = yy + 1.
   END.
   nextdate = DATE(STRING( yy ) +  '/' + STRING( mm ) + '/01') - 1.
   
   /* ������ĩ���һ�� */
   mm = mm + 1.
   IF mm > 12 THEN do:
       mm = mm - 12.
       yy = yy + 1.
   END.
   next2date = DATE(STRING( yy ) +  '/' + STRING( mm ) + '/01') - 1.
   
   /* mmΪ���������Ӧ��һ�����·ݣ�����mm���¶��� */
   mm = MONTH(onedate) .

OUTPUT TO "C:\qadguicli\bicallprogress\zhpod.txt".
/* OUTPUT TXT FILE */
       
/* DEFINE FIELD TYPE bi */

PUT  "#define column1 as char[10] "
     "~n#define column2 as char[10] "
     "~n#define column3 as char[40] "
     "~n#define column4 as char[24] "
     "~n#define column5 as char[16] "
     "~n#define column6 as char[18] "
     "~n#define column7 as char[24] "
     "~n#define column8 as char[24] "
     "~n#define column9 as char[10] " 
     "~n#define column10 as number "
     "~n#define column11 as char[2] "
     "~n#define column12 as number "
     "~n#define column13 as number "
     "~n#define column14 as char[18] "
     "~n#define column15 as char[18] "
     "~n#define column16 as char[18] "
     "~n#define column17 as char[10] "
     "~n#define column18 as number "
     
     "~n" .  /* Insert a new line*/

/* DEFINE INQURY FILE  LABEL NAME ~t  IS TAB KEY */
   PUT "pt_status "  "~t"
       "Vend"   "~t"   
       "Name              "   "~t" 
       "Attn"  "~t"
       "Fax"  "~t"
       "PARENT_PART"   "~t"   
       "PARENT_DESC1"   "~t"   
       "PARENT_DESC2"   "~t"   
       "Due_Date"    "~t"  
       "Qty "   "~t"  
       "UM"    "~t"   
       "Next_Qty"    "~t"  
       "Next2_Qty"   "~t"
       "flag"   "~t"
       "PO_NUMber   "  "~t"
       "pt_draw      "  "~t"
       "pt_buyer     "  "~t"
       "po_line " 
       SKIP(0) .  
       
FOR EACH npod_det:
    DELETE npod_det.
END.

/* �� pod_det ����ȡ���¶�������Ϣ                              */
/* ֻҪ�ж���������ʹ���״̬Ϊ��RD��Ҳ��Ӱ�충������Ԥʾ������� */
/* ȡ��ѡ��������ֻҪ�����붩����po_nbr =========================================
FOR EACH pod_det WHERE pod_due_date >= startdate AND pod_due_date <= enddate AND
    (pod_nbr = ponbr OR ponbr = "")  NO-LOCK,
    EACH po_mstr WHERE po_nbr = pod_nbr AND (po_vend = vend OR vend = "") NO-LOCK,
    EACH pt_mstr WHERE pt_part = pod_part and pt_buyer = buyer NO-LOCK:
================================================================================= */
FOR EACH pod_det WHERE pod_nbr = ponbr NO-LOCK,
    EACH po_mstr WHERE po_nbr = pod_nbr NO-LOCK,
    EACH pt_mstr WHERE pt_part = pod_part and pt_buyer = buyer NO-LOCK:

    FIND FIRST npod_det WHERE npod_part = pod_part AND npod_vend = po_vend 
        AND npod_due_date = pod_due_date NO-ERROR.
    IF AVAILABLE npod_det  THEN npod_qty = npod_qty + pod_qty_ord. 
    ELSE DO: 
               CREATE npod_det.
               FIND FIRST ad_mstr WHERE ad_addr = po_vend NO-LOCK NO-ERROR.
               
                ASSIGN npod_vend = ad_addr 
                       npod_name = ad_name + ad_line3
                       npod_attn = ad_attn
                       npod_fax  = ad_fax
                       npod_part = pt_part
                       npod_desc1 = pt_desc1
                       npod_desc2 = pt_desc2
                       npod_qty = pod_qty_ord
                       npod_due_date = pod_due_date
                       npod_um = pt_um
                       npod_nbr = pod_nbr
                       npod_draw = pt_draw
                       npod_buyer = pt_buyer
                       npod_st = pt_status
                       npod_line = pod_line
                       npod_output = 1.

                   FIND FIRST npod_det WHERE npod_vend = ad_addr 
                       AND npod_part = pt_part AND npod_due_date = 12/12/12  NO-LOCK NO-ERROR.
                   IF NOT AVAILABLE npod_det THEN DO:
                  

                                    CREATE npod_det.
                                    ASSIGN  npod_vend = ad_addr 
                                            npod_name = ad_name + ad_line3
                                            npod_attn = ad_attn
                                            npod_fax  = ad_fax
                                            npod_part = pt_part
                                            npod_desc1 = pt_desc1
                                            npod_desc2 = pt_desc2
                                            npod_due_date = 12/12/12
                                            npod_um = pt_um
                                            npod_nbr = ponbr
                                            npod_draw = pt_draw
                        				  	     npod_buyer = pt_buyer
                        					     npod_st = pt_status
                        					     npod_output = 1.
                   END. 
    END.
END.

/* Ϊ��ֹ©������������1.4.3���״̬Ϊ��AC���͡�SP���������ȫ����ʾԤʾ�� */
For each pt_mstr where ( pt_status = "AC" or pt_status = "SP") and pt_buyer = buyer and pt_vend = vend no-lock:
   FIND FIRST npod_det WHERE npod_part = pt_part AND npod_due_date = 12/12/12  NO-LOCK NO-ERROR.
   IF NOT AVAILABLE npod_det THEN DO:
      CREATE npod_det.
      FIND FIRST ad_mstr WHERE ad_addr = vend NO-LOCK NO-ERROR.
      ASSIGN  npod_vend = ad_addr 
              npod_name = ad_name + ad_line3
              npod_attn = ad_attn
              npod_fax  = ad_fax
              npod_part = pt_part
              npod_desc1 = pt_desc1
              npod_desc2 = pt_desc2
              npod_due_date = 12/12/12
              npod_um = pt_um
              npod_nbr = ponbr
              npod_draw = pt_draw
              npod_buyer = pt_buyer
              npod_st = pt_status
              npod_output = 0.
   END. 
end.


/* ========================================================================================================== */
/* �������º�������Ԥʾ�� */
FOR EACH npod_det where npod_due_date = 12/12/12,
    EACH pt_mstr where pt_part = npod_part,
    EACH mrp_det WHERE mrp_part = npod_part and mrp_due_date <= (next2date + 31)  AND mrp_detail = "�ƻ���"  USE-INDEX mrp_part,                       /*FOR 1*/
    EACH vd_mstr WHERE vd_addr = vend BREAK BY mrp_part BY mrp_due_date:
    
      if vd_rmks = "" then vd_rmks = "0111110".                                    /*�����Ӧ�̱�עûά��Ĭ��ÿ����һ���嶼���ͻ� */
      c = ok_date(mrp_due_date, vd_rmks).
      n = n + 1.
      find first empty1 where empty1_part = mrp_part and empty1_duedate = mrp_due_date no-error.
      if not available empty1 then do:
         CREATE empty1.
         ASSIGN    
         EMPTY1_ITEM = N
         empty1_part = mrp_part
         empty1_duedate = mrp_due_date
         empty1_qty = mrp_qty
         empty1_t = int(pt_rev)         /*�ͻ�����*/
         empty1_remark = vd_rmks
         empty1_sort = vd_sort
         empty1_addr = vd_addr
         empty1_yn = c.
      end.
      else
         ASSIGN
         EMPTY1_ITEM = N
         empty1_part = mrp_part
         empty1_duedate = mrp_due_date
         empty1_qty = empty1_qty + mrp_qty     /* �������ͬһ��ͬ����Ķ�����¼�������ۼ� */
         empty1_t = int(pt_rev)         /*�ͻ�����*/
         empty1_remark = vd_rmks
         empty1_sort = vd_sort
         empty1_addr = vd_addr
         empty1_yn = c.
END.  /*FOR 1*/


/***********************************************************************************************************/
/*===========    ����β���Ĵ���:����С��14�ľ��˺���һ�����ͻ���;���ڴ��ڵ���14�ľ�ֱ�����   ===========*/
/***********************************************************************************************************/
FOR EACH empty1 break by empty1_part:                   /*FOR 2*/
    FIND LAST empty2 WHERE empty2_part = empty1_part NO-ERROR .
         
    IF NOT AVAILABLE empty2 THEN 
        do:   /*do a*/
           IF empty1_yn = 1 THEN /* if empty1_t >= 14 then */
               do: /*do b*/
    /*&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&�޸�ԭ��:���ԭ�����ж�����β��i >= 2 ʱ�����Զ�����β��Ϊ i+1 ���¶���&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&*/
    /*&*/          a = 1.                                                                                                                                      /*&*/
    /*&*/          UU:                                                                                                                                         /*&*/
    /*&*/	  repeat:                                                                                                                                      /*&*/
    /*&*/          n1 = 'P' + substring(string(empty1_duedate),1,2) + substring(string(empty1_duedate),4,2) + substring(empty1_sort,1,2) + string(a).          /*&*/
    /*&*/	   find po_mstr where po_nbr = n1  NO-ERROR.                                                                                                   /*&*/
    /*&*/          if not available po_mstr then                                                                                                               /*&*/
    /*&*/               do:                                                                                                                                    /*&*/
    /*&*/                np = n1.                                                                                                                              /*&*/
    /*&*/	        leave uu.                                                                                                                              /*&*/
    /*&*/	      end.                                                                                                                                     /*&*/
    /*&*/	   else                                                                                                                                        /*&*/
    /*&*/	      do:                                                                                                                                      /*&*/
    /*&*/	         a = a + 1.                                                                                                                            /*&*/
    /*&*/		 if a > 9 then                                                                                                                         /*&*/
    /*&*/		     do:                                                                                                                               /*&*/
    /*&*/		        np = 'P' + substring(string(empty1_duedate),1,2) + substring(string(empty1_duedate),4,2) + substring(empty1_sort,1,2) + "Z".   /*&*/
    /*&*/		        leave uu.                                                                                                                      /*&*/
    /*&*/		     end.                                                                                                                              /*&*/
    /*&*/	      end.                                                                                                                                     /*&*/
    /*&*/	   end.                                                                                                                                        /*&*/
    /*&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& �޸�ʱ��: 07/12/13&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&*/
		   CREATE empty2.
                       ASSIGN 
                       empty2_ord_on = np
	               empty2_addr = empty1_addr
	               empty2_part = empty1_part
	               empty2_qty = empty1_qty
                       empty2_duedate = empty1_duedate
		       empty2_month = month(empty1_duedate).
	       end.
	    else
	        do:  /*do c*/
                   XX:
		   repeat:
		    empty1_duedate = empty1_duedate - 1.
		    if ok_date(empty1_duedate,vd_rmks) = 1 then 
		    leave XX.
		   end.
/*&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&�޸�ԭ��:���ԭ�����ж�����β��i >= 2 ʱ�����Զ�����β��Ϊ i+1 ���¶���&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&*/
/*&*/              a = 1.                                                                                                                                      /*&*/
/*&*/              UU:                                                                                                                                         /*&*/
/*&*/   	   repeat:                                                                                                                                     /*&*/
/*&*/		   n1 = 'P' + substring(string(empty1_duedate),1,2) + substring(string(empty1_duedate),4,2) + substring(empty1_sort,1,2) + string(a).          /*&*/
/*&*/		   find po_mstr where po_nbr = n1  NO-ERROR.                                                                                                   /*&*/
/*&*/              if not available po_mstr then                                                                                                               /*&*/
/*&*/                 do:                                                                                                                                      /*&*/
/*&*/		        np = n1.                                                                                                                               /*&*/
/*&*/		        leave uu.                                                                                                                              /*&*/
/*&*/		      end.                                                                                                                                     /*&*/
/*&*/		   else                                                                                                                                        /*&*/
/*&*/		      do:                                                                                                                                      /*&*/
/*&*/		         a = a + 1.                                                                                                                            /*&*/
/*&*/			 if a > 9 then                                                                                                                         /*&*/
/*&*/			     do:                                                                                                                               /*&*/
/*&*/			        np = 'P' + substring(string(empty1_duedate),1,2) + substring(string(empty1_duedate),4,2) + substring(empty1_sort,1,2) + "Z".   /*&*/
/*&*/			        leave uu.                                                                                                                      /*&*/
/*&*/			     end.                                                                                                                              /*&*/
/*&*/		      end.                                                                                                                                     /*&*/
/*&*/		   end.                                                                                                                                        /*&*/
/*&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& �޸�ʱ��: 07/12/13&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&*/
                   CREATE empty2.
                       ASSIGN
                       empty2_ord_on = np
	               empty2_addr = empty1_addr
	               empty2_part = empty1_part
	               empty2_qty = empty1_qty
                       empty2_duedate = empty1_duedate
		       empty2_month = month(empty1_duedate).
		end. /*end do c*/
	  end.  /*end do a*/
     ELSE
     DO: /*do d*/

         IF empty1_yn = 0 THEN   /****���ڲ��ǿ��ͻ��յļ�¼,�����empty2�е����һ����¼ʱ���С���ͻ����ڵĻ��ͽ�����ֱ�����,����������ڵĻ��ͽ��Ƶ����һ�����ͻ������һ���¼�¼****/
	 do:
	    if abs(empty1_duedate - empty2_duedate) < empty1_t then
	       empty2_qty = empty2_qty + empty1_qty. 
            if abs(empty1_duedate - empty2_duedate) >= empty1_t then
	       do:
	          XX:
		   repeat:
		    empty1_duedate = empty1_duedate - 1.
		    if ok_date(empty1_duedate,vd_rmks) = 1 then 
		    leave XX.
		   end.
		   find empty2 where empty2_part = empty1_part and empty2_duedate = empty1_duedate no-error.                                              
		        if not available empty2 then do:                                                                                                 
/*&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&�޸�ԭ��:���ԭ�����ж�����β��i >= 2 ʱ�����Զ�����β��Ϊ i+1 ���¶���&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&*/
/*&*/              a = 1.                                                                                                                                      /*&*/
/*&*/              UU:                                                                                                                                         /*&*/
/*&*/   	   repeat:                                                                                                                                     /*&*/
/*&*/		   n1 = 'P' + substring(string(empty1_duedate),1,2) + substring(string(empty1_duedate),4,2) + substring(empty1_sort,1,2) + string(a).          /*&*/
/*&*/		   find po_mstr where po_nbr = n1  NO-ERROR.                                                                                                   /*&*/
/*&*/              if not available po_mstr then                                                                                                               /*&*/
/*&*/                 do:                                                                                                                                      /*&*/
/*&*/		        np = n1.                                                                                                                               /*&*/
/*&*/		        leave uu.                                                                                                                              /*&*/
/*&*/		      end.                                                                                                                                     /*&*/
/*&*/		   else                                                                                                                                        /*&*/
/*&*/		      do:                                                                                                                                      /*&*/
/*&*/		         a = a + 1.                                                                                                                            /*&*/
/*&*/			 if a > 9 then                                                                                                                         /*&*/
/*&*/			     do:                                                                                                                               /*&*/
/*&*/			        np = 'P' + substring(string(empty1_duedate),1,2) + substring(string(empty1_duedate),4,2) + substring(empty1_sort,1,2) + "Z".   /*&*/
/*&*/			        leave uu.                                                                                                                      /*&*/
/*&*/			     end.                                                                                                                              /*&*/
/*&*/		      end.                                                                                                                                     /*&*/
/*&*/		   end.                                                                                                                                        /*&*/
/*&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& �޸�ʱ��: 07/12/13&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&*/                                                                                        
                          CREATE empty2.                               /*=====================================*/                                                     
                                  ASSIGN                                /* ��γ��������жϿձ�һ�����ݵ�ʱ��  */                                                      
                                  empty2_ord_on = np                    /* ��������������Ƿ���ձ�2���������� */                                           
	                          empty2_addr = empty1_addr             /* ����Ѵ�������ź����ڶ���ȵļ�¼  */
	                          empty2_part = empty1_part             /* �ͽ���1�и�����������ӵ���2��Ӧ��  */
	                          empty2_qty = empty1_qty               /* ��¼��;���������,���ڱ�2�д���һ�� */
                                  empty2_duedate = empty1_duedate       /* �µļ�¼.                           */
				  empty2_month = month(empty1_duedate). /* �޸�����:   2007/12/10              */
		          end.                                          /*=====================================*/
		      else                                              
		           empty2_qty = empty2_qty + empty1_qty.        
		           
	       end.
            end.
         IF empty1_yn = 1 THEN
            DO:
	       if abs(empty1_duedate - empty2_duedate) < empty1_t then   /*ͬ�ǿ��ͻ��յ����ڼ��С���ͻ����ڵ�,�������ϲ�.*/
	          empty2_qty = empty2_qty + empty1_qty. 
	       else do:        /*���ǿ��ͻ��������ڼ�������ͻ����ڵ�,����һ���¼�¼*/
                   a = 1.
                   UU:
		   repeat:
		   n1 = 'P' + substring(string(empty1_duedate),1,2) + substring(string(empty1_duedate),4,2) + substring(empty1_sort,1,2) + string(a).
		   find po_mstr where po_nbr = n1  NO-ERROR.
                   if not available po_mstr then
                      do:
		        np = n1.
		        leave uu.
		      end.
		   else 
		      do:
		         a = a + 1.
			 if a > 9 then 
			     do:
			        np = 'P' + substring(string(empty1_duedate),1,2) + substring(string(empty1_duedate),4,2) + substring(empty1_sort,1,2) + "Z".
			        leave uu.
			     end.
		      end.
		   end.
		 /*np = empty2_ord_on. */
	        CREATE empty2.
                ASSIGN
                empty2_ord_on = np
	        empty2_addr = empty1_addr
	        empty2_part = empty1_part
	        empty2_qty = empty1_qty
                empty2_duedate = empty1_duedate
		empty2_month = month(empty1_duedate).
		end.
	    END.
		
     END. /*end do d*/
         
END.  /*FOR 2*/

for each npod_det where npod_due_date = 12/12/12,
    each empty2 where empty2_part = npod_part:
    /* SS - 20081106.1 - B */
    /*
    if empty2_month = mm + 1 then npod_next = npod_next + empty2_qty.
    else if empty2_month = mm + 2 then npod_next2 = npod_next2 + empty2_qty.
    */
    if empty2_month = MONTH(nextdate) then npod_next = npod_next + empty2_qty.
    else if empty2_month = MONTH(next2date) then npod_next2 = npod_next2 + empty2_qty.
    /* SS - 20081106.1 - E */
/*ss - 100120*/
        find first pt_mstr where pt_part = npod_part no-lock no-error.
	if available pt_mstr then do:
           if pt_ord_mult <> 0 then do:              
	      if (npod_next / pt_ord_mult ) - integer(npod_next / pt_ord_mult) > 0 then
	              npod_next  = integer(npod_next / pt_ord_mult) * pt_ord_mult + pt_ord_mult.
		 else npod_next  = integer(npod_next / pt_ord_mult) * pt_ord_mult.
              if (npod_next2 / pt_ord_mult ) - integer(npod_next2 / pt_ord_mult) > 0 then
	              npod_next2 = integer(npod_next2 / pt_ord_mult) * pt_ord_mult + pt_ord_mult.
		 else npod_next2  = integer(npod_next2 / pt_ord_mult) * pt_ord_mult.
	   end.
	end.
/*ss - 100120*/
end.


/* SS - 090717.1 - B */
    /****�����˴�:
    ���������µ�Ԥʾ��(����mrp)�Ѿ�����1.4.7�İ�ȫ���,
    ֻ���ڴ˴��������µ����ⶩ���������µ����ⶩ������
    ���µ����ⶩ��   = ���°�ȫ���-���°�ȫ���
    �����µ����ⶩ�� = �����°�ȫ���-���°�ȫ���

    1.�ص�?:���òɹ����ױʼ�¼�ĵص�(ͬ��Ӧ�̲�̫�����ջ��������ص�)
    2.����?:ȡ����ĸ���,12�º�,�������뵽1��,
    *******/

    define var v_qty_next1 like pod_qty_ord .
    define var v_qty_next2 like pod_qty_ord .
    define var v_site like pod_site .
    find first pod_det where pod_nbr = ponbr  no-lock no-error .
    v_site = if avail pod_Det then pod_site else "" .

    for each npod_det where npod_due_date = 12/12/12 :
        find first xsqty_mstr where xsqty_part = npod_part and xsqty_site = ""  no-lock no-error .     /*���ȼ�-2*/
        find first xsqty_mstr where xsqty_part = npod_part and xsqty_site = v_site no-lock no-error .  /*���ȼ�-1*/
        v_qty_next1 = if avail xsqty_mstr then xsqty_sqty[month(nextdate)]  - xsqty_sqty[month(onedate)]  else  0.
        v_qty_next2 = if avail xsqty_mstr then xsqty_sqty[month(next2date)] - xsqty_sqty[month(nextdate)] else  0.
        /*�����и�����: month(onedate)>=month(xsqty_date)*/

        /* SS - 090818.1 - B */
        if v_qty_next1 < 0 then v_qty_next1 = 0 .
        if v_qty_next2 < 0 then v_qty_next2 = 0 .
        /* SS - 090818.1 - E */

        npod_next  = npod_next  + v_qty_next1.
        npod_next2 = npod_next2 + v_qty_next2.

/*ss - 100120*/
        find first pt_mstr where pt_part = npod_part no-lock no-error.
	if available pt_mstr then do:
           if pt_ord_mult <> 0 then do:              
	      if (npod_next / pt_ord_mult ) - integer(npod_next / pt_ord_mult) > 0 then
	              npod_next  = integer(npod_next / pt_ord_mult) * pt_ord_mult + pt_ord_mult.
		 else npod_next  = integer(npod_next / pt_ord_mult) * pt_ord_mult.
              if (npod_next2 / pt_ord_mult ) - integer(npod_next2 / pt_ord_mult) > 0 then
	              npod_next2  = integer(npod_next2 / pt_ord_mult) * pt_ord_mult + pt_ord_mult.
		 else npod_next2  = integer(npod_next2 / pt_ord_mult) * pt_ord_mult.
	   end.
	end.
/*ss - 100120*/

    end. /*for each npod_det*/
/* SS - 090717.1 - E */


/* ������¶�������Ԥʾ���ı� */
if ch = "Y" THEN do:
      FOR EACH npod_det :
         IF npod_due_date = 12/12/12 THEN DO:
   		   str_due_date = "Ԥʾ��".
   	   END.
         ELSE IF npod_due_date <> ? THEN DO:
   		   str_due_date = STRING(npod_due_date).
   	   END.
         ELSE str_due_date  = " ".
            
         PUT   
            npod_st   "~t"        
            npod_vend      "~t"   
            npod_name     "~t"  
            npod_attn     "~t"
            npod_fax       "~t"
            npod_part    "~t"
            npod_desc1     "~t"
            npod_desc2  "~t" 
            npod_due_date  "~t"
            npod_qty   "~t"
            npod_um     "~t"
            npod_next  "~t"
            npod_next2   "~t" 
            str_due_date   "~t" 
            npod_nbr   "~t" 
            npod_draw "~t"
            npod_buyer "~t"
            npod_line
            SKIP(0).
      END.
end.
else do:
      /* ɾ��������ЧԤʾ��(����Ԥʾ��������Ԥʾ��Ϊ0,�ұ���û�ж������� */
      FOR EACH npod_det :
         IF npod_due_date = 12/12/12 THEN 
            str_due_date = "Ԥʾ��".
         ELSE IF npod_due_date <> ? THEN 
            str_due_date = STRING(npod_due_date).
         ELSE str_due_date  = " ".
         
         if npod_due_date = 12/12/12 and npod_next = 0 and npod_next2 = 0 and npod_output = 0 then next. 
         else
         PUT   
            npod_st   "~t"        
            npod_vend      "~t"   
            npod_name     "~t"  
            npod_attn     "~t"
            npod_fax       "~t"
            npod_part    "~t"
            npod_desc1     "~t"
            npod_desc2  "~t" 
            npod_due_date  "~t"
            npod_qty   "~t"
            npod_um     "~t"
            npod_next  "~t"
            npod_next2   "~t" 
            str_due_date   "~t" 
            npod_nbr   "~t" 
            npod_draw "~t"
            npod_buyer "~t"
            npod_line
            SKIP(0).
      END.
end.

OUTPUT CLOSE.



/*--------------------------------*/
/* �Զ��庯���������Ƿ�Ϊ���ͻ��� */
/*--------------------------------*/
FUNCTION ok_date RETURNS INTEGER (INPUT one_date AS date, vend_str AS CHAR).
DEF VAR str1 AS CHAR.
DEF VAR str2 AS CHAR.
DEF VAR str3 AS CHAR.
DEF VAR date1 AS DATE.
DEF VAR date2 AS DATE.
DEF VAR date3 AS DATE.


CASE substring(vend_str,1,1):
    WHEN "a" or WHEN "A" THEN
      do:
         date1 = date(string(year(one_date)) + "/" +  string(month(one_date)) + "/" + substring(vend_str,2,2)).
         if weekday(date1) =1 then
	    date1 = date1 + 1.
	 else if weekday(date1) = 7 then
	    date1 = date1 + 2.
         AA:
	 Repeat:
	 FIND LAST hd_mstr WHERE hd_date = date1 NO-ERROR .
         IF NOT AVAILABLE hd_mstr THEN 
	      do:
	          if one_date = date1 then 
		     RETURN (1).
                  ELSE
                      IF weekday(date1) <> 1  THEN
                          IF WEEKDAY(date1) <> 7 THEN
		                        RETURN (0).
                          ELSE date1 = date1 + 2.
                      ELSE date1 = date1 + 1.
	      end.
	 ELSE
	        date1 = date1 + 1.
	 END.
      end.
    WHEN "b" or WHEN "B" THEN
      do:

	 date1 = date(string(year(one_date)) + "/" +  string(month(one_date)) + "/" + substring(vend_str,2,2)).
         if weekday(date1) =1 then
	    date1 = date1 + 1.
	 else if weekday(date1) = 7 then
	    date1 = date1 + 2.
	 date2 = date(string(year(one_date)) + "/" +  string(month(one_date)) + "/" + substring(vend_str,4,2)).
         if weekday(date2) = 1 then
	    date2 = date2 + 1.
	 else if weekday(date2) = 7 then
	    date2 = date2 + 2.

	 BB:
	 Repeat:	 
	 FIND LAST hd_mstr WHERE hd_date = date1 NO-ERROR .
         IF NOT AVAILABLE hd_mstr THEN 
	      do:
	          if one_date = date1 then 
		     RETURN (1).
                  ELSE 
                      IF weekday(date1) <> 1  THEN
                          IF WEEKDAY(date1) <> 7 THEN
		                        leave BB.
                          ELSE date1 = date1 + 2.
                      ELSE date1 = date1 + 1.
	      end.
	 ELSE

	        date1 = date1 + 1.
	 END.

	 CC:
	 Repeat:
	 FIND LAST hd_mstr WHERE hd_date = date2 NO-ERROR .
         IF NOT AVAILABLE hd_mstr THEN 
	      do:
	          if one_date = date2 then 
		     RETURN (1).
                  ELSE
                      IF weekday(date2) <> 1  THEN
                          IF WEEKDAY(date2) <> 7 THEN
		               RETURN (0).
                          ELSE date2 = date2 + 2.
                      ELSE date2 = date2 + 1.
	      end.
	 ELSE
	        date2 = date2 + 1.
	 END.
 
      end.
    WHEN "c" or WHEN "C" THEN
      do:
         date1 = date(string(year(one_date)) + "/" +  string(month(one_date)) + "/" + substring(vend_str,2,2)).
         if weekday(date1) =1 then
	    date1 = date1 + 1.
	 else if weekday(date1) = 7 then
	    date1 = date1 + 2.
	 date2 = date(string(year(one_date)) + "/" +  string(month(one_date)) + "/" + substring(vend_str,4,2)).
         if weekday(date2) =1 then
	    date2 = date2 + 1.
	 else if weekday(date2) = 7 then
	    date2 = date2 + 2.
	 date3 = date(string(year(one_date)) + "/" +  string(month(one_date)) + "/" + substring(vend_str,6,2)).
         if weekday(date3) =1 then
	    date3 = date3 + 1.
	 else if weekday(date3) = 7 then
	    date3 = date3 + 2.
	 dd:
	 Repeat:
	 FIND LAST hd_mstr WHERE hd_date = date1 NO-ERROR .
         IF NOT AVAILABLE hd_mstr THEN 
	      do:
	          if one_date = date1 then 
		     RETURN (1).
                  ELSE 
                      IF weekday(date1) <> 1  THEN
                          IF WEEKDAY(date1) <> 7 THEN
		                        leave dd.
                          ELSE date1 = date1 + 2.
                      ELSE date1 = date1 + 1.
	      end.
	 ELSE
	        date1 = date1 + 1.
	 END.

	 ee:
	 Repeat:
	 FIND LAST hd_mstr WHERE hd_date = date2 NO-ERROR .
         IF NOT AVAILABLE hd_mstr THEN 
	      do:
	          if one_date = date2 then 
		     RETURN (1).
                  ELSE 
                      IF weekday(date2) <> 1  THEN
                          IF WEEKDAY(date2) <> 7 THEN
		                        leave ee.
                          ELSE date2 = date2 + 2.
                      ELSE date2 = date2 + 1.
	      end.
	 ELSE
	        date2 = date2 + 1.
	 END.

	 ff:
	 Repeat:
	 FIND LAST hd_mstr WHERE hd_date = date3 NO-ERROR .
         IF NOT AVAILABLE hd_mstr THEN 
	      do:
	          if one_date = date3 then 
		     RETURN (1).
                  ELSE
                      IF weekday(date3) <> 1  THEN
                          IF WEEKDAY(date3) <> 7 THEN
		                        RETURN (0).
                          ELSE date3 = date3 + 2.
                      ELSE date3 = date3 + 1.
	      end.
	 ELSE
	        date3 = date3 + 1.
	 END.

      end.
    
    OTHERWISE
      do:
        IF SUBSTRING( vend_str, weekday(one_date),1) = "1" then
            DO:
               FIND LAST hd_mstr WHERE hd_date = one_date NO-ERROR .
               IF NOT AVAILABLE hd_mstr THEN
                    RETURN (1).
               ELSE RETURN (0).
            END.
           
        ELSE RETURN (0).
      end.
END CASE.      

END FUNCTION.
