/* CREATE BY LOONGBO  */

/* LAST MODIFIED BY LB01  LONG BO 2004-6-14                          
	增加警告提示，当用户输入转移数量大于OPEN数量的时候
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
		message "警告：转移数量大于未结数量。订量:" + string(xkrodet.xkrodqtyord)
		    + " 已转移量: " + string(xkrodet.xkrodqtyrcvd) 
		    + " 未结量: " + string(xkrodet.xkrodqtyopen).
		pause.
	end.
	/*--lb01*/
     
end.
