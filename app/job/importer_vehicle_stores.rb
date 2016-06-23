# Copyright © Mapotempo, 2015-2016
#
# This file is part of Mapotempo.
#
# Mapotempo is free software. You can redistribute it and/or
# modify since you respect the terms of the GNU Affero General
# Public License as published by the Free Software Foundation,
# either version 3 of the License, or (at your option) any later version.
#
# Mapotempo is distributed in the hope that it will be useful, but WITHOUT
# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
# or FITNESS FOR A PARTICULAR PURPOSE.  See the Licenses for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with Mapotempo. If not, see:
# <http://www.gnu.org/licenses/agpl.html>
#
require 'importer_stores'

class ImporterVehicleStores < ImporterStores

  def columns_vehicle
    {
      emission: {title: I18n.t('vehicle_stores.import_file.emission')},
      consumption: {title: I18n.t('vehicle_stores.import_file.consumption')},
      capacity: {title: I18n.t('vehicle_stores.import_file.capacity')},
      tomtom_id: {title: I18n.t('vehicle_stores.import_file.tomtom_id')},
      router_id: {title: I18n.t('vehicle_stores.import_file.router_id')},
      router_dimension: {title: I18n.t('vehicle_stores.import_file.router_dimension')},
      masternaut_ref: {title: I18n.t('vehicle_stores.import_file.masternaut_ref')},
      speed_multiplicator: {title: I18n.t('vehicle_stores.import_file.speed_multiplicator')},
    }
  end

  def columns
    super.merge(columns_vehicle)
  end

  def before_import(name, options)
    if @customer.vehicle_usage_sets.size > 1
      # Assert there is only one vehicle_usage_sets
      raise ImportBaseError.new(I18n.t('vehicle_stores.import_file.many_usage_sets'))
    end

    if options[:replace]
      @tmp_vehicle = @customer.vehicles.build(name: 'tmp')
      @customer.vehicles.select{ |vehicle| vehicle != @tmp_vehicle }.each(&:destroy)
    end

    super(name, options)
  end

  def import_row(name, row, line, options)
    store = super(name, row.clone.delete_if{ |k, v| columns_vehicle.keys.include? k }, line, options)
    store.save!
    vehicle = @customer.vehicles.find_by(ref: row[:ref]) if row[:ref]
    vehicle = @customer.vehicles.build if !vehicle
    vehicle.update! row.slice(*(columns_vehicle.keys + [:name, :ref, :color]))
    vehicle.vehicle_usages[0].store_start = store
    vehicle.vehicle_usages[0].store_stop = store
    vehicle.save!

    store # For subclasses
  end

  def after_import(name, options)
    super(name, options)
    if options[:replace]
      @customer.vehicles.destroy(@tmp_vehicle)
      @customer.stores.destroy(@tmp_store)
    end

    @customer.save!
  end
end
