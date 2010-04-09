require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/projects/index" do
  fixtures :projects, :users

  context "not logged in" do
    before :each do
      assigns[:projects] = [projects(:my_project), projects(:analizo)]
      logout
      render
    end

    it "should have a title" do
      response.should have_tag("h1", "Welcome to Mezuro")
    end

    it "should have a list of projects" do
      response.should have_tag("ul") do
        with_tag("li") do
          with_tag("a", projects(:my_project).name, project_path(projects(:my_project).identifier))
        end
        with_tag("li") do
          with_tag("a", projects(:analizo).name, project_path(projects(:analizo).identifier))
        end
      end
    end

    it "should have a link to create a new project" do
      response.should have_tag("a[href=?]", new_project_path)
    end

    it "should have a link to create an user" do
      response.should have_tag("a[href=?]", new_user_path)
    end

    it "should have a link to log in" do
      response.should have_tag("a[href=?]", login_path)
    end
  end
  

  context "user logged in" do
    before :each do
      assigns[:projects] = [projects(:my_project), projects(:analizo)]
      login_as 'viviane'
      render
    end

    it "should not have a link to login" do
      response.should_not have_tag("a[href=?]", login_path)
    end

    it "should not have a link to create an user" do
      response.should_not have_tag("a[href=?]", new_user_path)
    end

    it "should have a link to logout" do
      response.should have_tag("a[href=?]", logout_path)
    end
  end

end
