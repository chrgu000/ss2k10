/*Cai last modified by 05/20/2004*/
DelBlock:

do on endkey undo, leave
   on error undo, leave:

  find xkgpd_det where recid(xkgpd_det) = w-rid[Frame-line(f-errs)] no-error.

  if not available xkgpd_det then
    leave DelBlock .


        yn = YES .

        MESSAGE "确认删除这条记录吗？" 
            UPDATE yn .
        IF yn THEN DO :
            DELETE xkgpd_det .
          /*  NEXT .*/
        END.


end .
