# Copyright © Mapotempo, 2015
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

  def columns
    super.merge({
      emission: I18n.t('vehicle_stores.import_file.emission'),
      consumption: I18n.t('vehicle_stores.import_file.consumption'),
      capacity: I18n.t('vehicle_stores.import_file.capacity'),
      color: I18n.t('vehicle_stores.import_file.color'),
      tomtom_id: I18n.t('vehicle_stores.import_file.tomtom_id'),
      router_id: I18n.t('vehicle_stores.import_file.router_id'),
      masternaut_ref: I18n.t('vehicle_stores.import_file.masternaut_ref'),
      speed_multiplicator: I18n.t('vehicle_stores.import_file.speed_multiplicator'),
    })
  end

  def before_import(replace, name, synchronous)
    if @customer.vehicle_usage_sets.size > 1
      # Assert there is only one vehicle_usage_sets
      raise I18n.t('vehicle_stores.import_file.many_usage_sets')
    end

    if replace
      @tmp_vehicle = @customer.vehicles.build(name: 'tmp')
      @customer.vehicles.select{ |vehicle| vehicle != @tmp_vehicle }.each(&:destroy)
    end

    super(replace, name, synchronous)
  end

  def import_row(replace, name, row, line)
    store = super(replace, name, row, line)
    store.save!
    vehicle = @customer.vehicles.build(row.slice(:name, :ref, :emission, :consumption, :capacity, :color, :tomtom_id, :router_id, :masternaut_ref, :speed_multiplicator))
    vehicle.save!
    vehicle.vehicle_usages[0].store_start = store
    vehicle.vehicle_usages[0].store_stop = store
    vehicle.save!
  end

  def after_import(replace, name, synchronous)
    super(replace, name, synchronous)
    if replace
      @customer.vehicles.destroy(@tmp_vehicle)
      @customer.stores.destroy(@tmp_store)
    end

    @customer.save!
  end
end
