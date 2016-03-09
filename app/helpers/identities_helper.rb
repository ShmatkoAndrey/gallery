module IdentitiesHelper
  def bounds_acc(provider)
    identity = Identity.acc(provider, resource.id)
    if !identity
      p link_to "#{t 'user_.bound'} #{provider.to_s.titleize}", omniauth_authorize_path(resource_name, provider)
    else
      p link_to "#{t 'user_.unbound'} #{provider.to_s.titleize}", identity, :method => :delete
    end
  end
end
