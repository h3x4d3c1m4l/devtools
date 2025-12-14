# h3x4d3c1m4l's Personal Dev Tools

This is my [Flutter](https://flutter.dev/) project that started as coding challenge (like AoC) solutions tool, but now also serves as personal dev tool for experimental stuff.

Additionally I'd like this project to serve as a sample and demo for GitHub Actions, GitHub Pages and Flutter Web.

When a commit has been pushed to the `main` branch, it gets deployed here: <https://h3x4d3c1m4l.github.io/devtools/>.

## This tool currently contains (some) solutions for

- [Advent of Code 2021](https://adventofcode.com/2021)
- [Advent of Code 2022](https://adventofcode.com/2022)
- [Advent of Code 2023](https://adventofcode.com/2023)
- [Advent of Code 2024](https://adventofcode.com/2024)
- [Advent of Code 2025](https://adventofcode.com/2025)

## Features

### Done

- [x] Auto deploy `main` branch to GitHub Pages
- [x] Simple [Fluent UI](https://pub.dev/packages/fluent_ui) based interface
- [X] Track and show duration of solver run
- [X] Error handling
- [X] Show solver code with code highlighting
- [X] Dark mode
- [X] Link to challenge web page
- [X] Connect to API to retrieve inputs (may not work on web due to CORS limitations)

### Planned

- [ ] Run challenge solver asynchronically
- [ ] Custom solver input/solution views (currently there's only support for string input/output)
- [ ] About screen (link to GitHub, show licences using license registry)
- [ ] Settings menu (pick light/dark theme, language maybe)
