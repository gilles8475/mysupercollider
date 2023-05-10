//generation d'un proxyspace
//a l'intérieur d'un proxyspace les variable ~ sont des proxynodes (node audio un peu spécial)
//on ne peux pas déclarer une variable ~ qui ne soit pas un proxynode
p =ProxySpace.new(s).push;
~sig.play.fadeTime_(4);
(
~sig = {
	var sig;
	sig = SinOsc.ar({exprand(80,1600)}!16)*0.1;
	sig = Splay.ar(sig);
}
)

~sig.play;
~sig.stop(fadeTime: 2);
~sig.release;
~sig.clear;
//buffer
//si on fait
~buf = Buffer.read(s,"/home/gilles/Musique/superCollider/sounds/bell.aiff" ); //erreur, ~buf n'est pas un proxynode

//on déclare un event
e= ();
e.truc = 5;
e.machin = 'bidule';
e.truc; //5

(
e =();
e.buf = ();
e.buf.path = PathName(thisProcess.nowExecutingPath).parentPath ++ "sounds/";
PathName(e.buf.path).entries.collect({
	arg n,i;
	e.buf[i]=Buffer.read(s, n.fullPath);
});

)
e.freq = ();
e.freq[0] = Array.fill(8, {exprand(200,1000)});
e.buf[1].play;
~sig.clear;
~sig.play.fadeTime_(3);


(
~sig = {
	var sig, trig, env, buf;
	trig = Trig.kr(Dust.kr(2),0.2);
	buf = e.buf[6];
	sig = PlayBuf.ar(2, buf, 1, trig);
	env = Env.perc(0.001,0.2,1,-2).kr(0,trig);
	sig = sig*env;
}
)

~sig = {}




