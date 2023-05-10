s.options.numAudioBusChannels //nombre de bus audio
s.options.numControlBusChannels //nombre de bus de control

s.options.numOutputBusChannels //nombre de bus servant à envoyer du son (hp)
s.options.numInputBusChannels  //nombre de bus servant à recevoir du son (micros)

//on peux changer ces options
s.options.numOutputBusChannels_(12)
s.meter ; //il y a maintenant 12 output, les canaux 2 et 3 correspondent au micro
s.options.numOutputBusChannels_(2);

//pour réserver un bus audio
~monbus=Bus.audio(s,2); //on réserve un bus à deux canaux ce qui fait deux bus consécutif. SC fait la résa pour nous
~monbus.index //pour voir l'index du bus choisi par SC
s.scope;
{Out.ar(~monbus,{SinOsc.ar()!2})}.play ; //sélectionner le bus dans la fenetre pour voir s'il y a un signal'

//idem pour les bus de control

~control = Bus.control(s,1); //réservation d'un bus de control
~control.index;

//attention il faut faire distinction entre la variable qui sert au client pour désigner le bus
//et le bus crée par le systeme
// si on fait plusieur fois var = Bus.audio(s,2); le systeme réservera d'autres et seul le dernier crée sera accéssible par la variable.
//les autres pourront quand meme être accédés par leur numero si tant est qu'on s'en souvient

//ex
~bus = Bus.audio(s,200)// 24 bus réservés. si on lance plusieurs fois ce message le serveur va renvoyer une erreur des que l'on dépasse le nombre max de bus (1024)
//pour réinitialiser les bus
s.newBusAllocators;

//quelques commandes utiles
s.meter //pour voir le vumetre
s.plotTree //pour voir les nodes en cours
s.freeAllBuffers //pour enlever tous les buffers de la mémoire
s.outputBus //pour voir le numéro de bus réservés pour les sorties
s.inputBus //pour voir le numéro de bus réservé pourles entrés (micros). attention dans le vumetre le bus entrée est 0 mais en fait c'est 2
s.defaultGroup //le groupe par défaut
s.status
s.device
s.class

//application pratique
//on va générer un signal qu'on enverra sur un bus audio privée (cad pas un bus réservé par le systeme et raccordé aux hp), et ensuite on récupérera ce signal pour le transformer et l'envoyé sur le bus de sortie systeme (ici c'est 0)
//1-on définit une variable qui contiendra le bus privée
~fx = Bus.audio(s,2) //un bus à deux canaux
~fx.index //pour voir les numéros de canaux réservés

// on commence par lire le signal sur le bus ~fx. l'ordre d'execution a une importance. Comme le premier signal envoyé sur le serveur sera le dernier dans l'ordre d'execution.
//Pour générer un signal audio , SC lit tous les synth du haut vers le bas, et les découpe en portions correspondants à une période de contrôle.
s.options.blockSize //par défaut
//SC  "process" ces signaux et les envoie au serveur.
//si le premier signal dans la pile lit bus qui n'est écrit que sur un synth situé plus bas dans la pile alors il ne se passera rien. Dans notre cas si le signal Freeverb qui lit le bus ~fx est en haut de la pile, alors il lira un bus vide et ne génèrerar aucun son. Le bus qui recoit un signal doit se situer en bas de la pile
(
~freeverb={
	var sig = In.ar(~fx,2);
	sig = FreeVerb.ar(sig);
	Out.ar(0,sig)
}
)
//ensuite on génère un son qu'on envoie sur ce bus
(

~monsignal={Out.ar(~fx, {
	var env, sig;
	env=Env(times: [0.01,0.02]).kr(0, gate: Dust.kr(10));
	sig = Saw.ar(300);
	sig=sig*env;

}
)}; //un simple signal sinusoidal sur 2 canaux. on entend pas vu qu'il est sur un bus privé
);
//commençons par jouer ~monsignal
~monsignal.play(); //le signal est envoyé vers le bus privé ~fx donc on entend rien
//on joue ensuite ~freeverb;
~freeverb.play();//le signal est placé en tête de liste et il lit le bus ~fx.donc on entend rien car le bus ~fx est écrit par le Synth qui suit dans la pile de synth (regarder dans node tree) !!

// pour pallier ce problème on peut soit veiller à lancer les synth dans le bonne ordre, soit utiliser les options de play
~monsignal.play();
~freeverb.play( addAction: 'addToTail'); //là on est sur que l'effet réverbe est à la fin

s.scope //pour voir le signal
//pour que ce soit plus claire je vais réécrire les fonctions

(
~freeverb={
	var sig = In.ar(~fx,2);
	sig = FreeVerb.ar(sig);

};
~monsignal={
	var env, sig;
	env=Env(times: [0.01,0.02]).kr(0, gate: Dust.kr(1));
	sig = Saw.ar(300);
	sig=sig*env;

}

)
//là on peut utiliser les options de play sur une fonction

u=~monsignal.play(outbus: ~fx,fadeTime: 0.5,addAction: 'addToHead');
//'addToHead est l'option par défault donc on peux l'ommetre

~freeverb.play(target: u , outbus: 0, addAction: 'addAfter'); //ici on dit de mettre ce synth après u, ce qui signifie que u doit être déjà initialisé, ce qui n'est pas une bonne méthode

//comme on sait que freeverb doit être dernier dans la pile on utilisera plutôt
x=~freeverb.play(outbus: 0, addAction: 'addToTail');
u.release //stop le synth , remarquer le fadetime
x.free //stop le synth associé à freeverb


//On peut faire autrement et créer des groupes
//on va créer un groupe pour les instruments et un groiupe pour les effets

~instruments = Group.new() //on voit le groupe qui s'affiche à l'intérieur du groupe default
~effets = Group.new(addAction: 'addToTail');//le groupe effets est placé à la fin et comme ça les effets qui seront dedans recront les signaux des instruments qui sont dans un groupe situé au dessus
//maintenant on place les synth dans les groupes souhaités
u = ~monsignal.play(target: ~instruments, outbus: ~fx)
v = ~freeverb.play(target: ~effets, outbus: 0) //on a plus besoin de préciser l'ordre dans le groupe sauf si besoin particulier
u.release
v.release

~instruments.free //pour supprimer le groupe et tout ce qu'il contient'
~effets.free

// on va ajouter un autre effet
(
~delay = {
	var sig = In.ar(~fx);
	sig = DelayN.ar(sig, 0.3,0.3);
}
)

u = ~monsignal.play(target: ~instruments, outbus: ~fx);
v = ~freeverb.play(target: ~effets, outbus: 0);
w = ~delay.play(target: ~effets, outbus: 1);//remarquer l'effet sur le hp droit
w.release
v.release
u.release


//attention, quand on fait ctrl+. on supprime aussi les groupes