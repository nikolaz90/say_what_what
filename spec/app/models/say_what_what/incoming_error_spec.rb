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

  describe ".nuissance_error?" do
    before do
      SayWhatWhat.exempt_path_matchers = []
      SayWhatWhat.exempt_error_class_matchers = []
    end

    it "returns false if request_path is not in SayWhatWhat.exempt_path_matchers" do
      SayWhatWhat.exempt_path_matchers << "/support/sos"
      expect(incoming_error_instance.nuissance_error?).to eq false
    end

    it "returns true if request_path is in SayWhatWhat.exempt_path_matchers" do
      SayWhatWhat.exempt_path_matchers << "/home"
      error = described_class.new(
        error: double(class: NotImplementedError, backtrace: backtrace, message: "Dang!"),
        severity: "error",
        handled: false,
        error_context: {
          request_path: "/home"
        }
      )
      expect(error.nuissance_error?).to eq true
    end

    it "returns false if error_class is not in SayWhatWhat.exempt_error_class_matchers" do
      SayWhatWhat.exempt_error_class_matchers << "NotImplementedError"
      expect(incoming_error_instance.nuissance_error?).to eq false
    end

    it "returns true if error_class is in SayWhatWhat.exempt_error_class_matchers" do
      SayWhatWhat.exempt_error_class_matchers << "NotImplementedError"
      error = described_class.new(
        error: double(class: NotImplementedError, backtrace: backtrace, message: "Dang!"),
        severity: "error",
        handled: false
      )

      expect(error.nuissance_error?).to eq true
    end
  end

  describe ".max_occurrences_reached?" do
    it "returns false if SayWhatWhat.max_occurrences_per_error == nil" do
      SayWhatWhat.max_occurrences_per_error = nil
      expect(incoming_error_instance.max_occurrences_reached?).to eq false
    end

    it "returns false if error.occurrence_count == nil" do
      error = double("SayWhatWhat::Error", occurrence_count: nil)
      incoming_error_instance.instance_variable_set(:@error, error)

      expect(incoming_error_instance.max_occurrences_reached?).to eq false
    end

    it "returns true if error.occurrence_count is greater that SayWhatWhat.max_occurrences_per_error" do
      SayWhatWhat.max_occurrences_per_error = 15
      binding.pry
      error = double("SayWhatWhat::Error", occurrence_count: 16)
      incoming_error_instance.instance_variable_set(:@error, error)

      expect(incoming_error_instance.max_occurrences_reached?).to eq true
    end
  end
end
