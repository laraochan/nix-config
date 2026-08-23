# Repository instructions

このファイルは、このリポジトリを変更するコーディングエージェント向けの
実装ルールと設計判断をまとめたものです。

## アーキテクチャ

このリポジトリは、設定の適用範囲によってディレクトリを分ける。

- `flake.nix`: inputs、ホストと構成の関連付け、対象アーキテクチャを定義する。
- `modules/common`: macOSとNixOSの全ホストに共通するシステム設定を置く。
- `modules/darwin`: 全Macに共通するパッケージ、Homebrew、macOS設定を置く。
- `modules/nixos`: 全NixOSホストに共通するパッケージとサービスを置く。
- `hosts/<os>/<hostname>`: ホスト名、CPU、ブート、ハードウェアなど1台固有の設定を置く。
- `home/larao`: Home Managerで生成するlaraoユーザーの設定を置く。

設定は、適用対象が最も狭く正確になる場所へ置く。複数ホストで共有する設定を
`hosts` に複製せず、対応する `modules` へ移す。

## パッケージ管理

パッケージのインストールはHome Managerではなく、OS構成を構成するNix moduleで完結させる。
複数ホストで共有するものは `modules`、1台だけで使うものは `hosts` に置く。

| 対象 | 配置場所 |
| --- | --- |
| macOSとNixOSで共通のCLI | `modules/common` の `environment.systemPackages` |
| Mac専用のNixパッケージ | `modules/darwin` の `environment.systemPackages` |
| NixOS専用のパッケージ | `modules/nixos` の `environment.systemPackages` |
| Mac用GUIアプリやHomebrewパッケージ | `modules/darwin` の `homebrew` |

### 現在のファイル運用

現時点ではパッケージ、サービス、ユーザーごとにファイルを細分化しない。
設定は各OSの `default.nix` に直接記述し、役割が大きくなった時点で分割する。

- 共通パッケージは `modules/common/default.nix` の `environment.systemPackages` に置く。
- NixOS共通パッケージは `modules/nixos/default.nix` の `environment.systemPackages` に置く。
- NixOSのサービスは同じファイルで `services.<name>.enable` などを使い、サービスが導入するパッケージを重複して追加しない。
- laraoだけに限定する必要があるNixOSパッケージは `users.users.${username}.packages` に置く。
- 特定ホストだけのパッケージは `hosts/nixos/<hostname>/default.nix` に置く。

`default.nix` が読みにくくなった場合に限り、`packages.nix`、`services.nix`、
`users/<name>.nix` など責務単位で分割し、`default.nix` からimportする。
将来の可能性だけを理由に空ファイルや細かいディレクトリを先に作らない。

macOSのGUIアプリは、原則としてHomebrew caskで管理する。`home.packages` は
使用しない。Home Manager側からパッケージを追加する変更も行わない。

### この方針の理由

この構成ではnix-darwin、NixOS、nix-homebrewを併用する。Home Managerにも
パッケージ管理を持たせると、インストール元、更新方法、重複の有無を判断しにくい。
そのため、パッケージとシステム設定は `modules`、ユーザー設定の生成はHome Manager
という境界を維持する。

この判断はnix-darwinとHomebrewを併用する現在の構成を前提とする。
nix-darwinを廃止する場合は、Home Managerによるパッケージ管理を含めて
責務分担を再検討する。

## Home Manager

Home Managerはユーザー設定と設定ファイルの生成だけを担当する。

### Nixvimの例外

NixvimはNeovim本体、プラグイン、LSP、設定を不可分なユーザー環境として
生成するため、Home Managerによるパッケージ導入を許可する明示的な例外とする。
通常版Neovimを `modules` 側へ重複して追加しない。Nixvim以外にはこの例外を
拡張しない。

- `programs.<name>.enable = true` 自体は禁止しない。
- モジュールを有効にする前に、パッケージを暗黙に追加するか実装を確認する。
- `package = null` でパッケージ導入を無効化できる場合は必ず指定する。
- パッケージ導入を無効化できないモジュールは使用しない。
- その場合は `home.file` または `xdg.configFile` で設定だけを生成する。

たとえばHomebrew版Ghosttyは次のように設定する。

```nix
programs.ghostty = {
  enable = true;
  package = null;
  settings = { };
};
```

`home/larao` はDarwinとNixOSで共有される。OS固有のアプリ設定は
`lib.mkIf pkgs.stdenv.hostPlatform.isDarwin` などで対象OSを限定する。

## ホストの追加

Macを追加する場合:

1. `hosts/darwin` の既存ホストをコピーする。
2. ホスト名、アーキテクチャ、端末固有設定を変更する。
3. `flake.nix` に `darwinConfigurations.<hostname>` を追加する。

NixOSホストを追加する場合:

1. `hosts/nixos/nixos-example` を新しいホスト名でコピーする。
2. 対象マシンで `nixos-generate-config --show-hardware-config` を実行する。
3. `hardware-configuration.nix` を生成結果で置き換える。
4. ホスト名、ブートローダー、アーキテクチャを調整する。
5. `flake.nix` に `nixosConfigurations.<hostname>` を追加する。

`nixos-example` のhardware設定を物理マシンへそのまま適用しない。

## 検証

Nix設定を変更した後は、少なくとも次を実行する。

```sh
nix flake check path:. --no-build
nix build path:.#darwinConfigurations.\"laraos-MacBook-Pro\".system --dry-run
```

Nixファイルを変更した場合は、フォーマッターと空白エラーも確認する。

```sh
nix run path:.#formatter.aarch64-darwin -- .
git diff --check
```
