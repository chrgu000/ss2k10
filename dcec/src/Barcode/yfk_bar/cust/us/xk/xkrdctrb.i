/* CREATE BY LOONGBO  */

/* LAST MODIFIED BY LB01  LONG BO 2004-6-14                          
	���Ӿ�����ʾ�����û�����ת����������OPEN������ʱ��
*/


updblock:
do on endkey undo, leave
    on error undo, leave :

    find xkrodet where recid(xkrodet) = w-rid[frame-line(f-errs)] no-error .
    if not available xkrodet then leave updblock .
    display xkrodet.xkrodpart
    		xkrodet.xkrodqtyopen   /*lb01*/
    		xkrodet.xkrodqtyrcvd /*lb01*/
		    xkrodet.xkrodqtyord 
         with frame f-errs .
	
	update  xkrodet.xkrodqtyopen  with frame f-errs . 


	/*lb01*--*/
	if (xkrodet.xkrodqtyord - xkrodet.xkrodqtyrcvd)
	  < xkrodet.xkrodqtyopen then do:
		message "���棺ת����������δ������������:" + string(xkrodet.xkrodqtyord)
		    + " ��ת����: " + string(xkrodet.xkrodqtyrcvd) 
		    + " δ����: " + string(xkrodet.xkrodqtyopen).
		pause.
	end.
	/*--lb01*/
     
end.
