defmodule Minecraft.Packet.Server.Login.LoginAck do
  @moduledoc false

  @spec deserialize(binary) :: {any(), rest :: binary}
  def deserialize(_data) do
    {%{}, ""}
  end
end
