defmodule PledgeServerTest do
  alias Servy.PledgeServer
  use ExUnit.Case

  describe "Pledge Server" do
    test "chaches only the 3 most recent pledges and totals their amounts." do

      PledgeServer.start()

      PledgeServer.create_pledge("miguel", 10)
      PledgeServer.create_pledge("angel", 20)
      PledgeServer.create_pledge("lusney", 30)
      PledgeServer.create_pledge("yeimy", 40)

      most_recent_pledges = [{"yeimy", 40}, {"lusney", 30}, {"angel", 20}]

      assert PledgeServer.recent_pledges() == most_recent_pledges
      assert PledgeServer.total_pledged() == 100
    end
  end
end
