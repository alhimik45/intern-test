class BuyError < StandardError
end

class BadTimeoutError < TimeoutError
end

class BuyService

  def buy
    photos = get_photos
    photo = JSON.parse(photos).sample
    thumbnail = photo['thumbnailUrl']
    url = photo['url']

    thumbnail_color = thumbnail.split('/')[-1].to_i 16
    url_color = url.split('/')[-1].to_i 16
    raise BuyError if thumbnail_color > url_color

    todos = get_todos
    todo_id = JSON.parse(todos)['id']
    return {url: url, todo_id: todo_id}    
  end


  private
  def get_photos
    Timeout::timeout(3) {
      sleep(rand 6)
      RestClient.get 'http://jsonplaceholder.typicode.com/photos/'
    }
  end

  def get_todos
    3.times {
      begin
        Timeout::timeout(3) {
          sleep(rand 6)
          return RestClient.post 'http://jsonplaceholder.typicode.com/todos', {}
        }
      rescue
        raise BadTimeoutError
      end
    }
    raise BadTimeoutError
  end
end