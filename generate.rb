#!/usr/bin/env ruby

require 'csv'
require 'erb'
require 'ostruct'

words = [
  {english: "silver", polish: "srebro", grammar: "nn"},
  {english: "nice (person)", polish: "miły", grammar: "adj"},
  {english: "walk", polish: "chodzić", grammar: "v"},
  {english: "go (on foot)", polish: "iść", grammar: "v"},
].map { |h| OpenStruct.new(h) }

class Array
  def second
    self[1]
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

words = STDIN.readlines.drop(1).reduce([]) do |arr, line|
  csv = headers.map(&:second).zip(CSV.parse(line).first).map { |xform, val| xform ? nullify(xform).call(val) : val }
  row = headers.map(&:first).zip(csv)
  arr << OpenStruct.new(Hash[row])
end

def ready?(word)
  word.added_to_anki_at.nil? && word.polish && word.grammar
end

def number?(word)
  word.grammer == "num"
end

def time?(word)
  word.grammer == "day" || word.grammer == "month"
end

words.each do |word|
  next unless word.clarification
  notes = word.clarification.split(/[)(]+/).reject(&:empty?).join(", ")
  word.english += " (#{notes})"
end

template_file = "#{File.dirname(__FILE__)}/templates/layout.html.erb"
template = ERB.new(File.read(template_file))

publish_list = words.reject { |word| !ready?(word) || number?(word) || time?(word) }
puts template.result_with_hash(words: publish_list, icon_size: 24 )
STDERR.puts "Generated html for #{publish_list.count} words"
