/*ss - 110329.1 by: jack */  /* ��������ϸ���ܼƻ� */
/* ss - 110409.1 by: jack */  /* �ܼƻ�����ʱ���뵼�뵽xxsod_det��*/
/* ss - 110412.1 by: jack */  /* ����ʱ���ָ�ƻ� �� ���ӿ�ʼ���ںͽ����������У�������ε���������ڴ˷�Χ���޼ƻ���ɾ�������������ֶ�����*/
/* ss - 110422.1 by: jack */  /* ���ܿ���,��ʼ���ںͽ������ڱȽ��·� */  
/*  110422.1 -b
    sp���ܼƻ�ʱ�������¼��������֮��Ķ��������û�ж������½�����
 ss0422.1 -e 
*/
/* ss - 110425.1 -b */  /* ���ָ� v_qty_ord = 0 ʱ v_qty_ord = v_qty_ord`  */
/* ss - 110626.1 by: jack */  /* ���ı���������ת�� */
/* ss - 110704.1-2 by:jack */  /* �޸ĸ�ʽΪ��ʱ������t1,����ʱsp���ۼ� ,�����ͷ�s,m�������տ��ư汾*/
/* ss - 110831.1 by: jack */  /* ����ϸ���벻���Ƽ���  */
/* ss - 111027.1 bY; jack */ /* ��Ϊmp��ʱ����̯����ʱע����sod__dec01 ����*/
/* ss - 111129.1 by: jack */ /* ��û�в���ʱ����ɾ��ʱ�ļƻ� */

/* cm_sort ǰ��λ���� */
/*
{mfdtitle.i "110425.1"}
*/
/*
{mfdtitle.i "110626.1"}
*/
/*
{mfdtitle.i "110704.2"}
*/
/*
{mfdtitle.i "110831.1"}
*/
/*
{mfdtitle.i "111027.1"}
*/
{mfdtitle.i "111129.1"}

define variable vchr_file-name  as character format "x(30)":U   INIT  "/cim/lxy/"  .
DEFINE VAR v_nbr LIKE xxdp_nbr .
DEFINE VAR v_line AS CHAR .
DEFINE VAR m AS INT .
DEFINE VAR v_date AS DATE .
DEFINE VAR v_day AS INT .
DEFINE VAR v_holiday AS INT .
DEFINE VAR v_start AS DATE .
DEFINE VAR v_end AS DATE .
DEFINE VAR v_qty LIKE tr_qty_loc .
DEFINE VAR v_qty_old LIKE tr_qty_loc .
DEFINE VAR v_qty_new LIKE tr_qty_loc .
DEFINE VAR v_qty_ord LIKE sod_qty_ord .
DEFINE VAR v_qty_ord1 LIKE sod_qty_ord .  /* ��Ϊ��ʼ���ڵĵ�һ�충��������*/
DEFINE VAR v_qty_ord2 LIKE sod_qty_ord .  /* ��Ϊ��ʼ���ڵĵ�һ�충��������*/
DEFINE VAR v_sonbr LIKE so_nbr .
DEF VAR j AS INTEGER .
DEFINE VAR n AS INT .
DEFINE VAR v_last_date AS DATE .  /*  ��¼�����һ��������*/
/* ss - 110704.1 -b */

DEFINE VAR v_qty_ord3 LIKE sod_qty_ord .  /* �洢��������sp��w��������ʱ*/
/* ss - 110704.1 -e */
DEFINE TEMP-TABLE t1
    /* ss - 110412.1 -b */
    FIELD t1_start AS DATE
    FIELD t1_end AS DATE 
    /* ss - 110412.1 -e */
    FIELD t1_type AS CHAR
    FIELD t1_add AS CHAR    /* ���� 1 or���� �� */
    FIELD t1_cust AS CHAR
    FIELD t1_seq AS CHAR
    FIELD t1_vend LIKE ad_addr
    FIELD t1_site LIKE si_site
    FIELD t1_cust_part LIKE pt_part
    FIELD t1_desc1 LIKE pt_desc1
    FIELD t1_desc2 LIKE pt_desc2
    FIELD t1_plancode LIKE xxdp_plancode
    FIELD t1_date LIKE xxdp_date
    FIELD t1_time AS CHAR
    FIELD t1_qty AS DECIMAL
    FIELD t1_check AS CHAR 
    FIELD t1_ver AS CHAR
    FIELD t1_month AS INT
      /* ss - 110409.1 -b 
    FIELD t1_ptype AS CHAR /* sp mp */
     ss - 110409.1 -e */
    /* ss - 110409.1 -b */
    FIELD t1_ptype1 AS CHAR   /* xxsod_category */
    /* ss s- 110409.1 -e */
    FIELD t1_rmks LIKE xxdp_rmks
    FIELD t1_rmks1 LIKE xxdp_rmk1
    FIELD t1_del AS CHAR   /* 1 ɾ��������*/
    FIELD t1_part LIKE pt_part
     /* ss - 110409.1 -b */
    FIELD t1_ptype AS CHAR /* sp mp */
    /* ss - 110409.1 -e */
    INDEX t1_date t1_type t1_ptype t1_cust t1_ver  t1_cust_part  t1_date 

  
    .

/* ss - 110626.1 -b */

DEFINE TEMP-TABLE t3
    /* ss - 110412.1 -b */
    FIELD t3_start AS CHAR
    FIELD t3_end AS CHAR 
    /* ss - 110412.1 -e */
    FIELD t3_type AS CHAR
    FIELD t3_add AS CHAR    /* ���� 1 or���� �� */
    FIELD t3_cust AS CHAR
    FIELD t3_seq AS CHAR
    FIELD t3_vend LIKE ad_addr
    FIELD t3_site LIKE si_site
    FIELD t3_cust_part LIKE pt_part
    FIELD t3_desc1 LIKE pt_desc1
    FIELD t3_desc2 LIKE pt_desc2
    FIELD t3_plancode LIKE xxdp_plancode
    FIELD t3_date AS CHAR
    FIELD t3_time AS CHAR
    FIELD t3_qty AS DECIMAL
    FIELD t3_check AS CHAR 
    FIELD t3_ver AS CHAR
    FIELD t3_month AS INT
      /* ss - 110409.1 -b 
    FIELD t3_ptype AS CHAR /* sp mp */
     ss - 110409.1 -e */
    /* ss - 110409.1 -b */
    FIELD t3_ptype1 AS CHAR   /* xxsod_category */
    /* ss s- 110409.1 -e */
    FIELD t3_rmks LIKE xxdp_rmks
    FIELD t3_rmks1 LIKE xxdp_rmk1
    FIELD t3_del AS CHAR   /* 1 ɾ��������*/
    FIELD t3_part LIKE pt_part
     /* ss - 110409.1 -b */
    FIELD t3_ptype AS CHAR /* sp mp */
    /* ss - 110409.1 -e */
    INDEX t3_date t3_type t3_ptype t3_cust t3_ver  t3_cust_part  t3_date 

  
    .
/* ss - 110626.1 -e */

/* ss - 110412.1 -b */
DEFINE TEMP-TABLE t2
    FIELD t2_type AS CHAR
    FIELD t2_ptype AS CHAR
    FIELD t2_cust AS CHAR
    FIELD t2_ver AS CHAR
    FIELD t2_part LIKE pt_part
    FIELD t2_cust_part LIKE pt_part
    FIELD t2_add AS CHAR
    FIELD t2_start AS DATE
    FIELD t2_end AS DATE
    .
/* ss - 110412.1 -e */

DEF TEMP-TABLE ttem 
    FIELD ttem_type1 AS CHAR
    FIELD ttem_type AS CHAR
    FIELD ttem_cust LIKE xxsod_cust
    FIELD ttem_part LIKE xxsod_part
    FIELD ttem_desc AS CHAR FORMAT "x(120)"
    .
DEF TEMP-TABLE tto
    FIELD tto_nbr LIKE so_nbr 
    .
