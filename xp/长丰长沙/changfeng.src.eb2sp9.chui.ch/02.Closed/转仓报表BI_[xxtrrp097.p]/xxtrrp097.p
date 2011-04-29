/*xxtrrp097.p 转仓BI报表                                                                              */
/* REVISION: 100701.1   Created On: 20100701   By: Softspeed Roger Xiao                               */
/*-Revision end---------------------------------------------------------------*/


{mfdtitle.i "100701.1"}


define var loc   like pt_part .
define var loc1  like pt_part .
define var part  like pt_part .
define var part1 like pt_part .
define var date  as date .
define var date1 as date .

define var v_loc_to like tr_loc .
define var um    like pt_um.
define var desc1 like pt_desc1.
define var desc2 like pt_desc2.
define var locname1   like pt_desc1 .
define var locname2   like pt_desc1 .


define temp-table temp1 
    field t1_date like tr_effdate
    field t1_part like tr_part 
    field t1_site like tr_site 
    field t1_locf like tr_loc 
    field t1_loct like tr_loc
    field t1_qty  like tr_qty_loc 
    field t1_amt  like tr_gl_amt 
    .

define buffer trbuff for tr_hist.


form
    SKIP(.2)

    date                     colon 18   label "生效日期"
    date1                    colon 54   label  {t001.i}     
    loc                      colon 18
    loc1                     colon 54   label  {t001.i} 
    part                     colon 18
    part1                    colon 54   label  {t001.i} 

    skip (2)
   
with frame a  side-labels width 80 attr-space.
setFrameLabels(frame a:handle).

{wbrp01.i}
repeat:
    for each temp1 : delete temp1 . end.

    if part1 = hi_char        then part1 = "".
    if loc1  = hi_char        then loc1  = "".
    if date1 = hi_date        then date1 = ? .
    if date  = low_date       then date  = ? .

    update  
        date 
        date1
        part 
        part1
        loc
        loc1
    with frame a.

       
    

    if part1 = ""      then part1  = hi_char.
    if loc1  = ""      then loc1   = hi_char .
    if date1 = ?       then  date1 = hi_date  .
    if date  = ?       then  date  = low_date .



    /*不可有换页符&pagedFlag = "nopage"*/
    {gpselout.i &printType = "printer"
                &printWidth = 132
                &pagedFlag = "nopage"
                &stream = " "
                &appendToFile = " "
                &streamedOutputToTerminal = " "
                &withBatchOption = "yes"
                &displayStatementType = 1
                &withCancelMessage = "yes"
                &pageBottomMargin = 6
                &withEmail = "yes"
                &withWinprint = "yes"
                &defineVariables = "yes"}
mainloop: 
do on error undo, return error on endkey undo, return error:                    


	PUT UNFORMATTED "#def REPORTPATH=$/csqad/xxtrrp097" SKIP.
	PUT UNFORMATTED "#def :end" SKIP.


    for each temp1 : delete temp1 . end.
    for each tr_hist
        use-index tr_type
        where tr_type = "ISS-TR"
        and  tr_effdate >= date and tr_effdate <= date1
        and  tr_part >= part    and tr_part <= part1 
        and  tr_loc  >= loc     and tr_loc  <= loc1
        no-lock:
        find first trbuff 
            where trbuff.tr_trnbr = tr_hist.tr_trnbr + 1 
            and   trbuff.tr_type  = "rct-tr"
            and   trbuff.tr_part  = tr_hist.tr_part
            and   trbuff.tr_qty_loc = - tr_hist.tr_qty_loc
        no-lock no-error.
        v_loc_to = if avail trbuff then trbuff.tr_loc else "" .


        find first temp1 
            where t1_date = tr_hist.tr_effdate 
            and   t1_part = tr_hist.tr_part 
            and   t1_site = tr_hist.tr_site
            and   t1_locf = tr_hist.tr_loc
            and   t1_loct = v_loc_to
        no-error.
        if not avail temp1 then do:
            create temp1 .
            assign 
                t1_date = tr_hist.tr_effdate     
                t1_part = tr_hist.tr_part        
                t1_site = tr_hist.tr_site        
                t1_locf = tr_hist.tr_loc         
                t1_loct = v_loc_to               
                .
        end.
        t1_qty = t1_qty + (- tr_hist.tr_qty_loc).
        t1_amt = t1_amt + (- tr_hist.tr_gl_amt).
    end. /*for each tr_hist*/


    for each temp1 break by t1_part by t1_date by t1_locf :
        find first pt_mstr where pt_part = t1_part no-lock no-error.
        um    = if avail pt_mstr then pt_um else "" .
        desc1 = if avail pt_mstr then pt_desc1 else "" .
        desc2 = if avail pt_mstr then pt_desc1 else "" .

        find first loc_mstr where loc_loc = t1_locf no-lock no-error.
        locname1 = if avail loc_mstr then loc_desc else "".
        find first loc_mstr where loc_loc = t1_locf no-lock no-error.
        locname2 = if avail loc_mstr then loc_desc else "".

        export delimiter ";"
            t1_part
            desc1
            desc2
            um 
            t1_date
            t1_qty
            t1_amt
            t1_locf
            locname1
            t1_loct
            locname2
            .
            /*A;A;a;ea;2001/01/01;100;100;loca;loca;locb;locb*/
    end. /*for each temp1*/


end. /* mainloop: */
/* {mfrtrail.i}  *REPORT TRAILER  */
{mfreset.i}
{pxmsg.i &MSGNUM=9 &ERRORLEVEL=1}
end.  /* REPEAT */
{wbrp04.i &frame-spec = a}
