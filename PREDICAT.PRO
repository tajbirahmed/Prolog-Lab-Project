
/* --- Predicates --- */
predicates
    
    add_book(book_title, author_name, genre)
    
    remove_book(book_title)
    
    search_books_by_title(book_title, book_title)
    
    handle_error(status, string)
    
    update_book_copies(book_title, integer)
    
    search_books_by_author(author_name, book_title)

    search_books_by_genre(genre, book_title)

    register_user(user_name)    

    is_user_registered(user_name, symbol)

    check_borrow_limit(user_name, symbol)

    borrow_book(book_title, user_name)

    return_book(book_title, user_name)

    list_borrowed_books

    list_books

    list_users

    generate_library_report
