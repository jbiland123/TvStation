module ApplicationHelper
    def german_month_name(date)
      german_month_names = [nil, "Januar", "Februar", "März", "April", "Mai", "Juni", "Juli", "August", "September", "Oktober", "November", "Dezember"]
      german_month_names[date.month]
    end

    def german_month_name_short(date)
        german_month_names_short = [nil, "Jan", "Feb", "Mär", "Apr", "Mai", "Jun", "Jul", "Aug", "Sep", "Okt", "Nov", "Dez"]
        german_month_names_short[date.month]
      end

    def german_day_name(date)
        german_day_names = %w(Sonntag Montag Dienstag Mittwoch Donnerstag Freitag Samstag)
        german_day_names[date.wday]
    end

    def german_day_name_short(date)
        german_day_names_short = %w(So Mo Di Mi Do Fr Sa)
        german_day_names_short[date.wday]
    end

    def multiline_text(text)
        return text unless text.include?(',')
    
        text.split(',').join(',<br>').html_safe
      end
end