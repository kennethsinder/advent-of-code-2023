# typed: strict
# frozen_string_literal: true

require 'sorbet-runtime'
require 'test/unit'
require_relative './solution'

module Day1
  # Day 1 solution unit test.
  class TestSolution < Test::Unit::TestCase
    extend T::Sig

    sig { void }
    def test_empty
      solution = Solution.new([])
      result = solution.solve
      assert_equal(0, result.total_calibration_value)
    end

    sig { void }
    def test_simple_provided_case
      solution = Solution.new(%w[
                                1abc2
                                pqr3stu8vwx
                                a1b2c3d4e5f
                                treb7uchet
                              ])
      result = solution.solve
      assert_equal(142, result.total_calibration_value)
    end

    sig { void }
    def test_simple_provided_case_part_b
      solution = Solution.new(%w[
                                two1nine
                                eightwothree
                                abcone2threexyz
                                xtwone3four
                                4nineeightseven2
                                zoneight234
                                7pqrstsixteen
                              ])
      result = solution.solve
      assert_equal(281, result.total_calibration_value)
    end

    sig {void}
    def test_ambiguous_parsing
      solution = Solution.new(%w[
                                2oneight
                                5sevenine
                                sevenine3
                                1sevenine4
                                14sevenine9
                              ])
      result = solution.solve
      assert_equal(28 + 59 + 73 + 14 + 19, result.total_calibration_value)
    end
  end
end
