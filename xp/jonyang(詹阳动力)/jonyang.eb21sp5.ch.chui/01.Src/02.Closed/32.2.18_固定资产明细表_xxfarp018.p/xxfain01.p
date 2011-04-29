/*xxfain01.p  ����̶��ʲ����۾ɵ�����*/
/*��Ϊ�����ӳ�ʽ,���������޸�*/      /*ͬʱ���̶��ʲ�ά�� �� ��ر������*/
/*----rev history-------------------------------------------------------------------------------------*/
/* SS - 100510.1  By: Roger Xiao */  
/*-Revision end---------------------------------------------------------------*/

{mfdeclre.i}


/*
fapl.p bug:
ȡ���۾ɺ�,�ٱ���,�ұ�������С��ȡ���۾����ڵ��ʲ�,��������۾���ϸ,
�۾ɶ�Ϊ0 
����ڼ����200900
*/


/*ȡ������,�����۾�*/
PROCEDURE get-mth-used:
    /*
    input : ����������, �۾ɿ�ʼ�ڼ�,�۾���ֹ�ڼ�,�����ڼ�
    output: �����۾�����,�����۾�����

    ��: ����ÿ�궼��12���ڼ�.
    */

    define input  parameter i_life  as integer   no-undo.
    define input  parameter i_conv  as character no-undo.
    define input  parameter i_beg   as character no-undo.
    define input  parameter i_end   as character no-undo.
    define input  parameter i_now   as character no-undo.

    define output parameter o_oldyr   as integer   no-undo.
    define output parameter o_thisyr  as integer   no-undo.


    define var as-of-per as character no-undo.
    define var yrbeg as integer no-undo.
    define var yrend as integer no-undo.
    define var mth1  as integer no-undo. /*����*/
    define var mth2  as integer no-undo. /*�м�*/
    define var mth3  as integer no-undo. /*����*/

    as-of-per = min(i_end,i_now) . /*ȡ�����ڼ�*/
    if i_beg > as-of-per then leave .

    yrbeg = integer(substring(i_beg,1,4)).
    yrend = integer(substring(as-of-per,1,4)).
    mth1  = 0.
    mth2  = 0.
    mth3  = 0.

    /*�������ڼ����۾�����*/
    if yrbeg = yrend then do:
        mth1 = 0 .
        mth2 = 0 .
        mth3 = integer(substring(as-of-per,5,2)) - integer(substring(i_beg,5,2)) + 1 .
    end.
    else do:
        mth1 = 12 - integer(substring(i_beg,5,2)) + 1 . 
        mth2 = 12 * (yrend - yrbeg - 1) .
        mth3 = integer(substring(as-of-per,5,2)) .        
    end.


    /*�������ڼ�,�Ƿ񱨱��ڼ��ͬ��*/
    if substring(i_end,1,4) >= substring(i_now,1,4) then do:
        o_oldyr  = mth1 + mth2 .
        o_thisyr = mth3.
    end.
    else do:
        o_oldyr  = mth1 + mth2 + mth3.
        o_thisyr = 0.        
    end.
    
    /*���ڼ��۾ɷ�,�ڼ�����1 */
    if (i_conv = "2" or  i_conv = "3") then do:
        if o_oldyr > 0 then o_oldyr = max(0,o_oldyr - 1) .
        else o_thisyr = max(0,o_thisyr - 1) .
    end.

END PROCEDURE.  /* get-mth-used */




/*��Ϊ�����ӳ�ʽ,���������޸�*/
