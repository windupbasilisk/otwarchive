@tags @tag_wrangling @comments
Feature: Comment on tag
As a tag wrangler
I'd like to comment on a tag'

  Scenario: Comment on a tag and get taken to right page and see right date
    Given the following activated tag wranglers exist
        | login     |
        | dizmo     |
      And a fandom exists with name: "Stargate Atlantis", canonical: true
    When I am logged in as "dizmo"
    When I view the tag "Stargate Atlantis"
    Then I should see "0 comments"
    When I post the comment "Shouldn't this be a metatag with Stargate?" on the tag "Stargate Atlantis" via web
    Then I should see "Shouldn't this be a metatag with Stargate?"
      And I should see Posted nowish
      
    Scenario: Edit a comment on a tag
    
    Given the following activated tag wranglers exist
        | login     |
        | dizmo     |
      And a fandom exists with name: "Stargate Atlantis", canonical: true
    When I am logged in as "dizmo"
    When I post the comment "Shouldn't this be a metatag with Stargate?" on the tag "Stargate Atlantis"
    When I follow "Edit"
    Then the "Comment" field should contain "Shouldn't this be a metatag with Stargate?"
      And I should see "Cancel"
    When I fill in "Comment" with "Yep, we should have a Stargate franchise metatag."
      And I press "Update"
    Then I should see "Comment was successfully updated."
      And I should see "Yep, we should have a Stargate franchise metatag."
      And I should not see "Shouldn't this be a metatag with Stargate?"
      And I should see Last Edited nowish
    When I view the tag "Stargate Atlantis"
    Then I should see "1 comment"
    
    Scenario: Multiple comments on a tag increment correctly
    
    Given the following activated tag wranglers exist
        | login     |
        | dizmo     |
      And a fandom exists with name: "Stargate Atlantis", canonical: true
    When I am logged in as "dizmo"
    When I post the comment "Yep, we should have a Stargate franchise metatag." on the tag "Stargate Atlantis"
    When I am logged in as an admin
    When I post the comment "Important policy decision" on the tag "Stargate Atlantis"
    When I view the tag "Stargate Atlantis"
    Then I should see "2 comments"
      
  Scenario: Multiple comments on a tag show on discussion page
    
    Given the following activated tag wranglers exist
        | login     |
        | dizmo     |
        | Enigel    |
      And a fandom exists with name: "Stargate Atlantis", canonical: true
    When I am logged in as "Enigel"
    When I post the comment "Yep, we should have a Stargate franchise metatag." on the tag "Stargate Atlantis"
    When I am logged in as an admin
    When I post the comment "Important policy decision" on the tag "Stargate Atlantis"
    When I am logged in as "dizmo"
    When I view tag wrangling discussions
    Then I should see "Tag Wrangling Discussion"
      And I should see "Yep, we should have a Stargate franchise metatag."
      And I should see "Important policy decision"
      
  Scenario: Unedited tag doesn't show on discussion page
  
  Given the following activated tag wranglers exist
        | login     |
        | dizmo     |
        | Enigel    |
      And a fandom exists with name: "Stargate Atlantis", canonical: true
  When I am logged in as "Enigel"
  When I view the tag "Stargate Atlantis"
  When I am logged in as "dizmo"
  When I view tag wrangling discussions
  Then I should not see "Stargate Atlantis"
  
  Scenario: admin can also comment on tags, issue 1428
  
  Given a fandom exists with name: "Stargate Atlantis", canonical: true
  When I am logged in as an admin
  When I post the comment "Important policy decision" on the tag "Stargate Atlantis" via web
  When I view the tag "Stargate Atlantis"
  Then I should see "1 comment"
  
  Scenario: Issue 2185: email notifications for tag commenting; TO DO: replies to comments
  
    Given the following activated tag wranglers exist
        | login       | password      | email             |
        | dizmo       | wrangulator   | dizmo@example.org |
        | Enigel      | wrangulator   | enigel@example.org|
        | Cesy        | wrangulator   | cesy@example.org|
      And a fandom exists with name: "Eroica", canonical: true
      And a fandom exists with name: "Doctor Who", canonical: true
      And the tag wrangler "Enigel" with password "wrangulator" is wrangler of "Eroica"
      And the tag wrangler "Cesy" with password "wrangulator" is wrangler of "Doctor Who"
      And the tag wrangler "dizmo" with password "wrangulator" is wrangler of "Doctor Who"
      
    # receive copies of own comments
    When I am logged in as "Enigel" with password "wrangulator"
      And I go to Enigel's user page
      #'
      And I follow "Preferences"
      And I uncheck "Turn off copies of your own comments"
      And I press "Update"
      And I log out
      
    # fellow wrangler leaves a comment on a wrangler's fandom  
    When I am logged in as "Cesy" with password "wrangulator"
      And I go to Cesy's user page
      #'
      And I follow "Preferences"
      And I check "Turn off copies of your own comments"
      And I press "Update"
      And all emails have been delivered
      And I view the tag "Eroica"
      And I follow "0 comments"
      And I fill in "Comment" with "really clever stuff"
      And I press "Comment"
    Then I should see "Comment created"
      And 1 email should be delivered to "enigel@example.org"
      And the email should contain "really clever stuff"
      And the email should contain "Cesy"
      And the email should contain "left the following comment on the tag"
      
    # check that the links in the email go where they should; this is wonky and I don't know why
    When I follow "Go to the thread starting from this comment" in the email
    # the session is lost for some reason and I have to log in! I'll log in as dizmo though
      And I fill in "User name:" with "dizmo"
      And I fill in "Password:" with "wrangulator"
      And I press "Log in"
    # I get redirected to the tag comments page
    Then I should see "Reading Comments on Eroica"
      And I should see "really clever stuff"
    When I follow "Read all comments on Eroica" in the email
      And I fill in "User name:" with "Cesy"
      And I fill in "Password:" with "wrangulator"
      And I press "Log in"
    # TODO: This goes to the dashboard instead of a redirect to the tag! Why, why? I mean, why? Why?
    # Then I should see "Reading Comments on Eroica"
      # And I should see "really clever stuff"
    When I follow "Reply to this comment" in the email
      And I fill in "User name:" with "Enigel"
      And I fill in "Password:" with "wrangulator"
      And I press "Log in"
    # TODO: This goes to the dashboard instead of a redirect to the tag!
    # Then I should see "Reading Comments on Eroica"
      # And I should see "really clever stuff"
    
    When I view the tag "Doctor Who"
      And all emails have been delivered
      And I follow "0 comments"
      And I fill in "Comment" with "really clever stuff"
      And I press "Comment"
    Then I should see "Comment created"
      And 1 email should be delivered to "cesy@example.org"
      And 1 email should be delivered to "dizmo@example.org"
      And 1 email should be delivered to "enigel@example.org"
    When I follow "Edit"
      And all emails have been delivered
      And I press "Update"
    Then I should see "Comment was successfully updated"
      And 3 emails should be delivered
      