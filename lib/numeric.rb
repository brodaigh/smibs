class Numeric
public
def to_currency(pre_symbol='$', thousands=',', decimal='.', post_symbol=nil)
  "#{pre_symbol}#{("%.1f" % self ).gsub(".", decimal).gsub(/(\d)(?=(?:\d{3})+(?:$|[\\#{decimal}]))/,"\\1#{thousands}")}#{post_symbol}"
end
end