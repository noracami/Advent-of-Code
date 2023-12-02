# frozen_string_literal: true

module Utils
  def parse_input(file_name = nil)
    return if file_name.nil?

    File.readlines(file_name, chomp: true)
  end
end
