-- NOIZE! v1.0
-- Noise Synth
-- by deeg
--
-- @deeg_deeg_deeg
--
-- https://github.com/deeg-deeg-deeg
--
-- be aware!: may produce very
-- loud noises!!!
--
-- ENC 2: choose parameter
-- ENC 3: change selected 
--        parameter
-- ENC 1: change the amount 
--        parameters will be
--        changed
--
-- KEY 2&3: select which synth
--          will receive incoming
--          midi notes
--
--
--
--

engine.name = 'Noize' 

Noize = include('noize/lib/noize_engine')
m = midi.connect(2)

para_names = {"mul","xsaw_vol","multiSin_vol","rbell_vol","pvol","bvol","gvol","freq","xfreq","multiSin_freq","rbell_freqA","rbell_freqB", "delta","feedback","cutoff","q","resofreq","q2","bpfreq","bpwidth","level","rnd_freq","rnd_fil_freq", "midi_onoff", "rnd_speed", "possy", "poss_lim", "lowBord", "highBord", "bells_delta", "filter_min","filter_max"
}
screen_names ={"SINE","SAW", "MULTI SINE","BELL SYNTH","PINK NOISE", "BROWN NOISE", "GREY NOISE", "SINE FREQ", "SAW FREQ", "MSINE FREQ", "BELL FREQ A", "BELL FREQ B", "SINE DISTANCE", "SINE FEEDBACK", "CUTOFF F1", "Q F1", "CUTOFF F2", "Q F2", "CUTOFF F3", "Q F3", "LIMITER", "RND FREQ", "RND FILTER FREQ", "MIDI NOTE TRIGGER", "RANDOM SPEED", "POSSIBILITY", "POSSY LIMIT", "BORDER LOW", "BORDER HIGH", "BELLS DELTA", "FILTER MIN", "FILTER MAX"}

icons = {"x","▼","O","/","?","!!",";","a","Y","*","#","o","►","X","F","▲","|","<","@","m","±","[","_","+",")","=",":","{","w","º",">","f"}



deltas = {"0.01","0.1","1","10","100"}
deltaval = 3
midi_target = 0
selections = 32

whereamI = 1
x = 1
y = 1

function intro()

for i=1,150 do
  screen.clear()
  
  
  screen.font_face(1)
  screen.font_size(8)
  
  for y = 1,5 do
    for x = 1,18 do

    ypos = y*12-1
    
    screen.level((math.random(1,4)))
    screen.move(x*8-7,ypos)
    screen.text(icons[math.random(1,selections)])
    
    --wait(0.01)
    end
  end

    screen.font_face(1)
    screen.font_size(30)
    screen.level(math.random(10,15))
    screen.move(18+math.random(-4,4),42+math.random(-4,4))
    screen.text("NOIZE!")
    screen.update()
    wait(0.01)

end
  screen.clear()
  screen.update()
  

  wait(0.5)


end


function init()

  Noize.add_params()
  speed = 1000

  randomFreq = false
  rndFilter = false
  omute = false
  
  intro()
  
  sequence = clock.run(
    function()
      while true do
        speed = params:get("rnd_speed")
        possy = params:get("possy")
        poslimit = params:get("poss_lim")
        
        lowBord = params:get("lowBord")
        highBord = params:get("highBord")
        bells_delta = params:get("bells_delta")
        
        filmin = params:get("filter_min")
        filmax = params:get("filter_max")
        
        checkxVol1 = params:get("xfreq")
        checkxVol2 = params:get("xfreq")

        if params:get("rnd_freq") == 1 then randomFreq = true
          else
          randomFreq = false
        end
        if params:get("rnd_fil_freq") == 1 then rndFilter = true 
          else
          rndFilter = false
        end        
        
        
        clock.sync(1/speed)
        
        if randomFreq then
             decider=math.random(0,math.floor(poslimit))
            if decider <=math.floor(possy) then
                
                if highBord <= lowBord then highBord=lowBord+10 end
                lowVal=math.random(0,math.floor(lowBord))
                highVal=math.random(math.floor(lowBord),math.floor(highBord))
                
                synced_rnd = math.random(lowVal,highVal)
                
                engine.freq(math.random(lowVal,highVal))
                engine.xfreq(math.random(lowVal,highVal))
                engine.multiSin_freq(math.random(lowVal,highVal))
                
                engine.rbell_freqA(synced_rnd)
                engine.rbell_freqA(synced_rnd+bells_delta)
        
            end

        end
        
        if rndFilter then
          
          if filmax <= filmin then filmax=filmin+1 end
          engine.cutoff(math.random(math.floor(filmin),math.floor(filmax)))
          
        end

      end
    end
  )
  
  

