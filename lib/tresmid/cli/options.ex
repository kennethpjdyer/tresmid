defmodule Tresmid.CLI.Options do
  @moduledoc """

  ```text
  {Tresmid.CLI.Docs.opts}
  ```

  """

  @spec docs :: [
          {<<_::8>>, <<_::40, _::_*16>>, <<_::264, _::_*64>>}
          | {<<_::8>>, <<_::24>>, <<_::24>>, <<_::216>>},
          ...
        ]
  def docs do
    [
      {"c", "config", "PATH",
        "Sets the configuration file, (defaults to ~/.config/tresmid/config.yml)."
      },
      {"L", "local", "Specifies local repository configuration."},
      {"v", "verbose", "Enables verbose logging messages."}
    ]
  end

  def parse_opts(args) do
    OptionParser.parse(
      args, [
        switches: [
          config: :string,
          verbose: :boolean
        ], aliases: [
          c: :config,
          v: :verbose
        ]
      ])
    |> preproc_opts
  end

  def preproc_opts({opts, args, []}) do
    # TODO: Add Runtime Logging Configuration
    cond do
      Enum.member?(args, "help") ->
        {opts, args, :help}
      true ->
        # Start Config Server
        Tresmid.Config.start_link(opts[:config])

        # Set Verbose
        if Enum.member?(opts, :verbose) do
          Tresmid.Config.set(:verbose, true)
        else
          Tresmid.Config.set(:verbose, false)
        end
        {opts, args}
    end
  end

  def preproc_opts({_opts, _args, bad}) do
    IO.puts("CRITICAL: Invalid Options")
    IO.inspect bad
    System.halt(1)
  end
end
