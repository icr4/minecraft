defmodule Minecraft.Packet.Client.Login.LoginStart do
  @moduledoc false
  import Minecraft.Packet

  @type t :: %__MODULE__{packet_id: 0, username: String.t()}
  defstruct packet_id: 0,
            username: nil,
            profile_id: nil

  @spec serialize(t) :: {packet_id :: 0, binary}
  def serialize(%__MODULE__{username: username}) do
    {0, encode_string(username)}
  end

  @spec deserialize(binary) :: {t, rest :: binary}
  def deserialize(data) do
    {username, rest} = decode_string(data)
    {profile_id, _rest} = decode_varint(rest)

    %__MODULE__{username: username, profile_id: profile_id}
  end
end
