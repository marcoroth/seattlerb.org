require "minitest_helper"

class RSSControllerTest < ActionController::TestCase
  def setup
    @event = Event.create!(
      id: 42,
      date: "2024-09-03",
      created_at: "2024-08-01 12:34:56 UTC",
      updated_at: "2024-09-01 23:45:56 UTC",
    )
  end

  def test_index
    get :index

    assert_response :success
    assert_equal "application/atom+xml", response.content_type.split(";").first

    feed = Nokogiri::XML(response.body)

    assert_equal "Seattle Ruby Brigade", feed.at_css("feed author name").text
    assert_equal "https://seattlerb.org/feed.xml", feed.at_css("feed id").text
    assert_equal "Seattle.rb Events", feed.at_css("feed title").text

    assert_equal 1, feed.css("entry").length

    assert_equal "event-42", feed.at_css("entry id").text
    assert_equal "https://seattlerb.org", feed.at_css("entry link")["href"]
    assert_equal "Event September 2024", feed.at_css("entry title").text
    assert_equal "Seattle.rb Event on Tuesday, September 03, 2024", feed.at_css("entry content").text
    assert_equal "Seattle.rb Event on Tuesday, September 03, 2024", feed.at_css("entry summary").text
    assert_equal "2024-08-01T12:34:56Z", feed.at_css("entry published").text
    assert_equal "2024-09-01T23:45:56Z", feed.at_css("entry updated").text
  end
end
