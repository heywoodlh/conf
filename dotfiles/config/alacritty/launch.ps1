#!/usr/bin/env pwsh

# PowerShell script for launching stuff with Alacritty
# Launch Tmux on Linux/MacOS, don't on Windows
if (-not ($isWindows)) {
    $env:PATH = "/etc/profiles/per-user/$env:USER/bin:/run/current-system/sw/bin:$env:PATH"
    $env:TERM = "screen-256color"
    tmux
} else {
    pwsh
}
