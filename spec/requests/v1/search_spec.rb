require "rails_helper"
REQUEST_URL = "/v1/search"

describe "Search API endpoints", type: :request do

  describe "GET index" do

    context "no query params defined" do
      let(:json_body) { JSON.parse(response.body) }
      before { get REQUEST_URL, params: { format: :json } }

      it "responds with Expectation Failed header" do
        expect(response).not_to be_success
        expect(response.code).to eq("417")
      end
      it "responds with JSON error message" do
        expect(json_body.kind_of?(Hash)).to be(true)
        expect(json_body["message"]).to eq("Search query string `?q=` expected")
      end
    end

    context "query param defined" do
      it "responds with OK header" do
        get REQUEST_URL, params: { q: "2pac", format: :json }
        expect(response).to be_success
      end
    end

  end
end
