# Instagram Post Scraper
Instagram Post Scraper for Pixlee code challenge. Allows users to scrape down data from Instagram and store it in a local database that can be quickly searched later, without using additional Instagram API requests.

## Instructions
The live app can be found at [http://instagram-scraper.herokuapp.com](http://instagram-scraper.herokuapp.com). 

For local use, clone down the repo, create and populate ```.env ``` in the app root.

```
INSTAGRAM_KEY = '<api key>'
```

From there, normal rails installation applies. 

```
~> bundle install
~> rake db:create
~> rake db:migrate
~> rails s
```

## Usage
####Scraping Instagram
Navigate to the app and enter a hashtag, a start date, and an end date. Once all of the data has been verified as valid, the submit button will activate, which will begin sending requests to the instagram API. The responses are parsed, and Post objects are entered in to the database for each post that meets the timestamp criteria. Each Post is associated with the accompanying hashtag. 

A pointer to the next set of posts from Instagram is saved to the join table to make future searches for the same tag faster. When a POST is sent to the database, the first that happens is that if the tag already exists, it will find the object with the ```tag_time``` that is closest, after the user specified ```end_date```. The pointer stored in that object will be used as the starting point for the Instagram search. 

When scraping a new tag, if a post already exists in the database, the existing post will also be tagged with the new tag. This prevents doubling up on post objects, and allows the associations to pull that particular post on searches for either tag. 

####Searching Locally
Click the 'Search' button at the top of the page, and enter search details. If the tag exists in the database, it will pull up all of that tag's associated posts and return them to the controller. From there, they are displayed in a carousel. Users can scroll through the existing images, read the captions, and visit the origin post on Instagram by clicking on the picture itself. 

If no posts exist under that hashtag, the user will be redirected to the root, and an error message will appear informing the user that no posts exist and that they will need to scrape first. 

## Data Validation
To prevent false data from getting through, data is validated in 2 places. 
####The Frontend
When the user navigates to the page, the Submit button for both forms will initially be disabled. Every time the form changes, a script will run to confirm the following:

* The start date is set before the end date
* The end date is not in the future
* A hashtag is present

If all of those criteria have been met, the submit button will be unlocked. 

####The Backend
When a POST or a GET request is made to the Collection controller, the ```ErrorHandling``` module is called to confirm the same criteria as the frontend. The Hashtag text is also sanitized, removing all whitespaces and non-alphanumeric characters.

If the criteria have been met, the routes will continue to execute, if not, the user will be redirected and given an error message stating that their data is invalid. 

## Improvements / Difficulties
The biggest difficulty has been starting the search through Instagram's API from somewhere other than the beginning. While I've managed to get this to happen, it requires already having scraped previous data for that hashtag. EG, if I've done a search for data from 5/1 through 5/20, and then search for data from 4/18, it will start looking at 5/1. However, if I jump right to 4/18, it will have to go back from the current date. After extensive experimentation and searching, I've been unable to find a way around this. Other services that offered this feature no longer do as well, most citing the June 1st API update. 

While I ran out of time, ideally I would change the behavior of the carousel. Right now, it grabs all of the data from the post and displays it - however, the next step would be to only grab 20 photos on the initial load. Once the user hit the end of the initial 20, send an AJAX request to the server, and get the next 20. From there, append them to the current list, which would allow for users to go through the entire list with less data used/less load times. 