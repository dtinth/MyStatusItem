
MyStatusItem
============

Create your own status bar menu, without having any Cocoa knowledge, using your favorite programming language!

<img src="http://i.imgur.com/hfNNYn7.png" width="372" height="290">


About
-----

This this a simple application that pulls the menu items from `http://localhost:12799/menu.json` and displays it on the status bar.



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







