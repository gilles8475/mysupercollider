Buffer.freeAll;
(
~buffers = "/home/gilles/Musique/superCollider/sounds/*.wav".pathMatch.collect({
	arg path;
	Buffer.read(s,path);
});
~buffers[0].query;

)
(
SynthDef(\joueMono,{
	arg out=0, pan=0.0,amp=1.0,buf=0,ratio=1, pos=0.0, freq=1.0;
	var sig;
	sig=PlayBuf.ar(
		numChannels:1,
		bufnum:buf,
		rate:BufRateScale.kr(buf)*ratio, //permet de tenir des différences entre l'échantillonage du buffer et celui du server
		//par exemple si le fichier a été échantilloné à 88200hz et que le serveur est configuré pour lire du 44100 hz alors le scale sera de 1/2 pour ne pas avoir de modification de la tonalité.
		//on multipli par ratio pour controler la vitesse de lecture
		trigger: Impulse.ar(freq), //retour au début des que le trigger passe d'une valeur negative à une valeur postive
		startPos: BufFrames.kr(buf) * pos,
		loop: 0,
		doneAction:0
	);
	sig=Pan2.ar(sig,amp,amp);
	Out.ar(out,sig);

}).add
);
x = Synth.tail(s,\joueMono,[\buf,~buffers[0], \pos,0.5,\freq,1,\ratio,3.midiratio]);



//granulation avec Pbind



1.midiratio //freq*1.midiratio permet de jouer 1/2 ton au dessus de freq

