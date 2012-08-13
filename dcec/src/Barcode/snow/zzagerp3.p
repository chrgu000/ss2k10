/* zzagerp3.p aging  REPORT FROM invoice DATE                           */
/*                                 04/05/2000   by: fqtao                 */


         define new shared variable cust like ar_bill.
         define new shared variable cust1 like ar_bill.
         define new shared variable inv_date like ih_inv_date.
         define new shared variable inv_date1 like ih_inv_date label "effdate".
         define new shared variable age_days as integer extent 5
           label "Column Days".
         define new shared variable age_range as character extent 5
           format "X(16)".
         define new shared variable age_amt like ar_amt extent 6.
         define new shared variable age_tmp like ar_amt extent 6 .

        define new shared variable xxa_ar_amt like ar_amt label "AR balance".
        define new shared variable be_amt like ar_amt label "Beer Amt.".
        define new shared variable bc_amt like ar_amt label "B&C Amt.".
        define variable i as integer .
      /*  define  shared workfile age_file
             field age_cust like cm_addr
             field age_bc_amt like ar_amt
             field age_be_amt like ar_amt
             field age_ar_amt like ar_amt . */
/*G1P6*/  {mfdtitle.i "h "} 

         form
            cust           colon 15
            cust1          label {t001.i} colon 49 skip
           /* inv_date       colon 15  */
            inv_date1      colon 15 skip

            age_days[1]
            age_days[2]    label "[2]"
            age_days[3]    label "[3]"
            age_days[4]    label "[4]"  skip 
            age_days[5]    label "[5]"  skip(1)
         with frame a side-labels /*GM57*/ width 80.

/*lion*/         setFrameLabels(frame a:handle).
         repeat:

            if cust1 = hi_char then cust1 = "".
            if inv_date1 = hi_date then inv_date1 = ?.
            do i = 1 to 5:
               if age_days[i] = 0 then age_days[i] = (i  * 15).
            end.

            update
               cust cust1   inv_date1 
               age_days[1 for 5]
            with frame a.

            bcdparm = "".
            {mfquoter.i cust        }
            {mfquoter.i cust1       }
            {mfquoter.i inv_date    }
            {mfquoter.i inv_date1   }
            {mfquoter.i age_days[1] }
            {mfquoter.i age_days[2] }
            {mfquoter.i age_days[3] }
            {mfquoter.i age_days[4] }

            if cust1 = "" then cust1 = hi_char.
            if inv_date = ? then inv_date = low_date.
            if inv_date1 = ? then inv_date1 = hi_date.

            /* SELECT PRINTER */
            {mfselbpr.i "printer" 132}

            {gprun.i ""zzagerp3a.p""}
         /*   display age_file . */
            {mfrtrail.i}

         end.
