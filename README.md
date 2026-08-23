# nix-darwin / NixOS multi-host configuration

nix-darwinとNixOSの複数ホストを、共通モジュールとホスト固有設定に分けて
管理するflakeです。

## 構成

```text
.
├── flake.nix
├── home/larao
├── hosts
│   ├── darwin/laraos-macbook-pro
│   └── nixos/nixos-example
└── modules
    ├── common
    ├── darwin
    └── nixos
```

詳しい配置ルールと実装方針は [AGENTS.md](AGENTS.md)、ホスト構成の説明は
[hosts/README.md](hosts/README.md) を参照してください。

## macOSへ適用

```sh
sudo darwin-rebuild switch --flake .#laraos-MacBook-Pro
```

Home Managerもシステム再構築時に適用されるため、個別の
`home-manager switch` は不要です。

## NixOSへ適用

`nixos-example` はx86_64 QEMU向けのテンプレートです。実機では対象マシンで
生成した `hardware-configuration.nix` に置き換えてください。

```sh
sudo nixos-rebuild switch --flake .#<hostname>
```
