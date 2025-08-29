# Claude Code Working Preferences

## Work with git
- First, before implement any feature, check if we are on the right git branch.
- Create branch for each new feature.
- Small changes can be implemented and pushed directly in main branch.

## Project Overview
- **Type**: Godot 4.4 game project (Call of Chivalry)
- **Template**: Based on Maaack's Game Template
- **CI/CD**: GitHub Actions for Windows builds

## Working Style
- **Be direct and concise** - минимум лишних слов, максимум результата
- **Use TodoWrite proactively** for task planning and tracking
- **Systematic debugging** - check logs, compare configs, find root cause
- **Quick iteration cycles** - commit, push, verify results
- **Use existing template** - Стараться использовать существующий интерфейс Maaack's Game Template там где это уместно, не создавать дублирующие UI системы

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

### Game Architecture (Maaack's Template)

#### Structure
- **Levels**: Each location is a Level scene in `game/scenes/game_scene/levels/`
- **GameState**: Singleton for game progress, saves to user://
- **LevelState**: Per-level state (items found, challenges completed)
- **MainMenu**: Handles Continue/New Game/Level Select
- **Overlaid Menus**: Pause, Win/Lose screens as overlays

#### Navigation Flow
1. MainMenu → Start Game → Level 1
2. Level complete → signal `level_won_and_changed` → Next Level
3. GameState tracks progress automatically
4. Level Select shows unlocked levels from GameState

#### Key Files
- `game/scripts/game_state.gd` - Game progress management
- `game/scenes/menus/main_menu/main_menu_with_animations.gd` - Main menu
- `game/scenes/game_scene/levels/level.gd` - Base level logic
- `game/scenes/menus/level_select_menu/level_select_menu.gd` - Level selection

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

### Automated Testing

#### Test Framework
- **Test Runner**: `game/scenes/test/test_runner.tscn` - Orchestrates all tests
- **Test Scripts**: Located in `game/scripts/test/` directory
- **Test Pattern**: All test files should end with `_test.gd`

#### Running Tests Locally
```bash
# Windows (from project root)
test.bat

# Linux/Mac or Git Bash
./test.sh

# Using Godot directly
godot --headless --path . game/scenes/test/test_runner.tscn

# Using MCP tools (when available)
mcp__godot-mcp__run_project with scene: game/scenes/test/test_runner.tscn
```

#### Test Development Guidelines
1. **Always run tests before committing** - Use `test.bat` or MCP tools
2. **Add tests for new features** - Create new test files in `game/scripts/test/`
3. **Use assertions** - Each test should use `assert_equals()` for validation
4. **Signal testing** - Connect to signals and verify they emit correctly
5. **Return test results** - Implement `get_results()` method for CI integration

#### MCP Testing Tools Available
- `mcp__godot-mcp__run_project` - Run project with specific scene
- `mcp__godot-mcp__get_debug_output` - Check for errors and debug output
- `mcp__godot-mcp__stop_project` - Stop running project

#### Test Result Format
Tests return results in this format:
```gdscript
{
  "total": 26,
  "passed": 26,
  "failed": 0,
  "details": [...]
}
```

## Language Preference

Можно общаться на русском или английском - как удобнее.

## Описание игры

Call of Chivalry - 2D игра, главной задачей игрока является прохождение рыцарем череды испытаний. Каждое испытание представляет из себя "диалог" с вариантами действий. В каждом таком испытании рыцарь вынужден будет хитрить, тратить предметы либо откупаться золотом или здоровьем. Например, столкнувшись с бандитами рыцарь может сделать одно из следующих действий:
- воспользоваться мечом и потерять меч, но получить награду за устранение бандитов
- ускакать на коне, если конь имеется
- откупиться золотом
- ввязаться в драку и потерять 1 очко здоровья
После этого рыцарь автоматически перемещается к следующей задачке в локации либо, если задачки в локации кончились, игроку даётся выбор, куда направиться дальше.

Это и будет основой геймплея. Игрок будет посещать разные локации и сталкиваться с разными проблемами, постепенно узнавать и предугадывать опасности и на основе этого организовывать свой инвентарь и планировать свои действия.

### Основные игровые сущности:

#### Рыцарь

У рыцаря есть инвентарь с предметами, а так же 3 очка здоровья, 5 золотых монет и конь. Рыцарь перемещается с локации на локацию, преодолевает трудности и двигается к концу приключения. В конце его ждёт пещера с драконом.

#### Инвентарь

Перед началом приключения рыцарь набирает себе в инвентарь предметов со склада. После этого, рыцарь может сходить в магазин и купить там уникальные предметы за золото. Размер инвентаря - 10x10 клеток, максимальный вес - 50кг.

#### Предмет

Предметы хранятся в инвентаре рыцаря, предметы можно выкидывать (уничтожать). У предметов есть вес, а у инвентаря ограниченное количество слотов. Большинство предметов расходуется при использовании. Предметы нужны для прохождения испытаний, у каждого испытания свой набор предметов, которые могут помочь преодолеть испытание. Предметы имеют вес и могут занимать больше одного слота в инвентаре. Кроме того, все предметы должны иметь своё отображение на рыцаре.

#### Локация

Локация это набор тематически связанных испытаний, которые должен пройти рыцарь, чтобы перейти к следующей локации. В каждой локации может быть от 1 до 5 испытаний, в зависимости от типа локации и удачи. Чем меньше испытаний, тем они должны быть сложнее. Пройдя одну локацию, рыцарь получает выбор, к какой локации перейти. Пусть для начала будет всего 10 локаций:
- лес
- степь
- тундра
- болото
- пустыня
- ледник
- гора
- вулкан
- пещера
- логово дракона

#### Испытание

У каждой локации есть набор испытаний (штук 10), при входе в локацию выбирается 1-3 испытаний из этой локации и рыцарь должен пройти их одно за другим. Следующее испытание начинается как только рыцарь разобрался с текущим. Порядок и количество испытаний выбираются случайно при входе в локацию. У каждого испытания есть условная сложность (от 1 до 10), испытания должны подбираться так, чтобы суммарная их сложность была от 5 до 10.

Само испытание представляет из себя сценку с описанием проблемы и вариантами решения. Среди вариантов решения встречаются только те, которые удовлетворяют условиям. Если рыцарь встретил в лесу бандитов, но у него нет меча, то варианта помахать мечом не будет, останется лишь откупаться, драться или бежать.

#### Игровая карта

Игровая карта это набор локаций, расположенных друг за другом рядами по 3. Рыцарь может двигаться только вперёд по диагонали, не считая последней локации, вход в которую обязателен после прохождения трёх локаций до этого. Первую локацию можно выбрать свободно. Ряды локаций:
лес степь тундра
болото пустыня ледник
гора вулкан пещера
логово дракона

Таким образом, рыцарь изначально выбирает между лесом, степью и тундрой. Выбрав лес, дальше он сможет пойти в пустыню или ледник, болото исключается. Если он прошёл ледник, то дальше он может пойти в гору или вулкан. Пройдя третью локацию он оказывается в логове дракона.


### Визуальный стиль

Мультяшный, слегка комичный стиль. По ходу приключения рыцарь будет терять снаряжение и до дракона он будет добираться почти голый, это должно выглядеть забавно.

