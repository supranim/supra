<p align="center">
  Supra is the CLI tool for creating new Supranim projects and managing them!<br>
</p>

<p align="center">
  <code>nimble install supra</code>
</p>

<p align="center">
  <a href="https://github.com/">API reference</a><br>
  <img src="https://github.com/supranim/supra/workflows/test/badge.svg" alt="Github Actions">  <img src="https://github.com/supranim/supra/workflows/docs/badge.svg" alt="Github Actions">
</p>

## 😍 Key Features
- [x] Bootstrap new Supranim projects with a single command
- [x] Download and extract starter template from GitHub
- [ ] Interactive prompts for project configuration (name, author, license)
- [ ] Start customizable project templates
- [ ] Start versioned project templates (e.g. with specific versions of dependencies)
- [x] Written in Nim language

### Create a new project

Initialize a new Supranim project from a starter template hosted on GitHub, the default
template is the official [Starter Kit](https://github.com/supranim/app) available on the `main` branch.
```bash
supra init my-new-app
```

### Create a new REST API project

Use the `--restapi` flag to bootstrap from the
[REST API Starter Kit](https://github.com/supranim/starterkit-api).
You'll get an interactive checkbox prompt to pick YAML-based recipes
(`Space` to toggle, `Enter` to confirm). Each recipe adds its
`.nimble` dependencies, drops a service provider into
`src/service/provider/`, and wires its `init` line into `App.services`.
```bash
supra init my-new-api --restapi
```

Available recipes: `jose`, `nimcypher`, `brotli`, `mimedb`, `bag`,
`blackpaper`, `multipart`.

For non-interactive use (CI), select recipes with flags instead:
```bash
supra init my-new-api --restapi --skipconfig --with=jose,bag,blackpaper
supra init my-new-api --restapi --skipconfig --without=multipart
```

### ❤ Contributions & Support
- 🐛 Found a bug? [Create a new Issue](https://github.com/supranim/supra/issues)
- 👋 Wanna help? [Fork it!](https://github.com/supranim/supra/fork)
- 😎 [Get €20 in cloud credits from Hetzner](https://hetzner.cloud/?ref=Hm0mYGM9NxZ4)
- 🥰 [Donate via PayPal address](https://www.paypal.com/donate/?hosted_button_id=RJK3ZTDWPL55C)

### 🎩 License
Supranim | MIT license. [Made by Humans from OpenPeeps](https://github.com/openpeeps).<br>
Copyright &copy; 2025 OpenPeeps & Contributors &mdash; All rights reserved.
