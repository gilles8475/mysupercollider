s.boot;
Buffer.freeAll;
// same but best
b = Buffer.read(s,"sounds/violon-bit.aiff".resolveRelative);
b.query

//tips
"sounds/violon-bit.aiff".resolveRelative //affiche le chemin absolue vers le fichier sounds .
thisProcess.nowExecutingPath; //donne le nom du fichier actuelle
//////////////

b.play;
(
SynthDef.new(\play,{
	var sig, env;
	sig = PlayBuf.ar(
		numChannels:1,
		bufnum: \buf.kr(0), //equivalent à arg buf=0
		rate: BufRateScale.kr(\buf.kr(0))* \rate.kr(1),
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

)
//tips
1.midiratio //done le coef à appliquer à une fréquence pour avoir la note 6 demi tons au dessus

62.midicps //donne la fréquence qui correspond à la midinote 62
b.duration; //donne la durée du buffer


(
/*tips: Pour faire varier le pitch d'un buffer on peut faire varier le rate qui joue sur la vitesse de lecture'
si on veut un demi ton au dessus on applique un rate de 1.midiratio
si on veut 2 demi tons au dessus on applique un rate de 2.midiratio etc....
*/

Synth.new(
	\play,
	[
		buf:b.bufnum,
		rate: -12.midiratio, //un octave plus bas(12 demi tons)
		pan: 0,
		atk: 0.01,
		rel:1.8,
		spos:s.sampleRate*1.2, //lit à partir de 1 seconde
		loop:1,//loop à 1 signifie que le buffer est jouer en boucle

	]

)

)

//on peux jouer plusieurs fois le synth avec la fonction do
(
[0,2,4].do({|n|
	//n = n + [0,-12].choose; //ajoute 0 ou -12 aléatoirement à n
	n = n + [12,0,-12,-24].choose;
	Synth.new(
		\play,
		[
			buf:b.bufnum,
			rate: n.midiratio * rrand(-0.2,0.2).midiratio*[1,-1].choose, //détune entre -1/5 et +1/5 de demi ton
			pan: 0,
			atk: exprand(0.002,0.2),
			rel:exprand(0.5,2),
			spos:s.sampleRate*rrand(0.0,1.1),
			loop: 1,

		]

	)
})
)