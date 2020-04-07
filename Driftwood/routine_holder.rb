module RoutineHolder
	def update1		
		@sy=1 if @sy==0
		@sy=1 if @y<=300
		@sy=-1 if @y>=400
		@y+=@sy					
	end;
end;