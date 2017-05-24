module ApplicationHelper
  concerning :DateViewFeature do
    def short_datetime(datetime, offset = nil)
      return nil unless datetime
      offset ||= Time.zone.now
      ofd = offset.to_date
      dtd = datetime.to_date
      if offset - 1.hours < datetime
        datetime.strftime('%H:%M:%S')
      elsif ofd == dtd
        datetime.strftime('%H:%M')
      elsif ofd - 90.days < dtd || ofd.year == dtd.year
        datetime.strftime('%-m/%-d %H:%M')
      else
        datetime.strftime('%Y/%-m/%-d %H:%M')
      end
    end
    def short_date(datetime, offset = nil)
      return nil unless datetime
      offset ||= Time.zone.now
      ofd = offset.to_date
      dtd = datetime.to_date
      if ofd - 90.days < dtd || ofd.year == dtd.year
        datetime.strftime('%-m/%-d')
      else
        datetime.strftime('%Y/%-m/%-d')
      end
    end
    def long_date(datetime)
      return nil unless datetime
      datetime.strftime('%Y/%-m/%-d %H:%M')
    end
  end
end
