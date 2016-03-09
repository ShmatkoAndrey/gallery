module EventHelper
  def event(ev)
    case ev
      when 'Create post'
        "#{t 'event.post_create'}"
      when 'Destroy post'
        "#{t 'event.post_destroy'}"
      when 'Upload imgs'
        "#{t 'event.post_upload'}"
      when 'Comment create'
        "#{t 'event.comment_create'}"
      when 'Comment destroy'
        "#{t 'event.comment_destroy'}"
    end
  end
end