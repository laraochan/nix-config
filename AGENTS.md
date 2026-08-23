# Repository instructions

このファイルは、このリポジトリを変更するコーディングエージェント向けの
実装ルールと設計判断をまとめたものです。

## アーキテクチャ

このリポジトリは、設定の適用範囲と所有者によって責務を分ける。判断するときは
「どのマシンに適用するか」と「システムとユーザーのどちらが所有するか」を基準にする。

構成は次の方向に組み立てる。

1. `flake.nix` が対象ホストを選び、`hosts/<os>/<hostname>` を読み込む。
2. 各ホストが対応する `modules/darwin` または `modules/nixos` を読み込む。
3. OS別moduleが `modules/common` とHome Managerを読み込む。
4. Home Managerが `home/larao` からユーザー設定を生成する。

依存方向を逆にしない。共通moduleから特定ホストを参照したり、Home Managerから
システムmoduleを読み込んだりしない。

### `flake.nix`

flake inputs、ホストと構成の関連付け、対象アーキテクチャ、formatterを定義する。
パッケージ、サービス、dotfilesの具体的な設定は置かない。構成名は原則として
対象マシンの `networking.hostName` と一致させ、`--flake .` で現在のホストを
自動選択できるようにする。

### `hosts`

`hosts/<os>/<hostname>` は1台のマシン固有の入口である。ディレクトリ名は原則として
hostnameの小文字表記と一致させる。

ここには次の設定を置く。

- `networking.hostName` とホストのアーキテクチャ
- ブートローダー、ディスク、ファイルシステム、CPU、GPU
- `hardware-configuration.nix`
- その1台だけで必要なサービス、パッケージ、OS設定
- 対応するOS共通moduleのimport

複数ホストで同じ設定が必要になった場合は、`hosts` に複製せず対応する
`modules` へ移す。ユーザーのシェルやアプリ設定も置かない。

### `modules`

`modules` はOS構成が所有する共有設定を置く。パッケージのインストール、サービス、
ユーザーアカウント、OS defaultsなど、管理者権限で適用する設定を担当する。

- `modules/common`: macOSとNixOSの全ホストで共有するNix設定とCLIパッケージ
- `modules/darwin`: 全Macで共有するNixパッケージ、Homebrew、macOS defaults、
  nix-darwinへのHome Manager統合
- `modules/nixos`: 全NixOSホストで共有するパッケージ、サービス、ユーザー、locale、
  NixOSへのHome Manager統合

特定ホストのhardware設定やhostnameは置かない。ユーザー設定ファイルの内容も
`modules` に直接記述せず、Home Managerへ委譲する。

### `home/larao`

`home/larao` はlaraoユーザーとして生成する設定ファイルとユーザー環境を担当する。
シェル、Git、エディタ、ターミナルなどの設定を置き、DarwinとNixOSで共有する。

OSパッケージ、システムサービス、ユーザーアカウント、hardware設定は置かない。
パッケージの導入元を一意に保つため、原則としてHome Managerからパッケージを
インストールしない。例外は後述するNixvimだけとする。

### 配置を決める順序

1. ユーザー設定ファイルなら `home/larao` に置く。
2. システム設定で1台だけに適用するなら `hosts` に置く。
3. 同じOSの全ホストで共有するなら `modules/darwin` または `modules/nixos` に置く。
4. 両OSで共有するなら `modules/common` に置く。

設定は、実際の適用対象が最も狭く正確になる場所へ置く。将来共有するかもしれない
という理由だけで、ホスト固有の設定を先に共通化しない。

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

Home Managerはシステム構成に統合されているため、個別に
`home-manager switch` を実行しない。

## 設定の適用

macOSへ適用する場合:

```sh
sudo darwin-rebuild switch --flake .
```

ThinkPadのNixOSへ適用する場合:

```sh
sudo nixos-rebuild switch --flake .
```

hostname変更前の初回適用や、現在とは別のホスト構成を対象にする場合だけ、
`--flake .#<hostname>` と構成名を明示する。

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
