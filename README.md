This is an example of an online multiplayer game using the Steamworks extension in Gamemaker.  It has the bare minimum needed to make a multiplayer game function.  I hope that this can be a helpful jumping off point for anyone looking to implement Steam online multiplayer in their Gamemaker project.

I hope to make a video in the near future detailing how this project works.  In the meantime, all code is fully commented, so it should explain most of the reasons things are the way they are.

This repo also includes the extension "Input" by Juju Adams & Alynne Keith for simple implementation of inputs, but nothing relies on it besides handling the inputs.

Limitations:
 -
 - This primarily works in a PvE setting.  PvP typically requires more complex systems for various reasons, but if your game is co-op or a non-fighting game, this type of implementation should work just fine.
 - You will need your own Steam App ID for this to work out of the box.  You can use App ID 480 for testing, but the lobby hosting and joining code will need modification, as it just dumps the client into the first available lobby.  Works fine if your two computers are the only one on that App ID.  Not so much on 480.
 - Related to the previous item: the matchmaking code in this example is dog water.  It is just enough to get the host and another player into one lobby.  For your own project, you'll likely want a much more robust system.  This example is mainly to show how buffers and Steam network packets can be sent and received within a functioning game.  For additional info on how to set up lobbies, I recommend [this tutorial](https://youtu.be/QUQW1G1skbk?si=8SDnxMP04-KwtaI6) on the subject.

Thank you for stopping by, and I hope this is helpful to you!
