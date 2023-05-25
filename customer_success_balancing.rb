require 'byebug'

class CustomerSuccessBalancing
  attr_accessor :customer_success, :customers, :away_customer_success

  def initialize(customer_success, customers, away_customer_success)
    @customer_success = customer_success
    @customers = customers
    @away_customer_success = away_customer_success
  end

  def execute
    customers_list
  end

  private

  def customers_list
    customers_list = []
    @customer_success.map do |customer_success|
      # Lista de todos os clientes pelo score do customer success 
      customers = @customers.select{|x| x[:score] <= customer_success[:score] }
      # Gera a lista com todos os customer_success e a quantidade de clientes
      customers_list << {id: customer_success[:id], customers: customers.count}
    end
    # Ordena pela quantidade de clientes e exibe o primeiro item da lista
    customers_list.sort_by!{ |k| k["customers"]}.first[:id]
  end
end
