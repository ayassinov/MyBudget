package com.ninjas.mybudget.core.domain;

import org.joda.time.DateTime;

/**
 * @author ayassinov on 21/09/14.
 */
public class Transaction {

    private Long id;

    private Budget budget;

    private DateTime date;

    private TransactionType transactionType;

    private double amount;

    private String note;

}
