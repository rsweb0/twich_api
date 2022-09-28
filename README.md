# README

* Ruby Version 2.7.0

* Rails Version 6.0.3

#### Instructions

* Clone the git repository
* Install ruby-2.7.0'
* Run the command `bundle install`
* Run the command `rails dev:cache` to enable caching in dev environment.
* Run the test suite using `rspec` to confirm if the setup is successful.
* Start the rails server using `rails s`
* Test the application by visiting http://localhost:3000/


#### Details

* User Authentication implemented using `devise` gem along with reset password functionality.
* Visit http://localhost:3000/letter_opener to check emails in development mode.
* On the home page details of top 20 active streams are displayed.
* In the Navbar there is search box, using which user can search for any speciifc twitcher profile. When user clicks `Search` button, the content of the home page is replaced with search results. This fetaures is implemented using `Ajax`.
* The search results details contains the profile details and a badge indicating if the channel is in top 20 postions.
* We are recording user's activities using `paper_trail` gem. All the user's history can be seen on http://localhost:3000/history page or using `History` button in the Navbar.
* Test cases are added for the respective functionalities.
