; File: sustained.scd
; -------------------
; A live coding script for Sustained.
;
; Author: Akinori Kinoshita
; E-mail: art.akinoshi -at- gmail.com
; Sat Apr 20 11:41:05 CST 2013

Fri Mar 29 22:11:35 CST 2013

// audio live coding

Pdef(\a).play;
Pdef(\a,Pbind(\instrument,\SOShats,\out,8,\dur,Pseq([4,2,1,4]/4,inf),\amp,0.1));
Pdef(\a).clear;

Pdef(\b).play;
Pdef(\b,Pbind(\instrument,\synthpopbass,\out,8,\dur,1/4,\degree,Pseq(List.fib(24)%(List.fib(24)%12),inf),\octave,Pseq([4,6],inf)));
Pdef(\b,Pbind(\out,8,\dur,1/2,\degree,Pseq(List.fib(24)%(List.fib(24)%12),inf),\octave,Pseq([4,6],inf)));
Pdef(\b).clear;

Pdef(\c).play;
Pdef(\c,Pbind(\instrument,\synthpopbass,\out,8,\dur,1/4,\degree,Pseq(List.fib(24)%(List.fib(24)%12).rotate(7),inf)));
Pdef(\c).clear;

Pdef(\d).play;
Pdef(\d,Pbind(\instrument,\SOStom,\out,8,\dur,1/4,\amp,Pseq([1,1,0,1]*0.1,inf)));
Pdef(\d,Pbind(\instrument,\SOStom,\out,8,\dur,1/2,\amp,Pseq([1,1,0,1]*0.1,inf)));
Pdef(\d).clear;

Ndef(\out).play;
Ndef(\out).fadeTime=5;
Ndef(\out,{Mix.fill(100,{arg x;SinOsc.ar(x+1*100,mul:max(0,LFNoise1.kr(6)+Line.kr(-1,0.5,30)))})/100+AllpassN.ar(SinOsc.ar([2,4])*GVerb.ar(CombL.ar(In.ar(8)*LFPar.ar([1,2]),1,1,8),25,5),1/2,1/4,1/8)*0.4!2});

Ndef(\out,{GVerb.ar(In.ar(8),25,5)*0.5!2});
Ndef(\out).clear(10);
