# typed: strict
# frozen_string_literal: true

require 'sorbet-runtime'
require 'test/unit'
require_relative './solution'

module Day5
  # Day 5 solution unit test.
  class TestSolution < Test::Unit::TestCase
    extend T::Sig

    sig { void }
    def test_empty
      lines = []
      seeds, maps = Day5.parse_input(lines)
      locations = Day5.locations_for_seeds(seeds:, maps:)
      assert_equal([], locations)
    end

    sig { void }
    def test_simple_provided
      lines = <<~LINES
        seeds: 79 14 55 13

        seed-to-soil map:
        50 98 2
        52 50 48

        soil-to-fertilizer map:
        0 15 37
        37 52 2
        39 0 15

        fertilizer-to-water map:
        49 53 8
        0 11 42
        42 0 7
        57 7 4

        water-to-light map:
        88 18 7
        18 25 70

        light-to-temperature map:
        45 77 23
        81 45 19
        68 64 13

        temperature-to-humidity map:
        0 69 1
        1 0 69

        humidity-to-location map:
        60 56 37
        56 93 4
      LINES

      seeds, maps = Day5.parse_input(lines.split("\n"))
      assert_equal([79, 14, 55, 13], seeds)
      locations = Day5.locations_for_seeds(seeds:, maps:)
      assert_equal([82, 43, 86, 35], locations)
      assert_equal(35, locations.min)
    end

    sig { void }
    def test_simple_provided_parsed_as_range
      lines = <<~LINES
        seeds: 79 14 55 13

        seed-to-soil map:
        50 98 2
        52 50 48

        soil-to-fertilizer map:
        0 15 37
        37 52 2
        39 0 15

        fertilizer-to-water map:
        49 53 8
        0 11 42
        42 0 7
        57 7 4

        water-to-light map:
        88 18 7
        18 25 70

        light-to-temperature map:
        45 77 23
        81 45 19
        68 64 13

        temperature-to-humidity map:
        0 69 1
        1 0 69

        humidity-to-location map:
        60 56 37
        56 93 4
      LINES

      seeds, maps = Day5.parse_input(lines.split("\n"), parse_seeds_as_range: true)
      locations = Day5.locations_for_seeds(seeds:, maps:)
      assert_equal(46, locations.min)
    end
  end
end
