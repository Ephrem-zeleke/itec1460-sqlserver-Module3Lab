-- create an author table 
-- create a table called Authors
CREATE TABLE Authors (
    AuthorID INT PRIMARY KEY,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    BirthDate DATE
);

-- create a books table 

CREATE TABLE Books (
    BookID INT PRIMARY KEY,
    Title VARCHAR(100),
    AuthorID INT,
    PublicationYear INT,
    Price DECIMAL(10,2),
    FOREIGN KEY (AuthorID) REFERENCES Authors(AuthorID)
);

--insert data into Authors table 
INSERT INTO Authors (AuthorID, FirstName, LastName, BirthDate)
VALUES
(1, 'Jane', 'Austen', '1775-12-16'),
(2, 'George', 'Orwell', '1903-06-25'),
(3, 'J.K.', 'Rowling', '1965-07-31'),
(4, 'Ernest', 'Hemingway', '1899-07-21'),
(5, 'Virginia', 'Woolf', '1882-01-25')

-- lets insert some data to the books table 
INSERT INTO Books(BookID, Title, AuthorID, PublicationYear, Price)
VALUES
(1, 'Pride and Prejudice', 1, 1813, 12.99),
(2, '1984', 2, 1949, 10.99),
(3, 'Harry Potter and the Philosopher''s Stone', 3, 1997, 15.99),
(4, 'The Old Man and the Sea', 4, 1952, 11.99),
(5, 'To The Lighthouse', 5, 1927, 13.99)


-- create view 
-- Create a view that pulls data from the Authors and the Books tables
CREATE VIEW BookDetails AS
SELECT 
    b.BookID,
    b.Title,
    a.FirstName + ' ' + a.LastName AS AuthorName,
    b.PublicationYear,
    b.Price
FROM 
    Books b
JOIN 
    Authors a ON b.AuthorID = a.AuthorID;


-- create a filtered view
-- create a view named RecentBooks that shows books published after the year 1990

CREATE VIEW RecentBooks AS
SELECT 
    BookID,
    Title,
    PublicationYear,
    Price
FROM 
    Books
WHERE 
    PublicationYear > 1990;

-- create a view with calculated feilds
-- Creating a view named AuthorStats that shows the number of books and average price of books for each author

CREATE VIEW AuthorStats AS
SELECT 
    a.AuthorID,
    a.FirstName + ' ' + a.LastName AS AuthorName,
    COUNT(b.BookID) AS BookCount,
    AVG(b.Price) AS AverageBookPrice
FROM 
    Authors a
LEFT JOIN 
    Books b ON a.AuthorID = b.AuthorID
GROUP BY 
    a.AuthorID, a.FirstName, a.LastName;

-- query te views 
-- lets write a SQL query the views
-- retrive all records from the BookDetails view
SELECT Title, Price FROM BookDetails;

-- list all books from the RecentBooks view
SELECT * FROM RecentBooks;

-- lets show the statistics for authors 
SELECT * FROM AuthorStats;

-- create an updateable view
-- create an updateable view called AuthorContactInfo that allows updating the Author's fisrt and last name 

CREATE VIEW AuthorContactInfo AS
SELECT 
    AuthorID,
    FirstName,
    LastName
FROM 
    Authors;

-- lets update an author's name with this view

UPDATE AuthorContactInfo
SET FirstName = 'Joanne'
WHERE AuthorID = 3;

-- let us check by query the view 
SELECT * FROM AuthorContactInfo;

-- creating an audit trigger
-- now we will create a trigger that logs all price changes in the books table to a new audit table 
-- lets first create the audit table 
CREATE TABLE BookPriceAudit (
    AuditID INT IDENTITY(1,1) PRIMARY KEY,
    BookID INT,
    OldPrice DECIMAL(10,2),
    NewPrice DECIMAL(10,2),
    ChangeDate DATETIME DEFAULT GETDATE()
);

-- then, create the trigger

