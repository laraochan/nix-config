# Repository instructions

このファイルは、このリポジトリを変更するコーディングエージェント向けの
実装ルールです。

## パッケージ管理

- パッケージのインストールは、すべて `modules` 配下で完結させる。
- macOSとNixOSで共通のパッケージは `modules/common` に置く。
- Mac専用のNixパッケージは `modules/darwin` に置く。
- NixOS専用のパッケージは `modules/nixos` に置く。
- macOSのGUIアプリは、原則として `modules/darwin` のHomebrew caskで管理する。
- `home.packages` は使用しない。

## Home Manager

- Home Managerは、ユーザー設定と設定ファイルの生成だけを担当する。
- `programs.<name>.enable = true` 自体は禁止しない。
- Home Managerモジュールを有効にする前に、パッケージを暗黙に追加するか確認する。
- `package = null` でパッケージ導入を無効化できる場合は、それを指定する。
- パッケージ導入を無効化できないモジュールは使用しない。
- その場合は `home.file` または `xdg.configFile` で設定ファイルだけを生成する。
- Home Manager側からパッケージを追加する変更は行わない。

## 設定の配置

- 全OS・全ホスト共通のシステム設定は `modules/common` に置く。
- 全Mac共通の設定は `modules/darwin` に置く。
- 全NixOSホスト共通の設定は `modules/nixos` に置く。
- 特定のマシンだけの設定は `hosts/<os>/<hostname>` に置く。
- laraoユーザーの設定ファイルは `home/larao` に置く。

## 検証

Nix設定を変更した後は、少なくとも次を実行する。

```sh
nix flake check path:. --no-build
nix build 'path:.#darwinConfigurations."laraos-MacBook-Pro".system' --dry-run
```

Nixファイルを変更した場合は、フォーマッターと空白エラーの確認も行う。

```sh
nix run path:.#formatter.aarch64-darwin -- .
git diff --check
```
