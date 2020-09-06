# frozen_string_literal: true

require "dependabot/dependency_file"
require "dependabot/source"
require "dependabot/paket/file_parser"
require_common_spec "file_parsers/shared_examples_for_file_parsers"

RSpec.describe Dependabot::Paket::FileParser do
  it_behaves_like "a dependency file parser"

  let(:files) { [paket_dependencies_file, paket_lock_file] }

  let(:paket_dependencies_file) do
    Dependabot::DependencyFile.new(name: "paket.dependencies", content: paket_dependencies_body)
  end
  let(:paket_dependencies_body) { fixture("paket_dependencies", "basic.paket.dependencies") }
  let(:paket_lock_file) do
    Dependabot::DependencyFile.new(name: "paket.lock", content: paket_lock_body)
  end
  let(:paket_lock_body) { fixture("paket_lock", "basic.paket.lock") }
  let(:parser) { described_class.new(dependency_files: files, source: source) }
  let(:source) do
    Dependabot::Source.new(
      provider: "github",
      repo: "gocardless/bump",
      directory: "/"
    )
  end

  describe "parse" do
    subject(:dependencies) { parser.parse }

    its(:length) { is_expected.to eq(13) }

    describe "the first dependency" do
      subject(:dependency) { dependencies.first }

      it "has the right details" do
        expect(dependency).to be_a(Dependabot::Dependency)
        expect(dependency.name).to eq("Chessie")
        expect(dependency.package_manager).to eq("paket")
        expect(dependency.version).to eq("0.6.0")
        expect(dependency.requirements).to eq(
          [{
            requirement: nil,
            file: "paket.lock",
            groups: ["Main"],
            source: nil
          }]
        )
      end
    end


  end

end
