# typed: strict
# frozen_string_literal: true

require 'sorbet-runtime'

# Advent of code Day 5 solution code.
module Day5
  extend T::Sig

  sig do
    params(
      map_lines: T::Array[String]
    ).returns([String, String, T::Array[[Integer, Integer, Integer]]])
  end
  def self.process_map(map_lines)
    parsed_first_line = T.must(/([a-z]+)-to-([a-z]+)/.match(map_lines.fetch(0)))
    source_type = parsed_first_line[1].to_s
    destination_type = parsed_first_line[2].to_s

    result = T::Array[[Integer, Integer, Integer]].new

    map_lines.drop(1).each do |map_line|
      parsed_map_line = map_line.split(' ').map(&:to_i)
      result << [parsed_map_line.fetch(0), parsed_map_line.fetch(1), parsed_map_line.fetch(2)]
    end

    [source_type, destination_type, result]
  end

  #   seed-to-soil map:
  # 50 98 2
  # 52 50 48

  # soil-to-fertilizer map:
  # 0 15 37
  # 37 52 2
  # 39 0 15
  
  # 35 98 2

  sig do
    params(
      map_a: T::Array[[Integer, Integer, Integer]],
      map_b: T::Array[[Integer, Integer, Integer]]
    )
      .returns(T::Array[[Integer, Integer, Integer]])
  end
  def self.combine_maps(map_a, map_b)
    sources_to_split_by = map_a.flat_map do |_, source_start, length|
      [source_start, source_start + length]
    end.uniq.sort

    map_b.flat_map do |range_b|
      map_a.find do
    end

    []
  end

  sig do
    params(
      value: Integer,
      map: T::Array[[Integer, Integer, Integer]]
    )
      .returns(Integer)
  end
  def self.lookup_from_map(value:, map:)
    map.each do |destination_start, source_start, range_length|
      if value >= source_start && value < source_start + range_length
        return destination_start + (value - source_start)
      end
    end

    value
  end

  sig do
    params(
      seeds: T::Array[Integer],
      maps: T::Hash[String, [String, T::Array[[Integer, Integer, Integer]]]]
    )
      .returns(T::Array[Integer])
  end
  def self.locations_for_seeds(seeds:, maps:)
    seeds.map do |seed|
      current_value = seed
      current_source = 'seed'

      while current_source != 'location'
        new_source, map = maps.fetch(current_source)
        current_source = new_source

        current_value = lookup_from_map(value: current_value, map:)
      end

      current_value
    end
  end

  sig do
    params(
      input: T::Array[String],
      parse_seeds_as_range: T::Boolean
    ).returns(
      [T::Array[Integer], T::Hash[String, [String, T::Array[[Integer, Integer, Integer]]]]]
    )
  end
  def self.parse_input(input, parse_seeds_as_range: false)
    seeds = input[0].to_s.split(' ').drop(1).map(&:to_i)

    if parse_seeds_as_range
      seeds = seeds.each_slice(2).flat_map do |seed_start, length|
        (T.must(seed_start)...T.must(seed_start) + T.must(length)).to_a
      end
    end

    maps = T::Hash[String, [String, T::Array[[Integer, Integer, Integer]]]].new

    start_index = 2
    while start_index < input.length
      end_index = start_index + 1
      end_index += 1 until input[end_index].to_s.strip.empty?
      end_index -= 1

      map_lines = T.must(input[start_index..end_index])
      source_type, destination_type, map = process_map(map_lines)
      maps[source_type] = [destination_type, map]

      start_index = end_index + 2
    end

    [seeds, maps]
  end

  sig { params(path: String).returns(T::Array[String]) }
  def self.lines_from_file(path)
    lines = T::Array[String].new

    File.open(path, 'r') do |f|
      f.each_line do |line|
        lines << line
      end
    end

    lines
  end
end

if __FILE__ == $PROGRAM_NAME
  lines = Day5.lines_from_file('day/5/input.txt')

  # seeds, maps = Day5.parse_input(lines)
  # locations = Day5.locations_for_seeds(seeds:, maps:)
  # puts locations.min

  seeds, maps = Day5.parse_input(lines, parse_seeds_as_range: true)
  locations = Day5.locations_for_seeds(seeds:, maps:)
  puts locations.min
end
