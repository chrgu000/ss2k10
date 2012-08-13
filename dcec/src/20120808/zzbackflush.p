/* xxTransfer.p Item transfer report                   */
/* COPYRIGHT DCEC. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK.     */
/* V1   Developped: 03/28/01   BY: Zhang weihua */

 
/* ��ӳ���ת�����ı��� */

{mfdtitle.i } 
def var flushdate like tr_effdate . /*format "99/99/9999".*/
def var flushdate1 like tr_effdate. /* format "99/99/9999".*/
def var effdate  like tr_effdate.  /* format "99/99/9999".*/
def var effdate1 like tr_effdate.  /*format "99/99/9999".*/
def var site like tr_site .
def var bktotal as integer .
def var bkall as integer.


    
/*GUI preprocessor Frame A define */
&SCOPED-DEFINE PP_FRAME_NAME A
 FORM /*GUI*/ 
 RECT-FRAME       AT ROW 1.4 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1   COLUMN 3 NO-LABEL
 SKIP(.1)  /*GUI*/
	     flushdate           label "�س������ʱ��"colon 18
	     flushdate1          label {t001.i} colon 49 skip
	     effdate             label "��Ч����"colon 18
	     effdate1            label {t001.i} colon 49 skip

	     site                label "�ص�"  colon 18 
	              
  skip
with frame a side-labels width 80 attr-space NO-BOX THREE-D /*GUI*/.



 DEFINE VARIABLE F-a-title AS CHARACTER.
 F-a-title = " ѡ������ ".
 RECT-FRAME-LABEL:SCREEN-VALUE in frame a = F-a-title.
 RECT-FRAME-LABEL:WIDTH-PIXELS in frame a =
  FONT-TABLE:GET-TEXT-WIDTH-PIXELS(
  RECT-FRAME-LABEL:SCREEN-VALUE in frame a + " ", RECT-FRAME-LABEL:FONT).
 RECT-FRAME:HEIGHT-PIXELS in frame a =
  FRAME a:HEIGHT-PIXELS - RECT-FRAME:Y in frame a - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME a = FRAME a:WIDTH-CHARS - .5. /*GUI*/

/*GUI preprocessor Frame A undefine */
&UNDEFINE PP_FRAME_NAME
	  /* REPORT BLOCK */

	  
/*GUI*/ {mfguirpa.i true  "printer" 132 }  /*�ð����ļ��ǳ���Ҫ����û�иð����ļ�����ϵͳ��������ļ������������������ѡ��͹��� */

/*GUI repeat : */
/*GUI*/ procedure p-enable-ui:

	     if site  = hi_char then site = "".
	     if effdate = low_date then effdate = ?.
	     if effdate1 = hi_date then effdate1 = ?.
      	     if flushdate = low_date then flushdate = ?.
	     if flushdate1 = hi_date then flushdate1 = ?.


	     
run p-action-fields (input "display").
run p-action-fields (input "enable").
end procedure. /* p-enable-ui, replacement of Data-Entry GUI*/

/*GUI*/ procedure p-report-quote:  /*����������ı���������Ч�Լ��*/


          /*  {mfquoter.i keeper   }*/
	     {mfquoter.i site  }
     	     {mfquoter.i flushdate    }
     	     {mfquoter.i flushdate1   }
     	     {mfquoter.i effdate  }
     	     {mfquoter.i effdate1 }
	     if  site = "" then site = hi_char.
	     if  effdate =? then effdate  = low_date.
	     if  effdate1=? then effdate1 = hi_date.
	     if  flushdate =? then flushdate  = low_date.
	     if  flushdate1=? then flushdate1 = hi_date.

	     

	     /* SELECT PRINTER */
	     
/*GUI*/ end procedure. /* p-report-quote */

/*GUI*/ procedure p-report:
        {gpprtrpa.i "printer" 132}/*-------�ð����ļ���ù��ɽ���ǰ��mfgrptrm.i�ļ����ʹ�ã��ɽ���Ϣ���뵽windows*/
                /*{mfphead.i}. */   /*�ð����ļ��Ƿ�������ʾһЩ���еı�ͷ��ʽ��Ϣ�ģ�����˵����ƣ�ҳ�š�����Ҫ��ʾҳ�ŵĿ�ʹ�ôΰ����ļ�*/
   bktotal =0.
            bkall =0.
            FOR EACH tr_hist  where (tr_date >= flushdate and tr_date <= flushdate1) and (tr_effdate >= effdate and tr_date <= effdate1) and tr_type ="rct-wo"  and tr_userid ="MRP"  and tr_site = site  break by tr_part :
                bktotal = bktotal + tr_qty_loc.
                if last-of(tr_part) then  do:
                    find pt_mstr no-lock where pt_part = tr_part and pt_part_type ='58' no-error. 
                       if available pt_mstr  then do:
                           bkall = bkall + bktotal.
                           display  tr_part label "�������ͺ�"  pt_desc2 label "����������"  bktotal label "�س�������" tr_site label " �ص�" tr_loc label " ��λ" tr_effdate label "��Ч����" tr_date label "��������"  bkall with width 120 stream-io.
                       end.
                       bktotal =0.
                end.         
             END.
        /*     disp bkall.          */
         /*{mfguitrl.i}*/ 
        /*GUI*/ {mfgrptrm.i} /*Report-to-Window*/
        end procedure.

/*GUI*/ {mfguirpb.i &flds="  flushdate flushdate1 effdate effdate1 site "} /*Drive the Report*/ /*---�ð����ļ����������ֶεĿɱ༭״̬----*/


 {mfreset.i}





