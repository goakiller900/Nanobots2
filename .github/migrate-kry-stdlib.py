import json
import re
from pathlib import Path

root = Path('.')
old_root = '__stdlib2-continued__/'
new_root = '__kry_stdlib__/'

changed_imports = []
for path in root.rglob('*.lua'):
    if '.git' in path.parts or '.github' in path.parts:
        continue
    text = path.read_text(encoding='utf-8')
    updated = text.replace(old_root, new_root)
    if updated != text:
        path.write_text(updated, encoding='utf-8')
        changed_imports.append(path.as_posix())

if not changed_imports:
    raise SystemExit('No stdlib2-continued import paths were found')

info_path = root / 'info.json'
info = json.loads(info_path.read_text(encoding='utf-8'))
info['version'] = '3.4.3'
info['dependencies'] = [
    'kry_stdlib >= 2.2.4' if dependency.startswith('stdlib2-continued') else dependency
    for dependency in info['dependencies']
]
if 'kry_stdlib >= 2.2.4' not in info['dependencies']:
    raise SystemExit('Failed to replace the stdlib dependency')
info_path.write_text(json.dumps(info, indent=2) + '\n', encoding='utf-8')

readme_path = root / 'README.md'
readme = readme_path.read_text(encoding='utf-8')
readme = readme.replace(
    'Requires `stdlib2-continued` 2.1.0 or newer',
    'Requires `kry_stdlib` 2.2.4 or newer',
)
readme = readme.replace(
    'the `stdlib2-continued` dependency and import paths;',
    'the `kry_stdlib` dependency and import paths;',
)
readme_path.write_text(readme, encoding='utf-8')

changelog_path = root / 'changelog.txt'
changelog = changelog_path.read_text(encoding='utf-8')
entry = '''---------------------------------------------------------------------------------------------------
Version: 3.4.3
Date: 2026-07-13
  Changes:
    - Switched the stdlib dependency and import paths to kry_stdlib 2.2.4.
    - Updated validation and Factorio load testing for the maintained stdlib package.
---------------------------------------------------------------------------------------------------
'''
if 'Version: 3.4.3' not in changelog:
    changelog_path.write_text(entry + changelog, encoding='utf-8')

validate_path = root / '.github/workflows/validate.yml'
validate = validate_path.read_text(encoding='utf-8')
validate = validate.replace('stdlib2-continued >= 2.1.0', 'kry_stdlib >= 2.2.4')
validate = validate.replace(
    "legacy = ['__' + 'Nanobots2' + '__/', '__' + 'stdlib2' + '__/']",
    "legacy = ['__' + 'Nanobots2' + '__/', '__' + 'stdlib2' + '__/', '__stdlib2-continued__/']",
)
validate_path.write_text(validate, encoding='utf-8')

load_path = root / '.github/workflows/factorio-load-test.yml'
load = load_path.read_text(encoding='utf-8')
pattern = re.compile(
    r"          gh release download v2\.1\.2 \\\n"
    r"            --repo goakiller900/stdlib2 \\\n"
    r"            --pattern 'stdlib2-continued_2\.1\.2\.zip' \\\n"
    r"            --dir mods\n"
)
replacement = '''          curl --fail --location --retry 3 \\
            https://mods.factorio.com/api/mods/kry_stdlib/full \\
            --output /tmp/kry-stdlib.json
          download_url="$(jq -er '.releases[] | select(.version == "2.2.4") | .download_url' /tmp/kry-stdlib.json)"
          curl --fail --location --retry 3 \\
            "https://mods.factorio.com${download_url}" \\
            --output mods/kry_stdlib_2.2.4.zip
'''
load, replacements = pattern.subn(replacement, load, count=1)
if replacements != 1:
    raise SystemExit('Expected stdlib GitHub download block was not found')
load = load.replace('          GH_TOKEN: ${{ github.token }}\n', '')
load = load.replace('"stdlib2-continued"', '"kry_stdlib"')
load_path.write_text(load, encoding='utf-8')

print(f'Updated {len(changed_imports)} Lua import files')
for path in changed_imports:
    print(path)
