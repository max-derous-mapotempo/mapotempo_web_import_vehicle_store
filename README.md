Mapotempo-Web import vehicles and stores
========================================

Mapotempo-Web import at once vehicles, vehicle_usages and stores with only one vehicle_usage_set present.

Add api end-point to import at once vehicle, vehicle_usage and store into [Mapotempo-web](https://github.com/Mapotempo/mapotempo-web).

Add routes:
```
get /api/0.1/import_vehicle_stores.{format}
```

# Installation

Add this line to your application's Gemfile:

    gem 'mapotempo_web_import_vehicle_store'

And then execute:

    $ bundle

# License

Mapotempo is licensed under the AGPL-3 license, this gem too.
