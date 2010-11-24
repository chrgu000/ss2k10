/*  ---- */
/* Copyright 2010 SoftSpeed gz                                                         */
/* All rights reserved worldwide.  This is an unpublished work.                        */
/* SS - 100412.1 By: Kaine Zhang */



    if sVendorB = hi_char then sVendorB = "".

    if c-application-mode <> 'web' then
        update
            iYear
            iMonth
            sVendorA
            sVendorB
        with frame a .

    {wbrp06.i
        &command = update
        &fields = "
            iYear
            iMonth
            sVendorA
            sVendorB
            "
        &frm = "a"
    }
    


    if (c-application-mode <> 'web')
        or (c-application-mode = 'web' and (c-web-request begins 'data'))
    then do:
        bcdparm = "".
        {mfquoter.i iYear   }
        {mfquoter.i iMonth  }
        {mfquoter.i sVendorA  }
        {mfquoter.i sVendorB  }

        if sVendorB = "" then sVendorB = hi_char.
    end.


    find first glc_cal where glc_domain = global_domain and glc_year = iYear and glc_per = iMonth no-lock no-error.
	if not avail glc_cal then do:
	 	message "期间不存在".
	 	undo, retry.
	end.
	
	