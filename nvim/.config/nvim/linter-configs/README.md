# Neovim Linter Configurations

nvim-lint および LSP で使用するデフォルトのLinter設定ファイル群です。
プロジェクト固有の設定がない場合に、これらの設定が適用されます。

## 設定ファイル一覧

| ファイル | Linter | 対象言語 |
|---------|--------|---------|
| `phpstan.neon` | PHPStan | PHP |
| `biome.json` | Biome | JavaScript, TypeScript, JSON |
| `stylelint.config.mjs` | Stylelint | CSS, SCSS, Sass |
| `.sqlfluff` | SQLFluff | SQL |

## 各Linterの設定概要

### PHPStan (`phpstan.neon`)
- レベル8（最高レベル）で静的解析
- プロジェクトにphpstan.neonがある場合はそちらを優先

### Biome (`biome.json`)
- JavaScript/TypeScript/JSON用のLinter & Formatter
- 主なルール:
  - `noVar`: varの使用を警告
  - `useConst`: 再代入しないletをconst推奨
  - `noExplicitAny`: any型の明示的使用を警告
  - `noDoubleEquals`: ==の代わりに===を推奨
- プロジェクトにbiome.jsonがある場合はそちらを優先

### Stylelint (`stylelint.config.mjs`)
- CSS/SCSS/Sass用のLinter
- postcss-scss構文をサポート
- 主なルール:
  - `color-named`: 色名の使用を禁止
  - `declaration-no-important`: !importantの使用を警告
  - `selector-max-compound-selectors`: セレクタの深さを4に制限
  - `block-no-empty`: 空のブロックを禁止
  - `declaration-block-no-duplicate-properties`: 重複プロパティを禁止

### SQLFluff (`.sqlfluff`)
- SQL用のLinter
- PostgreSQL方言を使用
- 主なルール:
  - キーワードの大文字化
  - インデント (4スペース)
  - 行の最大長 120文字

## 使用方法

これらの設定は `~/.config/nvim/lua/plugins/nvim-lint.lua` および
`~/.config/nvim/lua/plugins/lspconfig.lua` から参照されます。

プロジェクト固有の設定を使用する場合は、プロジェクトルートに
対応する設定ファイルを配置してください。
