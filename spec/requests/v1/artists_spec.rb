require "rails_helper"

describe "Artists API endpoints", type: :request do
  let(:request_url) { "/v1/artists" }

  describe "GET artist" do
    let(:json_body) { JSON.parse(response.body) }

    context "artist to be created" do
      before { get "#{request_url}/3iCJOi5YKh247eutgCyLFe", params: { format: :json } }

      it "responds with success header" do
        expect(response).to be_success
      end
      it "responds with OK status" do
        expect(response.code).to eq("200")
      end
      it "result formated with the spotify id, external_urls, genres, href and name" do
        expect(json_body.keys).to match_array(%w(id external_urls genres href name))
      end
      it "has expected name" do
        expect(json_body["name"]).to eq("I See Stars")
      end
      it "has expected genres" do
        expect(json_body["genres"]).to match_array(["emo","metalcore","nintendocore","pixie","pop punk","post-screamo","screamo"])
      end
      it "create artist record" do
        expect(Artist.count).to eq(1)
        expect(Artist.first.spotify_id).to eq("3iCJOi5YKh247eutgCyLFe")
      end
    end

    context "artist to be found" do
      before { Rails.application.load_seed }

      it "fetches artist from DB" do
        expect {
          get "#{request_url}/4P0dddbxPil35MNN9G2MEX", params: { format: :json }
        }.not_to change{
          Artist.count
        }
      end
    end

    context "artist not to be found" do
      before { get "#{request_url}/a1b2e34r5t", params: { format: :json } }

      it "responds with error header" do
        expect(response).not_to be_success
      end
      it "responds with `Not Found`	status" do
        expect(response.code).to eq("404")
      end
      it "responds with JSON error message" do
        expect(json_body["error"].present?).to eq(true)
        expect(json_body["error"]["status"]).to eq(404)
        expect(json_body["error"]["message"]).to eq("Sorry, an artist with defined ID doesn't exist")
      end
    end
  end
end
