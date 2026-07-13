# Nanobots: Early Bots Continued

A community-maintained continuation of **Nanobots: Early Bots** for Factorio 2.1.

Nanobots provide consumable construction assistance before normal construction robotics. Equip the Nano Emitter with constructor or termite ammunition and it automatically works on nearby targets while you build.

## Important

This is not an official release from the original maintainer. The continuation preserves the original gameplay, graphics, concepts, and public interfaces while keeping the mod usable on current Factorio versions.

If the original maintainer returns and wants to resume maintenance, this continuation can be archived, redirected, or transferred as appropriate.

## Compatibility

- Factorio 2.1
- Space Age is supported but optional
- Requires `kry_stdlib` 2.2.4 or newer
- Incompatible with the original `Nanobots2` package

## Early construction nanobots

Research **Nanobots** after the early automation technologies, then craft a Nano Emitter and ammunition.

### Nanobot construction bots

Construction ammunition can:

- build entity ghosts and tile ghosts;
- fulfil module and item-request proxies;
- repair damaged structures;
- deconstruct marked entities;
- perform upgrade-planner replacements and rotations;
- demolish cliffs after the relevant technology is researched.

Nanobots consume ammunition as they work. They normally avoid areas already served by construction robots. The Nanobot Logistic Interface equipment can override that restriction.

### Nanobot termite bots

Termite ammunition targets nearby trees. The process destroys the trees rather than collecting wood.

Manually firing either ammunition type creates the visual nanobot cloud but does not perform the automatic construction scan.

## Equipment modules

The mod adds equipment-grid modules that expand personal-roboport behaviour:

- **Automatic item retriever** marks ground items for collection.
- **Automatic tree cutter** marks nearby trees for deconstruction.
- **Automatic unit launcher** deploys available combat-robot capsules when enemies approach.
- **Automatic feeder** consumes supported healing items to restore player health or equipment shields.
- **Nanobot logistic interface** allows nanobots to work inside active construction networks.

Most modules require a powered personal roboport and available construction robots.

## Programmable roboport interface

The Roboport Interface is a placeable scanner with a built-in constant combinator. Configure its signals to assign work to the connected logistic network.

Supported tasks include:

- collecting items from the ground;
- marking trees for removal;
- gathering fish;
- deconstructing exhausted mining drills;
- limiting work to the nearest roboport construction area.

Negative tree or fish signal values act as inventory thresholds. For example, a negative tree signal only orders more trees when the network contains less than the requested amount of wood.

The interface keeps a configurable percentage of construction robots free and pauses automated work while enemies are nearby.

## Settings

Runtime settings control:

- automatic Nano Emitter operation;
- whether the emitter must be the selected weapon;
- tile construction and item-request fulfilment;
- logistic-network restrictions;
- player AFK handling;
- scan and queue rates;
- the percentage of construction robots kept available.

## Continuation changes

The Factorio 2.1 continuation includes:

- the new internal name `Nanobots2-continued`;
- the `kry_stdlib` dependency and import paths;
- Factorio 2.1 ghost-revival and item-request handling;
- quality-aware item movement for Space Age compatibility;
- current constant-combinator sections and filters;
- safer queues for deleted or invalid entities;
- corrected multiplayer polling when no players are connected;
- refreshed metadata, documentation, validation, packaging, and automatic GitHub releases.

See `changelog.txt` for the complete release history.

## Reporting problems

Report reproducible continuation issues at the repository issue tracker. Include the Factorio version, enabled mods, the relevant log or error message, and steps that reproduce the problem.

## Credits

Original mod and concept by **Nexela**.

Additional historical contributions and testing by Articulating, TokMor, M16, snouz, Wube and the Factorio development team, content creators who showcased the mod, and the wider Factorio community.
