class Game
  attr_accessor :payoffs, :p1, :p2
  ACTIONS_HASH = { 0 => "Cooperate, Cooperate",
                   1 => "Defect, Cooperate",
                   2 => "Cooperate, Defect",
                   3 => "Defect, Defect"
  }

  def initialize(options={})
    @payoffs = options[:payoffs]
    @p1 = options[:p1]
    @p2 = options[:p2]
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
      .select {|key, value| value == 2 }
      .keys.map { |payoff| ACTIONS_HASH[payoffs.index(payoff)] }
  end

  def judge_payoff(payoff_1, payoff_2, player)
    payoff_1[player] > payoff_2[player] ? payoff_1 : payoff_2
  end

  def encode_move_memory(p1_move, p2_move)
    p1.move_memory_self << p1_move
    p2.move_memory_self << p2_move
    p1.move_memory_opponent << p2_move
    p2.move_memory_opponent << p1_move
  end

  def encode_payoff_memory(payoff)
    p1.payoff_memory << payoff[0]
    p2.payoff_memory << payoff[1]
  end

  def turn
    play(p1.move, p2.move)
  end

  def play(p1_move, p2_move)
    encode_move_memory(p1_move, p2_move)
    if p1_move == 1 && p2_move == 1
      payoff = payoffs[0]
      puts "\n" + ACTIONS_HASH[0]
    elsif p1_move == 0 && p2_move == 0
      payoff = payoffs[3]
      puts "\n" + ACTIONS_HASH[3]
    elsif p1_move == 0
      payoff = payoffs[1]
      puts "\n" + ACTIONS_HASH[1]
    else
      payoff = payoffs[2]
      puts "\n" + ACTIONS_HASH[2]
    end
    encode_payoff_memory(payoff)
    payoff
  end
end

class Player
  #player class by default set up as tit for tat
  attr_accessor :move_memory_self, :move_memory_opponent, :payoff_memory
  def initialize
    @move_memory_self = []
    @move_memory_opponent = []
    @payoff_memory = []
  end

  def payoff
    payoff_memory.inject(0) { |sum, po| sum += po }
  end

  def avg
    payoff/@payoff_memory.length.to_f
  end

  def cooperate
    1
  end

  def defect
    0
  end

  def first_move
    move_memory_opponent.empty?
  end

  def move
    return cooperate if first_move
    return opponent_last_move
  end

  def opponent_last_move
    move_memory_opponent[-1]
  end
end

class MeanTitForTat < Player
  def move
    return defect if first_move
    return opponent_last_move
  end
end

class Mean < Player
  def move
    defect
  end
end

class Nice < Player
  def move
    cooperate
  end
end

class Rando < Player
  def move
    if rand < 0.5
      cooperate
    else
      defect
    end
  end
end
