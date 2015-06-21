testinvmod=: (0 1 e.~ [| ]* invmod)


coclass 'factoring'

intpower=: 3 : 0
2x intpower y
:
a=. 1 [ xp=. x
for_k. |. }. #: y do.
  if. k do. a=. a*xp end.
  xp=. *: xp
end.
a*xp
)
modpow =: 4 : 'x y&|@^ 65537'
modexp =: 1 : (':';'x m&|@^ y')

imw=: ((2&{ - {. * 4&{ <.@% {:),(3&{ - 1&{ * 4&{ <.@% {:), 2&{., ({: | 4&{) ,~{:)^:(0 ~: {:)
invmod=: 4 : 0
NB. inverse of y mod x (x|y)
NB. uc vc ud vd d c  where d c init as x y
NB. q =. d<.@%c -- (4&{ <.@%~ {:)
a=. imw^:_ ] 1x,0x,0x,1x,x,y
if. 1~: 4{a do. 0 return. end. NB. returns 0 if no inverse
if.0< 2{ a do. 2{ a else. x+2{a end.
)

gcd2x=: 3 : 0  NB. extended euclid returns gcd,yp,yq in Rabin crypto.
'r0 r1'=.y
's0 s1'=.1 0
't0 t1'=.0 1
while. r1 ~: 0 do.
q=.  r0 <.@% r1
'r0 r1'=. r1,r0-q*r1
's0 s1'=. s1,s0-q*s1
't0 t1'=. t1,t0-q*t1
end.
r0,s0,t0
)

jacobi =: 4 : 0 NB. x is n , y is a. returns 1 0 _1 wiki jacobi symbol
NB. pD x, y
NB. if. 1 = *./ 0 < x,y do. 'x y' =. - x,y end.
NB. if. +./ 0 1 _1 = y do. if. 0 > x do. -y else. y end. return. end.
if. +./ 0 1  = y do. y return. end.
NB.if. 0 = 2|y do. if. +./ 1 7= 8| x do. x jacobi -: y else. x jacobi - -: y end. return. end.
if. 0 = 2|y do. if. +./ 1 7= 8| x do. x jacobi -: y else. x -@jacobi  -: y end. return. end.
NB.if. 3 3 -: 4 | x, y do. y jacobi - y | x else. y jacobi  y | x end.
if. 3 3 -: 4 | x, y do. y -@jacobi  y | x else. y jacobi  y | x end.
)
cf=: 4 : '{:"1 (,<.)@%@-/^:(<x) (,<.) y' NB. conttinued faction
cfx=: 4 : 0
 z=. a=. <.r=. y
 for. i.x do. z=. z, a=. <. r=. % r - a 
 if. a = _ do. z return. end. end.
)
 NB. x is highest denominator to round to. y is rational fraction
NB. returns just denominator.  Used for compression of rabin signatures.
cfround2 =:  4 : 0 
 'v0 v1 v2'=. 2 {:"1@:x: (+%)/\ 2 cfx y
 
     a=.<. r=. % r - <.r=. y
    NB. a=.<. r=. % r - <. r=. % r - <.r=. y
  while. x > v2  do. 
   if. _ = a=. <. r=. % r - a do. v2 return. end.
   v2 =. v0 + v1 * a
   v0 =. v1
   v1 =. v2  
  end. 
v0
)



NB. error if no denominator lower than x
cfround =: (<.@%:@[ 4 : 0 %~) :: 0: NB. x is highest denominator to round to. y is rational fraction
 z=. a=. <.r=. y
 whilst. x > {: s =. (] , {:@(2&x:)) (+%)/ z do. s1 =. s
 z=. z, a=. <. r=. % r - a 
 if. a = _ do. s return. end. end.
 s1
)

notmult =: %~ ~: <.@%~
ismult =: %~ = <.@%~
issquare =: %: = <.@%:
issquare =: ] = [: *: <.@%:

g0    =: , ,. =@i.@2:
it    =: {: ,: {. - {: * <.@%&{./
gcd   =: (}.@{.) @ (it^:(*@{.@{:)^:_) @ g0

ab    =: |.@(gcd/ * [ % +./)@(,&{.)
cr1   =: [: |/\ *.&{. , ,&{: +/ .* ab
chkc  =: [: assert ,&{: -: ,&{. | {:@cr1
cr    =: cr1 [ chkc

CRT =: 1 : 0 NB. m is coprime p q 
'n p q yp yq' =. RCdparams m
'a b' =. (yp , yq) |.@:* p,q NB. is gcd2x (euclid) such that 
NB. ([: |/\ *.&{. , ,&{: +/ .*  (yp , yq) |.@:* ,&{.)/@:((p,q) ,. ])
( n | ,&{: +/ .*  (a,b)"_)/@:((p,q) ,. ])
)

CRTm =: 1 : 0 NB. multiparam list of coprime bases.  
n =. */ m
assert n = *./m 
NB.abl =.  ab/\ m
NB. pD ( (2&{.@:]) , [: |/ *&(2&{) , ,&{: +/ .*  (2&{.@:]))/\@:(abl ,. m ,. ]) y
NB.,@:( (2&{.@:]) , [: |/\ *&(2&{) , ,&{: +/ .*  (2&{.@:]))/\@:(abl ,. m ,. ])
NB.( (2&{.@:]) , [: |/\ *&(2&{) , ,&{: +/ .*  (2&{.@:]))/\@:(abl ,. m ,. ])
[:{: cr1/@:(m ,. ])
NB. n | [: {: 
)


huo=: <. @ -:^:(0=2&|)^:a:  NB. halve until odd
NB. magic numbers from http://primes.utm.edu/prove/prove2_3.html
witnesses=: 4 : 0
 r=. 9080191 4759123141 2152302898747 3474749600383 341550071728321x
 if. y>:{:r do. 
  1+x ?@$ y-1 
 else.  
  ((r-1) I. y){:: 31 73 ; 2 7 61 ; 2 3 5 7 11 ; 2 3 5 7 11 13 ; 2 3 5 7 11 13 17 
 end.
)

NB. Miller-Rabin primality test
NB. deterministic for y< {:r (3.4e14) in witnesses; probabilistic for y>:{:r (0 answer is always correct; 
NB. 1 answer is wrong with error probability at most 0.25^x)

MillerRabin=: 100&$: : (4 : 0) " 0
 NB.if. 0=2|y do. 2=y return. end.
 NB.if. 74>y do. y e. i.&.(p:^:_1) 74 return. end.
 e=. huo y-1
 for_a. x witnesses y do. if. (+./c=y-1) +: 1={:c=. a y&|@^ e do. 0 return. end. end.
 1
)

MillerRabinQ=:(3 : 0) " 0
 e=. huo  y-1
 NB.a=. wit1 y
 if.   (1,<:y) -.@e.~ c=. (>:@?@<: y) y&|@^ {:e do. NB.0 return. end.
 if.  (1,<:y) ([: -. +./@:e.~) c y&|@^ 2 ^ >:i.<:#e do. 0 return. end. end.
 1
)

MillerRabinQ1=:(3 : 0) " 0 NB. fails but fast.
 e=. huo  y-1
 NB.a=. wit1 y
 if.   (1,<:y) -.@e.~ c=. 341550071728321x y&|@^ {:e do. NB.0 return. end.
 NB.if.   +./ 1= c y&|@^ 2 ^ >:i.<:#e do. 0 return. end. end.
 if.  (1,<:y) ([: -. +./@:e.~) c y&|@^ 2 ^ >:i.<:#e do. 0 return. end. end.
 1
)

MillerRabinQW=:(3 : 0) " 0 NB. fails but fast.
 if. (0 = [: +./ 5 7&|) y do. 0 return. end.
 e=. huo  y-1
 if.   (1,<:y) -.@e.~ c=. 341550071728321x y&|@^ {:e do. NB.0 return. end.
NB.if.   (1,<:y) -.@e.~ c=. 3825123056546413051x y&|@^ {:e do. NB.0 return. end.
 if.  (1,<:y) ([: -. +./@:e.~) c y&|@^ 2 ^ >:i.<:#e do. 0 return. end. end.
 1
)

MillerRabinX=: 4&$: : (4 : 0) " 0
 NB.if. 0=2|y do. 2=y return. end.
 NB.if. 74>y do. y e. i.&.(p:^:_1) 74 return. end.
 e=. huo y-1
 for_a. x witnesses y do. if. (c=y-1) +: 1=c=. a y&|@^ {:e do. 
 NB.if.  (+./c=y-1) +: +./ 1=c y&|@^ 2 ^ >:i.<:#e do. 0 return.  end. end. end.
 if.  (1,<:y) ([: -. +./@:e.~) c y&|@^ 2 ^ >:i.<:#e do. 0 return.  end. end. end.
 1
)


MillerRabin1=: 100&$: : (4 : 0) " 0
 if. 0=2|y do. 2=y return. end.
 if. 74>y do. y e. i.&.(p:^:_1) 74 return. end.
 e=. huo y-1
 for_a. x witnesses y do. if. (+./c=y-1) +: 1={: pD c=. a y&|@^ e do. 0 return. end. end.
 1
)

wit =: >:@:([ ?@$ <:@])
wit1 =: >:@?@<:
modexp =: 1 : (':';'x m&|@^ y')
randmodexp =: 4 : '(>: ? <: x) x&|@^ y' 
magicmodexp =: 4 : '3825123056546413051x x&|@^ y'
MR1e=: 3 : '-.@:(] ( ([:+./ <:@[ = ]) +: 1 = {:@])"1 (wit1) (y modexp)"0 1 huo@<:) y'
MR1i=: -.@:(] ( ([:+./ <:@[ = ]) +: 1 = {:@])"1 ] randmodexp"0 1  huo@<:) f.
MR1e2 =: 3 : '-. (([:+./ <:@[ = ]) +: 1={:) y randmodexp huo y-1'
MRtail =: 3 : '0 = e ( (1, <:@] ) -.@(+./)@:e.~ ] y&|@^ 2 ^ >:@:i.@#@:[)^:( (1, <:@] ) -.@(e.~) ])  (wit1 y) y&|@^ {: e =. huo y '
FermatFQ =: 3 : '(1 ,y-1) e.~ 3825123056546413051x y&|@^ <.@-:^:(0 = 2&|)^:_ <: y'"0
FermatQ2 =: 3 : '(<:y)  ( (1 = ])  +.  =)  3825123056546413051x y&|@^ <:y'"0
FermatQ =: 3 : '(1 , y-1) e.~ 3825123056546413051x y&|@^ <: y'"0
Fermat =:  (( 1 ,<:) e.~ ] magicmodexp <:)"0
MR1 =: MRtail
PrimeMod =:  (]) (] #~  [: -. [: +./0 = |"0 1) [: >:@:i. [: */ ] NB. pass y as p: i.4 for mod210
NB. PrimeMod 91 2 3 5 7 11 13  NB. allows for near 19 bit field for remainder, and 21.4 bit divider.
NB.    2^. 91 * # PrimeMod 2 3 5 7 11 13 17 = almost 23bits n = 25.4694 bits
lvl =: */ 2 3 5 7 11 13 17 91x
Pow23 =: PrimeMod 2 3 5 7 11 13 17
indexinPrimeMod =: 4 : 0 NB. find the compressible index of x within list of PrimeMod y (without computing PrimeMod)

)
compressRSA =: 3 : 0
NB. uses serpinski series c + k * 2&^ n
NB. where n is at least 25.4694 and a t most rsa bits with more likelyhood of being small than large
NB. k is odd. at least bits % 2^n at most bits % 2^n-1
NB. c is a number in list ((*/2 3 5 7 11 13 17) * i.91) +/ PrimeMod 2 3 5 7 11 13 17
(<. pD 2x ^. y) $: y
:
nump =. # Pow23
r =. y - 2x ^ x
  ( nump * <. (lvl % 91) %~  lvl  | r) + (Pow23 i. (lvl % 91) | r) , s=. <. lvl %~ r
)
decompressRSA =: 4 : 0 NB. x is minimum bit size
'r c' =. pD y
pD nump =. # Pow23
(2x^x) + (  (lvl % 91) *   <. nump %~ r ) + ((pD nump | r)  {Pow23) + c * lvl  
)
maybePrimeMod210 =: 211 ,~ 2 3 5 7 (] #~  [: -. [: +./0 = |"0 1) 1+i.210
maybePrimeMod420 =: 421 ,~ 2 2 3 5 7 (] #~  [: -. [: +./0 = |"0 1) 1+i.420
quicknextcandidate =: ((- 210&|@:]) + maybePrimeMod210&([ {~ [ I.`(>:@:I.)@.(e.~) 210&|@:])"1 )
nextprime =: quicknextcandidate^:(-.@(1&p:))^:_@:quicknextcandidate
nextprime2 =: quicknextcandidate^:(-.@(1&MillerRabin))^:_@:quicknextcandidate
nextprime3 =: quicknextcandidate^:(-.@(3&MillerRabinX))^:_@:quicknextcandidate
nextprime4 =: quicknextcandidate^:(-.@(1&MillerRabinX))^:_@:quicknextcandidate
nextprime40 =: quicknextcandidate^:(-.@(40&MillerRabin))^:_@:quicknextcandidate
nextprime3x =: quicknextcandidate^:(-.@(23&MillerRabinX))^:_@:quicknextcandidate
nextprimeQ =: quicknextcandidate^:(-.@(MillerRabinQ))^:_@:quicknextcandidate
nextprimeQ1 =: quicknextcandidate^:(-.@(MillerRabinQ1))^:_@:quicknextcandidate
nextprimeF =: quicknextcandidate^:(-.@(Fermat))^:_@:quicknextcandidate
nextprimeFQ =: quicknextcandidate^:(-.@(FermatQ))^:_@:quicknextcandidate


coclass 'cipher2'
coinsert 'hashutil'
coinsert 'OOP'
NB. requires zutil or OOP/typesys for amdt.
amend =: 2 : 0  NB. v is n or n{"num
s=. v"_ y
(u (s{y)) (s}) y 
:
s=. x v"_ y
(x u (s{y)) (s}) y 
)
NB. from http://en.wikipedia.org/wiki/Spigot_algorithm where x is 2, and y is k'th bit of ln 2
NB. can be used with any x.  slow with large y.  Produces wide fractional number (randomish)
 iofLn =: (([: +/ [: % ((1+i.11) ^~ [) * (1+i.11) + ]) + 1 | [: +/ >:@:i.@] %~ >:@:i.@] | [ ^ ] - >:@:i.@])~"0 0
NB.  #: 2x (256&( <.@*))@:iofLn 77
NB. 412123123123111112123x (4294967296&([ | <.@*))@:iofLn 43
NB. 16x (256&( <.@*))@:iofLn"0~ 4118 + i.16 16
NB. x is bits y is seed
bitsLnRNG =: (2x^[) ([ | <.@*) <.@-:@:x:@:[ iofLn ]
bitsLnRNGSlow =: 1 : '(2x^{. x: m)  |  (+/ x: m) bitsLnRNG x:'

NB.require 'openssl'
enc2 =:  ~.@:[ /:~ ] </.~ #@:] $ [ 
enc =: ;@:enc2
split =: ] </.~ ~.@:[ #~ ~.@:[ /:~ [: #/.~ #@:] $ [
pop=: 4 : 'o=. i.0  for_i. x do. y=. }. each amend i y [ o=. o,{. i {:: y  end. y (,<) o'
NB. pop=: 4 : 'o=. i.0  for_i. x do. y=. }.@:] each amdt i y [ o=. o,{. i {:: y  end. y (,<) o'
dec =:  >@{:@:(($~ #) pop  split)

genkey =: (0,~>: i.13) (] , [ #~ -.@e.) 14 #.inv */@:x:  NB. generates anagram key at least 13 base-14 digits long 8e14+ possibilities.
encB =: [: tb64 genkey@:[ ([ enc (' ' #~ #@[) {:@:,: ]) ] NB. functions to simplify use with numeric keys.
decB =: dltb@:(genkey@:[ dec fb64@:])
encB3 =: encB^:3 
decB3 =: decB^:3
NB.encX =: ([: tb64 (genkey@:[  enc  ]) (22 b.)&.(a.&i.)  a. {~ (127 , #@:]) bitsRndR2_RNG_~ 14 #. genkey@:[)
encX =: ([: tb64 (genkey@:[  ([ enc (' ' #~ #@[) {:@:,: ])  ]) (22 b.)&.(a.&i.)  a. {~  genkey@:[ ((127 , >./&#) bitsRndR2_RNG_~ 14 #. [) ])
decX =: dltb@:(genkey@:[ dec fb64@:] (22 b.)&.(a.&i.)  a. {~ (127 , #@:fb64@:]) bitsRndR2_RNG_~ 14 #. genkey@:[)
 
NB. words numbers password format. returns product after conversion.
splitpwToN =: 1&$: : (*  [: */@:(x:@:(0&{::) , [: ; [: (256x #.  a.&i.) each [: ;: 1&{::) splitpw)
Nproof =: 14x #. [: ({.~  100 <. 4r5 >.@* #) genkey
FRCparse =:  4 : 0 NB. use Nproof y to hide original key.
NB.'n t' =.  y
NB.pD ,. q: each n =. (x: n) , ; (256x #.  a.&i.) each ;: t 
'cannot be 0 in list' assert 0 < pD 2 ^.*/ y  [ pD 'key bits:'
 NB. nn =. ({.~  100 <. 4r5 >.@* #) genkey y
 nn =.genkey y
 n14 =. genkey 14#. 14 {. nn NB.genkey y
NB.genkey 
NB.pD 'proof key ' ,": 14 #. nn
NB. 'should be a total of at least 5 words+numbers' assert 4 < # n 
o =. (14x #. nn) encB3 100  $^:(> #) a=. x , ' ', n14 encB (# n14) $^:(> #)  x 
pD 'plaintext: ',  a
NB. pD (14x #. nn) decB3 o
'Decryption check failed: ' assert (dltb 100  $^:(> #) a ) -:   (14x #. nn) decB3 o
o

)
FRCproof =: 4 : 0 NB. pass Nproof y (of FRCparse)
 nn =.genkey y
NB. n14 =. genkey 14#. 14 {. 14#. inv y
n14 =. genkey 14 #. 14 {. genkey y
 o =. (14x #. nn) encB3 100  $^:(> #) a=. x , ' ', n14 encB (# n14) $^:(> #)  x 
)