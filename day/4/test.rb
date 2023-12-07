# typed: strict
# frozen_string_literal: true

require 'sorbet-runtime'
require 'test/unit'
require_relative './solution'

module Day4
  # Day 4 solution unit test.
  class TestSolution < Test::Unit::TestCase
    extend T::Sig

    sig { void }
    def test_empty
      total_points = Day4.points_for_cards([])
      assert_equal(0, total_points)

      total_cards = Day4.total_cards([])
      assert_equal(0, total_cards)
    end

    sig { void }
    def test_simple_provided
      card_lines = [
        'Card 1: 41 48 83 86 17 | 83 86  6 31 17  9 48 53',
        'Card 2: 13 32 20 16 61 | 61 30 68 82 17 32 24 19',
        'Card 3:  1 21 53 59 44 | 69 82 63 72 16 21 14  1',
        'Card 4: 41 92 73 84 69 | 59 84 76 51 58  5 54 83',
        'Card 5: 87 83 26 28 32 | 88 30 70 12 93 22 82 36',
        'Card 6: 31 18 13 56 72 | 74 77 10 23 35 67 36 11'
      ]
      total_points = Day4.points_for_cards(card_lines)
      assert_equal(13, total_points)

      total_cards = Day4.total_cards(card_lines)
      assert_equal(30, total_cards)
    end
  end
end
