
/* --- Clauses --- */
clauses

    /* Add a new book */
    add_book(Title, Author, Genre) :-
        not(book_record(Title, _, _, _)), 
        asserta(book_record(Title, Author, Genre, 5)),
        write("Book added: "), write(Title), nl. 

    add_book(Title, _, _) :-
        book_record(Title, _, _, _), 
        handle_error(duplicate, Title). 

    /* # Search books by title */
    search_books_by_title(SearchTitle, FoundTitle) :-
        book_record(FoundTitle, _, _, _), 
        SearchTitle = FoundTitle,         
        write("Book found: "), write(FoundTitle), nl. 

    search_books_by_title(SearchTitle, _) :-
        not(book_record(SearchTitle, _, _, _)), 
        write("Error: Book '"), 
        write(SearchTitle), 
        write("' not found."), nl. 

    /* Remove a book */
    remove_book(Title) :-
        retract(book_record(Title, _, _, _)),
        write("Book removed: "), 
        write(Title), nl.

    remove_book(Title) :-
        write("Error: Book '"), 
        write(Title), 
        write("' not found."), nl.

    /* Update book copies */
    update_book_copies(Title, NewCopies) :-
        book_record(Title, Author, Genre, _),
        retract(book_record(Title, Author, Genre, _)),
        asserta(book_record(Title, Author, Genre, NewCopies)),
        write("Updated copies for book: "), write(Title), 
        write(" to "), write(NewCopies), nl.

    update_book_copies(Title, _) :-
        write("Error: Book '"), write(Title), write("' not found."), nl.

    /* Search books by author */
    search_books_by_author(AuthorName, Title) :-
        book_record(Title, AuthorName, _, _),
        write("Book found: "), 
        write(Title), nl.

    search_books_by_author(AuthorName, _) :-
        book_record(_, AuthorName, _, _),
        write("Error: No books found for author '"), 
        write(AuthorName), 
        write("'."), nl.

    /* Search books by genre */
    search_books_by_genre(Genre, Title) :-
        book_record(Title, _, Genre, _),
        write("Book found: "), 
        write(Title), nl.

    search_books_by_genre(Genre, _) :-
        book_record(_, _, Genre, _),
        write("Error: No books found in genre '"), 
        write(Genre), 
        write("'."), nl.

    register_user(UserName) :-
        is_user_registered(UserName, yes),  
        write("Error: User '"), 
        write(UserName), 
        write("' is already registered."), nl, fail.

    register_user(UserName) :-
        is_user_registered(UserName, no),  
        asserta(user_record(UserName)),   
        write("User registered: "), 
        write(UserName), nl.

    /* Check if a user is already registered */
    is_user_registered(UserName, yes) :- 
        user_record(UserName), !.
    is_user_registered(_, no).

    /* Check if the user has borrowed any books */
    check_borrow_limit(UserName, Status) :-
        borrowed_books(UserName, _),  
        Status = yes.  
        
    check_borrow_limit(UserName, Status) :-
        not(borrowed_books(UserName, _)),  
        Status = no.  

    /* Borrow a book */
    borrow_book(BookTitle, UserName) :-
        user_record(UserName),   
        book_record(BookTitle, _, _, _),  
        not(borrowed_books(UserName, BookTitle)),  
        asserta(borrowed_books(UserName, BookTitle)),  
        write("User '"), write(UserName), 
        write("' successfully borrowed the book: "), 
        write(BookTitle), nl, !.  /* Prevent backtracking */

    borrow_book(BookTitle, UserName) :-
        borrowed_books(UserName, BookTitle),  
        write("Error: User '"), write(UserName), 
        write("' has already borrowed the book: "), 
        write(BookTitle), nl, fail.

    borrow_book(BookTitle, _) :-
        not(book_record(BookTitle, _, _, _)),  
        write("Error: Book '"), 
        write(BookTitle), write("' does not exist."), nl, fail.

    borrow_book(_, UserName) :-
        is_user_registered(UserName, no), 
        write("Error: User '"), 
        write(UserName), write("' is not registered."), nl, fail.

    /* Return a borrowed book */
    return_book(BookTitle, UserName) :-
        user_record(UserName),  
        borrowed_books(UserName, BookTitle),  
        retract(borrowed_books(UserName, BookTitle)),  
        write("User '"), write(UserName), 
        write("' has returned the book: "), 
        write(BookTitle), nl.



    return_book(BookTitle, UserName) :-
        user_record(UserName), 
        not(borrowed_books(UserName, BookTitle)), 
        write("Error: User '"), write(UserName), 
        write("' has not borrowed the book: "), 
        write(BookTitle), nl, fail.

    return_book(BookTitle, UserName) :-
        user_record(UserName),
        borrowed_books(UserName, BookTitle),
        retract(borrowed_books(UserName, BookTitle)),  % Remove from borrowed books list
        write("User '"), 
        write(UserName),
        write("' successfully returned the book: "), 
        write(BookTitle), nl.

    /* Handle errors based on status */
    handle_error(duplicate, Title) :-
        write("Error: Book '"), 
        write(Title), 
        write("' already exists."), 
        nl, !.

    handle_error(not_found, Title) :-
        write("Error: Book '"), 
        write(Title), 
        write("' not found."), nl, !.

    handle_error(unavailable, Title) :-
        write("Error: Book '"), 
        write(Title), 
        write("' is unavailable."), nl, !.

    handle_error(limit_reached, UserName) :-
        write("Error: User '"), 
        write(UserName), 
        write("' has reached the borrow limit."), nl, !.

    handle_error(default, Message) :-
        write("Error: "), 
        write(Message), nl. 


    /* Predicate to generate a library report */
    generate_library_report :-
        write("Library Report"), nl,
        write("----------------------------"), nl,

        /* List all books */
        write("Books in the Library:"), nl,
        list_books, nl,

    /* List all users */
        write("Registered Users:"), nl,
        list_users, nl,


        /* Display borrowed books */
        write("Borrowed Books:"), nl,
        list_borrowed_books, nl,

        write("----------------------------"), nl,
        write("End of Report"), nl.


    /* List all books */
    list_books :-
        book_record(Title, Author, Genre, Copies),
        write("Title: "), 
        write(Title), 
        write(", Author: "), 
        write(Author), 
        write(", Genre: "), 
        write(Genre), 
        write(", Copies: "), 
        write(Copies), nl,
        fail.
    list_books.  

    /* List all registered users */
    list_users :-
        user_record(UserName),
        write("User: "), 
        write(UserName), nl,
        fail.
    list_users.  

    /* List all borrowed books */
    list_borrowed_books :-
        borrowed_books(UserName, BookTitle),
        write("User: "), 
        write(UserName), 
        write(" borrowed Book: "), 
        write(BookTitle), nl,
        fail.
    list_borrowed_books.  