/* xsmf002main.p  sfc主程式                                                */
/* REVISION: 1.0         Last Modified: 2008/11/27   By: Roger   ECO:      */
/*-Revision end------------------------------------------------------------*/


/*不直接用xsmf002.p做主程式,是防止按F4退回到progress editor */


mainloop:
repeat:

    hide all no-pause .
    run xsmf002.p .
    quit.
         
    leave .   
end. /*mainloop*/
hide all no-pause .
quit.