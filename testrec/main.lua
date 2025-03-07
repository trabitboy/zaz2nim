--test sound recording to wav using love2d
--recording works on thinkpad linux
--reloading and playing works

require('wav')


devices = love.audio.getRecordingDevices( )
print( "Recording devices:"..#devices )
-- for i,device in ipairs(devices) do
--     print( i, device.getName() )
-- end

samplerate = 44100
bitdepth = 16
channels = 1
samplecount = 44100*60


soundRecorder =devices[1] 

success = soundRecorder:start( samplecount, samplerate, bitdepth, channels )

print( "RecordingDevice:start() returned: ", success )

mode='record'

-- local soundData = love.sound.newSoundData( samplecount, samplerate, bitdepth, channels)


-- function love.load()
--     -- soundRecorder:start()
-- end

function love.update(dt)
--     if samples then
--         soundData:append(samples)
--     end
end

--recording in ram stored there
--samples={}

function love.keypressed(key)
    if key == "space" then
        if mode=='record' then
            local rData = soundRecorder:getData()
            print('rData',rData)
            print( "RecordingDevice:getData() returned: ", rData:getSize() )
            soundRecorder:stop()
            mode='play'

            love.audio.newSource(rData):play()

            local samples = {}
            for i = 0, rData:getSampleCount() - 1 do
                local sample = rData:getSample(i)
                local n
                local to16bit = sample * 32767
                if (to16bit > 0) then
                    n = math.floor(math.min(to16bit, 32767))
                else
                    n = math.floor(math.max(to16bit, -32768))
                end
                table.insert(samples, n)
            end

            --samples is filled
            local w = wav.create_context("testrec.wav", "w")
            w.init(channels, samplerate, bitdepth)
            w.write_samples_interlaced(samples)
            w.finish()



        end
        -- soundRecorder:stop()
        -- soundData:export("test.wav")
    end
end

function love.draw()
    if mode=='record' then
        love.graphics.print("Recording...", 10, 10)
        love.graphics.print("Press space to stop recording", 10, 20)
    end
end
