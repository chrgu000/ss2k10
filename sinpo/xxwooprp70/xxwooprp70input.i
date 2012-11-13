/* SS - 110801.1 By: Kaine Zhang */

if dteA = low_date then dteA = ?.
if dteB = hi_date then dteB = ?.
if sWoNbrB = hi_char then sWoNbrB = "".
if sPartB = hi_char then sPartB = "".

update
    sParent
    sSite
    dteEffect
    dteA
    dteB
    sWoNbrA
    sWoNbrB
    sPartA
    sPartB
    dteDue
    sViewLevel
    bIncludeCloseWO
with frame a.


if (c-application-mode <> 'web')
    or (c-application-mode = 'web' and (c-web-request begins 'data'))
then do:
    bcdparm = "".
    {mfquoter.i   sParent       }
    {mfquoter.i   sSite         }
    {mfquoter.i   dteEffect     }
    {mfquoter.i   dteA          }
    {mfquoter.i   dteB          }
    {mfquoter.i   sWoNbrA           }
    {mfquoter.i   sWoNbrB           }
    {mfquoter.i   sPartA            }
    {mfquoter.i   sPartB            }
    {mfquoter.i   dteDue            }
    {mfquoter.i   sViewLevel            }
    {mfquoter.i   bIncludeCloseWO        }
end.

if lookup(sViewLevel, "1,2,3,4") = 0 then do:
    message "显示级别输入无效".
    undo, retry.
end.

if dteA = ? then dteA = low_date.
if dteB = ? then dteB = hi_date.
if sWoNbrB = "" then sWoNbrB = hi_char.
if sPartB = "" then sPartB = hi_char.

find first pt_mstr
    no-lock
    where pt_domain = global_domain
        and pt_part = sParent
    no-error.
if available(pt_mstr) and sSite = "" then sSite = pt_site.
display sSite with frame a.





