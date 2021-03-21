class Dlink1210ME < Oxidized::Model
  # D-LINK Switches level 2
  # Test on DGS-1210-28/ME
  # /var/lib/gems/2.5.0/gems/oxidized-0.28.0/lib/oxidized/model/Dlink1210ME.rb

  prompt /^(\e\[27m)?(\r*[\w\s.@()\/:-]+[#>]\s?)$/
  comment ''

# replace next line control sequence with a new line
   expect /(\e\[1M\e\[\??\d+(;\d+)*[A-Za-z]\e\[1L)|(\eE)/ do |data, re|
     data.gsub re, "\n"
   end

   cmd 'show config current_config' do |cfg|
     cfg.gsub! /show config current_config\s.+/, '# show config current_config' # show config current_config
     cfg.gsub! /^# User Account\ncreate account( \w* \w*)\n(\w*)\n(\w*)/, "# User Account\ncreate account\\1\ \n<< SENSORED >>\n<< SENSORED >>" # 
#     cfg.gsub! /^(Device|System) Uptime\s.+/, '===' # Omit constantly changing uptime info
     comment cfg
   end

  cfg :ssh do
    post_login 'disable clipaging'
    pre_logout 'logout'
  end
end
