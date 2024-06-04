-- main.lua

function love.load()
    -- Original points
    points = {
        {x = 100, y = 300},
        {x = 200, y = 100},
        {x = 300, y = 400},
        {x = 500, y = 500},
        {x = 600, y = 200}
    }
    
    segments = 10  -- Number of segments between each pair of points
    smoothedPoints = smoothLine(points, segments)
end

-- Catmull-Rom Spline Interpolation
function catmullRom(p0, p1, p2, p3, t)
    local t2 = t * t
    local t3 = t2 * t
    
    local a = -0.5 * t3 + t2 - 0.5 * t
    local b =  1.5 * t3 - 2.5 * t2 + 1.0
    local c = -1.5 * t3 + 2.0 * t2 + 0.5 * t
    local d =  0.5 * t3 - 0.5 * t2
    
    local x = a * p0.x + b * p1.x + c * p2.x + d * p3.x
    local y = a * p0.y + b * p1.y + c * p2.y + d * p3.y
    
    return {x = x, y = y}
end

-- Function to generate smoothed points
function smoothLine(points, segments)
    local smoothedPoints = {}
    
    for i = 2, #points - 2 do
        for t = 0, 1, 1 / segments do
            local p = catmullRom(points[i-1], points[i], points[i+1], points[i+2], t)
            table.insert(smoothedPoints, p)
        end
    end
    
    return smoothedPoints
end

function love.draw()
    -- Draw original points
    love.graphics.setColor(1, 0, 0)
    for _, p in ipairs(points) do
        love.graphics.circle("fill", p.x, p.y, 5)
    end
    
    -- Draw smoothed line
    love.graphics.setColor(0, 0, 1)
    for i = 1, #smoothedPoints - 1 do
        local p1 = smoothedPoints[i]
        local p2 = smoothedPoints[i + 1]
        love.graphics.line(p1.x, p1.y, p2.x, p2.y)
    end
end
