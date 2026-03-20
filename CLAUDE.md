# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a bash script that provides a tmux popup interface for quickly selecting and inserting file paths using fzf. It's designed for AI coding assistants like Claude Code to make file referencing seamless. The script runs inside tmux sessions and sends selected file paths back to the active pane.

## Core Architecture

### Configuration
- Config file: `~/.config/tmux-file-picker/config` (sourceable bash)
- Example: `config.example` in repo root
- `_load_config()` (tmux-file-picker:4-18) loads defaults then sources config
- Settings: `dir_roots`, `use_zoxide`, `dir_excludes`, `dir_max_depth`, `fd_flags`, `refs_dir`
- Install config via `make install-config`

### Main Entry Point
- `main()` function (tmux-file-picker:20) orchestrates the entire flow
- Script must run inside a tmux session (validates at tmux-file-picker:21)

### Execution Flow
1. **Argument Parsing** (tmux-file-picker:36-79): Processes flags and path arguments
2. **Directory Selection** (tmux-file-picker:82-111): Determines search directory
3. **Mode Detection** (tmux-file-picker:113-124): Detects if running in AI assistant context
4. **File Selection** (tmux-file-picker:152-168): Uses fzf for interactive file picking
5. **Path Processing** (tmux-file-picker:170-212): Handles relativization and formatting
6. **Output** (tmux-file-picker:214-230): Sends formatted paths to tmux pane

### Key Features

**Directory Picker (Alt-D)**
- Searches within configured `dir_roots` (defaults to `~` if unset)
- Optionally merges zoxide frecent directories when `use_zoxide=true`
- Excludes noise directories via `dir_excludes` config
- Deduplicates results when zoxide and fd overlap

**Smart Path Handling**
- Relative paths: Default when searching from current directory
- Absolute paths: Used when directory is changed via Alt-D
- Git-relative paths: With `--git-root` flag, paths are relative to git repository root

**At-Prefix Mode Detection** (tmux-file-picker:114-117)
- Detects AI assistants (claude, gemini, codex) by process inspection
- Formats output with `@` prefix for AI file references
- Otherwise shell-escapes paths for terminal safety

## Dependencies

**Required:**
- `tmux`: Must be running in a tmux session
- `fzf`: Interactive fuzzy finder
- `fd` (or `fdfind`): Fast file discovery
- `grealpath` (macOS): Path resolution (from coreutils via Homebrew)

**Optional:**
- `bat`/`batcat`: Syntax-highlighted file previews in fzf
- `zoxide`: Directory jumping for `--zoxide` flag
- `tree`: Better directory previews with zoxide

## Command Line Interface

### Flags
- `--git-root` / `-g`: Show paths relative to git repository root

### Arguments
- Optional path argument: Search in specific directory instead of current pane directory

### Environment Variables
- `XDG_CONFIG_HOME`: Overrides config file location (default: `~/.config`)

## Development Notes

### Testing the Script
Since this is a tmux-specific script, testing requires:
1. Running inside a tmux session
2. Test with `display-popup -E "./tmux-file-picker [flags]"` for popup behavior
3. Test with various flag combinations and directory scenarios

### Path Resolution Logic
- macOS uses `grealpath` instead of `realpath` (tmux-file-picker:100)
- Relative paths are resolved from pane's current directory (tmux-file-picker:94-96)
- `realpath -m` allows checking non-existent paths (tmux-file-picker:103)

### Critical Behaviors
- Empty selections exit gracefully (tmux-file-picker:87-88, 166-168)
- Paths with spaces are properly escaped in non-at-prefix mode
- Multiple file selection is supported via fzf's `--multi` flag

### Output Formatting
Two modes based on context detection:
1. **At-prefix mode**: `@path1 @path2 @path3 ` for AI assistants
2. **Shell mode**: Properly escaped paths for shell usage
