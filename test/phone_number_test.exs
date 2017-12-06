defmodule PhoneNumberTest do
  use ExUnit.Case
  doctest PhoneNumber

  test "greets the world" do
    assert PhoneNumber.hello() == :world
  end
end
