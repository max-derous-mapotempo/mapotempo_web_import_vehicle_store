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

V01::Stores.class_eval do
  desc 'Import vehicle, vehicle_usage and store (with only one vehicle_usage_set present) by upload a CSV file or by JSON.',
    nickname: 'importVehicleStores',
    params: V01::Entities::StoresImport.documentation
  post :import_vehicle_stores do
    if params[:stores]
      stores_import = DestinationsImport.new
      stores_import.assign_attributes(replace: params[:replace])
      begin
        ImporterVehicleStores.new(current_customer).import_hash(stores_import.replace, params[:stores])
      rescue => e
        error!({error: e.message}, 422)
      else
        status 204
      end
    else
      stores_import = DestinationsImport.new
      stores_import.assign_attributes(replace: params[:replace], file: params[:file])
      if stores_import.valid?
        begin
          ImporterVehicleStores.new(current_customer).import_csv(stores_import.replace, stores_import.tempfile, stores_import.name, true)
        rescue => e
          error!({error: e.message}, 422)
        else
          status 204
        end
      else
        error!({error: stores_import.errors.full_messages}, 422)
      end
    end
  end
end
