background =
{
x=0,
y=0,
scaleX = 0.4,
scaleY =0.4,
rotation =0,
image = love.graphics.newImage("BG"..love.math.random(1,3)..".png")
}

function background:new(tab)
    tab= tab or {}
    setmetatable(tab,self)
    self.__index= self
    return tab
    end

function background:draw()
    love.graphics.setColor(1,1,1,1)
    love.graphics.draw(self.image,self.x,self.y,self.rotation,self.scaleX,self.scaleY)
    love.graphics.setColor(1,1,1,1)
    -- to set to center add in draw -- self.image:getWidth()*0.5,self.image:getHeight()*0.5
end