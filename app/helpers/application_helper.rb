module ApplicationHelper
  def hello
    if user_signed_in? && !current_user.name.nil?
      !current_user.name.empty? ? "#{t 'header.hello.hello_user'} #{current_user.name}" : "#{t 'header.hello.hello_user'} #{current_user.username}"
    else
      "#{t 'header.hello.hello_guest'}"
    end
  end

  def avatar_small_thumb(user)
    if user_signed_in?
      if user.avatar.nil? || user.avatar.blank?
        image_tag('avatar.png', size: "30x30", class: 'avatar_small')
      else
        if user.avatar.small_thumb.file.exists?
          image_tag user.avatar.small_thumb, class: 'avatar_small'
        end
      end
    end
  end

  def avatar_thumb(user)
    if user_signed_in?
      if user.avatar.nil? || user.avatar.blank?
        image_tag('avatar.png', size: "150x150", class: 'avatar_thumb')
      else
        if user.avatar.thumb.file.exists?
          image_tag user.avatar.thumb, class: 'avatar_thumb'
        end
      end
    end
  end

  def resource_name
    :user
  end

  def resource
    @resource ||= User.new
  end

  def devise_mapping
    @devise_mapping ||= Devise.mappings[:user]
  end
end