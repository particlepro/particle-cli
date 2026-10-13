# particle

Search what was said on 140,000+ podcasts, from your terminal. `particle` is the command-line interface for the [Particle API](https://docs.particle.pro): transcripts, mentions, guests, rankings, sponsors, companies, and people. Names just work, so you never have to look up an id first.

```console
$ particle search "the future of nuclear power" --since 30d
Matters of Policy & Politics — Weathering the Storms: Steven Koonin on Data Centers, Energy…
2026-10-02 · 15:55–20:40 · weathering-the-storms-steven-koonin-on-data-centers-energy-strategies-and
  § The Future of Nuclear Power
  ▶   17:21  Steven Koonin: And if you want to have emissions-free electricity that's also
             reliable and reasonably affordable, nuclear is about the only way to go…
…
```

```sh
particle mentions "Jensen Huang" --since 7d           # every line that names him
particle guest appearances "Sam Altman"               # where he was a guest, and how long he spoke
particle transcript lennys --latest --format srt > episode.srt
particle company nvidia                               # by slug, domain, ticker, or name
```

## Install

```sh
# Homebrew (macOS, Linux); installs tab completion too
brew install particlepro/tap/particle

# Shell installer (macOS, Linux)
curl -LsSf https://cli.particle.pro/install.sh | sh

# Windows (PowerShell)
powershell -ExecutionPolicy Bypass -c "irm https://cli.particle.pro/install.ps1 | iex"
```

Every release, with archives and SHA-256 checksums for each platform, is on the [releases page](https://github.com/particlepro/particle-cli/releases). Upgrade with `brew upgrade particle`, or by running the installer again. `particle doctor` tells you when a newer version is out.

To uninstall, undo what the CLI set up, then remove it:

```sh
particle auth logout              # removes the saved key (and revokes it, if `auth login` issued it)
particle completion uninstall     # removes the lines `completion install` added to your shell's rc file
brew uninstall particle           # or delete the binary: rm "$(command -v particle)"
rm -rf ~/.config/particle ~/.cache/particle
```

The shell installer also added a line that puts `~/.local/bin` on your PATH (`. "$HOME/.local/bin/env"` in your shell profile); remove it if nothing else uses it.

## Try it without a key

```sh
particle stats                  # catalog size, and how many episodes arrived this week
particle docs quickstart        # the API docs, as markdown (particle docs lists every page)
particle schema search          # every field a command returns, as --jq paths
particle commands               # every command, with its price
particle doctor                 # is this installation ready? what to fix if not
```

## Get a key

Sign in (or sign up) from the CLI:

```sh
particle auth login             # approve in your browser; Particle issues a key for this CLI
particle whoami                 # the organization, project, and key in use
```

No browser here (SSH, an agent)? `auth login` prints a link and a code to open on any device, and waits. To use a key you already have, from [platform.particle.pro/tokens](https://platform.particle.pro/tokens): `particle auth login --paste`. `particle auth logout` revokes the key `auth login` was issued.

For scripts and CI, set `PARTICLE_API_KEY` instead, or pipe a key in: `echo "$KEY" | particle auth login --with-token`.

## Tab completion

```sh
particle completion install     # zsh, bash, or fish; Homebrew already did it
```

Completions load on the first Tab, so your shell starts as fast as before, and they always match the installed version. `particle completion uninstall` removes them. To set it up by hand, print a script: `particle completion zsh|bash|fish|powershell`.

## Common tasks

| Task | Command |
|---|---|
| What was said about a topic | `particle search "the future of nuclear power" --since 30d` |
| Exact words, on one show, newest first | `particle search -k "rate cut" -p all-in --recent` |
| What one person said about something | `particle search "nuclear power" --speaker "Bill Gates"` |
| What doctors are saying | `particle search "drug pricing" --occupation physicians` |
| Every line naming someone | `particle mentions "Jensen Huang" -n 50` |
| Where someone has been a guest | `particle guest appearances "Sam Altman"` |
| A show, its episodes | `particle podcast "Lenny's Podcast"` · `particle podcast episodes lennys -n 10` |
| Find a show | `particle podcast search "all in"` |
| A transcript | `particle transcript <episode>` · `--format text\|srt` · `--from 10:00 --to 20:00` · `--speaker <name>` |
| A company or person | `particle company nvidia` · `particle company list --ticker NVDA` · `particle person "Sam Altman"` |
| Who a name refers to | `particle resolve "Sam Altman" nvidia` |
| Watch for mentions | `particle alert create "Sam Altman" --email me@example.com` |
| Anything else in the API | `particle commands` · `particle <noun> --help` · `particle api <path>` |

Names work wherever a podcast, person, company, or entity is expected: `particle` resolves them to Particle's ids, asks when a name is ambiguous, and remembers the answer. A podcast also takes an Apple or Spotify link: `particle podcast https://podcasts.apple.com/us/podcast/id1627920305`.

## For agents and scripts

- **Start here:** `particle guide` prints a quick start written for agents: how output, errors, names, and paging behave, and what to run first. `particle` with no terminal prints it too.
- **Output:** in a pipe, `particle` prints the API's JSON, unchanged; on a terminal it prints tables and cards. `-o json|jsonl|csv|tsv|table|wide`, built-in `--jq '.data[].episode.slug'`, and `--columns` change that.
- **Discovery:** `particle commands --json` describes every API command, with flags, types, enums, and price. `particle schema <command>` shows what a command returns before you call it. `particle docs <words>` searches the API docs.
- **Errors:** when stderr isn't a terminal, errors are JSON, and `particle docs errors/<error_code>` explains an API error. Exit codes are stable:

  | Code | Meaning |
  |---|---|
  | 0 | Success, including empty results |
  | 1 | Unexpected error |
  | 2 | Usage, or the API rejected the request |
  | 3 | No key, or the key was refused |
  | 4 | Not found |
  | 5 | Ambiguous name (candidates listed; pass an id or `--first`) |
  | 6 | Billing or plan |
  | 7 | Rate limited |
  | 8 | Network failure, or the API is unavailable |

- **Paging:** `-n 200` follows pages until it has 200 items. `--all` fetches everything, capped by `--max-requests` (10 by default on billed endpoints). `--cursor` resumes.
- **Safety:** nothing prompts without a terminal. `--dry-run` shows the exact request and its list price without sending it. `--yes` confirms deletes, and `--first` settles ambiguous names.
- **Health:** `particle doctor --json` reports `ok` and each check, with a `fix` for anything that failed.

## Configuration

- **Commands:** `particle config list` · `particle config set output json` · `--profile work` · `particle auth status`.
- **Projects:** alerts, webhooks, and Slack connections use your API key's own project unless you set one with `particle config set project <id>` or `--project`.
- **Where things live:** settings are in `~/.config/particle/config.toml`. API keys go in the OS keychain, or in a private file when there's no keychain.
- **Environment variables** override the file: `PARTICLE_API_KEY`, `PARTICLE_PROFILE`, `PARTICLE_PROJECT`, `PARTICLE_OUTPUT`, `PARTICLE_API_URL`.

## Help

- API documentation: [docs.particle.pro](https://docs.particle.pro), or `particle docs` in your terminal
- Setup problems: `particle doctor`
- Bugs and feature requests: [open an issue](https://github.com/particlepro/particle-cli/issues)
- Anything else: api@particle.pro
