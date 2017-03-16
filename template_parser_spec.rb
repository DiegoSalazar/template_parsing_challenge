require 'rspec'
require './patient_bank_template_parser.rb'

describe TemplateParser do
  subject { described_class.new environment }

  context 'Plain values' do
    let(:template) { "Hi {FIRST_NAME}" }
    let(:environment) { { first_name: "Diego" } }
    let(:output) { "Hi Diego" }

    it 'replaces {FIRST_NAME} in with the actual value' do
      expect(subject.parse(template)).to eq output
    end
  end

  context 'Plain values when nil' do
    let(:template) { "Hi {FIRST_NAME}" }
    let(:environment) { { } }
    let(:output) { "Hi " }

    it 'does not add a nil value' do
      expect(subject.parse(template)).to eq output
    end
  end

  context 'If true' do
    let(:template) { "{#PATIENT_PAID}Patient paid.{#PATIENT_PAID}" }
    let(:environment) { { patient_paid: true } }
    let(:output) { "Patient paid." }

    it 'handles if conditions and adds the contained text to the output' do
      expect(subject.parse(template)).to eq output
    end
  end

  context 'If false' do
    let(:template) { "{#PATIENT_PAID}Patient paid.{#PATIENT_PAID}" }
    let(:environment) { { patient_paid: false } }
    let(:output) { "" }

    it 'does not output contained text within false conditions' do
      expect(subject.parse(template)).to eq output
    end
  end

  context 'Unless false' do
    let(:template) { "{^PATIENT_PAID}Patient did not pay.{^PATIENT_PAID}" }
    let(:environment) { { patient_paid: false } }
    let(:output) { "Patient did not pay." }

    it '' do
      expect(subject.parse(template)).to eq output
    end
  end

  context 'Unless true' do
    let(:template) { "{^PATIENT_PAID}Patient did not pay.{^PATIENT_PAID}" }
    let(:environment) { { patient_paid: true } }
    let(:output) { "" }

    it 'does not output contained text within true conditions' do
      expect(subject.parse(template)).to eq output
    end
  end

  context 'If true, nested unless true, returns stripped content' do
    let(:template) { "{#PATIENT_PAID}Patient paid.{^PATIENT_YOUNG} Patient is not young.{^PATIENT_YOUNG}{#PATIENT_PAID}" }
    let(:environment) { { patient_paid: true, patient_young: true } }
    let(:output) { "Patient paid." }

    it 'outputs contained text within nested true conditions' do
      expect(subject.parse(template)).to eq output
    end
  end

  context 'If true, nested unless false' do
    let(:template) { "{#PATIENT_PAID}Patient paid. {^PATIENT_YOUNG} Patient is not young.{^PATIENT_YOUNG}{#PATIENT_PAID}" }
    let(:environment) { { patient_paid: true, patient_young: false } }
    let(:output) { "Patient paid. Patient is not young." }

    it 'outputs contained text within nested true and false conditions' do
      expect(subject.parse(template)).to eq output
    end
  end

  context 'If false, nested unless false' do
    let(:template) { "{#PATIENT_PAID}Patient paid. {^PATIENT_YOUNG} Patient is not young.{^PATIENT_YOUNG}{#PATIENT_PAID}" }
    let(:environment) { { patient_paid: false, patient_young: false } }
    let(:output) { "" }

    it 'does not output contained text within nested false conditions' do
      expect(subject.parse(template)).to eq output
    end
  end
end
