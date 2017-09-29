defmodule JsonApiClient.RequestTest do
  use ExUnit.Case
  doctest JsonApiClient.Request
  alias JsonApiClient.Request
  import JsonApiClient.Request

  describe "params()" do
    test "adds a single value to the params map" do
      assert %Request{params: %{a: 1}} = params(%Request{}, a: 1)
    end
    test "adds multiple values to the params map" do
      assert %Request{params: %{a: 1, b: 2}} = params(%Request{}, a: 1, b: 2)
    end
  end

  describe "fields()" do
    test "fields can be expressed as a string" do
      req = fields(%Request{}, sometype: "name,email")
      assert req.params.fields.sometype == "name,email"
    end

    test "fields can be expressed as a list of strings" do
      req = fields(%Request{}, sometype: ~w(name email))
      assert req.params.fields.sometype == "name,email"
    end

    test "fields can be expressed as a list of atoms" do
      req = fields(%Request{}, sometype: [:name, :email])
      assert req.params.fields.sometype == "name,email"
    end
        
    test "fields for multiple types accepted in multiple calls" do
      req = %Request{}
      |> fields(type1: [:name, :email])
      |> fields(type2: [:age])

      assert req.params.fields == %{
        type1: "name,email",
        type2:  "age",
      }
    end

    test "fields for multiple types accepted in a single call" do
      req = fields(%Request{},
        type1: [:name, :email],
        type2: "age",
      )
      assert req.params.fields == %{
        type1: "name,email",
        type2:  "age",
      }
    end
  end

  test "sort", do: assert_updates_param(:sort)
  test "page", do: assert_updates_param(:page)
  test "filter", do: assert_updates_param(:filter)
  test "include", do: assert_updates_param(:include)

  def assert_updates_param(field_name) do
    assert %{params: %{^field_name => "someval"}} = 
      apply(Request, field_name, [%Request{}, "someval"])
  end

  test "id", do: assert_updates_field(:id)
  test "method", do: assert_updates_field(:method)

  def assert_updates_field(field_name) do
    assert %{^field_name => "someval"} = 
      apply(Request, field_name, [%Request{}, "someval"])
  end
end
