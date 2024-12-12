defmodule Minecraft.Packet.Server.Login.Compression do
  @moduledoc false
  import Minecraft.Packet, only: [encode_varint: 1]

  @type t :: %__MODULE__{
          packet_id: integer,
          threshold: integer
        }

  defstruct packet_id: 3, threshold: 256

  @spec serialize(t) :: {packet_id :: 1, binary}
  def serialize(%__MODULE__{threshold: threshold}) do
    {3, <<encode_varint(threshold)::binary>>}
  end
end
