# particle

Podcast intelligence from your terminal. `particle` is the command-line interface for the [Particle API](https://docs.particle.pro): transcripts, mentions, guests, rankings, sponsors, companies, and people across 140,000+ podcasts.

```console
$ particle search "AI agents replacing SaaS" --since 90d
$ particle mentions "Sam Altman" --since 30d
$ particle podcast "Lenny's Podcast"
$ particle transcript lennys --latest --format srt > episode.srt
```

## Install

```sh
# Homebrew (macOS, Linux)
brew install particlepro/tap/particle

# Shell installer (macOS, Linux)
curl -LsSf https://github.com/particlepro/particle-cli/releases/latest/download/particle-cli-installer.sh | sh

# Windows (PowerShell)
powershell -ExecutionPolicy Bypass -c "irm https://github.com/particlepro/particle-cli/releases/latest/download/particle-cli-installer.ps1 | iex"
```

Every release, with archives and SHA-256 checksums for each platform, is on the [releases page](https://github.com/particlepro/particle-cli/releases). Upgrade with `brew upgrade particle`, or by running the installer again.

## Get started

```sh
particle stats            # catalog size; works without a key
particle auth login       # paste a key from https://platform.particle.pro/tokens
particle                  # common commands and examples
particle whoami           # which organization, project, and key you're using
```

For scripts and CI, set `PARTICLE_API_KEY` instead of logging in.

## Common tasks

| Task | Command |
|---|---|
| What was said about a topic | `particle search "the future of nuclear power" --since 30d` |
| Exact words, on one show | `particle search -k "rate cut" -p all-in --recent` |
| Every line naming someone | `particle mentions "Jensen Huang" -n 50` |
| Who a name or link refers to | `particle resolve "Sam Altman" nvidia` |
| A show and its episodes | `particle podcast lennys` · `particle podcast episodes lennys -n 10` |
| A transcript | `particle transcript <episode>` · `--format text\|srt` · `--from 10:00 --to 20:00` |
| A company or person | `particle company nvidia` · `particle person "Sam Altman"` |
| Anything else in the API | `particle commands` · `particle <noun> --help` · `particle api <path>` |

Names work wherever a podcast, person, or company is expected. `particle` resolves them to Particle's ids, asks when a name is ambiguous, and remembers the answer.

## Scripts and agents

- **Output:** in a pipe, `particle` prints the API's JSON, unchanged. On a terminal it prints tables and cards. Other options: `-o json|jsonl|csv|table|wide`, built-in `--jq '.data[].slug'`, and `--columns`.
- **Paging:** `-n 200` follows pages until it has 200 items. `--all` fetches everything, capped by `--max-requests` (10 by default on billed endpoints). `--cursor` resumes.
- **Dry runs:** `--dry-run` shows the exact request and its list price without sending it.
- **Errors:** when stderr isn't a terminal, errors are JSON. Exit codes:

  | Code | Meaning |
  |---|---|
  | 0 | Success |
  | 2 | Usage |
  | 3 | Auth |
  | 4 | Not found |
  | 5 | Ambiguous name |
  | 6 | Billing |
  | 7 | Rate limited |
  | 8 | Unavailable |

- **Catalog:** `particle commands --json` describes every command, with its flags, enums, and price.

## Configuration

- **Commands:** `particle config list` · `particle config set output json` · `--profile work` · `particle auth status`.
- **Where things live:** settings are in `~/.config/particle/config.toml`. API keys go in the OS keychain, or in a private file when there's no keychain.
- **Environment variables** override the file: `PARTICLE_API_KEY`, `PARTICLE_PROFILE`, `PARTICLE_PROJECT`, `PARTICLE_OUTPUT`, `PARTICLE_API_URL`.
- **Shell completion:** `particle completion zsh|bash|fish|powershell`.

## Help

- API documentation: [docs.particle.pro](https://docs.particle.pro)
- Bugs and feature requests: [open an issue](https://github.com/particlepro/particle-cli/issues)
- Anything else: api@particle.pro