DEF VAR fn_me AS CHAR FORMAT "x(30)" INIT  "/cim/lxy/so_err.txt"  .
DEF VAR fn_ok AS CHAR FORMAT "x(30)" INIT  "/cim/lxy/so_ok.txt"  .
DEFINE VAR i AS INT .


DEFINE VAR v_sort AS CHAR .
    DEFINE VAR v_month AS CHAR .
    DEFINE VAR v_year AS CHAR .
    DEFINE VAR v_addso AS LOGICAL .
    DEFINE VAR v_addsod AS LOGICAL .
    DEFINE VAR v_i LIKE sod_line .
    DEF VAR fn_i AS CHAR .

    DEF VAR v_tax LIKE pt_taxable .
    DEF VAR v_tax1 LIKE pt_taxable .
    
    DEF VAR v_flag AS LOGICAL.
    DEF VAR v_type LIKE xxsod_type.
    DEF VAR v_flag_nbr AS CHAR.
    DEF VAR v_ord_date AS CHAR.
    DEF VAR vv_ord_date LIKE tr_effdate .
    DEF VAR vv_ord_date1 LIKE tr_effdate .


    DEFINE TEMP-TABLE tt   /* ��¼�ܼƻ����θ��Ǹ��µ����ڷ�Χ */
        
    FIELD tt_type AS CHAR
    FIELD tt_cust AS CHAR
    FIELD tt_start LIKE xxdp_date
    FIELD tt_end LIKE xxdp_date
    FIELD tt_ver AS CHAR
    FIELD tt_ptype AS CHAR   /* sp mp */
    FIELD tt_part LIKE pt_part
    FIELD tt_total LIKE sod_qty_ord
   /* ss - 111027.1 -b */
   FIELD tt_total1 LIKE sod_qty_ord   /* �洢m���Ͷ����ĵ�����*/
    /* ss - 111027.1 -e */
    FIELD tt_day AS INT
        /* ss - 111129.1 -b */
        FIELD tt_sodnbr LIKE sod_nbr
        FIELD tt_sodline LIKE sod_line
        FIELD tt_qty_ord LIKE sod_qty_ord
        /* ss - 111129.1 -e */
    INDEX tt_type tt_type tt_ptype tt_cust tt_ver  tt_part   

  
    .
    
    DEFINE TEMP-TABLE ts
        FIELD ts_nbr LIKE sod_nbr
        FIELD ts_line LIKE sod_line
        FIELD ts_part LIKE sod_part
        FIELD ts_qty_ord LIKE sod_qty_ord
        FIELD ts_total LIKE sod_qty_ord
        FIELD ts_day AS INT
        .


    /* ss - 090909.1 -b */
    define var v_curr like vd_curr .
    define var v_um like pt_um .
    define var v_part like pt_part .
    /* ss - 090909.1 -e */
    DEF TEMP-TABLE tte 
        FIELD tte_type1 AS CHAR
        FIELD tte_type AS CHAR
        FIELD tte_cust LIKE xxsod_cust
        FIELD tte_part LIKE xxsod_part
        FIELD tte_desc AS CHAR FORMAT "x(120)"
        .
    DEFINE VAR k AS INT .
      k = 101. /* ��ʼ���ļ�ֵ */

DEFINE VAR v_last_end AS DATE .

/* ss - 110412.1 -b */
DEFINE VAR v_start1 AS DATE .
/* ss - 110412.1 -e */

/* ss - 111027.1 -b */
DEFINE VAR v_qty1 LIKE tr_qty_loc .
/* ss - 111027.1 -e */




form 
   skip(1)
   vchr_file-name colon 20 label "�����ļ�"
   fn_me   COLON 20    LABEL "����������Ϣ�ļ�"
   fn_ok   COLON 20    LABEL "����ɹ�����Ϣ�ļ�"
   skip(1)
with frame a side-label width 80 .
setFrameLabels(frame a:handle).
     
