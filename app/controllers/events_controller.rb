class EventsController < ApplicationController

  def index
    # @eventable = find_eventable
    @events = Kaminari.paginate_array(Event.order('created_at DESC')).page(params[:page]).per(15)
  end

  def find_eventable # Для вывода всех евентов для нужной группы
    params.each do |name, value|
      if name =~ /(.+)_id$/
        return $1.classify.constantize.find(value)
      end
    end
    nil
  end

end