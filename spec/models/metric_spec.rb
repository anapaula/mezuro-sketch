require 'spec_helper'

describe Metric do
  fixtures :projects

  def valid_metric_attributes(attributes={})
    {
      :name => "acc",
      :value => "10",
      :metricable => projects(:my_project)
    }.merge attributes
  end

  it "should create a new instance" do
    Metric.create!(valid_metric_attributes)
  end

  it "should save information in database" do
    metric = Metric.new(valid_metric_attributes)
    metric.save.should == true
  end

  it "should belongs to a metricable" do
    metric = Metric.create!(valid_metric_attributes)
    metric.metricable.should == projects(:my_project)
  end

  context "creating instances with invalid attributes" do
    it "should not save a metric without name" do
      metric = Metric.new(valid_metric_attributes(:name => nil))
      metric.save.should == false
    end

    it "should not save a metric without metricable" do
      metric = Metric.new(valid_metric_attributes(:metricable => nil))
      metric.save.should == false
    end
  end
  
  context "handling '~' metric value case" do
    it "should store nil as value" do
      metric = Metric.new(valid_metric_attributes(:value => '~'))
      metric.save.should == true
      found_metric = Metric.find(metric.id)
      found_metric.value.should == nil
    end
  end

  context "rounding decimal numbers" do
    it "should round the value before save" do
      metric = Metric.new(valid_metric_attributes(:value => "123.4567"))
      metric.save
      found_metric = Metric.find metric.id
      found_metric.value.should == 123.46
    end
  end
end
