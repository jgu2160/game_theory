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

  def test_it_accepts_moves_and_provides_payoff
    setup_game_and_players
    assert_equal [2,2], @game.play(1,1)
    assert_equal [3,0], @game.play(0,1)
    assert_equal [0,3], @game.play(1,0)
    assert_equal [1,1], @game.play(0,0)
  end

  def setup_game_and_players
    #player class by default set up as tit for tat
    @p1 = Player.new
    @p2 = Player.new
    @game = Game.new(p1: @p1, p2: @p2)
    @game.prisoners_dilemma
  end

  def test_it_can_initialize_with_players
    setup_game_and_players
    assert_equal @p1, @game.p1
    assert_equal @p2, @game.p2
  end

  def test_it_can_induce_a_turn
    setup_game_and_players
    assert_equal [2,2], @game.turn
  end

  def test_players_can_remember_game_outcomes
    setup_game_and_players
    @game.turn
    assert_equal [1], @p1.move_memory_self
    assert_equal [1], @p1.move_memory_opponent
    assert_equal [2], @p1.payoff_memory
  end

  def test_tit_for_tat_results_in_cooperations
    setup_game_and_players
    3.times do
      @game.turn
    end
    assert_equal 6, @p1.payoff
    assert_equal 6, @p2.payoff
  end

  def test_mean_tit_for_tat_results_in_defect_winning
    setup_game_and_players
    p2 = MeanTitForTat.new
    @game.p2 = p2
    3.times do
      @game.turn
    end
    assert_equal 3, @p1.payoff
    assert_equal 6, p2.payoff
  end

  def test_mean_player_wins_v_tit_for_tat
    setup_game_and_players
    p2 = Mean.new
    @game.p2 = p2
    3.times do
      @game.turn
    end
    assert_equal 2, @p1.payoff
    assert_equal 5, p2.payoff
  end

  def test_mean_player_wins_v_tit_for_tat
    setup_game_and_players
    p1 = Mean.new
    p2 = Mean.new
    @game.p1 = p1
    @game.p2 = p2
    3.times do
      @game.turn
    end
    assert_equal 3, p1.payoff
    assert_equal 3, p2.payoff
  end
end
