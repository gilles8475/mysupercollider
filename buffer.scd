(
a = Routine {// routine est une fonction particulière qui stoppe son execution à yield et reprend son execution à l'endroit où elle s'était arrêtée. yield renvoie une valeur , ici c'est i
    var    i = 0;
    loop {
        i.yield;
        i = i + 1;
    };
};

)
a.next;//à chaque appel de next la fonction Routine est appelée et "yield" une valeur (ici i)

//On peut faire la même chose avec la fonction Pseries et la methode asStream
(
a=Pseries(start:0,step:1,length:25).asStream;
a.next;
a.nextN(10); //comme si on faisait 10 fois next et qu'on stockait les valeur dans un array
)
//pour visualiser le stream
a.all

/*dans l'exemple précédent a Pseries(0,1,inf) est le patter alors que Pseries(10,1,inf).asStream est un stream.
La différence est que le stream garde la trace des appelles qu'on lui a fait (avec next par exemple)*/

p=Pseries(0,1,10); //pattern
r=p.asStream ; //stream basé sur le pattern p
q=p.asStream; //idem
//r et q sont indépendants
r.next;
r.next;
q.next;
q.next;
r.next;
[q.next,r.next];

p=Pseq([3,5,7,9],repeats:2,offset:1); //[3,5,7,9] répété deux fois. Si on veut commencer sur la deuxieme valeur on met offset à 1
q=p.asStream;
q.next;

p=Prand([3,5,7,9],repeats:7); //joue au hasard un élément dans la liste 7 fois
q=p.asStream;
q.next;

p=Pxrand([3,5,7,9],repeats:7); //joue au hasard un élément dans la liste mais jamais deux fois le meme 7 fois
q=p.asStream;
q.next;

p=Pshuf([3,5,7,9],repeats:3); //mélange la liste et la joue 3 fois
q=p.asStream;
q.next;
//et il y en a plein d'autres qu'on peut voir dans le pattern guide

