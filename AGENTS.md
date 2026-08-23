# Repository instructions

このファイルは、このリポジトリを変更するコーディングエージェント向けの
実装ルールと設計判断をまとめたものです。

## アーキテクチャ

このリポジトリは、設定の適用範囲と所有者によって責務を分ける。判断するときは
「どのマシンに適用するか」と「システムとユーザーのどちらが所有するか」を基準にする。

構成は次の方向に組み立てる。

1. `flake.nix` が対象ホストを選び、対象OSを `systemPlatform` で渡す。
2. `hosts/<os>/<hostname>` が `modules/default.nix` を読み込む。
3. `modules/default.nix` が共有設定と対応する `modules/<os>` を読み込む。
4. OS別moduleがHome Managerを統合し、`systemPlatform` を `homePlatform` として渡す。
5. `home/default.nix` が共有設定と対応する `home/<os>` を読み込み、ユーザー設定を生成する。

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
- `modules/default.nix` のimport

複数ホストで同じ設定が必要になった場合は、`hosts` に複製せず対応する
`modules` へ移す。ユーザーのシェルやアプリ設定も置かない。

### `modules`

`modules` はOS構成が所有する共有設定を置く。サービス、ログインシェル、
ユーザーアカウント、OS defaultsなど、ログイン前またはシステム全体で必要な設定を担当する。

- `modules/default.nix`: 両OSで共有するNix設定、システム機能、フォントとOS別moduleの選択
- `modules/darwin`: 全Macで共有するNixパッケージ、Homebrew、macOS defaults、
  nix-darwinへのHome Manager統合
- `modules/nixos`: 全NixOSホストで共有するパッケージ、サービス、ユーザー、locale、
  NixOSへのHome Manager統合

特定ホストのhardware設定やhostnameは置かない。ユーザー設定ファイルの内容も
`modules` に直接記述せず、Home Managerへ委譲する。

### `home`

`home` はlaraoユーザーとして生成する設定ファイルとユーザー環境を担当する。
両OSで共有する設定を `home` 直下、macOS固有の設定を `home/darwin`、
NixOS固有の設定を `home/nixos` に置く。`home/default.nix` は共有moduleと、
`homePlatform` に対応するOS別moduleだけをimportする。
共有する個別プログラムの設定は `home/<name>.nix`、OS固有なら対応するOSディレクトリに置く。
共有するプログラムの設定内に、片方のOSだけで意味を持つ設定キーが含まれていても、
そのプログラムが両OSで設定を受理できるなら、キー単位でOS別ファイルへ分割しない。
設定量が多いプログラムだけ、プログラム名のディレクトリへ分割する。
OS固有でも複数のプログラムやデスクトップ環境を横断する設定は、まず対応するOSの
`default.nix` に置き、読みにくくなった場合だけ責務単位のファイルへ分割する。

システムサービス、ユーザーアカウント、hardware設定は置かない。laraoだけが使う
CLIとその設定はHome Managerが所有し、可能なら `programs.<name>` moduleで本体と設定を
まとめて管理する。

設定手段や画面ではなく、状態の所有者で配置を決める。OSが機能を提供するための基盤、
実行ファイル、権限、サービスはOS構成が所有する。その機能をlaraoがどう使うかという選択や、
ユーザーのホームディレクトリまたはユーザー単位の設定データベースに保存される値は `home` が
所有する。OS構成が提供し、Home Managerが利用方法を選ぶという分担を依存方向とする。

### 配置を決める順序

1. laraoだけが使うCLIやユーザー設定なら `home` に置く。
2. システム設定で1台だけに適用するなら `hosts` に置く。
3. 同じOSの全ホストで共有するなら `modules/darwin` または `modules/nixos` に置く。
4. 両OSで共有するなら `modules/default.nix` に置く。

`home` が所有すると決めた設定は、DarwinとNixOSで共有するなら `home` 直下、
macOSだけなら `home/darwin`、NixOSだけなら `home/nixos` に置く。

設定は、実際の適用対象が最も狭く正確になる場所へ置く。将来共有するかもしれない
という理由だけで、ホスト固有の設定を先に共通化しない。

## パッケージ管理

パッケージは適用範囲だけでなく、誰が所有する機能かによって導入元を決める。
Home Managerを設定生成だけに制限せず、ユーザー環境と不可分なCLIの導入も担当させる。

| 対象 | 配置場所 |
| --- | --- |
| サービス、ログイン、全ユーザーに必要 | `modules` または `hosts` のOS構成 |
| laraoだけが使うCLI | `home` のHome Manager構成 |
| Mac用GUIアプリ | `modules/darwin` のHomebrew cask |
| NixOS用GUIアプリ | `modules/nixos` または対象の `hosts` |
| GUIアプリのユーザー設定 | `home` |
| polkit、ブラウザ連携などシステム統合が必要なアプリ | `modules` または `hosts` のOS構成 |

### 所有者を決める基準

次の順序で判断する。

