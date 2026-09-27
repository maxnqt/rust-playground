# rust-playground

> A sandbox for experimenting with Rust, from ownership and traits to async, with write-ups for each.

This repo is my working notebook for learning Rust. It has two parts: `notes` where I write down concepts, gotchas, and "aha" moments as I go, and a set of `examples`, each a small, self-contained Cargo project that explores one idea.
 
Everything runs inside a Docker dev container, so the only thing you need installed locally is Docker. No Rust toolchain on the host required.

## Project layout

```
rust-playground/
├── docker/             # Shell setup copied into the image
│   ├── .bashrc         # History, completion, aliases
│   └── starship.toml   # Prompt (bind-mounted, edits apply on new shell)
├── examples/           # Self-contained Cargo projects, one folder per example
│   ├── rust.mk         # Shared cargo targets included by every example
│   └── <example>/
│       ├── src/
│       ├── Cargo.toml
│       ├── Makefile    # Includes ../rust.mk
│       └── README.md
├── notes/              # Learning log: concepts, commands, lessons learned
├── compose.yaml        # Dev container, code mount, cargo cache volumes
├── Dockerfile          # Rust dev image (rustfmt + clippy, non-root user)
├── LICENSE
└── Makefile            # Host commands: dev, stop, clean
```

## Getting started

**Prerequisites:** [Docker Desktop](https://docs.docker.com/get-docker/), Colima, or Docker Engine with the Compose plugin, plus `make`.

On macOS with Colima, install the `docker-buildx` plugin too and add
Homebrew's plugin folder to `~/.docker/config.json`
(`"cliPluginsExtraDirs": ["/opt/homebrew/lib/docker/cli-plugins"]`),
otherwise builds fall back to the legacy builder. The Makefile's
`COMPOSE` variable can be `docker compose` or `docker-compose`.

From the repo root on your machine:

```bash
make dev     # build the image, start the container, open a shell in it
make stop    # stop the container (image and caches are kept)
make clean   # remove the container, network, image, cache and history volumes
```

`make dev` is safe to run again: if the container is already up, it just opens another shell. The repo is mounted at `/workspace`, so edits you make in your editor on the host show up in the container immediately.

### Inside the container

The shell has a one-line [Starship](https://starship.rs) prompt
(`dev@rust-playground:/workspace (branch *%) $`), tab completion for
`make`, `cargo`, and `git`, and bash history that survives restarts.

| Alias | Runs |
|---|---|
| `ws` / `ex` | `cd /workspace` / `cd /workspace/examples` |
| `cb` / `cr` / `ct` / `ck` | `cargo build` / `run` / `test` / `check` |
| `cl` | `cargo clippy --all-targets` |

Prompt changes in `docker/starship.toml` apply when you open a new shell.
Changes to `docker/.bashrc` need `make dev` to rebuild.

Git markers in the prompt: `*` unstaged, `+` staged, `%` untracked,
`$` stash, `-` deleted, `=` conflicts, `>`/`<`/`<>` ahead/behind/diverged.

### Working on an example

Inside the container, `cd` into an example and use its Makefile:
 
```bash
cd examples/01-hello-world
make help                 # list all targets
make run ARGS="Ferris"    # cargo run -- Ferris
make test                 # cargo test
make ci                   # fmt check + clippy + tests
```
 
| Target | What it runs |
|---|---|
| `build` / `release` | `cargo build` / `cargo build --release` |
| `run` | `cargo run -- $(ARGS)` |
| `test` | `cargo test` |
| `check` | `cargo check` |
| `fmt` / `fmt-check` | `cargo fmt` / `cargo fmt --check` |
| `lint` | `cargo clippy --all-targets -- -D warnings` |
| `doc` | `cargo doc --no-deps` |
| `clean` | `cargo clean` |
| `ci` | `fmt-check` + `lint` + `test` |

### Adding an example

1. Inside the container: `cd examples && cargo new 02-my-example --name my-example`
2. Copy `01-hello-world/Makefile` into the new folder (it's just `include ../rust.mk`).
3. Add a README using the template below and a row to the example index.

**Example README template:**
 
1. **What it does:** one or two sentences
2. **Why it's useful:** the concept or problem it illustrates
3. **How to run it:** exact commands
4. **What I learned:** gotchas and notes

### Troubleshooting

If `cargo build` can't create `target/`, check that `dev` can write to
`/workspace`: `touch /workspace/test && rm /workspace/test` inside the
container should succeed. If it doesn't, the bind mount's permissions
don't match your host user.

## Topics

> Kind reminder: never try to "finish" (learning) a language. Reach productive fluency by becoming able to read an unfamiliar codebase, make a safe change, debug failures, test behavior, profile bottlenecks, and explain trade-offs.

A running list of topics covered in [`notes/`](notes/).

### Core mechanics

- [ ] Types
- [ ] Control flow
- [ ] Functions
- [ ] Collections
- [ ] Crates
- [ ] Errors
- [ ] I/O
- [ ] Debugging
- [ ] Build tooling
- [ ] Tests

### Idioms

- [ ] High-quality code in Rust's ecosystem
- [ ] Rust's "normal" APIs
- [ ] Naming
- [ ] Error model
- [ ] Ownership/memory model
- [ ] Conventions

### Production mechanics

- [ ] Logging
- [ ] Configuration
- [ ] Dependency management
- [ ] Concurrency
- [ ] Cancellation/timeouts
- [ ] Serialization
- [ ] Database/network access
- [ ] Observability
- [ ] Profiling
- [ ] Security boundaries

### Project(s)

> Narrow service/tool with a user/use case and constraints. Deliberate rewrites: make it work; then add tests and error handling; then refactor for clarity; then measure performance before optimizing.

- [ ] ...

## License

Code (Rust sources, Makefiles, Dockerfile, Compose files, etc.) is licensed under the [MIT License](LICENSE).
Written notes and documentation are licensed under [CC BY 4.0](https://creativecommons.org/licenses/by/4.0/).
