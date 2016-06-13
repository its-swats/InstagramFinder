module ErrorHandling
	def self.verify_form_params(params)
		byebug
		start_date = Date.parse(params[:start_date]).to_time.to_i
		end_date = Date.parse(params[:end_date]).to_time.to_i
		hashtag = params[:hashtag]
		current_date = Time.now.to_i		
		return end_date <= current_date && start_date <= end_date && !!hashtag
	end

end
