require "logstash/devutils/rspec/spec_helper"
require 'logstash/filters/zeromq'
require 'json'
require 'securerandom'

describe LogStash::Filters::ZeroMQ do
  let(:sentinel) { SecureRandom.hex[1..2] }
  let(:filter) { LogStash::Plugin.lookup("filter", "zeromq").new({"sentinel" => sentinel}) }
  let(:event) do
    LogStash::Event.new({
      "message" => "some message",
      "seq" => rand(1000),
      "field1" => "some field value",
      "@version" => "1",
      "@timestamp" => Time.now.utc.iso8601(3)
    })
  end

  let(:event_text) { event.to_json }

  before do
    allow(filter).to receive(:connect)
  end

  it "should send entire event as json if field not specified" do
    expect(filter).to receive(:send_recv).with(event_text)
    filter.filter(event)
  end

  it "should cancel event if peer returns an answer==sentinel" do
    expect(filter).to receive(:send_recv).and_return([true, sentinel])
    expect(event).to receive(:cancel)
    filter.filter(event)
  end

  it "should not cancel event if send_recv failed" do
    expect(filter).to receive(:send_recv).and_return([false, event_text])
    expect(event).to_not receive(:cancel)
    filter.filter(event)
  end

  context "Filter specific field" do
    let(:filter) { LogStash::Plugin.lookup("filter", "zeromq").new({"field" => "field1"}) }

    it "should send only a single field" do
      expect(filter).to receive(:send_recv).with(event["field1"])
      filter.filter(event)
    end

    it "should not cancel event if send_recv failed and event field==sentinel" do
      expect(filter).to receive(:send_recv).and_return([false, sentinel])
      expect(event).to_not receive(:cancel)
      filter.filter(event)
    end
  end
end
