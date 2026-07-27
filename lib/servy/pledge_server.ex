defmodule Servy.PledgeServer do
  @process_name __MODULE__
  def start do
    IO.puts("Starting the pledge server...")

    pid = spawn(__MODULE__, :listen_loop, [{[], 0}])
    Process.register(pid, @process_name)
    pid
  end

  def create_pledge(name, amount) do
    send(@process_name, {self(), :create_pledge, name, amount})

    receive do
      {:response, status} -> status
    end
  end

  def recent_pledges do
    send(@process_name, {self(), :recent_pledges})

    receive do
      {:response, pledges} -> pledges
    end
  end

  def total_pledged do
    send(@process_name, {self(), :total_pledged})

    receive do
      {:response, total} -> total
    end
  end

  def listen_loop({cache, total} = state) do
    receive do
      {sender, :create_pledge, name, amount} ->
        {:ok, id} = send_pledge_to_service(name, amount)
        most_recent_pledges = Enum.take(cache, 2)
        new_cache = [{name, amount} | most_recent_pledges]
        new_total = total + amount
        send(sender, {:response, id})
        listen_loop({new_cache, new_total})

      {sender, :recent_pledges} ->
        send(sender, {:response, cache})
        listen_loop(state)

      {sender, :total_pledged} ->
        send(sender, {:response, total})
        listen_loop(state)

      # unexpected ->
      #   IO.puts("Unexpected message: #{inspect(unexpected)}")
      #   listen_loop(state)
    end
  end

  defp send_pledge_to_service(_name, _amount) do
    # code to send to external
    {:ok, "pledge-#{Enum.random(1..1000)}"}
  end
end

# alias Servy.PledgeServer

# PledgeServer.start()

# IO.inspect(PledgeServer.create_pledge("larry", 10))
# IO.inspect(PledgeServer.create_pledge("moe", 20))
# IO.inspect(PledgeServer.create_pledge("curly", 30))
# IO.inspect(PledgeServer.create_pledge("daisy", 40))
# IO.inspect(PledgeServer.create_pledge("grace", 50))

# IO.inspect(PledgeServer.recent_pledges())
# IO.inspect(PledgeServer.total_pledged())
