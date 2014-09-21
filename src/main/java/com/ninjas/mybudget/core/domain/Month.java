package com.ninjas.mybudget.core.domain;

import lombok.Getter;
import lombok.Setter;

/**
 * @author ayassinov on 21/09/14.
 */
@Getter
@Setter
public class Month {

    private Long id;

    private String monthOfYear;

    private String name;

    private int year;
}
