![stackfuse banner](https://media.discordapp.net/attachments/806285072046751780/806547308376227840/stackfuse_logo.png)

[Come join the Discord server for updates on stackfuse.](https://discord.gg/Cr2k2UEvVE)

**stackfuse** is a **work-in-progress** fork of [Cambridge](https://github.com/SashLilac/cambridge), an open-source arcade stacking game. It is not intended to be clean, it is not intended to be built upon, it is not intended to be better than Cambridge. It's intended to be its own thing, with its own game modes and own assets and everything that goes along with that. If you want to actually improve the engine and contribute, please go help out the actual Cambridge project and not this. This fork is mainly a way to strive for creativity, not for improvement.

If you look at the source code, you will want to scream. You will hate it. And you know what? I don't give a damn. The sole reason this exists is to bring my mode concepts to life. There is a chance that if I ever get better at programming, I will revisit these concepts in the future.

## Features and WIP
* New gamemodes, see further down below
* Forced step or move reset depending on the mode
* Game will be refactored into 720p (Gameplay is more or less done, menus are left to fix though)
* All new assets mostly made by myself

## Gamemodes

* Temporarily: Hypertap Master: It's an arcade version of the block stacking game but with DAS removed. It's currently kept in as a stopgap of sorts and will be removed once I add more game modes.

* Powerstack: A survival-oriented gamemode where your goal is to keep your multiplier up high and extend your time limit. High score is defined by amount of levels you got. While you are in Power mode, line clears count twice as much.
* Liftoff: The stack lifts off the ground after a certain amount of placed pieces, and this interval will speed up over time, but so will the speed curve in general. Can you reach 999999?
* Prism: You have to follow a pattern of how many lines to clear at once. The pattern is 1, 2, 3, 4, 3, 2 and then repeats. Any wrong line clear will give you garbage below the screen and ruin your chances of passing the skill check. Has a relatively relaxed speed curve, with a win condition of doing the pattern 10 times in a row. **To beat the skill check, you have to clear the pattern 5 times without a wrong line clear in under 2:20.**

### Planned modes:

* Protolock: The version of G-Lock that I never really bothered finishing. No "strike system", fluctuating speeds, ends at 500 pieces.
* Clockwork: Time is ticking. A survival mode with no win condition, the only goal is to survive for as long as possible. The ticking increases over time, and such, your placement limits will decrease, leading to eventual topout.
* Loop: Has a loop system. After 50 Lines you earn one Loop, you roll back in levels but timings shorten. Constant 1G after 1 loop, constant 2G after 3 loops. At 5 loops, you have reached the fastest speeds. Reach 400 lines for a surprise.
* Demon Fuel: Inspired by a game called Devil Daggers. Survive for as long as you can (in seconds) with different gimmicks coming in at certain points. Will include "bombs" to wipe the field.
* Boss battles: They will probably be called differently, but basically, you "fight bosses" by depleting their HP with combos and tetrises. Bosses have multiple phases and different attack patterns by utilizing item-like effects on your board. As for what attacks exactly these bosses will have, who knows... I know I don't. Not yet, anyways.

## Playing the game

Download the current release in the releases tab. Windows players can just grab one of the Windows packages (though on the 32 bit version, the Discord Rich Presence doesn't work. I am aware of this bug and I'll eventually look into it).

Linux/macOS users will have to download the .love file and run it from a terminal by executing love with the path to the stackfuse.love file.

You can also clone the repository and try bleeding edge features if I pushed any, but there may be potential breakage. Use at your own risk.

## Things left to do

Development of stackfuse is an ongoing process, and such, there's always things to do. Here are things I might do in the future:
* New sound effects (there's only one or two missing now)
* BGM (I used to make music with LSDJ, I'll figure something out...)
* A custom mode selection menu with difficulty selection (still missing difficulties, I may try and look into adding a hidden toggle for a harder mode, where I haven't decided on how to tackle it yet)
* Reduce amount of rotation systems, force all to be pure step reset (maybe? I am not 100% on it yet)
* Enforce move reset in certain modes (Protolock comes to mind)
* Create new backgrounds, including Title screen (This is an ongoing process)
* Other game modes

## Credits

Basically, nearly everything in this fork was done by myself (This means code, sound and graphics assets, mode design and testing among other things), with small bits of help by those who are in the Cambridge Discord server.

If you want to see who worked on the original Cambridge project, please check the [Cambridge repository](https://github.com/SashLilac/cambridge) for those credits.

## License

As this fork is based on Cambridge, which is licensed under a MIT license, stackfuse is too - however I would appreciate if you wouldn't implement my own gamemodes in your own engines, unless you ask me first. I'll likely allow it if you do so. However, nothing is stopping you either.

Some code and assets in this repository are contributed by members of the
community, as well as borrowed from other places, either with licensing
or as placeholders until suitable material can be found that is properly
licensed. Their original sources, and copyright notices if applicable, are
listed in the file SOURCES. However, I will try and replace most of that stuff with my own things.
