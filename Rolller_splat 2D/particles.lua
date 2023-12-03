particle ={
  x= 0,
  y = 0,
  radius = 4,
  angle = 0,
  gravity = 0,
  weight = 5,
  position = "right",
  life = 1,
  speed = 10,
  r = 0.75, g = 0.75, b = 0.75 
 
 }
 
 function particle:new(tab)
 tab= tab or {}
 setmetatable(tab,self)
 self.__index= self
 return tab
 end

 function particle:draw()
   
  love.graphics.setColor(self.r,self.g,self.b)
  love.graphics.circle("fill",self.x,self.y,self.radius)
love.graphics.setColor(1,1,1)

end