mainloop:
repeat :

    FOR EACH t1:
        DELETE t1 .
    END.

     FOR EACH ttem:
      DELETE ttem.
    END.

    FOR EACH tt:
        DELETE tt .
    END.

    FOR EACH ts :
        DELETE ts .
    END.

    FOR EACH tte:
        DELETE tte .
    END.

    FOR EACH tto :
        DELETE tto .
    END.

    /* ss - 110412.1 -b */
    FOR EACH t2:
        DELETE t2 .
    END.
    /* ss - 110412.1 -e */

    /* ss - 110626.1 -b */
    FOR EACH t3 :
        DELETE t3 .
    END.
    /* ss - 110626.1 -e */
   
  update vchr_file-name fn_me  fn_ok with frame a.
  
  if search(vchr_file-name) = ? then 
  do:
     message "�ļ�������" .
     next.
  end.   
  
  /* {mfselprt.i "printer" 120}   */
  
     input from value(vchr_file-name).

     REPEAT:
         /* ss - 110626.1 -b 
          CREATE t1 .
          IMPORT DELIMITER "~011" t1 .

          /* ss - 110409.1 -b
          IF t1_ptype = "" THEN
              ASSIGN t1_ptype = "m" .
          ELSE IF t1_ptype = "1" THEN
              ASSIGN t1_ptype = "s" .
        ss - 110409.1 -e */
          /* ss - 110409.1 -b */
         
           IF t1_ptype1 = "1" THEN
            ASSIGN t1_ptype = "s" .
           ELSE
               t1_ptype = "m" .

          /* ss - 110409.1 -e */

              /* ss - 110412.1 -b */
               IF t1_type = "w" AND t1_add = "1" THEN DO:
                    FIND FIRST t2 WHERE t2_type = t1_type AND t2_ptype = t1_ptype AND t2_cust = t1_cust 
                        AND t2_ver = t1_ver AND t2_cust_part = t1_cust_part AND t2_add = t1_add NO-LOCK NO-ERROR .
                    IF NOT AVAILABLE t2 THEN DO:
                        CREATE t2 .
                        ASSIGN

                                t2_type = t1_type
                                t2_ptype  = t1_ptype
                                t2_cust = t1_cust
                                t2_ver = t1_ver 
                                t2_cust_part = t1_cust_part
                                t2_add = t1_add
                                t2_start = t1_start
                                t2_end = t1_end
                                .

                    END.
               END.
              

              
               /* ss - 110412.1 -e */
        ss - 110626.1 -e */
         /* ss - 110626.1 -b */
         CREATE t3 .
        IMPORT DELIMITER "~011" t3 .


        /* ss - 110704.1 -b */
        IF t3_start <> "" THEN DO:
       
        /* ss - 110704.1 -e */

        CREATE t1 .

        ASSIGN
                    
            t1_start =   DATE( int(entry(2,t3_start,"-" )),  int(entry(3,t3_start,"-")) , int(entry(1,t3_start,"-")))
            t1_end =  DATE( int(entry(2,t3_end,"-" )),  int(entry(3,t3_end,"-")) , int(entry(1,t3_end,"-"))) 
            t1_type =  t3_type 
            t1_add =  t3_add 
            t1_cust =  t3_cust 
            t1_seq = t3_seq 
            t1_vend = t3_vend 
            t1_site = t3_site 
            t1_cust_part = t3_cust_part 
            t1_desc1 = t3_desc1 
            t1_desc2 = t3_desc2 
            t1_plancode = t3_plancode 
            t1_date =  DATE( int(entry(2,t3_date,"-" )),  int(entry(3,t3_date,"-")) , int(entry(1,t3_date,"-")))
            t1_time = t3_time 
            t1_qty = t3_qty 
            t1_check  = t3_check 
            t1_ver = t3_ver 
            t1_month = t3_month 
            t1_ptype1 =  t3_ptype1 
            t1_rmks = t3_rmks 
            t1_rmks1 = t3_rmks1 
            t1_del = t3_del 
            t1_part = t3_part 
            t1_ptype = t3_ptype 
           .


        

         IF t1_ptype1 = "1" THEN
          ASSIGN t1_ptype = "s" .
         ELSE
             t1_ptype = "m" .

        /* ss - 110409.1 -e */

            /* ss - 110412.1 -b */
             IF t1_type = "w" AND t1_add = "1" THEN DO:
                  FIND FIRST t2 WHERE t2_type = t1_type AND t2_ptype = t1_ptype AND t2_cust = t1_cust 
                      AND t2_ver = t1_ver AND t2_cust_part = t1_cust_part AND t2_add = t1_add NO-LOCK NO-ERROR .
                  IF NOT AVAILABLE t2 THEN DO:
                      CREATE t2 .
                      ASSIGN

                              t2_type = t1_type
                              t2_ptype  = t1_ptype
                              t2_cust = t1_cust
                              t2_ver = t1_ver 
                              t2_cust_part = t1_cust_part
                              t2_add = t1_add
                              t2_start = t1_start
                              t2_end = t1_end
                              .

                  END.
             END.

          /* ss - 110704.1 -b */

               

          END . /* t3_start <> "" */
       
        /* ss - 110704.1 -e */

             /* ss - 110412.1 -e */


         /* ss - 110626.1 -e */

        
          
     end.

     input close.
     
     FOR EACH t1 WHERE t1_cust = "" :
         DELETE t1 .
     END.

     

     FOR EACH t1  :

         /* ss - 110422.1 -b */
         IF  MONTH(t1_start) <> MONTH(t1_end)  THEN DO:
                CREATE ttem.
         ASSIGN
             ttem_type1 = "���"
             ttem_type = "����" 
             ttem_cust = t1_cust
             ttem_part = t1_cust_part
             ttem_desc = "���ܿ���"
             .

            t1_del = "1" .
             NEXT .
         END.
         /* ��������ֻ���꣬�£����������� */

        

         /* ss - 110422.1 -e */

         /* ��������ֻ���꣬�£����������� */
          IF  NOT (t1_type = "w" OR t1_type = "m" )  THEN DO:
                 CREATE ttem.
          ASSIGN
              ttem_type1 = "���"
              ttem_type = "����" 
              ttem_cust = t1_cust
              ttem_part = t1_cust_part
              ttem_desc = "ֻ�ܵ�����������͡�"
              .
     
             t1_del = "1" .
              NEXT .
          END.
          /* ��������ֻ���꣬�£����������� */

          IF t1_ptype = ""  THEN DO:

               CREATE ttem.
          ASSIGN
              ttem_type1 = "���"
              ttem_type = "����" 
              ttem_cust = t1_cust
              ttem_part = t1_cust_part
              ttem_desc = "δָ���������͡�"
              .
     
             t1_del = "1" .
              NEXT .

          END.

          IF t1_cust = "" THEN DO:
         
           CREATE ttem.
          ASSIGN
              ttem_type1 = "���"
              ttem_type = "����" 
              ttem_cust = t1_cust
              ttem_part = t1_cust_part
              ttem_desc = "�ͻ�Ϊ�ա�"
              .
     
             t1_del = "1" .
              NEXT .
          END.

           IF t1_cust_part = "" THEN DO:
         
           CREATE ttem.
          ASSIGN
              ttem_type1 = "���"
              ttem_type = "����" 
              ttem_cust = t1_cust
              ttem_part = t1_cust_part
              ttem_desc = "�ͻ����Ϊ�ա�"
              .
     

             t1_del = "1" .
             NEXT .
          END.


         FIND FIRST cp_mstr WHERE cp_cust = t1_cust AND cp_cust_part = t1_cust_part NO-LOCK NO-ERROR .
         IF NOT AVAILABLE cp_mstr THEN DO:

              CREATE ttem.
          ASSIGN
              ttem_type1 = "���"
              ttem_type = "����" 
              ttem_cust = t1_cust
              ttem_part = t1_cust_part
              ttem_desc = "�ͻ������Ӧδά�����뵽(1.16)�˵�����ά����"
              .
     
             t1_del = "1" .
              NEXT .
         END.
         ELSE 
             t1_part = cp_part
                 .


          FIND FIRST cm_mstr WHERE cm_addr = t1_cust NO-LOCK NO-ERROR.
          IF NOT AVAIL cm_mstr THEN DO:
              CREATE ttem.
              ASSIGN
                  ttem_type1 = "�ͻ�"
                  ttem_type = "����" 
                  ttem_cust = t1_cust
                  ttem_part = t1_cust_part
                  ttem_desc = "�˿ͻ�������ϵͳ�в����ڣ����ȵ�(2.1.1)ά����Ŀ���롣"
                  .
             t1_del = "1" .
              NEXT .

              


          END.
          

         /* ss - 110704.2 - b */
          IF t1_type = "m" THEN DO:
          
          /* ss - 110704.2 -e */
             FIND FIRST xxdp_mstr WHERE xxdp_type = t1_type AND xxdp_year = YEAR(t1_date) AND xxdp_month = t1_month
                 AND xxdp_ptype = t1_ptype AND xxdp_vend = t1_cust AND xxdp_ver = t1_ver NO-LOCK NO-ERROR .
             IF AVAILABLE xxdp_mstr THEN DO:
    
                  CREATE ttem.
                  ASSIGN
                      ttem_type1 = "�ͻ�"
                      ttem_type = "����" 
                      ttem_cust = t1_cust
                      ttem_part = t1_cust_part
                      ttem_desc = "�˿ͻ��汾�Ѿ�����ϵͳ:" + STRING(YEAR(t1_date)) + "-" + STRING(t1_month) + "-"  + xxdp_ver + "-" + t1_ptype
                      .
    
            
                 t1_del = "1" .
                  NEXT .
              END.
          /* ss - 110704.2 -b */
          END.
          ELSE DO:
             
               FIND FIRST xxdp_mstr WHERE xxdp_type = t1_type AND xxdp_date = t1_date 
                 AND xxdp_ptype = t1_ptype AND xxdp_vend = t1_cust AND xxdp_ver = t1_ver NO-LOCK NO-ERROR .
             IF AVAILABLE xxdp_mstr THEN DO:
    
                  CREATE ttem.
                  ASSIGN
                      ttem_type1 = "�ͻ�"
                      ttem_type = "����" 
                      ttem_cust = t1_cust
                      ttem_part = t1_cust_part
                      ttem_desc = "�˿ͻ��汾�Ѿ�����ϵͳ:" + STRING(YEAR(t1_date)) + "-" + STRING(t1_month) + "-"  + xxdp_ver + "-" + t1_ptype
                      .
    
            
                 t1_del = "1" .
                  NEXT .
              END.

          END.
          /* ss - 110704.2 -e */
         
          
          FIND FIRST pj_mstr WHERE pj_project = t1_ptype + "p" NO-LOCK NO-ERROR.
          IF NOT AVAIL pj_mstr THEN DO:
              CREATE ttem.
              ASSIGN
                  ttem_type1 = "��Ŀ"
                  ttem_type = "����" 
                  ttem_cust = t1_cust
                  ttem_part = t1_ptype + "p"
                  ttem_desc = "����Ŀ��ϵͳ�в����ڣ����ȵ�(25.3.11)ά����Ŀ���롣"
                  .
             t1_del = "1" .
              NEXT .
          END.

     END.

        /* ��������ϸͬʱд�뵽 xxsod_det ��*/
    
     /* ss - 110409.1 -b */
      FOR EACH t1 USE-INDEX t1_date WHERE t1_type = "w" AND t1_del = ""  BREAK BY t1_type BY t1_ptype BY t1_cust 
              BY t1_ver BY t1_part BY t1_date  :
         
          FIND FIRST xxsod_det WHERE xxsod_cust = t1_cust AND xxsod_invnbr = t1_check  NO-ERROR .
          IF AVAILABLE xxsod_det THEN DO:
              CREATE ttem.
              ASSIGN
                  ttem_type1 = "��Ʊ"
                  ttem_type = "����" 
                  ttem_cust = t1_cust
                  ttem_part = t1_check
                  ttem_desc = "�˴�Ʊ�Ѿ����ڷ�������ϸ��"
                  .

               ASSIGN
                          xxsod_type = t1_type
                          xxsod_project = t1_ptype + "p"
                          xxsod_item = int(t1_seq)
                          xxsod_vend = t1_vend
                          xxsod_addr = t1_site
                          xxsod_part = t1_cust_part
                          xxsod_color = t1_desc1
                          xxsod_desc = t1_desc2
                          xxsod_plan = t1_plancode
                          xxsod_due_date = STRING(YEAR(t1_date)) + "-" + STRING(MONTH(t1_date),"99") + "-" + STRING(DAY(t1_date),"99")   
                          xxsod_due_time = t1_time
                          xxsod_qty_ord = t1_qty
                          xxsod_rev = int(t1_ver)
                          xxsod_week = t1_month
                          xxsod_category = t1_ptype1
                          xxsod_ship = t1_rmks
                          xxsod_rmks = t1_rmks1
                          xxsod_due_date1 = xxsod_due_date
                          xxsod_due_time1 = xxsod_due_time
                          xxsod__chr02 = string(xxsod_qty_ord)
                          xxsod_desc = TRIM(xxsod_desc)
                          xxsod__chr01 = "NO"
                      .
             

          END.
          ELSE DO:
              CREATE xxsod_det .
              ASSIGN
                  xxsod_type = t1_type
                  xxsod_cust = t1_cust
                  xxsod_project = t1_ptype + "p"
                  xxsod_item = int(t1_seq)
                  xxsod_vend = t1_vend
                  xxsod_addr = t1_site
                  xxsod_part = t1_cust_part
                  xxsod_color = t1_desc1
                  xxsod_desc = t1_desc2
                  xxsod_plan = t1_plancode
                  xxsod_due_date = STRING(YEAR(t1_date)) + "-" + STRING(MONTH(t1_date),"99") + "-" + STRING(DAY(t1_date),"99")   
                  xxsod_due_time = t1_time
                  xxsod_qty_ord = t1_qty
                  xxsod_invnbr = t1_check
                  xxsod_rev = int(t1_ver)
                  xxsod_week = t1_month
                  xxsod_category = t1_ptype1
                  xxsod_ship = t1_rmks
                  xxsod_rmks = t1_rmks1
                  .
               ASSIGN
                      xxsod_due_date1 = xxsod_due_date
                      xxsod_due_time1 = xxsod_due_time
                      xxsod__chr02 = string(xxsod_qty_ord)
                      xxsod_desc = TRIM(xxsod_desc)
                      xxsod__chr01 = "NO"
                      .
          END.

      END.
     /* ss - 110409.1 -e */

   
          /* ��ȡ�ܼƻ��еĿ�ʼ�������� �еĶ�������*/
         FOR EACH t1 USE-INDEX t1_date  WHERE t1_type = "w"  /* ss - 110412.1 ����ʱ����Ҫͳ�Ʒָ� -b */ AND t1_add = "1"  /* ss - 110412.1 -e */ AND t1_del = ""    BREAK BY t1_type BY t1_ptype BY t1_cust 
              BY t1_ver BY t1_part BY t1_date  :

                 /* �ܼ�¼��ʼ����*/
                  IF FIRST-OF(t1_part) THEN DO: 
    
                   
                    
                     
                          FIND FIRST tt WHERE tt_type = t1_type AND tt_cust = t1_cust AND tt_ver = t1_ver AND tt_ptype = t1_ptype 
                              AND tt_part = t1_part NO-LOCK NO-ERROR .
                          IF NOT AVAILABLE tt THEN DO:
                              CREATE tt.
                              ASSIGN
                                  tt_type = t1_type 
                                  tt_cust = t1_cust 
                                  tt_ver = t1_ver 
                                  tt_ptype = t1_ptype 
                                  tt_part = t1_part
                                  /* ss - 110412.1 -b
                                  tt_start = t1_date
                                  ss - 110412.1 -e */
                                  /* ss - 110412.1 -b */
                                  tt_start = t1_start
                                  /* ss - 110412.1 -e */
                                  .
    
                          END.

                          /* ss - 110412.1 -b */  /* �ܼƻ���ʼ�ͽ�������ֻ���뱾�� ��������뱾����ô���� ?*/
                           FIND FIRST tt WHERE tt_type = t1_type AND tt_cust = t1_cust AND tt_ver = t1_ver AND tt_ptype = t1_ptype 
                              AND tt_part = t1_part  NO-ERROR .
                          IF  AVAILABLE tt THEN DO:
                              
                              ASSIGN
                                
                                  tt_end = t1_end
                                  .
    
                                  v_date = tt_start .
                                 
                                  v_end =   DATE ( MONTH ( DATE( MONTH (tt_start) , 1 , YEAR(tt_start) )  + 31 )  , 
                                                   1 ,
                                                 YEAR( DATE( MONTH (tt_start) , 1 , YEAR(tt_start) )  + 31 )   
                                                 ) - 1 . 
 
    
                              
                                          /* ��¼ԭʼ����*/
                                          v_qty = 0 .
                                          /* ss - 111027.1 -b */
                                          v_qty1 = 0 .
                                          /* ss - 111027.1 -e */
                                          n = 0 . /* ͳ�������������� */
                                              REPEAT WHILE v_date <= v_end :
                    
                                               
                                                         
                                                         FIND FIRST cm_mstr WHERE cm_addr = t1_cust NO-LOCK NO-ERROR .
                                                         IF AVAIL cm_mstr THEN v_sort = SUBSTRING(cm_sort ,1 , 2 ) . ELSE v_sort = "" .
                    
                                                          v_year = SUBSTRING(STRING(YEAR(v_date),"9999") , 3 ).
                                                          IF MONTH(v_date) < 10 THEN v_month = STRING(MONTH(v_date) ,"9") .
                                                          ELSE IF MONTH(v_date) = 10 THEN v_month = "A".
                                                          ELSE IF MONTH(v_date) = 11 THEN v_month = "B".
                                                          ELSE v_month = "C" .
                    
                                                          v_sonbr = v_sort + v_year + v_month + STRING(DAY(v_date),"99") + SUBSTRING(t1_ptype,1,1) .
                                                         
                                                         
                                                         FIND FIRST sod_det WHERE sod_nbr = v_sonbr AND sod_part = t1_part NO-LOCK NO-ERROR .
                                                         IF  AVAILABLE sod_Det THEN  DO:
        /*                                                                                                                                      */
        /*                                                      FIND FIRST ts WHERE ts_nbr = sod_nbr AND  ts_part = sod_part NO-LOCK NO-ERROR . */
        /*                                                      IF NOT AVAILABLE ts THEN DO:                                                    */
        /*                                                          CREATE ts .                                                                 */
        /*                                                          ASSIGN                                                                      */
        /*                                                              ts_nbr = sod_nbr                                                        */
        /*                                                              ts_line = sod_line                                                      */
        /*                                                              ts_part = sod_part                                                      */
        /*                                                              ts_qty_ord = sod_qty_ord                                                */
        /*                                                              .                                                                       */
        /*                                                                                                                                      */
        /*                                                      END.                                                                            */
        
                                                              v_qty = v_qty + sod_qty_ord .
                                                         
                                                              /* ss - 111027.1 -b 
                                                           IF v_date > tt_end THEN
                                                               n = n + 1 .
                                                               ss - 111027.1 -e */
                                                              /* ss - 111027.1 -b */
                                                               IF v_date > tt_end THEN DO:
                                                              
                                                                 n = n + 1 .
                                                                 
                                                                 /* ss - 111129.1 -b
                                                                 IF sod__dec01 <> 0 AND v_qty1 = 0 THEN 

                                                                     v_qty1 = sod_qty_ord - sod__dec01 .
                                                                  ss - 111129.1 -e */
                                                                 /* ss - 111129.1 -b */
                                                                 IF sod__dec01 <> 0 AND v_qty1 = 0 THEN DO:
                                                                     v_qty1 = sod_qty_ord - sod__dec01 .
                                                                    
                                                                         ASSIGN
                                                                             tt_sodnbr = sod_nbr
                                                                             tt_sodline = sod_line
                                                                             tt_qty_ord = sod__dec01
                                                                             
                                                                             .
                                                                   
                                                                 END.

                                                                   

                                                                 /* ss - 111129.1 -e */
                                                               END.
                                                              /* ss - 111027.1 -e */
                                                         
                                                        END.
                                                        
                             
                    
                                               v_date = v_date + 1 .
                                            END.
    
                                      ASSIGN
                                        tt_total = v_qty 
                                        tt_day = n .
                                      /* ss - 111027.1 -b */
                                      tt_total1 = v_qty1 .
                                      /* ss - 111027.1 -e */
                                   
                                    /* �ӿ�ʼ���ڵ��������ڼ��㶩�� */
                                    /* ��¼ԭʼ����*/
                              
                              END.
                          /* ss - 110412.1 -e */

                     
                  END.


                  /* ss - 110412.1 -b

              IF LAST-OF(t1_part) THEN DO:



                       FIND FIRST tt WHERE tt_type = t1_type AND tt_cust = t1_cust AND tt_ver = t1_ver AND tt_ptype = t1_ptype 
                              AND tt_part = t1_part  NO-ERROR .
                          IF  AVAILABLE tt THEN DO:
                              
                              ASSIGN
                                
                                  tt_end = t1_date
                                  .
    
                                  v_date = tt_start .
                                 
                                  v_end =   DATE ( MONTH ( DATE( MONTH (tt_start) , 1 , YEAR(tt_start) )  + 31 )  , 
                                                   1 ,
                                                 YEAR( DATE( MONTH (tt_start) , 1 , YEAR(tt_start) )  + 31 )   
                                                 ) - 1 . 
 
    
                              
                                          /* ��¼ԭʼ����*/
                                          v_qty = 0 .
                                          n = 0 . /* ͳ�������������� */
                                              REPEAT WHILE v_date <= v_end :
                    
                                               
                                                         
                                                         FIND FIRST cm_mstr WHERE cm_addr = t1_cust NO-LOCK NO-ERROR .
                                                         IF AVAIL cm_mstr THEN v_sort = SUBSTRING(cm_sort ,1 , 2 ) . ELSE v_sort = "" .
                    
                                                          v_year = SUBSTRING(STRING(YEAR(v_date),"9999") , 3 ).
                                                          IF MONTH(v_date) < 10 THEN v_month = STRING(MONTH(v_date) ,"9") .
                                                          ELSE IF MONTH(v_date) = 10 THEN v_month = "A".
                                                          ELSE IF MONTH(v_date) = 11 THEN v_month = "B".
                                                          ELSE v_month = "C" .
                    
                                                          v_sonbr = v_sort + v_year + v_month + STRING(DAY(v_date),"99") + SUBSTRING(t1_ptype,1,1) .
                                                         
                                                         
                                                         FIND FIRST sod_det WHERE sod_nbr = v_sonbr AND sod_part = t1_part NO-LOCK NO-ERROR .
                                                         IF  AVAILABLE sod_Det THEN  DO:
        /*                                                                                                                                      */
        /*                                                      FIND FIRST ts WHERE ts_nbr = sod_nbr AND  ts_part = sod_part NO-LOCK NO-ERROR . */
        /*                                                      IF NOT AVAILABLE ts THEN DO:                                                    */
        /*                                                          CREATE ts .                                                                 */
        /*                                                          ASSIGN                                                                      */
        /*                                                              ts_nbr = sod_nbr                                                        */
        /*                                                              ts_line = sod_line                                                      */
        /*                                                              ts_part = sod_part                                                      */
        /*                                                              ts_qty_ord = sod_qty_ord                                                */
        /*                                                              .                                                                       */
        /*                                                                                                                                      */
        /*                                                      END.                                                                            */
        
                                                              v_qty = v_qty + sod_qty_ord .
                                                         
                                                           IF v_date > tt_end THEN
                                                               n = n + 1 .
                                                         
                                                        END.
                                                        
                             
                    
                                               v_date = v_date + 1 .
                                            END.
    
                                      ASSIGN
                                        tt_total = v_qty 
                                        tt_day = n .
                                   
                                    /* �ӿ�ʼ���ڵ��������ڼ��㶩�� */
                                    /* ��¼ԭʼ����*/
                              
                              END.

              END.
              ss - 110412.1 -e */

         END.
         /* ��ȡ�ܼƻ��еĿ�ʼ�������� �еĶ�������*/

          /* ��������ϸ���Ǳ������ݣ��Զ��ۼƵ��������һ�������ն�����,g�����꽫 t1_del = "1" �����¼ƻ��ظ�����*/
         FOR EACH t1 USE-INDEX t1_date  WHERE t1_type = "m" AND t1_del = "" AND t1_month <> MONTH(t1_date) BREAK BY t1_type BY t1_ptype BY t1_cust
         BY t1_ver BY t1_part  BY t1_date  :

                 IF FIRST-OF(t1_type) THEN DO:

                       m = 0 .

                     IF t1_type = "m" THEN DO:   /* �� */


                          FIND LAST xxdp_mstr USE-INDEX xxdp_nbr WHERE xxdp_type = "m" AND
                              xxdp_nbr BEGINS "m" + STRING(substring(string(YEAR(TODAY)),3),"99") + STRING(MONTH(TODAY),"99") + STRING(DAY(TODAY),"99") EXCLUSIVE-LOCK NO-ERROR .
                          IF AVAILABLE xxdp_mstr  THEN DO:
                              v_line = STRING( INT( SUBSTRING(xxdp_nbr,LENGTH(xxdp_nbr) - 3 ) ) + 1 ,"9999") .
                              v_nbr = "m" + STRING(substring(string(YEAR(TODAY)),3),"99") + STRING(MONTH(TODAY),"99") + STRING(DAY(TODAY),"99") + v_line .
                          END.
                          ELSE DO:
                          v_line = STRING(  1 ,"9999") .
                          v_nbr = "m" + STRING(substring(string(YEAR(TODAY)),3),"99") + STRING(MONTH(TODAY),"99") + STRING(DAY(TODAY),"99") + v_line .

                          END.






                      END .
                      


                 END.  /* first-of(t1_type) */


                 IF FIRST-OF(t1_part) THEN DO:



                          v_qty = 0 .
                 END.

                 v_qty = t1_qty + v_qty .

                        m = m + 1 .

                          CREATE xxdp_mstr .

                    ASSIGN
                            xxdp_type = t1_type
                            xxdp_nbr = v_nbr
                            xxdp_line = m
                            xxdp_add =  t1_add     /* ����1 or���� �� */
                            xxdp_vend =  t1_cust
                            xxdp_seq = t1_seq
                            xxdp_supply = t1_vend
                            xxdp_receive_site = t1_site
                            xxdp_cust_part = t1_cust_part
                            xxdp_desc1 = t1_desc1
                            xxdp_desc2 = t1_desc2
                            xxdp_plancode = t1_plancode
                            xxdp_date = t1_date
                            xxdp_time = t1_time
                            xxdp_qty = t1_qty
                            xxdp_check = t1_check
                            xxdp_ver =  t1_ver
                            xxdp_month = t1_month
                            xxdp_ptype = t1_ptype    /* sp mp */
                            xxdp_rmks = t1_rmks
                            xxdp_rmk1 = t1_rmks1
                            xxdp_part = t1_part
                            xxdp_year = YEAR(t1_date)
                            xxdp_pdate = 1
                            xxdp_process = YES
                            xxdp_crt_date = TODAY
                        .

                      IF LAST-OF(t1_part) THEN DO:
  
                          v_qty_ord = v_qty .
                          v_qty_ord1 = v_qty .
                          
                          {xxmdpupd3.i}  /* �¶ȼƻ����һ�������ո��� */
                      END.


                     t1_del = "1" .



    END.

          /* ��������ϸ���Ǳ������ݣ��Զ��ۼƵ��������һ�������ն�����*/

    /* ɾ�������Ͳ��ڱ��ε���ʱ�䷶Χ�Ķ���*/
    /* ss - 110412.1 -b */

    FOR EACH t2 WHERE  :

            v_start1 = t2_start .
    
            

             FIND FIRST cp_mstr WHERE cp_cust = t2_cust AND cp_cust_part = t2_cust_part NO-LOCK NO-ERROR .
               IF AVAILABLE cp_mstr THEN DO:
                    
                   t2_part = cp_part .
    
                    REPEAT WHILE v_start1 <= t2_end :
            
                        FIND FIRST t1 WHERE t1_add = "1" AND t1_del = "" AND t1_type = t2_type AND  t1_cust = t2_cust AND t1_ver = t2_ver
                             AND t1_cust_part = t2_cust_part AND t1_ptype = t2_ptype AND t1_date = v_start1 NO-LOCK NO-ERROR .
                        IF NOT AVAILABLE t1 THEN DO:
            
                           
                                 {xxmdpdel2.i}
                           
            
                          
            
                        END.
                       v_start1 = v_start1 + 1 .
    
                    END.
            END.


    END.
     

    /* ss - 110412.1 -e */
    /* ɾ�������Ͳ��ڱ��ε���ʱ�䷶Χ�Ķ���*/

        
             j = 0 .
          /* ���� */

          FOR EACH t1 USE-INDEX t1_date  WHERE t1_add = "1" AND t1_del = "" BREAK BY t1_type BY t1_ptype BY t1_cust
              BY t1_ver BY t1_part  BY t1_date  :

                      IF FIRST-OF(t1_type) THEN DO:

                        

                            m = 0 .

                          IF t1_type = "m" THEN DO:   /* �� */

                                 
                               FIND LAST xxdp_mstr USE-INDEX xxdp_nbr WHERE xxdp_type = "m" AND
                                   xxdp_nbr BEGINS "m" + STRING(substring(string(YEAR(TODAY)),3),"99") + STRING(MONTH(TODAY),"99") + STRING(DAY(TODAY),"99") EXCLUSIVE-LOCK NO-ERROR .
                               IF AVAILABLE xxdp_mstr  THEN DO:
                                   v_line = STRING( INT( SUBSTRING(xxdp_nbr,LENGTH(xxdp_nbr) - 3 ) ) + 1 ,"9999") .
                                   v_nbr = "m" + STRING(substring(string(YEAR(TODAY)),3),"99") + STRING(MONTH(TODAY),"99") + STRING(DAY(TODAY),"99") + v_line .
                               END.
                               ELSE DO:
                               v_line = STRING(  1 ,"9999") .
                               v_nbr = "m" + STRING(substring(string(YEAR(TODAY)),3),"99") + STRING(MONTH(TODAY),"99") + STRING(DAY(TODAY),"99") + v_line .

                               END.






                           END .
                           ELSE DO:  /*  �� */

                               
                               FIND LAST xxdp_mstr  USE-INDEX xxdp_nbr  WHERE xxdp_type = "w" AND
                                   xxdp_nbr BEGINS "w" + STRING(substring(string(YEAR(TODAY)),3),"99") + STRING(MONTH(TODAY),"99") + STRING(DAY(TODAY),"99") EXCLUSIVE-LOCK NO-ERROR .
                               IF AVAILABLE xxdp_mstr  THEN DO:

                                   

                                   v_line = STRING( INT( SUBSTRING(xxdp_nbr,LENGTH(xxdp_nbr) - 3 ) ) + 1 ,"9999") .
                                  
                                   v_nbr = "w" + STRING(substring(string(YEAR(TODAY)),3),"99") + STRING(MONTH(TODAY),"99") + STRING(DAY(TODAY),"99") + v_line .
                                   
                               END.
                               ELSE DO:
                                 v_line = STRING(  1 ,"9999") .
                                 v_nbr = "w" + STRING(substring(string(YEAR(TODAY)),3),"99") + STRING(MONTH(TODAY),"99") + STRING(DAY(TODAY),"99") + v_line .

                               END.

                           END.
                               
                           

                      END.  /* first-of(t1_type) */


                      IF FIRST-OF(t1_date) THEN DO:


