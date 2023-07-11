package com.example.demo.controller;

import com.example.demo.bookDetails.Author;
import com.example.demo.bookDetails.Book;
import com.example.demo.bookDetails.BookFilter;
import org.springframework.graphql.data.method.annotation.Argument;
import org.springframework.graphql.data.method.annotation.QueryMapping;
import org.springframework.graphql.data.method.annotation.SchemaMapping;
import org.springframework.stereotype.Controller;

import java.util.Arrays;
import java.util.Collection;

@Controller
public class BookController {


    @QueryMapping(value = "bookById")
    public Book teste(@Argument String id) {
        return Book.getById(id);
    }

    @QueryMapping()
    public Collection<Book> books() {
        return Arrays.asList(Book.getById("book-1"), Book.getById("book-2"), Book.getById("book-3"));
    }

    @SchemaMapping
    public Author author(Book book) {
        return Author.getById(book.getAuthorId());
    }
}