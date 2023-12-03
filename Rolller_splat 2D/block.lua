block ={
    x= 0,
    y = 0,
    width = 34,
    height = 34,
    rotation = 0,
    colorNumber = 1,
    identity = "pathway", -- Can also be "barrier"
    position = "interior",
    r = 0.2, g = 1, b = 1
   
   }
   
   function block:new(tab)
   tab= tab or {}
   setmetatable(tab,self)
   self.__index= self
   return tab
   end
   
   
   
   function block:draw()
       love.graphics.push()
       love.graphics.translate(self.x,self.y)
     love.graphics.setColor(self.r,self.g,self.b)
     love.graphics.rectangle("fill",-self.width*0.5,-self.height*0.5,self.width,self.height)
   love.graphics.setColor(1,1,1)
   love.graphics.pop()
   end
   
   