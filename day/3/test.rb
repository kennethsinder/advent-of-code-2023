# typed: strict
# frozen_string_literal: true

require 'sorbet-runtime'
require 'test/unit'
require_relative './solution'

module Day3
  # Day 3 solution unit test.
  class TestSolution < Test::Unit::TestCase
    extend T::Sig

    sig { void }
    def test_empty
      solution = Solution.new([])
      result = solution.solve
      assert_equal(0, result.part_number_sum)
      assert_equal(0, result.gear_ratio_sum)
    end

    sig { void }
    def test_no_symbols
      schematic = <<~SCHEMATIC
        467..114..
        ..........
        ..35..633.
        ..........
        617.......
        .......58.
        ..592.....
        ......755.
        ..........
        .664.598..
      SCHEMATIC

      solution = Solution.new(Solution.build_grid(schematic))
      result = solution.solve
      assert_equal(0, result.part_number_sum)
      assert_equal(0, result.gear_ratio_sum)
    end

    sig { void }
    def test_single_row
      ['467@.114@.', '467@#114..'].each do |schematic|
        solution = Solution.new(Solution.build_grid(schematic))
        result = solution.solve
        assert_equal(581, result.part_number_sum)
        assert_equal(0, result.gear_ratio_sum)
      end
    end

    sig { void }
    def test_simple_three_row_whitespace
      schematic = <<~SCHEMATIC
        100..100..
        ...*......
        ..300..633
      SCHEMATIC

      solution = Solution.new(Solution.build_grid(schematic))
      result = solution.solve
      assert_equal(400, result.part_number_sum)
      assert_equal(30_000, result.gear_ratio_sum)
    end

    sig { void }
    def test_simple_provided_case
      schematic = <<~SCHEMATIC
        467..114..
        ...*......
        ..35..633.
        ......#...
        617*......
        .....+.58.
        ..592.....
        ......755.
        ...$.*....
        .664.598..
      SCHEMATIC

      solution = Solution.new(Solution.build_grid(schematic))
      result = solution.solve
      assert_equal(4361, result.part_number_sum)
      assert_equal(467_835, result.gear_ratio_sum)
    end
  end
end
