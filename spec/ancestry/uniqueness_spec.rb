require "spec_helper"

describe Ancestry::Uniqueness::Validator do
  
  # set default value if undefined
  let(:scope_attr) { defined?(super) ? super() : nil }

  shared_examples_for "a valid validatable" do
    it "is valid" do
      subject.provider = provider
      subject.scope_attr = scope_attr
      expect(subject).to be_valid
    end
  end

  shared_examples_for "an invalid validatable" do
    it "is invalid" do
      subject.provider = provider
      subject.scope_attr = scope_attr
      expect(subject).not_to be_valid
    end
  end

  # If this ever needs to be DRYed up: https://www.envygeeks.com/blog/mocking-activerecord-to-test-concerns
  before :all do
    migration = ActiveRecord::Migration.new
    migration.verbose = false
    
    migration.create_table :validatables do |t|
      t.string :ancestry
      t.string :provider
      t.string :scope_attr
    end
  end

  after :all do
    migration = ActiveRecord::Migration.new
    migration.verbose = false

    migration.drop_table :validatables
  end

  context "without scope" do
    class Validatable < ActiveRecord::Base
      has_ancestry
      validates_with Ancestry::Uniqueness::Validator, attributes: :provider
    end

    let(:a_record) { Validatable.create!(provider: 'provider', parent: nil) }

    context "when record has no siblings" do
      subject { Validatable.new(parent: a_record) }
      let(:provider) { a_record.provider }
      it_behaves_like "a valid validatable"
    end

    context "when record has a sibling" do
      subject { Validatable.new(parent: a_record.parent) }

      context "with unique provider among siblings" do
        let(:provider) { 'different provider' }
        it_behaves_like "a valid validatable"
      end

      context "with existing provider among siblings" do
        let(:provider) { a_record.provider }
        it_behaves_like "an invalid validatable"
      end
    end
  end

  context "with scope" do
    class Validatable < ActiveRecord::Base
      has_ancestry
      validates_with Ancestry::Uniqueness::Validator, attributes: :provider, scope: :scope_attr
    end

    let(:a_record) { Validatable.create!(provider: 'provider', parent: nil, scope_attr: 'some scope') }

    context "when record has no siblings" do
      subject { Validatable.new(parent: a_record, scope_attr: a_record.scope_attr) }
      let(:provider)    { a_record.provider }
      let(:scope_attr)  { a_record.scope_attr }
      it_behaves_like "a valid validatable"
    end

    context "when record has a sibling" do
      subject { Validatable.new(parent: a_record.parent) }

      context "with unique provider among siblings and scope" do
        let(:provider)    { 'different provider' }
        let(:scope_attr)  { 'different scope' }
        it_behaves_like "a valid validatable"
      end

      context "with existing provider among siblings and unique provider among scope" do
        let(:provider)    { a_record.provider }
        let(:scope_attr)  { 'different scope' }
        it_behaves_like "an invalid validatable"
      end

      context "with unique provider among siblings and existing provider among scope" do
        let(:provider)    { 'different provider' }
        let(:scope_attr)  { a_record.scope_attr }
        it_behaves_like "a valid validatable"
      end

      context "with existing provider among siblings and scope" do
        let(:provider)    { a_record.provider }
        let(:scope_attr)  { a_record.scope_attr }
        it_behaves_like "an invalid validatable"
      end
    end
  end

end
