# Mystical Ninja Starring Goemon: Fast Travel Mod

This mod speeds up the dragon fast travel animation in Mystical Ninja Starring Goemon: Recompiled. Instead of waiting through the full 25-second dragon animation, this mod reduces it to just 100 frames for a much faster travel experience.

## Features
- Speeds up dragon fast travel animation from 25 seconds to 100 frames
- No other gameplay changes - just faster travel between areas

## Installation
1. Download the latest `.nrm` file from the releases
2. Place the mod file in your Mystical Ninja Starring Goemon: Recompiled mods folder
3. Enable the mod in the game's mod menu

## Building from Source
If you want to build this mod from source, you'll need to install `clang` and `make`.
* On Windows, using [chocolatey](https://chocolatey.org/) to install both is recommended. The packages are `llvm` and `make` respectively.
  * The LLVM 19.1.0 [llvm-project](https://github.com/llvm/llvm-project) release binary, which is also what chocolatey provides, does not support MIPS correctly. The solution is to install 18.1.8 instead, which can be done in chocolatey by specifying `--version 18.1.8` or by downloading the 18.1.8 release directly.
* On Linux, these can both be installed using your distro's package manager. You may also need to install your distro's package for the `lld` linker. On Debian/Ubuntu based distros this will be the `lld` package.
* On MacOS, these can both be installed using Homebrew. Apple clang won't work, as you need a mips target for building the mod code.

On Linux and MacOS, you'll need to also ensure that you have the `zip` utility installed.

You'll also need to grab a build of the `RecompModTool` utility from the releases of [N64Recomp](https://github.com/N64Recomp/N64Recomp). You can also build it yourself from that repo if desired.

### Building
* First, run `make` (with an optional job count) to build the mod code itself.
* Next, run the `RecompModTool` utility with `mod.toml` as the first argument and the build dir (`build` in the case of this mod) as the second argument.
  * This will produce your mod's `.nrm` file in the build folder.
  * If you're on MacOS, you may need to specify the path to the `clang` and `ld.lld` binaries using the `CC` and `LD` environment variables, respectively.

## Development Notes

For modders interested in the technical details or wanting to create similar mods:

### Writing Mods
See [this document](https://hackmd.io/fMDiGEJ9TBSjomuZZOgzNg) for an explanation of the modding framework, including how to write function patches and perform interop between different mods.

### Updating the Mystical Ninja Starring Goemon Decompilation Submodule
Mods can also be made with newer versions of the Mystical Ninja Starring Goemon decompilation instead of the commit targeted by this repo's submodule.
To update the commit of the decompilation that you're targeting, follow these steps:
* Build the [N64Recomp](https://github.com/N64Recomp/N64Recomp) repo and copy the N64Recomp executable to the root of this repository.
* Build the version of the Mystical Ninja Starring Goemon decompilation that you want to update to and copy the resulting .elf file to the root of this repository.
* Update the `mnsg` submodule in your clone of this repo to point to the commit you built in the previous step.
* Run `N64Recomp generate_symbols.toml --dump-context`
* Rename `dump.toml` and `data_dump.toml` to `mnsg.us.syms.toml` and `mnsg.us.datasyms.toml` respectively.
  * Place both files in the `Goemon64RecompSyms` folder.
* Try building.
  * If it succeeds, you're done.
  * If it fails due to a missing header, create an empty header file in the `include/dummy_headers` folder, with the same path.
    * For example, if it complains that `assets/objects/object_cow/object_cow.h` is missing, create an empty `include/dummy_headers/objects/object_cow.h` file.
  * If RecompModTool fails due to a function "being marked as a patch but not existing in the original ROM", it's likely that function you're patching was renamed in the Mystical Ninja Starring Goemon decompilation.
    * Find the relevant function in the map file for the old decomp commit, then go to that address in the new map file, and update the reference to this function in your code with the new name.
