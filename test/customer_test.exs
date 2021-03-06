defmodule ConektaTest.CustomerTest do
  use ExUnit.Case
  import Mock
  alias Conekta.CustomersResponse
  alias Conekta.Customer
  alias Conekta.CustomerFindResponse
  alias Conekta.CustomerDeleteResponse

  describe "Customers" do

    test "should read customers" do

      expected_mock = Mocks.CustomersMock.get_mock()

      with_mock Conekta.Client, [get_request: fn(_) -> expected_mock end] do

        actual = Conekta.Customers.customers()
        {:ok, content} = expected_mock
        expected_customers = {:ok, Poison.decode!(content.body, as: %CustomersResponse{})}

        assert actual == expected_customers

      end
    end

    test "should create a customer" do

      new_customer = %Customer{name: "Jorge Perez", email: "jorge@test.com"}
      expected_mock = Mocks.CustomersMock.get_new_customer_response()

      with_mock Conekta.Client, [post_request: fn(_, _) -> expected_mock end] do

          {:ok, created_customer} = Conekta.Customers.create(new_customer)
          assert new_customer.name == created_customer.name
          assert new_customer.email == created_customer.email

      end

    end

    test "should find a customer" do

      found_customer = %CustomerFindResponse{created_at: 1494884040, livemode: false, corporate: false, email: "jorge@test.com", id: "cus_2gXLaVPg9gLoxGeKs", name: "Jorge Perez", object: "customer"}
      expected_mock = Mocks.CustomersMock.get_new_customer_response()

      with_mock Conekta.Client, [get_request: fn(_) -> expected_mock end] do
          {:ok, customer} = Conekta.Customers.find("cus_2gXHiqgGWMk8ski6t")
          assert found_customer == customer
      end

    end

    test "should delete a customer" do

      expected_mock = Mocks.CustomersMock.get_delete_customer_response()
      deleted_customer = %CustomerDeleteResponse{id: "cus_2gXHiqgGWMk8ski6t", name: "Jorge Chavez", livemode: false, email: "jorge@test.com", phone: "521234567890", object: "customer", corporate: false, created_at: 1494871026}

      with_mock Conekta.Client, [delete_request: fn(_) -> expected_mock end] do

        assert Conekta.Customers.delete("cus_2gXHiqgGWMk8ski6t") == {:ok, deleted_customer}

      end

    end

    test "should update a customer" do

      updated_customer = %Customer{name: "Juan Perez", email: "edited@test.com"}

      expected_mock = Mocks.CustomersMock.get_update_customer_response()

      with_mock Conekta.Client, [put_request: fn(_, _) -> expected_mock end] do

        {:ok, customer}= Conekta.Customers.update("cus_2gYfQ9Pzfic158LXV", updated_customer)
        assert updated_customer.name == customer.name
        assert updated_customer.email == customer.email

      end

    end

  end

end
