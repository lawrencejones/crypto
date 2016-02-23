require 'digest'
require 'thread'

def hash(m)
  Digest::SHA256.digest(Digest::SHA256.digest(m))
end

seed = 'CO409CryptographyEngineeringRunsNowForItsSecondYear'
no_of_workers = 8

pids = (1..no_of_workers).map do |worker_no|
  Process.fork do
    i = worker_no

    loop do
      i += no_of_workers
      puts("[#{worker_no}] [##{i}]") if i % 100_000 == 0

      m = "#{seed}#{i}"
      h = hash(m).unpack('H*').first

      if h =~ /^0{6}/
        puts('Found! ', m: m, h: h)
        exit(0)
      end
    end
  end
end

done = Process.wait
pids.each { |pid| Process.kill('SIGTERM', pid) unless pid == done }
