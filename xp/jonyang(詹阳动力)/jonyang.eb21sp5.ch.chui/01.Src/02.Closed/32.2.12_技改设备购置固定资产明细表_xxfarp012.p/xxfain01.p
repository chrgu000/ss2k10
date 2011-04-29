/*xxfain01.p  计算固定资产已折旧的月数*/
/*此为公用子程式,不可随意修改*/      /*同时被固定资产维护 和 相关报表调用*/
/*----rev history-------------------------------------------------------------------------------------*/
/* SS - 100510.1  By: Roger Xiao */  
/*-Revision end---------------------------------------------------------------*/

{mfdeclre.i}


/*
fapl.p bug:
取代折旧后,再报废,且报废日期小于取代折旧日期的资产,不会产生折旧明细,
折旧额为0 
最后期间会变成200900
*/


/*取得往年,今年折旧*/
PROCEDURE get-mth-used:
    /*
    input : 寿命总月数, 折旧开始期间,折旧终止期间,报表期间
    output: 往年折旧月数,本年折旧月数

    另: 假设每年都是12个期间.
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
    define var mth1  as integer no-undo. /*首年*/
    define var mth2  as integer no-undo. /*中间*/
    define var mth3  as integer no-undo. /*本年*/

    as-of-per = min(i_end,i_now) . /*取结束期间*/
    if i_beg > as-of-per then leave .

    yrbeg = integer(substring(i_beg,1,4)).
    yrend = integer(substring(as-of-per,1,4)).
    mth1  = 0.
    mth2  = 0.
    mth3  = 0.

    /*按结束期间算折旧期数*/
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


    /*检查结束期间,是否报表期间的同年*/
    if substring(i_end,1,4) >= substring(i_now,1,4) then do:
        o_oldyr  = mth1 + mth2 .
        o_thisyr = mth3.
    end.
    else do:
        o_oldyr  = mth1 + mth2 + mth3.
        o_thisyr = 0.        
    end.
    
    /*下期间折旧法,期间数减1 */
    if (i_conv = "2" or  i_conv = "3") then do:
        if o_oldyr > 0 then o_oldyr = max(0,o_oldyr - 1) .
        else o_thisyr = max(0,o_thisyr - 1) .
    end.

END PROCEDURE.  /* get-mth-used */




/*此为公用子程式,不可随意修改*/
