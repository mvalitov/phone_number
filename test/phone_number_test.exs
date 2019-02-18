defmodule PhoneNumberTest do
  use ExUnit.Case
  doctest PhoneNumber
  @file_path Application.app_dir(:phone_number) |> Kernel.<>("/priv/phone_number/phones_example")

  describe "test parsing and e164_number" do
    File.read!(@file_path)
    |> String.split("\n")
    |> Enum.each(fn row ->
      c = String.split(row, ";")
      p = PhoneNumber.parse(Enum.at(c, 2))
      assert p.valid == true
      assert Enum.at(c, 0) == p.country.id
      assert Enum.at(c, 1) == p.country.country_code
      assert {:ok, Enum.at(c, 3)} == PhoneNumber.Phone.e164_number(p)
    end)
  end
end
