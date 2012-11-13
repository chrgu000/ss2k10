/* SS - 110801.1 By: Kaine Zhang */

if sLocB = hi_char then sLocB = "".
if sPartB = hi_char then sPartB = "".
if sProdLineB = hi_char then sProdLineB = "".

if c-application-mode <> 'web' then
    update
        sSite    
        sLocA
        sLocB
        sProdLineA
        sProdLineB
        sPartA    
        sPartB    
    with frame a .

{wbrp06.i
    &command = update
    &fields = "
        sSite    
        sLocA
        sLocB
        sProdLineA
        sProdLineB
        sPartA    
        sPartB    
        "
    &frm = "a"
}



if (c-application-mode <> 'web')
    or (c-application-mode = 'web' and (c-web-request begins 'data'))
then do:
    bcdparm = "".
    {mfquoter.i  sSite      }
    {mfquoter.i  sLocA      }
    {mfquoter.i  sLocB      }
    {mfquoter.i  sProdLineA }
    {mfquoter.i  sProdLineB }
    {mfquoter.i  sPartA     }
    {mfquoter.i  sPartB     }

    if sPartB = "" then sPartB = hi_char.
    if sLocB = "" then sLocB = hi_char.
    if sProdLineB = "" then sProdLineB = hi_char.
end.





