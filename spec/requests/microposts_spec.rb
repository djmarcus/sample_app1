require 'spec_helper'

describe "Microposts" do

  before(:each) do
    user = Factory(:user)
    visit signin_path
    fill_in :email,    :with => user.email
    fill_in :password, :with => user.password
    click_button
  end
  
  describe "creation" do
    
    describe "failure" do
    
      it "should not make a new micropost" do
        lambda do
          visit root_path
          fill_in :micropost_content, :with => ""
          click_button
          response.should render_template('pages/home')
          response.should have_selector("div#error_explanation")
        end.should_not change(Micropost, :count)
      end
    end

    describe "success" do
  
      it "should make a new micropost" do
        content = "Lorem ipsum dolor sit amet"
        lambda do
          visit root_path
          fill_in :micropost_content, :with => content
          click_button
          response.should have_selector("span.content", :content => content)
        end.should change(Micropost, :count).by(1)
      end
    end
  end

  describe "sidebar" do
  
    describe "should display the correct micropost count for the user" do
      
      it "should display 'Microposts' with zero posts" do
        visit root_path
        response.should have_selector("span", :content => "0 microposts")
      end

      it "should display 'Micropost' with one post" do
        content = "Lorem ipsum dolor sit amet"
        lambda do
          visit root_path
          fill_in :micropost_content, :with => content
          click_button
          response.should have_selector("span", :content => "1 micropost")
        end
      end

      it "should display 'Microposts' with more than one post" do
        content = "Lorem ipsom something something"
        content2 = "I hope this test works"

        lambda do 
          visit root_path
          fill_in :micropost_content, :with =>content
          click_button
          fill_in :micropost_content, :with =>content2
          click_button
          response.should have_selector("span", :content => "2 micropsots")
        end
      end
    end
  end
end

