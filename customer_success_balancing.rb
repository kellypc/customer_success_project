class CustomerSuccessBalancing
  attr_accessor :customer_success, :customers, :away_customer_success, :available_customer_success

  def initialize(customer_success, customers, away_customer_success)
    @customer_success = customer_success
    @customers = customers
    @away_customer_success = away_customer_success
    @available_customer_success = []
  end

  def execute
    remove_away_customer_success
    customers_list = balance_customer_by_customer_success
    return customer_success_with_more_customers(customers_list)
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

  def customer_success_with_more_customers(customers_list)    
    @available_customer_success.each do |customer_success|
      customer_success[:customers_size] = 0
      customers_list.each do |customer|
        if customer_success[:id] == customer[:customer_success][:id]
          customer_success[:customers_size] += 1
        end
      end
    end
    @customer_success.sort_by!{ |k| k["customers"]}.first[:id]
  end

  def remove_away_customer_success
    @customer_success.each do |cs|
      unless away_customer_success.include?(cs[:id])
        @available_customer_success << cs
      end
    end
  end
end