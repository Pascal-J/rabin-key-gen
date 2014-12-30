testinvmod=: (0 1 e.~ [| ]* invmod)



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
NB. where n is at least 25.4694 and at most rsa bits with more likelyhood of being small than large
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
