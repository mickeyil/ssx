SSX
===

SSX is SSH on colorful xterm.

Description
-----------

SSX uses consistent colors for the same hostname, so that it would be easier to navigate accross different windows with different hostnames.

Usage
-----
Just replace the ssh command with ssx, it uses the same syntax:
```
$ ssx.rb [ssh options] user@host [command]
```
TODO's
------

Currently, colors are hard coded in the script, and has to be written manually.
Next two tasks would be:

1. Allow personal customization: read host => fg,bg mappings from a configuration file.

You're welcome to fork and improve!
