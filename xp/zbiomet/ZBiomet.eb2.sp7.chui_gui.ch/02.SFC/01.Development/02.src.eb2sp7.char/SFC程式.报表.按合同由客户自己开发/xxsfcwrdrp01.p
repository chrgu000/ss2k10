


      define shared variable v_wolot like xwo_lot.
      define shared variable v_op like xwr_op  .

      define variable nbr like xwo_nbr format "x(10)" label "����".
      define variable lot like xwo_lot label "��־".
      define variable op like xwr_op label "OP".

      FORM /*GUI*/ 
         nbr      at 1
         lot      at 18
         op       at 33
      with frame a row 1 centered overlay side-labels width 80.
      
      lot = v_wolot.
      op = v_op. 
      find first xwo_mstr where xwo_lot = lot no-lock no-error.
      nbr = (if available xwo_mstr then xwo_nbr else "").

      repeat:
         update        
            nbr
            lot
            op
	 with frame a .

         clear frame a all no-pause.

         display
            nbr
            lot
            op
	 with frame a.


         loopa:
         for each xxwrd_det no-lock
	    where (nbr = "" or xxwrd_wonbr = nbr)
	      and (lot = "" or xxwrd_wolot = lot)
	      and (op = 0 or xxwrd_op = op)
              and xxwrd_status <> "D"
	 break by xxwrd_wonbr by xxwrd_wolot desc by xxwrd_op
	 on endkey undo, leave loopa 
	 with frame b 12 down width 80:

	    display
               xxwrd_wolot      format "x(7)" label "��־"
               xxwrd_part       format "x(16)"
               xxwrd_op         format ">9" label "OP"
               xxwrd_qty_ord    format "->>>>>9" 
               xxwrd_qty_comp   format "->>>>>9"
               xxwrd_qty_rejct  format "->>>>9"
               xxwrd_qty_rework format "->>>>9" column-label "����!��ʼ��"
               xxwrd_qty_return format "->>>>9" column-label "����!�����"
	       string(xxwrd_time_setup,"HH:MM") format "x(5)" column-label "׼��!ʱ��"
	       string(xxwrd_time_run,"HH:MM") format "x(5)" column-label "����!ʱ��"
	    with down frame b.

	    if frame-line(b) = frame-down(b) then pause.

         end.

      end.

      hide frame a.
         