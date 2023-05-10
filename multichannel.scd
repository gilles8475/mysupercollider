s.meter;
Server.default.options.numOutputBusChannels_(16);//nombre de canaux de sortie à 16
(
~num = 50;
SynthDef.new(
	\mulchexp,
	{
		arg out=0, amp=0.1, dens=1.0,pan=0.0;
		var sig;
		sig = Dust.ar(dens!2,amp);//equivalent à sig=[Dust.ar([1.0,1.0],amp),Dust.ar([1.0,1.0],amp)]
		//sig=CombC.ar(sig, 0.01, [300,440].reciprocal,4.0);
		sig=CombC.ar(sig, 0.01, Array.rand(~num,300.0,1000.0).reciprocal,4.0);
		//sig=Mix.new(sig);//rassemble les ~numcanaux en 1 seul (celui de gauche)
		//sig=Pan2.ar(sig,pan);//Pan2 prend un signal et le répartie sur 2 canaux selon une valeur pos qui varie de -1(gauche) à +1(doite). le signal sur les deux canaux est identique
		sig=Splay.ar(sig);//répartie un array de signaux sur 2 canaux SC se charge de répartir les différents canaux
		Out.ar(out,sig);
	}
).add
)

x =Synth.new(\mulchexp);//dans supercollider on peut enlever la methode new qui est implicite
x.set(\dens,5)

{CombC.ar(WhiteNoise.ar(),0.2,0.2,1)}.play
~sig1={SinOsc.ar(440,mul:0.1)};
~sig2={SinOsc.ar(340,mul:0.1)};
~sig3={SinOsc.ar(540,mul:0.1)};

{Mix.new([~sig1,~sig2])}.play;
{Pan2.ar([[~sig1,~sig2],~sig3],-1)}.play
{Splay.ar([~sig1,~sig2,~sig3])}.play

{Line.kr(0,1,1)}.plot(1)