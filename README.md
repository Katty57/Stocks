# Stocks
App to track stocks change.

# Illustrations
#### There are four screens (count from left to right):
- Entry screen is used to display stocks. By pressing the star button, stock can be added to Favourites;
- Favourites screen displays stocks which are favourite with pressed star button. Here also stock can be added or deleted from favourites and screen will update in real time;
- Search screen. Here you can search stocks by name;
- Last screen is the screen which represents details about stock. Such as chart of changing values of stocks in different period.
<p float="center">
 <img src="https://user-images.githubusercontent.com/31551241/175475939-1e255794-1421-4ae1-9ada-94fe008550d4.png" width="230" />
 <img src="https://user-images.githubusercontent.com/31551241/175475955-be5699f7-888d-40c3-a395-46c616492fb1.png" width="230" /> 
 <img src="https://user-images.githubusercontent.com/31551241/175475969-15f462fd-74cd-4079-a33b-22e1346d38d1.png" width="230" />
 <img src="https://user-images.githubusercontent.com/31551241/175475981-738d6875-12ce-4bea-be41-378117ae5974.png" width="230" /> 
</p>

# Technologies
#### In project were used such technologies:
- **Model-View-Presenter** as architecture pattern;
- Design in code with **UIKit** and **Autolayout**;
- Loading data from Network with **URLSession** and **GCD**;
- Representing chart using **Chart** package;
- Updating and caching images with **Kingfisher** package;
- Saving data using **FileManager**;
- Adding or deleting stocks from favorites with NSNotificationCenter.
