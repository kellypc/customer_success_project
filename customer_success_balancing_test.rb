require 'minitest/autorun'
require 'timeout'
require_relative 'customer_success_balancing.rb'

class CustomerSuccessBalancingTests < Minitest::Test
  def test_scenario_one
    balancer = CustomerSuccessBalancing.new(
      build_scores([60, 20, 95, 75]),
      build_scores([90, 20, 70, 40, 60, 10]),
      [2, 4]
    )
    assert_equal 1, balancer.execute
  end

  def test_scenario_two
    balancer = CustomerSuccessBalancing.new(
      build_scores([11, 21, 31, 3, 4, 5]),
      build_scores([10, 10, 10, 20, 20, 30, 30, 30, 20, 60]),
      []
    )
    assert_equal 0, balancer.execute
  end

  def test_scenario_three
    balancer = CustomerSuccessBalancing.new(
      build_scores(Array(1..999)),
      build_scores(Array.new(10000, 998)),
      [999]
    )
    result = Timeout.timeout(1.0) { balancer.execute }
    assert_equal 998, result
  end

  def test_scenario_four
    balancer = CustomerSuccessBalancing.new(
      build_scores([1, 2, 3, 4, 5, 6]),
      build_scores([10, 10, 10, 20, 20, 30, 30, 30, 20, 60]),
      []
    )
    assert_equal 0, balancer.execute
  end

  def test_scenario_five
    balancer = CustomerSuccessBalancing.new(
      build_scores([100, 2, 3, 6, 4, 5]),
      build_scores([10, 10, 10, 20, 20, 30, 30, 30, 20, 60]),
      []
    )
    assert_equal 1, balancer.execute
  end

  def test_scenario_six
    balancer = CustomerSuccessBalancing.new(
      build_scores([100, 99, 88, 3, 4, 5]),
      build_scores([10, 10, 10, 20, 20, 30, 30, 30, 20, 60]),
      [1, 3, 2]
    )
    assert_equal 0, balancer.execute
  end

  def test_scenario_seven
    balancer = CustomerSuccessBalancing.new(
      build_scores([100, 99, 88, 3, 4, 5]),
      build_scores([10, 10, 10, 20, 20, 30, 30, 30, 20, 60]),
      [4, 5, 6]
    )
    assert_equal 3, balancer.execute
  end

  def test_scenario_eight
    balancer = CustomerSuccessBalancing.new(
      build_scores([60, 40, 95, 75]),
      build_scores([90, 70, 20, 40, 60, 10]),
      [2, 4]
    )
    assert_equal 1, balancer.execute
  end

  def test_tie_scenario_should_return_zero
    balancer = CustomerSuccessBalancing.new(
      build_scores([15, 80]),
      build_scores([60, 40, 95, 10, 12]),
      []
    )
    assert_equal 0, balancer.execute
  end

  def test_error_if_customer_success_id_more_than_1_000
    balancer = CustomerSuccessBalancing.new(
      [{id: 1, score: 60}, { id: 1500, score: 20 }],
      [{id: 1, score: 3}, {id: 2, score: 10}],
      []
    )

    assert_raises ArgumentError do  
      balancer.execute
    end
  end

  def test_error_if_customer_success_score_more_than_10_000
    balancer = CustomerSuccessBalancing.new(
      [{id: 1, score: 60}, { id: 2, score: 20_000 }],
      [{id: 1, score: 3}, {id: 2, score: 10}],
      []
    )

    assert_raises ArgumentError do  
      balancer.execute
    end
  end

  def test_error_if_customer_id_more_than_1_000_000
    balancer = CustomerSuccessBalancing.new(
      [{id: 1, score: 60}, { id: 20, score: 20 }],
      [{id: 1, score: 60}, { id: 1_500_000, score: 100 }],
      []
    )

    assert_raises ArgumentError do  
      balancer.execute
    end
  end

  def test_error_if_customer_score_more_than_100_000
    balancer = CustomerSuccessBalancing.new(
      [{id: 1, score: 60}, { id: 1_500_000, score: 20 }],
      [],
      []
    )

    assert_raises ArgumentError do  
      balancer.execute
    end
  end

  private

  def build_scores(scores)
    scores.map.with_index do |score, index|
      { id: index + 1, score: score }
    end
  end
end