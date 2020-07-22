# CustomerRewardPointReport
Script ruby file for customer reward point tracker with specs via Rspec.

Example input:
```
{
      "events": [
        {
          "action": "new_customer",
          "name": "Jessica",
          "timestamp": "2020-07-01T00:00:00-05:00"
        },
        {
          "action": "new_customer",
          "name": "Will",
          "timestamp": "2020-07-01T01:00:00-05:00"
        },
        {
          "action": "new_customer",
          "name": "Elizabeth",
          "timestamp": "2020-07-01T12:00:00-05:00"
        },
        {
          "action": "new_order",
          "customer": "Jessica",
          "amount": 12.50,
          "timestamp": "2020-07-01T12:15:57-05:00"
        },
        {
          "action": "new_order",
          "customer": "Jessica",
          "amount": 16.50,
          "timestamp": "2020-07-01T10:01:00-05:00"
        },
        {
          "action": "new_order",
          "customer": "Will",
          "amount": 8.90,
          "timestamp": "2020-07-01T12:20:00-05:00"
        },
        {
          "action": "new_order",
          "customer": "Will",
          "amount": 1.50,
          "timestamp": "2020-07-01T12:21:00-05:00"
        }
      ]
    }
```
Expected output:
Jessica: 22 points with 11 points per order.
Will: 3 points with 3 points per order.
Elizabeth: No orders.

__Considerations__
Per the challenge guidelines, this input is a response from a service, where I've assummed validations are present for formatting, so the code does not explore 
all edge cases. My interpretation of the challenge was to only generate a report, and with that objective in mind, I avoided scope creep by not implementing a 
full application with User/Role/Customer/Order tables, but my inclination was certainly to build it out. Given the dataset provided, user/customer uniqueness would 
have been an issue with only the first name provided. Retrospectively, the `process_events` method is bulkier than I'd like, so on a pass through, refacotring this 
would be my first priority. I avoided magic numbers, convered most methods with specs, used explicit naming for code clarity, and modulaized wherever possible to 
allow ease in future updates.

__Setup__
Clone the project into a specified local diectory. 

`cd` into the CustomerRewardPointReport directory. 

Ensure you have ruby installed with `ruby -v`.
 
`gem install rspec` (`sudo gem install rspec` if needed). 

Run `ruby simple_reward_point_tracker.rb` to run the specs. 

