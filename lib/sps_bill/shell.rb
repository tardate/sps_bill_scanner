class SpsBill::Shell
  attr_accessor :options, :fileset

  # command line options definition
  OPTIONS = %w(help verbose csv+ raw+ data=s)

  # Usage message
  def self.usage
    puts <<-EOS

SP Services Bill Scanner v#{SpsBill::Version::STRING}
===================================

Usage:
  sps_bill [options]

Command Options
  -r  | --raw    raw data format (without headers)
  -c  | --csv    output in CSV format (default)
  -d= | --data=[charges,electricity,gas,water,all]

    EOS
  end

  # +new+
  def initialize(options)
    @fileset = ARGV
    @options = (options||{}).each{|k,v| {k => v} }
  end

  def run
    if options[:help] or fileset.empty?
      self.class.usage
      return
    end
    case options[:data]
    when /^c/
      export(:total_amounts)
    when /^e/
      export(:electricity_usages)
    when /^g/
      export(:gas_usages)
    when /^w/
      export(:water_usages)
    # when /^a/
    else
      export(:all_data)
    end
  end

  def bills
    @bills ||= SpsBill::BillCollection.load(fileset)
  end

  def export(dataset_selector)
    format_header bills.headers(dataset_selector)
    format_rows bills.send(dataset_selector)
  end

  def format_rows(data)
    data.each do |row|
      puts row.join(',')
    end
  end

  def format_header(data)
    return if options[:raw]
    puts data.join(',')
  end

end