//pour visualiser un stream on utilise la méthode all sur le stream
Pseq(#[1,2,3,4],4).asStream.all.plot
Pser([1,2,3,4,5],8).asStream.all;
//sucre syntaxique
(1..5)// equivalent à [1,2,3,4,5]

Pseq([1,2,3,4,4]).asStream.all.plot;

//dictionnaire
//un dictionnaire est une collection de key/value
//création dictionnaire
d=Dictionary.newFrom(List[\a,1,\b,2,\c,4]);
d.add(\monkey -> 0);//ajoute un élément à partir d'une association
d.put(\dog, 10); //ajoute un élément
d.put('cat',25); //idem
d.removeAt('b');//enleve un élément
d.removeAt('b');//enleve un élément
d.removeAt('b');//enleve un élément
d.removeAt('cat');//enleve un élément
d.removeAt(\dog);//enleve un élément retourne lavaleur de l'élément supprimé
d=()
d.putAll(Dictionary[\hello -> 9, \whello -> "world"], Dictionary["abd" -> 6]); //ajoute les deux dico dans le dico tres bizarre ça bug si on ajoute un diico avec une clé qui existe déjà !!!
d.putAll(Dictionary[\hello -> 9, \whello -> "world"], Dictionary["abd" -> 6]);
d=(monkey:99)
d.removeAt(\monkey)
d
d.putAll(Dictionary[\hello -> 9, \whello -> "world"], Dictionary["abd" -> 6]);
d.removeAt(\whello)
//accéder à un élément par sa clef
d.at(\abd);
//chercher la clef associée à une valeur
d.findKeyForValue(9);

//on peut mettre une fonction ou une liste ou n'importe quoi dans un dictionnaire' en dans un dictionnaire
(
d=(
	0:\zero,
	\abc: \alpha,
	[1,2,3,4,5]: \fibonacci,
	{arg x ; try{x.even}}: \even //fonction qui test si la valeur est paire

);
)
23.even
/* une petite explication s'impose.
Quand on met un array dans un dictionnaire c'est comme si tous les élément de cet array était des clef associée à la valeur de cet array. par contre on accédera pas à la valeur de cette clef avec d.at mais avec d.matchAt
*/

d.matchAt(2)//renvoie fibonacci car 2 est dans le array;
/*quand on met une fonction en tant que clef de dictionnaire, c'est comme si tous les éléments qui réponde à la condition appartenait au dictionnaire. bien sur la fonction doit renvoyer un booleen*/
d.matchAt(42); //renvoie even car quand 42 est passé à {arg x; try{x.even}} true est renvoyé et donc la clef 42 est associé à even.
/*Par contre si une clef répond à plusieurs conditions la valeur retourné sera arbitraire. donc attention à l'usage de  matchAt*/
//exemple
d.matchAt(4) //renvoie fibonacci car 4 appartient à [1,2,3,4,5]
//à noter qu'on met un try dans la fonction comme c'est indiqué dans l'aide. mais je vois pas la différence si on en met pas.
d.matchAt('52') // erreur

(
d=(
	0:\zero,
	\abc: \alpha,
	[1,2,3,4,5]: \fibonacci,
	{arg x ; x.even}: \even //fonction qui test si la valeur est paire

);
)

d.matchAt('52') //erreur aussi ????

//on a aussi des méthodes identiques aux dictionnaires

// do, collect, reject, select
d = Dictionary[\a -> "hello", \b -> "robot", \c -> [1, 2, 3]];
d = (a: "hello", b: "robot", c: [1, 2, 3]); // equivalent
d.do { |item, i| [item, i].postln };//parcours le dico et affiche les clefs avec un numéro d'index qui ne correspond à rien !!!???
d.collect { |item| item + 100 }; //crée un nouveau dictionnaire qui ajoute 100 à chaque valeur
d.reject { |item| item.size > 4 };
d.select { |item| item.size > 4 };
//et il y a plein de méthode

//LES EVENEMENTS
//un évènement s'écrit sous la forme
e = (argument1: 440, argument2:125);
e.at(\argument1) //440
e.at(\argument2) //125
e.put(\argument1,880); //remplace 440 par 880
e.put(\argument3, 45)//ajoute argument3, 45 à l'évènement
e.argument1 //affiche la valeur de la clef argument1
e.put(\argument3,nil); //enleve argument3
e.put(\dur,45); //ajoute dur,45
e.removeAt(\dur) //supprime dur comme plus haut

//utilisation de Pbind. Pbind crée un objet Pbind
(
p=Pbind(
	\degree, Pseq(#[0, 0, 4, 4, 5, 5, 4,25,56], 1),
    \dur, Pseq(#[0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 1], 1)
);
p=p.asStream; //on transforme l'objet Pbind en stream
);

//maintenant on peut appeler la methode next avec le parametre Event.new (création d'un évènement')
p.next(Event.new)// cela va renvoyer une série d'évènement (a,b) où a est un élément de \degree et \b un élément de \dur. C'est donc comme si on parcourait les deux tableaux et qu'on couplait les valeurs de meme index. Si un tableau est plus long que l'autre aucune valeur n'est générée

/*Supercollider possède un évènement par défaut appelé Event.default. Chaque évènement possède les clefs/valeur de cet évènement. En particulier il possède une clef play à laquelle est associé une fonction qui joue une note.
Donc n'importe quel évènement peut se voir appliquer la méthode play*/
Event.default.play;
().play;

a=(\key1:12,\key2:24);
a.play //joue une note
a.put(\play,{"et non ça marche plus!".postln});
a.play //affiche "et non ça marche plus"
b=()

//on peut donc appliquer play à notre Pbind p défini ci dessus
p.next(Event.new).play

//mais on peut jouer le pbind directement car celui ci possède une méthode play qui va jouer(play) les event associés

(
p=Pbind(
	\degree, Pseq(#[0, 0, 4, 4, 5, 5, 4], inf),
    \dur, Pseq(#[0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 1], inf)
);
)
q=p.play;
q.stop //pour arreter

//quand un évènement "play" un synth toutes les valeurs stockées avec le même nom dans cet event seront passées au nouveau synth. par exemple:
//je définis un nouveau synth qui va s'appeler default
(
SynthDef(\default,{
	arg out=0, lafrequence=200, lamplitude=0.5, gate=1;
	var sig;
	sig = SinOsc.ar(lafrequence*SinOsc.kr(50).range(0.5,1.5),0,lamplitude);
	Out.ar(out,sig);
}).add

);

(lafrequence:500,lamplitude:0.1,pan:0.7).play //est équivalent à  Synth(\default, [frequence: 640, amplitude: 0.1, pan: 0.7])
//comme j'ai redéfinis default c'est ce dernier qui va être joué
//normalement les parametres de l'event doivent correspondre aux parametres du synthdef mais certains sont redéfinis en interne comme par example degree qui est converti automatiquement en freq.

//on est pas obligé de redéfinir le synthdef par default. le synthdef qui sera joué par play est défini par la clef \ instrument

SynthDef(\harpsi, { |outbus = 0, freq = 440, amp = 0.1, gate = 1|
    var out;
    out = EnvGen.ar(Env.adsr, gate, doneAction: Done.freeSelf) * amp *
        Pulse.ar(freq, 0.25, 0.75);
    Out.ar(outbus, out ! 2);
}).add;    //un synthdef qui a un son de harp
(
p = Pbind(
        // Use \harpsi, not \default
    \instrument, \harpsi,
    \degree, Pseries(0, 1, 8),
	\dur, 0.25)

)
q=p.asStream;
10.q.next(()).play //raccourci pour p.next(Event.new)
x=Prand([4,5,6,7,3],inf).asStream;
x=Pser([1,[2,3],4,5,6],25,0).asStream
x=Pslide([1,2,3,4,5,6,7],4,2).asStream
x=Pcauchy().asStream;
x=Place([1,[2,3],4,[5,6],7],5).asStream;
x=Ppatlace([1,[2,3,4,5],4,[5,6],7],5).asStream;

x.next;
x.reset


s.boot;
(
p=Pbind(
	\degree, Pslide([0,1,2,3,4,5,6],inf,3),
	\dur, Pseq([0.5,0.5,0.25,1,1,0.5],inf)
).play
)
(
p=Pbind(
	\degree, Pwalk([0,1,2,3,4,5,6],2,1),
	\dur, Pseq([0.5,0.5,0.25,1,1,0.5],inf)
).play
)
(
p=Pbind(
	\degree, Pcauchy(),
	\dur, Pseq([0.5,0.5,0.25,1,1,0.5],inf)
).play
)

































