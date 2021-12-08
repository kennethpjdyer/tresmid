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
      {"C", "cwd", "DIR", "Sets the current directory."},
      {"L", "local", "Specifies local repository configuration."},
      {"v", "verbose", "Enables verbose logging messages."}
    ]
  end

  def parse_opts(args) do
    OptionParser.parse(
      args, [
        switches: [
          cwd: :string,
          local: :boolean,
          verbose: :boolean
        ], aliases: [
          C: :cwd,
          L: :local,
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
        if Enum.member?(opts, :verbose) do
          Tresmid.Database.start_link(true)
        else
          Tresmid.Database.start_link(false)
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
