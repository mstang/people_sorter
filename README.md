# PeopleSorter

This coding assignment is written in Elixir.

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

I provided three example files to test from the command line:
 * text_comman.txt
 * text_pipe.txt
 * text_space.txt

To run the app from the command line:

*  ./people_sorter --sort-by=dob text_space.txt

For the sort-by parameter you can provide dob, color or last name.
As far as the filenames go, you can include multiple files.

## Issues and Assumptions

The main assumption I made was with the command line app.  
I could assume that the dates would always be in the correct format and valid.
However, if an invalid date was included in one of the files, bad things could happen.
So, I had a couple of choices:
1) I could insert the invalid date in the list of Persons.  However, that would mean that my sorting on DOB would have to be tolerant of invalid dates.  And it would mean that my data
contained invalid data.  Which would mean that everything that touched the DOB would have to 
be able to handle bad data.
2) So, if I couldn't insert bad data, then I could ignore it and fail silently.  I feel that failing silently is never a good idea.   And data wouldn't be missing.
3) So, I finally decided to validate the dates.  However, this meant that I would need 
to provide feedback to the User.  Since it is a command line app, I decided to print 
messages to the console, warning the user.

With the API call, I can return an error to the caller.

Since this is a coding assignment, I left in the Phoenix Generated Code that wasn't used.