CREATE TRIGGER trg_BookPriceChange
ON Books
AFTER UPDATE
AS
BEGIN
    IF UPDATE(Price)
    BEGIN
        INSERT INTO BookPriceAudit (BookID, OldPrice, NewPrice)
        SELECT 
            i.BookID,
            d.Price,
            i.Price
        FROM inserted i
        JOIN deleted d ON i.BookID = d.BookID
    END
END;

-- test the trigger by updating the book's price 
-- update a book's price 

UPDATE Books
SET Price = 14.99
WHERE BookID = 1;

-- check the audit table 
SELECT * FROM BookPriceAudit;


--part two of lab 
-- creating a book review table 

CREATE TABLE BookReviews (
    ReviewID INT PRIMARY KEY, 
    BookID INT,
    CustomerID NCHAR(5),
    Rating INT CHECK (Rating BETWEEN 1 AND 5),
    ReviewText NVARCHAR (MAX),
    ReviewDate DATE,
    FOREIGN KEY (BookID) REFERENCES Books(BookID),
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

-- create a view named vw_BookReviewStats that shows the book title, total number of reviews , average rating and most recent review data
-- now lets create the view 
CREATE VIEW vw_BookReviewStats AS 
SELECT 
    b.Title AS BookTitle,
    COUNT(br.ReviewID) AS TotalReview,
    AVG(br.Rating) AS AverageRating,
    MAX(br.ReviewDate) AS MostRecentReviewDate
FROM 
    Books b
JOIN
    BookReviews br ON b.BookID = br.BookID
GROUP BY 
    b.Title;

-- create triggers
-- create a trigger named tr_ValidateReviewDate that prevent reviews from being added with a future date. 
-- the system will display a message saying like "review data can't be in the future "

CREATE TRIGGER tr_ValidateReviewDate
ON BookReviews
AFTER INSERT, UPDATE
AS
BEGIN 
    IF EXISTS (SELECT 1 
            FROM inserted 
            WHERE ReviewDate > GETDATE())
    BEGIN
        THROW 50001, 'Review date can not be in the future.', 1;
        ROLLBACK TRANSACTION
        END
    END;

-- the throw will return a message saying that review date can not be in the future. 

-- create a trigger named tr_UpdateBookRating 
-- first we have to add an average rating column to the Books table 
--lets add the column first
ALTER TABLE Books
ADD AverageRating DECIMAL(3,2) DEFAULT 0;

-- now lets create the trigger
CREATE TRIGGER tr_UpdateBookRating
ON BookReviews
AFTER INSERT, UPDATE, DELETE
AS 
BEGIN
    UPDATE Books
    SET AverageRating = (
        SELECT ISNULL(AVG(Rating),0)
        FROM BookReviews
        WHERE BookReviews.BookID = Books.BookID
    )
    WHERE BookID IN (
        SELECT BookID FROM inserted
        UNION
        SELECT BookID FROM deleted
    );
END;

-- test our work 
-- first let's insert 3 reviews for different books 
INSERT INTO BookReviews(ReviewID, BookID, CustomerID, Rating, ReviewText, ReviewDate)
VALUES
    (1, 1, 'ALFKI', 5, 'an amazing books that takes my breath away', '2025-1-20'),
    (2, 2, 'ANATR', 3, 'it is a good book but not my type. well written.', '2024-4-7'),
    (3, 3, 'ANTON', 5, 'it is a very nice book and i like the story. it is like reading my own life', '2023-10-24');

-- try to insert a review with a future data to check our trigger for tr_validateReviewDate

INSERT INTO BookReviews(ReviewID, BookID, CustomerID, Rating, ReviewText, ReviewDate)
VALUES
    (4, 4, 'BERGS', 2, 'not an interesting books', '2030-4-9');

-- qurying the view to see the statistics
SELECT * FROM vw_BookReviewStats;

-- update a review's rating and verify the book's average rating update automatically

UPDATE BookReviews
SET Rating = 2
WHERE ReviewID = 1;