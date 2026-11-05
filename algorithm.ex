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

      true ->
        {:miss, state}
    end
  end

  def put(state, key, value) do
    cond do
      match?({:ok, _}, LRU.get(state.t1, key)) ->
        state = %{
          state
          | t1: LRU.delete(state.t1, key),
            t2: LRU.put(state.t2, key, value)
        }

        state

      match?({:ok, _}, LRU.get(state.t2, key)) ->
        %{state | t2: LRU.put(state.t2, key, value)}

      match?({:ok, _}, LRU.get(state.b1, key)) ->
        nil
    end
  end

  def delete(state, key) do
    %{
      state
      | t1: LRU.delete(state.t1, key),
        t2: LRU.delete(state.t2, key),
        b1: LRU.delete(state.b1, key),
        b2: LRU.delete(state.b2, key)
    }
  end

  defp adjust_parameter_up(state, b1, b2) do
    delta =
      max(
        div(LRU.size(b2), max(LRU.size(b1), 1)),
        1
      )

    %{state | p: min(state.capacity, state.p + delta)}
  end

  defp adjust_parameter_down(state, b1, b2) do
    delta =
      max(
        div(LRU.size(b1), max(LRU.size(b2), 1)),
        1
      )

    %{state | p: max(0, state.p - delta)}
  end
end