1. OSの起動、ログイン、サービス提供に必要ならOS構成に置く。
2. 複数ユーザーが利用するシステム管理用ツールならOS構成に置く。
3. laraoの対話環境や設定と不可分なCLIならHome Managerに置く。
4. GUI本体はDarwinではHomebrew、NixOSではOS構成に置き、設定だけHome Managerに置く。

同じパッケージをOS構成とHome Managerの両方から導入するのは原則として避ける。
ログインシェルのzshのように、OSへの登録とユーザー設定の両方で必要な場合だけ許可する。
この構成では `home-manager.useGlobalPkgs = true` のため、両者は同じnixpkgsの成果物を
参照する。

### Home Managerでのパッケージ導入

ユーザー用CLIにHome Manager moduleがある場合は、`programs.<name>.enable = true` を使い、
パッケージ、設定、シェル統合を同じmoduleに所有させる。moduleがない場合に限り
`home.packages` を使う。

たとえばfzfとStarshipはHome Managerが所有する。

```nix
programs.fzf = {
  enable = true;
  enableZshIntegration = true;
};

programs.starship = {
  enable = true;
  enableZshIntegration = true;
};
```

一方、zsh本体はログインシェルとしてOS構成でも有効にし、補完、履歴、aliasなどの
ユーザー設定は `programs.zsh` で管理する。この重複を他のCLIへ一般化しない。

1つのmoduleが実行ファイルだけでなく、権限、サービス、OS統合を一体で提供する場合は、
機能全体をOS構成に所有させる。ユーザー用CLIとして独立しており、システム権限やサービスを
必要としない部分だけをHome Managerへ委譲する。導入手段を揃えるために、不可分な機能を
複数の所有者へ分解しない。

### 非自由パッケージ

非自由パッケージは `nixpkgs.config.allowUnfree = true` で一括許可せず、原則として
`allowUnfreePredicate` で実際に導入するパッケージだけを許可する。この設定はパッケージの
ユーザー設定ではなくnixpkgsの評価ポリシーなので、`home` ではなく、そのnixpkgsを提供する
`modules/darwin` または `modules/nixos` に置く。

この構成では `home-manager.useGlobalPkgs = true` のため、Home Managerから導入する非自由
パッケージもOS構成のpredicateで許可する。ラッパーと内部成果物の両方が評価対象になる場合は、
評価に必要な名前を過不足なく許可する。許可リストを `modules/default.nix` に集約せず、
不要なOSまで許可範囲を広げない。

### ファイルの分割

現時点ではOS moduleをパッケージ、サービス、ユーザーごとに細分化しない。
設定は各OSの `default.nix` に直接記述し、読みにくくなった時点で分割する。

`default.nix` が読みにくくなった場合に限り、`packages.nix`、`services.nix`、
`users/<name>.nix` など責務単位で分割し、`default.nix` からimportする。
将来の可能性だけを理由に空ファイルや細かいディレクトリを先に作らない。

macOSのGUIアプリは原則としてHomebrew caskで管理する。Homebrew版アプリを
Home Manager moduleで設定する場合は、対応していれば `package = null` を指定する。

### この方針の理由

パッケージをすべてOS構成へ集約すると、Home Managerのmoduleが提供する設定生成、
シェル統合、関連ファイルの一貫した管理を利用できない。一方、すべてをHome Managerへ
移すと、サービスやログインなどOSが所有すべき機能との境界が崩れる。そのため、導入手段
ではなく機能の所有者を基準に分ける。

## Home Manager

Home Managerはlaraoのユーザー環境を担当し、ユーザー用CLI、その設定ファイル、
シェル統合を一体として管理する。Nixvimもこの原則に従ってHome Managerが所有する。

OS構成またはHomebrewが本体を所有するGUIアプリは、Home Managerから重複導入しない。
`package = null` を利用できない場合は、そのmoduleを使わず `home.file` または
`xdg.configFile` で設定だけを生成する。

たとえばHomebrew版Ghosttyは次のように設定する。

```nix
programs.ghostty = {
  enable = true;
  package = null;
  settings = { };
};
```

`flake.nix` は `specialArgs.systemPlatform` に `"darwin"` または `"nixos"` を渡す。
`modules/default.nix` はこの値でOS別moduleを選び、OS別moduleは同じ値をHome Managerの
`extraSpecialArgs.homePlatform` へ渡す。`home/default.nix` はこの値でOS別moduleを選ぶ。
module引数の評価が循環するため、`imports` の条件に `pkgs` や `config` を使わない。
OS固有のmodule、option、パッケージ、またはファイル全体が片方のOSにしか適用できない設定は
対応するOSディレクトリに置く。共有プログラムの設定は個々のキー名だけを理由に分割せず、
共有ファイル内で同じOS分岐も重ねない。

デスクトップ環境では、機能を利用可能にするシステム基盤と、ユーザーが選ぶ状態を分離する。
設定値がユーザー単位で保存され、ユーザー設定がシステム既定値より優先される仕組みでは、
OS構成に既定値を書いてlaraoの状態を間接的に制御しない。Home Managerからユーザー単位の
設定を直接生成する。全ユーザーへ同じ値を強制する要件がある場合だけ、OS構成のポリシーとして
管理する。

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
nix fmt
git diff --check
```
