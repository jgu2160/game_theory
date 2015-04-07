require "minitest/autorun"
require "minitest/pride"
require_relative "game"

class GameTest < MiniTest::Test
  def pris_payoffs
    [[2,2], [3,0], [0,3], [1,1]]
  end

  def stag_payoffs
    [[2,2], [1,0], [0,1], [1,1]]
  end

  def battle_payoffs
    [[3,2], [0,0], [1,1], [2,3]]
  end

  def test_pris_game_has_a_payoff_array
    prisoner = Game.new(payoffs: pris_payoffs)
    assert_equal pris_payoffs, prisoner.payoffs
  end

  def test_stag_game_has_a_payoff_array
    prisoner = Game.new(payoffs: stag_payoffs)
    assert_equal stag_payoffs, prisoner.payoffs
  end

  def test_it_sets_equal_to_correct_game
    game = Game.new
    game.prisoners_dilemma
    assert_equal pris_payoffs, game.payoffs
    game.stag_hunt
    assert_equal stag_payoffs, game.payoffs
  end

  def test_it_finds_the_equilibria
    game = Game.new
    game.prisoners_dilemma
    assert_equal ["Defect, Defect"], game.nash_equilibrium
    game.stag_hunt
    assert_equal ["Cooperate, Cooperate", "Defect, Defect"], game.nash_equilibrium
    game.battle_of_the_sexes
    assert_equal ["Cooperate, Cooperate", "Defect, Defect"], game.nash_equilibrium
  end
end
