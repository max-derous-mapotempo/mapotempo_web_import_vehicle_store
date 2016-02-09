require 'test_helper'

class V01::VehicleStoresTest < ActiveSupport::TestCase
  include Rack::Test::Methods
  include ActionDispatch::TestProcess
  set_fixture_class delayed_jobs: Delayed::Backend::ActiveRecord::Job

  def app
    Rails.application
  end

  setup do
    @store = stores(:store_one)
  end

  def api_vehicle_store(param = {})
    part = part ? '/' + part.to_s : ''
    '/api/0.1/import_vehicle_stores.json?api_key=testkey1&' + param.collect{ |k, v| "#{k}=#{v}" }.join('&')
  end

  test 'should create bulk from json' do
    @store.customer.plannings.each(&:destroy)
    @store.customer.reload
    @store.customer.vehicle_usage_sets[1..-1].each(&:destroy) if @store.customer.vehicle_usage_sets.size > 1

    assert_difference('Store.count', 1) do
      assert_difference('Vehicle.count', 1) do
        post api_vehicle_store(), {stores: [{
          name: 'Nouveau dépôt',
          street: nil,
          postalcode: nil,
          city: 'Tule',
          lat: 43.5710885456786,
          lng: 3.89636993408203,
          ref: nil,
          geocoding_accuracy: nil,
          foo: 'bar'
        }]}
        assert last_response.created?, 'Bad response: ' + last_response.body
        json = JSON.parse(last_response.body)
        assert_equal 1, json.size
      end
    end
  end

  test 'should no create bulk from json when many vehicle_usage_sets are present' do
    assert @store.customer.vehicle_usage_sets.size > 1

    post api_vehicle_store(), {stores: [{
      name: 'Nouveau dépôt',
      street: nil,
      postalcode: nil,
      city: 'Tule',
      lat: 43.5710885456786,
      lng: 3.89636993408203,
      ref: nil,
      geocoding_accuracy: nil,
      foo: 'bar'
    }]}
    assert_equal 422, last_response.status, last_response.body
  end
end
