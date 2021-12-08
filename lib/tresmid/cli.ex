defmodule Tresmid.CLI do
  @moduledoc """

  The primary interface for Tresmid is the command-line application
  `tresmid`.

  For additional information on its use, see:

  * `Tresmid.CLI.Options`

  * `Tresmid.CLI.Commands`

  """

  def main(args) do
    args |> Tresmid.CLI.Options.parse_opts |> Tresmid.CLI.Commands.run
  end
end
