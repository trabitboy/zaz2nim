--load ../testrec.wav and play it


love.audio.newSource("testrec.wav",'static'):play()

love.draw = function()
    love.graphics.print("test play", 10, 10)
end