/*                               v_day = 0 .                                                               */
/*                               v_holiday = 0 .                                                           */
/*                                                                                                         */
/*                                /* �����깤��ʱ�� */                                                     */
/*                                v_start =  DATE(t1_month , 1 , t1_year ).                                */
/*                                v_end =  DATE(MONTH(v_start + 31)  , 1 , YEAR(v_start + 31 )) - 1 .      */
/*                                v_date = v_start .                                                       */
/*                                REPEAT WHILE v_date <= v_end :                                           */
/*                                    v_day = v_day + 1 .                                                  */
/*                                    v_date = v_date + 1 .                                                */
/*                                END.                                                                     */
/*                                                                                                         */
/*                                                                                                         */
/*                                FOR EACH hd_mstr WHERE hd_date >= v_start AND hd_date <= v_end NO-LOCK : */
/*                                  v_holiday = v_holiday + 1 .                                            */
/*                                END.                                                                     */
/*                                                                                                         */
/*                                v_day = v_day - v_holiday .                                              */
                               v_qty = 0 .
                      END.

                      v_qty = t1_qty + v_qty .

                             m = m + 1 .

                            

                               CREATE xxdp_mstr .

                         ASSIGN
                                 xxdp_type = t1_type
                                 xxdp_nbr = v_nbr
                                 xxdp_line = m
                                 xxdp_add =  t1_add     /* ����1 or���� �� */
                                 xxdp_vend =  t1_cust
                                 xxdp_seq = t1_seq
                                 xxdp_supply = t1_vend
                                 xxdp_receive_site = t1_site
                                 xxdp_cust_part = t1_cust_part
                                 xxdp_desc1 = t1_desc1
                                 xxdp_desc2 = t1_desc2
                                 xxdp_plancode = t1_plancode
                                 xxdp_date = t1_date
                                 xxdp_time = t1_time
                                 xxdp_qty = t1_qty
                                 xxdp_check = t1_check
                                 xxdp_ver =  t1_ver
                                 xxdp_month = t1_month
                                 xxdp_ptype = t1_ptype    /* sp mp */
                                 xxdp_rmks = t1_rmks
                                 xxdp_rmk1 = t1_rmks1
                                 xxdp_part = t1_part
                                 xxdp_year = YEAR(t1_date)
                                 xxdp_pdate = 1
                                 xxdp_process = YES
                                 xxdp_crt_date = TODAY
                             .

                         
                           IF LAST-OF(t1_date) THEN DO:
        /*                         IF ( v_qty MOD v_day ) = 0 THEN DO:                         */
        /*                          v_qty_ord = v_qty / v_day .                                */
        /*                          v_qty_ord1 = v_qty_ord .                                   */
        /*                        END.                                                         */
        /*                        ELSE DO:                                                     */
        /*                            v_qty_ord = TRUNCATE( v_qty / v_day , 0 ) .              */
        /*                            v_qty_ord1 = ( v_qty - v_qty_ord * v_day ) + v_qty_ord . */
        /*                        END.                                                         */
                               v_qty_ord = v_qty .
                               v_qty_ord1 = v_qty .
                             
                               {xxmdpupd1.i}  /* ���� */
                           END.


                       /* ������ָ���� */
                 IF LAST-OF(t1_part) AND t1_type = "w" THEN DO:


                              /* �ָ����*/
                             FIND FIRST tt WHERE tt_type = t1_type AND tt_cust = t1_cust AND tt_ver = t1_ver AND tt_ptype = t1_ptype
                                     AND tt_part = t1_part  NO-ERROR .
                                 IF  AVAILABLE tt THEN DO:

                                     ASSIGN
                                         v_date = tt_start
                                         v_end = tt_end
                                         .



                                             /* ͳ�Ƹ��º󶩵�����*/
                                             v_qty = 0 .

                                             REPEAT WHILE v_date <= v_end :



                                                        FIND FIRST cm_mstr WHERE cm_addr = t1_cust NO-LOCK NO-ERROR .
                                                        IF AVAIL cm_mstr THEN v_sort = SUBSTRING(cm_sort ,1 , 2 ) . ELSE v_sort = "" .

                                                         v_year = SUBSTRING(STRING(YEAR(v_date),"9999") , 3 ).
                                                         IF MONTH(v_date) < 10 THEN v_month = STRING(MONTH(v_date) ,"9") .
                                                         ELSE IF MONTH(v_date) = 10 THEN v_month = "A".
                                                         ELSE IF MONTH(v_date) = 11 THEN v_month = "B".
                                                         ELSE v_month = "C" .

                                                         v_sonbr = v_sort + v_year + v_month + STRING(DAY(v_date),"99") + SUBSTRING(t1_ptype,1,1) .

                                                        FIND FIRST sod_det WHERE sod_nbr = v_sonbr AND sod_part = t1_part NO-LOCK NO-ERROR .
                                                        IF  AVAILABLE sod_Det THEN  DO:
                                                           v_qty = v_qty + sod_qty_ord .
                                                        END.



                                                    v_date = v_date + 1 .
                                              END.
                                            
                                         
                                               /* �ӿ�ʼ���ڵ��������ڼ��㶩�� */
                                                /* ͳ�Ƹ��º󶩵�����*/
                                                /* ƽ������ʣ�ඩ��*/
                                               IF tt_total - v_qty > 0   THEN DO:
                                                
                                                   /* ss - 110422.1 -b */
                                                   IF t1_ptype <> "s" THEN DO:  /* �ܼƻ�mp������ʽ*/

                                                     /* ss - 111027.1 -b */
                                                      IF tt_total1 - v_qty  <> 0  THEN  DO:  /* û�в���ʱ��ƽ���ָ� */
                                                     
                                                      /* ss - 111027.1 -e */
                                                  
                                                   /* ss - 110422.1 -e */
                                                           /* ����*/
                                                          IF tt_day > 0 THEN DO:
                                                                
                                                             
                                                              
                                                                  v_day = tt_day .
                                                              IF v_day <> 0  THEN DO:
                                                                  /* ss - 111027.1 -b 
                                                                  v_qty = tt_total - v_qty .  /* ʣ������*/
                                                                  ss - 111027.1 -e */
                                                                  /* ss - 111027.1 -b */
                                                                   v_qty = tt_total1 - v_qty .  /* ��������*/

                                                                  /* ss - 111027.1 -e */
        
                                                                  IF ( v_qty MOD v_day ) = 0 THEN DO:
                                                                     v_qty_ord = v_qty / v_day .
                                                                     v_qty_ord1 = v_qty_ord .
                                                                   END.
                                                                   ELSE DO:
                                                                       v_qty_ord = TRUNCATE( v_qty / v_day , 0 ) .
                                                                       v_qty_ord1 = ( v_qty - v_qty_ord * v_day ) + v_qty_ord .
                                                                   END.

                                                                   /* ss - 111027.1 -b
                                                                   /* ss - 110425.1 -b */
                                                                   IF v_qty_ord = 0 THEN
                                                                       v_qty_ord = v_qty_ord1 .
                                                                   /* ss - 110425.1 -e */
                                                                   ss - 111027.1 -e */

                                                                   
                                                               {xxmdpupd2.i}
                                                              END.
                                                               ELSE DO:
                                                                    CREATE ttem.
                                                                      ASSIGN
                                                                          ttem_type1 = "��Ŀ"
                                                                          ttem_type = "����" 
                                                                          ttem_cust = t1_cust
                                                                          ttem_part = t1_ptype + "p"
                                                                          ttem_desc = "���ʱ��Ϊ�ż�ʱ�䡣"
                                                                          .
        
                                                               END.
                                                          END.  /* tt_day > 0 111129.1 */
                                                      /* ss - 111027.1 -b */
                                                         END. /* tt_total1 - v_qty  <> 0 111129.1 */
                                                         /* ss - 111027.1 -e */
                                                         /* ss - 111129.1 -b */
                                                         ELSE DO:  /*  tt_total1 - v_qty  = 0 */

                                                             {xxmdpupd5.i}

                                                         END.
                                                         /* ss - 111129.1 -e */
                                                    /* ss - 110422.1 -b */
                                                   END.
                                                   ELSE DO:  /* �ܼƻ� sp������ʽ,���ҵ������ں���sp�������ۼƣ����������½� */
                                                       /* ��ɾ�� �����ڵ���ĩ��sp���� �����»�ȡ�����¶���*/
                                                        {xxmdpdel1.i}
                                                       /* ��ɾ�� �����ڵ���ĩ��sp���� �����»�ȡ�����¶���*/
                                                        v_qty_ord = tt_total - v_qty .
                                                       {xxmdpupd4.i}

                                                   END.
                                                    /* ss - 110422.1 -e */


                                               END.
                                               ELSE DO: /* Ϊ0 ɾ��ʣ���¶���*/
                                                   IF tt_day > 0 THEN DO:
                                                       {xxmdpdel1.i}
                                                   END.

                                               END.
                                 END.
                             /*  �ָ���� */
                 END.
               /* ������ָ���� */




         END.

          /* ���� */


      /* ���� */
        

      FOR EACH t1 USE-INDEX t1_date  WHERE t1_add = "" AND t1_del = "" BREAK BY t1_type BY t1_ptype BY t1_cust
              BY t1_ver BY t1_part BY t1_date  :



              IF FIRST-OF(t1_type) THEN DO:

                    m = 0 .

                  IF t1_type = "m" THEN DO:   /* �� */


                       FIND LAST xxdp_mstr USE-INDEX xxdp_nbr  WHERE xxdp_type = "m" AND
                           xxdp_nbr BEGINS "m" + STRING(substring(string(YEAR(TODAY)),3),"99") + STRING(MONTH(TODAY),"99") + STRING(DAY(TODAY),"99") EXCLUSIVE-LOCK NO-ERROR .
                       IF AVAILABLE xxdp_mstr  THEN DO:
                           v_line = STRING( INT( SUBSTRING(xxdp_nbr,LENGTH(xxdp_nbr) - 3 ) ) + 1 ,"9999") .
                           v_nbr = "m" + STRING(substring(string(YEAR(TODAY)),3),"99") + STRING(MONTH(TODAY),"99") + STRING(DAY(TODAY),"99") + v_line .
                       END.
                       ELSE DO:
                           v_line = STRING(  1 ,"9999") .
                           v_nbr = "m" + STRING(substring(string(YEAR(TODAY)),3),"99") + STRING(MONTH(TODAY),"99") + STRING(DAY(TODAY),"99") + v_line .

                       END.




                   END .
                   ELSE DO:  /*  �� */

                       

                       FIND LAST xxdp_mstr USE-INDEX xxdp_nbr WHERE xxdp_type = "w" AND
                           xxdp_nbr BEGINS "w" + STRING(substring(string(YEAR(TODAY)),3),"99") + STRING(MONTH(TODAY),"99") + STRING(DAY(TODAY),"99") EXCLUSIVE-LOCK NO-ERROR .
                       IF AVAILABLE xxdp_mstr  THEN DO:
                           v_line = STRING( INT( SUBSTRING(xxdp_nbr,LENGTH(xxdp_nbr) - 3 ) ) + 1 ,"9999") .
                           v_nbr = "w" + STRING(substring(string(YEAR(TODAY)),3),"99") + STRING(MONTH(TODAY),"99") + STRING(DAY(TODAY),"99") + v_line .
                          
                       END.
                       ELSE DO:
                           v_line = STRING(  1 ,"9999") .
                           v_nbr = "w" + STRING(substring(string(YEAR(TODAY)),3),"99") + STRING(MONTH(TODAY),"99") + STRING(DAY(TODAY),"99") + v_line .

                       END.





                   END.


              END.  /* first-of(t1_type) */



              IF FIRST-OF(t1_date) THEN DO:

                     /* ss - 110329.1 -b
                      v_day = 0 .
                      v_holiday = 0 .

                       /* �����깤��ʱ�� */
                       v_start =  DATE(t1_month , 1 , t1_year ).
                       v_end =  DATE(MONTH(v_start + 31)  , 1 , YEAR(v_start + 31 )) - 1 .
                       v_date = v_start .
                       REPEAT WHILE v_date <= v_end :
                           v_day = v_day + 1 .
                           v_date = v_date + 1 .
                       END.


                       FOR EACH hd_mstr WHERE hd_date >= v_start AND hd_date <= v_end NO-LOCK :
                         v_holiday = v_holiday + 1 .
                       END.

                       v_day = v_day - v_holiday .
                       ss - 110329.1 -e */


                       v_qty = 0 .
              END.

              v_qty = t1_qty + v_qty .

              m = m + 1 .


                 CREATE xxdp_mstr .

                 ASSIGN
                         xxdp_type = t1_type
                         xxdp_nbr = v_nbr
                         xxdp_line = m
                         xxdp_add =  t1_add     /* ����1 or���� �� */
                         xxdp_vend =  t1_cust
                         xxdp_seq = t1_seq
                         xxdp_supply = t1_vend
                         xxdp_receive_site = t1_site
                         xxdp_cust_part = t1_cust_part
                         xxdp_desc1 = t1_desc1
                         xxdp_desc2 = t1_desc2
                         xxdp_plancode = t1_plancode
                         xxdp_date = t1_date
                         xxdp_time = t1_time
                         xxdp_qty = t1_qty
                         xxdp_check = t1_check
                         xxdp_ver =  t1_ver
                         xxdp_month = t1_month
                         xxdp_ptype = t1_ptype    /* sp mp */
                         xxdp_rmks = t1_rmks
                         xxdp_rmk1 = t1_rmks1
                         xxdp_part = t1_part
                         xxdp_year = YEAR(t1_date)
                         xxdp_pdate = 1
                         xxdp_process = YES
                         xxdp_crt_date = TODAY
                     .
               IF LAST-OF(t1_date) THEN DO:
