#!/usr/bin/ruby

require 'json'
require 'open3'
require 'fileutils'

def run_command(command, should_fail = true)
	puts "cmd: " + command
	stdout, stderr, status = Open3.capture3(command)
	#puts stdout, stderr, status
	if !status.success?
	  puts "Failed to run command"
	  puts stdout, stderr, status
	  if should_fail
		raise
	  end
	end
end

def setup_repo()
	puts "Starting repo setup"
	# remove old directories
	run_command("rmdir /S /Q #{$base_path}\\repo", false)
	run_command("rmdir /S /Q #{$base_path}\\tmp", false)

	# create repo directory
	run_command("mkdir #{$base_path}\\repo")
	# create tmp directory for repo
	run_command("mkdir #{$base_path}\\tmp\\coreplans")

	# setup git repos in tmp directory with sparse checkout
	run_command("cd #{$base_path}\\tmp\\coreplans && git.exe init")
	run_command("cd #{$base_path}\\tmp\\coreplans && git.exe remote add -f origin https://github.com/habitat-sh/core-plans.git")
	run_command("cd #{$base_path}\\tmp\\coreplans && git.exe config core.sparseCheckout true")
end

def configure_coreplans()
	puts "Configuring repo of coreplans packages"
  	File.foreach("#{$coreplans_file}") { |line|
		run_command("echo #{line.strip()} >> #{$base_path}\\tmp\\coreplans\\.git\\info\\sparse-checkout")
	}
end

def download_coreplans()
	puts "Downloading repo of coreplans packages"
	run_command("cd #{$base_path}\\tmp\\coreplans && git.exe pull origin master", true)
	#run_command("cd #{$base_path}\\tmp\\coreplans && git.exe fetch origin")
  	File.foreach("#{$coreplans_file}") { |line|
		if !$to_skip.include? line
			pkg_name = line.strip()
			branch_name ="#{pkg_name}-#{$branch_suffix}"
			run_command("cd #{$base_path}\\tmp\\coreplans && git.exe checkout origin/#{branch_name} -- #{pkg_name}", false)
		end
	}
end

def move_coreplans()
  	puts "Moving repo of coreplans packages"
  	File.foreach("#{$coreplans_file}") { |line|
		run_command("move #{$base_path}\\tmp\\coreplans\\#{line.strip()} #{$base_path}\\repo\\")
		# sleep(5)
	}
end

def download_baseplans()
	puts "Downloading repo of baseplans pacakges"
	File.foreach("#{$baseplans_file}") { |line|
		pkg_name = line.strip()
		run_command("git.exe clone https://github.com/chef-base-plans/#{line.strip}.git #{$base_path}\\repo\\#{pkg_name}")
		run_command("cd #{$base_path}\\repo\\#{pkg_name} && git.exe fetch origin")
		if !$to_skip.include? line
			run_command("cd #{$base_path}\\repo\\#{pkg_name} && git.exe checkout #{$branch_name}", false)
		end
	}
end

# update global paramters before script run
$base_path="C:\\Users\\Administrator\\Documents\\Refresh"
$coreplans_file="#{$base_path}\\conf\\packageForWindows_coreplans.txt"
$baseplans_file="#{$base_path}\\conf\\packageForWindows_baseplans.txt"
$skip_file="#{$base_path}\\conf\\packageForWindows_skip.txt"

$branch_name="refresh2021q2"
$branch_suffix = ARGV[0] != nil ? ARGV[0] : 'version-bump-win'

begin
	puts "fiile: #{$skip_file}"
	$to_skip = File.readlines("#{$skip_file}")
rescue Errno::ENOENT
	$to_skip = [] # File does not exist, keep it as an empty array
end

setup_repo()
configure_coreplans()
download_coreplans()
move_coreplans()
#download_baseplans()

