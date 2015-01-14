require 'dll'
NB. require 'shards'
sslp =: IFWIN pick '';'D:\OpenSSL-Win64\bin\'
sslp =: IFWIN pick ''; '/',~ jpath '~bin'  NB. with J802.  cut this line if you wish to point to downloaded folder
NB. OPENSSL =: jpath '~system/ssleay32.dll '
NB.OPENSSL =: sslp , '\ssleay32.dll '
OPENSSL =: sslp , (IFIOS + (;: 'Win Linux Android Darwin') i. <UNAME_z_) pick 'libeay32.dll '; (2 $ <'libssl.so.1.0.0 '),  (2 $ <'/usr/lib/libssl.dylib ')
NB.OPENSSL =: sslp , (IFIOS + (;: 'Win Linux Android Darwin') i. <UNAME_z_) pick 'libeay32.dll '; (2 $ <'libssl.so ');  (2 $ <'libssl.0.9.8.dylib ')

SSLE =: sslp , '\openssl'
ssl =: 1 : '(OPENSSL , m)&cd'
RSAbits =: 64
RSApE =: 3 ] 65537
sslsha256 =: ' SHA256 i *c l *c' ssl
sslsha512 =: ' SHA512 i *c l *c' ssl
sslsha1 =: ' SHA1 i *c l *c' ssl
sslRIPEMD160 =: ' RIPEMD160 i *c l *c' ssl
sslRMD160 =: (IFWIN {:: ' RIPEMD160 > + x *c x *c';'RIPEMD160 > x *c x *c')  ssl
sslSha256 =: (IFWIN {:: ' SHA256 > + x *c x *c';'SHA256 > x *c x *c')  ssl  NB. SHA256 i *c l *c' ssl
sslSha512 =: (IFWIN {:: ' SHA512 > + x *c x *c';'SHA512 > x *c x *c')  ssl
sslSha1 =: (IFWIN {:: ' SHA1 > + x *c x *c';'SHA1 > x *c x *c')  ssl
sslMD5 =: (IFWIN {:: ' MD5 > + x *c x *c';'MD5 > x *c x *c')  ssl


tobyte64 =:  (8 # 256) #: ]
tobyte32 =: (4 # 256) #: ]
int32hash =: (_4 tobyte32 inv\ a.i.])@:
int64hash =: (_8 tobyte64 inv\ a.i.])@:
b64hash =: tobase64@:
hexhash =: ( [: ,@:hfd a.i.])@:
bighash =: (256x #. a. i. ])@
listhash =: (a. i. ])@:  NB. fastest
int64hash =: listhash ((_8 (256x&#.)\ ])@:) NB. slower but more compatible.
int32hash =: listhash ((_4 (256x&#.)\ ])@:)


sr160=: 3 : 0
output=: (20) # ' '
sslRIPEMD160 (y);(# y);output
output
)
sr160=: 3 : 0
sslRMD160 (y);(#y);md=. 20#' '
md
)

sha1 =: 3 : 0
output=: (20) # ' '
sslsha1 (y);(# y);output
output
)
sha1=: 3 : 0
sslSha1 (y);(#y);md=. 20#' '
md
)
sha12=: 3 : 0
sslSha1 (y);(# , y);md=. 20#' '
md
)

md5 =: 3 : 0
sslMD5 (y);(# , y);md=. 16#' '
md
)


S512 =: 3 : 0
output=: (64) # ' '
sslsha512 (y);(# y);output
output
)

s512=: 3 : 0
sslSha512 (y);(#y);md=. 64#' '
md
)
s256 =: 3 : 0
output=: (32) # ' '
sslsha256 (y);(# y);output
output
)
s256=: 3 : 0
sslSha256 (y);(#y);md=. 32#' '
md
)
dfh =: 16x #. 16 | '0123456789ABCDEF0123456789abcdef' i. ]

3 : 0 ''  NB. needs better fix for 32bit
if. IFWIN *. -. IF64 do.
 s256 =: [: {&a. 256x #. inv [: dfh 'sha256'&gethash
 s512 =: [: {&a. 256x #. inv [: dfh 'sha512'&gethash
end.
1
)
   gethashA =: 1 : 0
y=. ,y
c=. '"',libjqt,'" gethash ',(IFWIN#'+'),' i *c *c i * *i'
'r m y w p n'=. c cd (tolower m);y;(#y);(,2);,0
res=. memr p,0,n
if. r do.
  res (13!:8) 3
end.
res
)
NB. not exact spec.  repeats key with $ instead of 0 pad.
NB. x is key y is message.
hmac =: 1 : 0  NB. constant blocksize 64. u is hashfunction that produces binary
 NB. dumb: ] ([: u {.@:] , [: u hexhash [ ,~ {:@:])  256x afd@:#. (92 54) (22 b.)/ 64 $ listhash [: u hexhash^:(64 > #) [
] ([: u {.@:] , [: u [ ,~ {:@:])  256x afd@:#. (92 54) (22 b.)/ 64 $ listhash [: u^:(64 > #) [
)
BNctxnew =: ' BN_CTX_new *l' ssl
BNnew =: ' BN_new *i' ssl
BNmul =: ' BN_mul i *x *x *x *x' ssl
NB. BIGNUM *BN_bin2bn(const unsigned char *s,int len,BIGNUM *ret)
BN2bn =: ' BN_bin2bn *x *c l *x' ssl
NB. int	BN_bn2bin(const BIGNUM *a, unsigned char *to)
BN2bin =: ' BN_bn2bin l *i *c' ssl
BNnum_bytes=: ' BN_num_bytes i *x' ssl
NB. char *BN_bn2dec(const BIGNUM *num)
BN2dec=: ' BN_bn2dec c *i' ssl
NB. int BN_dec2bn(BIGNUM **num, const char *str)
dec2BN=: ' BN_dec2bn i *x *c' ssl

dec2bn=: 3 : 0
 o =. >BNnew 0{.a.
i=. dec2BN o;(":y)
<o
)

bn2dec=: 3 : 'c=. BN2dec (y)'



bn2bin =: 3 : 0
len =. BNnum_bytes y
o =. len # '0'
i =. BN2bin y;o
o
)
bin2bn =: 3 : 0
len =. # a=. 2 #. inv y

o =. (len%8) #' '  NB.>BNnew 0{.a.file:///D:/j802/addons/graphics/bmp/bmp.ijs
pD i =. BN2bn o;len;(a)
pD i =. BN2bn o;len;''
o
)

Bmul =: 4 : 0
r =. BNnew 0
pD i =. BNmul (r);(x);(y);BNnew 
r
)

BASE64=: (a.{~ ,(a.i.'Aa') +/i.26),'0123456789+/'

NB. =========================================================
NB.*tobase64 v To base64 representation
tobase64=: 3 : 0
res=. BASE64 {~ #. _6 [\ , (8#2) #: a. i. y
res, (0 2 1 i. 3 | # y) # '='
)
tb64 =: ('=' #~  0 2 1 i. 3 | # )  ,~ BASE64 {~  [: #. _6  ]\    (8#2) ,@:#: a.&i. 
tob64 =: 3 : '(''='' #~  0 2 1 i. 3 | # y)  ,~ BASE64 {~  #. _6  ]\    (8#2) ,@:#: a.&i. y'
t2b64 =: 3 : '(''='' #~  0 2 1 i. 3 | # y)  ,~ res=. BASE64 {~  #. _6  ]\    (8#2) ,@:#: a.&i. y'

NB. =========================================================
NB.*frombase64 v From base64 representation
frombase64=: 3 : 0
pad=. _2 >. (y i. '=') - #y
pad }. a. {~ #. _8 [\ , (6#2) #: BASE64 i. y
)
fb64 =: (_2 >. ( i.&'=') - #) }. a. {~ [: #. _8 [\ [: , (6#2) #: BASE64&i.

coinsert 'jtask'

Cdefs =: 0 : 0

typedef int evp_sign_method(int type,const unsigned char *m,
			    unsigned int m_length,unsigned char *sigret,
			    unsigned int *siglen, void *key);
typedef int evp_verify_method(int type,const unsigned char *m,
			    unsigned int m_length,const unsigned char *sigbuf,
			    unsigned int siglen, void *key);

)




pD_z_ =:  1!:2&2
ORdef_z_ =: ".@[^:(_1< 4!:0@<@[)
defaults1 =: ([`]@.(0=#@>@[))
defaults =: defaults1"0 0 f.
Boxlink =: boxopen each@:,&<
rangei =: [ +  >:@] i.@- [
NB. x is low;high boxed an additional layer if they will be compared to boxed data.
takerange =: 4 : ('''a b'' =. x';'(a i.~ y) rangei b i.~ y')
dfhx =: 16x #. 16 | '0123456789ABCDEF0123456789abcdef' i. ]

appdir =: 'DIR_application_' ORdef jpath '~system'

newandgetrsa =: 4 : 0
y =. >y defaults < appdir ,'/nbmember'
NB. 'ec rsa '=. x newkeys y
(a.{~ expandpw x) nkrsa y
'd p q' =. 1 2 3 { rsakeyparams y
n =. p*q 
pD c=. x (] (22 b.) #@]  $ expandpw@[) _2 dfh\ d
pD (3!:1 c) fwrite  y , 'rsa.enc'
d =. dfhx d
RSAn =: n
RSAsign=: RSAn&|@^ 
RSAsignP =: [ (RSAsign f.) a: getprivrsa~ ]
RSAverifyself=: RSApE RSAn&|@^~ ]
d ; RSAn 
)

getprivrsa =: 4 : 0
y =. y defaults appdir ,'/nbmember'
dfhx ,hfd x (] (22 b.) #@]  $ expandpw@[) 3!:2 fread y, 'rsa.enc'
)

RSAverify=: 4 : 'RSApE x&|@^~ y'

newkeys =: 4 : 0
NB. y =. y defaults 'member'
p =. a.{~ expandpw x
p (nkec ;nkrsa) y



NB. tobase64 a.{~_2 dfh\
NB. pubh ;pubrsa
)

nkec =: 4 : 0
p =. tobase64 x
_1 fork SSLE , ' ecparam -out "', y ,'par.pem" -name secp256k1 -conv_form compressed -genkey' NB. delete unencrypted later
NB.6!:3 ] 5
_1 fork SSLE , ' ec -in "', y ,'par.pem" -bf-cbc -passout pass:',p,' -out "', y,'ec.pem"'
NB.6!:3 ] 5
_1 fork SSLE , ' ec -in "', y,'ec.pem" -passin pass:',p,' -pubout -out "',y,'ecpub.pem"'
NB. 6!:3 ] 5
pD l =. <;. _2 hex =: spawn SSLE , ' ec -in "', y ,'ec.pem" -passin pass:', p , ' -text'
privh =. ,> }:^:(':' = {:) each  (#~ 0 ,@:-.@:=$&>)  , ;: > 2 3 4 { l
pD pubh =.  a.{~ _2 dfh\   ,> }:^:(':' = {:) each  (#~ 0 ,@:-.@:=$&>)  , ;: > 6 7 8 9 10 { l
(3!:1 pubh) fwrite  y,'ecpub.hex'
pubh
)

nkrsa =: 4 : 0
_1 fork SSLE , ' genrsa ',((3=RSApE) {'  ' ,:'-3'), ' -out "', y ,'rsa.pem" ' , ": RSAbits NB. delete unencrypted later
_1 fork SSLE , ' rsa -in "', y ,'rsa.pem"  -pubout  -out "', y ,'rsapub.pem"'
pD l =. <;. _2 hex =: spawn SSLE , ' rsa -pubin -in "', y ,'rsapub.pem" -text'
pD pubrsa =. a.{~ _2 dfh\ ,> }:^:(':' = {:) each  (#~ 0 ,@:-.@:=$&>)  , ;: > ('-----BEGIN PUBLIC KEY-----' Boxlink '-----END PUBLIC KEY-----') (}.@:}:@:takerange { ]) l
(3!:1 pubrsa) fwrite  y,'rsapub.hex'
pubrsa
)

rsakeyparams =: 3 : 0
NB. y =. y defaults '"', appdir ,'/','memberrsa.pem"'
l =. <;. _2 hex =: spawn SSLE , ' rsa  -in "',y,'rsa.pem" -text'
NB.pEt =:  '65537 (0x10001)'
pEt =: deb (3 = RSApE) { '65537 (0x10001)',:'3 (0x3)' 
pD l
pD ]m =. dfhx ,> }:^:(':' = {:) each  (#~ 0 ,@:-.@:=$&>)  , ;: > ('modulus:' Boxlink 'publicExponent: ',pEt) (}.@:}:@:takerange { ]) l
pD ]d =. ,> }:^:(':' = {:) each  (#~ 0 ,@:-.@:=$&>)  , ;: > ('privateExponent:' Boxlink 'prime1:') (}.@:}:@:takerange { ]) l
pD ]p =. dfhx ,> }:^:(':' = {:) each  (#~ 0 ,@:-.@:=$&>)  , ;: > ('prime1:' Boxlink 'prime2:') (}.@:}:@:takerange { ]) l
pD ]q =. dfhx ,> }:^:(':' = {:) each  (#~ 0 ,@:-.@:=$&>)  , ;: > ('prime2:' Boxlink 'exponent1:') (}.@:}:@:takerange { ]) l
pD ]e1 =. dfhx ,> }:^:(':' = {:) each  (#~ 0 ,@:-.@:=$&>)  , ;: > ('exponent1:' Boxlink 'exponent2:') (}.@:}:@:takerange { ]) l
pD ]e2 =. dfhx ,> }:^:(':' = {:) each  (#~ 0 ,@:-.@:=$&>)  , ;: > ('exponent1:' Boxlink 'exponent2:') (}.@:}:@:takerange { ]) l
pD ]c =.  dfhx ,> }:^:(':' = {:) each  (#~ 0 ,@:-.@:=$&>)  , ;: > ('coefficient:' Boxlink '-----BEGIN RSA PRIVATE KEY-----') (}.@:}:@:takerange { ]) l
NB.'m d p q e1 e2 c' =. ([: dfhx@:,@:> [: }:^:(':' = {:) each [: (#~ 0 ,@:-.@:=$&>) [: , [: ;: >) each Boxlink/
m;d;p;q;e1;e2;c
)

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
afd =: (a.{~ 256&#. inv) f. 
dfa =: (256x #. a. i. ]) 
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

expandpw1 =: 256&$@:(255&- ,])@: ( favorites  ([ (, ,) (22 b.)"0 1 , ])  (a. i. ]) ) 
expandpw2 =: 256&$@:(255&- ,])@: ( ([: ; 256 #.inv each [)  ([ (, ,) (22 b.)"0 1 , ])  (a. i. ]) ) 
expandpw3 =: 5 32&$@:(255&- ,])@: (  (favorites ,~ [: ; 256 #.inv each [)  ([ (, ,) (22 b.)"0 1 , ])  (a. i. ]) ) 
expandpw =:   (favorites ,~ [: ; 256 #.inv each [)  ([ (, ,) (22 b.)"0 1 , ])  (a. i. ]) 
expandpwF =:   (favoritesF ,~ [: ; 256 #.inv each [)  ([ (, ,) (22 b.)"0 1 , ])  (a. i. ]) 
 parsepwC =: (2  : 0) 
'enter at least one space, a leading non number, and use trailing number(s)' assert 1<# ;: y
(0&".@:>@:{: (256| +/)@:((n $ [: u listhash ":@:expandpw) ,  (5 ,n) $ expandpw) ;@:}:) ;: y
)
parsepw =:  s512 parsepwC 61
splitpw =:  (;: inv@:}: ;~  a:&+^:(-: 0:)@:(0&".)@:>@:{:)@:;:@:(-.&'''' ) :: ('needs a trailing number greater than 0'"_)
itemsbetween =: 2 : '((m >:@i.~ y) , n <:@i.~ y) (takerange { ]) y'

NB. secure RNG depends on whether numbers are published or discoverable.  Returned number range should be 30 bits less than period for basic security, but there are ways of guessing seed range.
NB. adding to gbflip allows a period increase of 2^55.
lcG =: 2 : '( ] | n assign (1-~2x^m) | 48271x * 3 : n)"0'  NB. generates a random generator verb using a var ('seed') as n.  m should be a mersenne prime exp, 31 61 89 107 127 521 607
NB.lcG4 =: 2 : ' ] |  n (][ [ assign ([: +/@:RawRnd31 2:) + ]) 48271x  ((1-~2x^m) |  *) 3 : n' NB. variation that sets seed different than return val.
lcG4 =: 2 : ' ] |  n (][ [ assign ( {.@RawRnd31@1:) + ]) (n~ + 48271x)  ((1-~2x^m) |  *) 3 : n' NB. variation that sets seed different than return val.
lcG31 =: 1 : '(]| m (][ [ assign ( {.@RawRnd31@1:) + ]) 48271x  (2147483647 |  *) 3 : m)"0'
lcG61 =: 1 : ']| m (][ [ assign ( {.@RawRnd31@1:) + ]) 48271x  (( x: inv ^:IF64 2305843009213693951x) |  *) 3 : m'

NB. lcG4 =: 2 : ' ] |  n (][ [ assign ([: +/@:RawRnd31 2:) + ]) 48271x  ((1-~2x^m) |  *) 3 : n' 
NB. set consistent between 32/64bit versions IF64
RawRnd31 =: ((] {. [: , [: }:("1) _3 ,\ [: 128!:(4) 3 * 2 >.@%~ ])"0)`(( ] {. 2147483647 ,@:(17 b. ,. [ 17 b. (>: @[)  <.@%~]) [: 128!:(4) 2 >.@%~ ])"0)@.IF64
initRND =:  3 : 0
31 initRND y
NB.roll =: 'seed' lcG31
NB.seed =: y + */ RawRnd31 2 [ 9!:1  y [ (9!:43) 1
: 
seed =: (2x ^ x-3) + y + */ x:^:(-. IF64) RawRnd31 2 [ 9!:1  (2x^31) | y [ (9!:43) 1
select. x case. 31 do. roll =: 'seed' lcG31"0 case. 61 do.  roll =: 'seed' lcG61"0 case. do. roll =: x lcG4 'seed'"0 end.
seed
) 
rollbits =: 3 : 'roll 2x ^ y'
rollpad =: 3 : 'roll each y $ each 256'
bitsRnd =: 3 : 0"0
m =. 2x^ 31 (| , <.@%~ # [) y
(2147483648x #. (2x^{.) #: (amend 0) RawRnd31@:#)  m
)
bitsRnd =: (2147483648x #.  (2x^{.) #: (amend 0) RawRnd31@:#)@:(31&(| , <.@%~ # [))"0
bitsRndS =: ([: 9!:1  (2x^31) | [ [ [: (9!:43) 1:) bitsRnd@] ]
bitsRndC =: 4 : 0 NB. x is seed y is bits
xp =. 2x >.@%~ {.y
x =. x: x
 x initRND~ s =.  xp ((],{:@:] ) {~   1 i.~ <)  31 61 89 107 127 521 607 1279 2203x
NB. pD seed
NB.s initRND (bitsRnd + rollbits) (+ ?) xp
s initRND (bitsRnd + rollbits)  (+ ?) xp
o =. i.0
for_i. y do.
NB.o=. o , (2x&^ | (bitsRnd i) + [: roll 2x ^ xp"_) i 
o=. o , (2x&^ | bitsRnd + rollbits) i 
end.
o [ 61 initRND seed|~ 2x^48
)
bitsRndR =: 4 : 0 NB. x is seed y is bits
xp =.  {.y
x =. x: x
 x initRND~ s =.  xp ((],{:@:] ) {~   1 i.~ <)  31 61 89 107 127 521 607 1279 2203x
 (bitsRnd + rollbits) y NB. can overflow requested bits.  use roll instead for specific range.
)

bitsRndR2 =: 4 : 0 NB. x is seed y is bits, then num bytes to return
xp =.  {.y
x =. x: x
 x initRND~ s =.  xp ((],{:@:] ) {~   1 i.~ <)  31 61 89 107 127 521 607 1279 2203x
 rollbits 8 #~ }. y NB. can overflow requested bits.  use roll instead for specific range.
)


lcG64 =: 6148914537289504899x&((x: inv^:IF64 9223371812008258273)  | *)
genqpn4 =: 3 : 0
'p q' =. x: 2{. <: 12 * (, ] +  +:@>.@%:)y
assert. q > p
while.  1 -.@p: p do. p=.p+12 end.
NB.if. q<:  a=. <: >.&.(%&12) p + 2 >.@* >.@%: >.@%: p do. q=. a end. NB. should not be that many passes as initial q  passed test
if. q<:  a=. <: >.&.(%&12) p +  +:@>.@%: p do. q=. a end. NB. should not be that many passes as initial q  passed test
while.  1 -.@p: q do. q=.q+12 end.
p,q
)
genqp12 =: 3 : 0
'p q' =. <: 12 * y
assert. q > p
while. -.@MillerRabinQ1 p do. p=.p+12 end.
while. -.@MillerRabinQ1 q do. q=.q+12 end.
p,q
)

genq =: 3 : 0
p =. x:  <: 12 * y
q =. <: 12 * p +  p bitsRndC 2 <.@^. p 
assert. q > p
while.  1 -.@p: p do. p=.p+12 end.
if. q<:  a=. <: >.&.(%&12) p +  +:@>.@%: p  do. q=. a end. NB. should not be that many passes as initial q  passed test
while.  1 -.@p: q do. q=.q+12 end.
p,q
)
gpqr =: 4 : 0 NB. x is bits, y is seed
 'p q' =. pD \:~ y bitsRndC 2 $ x
 q =. q + p <.@% 2 
while. q < 1.05 * p do.  q=.(bitsRnd + rollbits) {.x end.
genqp12 p,q
)
gpqr =: 4 : 0 NB. x is bits, y is seed
'p q' =. \:~ y bitsRndC 2 $ x
 q =. q + p <.@% 2 
while. q < 1.05 * p do.  q=.(bitsRnd + rollbits) {.x end.
genpqW p,q
)
gpqs =: 4 : 0 NB. x is bits, y is seed
'p q s' =. 3+4*2 ,@:(+\. , +/@:]) \:~ y bitsRndC 3 $ x
while. -.@MillerRabinQ p do. p=.p+4 end.
while. -.@MillerRabinQ q do. q=.q+4 end.
while. -.@MillerRabinQ s do. s=.s+4 end.
p,q,s
)
genpqW =: 3 : 0 NB. Q1 only for large numbers.
'p q' =. 3 _1 + 8 * y
assert. q > p
while. -.@MillerRabinQ1 p do. p=.p+8 end.
while. -.@MillerRabinQ1 q do. q=.q+8 end.
p,q
)
NB. can be 2bits less than (8)byte boundary. as sig adds 2 bits. pad is 1 + 8x where x is bytes padded.
gencompressedN =: 4 : 0 NB.y is seed x is bits of n, safepadbits.  bits of n should be mult of 2
'nb pad' =. 2 {. x , 17x
 n =. 2x^ nb 
aa=.#.  a=. x: (0 #~ nb - a),~ 1 #~ a=. (nb <.@% 2) - pad
 y bitsRndR nb >.@% 2
r4n =.   8 <.@%~ #. 2 (1 1x , 0#~ 2 -~ <.@%~) nb NB.16 %~ 2x ^ nb <.@% 2x
NB. pD  roll f. ;lrA
r4n =. r4n - roll r4n >.@% 3
r4n8 =.  r4n  >.@% 4r3 NB. - 2x ^ nb <.@% 4 NB.
p =. 3 + 8 * r4n - roll r4n8
while. -.@MillerRabinQW p do. p =. 3 + 8 * r4n - roll r4n8 end. NB.3 + r4n * 8 * roll r4n8 end.
  ql =. p >.@%~ 8 %~ aa
  qu =. p >.@%~ 8 %~ n
r =. qu - ql
NB. y bitsRndR 2 >.@^. r  NB. no need to reset 
q =. 1 -~ 8* ql + a=. roll r
die =. 0
while. -.@MillerRabinQW q do. a=.a+1 
if. a> r do. 'regenerate with new password/seed/padding' assert die = 0 
die =. 1 [ a =. 0 [ q =. 1 -~ + 8 * ql + 1 else. q =. q+8 end. end.NB.q =. 1 -~ 8* ql + roll r end.
assert. n >  b=. p * q
assert. aa < b
assert. 0 = 8 | 5 -~ b-aa
p,q, 8 <.@%~ 5 -~ b-aa
)
FixCompressedN =: 4 : 0
'nb pad' =. 2 {. x , 17x
'p q n' =. y
n =. x decodeN n
if. -. 5 MillerRabin p do. p=. p+8 
pD 'Fixing... p but more secure to regenerate' while. -.@MillerRabinQW p do. p =. p+8 end. end.
if. -. 5 MillerRabin q do. p=. q+8 
pD 'Fixing... q but more secure to regenerate' while. -.@MillerRabinQW q do. q =. q+8 end. end.
'key was unfixable.  Must Regenerate with different password.' assert (2x ^ nb) > b =. p*q 
aa=.#.  a=. x: (0 #~ nb - a),~ 1 #~ a=. (nb <.@% 2) - pad
p,q,  8 <.@%~ 5 -~ b-aa
)

decodeN =: 4 : 0
'nb pad' =. 2 {. x , 19x
aa=.#.  a=. x: (0 #~ nb - a),~ 1 #~ a=. (nb <.@% 2) - pad
5+ aa+ 8*y
)
encodeN =: 4 : 0 NB. just used for tests
'nb pad' =. 2 {. x , 19x
n =. 2x^ nb
aa=.#.  a=. x: (0 #~ nb - a),~ 1 #~ a=. (nb <.@% 2) - pad
b =. n-3
assert. 0 = 8 | 5 -~ b-aa
pD 256 #. inv o =. 8 <.@%~ 5 -~ b-aa
o
)
NB. uses RSA math (totient of p*q relationship)
lcGR =: 1 : 0 NB. m is a random or chosen number.  Will create a random number generator with period slightly higher than (2-~m*12)^2, and range of approximately (12+y)^2
NB. can optionally provide pair as m. if pair, should be sorted
NB. will hang if you don't pass large extended numbers.ie 1e23 will hang
'p q' =. genqpn4`genq@.(1=#) m 
d =. 3 invmod~ */ <: p,q

d&((p*q) | *) 
)
NB. intentionally slow lCG gen
lcGPrime =: 1 : 0 NB. Gens a prime lcg based on seed and bits
's bits' =. m
p=. 11 + 12 * s bitsRndR bits
while. -.@MillerRabinQW p do. p =. 11 + 12 * rollbits bits end.
NB. lcG4 =: 2 : ' ] |  n (][ [ assign ( {.@RawRnd31@1:) + ]) (n~ + 48271x)  ((1-~2x^m) |  *) 3 : n'
roll =: (] | 'seed' (][ [ assign ( {.@RawRnd31@1:) + ]) (p|seed) (p|*) 3 : 'seed')"0
)
NB. slow to stop brute force guessing.
Slowbytes =:  4 : 0 NB.x is numbytes # bytes (or range), y is passphrase in splitpw format
'n p' =. splitpw y
bits =. 129 + ^:> >: {: n
(bits ,~ s512 bighash ; ": expandpwF&>/ splitpw y) lcGPrime x
)

lcGPrime2 =: 1 : 0 NB. Gens a prime lcg based on seed and bits , but with y (constant) slowdown factor
's bits' =. m
p=. 11 + 12 * s bitsRndR bits
while. -.@MillerRabinQW p do. p =. 11 + 12 * rollbits bits end.
NB. lcG4 =: 2 : ' ] |  n (][ [ assign ( {.@RawRnd31@1:) + ]) (n~ + 48271x)  ((1-~2x^m) |  *) 3 : n'
roll =: (] | 'seed' (][ [ assign ( {.@RawRnd31@1:) + ]) ((y,~ bits-8) bitsLnRNGSlow  +/ (256 * RawRnd31 2) | p , seed) (p|*) 3 : 'seed')"0
seed
)
NB. slow to stop brute force guessing.
Slowbytes2 =:  1 : 0 NB.x is numbytes # bytes (or range), y is passphrase in splitpw format. m is slowdown factor
:
'n p' =. splitpw y
bits =. 129 + ^:> >: {: n
(bits ,~ s512 bighash ; ": expandpwF&>/ splitpw  y) lcGPrime2 1 >. m - bits
roll x
)

TimeBytes =: 4 : 0 NB. x is range of start,len numbers to be appended to pw, y is pwd in splitpw format
'l u' =. x
c =. 10
r =. c >.@%~ u
(;/ 0 , l + c * i.r) ,. (;/ l + i.c) , (r,c) $ timex each  (<'1 (300 Slowbytes2) ') , each  <"1 ([: quote  y ,"1 ' ' , ":)"0 l + i. r*c
)
getdn =: 3 : 0 NB. Just get d and n
NB.'p q' =. genqpn4`genq@.(1=#) y 
'p q' =. genqpn4 y 
d =. 3 invmod~ */ <: p,q
NB.d&((p*q) modmult) 
NB. d&((p*q) | ] + *) 
d,((p*q) ) 
)
lcGS =: 1 : 0 NB. m is a random or chosen number.  Will create a random number generator with period slightly higher than (2-~m*12)^2, and range of approximately (12+y)^2
NB. can optionally provide pair as m. if pair, should be sorted
NB. will hang if you don't pass large extended numbers.ie 1e23 will hang
'p q' =. x: 2{. <: 12 * (, ] + 6 >.@%~ >.@%:)m 
assert. q > p
while.  1 -.@p: p do. p=.p+12 end. NB. improve with miller rabin tests
if. q<:  a=. <: >.&.(%&12) p + 2 >.@* >.@%: >.@%: p do. q=. a end. NB. should not be that many passes as initial q  passed test
while.  1 -.@p: q do. q=.q+12 end.
d =. 3 invmod3~ */ <: p,q NB. from file rsa.ijs.
nn =. p*q
d (nn | *)  2&+^:([: +./ 0 1 = nn&|)
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

NB. rabin crypto functions p q and derived yp yq needed for decrypt.  n is public p*q. m is message that must be smaller than n.
RCcrypt =: 4 : 'y x modexp 2' NB. x is m, y is n
RCgetypyq =: }.@:gcd2x NB. y is p,q  returns yp,yq
RCdecrypt =: (] RCdecrypt2~ RCdparams@:[)"1 0   NB. y is message to decrypt. x is p q
RCdparams =: */ , ] , RCgetypyq
RCdecrypt2 =: 4 : 0 NB. x is n p q yp yq.  y is encrypted m . p,q need be 3=4&|
'n p q yp yq' =. x
mp =. y p modexp 4%~>:p
mq =. y q modexp 4%~>:q
fp =. yp * p * mq
fq =. yq * q * mp
NB.pD mp,yp,fp,yq, mq,fq
r =. n|fq+fp
s =. n|fp-fq
r, (n-r), s, (n-s)
) 

Pad =: ] * 2x ^ [
UnPad =: (2x ^ [) ([ %~ ] #~ 0 = |) ]

RWdparams =: 3 : 0 NB. */ ,] , ({. | {: ^2-~{.), ] | 2 ^ 8 %~ 11 5 -~ 9 3 * ] NB. y is pq. returns williams precomputes
'p q' =. y
 'a b'=. 8 %~ 11 5 -~ 9 3 * y
 f2 =.  2 p modexp a
 f1 =.  2 q modexp b
 f3 =. q p modexp 2-~p 
 (p*q), y , f3, f2, f1
)
RWdecrypt2 =: 4 : 0
'n p q f3 f2 f1' =. x
u =. y q modexp 8%~>:q
'e f' =. _1 2
if. 0= q|y-~ u ^ 4 do. e=.1 end.
ey=.e*y
v =. ey  p modexp 8%~3-~p
if. 0= p|ey-~ (ey^2) * v ^ 4 do. f=.1 end.
if. 1=f do. W=. q|u  else. W=. q|f1*u end.
if. 1=f do. X=. p|ey*v ^ 3  else. X=. p|f2*ey*v ^ 3 end.
NB.if. 1=f do. X=. (ey*v) p modexp 3  else. X=. (f2*ey*v) p modexp 3 end.
s =.(n| *:) Y=. n| W+q*p| f3 * X-W
NB. pD e,f, Y, s
NB.assert. 0 =y - 
NB. pD n efsquare e,f,s
e,f, s <. n-s
)
efsquare =: (| */ * {:)"0 1 NB.x is mod n, y is e f s Williams "tweaked square roots"
RWencrypt =:  4 : 0"0 NB. adds sqrtn(n is x) then takes negative(n-) if >n/2, and adds sqrtn again.  
s =. >.@%: x
m =. y+s
assert. m < x-s  NB.do. m=. y end.
NB.if. m > x - s do. m =. m-s end. NB. if m was <s, m+s, if m was > n-s, m-2s, if m was >n-2s, m-s
NB. if. m > x >.@% 2 do. m =. x -m + s end.
pD m
m x modexp 2
)
RWdecrypt3 =: (] RWdecrypt2~ RWdparams@:[ )"1 0
RWdecrypt =: 4 : 0
'n p q f3 f2 f1' =. par =. RWdparams x
 s =. 2x^ 2 >.@^. n assert. *./ n> y+2*s
par RWdecrypt2"1 0 y+s

)
Sign =: ((4*{:) +(4 2 $ _1 1 _1 2 1 1 1 2) i. 2&{.)@:RWdecrypt2"1 0
Sign2 =: ((4*{:) +(4 2 $ _1 1 _1 2 1 1 1 2) i. 2&{.)"1@:([ RWdecrypt2 ] + 2x ^ 2 >.@^. {.@:[ )"1 0 NB. pad at source instead.
Verify2 =: RWverify NB. pad at source instead.
Verify =: RWverify2
RWsign =: ((4*{:) +(4 2 $ _1 1 _1 2 1 1 1 2) i. 2&{.)@:RWdecrypt"1 0 
RWsign3 =: 1 : 0
'n p q f3 f2 f1' =. par =. RWdparams m
 s =. 2x^ 2 >.@^. n NB.assert. *./ n> y+2*s
((4*{:) +(4 2 $ _1 1 _1 2 1 1 1 2) i. 2&{.)"1@:(par RWdecrypt2"1 0 s&+)
)
RWsign2 =: ((4*{:) +(4 2 $ _1 1 _1 2 1 1 1 2) i. 2&{.)@:RWdecrypt3"1 0 
RWsign4 =: 1 : 0
'n p q f3 f2 f1' =. par =. RWdparams m
((4*{:) +(4 2 $ _1 1 _1 2 1 1 1 2) i. 2&{.)"1@:(par RWdecrypt2"1 0 x:)
)
RWverify =: >.@%:@[ -~ [efsquare ((4 <.@%~ ]) ,~ (4 2 $ _1 1 _1 2 1 1 1 2) {~ 4&|)"0  NB. dyad x is n, y is encoded e f s. Original sig was for y+ sqrt n
RWverify =: 1 : 0
(2x ^ 2 >.@^. m) -~  m efsquare ((4 <.@%~ ]) ,~ (4 2 $ _1 1 _1 2 1 1 1 2) {~ 4&|)"0 
)
RWverify2 =: efsquare ((4 <.@%~ ]) ,~ (4 2 $ _1 1 _1 2 1 1 1 2x) {~ 4&|)"0 NB. rawsig without + sqrt n
NB. RWverify2 =: 1 : '(m efsquare ((4 <.@%~ ]) ,~ (4 2 $ _1 1 _1 2 1 1 1 2) {~ 4&|)"0)' 


lampq =: ] * }.@:gcd2x  NB. y is pq. ret r1 r2, where r1 is mult of p and 1=q|p*r1. r2 mult of q and 1=p|q*r2
RWLencrypt =: 1 : 0 NB. x is pubkey pq. epsilon y is message
NB.n =.p * q [ 'p q' =.m
 
'n e' =.m
(n | (_1 ^ 1 0 1 {~ [: * n&jacobi) * (e ^ 2&|) * n|*:)"1 0
)
NB. give up on above
RWLencrypt =: 4 : 0"1 0 NB. allows cueless decryption but as expensive as RSA.
assert. x> 4+8*y
if. 1 = x jacobi m2=. x |  >: 2 * y do. (x | *~) 4 * m2  else. (x | *~) 2 * m2 end.
)
RWLdecrypt =: 4 : 0"1 0
n =. p * q [ 'p q e' =. x
d0 =. ( 1 0 1 {~ [: * q&jacobi)  y
d1 =. ( 1 0 1 {~ [: * n&jacobi) y
NB.e =. 4 1 (n | [:-/ *) lampq p,q
NB.pD d0, d1
(p,q) RCdecrypt"1 0  y * (_1 ^ d1)* e ^ - d0
)
RWLparams =: */ ,] , 2 %~ 1+4 %~ <:@{. * <:@{:
RWLdecrypt =: 4 : 0"1 0
'n p q t' =.  RWLparams x 
NB.n =. p * q [ 'p q' =. x
NB. pD (4&|, ])
d =. y n modexp t
select. 4|d
case. 0 do. 2 %~ <: 4%~d
case. 1 do. 2 %~ <: 4%~n-d
case. 2 do. 2 %~ <: 2%~d
case. 3 do. 2 %~ <: 2%~n-d
end.
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
notmult =: %~ ~: <.@%~
ismult =: %~ = <.@%~
issquare =: %: = <.@%:
NB. for compressing signatures take cfx s/n (extended) then expand with (+%)/\ (+%)/\ 30 cfx 45 % 253x
NB. the denominator d in list where d (n | *) s < sqrt of n, is key to replace s. r =. 378877 (169567420181x (] <.-) 169567420181x | * ) 108506016599
NB. verify with  r = sqrt (d^2) (n|*) m  (m is s^2)  ([: %: 169567420181x | [: */ 169567420181x | *: ) 378877 108506016599x
NB. cannot sign multiples of p,q
RCSign =: 4 : 0  NB. finding square (of hash+pad) can be slow but allows half length sig + pad
'n p q yp yq' =. par =. RCdparams x
sq =. <.@%: n
pad =. 0 NB.pad =. 4 ?. 4  NB. must find square. 8 bit pad allows 1e_32 prob of non failure.
NB. while. 1< {. gcd2x n, y+{. pad do. pad =. }. pad end.  NB. must find square
pD r =. ([: ( #~  (sq&>: *. 1&<))"1 [: {:("1)  2 x: [: (+%)/\("1)  20 cfx("0)  n %~ ]) a=. par RCdecrypt2 y + {. pad
for_i. |:r do. pD 'o' ; o=. ([: I. 0&< *. sq&>:) pD b=. i (n (] <.-) n | * ) pD a
if.0<#o do. ({. pad) , y ,  {. pD /:~ (o{i),. o{a [ o =. {. o return. end. end.
)

NB. where msg is n/4 < msg < n/2 bits such as sha512 for 1025 to 2047 bit n then m^2 = n|m^2, but m^4 > n
RCSign =: 4 : 0  NB. finding square (of hash+pad) can be slow but allows half length sig + pad
'n p q yp yq' =. par =. RCdparams x
sq =. <.@%: n
pad =. 3 ? 3 NB.pad =. 4 ?. 4  NB. must find square. 8 bit pad allows 1e_32 prob of non failure.
while. +./ (p, q) ismult y + {. pad do. pad =. }. pad end.
NB. while. 1< {. gcd2x n, y+{. pad do. pad =. }. pad end.  NB. must find square
 r =. ([: ( #~  (sq&>: *. 1&<))"1 [: {:("1)  2 x: [: (+%)/\("1)  20 cfx("0)  n %~ ]) a=. par RCdecrypt2 msg=.n | *: y + {. pad
for_i. |:r do.'o' ; o=. ([: I. 0&< *. sq&>:)  b=. i (n (] <.-) n | * ) a
if.0<#o do.  y  , ({. pad) + 3* {.  /:~ (o{i),. o{a [ o =. {. o return. end. end.
)


NB. theory: what if sign of m^2 instead of m to ensure square instead of jacobi and pad.
NB. pad of 0 1 or 2 allows signing any value. (m+pad)^2 . pad needed to avoid all multiples of p,q. encode m as pad+3 *m decde as (3|m) + m <.@% 3
RCVerify2 =: 4 : 0"1
'pad m s' =. y
(pad+m) (  x |  [ * *:@] ) s NB. if result has integer square root, valid (probably?)
)
RCVerify =: 4 : 0"1
'm s' =. y
pad =. 3 |s
s=. s <.@% 3
msg =. (x|*:) m + pad
pD s, pad, m,  o =. msg (  x |  [ * *:@] ) s NB. if result has integer square root, valid (probably?)
issquare o
)
RCknownpad100 =: ] 
privkey =: 4 : 0

)


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
