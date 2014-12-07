SSX
===

SSX is SSH on colorful xterm.

Description
-----------

SSX uses consistent colors for the same hostname, so that it is easier to navigate accross different windows with different remote shells. No color configuration is required: colors are generated from the hostname's string hash.

Usage
-----
Just replace the ssh command with ssx, it uses the same syntax:
```
$ ssx.rb [ssh options] user@host [command]
```

