s.options.numAudioBusChannels;
s.options.numOutputBusChannels=4; //fixe à quatre le nombre de sortie audio
s.meter;
s.plotTree;

(/*
emets des bip aléatoires en fréquence et en espacement
*/
SynthDef.new(\blip,{
	arg out=0, density=2, maxfreq=800;
	var freq, trig, sig;
	freq =LFNoise0.kr(3).exprange(100,maxfreq).round(300);
	sig = SinOsc.ar(freq)*0.5;
	trig = Dust.kr(density);//emet des impulsions
	sig =sig*EnvGen.kr(Env.perc(0.01,0.2),trig); //chaque impulsion déclenche l'enveloppe et donc le signal
	sig=Pan2.ar(sig, LFNoise1.kr(10)); //le signal est envoyé sur 2 canaux selon une répartition aléatoire correspondant au bruit LFNoise0.
	//attention !! ce signal sera envoyé sur out et out+1, donc il faut faire attention à vérifier que ces sorties ne sont pas occupées. voir la doc sur les Bus
	Out.ar(out,sig);

}).add;
);

(
SynthDef.new(\reverb,{
	arg in, out=0;
	var sig;
	sig = In.ar(in,1);//branché sur la sortie in
	sig = FreeVerb.ar(sig,0.5,0.8,0.2)!2;
	Out.ar(out,sig)
}).add
)
//pour mémoire, visu des enveloppes

{LFNoise0.kr(3)}.plot(3);
{Dust.kr(2)}.plot(5);


y=Synth.new(\reverb,[\in,6]);//l'ordre de lancement a de l'importance. celui qui recoit le signal doit être lancé avant celui qui le recoit. car le dernier synth créer se trouve en haut
x= Synth(\blip,[\out,6]);
/*Plutot que d'utiliser des numéro de bus codé en dur on laisse faire SC à l'aide de la classe Bus */
~reverbBus = Bus.audio(s,1); //SC nous donne le premier bus valable
y=Synth.new(\reverb,[\in,~reverbBus]);
x= Synth(\blip,[\out,~reverbBus]);
x.set(\maxfreq,800);

//on va créer des groupes
s.freeAll; //supprime les synth en cours (voir sur  fenetre plotTree)
(


~sourceGrp = Group.new; //on crée un groupe
//les deux synth sont placé dans ce groupe
x= Synth(\blip,[\out,~reverbBus], ~sourceGrp);
y=Synth.new(\reverb,[\in,~reverbBus],~sourceGrp,addAction:'addToTail');//y est placé à la fin du groupe
);
s.freeAll;

//on peut aussi créer deux goupes 1 pour le signal et 1 pour les effets
(
~sourceGrp = Group.new;
~fxGrp = Group.after(~sourceGrp);//comme ça ce groupe
x= Synth(\blip,[\out,~reverbBus], ~sourceGrp);
y=Synth.new(\reverb,[\in,~reverbBus],~fxGrp);
);
//on peut envoyer une variable à un groupe de synth (ou node)
~sourceGrp.set(\density,10);

//on peut aussi créer plusieurs synth qu'on met dans un groupe
(
~sourceGrp = Group.new;
~fxGrp = Group.after(~sourceGrp);
8.do({
	Synth.new(\blip,[\out,~reverbBus], ~sourceGrp);
});
y=Synth.new(\reverb,[\in,~reverbBus],~fxGrp);
);
//et on change density pour tout le groupe
~sourceGrp.set(\density,12);


