end
  
function enc(n,d)
  
  if n == 1 then
  -- set delta  
  
    deltaval = util.clamp(deltaval + d, 1, 5)
    
  
  elseif n == 2 then
  
  -- select option
    whereamI = util.clamp(whereamI + d, 1, selections)
    
  
  elseif n == 3 then
  
  -- change current value
    change = params:get(para_names[whereamI]) + d*deltas[deltaval]
    params:set(para_names[whereamI], change)
    
    if whereamI == 22 then
      checko = params:get(para_names[whereamI])
      
      if checko == 1 then
        randomFreq = true
        else
        randomFreq = false
      end
    end
    
        
    if whereamI == 22 then
      checko = params:get(para_names[whereamI])
      
      if checko == 1 then
        rndFilter = true
        else
        rndFilter = false
      end
        
    
    end
    
    
    
    
  end
  redraw()
end

function key(n,z)
  if n == 3 and z == 1 then
  -- select wave +1
      midi_target = util.clamp(midi_target + 1, 0, 5)
    redraw()
  end
  
  if n == 2 and z == 1 then
      midi_target = util.clamp(midi_target - 1, 0, 5)
  
    redraw()
  end
  
end

m.event = function(data) -- event routine taken from ericmoderbacher, listening to incoming midi
 
  mess = midi.to_msg(data)
  midi_onoff = params:get("midi_onoff")
  
  if mess.type == "note_on" then
    hz = midi_to_hz(mess.note)
    print (hz)
      for i=1,5 do
        
        if i == midi_target and midi_target ~= 5 then
          params:set(para_names[i+7],hz)
          if midi_onoff == 1 then
            params:set(para_names[i],0.5)
          end
        elseif i == midi_target and midi_target == 5 then
          for i=1,4 do
            params:set(para_names[i+7],hz)
            if midi_onoff == 1 then
              params:set(para_names[i],0.5)
            end
            
          end
        end
      end
      redraw();
  end
  
  if mess.type == "note_off" and midi_onoff == 1 then
    
     for i=1,5 do
        
        if i == midi_target and midi_target ~= 5 then
          params:set(para_names[i],0)
      
        elseif i == midi_target and midi_target == 5 then
          for i=1,4 do
            params:set(para_names[i],0)
          end
        end
     end
  end
  
  
end

function midi_to_hz(note)
  local hz = (440 / 32) * (2 ^ ((note - 9) / 12))
  return hz
end

function wait(seconds)
    local start = os.clock()
    repeat until os.clock() > start + seconds
end


function redraw()
  screen.clear()
  
  screen.font_face(1)
  screen.font_size(8)
  
  local i = 1
  
  for y=1,5 do
    for x=1,7 do
    
    
      ypos = y*12-1
      
      screen.level((i == whereamI) and 15 or (math.random(1,3)))
      screen.move(x*8-7,ypos)
      screen.text(icons[i])
    
  
  
      
      if i == whereamI then
        screen.move(x*8-7, ypos+4)
        screen.line_rel(4,0)
        screen.stroke()
      end
      
      if i == midi_target and i ~= 5 then
        screen.move(x*8-7, ypos-5)
        screen.text("*")
      elseif i == 5 and i == midi_target then
        screen.move(1, 6)
        screen.text("* * * * *")
      end
      i = i+1
      if i == 33 then break end
    
     end
  end 
  
  screen.level(12)
  screen.move(70,20)
  screen.font_size(18)
  
  if whereamI == 22 then
    was = params:get(para_names[whereamI])
    if was == 1 then textwrite = "ON"
      print("on")
    elseif was == 2 then textwrite = "OFF" 
      end
    screen.text(textwrite)
    
  elseif whereamI == 23 then
    
    was = params:get(para_names[whereamI])
    if was == 1 then textwrite = "ON"
      print("on")
    elseif was == 2 then textwrite = "OFF" 
      end
    screen.text(textwrite)
    
  elseif whereamI == 24 then
    
    was = params:get(para_names[whereamI])
    if was == 1 then textwrite = "ON"
      print("on")
    elseif was == 2 then textwrite = "OFF" 
      end
    screen.text(textwrite)
    
  
  else
    
    screen.text(params:get(para_names[whereamI]))
    
  end
  
  
  screen.font_size(8)
  screen.level(5)
  screen.move(70,40)
  screen.text(screen_names[whereamI])
  
  screen.level(1)
  screen.move(70,60)
  screen.text("delta: "..deltas[deltaval])
  
--  screen.level(1)
--  for i=1,8 do
--  screen.move(60,8*i)
--  screen.text("o")
--  end
  

  screen.update()
end
