To the developer that will one day take over this project,

There are some parts of this that are as they were meant to be; that is, are efficient, extensible and will scale well.

Other parts of this piece of software are basically band-aids made out of cactus.  I've tried to add comments where this happens.



Bad things:
-Everything about getting info from the server.  Step one to fixing this: get our own server so we can have access to the server-side code.  I'm literally parsing the html now.  I'm also using a depracated method to get said html.

Personal preferences:
-I don't like the storyboard.  At all.  So everything except for the navigation controller and the root controller (currently the emotion logging screen) is pushed / declared / customized programmatically.
