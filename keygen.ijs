1!:44 MYDIR =: getpath_j_  '\/' rplc~ > (4!:4<'thisfile'){(4!:3)  thisfile=:'' NB. boilerplate to set the working directory
APPDATA_keygenform_ =: MYDIR
require MYDIR ,'records.ijs'
require MYDIR ,'openssl2.ijs'
require MYDIR ,'factoring2.ijs'
require 'general/dirutils'  
NB. require MYDIR , 'records.ijs'
require 'languagecodes.ijs'

coclass__OOP 'keygenform'


coinsert 'rabin'
coinsert 'cipher2'
coinsert 'OOP'
NB.coinsert 'record'

 
TYPES_record_ =: TYPES_typesys_ , (9{a.) cut &> cutLF 0 : 0
ispwd	'unconvertable' raiseErr ]		[: notfalse ispwdan_keygenform_		Password must be list of 1 or more words(punctuation ok) followed by 1 or more LIST OF NUMBERS.  List items are separated by spaces
islang	'unconvertable' raiseErr ]		 inlangcode_keygenform_ 		Must be a list of languages either their 2 letter codes, or english name or sometimes ASCII native name. Separated by ;
)
PARAMS =: DEF_record_ 'name `5&mthan ; locations ; date_of_birth num`19000101 23001231&inrange ; languages islang ; email ; password1 str`24&mthan ispwd ; password2 dltb`8&mthan ispwd ; password3 dltb`7&mthan  ispwd; password4 dltb`7&mthan  ispwd;keysizes int `int 2&count'

inlangcode =: (3 : '([: *./ ([: 0:^:(0 = #) [: +./&:> (}. each languages_verification_) e. L:1~  dltb@:toupper each@:boxopen) every)@:boxopen y' '59&cut' c_record_)
SK =: 190 NB. 894
PK =: 198 NB. 1214
SK =: 894
PK =: 1214


ispwdan =:  0 < 0 ". >@{:@:;:

cb =: 3 : 0 
if. a: -: y do. return. end.
if. notfalse keysizes__PARAMS y do. 'sk pk' =. keysizes__PARAMS y else.'sk pk' =. SK, PK end.
'generating salt' hout__co  3 {. y
favorites_passwords_ =: 1 2 3
load 'openssl2.ijs'
favorites_passwords_ =:  favorites =.   256 | _3 +/\  fb64 listhash ((name__PARAMS , ' ', ":@date_of_birth__PARAMS , ' ' , locations__PARAMS ) y) (] encX FRCparse) FavoritesN =: splitpwToN (password1__PARAMS , ' ', ":@date_of_birth__PARAMS) y
load 'openssl2.ijs'
pathcreate APPDATA , 'keys'
  (APPDATA , 'keys/salt.settings')fwrite~  3!:1 favoritesF_passwords_ =: favoritesF =. > ;@:(rollpad@:#22 b.each<)each < (32# 256) Slowbytes 'x ' , ": 32{. favorites
load 'openssl2.ijs'
'generating logon key (can take a minute)...' hout__co  (": sk) , ' bits'
 syskey =. sk gencompressedN 256x #. fb64^:2 listhash (pD (name__PARAMS , ' ' , ":@:date_of_birth__PARAMS  , ' ' , locations__PARAMS ) y) FRCparse Nproof FavoritesN splitpwToN password2__PARAMS y
'validating logon key' hout__co  (": sk) , ' bits'
syskey =. sk FixCompressedN^:_ syskey
'generating spending key (can take a minute)...' hout__co  (": pk) , ' bits'
perskey=. pk gencompressedN 256x #. fb64^:2 listhash (pD (name__PARAMS , ' ' , ":@:date_of_birth__PARAMS  , ' ' , locations__PARAMS ) y) FRCparse Nproof FavoritesN splitpwToN password2__PARAMS y
'validating spending key' hout__co  (": pk) , ' bits'
perskey =. pk FixCompressedN^:_ perskey
'slow encrypting spending and logon keys' hout__co 'if this takes much longer than 1-2 seconds, then change the last number in passwords 3 and 4 to be below 400', 'if this wizzed by so fast you did not even notice the message, then consider increasing the last number of password 3 and 4',: 'the lower the last number, the faster using passwords will be (though this causes security risks if your computer is stolen)'
,. SPENDING=:;@:(rollpad@:#22 b.each<)each  }. PERSKEY =: 256#.inv each;/ RWdparams 2{.perskey[1 (200 Slowbytes2)  ;: inv@:(}: , 60&+&.".each@:{:) ;: password3__PARAMS y
'encrypted spending and logon keys' hout__co ,. LOGON=:;@:(rollpad@:#22 b.each<)each }. SYSKEY =: (256#.inv each ;/ RWdparams 2{. syskey), SPENDING[1 (300 Slowbytes2) password4__PARAMS y
(3!:1 LOGON) fwrite APPDATA , 'keys/keys.settings'
 pD PUBKEYS =:  {&a. each 256 #.inv each {: each perskey ,~&< syskey
wd 'clipcopy *', tobase64 3!:1 (email__PARAMS y) ; PUBKEYS , (name__PARAMS y);(< (';' cut locations__PARAMS y)), < (';' cut languages__PARAMS y)
'data saved and public key info  placed on clipboard' hout__co ,. (tobase64_keygenform_ leaf@:] amdt 1 2)  3!:2  frombase64 wdclippaste ''
'Make a cribsheet for passwords 1 and 2.  They are used just to recreate your key on other computers' hout__co 'Create a strategy to remember your passwords' , 'submit your public key info (on clipboard) to join a society.  Do so before copying anything else on this page.' , 'You will be given a membership ID' , 'A finalization step will copy this data to a folder for your membership ID.', 'to finalize, run the J command: (copy next line and paste into J console.  then hit enter.)' ,: 'final_keygenform_ a:'
)

go =: 3 : 0
start_consoleform_ co =: 'cb__Ckeygenform__OOP;output from key generation will display here' DEF_consoleform_ r =: 'pass ; Personalized Deterministic rabin key generator with provable authorship; Fill in all fields. ;cb__Ckeygenform__OOP; ` ` `english` ` ` ` ` `190 198 ; edit`edit`edit`edit`edit`passw"1`passw"1`passw"1`passw"1`ignore"1 ; Your name. Use initial for first or last name.  Punctuation optional.`location(s) you consider home.  City, region, country.  Separate multiple ones with semicolon`YYYYMMDD with no punctuation`languages you can speak write or read.  Separate with semicolons.`A permanent email`Salt. 24+ characters list of word(s) then list of numbers.  list items are separated by spaces`8+ character password.  Ends in list of numbers separated from rest with a space.`8+ character password (can repeat password2)`8+ character password (can repeat password2)`list of 2 numbers to override (if ignore is off) bit sizes (ignore/override only for quick tests)' DEFfromR_recordform_ PARAMS
NB. start_consoleform_ co =: '`;hello world' DEF_consoleform_ r =: ('pass ; password for life;cb__; ; passw`edit ; enter long password you will remember ` numbers are good') DEF_recordform_ 'password str `7&mthan; other int`3 5&inrange 0&gthan 22&lthan'
)
go a: