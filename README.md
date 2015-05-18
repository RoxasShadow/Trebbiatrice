![Trebbiatrice](http://i.imgur.com/ZSVlfcR.jpg)

Trebbiatrice
============
Track the time on Harvest automatically watching what you're working on.

What do you need
----------------
- Mac OS X (more platforms later)
- Sublime Text (more editors later)
- (Projects/Workspace/Files/Folders)'s name matching the ones you've available on Harvest

Installation
------------
`$ gem install trebbiatrice`

```sh
export TREBBIA_PASS='password'
export TREBBIA_DOMAIN='subdomain'
export TREBBIA_MAIL='email'
```

`$ trebbiatrice [trebbia]`

About Sublime Text
------------------
If you do not work with workspaces/projects like I said before, you can add `"show_full_path": true` to your editor's settings. In this way, `trebbiatrice` will try to match the Harvest projects with the name of the folder in which your files your're working on are saved.

To track with Sublime Text, just do `$ trebbiatrice sublime`.

About Atom
----------
Install the package `custom-title` in Atom and set something like `<%= fileName %><% if (projectPath) { %> - /<%= relativeFilePath %><% } %>` in the custom title. Otherwise just work in the folder with the name of your project.

To track with Atom, the command is `$ trebbiatrice atom`.

TODO
----
- Configuration file
- Run as daemon
- Logger
- More testate

Why
---
```
<RoxasShadow> https://www.getharvest.com/
<RoxasShadow> è carino
<RoxasShadow> e ha integrazioni ovunque
<Cusy> trovo strano non te ne sia sviluppato uno tuo
<Byakko> infatti
[...]
<Byakko> quindi, quando apri gli anime SubDesu-H ti segna mpv aperto
<Cusy> ^
<RoxasShadow> no
<RoxasShadow> è manuale
[...]
<RoxasShadow> più che altro quasi quasi
<RoxasShadow> potrei fare qualcosa di automatizzato
<RoxasShadow> harvest ha le api
<RoxasShadow> potrei detectare la roba aperta in sublime
<RoxasShadow> Cusy sei utile
<Byakko> vero
<Cusy> ....
<RoxasShadow> non credo esista
<Cusy> NOI TI PERCULAVAMO
<Byakko> così eviti il tempo di segnartele ogni volta
<RoxasShadow> o almeno non conosco
<Byakko> guadagni in tempo ed efficenza
<RoxasShadow> ^
<Cusy> ....
```

... and also because half of Moze's development team forget to track the time. Anna will be happy now.
