s.boot;
{SinOsc.ar()}.scope
{XLine.kr(10,1000)}.plot(1);
{Line.kr(1,1000)}.plot(1);
{LFPulse.ar()}.scope;
{Impulse.ar(LFPulse.kr(10,0.0,0.5,200))}.scope

(
SynthDef(\monimpulse,{
	arg freq=440, width=0.5, mul=200;
	var sig;
	sig=Impulse.ar(LFPulse.kr(freq,0,width,mul));
	Out.ar(0,sig);

}).add;
)
q=Synth.new(\monimpulse);
q.set(\freq,800);
q.set(\width,0.5);
q.set(\mul,50)

{ LFPulse.ar(400,0,2,0.1)}.scope
MouseY.kr(0,100).scope
{VarSaw.ar(width:0.5)}.plot(1)
{LFPulse.ar(440,0.0,VarSaw.kr(5,0.0,0.5))}.scope
{SyncSaw.kr()}.plot(1);
{ FSinOsc.ar(400,0,0.1) }.scope();
{Blip.ar(XLine.kr(2000,100,0.5),100,0.2) }.scope(1);
{SinOsc.ar}.play; //simple sinusoide
{Blip.ar(4,200) }.plot(1);//train d'impulsion qui vibre un peu
{LFPar.ar(440)}.scope//approximation parabolique d'une sinusoide
{Pulse.ar(200,0.5)}.plot(0.15);//train d'impulsionsncarrés
{Pulse.ar(200.5)}.play;
{ LFSaw.ar(400)}.plot//signal triangulaire avec décroissance abrupte
{ LFSaw.ar(400)}.play//signal triangulaire avec décroissance abrupte
{ LFTri.ar(800,0,0.1) }.plot//signal triangulaire

{Impulse.ar(freq:1000)}.plot(0.1) //train d'impulsion

{LFPulse.ar()}.plot()//impulsions carrées
{LFPulse.ar()}.play()//impulsions carrées
{VarSaw.ar()}.plot//signal triangulaire mais on peut faire varier la forme des dents avec le parametre width
{VarSaw.ar()}.play//
{SyncSaw.ar(800,200)}.plot(2)// des triangles qui varient en amplitude
{SyncSaw.ar(100)}.play;


{ Saw.ar()}.plot //des dents de scie ancore
{ Saw.ar(400)}.play //presque similaire à LFSaw
{Pulse.ar(10,0.5)}.plot(1) //des impulsions


{ Pulse.ar(XLine.kr(10000,200,6),0.1,0.2) }.scope(1);
//Klang est un oscillateur multifréquence
{Klang.ar(`[[400,400,400],[0.3,0.3,0.3],[0,pi/4,pi/2]],0.8,0)}.play;



//bruits à faible spectre
{ LFNoise0.ar(100) }.plot(0.1);//du bruit consistant en une suite de créneaux(signal carré) de durée 1/freq
{ LFNoise0.ar(400) }.play

{ LFNoise1.ar(100) }.plot(0.1);//du bruit consistant en une suite de triangle de durée 1/freq
{ LFNoise1.ar(400) }.play//ça grésille moins que LFNoise0

{ LFNoise2.ar(100) }.plot(0.1);//du bruit consistant en une suite de morceaux de sinusoide de durée 1/freq
{ LFNoise2.ar(400) }.play//c'est encore plus soft que noise0 et noise1

{ LFClipNoise.ar(200) }.plot(0.1)//train d'impulsion de largeur aléaroire
{ LFClipNoise.ar(400) }.play //ça fait un grésillement désagréable car le spectre s'étale dans les haute fréquence

//Bruit à large spectre
{ ClipNoise.ar() }.plot(0.001);//des carrés des triangle en vrac
{ ClipNoise.ar(0.1) }.play //ça procure un bruit sur tout le spectre c'est pour ça qu'il n'y a pas de parametre de frequence
{ WhiteNoise.ar() }.plot(0.001);//bruit blanc
{ WhiteNoise.ar(0.1) }.play //moins agressif que clipnoise

{ PinkNoise.ar() }.plot(0.001);//du bruit rose
{ PinkNoise.ar(0.1) }.play //moins agressif que clipnoise et white noise
{ BrownNoise.ar() }.plot(0.001);//du bruit brun
{ BrownNoise.ar(0.1) }.play //

{ GrayNoise.ar() }.plot(0.001);//du bruit brun
{ GrayNoise.ar(0.1) }.play // seules des oreilles de pro peuvent voire les différences !!!


//bruits à base d'impulsions
{ Dust.ar(1000) }.plot(1);//des impulsions réparties aléatoirement selon une densité donnée. les pics sont positifs
{ Dust.ar(100) }.play // ça fait un bruit de crépitement
{ Dust2.ar(1000) }.plot(1);//des impulsions réparties aléatoirement selon une densité donnée. les pics peuvent être négatifs
{ Dust2.ar(100) }.play // ça fait aussi un bruit de crépitement

//bruit chaotique

{ Crackle.ar(chaosParma:2) }.plot
{ Crackle.ar(chaosParam:2,mul:0.5) }.play //plus le chaosparam est proche de 0 plus le signal sera aigu. avec chaosParame à 2 ça fait un son de pluie qui tombe sur le sol

//Les filtres
//les filtres prennent en parametre un signal
{LPF.ar(WhiteNoise.ar(),440)}.play//filtre les freq supérieur à 440
{HPF.ar(WhiteNoise.ar(),440)}.play //filtre les freq inférieur à 440


//filtrer  à bande passante
{BPF.ar(WhiteNoise.ar(),freq:440,rq:0.2,mul:10)}.play//filtre les freq sur 440 440+440*rq. Plus lr rq sera petit et plus le filtre ser aétroit autour de freq. On peux s'en servir pour faire du vent'
{BRF.ar(WhiteNoise.ar(),440)}.play

//filtre à résonnance
{ RLPF.ar(WhiteNoise.ar, freq:600, rq:0.6, mul:0.2) }.play// ça fait un bruit de vent. on peut s'amuser à faire varier le rq
{ RHPF.ar(WhiteNoise.ar(), freq:600, rq:0.6, mul:0.2) }.play//ça fitre les basses freq

//les filtres formant
{ Formlet.ar(Impulse.ar(10), 800, 0.01, 0.1) }.play;
{ Klank.ar(`[[200, 671, 1153, 1723], nil, [1, 1, 1, 1]], Impulse.ar(20, 0, 0.1)) }.play;//ça fait raisonner les impulsions


