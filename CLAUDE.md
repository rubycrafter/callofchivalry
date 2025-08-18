# Claude Code Working Preferences

## Project Overview
- **Type**: Godot 4.4 game project (Call of Chivalry)
- **Template**: Based on Maaack's Game Template
- **CI/CD**: GitHub Actions for Windows builds

## Working Style
- **Be direct and concise** - минимум лишних слов, максимум результата
- **Use TodoWrite proactively** for task planning and tracking
- **Systematic debugging** - check logs, compare configs, find root cause
- **Quick iteration cycles** - commit, push, verify results

## Project-Specific Knowledge

### Build & Export
- Export preset: `export_presets.cfg` configured for Windows Desktop
- Binary format: embed_pck=true (single exe file)
- Main scene: Use direct paths, not UIDs (UIDs may fail in CI)
- Console wrapper: Keep disabled for release builds

### CI Pipeline
- Workflow: `.github/workflows/ci.yml`
- Godot version: 4.4.0 (use full semantic version)
- Build output: `builds/windows/call-of-chivalry.exe`
- Artifacts uploaded as `windows-build`

### Common Issues & Solutions
1. **App crashes on startup after CI build**
   - Check if main_scene uses UID instead of direct path
   - Verify export_presets.cfg settings
   - Look for UID resolution warnings in build logs

2. **Pipeline failures**
   - Godot setup needs full version (4.4.0, not 4.4)
   - Export presets must exist before build
   - Verify build output before uploading artifacts

### Testing Commands
```bash
# Check PR status
gh pr checks <number>

# View pipeline logs
gh run view <run-id> --log

# Check available artifacts
gh api repos/rubycrafter/callofchivalry/actions/runs/<run-id>/artifacts
```

## Language Preference
Можно общаться на русском или английском - как удобнее.