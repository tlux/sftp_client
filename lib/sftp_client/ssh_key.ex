defmodule SFTPClient.SSHKey do
  @moduledoc false

  # Taken from: https://gist.github.com/voltone/4cf8813dbc4161abe84485d084513964
  # Written by Bram Verburg. To the extent possible under law, the author(s)
  # have dedicated all copyright and related and neighboring rights to this
  # software to the public domain worldwide. This software is distributed
  # without any warranty.

  require Record

  Record.defrecord(
    :rsa_private_key,
    :RSAPrivateKey,
    Record.extract(:RSAPrivateKey, from_lib: "public_key/include/public_key.hrl")
  )

  def pem_entry_decode({{:no_asn1, :new_openssh}, bin, :not_encrypted}) do
    binary_decode(bin)
  end

  def pem_entry_decode(pem) do
    :public_key.pem_entry_decode(pem)
  end

  defp binary_decode(
         <<"openssh-key-v1", 0, cipher_len::32,
           cipher_name::binary-size(cipher_len), kdf_len::32,
           kdf_name::binary-size(kdf_len), kdf_opts_len::32,
           kdf_opts::binary-size(kdf_opts_len), keys::32, more::binary>>
       ) do
    binary_decode(cipher_name, kdf_name, kdf_opts, keys, more)
  end

  defp binary_decode(
         "none",
         "none",
         "",
         1,
         <<public_len::32, public::binary-size(public_len), private_len::32,
           private::binary-size(private_len)>>
       ) do
    {:public_key.ssh_decode(public, :ssh2_pubkey), decode_private(private)}
  end

  defp decode_private(
         <<checkint::32, checkint::32, type_len::32,
           type::binary-size(type_len), more::binary>>
       ) do
    decode_private(type, more)
  end

  defp decode_private(
         "ssh-rsa",
         <<modulus_len::32, modulus::size(modulus_len)-unit(8),
           public_exp_len::32, public_exp::size(public_exp_len)-unit(8),
           private_exp_len::32, private_exp::size(private_exp_len)-unit(8),
           coefficient_len::32, coefficient::size(coefficient_len)-unit(8),
           prime1_len::32, prime1::size(prime1_len)-unit(8), prime2_len::32,
           prime2::size(prime2_len)-unit(8), _rest::binary>>
       ) do
    rsa_private_key(
      version: :"two-prime",
      modulus: modulus,
      publicExponent: public_exp,
      privateExponent: private_exp,
      prime1: prime1,
      prime2: prime2,
      exponent1: Integer.mod(private_exp, prime1 - 1),
      exponent2: Integer.mod(private_exp, prime2 - 1),
      coefficient: coefficient
    )
  end
end
