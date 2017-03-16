# Given a template and an environment, fill the template with correct values.
class TemplateParser
  IF_TAG = ?#     # prefix for if tags
  UNLESS_TAG = ?^ # prefix for unless tags
  NIL_VAR = ''
  TAG_CAPTURE = /
    {(.+)} # capture an opening tag
    (.+)   # capture content after opening tag
    {(\1)} # capture tag matching first capture
    |      # or
    {(.+)} # capture just a tag
  /x

  # @param environment
  # a hash of values to interpolate into templates
  #
  def initialize(environment)
    @environment = environment
  end

  # @param template
  # a string template
  # @return an interpolated string
  #
  def parse(template)
    @template = template.dup
    interpolate_environment while contains_tags?
    @template
  end

  private

  def contains_tags?
    @template =~ TAG_CAPTURE
  end

  def interpolate_environment
    match, tag, content, _, variable = TAG_CAPTURE.match(@template).to_a
    return if match.nil?

    interpolate_variable match, variable if variable
    interpolate_tags match, tag, content if tag
  end

  def interpolate_variable(match, variable)
    @template.gsub! match, @environment.fetch(variable.downcase.to_sym, NIL_VAR)
  end

  def interpolate_tags(match, tag, content)
    symbol = tag.sub(/[#{IF_TAG}#{UNLESS_TAG}]/, NIL_VAR).downcase.to_sym

    @template.gsub! match, if tag =~ /#{IF_TAG}/
                              @environment[symbol] ? content : NIL_VAR
                            elsif tag =~ /#{UNLESS_TAG}/
                              @environment[symbol] ? NIL_VAR : content
                            end.strip
  end
end
