require "typhoeus"

module ExploreukToolbarExtras
  module ControllerOverride
    extend ActiveSupport::Concern
  
    def details
      @response, @document = get_solr_response_for_doc_id   

      respond_to do |format|
        format.html
        format.js { render :layout => false }
      end
    end

    # from exploreuk on BL 2.x
    # tweaked for Rails 4
    def download
      @response, @document = get_solr_response_for_doc_id

      if @document[:reference_image_url_s]
        remote_url = @document[:reference_image_url_s]
        image = Typhoeus::Request.get(remote_url).body
        send_data(image,
                  filename: File.basename(remote_url),
                  type: "image/jpeg")
      end
    end
  end
end
