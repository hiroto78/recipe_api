module RequestHelper
  def self.included(base)
    base.extend(ClassMethods)
  end

  def check_validation_failed(errors = {})
    expect(response).to have_http_status(400)
    body = JSON.parse(response.body)

    expect(body['detail']).to contain_exactly(*JSON.parse(errors.to_json))
  end

  module ClassMethods
    def prepare_get_headers
      before do
        @headers ||= {}
        @headers['ACCEPT'] = 'application/json'
      end
    end

    def prepare_post_headers
      before do
        @headers ||= {}
        @headers['ACCEPT'] = 'application/json'
        @headers['Content-Type'] = 'application/json'
      end
    end

    def prepare_patch_headers
      before do
        @headers ||= {}
        @headers['ACCEPT'] = 'application/json'
        @headers['Content-Type'] = 'application/json'
      end
    end

    def prepare_put_headers
      before do
        @headers ||= {}
        @headers['ACCEPT'] = 'application/json'
        @headers['Content-Type'] = 'application/json'
      end
    end

    def prepare_delete_headers
      before do
        @headers ||= {}
        @headers['ACCEPT'] = 'application/json'
        @headers['Content-Type'] = 'application/json'
      end
    end
  end
end
