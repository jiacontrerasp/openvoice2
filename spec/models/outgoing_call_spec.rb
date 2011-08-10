require 'spec_helper'

describe Jobs::OutgoingCall do

  before do
    setup_connfu(handler_class = nil)
  end

  it "should dial caller & recipent and join the two call legs together" do
    Jobs::OutgoingCall.perform("caller", "recipient")

    incoming :outgoing_call_result_iq, "call-id", Connfu.connection.commands.last.id
    incoming :outgoing_call_ringing_presence, "call-id"
    incoming :outgoing_call_answered_presence, "call-id"

    Connfu.connection.commands.map(&:class).should == [
      Connfu::Commands::Dial,
      Connfu::Commands::NestedJoin
    ]
  end
end