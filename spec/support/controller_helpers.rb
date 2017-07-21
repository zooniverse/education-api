module ControllerHelpers
  def parsed_response
    @parsed_response ||= JSON.parse(response.body).with_indifferent_access
  end
end
