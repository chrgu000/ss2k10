/* xxmsg01.p wireless barcode equipment 's message display                  */
/* REVISION: 1.0      Create : 08/17/06   BY: Roger                         */
/* ------------------------------------------------------------------------ */

/* 如果文件xxmsg01.p编译在 /ch/xx      :  {gprun.i ""xxmsg01.p"" "(input v_nbr , input  v_desc ,input v_err)"}  */
/* 如果文件xxmsg01.p存放在 /app/bc/xs  :   run xxmsg01.p (input v_nbr , input  v_desc ,input v_err)  .          */

define input parameter  v_nbr like msg_nbr .
define input parameter  v_desc as char  .
define input parameter  v_err as logical   .

define var v_msg as char  format "x(24)" extent 5 .

hide all no-pause .

        define frame bcmsg
           v_msg[1] no-label skip
           v_msg[2] no-label skip
           v_msg[3] no-label skip
           v_msg[4] no-label skip
           v_msg[5] no-label skip
        with  size  24 by 5  no-box. 
        
        
        if v_nbr > 0  then do:
            for first msg_mstr where msg_lang = "ch" and msg_nbr = v_nbr no-lock :
                v_msg[1] = right-trim(msg_desc)  .
            end.       
        end.
         
        

        v_msg[2] = right-trim(substring(v_msg[1],1,12)) .
        v_msg[3] = if right-trim(substring(v_msg[1],13)) = "" then "" else right-trim(substring(v_msg[1],13)) .
        v_msg[4] = v_desc .
        v_msg[1] = "" . 
        
        
        if v_err  then do:
            v_msg[5] =  "按任意键继续...".
            disp v_msg[1] v_msg[2] v_msg[3] v_msg[4] v_msg[5]  with frame bcmsg .
            pause  NO-MESSAGE .
        end.
        else do:
            v_msg[5] =  "暂停1秒,按任意键继续...".
            disp v_msg[1] v_msg[2] v_msg[3] v_msg[4] v_msg[5]  with frame bcmsg .
            pause 1 NO-MESSAGE .
        end.

hide all no-pause .


/* 原始程序:                                                         */
/*                                                                   */
/* {mfdtitle.i "1+ "}                                                */
/*                                                                   */
/* {pxmsg.i &MSGNUM=1  &ERRORLEVEL=1 }                               */
/*                                                                   */
/*                                                                   */
/* ERRORLEVEL=1 . just disp error message                            */
/* ERRORLEVEL=2 . disp Waring: + error message                       */
/* ERRORLEVEL=3 . disp error : + error message  + Please input again */
