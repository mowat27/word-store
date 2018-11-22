#!/usr/bin/env ruby

require 'erb'
require 'ostruct'

words = [
  {english: "silver", polish: "srebro", grammar: "nn"},
  {english: "nice (person)", polish: "miły", grammar: "adj"},
  {english: "walk", polish: "chodzić", grammar: "v"},
  {english: "go (on foot)", polish: "iść", grammar: "v"},
].map { |h| OpenStruct.new(h) }

template_file = ARGV.first || "#{File.dirname(__FILE__)}/templates/layout.html.erb"

template = ERB.new(File.read(template_file))
puts template.result(binding)
