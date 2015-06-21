rabin-key-gen
=============

##Requires and installation##

J 8.03 or 8.04 (likely compatible with later versions).  Available from http://www.jsoftware.com/stable.htm.

recommended copy the downloaded files here (inside zip file) to folder is home/natbit or (C:/User/Yourname/natbit).  unzip all files there.  (You may download from github on right sidebar)

to run, start J with the jqt command (a yellow background J programming console will open)

Ensure all additional packages are installed by running Tools | Package manager (menu items in J)

The easiest way to generate a key is to run the following command in J
COPY NEXT LINE, PASTE IT INTO J WINDOW, then press ENTER.  (if you did not install to natbit folder under your home directory, then replace the word natbit with the name of the folder you used)

load jpath '~/natbit/keygen.ijs'

To run an interactive literate version of the key generator that explains a bit of J and a bit of how to generate passwords.

lab_jlab_ jpath '~/natbit/', 'setupnb.ijt' [ require 'labs/labs'

If this is your first time using J, you can advance throug a few steps (with ctrl-J key) in the lab to learn a bit about the programming language.

The first version is recommended as it is much quicker, and has additional safeguards and data validation.


##Features and Purpose

This is a process to generate keys for use in the Rabin Williams (or RSA with small modification) public cyrptosystem.

It uses an interactive J lab session for portability accross platforms (64 and 32 bit desktops and android) and visibility and verifiability that the key is generated through function paths that you can verify.  It is open source, and each executed line may be examined afterwards.

The keys are generated deterministically such that the same key may be generated on other computers without transfering any information through a network.  Significant entropy is created to ensure the generated key will be unique for 10s of billions of people, even with short memorable passphrases being used.

A significant advantage of this deterministic key generation process is that it is possible to prove that you are the creator of the key, without revealing the creation passphrases, even if malware/key logging or data theft compromise your private key.  

Being able to prove authorship allows you to revoke a key (and replace it with a new one).  It makes your identity or key impossible to steal (permanently) as only you can revoke and replace the key.

Innovative ways to create a memorable long key allow the creation of unique salts to your cryptographic keys, that are protected using 1 or a series of short memorable passphrases to reduce the chance of being locked out of your key.  Theft of your salt provides no information useable to prove authorship of your key, and would still require Millenia of computer time to build hacking tables that expose your key on disk.

##Quick Overview of use of this program

You will be creating and saving 2 passwords.  No information about those passwords or private keys will be revealed to anyone else.  

The combination of the 2 passwords must be unique to everyone else in the world.  That is the only reason personal information is used as part of your password creation.  Though it is possible for 2 people in the world to pick the same long passwords, the combination of those passwords and a name, location and date of birth (not published) is not significantly probable.

Through the first process (load jpath '~/natbit/keygen.ijs'), there are just 9 fields to enter, and passwords 3 and 4 can be copies of password 2 (set mask off to be able to copy)

##Welcome contributions

C libraries and J bindings for random number generators (large/medium mersenne prime LCGs and gbflip combiners), Miller Rabin tester, key generator, and signing and encryption functions.

## FAQ for password choices

Yes.  You may use password vault systems to write down exact passwords used or to generate them.  For Password#1, ideally you should add uniquely identifying words such as your name at front or end of the generated/recorded password.  Doing so assures uniqueness and provability of authorship.  Password vaults are slightly less secure than the recommended system, as you would lose all passwords if your vault password is compromised.  The disk encryption used by this program is at least as strong as any current vault system.

Yes.  You may use a password identical to online passwords as password#2.  Doing so ensures that you remember it.  Adding an extra digit/number that you will remember is recommended if you use this technique for memorization.  Slight differences to online passwords would protect you from those who know that online password, but because these passwords are never sent through any network, an attacker would need to know both that online password and the contents of specific files on your computer.  Even with that knowledge, they would never be able to prove original authorship of any keys, while you can (provided you remember both passwords).

Yes.  You may use randomly selected poetry words or similar schemes to bitcoin paper wallets.  Paper wallets though may be lost or stolen, and so it is more secure for password #1 to leave a paper/email/electronic trail of brain cues that would help only you to fully recreate password#1.  Having the record in backed up electronic form makes it more resistant to fire, and having it coded into clues that only you fully understand makes it more resistant to theft.

How to Customize Password 3 and 4? - Passwords 3 and 4 are used for on-disk encryption of your keys.  It is recommended to be the same as password#2 simply to ensure memorization.  A slight variation adds security by simply being different, and providing no knowledge of password#2 if it is discovered.  The speed with which passwords#3 and #4 encrypt and decrypt your keys from disk depends on the last number of that password.  The higher the number, the larger the prime number that forms the basis for encryption is searched (the prime searched will be of similar length to  2 ^ lastnumber... 129 is added to your number if it is below 129).  The larger the length of a searched prime number, the longer it takes on average to find one, but it is a matter of luck whether the process is quick or slow.  The longest compression delay occurs is expected with last numbers greater or equal to 400.  If it takes about half a second to do the decryption on your computer, then that is likely a good choice.  One second is still ok.  By going up in number by 10 each try, you increase the security, but also may be lucky to still provide an encryption that is under 1 second.  An optimization program is in chapter 7 that taylors an added number to speed and security, though all number choices are considered practically secure, you may simply .