/*                    IF ( v_qty MOD v_day ) = 0 THEN DO:                          */
/*                      v_qty_ord = v_qty / v_day .                                */
/*                      v_qty_ord1 = v_qty_ord .                                   */
/*                    END.                                                         */
/*                    ELSE DO:                                                     */
/*                        v_qty_ord = TRUNCATE( v_qty / v_day , 0 ) .              */
/*                        v_qty_ord1 = ( v_qty - v_qty_ord * v_day ) + v_qty_ord . */
/*                    END.                                                         */

                   v_qty_ord = v_qty .
                   v_qty_ord1 = v_qty .

                   {xxmdpnew1.i}
               END.

              /* ss - 110412.1 -b
               /* ������ָ���� */
                 IF LAST-OF(t1_part) AND t1_type = "w" THEN DO:

                      /* �ָ����*/
                     FIND FIRST tt WHERE tt_type = t1_type AND tt_cust = t1_cust AND tt_ver = t1_ver AND tt_ptype = t1_ptype
                             AND tt_part = t1_part  NO-ERROR .
                         IF  AVAILABLE tt THEN DO:

                             ASSIGN
                                 v_date = tt_start
                                 v_end = tt_end
                                 .



                                     /* ͳ�Ƹ��º󶩵�����*/
                                     v_qty = 0 .

                                     REPEAT WHILE v_date <= v_end :



                                                FIND FIRST cm_mstr WHERE cm_addr = t1_cust NO-LOCK NO-ERROR .
                                                IF AVAIL cm_mstr THEN v_sort = SUBSTRING(cm_sort ,1 , 2 ) . ELSE v_sort = "" .

                                                 v_year = SUBSTRING(STRING(YEAR(v_date),"9999") , 3 ).
                                                 IF MONTH(v_date) < 10 THEN v_month = STRING(MONTH(v_date) ,"9") .
                                                 ELSE IF MONTH(v_date) = 10 THEN v_month = "A".
                                                 ELSE IF MONTH(v_date) = 11 THEN v_month = "B".
                                                 ELSE v_month = "C" .

                                                 v_sonbr = v_sort + v_year + v_month + STRING(DAY(v_date),"99") + SUBSTRING(t1_ptype,1,1) .


                                                FIND FIRST sod_det WHERE sod_nbr = v_sonbr AND sod_part = t1_part NO-LOCK NO-ERROR .
                                                IF  AVAILABLE sod_Det THEN  DO:


                                                        v_qty = v_qty + sod_qty_ord .



                                               END.



                                      v_date = v_date + 1 .
                                   END.


                                   /* �ӿ�ʼ���ڵ��������ڼ��㶩�� */
                                    /* ͳ�Ƹ��º󶩵�����*/
                                    /* ƽ������ʣ�ඩ��*/
                                   IF tt_total - v_qty > 0   THEN DO:
                                       /* ����*/
                                      IF tt_day > 0 THEN DO:



                                              v_day = tt_day .
                                              
                                              IF v_day <> 0 THEN  DO:
                                              
                                              v_qty = tt_total - v_qty .  /* ʣ������*/

                                              IF ( v_qty MOD v_day ) = 0 THEN DO:
                                                 v_qty_ord = v_qty / v_day .
                                                 v_qty_ord1 = v_qty_ord .
                                               END.
                                               ELSE DO:
                                                   v_qty_ord = TRUNCATE( v_qty / v_day , 0 ) .
                                                   v_qty_ord1 = ( v_qty - v_qty_ord * v_day ) + v_qty_ord .
                                               END.

                                              {xxmdpupd2.i}
                                              END.
                                               ELSE DO:
                                                            CREATE ttem.
                                                              ASSIGN
                                                                  ttem_type1 = "��Ŀ"
                                                                  ttem_type = "����" 
                                                                  ttem_cust = t1_cust
                                                                  ttem_part = t1_ptype + "p"
                                                                  ttem_desc = "���ʱ��Ϊ�ż�ʱ�䡣"
                                                                  .

                                            END.
                                      END.


                                   END.
                                   ELSE DO: /* Ϊ0 ɾ��ʣ���¶���*/
                                       IF tt_day > 0 THEN DO:
                                           {xxmdpdel1.i}
                                       END.

                                   END.




                         END.



                     /*  �ָ���� */




                 END.
               /* ������ָ���� */

                ss - 110412.1 -e */


     END.
     /* ���� */




      MESSAGE "���ι�����" + string(j) + "������,���鵼������Ϣ�ļ���ȷ�������Ƿ�������ȷ�ĵ��뵽ϵͳ!" VIEW-AS ALERT-BOX.
      /*HIDE MESSAGE NO-PAUSE .*/
    
      OUTPUT TO VALUE (fn_me) APPEND .
      EXPORT DELIMITER ";" "����" "��������" "�ͻ�����" "����/�����" 
                           "��������" .
      FOR EACH ttem  WHERE ttem_cust <> "" :
          EXPORT DELIMITER ";" ttem .
      END.
      OUTPUT CLOSE .

       OUTPUT TO VALUE (fn_me) APPEND .
/*       EXPORT DELIMITER ";" "����" "��������" "�ͻ�����" "����/�����" */
/*                            "��������" .                               */
      FOR EACH tte WHERE tte_cust <> "":
          EXPORT DELIMITER ";" tte .
      END.
      OUTPUT CLOSE .

      OUTPUT TO VALUE(fn_ok) APPEND .
      EXPORT DELIMITER ";" "������" .
      FOR EACH tto WHERE tto_nbr <> "" BREAK BY tto_nbr :
          IF FIRST-OF(tto_nbr) THEN
          EXPORT DELIMITER ";" tto.
      END.
      OUTPUT CLOSE .

     /*
     {mfreset.i} 
   {mfgrptrm.i}
   */
end.
