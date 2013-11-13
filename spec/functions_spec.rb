require 'minitest/autorun'
require 'ruby2js/filter/functions'

describe Ruby2JS::Filter::Functions do
  
  def to_js( string)
    Ruby2JS.convert(string, filters: [Ruby2JS::Filter::Functions])
  end
  
  describe :gvars do
    it "should handle jquery calls" do
      to_js( '$$.("span")' ).must_equal '$("span")'
    end
  end
  
  describe 'conversions' do
    it "should handle to_s" do
      to_js( 'a.to_s' ).must_equal 'a.toString()'
    end

    it "should handle to_s(16)" do
      to_js( 'a.to_s(16)' ).must_equal 'a.toString(16)'
    end

    it "should handle to_i" do
      to_js( 'a.to_i' ).must_equal 'parseInt(a)'
    end

    it "should handle to_i(16)" do
      to_js( 'a.to_i' ).must_equal 'parseInt(a)'
    end

    it "should handle to_f" do
      to_js( 'a.to_f' ).must_equal 'parseFloat(a)'
    end
  end
    
  describe 'array' do
    it "should map each to forEach" do
      to_js( 'a = 0; [1,2,3].each {|i| a += i}').
        must_equal 'var a = 0; [1, 2, 3].forEach(function(i) {a += i})'
    end

    it "should map each_with_index to forEach" do
      to_js( 'a = 0; [1,2,3].each_with_index {|n, i| a += n}').
        must_equal 'var a = 0; [1, 2, 3].forEach(function(n, i) {a += n})'
    end

    it "should leave $.each alone" do
      to_js( 'a = 0; $$.each([1,2,3]) {|n, i| a += n}').
        must_equal 'var a = 0; $.each([1, 2, 3], function(n, i) {a += n})'
    end

    it "should leave jquery.each alone" do
      to_js( 'a = 0; jQuery.each([1,2,3]) {|n, i| a += n}').
        must_equal 'var a = 0; jQuery.each([1, 2, 3], function(n, i) {a += n})'
    end
  end

  describe Ruby2JS::Filter::DEFAULTS do
    it "should include Functions" do
      Ruby2JS::Filter::DEFAULTS.must_include Ruby2JS::Filter::Functions
    end
  end
end