require "spec_helper"

describe "ExploreUK Toolbar Extras", :type => :feature do
  let (:blacklight_config) do
    Blacklight::Configuration.new do |config|
      config.add_show_field 'pdf_url_display', :label => 'PDF'
      config.add_show_field 'miscellaneous_t', :label => 'TMBG'
    end
  end

  before do
    load_sample_documents
    CatalogController.blacklight_config = blacklight_config
  end

  let (:book_id) { "sample_book_cats_1" }
  let (:book_page) { "/catalog/#{book_id}" }

  context "Show action" do
    let (:book_no_content_page) { "/catalog/sample_book_ocelots_1" }
    let (:docs) { [book_page, book_no_content_page] }

    before do
      visit book_page
    end

    context "All documents" do
      before do
        visit book_no_content_page
      end

      it "includes labels for all required links" do
        docs.each do |doc|
          visit doc
          # move to details action
          #expect(page).to have_content I18n.t('exploreuk.tools.item')
          expect(page).to have_content I18n.t('exploreuk.tools.full_record')
          expect(page).to have_content I18n.t('exploreuk.tools.statistics')
          expect(page).to have_content I18n.t('exploreuk.tools.share')
          expect(page).to have_content I18n.t('exploreuk.tools.download_item')
        end
      end

      it "includes a link to the full record" do
        expect(page).to have_link(I18n.t('exploreuk.tools.full_record'), href: "#{book_no_content_page}/details")
      end
    end

    context "Documents with PDFs" do
      before do
        visit book_page
      end

      it "includes a PDF link" do
        expect(page).to have_link(I18n.t('exploreuk.tools.pdf'), href: "http://example.com")
      end
    end

    context "Documents with downloadable content" do
      before do
        visit book_page
      end

      it "includes a download link" do
        expect(page).to have_link(I18n.t('exploreuk.tools.download'), href: "#{book_page}/download")
      end
    end
  end

  context "Details action" do
    let (:book_details) { "/catalog/#{book_id}/details" }

    before do
      visit book_details
    end

    it "shows expected fields for the details action" do
      expect(page).to have_content "PDF"
      expect(page).to have_content "http://example.com"
      expect(page).to have_content "TMBG"
      expect(page).to have_content "Nightgown of the sullen moon"
    end
  end
end

def load_sample_documents
  docs = YAML::load(File.open(File.join(File.expand_path("../../fixtures", __FILE__), "sample_solr_documents.yml")))
  Blacklight.solr.add docs
  Blacklight.solr.commit
end
