/* SS - 110104.1 By: Kaine Zhang */

&if defined(canAccessPart) = 0 &then
    function canAccessPart returns logical(input sPart as character):
        define variable bCanAccessPart as logical no-undo.
        {gprun.i
            ""xxcanaccesspart.p""
            "(
                input sPart,
                output bCanAccessPart
            )"
        }
        return bCanAccessPart.
    end function.
    &global-define canAccessPart ""
&endif


&if defined(canAccessBom) = 0 &then
    function canAccessBom returns logical(input sBom as character):
        define variable bCanAccessBom as logical no-undo.
        {gprun.i
            ""xxcanaccessbom.p""
            "(
                input sBom,
                output bCanAccessBom
            )"
        }
        return bCanAccessBom.
    end function.
    &global-define canAccessBom ""
&endif


