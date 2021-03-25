class HUAWEIUSG6320 < Oxidized::Model
  # new-devices/HUAWEIUSG6320
  # Test on HUAWEI USG6320.rb
  # /var/lib/gems/2.5.0/gems/oxidized-0.28.0/lib/oxidized/model/HUAWEIUSG6320.rb

#  prompt /^(\e\[27m)?(\r*[\w\s.@()\/:-]+[#>]\s?)$/
  prompt /^((\[|\<)\w*(\]|\>))/
  comment ''

# replace next line control sequence with a new line
   expect /(\e\[1M\e\[\??\d+(;\d+)*[A-Za-z]\e\[1L)|(\eE)/ do |data, re|
     data.gsub re, "\n"
   end

   cmd 'display current-configuration detail' do |cfg|
     cfg.gsub! /Last configuration was saved at\s.+/, 'Last configuration was saved at << SENSORED >>' # Omit constantly changing uptime info
     cfg.gsub! /(display current-configuration detail)\n([\d|\w|\r-|:|.]*)/, "\\1\n << SENSORED >>"
     cfg.gsub! /^# User Account\ncreate account( \w* \w*)\n(\w*)\n(\w*)/, "# User Account\ncreate account\\1\ \n<< SENSORED >>\n<< SENSORED >>" #
     comment cfg
   end

  cfg :ssh do
    post_login 'system-view'
    post_login 'quit'
    pre_logout 'quit'
  end
end
