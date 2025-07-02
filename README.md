# Play Integrity Fix

This module tries to fix Play Integrity and SafetyNet verdicts to get a valid attestation.

## NOTE

This module is not made to hide root, nor to avoid detections in other apps. It only serves to pass Device verdict in the Play Integrity tests and certify your device.

## Tutorial

You will need root and Zygisk. Enable Magisk's built-in Zygisk or use [ZygiskNext](https://github.com/Dr-TSNG/ZygiskNext) / [ReZygisk](https://github.com/PerformanC/ReZygisk).

## Variety

- **inject-vending**: Based on the official inject branch, with the added spoofVendingSdk option.
- **inject-manual**: Based on inject-vending, with auto config (detect TrickyStore and ROM signature) removed.
- **inject-s**: Based on inject-manual, lightweight since it dropped the JSON format (pif.json -> pif.prop).

> [!WARNING]
> Do not use third-party tools to fetch fingerprints to avoid conflicts.
> The WebUI provides full control for configurable options.

## More

- The *spoofVendingSdk* option has been patched by Google; device verdict on A12+ with *spoofVendingSdk* is no longer possible.
- The **inject-vending** and **inject-manual** branches are discontinued, but the branches will not be removed.

### About official PIF by chiteroman

- The [offical PIF by chiteroman](https://github.com/chiteroman/PlayIntegrityFix) has been removed from GitHub.
  - Official untouched main branch: https://github.com/KOWX712/PlayIntegrityFix/tree/main
  - Official untouched inject branch: https://github.com/KOWX712/PlayIntegrityFix/tree/inject
  - All tags from the official PIF repo are also preserved in this repo.

## Acknowledgments

- [kdrag0n](https://github.com/kdrag0n/safetynet-fix) & [Displax](https://github.com/Displax/safetynet-fix) for the original idea.
- This project is forked from the official chiteroman's PIF repo.
- [osm0sis](https://github.com/osm0sis) for his original [autopif2.sh](https://github.com/osm0sis/PlayIntegrityFork/blob/main/module/autopif2.sh) script, and [backslashxx](https://github.com/backslashxx) & [KOWX712](https://github.com/KOWX712) for improving it ([action.sh](https://github.com/chiteroman/PlayIntegrityFix/blob/main/module/action.sh)).
