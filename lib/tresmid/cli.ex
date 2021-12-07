defmodule Tresmid.CLI do
  @moduledoc false

  def main(args) do
    args |> Tresmid.CLI.Options.parse_opts |> Tresmid.CLI.Commands.run
  end
end
