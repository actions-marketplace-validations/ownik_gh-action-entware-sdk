# 🚀 gh-action-entware-sdk ![GitHub Actions Workflow Status](https://img.shields.io/github/actions/workflow/status/ownik/gh-action-entware-sdk/test.yml?label=test)

**gh-action-entware-sdk** is a GitHub Action for building packages for **Entware** using a prebuilt SDK.

Instead of compiling the full toolchain every time, the action uses a **prebuilt Entware SDK**, dramatically reducing CI build times.

The unofficial SDK builds are available here: https://github.com/ownik/entware-sdk

# 📦 Usage

```yaml
name: Build Entware Package

jobs:
  build:
    runs-on: ubuntu-latest

    steps:
      - name: Checkout repository
        uses: actions/checkout@v4

      - name: Build packages
        uses: ownik/gh-action-entware-sdk@v1
        env:
          PACKAGES: my-package
          V: s
```

---

# ⚙️ Configuration

The action is configured using **environment variables**.

| Variable | Description |
|--------|--------|
| **CONTAINER** | Allows using a different SDK container instead of `ghcr.io/openwrt/buildbot/buildworker-v3.11.3:latest`. |
| **PACKAGES** | List of packages to build. |
| **V** | Build verbosity level (passed to `make`). |
| **BUILD_LOG** | If enabled, stores build logs in `./logs`. |
| **ARTIFACTS_DIR** | Directory where built packages will be stored. Default: `GITHUB_WORKSPACE`. |
| **FEED_DIR** | Path used in the generated `feeds.conf` for the current repository. Default: `GITHUB_WORKSPACE`. |
| **FEEDNAME** | Feed name used in the generated `feeds.conf`. Default: `action`. |
| **EXTRA_FEEDS** | Additional feeds added to `feeds.conf`. `\|` characters are replaced with spaces. |
| **IGNORE_ERRORS** | If enabled, allows the build to continue even if some packages fail. |

# 🐳 Build Environment

By default the action runs inside the official OpenWrt build worker container:

```
ghcr.io/openwrt/buildbot/buildworker-v3.11.3:latest
```

This is currently the **latest image that still includes Python 2**, which is still required by parts of the Entware.

You may override this container using the `CONTAINER` variable.

# 🔗 Related Projects

+ **Entware SDK builds** https://github.com/ownik/entware-sdk
+ **Entware project** https://github.com/Entware/Entware
