defmodule ARC.LRU do
  defstruct items: %{},
            order: :gb_trees.empty(),
            next: 0

  def new, do: %__MODULE__{}
end
