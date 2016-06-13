require 'rails_helper'

RSpec.describe CollectionController, type: :controller do
	let (:valid_params) {{ start_date: "2016-06-01", end_date: "2016-06-07", hashtag: 'apitest' }} 
	let (:valid_params_without_posts) {{ start_date: "2016-06-01", end_date: "2016-06-07", hashtag: 'bicycle' }} 
	let (:invalid_params) {{ start_date: "2016-06-09", end_date: "2016-03-01", hashtag: 'apitest' }}
	
	describe '#index' do
		before(:each) do
			tag = Tag.create(hashtag: 'apitest')
			post = Post.create(username: 'A-a-ron')
			PostTag.create(tag_id: tag.id, post_id: post.id, tag_time: 1465202800, pointer: 'pointer' )
		end
		it 'returns 200 on legitimate params' do 
			get :index, request: valid_params
			expect(response.status).to eq(200)
		end
		it 'redirects to index with a 302 when no posts are found' do 
			get :index, request: valid_params_without_posts
			expect(response.status).to eq(302)
		end
		it 'redirects to index with a 302 on invalid params' do
			get :index, request: invalid_params
			expect(response.status).to eq(302)
		end
		it 'populates flash with an error message on invalid terms' do
			get :index, request: invalid_params
			expect(flash[:errors]).to eq("Your search terms were not valid, please try again.")
		end
		it 'populates flash with an error message when no posts exist for search term' do
			get :index, request: valid_params_without_posts
			expect(flash[:errors]).to eq("No entries for bicycle found - please scrape first.")
		end
	end


	describe '#post' do
		before(:each) do
			tag = Tag.create(hashtag: 'apitest')
			post = Post.create(username: 'A-a-ron')
			PostTag.create(tag_id: tag.id, post_id: post.id, tag_time: 1465202800, pointer: 'pointer' )
		end
		it 'returns 200 on successful creation' do
			post :create, request: valid_params
			expect(response.status).to eq(302)
		end
		it 'redirects to index with a 302 on on invalid params' do
			post :create, request: invalid_params
			expect(response.status).to eq(302)
		end
		it 'populates flash errors with an error message when params are invalid' do 
			post :create, request: invalid_params
			expect(flash[:errors]).to eq("Your search terms were not valid, please try again.")
		end
	end
end