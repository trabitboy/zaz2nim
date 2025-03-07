require('wav')

samplerate = 44100
bitdepth = 16
channels = 1
samplecount = 44100*60


function startRecord()
    devices = love.audio.getRecordingDevices( )
    print( "zzn Recording devices:"..#devices )
    --arbitrary, hope it works
    soundRecorder =devices[1] 

    success = soundRecorder:start( samplecount, samplerate, bitdepth, channels )

    print( "zzn RecordingDevice:start() returned: ", success )

end

function stopRecord()
    local rData = soundRecorder:getData()
    print('zzn rData',rData)
    print( "zzn RecordingDevice:getData() returned: ", rData:getSize() )
    soundRecorder:stop()
    soundRecorder=nil --used for mode detection

    -- mode='play'

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
    local loveSaveDirectory =love.filesystem.getSaveDirectory()

    local w = wav.create_context(loveSaveDirectory..'/'.."testrec.wav", "w")
    w.init(channels, samplerate, bitdepth)
    w.write_samples_interlaced(samples)
    w.finish()
    setHoverMsg('saved in '..loveSaveDirectory)
    love.system.setClipboardText(loveSaveDirectory)

    --dbg test
    -- feedback = love.audio.newSource(rdata,'static')
    -- feedback:play()
end