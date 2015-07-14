class Numeric
  def relative_occurence
    ago = self > 0
    
    secs  = self.to_int.abs
    mins  = secs / 60
    hours = mins / 60
    days  = hours / 24

    duration =
      if days > 0
        "#{days} days, #{hours % 24} hours"
      elsif hours > 0
        "#{hours} hours, #{mins % 60} minutes"
      elsif mins > 0
        "#{mins} minutes"
      elsif secs >= 0
        "#{secs} seconds"
      end

    if ago
      "#{ duration } ago"
    else
      "in #{ duration }"
    end
  end
end

class String
  def truncate max_length=140
    if length > max_length
      self[0..(max_length - 3)] + '...'
    else
      dup
    end
  end
end
