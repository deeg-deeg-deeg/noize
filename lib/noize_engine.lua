local Noize = {}
local Formatters = require 'formatters'


local specs = {
  
  ["mul"] = controlspec.new(0, 10, 'lin', 0, 1, ""),
  
  ["xsaw_vol"] = controlspec.new(0, 10, 'lin', 0, 0, ""),
  ["multiSin_vol"] = controlspec.new(0, 10, 'lin', 0, 0, ""),
  ["rbell_vol"] = controlspec.new(0, 10, 'lin', 0, 0, ""),
  
  ["pvol"] = controlspec.new(0, 10, "lin", 0, 0, ""),
  ["bvol"] = controlspec.new(0, 10, "lin", 0, 0, ""),
  ["gvol"] = controlspec.new(0, 10, "lin", 0, 0, ""),
  ["freq"] = controlspec.new(0, 20000, "lin", 0, 20, "Hz"),
  
  ["xfreq"] = controlspec.new(0, 20000, "lin", 0, 20, "Hz"),
  ["multiSin_freq"] = controlspec.new(0, 20000, "lin", 0, 20, "Hz"),
  ["rbell_freqA"] = controlspec.new(0, 20000, "lin", 0, 200, "Hz"),
  ["rbell_freqB"] = controlspec.new(0, 20000, "lin", 0, 2000, "Hz"),
  
  ["delta"] = controlspec.new(-10, 10, 'lin', 0, 1, ""),
  ["feedback"] = controlspec.new(0, 10, "lin", 0, 1, ""),
  ["cutoff"] = controlspec.new(1, 20000, "lin", 0, 20000, "Hz"),
  ["q"] = controlspec.new(0, 1, 'lin', 0, 1, ""),
  ["resofreq"] = controlspec.new(1, 20000, "lin", 0, 20000, "Hz"),
  ["q2"] = controlspec.new(0.1, 5, 'lin', 0, 1, ""),
  ["bpfreq"] = controlspec.new(1, 20000, "lin", 0, 400, "Hz"),
  ["bpwidth"] = controlspec.new(0, 30, 'lin', 0, 1, ""),  
  ["level"] = controlspec.new(0, 10, 'lin', 0, 1, "")
  
}


local mnames = {
  
  ["mul"] = "Sine",
  
  ["xsaw_vol"] = "XSaw",
  ["multiSin_vol"] = "Multiple Sines",
  ["rbell_vol"] = "Bell Sine",
    
  ["pvol"] = "Pink Noise",
  ["bvol"] = "Brown Noise",
  ["gvol"] = "Gray Noise",
  ["freq"] = "Sine Frequency",
  
  ["xfreq"] = "XSaw Frequency",
  ["multiSin_freq"] = "Multiple Sine Freq",
  ["rbell_freqA"] = "Bell Freq A",
  ["rbell_freqB"] = "Bell Freq B",
  
  ["delta"] = "Sine Delta",
  ["feedback"] = "Feedback",
  ["cutoff"] = "F01 Cutoff",
  ["q"] = "F01_Q",
  ["resofreq"] = "F02 Cutoff",
  ["q2"] = "F02_Q",
  ["bpfreq"] = "F03 Cutoff",
  ["bpwidth"] = "F03 Width",
  ["level"] = "Limiter Level"
  
}
-- this table establishes an order for parameter initialization:
local param_names = {"mul","xsaw_vol","multiSin_vol","rbell_vol","pvol","bvol","gvol","freq","xfreq","multiSin_freq","rbell_freqA","rbell_freqB", "delta","feedback","cutoff","q","resofreq","q2","bpfreq","bpwidth","level"}

-- initialize parameters:
function Noize.add_params()
  params:add_separator("Noize")

  for i = 1,7 do
    local p_name = param_names[i]
    local x_name = mnames[i]
    params:add{
      type = "control",
      id = p_name,
      name = mnames[p_name],
      controlspec = specs[p_name],
      formatter = p_name == "pan" and Formatters.bipolar_as_pan_widget or nil,
      -- every time a parameter changes, we'll send it to the SuperCollider engine:
      action = function(x) engine[p_name](x) end
    }
  end
  
  params:add_separator("Frequency Settings")
  
  for i = 8, 14 do
    local p_name = param_names[i]
    local x_name = mnames[i]
    params:add{
      type = "control",
      id = p_name,
      name = mnames[p_name],
      controlspec = specs[p_name],
      formatter = p_name == "pan" and Formatters.bipolar_as_pan_widget or nil,
      -- every time a parameter changes, we'll send it to the SuperCollider engine:
      action = function(x) engine[p_name](x) end
    }
  end  
  
  params:add_separator("Filters")
  
   for i = 15, #param_names do
    local p_name = param_names[i]
    local x_name = mnames[i]
    params:add{
      type = "control",
      id = p_name,
      name = mnames[p_name],
      controlspec = specs[p_name],
      formatter = p_name == "pan" and Formatters.bipolar_as_pan_widget or nil,
      -- every time a parameter changes, we'll send it to the SuperCollider engine:
      action = function(x) engine[p_name](x) end
    }
   end  

  params:add_separator("Random Freq Settings")
  
  params:add_control("rnd_speed", "rnd speed", controlspec.new(1, 10000, "lin", 0, 1, ""))
  params:add_control("possy", "possibility", controlspec.new(1, 100, "lin", 0, 10, ""))
  params:add_control("poss_lim", "limit", controlspec.new(1, 10000, "lin", 0, 400, ""))
  params:add_control("lowBord", "lowBord", controlspec.new(1, 12000, "lin", 0, 400, ""))
  params:add_control("highBord", "highBord", controlspec.new(0, 20000, "lin", 0, 2000, ""))
  params:add_control("bells_delta", "bells_delta", controlspec.new(0, 10000, "lin", 0.1, 100, ""))
  
  params:add_separator("Random Filter Settings")
  
  params:add_control("filter_min", "filter_min", controlspec.new(0, 20000, "lin", 0, 0, ""))
  params:add_control("filter_max", "filter_max", controlspec.new(0, 20000, "lin", 01, 20000, ""))
  
  params:add_option("rnd_freq","RND Freq",{"on", "off"},2)
  params:add_option("rnd_fil_freq","RND Filter Freq",{"on", "off"},2)
  params:add_option("midi_onoff","Midi Note_on",{"on", "off"},2)
  
  
  params:bang()
end

-- a single-purpose triggering command fire a note
function Noize.trig(hz)
  if hz ~= nil then
    engine.freq(hz)
  end
end

 -- we return these engine-specific Lua functions back to the host script:
return Noize