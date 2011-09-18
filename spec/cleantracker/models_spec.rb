require File.expand_path(File.dirname(__FILE__) + "/../spec_helper")
require "cleantracker/models"

describe Cleantracker::Models do

  it "abbreviates codecast permalinks" do
    subject.cc_abbreviate("clean-code-episode-1").should == "E1"
    subject.cc_abbreviate("clean-code-episode-2").should == "E2"
    subject.cc_abbreviate("clean-code-episode-3-sc-1-testableHtml").should == "SC3-1"
    subject.cc_abbreviate("clean-code-episode-3-sc-2-prime").should == "SC3-2"
    subject.cc_abbreviate("theLastProgrammingLanguage").should == "tLPL"
    subject.cc_abbreviate("clean-code-episode-6-part-1").should == "E6-1"
    subject.cc_abbreviate("clean-code-episode-6-part-2").should == "E6-2"
  end

  it "adds codecasts abbreviations to licenses" do
    codecasts = [{:key => "abc", :permalink => "clean-code-episode-1"},
            {:key => "xyz", :permalink => "theLastProgrammingLanguage"}]
    data = [{:item_key => "xyz", :id => "123"},
            {:item_key => "abc", :id => "321"}]

    subject.add_codecast_abbreviations(codecasts, data)

    data.should == [{:item_key => "xyz", :id => "123", :codecast_abbr => "tLPL"},
            {:item_key => "abc", :id => "321", :codecast_abbr => "E1"}]
  end

  it "adds codecasts abbreviations" do
    codecasts = [{:key => "abc", :permalink => "clean-code-episode-1"},
            {:key => "xyz", :permalink => "theLastProgrammingLanguage"}]

    subject.add_abbreviations(codecasts)

    codecasts.should == [{:key => "abc", :permalink => "clean-code-episode-1", :abbr => "E1"},
            {:key => "xyz", :permalink => "theLastProgrammingLanguage", :abbr => "tLPL"}]
  end

end

