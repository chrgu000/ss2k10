/* �ƿⵥ�ӳ��� - Create by Long bo        2004-5-11            */
/* �ó����ƿ������ã���ʾ�õ����ƿ�����������û������޸����� */
/* Ȼ��ó�����ñ�׼�ƿ��������ƿ�                         */
/* ���ת���������λ�������ȼ�¼����ʱ�� rctkb ��              */
/* last modify by Sunny on May 20,2004 xxut001.i change to xkut001.i            */
/* Last Modified: hou      2006.03.08                     *H01* */

	{mfdeclre.i}

	define input PARAMETER rdcponbr like po_nbr.
	define input PARAMETER rdceffdate as date.

	define variable yn as logical .		
	
	/*
	def new shared temp-table xkrodet like xkrod_det.

*/

	define /*H01* new */ shared work-table xkrodet
		field xkrodnbr like xkrod_det.xkrod_nbr
		field xkrodline like xkrod_line
		field xkrodpart like pt_part
		field xkrodqtyord as decimal format "->,>>>,>>9.9<<<<<<<<" label "����"
		field xkrodqtyopen as decimal format "->,>>>,>>9.9<<<<<<<<" label "��ת����"
 		field xkrodqtyrcvd as decimal format "->,>>>,>>9.9<<<<<<<<" label "��ת����".
	
	FORM 
        xkrodet.xkrodpart label "���"
        xkrodet.xkrodqtyord label "����"  /*lb01*/
        xkrodqtyrcvd label "��ת����"
        xkrodet.xkrodqtyopen label "��ת������"
	with centered overlay 10 DOWN frame f-errs width 80 THREE-D .

	find first xkro_mstr no-lock where xkro_nbr = rdcponbr no-error.
	if not available xkro_mstr then leave.
	
	for each xkrodet:
		delete xkrodet.
	end.

/* lb01*/	
	for each xkrod_det no-lock where xkrod_nbr = rdcponbr:
		create xkrodet.
		assign
		xkrodnbr = xkrod_det.xkrod_nbr
		xkrodline = xkrod_line
		xkrodpart = xkrod_part
		xkrodqtyord = xkrod_qty_ord
		xkrodqtyopen = xkrod_qty_ord - xkrod_qty_rcvd
 		xkrodqtyrcvd = xkrod_qty_rcvd.
	end.
	
	
mainloop:
repeat:
	do transaction on error undo, leave : 
	  
		clear frame d all.
		clear frame c all.
		
		/*DISPLAY ITEMS WILL TO TRANSFER */
		display
		xkro_site label "Դ�ص�"
	        xkro_loc label "Դ��λ"
	        xkro_dsite label "Ŀ�ĵص�"
	        xkro_dloc label "Ŀ�Ŀ�λ"
		with frame c width 80.	
		
	    for each xkrodet:
	        display 
	        xkrodet.xkrodpart label "���"
	        xkrodet.xkrodqtyord label "����"  /*lb01*/
	        xkrodet.xkrodqtyrcvd label "��ת����"  /*lb01*/
	        xkrodet.xkrodqtyopen label "��ת����"  /*lb01*/
	        with frame d down width 80.
	        down 1 with frame d.
	    end.
	
	    yn = yes .
	    message "ȷ�Ͻ���Щ����ƿ⣿ " view-as alert-box question buttons yes-no-cancel
	    update yn .
	    if yn = ? then 
	    	return.
	    
	    if not yn then do :
	
	        mainblock:
	        do on error undo,leave on endkey undo,leave:
	
	            clear frame f-errs all.
	            hide frame d .
	
/*sunny*/	            { xkut001.i 
			    &file = "xkrodet"
			    &frame = "f-errs"
			    &fieldlist = "xkrodet.xkrodpart
					  xkrodet.xkrodqtyord  /*lb01*/
					  xkrodet.xkrodqtyrcvd /*lb01*/
					  xkrodet.xkrodqtyopen 
					"
			    &prompt     = "xkrodet.xkrodpart" 
			    &pgupkey    = "ctrl-u"
			    &pgdnkey    = "ctrl-d"
			    &midchoose  = "color mesages"
			    &updkey = "M"
			    &updcode = "~{xkrdctrb.i~}"	
				  }              
	
	            hide frame f-errs no-pause .
	
	        end.        
	
	        hide message no-pause.
	
	    end.
	
	    if yn = yes then do : 
			{gprun.i ""xkiclotr03.p"" "(rdcponbr, rdceffdate)"}
			return.
	    end. 
	end.	
end.	
	


