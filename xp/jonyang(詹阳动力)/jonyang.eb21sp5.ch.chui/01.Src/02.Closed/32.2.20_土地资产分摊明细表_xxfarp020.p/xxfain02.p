/*xxfain02.p  ����������ʼ�·�,����:���۽����ڼ�*/
/*��Ϊ�����ӳ�ʽ,���������޸�*/     
/*----rev history-------------------------------------------------------------------------------------*/
/* SS - 100510.1  By: Roger Xiao */  
/*-Revision end---------------------------------------------------------------*/

{mfdeclre.i}


/*����������ʼ�·�,����:���۽����ڼ�*/
PROCEDURE get-perend-need:
    /*
    input : ����������, �۾ɷ���,�۾ɿ�ʼ�ڼ�,
    output: ���۽����ڼ�

    ��: ����ÿ�궼��12���ڼ�.
    */

    define input  parameter i_life  as integer   no-undo.
    define input  parameter i_conv  as character no-undo.
    define input  parameter i_beg   as character no-undo.
    define output parameter o_end   as character no-undo.

    define var v_mth as integer  no-undo.
    define var v_ii  as integer  no-undo.
    define var v_yr  as integer  no-undo.

    if (i_conv = "2" or  i_conv = "3") then i_life = i_life + 1.

    v_mth = integer(substring(i_beg,5,2)) .
    v_yr  = integer(substring(i_beg,1,4)) .

    v_ii = 0 .
    do v_ii = 2 to i_life:
        if v_mth <= 11 then v_mth = v_mth + 1 .
        else do:
            v_mth = 1 .
            v_yr  = v_yr + 1 .
        end.        
    end.

    o_end = string(v_yr,"9999") + string(v_mth,"99") .
END PROCEDURE.  /* get-perend-need */


/*��Ϊ�����ӳ�ʽ,���������޸�*/     

