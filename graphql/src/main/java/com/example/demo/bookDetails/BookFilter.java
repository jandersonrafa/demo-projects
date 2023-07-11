package com.example.demo.bookDetails;

import java.util.Arrays;
import java.util.List;

public class BookFilter {

    private String nameContains;
    public BookFilter(String nameContains) {
        this.nameContains = nameContains;
    }

    public String getNameContains() {
        return nameContains;
    }

    public void setNameContains(String nameContains) {
        this.nameContains = nameContains;
    }
}