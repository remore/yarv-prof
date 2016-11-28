require 'yarv-prof/version'
require 'tempfile'

class YarvProf
  class << self
    def start(clock: :wall, out:'/tmp/yarv-prof/')
      at_exit do
        Process.kill(:TERM, @pid) if !@pid.nil?
        FileUtils.remove_entry @file.path if File.exists?(@file.path)
      end
      @measure_mode = clock == :cpu ? "vtimestamp" : "timestamp"
      @dump_to = out
      @file = Tempfile.new('.yarv-prof.d')
      @file.puts <<EOS
dtrace:::BEGIN{
  printf("insn,#{@measure_mode}\\n");
}

ruby#{Process.pid}:::insn{
  printf("%s,%d\\n", copyinstr(arg0), #{@measure_mode});
}
EOS
      @file.close
      FileUtils.mkdir @dump_to if !File.directory?(@dump_to)
      dumpfile = Time.now.strftime('%Y%m%d_%H%M%S.dump')
      @pid = Process.spawn("dtrace -q -s '#{@file.path}'", :err => :out,:out => @dump_to + dumpfile)
      #while File.read(DUMPTO+dumpfile).size < 10 do
      #  sleep 0.01
      #end
      sleep 0.5
    end

    def end
      Process.kill(:TERM, @pid) if !@pid.nil?
    end
  end
end
