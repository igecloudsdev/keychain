# ChangeLog for Keychain
https://www.funtoo.org/Funtoo:Keychain

## keychain 2.9.5 (16 May 2025)

This is a bugfix release.

* Hardening checks were failing on Android and some MacOS environments. Make them
  more compatible and lower to warnings instead of aborting the script, until
  they have been tested in more environments.
  ([#177](https://github.com/funtoo/keychain/issues/177))

* Fixed issues with indentation of `note()`, `warn()`, `mesg()`.

* Convert `SSH_AUTH_SOCK in pidfile is invalid; ignoring it` into a debug message,
  as this is normal when rebooting your system so is not really useful to show 
  typically. ([#176](https://github.com/funtoo/keychain/issues/176))

## keychain 2.9.4 (14 May 2025)

This is a minor bugfix release.

* Fix minor regression which allowed some warnings to display with `--quiet`.
([#175](https://github.com/funtoo/keychain/issues/175))

* "Cannot find separate public key" turned into a `note()` rather than `warn()`,
  along with several other non-critical notices. `note()` can be suppressed with
  `--quiet`, unlike `warn()`. ([#157](https://github.com/funtoo/keychain/issues/157))

* Minor improvement when wiping GnuPG keys with `--wipe` option so keychain output
  is more understandable when gpg-agent is not running.

## keychain 2.9.3 (14 May 2025)

This is a security and bug fix release. Many thanks to those who have reported
issues to GitHub, send in pull requests, and tested out fixes. 2.9.3 includes
the following updates:

* The `--quick` option logic had several bugs which have been resolved. Thanks
  to Filipe Fernandes (@ffernand) for reporting the issue and for assistance
  testing fixes. ([#167](https://github.com/funtoo/keychain/issues/167))

* Fix keychain `--query` exit code when no pidfile exists.
  ([#171](https://github.com/funtoo/keychain/issues/171))

* `--systemd` option should now be fixed.
  ([[#168](https://github.com/funtoo/keychain/issues/168)])

* Harden keychain so the use of the `--dir` and `--absolute` options cannot be
  used to instruct keychain to write pidfiles into insecure areas.
  ([#174](https://github.com/funtoo/keychain/issues/174))
  
  Prior to this release, it was possible to use these options in combination
  with bad (empty) default umask to write pidfiles into a public area on disk
  where they were writable by other users. In the worst case, this could allow
  arbitrary execution of the contents of the malicious pidfile by keychain.
  
  This hardening now makes it difficult for a user to configure their keychain
  in a way that would allow this to happen. Note that if you are not using the
  `--dir` or `--absolute` options, keychain will use the `$HOME/.keychain` 
  directory by default, which is typically under the full control of the 
  current user and thus not exploitable. 

  The hardening changes include:

  * Setting a global restrictive `umask` in the script.
  * Remove pidfiles before redirecting data to them to ensure they are created
    with restrictive permissions from the `umask`.
  * Check the keychain pidfile directory to ensure it is owned by the current 
    user, and only the current user can access it (mode 700). If not, abort
    with an informative error message.
  * Check any existing pidfiles prior to use to make sure they are owned by the
    current user, and only the current user can access them. If not, abort with
    an informative error message.

  Thanks to Eisuke Kawashima (@e-kwsm) for reporting this issue, the `--systemd`
  issue, as well as for the `--query` fix.


## keychain 2.9.2 (2 May 2025)

This is primarily a bug fix release, but also introduces the new `--extended`
option -- see below:

* Deprecate `--confhost` option and replace with `--extended` option. The old
  `--confhost myhost` would now be `--extended host:myhost`. This also allows
  specifying SSH keys (`sshk:` prefix), GPG keys ( `gpgk:` prefix) and hosts
  (`host:` prefix) together without confusion.
* Well, I became intimately familiar with `IFS` the hard way. Fix 2.9.1 bug
  [#159](https://github.com/funtoo/keychain/issues/159) by reworking IFS settings and
  adding proper documentation to the right places. This fixes the `--timeout` option
  and also now allows `--stop` to work properly which was broken.
* Improve `--agents` deprecation warning.
* Have keychain properly adopt a currently-running gpg-agent providing ssh-agent
  functionality when `--ssh-use-gpg` is specified.
* Explicitly clean up known-bad pidfiles during processing.
* Deprecate `--confhost` option and replace with new `--extended` option.
* Improve host-based key processing by using `ssh -G` to officially extract
  host-based keys.
* Make `Makefile` BSD-compatible.

## keychain 2.9.1 (1 May 2025)

This release fixes a major bug related to the `--eval` option with non-Bourne shells.

* Fix `--eval` option so it works with non-Bourne shells ([#158](https://github.com/funtoo/keychain/issues/158)).
* Last-minute option change: replace `--ssh-wipe` and `--gpg-wipe` with `--wipe [ssh|gpg|all]`.
* Deprecate `--attempts` option which doesn't work with gpg-agent pinentry nor modern OpenSSH.
* More script rewriting -- default to IFS of newline in the script, totally rework SSH and GPG
  key adding code.
* Remove undocumented and likely unused `--` option.
* Script is now at a svelte 1049 lines of code.

## keychain 2.9.0 (30 Apr 2025)

These release notes contain a summary of all changes, including cumulative
changes in pre-releases:

* A new release after 8 years, with Daniel Robbins (script creator) returning as maintainer.
* 60% of the script has been rewritten, and is now compliant with 
[ShellCheck](https://shellcheck.net).
* `--agents` and `--inherit` options have been deprecated to improve ease-of-use.
* `gpg-agent` no longer started by default -- only when a GPG key has been provided on the
  command-line. GnuPG 2.1+ supported.
* GnuPG pidfiles with `-gpg` extension are deprecated and no longer used.
* Better GnuPG integration: `gpg-agent` can be used for SSH key storage. This can be enabled
  by specifying one of the new `--ssh-allow-gpg` and `--ssh-spawn-gpg` options. Agent information
  for `gpg-agent`'s SSH socket will be stored in the regular pidfile for compatibility.
* Add `--ssh-rm`, `--ssh-wipe`, `--gpg-wipe` options for removing/wiping SSH and GPG keys. This addresses
  GitHub Issue [#153](https://github.com/funtoo/keychain/issues/153).
* `--clear` option is now designed to be used for "initial clearing" of keys only.
* Many user interface output improvements, to provide additional detail.
* `--debug` option which can be used to troubleshoot issues with keychain.
* Manual page significantly improved: New section on invocation, as well as documentation of
  the startup and agent detection algorithm.
* Addition of `--ssh-agent-socket` option to manually specify desired path of the ssh-agent socket
  when starting.
* Addition of `--confallhosts` to load identity files for all hosts.
* Various bug fixes and improvements.
* Script size reduced from 1500 to 1133 lines.

## keychain 2.9.0_beta4 (26 Apr 2025)

* Rewrite key parsing code to remove unwanted use of `wantagent gpg` in the code. This may fix previous
  bugs related to identifying and loading GPG keys.
* Fix GitHub Issue [#61](https://github.com/funtoo/keychain/issues/61) by ensuring that any error messages
  generated when adding SSH or GPG keys are printed as warnings to facilitate troubleshooting by users.
* Manually merge in fish shell examples into `keychain.pod`.
* Resolve GitHub Issue [#75](https://github.com/funtoo/keychain/issues/75) and ensure that "IdentityFile"
  allows case variations.

## keychain 2.9.0_beta3 (25 Apr 2025)

* The previous beta of keychain attempted to use gpg-agent by default instead of ssh-agent. This behavior has been
  changed so that now you must opt-in to using gpg-agent. There are two new options to allow you to do this:
  `--ssh-allow-gpg` and `--ssh-spawn-gpg`, which are documented in the man page.
* Displayed information about found/started agents has been greatly enhanced.
* New option `--debug`, which currently allows display of more information regarding
  keychain's decisions.
* Full technical documentation for keychain's agent-detection algorithm in the man page.
* Key decision points in keychain's internal code now have better comments.
* Fixing behavior of `--noinherit` to match previous versions.
* Fixing behavior of `--quick` to match previous versions.
* Tweaking agent detection to match legacy `--inherit=local-once` option.
* Many documentation updates and improvements.
* Now at 1119 lines of code (from 1500 lines of code in keychain 2.8.5)

## keychain 2.9.0_beta2 (23 Apr 2025)

* Code has been overhauled to be more maintainable and various parts of the codebase have been rewritten. During this
  process, which started with 2.9.0_alpha1, various things were broken. THIS IS THE FIRST POTENTIALLY VIABLE WORKING
  RELEASE since 2.8.5, so PLEASE TEST AND PROVIDE FEEDBACK. It will be marked as a non-prerelease on GitHub to get
  more active testing and feedback.
* Please note -- this version of keychain uses gpg-agent by default, if available. We are evaluating the consequences
  of this change at the moment, request feedback on complications related to this change, and THIS DECISION MAY BE
  REVERSED in the final release of 2.9.0 (we may go back to defaulting to ssh-agent, and have an option to use gpg-agent
  in place of ssh-agent, instead of just automatically using gpg-agent.) Please provide feedback in GitHub issues
  based on your experience. We have already found some challenges with the gpg-agent-by-default strategy, so no need
  to convince anyone. Just share your feedback/opinion.
* ChangeLog has been converted to ChangeLog.md (thanks @d4g33z) to facilitate better interoperability with GitHub and
  modern conventions.

## keychain 2.9.0_beta1 (15 Apr 2025)

* Keychain will now detect when gpg-agent is available and has ssh-agent functionality, and use gpg-agent by default. To disable this behavior, use the '--nosub' option to disable auto-substitution of gpg-agent for ssh-agent. This implements GitHub issue #67 requested by Martin Väth.
* Begin removal of support for gpg-agent earlier than 2.1. This release is about 9 years old at this point, and if you have a newer version of keychain on a system, it's likely you also have updated GNUPG.
* Update of keychain project URL to point to GitHub, and minor copyright updates.

## keychain 2.9.0_alpha1 (9 Apr 2025)

* Daniel Robbins returns as keychain maintainer.
* 'keychain' and 'keychain.1' removed from git repo and added to .gitignore.
* Make 'keychain.sh' fully-compliant with ShellCheck, and add necessary exception comments to the codebase. These changes require testing, as some of the suggested fixes are not desired, and I tried to catch all of these. Thus the \_alpha1 status.
* Merge in typographical errors from Peter Pentchev (@ppentchev). (commit d8a566d6402a2e93ce1664cb9c7e9df3233323de)
* Merge in validity checking for malformed SSH public key files, also from Peter Pentchev (@ppentchev). (commit 2722fdcc5d86725dd72995a83694862849494471)
* Merge in support for --agents, which adds detection of gpg-agent which was disabled. From Mikko Koivunalho (@mikkoi). (commit 1d170da33be908c742a0840191533fe90b82db5b)
* Merge in support for --agent-socket option, to specify the path for SSH_AUTH_SOCK manually. From Mikhail f. Shiryaev (@felixoid). (commit 2a3dfcd46e91c32a620d64035c42c8d2971c926f)
* Fix handling of exit codes. This fix is from Manolis Androulidakis (@manolis-andr). (commit ced07855cca34664c382aaaf536e719113f9e4e4)
* Add --confallhosts option to allow loading of keys from all hosts. This is from Ole Martin Ruud (@barskern). (commit 004107877d0258076653b291f25c1e6083fec0fb)
* Update GPL-2 license file. This is from Karol Babioch (@ghost). (commit 15ad9e1c8d5624dd762e503c4da014bcc8ebe890)

## keychain 2.8.5 (24 Jan 2018)

* Summary: Various fixes and support systemd gnupg sockets
* Some shells don't support local builtin (Roy Marples)
* Support systemd managed gnupg sockets (Pedro Romano)
* Fix some lintian warnings in the man page (Chris West)
* Fix issues loading pem keys (Jack Twilley)

## keychain 2.8.4 (19 Oct 2017)

* Summary: Support to GPG2 (Ryan Harris)
* Support busybox ps (Alastair Hughes)
* Various optimizations

## keychain 2.8.3 (24 Jun 2016)

* Summary: fix gpg key addition (Clemens Kaposi)

## keychain 2.8.2 (06 Nov 2015)

* Summary: Support new ssh features, bug fix release.
* Support for new hash algorithms (Ben Boeckel)
* Remove bashisms (Daniel Hertz)
* Various optimizations (Daniel Hahler)
* --timeout option now gets passed to agent, doc fixes (Andrew Bezella, Emil Lundberg)
* RPM, Makefile fixes (Mike Frysinger)

## keychain 2.8.1 (29 May 2015)

* Summary: POSIX compatibility and bug fix release.
* Only set PATH to a standard value if PATH is not set. Otherwise, do not modify.
* Makefile Cygwin and RPM spec fixes (thanks Luke Bakken and Ricardo Silva)
* Confhost fixes. Deprecate in_path. Use command -v instead.
* Find_pids: Modify "ps" call to work with non-GNU ps. (Bryan Drewery)
* Re-introduce POSIX compatibility (remove shopt.) (vaeth)

## keychain 2.8.0 (21 Mar 2015)

* Support for OpenSSH 6.8 fingerprints.
* Support for GnuPG 2.1.0.
* Handle private keys that are symlinks, even if the associated public key is in the target directory rather than alongside the symlink.
* Allow private keys to have extensions, such as foo.priv. When looking for matching public keys, look for foo.priv.pub, but also strip extension and look for foo.pub if foo.priv.pub doesn't exist.
* Initial support for --list/-l option to list SSH keys.
* Updated docs for fish shell usage.

## keychain 2.7.2_beta1 (07 July 2014)

* Various changes and updates:
* Fixes for fish from Marc Joliet.
* Keychain will default to start only ssh-agent unless GPG is explicitly updated using --agents.
* Write ~/.gpg-agent-info when launching gpg-agent - fix from Thomas Spura.
* Add support for injecting agents into systemd (Ben Boeckel)
* Add support for --query option (Ben Boeckel)
* Add --absolute flag, allowing user to set a full path without getting a .keychain suffix automatically appended.
* Add --confhost option to scan ~/.ssh/config file to locate private key path specified there.

## keychain 2.7.1 (07 May 2010)

* 07 May 2010; Daniel Robbins <drobbins@funtoo.org>: Addition of a "make clean" target. removal of runtests as it is currently broken.
* 07 May 2010; Daniel Robbins <drobbins@funtoo.org>: New release process in Makefile and release.sh - keychain release tarball will now contain pre-generated keychain, keychain.1 and keychain.spec so that users do not need to run "make". Updated README.rst to refer to the "source code" as a "release archive" since it contains both source code and ready-to-go script and man page.
* 14 Apr 2010; Daniel Robbins <drobbins@funtoo.org>: GPG fix from Gentoo bug 203871; from Frederic Bathelery. This fix will fix the issue with pinentry starting in the background and not showing up in the terminal.
* 20 Feb 2010; Daniel Robbins <drobbins@funtoo.org>: MacOS X documentation fix from James Turnbull.

## keychain 2.7.0 (23 Oct 2009)

* 23 Oct 2009; Daniel Robbins <drobbins@funtoo.org>: updated README.rst with 2.7.0 and MacOS X package update.
* 18 Oct 2009; Daniel Robbins <drobbins@funtoo.org>: lockfile() replacement from Parallels Inc. OpenVZ code, takelock() rewrite, resulting in ~100 line code savings. Default lock timeout set to 5 seconds, and now keychain will try to forcefully acquire the lock if the timeout aborts, rather than simply failing and aborting.
* 30 Sep 2009; Daniel Robbins <drobbins@funtoo.org>: MacOS X/BSD improvements: fix sed call in Makefile for MacOS X and presumably other *BSD environments, Rename COPYING to COPYING.txt, slight COPYING.txt formatting changes to allow license to display more cleanly from MacOS X .pkg automated install. Fixed POD errors (removed '=end').
* 29 Sep 2009; Daniel Robbins <drobbins@funtoo.org>: disable "Identity added" messages when --quiet is specified (Gentoo bug #250328, thanks to Richard Laager,) --help will print output to stdout (Gentoo bug #196060, thanks to Elan Ruusamäe,) output cleanup and colorization changes - moving away from blue and over to cyan as it displays better terminals with black background. Also some additional colorization. Version bump to 2.6.10.

## keychain 2.6.9 (26 Jul 2009)

* 26 Jul 2009; Daniel Robbins <drobbins@funtoo.org>: Close Gentoo bug 222953 from Bernd Petrovitsch to fix potential issues with GNU grep, Mac OS X color fix when called with --eval from Aron Griffis <agriffis@n01se.net>, Perl 5.10 Makefile fix from Aron Griffis <agriffis@n01se.net>. Transition README to README.rst (reStructuredText). Updated maintainership information. Simplified default output ( --version or --help now required to show version, copyright and license information.)

## keychain 2.6.8 (24 Oct 2006)

* 24 Oct 2006; Aron Griffis <agriffis@gentoo.org>:
    Save `LC_ALL` for gpg invocation so that pinentry-curses works. This affected peper and kloeri, though it seems to work for me in any case.

## keychain 2.6.7 (24 Oct 2006)

* 24 Oct 2006; Aron Griffis <agriffis@gentoo.org>:
    Prevent `gpg_listmissing` from accidentally loading keys

## keychain 2.6.6 (08 Sep 2006)

* 08 Sep 2006; Aron Griffis <agriffis@gentoo.org>:
    Make --lockwait -1 mean forever. Previously 0 meant forever but was undocumented. Add more locking regression tests #137981

## keychain 2.6.5 (08 Sep 2006)

* 08 Sep 2006; Aron Griffis <agriffis@gentoo.org>:
    Break out of loop when empty lockfile can't be removed #127471. Add locking regression tests:
    `100_lock_stale` `101_lock_held` `102_lock_empty` `103_lock_empty_cant_remove`

## keychain 2.6.4 (08 Sep 2006)

* 08 Sep 2006; Aron Griffis <agriffis@gentoo.org>:
    Add validinherit function so that validity of `SSH_AUTH_SOCK` and friends can be validated from startagent rather than up front. The advantage is that warning messages aren't emitted unnecessarily when `--inherit *-once`.
    Fix `--eval` for fish, and add new testcases:
    * `053_start_with_--eval_ksh`
    * `054_start_with_--eval_fish`
    * `055_start_with_--eval_csh`

## keychain 2.6.3 (07 Sep 2006)

* 07 Sep 2006; Aron Griffis <agriffis@gentoo.org>:
    Support fish: http://roo.no-ip.org/fish/
    Thanks to Ilkka Poutanen for the patch.

## keychain 2.6.2 (20 Mar 2006)

* 20 Mar 2006; Aron Griffis <agriffis@gentoo.org>:
    Add `--confirm` option and corresponding regression tests for Debian bug 296382. Thanks to Liyang HU for the patch. Also add initialization for `$ssh_timeout` which was being inherited from the environment and add regression tests for `--timeout`

## keychain 2.6.1 (10 Oct 2005)

* 10 Oct 2005; Aron Griffis <agriffis@gentoo.org>:
    Change `unset evalopt` to `evalopt=false` and run through *all* the regression tests instead of just the new ones. *sigh*

## keychain 2.6.0 (10 Oct 2005)

* 10 Oct 2005; Aron Griffis <agriffis@gentoo.org>:
    Add the `--eval` option which makes keychain startup easier. See the man-page for examples. Get rid of the release notes from README, so now this file is where changes are tracked.

## keychain 2.5.5 (28 Jul 2005)

* 28 Jul 2005; Aron Griffis <agriffis@gentoo.org>:
    Add the `--env` option and automatic reading of `.keychain/env`. This allows variables such as PATH to be overridden for peculiar environments

## keychain 2.5.4.1 (11 May 2005)

* 11 May 2005; Aron Griffis <agriffis@gentoo.org>:
    A minor bug in 2.5.4 resulted in always exiting with non-zero status. Change back to the correct behavior of zero for success, non-zero for failure

## keychain 2.5.4 (11 May 2005)

* 11 May 2005; Aron Griffis <agriffis@gentoo.org>:
    Fix bug 92316: If any locale variables are set, override them with `LC_ALL=C`. This fixes a multibyte issue with awk that could keep a running ssh-agent from being found.
    Fix bug 87340: Use files instead of symlinks for locking, since symlink creation is not atomic on cygwin.

## keychain 2.5.3.1 (10 Mar 2005)

* 10 Mar 2005; Aron Griffis <agriffis@gentoo.org>:
    Fix problem introduced in 2.5.3 wrt adding gpg keys to the agent. Thanks to Azarah for spotting it.

## keychain 2.5.3 (09 Mar 2005)

* 09 Mar 2005; Aron Griffis <agriffis@gentoo.org>:
    Improve handling of DISPLAY by unsetting if blank. Call gpg with `--use-agent` explicitly.

## keychain 2.5.2 (06 Mar 2005)

* 06 Mar 2005; Aron Griffis <agriffis@gentoo.org>:
    Fix bug 78974 "keychain errors on Big/IP (x86 BSD variant)" by refraining from using ! in conditional expressions. Fix RSA fingerprint extraction on Solaris, reported in email by Travis Fitch. Use \$HOSTNAME when possible instead of calling `uname -n` to improve bash_profile compatibility.

## keychain 2.5.1 (12 Jan 2005)

* 12 Jan 2005; Aron Griffis <agriffis@gentoo.org>:
    Don't accidentally inherit a forwarded agent when inheritwhich=local-once. Move the --stop warning after the version splash.

## keychain 2.5.0 (07 Jan 2005)

* 07 Jan 2005; Aron Griffis <agriffis@gentoo.org>:
    Add inheritance support via --inherit. Add parameters to --stop for more control. Change the default behavior of keychain to inherit if there's no keychain agent running ("--inherit local-once"), and refrain from killing other agents unless "--stop others" is specified.

## keychain 2.4.3 (17 Nov 2004)

* 17 Nov 2004; Aron Griffis <agriffis@gentoo.org>:
    Fix bug 69879: Update findpids to work again on BSD; it has been broken since the changes in version 2.4.2. Now we use OSTYPE (bash) or uname to determine the system type and call ps appropriately.

## keychain 2.4.2.1 (30 Sep 2004)

* 30 Sep 2004; Aron Griffis <agriffis@gentoo.org>:
    Fix minor issues in the test for existing gpg keys wrt DISPLAY

## keychain 2.4.2 (29 Sep 2004)

* 29 Sep 2004; Aron Griffis <agriffis@gentoo.org>:
    Make gpg support more complete. Allow adding keys, clearing the agent, etc. Fix --quick support to work properly again; it was broken since 2.4.0. Change default --attempts to 1 since the progs ask multiple times anyway.

## keychain 2.4.1 (22 Sep 2004)

* 22 Sep 2004; Aron Griffis <agriffis@gentoo.org>:
    Fix bugs 64174 and 64178; support Sun SSH, which is really OpenSSH in disguise and a few critical outputs changed. Thanks to Nathan Bardsley for lots of help debugging on Solaris 9
* 15 Sep 2004; Aron Griffis <agriffis@gentoo.org>:
    Fix pod2man output so it formats properly on SGI systems. Thanks to Matthew Moore for reporting the problem.

## keychain 2.4.0 (09 Sep 2004)

* 09 Sep 2004; Aron Griffis <agriffis@gentoo.org>:
    Fix bug 26970 with first pass at gpg-agent support
* Fix Debian bug 269722; don't filter output of ssh-add
* Fix bug reported by Marko Myllynen regarding keychain and Solaris awk's inability to process -F'[ :]'
* Fix bug in now_seconds calculation, noticed by me.

## keychain 2.3.5 (28 Jul 2004)

* 28 Jul 2004; Aron Griffis <agriffis@gentoo.org>:
    Fix bug 58623 with patch from Daniel Westermann-Clark; don't put an extra newline in the output of listmissing
* Generate keychain.spec from keychain.spec.in automatically so that the version can be set appropriately.

## keychain 2.3.4 (24 Jul 2004)

* 24 Jul 2004; Aron Griffis <agriffis@gentoo.org>:
    Fix bug 28599 reported by Bruno Pelaia; ignore defunct processes in ps output

## keychain 2.3.3 (30 Jun 2004)

* 30 Jun 2004; Aron Griffis <agriffis@gentoo.org>:
    Fix bug reported by Matthew S. Moore in email; escape the backticks in --help output
* Fix bug reported by Herbie Ong in email; set pidf, cshpidf and lockf variables after parsing command-line to honor --dir setting
* Fix bug reported by Stephan Stahl in email; make spaces in filenames work throughout keychain, even in pure Bourne shell
* Fix operation on HP-UX with older OpenSSH by interpreting output of ssh-add as well as the error status

## keychain 2.3.2 (16 Jun 2004)

* 16 Jun 2004; Aron Griffis <agriffis@gentoo.org>:
    Fix bug 53837 (keychain needs ssh-askpass) by unsetting SSH_ASKPASS when --nogui is specified

## keychain 2.3.1 (03 Jun 2004)

* 03 Jun 2004; Aron Griffis <agriffis@gentoo.org>:
    Fix bug 52874: problems when the user is running csh

## keychain 2.3.0 (14 May 2004)

* 14 May 2004; Aron Griffis <agriffis@gentoo.org>:
    Rewrite the locking code to avoid procmail

## keychain 2.2.2 (03 May 2004)

* 03 May 2004; Aron Griffis <agriffis@gentoo.org>:
    Call loadagent prior to generating `$HOSTNAME-csh` file so that variables are set.

## keychain 2.2.1 (27 Apr 2004)

* 27 Apr 2004; Aron Griffis <agriffis@gentoo.org>:
    Find running ssh-agent processes by searching for /[s]sh-agen/ instead of /[s]sh-agent/ for the sake of Solaris, which cuts off ps -u output at 8 characters. Thanks to Clay England for reporting the problem and testing the fix.

## keychain 2.2.0 (21 Apr 2004)

* 21 Apr 2004; Aron Griffis <agriffis@gentoo.org>:
    Rewrote most of the code, organized into functions, fixed speed issues involving ps, fixed compatibility issues for various UNIXes, hopefully didn't introduce too many bugs. This version has a --quick option (for me) and a --timeout option (for carpaski).
* Also added a Makefile and converted the man-page to pod for easier editing. See perlpod(1) for information on the format. Note that the pod is sucked into keychain and colorized when you run make.

## keychain 2.0.3 (06 Apr 2003)

* 06 Apr 2003; Seth Chandler <sethbc@gentoo.org>:
    Added keychain man page, fixed bugs with displaying colors for keychain --help. Also added a \$grepopts to fix the grepping for a pid on cygwin Also added a TODO document color fix based on submission by Luke Holden <email@alterself.org>

## keychain 2.0.2 (26 Aug 2002)

* 26 Aug 2002; the Tru64 fix didn't work; it was being caused by "trap - foo" rather than "tail +2 -". Now really fixed.
* 26 Aug 2002; fixed "ssh-add" call to only redirect stdin (thus enabling ssh-askpass) if ssh_askpass happens to be set; this is to work around a bug in openssh were redirecting stdin will enable ssh-askpass even if ssh_askpass isn't set, which contradicts the openssh 3.4_p1 man page. to enable ssh-askpass, keychain now requires that the ssh_askpass var be set to point to your askpass program.

## keychain 2.0.1 (24 Aug 2002)

* 24 Aug 2002; "--help" fixes; the keychain files were listed as sh-\${HOSTNAME} rather than \${HOSTNAME}-sh. Now consistent with the actual program. Thanks to Christian Plessl <plessl@tik.ee.ethz.ch>, others for reporting this issue.
* 24 Aug 2002; cycloon <cycloon@linux-de.org>: "If you add < /dev/null when adding the missingkeys via "ssh-add \${missingkeys}" (at line 454 of version 2.0) so that it reads: "ssh-add \${missingkeys} < /dev/null" then users can use program like x11-ssh-askpass in xfree to type in their passphrase. It then still works for users on shell, depending if \$DISPLAY is set." Added.
* 24 Aug 2002; A fix to calling "tail" that *should* fix things for Tru64 Unix; unfortunately, I have no way to test but the solution should be portable to all other flavors of systems. Thanks to Mark Scarborough <Mark.Scarborough@broadwing.com> for reporting the issue.
* 24 Aug 2002; Changed around the psopts detection stuff so that "-x -u \$me f" is used; this is needed on MacOS X. Thanks to Brian Bergstrand <brian@classicalguitar.net>, others for reporting this issue.

## keychain 2.0 (17 Aug 2002)

* 17 Aug 2002; (Many submitters): A fix for keychain when running on HP-UX 10.20.
* 17 Aug 2002; Patrice DUMAS - DOCT <dumas@centre-cired.fr>: Now perform help early on to avoid unnecessary processing. Also added --dir option to allow keychain to look in an alternate location for the .keychain directory (use like this: "keychain --dir /var/foo")
* 17 Aug 2002; Martial MICHEL <martial@users.sourceforge.net>: Martial also suggested moving help processing to earlier in the script. He also submitted a patch to place .ssh-agent-* files in a ~/.keychain/ directory, which makes sense particularly for NFS users so I integrated the concept into the code.
* 17 Aug 2002; Fred Carter <fred.carter@amberpoint.com>: Cygwin fix to use proper "ps" options.
* 17 Aug 2002; Adrian Howard <adrianh@quietstars.com>: patch so that lockfile gets removed even if --noask is specified.
* 17 Aug 2002; Mario Wolff <wolff@voll.prima.de>: Replaced an awk dependency with a shell construct for improved performance.
* 17 Aug 2002; Marcus Stoegbauer <marcus@grmpf.org>, Dmitry Frolov <frolov@riss-telecom.ru>: I (Daniel Robbins) solved problems reported by Marcus and Dmitry (mis-parsed command line issues) by following Dmitry's good suggestion of performing argument parsing all at once at the top of the script.
* 17 Aug 2002; Brian W. Curry <truth@bcurry.cjb.net>: Added commercial SSH2 client support; improved output readability by initializing myfail=0; integrated Cygwin support into the main keychain script; improved Cygwin support by setting "trap" appropriately. Thanks Brian!

## keychain 1.9 (04 Mar 2002)

* 04 Mar 2002; changed license from "GPL, v2 or later" to "GPL v2".
* 04 Mar 2002; added "keychain.cygwin" for Cygwin systems. It may be time to follow this pattern and start building separate, optimized scripts for each platform so they don't get too sluggish. Maybe I could use a C preprocessor for this.
* 06 Dec 2001; several people: Solaris doesn't like '-e' comparisons; switched to '-f'

## keychain 1.8 (29 Nov 2001)

* 29 Nov 2001; Philip Hallstrom (philip@adhesivemedia.com) Added a "--local" option for removing the \${HOSTNAME} from the various files that keychain creates. Handy for non-NFS users.
* 29 Nov 2001; Aron Griffis (agriffis@gentoo.org) Using the Bourne shell "type" builtin rather than using the external "which" command. Should make things a lot more robust and slightly faster.
* 09 Nov 2001; Mike Briseno (mike@radik.com) Solaris' "which" command outputs "no lockfile in..." to stdout rather than stderr. A one-line fix (test the error condition) has been applied.
* 09 Nov 2001; lockfile settings tweak
* 09 Nov 2001; Rewrote how keychain detects failed passphrase attempts. If you stop making progress providing valid passphrases, it's three strikes and you're out.
* 09 Nov 2001; Constantine P. Sapuntzakis (csapuntz@stanford.edu) Some private keys can't be "ssh-keygen -l -f"'d; this patch causes keychain to look for the corresponding public key if the private key doesn't work. Thanks Constantine!
* 09 Nov 2001; Victor Leitman (vleitman@yahoo.com) CYAN color misdefined; fixed.
* 27 Oct 2001; Brian Wellington (bwelling@xbill.org) A "quiet mode" (--quiet) fix; I missed an "echo".
* 27 Oct 2001; J.A. Neitzel (jan@belvento.org) Missed another "kill -9"; it's now gone.

## keychain 1.7 (21 Oct 2001)

* 21 Oct 2001; Frederic Gobry (frederic.gobry@smartdata.ch) Frederic suggested using procmail's lockfile to serialize the execution of critical parts of keychain, thus avoiding multiple ssh-agent processes being started if you happen to have multiple xterms open automatically when you log in. Initially, I didn't think I could add this, since systems may not have the lockfile command; however, keychain will now auto-detect whether lockfile is installed; if it is, keychain will automatically use it, thus preventing multiple ssh-agent processes from being spawned.
* 21 Oct 2001; Raymond Wu (ursus@usa.net): --nocolor test is no longer inside the test for whether "echo -e" works. According to Raymond, this works optimally on his Solaris box.
* 21 Oct 2001; J.A. Neitzel (jan@belvento.org): No longer "kill -9" our ssh-agent processes. SIGTERM should be sufficient and will allow ssh-agent to clean up after itself (this reverses a previously-applied patch).
* 21 Oct 2001; Thomas Finneid (tfinneid@online.no): Added argument "--quiet | -q" to make the program less intrusive to the user; with it, only error and interactive messages will appear.
* 21 Oct 2001; Thomas Finneid (tfinneid@online.no): Changed the format of some arguments to bring them more in line with common *nix programs: added "-h" as alias for "--help"; added "-k" as alias for "--stop"
* 21 Oct 2001; Mark Stosberg (mark@summersault.com): \$pidf to "\$pidf" fixes to allow keychain to work with paths that include spaces (for Darwin and MacOS X in particular).
* 21 Oct 2001; Jonathan Wakely (redi@redi.uklinux.net): Small patch to convert "echo -n -e" to "echo -e "\c"" for FreeBSD compatibility.

## keychain 1.6 (15 Oct 2001)

* 13 Oct 2001; Ralf Horstmann (ralf.horstmann@webwasher.com): Add /usr/ucb to path for Solaris systems.
* 11 Oct 2001; Idea from Joe Reid (jreid@vnet.net): Try to add multiple keys using ssh-add; avoid typing in identical passphrases more than once. Good idea!

## keychain 1.5 (21 Sep 2001)

* 21 Sep 2001; David Hull (hull@paracel.com): misc. compatibility, signal handling, cleanup fixes
* 21 Sep 2001; "ps" test to find the right one for your OS.
* 20 Sep 2001; Marko Myllynen (myllynen@lut.fi): "grep [s]sh-agent" to "grep [s]sh-agent" (zsh fix)

## keychain 1.4 (20 Sep 2001)

* 20 Sep 2001; David Hull (hull@paracel.com): "touch \$foo" to ">\$foo" optimization and other "don't fork" fixes. Converted \${foo#--} to a case statement for Solaris sh compatibility.
* 20 Sep 2001; Try an alternate "ps" syntax if our default one fails. This should give us Solaris and IRIX (sysV) compatibility without breaking BSD.
* 20 Sep 2001; Hans Peter Verne (h.p.verne@usit.uio.no); "echo -e" to "echo \$E" (for IRIX compatibility with --nocolor), optimization of grep ("grep [s]sh-agent")
* 17 Sep 2001; Marko Myllynen (myllynen@lut.fi): Various fixes: trap signal 2 if signal INT not supported (NetBSD); handle invalid keys correctly; ancient version of ash didn't support ~, so using \$HOME; correct zsh instruction; minor cleanups

## keychain 1.3 (12 Sep 2001)

* 12 Sep 2001; Minor color changes; the cyan was hard to read on xterm-colored terms so it was switched to bold. Additional --help text added.
* 10 Sep 2001; We now use .ssh-agent-[hostname] instead of .ssh-agent. We now create a .ssh-agent-csh-[hostname] file that can be sourced by csh-compatible shells. We also now kill all our existing ssh-agent processes before starting a new one.
* 10 Sep 2001; Robert R. Wal (rrw@hell.pl): Very nice NFS fixes, colorization fixes, tcsh redirect -> grep -v fix. Thanks go out to others who sent me similar patches.
* 10 Sep 2001; Johann Visagie (johann@egenetics.com): "source" to "." shell-compatibility fixes. Thanks for the FreeBSD port.
* 10 Sep 2001; Marko Myllynen (myllynen@lut.fi): rm -f \$pidf after stopping ssh-agent fix

## keychain 1.2 (09 Sep 2001)

* 09 Sep 2001; README updates to reflect new changes.
* 09 Sep 2001; Marko Myllynen (myllynen@lut.fi): bash 1/zsh/sh compatibility; now only tries to kill *your* ssh-agent processes, version fix, .ssh-agent file creation error detection. Thanks!

## keychain 1.1 (07 Sep 2001)

* 07 Sep 2001; Addition of README stating that keychain requires bash 2.0 or greater, as well as quick install directions and web URL.
* 07 Sep 2001; Explicitly added /sbin and /usr/sbin to path, and then called "pidof". I think that this is a bit more robust.
* 06 Sep 2001; from John Ellson (ellson@lucent.com): "pidof" changed to "/sbin/pidof", since it's probably not in \$PATH
* 06 Sep 2001; New ChangeLog! :)

## keychain 1.0 (Aug 2001)
* initial release
