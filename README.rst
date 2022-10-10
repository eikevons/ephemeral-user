==============
Ephemeral user
==============

Mount an overlay filesystem over a user's home directory with a
temporary upper directory.

The idea is to have an ephemeral user for web browsing where you can
reset the browser profile any time with minimum effort.

This package contains templates which can be processed and installed
with ``make``:

``home-overlay``:
  a script to start and stop the overlay mount
``home-overlay.service``:
  a ``systemd (1)`` service
``clear``:
  a script to reset the ephemeral-users home directory
``Makefile``:
  to install the package

Install
-------

Run as root: ``make install``. This creates the user *ephemeral* with
disabled login if necessary, installs the necessary scripts and enables
the systemd service.

Use ``make sudo-snippet`` to get a snippet you can paste into e.g.
``/etc/sudoers.d/local-browsing``.

Options
~~~~~~~

``TARGETUSER``:
  To choose a different user name use ``make install -e TARGETUSER=...``
  (default: ``ephemeral``).
``PREFIX``:
  To select a different install prefix use ``make install -e PREFIX=...``
  (default: ``/usr/local/``).

Usage
-----

(This assumes the user was "ephemeral".)

#. Prepare the ephemeral user's home directory, e.g. create a Firefox
   profile.
#. Start the overlay: ``sudo ephemeral-home-overlay start``.
#. Start Firefox as the ephemeral user ``sudo -u ephemeral firefox``.

To reset the ephemeral user's home directory, e.g. to clean the Firefox
profile:

#. Stop Firefox.
#. Restart the home overlay: ``ephemeral-clear``.

Audio
~~~~~

If you want to enable the ephemeral user to play audio via your main
user's pulse audio add the following to your **main** user's
``~/.config/pulse/default.pa``::

  #!/usr/bin/pulseaudio -nF

  # Load system default config
  .include /etc/pulse/default.pa

  load-module module-native-protocol-unix auth-anonymous=1 socket=/tmp/pulse-main.socket

and create ``.config/pulse/client.conf`` for the **ephemeral**
containing::

  default-server = unix:/tmp/pulse-main.socket

See `Arch Wiki <https://wiki.archlinux.org/index.php/PulseAudio/Examples#Allowing_multiple_users_to_use_PulseAudio_at_the_same_time>`_.

Requirements
------------

* ``sudo``
* ``adduser``

Recommended commands:
* ``pgrep``
* ``notify-send``
