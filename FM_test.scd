(
SynthDef(\bass, { |out, freq = 440, gate = 1, amp = 0.5, slideTime = 0.17, ffreq = 1100, width = 0.15,
        detune = 1.005, preamp = 4|
    var    sig,
        env = Env.adsr(0.01, 0.3, 0.4, 0.1);
    freq = Lag.kr(freq, slideTime);
    sig = Mix(VarSaw.ar([freq, freq * detune], 0, width, preamp)).distort * amp
        * EnvGen.kr(env, gate, doneAction: Done.freeSelf);
    sig = LPF.ar(sig, ffreq);
    Out.ar(out, sig ! 2)
}).add;
)
Synth(\bass)
q=Pxrand([2,7,23],inf).asStream



(
TempoClock.default.tempo = 132/60;
p = Pxrand([
    Pbind(            // repeated notes
        \instrument, \bass,
        \midinote, [36,24,12,12],
        \dur, Pseq([0.75, 0.25, 0.25, 0.25, 0.5], 1),
        \legato, Pseq([0.9, 0.3, 0.3, 0.3, 0.3], 1),
        \amp, 0.5, \detune, 1.005
    ),
    Pmono(\bass,        // octave jump
        \midinote, Pseq([36, 48, 36], 1),
        \dur, Pseq([0.25, 0.25, 0.5], 1),
        \amp, 0.5, \detune, 1.005
    ),
    Pmono(\bass,        // tritone jump
        \midinote, Pseq([36, 42, 41, 33], 1),
        \dur, Pseq([0.25, 0.25, 0.25, 0.75], 1),
        \amp, 0.5, \detune, 1.005
    ),
    Pmono(\bass,        // diminished triad
        \midinote, Pseq([36, 39, 36, 42], 1),
        \dur, Pseq([0.25, 0.5, 0.25, 0.5], 1),
        \amp, 0.5, \detune, 1.005
    )
], inf).play(quant: 1);
)

(

SynthDef(\perc,{
	var sig, env;
	env = Env.perc(releaseTime: \release.kr(0.4));
	sig = PinkNoise.ar()*EnvGen.kr(env, doneAction: 2);
	Out.ar(0,sig!2);
}).add;

)
Synth(\perc)

(
SynthDef(\play,{|freq=440|
	var sig, env;
	env =  Env(times: [0.02,\rel.kr(0.3)]);
	sig = SinOsc.ar(freq,mul: 0.5).distort*EnvGen.kr(env,doneAction: 2);
	sig = Clip.ar(sig,hi: 1);
	Out.ar(0,sig)

}).add;
)
Synth(\play);
(
p=Pbind(
	\instrument, \play,
	\dur, Pseq([1,1,1],inf),
	\degree, Pxrand([0,1,2,3,4,5,6],inf),


).play(quant:4);


q=Pbind(
	\instrument, \play,
	\dur, Pseq([4,4,4],inf),
	\degree, Prand([[0,2,4],[2,4,6],[3,5,7]],inf),
	\rel, 2,

).play(quant:4);

(
b = Pbind(
	\instrument, \perc,
	\dur, Pseq([1,1,1,1/2],inf),
	\release, Pseq([0.5,0.2,1],inf)
).play(quant:4)
)

)



q.stop;
p.stop;
q.resume;
p.resume

(
{
    Decay2.ar(
		Impulse.ar(8, 0,SinOsc.kr(0.2)),
        0.001,
        0.3
    )
    * Mix.ar(Pulse.ar([80, 81], 0.3))
}.play;
)



{Impulse.ar(100, 0, LFSaw.kr(0.3, 1, -0.3, 0.3))}.plot(1)
{LFSaw.kr(100, 1, -0.3, 0.3)}.plot(1);
{Pulse.ar([80,81])}.plot;
{Mix.ar(Pulse.ar([80, 81], 0.3))}.plot(5)



///FM synthesis


(


SynthDef(\fm,{
	var sig, mod, env;
	env = Env(levels: [0,1,0],times: [\atk.ir(0.01),\rel.ir(1)],curve: [1,-2]).ar(2);
	//mod = SinOsc.ar(MouseX.kr(1,2000,1).poll,mul: MouseY.kr(1,1000,1).poll);
	//mod = SinOsc.ar(\freq.kr(400)*\ratio.kr(1),mul: 900);
	mod = SinOsc.ar(\midinote.kr([60,67]).midicps*\ratio.kr(5),mul: \modamp.kr(100));
	sig = SinOsc.ar(\freq.kr(400)+mod);
	sig =Pan2.ar(sig, \pan.kr(0), \amp.kr(0.2).clip(0,0.5));
	sig =sig*env*0.8;
	Out.ar(\out.ir(0),sig);

}).add;
)
(
SynthDef(\fmmel,{
	var sig, mod, env;
	env = Env(levels: [0,1,0],times: [\atk.ir(0.01),\rel.ir(0.2)],curve: [1,-1]).ar(2);
	mod = SinOsc.ar(\midinote.kr(48).midicps*\ratio.kr(8),mul: \modamp.kr(400));

	//mod = SinOsc.ar(\freq.kr(400)*\ratio.kr(4),mul: \modamp.kr(700));
	sig = SinOsc.ar(\freq.kr(600)+mod);
	sig =Pan2.ar(sig, \pan.kr(0), \amp.kr(0.2));
	sig =sig*env*0.1;
	Out.ar(\out.ir(0),sig);

}).add

)

(
SynthDef(\play2,{
	var sig, mod, env;
	env = Env(levels: [0,1,0],times: [\atk.ir(0.001),\rel.ir(0.5)],curve: [1,-1]).ar(3);
	//mod = SinOsc.ar(\midinote.kr(62).midicps*\ratio.kr(1),mul: \modamp.kr(100));

	//mod = SinOsc.ar(\freq.kr(400)*\ratio.kr(4),mul: \modamp.kr(700));
	sig = LFPulse.ar(\midinote.kr(36).midicps,width: 0.25);
	sig =Pan2.ar(sig, \pan.kr(0), \amp.kr(0.2));
	sig =sig*env*0.3;
	Out.ar(\out.ir(0),sig);

}).add

)



(
Synth(\fm,[
	\freq, 355
])
)


(
p =Routine({
	loop{
		//Synth(\fm,[\freq, 400*(-24).midiratio,\ratio,6,\amp,0.05]);
		Synth(\fm);
		1.wait;
		}
}).play(quant:1)

);
p.stop;
(

x = Routine({
	arg c=1.0;
	loop({
		SinOsc.ar(440);
		c.wait;

	})
}).play

)
x.play()

(
q =Routine({
	loop{
		//Synth(\fmmel,[\freq, 240*(6.midiratio),\ratio,6]);
		Synth(\fmmel,[
			\midinote, [48,60,36].choose,
			\rel, 1,
		]);
		0.2.wait;
		}
}).play(quant:1)

)
q.stop

(
r =Routine({
	loop{
		//Synth(\fmmel,[\freq, 240*(6.midiratio),\ratio,6]);
		Synth(\play2);
		0.1.wait;
		}
}).play(quant:4)

)
r.stop


//////

s.scope
{SinOsc.ar(400+SinOsc.ar(\modfreq.kr(1)).range(-100,100))}.plot(5)
6.dbamp
0.midiratio
60.midicps


rrand(24,28)


o =Pseq([60,62,65,67],8).asStream

o.next









