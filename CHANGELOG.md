This document has been translated by [DeepL Translator](https://www.deepl.com/translator).

# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog][Keep a Changelog] and this project adheres to [Semantic Versioning][Semantic Versioning].

## \[Unreleased]
If you want to see what the next version of the plan is, check out the [here](https://github.com/zero-plusplus/CustomHotkey.ahk/labels/milestone).
Also want to check the development status, check the [commit history](https://github.com/zero-plusplus/CustomHotkey.ahk/commits/develop) of the develop branch.

---

## \[Released]

## [0.0.4] - 2023-xx-xx
### Added
* [#14](https://github.com/zero-plusplus/CustomHotkey.ahk/issues/14) Add the option to specify each monitor and primary monitor in `"monitor"` and `"screen"` of origin such as `"monitor-primary"` and `"monitor-1"`
* [#20](https://github.com/zero-plusplus/CustomHotkey.ahk/issues/20) Add `"monitors"` (alias `"screens"`) to origin

### Fixed
* [#13](https://github.com/zero-plusplus/CustomHotkey.ahk/issues/13) Origin `"monitor"` and `"screen"` return coordinates of the primary monitor, instead of the active monitor
* [#22](https://github.com/zero-plusplus/CustomHotkey.ahk/issues/22) CommandPaletteCombiAction is not searched correctly when searching for certain characters
* [#23](https://github.com/zero-plusplus/CustomHotkey.ahk/issues/23) When using the `R` option in PasteAction etc., if the string to expand contains a string such as `${abc}`, it will not be embedded correctly
* [#24](https://github.com/zero-plusplus/CustomHotkey.ahk/issues/24) ExitAllAction does not terminate some AutoHotkey scripts

## [0.0.3] - 2022-10-30
### Fixed
* [#15](https://github.com/zero-plusplus/CustomHotkey.ahk/issues/15) Hotkey options not set on CustomHotkey constructor
* [#16](https://github.com/zero-plusplus/CustomHotkey.ahk/issues/16) `CustomHotkey.setOptions` overwrites unspecified options with an empty string
* [#17](https://github.com/zero-plusplus/CustomHotkey.ahk/issues/17) Passing a string to the `CustomHotkey.TrayTipAction` constructor does not display a tray tip

## [0.0.2] - 2022-10-27
### Fixed
* [#3](https://github.com/zero-plusplus/CustomHotkey.ahk/issues/3) When combined KeyStrokeCombiAction, temporarily disabled hotkeys are no longer restored to their original state

## [0.0.1] - 2022-10-22
First released

---

<!-- Links -->
[Keep a Changelog]: https://keepachangelog.com/
[Semantic Versioning]: https://semver.org/

<!-- Versions -->
[0.0.4]: https://github.com/zero-plusplus/CustomHotkey.ahk/compare/v0.0.3..v0.0.4
[0.0.3]: https://github.com/zero-plusplus/CustomHotkey.ahk/compare/v0.0.2..v0.0.3
[0.0.2]: https://github.com/zero-plusplus/CustomHotkey.ahk/compare/v0.0.1..v0.0.2
[0.0.1]: https://github.com/zero-plusplus/CustomHotkey.ahk/tree/v0.0.1