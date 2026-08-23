# hosts ディレクトリ

`hosts` には、各マシンに固有の設定を置きます。1台につき1ディレクトリを作り、
ディレクトリ名は原則としてホスト名と合わせます。

```text
hosts/
├── darwin/
│   └── laraos-macbook-pro/
│       └── default.nix
└── nixos/
    ├── thinkpad-e14-gen5/
    │   ├── default.nix
    │   └── hardware-configuration.nix
    └── nixos-example/
        ├── default.nix
        └── hardware-configuration.nix
```

## hosts に置くもの

- ホスト名
- CPUアーキテクチャ
- ブートローダーやディスク構成
- そのマシンだけで有効にするサービス
- 画面、GPU、ネットワークなどのハードウェア固有設定
- そのマシンだけに必要なパッケージやmacOS defaults

複数のマシンで共有したい設定は `hosts` ではなく `modules` に置きます。
ユーザー個人のシェル、Git、dotfiles、ユーザー用パッケージは `home/larao` に
置きます。

## Darwinホスト

`hosts/darwin/<hostname>/default.nix` にはMac固有の設定を記述します。

現在の `laraos-macbook-pro` には次の設定があります。

- `modules/darwin` の読み込み
- `networking.hostName`
- `nixpkgs.hostPlatform`

DockやHomebrewアプリなど、すべてのMacで共通にする設定は
`modules/darwin` に置いています。

Macを追加する場合は既存ディレクトリをコピーし、ホスト名やアーキテクチャ、
端末固有設定を変更します。その後、`flake.nix` に
`darwinConfigurations.<hostname>` を追加します。

## NixOSホスト

`hosts/nixos/<hostname>/default.nix` にはNixOSマシン固有の設定を記述します。

- `modules/nixos` の読み込み
- `networking.hostName`
- ブートローダー
- マシン固有のサービス
- `hardware-configuration.nix` の読み込み

`hardware-configuration.nix` は対象マシンのディスク、ファイルシステム、カーネル
モジュールなどを記録するため、別のマシンからコピーして使わないでください。
対象マシンで次のコマンドを実行して生成します。

```sh
nixos-generate-config --show-hardware-config
```

生成した内容で対象ホストの `hardware-configuration.nix` を置き換えます。

## 設定の置き場所

| 設定内容 | 置き場所 |
| --- | --- |
| 全OS・全マシン共通 | `modules/common` |
| 全Mac共通 | `modules/darwin` |
| 全NixOS共通 | `modules/nixos` |
| 特定の1台だけ | `hosts/<os>/<hostname>` |
| laraoのユーザー設定 | `home/larao` |

迷った場合は、まずホスト側に追加し、2台以上で同じ設定が必要になった時点で
対応する `modules` へ移すと管理しやすくなります。
