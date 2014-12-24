rabin-key-gen
=============




##Requires and installation##

J 8.03 (likely compatible with later versions).  Available from http://www.jsoftware.com.

recommended copy to folder is home/natbit or (C:/User/Yourname/natbit).  unzip all files there.

to run, start J with the jqt command

Ensure all additional packages are installed by running Tools | Package manager

open a lab with Help|Studio|Labs (The first one Introduction to J is fine)

If this is your first time using J, you can advance throug a few steps (with ctrl-J key) in the lab to learn a bit about the language.

to start the program, type (assuming you copied files to home/natbit)

lab_jlab_ jpath '~/natbit/setupnb.ijt'

##Features and Purpose

This is a process to generate keys for use in the Rabin Williams (or RSA with small modification) public cyrptosystem.

It uses an interactive J lab session for portability accross platforms (64 and 32 bit desktops and android) and visibility and verifiability that the key is generated through function paths that you can verify.  

The keys are generated deterministically such that the same key may be generated on other computers without transfering any information through a network.  Significant entropy is created to ensure the generated key will be unique for 10s of billions of people, even with short memorable passphrases being used.

A significant advantage of deterministic key generation is that it is possible to prove that you are the creator of the key even if the mathematics, or other trick uses, for the cryptosystem reveal your key, or malware/key logging/data theft compromise your private key.  

Being able to prove authorship allows you to revoke a key (and replace it with a new one)

Using a series of short memorable passphrases reduces the chance of being locked out of your key.

##Welcome contributions

C libraries and J bindings for random number generators (large/medium mersenne prime LCGs and gbflip combiners), Miller Rabin tester, key generator, and signing and encryption functions.
