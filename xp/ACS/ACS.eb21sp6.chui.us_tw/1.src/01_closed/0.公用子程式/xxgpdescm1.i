/* xxgpdescm1.i var define for xxgpdescm shared temp-table */
        /********************************************************************
                *��Ϊ�����ӳ�ʽ,���������޸�!!*      
                *ͬʱ��������:27.1,27.6.4,27.6.9,28.1,28.9.10��*
         ********************************************************************/
/*----rev history-------------------------------------------------------------------------------------*/
/* SS - 110114.1  By: Roger Xiao */
/*-Revision end---------------------------------------------------------------*/


define {1} shared var v_tt as logical no-undo .
define {1} shared temp-table tt_hist no-undo
    field tt_table    as char 
    field tt_recid    as recid   
    field tt_desc     as char .