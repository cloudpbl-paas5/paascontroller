#!/usr/bin/ruby
# -*- encoding: utf-8 -*-

require 'mysql2'

def changeUserDB(repo_name, user_name, ip_address)
  client = Mysql2::Client.new(:host => "localhost", :username => "root", :password => "cloud2016", :database => "gitRepo")
  client.query("INSERT INTO gitRepo.Usr_repo (usr_name, repo_name) VALUES ('#{user_name}', '#{repo_name}')")
  results = client.query("SELECT id FROM gitRepo.Usr_repo WHERE usr_name = '#{user_name}'")
  repo_id = 0
  results.each do |row|
    repo_id = row["id"]
  end
  user_db_name = "#{user_name}-#{repo_name[0..-5]}"
  #passwd = [*0..9, *'a'..'z', *'A'..'Z'].sample(8).join
  passwd = user_name + 'cloud2016'
  client.query("CREATE USER IF NOT EXISTS '#{user_name}'@'157.82.3.%' IDENTIFIED BY '#{passwd}'")
  client.query("CREATE DATABASE `#{user_db_name}`")
  client.query("GRANT ALL ON `#{user_db_name}`.* TO #{user_name}@'157.82.3.%'")
  client.query("INSERT INTO gitRepo.Usr_db (repo_id, db_name, usr_name, passwd) VALUES (#{repo_id}, '#{user_db_name}', '#{user_name}', '#{passwd}')")
  return passwd
end