// on a aussi tout un tas de la distorsions
{ SinOsc.ar(300, 0).distort * 0.2 }.play;
{ SinOsc.ar(300, 0).softclip * 0.2 }.play;
{ SinOsc.ar(300, 0).fold2(2) * 0.2 }.play;
{ SinOsc.ar(300, 0).wrap2(1) * 0.2 }.play;
{ SinOsc.ar(300, 0).clip2(1) * 0.2 }.play;
{ SinOsc.ar(200, 0, 0.2).scaleneg(MouseX.kr(-1,1)) }.play// ça fait un peu un bruit d'orgue d"église'

//le panning
//Pan2 répartit un signal mono sur deux voies
{ Pan2.ar(BrownNoise.ar, MouseX.kr(-1,1), 0.3) }.scope(2);
{ LinPan2.ar(BrownNoise.ar, MouseX.kr(-1,1), 0.3) }.scope(2);// ça fait pareil que pan2 mais c'est moins fort(les signaux sont atténués selon la balance)

//reverb
//freeverb
{FreeVerb.ar(Dust.ar(10), 0.75, 0.9, 0.4)}.play;
//gverb
{GVerb.ar(Dust.ar(10), 105, 5, 0.7, 0.8, 60, 0.1, 0.5, 0.4)}.play;

//delay
{Decay.ar(Impulse.ar(2,0,0.4), 0.5)}.play //décale un signal dans le temps
{DelayN.ar(Impulse.ar(5),0.1,0.1,1,Impulse.ar(10))}.play;

//jouer avec les buffer
//b = Buffer.read(s, Platform.resourceDir +/+ "sounds/a11wlk01.wav");//charge un buffer
b = Buffer.read(s,"/home/gilles/Musique/superCollider/sounds/gaulois_refractaire.wav");
b.query
{PlayBuf.ar(1,b,rate:1,loop:1)}.play;// en jouant sur rate on fait varier la vitesse de lecture





{var trig=LFClipNoise.kr(5,1,0);PlayBuf.ar(1,b,1,trig,0,1)}.play;

(
(
b = Buffer.alloc(s, 2048, 1, bufnum: 80);
b.sine1(1.0/(1..6), true, true, true);
{ Osc.ar(80, 100, 0, 0.1) }.scope(1, zoom:4);
)
)
 {LFPar.ar(LFClipNoise.kr(MouseX.kr(0.5, 64, 1), 200, 400), 0, 0.2) }.scope(1, zoom:8);

{ LFNoise0.ar(MouseX.kr(200, 10000, 1), 0.25) }.scope(1);
{ LFNoise1.ar(MouseX.kr(200, 10000, 1), 0.25) }.scope(1);
{ LFClipNoise.ar(MouseX.kr(200, 10000, 1), 0.125) }.scope(1);
{ SinOsc.ar(LFNoise0.kr(MouseX.kr(0.5, 64, 1), 100, 500), 0, 0.2) }.scope(1, zoom:8);

















