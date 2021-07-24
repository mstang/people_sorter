# PeopleSorter

To start the API server:

  * Install dependencies with `mix deps.get`
  * Install Node.js dependencies with `npm install` inside the `assets` directory
  * Start Phoenix endpoint with `mix phx.server`

Now you can make POST API calls to create people:

 * http://localhost:4000/records?person=Dietrich|Cooper|oda2088@langosh.info|Pink|e9/9/1953

Now you can make GET API calls to lists of people:
 * http://localhost:4000/records/dob
 * http://localhost:4000/records/color
 * http://localhost:4000/records/last_name

## Learn more

