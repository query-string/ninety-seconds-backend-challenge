require "rails_helper"

describe "Search API endpoints", type: :request do
  let(:request_url) { v1_search_index_path }

  describe "GET index" do
    let(:json_body) { JSON.parse(response.body) }

    context "no query params defined" do
      before { get request_url, params: { format: :json } }

      it "responds with error header" do
        expect(response).not_to be_success
      end
      it "responds with `Expectation Failed` status" do
        expect(response.code).to eq("417")
      end
      it "responds with JSON error message" do
        expect(json_body["error"].present?).to eq(true)
        expect(json_body["error"]["status"]).to eq(412)
        expect(json_body["error"]["message"]).to eq("Search query string `?q=` expected")
      end
    end

    context "query param defined" do
      context "artists to be found" do
        before { get request_url, params: { q: "2pac", format: :json } }

        it "responds with success header" do
          expect(response).to be_success
        end
        it "responds with OK status" do
          expect(response.code).to eq("200")
        end
        it "responds a list of artists" do
          expect(json_body["artists"].any?).to be(true)
        end
        it "result formated with the spotify id, external_urls, genres, href and name" do
          expect(json_body["artists"].map(&:keys).flatten.uniq).to match_array(%w(id external_urls genres href name))
        end
      end

      context "artists not to be found" do
        before { get request_url, params: { q: "lolwut", format: :json } }

        it "responds with success header" do
          expect(response).to be_success
        end
        it "responds with `Partial Content`	status" do
          expect(response.code).to eq("206")
        end
        it "responds with an empty list of artists" do
          expect(json_body["artists"].any?).to be(false)
        end
      end
    end

  end
end
