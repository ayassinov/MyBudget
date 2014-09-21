package com.ninjas.mybudget.core.domain;

import com.fasterxml.jackson.annotation.JsonIgnore;

import java.util.ArrayList;
import java.util.List;

/**
 * @author ayassinov on 21/09/14.
 */
public class Budget {

    private Category category;

    private int order;

    private double estimatedBalance;

    private double realBalance;

    private double gap;

    @JsonIgnore
    private List<Transaction> transactions = new ArrayList<>();
}
