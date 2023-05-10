s.meter;
s.plotTree;
s.scope;
FreqScope.new;

(
SynthDef(\fmMod,{
	arg freq=440, amp=1, mfreq=1;
	var sig;
	sig = SinOsc.ar(mfreq,mul:amp);
	sig = SinOsc.ar(freq+sig*0.2!2);
	Out.ar(0, sig);
}).add
)

x= Synth(\fmMod);
x.set(\freq,500);
x.set(\mfreq,8);
x.set(\amp,400);


{SinOsc.ar().fold(0.5,0.7)}.play
{LFPulse.ar(2,0,0.01)}.plot(1)