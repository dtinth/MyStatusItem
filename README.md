
MyStatusItem
============

Create your own status bar menu, without having any Cocoa knowledge, using your favorite programming language!
I created this tool because I suck at Cocoa.

<img src="http://i.imgur.com/hfNNYn7.png" width="372" height="290">


About
-----

This this a simple application that pulls the menu items from a URL (default: `http://localhost:12799/menu.json`) and displays it on the status bar.

That means you can create your own menu using any language that can serve JSON over HTTP. [__See code examples in the Wiki!__](https://github.com/dtinth/MyStatusItem/wiki/Creating-Menus)



Installation
------------

Download a [release](https://github.com/dtinth/MyStatusItem/releases)
and put it in `/Application/` or whatever.



menu.json File Format
---------------------

```json
{
  "title": "[1]",
  "items": [
    ITEM, ...
  ]
}
```

### ITEM

Each item is a JSON object.


#### A separator

```json
{ "separator": true }
```

Renders a separator.


#### A menu item

```json
{ "title": "Hello!" }
```

Renders a menu item with text "Hello!".
If no action is specified, the item is disabled.


##### Specifying an action

```json
{ "title": "Start Pomodoro", "url": "http://localhost:12799/pomodoro/start" }
```

The item becomes enabled.
When clicked, MyStatusItem will send a POST request to the specified `url`.
It expects a 200 response.
The response data is ignored, and the menu is refreshed.

```json
{ "title": "Start Music", "script": "tell application \"iTunes\" to play" }
```

The item becomes enabled.
When clicked, the specified AppleScript will run.


##### An alternate menu item.

```json
{ "title": "Start Music", "script": "tell application \"iTunes\" to play" },
{ "title": "Stop Music", "script": "tell application \"iTunes\" to pause",
  "alternate": true }
```

While <kbd>option</kbd> key is held down, the alternate item replaces the previous item.



Customization and Settings
--------------------------


### Running at Startup

Just put the app in Login Items.


### Changing the Menu URL

```bash
defaults write th.in.dt.MyStatusItem menuURL -string 'http://localhost:22222/menu.php'
```

### Changing the Refresh Period

```bash
defaults write th.in.dt.MyStatusItem refreshPeriod -float 10
```

### Repositioning MyStatusItem in the Status Bar

Use the awesome [Bartender](http://www.macbartender.com/) app.




Help Me Please
--------------

This project has fulfilled my needs already,
but there are areas of improvements to make it more useful to others and to make it more cool:

- Can someone create an icon for this?
- Again, I suck at Cocoa, and now the code is messy. A refactor may make the code easier to work with.
- More language examples in the [Wiki](https://github.com/dtinth/MyStatusItem/wiki/Creating-Menus).
- Support nested submenus.
- Windows / Linux port?


Any contribution is appreciated!





