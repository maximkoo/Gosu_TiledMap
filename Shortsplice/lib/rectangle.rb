class Rectangle
	attr_accessor :x,:y,:w,:h
#	def initialize(x,y,w,h)
#		@x,@y=x,y
#		@w,@h=w,h
#	end;
	
	def x1
		@x;
	end;
	
	def x2
		@x+@w-1;
	end;
	
	def y1
		@y
	end;
	
	def y2
		@y+@h-1
	end;
end;
