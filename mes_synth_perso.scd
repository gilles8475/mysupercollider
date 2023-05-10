(
SynthDef(\glou,{
	arg amp=0.5, freq=440, gate=1.0;
	var env,sig;
	env=EnvGen.kr(Env.adsr(),gate:gate,levelScale:1.0,timeScale:1.0,doneAction:2);
	sig = {SinOsc.ar(XLine.kr(100,500,2),mul:env)};
	Out.ar(0,sig);


}).add

);

(
SynthDef(\glou2,{
	arg amp=0.5, freq=440, gate=1.0;
	var env,sig;
	env=EnvGen.kr(Env([0,1,0.8,0.5,1,0],[0.5,0.5,0.2,0.3],[-3,-5]),gate:gate,levelScale:1.0,timeScale:1.0,doneAction:2);
	sig = {SinOsc.ar(XLine.kr(100,500,2))*env};
	Out.ar(0,sig);


}).add

);

(
SynthDef(\glou3,{
	arg amp=0.5, freq=440, gate=1.0;
	var env,sig;
	env=EnvGen.kr(Env.perc(releaseTime:0.8,curve:-8),gate:gate,levelScale:4.0,timeScale:1.0,doneAction:2);
	sig = {LFNoise0.ar(XLine.kr(100,freq,0.5))};
	Out.ar(0,sig);


}).add

);

(
SynthDef(\glou4,{
	arg amp=0.5, freq=440, gate=1.0;
	var env,sig;
	env=EnvGen.kr(Env.perc(releaseTime:8,curve:2),gate:gate,levelScale:4.0,timeScale:1.0,doneAction:2);
	sig = {BPF.ar(WhiteNoise.ar(),freq:Dust2.kr(500,200,200),rq:0.2,mul:10)};
	Out.ar(0,sig);


}).add

);
(
SynthDef(\test,{|freq = 440, delay=0.95|
	var sig, freq2, frequ;
	freq2 = Lag.kr(freq,delay);
	frequ=freq2;
	sig = VarSaw.ar([frequ, frequ*1.005],mul:0.1);
	sig=LPF.ar(sig,1100);
	Out.ar(0,sig)
}).add
)
x=Synth(\test);
x.set(\delay,0.25)

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
//****************
{Lag.ar(10,0.1,1.0,0.0)}.plot()
Env.perc(releaseTime:0.5,curve:-12).plot
x=Synth(\glou4,[\gate,1,\freq,440])
x.set(\gate,0)
Platform.userExtensionDir
MethodOverride.printAll
{WhiteNoise.ar(0.01)}.play
{OnePole.ar(WhiteNoise.ar(0.01), 0.8)}.play
{LFSaw.ar(440,mul:0.02)}.play
{OnePole.ar(LFSaw.ar(440,mul:0.5),0.95)}.plot;
{LFSaw.ar(440,mul:0.5)}.plot;

Lag.ar(440,10)

s.plotTree
500.round(120)