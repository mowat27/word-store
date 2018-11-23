#!/usr/bin/env ruby

require 'csv'
require 'erb'
require 'ostruct'

# -- Functions and Classes -----------------------------------------------------

class Array
  def second
    self[1]
  end
end

class Object
  def present?
    !nil?
  end
end

int = ->(x) { x.to_i }
downcase = ->(s) { s.to_s.downcase }

def nullify (fn = nil)
  return ->(s) {s.strip} if fn.nil?
  ->(s) { (s.nil? || s.empty?) ? nil : fn.call(s.strip) }
end

headers = [
  [:num, int],
  [:english],
  [:clarification],
  [:google_trans, downcase],
  [:polish, downcase],
  [:grammar, downcase],
  [:added_to_anki_at],
  [:notes]
]

class Word < Struct.new *headers.map(&:first)
  def fully_translated?
    polish.present? && grammar.present?
  end

  def added?
    added_to_anki_at.present?
  end

  def noun?
    grammar =~ /^n(m|f|n)$/
  end

  def adjective?
    grammar == "adj"
  end

  def verb?
    grammar == "v"
  end

  def number?
    grammar == "num"
  end

  def time?
    grammar == "day" || grammar == "month"
  end
end

def forvo_command(words)
  words.reduce("forvo") { |s, word| s + %Q{ "#{word.polish}"} }
end

def ready?(word)
  word.fully_translated? && !word.added?
end

def in_scope?(word)
  word.noun? || word.verb? || word.adjective?
end

# -- Program -------------------------------------------------------------------

words = STDIN.readlines.drop(1).reduce([]) do |arr, line|
  csv = headers.map(&:second).zip(CSV.parse(line).first).map { |xform, val| xform ? nullify(xform).call(val) : val }
  row = headers.map(&:first).zip(csv)
  arr << Word.new(*csv)
end

template_file = "#{File.dirname(__FILE__)}/templates/layout.html.erb"
template = ERB.new(File.read(template_file))
selected_words = words.select { |word| in_scope?(word) && ready?(word) }

puts template.result_with_hash(
  words: selected_words,
  icon_size: 20,
  forvo_cli: forvo_command(selected_words),
  forvo_api_key:
)

STDERR.puts "Generated html for #{selected_words.count} words"
