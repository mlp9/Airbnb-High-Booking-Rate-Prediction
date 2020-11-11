# Airbnb-High-Booking-Rate-Prediction
Airbnb, Inc. is an american vacation rental online marketplace company based in San Francisco, California, United States. Airbnb offers arrangement for lodging, primarily homestays, or tourism experiences. The company does not own any of the real estate listings, nor does it host events; it acts as a broker, receiving commissions from each booking. In this project we are trying to predict whether a listing would receive high booking or not. 

## Exploratory data analysis

As an Airbnb user, when I book a listing, I care a lot about how much I need to pay in total. Therefore, we use price times minimum nights to get the minimum payment of listings and draw a bar chart to see the distribution of the high booking rate listings within the different intervals of minimum payment.
From figure 1(left), we can observe that with minimum payment increasing, the number of high booking rate listings decreases. Also, we can tell from the figure 1(right)  that with minimum payment increasing, the percentage of high booking rate listings decreases and then levels off with a little fluctuation. Since there is a subtle relationship between high booking rate and minimum payment, we created the interactive term, which is price times minimum nights. 

The location of Airbnb listings is one of the key factors that could affect the price and also the booking rate. For example, houses in tourist cities and large cities are more likely to have higher prices and also the booking rate. Specifically, houses and apartments in New York are probably more expensive than houses and apartments in Denver in general. Therefore, we could make a plot to see how the airbnb listings are distributed in the training data base on their longitude and latitude.
From figure 2, it is clear that the airbnb listings are spread across the U.S., moreover New York and Los Angeles are the two most popular cities which have more than half of the airbnb listings in total. We think different cities could have different effects on the booking rate of listings, therefore we will include the variable ‘city_name’ in the future analysis.

Airbnb is often used for business travel, the prices of business travel hotels are always different from those of general hotels. Also, there are different prices for licensed and unlicensed hotels. So we make a plot to see how the two factors business travel and license required affect the price.
From figure 3, we can see business-travel hotels are more expensive than non-business-travel ones, which is reasonable because of the extra service. When a hotel is not business travel ready, the price distribution is almost identical despite the license requirements, only with several lower priced hotels who do not need a license. And for the business-travel hotels, unlicensed hotels are significantly more expensive than licensed ones. This is probably a result of a more personalized and specialized experience. So we can see the two factors business travel and license required can significantly affect the price, then affect the hotels’ booking rate.

For short stays, I prefer hotel rooms to airbnb home stays. Among other reasons, even though an airbnb is usually cheaper in tag price, for short stays, it tends to be more expensive in total price than a hotel room with the addition of a cleaning fee. Since the total price is such an important consideration affecting customers’ behavior, I took a look at the possible factors that interact with cleaning fee(Figure 4).
As for choosing features to visualize, ‘minimum_nights’ seems to play an important role. Intuitively, the more minimum nights required, the less average total price paid because cleaning fee is a one-time payment. After introducing ‘requires_license’, we can easily tell 3 groups of data, from left to right, differentiates from each other by license requirements and the level of cleaning fee. To sum up, ‘minimum_nights’ and ‘requires_license’ affects cleaning fee, cleaning fee affects total daily price, which eventually affects customer behavior. Up to this point, there is no physical proof whether this logic significantly affects the model outcome. We can only say that both ‘minumin_nights’ and ‘requires_license’ are important factors, which is later proved by the importance analysis.
 
In order to understand the pricing of the listings, we decided to have a look at how the price data of different room types distributed and dispersed (under $500)(Figure 5).
The prices of ‘entire home/apt’ are more dispersed while the prices of private room and shared
rooms are more concentrated at lower prices. It’s not surprising that ‘entire rooms’ are the most
expensive ones and shared rooms cost the least. However, the median of ‘entire home/apt’ is
higher than most of both private rooms and shared rooms. And on average, a private room is
only $10 more expensive than shared rooms. Therefore, if a customer’s priority is financially
economic, one would check for private rooms first, which is so much less expensive than entire
homes while enjoying some privacy in contrast to shared rooms.
One thing to notice is that both private rooms and shared rooms have a few data points over the
$200 range. It could be several mis entries or some truly expensive places worth checking out if
Curious.

## Feature Engineering
List of features used in model
accommodates, availability_30, availability_365, availability_60, availability_90, bathrooms, bedrooms, beds, cleaning_fee, extra_people, first_review, guests_included, host_listings_count, host_response_rate, host_since, latitude, longitude, maximum_nights, minimum_nights, price, security_deposit

Generally, on the basis of not overfitting, we believe that the more information to include into the model, the more accuracy we may generate. Following this logic, we included almost every column, except for prohibitively difficult ones such as ‘host_name’, ‘Neighbourhood’, ’space’, ‘Market’ etc. In the case where a variable is not suitable for better model performance, we would check the result of importance analysis and exclude features accordingly. As a result, much of our effort in feature engineering was to make use of complex variables. These variables either have too many categories for R to process, or they contain text messages that need further processing. We will list new variables created with a short introduction below.

## Explanation and list of new variables created
number of amenities and distinctive amenities: num_of_amenities, TV, Wifi, AC, Parking, Laundry, Bathtub, Pet, Kitchen
sentiment analysis of ‘name’ and ‘summary’: name_compound, name_negativity, name_neutrality, name_positivity,desc_compound, desc_negativity, desc_neutrality, desc_positivity
record the time difference between opening and the first review: diff.time.review
bathroom per bedroom: bath_per_bedroom
top 30 travel cities as dummy variables: top_travel_city_i (0 <= i <= 5)
availability of monthly or weekly prices: is_monthly_f, is_monthly_t, is_weekly_f, is_weekly_t
whether host shares neighborhood with the house: neighbourhood_same_0, neighbourhood_same_1, neighbourhood_same_unkown
interactive variables of ‘room_type’ and ‘price’, ‘minimum_nights’ and ‘price’: room_type_Entire_price, room_type_Private_price, room_type_Shared_price, minimum_price
More dummy variables created for: ‘city_name’, ‘host_has_profile_pic’, ‘bed_type’, ‘cancellation_policy’, ‘host_reponse_time’, ‘instant_bookable’, ‘is_business_travel_ready’, ‘is_location_exact’, ‘property_type’, ‘require_guest_phone_verification’, ‘require_guest_profile_picture’, ‘requires_license’, ‘room_type’, ‘state’


