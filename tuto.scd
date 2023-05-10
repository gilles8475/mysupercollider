(
y={LFNoise0.kr(freq: 25, mul: 1.0, add: 0.0).range(400,600).poll(1)}:
{SinOsc.ar(y)}.play;
)

z={LFNoise0.ar(freq: 100.0, mul: 1.0, add: 0.0).range(40,60).poll(1)};
z.play;
(
y={Line.kr(100,1000,0.2).poll};
{LFPulse.ar(freq:y,mul:0.01)}.play;
)
a={10.rand.postln}
b=a.neg;
a.value;
b.value;

(
{
	var sig,mult,freq;
	mult={LFNoise0.kr(300).exprange(1,100)}.plot;
	//mult.plot;
	freq={Line.kr(400,600,2)};

	sig=SinOsc.ar([freq,freq*1.5],mul:mult*0.001);
}.play
)
{LFNoise0.kr(2).range(1,100)}.plot(2)
{WhiteNoise.kr()}.plot(2)
s.meter
{XLine.kr(1,1000,1)}.plot(1)
{Line.kr(0,100,1)}.plot(1)
a={Impulse.ar(120)};
a={LFNoise0.kr()}
{SinOsc.ar(440*a)}.scope;
//different UGens
{LFCub.ar(50)}.plot(1)
{XLine.kr(1,20,3)}.plot(4);
{Blip.ar(numharm:10)}.play
{Blip.ar(200,Line.kr(1,100,5),0.2)}.play;

s.plotTree;

(
{
	var sig, env;
	env=Env.new([0,1,0.5,1,0],[0.1,1,1.5,0.5],\linear);
	SinOsc.ar(470)*EnvGen.kr(env,doneAction:2,timeScale:0.4)

}.play
)
Env.new([0,1,0.5,1,0],[0.1,1,1.5,0.5],\linear).plot(2);
(
{
	var sig, env;
	env= XLine.kr(1,0.001,1,doneAction:2);
	sig = Pulse.ar(ExpRand.new(30,500))*env
}.play
)
(
{
	var sig,freq, env;
	env= XLine.kr(1,0.001,1,doneAction:2);//doneAction:2 signifie que le synth est tué une fois que l'enveloppe est jouée
	freq=XLine.kr(880,110,0.5,doneAction:0);
	sig = Pulse.ar(freq)*env
}.play
)
{Pulse.ar(freq: 440.0, width: 0.2, mul: 1.0, add: 0.0)}.scope;
//enveloppe avec EnvGen
Env.new.plot;//enveloppe par default= triangle 0,1,0 sur 1 seconde
Env.new([0,1,0.2,0],[0.5,1,2],\lin).plot;
Env.new([0.01,1,0.2,0.01],[0.5,1,2],\exp).plot;
Env.new([0,1,0.2,0],[0.5,1,2],[-3,-3,-1]).plot;
(
x={
	arg gate=0;
	var sig, env;
	env=EnvGen.kr(Env.new(
		[0,1,0.2,0],[0.5,1,2],[-3,-3,0]
	),gate:gate/*,doneAction:2*/
	);
	sig=Pulse.ar(ExpRand(30,500))*env;
}.play

)
x.set(\gate,1) // changer gate d'une valeur negative ou nulle à une valeur positive déclenche le synth associé à l'envellope

(
x={
	arg t_gate=1;//t_gate a une signification spéciale. signifie que la valeur est remise à zero à la fin du cycle de l'enveloppe. c'est utile pour déclencher des évènements avec gate sans avoir à repasser la valeur à zero manuellement
	var sig, env;
	env=EnvGen.kr(Env.new(
		[0,1,0.2,0],[0.5,1,2],[-3,-3,0]
	),gate:t_gate/*,doneAction:2*/
	);
	sig=Pulse.ar(LFPulse.kr(8).range(400,450))*env;
}.play

)
x.set(\t_gate,1) // plus besoins de mettre t_gate à zero (c'est compliqué à expliquer')


{LFPulse.kr(8)}.plot(1)

p=Pseries(0,2,10);
p.next;
q=p.asStream;
q.next

p=Pshuf([2,5,8],2,3).asStream.all;
p.next;






