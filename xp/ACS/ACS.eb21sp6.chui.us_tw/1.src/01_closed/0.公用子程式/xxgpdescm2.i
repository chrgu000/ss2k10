/* xxgpdescm2.i create record for xxgpdescm shared temp-table */
/*��Ϊ�����ӳ�ʽ,���������޸�!!*/      /*ͬʱ��������:27.1,27.6.4,27.6.9,28.1,28.9.10��*/
        /********************************************************************
                *��Ϊ�����ӳ�ʽ,���������޸�!!*      
                *ͬʱ��������:27.1,27.6.4,27.6.9,28.1,28.9.10��*
         ********************************************************************/
/*----rev history-------------------------------------------------------------------------------------*/
/* SS - 110114.1  By: Roger Xiao */
/*-Revision end---------------------------------------------------------------*/



find first tt_hist 
   where tt_table = "{&table}"
   and   tt_recid = recid({&table})
no-error.
if not avail tt_hist then do:
   create tt_hist .
   assign tt_table = "{&table}"      
          tt_recid = recid({&table}) 
          .
end.
assign 
    tt_desc  = {&desc}       
    v_tt     = yes.
