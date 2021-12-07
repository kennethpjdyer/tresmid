defmodule Tresmid do
  @moduledoc """

  Tool for building managing Git worktrees and branch across multiple projects.

  The name derives from the Old Icelandic word *trésmiðr*, which
  translates to "carpenter" through the compound *tree-smith*,
  here used in the sense of a smith of Git work trees.

  ## Installation

  /* TODO:  Provide an installation method based on source code, include
  cloning the Git repository, compiling the escript, and adding the
  escript path to the `PATH` variable.*/

  ## Usage

  The primary interface for Tresmid is the command-line application
  `tresmid`.

  ### Options

  ```text
  #{Tresmid.CLI.Docs.opts}
  ```

  ### Commands

  |Command | Description |
  |---|---|
  | `config` | Used to manage global configuration options. |
  | `repo` | Used to interact with and manage local Git repositories. |

  #{Tresmid.Config.docs}

  #{Tresmid.Repo.docs}

  """

end
