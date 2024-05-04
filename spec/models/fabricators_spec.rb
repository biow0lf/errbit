Fabrication::Config.fabricator_path.each do |folder|
  Rails.root.glob("#{folder}/**/*.rb").each do |file|
    require file
  end
end

describe "Fabrication" do
  # TODO : when 1.8.7 drop support se directly Symbol#sort
  Fabrication.manager.schematics.keys.sort.each do |fabricator_name|
    context "Fabricate(:#{fabricator_name})" do
      subject { Fabricate.build(fabricator_name) }

      it { is_expected.to be_valid }
    end
  end
end
