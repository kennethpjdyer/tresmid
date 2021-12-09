defmodule Tresmid.Make do
  require Logger

  def run(repo, ticket, text, upstream) do
    Logger.info("Called make operation.")
    IO.inspect {repo, ticket, text, upstream}
  end

  ######################## DOCUMENTATION ############################
  def docs do
    """
    ## mk Command

    TODO: Document make command
    """
  end

  def usage do
    """
    Usage function for mk
    """
  end
end
