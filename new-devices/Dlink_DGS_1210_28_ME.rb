class Dlink_DGS_1210_28_ME < Oxidized::Model
  # D-link DGS-1210-28/ME
  # /var/lib/gems/2.5.0/gems/oxidized-0.28.0/lib/oxidized/model/Dlink_DGS_1210_28_ME.rb

  prompt /^(\e\[27m)?(\r*[\w\s.@()\/:-]+[#>]\s?)$/
  comment '# '

# replace next line control sequence with a new line
   expect /(\e\[1M\e\[\??\d+(;\d+)*[A-Za-z]\e\[1L)|(\eE)/ do |data, re|
     data.gsub re, "\n"
   end

  cmd 'show switch' do |cfg|
    cfg.gsub! /show switch\s.+/, ''
    cfg.gsub! /^System up time\s.+/, 'System up time                    : "Value removed"' # удаление значения uptime
    cfg.gsub! /^System Time\s.+/,    'System Time                       : "Value removed"' # удаление значения System Time
    cfg.gsub! /^RTC Time\s.+/,       'RTC Time                          : "Value removed"' # удаление значения System Time
    cfg.gsub! /^(\e\[27m)?/,    '' # удаление нечитаемого символа
    comment cfg
  end

  cmd 'show vlan' do |cfg|
    cfg.gsub! /show vlan\s.+/, ''
    cfg.gsub! /^(\e\[27m)?/,    '' # удаление нечитаемого символа
    comment cfg
  end

  cmd 'show config current_config' do |cfg|
    cfg.gsub! /show config current_config\s.+/, ''
    cfg.gsub! /^# User Account\ncreate account( \w* \w*)\n(\w*)\n(\w*)/, "# User Account\ncreate account\\1\ \n<< Value removed >>\n<< Value removed >>" # 
    cfg.gsub! /^(\e\[27m)?/,    '' # удаление нечитаемого символа
    cfg
  end

  cfg :ssh do
    post_login 'disable clipaging'
    pre_logout 'logout'
  end
end
