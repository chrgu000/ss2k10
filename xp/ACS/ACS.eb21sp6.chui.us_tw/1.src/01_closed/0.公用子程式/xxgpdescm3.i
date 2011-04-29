/* xxgpdescm3.i update to glt_Det from xxgpdescm shared temp-table */

        /********************************************************************
                *此为公用子程式,不可随意修改!!*      
                *同时被调用于:27.1,27.6.4,27.6.9,28.1,28.9.10等*
         ********************************************************************/
/*----rev history-------------------------------------------------------------------------------------*/
/* SS - 110114.1  By: Roger Xiao */
/*-Revision end---------------------------------------------------------------*/



if v_tt then do:
    for each tt_hist 
        where tt_table = "{&table}" :

        find first {&table} where recid({&table}) = tt_recid no-error .
        if avail {&table} then do:
            if {&desc} <> tt_Desc then do:
                assign {&desc} = tt_desc .
            end.

            for each glt_det 
                where glt_doc = {&gltdoc} 
                and (glt_acct = {&gltacct} )
                :
                assign glt_desc = tt_desc .
            end.
        end.


        release {&table} .
        release glt_Det .

        delete tt_hist.
    end. /*for each tt_hist :*/
end. /*if v_tt then*/
