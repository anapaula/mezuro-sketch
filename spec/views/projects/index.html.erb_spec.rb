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
          with_tag("a", projects(:my_project).identifier, project_path(projects(:my_project).identifier))
        end
        with_tag("li") do
          with_tag("a", projects(:analizo).identifier, project_path(projects(:analizo).identifier))
        end
      end
    end
  end

end
