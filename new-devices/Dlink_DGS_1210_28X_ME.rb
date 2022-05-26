class Dlink_DGS_1210_28X_ME < Oxidized::Model
  # D-LINK Switches DGS-1210-28X/ME

  prompt /^(\e\[27m)?(\r*[\w\s.@()\/:-]+[#>]\s?)$/

  comment '# '

  cmd :secret do |cfg|
    cfg.gsub! /^(create snmp community) \S+/, '\\1 <removed>'
    cfg.gsub! /^(create snmp group) \S+/, '\\1 <removed>'
    cfg
  end

  cmd :all do |cfg|
    cfg.each_line.to_a[2..-2].map { |line| line.delete("\r").rstrip }.join("\n") + "\n"
  end

  cmd 'show switch' do |cfg|
    cfg.gsub! /^System up time\s.+/, 'System up time                    : "Value removed"' # Omit constantly changing uptime info
    cfg.gsub! /^System Time\s.+/,    'System Time                       : "Value removed"' # Omit constantly changing uptime info
    cfg.gsub! /^RTC Time\s.+/,       'RTC Time                          : "Value removed"' # Omit constantly changing uptime info
    comment cfg
  end

  cmd 'show vlan' do |cfg|
    comment cfg
  end

   cmd 'show config current_config' do |cfg|
     cfg.gsub! /^# User Account\ncreate account( \w* \w*)\n(\w*)\n(\w*)/, "# User Account\ncreate account\\1\ \n<< Value removed >>\n<< Value removed >>" #
     cfg
   end

  cfg :ssh do
    post_login 'disable clipaging'
    pre_logout 'logout'
  end

end
