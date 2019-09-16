# furry-con-data
A tool that creates the JSON behind the furry convention map served at [https://coyo.tl/map](https://coyo.tl/map)

## Would you like to help?
Updating the map is as easy as a pull request! Simply add a line to basic_con_data.csv, and your updates can be live quickly and easily. The format of the CSV file is simple. The first column contains the name of the convention. The second, its location (as you'd put into Google Maps or similar). The third and fourth are latitude and longitude, in decimal format; this is a precise GPS location. Typically, the host city is "good enough"; you don't need to specify exactly the location of the hotel. Preferably, though, this would be of the exact town and not the metropolitan area (e.g., MFF is in Rosemont, IL, not Chicago, IL, and the lat/long reflects that). The fifth column is the most recent attendance for a convention (approximate is okay, if no exact figures are available). The sixth column is the date of the final Sunday of the most recent iteration (in format mm/dd/yyyy). The seventh column is "1" if a convention is a member of the FCLR, and "0" if not. If you don't know what this means, either see [here](https://fclr.info) or assume that it is not, as the list was initially generated with most of the members of the FCLR in it. The data should be sorted alphabetically by convention name.

To summarize:

Convention Name|Host City|Latitude|Longitude|Attendance|Date of final Sunday of event|FCLR Membership
 --- | --- | --- | --- | --- | --- | ---
