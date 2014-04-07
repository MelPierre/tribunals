module Concerns::Decision::Search
  extend ActiveSupport::Concern
  
  module ClassMethods
    def search(query)
      if query.present?
        quoted_query = self.connection.quote(query)
        where("to_tsvector('english', search_text::text) @@ plainto_tsquery('english', :q::text)", q:query)
        .order("search_text ~* #{quoted_query} DESC")
      else
        where("")
      end
    end
  end
end