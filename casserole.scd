s.boot;
Buffer.freeAll;
// same but best
~casserole = Buffer.read(s,"sounds/casserole1.wav".resolveRelative);
~casserole.plot;
Env.adsr(0.02, 0.2, 0.25, 1, 1, -4).plot;






////////////
(
~sig = {PlayBuf.ar(2,~casserole,doneAction: 2)};
{FreeVerb.ar(~sig,mix: 1)}.play
)
{FreeVerb2.ar(PlayBuf.ar(2,~casserole,doneAction: 2),mix: 0.33,room:0.5,damp: 0)}.play

(
{Decay2.ar(
	PlayBuf.ar(2,~casserole,rate: 1,loop:1,doneAction: 2),
	attackTime: 0.001,
	decayTime: 10,
	mul: LinLin.kr(SinOsc.ar(10),-1,1,-0.08,0.08)
)
* Pulse.ar([480,481],0.3,0.3)
}.play
)

{Mix.ar(Pulse.ar([80,81],0.2,0.2))}.play;
{SinOsc.ar(MouseX.kr(20,20000,warp: 0).poll,mul: MouseY.kr(0,0.1))}.play

//////////////
(
SynthDef.new(\test,{
	var sig, env, rate;
	rate =\freq.kr(440)/440;
	env = Env.adsr(attackTime: 0.01,decayTime: 0.02,sustainLevel: 0.5, releaseTime: 2);
	env =EnvGen.kr(env,gate: \gate.kr(1),timeScale: \timescale.kr(1),doneAction: 2);
	sig = PlayBuf.ar(
		numChannels:2,
		bufnum: ~casserole, //equivalent à arg buf=0
		rate: BufRateScale.kr(\buf.kr(0))* rate,
		//rate: BufRateScale.kr(\buf.kr(0))* \midinote.kr(60),
		startPos: \spos.kr(0),
		loop: \loop.ir(0),
	);
	sig = Pan2.ar(sig, \pos.ir(0));
	sig = sig *env;
	Out.ar(0,sig);

}).add;
Synth(\test);

)


{SinOsc.ar().clip(-0.5,0.5)}.plot
{LinLin.ar(SinOsc.ar(),-2,1,-0.5,0.5)}.plot
{ Klank.ar(`[[200, 671, 1153, 1723], nil, [1, 1, 1, 1]], Impulse.ar(2, 0, 0.1)) }.play;





(

SynthDef.new(\casserole,{
	var sig, env, rate;
	rate = \freq.kr(440)/440;
	sig = PlayBuf.ar(
		numChannels:2,
		bufnum: \buf.kr(0), //equivalent à arg buf=0
		rate: BufRateScale.kr(\buf.kr(0))* rate,
		//rate: BufRateScale.kr(\buf.kr(0))* \midinote.kr(60),
		startPos: \spos.kr(0),
		loop: \loop.ir(0),
	);

	env = EnvGen.kr(
		Env(
			levels: [0,1,0],
			//times: [0.02,3],
			times:[\atk.ir(0.02), \rel.ir(3)],
			curve: [-2,-4]

		),
		doneAction: 2
	);
	sig = Pan2.ar(sig, \pan.kr(0));
	sig = sig*env;
	sig = sig *\amp.kr(1);
	Out.ar(\out.kr(0),sig);
}).add;

);

(
Synth(\casserole,[
	\buf, ~casserole.bufnum,
	\freq, 700,
])
)

(
p = Pbind(
	\tempo, 120/60,
	\instrument, \casserole,
	\buf, ~casserole,
	//\freq, Pseq([400,600,700,800],inf),
	\degree, Pseq([-24],inf),



	\dur, Pseq([1,1],inf),

).play

);
(
q=Pbind(
	\tempo, 120/60,
	\instrument, \casserole,
	\buf, ~casserole.bufnum,
	\degree, Pseq([0,12,4,6].midiratio,inf),
	\dur, Pseq([1/2,1,1,1/4],inf),

).play

)
Pbind.browse