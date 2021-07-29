![stackfuse banner](https://media.discordapp.net/attachments/806285072046751780/806547308376227840/stackfuse_logo.png)

[Come join the Discord server for updates on stackfuse.](https://discord.gg/Cr2k2UEvVE)

**stackfuse** is a **work-in-progress** fork of [Cambridge](https://github.com/SashLilac/cambridge), an open-source arcade stacking game. It is not intended to be clean, it is not intended to be built upon, it is not intended to be better than Cambridge. It's intended to be its own thing, with its own game modes and own assets and everything that goes along with that. If you want to actually improve the engine and contribute, please go help out the actual Cambridge project and not this. This fork is mainly a way to strive for creativity, not for improvement.

If you look at the source code, you will want to scream. You will hate it. And you know what? I don't give a damn. The sole reason this exists is to bring my mode concepts to life. There is a chance that if I ever get better at programming, I will revisit these concepts in the future.

This fork likely wouldn't be a reality without the help of the Cambridge discord. While I would normally tell you to go check it out, the server was closed for some undisclosed reason.

## Features and WIP
* New gamemodes, see further down below
* Forced step or move reset depending on the mode
* Game will be refactored into 720p (Gameplay is more or less done, menus are left to fix though)
* All new assets mostly made by myself

## Gamemodes

* Temporarily: Hypertap Master: It's an arcade version of Tetris with DAS removed. It's currently kept in as a stopgap of sorts.

* Powerstack: A survival-oriented gamemode where your goal is to keep your multiplier up high and extend your time limit. High score is defined by amount of levels you got.
* Liftoff: The stack lifts off the ground after a certain amount of placed pieces, and this interval will speed up over time, but so will the speed curve in general. Can you reach 999999?

### Planned modes:

* Protolock: The version of G-Lock that I never really bothered finishing. No "strike system", fluctuating speeds, ends at 500 pieces.
* Clockwork: Time is ticking. A survival mode with no win condition, the only goal is to survive for as long as possible. The ticking increases over time, and such, your placement limits will decrease, leading to eventual topout.
* Loop: Has a loop system. After 50 Lines you earn one Loop, you roll back in levels but timings shorten. Constant 1G after 1 loop, constant 2G after 3 loops. At 5 loops, you have reached the fastest speeds. Reach 400 lines for a surprise.
* Prism: You have to follow a pattern of how many lines to clear at once. The pattern is 1, 2, 3, 4, 3, 2 and then repeats. Any wrong line clear will give you garbage below the screen and the more mistakes you make, the more garbage will come up. Has a relatively relaxed speed curve, with a win condition of doing the pattern 10 times in a row. Might randomize piece colors, not sure yet.
* Demon Fuel: Inspired by a game called Devil Daggers. Survive for as long as you can (in seconds) with different gimmicks coming in at certain points. Will include "bombs" to wipe the field.
* Boss battles: They will probably be called differently, but basically, you "fight bosses" by depleting their HP with combos and tetrises. Bosses have multiple phases and different attack patterns by utilizing item-like effects on your board. As for what attacks exactly these bosses will have, who knows... I know I don't. Not yet, anyways. lmao

## Playing the game

Clone the repo if you really want to try this out. Windows people can just run launch.bat and other OS users can use the terminal to launch it - just point love2d to the root of the downloaded repo.

A proper alpha release will be built once a few of the things left to do are done, see below.

## Things left to do

This is more to remind myself of what is left to be done:
* Refactor all menus into 720p
* New sound effects (both in general and for the new game modes)
* Rip out all settings not necessary for this fork
* A custom mode selection menu with difficulty selection
* Reduce amount of rotation systems, force all to be pure step reset
* Enforce move reset in certain modes (Protolock comes to mind)
* Find a new decent font willing to work with the MIT license
* Adjust all stats to be at the same heights in-game for obvious aesthetic reasons
* Create new backgrounds, including Title screen
* Of course, work on new modes! This is the smallest priority for now, I think.

## Credits

Basically, nearly everything in this fork was done by myself (This means code, sound and graphics assets, mode design and testing among other things), with small bits of help by those who used to be in the Cambridge discord server, which is since defunct.

If you want to see who worked on the original Cambridge project, please check the [Cambridge repository](https://github.com/SashLilac/cambridge) for those credits.

## License

As this fork is based on Cambridge, which is licensed under a MIT license, stackfuse is too - however I would appreciate if you wouldn't implement my own gamemodes in your own engines, unless you ask me first. I'll likely allow it if you do so. However, nothing is stopping you either.

Some code and assets in this repository are contributed by members of the
community, as well as borrowed from other places, either with licensing
or as placeholders until suitable material can be found that is properly
licensed. Their original sources, and copyright notices if applicable, are
listed in the file SOURCES. However, I will try and replace most of that stuff with my own things.
