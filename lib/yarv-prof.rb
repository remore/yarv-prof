require 'yarv-prof/version'
require 'tempfile'

class YarvProf
  class << self
    def start(clock: :wall, out:'/tmp/yarv-prof/', opt:'-x bufsize=20m')
      at_exit do
        Process.kill(:TERM, @pid) if !@pid.nil?
        FileUtils.remove_entry @file.path if File.exists?(@file.path)
      end
      measure_mode = clock == :cpu ? "vtimestamp" : "timestamp"
      @file = Tempfile.new('.yarv-prof.d')
      @file.puts <<EOS
dtrace:::BEGIN{
  printf("insn,#{measure_mode}\\n");
}

ruby#{Process.pid}:::insn{
  printf("%s,%d\\n", copyinstr(arg0), #{measure_mode});
}
EOS
      @file.close
      FileUtils.mkdir out if !File.directory?(out)
      dumpfile = out + Time.now.strftime('%Y%m%d_%H%M%S.dump')
      @pid = Process.spawn("dtrace -q -s '#{@file.path}' #{opt}", :err => :out,:out => dumpfile)
      `size=0;while [ $size -le 10 ];do size=$(wc -c < #{dumpfile});sleep 0.01;done`
    end

    def end
      sleep 1 # sleep here otherwise the log file will be empty
      Process.kill(:TERM, @pid) if !@pid.nil?
    end
  end
end
