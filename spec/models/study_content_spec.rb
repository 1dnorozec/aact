require 'rails_helper'


describe Study do
  it "should have correct date attribs" do
    nct_id='NCT00023673'
    xml=Nokogiri::XML(File.read("spec/support/xml_data/#{nct_id}.xml"))
    study=Study.new({xml: xml, nct_id: nct_id}).create
    expect(study.start_month_year).to eq('July 2001')
    expect(study.completion_month_year).to eq('November 2013')
    expect(study.primary_completion_month_year).to eq('January 2009')
    expect(study.verification_month_year).to eq('November 2015')

    expect(study.first_received_date).to eq('September 13, 2001'.to_date)
    expect(study.first_received_results_date).to eq('February 12, 2014'.to_date)
    expect(study.last_changed_date).to eq('November 14, 2015'.to_date)

    expect(study.calculated_value.start_date).to eq(study.start_month_year.to_date)
    expect(study.calculated_value.verification_date).to eq(study.verification_month_year.to_date)
    expect(study.calculated_value.completion_date).to eq(study.completion_month_year.to_date)
    expect(study.calculated_value.primary_completion_date).to eq(study.primary_completion_month_year.to_date)
  end

  it "should have expected date values" do
    xml=Nokogiri::XML(File.read('spec/support/xml_data/example_study.xml'))
    study=Study.new({xml: xml, nct_id: 'NCT02260193'}).create
    expect(study.first_received_results_disposition_date).to eq('December 1, 1999'.to_date)
  end

  context 'when patient data section exists' do
    xml=Nokogiri::XML(File.read('spec/support/xml_data/NCT02830269.xml'))
    study=Study.new({xml: xml, nct_id: 'NCT02830269'}).create

    it 'should have expected sharing ipd value' do
      expect(study.plan_to_share_ipd).to eq('Undecided')
    end

    it 'should have expected ipd description value' do
      expect(study.plan_to_share_description).to eq('NC')
    end
  end

  context 'study has limitations and caveats' do
    nct_id='NCT00023673'
    xml=Nokogiri::XML(File.read("spec/support/xml_data/#{nct_id}.xml"))
    study=Study.new({xml: xml, nct_id: nct_id}).create

    it 'should have expected limitations and caveats value' do
      expect(study.limitations_and_caveats).to eq('This study was originally designed to escalate 3DRT via increasing doses per fraction. However, due to excessive toxicity at dose level 1 (75.25 Gy, 2.15 Gy/fraction), the protocol was amended in January 2003 to de-escalate 3DRT dose.')
    end

  end

  context 'when patient data section does not exist' do
    xml=Nokogiri::XML(File.read('spec/support/xml_data/example_study.xml'))
    study=Study.new({xml: xml, nct_id: 'NCT02260193'}).create

    it 'should return empty string for sharing ipd value' do
      expect(study.plan_to_share_ipd).to eq('')
    end

    it 'should return empty string for ipd description value' do
      expect(study.plan_to_share_description).to eq('')
    end
  end
end
