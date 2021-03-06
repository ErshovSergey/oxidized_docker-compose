class DlinkDGS_1510_28X_ME < Oxidized::Model
  # D-LINK Switches dlinkDGS-1510-28X/ME

  prompt /^(\r*[\w\s.@()\/:-]+[#>]\s?)$/
  comment '#'

  cmd :secret do |cfg|
    cfg.gsub! /^(create snmp community) \S+/, '\\1 <removed>'
    cfg.gsub! /^(create snmp group) \S+/, '\\1 <removed>'
    cfg
  end

  cmd :all do |cfg|
    cfg.each_line.to_a[2..-2].map { |line| line.delete("\r").rstrip }.join("\n") + "\n"
  end

  cmd 'show switch' do |cfg|
    cfg.gsub! /^System Uptime\s.+/, '' # Omit constantly changing uptime info
    comment cfg
  end

  cmd 'show vlan' do |cfg|
    comment cfg
  end

  cmd 'show config effective'  do |cfg|
#     cfg.gsub! /^# User Account\ncreate account( \w* \w*)\n(\w*)\n(\w*)/, "# User Account\ncreate account\\1\ \n<< SENSORED >>\n<< SENSORED >>"
      cfg.gsub! /^# ACCOUNT LIST\ncreate account (\w* \w*)\n(\w*)\n(\w*)/, "# ACCOUNT LIST\ncreate account\ncreate account \\1\ \n<< SENSORED >>\n<< SENSORED >>"
    comment cfg
  end

  cfg :ssh do
    post_login 'disable clipaging'
    pre_logout 'logout'
  end
end
