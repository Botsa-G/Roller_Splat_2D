require"collision"
 require"block"

player ={
 x= 0,
 y = 0,
 radius = 16 ,
 swipeToRight = false,
 swipeToLeft = false,
 swipeUp = false,
 swipeDown = false,
 r = 0.75, g = 0.75, b = 0.75 

}

function player:new(tab)
tab= tab or {}
setmetatable(tab,self)
self.__index= self
return tab
end

function player:SwipeRight(blockTab)
for i =1,#blockTab do if self.y == blockTab[i].y and  blockTab[i].identity == "barrier"
  and self.x<= (blockTab[i].x-blockTab[i].width) then return (blockTab[i].x-blockTab[i].width) end end
end

function player:SwipeLeft(blockTab)
  for i = #blockTab,1,-1 do if self.y == blockTab[i].y and  blockTab[i].identity == "barrier" and  blockTab[i].position == "interior"
    and self.x>= (blockTab[i].x+blockTab[i].width) then return (blockTab[i].x+blockTab[i].width) end end
  end

   function player:SwipeUp(blockTab)
      for i = #blockTab,1,-1 do if self.x == blockTab[i].x and  blockTab[i].identity == "barrier" and  blockTab[i].position == "interior"
      and self.y>= (blockTab[i].y+blockTab[i].height) then return (blockTab[i].y+blockTab[i].height) end end
    end

    function player:SwipeDown(blockTab)
      for i =1,#blockTab do if self.x == blockTab[i].x and  blockTab[i].identity == "barrier"
        and self.y<= (blockTab[i].y-blockTab[i].height) then return (blockTab[i].y-blockTab[i].height) end end
          
      end
  


function player:draw()
   
  love.graphics.setColor(self.r,self.g,self.b)
  love.graphics.circle("fill",self.x,self.y,self.radius)
love.graphics.setColor(1,1,1)

end

