#!/usr/bin/env ruby
require_relative "workspace"
require_relative "user"
require_relative "channel"

# require_relative "../specs/test_helper"
require "table_print"
require "httparty"
require "pry"
require "dotenv"
Dotenv.load

def main
  workspace = Slack::Workspace.new

  puts "Welcome to the Ada Slack CLI!"
  # TODO project
  loop do
    puts "What would you like to do next?"
    puts "[list users] [list channels] [select user] [select channel] [details] [quit]"
    print "> "

    user_input = gets.chomp

    case user_input.downcase
    when "list users"
      tp workspace.users, :name, :real_name, :slack_id
    when "list channels"
      tp workspace.channels, :name, :topic, :member_count, :slack_id
    when "select user"
      puts "hehe haven't done this yet"
    when "select channel"
      puts "hehe haven't done this yet"
    when "details"
      puts "hehe haven't done this yet"
    end

    break if user_input == "quit"
  end

  puts "Thank you for using the Ada Slack CLI"
end

main if __FILE__ == $PROGRAM_NAME
