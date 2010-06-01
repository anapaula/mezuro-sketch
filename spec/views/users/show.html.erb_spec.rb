require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/users/show" do

  context "user has projects" do
    fixtures :projects, :users
    before :each do
      assigns[:user] = users(:viviane)
      assigns[:projects] = [projects(:my_project), projects(:analizo)]
      render
    end
  
    it "should have a title: User Info" do
      response.should have_tag("h1", "User Info")
    end

    it "should have a table with user info" do
      response.should have_tag("table") do
        with_tag("tr[id=?]", "tr_user_login") do
          with_tag("td", "Login")
          with_tag("td", "viviane")
        end
        with_tag("tr[id=?]", "tr_user_email") do
          with_tag("td", "Email")
          with_tag("td", "vivi@qualquercoisa.com")
        end   
        with_tag("tr[id=?]", "tr_user_creation_date") do
          with_tag("td", "Created at")
          with_tag("td", "28 May 2010")
        end
      end
    end

    it "should have a title for user projects list" do
      response.should have_tag("h3", "List of User Projects")
    end

    it "should have a list of user projects" do
      response.should have_tag("ul") do
        with_tag("li") do
          with_tag("a", projects(:my_project).name, project_path(projects(:my_project).identifier))
        end
        with_tag("li") do
          with_tag("a", projects(:analizo).name, project_path(projects(:analizo).identifier))
        end
      end
    end 
  end

  context "user doesn't have projects" do
    before :each do
      assigns[:user] = User.new(:login => "vinicius",
        :password => "magro",
        :password_confirmation => "magro",
        :email => "vinicius@qualquercoisa.com",
        :created_at => "28 May 2010")
      assigns[:projects] = []
      render
    end

    it "should not have a title for user projects list" do
      response.should_not have_tag("h3", "List of User Projects")
    end

    it "should have a link to new project" do 
      response.should have_tag("h3") do
        with_tag("a[href=?]", new_project_path)
      end
    end
  end
 end
