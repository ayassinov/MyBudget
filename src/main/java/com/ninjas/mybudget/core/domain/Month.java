package com.ninjas.mybudget.core.domain;

import javax.persistence.Entity;
import javax.persistence.Id;


import lombok.Getter;
import lombok.Setter;

/**
 * @author ayassinov on 21/09/14.
 */
@Getter
@Setter
@Entity
public class Month {

	@Id
    private Long id;

    private String monthOfYear;

    private String name;

    private int year;
}
