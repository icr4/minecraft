defmodule Minecraft.Crypto.AES do
  @moduledoc """
  Helper module for encrypting/decrypting using AES/CFB8.
  """

  @type t :: %__MODULE__{key: binary, ivec: binary}

  defstruct key: nil, ivec: nil

  @doc """
  Decrypts a `message`, given the current AES `state`.
  """
  @spec decrypt(binary, t) :: {decrypted_message :: binary, new_state :: t}
  def decrypt(message, state) do
    decrypt(message, state, [])
  end

  defp decrypt(<<head::1-binary, rest::binary>>, %__MODULE__{} = state, decrypted) do
    plain_text =
      :crypto.crypto_one_time(
        map_algorithm(:aes_cfb8, state.key),
        state.key,
        state.ivec,
        head,
        false
      )

    ivec = next_ivec(state.ivec, head)
    decrypt(rest, %__MODULE__{state | ivec: ivec}, [decrypted | plain_text])
  end

  defp decrypt("", state, decrypted) do
    {IO.iodata_to_binary(decrypted), state}
  end

  @doc """
  Encrypts a `message`, given the current AES `state`.
  """
  @spec encrypt(binary, t) :: {encrypted_message :: binary, new_state :: t}
  def encrypt(message, state) do
    encrypt(message, state, [])
  end

  defp encrypt(<<head::1-binary, rest::binary>>, %__MODULE__{} = state, encrypted) do
    cipher_text =
      :crypto.crypto_one_time(
        map_algorithm(:aes_cfb8, state.key),
        state.key,
        state.ivec,
        head,
        true
      )

    ivec = next_ivec(state.ivec, cipher_text)
    encrypt(rest, %__MODULE__{state | ivec: ivec}, [encrypted | cipher_text])
  end

  defp encrypt("", state, encrypted) do
    {IO.iodata_to_binary(encrypted), state}
  end

  defp next_ivec(ivec, data) when byte_size(data) == 1 and byte_size(ivec) == 16 do
    <<_::1-binary, rest::15-binary>> = ivec
    <<rest::binary, data::binary>>
  end

  defp map_algorithm(:aes_cfb8, key) do
    case bit_size(key) do
      128 -> :aes_128_cfb8
      192 -> :aes_192_cfb8
      256 -> :aes_256_cfb8
    end
  end
end
