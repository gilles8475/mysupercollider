(
~func ={
	|a="pierre",b="durand"|
	a.postln;
	b.postln;
};
)
a=~func.loop("gilles","dupont");
a.free
(
[5,6,7,8].do({
	arg a,b;
	("boulette"++ a ++ '-'++b).postln;
})
)
(
SynthDef.new(\boulette,{
	arg freq=220, phase=0,amp=0.5, hp=0;
	Out.ar(hp,SinOsc.ar(freq,phase,amp))
}).add
)
a=Synth.new(\boulette,[\freq,400,\phase,2*pi,\amp,0.5,\hp,0]);
b=Synth.new(\boulette,[\freq,600,\phase,pi/4,\amp,0.5,\hp,1]);
c=Synth.new(\boulette,[\freq,800,\phase,0,\amp,0.1,\hp,[0]]);

(
SynthDef.new(\buu,{
	arg out=0, freq=220, phase=0,amp=0.5, panure=0.0;
	var sig,lfo;
	sig=VarSaw.ar(freq,phase,width:1,mul:amp);
	lfo=LFNoise1.kr(5);
	sig = Pan2.ar(sig,lfo);
	Out.ar(out,sig)
}).add
)
(var test =5;test;)
q= Synth.new('buu',[\freq,200,\amp,0.02]);
q.set(\freq,440);
q.set(\phase,pi);
q.set(\amp,0.01);
q.set(\hp,0);
q.set(\panure,0.8)

{SinOsc.ar(SinOsc.kr(10,0,200,500),0)}.play
2!2

(
SynthDef.new(\muladd,{
	arg amp=0.1, freq=300, vib=1, pulse=5;
	var sig, lfo;
	//lfo=SinOsc.kr(5,0.5).exprange(freq*0.5,freq*2);//oscillation de 200 à 800
	//n.midiratio = coef multiplicateur pour avoir n demi ton au dessus ou en dessous (si n est négatif) d'une freq donnée
	lfo=SinOsc.kr(pulse,0.5).exprange(freq * (vib * -1).midiratio,freq * vib.midiratio);//vib 1/2 ton(s)  de part et d'autre de freq'
	sig = SinOsc.ar(lfo,0.0,amp);
	Out.ar(0,sig!2); //sig!2 equivalent à [sig,sig;
}).add
)

a = Synth.new(\muladd);
a.set(\vib,24)
a.set(\pulse,10)
2.pow(1/12).reciprocal*2.pow(1/12)

2.pow(1/24)
0.5.midiratio;
0.5.reciprocal
0.5.midiratio