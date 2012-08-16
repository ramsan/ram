module DeviseDowncase
  def downcase_authentication_params
    #logger.info "params[resource_name] (pre):\n" + params[resource_name].inspect
    params[resource_name]['email'].downcase! if params[resource_name].has_key?('email')
    params[resource_name]['password'].downcase! if params[resource_name].has_key?('password')
    params[resource_name]['password_confirmation'].downcase! if params[resource_name].has_key?('password_confirmation')
    #logger.info "params[resource_name] (post):\n" + params[resource_name].inspect
  end
end