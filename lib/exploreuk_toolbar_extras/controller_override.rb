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

    # definitely ExploreUK-specific
    def thumbs
      (response, @document) = get_solr_response_for_doc_id
      rows = 10
      start = params[:page].to_i || 0
      object_id_s = @document[:object_id_s]
      @response = find({
        :start => rows * start,
        :fq => "object_id_s:#{object_id_s}",
        :sort => "global_sort_key_i asc",
      })

      respond_to do |format|
        format.html {setup_next_and_previous_documents}
        format.json do
          render json: @response
        end
      end
    end
  end
end
