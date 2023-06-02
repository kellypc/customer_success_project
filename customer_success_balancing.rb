require 'byebug'

class CustomerSuccessBalancing
  attr_accessor :customer_success, :customers, :away_customer_success, :available_customer_success, :balanced_list

  def initialize(customer_success, customers, away_customer_success)
    @customer_success = customer_success
    @customers = customers
    @away_customer_success = away_customer_success
    @available_customer_success = []
    @balanced_list = []
  end

  def execute
    remove_away_customer_success
    @balanced_list = balance_customer_by_customer_success
    sort_customers_success_by_customers
    customer_success_with_more_customers
  end

  private

  def balance_customer_by_customer_success
    @customers.each do |customer|
      @available_customer_success.each do |customer_success|
        next if customer[:score] > customer_success[:score]
        customer[:customer_success] = customer_success
      end
    end    
    @customers
  end

  def sort_customers_success_by_customers    
    @available_customer_success.each do |customer_success|
      customer_success[:customers] = []
      customer_success[:customers_size] = 0
      @balanced_list.each do |customer|
        next if customer[:customer_success].nil? # Clientes podem ficar sem ser atendidos
        if customer_success[:id] == customer[:customer_success][:id]
          customer_success[:customers] << customer
          customer_success[:customers_size] += 1
        end
      end
    end
    @available_customer_success.sort_by!{ |k| k[:customers].size}.reverse!
  end

  def remove_away_customer_success
    @customer_success.each do |cs|
      unless away_customer_success.include?(cs[:id])
        @available_customer_success << cs
      end
    end
  end

  def customer_success_with_more_customers
    tie_between_customer_succcess ? 0 : @available_customer_success[0][:id]
  end

  def tie_between_customer_succcess
    @available_customer_success[0][:customers].size == @available_customer_success[1][:customers].size
  end
end