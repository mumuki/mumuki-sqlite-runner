
class Hash
  def to_yaml
    super.sub('---', '').strip
  end
end