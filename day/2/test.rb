# typed: strict
# frozen_string_literal: true

require 'sorbet-runtime'
require 'test/unit'
require_relative './solution'

module Day2
  # Day 1 solution unit test.
  class TestSolution < Test::Unit::TestCase
    extend T::Sig

    sig { void }
    def test_empty
      solution = Solution.new([])
      result = solution.solve
      assert_equal([], result.failed_game_ids)
    end

    sig { void }
    def test_basic_provided_part_a_example
      lines = [
        'Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green',
        'Game 2: 1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue',
        'Game 3: 8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red',
        'Game 4: 1 green, 3 red, 6 blue; 3 green, 6 red; 3 green, 15 blue, 14 red',
        'Game 5: 6 red, 1 blue, 3 green; 2 blue, 1 red, 2 green'
      ]

      games = Day2.parse_games_from_lines(lines)

      solution = Solution.new(games)
      result = solution.solve
      assert_equal([1, 2, 5], result.successful_game_ids)
      assert_equal([3, 4], result.failed_game_ids)
      assert_equal(8, result.successful_game_ids.sum)
      assert_equal([48, 12, 1560, 630, 36], result.powers)
      assert_equal(2286, result.powers.sum)
    end
  end
end
