# frozen_string_literal: true

RSpec.describe SayWhatWhat::IncomingError do
  let(:backtrace) do
    [
      "app/models/donuts.rb:10:in `save`",
      "app/queries/donut_query.rb:20:in `call`",
      "app/controllers/donuts_controller.rb:30:in `create`",
      "config/application.rb:40:in `run`"
    ]
  end

  let(:error1) do
    double(
      class: StandardError,
      backtrace: backtrace,
      message: "Doh!"
    )
  end

  let(:incoming_error_instance) do
    described_class.new(
      error: error1,
      severity: "error",
      handled: false,
      error_context: {}
    )
  end

  describe ".finger_print" do
    it "generates a hexdeigest" do
      incoming_error = incoming_error_instance
      expected_finger_print = Digest::SHA256.hexdigest(
        "StandardErrorDoh!#{backtrace[0..2]}"
      )

      expect(incoming_error.finger_print).to eq expected_finger_print
    end

    it "returns the same fingerprint when error is the same" do
      first_finger_print = incoming_error_instance.finger_print
      second_finger_print = incoming_error_instance.finger_print

      expect(first_finger_print).to eq(second_finger_print)
    end

    it "returns a different fingerprint when backtrace is not the same" do
      first_finger_print = incoming_error_instance.finger_print
      second_finger_print = described_class.new(
        error: double(class: StandardError, backtrace: backtrace.reverse, message: "Doh!"),
        severity: "error",
        handled: false
      ).finger_print

      expect(first_finger_print).not_to eq(second_finger_print)
    end

    it "returns a different fingerprint when error class is not the same" do
      first_finger_print = incoming_error_instance.finger_print
      second_finger_print = described_class.new(
        error: double(class: NameError, backtrace: backtrace, message: "Doh!"),
        severity: "error",
        handled: false
      ).finger_print

      expect(first_finger_print).not_to eq(second_finger_print)
    end

    it "returns a different fingerprint when message is not the same" do
      first_finger_print = incoming_error_instance.finger_print
      second_finger_print = described_class.new(
        error: double(class: StandardError, backtrace: backtrace, message: "Dang!"),
        severity: "error",
        handled: false
      ).finger_print

      expect(first_finger_print).not_to eq(second_finger_print)
    end
  end
end
