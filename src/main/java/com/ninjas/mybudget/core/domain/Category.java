package com.ninjas.mybudget.core.domain;

import com.fasterxml.jackson.annotation.JsonIgnore;

import java.util.ArrayList;
import java.util.List;

import lombok.EqualsAndHashCode;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

/**
 * @author ayassinov on 21/09/14.
 */
@Getter
@Setter
@NoArgsConstructor
@EqualsAndHashCode(of = "name")
@ToString
public class Category {

    private Long id;

    private String name;

    private Category parentCategory;

    @JsonIgnore
    private List<Category> subCategories = new ArrayList<>();

    private String isArchived;
    
    public Category(Long id, String name, Category parentCategory,String isArchived){
    	this.id = id;
    	this.name = name;
    	this.parentCategory = parentCategory;
    	this.isArchived = isArchived;
    }

}
