package com.ninjas.mybudget.core.domain;

import com.fasterxml.jackson.annotation.JsonIgnore;

import java.util.ArrayList;
import java.util.List;

/**
 * @author ayassinov on 21/09/14.
 */
public class Category {

    private Long id;

    private String name;

    private Category parentCategory;

    @JsonIgnore
    private List<Category> subCategories = new ArrayList<>();

    private String isArchived;

}
