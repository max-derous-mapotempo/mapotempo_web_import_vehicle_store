# Copyright © Mapotempo, 2016
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
class V01::Entities::VehicleStore < V01::Entities::Store
  def self.entity_name
    'V01_VehicleStore'
  end

  expose(:emission, documentation: { type: Integer })
  expose(:consumption, documentation: { type: Integer })
  expose(:capacity, documentation: { type: Integer })
  expose(:fuel_type, documentation: { type: String })
  expose(:capacity_unit, documentation: { type: String })
  expose(:router_id, documentation: { type: Integer })
  expose(:router_dimension, documentation: { type: String, values: ::Router::DIMENSION.keys })
  expose(:speed_multiplicator, documentation: { type: Float })
end
