@bookmarks @collections @works

Feature: Collectible items
  As a user
  I want to add various items to collections
  
  Scenario: Add my bookmark to a collection
    Given I have a collection "Various Penguins"
      And I am logged in as a random user
      And I have a bookmark for "Tundra penguins"
    When I add my bookmark to the collection
    Then I should see "Added"
    # TODO: add something to bookmark blurb about collection belonging, similar to works?
    #  And I follow "Various Penguins"
    When I go to "Various Penguins" collection's page
    Then I should see "Bookmarks (1)"
      And I should see "Tundra penguins"

  Scenario: Add my work to a collection
    Given I have a collection "Various Penguins"
      And I am logged in as a random user
      And I post the work "Blabla"
    When I add my work to the collection
    Then I should see "Added"
    When I go to "Various Penguins" collection's page
    Then I should see "Works (1)"
      And I should see "Blabla"

  Scenario: Add my chaptered work to a collection
    Given I have a collection "Various Penguins"
      And I am logged in as a random user
      And I post the chaptered work "Blabla"
    When I add my work to the collection
    Then I should see "Added"
    When I go to "Various Penguins" collection's page
    Then I should see "Works (1)"
      And I should see "Blabla"

  Scenario: Add my work to a moderated collection
    Given I have a moderated collection "Various Penguins"
      And I am logged in as a random user
      And I post the work "Blabla"
    When I add my work to the collection
    Then I should see "will have to be approved"
    When I go to "Various Penguins" collection's page
    Then I should see "Works (0)"
      And I should not see "Blabla"

  Scenario: Add my work to a closed collection
    Given I have a closed collection "Various Penguins"
      And I am logged in as a random user
      And I post the work "Blabla"
    When I add my work to the collection
    Then I should see "is closed"
    When I go to "Various Penguins" collection's page
    Then I should see "Works (0)"
      And I should not see "Blabla"
