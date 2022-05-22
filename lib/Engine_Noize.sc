/*
2022, deeg / @deeg_deeg_deeg
*/

Engine_Noize : CroneEngine {

	var <synths;


	*new { arg context, doneCallback;

		^super.new(context, doneCallback);
	}

	alloc {

		synths = {

			arg out = 0,
	    freq, cutoff, feedback, q, limLvl, delta, q2, cutoff2, mul,pvol, bvol, gvol, xsaw_vol, xfreq, multiSin_vol, multiSin_freq, rbell_vol, rbell_freqA, rbell_freqB, bpfreq=400, bpwidth=1;

    
    

    var sine1 = SinOscFB.ar(freq,feedback,mul,0);
  	var sine2 = SinOscFB.ar(freq*delta,feedback,mul,0);
  	var pnoise = PinkNoise.ar(pvol,0);
  	var bnoise = BrownNoise.ar(bvol,0);
  	var gnoise = GrayNoise.ar(gvol,0);
  	
  	var xsaw = LFSaw.ar(xfreq, 0.5, xsaw_vol,0);
  	var multiSin = ({SinOsc.ar(multiSin_freq, 0, multiSin_vol, 0)} ! 15).sum;
  	var rbell = Mix.fill(10, {SinOsc.ar(rrand(rbell_freqA,rbell_freqB), 0, rbell_vol,0)});
  
              	

	  var mix = Mix.ar([sine1,sine2,pnoise,bnoise,gnoise,xsaw,multiSin,rbell]); 

	  var filter = BLowPass4.ar(in: mix, freq: cutoff, rq: q);
	  
	  var filter2 = Resonz.ar(in: filter, freq: cutoff2, bwr: q2, mul: 1.0, add: 0.0);
	  
	  var filter3 = Limiter.ar(BBandPass.ar(in: filter2, freq: bpfreq, bw: bpwidth, mul: 1, add:0), limLvl, 0.01);
	  
	  var signal = Pan2.ar(filter3,0);

    Out.ar(out, signal);
		

		}.play(args: [\out, context.out_b], target: context.xg);



		
   this.addCommand("freq", "f", { arg msg;
			synths.set(\freq, msg[1]);
		});
		
	  this.addCommand("cutoff", "f", { arg msg;
			synths.set(\cutoff, msg[1]);
		});

   this.addCommand("feedback", "f", { arg msg;
			synths.set(\feedback, msg[1]);
		});

   this.addCommand("q", "f", { arg msg;
			synths.set(\q, msg[1]);
		});
		
	 this.addCommand("level", "f", { arg msg;
			synths.set(\limLvl, msg[1]);
		});
		
		this.addCommand("delta", "f", { arg msg;
			synths.set(\delta, msg[1]);
		});
		
		this.addCommand("mul", "f", { arg msg;
			synths.set(\mul, msg[1]);
		});
		
		this.addCommand("q2", "f", { arg msg;
			synths.set(\q2, msg[1]);
		});
		
		this.addCommand("resofreq", "f", { arg msg;
			synths.set(\cutoff2, msg[1]);
		});
		
		this.addCommand("pvol", "f", { arg msg;
			synths.set(\pvol, msg[1]);
		});

		this.addCommand("bvol", "f", { arg msg;
			synths.set(\bvol, msg[1]);
		});		
		
		this.addCommand("gvol", "f", { arg msg;
			synths.set(\gvol, msg[1]);
		});
	
		this.addCommand("multiSin_freq", "f", { arg msg;
			synths.set(\multiSin_freq, msg[1]);
		});

		this.addCommand("multiSin_vol", "f", { arg msg;
			synths.set(\multiSin_vol, msg[1]);
		});

		this.addCommand("rbell_vol", "f", { arg msg;
			synths.set(\rbell_vol, msg[1]);
		});
		
		this.addCommand("xfreq", "f", { arg msg;
			synths.set(\xfreq, msg[1]);
		});
		
		this.addCommand("xsaw_vol", "f", { arg msg;
			synths.set(\xsaw_vol, msg[1]);
		});

		this.addCommand("rbell_freqA", "f", { arg msg;
			synths.set(\rbell_freqA, msg[1]);
		});	
		
		this.addCommand("rbell_freqB", "f", { arg msg;
			synths.set(\rbell_freqB, msg[1]);
		});			
		
		this.addCommand("bpfreq", "f", { arg msg;
			synths.set(\bpfreq, msg[1]);
		});	
		
		this.addCommand("bpwidth", "f", { arg msg;
			synths.set(\bpwidth, msg[1]);
		});	

	}
	
	// define a function that is called when the synth is shut down
	free {
		synths.free;
	}
}

