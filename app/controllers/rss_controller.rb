require "rss"

class RSSController < ApplicationController
  def index
    rss = RSS::Maker.make("atom") do |maker|
      maker.channel.author = "Seattle Ruby Brigade"
      maker.channel.updated = Time.now.to_s
      maker.channel.about = "https://seattlerb.org/feed.xml"
      maker.channel.title = "Seattle.rb Events"

      Event.all.order(date: :asc).each do |event|
        maker.items.new_item do |item|
          item.id = ["event", event.id].join("-")
          item.link = "https://seattlerb.org"
          item.title = "Event #{event.date.strftime("%B %Y")}"
          item.published = event.created_at.xmlschema
          item.updated = event.updated_at.xmlschema
          item.content.type = "text"
          item.content.content = "Seattle.rb Event on #{event.date.strftime("%A, %B %d, %Y")}"
          item.summary = "Seattle.rb Event on #{event.date.strftime("%A, %B %d, %Y")}"
        end
      end
    end

    render xml: rss.to_s, content_type: "application/atom+xml"
  end
end
