json.array!(@words) do |word|
  json.extract! word, :id, :word, :created_at
  json.url word_url(word, format: :json)
end
