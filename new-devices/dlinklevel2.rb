class DlinkLevel2 < Oxidized::Model
  # D-LINK Switches level 2
  # Add support dgs 1210 series (tested only with dgs-1210????????)
  # Add support dgs 1510 series (tested only with DGS-1510-52X,DGS-1510-28X)
  # /var/lib/gems/2.5.0/gems/oxidized-0.28.0/lib/oxidized/model/dlinklevel2.rb

  prompt /^(\e\[27m)?(\r*[\w\s.@()\/:-]+[#>]\s?)$/
#  prompt /^(\r*[\w\s.@()\/:-]+[#>]\s?)$/
  comment ''
# replace next line control sequence with a new line
   expect /(\e\[1M\e\[\??\d+(;\d+)*[A-Za-z]\e\[1L)|(\eE)/ do |data, re|
     data.gsub re, "\n"
   end

   cmd 'show running-config' do |cfg|
#     cfg.gsub! /^(Device|System) Uptime\s.+/, '' # Omit constantly changing uptime info
#     cfg.gsub! /^username\s.+/, 'username --->*** Sensored ***'
     cfg.gsub! /^username\s.+/, '0000000000000'
     comment cfg
   end

  cfg :ssh do
    post_login 'terminal length 0'
    pre_logout 'logout'
  end
end
