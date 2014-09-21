package com.ninjas.mybudget.core.domain;

import java.util.ArrayList;
import java.util.List;

/**
 * @author ayassinov on 21/09/14.
 */
public class BalanceSheet {

    private Long id;

    private User user;

    private Month month;

    private double startAmount;

    private double estimatedBalance;

    private double realBalance;

    private double gap;
    
    private List<Budget> budgets = new ArrayList<>();

}
