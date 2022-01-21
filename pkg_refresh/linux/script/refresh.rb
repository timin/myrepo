#!/usr/bin/env ruby

require 'logger'
require 'dotenv'
require 'open3'
require 'pp'

def run_command(command)
	$LOG.debug("Running command: #{command}")
	Open3.popen2e(command) do |_, stdout_and_stderr, wait_thr|
		Thread.new { stdout_and_stderr.each {|l| puts l } }
	raise RuntimeError unless wait_thr.value.success?
	end
end

def refresh(list, skip)
	list.each { |line|
		plan, plan_args = line.split(' ')

		$LOG.info("Plan '#{plan}' is skipped") if skip.include? plan
		next if skip.include? plan

		$LOG.info("Building plan: #{plan}")
		$LOG.info("With args: #{plan_args}") if plan_args

		build_start_time = Time.now
		error = false

		begin
		run_command("hab studio run \"#{plan_args} build repo/#{plan}/\"")
		$LOG.info("Plan built: #{plan}")
		$LOG.info("With args: #{plan_args}") if plan_args
		rescue RuntimeError
		puts "Build failed: #{plan}"
		$LOG.error("Error building plan: #{plan}")
		error = true
		ensure

		build_end_time = Time.now
		build_time = build_end_time - build_start_time
		minutes = (build_time / 60).floor
		seconds = build_time.to_i % 60
		$LOG.info("Build '#{plan}' finished in #{minutes}m#{seconds}s")
	end
	raise if error

	Dotenv.overload('results/last_build.env')

	$LOG.debug("Changed pkg_ident to #{ENV['pkg_ident']}")
	$LOG.debug("Changed pkg_artifact to #{ENV['pkg_artifact']}")

	run_command("hab pkg upload results/#{ENV['pkg_artifact']} -u #{$builder_url} -z #{$auth_token} -c stable")

	$LOG.info("Uploaded #{ENV['pkg_artifact']} to #{$builder_url}:stable")
	}
end

time = Time.new
$LOG = Logger.new('refresh_%s%s%s.log' % [time.year, time.month, time.day], 'daily', level: 'INFO')
$LOG.datetime_format = '%Y-%m-%d %H:%M:%S'

start = Time.now

load "./conf/env.rb"

# update global paramters before script run
$base_path="/home/ubuntu/Refresh"
$buildorder_file="#{$base_path}/conf/packageForLinux_buildorder.txt"
$skip_file="#{$base_path}/conf/packageForLinux_skip.txt"
$builder_url="https://ec2-35-81-164-100.us-west-2.compute.amazonaws.com/bldr/v1/"
$auth_token=""

buildorder, toskip = []
buildorder = File.readlines("#{$buildorder_file}")
toskip = File.readlines("#{$skip_file}")

refresh(buildorder, toskip)

finish = Time.now
diff = finish - start
puts diff
