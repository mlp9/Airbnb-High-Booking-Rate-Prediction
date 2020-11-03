# Airbnb-High-Booking-Rate-Prediction
Airbnb, Inc. is an american vacation rental online marketplace company based in San Francisco, California, United States. Airbnb offers arrangement for lodging, primarily homestays, or tourism experiences. The company does not own any of the real estate listings, nor does it host events; it acts as a broker, receiving commissions from each booking. In this project we are trying to predict whether a listing would receive high booking or not. 

## Exploratory data analysis

As an Airbnb user, when I book a listing, I care a lot about how much I need to pay in total. Therefore, we use price times minimum nights to get the minimum payment of listings and draw a bar chart to see the distribution of the high booking rate listings within the different intervals of minimum payment.
From figure 1(left), we can observe that with minimum payment increasing, the number of high booking rate listings decreases. Also, we can tell from the figure 1(right)  that with minimum payment increasing, the percentage of high booking rate listings decreases and then levels off with a little fluctuation. Since there is a subtle relationship between high booking rate and minimum payment, we created the interactive term, which is price times minimum nights. 

The location of Airbnb listings is one of the key factors that could affect the price and also the booking rate. For example, houses in tourist cities and large cities are more likely to have higher prices and also the booking rate. Specifically, houses and apartments in New York are probably more expensive than houses and apartments in Denver in general. Therefore, we could make a plot to see how the airbnb listings are distributed in the training data base on their longitude and latitude.
From figure 2, it is clear that the airbnb listings are spread across the U.S., moreover New York and Los Angeles are the two most popular cities which have more than half of the airbnb listings in total. We think different cities could have different effects on the booking rate of listings, therefore we will include the variable ‘city_name’ in the future analysis.



