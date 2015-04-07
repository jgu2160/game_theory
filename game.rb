require "byebug"
class Game
  attr_accessor :payoffs
  ACTION_HASH = { "0": "Cooperate, Cooperate",
                  "1": "Defect, Cooperate",
                  "2": "Cooperate, Defect",
                  "3": "Defect, Defect"
  }

  def initialize(options={})
    @payoffs = options[:payoffs]
  end

  def prisoners_dilemma
    self.payoffs = [[2,2], [3,0], [0,3], [1,1]]
  end

  def stag_hunt
    self.payoffs = [[2,2], [1,0], [0,1], [1,1]]
  end

  def battle_of_the_sexes
    self.payoffs = [[3,2], [0,0], [1,1], [2,3]]
  end

  def nash_equilibrium
    p2c = judge_payoff(payoffs[0], payoffs[1], 0)
    p2d = judge_payoff(payoffs[2], payoffs[3], 0)
    p1c = judge_payoff(payoffs[0], payoffs[2], 1)
    p1d = judge_payoff(payoffs[1], payoffs[3], 1)
    best_choices = [p2c, p2d, p1c, p1d]
    best_choices.each_with_object(Hash.new(0)) { |payoff, hash| hash[payoff] += 1 }
      .select {|key,value| value == 2 }
      .keys.map { |payoff| ACTION_HASH[payoffs.index(payoff).to_s.to_sym] }
  end

  def judge_payoff(payoff_1, payoff_2, player)
    payoff_1[player] > payoff_2[player] ? payoff_1 : payoff_2
  end
end
