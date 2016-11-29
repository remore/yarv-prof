## Prerequisite

- DTrace must be installed on your system
- You need to edit MRI source code as follows(since pre-compiled MRI doesn't provide `insn` probe, you need to enable this  manually, as of Ruby2.4.0)

```
$ git clone https://github.com/ruby/ruby.git
$ cd ruby && autoconf
$ ./configure
$ vi vm_opts.h # set the VM_COLLECT_USAGE_DETAILS flag to 1 manually
$ make && make install
$ ./ruby -v
```

## Getting Started

Since we use custom built MRI binary, the profiling command will look like following(unless you have installed custom built MRI and rubygems onto your system)

```
$ gem install yarv-prof
$ sudo ./ruby -I `gem env gemdir`/gems/yarv-prof*/lib/ -r yarv-prof -e "YarvProf.start; p :hello; YarvProf.end"
$ yarv-prof --load /tmp/yarv-prof/20161128_214131.dump
total number of instruction calls: 26
insn                                   count      total_walltime      mean        variance    stdev
---------------------------------------------------------------------------------------------------
opt_send_without_block                4(15%)         298567(33%)     74642      2362231992    48603
trace                                 4(15%)         139888(15%)     34972       566184557    23795
getinlinecache                         2(7%)           76616(8%)     38308      1093622912    33070
getconstant                            2(7%)           65426(7%)     32713       674546450    25972
setinlinecache                         2(7%)           51301(5%)     25650       218718612    14789
leave                                  2(7%)           46497(5%)     23248        54444612     7379
putobject                              2(7%)           44293(4%)     22146       182576940    13512
getinstancevariable                    2(7%)           42118(4%)     21059        94146642     9703
pop                                    2(7%)           41412(4%)     20706         2056392     1434
opt_not                                1(3%)           30059(3%)     30059             NaN      NaN
jump                                   1(3%)           27644(3%)     27644             NaN      NaN
putself                                1(3%)           23844(2%)     23844             NaN      NaN
branchunless                           1(3%)           15042(1%)     15042             NaN      NaN
```

## Usage

#### Step1: Recording

This is the sample usage of YarvProf in your code.

```
YarvProf.start(clock: :cpu, out:'~/log/')
p :hello
YarvProf.end
```

YarvProf#start can take following 3 optional keyword args.

- `clock` is for the flag to switch measurement mode(`:cpu` or `:wall`)
- `out` is to specify the target directory path which the dump file will be stored in.
- `opt` is to give arbitrary CLI option when yarv-prof trigger dtrace command(e.g. `opt:'-x bufsize=20m'`).

#### Step2: Reporting

Here is the sample usage of yarv-prof CLI command, which is specifically designed to parse and view dumped data.

```
$ yarvprof --load ./result.dump --insn getlocal_OP__WC__1
```

yarv-prof command can take following options.

```
$ yarvprof -h
Usage: yarv-prof [options]
    -v, --version                    Print version
        --load=FILENAME              Load .dump file
        --csv                        Report with csv format
        --raw                        Show raw log data with time series alignment
        --insn=VALUE                 Show a specific instruction only
```

## TBD in future

- More detailed information regarding YARV instructions
- Improve performance
- System Tap support for linux environment(only if needed)
- Sampling profiler mode(if needed)
- Docker support etc

## Other resources

- You may want to refer [my presentation slide](TBD) at RubyConf Taiwan 2016

## License

MIT
