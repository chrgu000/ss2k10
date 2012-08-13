

	{mfdtitle.i "a"}

	
	def var gnbr like sod_nbr.
	
	def var gmfgtotamt as decimal.
	def var gmfgtaxamt as decimal.
	def var gmfgnetamt as decimal.
	
	gnbr = "3".
	
        {gprun.i ""zzgtsola.p"" 
                 "(
                   input gnbr,
                   output gmfgtotamt,output  gmfgtaxamt,output  gmfgnetamt
                  )"}

	disp gnbr gmfgtotamt  gmfgtaxamt  gmfgnetamt.
	
	