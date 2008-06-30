require File.dirname(__FILE__) + '/spec_helper'

describe YARD::Docstring do
  it "should parse comments into tags" do
    doc = Docstring.new(<<-eof)
      @param name Hello world
        how are you?
      @param name2 
        this is a new line
      @param name3 and this
        is a new paragraph:

        right here.
    eof
    doc.tags("param").each do |tag|
      if tag.name == "name"
        tag.text.should == "Hello world how are you?"
      elsif tag.name == "name2"
        tag.text.should == "this is a new line"
      elsif tag.name == "name3"
        tag.text.should == "and this is a new paragraph:\n\nright here."
      end
    end
  end
  
  it "should handle empty docstrings with #summary" do
    o1 = Docstring.new
    o1.summary.should == ""
  end

  it "should return the first sentence with #summary" do
    o = Docstring.new("DOCSTRING. Another sentence")
    o.summary.should == "DOCSTRING."
  end

  it "should return the first paragraph with #summary" do
    o = Docstring.new("DOCSTRING, and other stuff\n\nAnother sentence.")
    o.summary.should == "DOCSTRING, and other stuff."
  end

  it "should return proper summary when docstring is changed" do
    o = Docstring.new "DOCSTRING, and other stuff\n\nAnother sentence."
    o.summary.should == "DOCSTRING, and other stuff."
    o = Docstring.new "DOCSTRING."
    o.summary.should == "DOCSTRING."
  end

  it "should not double the ending period in docstring.summary" do
    o = Docstring.new("Returns a list of tags specified by +name+ or all tags if +name+ is not specified.\n\nTest")
    o.summary.should == "Returns a list of tags specified by +name+ or all tags if +name+ is not specified."
  
    doc = Docstring.new(<<-eof)
      
      Returns a list of tags specified by +name+ or all tags if +name+ is not specified.
      
      @param name the tag name to return data for, or nil for all tags
      @return [Array<Tags::Tag>] the list of tags by the specified tag name
    eof
    doc.summary.should == "Returns a list of tags specified by +name+ or all tags if +name+ is not specified."
  end

end
