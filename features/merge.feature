Feature: Merge Articles
  As a blog administrator
  In order to prevent multiple articles on the same topic
  I want to be able to merge articles

  Background:

    Given the blog is set up

    Given the following users exist:
      | profile_id | login  | name  | password | email           |
      | 2          | john   | John  | abc123   | john@mail.com   |
      | 3          | jack   | Jack  | 123abc   | jack@mail.com   |

    Given the following articles exist:
      | id | title    | author | user_id | body    | allow_comments | published |
      | 3  | money    | john   | 2       | good    | true           | true      |
      | 4  | drugz    | jack   | 3       | bad     | true           | true      |

    Given the following comments exist:
      | id | author | body    | article_id | user_id |
      | 1  | john   | lmao    | 3          | 2       |
      | 2  | john   | rofl    | 4          | 2       |


  Scenario: A non-admin cannot merge articles.
    Given I am logged in as "john" with pass "abc123"
    And I am on the Edit Page of Article with id 3
    Then I should not see "Merge Articles"

  Scenario: When articles are merged, the merged article should contain the text of both previous articles.
    Given the article with ids "3" and "4" were merged
    And I am on the home page
    Then I should see "money"
    When I follow "money"
    Then I should see "good"
    And I should see "bad"

  Scenario: When articles are merged, the merged article should have one author (either one of the authors of the original article).
    Given the article with ids "3" and "4" were merged
    Then "John" should be author of 1 articles
    And "Jack" should be author of 0 articles

  Scenario: Comments on each of the two original articles need to all carry over and point to the new, merged article.
    Given the article with ids "3" and "4" were merged
    And I am on the home page
    Then I should see "money"
    When I follow "money"
    Then I should see "lmao"
    And I should see "rofl"

  Scenario: The title of the new article should be the title from either one of the merged articles.
    Given the article with ids "3" and "4" were merged
    And I am on the home page
    Then I should see "money"
    And I should not see "drugz"