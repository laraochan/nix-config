# nix-darwin / NixOS multi-host configuration

The repository is split into reusable modules and per-machine configuration.

各ディレクトリの役割は次のとおりです。

- `hosts`: ホスト名、アーキテクチャ、ハードウェアなど各マシン固有の設定
- `modules`: 複数マシンで再利用する共通設定
- `home`: Home Managerで管理するユーザー設定

`hosts` に何を置くかの詳しい説明は [`hosts/README.md`](hosts/README.md) を
参照してください。

このリポジトリを変更するコーディングエージェント向けの実装ルールは
[`AGENTS.md`](AGENTS.md) に記載しています。READMEは人間向けの背景と設計判断、
AGENTS.mdは変更時に守る具体的なルールを担当します。

```text
.
├── flake.nix
├── home/larao
│   └── programs
│       ├── gh.nix
│       ├── ghostty.nix
│       ├── git.nix
│       ├── neovim.nix
│       ├── yazi.nix
│       └── zsh.nix
├── hosts
│   ├── darwin/laraos-macbook-pro
│   └── nixos/nixos-example
└── modules
    ├── common
    ├── darwin
    └── nixos
```

## Apply the existing Mac

```sh
sudo darwin-rebuild switch --flake .#laraos-MacBook-Pro
```

## Add a NixOS machine

1. Copy `hosts/nixos/nixos-example` to a directory named after the new host.
2. On that machine, replace `hardware-configuration.nix` with the output of
   `nixos-generate-config --show-hardware-config`.
3. Adjust the hostname, boot loader and architecture in the host module.
4. Add a `nixosConfigurations.<hostname>` entry to `flake.nix`.
5. Apply it with:

```sh
sudo nixos-rebuild switch --flake .#<hostname>
```

The checked-in `nixos-example` assumes an x86_64 QEMU-style machine with an
ext4 root filesystem labelled `nixos`; do not deploy it unchanged to physical
hardware.

## Home Manager

Both macOS and NixOS load `home/larao/default.nix` automatically as part of
their system rebuild. No separate `home-manager switch` command is required.

### パッケージ管理とHome Managerの責務

このリポジトリでは、パッケージのインストールをすべてOS側の `modules` で
完結させます。Home Managerはパッケージをインストールせず、ユーザー設定や
設定ファイルを生成する責務だけを持ちます。

```text
modules ── パッケージ、サービス、OS設定を管理
home    ── ユーザーの設定ファイルだけを生成
```

具体的な配置ルールは次のとおりです。

| 対象 | 配置場所 |
| --- | --- |
| macOSとNixOSで共通のCLI | `modules/common` の `environment.systemPackages` |
| Mac専用のNixパッケージ | `modules/darwin` の `environment.systemPackages` |
| NixOS専用のパッケージ | `modules/nixos` の `environment.systemPackages` |
| Mac用GUIアプリやHomebrewパッケージ | `modules/darwin` の `homebrew` |
| dotfilesやアプリのユーザー設定 | `home/larao` |

そのため、`home/larao` では次を原則として使用しません。

- `home.packages`
- パッケージ導入を目的とした `programs.<name>.enable`

Home Managerの `programs.<name>` モジュールは、有効化するとパッケージも暗黙に
追加する場合があります。設定だけを管理したいアプリでは、モジュールが対応して
いれば `package = null` を指定します。たとえばHomebrew版Ghosttyの設定は次の
ように管理できます。

```nix
programs.ghostty = {
  enable = true;
  package = null;
  settings = {
    font-size = 14;
  };
};
```

設定専用モードを提供しないHome Managerモジュールは無理に使わず、
`home.file` や `xdg.configFile` で設定ファイルだけを生成します。

### この方針にした理由

この構成ではnix-darwin、NixOS、nix-homebrewを併用します。Home Managerにも
パッケージ管理を持たせると、同じ端末のパッケージが複数の仕組みに分散し、
インストール元、更新方法、重複の有無を判断しにくくなります。

パッケージ管理を `modules` に集約することで、OSごとに何が導入されるかを
システム構成から確認できるようにします。Home ManagerはOSをまたいで再利用
できるユーザー設定の生成に集中させます。

この決定は、nix-darwinとHomebrewを併用する現在の構成を前提とします。
nix-darwinを使わない構成へ移行する場合は、Home Managerによるパッケージ管理を
含めて責務分担を再検討します。

To add another Mac, copy the existing Darwin host directory, adjust its host
settings, and add another `darwinConfigurations.<hostname>` entry.

## Check and format

```sh
nix flake check
nix fmt
```
