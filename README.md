rabin-key-gen
=============

##Requires and installation##

J 8.03 (likely compatible with later versions).  Available from http://www.jsoftware.com.

recommended copy to folder is home/natbit or (C:/User/Yourname/natbit).  unzip all files there.  (You may download from github on right sidebar)

to run, start J with the jqt command (a yellow background J programming console will open)

Ensure all additional packages are installed by running Tools | Package manager (menu items in J)

open a lab with Help|Studio|Labs (The first one Introduction to J is fine)

If this is your first time using J, you can advance throug a few steps (with ctrl-J key) in the lab to learn a bit about the programming language.

to start the program, type (assuming you copied files to home/natbit)

lab_jlab_ jpath '~/natbit/setupnb.ijt'

##Features and Purpose

This is a process to generate keys for use in the Rabin Williams (or RSA with small modification) public cyrptosystem.

It uses an interactive J lab session for portability accross platforms (64 and 32 bit desktops and android) and visibility and verifiability that the key is generated through function paths that you can verify.  

The keys are generated deterministically such that the same key may be generated on other computers without transfering any information through a network.  Significant entropy is created to ensure the generated key will be unique for 10s of billions of people, even with short memorable passphrases being used.

A significant advantage of deterministic key generation is that it is possible to prove that you are the creator of the key even if the mathematics, or other trick uses, for the cryptosystem reveal your key, or malware/key logging/data theft compromise your private key.  

Being able to prove authorship allows you to revoke a key (and replace it with a new one)

Using a series of short memorable passphrases reduces the chance of being locked out of your key.

##Quick Overview of use of this program

You will be creating and saving 2 passwords.  No information about those passwords or private keys will be revealed to anyone else.  

The combination of the 2 passwords must be unique to everyone else in the world.

Except for the prompts that ask you to repeatedly enter passwords, the process can be completed in 5 minutes.  Press CTRL-J to quickly advance to next screen without reading to make it quicker.

##Welcome contributions

C libraries and J bindings for random number generators (large/medium mersenne prime LCGs and gbflip combiners), Miller Rabin tester, key generator, and signing and encryption functions.
