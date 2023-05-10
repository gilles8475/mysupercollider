//un gros son type pulsation

(
SynthDef(\bigpulse,{
	var env, sig, mod;
	mod = SinOsc.ar(\mod.kr(10),add: \add.kr(10));
	env = Env.new([0,0.8,0.5,1,0],[0.5,0.5,0.02,0.06],[-2,-2,-2,-2]).kr(2);
	sig = LFPulse.ar(\freq.kr(40)+mod)*env;
	sig = HPF.ar(sig,640);
	Out.ar(0,sig!2)

}).add;
)


(
SynthDef(\tam,{
	var env, sig;
	env = Env.perc(attackTime: \atk.kr(0.01), releaseTime: \release.kr(0.2)).kr(2);
	sig = Saw.ar(\freq.kr(440),0.5);
	sig = sig*env;
	sig = sig + Delay1.kr(sig,\delay.kr(100));
	Out.ar(0,sig!2)
}).add
)