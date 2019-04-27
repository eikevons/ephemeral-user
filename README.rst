Ephemeral user
==============

Mount an overlay filesystem over a user's home directory with a
temporary upper directory.

The idea is to have an ephemeral user for web browsing where you can
reset the browser profile any time with minimum effort.

This package contains templates which can be processed and installed
with `make`:

`home-overlay`:
  a script to start and stop the overlay mount
`home-overlay.service`:
  a `systemd (1)` service
`clear`:
  a script to reset the ephemeral-users home directory
`Makefile`:
  to install the package

Install
-------

Run as root: `make install`. This creates the user _ephemeral_ with
disabled login if necessary, installs the necessary scripts and enables
the systemd service.

Options
~~~~~~~

`TARGETUSER`:
  To choose a different user name use `make install -e TARGETUSER=...`
  (default: `ephemeral`).
`PREFIX`:
  To select a different install prefix use `make install -e PREFIX=...`
  (default: `/usr/local/`).

Usage
-----

(This assumes the user was "ephemeral".)

#. Prepare the ephemeral user's home directory, e.g. create a Firefox
   profile.
#. Start the overlay: `sudo ephemeral-home-overlay start`.
#. Start Firefox as the ephemeral user `sudo -u ephemeral firefox`.

To reset the ephemeral user's home directory, e.g. to clean the Firefox
profile:

#. Stop Firefox.
#. Restart the home overlay: `ephemeral-clear`.

Requirements
------------

* `sudo`
* `adduser`
