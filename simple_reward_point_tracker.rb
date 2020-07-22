require "rspec/autorun"
require 'time'

class CustomerRewardPointReport

  STARTING_COUNT = 0

  UPPER_THRESHOLD = 20
  LOWER_THRESHOLD = 3

  TIER_1_TIMES = 10 || 14
  TIER_2_TIMES = 11 || 13
  TIER_3_TIMES = 12

  TIER_1_MODIFIER = 1.0
  TIER_2_MODIFIER = 2.0
  TIER_3_MODIFIER = 3.0
  TIER_4_MODIFIER = 0.25

  def process_events(response)
    if response[:events].empty?
      return "No events to report."
    end

    report_data = {}

    response[:events].each do |event|
      case event[:action]
      when "new_customer"
        report_data[event[:name]] = {}
        report_data[event[:name]][:points] = STARTING_COUNT
        report_data[event[:name]][:qualifying_order_count] = STARTING_COUNT
      when "new_order"
        customer = report_data[event[:customer]]
        if report_data[event[:customer]].nil?
          report_data[event[:customer]] = {}
          report_data[event[:customer]][:points] = STARTING_COUNT
          report_data[event[:customer]][:qualifying_order_count] = STARTING_COUNT
        end

        points = calculate_points(event[:amount], determine_rate(event[:timestamp]))

      else
        puts "We need to expand! New action: #{event[:action]}"
        next
      end
    end
    return generate_report(report_data)

  end

  def calculate_points(order_amount, rate)

  end

  def determine_rate(timestamp)

  end

  def generate_report(data)

  end

  def avg_points_per_order(customer_data)
  end
end

describe CustomerRewardPointReport do
  let(:response) {
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
  }
  describe :process_events do
    it "returns the challenge's expected output" do
      report = CustomerRewardPointReport.new.process_events(response)
      expected_output = "Jessica: 22 points with 11 points per order.\nWill: 3 points with 3 points per order.\nElizabeth: No orders."
      expect(report).to eq(expected_output)
    end

    context "When the action is not recognized" do
      it "does not fail" do
        response = {
          "events": [
            {
              "action": "new_customer",
              "name": "Jessica",
              "timestamp": "2020-07-01T00:00:00-05:00"
            },
            {
              "action": "new_action",
              "name": "Will",
              "timestamp": "2020-07-01T01:00:00-05:00"
            }
          ]
        }
        expect(CustomerRewardPointReport.new.process_events(response)).to be_truthy
      end
    end

    context "When the customer is not new" do
      it "still reports on the existing customer" do
        response = {
          "events": [
            {
              "action": "new_order",
              "customer": "Marla",
              "amount": 8.90,
              "timestamp": "2020-07-01T11:00:00-05:00"
            },
            {
              "action": "new_order",
              "customer": "Paco",
              "amount": 8.90,
              "timestamp": "2020-07-01T10:00:00-05:00"
            }
          ]
        }
        expect(CustomerRewardPointReport.new.process_events(response)).to include("Paco")
      end
    end

    context "When the reponse is empty" do
      it "Output is: No events to report." do
        response = {
          "events": [
          ]
        }
        expect(CustomerRewardPointReport.new.process_events(response)).to eql("No events to report.")
      end
    end
  end

  describe :determine_rate do
    context "When the timestamp is between in 10:00pm - 10:59pm or 2:00pm - 2:59pm" do
      it "returns tier 1 rate of 1 point per dollar spent" do
        timestamp = "2020-07-01T10:00:00-05:00"
        expect(CustomerRewardPointReport.new.determine_rate(timestamp)).to eql(1.0)
      end
    end
    context "When the timestamp is between in 11:00pm - 11:59pm or 1:00pm - 1:59pm" do
      it "returns tier 2 rate of 2 points per dollar spent" do
        timestamp = "2020-07-01T11:00:00-05:00"
        expect(CustomerRewardPointReport.new.determine_rate(timestamp)).to eql(2.0)
      end
    end
    context "When the timestamp is between in 12:00pm - 12:59pm" do
      it "returns tier 3 rate of 3 points per dollar spent" do
        timestamp = "2020-07-01T12:00:00-05:00"
        expect(CustomerRewardPointReport.new.determine_rate(timestamp)).to eql(3.0)
      end
    end
    context "When the timestamp is outside 10am-3pm" do
      it "returns tier 4 rate of 0.24 points per dollar spent" do
        timestamp = "2020-07-01T03:00:00-05:00"
        expect(CustomerRewardPointReport.new.determine_rate(timestamp)).to eql(0.25)
      end
    end
  end

  describe :calculate_points do
    context "When the order amount is less than $0.01" do
      it "returns 0 points" do
        order_amount = 0.0
        rate = 3.0
        expect(CustomerRewardPointReport.new.calculate_points(order_amount, rate)).to eql(0.0)
      end
    end
  end

  describe :avg_points_per_order do
    context "When the customer has no qualifying orders" do
      it "is not called" do
        response = {
          "events": [
            {
              "action": "new_customer",
              "name": "Jessica",
              "timestamp": "2020-07-01T00:00:00-05:00"
            },
            {
              "action": "new_action",
              "name": "Will",
              "timestamp": "2020-07-01T01:00:00-05:00"
            }
          ]
        }
        expect(CustomerRewardPointReport.new.process_events(response)).not_to receive(:avg_points_per_order)
      end
    end
  end
end
