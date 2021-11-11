class Dlink_DGS_1510_xxX < Oxidized::Model
  # Add support dgs 1510 series (tested only with DGS-1510-52X,DGS-1510-28X)
  # /var/lib/gems/2.5.0/gems/oxidized-0.28.0/lib/oxidized/model/Dlink_DGS_1510_xxX.rb

  prompt /^(\e\[27m)?(\r*[\w\s.@()\/:-]+[#>]\s?)$/
  comment '# '

# replace next line control sequence with a new line
   expect /(\e\[1M\e\[\??\d+(;\d+)*[A-Za-z]\e\[1L)|(\eE)/ do |data, re|
     data.gsub re, "\n"
   end

   cmd 'show running-config' do |cfg|
     cfg.gsub! /\s.+show running-config\s.+/, 'show config current_config'
     cfg.gsub! /Current configuration\s.+/, '# Current configuration'
     cfg.gsub! /username( \w* )(password \d)( \w*)/, 'username\\1\\2 << Value removed >>'
     cfg
   end

  cfg :ssh do
    post_login 'terminal length 0'
    pre_logout 'logout'
  end
end
