function collide (x1,y1,w1,h1,x2,y2,w2,h2)
 return x1< x2 + w2 and
      x1+ w1 > x2 and
      y1< y2 + h2 and
      y1+ h1 > y2 
end

function Ccollide (x1,y1,w1,h1,x2,y2,w2,h2)
 return x1-0.5*w1< x2 + 0.5* w2 and
      x1+0.5* w1 > x2-0.5*w2 and
      y1-0.5*h1< y2 + 0.5* h2 and
      y1+0.5* h1 > y2 -0.5*h2
end


function Ycollide (x1,y1,w1,h1,x2,y2,w2,h2)
 return
      y1< y2 + h2 and
      y1+ h1 > y2 
end

function tcollide (x1,y1,w1,h1,x2,y2,w2,h2)
 return
      --y1< y2 + h2 and
	   x1< x2 + w2 and
      x1+ w1 > x2 and
      y1+ h1 > y2 
end


function Xcollide (x1,y1,w1,h1,x2,y2,w2,h2)
 return x1< x2 + w2 and
      x1+ w1 > x2  
end

function RXcollide (x1,y1,w1,h1,x2,y2,w2,h2)
 return x1< x2 + w2 --and
      --x1+ w1 > x2  
end

function LXcollide (x1,y1,w1,h1,x2,y2,w2,h2)
 return --x1< x2 + w2 --and
      x1+ w1 > x2  
end

function distance(x1,y1,x2,y2)

return math.sqrt((y2-y1)*(y2-y1) + (x2-x1)* (x2-x1)) 

end

function bounce(k,actualPosition,velocity,currentPosition,dt,rest,multiplier)
local x = currentPosition - actualPosition
local f= -1 * k * x
velocity = velocity + f
return (currentPosition +velocity*multiplier*dt )
--velocity = velocity * rest
end 
---- Redo
function bounce(input)
local extention = input.currentPosition - input.actualPosition
local force= -1 * input.k * extention
input.velocity = input.velocity + input.force

return (input.currentPosition +input.velocity* input.multiplier * input.dt)
--input.velocity = input.velocity * input.rest

end

function lerp(a,b,t)
return (a + (b-a)*t) 
end