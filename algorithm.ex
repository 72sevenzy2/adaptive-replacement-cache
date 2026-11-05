defmodule ARC.Algorithm do
  alias ARC.{LRU, State}

  def get(state, key) do
    cond do
      match?({:ok, _}, LRU.get(state.t1, key)) ->
        {:ok, value} = LRU.get(state.t1, key)

        state = %{
          state
          | t1: LRU.delete(state.t1, key),
            t2: LRU.put(state.t2, key, value)
        }

        {{:ok, value}, state}

      match?({:ok, _}, LRU.get(state.t2, key)) ->
        {:ok, value} = LRU.get(state.t2, key)

        state = %{
          state
          | t2: LRU.put(state.t2, key, value)
        }

        {{:ok, value}, state}
    end
  end
end
