# ##
# File: <spec>/xml_matchers.rb
#
# Refs: https://github.com/sparklemotion/nokogiri/wiki/Cheat-sheet
#       https://arjanvandergaag.nl/blog/rspec-matchers.html
#       http://blog.wolfman.com/articles/2008/1/2/xpath-matchers-for-rspec
#       https://semaphoreci.com/community/tutorials/how-to-use-custom-rspec-matchers-to-specify-behaviour
#

# Useage
# ----------------------------------------------------------------------
# expect(bundle).to have_xpath('//witnesses/witness/role')
# expect(bundle).to have_nodes('//witnesses/witness/role', 3)
# expect(bundle).to match_xpath('//lossInformation/date', "2020-01-28")

    # check if the xpath exists one or more times
class HaveXpath
  def initialize(xpath)
    @xpath = xpath
  end

  def matches?(str)
    @str = str
    xml_document.xpath(@xpath).any?
  end

  def failure_message
    "Expected xpath #{@xpath.inspect} to match in:\n" + pretty_printed_xml
  end

  def failure_message_when_negated
    "Expected xpath #{@xpath.inspect} not to match in:\n" + pretty_printed_xml
  end

  private

  def pretty_printed_xml
    xml_document.to_xml(indent: 2)
  end

  def xml_document
    @xml_document ||= Nokogiri::XML(@str)
  end
end

def have_xpath(*xpath)
  HaveXpath.new(*xpath)
end

# check if the xpath has the specified value
# value is a string and there must be a single result to match its
# equality against
class MatchXpath
  def initialize(xpath, val)
    @xpath = xpath
    @val= val
  end

  def matches?(response)
    @response = response
    doc = response.is_a?(Nokogiri::XML::Document) ? response : Nokogiri::XML(@response)
    ok= true
    doc.xpath(@xpath).each do |e|
      @actual_val= case e
                   when Nokogiri::XML::Attr
                     e.to_s
                   when Nokogiri::XML::Element
                     e.text
                   else
                     e.to_s
                   end
      return false unless @val == @actual_val
    end
    return ok
  end

  def failure_message
    "The xpath #{@xpath} did not have the value '#{@val}' \n It was '#{@actual_val}'"
  end

  def failure_message_when_negated
    "The xpath #{@xpath} has the value '#{@val}' \n Was expected not to match '#{@actual_val}'"
  end

  def description
    "match the xpath expression #{@xpath} with #{@val}"
  end
end

def match_xpath(xpath, val)
  MatchXpath.new(xpath, val)
end

# checks if the given xpath occurs num times
class HaveNodes  #:nodoc:
  def initialize(xpath, num)
    @xpath= xpath
    @num = num
  end

  def matches?(response)
    @response = response
    doc = response.is_a?(Nokogiri::XML::Document) ? response : Nokogiri::XML(@response)
    matches = doc.xpath(@xpath)
    @num_found= matches.size
    @num_found == @num
  end

  def failure_message
    "Did not find expected number of nodes #{@num} in xpath #{@xpath} \n Found #{@num_found}"
  end

  def description
    "match the number of nodes #{@num}"
  end
end

def have_nodes(xpath, num)
  HaveNodes.new(xpath, num)
end

