defmodule NervesTeamDevice.MixProject do
  use Mix.Project

  @app :nerves_team_device
  @all_targets [:rpi0]

  def project do
    [
      app: :nerves_team_device,
      version: "0.1.0",
      elixir: "~> 1.9",
      archives: [nerves_bootstrap: "~> 1.6"],
      start_permanent: Mix.env() == :prod,
      build_embedded: true,
      aliases: [loadconfig: [&bootstrap/1]],
      deps: deps(),
      releases: [{@app, release()}],
      preferred_cli_target: [run: :host, test: :host]
    ]
  end

  # Starting nerves_bootstrap adds the required aliases to Mix.Project.config()
  # Aliases are only added if MIX_TARGET is set.
  def bootstrap(args) do
    Application.start(:nerves_bootstrap)
    Mix.Task.run("loadconfig", args)
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      mod: {NervesTeamDevice.Application, []},
      extra_applications: [:logger, :runtime_tools]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      # Dependencies for all targets
      {:nerves, "~> 1.5.0", runtime: false},
      {:shoehorn, "~> 0.6"},
      {:ring_logger, "~> 0.6"},
      {:toolshed, "~> 0.2"},
      {:nerves_team_ui, path: "../nerves_team_ui"},

      # Dependencies for all targets except :host
      {:nerves_runtime, "~> 0.6", targets: @all_targets},
      {:nerves_init_gadget, "~> 0.4", targets: @all_targets},
      {:scenic_driver_oled_bonnet, 
        github: "nerves-training/scenic_driver_oled_bonnet",
        targets: @all_targets},

      # Dependencies for specific targets
      {:nerves_system_rpi0, "~> 1.8", runtime: false, targets: :rpi0},
      {:nerves_hub, "~> 0.7", targets: @all_targets},
      {:nerves_key, "~> 0.5", targets: @all_targets},
      {:nerves_key_pkcs11, "~> 0.2", targets: @all_targets},
      {:nerves_time, "~> 0.2", targets: @all_targets}, 
    ]
  end

  def release do
    [
      overwrite: true,
      cookie: "#{@app}_cookie",
      include_erts: &Nerves.Release.erts/0,
      steps: [&Nerves.Release.init/1, :assemble],
      strip_beams: Mix.env() == :prod
    ]
  end
end