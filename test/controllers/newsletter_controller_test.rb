require "minitest_helper"

class NewsletterControllerTest < ActionController::TestCase
  def test_subscribe_to_discussion
    mock = MiniTest::Mock.new
    mock.expect :call, nil, [{'email' => 'a@email.com'}]

    ZenspiderSubscriber.stub :subscribe_to_discussion, mock do
      post :subscribe, params: { :subscribe => {:person => {:email => 'a@email.com'}, :subscribe_to_discussion => "1"} }
    end

    mock.verify

    assert_redirected_to join_us_path
  end

  def test_subscribe_to_jobs
    mock = MiniTest::Mock.new
    mock.expect :call, nil, [{'email' => 'a@email.com'}]

    ZenspiderSubscriber.stub :subscribe_to_jobs, mock do
      post :subscribe, params: { :subscribe => {:person => {:email => 'a@email.com'}, :subscribe_to_jobs => "1"} }
    end

    mock.verify

    assert_redirected_to join_us_path
  end
end
